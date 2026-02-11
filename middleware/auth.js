const jwt = require('jsonwebtoken');
require('dotenv').config();

const authenticateToken = (req, res, next) => {
  const token = (req.headers['authorization'] && req.headers['authorization'].split(' ')[1]) || null;
  if (!token) return res.status(401).json({ error: 'Token di accesso mancante' });
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ error: 'Token non valido o scaduto' });
    req.user = user;
    next();
  });
};

const isAdmin = (req, res, next) => {
  if (req.user.user_type_code !== 'ADMIN') return res.status(403).json({ error: 'Accesso negato: privilegi insufficienti' });
  next();
};

module.exports = { authenticateToken, isAdmin };
