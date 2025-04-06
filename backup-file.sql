-- MariaDB dump 10.19  Distrib 10.6.4-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: integrator
-- ------------------------------------------------------
-- Server version	10.6.4-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts_user`
--

DROP TABLE IF EXISTS `accounts_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `email` varchar(254) NOT NULL,
  `inn` varchar(12) DEFAULT NULL,
  `organization` varchar(300) DEFAULT NULL,
  `address` varchar(300) DEFAULT NULL,
  `phone` varchar(18) DEFAULT NULL,
  `telegram` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `inn` (`inn`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_user`
--

LOCK TABLES `accounts_user` WRITE;
/*!40000 ALTER TABLE `accounts_user` DISABLE KEYS */;
INSERT INTO `accounts_user` VALUES (1,'pbkdf2_sha256$260000$vkYUJchhCwOYFHf4Rrx0ms$spb6iXt51S9J16tJVKJR24lF5MDBnCqQLCc+HrcMlZQ=','2022-10-18 10:17:24.515261',1,'','',1,1,'2022-09-26 09:56:50.000000','admin@test.ru',NULL,NULL,NULL,NULL,NULL),(2,'pbkdf2_sha256$260000$O0zBCirnUZOTDMEh46hPzR$4e9DHAMqtpNE5TMxWmeKbDhlxQdzg5Qfpx6bN3OXGr0=','2022-10-03 11:07:11.570133',0,'Тестовый пользователь','Заказчик',0,1,'2022-09-26 10:40:26.000000','someaddress@mail.com','123','Какая-то организация',NULL,'123456789',NULL),(3,'pbkdf2_sha256$260000$UTIL4P4DchVdyPEsePKWBU$jJ43HWZyab5VQtV4kqfPgE7RbU1J9qVncDCEO6VGchw=','2022-10-16 19:43:35.579379',0,'Дмитрий','Гуськов',1,1,'2022-09-26 10:41:25.000000','dg@ex-disk.ru','1111','testorg','address','89499111111','@gdmit'),(4,'pbkdf2_sha256$260000$5zSmJ71lZ16nFauAyIvXcx$nML/MmaEsiKgZy7cf/pP7GYdFZlItpP+SVtXJmGYvr8=',NULL,0,'Георгий','Нефедьев',0,1,'2022-09-26 10:42:21.000000','gn@ex-disk.ru','7750005482','АО «СМП Банк»','Российская Федерация, 115035, Москва, ул. Садовническая, дом  71, строение  11',NULL,NULL),(5,'pbkdf2_sha256$260000$uFRfpH5OMxFntrKVT41RWn$xpbZLkU8uFr15IaUFgQYDBG9qIWqCGgKWJMLbyyD4v0=','2022-10-17 10:44:46.795787',0,'','',1,1,'2022-09-26 10:44:25.000000','murzhinaei@fferisman.ru',NULL,NULL,NULL,NULL,NULL),(6,'pbkdf2_sha256$260000$GPpI5GoMXCIn4QRffsL6mI$ufsDpTd1DAl/4zNmeHUVR/4UXDvVn0ddWsX2L001LnY=','2022-10-17 11:08:42.125891',0,'Сергей','Жуков',0,1,'2022-09-26 10:45:16.000000','engineer@test.ru',NULL,NULL,NULL,NULL,NULL),(7,'pbkdf2_sha256$260000$EYEHWi1XE3DMfbPXW8IVOr$rtx+VypBysihyyFjCRc0XkyXf4KejWEZBsvUUg4c8qA=','2022-10-17 10:28:56.184455',0,'Виктор','Брагин',0,1,'2022-10-12 08:06:06.000000','admin_01_modulbank@test.ru','2204000595','АО КБ «Модульбанк»','156005, Костромская область, г. Кострома, пл. Октябрьская, д. 1','112',NULL),(8,'pbkdf2_sha256$260000$AI2GulCM6AthVihmVdHBjM$EzhPHe6jfUxxN3mf6Md4ZmxXU7JBdRlVh+HmtRJtmT4=','2022-10-16 18:50:48.732506',0,'Алексей','Сухоруков',1,1,'2022-10-16 18:44:37.000000','as@ex-disk.ru',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `accounts_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_user_groups`
--

DROP TABLE IF EXISTS `accounts_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_user_groups_user_id_group_id_59c0b32f_uniq` (`user_id`,`group_id`),
  KEY `accounts_user_groups_group_id_bd11a704_fk_auth_group_id` (`group_id`),
  CONSTRAINT `accounts_user_groups_group_id_bd11a704_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `accounts_user_groups_user_id_52b62117_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_user_groups`
--

LOCK TABLES `accounts_user_groups` WRITE;
/*!40000 ALTER TABLE `accounts_user_groups` DISABLE KEYS */;
INSERT INTO `accounts_user_groups` VALUES (1,1,1),(2,2,3),(9,3,2),(5,4,3),(6,5,1),(7,6,2),(8,7,3),(10,8,2);
/*!40000 ALTER TABLE `accounts_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_user_user_permissions`
--

DROP TABLE IF EXISTS `accounts_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_user_user_permi_user_id_permission_id_2ab516c2_uniq` (`user_id`,`permission_id`),
  KEY `accounts_user_user_p_permission_id_113bb443_fk_auth_perm` (`permission_id`),
  CONSTRAINT `accounts_user_user_p_permission_id_113bb443_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `accounts_user_user_p_user_id_e4f0a161_fk_accounts_` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_user_user_permissions`
--

LOCK TABLES `accounts_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `accounts_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_appcommentmodel`
--

DROP TABLE IF EXISTS `applications_appcommentmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_appcommentmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `text` longtext NOT NULL,
  `pubdate` datetime(6) NOT NULL,
  `application_id` bigint(20) NOT NULL,
  `author_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_appcomm_application_id_cf0073cb_fk_applicati` (`application_id`),
  KEY `applications_appcomm_author_id_866ef28b_fk_accounts_` (`author_id`),
  CONSTRAINT `applications_appcomm_application_id_cf0073cb_fk_applicati` FOREIGN KEY (`application_id`) REFERENCES `applications_applicationmodel` (`id`),
  CONSTRAINT `applications_appcomm_author_id_866ef28b_fk_accounts_` FOREIGN KEY (`author_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_appcommentmodel`
--

LOCK TABLES `applications_appcommentmodel` WRITE;
/*!40000 ALTER TABLE `applications_appcommentmodel` DISABLE KEYS */;
INSERT INTO `applications_appcommentmodel` VALUES (3,'test','2022-10-03 10:01:04.990218',4,6),(4,'test 2','2022-10-03 10:07:45.662524',4,1),(5,'Назначить на Горча!!','2022-10-16 18:38:39.069900',160402,1),(6,'Назначить на Коптянского','2022-10-16 18:39:39.793373',160402,1),(7,'Созвонился с заказчиком, запросил логи','2022-10-16 19:06:50.934566',160402,8),(8,'меняем кассету','2022-10-16 19:30:51.951196',160403,3),(9,'test 111','2022-10-17 11:05:51.520035',4,6),(10,'Test 222','2022-10-17 11:08:04.942054',4,6);
/*!40000 ALTER TABLE `applications_appcommentmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_appdocumentsmodel`
--

DROP TABLE IF EXISTS `applications_appdocumentsmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_appdocumentsmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `document` varchar(100) NOT NULL,
  `application_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_appdocu_application_id_d529fe6c_fk_applicati` (`application_id`),
  CONSTRAINT `applications_appdocu_application_id_d529fe6c_fk_applicati` FOREIGN KEY (`application_id`) REFERENCES `applications_applicationmodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_appdocumentsmodel`
--

LOCK TABLES `applications_appdocumentsmodel` WRITE;
/*!40000 ALTER TABLE `applications_appdocumentsmodel` DISABLE KEYS */;
INSERT INTO `applications_appdocumentsmodel` VALUES (2,'IP.xlsx','applications/160401/14102022151743.xlsx',160401),(3,'equipments.xlsx','applications/160403/16102022181618.xlsx',160403),(4,'equipments.xlsx','applications/160403/16102022181618_gyV5gwA.xlsx',160403),(5,'ECS (1).xlsx','applications/160404/16102022195552.xlsx',160404),(6,'equipments.xlsx','applications/160404/16102022195552_k3exWDq.xlsx',160404);
/*!40000 ALTER TABLE `applications_appdocumentsmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_apphistorymodel`
--

DROP TABLE IF EXISTS `applications_apphistorymodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_apphistorymodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `text` varchar(300) NOT NULL,
  `pubdate` datetime(6) NOT NULL,
  `number` int(11) DEFAULT NULL,
  `application_id` bigint(20) DEFAULT NULL,
  `author_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_apphist_application_id_90e824d9_fk_applicati` (`application_id`),
  KEY `applications_apphist_author_id_46a26006_fk_accounts_` (`author_id`),
  CONSTRAINT `applications_apphist_application_id_90e824d9_fk_applicati` FOREIGN KEY (`application_id`) REFERENCES `applications_applicationmodel` (`id`),
  CONSTRAINT `applications_apphist_author_id_46a26006_fk_accounts_` FOREIGN KEY (`author_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_apphistorymodel`
--

LOCK TABLES `applications_apphistorymodel` WRITE;
/*!40000 ALTER TABLE `applications_apphistorymodel` DISABLE KEYS */;
INSERT INTO `applications_apphistorymodel` VALUES (1,1,'Заявка создана, присвоен статус \"Обработка\"','2022-09-27 11:26:27.617578',NULL,NULL,1),(2,3,'Отправлено сообщение о создании заявки на адрес электронной почты someaddress@mail.com','2022-09-27 11:26:28.015544',NULL,NULL,1),(3,4,'Отправлено сообщение о создании заявки в телеграм-канал','2022-09-27 11:26:28.328455',NULL,NULL,1),(4,1,'Статус заявки изменен на \"В работе\"','2022-09-27 11:27:05.306086',NULL,NULL,1),(5,3,'Отправлено сообщение об изменении статуса заявки на \"В работе\" на адрес электронной почты someaddress@mail.com','2022-09-27 11:27:05.734346',NULL,NULL,1),(6,4,'Отправлено сообщение об изменении статуса заявки на \"В работе\" в телеграм-канал','2022-09-27 11:27:06.084911',NULL,NULL,1),(7,2,'Назначен инженер \"engineer@test.ru\"','2022-09-27 11:27:06.090083',NULL,NULL,1),(8,4,'Отправлено сообщение о назначении инженера \"engineer@test.ru\" в телеграм-канал','2022-09-27 11:27:06.228771',NULL,NULL,1),(9,4,'Отправлено сообщение о добавлении комментария в телеграм-канал','2022-09-27 11:47:20.236668',NULL,NULL,6),(10,4,'Отправлено сообщение о добавлении комментария в телеграм-канал','2022-09-27 11:47:56.616828',NULL,NULL,6),(11,1,'Статус заявки изменен на \"Согласование исполнения\"','2022-09-27 11:48:03.727463',NULL,NULL,6),(12,3,'Отправлено сообщение об изменении статуса заявки на \"Согласование исполнения\" на адрес электронной почты someaddress@mail.com','2022-09-27 11:48:04.145578',NULL,NULL,6),(13,4,'Отправлено сообщение об изменении статуса заявки на \"Согласование исполнения\" в телеграм-канал','2022-09-27 11:48:04.488150',NULL,NULL,6),(14,1,'Статус заявки изменен на \"Закрыта\"','2022-09-27 11:48:40.359607',NULL,NULL,2),(15,3,'Отправлено сообщение об изменении статуса заявки на \"Закрыта\" на адрес электронной почты someaddress@mail.com','2022-09-27 11:48:41.341241',NULL,NULL,2),(16,4,'Отправлено сообщение об изменении статуса заявки на \"Закрыта\" в телеграм-канал','2022-09-27 11:48:41.642860',NULL,NULL,2),(17,1,'Заявка создана, присвоен статус \"Обработка\"','2022-09-27 12:25:08.527366',NULL,NULL,2),(18,3,'Отправлено сообщение о создании заявки на адрес электронной почты someaddress@mail.com','2022-09-27 12:25:08.844397',NULL,NULL,2),(19,4,'Отправлено сообщение о создании заявки в телеграм-канал','2022-09-27 12:25:09.207811',NULL,NULL,2),(20,1,'Заявка создана, присвоен статус \"Обработка\"','2022-09-28 08:50:22.671009',NULL,3,6),(21,3,'Отправлено сообщение о создании заявки на адрес электронной почты someaddress@mail.com','2022-09-28 08:50:23.114274',NULL,3,6),(22,4,'Отправлено сообщение о создании заявки в телеграм-канал','2022-09-28 08:50:23.472724',NULL,3,6),(23,1,'Статус заявки изменен на \"Согласование исполнения\"','2022-09-28 11:12:17.830599',NULL,NULL,1),(24,3,'Отправлено сообщение об изменении статуса заявки на \"Согласование исполнения\" на адрес электронной почты someaddress@mail.com','2022-09-28 11:12:18.168669',NULL,NULL,1),(25,4,'Отправлено сообщение об изменении статуса заявки на \"Согласование исполнения\" в телеграм-канал','2022-09-28 11:12:18.556368',NULL,NULL,1),(26,1,'Статус заявки изменен на \"Закрыта\". Закрыто автоматически','2022-09-30 09:50:54.204692',NULL,NULL,1),(27,3,'Отправлено сообщение об изменении статуса заявки на \"Закрыта\" на адрес электронной почты someaddress@mail.com','2022-09-30 09:50:55.336905',NULL,NULL,1),(28,4,'Отправлено сообщение об изменении статуса заявки на \"Закрыта\" в телеграм-канал','2022-09-30 09:50:55.669708',NULL,NULL,1),(29,1,'Заявка создана, присвоен статус \"Обработка\"','2022-10-03 06:54:11.410339',NULL,4,6),(30,3,'Отправлено сообщение о создании заявки на адрес электронной почты someaddress@mail.com','2022-10-03 06:54:11.868294',NULL,4,6),(31,4,'Отправлено сообщение о создании заявки в телеграм-канал','2022-10-03 06:54:12.228498',NULL,4,6),(32,5,'Списание запчасти \"Cartridge Hewlett-Packard CF244A (3 шт.)\"','2022-10-03 10:01:04.604813',NULL,4,6),(33,4,'Отправлено сообщение о списании запчасти в телеграм-канал','2022-10-03 10:01:04.985704',NULL,4,6),(34,4,'Отправлено сообщение о добавлении комментария в телеграм-канал','2022-10-03 10:01:05.137075',NULL,4,6),(35,4,'Отправлено сообщение о добавлении комментария в телеграм-канал','2022-10-03 10:07:45.968311',NULL,4,1),(36,1,'Заявка создана, присвоен статус \"Обработка\"','2022-10-14 15:17:43.313204',NULL,160401,7),(37,3,'Отправлено сообщение о создании заявки на адрес электронной почты admin_01_modulbank@test.ru','2022-10-14 15:17:44.122680',NULL,160401,7),(38,4,'Отправлено сообщение о создании заявки в телеграм-канал','2022-10-14 15:17:44.514730',NULL,160401,7),(39,1,'Статус заявки изменен на \"В работе\"','2022-10-14 15:23:44.857456',NULL,160401,1),(40,3,'Отправлено сообщение об изменении статуса заявки на \"В работе\" на адрес электронной почты admin_01_modulbank@test.ru','2022-10-14 15:23:45.411333',NULL,160401,1),(41,4,'Отправлено сообщение об изменении статуса заявки на \"В работе\" в телеграм-канал','2022-10-14 15:23:45.765418',NULL,160401,1),(42,2,'Изменен приоритет заявки на \"Критический\"','2022-10-14 15:23:45.770782',NULL,160401,1),(43,4,'Отправлено сообщение об изменении приоритета заявки на \"Критический\" в телеграм-канал','2022-10-14 15:23:45.915475',NULL,160401,1),(44,2,'Назначен инженер \"Test test test\"','2022-10-14 15:23:45.918473',NULL,160401,1),(45,4,'Отправлено сообщение о назначении инженера \"Test test test\" в телеграм-канал','2022-10-14 15:23:46.080799',NULL,160401,1),(46,2,'Назначен инженер \"Сергей Жуков\"','2022-10-14 15:25:00.337361',NULL,160401,1),(47,4,'Отправлено сообщение о назначении инженера \"Сергей Жуков\" в телеграм-канал','2022-10-14 15:25:00.717503',NULL,160401,1),(48,2,'Назначен инженер \"Test test test\"','2022-10-14 15:27:17.885456',NULL,160401,1),(49,4,'Отправлено сообщение о назначении инженера \"Test test test\" в телеграм-канал','2022-10-14 15:27:18.276405',NULL,160401,1),(50,1,'Статус заявки изменен на \"Согласование исполнения\"','2022-10-14 15:32:06.900102',NULL,160401,3),(51,3,'Отправлено сообщение об изменении статуса заявки на \"Согласование исполнения\" на адрес электронной почты admin_01_modulbank@test.ru','2022-10-14 15:32:07.266768',NULL,160401,3),(52,4,'Отправлено сообщение об изменении статуса заявки на \"Согласование исполнения\" в телеграм-канал','2022-10-14 15:32:07.639790',NULL,160401,3),(53,2,'Назначен инженер \"Сергей Жуков\"','2022-10-14 15:40:27.053396',NULL,160401,1),(54,4,'Отправлено сообщение о назначении инженера \"Сергей Жуков\" в телеграм-канал','2022-10-14 15:40:27.360707',NULL,160401,1),(55,2,'Назначен инженер \"Дмитрий Гуськов\"','2022-10-14 15:40:35.062348',NULL,160401,1),(56,4,'Отправлено сообщение о назначении инженера \"Дмитрий Гуськов\" в телеграм-канал','2022-10-14 15:40:35.360009',NULL,160401,1),(57,1,'Статус заявки изменен на \"Закрыта\"','2022-10-14 15:43:36.745768',NULL,160401,7),(58,3,'Отправлено сообщение об изменении статуса заявки на \"Закрыта\" на адрес электронной почты admin_01_modulbank@test.ru','2022-10-14 15:43:37.223463',NULL,160401,7),(59,4,'Отправлено сообщение об изменении статуса заявки на \"Закрыта\" в телеграм-канал','2022-10-14 15:43:37.644112',NULL,160401,7),(60,1,'Заявка создана, присвоен статус \"Обработка\"','2022-10-16 17:58:14.423038',NULL,160402,7),(61,3,'Отправлено сообщение о создании заявки на адрес электронной почты admin_01_modulbank@test.ru','2022-10-16 17:58:14.887460',NULL,160402,7),(62,4,'Отправлено сообщение о создании заявки в телеграм-канал','2022-10-16 17:58:15.276644',NULL,160402,7),(63,1,'Заявка создана, присвоен статус \"Обработка\"','2022-10-16 18:16:18.812952',NULL,160403,7),(64,3,'Отправлено сообщение о создании заявки на адрес электронной почты admin_01_modulbank@test.ru','2022-10-16 18:16:19.415664',NULL,160403,7),(65,4,'Отправлено сообщение о создании заявки в телеграм-канал','2022-10-16 18:16:19.765945',NULL,160403,7),(66,1,'Статус заявки изменен на \"В работе\"','2022-10-16 18:35:04.509740',NULL,160402,1),(67,3,'Отправлено сообщение об изменении статуса заявки на \"В работе\" на адрес электронной почты admin_01_modulbank@test.ru','2022-10-16 18:35:04.988454',NULL,160402,1),(68,4,'Отправлено сообщение об изменении статуса заявки на \"В работе\" в телеграм-канал','2022-10-16 18:35:05.323527',NULL,160402,1),(69,2,'Изменен приоритет заявки на \"Высокий\"','2022-10-16 18:35:05.328716',NULL,160402,1),(70,4,'Отправлено сообщение об изменении приоритета заявки на \"Высокий\" в телеграм-канал','2022-10-16 18:35:05.462907',NULL,160402,1),(71,2,'Назначен инженер \"Дмитрий Гуськов\"','2022-10-16 18:35:05.466182',NULL,160402,1),(72,4,'Отправлено сообщение о назначении инженера \"Дмитрий Гуськов\" в телеграм-канал','2022-10-16 18:35:05.603680',NULL,160402,1),(73,4,'Отправлено сообщение о добавлении комментария в телеграм-канал','2022-10-16 18:38:39.430156',NULL,160402,1),(74,4,'Отправлено сообщение о добавлении комментария в телеграм-канал','2022-10-16 18:39:40.148081',NULL,160402,1),(75,2,'Назначен инженер \"Алексей Сухоруков\"','2022-10-16 18:45:31.639833',NULL,160402,1),(76,4,'Отправлено сообщение о назначении инженера \"Алексей Сухоруков\" в телеграм-канал','2022-10-16 18:45:31.952826',NULL,160402,1),(77,2,'Назначен инженер \"Дмитрий Гуськов\"','2022-10-16 18:48:22.533838',NULL,160402,1),(78,4,'Отправлено сообщение о назначении инженера \"Дмитрий Гуськов\" в телеграм-канал','2022-10-16 18:48:22.886460',NULL,160402,1),(79,2,'Назначен инженер \"Алексей Сухоруков\"','2022-10-16 18:48:55.215690',NULL,160402,1),(80,4,'Отправлено сообщение о назначении инженера \"Алексей Сухоруков\" в телеграм-канал','2022-10-16 18:48:55.519010',NULL,160402,1),(81,5,'Списание запчасти \"HDD HPE Диск НРE 3PAR 200GB SLC SAS 2.5\"','2022-10-16 19:06:50.644440',NULL,160402,8),(82,4,'Отправлено сообщение о списании запчасти в телеграм-канал','2022-10-16 19:06:50.931304',NULL,160402,8),(83,4,'Отправлено сообщение о добавлении комментария в телеграм-канал','2022-10-16 19:06:51.126143',NULL,160402,8),(84,1,'Статус заявки изменен на \"Согласование исполнения\"','2022-10-16 19:13:11.297826',NULL,160402,8),(85,3,'Отправлено сообщение об изменении статуса заявки на \"Согласование исполнения\" на адрес электронной почты admin_01_modulbank@test.ru','2022-10-16 19:13:11.603657',NULL,160402,8),(86,4,'Отправлено сообщение об изменении статуса заявки на \"Согласование исполнения\" в телеграм-канал','2022-10-16 19:13:11.957652',NULL,160402,8),(87,1,'Статус заявки изменен на \"Закрыта\"','2022-10-16 19:17:01.950633',NULL,160402,7),(88,3,'Отправлено сообщение об изменении статуса заявки на \"Закрыта\" на адрес электронной почты admin_01_modulbank@test.ru','2022-10-16 19:17:02.358644',NULL,160402,7),(89,1,'Статус заявки изменен на \"Закрыта\"','2022-10-16 19:17:02.545242',NULL,160402,7),(90,4,'Отправлено сообщение об изменении статуса заявки на \"Закрыта\" в телеграм-канал','2022-10-16 19:17:02.720941',NULL,160402,7),(91,3,'Отправлено сообщение об изменении статуса заявки на \"Закрыта\" на адрес электронной почты admin_01_modulbank@test.ru','2022-10-16 19:17:03.008548',NULL,160402,7),(92,4,'Отправлено сообщение об изменении статуса заявки на \"Закрыта\" в телеграм-канал','2022-10-16 19:17:03.440735',NULL,160402,7),(93,1,'Статус заявки изменен на \"В работе\"','2022-10-16 19:27:32.739938',NULL,160403,1),(94,3,'Отправлено сообщение об изменении статуса заявки на \"В работе\" на адрес электронной почты admin_01_modulbank@test.ru','2022-10-16 19:27:33.250524',NULL,160403,1),(95,4,'Отправлено сообщение об изменении статуса заявки на \"В работе\" в телеграм-канал','2022-10-16 19:27:33.627695',NULL,160403,1),(96,2,'Назначен инженер \"Дмитрий Гуськов\"','2022-10-16 19:27:33.633215',NULL,160403,1),(97,4,'Отправлено сообщение о назначении инженера \"Дмитрий Гуськов\" в телеграм-канал','2022-10-16 19:27:33.813888',NULL,160403,1),(98,5,'Списание запчасти \"Cartridge HPE Картридж ленточный LTO-4\"','2022-10-16 19:30:51.638279',NULL,160403,3),(99,4,'Отправлено сообщение о списании запчасти в телеграм-канал','2022-10-16 19:30:51.948029',NULL,160403,3),(100,4,'Отправлено сообщение о добавлении комментария в телеграм-канал','2022-10-16 19:30:52.075366',NULL,160403,3),(101,1,'Заявка создана, присвоен статус \"Обработка\"','2022-10-16 19:55:52.707552',NULL,160404,7),(102,3,'Отправлено сообщение о создании заявки на адрес электронной почты admin_01_modulbank@test.ru','2022-10-16 19:55:53.244134',NULL,160404,7),(103,4,'Отправлено сообщение о создании заявки в телеграм-канал','2022-10-16 19:55:53.591261',NULL,160404,7),(104,4,'Отправлено сообщение о добавлении комментария в телеграм-канал','2022-10-17 11:05:51.860393',NULL,4,6),(105,5,'Списание запчасти \"Cartridge Hewlett-Packard CF244A\"','2022-10-17 11:08:04.588687',NULL,4,6),(106,4,'Отправлено сообщение о списании запчасти в телеграм-канал','2022-10-17 11:08:04.938683',NULL,4,6),(107,4,'Отправлено сообщение о добавлении комментария в телеграм-канал','2022-10-17 11:08:05.133453',NULL,4,6),(108,1,'Заявка создана, присвоен статус \"Обработка\"','2022-10-18 10:31:24.953531',NULL,160405,1),(109,3,'Отправлено сообщение о создании заявки на адрес электронной почты someaddress@mail.com','2022-10-18 10:31:25.349040',NULL,160405,1),(110,4,'Отправлено сообщение о создании заявки в телеграм-канал','2022-10-18 10:31:25.764134',NULL,160405,1);
/*!40000 ALTER TABLE `applications_apphistorymodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_applicationarchivemodel`
--

DROP TABLE IF EXISTS `applications_applicationarchivemodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_applicationarchivemodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `problem` longtext NOT NULL,
  `fio` varchar(250) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(18) NOT NULL,
  `pubdate` datetime(6) NOT NULL,
  `old_id` int(11) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `engineer_id` bigint(20) DEFAULT NULL,
  `equipment_id` bigint(20) DEFAULT NULL,
  `priority_id` bigint(20) DEFAULT NULL,
  `status_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_applica_client_id_da0e5d59_fk_accounts_` (`client_id`),
  KEY `applications_applica_creator_id_cfe56758_fk_accounts_` (`creator_id`),
  KEY `applications_applica_engineer_id_e9ae68e9_fk_accounts_` (`engineer_id`),
  KEY `applications_applica_equipment_id_3d0a5a9a_fk_applicati` (`equipment_id`),
  KEY `applications_applica_priority_id_25694669_fk_applicati` (`priority_id`),
  KEY `applications_applica_status_id_0b61ca4b_fk_applicati` (`status_id`),
  CONSTRAINT `applications_applica_client_id_da0e5d59_fk_accounts_` FOREIGN KEY (`client_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `applications_applica_creator_id_cfe56758_fk_accounts_` FOREIGN KEY (`creator_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `applications_applica_engineer_id_e9ae68e9_fk_accounts_` FOREIGN KEY (`engineer_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `applications_applica_equipment_id_3d0a5a9a_fk_applicati` FOREIGN KEY (`equipment_id`) REFERENCES `applications_equipmentmodel` (`id`),
  CONSTRAINT `applications_applica_priority_id_25694669_fk_applicati` FOREIGN KEY (`priority_id`) REFERENCES `applications_appprioritymodel` (`id`),
  CONSTRAINT `applications_applica_status_id_0b61ca4b_fk_applicati` FOREIGN KEY (`status_id`) REFERENCES `applications_statusmodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_applicationarchivemodel`
--

LOCK TABLES `applications_applicationarchivemodel` WRITE;
/*!40000 ALTER TABLE `applications_applicationarchivemodel` DISABLE KEYS */;
INSERT INTO `applications_applicationarchivemodel` VALUES (1,'Test user','Заказчик Тестовый пользователь','someaddress@mail.com','123456789','2022-09-27 12:25:08.523942',2,2,2,NULL,4,2,4),(2,'Test admin','Заказчик Тестовый пользователь','someaddress@mail.com','123456789','2022-09-27 11:26:27.610103',1,2,1,6,3,2,4);
/*!40000 ALTER TABLE `applications_applicationarchivemodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_applicationmodel`
--

DROP TABLE IF EXISTS `applications_applicationmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_applicationmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `problem` longtext NOT NULL,
  `fio` varchar(250) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(18) NOT NULL,
  `pubdate` datetime(6) NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `engineer_id` bigint(20) DEFAULT NULL,
  `equipment_id` bigint(20) DEFAULT NULL,
  `priority_id` bigint(20) DEFAULT NULL,
  `status_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_applica_equipment_id_d6466002_fk_applicati` (`equipment_id`),
  KEY `applications_applica_priority_id_5a56be90_fk_applicati` (`priority_id`),
  KEY `applications_applica_status_id_c92c3472_fk_applicati` (`status_id`),
  KEY `applications_applica_client_id_f5c0d1c8_fk_accounts_` (`client_id`),
  KEY `applications_applica_creator_id_b64ec8fd_fk_accounts_` (`creator_id`),
  KEY `applications_applica_engineer_id_4de857f3_fk_accounts_` (`engineer_id`),
  CONSTRAINT `applications_applica_client_id_f5c0d1c8_fk_accounts_` FOREIGN KEY (`client_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `applications_applica_creator_id_b64ec8fd_fk_accounts_` FOREIGN KEY (`creator_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `applications_applica_engineer_id_4de857f3_fk_accounts_` FOREIGN KEY (`engineer_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `applications_applica_equipment_id_d6466002_fk_applicati` FOREIGN KEY (`equipment_id`) REFERENCES `applications_equipmentmodel` (`id`),
  CONSTRAINT `applications_applica_priority_id_5a56be90_fk_applicati` FOREIGN KEY (`priority_id`) REFERENCES `applications_appprioritymodel` (`id`),
  CONSTRAINT `applications_applica_status_id_c92c3472_fk_applicati` FOREIGN KEY (`status_id`) REFERENCES `applications_statusmodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=160406 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_applicationmodel`
--

LOCK TABLES `applications_applicationmodel` WRITE;
/*!40000 ALTER TABLE `applications_applicationmodel` DISABLE KEYS */;
INSERT INTO `applications_applicationmodel` VALUES (3,'Test engineer','Заказчик Тестовый пользователь','someaddress@mail.com','123456789','2022-09-28 08:50:22.664774',2,6,6,4,3,1),(4,'Test spares','Заказчик Тестовый пользователь','someaddress@mail.com','123456789','2022-10-03 06:54:11.403582',2,6,6,3,2,1),(160401,'сломался DIMM','Брагин Виктор','admin_01_modulbank@test.ru','112','2022-10-14 15:17:43.306833',7,7,3,NULL,4,4),(160402,'drive filed 3:0:0','Брагин Виктор','admin_01_modulbank@test.ru','112','2022-10-16 17:58:14.419498',7,7,8,NULL,1,4),(160403,'drive LTO-6 failed','Дежурный администратор','admin_01_modulbank@test.ru','112','2022-10-16 18:16:18.804520',7,7,3,15,2,2),(160404,'drive failed 3:0:0','Брагин Виктор','admin_01_modulbank@test.ru','112','2022-10-16 19:55:52.700122',7,7,NULL,NULL,2,1),(160405,'Тест сообщения','Заказчик Тестовый пользователь','someaddress@mail.com','123456789','2022-10-18 10:31:24.949300',2,1,NULL,3,3,1);
/*!40000 ALTER TABLE `applications_applicationmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_appprioritymodel`
--

DROP TABLE IF EXISTS `applications_appprioritymodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_appprioritymodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `priority` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_appprioritymodel`
--

LOCK TABLES `applications_appprioritymodel` WRITE;
/*!40000 ALTER TABLE `applications_appprioritymodel` DISABLE KEYS */;
INSERT INTO `applications_appprioritymodel` VALUES (1,'Высокий',1),(2,'Средний',2),(3,'Низкий',3),(4,'Критический',0);
/*!40000 ALTER TABLE `applications_appprioritymodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_appsparemodel`
--

DROP TABLE IF EXISTS `applications_appsparemodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_appsparemodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `pubdate` datetime(6) NOT NULL,
  `application_id` bigint(20) NOT NULL,
  `author_id` bigint(20) DEFAULT NULL,
  `spare_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_appspar_application_id_21f93fdf_fk_applicati` (`application_id`),
  KEY `applications_appspar_author_id_04e52da1_fk_accounts_` (`author_id`),
  KEY `applications_appspar_spare_id_10978cce_fk_applicati` (`spare_id`),
  CONSTRAINT `applications_appspar_application_id_21f93fdf_fk_applicati` FOREIGN KEY (`application_id`) REFERENCES `applications_applicationmodel` (`id`),
  CONSTRAINT `applications_appspar_author_id_04e52da1_fk_accounts_` FOREIGN KEY (`author_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `applications_appspar_spare_id_10978cce_fk_applicati` FOREIGN KEY (`spare_id`) REFERENCES `applications_sparemodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_appsparemodel`
--

LOCK TABLES `applications_appsparemodel` WRITE;
/*!40000 ALTER TABLE `applications_appsparemodel` DISABLE KEYS */;
INSERT INTO `applications_appsparemodel` VALUES (1,'2022-10-03 10:01:04.599857',4,6,1),(2,'2022-10-16 19:06:50.638479',160402,8,10),(3,'2022-10-16 19:30:51.633497',160403,3,15),(4,'2022-10-17 11:08:04.582782',4,6,1);
/*!40000 ALTER TABLE `applications_appsparemodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_appstatusmodel`
--

DROP TABLE IF EXISTS `applications_appstatusmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_appstatusmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `pubdate` datetime(6) NOT NULL,
  `application_id` bigint(20) DEFAULT NULL,
  `status_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_appstat_application_id_9e0e71fb_fk_applicati` (`application_id`),
  KEY `applications_appstat_status_id_16021db7_fk_applicati` (`status_id`),
  CONSTRAINT `applications_appstat_application_id_9e0e71fb_fk_applicati` FOREIGN KEY (`application_id`) REFERENCES `applications_applicationmodel` (`id`),
  CONSTRAINT `applications_appstat_status_id_16021db7_fk_applicati` FOREIGN KEY (`status_id`) REFERENCES `applications_statusmodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_appstatusmodel`
--

LOCK TABLES `applications_appstatusmodel` WRITE;
/*!40000 ALTER TABLE `applications_appstatusmodel` DISABLE KEYS */;
INSERT INTO `applications_appstatusmodel` VALUES (6,'2022-09-28 08:50:22.668541',3,1),(9,'2022-10-03 06:54:11.408282',4,1),(10,'2022-10-14 15:17:43.311602',160401,1),(11,'2022-10-14 15:23:45.768277',160401,2),(12,'2022-10-14 15:32:07.642596',160401,3),(13,'2022-10-14 15:43:36.739167',160401,4),(14,'2022-10-16 17:58:14.421792',160402,1),(15,'2022-10-16 18:16:18.811875',160403,1),(16,'2022-10-16 18:35:05.325787',160402,2),(17,'2022-10-16 19:13:11.960385',160402,3),(18,'2022-10-16 19:17:01.944238',160402,4),(19,'2022-10-16 19:17:02.539016',160402,4),(20,'2022-10-16 19:27:33.630529',160403,2),(21,'2022-10-16 19:55:52.706533',160404,1),(22,'2022-10-18 10:31:24.951997',160405,1);
/*!40000 ALTER TABLE `applications_appstatusmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_brandmodel`
--

DROP TABLE IF EXISTS `applications_brandmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_brandmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_brandmodel`
--

LOCK TABLES `applications_brandmodel` WRITE;
/*!40000 ALTER TABLE `applications_brandmodel` DISABLE KEYS */;
INSERT INTO `applications_brandmodel` VALUES (1,'Hewlett-Packard'),(2,'Canon'),(3,'HPE'),(4,'IBM'),(5,'Dell');
/*!40000 ALTER TABLE `applications_brandmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_contractdocumentmodel`
--

DROP TABLE IF EXISTS `applications_contractdocumentmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_contractdocumentmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `document` varchar(100) NOT NULL,
  `contract_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_contrac_contract_id_66c9d7e6_fk_applicati` (`contract_id`),
  CONSTRAINT `applications_contrac_contract_id_66c9d7e6_fk_applicati` FOREIGN KEY (`contract_id`) REFERENCES `applications_contractmodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_contractdocumentmodel`
--

LOCK TABLES `applications_contractdocumentmodel` WRITE;
/*!40000 ALTER TABLE `applications_contractdocumentmodel` DISABLE KEYS */;
INSERT INTO `applications_contractdocumentmodel` VALUES (1,'contracts/4/Dogovor_tehpodderzka__HP_Modul_bank_2021_soglas.doc',4);
/*!40000 ALTER TABLE `applications_contractdocumentmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_contracthistorymodel`
--

DROP TABLE IF EXISTS `applications_contracthistorymodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_contracthistorymodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `text` varchar(300) NOT NULL,
  `pubdate` datetime(6) NOT NULL,
  `author_id` bigint(20) NOT NULL,
  `contract_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_contrac_author_id_b1abb99c_fk_accounts_` (`author_id`),
  KEY `applications_contrac_contract_id_e1b3fe65_fk_applicati` (`contract_id`),
  CONSTRAINT `applications_contrac_author_id_b1abb99c_fk_accounts_` FOREIGN KEY (`author_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `applications_contrac_contract_id_e1b3fe65_fk_applicati` FOREIGN KEY (`contract_id`) REFERENCES `applications_contractmodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_contracthistorymodel`
--

LOCK TABLES `applications_contracthistorymodel` WRITE;
/*!40000 ALTER TABLE `applications_contracthistorymodel` DISABLE KEYS */;
INSERT INTO `applications_contracthistorymodel` VALUES (2,'Договор создан','2022-09-27 07:43:04.992082',1,3),(4,'Дата окончания действия договора измененена c 01.01.2023 на 01.03.2023','2022-09-27 07:48:13.559886',1,3),(5,'Договор создан','2022-10-12 08:59:15.369995',1,4);
/*!40000 ALTER TABLE `applications_contracthistorymodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_contractmodel`
--

DROP TABLE IF EXISTS `applications_contractmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_contractmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `number` varchar(50) NOT NULL,
  `signed` date NOT NULL,
  `enddate` date NOT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `executor_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_contrac_client_id_f5346679_fk_accounts_` (`client_id`),
  KEY `applications_contrac_executor_id_cc17d7c6_fk_applicati` (`executor_id`),
  CONSTRAINT `applications_contrac_client_id_f5346679_fk_accounts_` FOREIGN KEY (`client_id`) REFERENCES `accounts_user` (`id`),
  CONSTRAINT `applications_contrac_executor_id_cc17d7c6_fk_applicati` FOREIGN KEY (`executor_id`) REFERENCES `applications_executormodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_contractmodel`
--

LOCK TABLES `applications_contractmodel` WRITE;
/*!40000 ALTER TABLE `applications_contractmodel` DISABLE KEYS */;
INSERT INTO `applications_contractmodel` VALUES (3,'1/2022','2022-07-24','2023-03-01',2,NULL),(4,'ЕХ202106-У','2022-06-01','2023-05-31',7,NULL);
/*!40000 ALTER TABLE `applications_contractmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_equipmentconfigmodel`
--

DROP TABLE IF EXISTS `applications_equipmentconfigmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_equipmentconfigmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `document` varchar(100) NOT NULL,
  `equipment_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_equipme_equipment_id_2f63d20f_fk_applicati` (`equipment_id`),
  CONSTRAINT `applications_equipme_equipment_id_2f63d20f_fk_applicati` FOREIGN KEY (`equipment_id`) REFERENCES `applications_equipmentmodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_equipmentconfigmodel`
--

LOCK TABLES `applications_equipmentconfigmodel` WRITE;
/*!40000 ALTER TABLE `applications_equipmentconfigmodel` DISABLE KEYS */;
INSERT INTO `applications_equipmentconfigmodel` VALUES (1,'equipments/4/blank.pdf',4);
/*!40000 ALTER TABLE `applications_equipmentconfigmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_equipmentmodel`
--

DROP TABLE IF EXISTS `applications_equipmentmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_equipmentmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sn` varchar(50) NOT NULL,
  `warranty` date DEFAULT NULL,
  `brand_id` bigint(20) DEFAULT NULL,
  `model_id` bigint(20) DEFAULT NULL,
  `vendor_id` bigint(20) DEFAULT NULL,
  `contract_id` bigint(20) DEFAULT NULL,
  `support_id` bigint(20) DEFAULT NULL,
  `address` varchar(300) DEFAULT NULL,
  `account` varchar(100) DEFAULT NULL,
  `note` longtext DEFAULT NULL,
  `type_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sn` (`sn`),
  KEY `applications_equipme_brand_id_05f6e102_fk_applicati` (`brand_id`),
  KEY `applications_equipme_model_id_aefea4f3_fk_applicati` (`model_id`),
  KEY `applications_equipme_vendor_id_80221560_fk_applicati` (`vendor_id`),
  KEY `applications_equipme_contract_id_06f6af88_fk_applicati` (`contract_id`),
  KEY `applications_equipme_support_id_e13e98c4_fk_applicati` (`support_id`),
  KEY `applications_equipme_type_id_26068f60_fk_applicati` (`type_id`),
  CONSTRAINT `applications_equipme_brand_id_05f6e102_fk_applicati` FOREIGN KEY (`brand_id`) REFERENCES `applications_brandmodel` (`id`),
  CONSTRAINT `applications_equipme_contract_id_06f6af88_fk_applicati` FOREIGN KEY (`contract_id`) REFERENCES `applications_contractmodel` (`id`),
  CONSTRAINT `applications_equipme_model_id_aefea4f3_fk_applicati` FOREIGN KEY (`model_id`) REFERENCES `applications_modelmodel` (`id`),
  CONSTRAINT `applications_equipme_support_id_e13e98c4_fk_applicati` FOREIGN KEY (`support_id`) REFERENCES `applications_supportlevelmodel` (`id`),
  CONSTRAINT `applications_equipme_type_id_26068f60_fk_applicati` FOREIGN KEY (`type_id`) REFERENCES `applications_equipmenttypemodel` (`id`),
  CONSTRAINT `applications_equipme_vendor_id_80221560_fk_applicati` FOREIGN KEY (`vendor_id`) REFERENCES `applications_vendormodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_equipmentmodel`
--

LOCK TABLES `applications_equipmentmodel` WRITE;
/*!40000 ALTER TABLE `applications_equipmentmodel` DISABLE KEYS */;
INSERT INTO `applications_equipmentmodel` VALUES (3,'12345',NULL,1,1,NULL,3,2,NULL,NULL,NULL,NULL),(4,'54321',NULL,2,3,NULL,3,1,NULL,NULL,NULL,NULL),(5,'789456',NULL,1,6,NULL,3,NULL,NULL,NULL,'',NULL),(7,'CZ37212YXC','2023-05-31',3,8,NULL,4,3,'Москва',NULL,'',3),(8,'2S6550B478','2023-05-31',3,9,NULL,4,2,'Москва',NULL,'',3),(9,'2S6550B379','2023-05-31',3,9,NULL,4,2,'Москва',NULL,'',3),(10,'2S6441B048','2023-05-31',3,9,NULL,4,2,NULL,NULL,'',3),(11,'KLKJGZSN','2023-05-31',4,10,NULL,4,2,NULL,NULL,'',3),(12,'0101010101','2023-05-31',4,11,NULL,4,3,'Москва',NULL,'',4),(13,'KD85T4H','2023-05-31',4,12,NULL,4,3,'Новосибирск',NULL,'',4),(14,'KD63KP5','2023-05-31',4,13,NULL,4,3,'Кострома',NULL,'',4),(15,'DEC61002RP','2023-05-31',3,14,NULL,4,3,NULL,NULL,'',5),(16,'CZC002FSMT','2023-05-31',3,15,NULL,4,2,'Москва',NULL,'',6);
/*!40000 ALTER TABLE `applications_equipmentmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_equipmentstatusmodel`
--

DROP TABLE IF EXISTS `applications_equipmentstatusmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_equipmentstatusmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_equipmentstatusmodel`
--

LOCK TABLES `applications_equipmentstatusmodel` WRITE;
/*!40000 ALTER TABLE `applications_equipmentstatusmodel` DISABLE KEYS */;
INSERT INTO `applications_equipmentstatusmodel` VALUES (1,'Unused'),(2,'Used');
/*!40000 ALTER TABLE `applications_equipmentstatusmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_equipmenttypemodel`
--

DROP TABLE IF EXISTS `applications_equipmenttypemodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_equipmenttypemodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_equipmenttypemodel`
--

LOCK TABLES `applications_equipmenttypemodel` WRITE;
/*!40000 ALTER TABLE `applications_equipmenttypemodel` DISABLE KEYS */;
INSERT INTO `applications_equipmenttypemodel` VALUES (1,'Network adapter'),(2,'Drive'),(3,'СХД'),(4,'Server'),(5,'Tape Library'),(6,'FC switch');
/*!40000 ALTER TABLE `applications_equipmenttypemodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_executormodel`
--

DROP TABLE IF EXISTS `applications_executormodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_executormodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_executormodel`
--

LOCK TABLES `applications_executormodel` WRITE;
/*!40000 ALTER TABLE `applications_executormodel` DISABLE KEYS */;
/*!40000 ALTER TABLE `applications_executormodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_modelmodel`
--

DROP TABLE IF EXISTS `applications_modelmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_modelmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `brand_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_modelmo_brand_id_b94be289_fk_applicati` (`brand_id`),
  CONSTRAINT `applications_modelmo_brand_id_b94be289_fk_applicati` FOREIGN KEY (`brand_id`) REFERENCES `applications_brandmodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_modelmodel`
--

LOCK TABLES `applications_modelmodel` WRITE;
/*!40000 ALTER TABLE `applications_modelmodel` DISABLE KEYS */;
INSERT INTO `applications_modelmodel` VALUES (1,'LaserJet Pro M28a',1),(2,'3par 7200',1),(3,'i-SENSYS MF3010',2),(4,'LaserJet Pro M28w',1),(5,'LaserJet Pro M15a',1),(6,'LaserJet Pro M15w',1),(7,'3PAR 7400',3),(8,'3PAR 8200',3),(9,'MSA P2000',3),(10,'DS3524',4),(11,'3650 M3',4),(12,'System x3650 M3',4),(13,'System x3650 M3',4),(14,'MSL 2024 G3',3),(15,'B6000 48x16Gb FC switch',3);
/*!40000 ALTER TABLE `applications_modelmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_providermodel`
--

DROP TABLE IF EXISTS `applications_providermodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_providermodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_providermodel`
--

LOCK TABLES `applications_providermodel` WRITE;
/*!40000 ALTER TABLE `applications_providermodel` DISABLE KEYS */;
/*!40000 ALTER TABLE `applications_providermodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_sparecompatiblemodel`
--

DROP TABLE IF EXISTS `applications_sparecompatiblemodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_sparecompatiblemodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `equipment_id` bigint(20) NOT NULL,
  `spare_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_spareco_spare_id_9df582ea_fk_applicati` (`spare_id`),
  KEY `applications_spareco_equipment_id_29d4e446_fk_applicati` (`equipment_id`),
  CONSTRAINT `applications_spareco_equipment_id_29d4e446_fk_applicati` FOREIGN KEY (`equipment_id`) REFERENCES `applications_modelmodel` (`id`),
  CONSTRAINT `applications_spareco_spare_id_9df582ea_fk_applicati` FOREIGN KEY (`spare_id`) REFERENCES `applications_sparemodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_sparecompatiblemodel`
--

LOCK TABLES `applications_sparecompatiblemodel` WRITE;
/*!40000 ALTER TABLE `applications_sparecompatiblemodel` DISABLE KEYS */;
INSERT INTO `applications_sparecompatiblemodel` VALUES (2,5,1),(4,7,2),(6,7,3),(8,7,4),(9,10,5),(10,9,5),(11,8,5),(12,14,6),(13,13,6),(14,12,7),(15,13,7),(16,14,7),(17,10,8),(18,9,8),(19,8,8),(20,10,9),(21,9,9),(22,8,9),(24,7,10),(25,11,11),(26,11,12),(27,11,13),(29,7,14),(30,15,15),(31,6,1),(32,4,1);
/*!40000 ALTER TABLE `applications_sparecompatiblemodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_sparemodel`
--

DROP TABLE IF EXISTS `applications_sparemodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_sparemodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sn` varchar(50) DEFAULT NULL,
  `account` varchar(100) DEFAULT NULL,
  `contract` varchar(100) DEFAULT NULL,
  `place` varchar(50) DEFAULT NULL,
  `note` longtext DEFAULT NULL,
  `brand_id` bigint(20) DEFAULT NULL,
  `equipment_id` bigint(20) DEFAULT NULL,
  `model_id` bigint(20) DEFAULT NULL,
  `provider_id` bigint(20) DEFAULT NULL,
  `status_id` bigint(20) DEFAULT NULL,
  `stock_id` bigint(20) DEFAULT NULL,
  `type_id` bigint(20) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_sparemo_model_id_c20e0b75_fk_applicati` (`model_id`),
  KEY `applications_sparemo_provider_id_a8fce131_fk_applicati` (`provider_id`),
  KEY `applications_sparemo_status_id_f61d0f5b_fk_applicati` (`status_id`),
  KEY `applications_sparemo_stock_id_c8f1fac5_fk_applicati` (`stock_id`),
  KEY `applications_sparemo_type_id_00214fdf_fk_applicati` (`type_id`),
  KEY `applications_sparemo_brand_id_6485862e_fk_applicati` (`brand_id`),
  KEY `applications_sparemo_equipment_id_326721ae_fk_applicati` (`equipment_id`),
  CONSTRAINT `applications_sparemo_brand_id_6485862e_fk_applicati` FOREIGN KEY (`brand_id`) REFERENCES `applications_brandmodel` (`id`),
  CONSTRAINT `applications_sparemo_equipment_id_326721ae_fk_applicati` FOREIGN KEY (`equipment_id`) REFERENCES `applications_modelmodel` (`id`),
  CONSTRAINT `applications_sparemo_model_id_c20e0b75_fk_applicati` FOREIGN KEY (`model_id`) REFERENCES `applications_sparenamemodel` (`id`),
  CONSTRAINT `applications_sparemo_provider_id_a8fce131_fk_applicati` FOREIGN KEY (`provider_id`) REFERENCES `applications_providermodel` (`id`),
  CONSTRAINT `applications_sparemo_status_id_f61d0f5b_fk_applicati` FOREIGN KEY (`status_id`) REFERENCES `applications_equipmentstatusmodel` (`id`),
  CONSTRAINT `applications_sparemo_stock_id_c8f1fac5_fk_applicati` FOREIGN KEY (`stock_id`) REFERENCES `applications_stockmodel` (`id`),
  CONSTRAINT `applications_sparemo_type_id_00214fdf_fk_applicati` FOREIGN KEY (`type_id`) REFERENCES `applications_sparetypemodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_sparemodel`
--

LOCK TABLES `applications_sparemodel` WRITE;
/*!40000 ALTER TABLE `applications_sparemodel` DISABLE KEYS */;
INSERT INTO `applications_sparemodel` VALUES (1,'CF244-00901',NULL,NULL,NULL,'',1,1,1,NULL,1,NULL,2,0),(2,NULL,NULL,NULL,NULL,'',3,NULL,2,NULL,NULL,NULL,3,6),(3,NULL,NULL,NULL,NULL,'',3,NULL,3,NULL,NULL,NULL,3,8),(4,NULL,NULL,NULL,NULL,'',3,NULL,4,NULL,NULL,NULL,4,3),(5,NULL,NULL,NULL,NULL,'',3,10,5,NULL,NULL,NULL,3,10),(6,NULL,NULL,NULL,NULL,'',5,14,6,NULL,NULL,NULL,5,1),(7,NULL,NULL,NULL,NULL,'',4,12,7,NULL,NULL,NULL,6,12),(8,NULL,NULL,NULL,NULL,'',3,10,8,NULL,NULL,NULL,6,1),(9,NULL,NULL,NULL,NULL,'',3,NULL,9,NULL,NULL,NULL,7,7),(10,NULL,NULL,NULL,NULL,'',3,NULL,10,NULL,NULL,NULL,3,13),(11,NULL,NULL,NULL,NULL,'',4,11,11,NULL,NULL,NULL,3,20),(12,NULL,NULL,NULL,NULL,'',4,11,12,NULL,NULL,NULL,3,4),(13,NULL,NULL,NULL,NULL,'',4,11,13,NULL,NULL,NULL,3,6),(14,NULL,NULL,NULL,NULL,'',3,NULL,14,NULL,NULL,NULL,8,24),(15,NULL,NULL,NULL,NULL,'',3,15,15,NULL,NULL,NULL,2,99);
/*!40000 ALTER TABLE `applications_sparemodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_sparenamemodel`
--

DROP TABLE IF EXISTS `applications_sparenamemodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_sparenamemodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `brand_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_sparena_brand_id_cee7b661_fk_applicati` (`brand_id`),
  CONSTRAINT `applications_sparena_brand_id_cee7b661_fk_applicati` FOREIGN KEY (`brand_id`) REFERENCES `applications_brandmodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_sparenamemodel`
--

LOCK TABLES `applications_sparenamemodel` WRITE;
/*!40000 ALTER TABLE `applications_sparenamemodel` DISABLE KEYS */;
INSERT INTO `applications_sparenamemodel` VALUES (1,'CF244A',1),(2,'Жесткий диск HDD 4TB NL-SAS (SATA) 7200RPM',3),(3,'Жесткий диск HDD 8TB NL-SAS (SATA) 7200RPM',3),(4,'3PAR 7200 no-drives',3),(5,'Жесткий диск SSD 3,84TB',3),(6,'Dell 540-BBHB Broadcom 5719 Quad Port 1 Gb Network Interface Card',5),(7,'Аккумуляторная батарея ВВ Battery HR 9-6',4),(8,'Батарея HP EVA Battery module - 4.0 V, 13.5 Ahr',3),(9,'Ветилятор модуля ввода вывода HP I/O Fan Module',3),(10,'Диск НРE 3PAR 200GB SLC SAS 2.5',3),(11,'Жесткий диск SAS 10K 1200GB',4),(12,'Жесткий диск SAS 10K 600GB',4),(13,'Жесткий диск SAS 10K 900GB',4),(14,'Кабель HP LC',3),(15,'Картридж ленточный LTO-4',3),(16,'Комплект 2хНРЕ 480Gb 6G SSD',3);
/*!40000 ALTER TABLE `applications_sparenamemodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_sparepnmodel`
--

DROP TABLE IF EXISTS `applications_sparepnmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_sparepnmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `number` varchar(50) DEFAULT NULL,
  `spare_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applications_sparepn_spare_id_810fbab9_fk_applicati` (`spare_id`),
  CONSTRAINT `applications_sparepn_spare_id_810fbab9_fk_applicati` FOREIGN KEY (`spare_id`) REFERENCES `applications_sparemodel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_sparepnmodel`
--

LOCK TABLES `applications_sparepnmodel` WRITE;
/*!40000 ALTER TABLE `applications_sparepnmodel` DISABLE KEYS */;
INSERT INTO `applications_sparepnmodel` VALUES (1,'‎CF244A',1),(2,'12345',1);
/*!40000 ALTER TABLE `applications_sparepnmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_sparetypemodel`
--

DROP TABLE IF EXISTS `applications_sparetypemodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_sparetypemodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_sparetypemodel`
--

LOCK TABLES `applications_sparetypemodel` WRITE;
/*!40000 ALTER TABLE `applications_sparetypemodel` DISABLE KEYS */;
INSERT INTO `applications_sparetypemodel` VALUES (1,'Thermal film'),(2,'Cartridge'),(3,'HDD'),(4,'Контроллер СХД'),(5,'Network Interface Card'),(6,'Battery'),(7,'FAN'),(8,'Cable');
/*!40000 ALTER TABLE `applications_sparetypemodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_statusmodel`
--

DROP TABLE IF EXISTS `applications_statusmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_statusmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `priority` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_statusmodel`
--

LOCK TABLES `applications_statusmodel` WRITE;
/*!40000 ALTER TABLE `applications_statusmodel` DISABLE KEYS */;
INSERT INTO `applications_statusmodel` VALUES (1,'Обработка',0),(2,'В работе',1),(3,'Согласование исполнения',2),(4,'Закрыта',3),(5,'Отказ',4);
/*!40000 ALTER TABLE `applications_statusmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_stockmodel`
--

DROP TABLE IF EXISTS `applications_stockmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_stockmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_stockmodel`
--

LOCK TABLES `applications_stockmodel` WRITE;
/*!40000 ALTER TABLE `applications_stockmodel` DISABLE KEYS */;
INSERT INTO `applications_stockmodel` VALUES (2,'Офис БЦ Дербеневка'),(3,'АльфаСклад Лихоборы');
/*!40000 ALTER TABLE `applications_stockmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_supportlevelmodel`
--

DROP TABLE IF EXISTS `applications_supportlevelmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_supportlevelmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `priority` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_supportlevelmodel`
--

LOCK TABLES `applications_supportlevelmodel` WRITE;
/*!40000 ALTER TABLE `applications_supportlevelmodel` DISABLE KEYS */;
INSERT INTO `applications_supportlevelmodel` VALUES (1,'Какой-то уровень поддержки',0),(2,'24/7',0),(3,'9/5',0);
/*!40000 ALTER TABLE `applications_supportlevelmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications_vendormodel`
--

DROP TABLE IF EXISTS `applications_vendormodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applications_vendormodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications_vendormodel`
--

LOCK TABLES `applications_vendormodel` WRITE;
/*!40000 ALTER TABLE `applications_vendormodel` DISABLE KEYS */;
/*!40000 ALTER TABLE `applications_vendormodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (1,'Администратор'),(3,'Заказчик'),(2,'Инженер');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,1,7),(8,1,8),(9,1,9),(10,1,10),(11,1,11),(12,1,12),(13,1,13),(14,1,14),(15,1,15),(16,1,16),(17,1,21),(18,1,22),(19,1,23),(20,1,24),(21,1,25),(22,1,26),(23,1,27),(24,1,28),(25,1,29),(26,1,30),(27,1,31),(28,1,32),(29,1,33),(30,1,34),(31,1,35),(32,1,36),(33,1,37),(34,1,38),(35,1,39),(36,1,40),(37,1,41),(38,1,42),(39,1,43),(40,1,44),(41,1,45),(42,1,46),(43,1,47),(44,1,48),(45,1,49),(46,1,50),(47,1,51),(48,1,52),(49,1,53),(50,1,54),(51,1,55),(52,1,56),(53,1,57),(54,1,58),(55,1,59),(56,1,60),(57,1,61),(58,1,62),(59,1,63),(60,1,64),(61,1,65),(62,1,66),(63,1,67),(64,1,68),(65,1,69),(66,1,70),(67,1,71),(68,1,72),(69,1,77),(70,1,78),(71,1,79),(72,1,80),(78,2,21),(79,2,22),(81,2,24),(82,2,25),(83,2,26),(84,2,27),(85,2,28),(80,2,53),(86,2,54),(87,2,55),(77,2,56),(73,2,65),(74,2,66),(75,2,67),(76,2,68),(89,3,21),(90,3,22),(88,3,24);
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add Партнер',1,'add_partnermodel'),(2,'Can change Партнер',1,'change_partnermodel'),(3,'Can delete Партнер',1,'delete_partnermodel'),(4,'Can view Партнер',1,'view_partnermodel'),(5,'Can add Услуга',2,'add_servicemodel'),(6,'Can change Услуга',2,'change_servicemodel'),(7,'Can delete Услуга',2,'delete_servicemodel'),(8,'Can view Услуга',2,'view_servicemodel'),(9,'Can add Контакты',3,'add_contactmodel'),(10,'Can change Контакты',3,'change_contactmodel'),(11,'Can delete Контакты',3,'delete_contactmodel'),(12,'Can view Контакты',3,'view_contactmodel'),(13,'Can add Социальная сеть',4,'add_socialmodel'),(14,'Can change Социальная сеть',4,'change_socialmodel'),(15,'Can delete Социальная сеть',4,'delete_socialmodel'),(16,'Can view Социальная сеть',4,'view_socialmodel'),(17,'Can add Уровень поддержи',5,'add_supportlevelmodel'),(18,'Can change Уровень поддержи',5,'change_supportlevelmodel'),(19,'Can delete Уровень поддержи',5,'delete_supportlevelmodel'),(20,'Can view Уровень поддержи',5,'view_supportlevelmodel'),(21,'Can add Заявка',6,'add_applicationmodel'),(22,'Can change Заявка',6,'change_applicationmodel'),(23,'Can delete Заявка',6,'delete_applicationmodel'),(24,'Can view Заявка',6,'view_applicationmodel'),(25,'Can add Приоритет заявки',7,'add_appprioritymodel'),(26,'Can change Приоритет заявки',7,'change_appprioritymodel'),(27,'Can delete Приоритет заявки',7,'delete_appprioritymodel'),(28,'Can view Приоритет заявки',7,'view_appprioritymodel'),(29,'Can add Бренд оборудования',8,'add_brandmodel'),(30,'Can change Бренд оборудования',8,'change_brandmodel'),(31,'Can delete Бренд оборудования',8,'delete_brandmodel'),(32,'Can view Бренд оборудования',8,'view_brandmodel'),(33,'Can add Статус заявки',9,'add_statusmodel'),(34,'Can change Статус заявки',9,'change_statusmodel'),(35,'Can delete Статус заявки',9,'delete_statusmodel'),(36,'Can view Статус заявки',9,'view_statusmodel'),(37,'Can add Вендор',10,'add_vendormodel'),(38,'Can change Вендор',10,'change_vendormodel'),(39,'Can delete Вендор',10,'delete_vendormodel'),(40,'Can view Вендор',10,'view_vendormodel'),(41,'Can add Модель оборудования',11,'add_modelmodel'),(42,'Can change Модель оборудования',11,'change_modelmodel'),(43,'Can delete Модель оборудования',11,'delete_modelmodel'),(44,'Can view Модель оборудования',11,'view_modelmodel'),(45,'Can add Оборудование',12,'add_equipmentmodel'),(46,'Can change Оборудование',12,'change_equipmentmodel'),(47,'Can delete Оборудование',12,'delete_equipmentmodel'),(48,'Can view Оборудование',12,'view_equipmentmodel'),(49,'Can add Договор',13,'add_contractmodel'),(50,'Can change Договор',13,'change_contractmodel'),(51,'Can delete Договор',13,'delete_contractmodel'),(52,'Can view Договор',13,'view_contractmodel'),(53,'Can add app status model',14,'add_appstatusmodel'),(54,'Can change app status model',14,'change_appstatusmodel'),(55,'Can delete app status model',14,'delete_appstatusmodel'),(56,'Can view app status model',14,'view_appstatusmodel'),(57,'Can add app history model',15,'add_apphistorymodel'),(58,'Can change app history model',15,'change_apphistorymodel'),(59,'Can delete app history model',15,'delete_apphistorymodel'),(60,'Can view app history model',15,'view_apphistorymodel'),(61,'Can add app documents model',16,'add_appdocumentsmodel'),(62,'Can change app documents model',16,'change_appdocumentsmodel'),(63,'Can delete app documents model',16,'delete_appdocumentsmodel'),(64,'Can view app documents model',16,'view_appdocumentsmodel'),(65,'Can add app comment model',17,'add_appcommentmodel'),(66,'Can change app comment model',17,'change_appcommentmodel'),(67,'Can delete app comment model',17,'delete_appcommentmodel'),(68,'Can view app comment model',17,'view_appcommentmodel'),(69,'Can add user',18,'add_user'),(70,'Can change user',18,'change_user'),(71,'Can delete user',18,'delete_user'),(72,'Can view user',18,'view_user'),(73,'Can add log entry',19,'add_logentry'),(74,'Can change log entry',19,'change_logentry'),(75,'Can delete log entry',19,'delete_logentry'),(76,'Can view log entry',19,'view_logentry'),(77,'Can add permission',20,'add_permission'),(78,'Can change permission',20,'change_permission'),(79,'Can delete permission',20,'delete_permission'),(80,'Can view permission',20,'view_permission'),(81,'Can add group',21,'add_group'),(82,'Can change group',21,'change_group'),(83,'Can delete group',21,'delete_group'),(84,'Can view group',21,'view_group'),(85,'Can add content type',22,'add_contenttype'),(86,'Can change content type',22,'change_contenttype'),(87,'Can delete content type',22,'delete_contenttype'),(88,'Can view content type',22,'view_contenttype'),(89,'Can add session',23,'add_session'),(90,'Can change session',23,'change_session'),(91,'Can delete session',23,'delete_session'),(92,'Can view session',23,'view_session'),(93,'Can add kv store',24,'add_kvstore'),(94,'Can change kv store',24,'change_kvstore'),(95,'Can delete kv store',24,'delete_kvstore'),(96,'Can view kv store',24,'view_kvstore'),(97,'Can add contract history model',25,'add_contracthistorymodel'),(98,'Can change contract history model',25,'change_contracthistorymodel'),(99,'Can delete contract history model',25,'delete_contracthistorymodel'),(100,'Can view contract history model',25,'view_contracthistorymodel'),(101,'Can add Уровень поддержи',26,'add_supportlevelmodel'),(102,'Can change Уровень поддержи',26,'change_supportlevelmodel'),(103,'Can delete Уровень поддержи',26,'delete_supportlevelmodel'),(104,'Can view Уровень поддержи',26,'view_supportlevelmodel'),(105,'Can add Заявка',27,'add_applicationarchivemodel'),(106,'Can change Заявка',27,'change_applicationarchivemodel'),(107,'Can delete Заявка',27,'delete_applicationarchivemodel'),(108,'Can view Заявка',27,'view_applicationarchivemodel'),(109,'Can add Состояние оборудования',28,'add_equipmentstatusmodel'),(110,'Can change Состояние оборудования',28,'change_equipmentstatusmodel'),(111,'Can delete Состояние оборудования',28,'delete_equipmentstatusmodel'),(112,'Can view Состояние оборудования',28,'view_equipmentstatusmodel'),(113,'Can add Тип оборудования',29,'add_equipmenttypemodel'),(114,'Can change Тип оборудования',29,'change_equipmenttypemodel'),(115,'Can delete Тип оборудования',29,'delete_equipmenttypemodel'),(116,'Can view Тип оборудования',29,'view_equipmenttypemodel'),(117,'Can add Поставщик оборудования',30,'add_providermodel'),(118,'Can change Поставщик оборудования',30,'change_providermodel'),(119,'Can delete Поставщик оборудования',30,'delete_providermodel'),(120,'Can view Поставщик оборудования',30,'view_providermodel'),(121,'Can add Склад',31,'add_stockmodel'),(122,'Can change Склад',31,'change_stockmodel'),(123,'Can delete Склад',31,'delete_stockmodel'),(124,'Can view Склад',31,'view_stockmodel'),(125,'Can add Совместимое оборудование',32,'add_sparecompatiblemodel'),(126,'Can change Совместимое оборудование',32,'change_sparecompatiblemodel'),(127,'Can delete Совместимое оборудование',32,'delete_sparecompatiblemodel'),(128,'Can view Совместимое оборудование',32,'view_sparecompatiblemodel'),(129,'Can add ЗИП',33,'add_sparemodel'),(130,'Can change ЗИП',33,'change_sparemodel'),(131,'Can delete ЗИП',33,'delete_sparemodel'),(132,'Can view ЗИП',33,'view_sparemodel'),(133,'Can add Тип запчасти',34,'add_sparetypemodel'),(134,'Can change Тип запчасти',34,'change_sparetypemodel'),(135,'Can delete Тип запчасти',34,'delete_sparetypemodel'),(136,'Can view Тип запчасти',34,'view_sparetypemodel'),(137,'Can add Номер партии',35,'add_sparepnmodel'),(138,'Can change Номер партии',35,'change_sparepnmodel'),(139,'Can delete Номер партии',35,'delete_sparepnmodel'),(140,'Can view Номер партии',35,'view_sparepnmodel'),(141,'Can add Наименование запчасти',36,'add_sparenamemodel'),(142,'Can change Наименование запчасти',36,'change_sparenamemodel'),(143,'Can delete Наименование запчасти',36,'delete_sparenamemodel'),(144,'Can view Наименование запчасти',36,'view_sparenamemodel'),(145,'Can add app spare model',37,'add_appsparemodel'),(146,'Can change app spare model',37,'change_appsparemodel'),(147,'Can delete app spare model',37,'delete_appsparemodel'),(148,'Can view app spare model',37,'view_appsparemodel'),(149,'Can add Исполнитель',38,'add_executormodel'),(150,'Can change Исполнитель',38,'change_executormodel'),(151,'Can delete Исполнитель',38,'delete_executormodel'),(152,'Can view Исполнитель',38,'view_executormodel'),(153,'Can add Файл конфигурации',39,'add_equipmentconfigmodel'),(154,'Can change Файл конфигурации',39,'change_equipmentconfigmodel'),(155,'Can delete Файл конфигурации',39,'delete_equipmentconfigmodel'),(156,'Can view Файл конфигурации',39,'view_equipmentconfigmodel'),(157,'Can add Файл договора',40,'add_contractdocumentmodel'),(158,'Can change Файл договора',40,'change_contractdocumentmodel'),(159,'Can delete Файл договора',40,'delete_contractdocumentmodel'),(160,'Can view Файл договора',40,'view_contractdocumentmodel');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts_contactmodel`
--

DROP TABLE IF EXISTS `contacts_contactmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts_contactmodel` (
  `type` varchar(8) NOT NULL,
  `name` varchar(250) NOT NULL,
  `address` varchar(300) NOT NULL,
  `code` varchar(50) NOT NULL,
  `phone` varchar(18) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts_contactmodel`
--

LOCK TABLES `contacts_contactmodel` WRITE;
/*!40000 ALTER TABLE `contacts_contactmodel` DISABLE KEYS */;
INSERT INTO `contacts_contactmodel` VALUES ('contacts','ООО \"ИКСКЛАУД\"','115280, г. Москва, ул. Ленинская Слобода, д. 19, этаж','1/КОМ 41Х1Д/ОФ А6М','+7 (985) 226 0019');
/*!40000 ALTER TABLE `contacts_contactmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_accounts_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2022-09-26 10:00:06.364167','1','Администратор',1,'[{\"added\": {}}]',21,1),(2,'2022-09-26 10:01:46.528671','2','Инженер',1,'[{\"added\": {}}]',21,1),(3,'2022-09-26 10:02:13.250847','3','Заказчик',1,'[{\"added\": {}}]',21,1),(4,'2022-09-26 10:02:36.098717','1','admin@test.ru',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',18,1),(5,'2022-09-26 10:40:27.018758','2','Заказчик Тестовый пользователь',1,'[{\"added\": {}}]',18,1),(6,'2022-09-26 10:40:33.948199','2','Заказчик Тестовый пользователь',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',18,1),(7,'2022-09-26 10:41:25.797033','3','test test Test',1,'[{\"added\": {}}]',18,1),(8,'2022-09-26 10:41:33.662333','3','test test Test',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',18,1),(9,'2022-09-26 10:42:21.990813','4','Нефедьев Георгий',1,'[{\"added\": {}}]',18,1),(10,'2022-09-26 10:42:59.870100','4','Нефедьев Георгий',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',18,1),(11,'2022-09-26 10:43:13.110678','4','Нефедьев Георгий',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',18,1),(12,'2022-09-26 10:43:47.673686','4','Нефедьев Георгий',2,'[{\"changed\": {\"fields\": [\"Staff status\", \"Groups\"]}}]',18,1),(13,'2022-09-26 10:44:26.088709','5','murzhinaei@fferisman.ru',1,'[{\"added\": {}}]',18,1),(14,'2022-09-26 10:44:34.213409','5','murzhinaei@fferisman.ru',2,'[{\"changed\": {\"fields\": [\"Staff status\", \"Groups\"]}}]',18,1),(15,'2022-09-26 10:45:16.739506','6','engineer@test.ru',1,'[{\"added\": {}}]',18,1),(16,'2022-09-26 10:45:22.113928','6','engineer@test.ru',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',18,1),(17,'2022-09-26 10:58:43.723517','1','Hewlett-Packard',1,'[{\"added\": {}}]',8,1),(18,'2022-09-26 10:58:51.576966','2','Canon',1,'[{\"added\": {}}]',8,1),(19,'2022-09-26 10:59:17.188211','1','Hewlett-Packard LaserJet Pro M28a',1,'[{\"added\": {}}]',11,1),(20,'2022-09-26 10:59:34.310468','2','Hewlett-Packard 3par 7200',1,'[{\"added\": {}}]',11,1),(21,'2022-09-26 11:00:35.131748','1','Заказчик Тестовый пользователь №1/2022 от 24.07.2022',1,'[{\"added\": {}}]',13,1),(22,'2022-09-27 06:53:54.706344','1','Заказчик Тестовый пользователь №1/2022 от 24.07.2022',2,'[{\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Hewlett-Packard Hewlett-Packard LaserJet Pro M28a (S/n: 12345)\"}}]',13,1),(23,'2022-09-27 07:09:57.150900','1','Заказчик Тестовый пользователь №1/2022 от 24.07.2022',2,'[]',13,1),(24,'2022-09-27 07:11:36.535288','3','Canon i-SENSYS MF3010',1,'[{\"added\": {}}]',11,1),(25,'2022-09-27 07:11:47.651183','1','Заказчик Тестовый пользователь №1/2022 от 24.07.2022',2,'[{\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Canon Canon i-SENSYS MF3010 (S/n: 54321)\"}}]',13,1),(26,'2022-09-27 07:12:38.489671','1','Заказчик Тестовый пользователь №1/2022 от 24.07.2022',3,'',13,1),(27,'2022-09-27 07:43:04.996909','3','Заказчик Тестовый пользователь №1/2022 от 24.07.2022',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Hewlett-Packard Hewlett-Packard LaserJet Pro M28a (S/n: 12345)\"}}, {\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Canon Canon i-SENSYS MF3010 (S/n: 54321)\"}}]',13,1),(28,'2022-09-27 07:46:56.250038','3','Заказчик Тестовый пользователь №1/2022 от 24.07.2022',2,'[{\"changed\": {\"fields\": [\"\\u0414\\u0430\\u0442\\u0430 \\u043e\\u043a\\u043e\\u043d\\u0447\\u0430\\u043d\\u0438\\u044f \\u0434\\u043e\\u0433\\u043e\\u0432\\u043e\\u0440\\u0430\"]}}]',13,1),(29,'2022-09-27 07:48:13.561825','3','Заказчик Тестовый пользователь №1/2022 от 24.07.2022',2,'[{\"changed\": {\"fields\": [\"\\u0414\\u0430\\u0442\\u0430 \\u043e\\u043a\\u043e\\u043d\\u0447\\u0430\\u043d\\u0438\\u044f \\u0434\\u043e\\u0433\\u043e\\u0432\\u043e\\u0440\\u0430\"]}}]',13,1),(30,'2022-09-27 08:49:34.255671','1','Какой-то уровень поддержки',1,'[{\"added\": {}}]',26,1),(31,'2022-09-27 08:49:40.338580','2','24/7',1,'[{\"added\": {}}]',26,1),(32,'2022-09-27 08:49:54.842162','1','Обработка',1,'[{\"added\": {}}]',9,1),(33,'2022-09-27 08:50:06.745092','2','В работе',1,'[{\"added\": {}}]',9,1),(34,'2022-09-27 08:50:13.532053','3','Согласование исполнения',1,'[{\"added\": {}}]',9,1),(35,'2022-09-27 08:50:22.618196','4','Закрыта',1,'[{\"added\": {}}]',9,1),(36,'2022-09-27 08:50:29.534856','5','Отказ',1,'[{\"added\": {}}]',9,1),(37,'2022-09-27 08:51:13.582872','1','Высокий',1,'[{\"added\": {}}]',7,1),(38,'2022-09-27 08:51:20.568196','2','Средний',1,'[{\"added\": {}}]',7,1),(39,'2022-09-27 08:51:27.786529','3','Низкий',1,'[{\"added\": {}}]',7,1),(40,'2022-09-27 08:51:33.607457','4','Критический',1,'[{\"added\": {}}]',7,1),(41,'2022-09-27 08:53:46.716197','3','Заказчик Тестовый пользователь №1/2022 от 24.07.2022',2,'[{\"changed\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Canon Canon i-SENSYS MF3010 (S/n: 54321)\", \"fields\": [\"\\u0423\\u0440\\u043e\\u0432\\u0435\\u043d\\u044c \\u043f\\u043e\\u0434\\u0434\\u0435\\u0440\\u0436\\u043a\\u0438\"]}}, {\"changed\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Hewlett-Packard Hewlett-Packard LaserJet Pro M28a (S/n: 12345)\", \"fields\": [\"\\u0423\\u0440\\u043e\\u0432\\u0435\\u043d\\u044c \\u043f\\u043e\\u0434\\u0434\\u0435\\u0440\\u0436\\u043a\\u0438\"]}}]',13,1),(42,'2022-09-28 12:04:14.912741','1','Unused',1,'[{\"added\": {}}]',28,1),(43,'2022-09-28 12:04:25.468655','2','Used',1,'[{\"added\": {}}]',28,1),(44,'2022-09-28 12:04:48.359170','1','Network adapter',1,'[{\"added\": {}}]',29,1),(45,'2022-09-28 12:04:57.811665','2','Drive',1,'[{\"added\": {}}]',29,1),(46,'2022-09-29 12:31:09.942924','1','Network adapter',1,'[{\"added\": {}}]',34,1),(47,'2022-09-29 12:31:19.562844','2','Drive',1,'[{\"added\": {}}]',34,1),(48,'2022-09-29 12:31:56.810071','2','cartridge',2,'[{\"changed\": {\"fields\": [\"\\u041d\\u0430\\u0438\\u043c\\u0435\\u043d\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}]',34,1),(49,'2022-09-29 12:34:02.247915','1','Thermal film',2,'[{\"changed\": {\"fields\": [\"\\u041d\\u0430\\u0438\\u043c\\u0435\\u043d\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}]',34,1),(50,'2022-09-29 12:34:08.910432','2','Cartridge',2,'[{\"changed\": {\"fields\": [\"\\u041d\\u0430\\u0438\\u043c\\u0435\\u043d\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}]',34,1),(51,'2022-09-29 12:36:49.866193','1','Hewlett-Packard HP 44A (CF244A)',1,'[{\"added\": {}}]',36,1),(52,'2022-09-29 12:36:59.551513','1','Hewlett-Packard 44A (CF244A)',2,'[{\"changed\": {\"fields\": [\"\\u041d\\u0430\\u0438\\u043c\\u0435\\u043d\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}]',36,1),(53,'2022-09-29 12:37:22.525287','1','Hewlett-Packard CF244A',2,'[{\"changed\": {\"fields\": [\"\\u041d\\u0430\\u0438\\u043c\\u0435\\u043d\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}]',36,1),(54,'2022-09-29 12:43:46.130964','4','Hewlett-Packard LaserJet Pro M28w',1,'[{\"added\": {}}]',11,1),(55,'2022-09-29 12:44:14.545489','5','Hewlett-Packard HP LaserJet Pro M15a',1,'[{\"added\": {}}]',11,1),(56,'2022-09-29 12:44:31.509418','6','Hewlett-Packard HP LaserJet Pro M15w',1,'[{\"added\": {}}]',11,1),(57,'2022-09-29 12:44:43.930262','1','Hewlett-Packard CF244A (S/n: CF244-00901)',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u041d\\u043e\\u043c\\u0435\\u0440 \\u043f\\u0430\\u0440\\u0442\\u0438\\u0438\", \"object\": \"\\u200eCF244A\"}}]',33,1),(58,'2022-09-29 12:45:40.712985','5','Hewlett-Packard LaserJet Pro M15a',2,'[{\"changed\": {\"fields\": [\"\\u041d\\u0430\\u0438\\u043c\\u0435\\u043d\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}]',11,1),(59,'2022-09-29 12:45:48.000144','6','Hewlett-Packard LaserJet Pro M15w',2,'[{\"changed\": {\"fields\": [\"\\u041d\\u0430\\u0438\\u043c\\u0435\\u043d\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}]',11,1),(60,'2022-09-29 12:50:45.273269','3','Тестовый пользователь Заказчик №1/2022 от 24.07.2022',2,'[{\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Hewlett-Packard LaserJet Pro M15w (S/n: 789456)\"}}]',13,1),(61,'2022-09-29 12:52:57.051564','1','Hewlett-Packard CF244A (S/n: CF244-00901)',2,'[{\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Hewlett-Packard CF244A (S/n: CF244-00901)\"}}]',33,1),(62,'2022-10-03 12:04:47.004725','1','Cartridge Hewlett-Packard CF244A (2 шт.)',2,'[{\"changed\": {\"fields\": [\"\\u0421\\u043e\\u0441\\u0442\\u043e\\u044f\\u043d\\u0438\\u0435\"]}}]',33,1),(63,'2022-10-06 10:41:17.572706','1','Cartridge Hewlett-Packard CF244A (2 шт.)',2,'[{\"added\": {\"name\": \"\\u041f\\u0430\\u0440\\u0442\\u043d\\u043e\\u043c\\u0435\\u0440\", \"object\": \"12345\"}}]',33,1),(64,'2022-10-06 10:47:58.983376','1','Cartridge Hewlett-Packard CF244A (1 шт.)',2,'[{\"changed\": {\"fields\": [\"\\u041a\\u043e\\u043b\\u0438\\u0447\\u0435\\u0441\\u0442\\u0432\\u043e\"]}}]',33,1),(65,'2022-10-06 10:48:06.047272','1','Cartridge Hewlett-Packard CF244A (2 шт.)',2,'[{\"changed\": {\"fields\": [\"\\u041a\\u043e\\u043b\\u0438\\u0447\\u0435\\u0441\\u0442\\u0432\\u043e\"]}}]',33,1),(66,'2022-10-06 16:29:51.057397','1','Cartridge Hewlett-Packard CF244A',2,'[{\"changed\": {\"fields\": [\"\\u041a\\u043e\\u043b\\u0438\\u0447\\u0435\\u0441\\u0442\\u0432\\u043e\"]}}]',33,1),(67,'2022-10-12 08:06:06.351908','7','admin_01',1,'[{\"added\": {}}]',18,1),(68,'2022-10-12 08:52:19.965846','3','СХД',1,'[{\"added\": {}}]',29,1),(69,'2022-10-12 08:52:33.082932','3','HPE',1,'[{\"added\": {}}]',8,1),(70,'2022-10-12 08:52:49.258848','7','HPE 3PAR 7400',1,'[{\"added\": {}}]',11,1),(71,'2022-10-12 08:54:39.236736','1','ООО «ЭКС-ДИСК»',1,'[{\"added\": {}}]',31,1),(72,'2022-10-12 08:59:15.372955','4','admin_01 №ЕХ202106-У от 01.06.2022',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HPE 3PAR 7400 (S/n: CZ35398679)\"}}]',13,1),(73,'2022-10-12 10:03:09.234096','8','HPE 8200',1,'[{\"added\": {}}]',11,1),(74,'2022-10-12 10:04:55.868258','3','9/5',1,'[{\"added\": {}}]',26,1),(75,'2022-10-12 10:05:20.169825','4','admin_01 №ЕХ202106-У от 01.06.2022',2,'[{\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HPE 8200 (S/n: CZ37212YXC)\"}}]',13,1),(76,'2022-10-12 10:06:22.792700','7','admin_01',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',18,1),(77,'2022-10-12 10:13:35.143832','1','HPE',1,'[{\"added\": {}}]',10,1),(78,'2022-10-12 10:14:13.558893','1','HPE',3,'',10,1),(79,'2022-10-12 10:24:48.500413','4','admin_01 №ЕХ202106-У от 01.06.2022',2,'[]',13,1),(80,'2022-10-13 06:00:35.820693','7','Виктор Брагин',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\"]}}]',18,1),(81,'2022-10-13 06:01:31.387547','8','HPE 3PAR 8200',2,'[{\"changed\": {\"fields\": [\"\\u041d\\u0430\\u0438\\u043c\\u0435\\u043d\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}]',11,1),(82,'2022-10-13 06:02:14.485487','9','HPE MSA P2000',1,'[{\"added\": {}}]',11,1),(83,'2022-10-13 06:03:49.642968','4','Виктор Брагин №ЕХ202106-У от 01.06.2022',2,'[{\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HPE MSA P2000 (S/n: 2S6550B478)\"}}, {\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HPE MSA P2000 (S/n: 2S6550B379)\"}}, {\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HPE MSA P2000 (S/n: 2S6441B048)\"}}]',13,1),(84,'2022-10-13 06:04:24.302444','4','IBM',1,'[{\"added\": {}}]',8,1),(85,'2022-10-13 06:04:31.584798','10','IBM DS3524',1,'[{\"added\": {}}]',11,1),(86,'2022-10-13 06:05:10.684713','4','Server',1,'[{\"added\": {}}]',29,1),(87,'2022-10-13 06:05:35.997243','11','IBM 3650 M3',1,'[{\"added\": {}}]',11,1),(88,'2022-10-13 06:06:07.404964','4','Виктор Брагин №ЕХ202106-У от 01.06.2022',2,'[{\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"IBM DS3524 (S/n: KLKJGZSN)\"}}, {\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"IBM 3650 M3 (S/n: 0101010101)\"}}]',13,1),(89,'2022-10-13 06:06:44.194944','12','IBM System x3650 M3',1,'[{\"added\": {}}]',11,1),(90,'2022-10-13 06:07:10.695914','4','Виктор Брагин №ЕХ202106-У от 01.06.2022',2,'[{\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"IBM System x3650 M3 (S/n: KD85T4H)\"}}]',13,1),(91,'2022-10-13 06:07:42.007758','4','Виктор Брагин №ЕХ202106-У от 01.06.2022',2,'[]',13,1),(92,'2022-10-13 06:10:09.639028','4','Виктор Брагин №ЕХ202106-У от 01.06.2022',2,'[]',13,1),(93,'2022-10-13 06:11:03.050458','13','IBM System x3650 M3',1,'[{\"added\": {}}]',11,1),(94,'2022-10-13 06:11:32.373123','4','Виктор Брагин №ЕХ202106-У от 01.06.2022',2,'[{\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"IBM System x3650 M3 (S/n: KD63KP5)\"}}]',13,1),(95,'2022-10-13 06:13:55.016804','5','Tape Library',1,'[{\"added\": {}}]',29,1),(96,'2022-10-13 06:14:10.689533','14','HPE MSL 2024 G3',1,'[{\"added\": {}}]',11,1),(97,'2022-10-13 06:14:32.425090','4','Виктор Брагин №ЕХ202106-У от 01.06.2022',2,'[{\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HPE MSL 2024 G3 (S/n: DEC61002RP)\"}}]',13,1),(98,'2022-10-13 06:15:28.854117','6','FC switch',1,'[{\"added\": {}}]',29,1),(99,'2022-10-13 06:16:04.242915','15','HPE B6000 48x16Gb FC switch',1,'[{\"added\": {}}]',11,1),(100,'2022-10-13 06:16:31.014124','4','Виктор Брагин №ЕХ202106-У от 01.06.2022',2,'[{\"added\": {\"name\": \"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HPE B6000 48x16Gb FC switch (S/n: CZC002FSMT)\"}}]',13,1),(101,'2022-10-13 06:16:51.713916','4','Виктор Брагин №ЕХ202106-У от 01.06.2022',2,'[]',13,1),(102,'2022-10-13 11:09:19.759844','3','Тестовый пользователь Заказчик №1/2022 от 24.07.2022',2,'[{\"added\": {\"name\": \"\\u0424\\u0430\\u0439\\u043b \\u043a\\u043e\\u043d\\u0444\\u0438\\u0433\\u0443\\u0440\\u0430\\u0446\\u0438\\u0438\", \"object\": \"Canon i-SENSYS MF3010 (S/n: 54321)\"}}]',13,1),(103,'2022-10-14 15:04:49.462793','4',' №ЕХ202106-У от 01.06.2022 (АО КБ «Модульбанк»)',2,'[{\"added\": {\"name\": \"\\u0424\\u0430\\u0439\\u043b \\u0434\\u043e\\u0433\\u043e\\u0432\\u043e\\u0440\\u0430\", \"object\": \"contracts/4/Dogovor_tehpodderzka__HP_Modul_bank_2021_soglas.doc\"}}]',13,1),(104,'2022-10-14 15:12:50.564383','7','Виктор Брагин',2,'[{\"changed\": {\"fields\": [\"password\"]}}]',18,1),(105,'2022-10-14 15:15:38.640175','4',' №ЕХ202106-У от 01.06.2022 (АО КБ «Модульбанк»)',2,'[{\"added\": {\"name\": \"\\u0424\\u0430\\u0439\\u043b \\u043a\\u043e\\u043d\\u0444\\u0438\\u0433\\u0443\\u0440\\u0430\\u0446\\u0438\\u0438\", \"object\": \"HPE 3PAR 7400 (S/n: CZ35398679)\"}}]',13,1),(106,'2022-10-14 15:21:55.312711','3','Test test test',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',18,1),(107,'2022-10-14 15:22:23.159738','6','Сергей Жуков',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\"]}}]',18,1),(108,'2022-10-14 15:28:07.032249','3','Дмитрий Гуськов',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\"]}}]',18,1),(109,'2022-10-14 15:38:33.738052','3','Дмитрий Гуськов',2,'[{\"changed\": {\"fields\": [\"\\u0418\\u0434\\u0435\\u043d\\u0442\\u0438\\u0444\\u0438\\u043a\\u0430\\u0442\\u043e\\u0440 \\u0432 \\u0442\\u0435\\u043b\\u0435\\u0433\\u0440\\u0430\\u043c\\u0435\"]}}]',18,1),(110,'2022-10-14 15:38:57.426913','3','Дмитрий Гуськов',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',18,1),(111,'2022-10-16 04:07:58.031341','3','HDD',1,'[{\"added\": {}}]',34,1),(112,'2022-10-16 04:08:28.247549','2','HPE Жесткий диск HDD 4TB NL-SAS (SATA) 7200RPM',1,'[{\"added\": {}}]',36,1),(113,'2022-10-16 04:09:34.400899','2','HDD HPE Жесткий диск HDD 4TB NL-SAS (SATA) 7200RPM',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD HPE \\u0416\\u0435\\u0441\\u0442\\u043a\\u0438\\u0439 \\u0434\\u0438\\u0441\\u043a HDD 4TB NL-SAS (SATA) 7200RPM\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD HPE \\u0416\\u0435\\u0441\\u0442\\u043a\\u0438\\u0439 \\u0434\\u0438\\u0441\\u043a HDD 4TB NL-SAS (SATA) 7200RPM\"}}]',33,1),(114,'2022-10-16 04:09:46.583984','2','HDD HPE Жесткий диск HDD 4TB NL-SAS (SATA) 7200RPM',2,'[{\"changed\": {\"fields\": [\"\\u041a\\u043e\\u043b\\u0438\\u0447\\u0435\\u0441\\u0442\\u0432\\u043e\"]}}]',33,1),(115,'2022-10-16 04:10:10.292405','3','HPE Жесткий диск HDD 8TB NL-SAS (SATA) 7200RPM',1,'[{\"added\": {}}]',36,1),(116,'2022-10-16 04:10:36.458424','3','HDD HPE Жесткий диск HDD 8TB NL-SAS (SATA) 7200RPM',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD HPE \\u0416\\u0435\\u0441\\u0442\\u043a\\u0438\\u0439 \\u0434\\u0438\\u0441\\u043a HDD 8TB NL-SAS (SATA) 7200RPM\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD HPE \\u0416\\u0435\\u0441\\u0442\\u043a\\u0438\\u0439 \\u0434\\u0438\\u0441\\u043a HDD 8TB NL-SAS (SATA) 7200RPM\"}}]',33,1),(117,'2022-10-16 04:14:02.348024','4','Контроллер',1,'[{\"added\": {}}]',34,1),(118,'2022-10-16 04:14:15.517832','4','HPE Контроллер СХД 3PAR 7200 no-drives',1,'[{\"added\": {}}]',36,1),(119,'2022-10-16 04:14:49.360800','4','Контроллер HPE Контроллер СХД 3PAR 7200 no-drives',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"\\u041a\\u043e\\u043d\\u0442\\u0440\\u043e\\u043b\\u043b\\u0435\\u0440 HPE \\u041a\\u043e\\u043d\\u0442\\u0440\\u043e\\u043b\\u043b\\u0435\\u0440 \\u0421\\u0425\\u0414 3PAR 7200 no-drives\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"\\u041a\\u043e\\u043d\\u0442\\u0440\\u043e\\u043b\\u043b\\u0435\\u0440 HPE \\u041a\\u043e\\u043d\\u0442\\u0440\\u043e\\u043b\\u043b\\u0435\\u0440 \\u0421\\u0425\\u0414 3PAR 7200 no-drives\"}}]',33,1),(120,'2022-10-16 04:15:13.553552','5','HPE Жесткий диск SSD 3,84TB',1,'[{\"added\": {}}]',36,1),(121,'2022-10-16 04:15:47.680925','5','HDD HPE Жесткий диск SSD 3,84TB',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD HPE \\u0416\\u0435\\u0441\\u0442\\u043a\\u0438\\u0439 \\u0434\\u0438\\u0441\\u043a SSD 3,84TB\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD HPE \\u0416\\u0435\\u0441\\u0442\\u043a\\u0438\\u0439 \\u0434\\u0438\\u0441\\u043a SSD 3,84TB\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD HPE \\u0416\\u0435\\u0441\\u0442\\u043a\\u0438\\u0439 \\u0434\\u0438\\u0441\\u043a SSD 3,84TB\"}}]',33,1),(122,'2022-10-16 04:16:37.882674','5','Network Interface Card',1,'[{\"added\": {}}]',34,1),(123,'2022-10-16 04:16:44.462987','5','Dell',1,'[{\"added\": {}}]',8,1),(124,'2022-10-16 04:16:51.129180','6','Dell Dell 540-BBHB Broadcom 5719 Quad Port 1 Gb Network Interface Card',1,'[{\"added\": {}}]',36,1),(125,'2022-10-16 04:17:51.546991','6','Network Interface Card Dell Dell 540-BBHB Broadcom 5719 Quad Port 1 Gb Network Interface Card',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Network Interface Card Dell Dell 540-BBHB Broadcom 5719 Quad Port 1 Gb Network Interface Card\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Network Interface Card Dell Dell 540-BBHB Broadcom 5719 Quad Port 1 Gb Network Interface Card\"}}]',33,1),(126,'2022-10-16 04:18:17.709369','6','Battery',1,'[{\"added\": {}}]',34,1),(127,'2022-10-16 04:18:33.736776','7','IBM Аккумуляторная батарея ВВ Battery HR 9-6',1,'[{\"added\": {}}]',36,1),(128,'2022-10-16 04:19:07.372676','7','Battery IBM Аккумуляторная батарея ВВ Battery HR 9-6',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Battery IBM \\u0410\\u043a\\u043a\\u0443\\u043c\\u0443\\u043b\\u044f\\u0442\\u043e\\u0440\\u043d\\u0430\\u044f \\u0431\\u0430\\u0442\\u0430\\u0440\\u0435\\u044f \\u0412\\u0412 Battery HR 9-6\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Battery IBM \\u0410\\u043a\\u043a\\u0443\\u043c\\u0443\\u043b\\u044f\\u0442\\u043e\\u0440\\u043d\\u0430\\u044f \\u0431\\u0430\\u0442\\u0430\\u0440\\u0435\\u044f \\u0412\\u0412 Battery HR 9-6\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Battery IBM \\u0410\\u043a\\u043a\\u0443\\u043c\\u0443\\u043b\\u044f\\u0442\\u043e\\u0440\\u043d\\u0430\\u044f \\u0431\\u0430\\u0442\\u0430\\u0440\\u0435\\u044f \\u0412\\u0412 Battery HR 9-6\"}}]',33,1),(129,'2022-10-16 04:19:38.481302','8','HPE Батарея HP EVA Battery module - 4.0 V, 13.5 Ahr',1,'[{\"added\": {}}]',36,1),(130,'2022-10-16 04:20:05.410816','8','Battery HPE Батарея HP EVA Battery module - 4.0 V, 13.5 Ahr',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Battery HPE \\u0411\\u0430\\u0442\\u0430\\u0440\\u0435\\u044f HP EVA Battery module - 4.0 V, 13.5 Ahr\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Battery HPE \\u0411\\u0430\\u0442\\u0430\\u0440\\u0435\\u044f HP EVA Battery module - 4.0 V, 13.5 Ahr\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Battery HPE \\u0411\\u0430\\u0442\\u0430\\u0440\\u0435\\u044f HP EVA Battery module - 4.0 V, 13.5 Ahr\"}}]',33,1),(131,'2022-10-16 04:20:32.524406','7','FAN',1,'[{\"added\": {}}]',34,1),(132,'2022-10-16 04:20:41.453989','9','HPE Ветилятор модуля ввода вывода HP I/O Fan Module',1,'[{\"added\": {}}]',36,1),(133,'2022-10-16 04:21:10.591948','9','FAN HPE Ветилятор модуля ввода вывода HP I/O Fan Module',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"FAN HPE \\u0412\\u0435\\u0442\\u0438\\u043b\\u044f\\u0442\\u043e\\u0440 \\u043c\\u043e\\u0434\\u0443\\u043b\\u044f \\u0432\\u0432\\u043e\\u0434\\u0430 \\u0432\\u044b\\u0432\\u043e\\u0434\\u0430 HP I/O Fan Module\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"FAN HPE \\u0412\\u0435\\u0442\\u0438\\u043b\\u044f\\u0442\\u043e\\u0440 \\u043c\\u043e\\u0434\\u0443\\u043b\\u044f \\u0432\\u0432\\u043e\\u0434\\u0430 \\u0432\\u044b\\u0432\\u043e\\u0434\\u0430 HP I/O Fan Module\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"FAN HPE \\u0412\\u0435\\u0442\\u0438\\u043b\\u044f\\u0442\\u043e\\u0440 \\u043c\\u043e\\u0434\\u0443\\u043b\\u044f \\u0432\\u0432\\u043e\\u0434\\u0430 \\u0432\\u044b\\u0432\\u043e\\u0434\\u0430 HP I/O Fan Module\"}}]',33,1),(134,'2022-10-16 04:24:01.084535','10','HPE Диск НРE 3PAR 200GB SLC SAS 2.5',1,'[{\"added\": {}}]',36,1),(135,'2022-10-16 04:24:20.132973','10','HDD HPE Диск НРE 3PAR 200GB SLC SAS 2.5',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD HPE \\u0414\\u0438\\u0441\\u043a \\u041d\\u0420E 3PAR 200GB SLC SAS 2.5\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD HPE \\u0414\\u0438\\u0441\\u043a \\u041d\\u0420E 3PAR 200GB SLC SAS 2.5\"}}]',33,1),(136,'2022-10-16 04:28:08.360006','11','IBM Жесткий диск SAS 10K 1200GB',1,'[{\"added\": {}}]',36,1),(137,'2022-10-16 04:28:27.001744','11','HDD IBM Жесткий диск SAS 10K 1200GB',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD IBM \\u0416\\u0435\\u0441\\u0442\\u043a\\u0438\\u0439 \\u0434\\u0438\\u0441\\u043a SAS 10K 1200GB\"}}]',33,1),(138,'2022-10-16 04:28:49.018056','12','IBM Жесткий диск SAS 10K 600GB',1,'[{\"added\": {}}]',36,1),(139,'2022-10-16 04:29:05.208449','12','HDD IBM Жесткий диск SAS 10K 600GB',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD IBM \\u0416\\u0435\\u0441\\u0442\\u043a\\u0438\\u0439 \\u0434\\u0438\\u0441\\u043a SAS 10K 600GB\"}}]',33,1),(140,'2022-10-16 04:29:27.986994','13','IBM Жесткий диск SAS 10K 900GB',1,'[{\"added\": {}}]',36,1),(141,'2022-10-16 04:29:49.296275','13','HDD IBM Жесткий диск SAS 10K 900GB',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"HDD IBM \\u0416\\u0435\\u0441\\u0442\\u043a\\u0438\\u0439 \\u0434\\u0438\\u0441\\u043a SAS 10K 900GB\"}}]',33,1),(142,'2022-10-16 04:30:39.699243','8','Cable',1,'[{\"added\": {}}]',34,1),(143,'2022-10-16 04:30:47.103401','14','HPE Кабель HP LC',1,'[{\"added\": {}}]',36,1),(144,'2022-10-16 04:31:02.276628','14','Cable HPE Кабель HP LC',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Cable HPE \\u041a\\u0430\\u0431\\u0435\\u043b\\u044c HP LC\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Cable HPE \\u041a\\u0430\\u0431\\u0435\\u043b\\u044c HP LC\"}}]',33,1),(145,'2022-10-16 04:31:37.296558','15','HPE Картридж ленточный LTO-4',1,'[{\"added\": {}}]',36,1),(146,'2022-10-16 04:31:58.309301','15','Cartridge HPE Картридж ленточный LTO-4',1,'[{\"added\": {}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Cartridge HPE \\u041a\\u0430\\u0440\\u0442\\u0440\\u0438\\u0434\\u0436 \\u043b\\u0435\\u043d\\u0442\\u043e\\u0447\\u043d\\u044b\\u0439 LTO-4\"}}]',33,1),(147,'2022-10-16 04:32:34.045396','16','HPE Комплект 2хНРЕ 480Gb 6G SSD',1,'[{\"added\": {}}]',36,1),(148,'2022-10-16 18:44:37.990898','8','Алексей Сухоруков',1,'[{\"added\": {}}]',18,1),(149,'2022-10-16 18:45:21.416712','8','Алексей Сухоруков',2,'[{\"changed\": {\"fields\": [\"Staff status\", \"Groups\"]}}]',18,1),(150,'2022-10-16 19:24:20.370115','4','Контроллер СХД',2,'[{\"changed\": {\"fields\": [\"\\u041d\\u0430\\u0438\\u043c\\u0435\\u043d\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}]',34,1),(151,'2022-10-16 19:25:24.298212','4','HPE 3PAR 7200 no-drives',2,'[{\"changed\": {\"fields\": [\"\\u041d\\u0430\\u0438\\u043c\\u0435\\u043d\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}]',36,1),(152,'2022-10-17 09:16:02.666964','6','HPE 3PAR 7400 (S/n: CZ35398679)',3,'',12,1),(153,'2022-10-17 09:21:50.703785','2','Офис БЦ Дербеневка',1,'[{\"added\": {}}]',31,1),(154,'2022-10-17 09:22:05.834091','3','АльфаСклад Лихоборы',1,'[{\"added\": {}}]',31,1),(155,'2022-10-17 09:22:14.563489','1','ООО «ЭКС-ДИСК»',3,'',31,1),(156,'2022-10-17 10:58:02.660433','1','Cartridge Hewlett-Packard CF244A',2,'[{\"changed\": {\"fields\": [\"\\u041e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\"]}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Cartridge Hewlett-Packard CF244A\"}}, {\"added\": {\"name\": \"\\u0421\\u043e\\u0432\\u043c\\u0435\\u0441\\u0442\\u0438\\u043c\\u043e\\u0435 \\u043e\\u0431\\u043e\\u0440\\u0443\\u0434\\u043e\\u0432\\u0430\\u043d\\u0438\\u0435\", \"object\": \"Cartridge Hewlett-Packard CF244A\"}}]',33,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (18,'accounts','user'),(19,'admin','logentry'),(17,'applications','appcommentmodel'),(16,'applications','appdocumentsmodel'),(15,'applications','apphistorymodel'),(27,'applications','applicationarchivemodel'),(6,'applications','applicationmodel'),(7,'applications','appprioritymodel'),(37,'applications','appsparemodel'),(14,'applications','appstatusmodel'),(8,'applications','brandmodel'),(40,'applications','contractdocumentmodel'),(25,'applications','contracthistorymodel'),(13,'applications','contractmodel'),(39,'applications','equipmentconfigmodel'),(12,'applications','equipmentmodel'),(28,'applications','equipmentstatusmodel'),(29,'applications','equipmenttypemodel'),(38,'applications','executormodel'),(11,'applications','modelmodel'),(30,'applications','providermodel'),(32,'applications','sparecompatiblemodel'),(33,'applications','sparemodel'),(36,'applications','sparenamemodel'),(35,'applications','sparepnmodel'),(34,'applications','sparetypemodel'),(9,'applications','statusmodel'),(31,'applications','stockmodel'),(26,'applications','supportlevelmodel'),(10,'applications','vendormodel'),(21,'auth','group'),(20,'auth','permission'),(5,'clients','supportlevelmodel'),(3,'contacts','contactmodel'),(22,'contenttypes','contenttype'),(1,'partners','partnermodel'),(2,'services','servicemodel'),(23,'sessions','session'),(4,'socials','socialmodel'),(24,'thumbnail','kvstore');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2022-09-26 09:55:51.113729'),(2,'contenttypes','0002_remove_content_type_name','2022-09-26 09:55:51.142550'),(3,'auth','0001_initial','2022-09-26 09:55:51.343529'),(4,'auth','0002_alter_permission_name_max_length','2022-09-26 09:55:51.370763'),(5,'auth','0003_alter_user_email_max_length','2022-09-26 09:55:51.383064'),(6,'auth','0004_alter_user_username_opts','2022-09-26 09:55:51.390953'),(7,'auth','0005_alter_user_last_login_null','2022-09-26 09:55:51.396611'),(8,'auth','0006_require_contenttypes_0002','2022-09-26 09:55:51.398531'),(9,'auth','0007_alter_validators_add_error_messages','2022-09-26 09:55:51.408016'),(10,'auth','0008_alter_user_username_max_length','2022-09-26 09:55:51.414932'),(11,'auth','0009_alter_user_last_name_max_length','2022-09-26 09:55:51.420315'),(12,'auth','0010_alter_group_name_max_length','2022-09-26 09:55:51.434804'),(13,'auth','0011_update_proxy_permissions','2022-09-26 09:55:51.444086'),(14,'auth','0012_alter_user_first_name_max_length','2022-09-26 09:55:51.451455'),(15,'accounts','0001_initial','2022-09-26 09:55:51.593199'),(16,'admin','0001_initial','2022-09-26 09:55:51.697871'),(17,'admin','0002_logentry_remove_auto_add','2022-09-26 09:55:51.709368'),(18,'admin','0003_logentry_add_action_flag_choices','2022-09-26 09:55:51.718120'),(19,'applications','0001_initial','2022-09-26 09:55:52.372237'),(20,'clients','0001_initial','2022-09-26 09:55:52.388824'),(21,'contacts','0001_initial','2022-09-26 09:55:52.407313'),(22,'partners','0001_initial','2022-09-26 09:55:52.422979'),(23,'services','0001_initial','2022-09-26 09:55:52.438136'),(24,'sessions','0001_initial','2022-09-26 09:55:52.467052'),(25,'socials','0001_initial','2022-09-26 09:55:52.485950'),(26,'thumbnail','0001_initial','2022-09-26 09:55:52.531161'),(27,'applications','0002_contracthistorymodel','2022-09-26 10:47:06.438613'),(28,'applications','0003_auto_20220926_1048','2022-09-26 10:48:40.882779'),(29,'applications','0004_auto_20220927_0741','2022-09-27 07:42:04.205290'),(30,'applications','0005_supportlevelmodel','2022-09-27 08:46:57.264498'),(31,'clients','0002_delete_supportlevelmodel','2022-09-27 08:46:57.274081'),(32,'applications','0006_equipmentmodel_support','2022-09-27 08:53:26.766231'),(33,'applications','0007_equipmentmodel_address','2022-09-27 08:55:42.426079'),(34,'applications','0008_auto_20220928_1056','2022-09-28 10:57:14.130607'),(35,'applications','0009_alter_applicationarchivemodel_pubdate','2022-09-28 11:08:54.588196'),(36,'applications','0010_auto_20220928_1159','2022-09-28 11:59:21.981067'),(37,'applications','0011_auto_20220929_0720','2022-09-29 07:20:30.849837'),(38,'applications','0012_sparemodel_quantity','2022-09-29 10:44:37.583670'),(39,'applications','0013_alter_sparemodel_sn','2022-09-29 12:42:22.203453'),(40,'applications','0014_auto_20220930_0945','2022-09-30 09:45:31.893776'),(41,'applications','0015_auto_20221006_1028','2022-10-06 10:28:21.267585'),(42,'accounts','0002_user_telegram','2022-10-06 12:08:12.931059'),(43,'applications','0016_auto_20221006_1208','2022-10-06 12:08:13.009303'),(44,'applications','0017_alter_equipmentmodel_warranty','2022-10-12 10:18:14.986991'),(45,'applications','0018_alter_contractmodel_client','2022-10-12 10:40:09.131629'),(46,'applications','0019_auto_20221013_0732','2022-10-13 07:32:21.252840'),(47,'applications','0020_auto_20221013_0735','2022-10-13 07:35:06.724399'),(48,'applications','0021_equipmentconfigmodel','2022-10-13 07:49:00.832749'),(49,'applications','0022_auto_20221013_1023','2022-10-13 10:23:51.673673'),(50,'applications','0023_remove_equipmentconfigmodel_contract','2022-10-13 10:25:35.656685'),(51,'applications','0024_contractdocumentmodel','2022-10-14 06:08:08.388905'),(52,'applications','0025_alter_sparemodel_equipment','2022-10-17 10:51:12.597906'),(53,'applications','0026_alter_sparecompatiblemodel_equipment','2022-10-17 10:52:27.779344');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('6fdys91v4hnwtjer5n6i2ulrost1d2o6','.eJxVi8sOwiAUBf-FtWm4UKC4NOl3ELiP0Kg1kbIy_rs16UIXZzNn5qVS7ltNvfEzLaTOCtTpl5WMV16_R0Z89HVrw4HaMN_zcrscwl9Vc6t7IjJ6IjB21N5IkAJ6HwNM3kUswZKQdWiLAUNA2lHkWNiBpokxaPX-AEshNAc:1okMBc:Pi-oB6MM7FXxU_X0TufqE_Zu96_bqTOhGJ2Em-Z3DuE','2022-10-31 09:13:28.590266'),('8qjfeatzb2k79rdqhvjfax5t29xr5567','.eJxVi80OwiAMgN-Fs1lKxwp6NPE5SFsgLOpMZJyM7-5MdtDr9_MykftaY2_5GedkTsabwy8T1mtevoJVH31Z27CjNlzuPN_Oe_B3VW51WxBDTtZT4SKUxokI8ugIiijhJsQpBssAgqoBpRxpFD8RQBJ0aM37A0X_M28:1okNMe:sD_r3Nr1csOaE9VV3Yk_NhrpoRUd8kB8vatFKj_LAlo','2022-10-31 10:28:56.186585'),('ae0wrc8q66uxcefi9azudufg6tswwb0d','.eJxVi8sOwiAUBf-FtWm4UKC4NOl3ELiP0Kg1kbIy_rs16UIXZzNn5qVS7ltNvfEzLaTOCtTpl5WMV16_R0Z89HVrw4HaMN_zcrscwl9Vc6t7IjJ6IjB21N5IkAJ6HwNM3kUswZKQdWiLAUNA2lHkWNiBpokxaPX-AEshNAc:1ojPoa:k6heQIdCPXTXcr4hdOYfNBehUfhz-Iuq4qKvSeBpYrU','2022-10-28 18:53:48.412256'),('ahelt5q5hlpd6jy4qle1y4bhhafkrhk2','.eJxVi8sOwiAUBf-FtWm4UKC4NOl3ELiP0Kg1kbIy_rs16UIXZzNn5qVS7ltNvfEzLaTOCtTpl5WMV16_R0Z89HVrw4HaMN_zcrscwl9Vc6t7IjJ6IjB21N5IkAJ6HwNM3kUswZKQdWiLAUNA2lHkWNiBpokxaPX-AEshNAc:1od8db:pE0Uw4jUziFEFxtHsHG_CvJ6K1seduJ2INzJ86fpOMI','2022-10-11 11:20:31.520837'),('anuzm1g5lrs0fz88wi2lrps6c5lykmnn','.eJxVi80OwiAMgN-Fs1lKxwp6NPE5SFsgLOpMZJyM7-5MdtDr9_MykftaY2_5GedkTsabwy8T1mtevoJVH31Z27CjNlzuPN_Oe_B3VW51WxBDTtZT4SKUxokI8ugIiijhJsQpBssAgqoBpRxpFD8RQBJ0aM37A0X_M28:1ok7mF:UkxZcOcu6qCfwzxRqANHlLqsPq8sT0-bTXKwztODl3s','2022-10-30 17:50:19.176971'),('bxny0nuuyvow89ivfow3rb50y0jsdiwj','.eJxVi8sOwiAUBf-FtWm4UKC4NOl3ELiP0Kg1kbIy_rs16UIXZzNn5qVS7ltNvfEzLaTOCtTpl5WMV16_R0Z89HVrw4HaMN_zcrscwl9Vc6t7IjJ6IjB21N5IkAJ6HwNM3kUswZKQdWiLAUNA2lHkWNiBpokxaPX-AEshNAc:1okjf2:dUc56bEreQrPGXhTRejLbKP5ysPblYrzjn4sFLuhXYE','2022-11-01 10:17:24.517326'),('f4w30pxw69wmfbtmnpxe3mjqnx1pn0b4','.eJxVi8sOwiAUBf-FtWm4UKC4NOl3ELiP0Kg1kbIy_rs16UIXZzNn5qVS7ltNvfEzLaTOCtTpl5WMV16_R0Z89HVrw4HaMN_zcrscwl9Vc6t7IjJ6IjB21N5IkAJ6HwNM3kUswZKQdWiLAUNA2lHkWNiBpokxaPX-AEshNAc:1ojMOw:glHV6PJJ0vKyxxC1NrbJLuce4W-frXEkGV6lvMmTbBQ','2022-10-28 15:15:06.050650'),('hxsj6cfqiri9jyk3nhn87l8jy8gkur0n','.eJxVi8sOwiAUBf-FtWm4UKC4NOl3ELiP0Kg1kbIy_rs16UIXZzNn5qVS7ltNvfEzLaTOCtTpl5WMV16_R0Z89HVrw4HaMN_zcrscwl9Vc6t7IjJ6IjB21N5IkAJ6HwNM3kUswZKQdWiLAUNA2lHkWNiBpokxaPX-AEshNAc:1ojNSj:fzwx7gVvi5494mIs1o80AptaMX9ZAChHe-kNIezDCUk','2022-10-28 16:23:05.234639'),('nwa0yy21dlaqol6xt9pgy8m4mggyqh98','.eJxVi8sOwiAUBf-FtWm4UKC4NOl3ELiP0Kg1kbIy_rs16UIXZzNn5qVS7ltNvfEzLaTOCtTpl5WMV16_R0Z89HVrw4HaMN_zcrscwl9Vc6t7IjJ6IjB21N5IkAJ6HwNM3kUswZKQdWiLAUNA2lHkWNiBpokxaPX-AEshNAc:1oiVy9:taCqkXEdycP5IPTvT8Xb8cLWn-sjYaNjcgCr7rMdPtk','2022-10-26 07:15:57.860224'),('pe2a9uoudex86g4z77od7mssw9ukkfvd','.eJxVi8sOwiAUBf-FtWm4UKC4NOl3ELiP0Kg1kbIy_rs16UIXZzNn5qVS7ltNvfEzLaTOCtTpl5WMV16_R0Z89HVrw4HaMN_zcrscwl9Vc6t7IjJ6IjB21N5IkAJ6HwNM3kUswZKQdWiLAUNA2lHkWNiBpokxaPX-AEshNAc:1ojMWn:Ken4KNr2mQyRxRXrJnrPTRp-QGyVCIC9tl1FsRyvBx4','2022-10-28 15:23:13.087147'),('utfzft3bxi4gd36uzd31led3xdxgdz0v','.eJxVi8sOwiAUBf-FtWm4UKC4NOl3ELiP0Kg1kbIy_rs16UIXZzNn5qVS7ltNvfEzLaTOCtTpl5WMV16_R0Z89HVrw4HaMN_zcrscwl9Vc6t7IjJ6IjB21N5IkAJ6HwNM3kUswZKQdWiLAUNA2lHkWNiBpokxaPX-AEshNAc:1okNzk:Scawrin3hg-92aAwwCwF4r-SAF959sPN3zc4ndhhCXk','2022-10-31 11:09:20.334504');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partners_partnermodel`
--

DROP TABLE IF EXISTS `partners_partnermodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partners_partnermodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `img` varchar(100) NOT NULL,
  `priority` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partners_partnermodel`
--

LOCK TABLES `partners_partnermodel` WRITE;
/*!40000 ALTER TABLE `partners_partnermodel` DISABLE KEYS */;
INSERT INTO `partners_partnermodel` VALUES (1,'Dell','partners/12052022111847.png',0),(2,'Hewlett-Packard','partners/12052022112515.png',1),(3,'Cisco','partners/12052022112537.png',2),(4,'Brocade','partners/12052022112720.png',3),(5,'WMware','partners/12052022112806.png',4),(6,'Microsoft','partners/12052022112955.png',5),(7,'Veeam','partners/12052022113013.png',7),(8,'Hitachi','partners/12052022113028.png',8);
/*!40000 ALTER TABLE `partners_partnermodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services_servicemodel`
--

DROP TABLE IF EXISTS `services_servicemodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `services_servicemodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `description` longtext NOT NULL,
  `img` varchar(100) NOT NULL,
  `priority` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services_servicemodel`
--

LOCK TABLES `services_servicemodel` WRITE;
/*!40000 ALTER TABLE `services_servicemodel` DISABLE KEYS */;
INSERT INTO `services_servicemodel` VALUES (1,'Покупка оборудования','Мы сотрудничаем с лучшими производителями систем хранения данных и готовы предложить решение, оптимальное по цене и производительности, подходящее для выполнения Вашей задачи.','services/13052022122926.jpg',0),(2,'Установка и настройка','Монтаж, сборка, перевозка и настройка оборудования HPE, Dell EMC, NetApp, Brocade. Интеграция нового оборудования в существующую инфраструктуру заказчика. Соблюдение совместимости версий. Богатый опыт проведения инсталляции в крупнейших компаниях.','services/13052022123017.jpg',1),(3,'Поддержка и ремонт','В основу сервиса положены принципы предотвращения системных сбоев за счет своевременного глубокого анализа работы, существующей инфраструктуры, применения лучших практик производителя оборудования при настройке и внесении изменений в конфигурацию оборудования. Все работы осуществляются сертифицированными специалистами.','services/13052022123103.jpg',2);
/*!40000 ALTER TABLE `services_servicemodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socials_socialmodel`
--

DROP TABLE IF EXISTS `socials_socialmodel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `socials_socialmodel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `img` varchar(100) NOT NULL,
  `link` varchar(300) DEFAULT NULL,
  `priority` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socials_socialmodel`
--

LOCK TABLES `socials_socialmodel` WRITE;
/*!40000 ALTER TABLE `socials_socialmodel` DISABLE KEYS */;
INSERT INTO `socials_socialmodel` VALUES (1,'Facebook','socials/16052022074712.png',NULL,0),(2,'Telegram','socials/16052022074910.png',NULL,1);
/*!40000 ALTER TABLE `socials_socialmodel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thumbnail_kvstore`
--

DROP TABLE IF EXISTS `thumbnail_kvstore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `thumbnail_kvstore` (
  `key` varchar(200) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thumbnail_kvstore`
--

LOCK TABLES `thumbnail_kvstore` WRITE;
/*!40000 ALTER TABLE `thumbnail_kvstore` DISABLE KEYS */;
/*!40000 ALTER TABLE `thumbnail_kvstore` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-10-18 14:05:01
