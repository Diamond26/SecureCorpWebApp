  const express = require('express'), router = express.Router(), db = require('../config/database'), { authenticateToken, isAdmin } = require('../middleware/auth');
  const validateTicketInput = (title, description) => !title || !description ? 'Titolo e descrizione sono obbligatori' : title.length > 120 ? 'Il titolo non può superare 120 caratteri' : description.length > 2000 ? 'La descrizione non può superare 2000 caratteri' : null;

  router.post('/', authenticateToken, async (req, res) => {
    try {
      const { title, description, ticket_type } = req.body, validationError = validateTicketInput(title, description);
      if (validationError) return res.status(400).json({ error: validationError });
      if (!ticket_type) return res.status(400).json({ error: 'Tipo ticket è obbligatorio' });
      const [ticketTypes] = await db.query('SELECT id FROM ticket_type WHERE code = ?', [ticket_type]);
      if (ticketTypes.length === 0) return res.status(400).json({ error: 'Tipo ticket non valido' });
      const [statuses] = await db.query('SELECT id FROM ticket_status WHERE code = ?', ['OPEN']);
      if (statuses.length === 0) return res.status(500).json({ error: 'Errore configurazione sistema' });
      const [result] = await db.query('INSERT INTO ticket (user_id, ticket_type_id, ticket_status_id, title, description) VALUES (?, ?, ?, ?, ?)', [req.user.id, ticketTypes[0].id, statuses[0].id, title, description]);
      res.status(201).json({ message: 'Ticket creato con successo', ticket_id: result.insertId });

    } catch (error) {
      console.error('Errore creazione ticket:', error);
      res.status(500).json({ error: 'Errore durante la creazione del ticket' });
    }
  });

  router.get('/', authenticateToken, async (req, res) => {
    try {
      const isAdminUser = req.user.user_type_code === 'ADMIN';
      const query = isAdminUser ? 'SELECT t.id, t.title, t.description, t.created_at, t.updated_at, COALESCE(u.username, "Utente Eliminato") as creator, tt.code as ticket_type, tt.description as ticket_type_desc, ts.code as status, ts.description as status_desc FROM ticket t LEFT JOIN user u ON t.user_id = u.id JOIN ticket_type tt ON t.ticket_type_id = tt.id JOIN ticket_status ts ON t.ticket_status_id = ts.id ORDER BY t.created_at DESC' : 'SELECT t.id, t.title, t.description, t.created_at, t.updated_at, tt.code as ticket_type, tt.description as ticket_type_desc, ts.code as status, ts.description as status_desc FROM ticket t JOIN ticket_type tt ON t.ticket_type_id = tt.id JOIN ticket_status ts ON t.ticket_status_id = ts.id WHERE t.user_id = ? ORDER BY t.created_at DESC';
      const [tickets] = await db.query(query, isAdminUser ? [] : [req.user.id]);
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
      const [tickets] = await db.query('SELECT t.id, t.title, t.description, t.created_at, t.updated_at, t.user_id, COALESCE(u.username, "Utente Eliminato") as creator, tt.code as ticket_type, tt.description as ticket_type_desc, ts.code as status, ts.description as status_desc FROM ticket t LEFT JOIN user u ON t.user_id = u.id JOIN ticket_type tt ON t.ticket_type_id = tt.id JOIN ticket_status ts ON t.ticket_status_id = ts.id WHERE t.id = ?', [ticketId]);
      if (tickets.length === 0) return res.status(404).json({ error: 'Ticket non trovato' });
      const ticket = tickets[0];
      if (req.user.user_type_code !== 'ADMIN' && ticket.user_id !== req.user.id) return res.status(403).json({ error: 'Non autorizzato ad accedere a questo ticket' });
      res.json(ticket);

    } catch (error) {
      console.error('Errore recupero ticket:', error);
      res.status(500).json({ error: 'Errore durante il recupero del ticket' });
    }
  });

  router.patch('/:id', authenticateToken, async (req, res) => {
    try {
      const ticketId = parseInt(req.params.id), { title, description } = req.body, validationError = validateTicketInput(title, description);
      if (isNaN(ticketId)) return res.status(400).json({ error: 'ID ticket non valido' });
      if (validationError) return res.status(400).json({ error: validationError });
      const [tickets] = await db.query('SELECT t.id, t.user_id, ts.code as status FROM ticket t JOIN ticket_status ts ON t.ticket_status_id = ts.id WHERE t.id = ?', [ticketId]);
      if (tickets.length === 0) return res.status(404).json({ error: 'Ticket non trovato' });
      const ticket = tickets[0];
      if (ticket.user_id !== req.user.id) return res.status(403).json({ error: 'Non autorizzato a modificare questo ticket' });
      if (ticket.status !== 'OPEN') return res.status(400).json({ error: 'Puoi modificare solo ticket aperti' });
      await db.query('UPDATE ticket SET title = ?, description = ? WHERE id = ?', [title, description, ticketId]);
      res.json({ message: 'Ticket aggiornato con successo' });

    } catch (error) {
      console.error('Errore aggiornamento ticket:', error);
      res.status(500).json({ error: 'Errore durante l\'aggiornamento del ticket' });
    }
  });

  router.patch('/:id/status', authenticateToken, isAdmin, async (req, res) => {
    try {
      const ticketId = parseInt(req.params.id), { status } = req.body;
      if (isNaN(ticketId)) return res.status(400).json({ error: 'ID ticket non valido' });
      if (!status) return res.status(400).json({ error: 'Status è obbligatorio' });
      if (!['OPEN', 'IN_PROGRESS', 'CLOSED'].includes(status)) return res.status(400).json({ error: 'Status non valido' });
      const [tickets] = await db.query('SELECT id FROM ticket WHERE id = ?', [ticketId]);
      if (tickets.length === 0) return res.status(404).json({ error: 'Ticket non trovato' });
      const [statuses] = await db.query('SELECT id FROM ticket_status WHERE code = ?', [status]);
      if (statuses.length === 0) return res.status(500).json({ error: 'Errore configurazione sistema' });
      await db.query('UPDATE ticket SET ticket_status_id = ? WHERE id = ?', [statuses[0].id, ticketId]);
      res.json({ message: 'Status aggiornato con successo' });

    } catch (error) {
      console.error('Errore aggiornamento status:', error);
      res.status(500).json({ error: 'Errore durante l\'aggiornamento dello status' });
    }
  });

  router.get('/meta/types', authenticateToken, async (req, res) => { try { const [types] = await db.query('SELECT code, description FROM ticket_type ORDER BY description'); res.json(types); } catch (error) { res.status(500).json({ error: 'Errore durante il recupero dei tipi ticket' }); } });
  router.get('/meta/statuses', authenticateToken, isAdmin, async (req, res) => { try { const [statuses] = await db.query('SELECT code, description FROM ticket_status ORDER BY id'); res.json(statuses); } catch (error) { res.status(500).json({ error: 'Errore durante il recupero degli stati ticket' }); } });

  module.exports = router;
