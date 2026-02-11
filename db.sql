CREATE DATABASE  IF NOT EXISTS `securecorp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `securecorp`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: securecorp
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `entity_type` varchar(30) DEFAULT NULL,
  `entity_id` bigint unsigned DEFAULT NULL,
  `description` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_activity_user` (`user_id`),
  KEY `idx_activity_action` (`action`),
  KEY `idx_activity_entity` (`entity_type`,`entity_id`),
  KEY `idx_activity_created` (`created_at`),
  CONSTRAINT `fk_activity_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_logs`
--

LOCK TABLES `activity_logs` WRITE;
/*!40000 ALTER TABLE `activity_logs` DISABLE KEYS */;
INSERT INTO `activity_logs` VALUES (1,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:36:13'),(2,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:37:22'),(3,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:37:48'),(4,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:37:54'),(5,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:39:15'),(6,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:39:27'),(7,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:39:32'),(8,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:41:25'),(9,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:41:30'),(10,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:43:35'),(11,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:48:03'),(12,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:48:12'),(13,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:48:24'),(14,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:50:01'),(15,28,'USER_CREATED','USER',30,'Utente creato: dario (USER)','::1','{\"username\": \"dario\", \"user_type\": \"USER\", \"created_by\": \"admin\"}','2026-02-11 22:50:16'),(16,28,'TICKET_MESSAGE_ADDED','TICKET',6,'Risposta aggiunta al ticket: \"dasdasdsa\"','::1','{\"sender\": \"admin\", \"ticket_id\": 6, \"message_preview\": \"ciaooo\\n\"}','2026-02-11 22:50:29'),(17,28,'TICKET_STATUS_CHANGED','TICKET',6,'Status ticket modificato: \"dasdasdsa\" (CLOSED → OPEN)','::1','{\"ticket_id\": 6, \"changed_by\": \"admin\", \"new_status\": \"OPEN\", \"old_status\": \"CLOSED\"}','2026-02-11 22:50:33'),(18,28,'TICKET_MESSAGE_ADDED','TICKET',4,'Risposta aggiunta al ticket: \"dasdsadsadas\"','::1','{\"sender\": \"admin\", \"ticket_id\": 4, \"message_preview\": \"dasdsadsa\"}','2026-02-11 22:50:36'),(19,28,'TICKET_STATUS_CHANGED','TICKET',4,'Status ticket modificato: \"dasdsadsadas\" (IN_PROGRESS → CLOSED)','::1','{\"ticket_id\": 4, \"changed_by\": \"admin\", \"new_status\": \"CLOSED\", \"old_status\": \"IN_PROGRESS\"}','2026-02-11 22:50:40'),(20,28,'USER_DELETED','USER',30,'Utente eliminato: dario','::1','{\"deleted_by\": \"admin\", \"deleted_user\": \"dario\"}','2026-02-11 22:50:44'),(21,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 22:51:12'),(22,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 22:51:14'),(23,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:00:09'),(24,29,'LOGOUT','AUTH',29,'Logout effettuato: utente','::1','{\"username\": \"utente\"}','2026-02-11 23:00:15'),(25,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:00:20'),(26,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 23:00:28'),(27,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:00:31'),(28,29,'TICKET_CREATED','TICKET',7,'Ticket creato: \"ddasdas\"','::1','{\"title\": \"ddasdas\", \"creator\": \"utente\", \"ticket_type\": \"ACCESS\"}','2026-02-11 23:00:35'),(29,29,'LOGOUT','AUTH',29,'Logout effettuato: utente','::1','{\"username\": \"utente\"}','2026-02-11 23:00:37'),(30,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:00:40'),(31,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:03:27'),(32,28,'TICKET_MESSAGE_ADDED','TICKET',7,'Risposta aggiunta al ticket: \"ddasdas\"','::1','{\"sender\": \"admin\", \"ticket_id\": 7, \"message_preview\": \"dasdasd\"}','2026-02-11 23:03:33'),(33,28,'TICKET_MESSAGE_ADDED','TICKET',7,'Risposta aggiunta al ticket: \"ddasdas\"','::1','{\"sender\": \"admin\", \"ticket_id\": 7, \"message_preview\": \"dasdasd\"}','2026-02-11 23:03:33'),(34,28,'TICKET_MESSAGE_ADDED','TICKET',7,'Risposta aggiunta al ticket: \"ddasdas\"','::1','{\"sender\": \"admin\", \"ticket_id\": 7, \"message_preview\": \"dasdasd\"}','2026-02-11 23:03:34'),(35,28,'TICKET_MESSAGE_ADDED','TICKET',7,'Risposta aggiunta al ticket: \"ddasdas\"','::1','{\"sender\": \"admin\", \"ticket_id\": 7, \"message_preview\": \"dasdasd\"}','2026-02-11 23:03:34'),(36,28,'TICKET_MESSAGE_ADDED','TICKET',7,'Risposta aggiunta al ticket: \"ddasdas\"','::1','{\"sender\": \"admin\", \"ticket_id\": 7, \"message_preview\": \"dasdasd\"}','2026-02-11 23:03:34'),(37,28,'TICKET_STATUS_CHANGED','TICKET',7,'Status ticket modificato: \"ddasdas\" (OPEN → IN_PROGRESS)','::1','{\"ticket_id\": 7, \"changed_by\": \"admin\", \"new_status\": \"IN_PROGRESS\", \"old_status\": \"OPEN\"}','2026-02-11 23:03:37'),(38,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 23:03:38'),(39,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:03:43'),(40,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:06:59'),(41,29,'LOGOUT','AUTH',29,'Logout effettuato: utente','::1','{\"username\": \"utente\"}','2026-02-11 23:07:04'),(42,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:07:06'),(43,28,'TICKET_MESSAGE_ADDED','TICKET',7,'Risposta aggiunta al ticket: \"ddasdas\"','::1','{\"sender\": \"admin\", \"ticket_id\": 7, \"message_preview\": \"dasd\"}','2026-02-11 23:07:10'),(44,28,'TICKET_STATUS_CHANGED','TICKET',7,'Status ticket modificato: \"ddasdas\" (IN_PROGRESS → CLOSED)','::1','{\"ticket_id\": 7, \"changed_by\": \"admin\", \"new_status\": \"CLOSED\", \"old_status\": \"IN_PROGRESS\"}','2026-02-11 23:07:25'),(45,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 23:07:28'),(46,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:07:34'),(47,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:10:37'),(48,28,'TICKET_MESSAGE_ADDED','TICKET',7,'Risposta aggiunta al ticket: \"ddasdas\"','::1','{\"sender\": \"admin\", \"ticket_id\": 7, \"message_preview\": \"ciao\"}','2026-02-11 23:10:46'),(49,28,'TICKET_STATUS_CHANGED','TICKET',7,'Status ticket modificato: \"ddasdas\" (CLOSED → OPEN)','::1','{\"ticket_id\": 7, \"changed_by\": \"admin\", \"new_status\": \"OPEN\", \"old_status\": \"CLOSED\"}','2026-02-11 23:10:52'),(50,28,'TICKET_STATUS_CHANGED','TICKET',7,'Status ticket modificato: \"ddasdas\" (OPEN → IN_PROGRESS)','::1','{\"ticket_id\": 7, \"changed_by\": \"admin\", \"new_status\": \"IN_PROGRESS\", \"old_status\": \"OPEN\"}','2026-02-11 23:10:54'),(51,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 23:11:04'),(52,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:11:06'),(53,29,'LOGOUT','AUTH',29,'Logout effettuato: utente','::1','{\"username\": \"utente\"}','2026-02-11 23:13:09'),(54,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:13:20'),(55,28,'TICKET_MESSAGE_ADDED','TICKET',7,'Risposta aggiunta al ticket: \"ddasdas\"','::1','{\"sender\": \"admin\", \"ticket_id\": 7, \"message_preview\": \"uffa\\n\"}','2026-02-11 23:13:28'),(56,28,'TICKET_STATUS_CHANGED','TICKET',7,'Status ticket modificato: \"ddasdas\" (IN_PROGRESS → CLOSED)','::1','{\"ticket_id\": 7, \"changed_by\": \"admin\", \"new_status\": \"CLOSED\", \"old_status\": \"IN_PROGRESS\"}','2026-02-11 23:13:42'),(57,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 23:13:43'),(58,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:13:46'),(59,29,'TICKET_CREATED','TICKET',8,'Ticket creato: \"prova123\"','::1','{\"title\": \"prova123\", \"creator\": \"utente\", \"ticket_type\": \"BUG\"}','2026-02-11 23:13:56'),(60,29,'LOGOUT','AUTH',29,'Logout effettuato: utente','::1','{\"username\": \"utente\"}','2026-02-11 23:13:59'),(61,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:14:01'),(62,28,'TICKET_MESSAGE_ADDED','TICKET',8,'Risposta aggiunta al ticket: \"prova123\"','::1','{\"sender\": \"admin\", \"ticket_id\": 8, \"message_preview\": \"si prova\"}','2026-02-11 23:14:07'),(63,28,'TICKET_STATUS_CHANGED','TICKET',8,'Status ticket modificato: \"prova123\" (OPEN → IN_PROGRESS)','::1','{\"ticket_id\": 8, \"changed_by\": \"admin\", \"new_status\": \"IN_PROGRESS\", \"old_status\": \"OPEN\"}','2026-02-11 23:14:10'),(64,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 23:14:15'),(65,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:14:18'),(66,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:16:48'),(67,28,'TICKET_MESSAGE_ADDED','TICKET',8,'Risposta aggiunta al ticket: \"prova123\"','::1','{\"sender\": \"admin\", \"ticket_id\": 8, \"message_preview\": \"provaaa\"}','2026-02-11 23:16:53'),(68,28,'TICKET_STATUS_CHANGED','TICKET',8,'Status ticket modificato: \"prova123\" (IN_PROGRESS → OPEN)','::1','{\"ticket_id\": 8, \"changed_by\": \"admin\", \"new_status\": \"OPEN\", \"old_status\": \"IN_PROGRESS\"}','2026-02-11 23:16:58'),(69,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 23:17:00'),(70,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:17:03'),(71,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:21:16'),(72,29,'TICKET_CREATED','TICKET',9,'Ticket creato: \"dsadasdas\"','::1','{\"title\": \"dsadasdas\", \"creator\": \"utente\", \"ticket_type\": \"SUPPORT\"}','2026-02-11 23:21:24'),(73,29,'TICKET_CREATED','TICKET',10,'Ticket creato: \"783578954546576\"','::1','{\"title\": \"783578954546576\", \"creator\": \"utente\", \"ticket_type\": \"BUG\"}','2026-02-11 23:21:29'),(74,29,'LOGOUT','AUTH',29,'Logout effettuato: utente','::1','{\"username\": \"utente\"}','2026-02-11 23:21:30'),(75,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:21:32'),(76,28,'TICKET_STATUS_CHANGED','TICKET',10,'Status ticket modificato: \"783578954546576\" (OPEN → IN_PROGRESS)','::1','{\"ticket_id\": 10, \"changed_by\": \"admin\", \"new_status\": \"IN_PROGRESS\", \"old_status\": \"OPEN\"}','2026-02-11 23:21:36'),(77,28,'TICKET_MESSAGE_ADDED','TICKET',10,'Risposta aggiunta al ticket: \"783578954546576\"','::1','{\"sender\": \"admin\", \"ticket_id\": 10, \"message_preview\": \"1213213123123\"}','2026-02-11 23:21:40'),(78,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 23:21:45'),(79,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:21:49'),(80,29,'LOGOUT','AUTH',29,'Logout effettuato: utente','::1','{\"username\": \"utente\"}','2026-02-11 23:21:53'),(81,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:24:23'),(82,29,'LOGOUT','AUTH',29,'Logout effettuato: utente','::1','{\"username\": \"utente\"}','2026-02-11 23:24:25'),(83,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:24:28'),(84,28,'TICKET_MESSAGE_ADDED','TICKET',10,'Risposta aggiunta al ticket: \"783578954546576\"','::1','{\"sender\": \"admin\", \"ticket_id\": 10, \"message_preview\": \"dsadas\"}','2026-02-11 23:24:32'),(85,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::ffff:127.0.0.1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:29:30'),(86,28,'USER_CREATED','USER',31,'Utente creato: davide (USER)','::1','{\"username\": \"davide\", \"user_type\": \"USER\", \"created_by\": \"admin\"}','2026-02-11 23:29:44'),(87,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:31:07'),(88,28,'TICKET_MESSAGE_ADDED','TICKET',10,'Risposta aggiunta al ticket: \"783578954546576\"','::1','{\"sender\": \"admin\", \"ticket_id\": 10, \"message_preview\": \"dasda\"}','2026-02-11 23:31:26'),(89,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 23:32:00'),(90,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:32:57'),(91,28,'LOGOUT','AUTH',28,'Logout effettuato: admin','::1','{\"username\": \"admin\"}','2026-02-11 23:33:02'),(92,29,'LOGIN_SUCCESS','AUTH',29,'Login riuscito: utente','::1','{\"username\": \"utente\", \"user_type\": \"USER\"}','2026-02-11 23:33:21'),(93,29,'LOGOUT','AUTH',29,'Logout effettuato: utente','::1','{\"username\": \"utente\"}','2026-02-11 23:33:31'),(94,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:35:47'),(95,28,'LOGIN_SUCCESS','AUTH',28,'Login riuscito: admin','::1','{\"username\": \"admin\", \"user_type\": \"ADMIN\"}','2026-02-11 23:35:54');
/*!40000 ALTER TABLE `activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `action` varchar(50) NOT NULL,
  `entity_type` varchar(50) NOT NULL,
  `entity_id` bigint unsigned NOT NULL,
  `details` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_action` (`user_id`,`action`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_created` (`created_at`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jwt`
--

DROP TABLE IF EXISTS `jwt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jwt` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `jti` char(36) NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `issued_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  `revoked_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_jwt_jti` (`jti`),
  KEY `idx_jwt_user_expires` (`user_id`,`expires_at`),
  KEY `idx_jwt_expires` (`expires_at`),
  CONSTRAINT `fk_jwt_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jwt`
--

LOCK TABLES `jwt` WRITE;
/*!40000 ALTER TABLE `jwt` DISABLE KEYS */;
INSERT INTO `jwt` VALUES (29,13,'794dbb21-0c91-4c98-a5d5-f93644ab89cc','$2a$10$XCTxxMGJjYwrN2QKTreqXeCxDbyd2r.aAh3whzjg4ea4mHSGk6Pay','2026-02-04 15:29:47','2026-02-11 15:29:47','2026-02-04 15:33:22'),(30,15,'101007a1-2e49-45ad-80b6-3df59dc2ab4c','$2a$10$caIPj7lNJDGIvT3Bw9fZ0OenajGuNxvYp31lBItBRzf2ovxdfyBr2','2026-02-04 15:32:56','2026-02-11 15:32:57','2026-02-04 15:33:23'),(31,13,'abc5ab17-848f-43f3-8575-a6df4f6689c9','$2a$10$/depvtu0SHklc87kcMgy/u3OuPqktvBzRsuj1VmR2sfjqzyt9/EqW','2026-02-04 17:51:47','2026-02-11 17:51:48',NULL),(32,13,'b7ef3edd-4eae-4d2d-9050-45bdae1298a3','$2a$10$geDHiVuvpNDc0Tc3fs9WEuGQHopHJM4t0/EseYwv64UaThYlpv7A2','2026-02-05 15:23:12','2026-02-12 15:23:12','2026-02-05 15:23:26'),(33,13,'b7f13a2d-ed70-4bec-9b0e-3b2e268427fe','$2a$10$keW3nbs.6pCjkQFQ/wZr2evtc/V/YLqJ2RXIcnod2zz.ycekIdjAu','2026-02-05 15:33:24','2026-02-12 15:33:24','2026-02-05 15:34:15'),(34,15,'a0e3fffa-2e59-4bd0-a1f5-818b15b0e2c5','$2a$10$L/1Y07BakdqwuXn14O8WvO.zLkPYZgJ0LTQjDByXuYQwVPJWF4CkK','2026-02-05 15:34:19','2026-02-12 15:34:20',NULL),(35,13,'c0ed8488-477d-4161-9421-f2f3285d5444','$2a$10$K1zha6qk/1U2Se3dTLwLWeLbniAKiC13w41s4HgDAqaqwPzt7R45G','2026-02-05 15:44:07','2026-02-12 15:44:08','2026-02-05 15:58:27'),(36,13,'4d1103b4-656d-450c-a235-0b730a80898e','$2a$10$oGA6vBUncDHhOSs6l5wQ3eMX0p0bFuQnGiyB8t6hnMIoDWzo705Ga','2026-02-05 15:58:30','2026-02-12 15:58:31','2026-02-05 15:58:39'),(37,15,'15ee9d85-3f1a-4daa-9239-3a08d892fca6','$2a$10$/nzQJ6MBu3OTgvbWPkBTaeK.VgVD2tBNueFqeBtmKlzAByXb/cHQ6','2026-02-05 15:58:47','2026-02-12 15:58:48',NULL),(38,13,'0142786b-dc62-4c4b-85e4-72b281213b4e','$2a$10$fqPCbVv.Lvp2v67SAO5uLOiQVPfbjtzRyHnxydaRNoV0p0oucnxjW','2026-02-05 16:01:28','2026-02-12 16:01:29','2026-02-05 16:01:31'),(39,13,'e25c0140-2461-4c66-8f5e-87e2e5760fd2','$2a$10$nexN1O.y/Un4iZCCgh6Er.xxbAidUVGZ5DyItHwbmJZEFlVpWrwom','2026-02-05 16:19:33','2026-02-12 16:19:33',NULL),(40,13,'10075f44-6ad6-4c99-bc4a-11947e3e335d','$2a$10$afnavOOYwxQRp41gJzOJb.MnOSAaQfHNFIqLNigMHSVB27odKai8u','2026-02-05 16:55:58','2026-02-12 16:55:58',NULL),(41,13,'11bc7658-f215-43fd-acb1-9b632dd93b47','$2a$10$E17P68t3SpECeMx9zqlMkOk3fRVIgEnjsgHnaJ1bXfivwZEK2KbTS','2026-02-05 17:10:30','2026-02-12 17:10:30','2026-02-05 17:11:17'),(42,15,'e696aa36-858c-466e-8a31-1376891c8bfc','$2a$10$.gkjX0fe4wYK/R6m3YMBG.Lm.LkdLc9jixoqQt58nyiil6MIV6FU6','2026-02-05 17:11:27','2026-02-12 17:11:27','2026-02-05 17:11:50'),(79,28,'327df14f-9dc6-4a15-8504-d4cc140f8562','$2a$10$2RPjlgQVI8XT2RKb3FAGQOQ5XBsSRjjKYErCCkwH6C1FGd7gLKCjO','2026-02-11 23:00:04','2026-02-18 23:00:05',NULL),(80,28,'5a5f705a-b6a2-42e6-a988-9580bf35f416','$2a$10$fQ6TYq3vInyegjxo8AmIP.Ns7BAYKGaPcey4RWl1LxOuMf0hxDuI.','2026-02-11 23:12:15','2026-02-18 23:12:16',NULL),(81,28,'8019b9f6-9f1d-462f-b572-b5bac5a40f57','$2a$10$26YEFukh18q3a5a6yda3peHio73w9lLKqNrlsJE7GbwBWce4BeQ4u','2026-02-11 23:13:41','2026-02-18 23:13:41',NULL),(82,28,'2ff4d520-ad1a-42c5-b962-4bf04fd05a5d','$2a$10$Hpnf4HIkBtg/.SvNINGz9uDr5im.ACVBOROzePE6AraLIPa0BmQk6','2026-02-11 23:36:13','2026-02-18 23:36:13',NULL),(83,28,'7bcb2c5a-ec0b-450d-a182-a1e84b830ecb','$2a$10$Ef/PUDfhNRcyC8OdHNYlgOz410KBDIpjmYbULLF16cKriUc5tDBmm','2026-02-11 23:37:22','2026-02-18 23:37:22',NULL),(84,28,'b9a91c9c-a992-492b-9345-7351583018b8','$2a$10$E6rLqry4VjQUJW3NQSjOa.QRulnSItd.YU0lnuB12lnilCxOw52OO','2026-02-11 23:37:48','2026-02-18 23:37:49',NULL),(85,28,'bb117292-d084-4888-b592-83dd6db399dd','$2a$10$b3P4Fkm42Timnc4PDM4x3eFs25tfAw5AEluAHnBAzp6KHy8UX02ZG','2026-02-11 23:37:54','2026-02-18 23:37:55',NULL),(86,28,'293791aa-3156-4fb0-9818-0c5588f0b338','$2a$10$6q6kFqbK3i9ZcLzKvp2SweB42TyxUSF/ZrZ3vKJKOhuc4p2UAE.uu','2026-02-11 23:39:15','2026-02-18 23:39:16',NULL),(87,28,'43b61a16-fafe-45f5-8140-32f5cd079cd9','$2a$10$xKwa0T1lb.yXXGmi3uVEc.DI4wDyF0q8otggfNMsCMXABagwKgPVm','2026-02-11 23:39:26','2026-02-18 23:39:27',NULL),(88,28,'3fe4bef8-26f1-49c0-bbaa-a0de8bdd539b','$2a$10$6r28LRejBcGQlKBa8m7jQejvvvF9fQc0DEIKmcSPjqnL4fQd/dpQe','2026-02-11 23:39:32','2026-02-18 23:39:33',NULL),(89,28,'33dac14d-0bb2-4cfd-98de-6bfe85272652','$2a$10$dSfM5vE1qsAmKu374SGbwenb1jnHIh6KnmXBaCmhZKTIg/irbLY56','2026-02-11 23:41:25','2026-02-18 23:41:26',NULL),(90,28,'605aef05-220d-4d84-a346-d3f515037835','$2a$10$IQ0fNoWmJwkU9mR97uXrpu5yi9w4dQ8AUVxOabzdYiNhbm1H2Ac5O','2026-02-11 23:41:30','2026-02-18 23:41:30',NULL),(91,28,'d31a1da4-7179-48a9-b6a0-d376d031a2f0','$2a$10$Z0mVr1O2sKHLd3MVec4gI.WsmYQQNohDAglJRhPhLj4UmdA8jdzcO','2026-02-11 23:43:35','2026-02-18 23:43:35',NULL),(92,28,'c7b5ff86-cc53-4aed-a856-658c7afd4b31','$2a$10$zQVGz/YyEncIuikhE9v2aegSF9duV4DFUQdf/rB6QbkjCCGLHHaRW','2026-02-11 23:48:03','2026-02-18 23:48:03',NULL),(93,28,'215bc4d0-9839-41d7-8be1-662fc947f078','$2a$10$Wd6qvyVx9pB1a5wKjkJT7egko/t.aa.pVlQKM8.eE6aBfcfjJ.VzC','2026-02-11 23:48:12','2026-02-18 23:48:13',NULL),(94,28,'7c94dbf9-0485-4913-934c-d420204ffa09','$2a$10$Fr8r7E/TEw3zvW1k0IUMqO6fLJi8a33BCD6FgnLY9X8R23Jqz7cke','2026-02-11 23:48:24','2026-02-18 23:48:24',NULL),(95,28,'dfe58515-0863-4e5a-9122-62b99efe9940','$2a$10$.AJ6oAThjafcYJwSK91rReHoGNRa3/VR9OTBtTYmpH4wkyJ7isS4K','2026-02-11 23:50:01','2026-02-18 23:50:01','2026-02-11 23:51:12'),(96,28,'f66b93f5-0570-4d7a-ba8e-c0de8acc1b07','$2a$10$zHZL50J5kzGabjRFVtFI2uf/B5cajdOpM3x2jegAmncMjubx0.CuC','2026-02-11 23:51:14','2026-02-18 23:51:15',NULL),(97,29,'f279f926-3d8a-4a8d-a05f-2538fe9b5b85','$2a$10$Wv.ez7614238OLmr6sHNvOB2AE1jME.zX81Ccnm2XvMpjs67K4itS','2026-02-12 00:00:09','2026-02-19 00:00:10','2026-02-12 00:00:15'),(98,28,'fe169df5-8ef1-4d9a-a4a9-8db486f632e0','$2a$10$mvEek/I07xhLd2ZvkBv5YupHQaFntmo0WK1LyqPv6YUfXQFf/AcpO','2026-02-12 00:00:20','2026-02-19 00:00:20','2026-02-12 00:00:28'),(99,29,'67772ffe-3d65-436c-ba5d-20e4e5ff96e0','$2a$10$FjFZCuvdglxsbHdKmBeFN.bP4C5tq7reYt/CbkBGsf075gMjP7rbO','2026-02-12 00:00:31','2026-02-19 00:00:32','2026-02-12 00:00:37'),(100,28,'9d595988-237e-4b88-9f38-60244451958e','$2a$10$5FdJD39U0UVRDlxDQQMck.Exb.DZpPWVSgmfRKYm48U9HzZL95uDK','2026-02-12 00:00:40','2026-02-19 00:00:40',NULL),(101,28,'67aa2e4a-4dde-4fef-a1fb-fbce4f9402c9','$2a$10$qWVfJqVV3lFSwQp.1KL03eLS0wyL4Evg5rFduVE6wLgIoJxkpP6lu','2026-02-12 00:03:27','2026-02-19 00:03:27','2026-02-12 00:03:38'),(102,29,'f95864c3-2a17-465e-9f62-438216c28bd9','$2a$10$iu23eTb10VYrORdqanMdFuhKNNR/Bt4DTf8g3LfVAaSF4BAkojEOa','2026-02-12 00:03:43','2026-02-19 00:03:44',NULL),(103,29,'f397fa0b-705e-46b3-8407-eb8e20e6fc2a','$2a$10$Vg3JJHGQTBgkCb4zIwzNyu7ftQxM0Y05xx3lWbRK107hrL9.03bni','2026-02-12 00:06:59','2026-02-19 00:07:00','2026-02-12 00:07:04'),(104,28,'6d57bab5-74d5-42a8-9b01-ad2b9a25ad9a','$2a$10$ymESx7S8315Tp/RVpMiDVOs56WptLPQPll0IFiXrKvvBjVgHSsiUC','2026-02-12 00:07:06','2026-02-19 00:07:06','2026-02-12 00:07:28'),(105,29,'453fcca8-0803-495b-a3f9-785c8086e8cf','$2a$10$Xov.XYv468e5muUxupVnyei01DFTGi5nQ.Avy/osdmxBP8KYe5zvG','2026-02-12 00:07:34','2026-02-19 00:07:34',NULL),(106,28,'f2a8809a-b427-40a1-834d-9a77fbd507e4','$2a$10$FIYoTKmJLUlH./ap4MiGI.HF6A7nW8xb3xFqVJw6Rbil4Yro9c1gu','2026-02-12 00:10:37','2026-02-19 00:10:37','2026-02-12 00:11:03'),(107,29,'13ed58e1-e6be-4446-b46d-a09b9b69c1d7','$2a$10$/x3Eu1S/UWGR7YPaZcaDQ.a1HKw/Spi0/mNt4Mk7AqKIb/Ql7a3qq','2026-02-12 00:11:06','2026-02-19 00:11:07','2026-02-12 00:13:09'),(108,28,'358b21ec-3858-4db9-a2bb-6bf444786d95','$2a$10$FFXOQrT27T3xznVNSwgDzuTiO5nYaPmGdPhAGubzh2Lt7qlIKkMsy','2026-02-12 00:13:20','2026-02-19 00:13:20','2026-02-12 00:13:43'),(109,29,'d2f5a576-e0b9-44c8-a3f9-51d2ff524e2f','$2a$10$CpRn/ph4GnBQ4cQkCfjaHuxOjpTq2bwenPyZA2orONG7vScNQcU9a','2026-02-12 00:13:46','2026-02-19 00:13:46','2026-02-12 00:13:59'),(110,28,'b6edf76a-fcb5-43a0-bebc-8eb8581a923c','$2a$10$rmzYbPqZi.e41oQIYM.7GekBusLYopjlcsUSFn2BZc2P2K9u4.wcm','2026-02-12 00:14:01','2026-02-19 00:14:01','2026-02-12 00:14:15'),(111,29,'18a1ee49-9391-4591-9838-2781a47f42fb','$2a$10$k9lRSt.WvNL1ey2vnFjVn.L3zaDZQ7e8CMncW4dpyP0.vjNhVVxkC','2026-02-12 00:14:18','2026-02-19 00:14:19',NULL),(112,28,'c2097d73-c636-4db1-9217-1b0d42f5d9ed','$2a$10$d851TlgG5hgVwHeSRTA/xO1QsEfyRU.zhhVcCO7bscNkRxpts3JNm','2026-02-12 00:16:48','2026-02-19 00:16:49','2026-02-12 00:17:00'),(113,29,'0d09f325-5fd2-4dbd-bd2f-9ed15f53b6d1','$2a$10$YcK.el1V7oZFc/v2/1dZX.ZlOv0vt23qCWDjuPyRbndGeQGVhaKqK','2026-02-12 00:17:03','2026-02-19 00:17:04',NULL),(114,29,'0de82e72-361c-443e-86a3-a89cd7ba9485','$2a$10$1oynuhzh5rNIqT4hLQZLwudx0LM1MiBSQsAjXXZR50kJfIxybXjQq','2026-02-12 00:21:16','2026-02-19 00:21:16','2026-02-12 00:21:30'),(115,28,'e94019b0-8672-4c79-8b50-302421bed6de','$2a$10$8MjbkzStBC8MbefAGjAKouesVEzPPcO1Swx2hm2ONtdstW2nm32Mq','2026-02-12 00:21:32','2026-02-19 00:21:33','2026-02-12 00:21:45'),(116,29,'05b84f61-afa4-42ed-a156-b2a17209ef13','$2a$10$gZCZgPEa/pc7K2768hgAOOvzAqvqv/4tCgBrCs07KpPIPIfRZjBtO','2026-02-12 00:21:49','2026-02-19 00:21:50','2026-02-12 00:21:53'),(117,29,'ca184a7a-33b5-42b1-a4bc-d48f88257c69','$2a$10$XnlciLd9rUveceQUOrAnfOe36imZF.iUkZJTz38ofC2m6mUPyKdfC','2026-02-12 00:24:23','2026-02-19 00:24:23','2026-02-12 00:24:25'),(118,28,'df9a609e-d912-4558-8a34-69e094d8f75e','$2a$10$0lLTRvRc3xYl2ouVUfOzMODy.8799YOtHiXNmsbWh1jF6tA4wOx9S','2026-02-12 00:24:28','2026-02-19 00:24:28',NULL),(119,28,'dc41316c-071c-4107-bab1-46bd40b079a2','$2a$10$UONCu0FZ0/5aq9bzUvHlTuXO.b5OUIfzQWV5E4rN.EO7D8lUSXdt.','2026-02-12 00:29:30','2026-02-19 00:29:30',NULL),(120,28,'0b5f5eda-21b9-423b-8633-0a5a926fc1c4','$2a$10$tqAV6VtsYu1HsRYR79TiLe38PEXCZsIkVDVJLM1znT5b.KZpWnHFe','2026-02-12 00:31:07','2026-02-19 00:31:07','2026-02-12 00:32:00'),(121,28,'17e93126-836f-4173-bcfe-97ffd8aa3abd','$2a$10$Z8Dwa4NCyST8zlAr.3GfHeTlprrRqPNm5zawVpSp4jxoRLavi9baq','2026-02-12 00:32:57','2026-02-19 00:32:58','2026-02-12 00:33:02'),(122,29,'be354f63-77e2-4b9e-b9fb-c2e35cd496f3','$2a$10$rgqZh/UNagcdeUe7wwC/LOJTAxqItUmKaFrAd0G/Ine/PNje8.H4O','2026-02-12 00:33:21','2026-02-19 00:33:22','2026-02-12 00:33:31'),(123,28,'42f31d80-944a-458e-8339-f0f029688d97','$2a$10$e1SGuyrxiSW5APBElb1WmuOk66jcsjavDKFwFwftSmT5axE0CyTxe','2026-02-12 00:35:47','2026-02-19 00:35:47',NULL),(124,28,'c37dbea2-5d74-42b3-b9a9-1ed8342e9fa7','$2a$10$fvmpPrZXNXIHdel0WFKJyu3MEV3wqGHBIEFrrYKf0yn1PrKM5SPNe','2026-02-12 00:35:54','2026-02-19 00:35:55',NULL);
/*!40000 ALTER TABLE `jwt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `new_view`
--

DROP TABLE IF EXISTS `new_view`;
/*!50001 DROP VIEW IF EXISTS `new_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `new_view` AS SELECT 
 1 AS `code`,
 1 AS `description`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ticket`
--

DROP TABLE IF EXISTS `ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT NULL,
  `ticket_type_id` smallint unsigned NOT NULL,
  `ticket_status_id` tinyint unsigned NOT NULL,
  `title` varchar(120) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `deleted_by` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ticket_user_created` (`user_id`,`created_at`),
  KEY `idx_ticket_status_created` (`ticket_status_id`,`created_at`),
  KEY `idx_ticket_type` (`ticket_type_id`),
  KEY `idx_deleted` (`deleted`,`deleted_at`),
  KEY `fk_ticket_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_ticket_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ticket_status` FOREIGN KEY (`ticket_status_id`) REFERENCES `ticket_status` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ticket_type` FOREIGN KEY (`ticket_type_id`) REFERENCES `ticket_type` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ticket_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket`
--

LOCK TABLES `ticket` WRITE;
/*!40000 ALTER TABLE `ticket` DISABLE KEYS */;
INSERT INTO `ticket` VALUES (1,NULL,3,1,'prova123','provaaaaaaaaaaaaaa','2026-02-03 14:16:30',NULL,0,NULL,NULL),(2,15,2,3,'dsadasd','dasdasdada','2026-02-05 14:34:25','2026-02-11 20:50:12',0,NULL,NULL),(3,NULL,2,1,'heila','heiladasdasd','2026-02-11 20:50:37','2026-02-11 21:38:23',0,NULL,NULL),(4,NULL,3,3,'dasdsadsadas','dsadasdsad','2026-02-11 21:38:19','2026-02-11 22:50:40',0,NULL,NULL),(5,NULL,2,1,'dsadasdsadasdasdsa','asdasddasdsad','2026-02-11 21:43:10','2026-02-11 21:43:13',0,NULL,NULL),(6,NULL,2,1,'dasdasdsa','dasdsadas','2026-02-11 21:44:01','2026-02-11 22:50:33',0,NULL,NULL),(7,29,3,3,'ddasdas','dasdsads','2026-02-11 23:00:35','2026-02-11 23:13:42',0,NULL,NULL),(8,29,1,1,'prova123','prova123\n','2026-02-11 23:13:56','2026-02-11 23:16:58',0,NULL,NULL),(9,29,2,1,'dsadasdas','dsadsad','2026-02-11 23:21:23',NULL,0,NULL,NULL),(10,29,1,2,'783578954546576','65564745647654675','2026-02-11 23:21:29','2026-02-11 23:21:36',0,NULL,NULL);
/*!40000 ALTER TABLE `ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_message`
--

DROP TABLE IF EXISTS `ticket_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket_message` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_message_ticket` (`ticket_id`),
  KEY `fk_message_user` (`user_id`),
  CONSTRAINT `fk_message_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_message_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_message`
--

LOCK TABLES `ticket_message` WRITE;
/*!40000 ALTER TABLE `ticket_message` DISABLE KEYS */;
INSERT INTO `ticket_message` VALUES (5,6,28,'ciaooo\n','2026-02-11 22:50:29'),(6,4,28,'dasdsadsa','2026-02-11 22:50:36'),(7,7,28,'dasdasd','2026-02-11 23:03:33'),(8,7,28,'dasdasd','2026-02-11 23:03:33'),(9,7,28,'dasdasd','2026-02-11 23:03:34'),(10,7,28,'dasdasd','2026-02-11 23:03:34'),(11,7,28,'dasdasd','2026-02-11 23:03:34'),(12,7,28,'dasd','2026-02-11 23:07:10'),(13,7,28,'ciao','2026-02-11 23:10:46'),(14,7,28,'uffa\n','2026-02-11 23:13:28'),(15,8,28,'si prova','2026-02-11 23:14:07'),(16,8,28,'provaaa','2026-02-11 23:16:53'),(17,10,28,'1213213123123','2026-02-11 23:21:40'),(18,10,28,'dsadas','2026-02-11 23:24:32'),(19,10,28,'dasda','2026-02-11 23:31:25');
/*!40000 ALTER TABLE `ticket_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_status`
--

DROP TABLE IF EXISTS `ticket_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket_status` (
  `id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL,
  `description` varchar(120) NOT NULL,
  `is_terminal` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ticket_status_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_status`
--

LOCK TABLES `ticket_status` WRITE;
/*!40000 ALTER TABLE `ticket_status` DISABLE KEYS */;
INSERT INTO `ticket_status` VALUES (1,'OPEN','Ticket aperto',0),(2,'IN_PROGRESS','In lavorazione',0),(3,'CLOSED','Ticket chiuso',1);
/*!40000 ALTER TABLE `ticket_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_type`
--

DROP TABLE IF EXISTS `ticket_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket_type` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL,
  `description` varchar(120) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ticket_type_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_type`
--

LOCK TABLES `ticket_type` WRITE;
/*!40000 ALTER TABLE `ticket_type` DISABLE KEYS */;
INSERT INTO `ticket_type` VALUES (1,'BUG','Segnalazione bug'),(2,'SUPPORT','Richiesta supporto'),(3,'ACCESS','Richiesta accesso');
/*!40000 ALTER TABLE `ticket_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_type_id` tinyint unsigned NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_username` (`username`),
  KEY `idx_user_user_type_id` (`user_type_id`),
  CONSTRAINT `fk_user_user_type` FOREIGN KEY (`user_type_id`) REFERENCES `user_type` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (28,2,'admin','$2a$10$UF7fvWO6BSiesNEedj87OOBASZRoVnY4MHWY7YTspBeF/h.EAFNqu',1,'2026-02-11 22:00:00'),(29,1,'utente','$2a$10$soUgOFO6c9E29lfrwJiTduDwj934JxaLytbcxfWkYTJfRehr0OffC',1,'2026-02-11 22:00:00'),(31,1,'davide','$2a$10$ypuE1bZSxipG.UuvZhhmCuo5xZujtl/U1b0HmB2GoBjoYJby43Suq',1,'2026-02-11 23:29:44');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_type`
--

DROP TABLE IF EXISTS `user_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_type` (
  `id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `description` varchar(120) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_type_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_type`
--

LOCK TABLES `user_type` WRITE;
/*!40000 ALTER TABLE `user_type` DISABLE KEYS */;
INSERT INTO `user_type` VALUES (1,'USER','Utente standard'),(2,'ADMIN','Amministratore');
/*!40000 ALTER TABLE `user_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'securecorp'
--

--
-- Dumping routines for database 'securecorp'
--
/*!50003 DROP PROCEDURE IF EXISTS `delete_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user`(
  IN p_user_id INT
)
BEGIN
  DELETE FROM `user`
  WHERE id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getusertype` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getusertype`()
BEGIN
    SELECT ut.code, ut.description
    FROM securecorp.user_type ut;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_me` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_me`(
  IN p_user_id INT
)
BEGIN
  SELECT 
    u.id,
    u.username,
    ut.code AS user_type,
    u.created_at
  FROM `user` u
  JOIN user_type ut ON ut.id = u.user_type_id
  WHERE u.id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_users` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_users`()
BEGIN
  SELECT 
    u.id,
    u.username,
    ut.code AS user_type,
    ut.description AS user_type_desc,
    u.is_active,
    u.created_at
  FROM `user` u
  JOIN user_type ut ON ut.id = u.user_type_id
  ORDER BY u.created_at DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_jwt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_jwt`(
    IN p_user_id INT,
    IN p_jti VARCHAR(255),
    IN p_token_hash VARCHAR(255),
    IN p_expires_at DATETIME
)
BEGIN
    INSERT INTO jwt (user_id, jti, token_hash, expires_at)
    VALUES (p_user_id, p_jti, p_token_hash, p_expires_at);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `login_jwt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_jwt`(
    IN p_user_id INT,
    IN p_jti VARCHAR(255),
    IN p_token_hash VARCHAR(255),
    IN p_expires_at DATETIME
)
BEGIN
    INSERT INTO jwt (user_id, jti, token_hash, expires_at)
    VALUES (p_user_id, p_jti, p_token_hash, p_expires_at);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `logout_jwt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `logout_jwt`(
  IN p_jti CHAR(36),
  IN p_user_id INT
)
BEGIN
  UPDATE jwt
  SET revoked_at = CURRENT_TIMESTAMP
  WHERE jti = p_jti
    AND user_id = p_user_id
    AND revoked_at IS NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `refresh_jwt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `refresh_jwt`(
  IN p_jti CHAR(36)
)
BEGIN
  SELECT 
    t.user_id,
    t.token_hash,
    u.username,
    ut.code AS user_type_code
  FROM jwt t
  JOIN `user` u ON u.id = t.user_id
  JOIN user_type ut ON ut.id = u.user_type_id
  WHERE t.jti = p_jti
    AND t.revoked_at IS NULL
    AND t.expires_at > CURRENT_TIMESTAMP;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_jwt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_jwt`(
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),
    IN p_user_type_code VARCHAR(20)
)
BEGIN
    DECLARE v_user_type_id INT;

    -- recupera id del tipo utente
    SELECT id
    INTO v_user_type_id
    FROM user_type
    WHERE code = p_user_type_code
    LIMIT 1;

    IF v_user_type_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo utente non valido';
    END IF;

    -- inserimento utente
    INSERT INTO `user` (username, password_hash, user_type_id, created_at)
    VALUES (p_username, p_password_hash, v_user_type_id, NOW());

    -- ritorna l'id creato
    SELECT LAST_INSERT_ID() AS user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_user`(
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),
    IN p_user_type_code VARCHAR(20)
)
BEGIN
    DECLARE v_user_type_id INT;

    -- recupera id del tipo utente
    SELECT id
    INTO v_user_type_id
    FROM user_type
    WHERE code = p_user_type_code
    LIMIT 1;

    IF v_user_type_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo utente non valido';
    END IF;

    -- inserimento utente
    INSERT INTO `user` (username, password_hash, user_type_id, created_at)
    VALUES (p_username, p_password_hash, v_user_type_id, NOW());

    -- ritorna l'id creato
    SELECT LAST_INSERT_ID() AS user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_count_activity_logs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_count_activity_logs`(
  IN p_filter_action VARCHAR(50),
  IN p_filter_user_id INT,
  IN p_filter_entity_type VARCHAR(30),
  IN p_date_from DATETIME,
  IN p_date_to DATETIME
)
BEGIN
  SELECT COUNT(*) AS total
  FROM activity_logs al
  WHERE 
    (p_filter_action IS NULL OR al.action = p_filter_action)
    AND (p_filter_user_id IS NULL OR al.user_id = p_filter_user_id)
    AND (p_filter_entity_type IS NULL OR al.entity_type = p_filter_entity_type)
    AND (p_date_from IS NULL OR al.created_at >= p_date_from)
    AND (p_date_to IS NULL OR al.created_at <= p_date_to);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_activity_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_activity_log`(
  IN p_user_id INT,
  IN p_action VARCHAR(50),
  IN p_entity_type VARCHAR(30),
  IN p_entity_id BIGINT,
  IN p_description TEXT,
  IN p_ip_address VARCHAR(45),
  IN p_metadata_json JSON
)
BEGIN
  INSERT INTO activity_logs (
    user_id,
    action,
    entity_type,
    entity_id,
    description,
    ip_address,
    metadata
  ) VALUES (
    p_user_id,
    p_action,
    p_entity_type,
    p_entity_id,
    p_description,
    p_ip_address,
    p_metadata_json
  );
  
  SELECT LAST_INSERT_ID() AS log_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_activity_logs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_activity_logs`(
  IN p_limit INT,
  IN p_offset INT,
  IN p_filter_action VARCHAR(50),
  IN p_filter_user_id INT,
  IN p_filter_entity_type VARCHAR(30),
  IN p_date_from DATETIME,
  IN p_date_to DATETIME
)
BEGIN
  SELECT 
    al.id,
    al.user_id,
    COALESCE(u.username, 'Sistema') AS username,
    al.action,
    al.entity_type,
    al.entity_id,
    al.description,
    al.ip_address,
    al.metadata,
    al.created_at
  FROM activity_logs al
  LEFT JOIN `user` u ON al.user_id = u.id
  WHERE 
    (p_filter_action IS NULL OR al.action = p_filter_action)
    AND (p_filter_user_id IS NULL OR al.user_id = p_filter_user_id)
    AND (p_filter_entity_type IS NULL OR al.entity_type = p_filter_entity_type)
    AND (p_date_from IS NULL OR al.created_at >= p_date_from)
    AND (p_date_to IS NULL OR al.created_at <= p_date_to)
  ORDER BY al.created_at DESC
  LIMIT p_limit OFFSET p_offset;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user`(
  IN p_user_id INT,
  IN p_username VARCHAR(50),
  IN p_user_type_id INT,
  IN p_is_active BOOLEAN
)
BEGIN
  UPDATE `user`
  SET
    username = COALESCE(p_username, username),
    user_type_id = COALESCE(p_user_type_id, user_type_id),
    is_active = COALESCE(p_is_active, is_active)
  WHERE id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_password`(
  IN p_user_id INT,
  IN p_password_hash VARCHAR(255)
)
BEGIN
  UPDATE `user`
  SET password_hash = p_password_hash
  WHERE id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `new_view`
--

/*!50001 DROP VIEW IF EXISTS `new_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `new_view` AS select `ut`.`code` AS `code`,`ut`.`description` AS `description` from `user_type` `ut` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-12  0:44:57
