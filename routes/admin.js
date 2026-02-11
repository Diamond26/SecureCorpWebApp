

const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { authenticateToken, isAdmin } = require('../middleware/auth');

router.get('/logs', authenticateToken, isAdmin, async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        let limit = parseInt(req.query.limit) || 50;

        if (limit > 100) limit = 100;
        if (limit < 1) limit = 50;
        if (page < 1) page = 1;

        const offset = (page - 1) * limit;

        const filterAction = req.query.action || null;
        const filterUserId = req.query.user_id ? parseInt(req.query.user_id) : null;
        const filterEntityType = req.query.entity_type || null;
        const dateFrom = req.query.date_from || null;
        const dateTo = req.query.date_to || null;

        if (filterUserId && isNaN(filterUserId)) {
            return res.status(400).json({ error: 'user_id deve essere un numero' });
        }

        const [logsResult] = await db.query(
            'CALL sp_get_activity_logs(?, ?, ?, ?, ?, ?, ?)',
            [limit, offset, filterAction, filterUserId, filterEntityType, dateFrom, dateTo]
        );
        const logs = logsResult[0];

        const [countResult] = await db.query(
            'CALL sp_count_activity_logs(?, ?, ?, ?, ?)',
            [filterAction, filterUserId, filterEntityType, dateFrom, dateTo]
        );
        const totalLogs = countResult[0][0].total;
        const totalPages = Math.ceil(totalLogs / limit);

        res.json({
            logs,
            pagination: {
                page,
                limit,
                total: totalLogs,
                totalPages,
                hasNextPage: page < totalPages,
                hasPrevPage: page > 1
            },
            filters: {
                action: filterAction,
                user_id: filterUserId,
                entity_type: filterEntityType,
                date_from: dateFrom,
                date_to: dateTo
            }
        });

    } catch (error) {
        console.error('❌ Errore recupero logs:', error);
        res.status(500).json({ error: 'Errore durante il recupero dei log di sistema' });
    }
});

router.get('/logs/actions', authenticateToken, isAdmin, async (req, res) => {
    try {
        const [actions] = await db.query('SELECT DISTINCT action FROM activity_logs ORDER BY action');
        res.json(actions.map(a => a.action));
    } catch (error) {
        console.error('❌ Errore recupero azioni:', error);
        res.status(500).json({ error: 'Errore durante il recupero delle azioni' });
    }
});

router.get('/logs/entity-types', authenticateToken, isAdmin, async (req, res) => {
    try {
        const [entityTypes] = await db.query('SELECT DISTINCT entity_type FROM activity_logs WHERE entity_type IS NOT NULL ORDER BY entity_type');
        res.json(entityTypes.map(e => e.entity_type));
    } catch (error) {
        console.error('❌ Errore recupero entity types:', error);
        res.status(500).json({ error: 'Errore durante il recupero dei tipi di entità' });
    }
});

module.exports = router;
