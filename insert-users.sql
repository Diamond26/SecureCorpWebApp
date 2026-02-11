-- =========================================================
-- SCRIPT PER CREARE GLI UTENTI DI TEST
-- Esegui questo DOPO aver importato il db.sql principale
-- =========================================================

USE securecorp;

-- Elimina utenti esistenti se presenti
DELETE FROM user WHERE username IN ('admin', 'utente');

-- Inserisci Admin
-- Username: admin
-- Password: admin
-- Hash bcrypt (cost 10): $2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi
INSERT INTO user (user_type_id, username, password_hash, is_active) 
VALUES (
  (SELECT id FROM user_type WHERE code = 'ADMIN'),
  'admin',
  '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  1
);

-- Inserisci Utente
-- Username: utente
-- Password: utente
-- Hash bcrypt (cost 10): $2a$10$Ld3HktGV4XmVPOXev.H79.tEXTPEV/6BnI8Hk7TZ3N1pcJZEHB8Iq
INSERT INTO user (user_type_id, username, password_hash, is_active) 
VALUES (
  (SELECT id FROM user_type WHERE code = 'USER'),
  'utente',
  '$2a$10$Ld3HktGV4XmVPOXev.H79.tEXTPEV/6BnI8Hk7TZ3N1pcJZEHB8Iq',
  1
);

-- Verifica che gli utenti siano stati creati
SELECT u.id, u.username, ut.code as tipo_utente, u.is_active
FROM user u
JOIN user_type ut ON u.user_type_id = ut.id
WHERE u.username IN ('admin', 'utente');
