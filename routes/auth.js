const express = require('express'), router = express.Router(), bcrypt = require('bcryptjs'), jwt = require('jsonwebtoken'), { v4: uuidv4 } = require('uuid'), db = require('../config/database'), { authenticateToken } = require('../middleware/auth'), rateLimit = require('express-rate-limit');
const loginLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 5, message: { error: 'Troppi tentativi di login riprova tra 15 minuti.' }, standardHeaders: true, legacyHeaders: false });
const refreshLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 10, message: { error: 'Troppi tentativi di refresh riprova più tardi.' } });


router.post('/register', authenticateToken, async (req, res) => {
  try {const { username, password, user_type } = req.body;
  if (req.user.user_type_code !== 'ADMIN') return res.status(403).json({ error: 'Non autorizzato' });
  if (!username || !password || !user_type) return res.status(400).json({ error: 'Username, password e tipo utente sono obbligatori' });
  if (username.length < 3 || username.length > 50) return res.status(400).json({ error: 'Username deve essere tra 3 e 50 caratteri' });
  if (password.length < 6) return res.status(400).json({ error: 'Password deve essere almeno 6 caratteri' });
  if (!['USER', 'ADMIN'].includes(user_type)) return res.status(400).json({ error: 'Tipo utente non valido' });
  const password_hash = await bcrypt.hash(password, 10);
  const [rows] = await db.query('CALL register_jwt(?, ?, ?)',[username, password_hash, user_type]);
  const user_id = rows[0][0].user_id; res.status(201).json({message: 'Utente registrato con successo',user_id});
  } catch (error) {console.error('Errore registrazione:', error);
  if (error.sqlState === '45000') {return res.status(400).json({ error: error.sqlMessage });}
  res.status(500).json({ error: 'Errore durante la registrazione' });}});


router.post('/login', loginLimiter, async (req, res) => {
  try {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Credenziali non valide' });
  const [users] = await db.query('SELECT u.id, u.username, u.password_hash, u.is_active, ut.code as user_type_code FROM user u JOIN user_type ut ON u.user_type_id = ut.id WHERE u.username = ?', [username]);
  if (users.length === 0) return res.status(401).json({ error: 'Credenziali non valide' });
  const user = users[0];
  if (!user.is_active) return res.status(401).json({ error: 'Credenziali non valide' });
  const passwordMatch = await bcrypt.compare(password, user.password_hash);
  if (!passwordMatch) return res.status(401).json({ error: 'Credenziali non valide' });
  const accessToken = jwt.sign({ id: user.id, username: user.username, user_type_code: user.user_type_code }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_ACCESS_EXPIRATION });
  const jti = uuidv4(), refreshToken = jwt.sign({ id: user.id, jti }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_REFRESH_EXPIRATION });
  const tokenHash = await bcrypt.hash(refreshToken, 10), expiresAt = new Date(); expiresAt.setDate(expiresAt.getDate() + 7);
  await db.query('CALL login_jwt(?, ?, ?, ?)',[user.id, jti, tokenHash, expiresAt]);
  res.json({ accessToken, refreshToken, user: { id: user.id, username: user.username, user_type: user.user_type_code } });} catch (error) {
  console.error('❌ Errore login:', error);
  console.error('Stack trace:', error.stack);
  res.status(500).json({ error: 'Errore durante il login' });}});


router.post('/refresh', refreshLimiter, async (req, res) => {
    try {const { refreshToken } = req.body;
    if (!refreshToken) return res.status(401).json({ error: 'Refresh token mancante' });
    let decoded;
    try { decoded = jwt.verify(refreshToken, process.env.JWT_SECRET); } catch { return res.status(403).json({ error: 'Refresh token non valido' }); }
    const [rows] = await db.query('CALL refresh_jwt(?)', [decoded.jti]);
    const tokens = rows[0];
    if (!tokens?.length) return res.status(403).json({ error: 'Refresh token non valido o revocato' });
    const tokenData = tokens[0];
    if (!(await bcrypt.compare(refreshToken, tokenData.token_hash))) return res.status(403).json({ error: 'Refresh token non valido' });
    const newAccessToken = jwt.sign({ id: tokenData.user_id, username: tokenData.username, user_type_code: tokenData.user_type_code }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_ACCESS_EXPIRATION });
    res.json({ accessToken: newAccessToken });} 
    catch (error) { console.error('Errore refresh:', error); res.status(500).json({ error: 'Errore durante il refresh del token' }); }});


router.post('/logout', authenticateToken, async (req, res) => {
  try {
  const { refreshToken } = req.body;
  if (!refreshToken) return res.status(400).json({ error: 'Refresh token mancante' });
  const decoded = jwt.decode(refreshToken);
  if (!decoded || !decoded.jti) return res.status(400).json({ error: 'Token non valido' });
  await db.query('CALL logout_jwt(?, ?)', [decoded.jti,req.user.id]);
  res.json({ message: 'Logout effettuato con successo' });} catch (error) {console.error('Errore logout:', error);
  res.status(500).json({ error: 'Errore durante il logout' });}});


router.get('/me', authenticateToken, async (req, res) => {
  try {const [rows] = await db.query('CALL get_me(?)', [req.user.id]);const users = rows[0];
  if (users.length === 0) return res.status(404).json({ error: 'Utente non trovato' });
  res.json(users[0]); } catch (error) 
  {console.error('Errore recupero utente:', error);res.status(500).json({ error: 'Errore durante il recupero delle informazioni utente' });}});


router.get('/users', authenticateToken, async (req, res) => {
  try {
  if (req.user.user_type_code !== 'ADMIN') return res.status(403).json({ error: 'Non autorizzato' });
  const [rows] = await db.query('CALL get_users()');const users = rows[0];
  res.json(users);} 
  catch (error) {console.error('Errore recupero utenti:', error); res.status(500).json({ error: 'Errore durante il recupero degli utenti' });}});


router.patch('/users/:id', authenticateToken, async (req, res) => {
  try {
    if (req.user.user_type_code !== 'ADMIN') return res.status(403).json({ error: 'Non autorizzato' });
    const userId = parseInt(req.params.id), { username, user_type, is_active } = req.body;
    if (isNaN(userId)) return res.status(400).json({ error: 'ID utente non valido' });
    if (username && (username.length < 3 || username.length > 50)) return res.status(400).json({ error: 'Username deve essere tra 3 e 50 caratteri' });
    if (user_type && !['USER', 'ADMIN'].includes(user_type)) return res.status(400).json({ error: 'Tipo utente non valido' });
    const [existingUsers] = await db.query('SELECT id FROM `user` WHERE id = ?', [userId]);
    if (existingUsers.length === 0) return res.status(404).json({ error: 'Utente non trovato' });
    if (username) { const [duplicates] = await db.query('SELECT id FROM `user` WHERE username = ? AND id != ?', [username, userId]); if (duplicates.length > 0) return res.status(400).json({ error: 'Username già in uso' }); }
    let userTypeId = null;
    if (user_type) { const [userTypes] = await db.query('SELECT id FROM user_type WHERE code = ?', [user_type]); if (userTypes.length === 0) return res.status(500).json({ error: 'Tipo utente non trovato' }); userTypeId = userTypes[0].id; }
    if (username === undefined && userTypeId === null && typeof is_active !== 'boolean') return res.status(400).json({ error: 'Nessun campo da aggiornare' });
    await db.query('CALL update_user(?, ?, ?, ?)', [userId, username ?? null, userTypeId, typeof is_active === 'boolean' ? is_active : null]);
    res.json({ message: 'Utente aggiornato con successo' });
  } catch (error) { console.error('Errore aggiornamento utente:', error); res.status(500).json({ error: 'Errore durante l\'aggiornamento dell\'utente' }); }
});



router.patch('/users/:id/password', authenticateToken, async (req, res) => {
  try {
  if (req.user.user_type_code !== 'ADMIN') return res.status(403).json({ error: 'Non autorizzato' });
  const userId = parseInt(req.params.id), { new_password } = req.body;
  if (isNaN(userId)) return res.status(400).json({ error: 'ID utente non valido' });
  if (!new_password || new_password.length < 6) return res.status(400).json({ error: 'Password deve essere almeno 6 caratteri' });
  const [users] = await db.query('SELECT id FROM user WHERE id = ?', [userId]);
  if (users.length === 0) return res.status(404).json({ error: 'Utente non trovato' });
  const password_hash = await bcrypt.hash(new_password, 10);
  await db.query('CALL update_user_password(?, ?)',[userId, password_hash]);
  res.json({ message: 'Password aggiornata con successo' });} catch (error) {console.error('Errore cambio password:', error);
  res.status(500).json({ error: 'Errore durante il cambio password' });}});

router.delete('/users/:id', authenticateToken, async (req, res) => {
  try {
  if (req.user.user_type_code !== 'ADMIN') return res.status(403).json({ error: 'Non autorizzato' });
  const userId = parseInt(req.params.id);
  if (isNaN(userId)) return res.status(400).json({ error: 'ID utente non valido' });
  if (userId === req.user.id) return res.status(400).json({ error: 'Non puoi eliminare il tuo account' });
  const [users] = await db.query('SELECT id FROM user WHERE id = ?', [userId]);
  if (users.length === 0) return res.status(404).json({ error: 'Utente non trovato' });
  await db.query('CALL delete_user(?)', [userId]);
  res.json({ message: 'Utente eliminato con successo' });} catch (error) {console.error('Errore eliminazione utente:', error);
  res.status(500).json({ error: 'Errore durante l\'eliminazione dell\'utente' });}});

module.exports = router;
