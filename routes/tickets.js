const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { authenticateToken, isAdmin } = require('../middleware/auth');
const { logActivityFromRequest } = require('../utils/auditLogger');

const validateTicketInput = (title, description) =>
  !title || !description ? 'Titolo e descrizione sono obbligatori' :
    title.length > 120 ? 'Il titolo non può superare 120 caratteri' :
      description.length > 2000 ? 'La descrizione non può superare 2000 caratteri' : null;

router.post('/', authenticateToken, async (req, res) => {
  try {
    const { title, description, ticket_type } = req.body;
    const validationError = validateTicketInput(title, description);

    if (validationError) return res.status(400).json({ error: validationError });
    if (!ticket_type) return res.status(400).json({ error: 'Tipo ticket è obbligatorio' });

    const [ticketTypes] = await db.query('SELECT id FROM ticket_type WHERE code = ?', [ticket_type]);
    if (ticketTypes.length === 0) return res.status(400).json({ error: 'Tipo ticket non valido' });

    const [statuses] = await db.query('SELECT id FROM ticket_status WHERE code = ?', ['OPEN']);
    const [result] = await db.query(
      'INSERT INTO ticket (user_id, ticket_type_id, ticket_status_id, title, description) VALUES (?, ?, ?, ?, ?)',
      [req.user.id, ticketTypes[0].id, statuses[0].id, title, description]
    );

    const ticketId = result.insertId;

    await logActivityFromRequest(req, {
      userId: req.user.id,
      action: 'TICKET_CREATED',
      entityType: 'TICKET',
      entityId: ticketId,
      description: `Ticket creato: "${title}"`,
      metadata: { title, ticket_type, creator: req.user.username }
    });

    res.status(201).json({ message: 'Ticket creato con successo', ticket_id: ticketId });
  } catch (error) {
    console.error('Errore creazione ticket:', error);
    res.status(500).json({ error: 'Errore durante la creazione del ticket' });
  }
});

router.get('/', authenticateToken, async (req, res) => {
  try {
    const isAdminUser = req.user.user_type_code === 'ADMIN';
    const { search, status, type } = req.query;

    let query = `
      SELECT t.id, t.title, t.description, t.created_at, t.updated_at, 
      COALESCE(u.username, "Utente Eliminato") as creator, 
      tt.code as ticket_type, tt.description as ticket_type_desc, 
      ts.code as status, ts.description as status_desc 
      FROM ticket t 
      LEFT JOIN user u ON t.user_id = u.id 
      JOIN ticket_type tt ON t.ticket_type_id = tt.id 
      JOIN ticket_status ts ON t.ticket_status_id = ts.id
    `;

    const conditions = [];
    const params = [];

    if (!isAdminUser) {
      conditions.push('t.user_id = ?');
      params.push(req.user.id);
    }

    if (search) {
      conditions.push('(t.title LIKE ? OR u.username LIKE ?)');
      params.push(`%${search}%`, `%${search}%`);
    }
    if (status) {
      conditions.push('ts.code = ?');
      params.push(status);
    }
    if (type) {
      conditions.push('tt.code = ?');
      params.push(type);
    }

    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }

    query += ' ORDER BY t.created_at DESC';

    const [tickets] = await db.query(query, params);
    res.json(tickets);
  } catch (error) {
    console.error('Errore recupero tickets:', error);
    res.status(500).json({ error: 'Errore durante il recupero dei ticket' });
  }
});

router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const ticketId = parseInt(req.params.id);
    if (isNaN(ticketId)) return res.status(400).json({ error: 'ID ticket non valido' });

    const [tickets] = await db.query(
      'SELECT t.id, t.title, t.description, t.created_at, t.updated_at, t.user_id, COALESCE(u.username, "Utente Eliminato") as creator, tt.code as ticket_type, tt.description as ticket_type_desc, ts.code as status, ts.description as status_desc FROM ticket t LEFT JOIN user u ON t.user_id = u.id JOIN ticket_type tt ON t.ticket_type_id = tt.id JOIN ticket_status ts ON t.ticket_status_id = ts.id WHERE t.id = ?',
      [ticketId]
    );

    if (tickets.length === 0) return res.status(404).json({ error: 'Ticket non trovato' });
    const ticket = tickets[0];

    if (req.user.user_type_code !== 'ADMIN' && ticket.user_id !== req.user.id) {
      return res.status(403).json({ error: 'Non autorizzato ad accedere a questo ticket' });
    }

    const [messages] = await db.query(`
      SELECT m.id, m.message, m.created_at, u.username as sender, ut.code as sender_role
      FROM ticket_message m
      JOIN user u ON m.user_id = u.id
      JOIN user_type ut ON u.user_type_id = ut.id
      WHERE m.ticket_id = ?
      ORDER BY m.created_at ASC
    `, [ticketId]);

    ticket.messages = messages;
    res.json(ticket);
  } catch (error) {
    console.error('Errore recupero ticket:', error);
    res.status(500).json({ error: 'Errore durante il recupero del ticket' });
  }
});

router.patch('/:id', authenticateToken, async (req, res) => {
  try {
    const ticketId = parseInt(req.params.id);
    const { title, description } = req.body;
    const validationError = validateTicketInput(title, description);

    if (isNaN(ticketId)) return res.status(400).json({ error: 'ID ticket non valido' });
    if (validationError) return res.status(400).json({ error: validationError });

    const [tickets] = await db.query('SELECT t.id, t.title, t.user_id, ts.code as status FROM ticket t JOIN ticket_status ts ON t.ticket_status_id = ts.id WHERE t.id = ?', [ticketId]);
    if (tickets.length === 0) return res.status(404).json({ error: 'Ticket non trovato' });

    const ticket = tickets[0];
    if (ticket.user_id !== req.user.id) return res.status(403).json({ error: 'Non autorizzato a modificare questo ticket' });
    if (ticket.status !== 'OPEN') return res.status(400).json({ error: 'Puoi modificare solo ticket aperti' });

    await db.query('UPDATE ticket SET title = ?, description = ? WHERE id = ?', [title, description, ticketId]);

    await logActivityFromRequest(req, {
      userId: req.user.id,
      action: 'TICKET_UPDATED',
      entityType: 'TICKET',
      entityId: ticketId,
      description: `Ticket modificato: "${title}"`,
      metadata: { old_title: ticket.title, new_title: title, updated_by: req.user.username }
    });

    res.json({ message: 'Ticket aggiornato con successo' });
  } catch (error) {
    console.error('Errore aggiornamento ticket:', error);
    res.status(500).json({ error: 'Errore durante l\'aggiornamento del ticket' });
  }
});

router.patch('/:id/status', authenticateToken, isAdmin, async (req, res) => {
  try {
    const ticketId = parseInt(req.params.id);
    const { status } = req.body;

    if (isNaN(ticketId)) return res.status(400).json({ error: 'ID ticket non valido' });
    if (!status) return res.status(400).json({ error: 'Status è obbligatorio' });
    if (!['OPEN', 'IN_PROGRESS', 'CLOSED'].includes(status)) return res.status(400).json({ error: 'Status non valido' });

    const [tickets] = await db.query('SELECT t.id, t.title, t.user_id, ts.code as current_status FROM ticket t JOIN ticket_status ts ON t.ticket_status_id = ts.id WHERE t.id = ?', [ticketId]);
    if (tickets.length === 0) return res.status(404).json({ error: 'Ticket non trovato' });

    const ticket = tickets[0];
    const oldStatus = ticket.current_status;

    const [statuses] = await db.query('SELECT id FROM ticket_status WHERE code = ?', [status]);
    await db.query('UPDATE ticket SET ticket_status_id = ? WHERE id = ?', [statuses[0].id, ticketId]);

    await logActivityFromRequest(req, {
      userId: req.user.id,
      action: 'TICKET_STATUS_CHANGED',
      entityType: 'TICKET',
      entityId: ticketId,
      description: `Status ticket modificato: "${ticket.title}" (${oldStatus} → ${status})`,
      metadata: { ticket_id: ticketId, old_status: oldStatus, new_status: status, changed_by: req.user.username }
    });

    res.json({ message: 'Status aggiornato con successo' });
  } catch (error) {
    console.error('Errore aggiornamento status:', error);
    res.status(500).json({ error: 'Errore durante l\'aggiornamento dello status' });
  }
});

router.post('/:id/messages', authenticateToken, isAdmin, async (req, res) => {
  try {
    const ticketId = parseInt(req.params.id);
    const { message } = req.body;

    if (isNaN(ticketId)) return res.status(400).json({ error: 'ID ticket non valido' });
    if (!message || !message.trim()) return res.status(400).json({ error: 'Il messaggio non può essere vuoto' });

    const [tickets] = await db.query('SELECT id, title, user_id FROM ticket WHERE id = ?', [ticketId]);
    if (tickets.length === 0) return res.status(404).json({ error: 'Ticket non trovato' });

    const ticket = tickets[0];

    await db.query('INSERT INTO ticket_message (ticket_id, user_id, message) VALUES (?, ?, ?)', [ticketId, req.user.id, message]);

    await logActivityFromRequest(req, {
      userId: req.user.id,
      action: 'TICKET_MESSAGE_ADDED',
      entityType: 'TICKET',
      entityId: ticketId,
      description: `Risposta aggiunta al ticket: "${ticket.title}"`,
      metadata: { ticket_id: ticketId, sender: req.user.username, message_preview: message.substring(0, 50) }
    });

    res.status(201).json({ message: 'Risposta inviata con successo' });
  } catch (error) {
    console.error('Errore invio messaggio:', error);
    res.status(500).json({ error: 'Errore durante l\'invio del messaggio' });
  }
});

router.get('/meta/types', authenticateToken, async (req, res) => {
  try { const [types] = await db.query('SELECT code, description FROM ticket_type ORDER BY description'); res.json(types); } catch (error) { res.status(500).json({ error: 'Errore' }); }
});
router.get('/meta/statuses', authenticateToken, isAdmin, async (req, res) => {
  try { const [statuses] = await db.query('SELECT code, description FROM ticket_status ORDER BY id'); res.json(statuses); } catch (error) { res.status(500).json({ error: 'Errore' }); }
});

module.exports = router;