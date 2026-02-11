const mysql = require('mysql2/promise');
require('dotenv').config();
async function testDatabase() {
  console.log('🔍 Test connessione database...');
  
  try {
    const connection = await mysql.createConnection({ host: process.env.DB_HOST, user: process.env.DB_USER, password: process.env.DB_PASSWORD, database: process.env.DB_NAME, port: process.env.DB_PORT });
    console.log('✅ Connessione riuscita!');

    const [tables] = await connection.query('SHOW TABLES');
    console.log('📋 Tabelle trovate:', tables.length);
    const [userTypes] = await connection.query('SELECT * FROM user_type');
    console.log('👥 Tipi utente:', userTypes.length);
    if (userTypes.length > 0) console.table(userTypes);

    const [users] = await connection.query('SELECT u.id, u.username, ut.code as user_type, u.is_active, LENGTH(u.password_hash) as hash_length FROM user u LEFT JOIN user_type ut ON u.user_type_id = ut.id');
    console.log('👤 Utenti trovati:', users.length);
    if (users.length > 0) console.table(users);

    const [loginTest] = await connection.query('SELECT u.id, u.username, u.password_hash, u.is_active, ut.code as user_type_code FROM user u JOIN user_type ut ON u.user_type_id = ut.id WHERE u.username = ?', ['admin']);
    console.log('🔐 Query di login:', loginTest.length > 0 ? '✅ Funziona' : '❌ Fallita');

    const [ticketTypes] = await connection.query('SELECT * FROM ticket_type');
    console.log('📝 Tipi ticket:', ticketTypes.length);
    if (ticketTypes.length > 0) console.table(ticketTypes);
    const [ticketStatuses] = await connection.query('SELECT * FROM ticket_status');
    console.log('📊 Stati ticket:', ticketStatuses.length);
    if (ticketStatuses.length > 0) console.table(ticketStatuses);

    await connection.end();
    console.log('\n✅ Test completato!');
  } catch (error) {
    console.error('\n❌ ERRORE:', error.message);
    console.error('Dettagli:', error);
  }
}

testDatabase();
