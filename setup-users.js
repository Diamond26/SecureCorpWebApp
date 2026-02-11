const bcrypt = require('bcryptjs'), mysql = require('mysql2/promise');
require('dotenv').config();
async function setupUsers() {
  try {
    const connection = await mysql.createConnection({ host: process.env.DB_HOST, user: process.env.DB_USER, password: process.env.DB_PASSWORD, database: process.env.DB_NAME });
    console.log('✓ Connesso al database');
    const adminPasswordHash = await bcrypt.hash('admin', 10), userPasswordHash = await bcrypt.hash('utente', 10);
    const [userTypes] = await connection.query('SELECT id, code FROM user_type');
    const adminTypeId = userTypes.find(t => t.code === 'ADMIN')?.id, userTypeId = userTypes.find(t => t.code === 'USER')?.id;
    if (!adminTypeId || !userTypeId) { console.error('Errore: Tipi utente non trovati nel database!'); await connection.end(); return; }
    await connection.query("DELETE FROM user WHERE username IN ('admin', 'utente')");
    const [adminResult] = await connection.query('INSERT INTO user (user_type_id, username, password_hash, is_active) VALUES (?, ?, ?, ?)', [adminTypeId, 'admin', adminPasswordHash, true]);
    const [userResult] = await connection.query('INSERT INTO user (user_type_id, username, password_hash, is_active) VALUES (?, ?, ?, ?)', [userTypeId, 'utente', userPasswordHash, true]);
    const [users] = await connection.query('SELECT u.id, u.username, ut.code as user_type, u.is_active FROM user u JOIN user_type ut ON u.user_type_id = ut.id WHERE u.username IN ("admin", "utente")');
    console.log('✓ Setup completato!\nCredenziali:\nAdmin: username=admin, password=admin\nUser: username=utente, password=utente');
    console.table(users);
    await connection.end();
  } catch (error) {
    console.error('❌ Errore:', error.message);
    process.exit(1);
  }
}

setupUsers();
