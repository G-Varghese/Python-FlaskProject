-- MySQL dump 10.13  Distrib 8.0.31, for macos12 (x86_64)
--
-- Host: localhost    Database: gym
-- ------------------------------------------------------
-- Server version	8.0.31

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
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `attendance_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int DEFAULT NULL,
  `attendance_date` date DEFAULT NULL,
  `swipe_in` varchar(10) DEFAULT NULL,
  `swipe_out` varchar(10) DEFAULT NULL,
  `hours` varchar(10) DEFAULT NULL,
  `category` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`attendance_id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupclass`
--

DROP TABLE IF EXISTS `groupclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groupclass` (
  `groupclass_id` int NOT NULL AUTO_INCREMENT,
  `groupclass_name` varchar(45) DEFAULT NULL,
  `groupclass_description` varchar(45) DEFAULT NULL,
  `groupclass_occurance` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`groupclass_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupclass`
--

LOCK TABLES `groupclass` WRITE;
/*!40000 ALTER TABLE `groupclass` DISABLE KEYS */;
INSERT INTO `groupclass` VALUES (401, 'BodyAttack', 'A high-energy fitness class', 'Mondays 8am'),
(402, 'BodyBalance', 'A new generation yoga class', 'Tuesdays 6pm'),(403, 'RPM', 'A group indoor cycling workout', 'Wednesdays 7pm'),
(404, 'BodyPump', 'An ideal workout to get lean, toned and fit', 'Thursdays 6am'),(405,'BodyStep', 'A full-body cardio workout', 'Fridays 6am'),
(406, 'TheTrip', 'A fully immersive workout experience', 'Saturdays 10am'),(407, 'BodyJam', 'An ultimate combination of music and dance', 'Saturdays 2pm'), 
(408, 'Boxing', 'A full body workout', 'Sundays 1pm'),(409, 'Spring', 'A High-Intensity Interval Training (HIIT) workout', 'Sundays 8pm'),
(410, 'Yoga', 'A perfect class for stretching and strengthening', 'Sundays 9pm');
/*!40000 ALTER TABLE `groupclass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupclassbooking`
--

DROP TABLE IF EXISTS `groupclassbooking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groupclassbooking` (
  `groupclassbooking_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int DEFAULT NULL,
  `groupclasssession_id` int DEFAULT NULL,
  `groupclassbooking_status` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`groupclassbooking_id`),
  KEY `member_id` (`member_id`),
  KEY `groupclasssession_id` (`groupclasssession_id`),
  CONSTRAINT `groupclassbooking_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `groupclasssession_id` FOREIGN KEY (`groupclasssession_id`) REFERENCES `groupclasssession` (`groupclasssession_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupclassbooking`
--

LOCK TABLES `groupclassbooking` WRITE;
/*!40000 ALTER TABLE `groupclassbooking` DISABLE KEYS */;
INSERT INTO `groupclassbooking` VALUES (8001, 1001, 6001,'Confirmed'),(8002, 1003, 6001,'Confirmed'),(8003, 1006,6003, 'Confirmed'), 
(8004, 1007, 6005,'Confirmed'),(8005, 1010, 6005,'Confirmed'),(8006, 1011,6007,'Confirmed'),(8007, 1014,6007,'Confirmed'), 
(8008, 1016,6008,'Confirmed'),(8009, 1019,6009,'Confirmed'),(8010, 1020,6010,'Confirmed');

/*!40000 ALTER TABLE `groupclassbooking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupclasssession`
--

DROP TABLE IF EXISTS `groupclasssession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groupclasssession` (
  `groupclasssession_id` int NOT NULL AUTO_INCREMENT,
  `groupclass_id` int DEFAULT NULL,
  `groupclass_date` date DEFAULT NULL,
  `groupclass_time` varchar(45) DEFAULT NULL,
  `vaccancyslot` int DEFAULT NULL,
  PRIMARY KEY (`groupclasssession_id`),
  KEY `groupclass_id_idx` (`groupclass_id`),
  CONSTRAINT `groupclass_id` FOREIGN KEY (`groupclass_id`) REFERENCES `groupclass` (`groupclass_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupclasssession`
--

LOCK TABLES `groupclasssession` WRITE;
/*!40000 ALTER TABLE `groupclasssession` DISABLE KEYS */;
/*!40000 ALTER TABLE `groupclasssession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `member_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `member_name` varchar(45) DEFAULT NULL,
  `member_gender` varchar(45) DEFAULT NULL,
  `member_dob` date DEFAULT NULL,
  `member_status` varchar(30) DEFAULT NULL,
  `member_joindate` date DEFAULT NULL,
  `member_lastpaydate` date DEFAULT NULL,
  `member_houseaddress` varchar(45) DEFAULT NULL,
  `member_suburb` varchar(30) DEFAULT NULL,
  `member_city` varchar(30) DEFAULT NULL,
  `member_postalcode` int DEFAULT NULL,
  `member_phone` int(15) DEFAULT NULL,
  `member_email` varchar(45) DEFAULT NULL,

  PRIMARY KEY (`member_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `members_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1001, 10001, 'Saige Vasquez', 'Male', '1992-04-01', 'Active', '2022-08-01', '2023-03-01', '153 Long Street', 'Woolston', 'Christchurch', 8023, 0281490501, 'jbailie@live.com'), 
(1002, 10002, 'Jordan Hale', 'Male', '1994-05-01', 'Active', '2021-09-21', '2023-03-01', '157 McKellar Place', 'Hornby', 'Christchurch', 8042, 0220581112, 'bmidd@me.com'),
 (1003, 10003, 'Kendal Fox', 'Male', '1993-02-09', 'Active', '2022-09-12', '2023-03-01', '65 Four Elms Place', 'Burwood', 'Christchurch', 8083, 0206334204, 'offthelip@aol.com'),
 (1004, 10005, 'Rayna Wolf', 'Male', '1993-02-09', 'Active', '2022-09-12', '2023-03-01', '13 Somme Street', 'St Albans', 'Christchurch', 8014, 0290439118, 'kosact@att.net'),
 (1005, 10007, 'Macey Key', 'Female', '1991-07-18', 'Active', '2022-09-11', '2023-03-01', '37 Harrys Way', 'Harewood', 'Christchurch', 8051, 0293580995, 'dsowsy@aol.com'),
 (1006, 10008, 'Paul Hill', 'Male', '1993-02-09', 'Inactive', '2021-05-09', '2023-03-01', '152 Main South Road', 'Hei Hei', 'Christchurch', 8042, 0215402229, 'parrt@msn.com'),
 (1007, 10009, 'Laurel Gill', 'Female', '1989-02-09', 'Active', '2020-01-12', '2023-03-01', '65 Timbertop Lane', 'St Martins', 'Christchurch', 8022, 0275226165, 'andersbr@verizon.net'),
 (1008, 10010, 'Serenity Estes', 'Male', '1996-03-15', 'Active', '2022-07-09', '2023-03-01', '67 Greenhurst Street', 'Hei Hei', 'Christchurch', 8042, 0204573419, 'grady@msn.com'),
 (1009, 10013, 'Valentin Gregory', 'Male', '1994-04-15', 'Active', '2022-08-09', '2023-03-01', '136 Melissa Place', 'Avonhead', 'Christchurch', 8042, 0280307912, 'mmccool@hotmail.com'),
 (1010, 10014, 'Sam Malone', 'Female', '1996-10-15', 'Active', '2022-04-09', '2023-03-01', '79 Farm Lane', 'Brooklands', 'Christchurch', 8083, 029518258, 'grady@msn.com'),
 (1011, 10015, 'Katrina Sandoval', 'Female', '1989-11-15', 'Active', '2022-09-11', '2023-03-01', '107 McLellan Place', 'Riccarton', 'Christchurch', 8041, 0273384313, 'tmccarth@aol.com'), 
 (1012, 10016, 'Isaiah Curry', 'Male', '1987-10-20', 'Active', '06-01-2023', '2023-03-01', '199 Sparks Road', 'Somerfield', 'Christchurch', 8024, 0200525333, 'dwheeler@live.com'),
 (1013, 10017, 'Caylee Villegas', 'Male', '1988-10-20', 'Active', '2022-01-23', '2023-03-01', '17 Camberwell Place', 'Yaldhurst', 'Christchurch', 8042, 0287434243, 'staffelb@aol.com'),
 (1014, 10018, 'Joseph Randolph', 'Male', '1985-10-20', 'Active', '2022-06-23', '2023-03-01', '23 Utah Place', 'Aranui', 'Christchurch', 8061, 0218683652, 'empathy@verizon.net'),
 (1015, 10021, 'Cameron Fuller', 'Male', '1998-06-19', 'Active', '2022-01-23', '2023-03-01', '121 Marlin Place', 'Mairehau', 'Christchurch', 8013, 0262056994, 'bdbrown@live.com'),
 (1016, 10023, 'Jewel Mcdaniel', 'Male', '1989-04-09', 'Inactive', '2021-05-09', '2023-03-01', '163 Colac Street', 'Avondale', 'Christchurch', 8061, 0264914749, 'kdawson@aol.com'),
 (1017, 10025, 'Charlie Jones', 'Female', '1998-06-19', 'Active', '2023-01-23', '2023-03-01', '46 Neville Street', 'Barrington', 'Christchurch', 8024, 022601209, 'quantaman@yahoo.com'),
 (1018, 10026, 'Jeffery Solomon','Male', '1997-09-28', 'Active', '2023-01-10','2023-03-01', '101 Willow Street', 'Waltham', 'Christchurch', 8011, 0209234626, 'ajohnson@me.com'),
 (1019, 10027, 'Randy Mckenzie', 'Female', '1993-04-23', 'Active', '2022-06-12', '2023-03-01', '166 Hewitts Road', 'St Albans', 'Christchurch', 8014, 0295038548, 'ducasse@me.com'),
 (1020, 10028, 'Katrina Sandoval', 'Female', '1997-08-28', 'Active', '2022-08-30', '2023-03-01', '223 Olivine Street', 'Edgeware', 'Christchurch', 8013, 0295816035, 'mglee@msn.com');


/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `payment_amount` float NOT NULL,
  `payment_description` varchar(45) DEFAULT NULL,
  `payment_date` date NOT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `member_id_idx` (`member_id`),
  CONSTRAINT `member_id` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personalbooking`
--

DROP TABLE IF EXISTS `personalbooking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personalbooking` (
  `personalbooking_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int DEFAULT NULL,
  `payment_id` int DEFAULT NULL,
  `personaltrainingsession_id` int DEFAULT NULL,
  PRIMARY KEY (`personalbooking_id`),
  KEY `member_id` (`member_id`),
  KEY `payment_id` (`payment_id`),
  KEY `personaltrainingsession_id` (`personaltrainingsession_id`),
  CONSTRAINT `payment_id` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`payment_id`),
  CONSTRAINT `personalbooking_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `personaltrainingsession_id` FOREIGN KEY (`personaltrainingsession_id`) REFERENCES `personaltrainingsession` (`personaltrainingsession_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personalbooking`
--

LOCK TABLES `personalbooking` WRITE;
/*!40000 ALTER TABLE `personalbooking` DISABLE KEYS */;
/*!40000 ALTER TABLE `personalbooking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personaltraining`
--

DROP TABLE IF EXISTS `personaltraining`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personaltraining` (
  `personaltraining_id` int NOT NULL AUTO_INCREMENT,
  `trainer_id` int NOT NULL,
  `personaltraining_name` varchar(45) DEFAULT NULL,
  `personaltraining_description` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`personaltraining_id`),
  KEY `trainer_id_idx` (`trainer_id`),
  CONSTRAINT `trainer_id` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`trainer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personaltraining`
--

LOCK TABLES `personaltraining` WRITE;
/*!40000 ALTER TABLE `personaltraining` DISABLE KEYS */;
INSERT INTO `personaltraining` VALUES (501, 300, 'Go Calorie', 'A course specialised for weight loss'),(502, 301, 'Ferg', 'A one-on-one instructed workout course'),
(503, 302, 'Bulk-up', 'A course specialised for getting stronger'),(504, 303, 'Kick-off', 'A course designed for beginners'),
(505, 304, 'Sole-Fit', 'A whole-body workout program'), (506, 305, 'Fit Boost', 'A one-on-one yoga course'), 
(507, 306, 'Countdown', 'A specialised training for an event'),(508, 307, 'Active', 'A course designer for seniors'),
(509, 308, 'The Spring', 'A specialised course in getting a healthier life'),(510, 309, 'Keep Up', 'A course specialised for those experienced');

/*!40000 ALTER TABLE `personaltraining` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personaltrainingsession`
--

DROP TABLE IF EXISTS `personaltrainingsession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personaltrainingsession` (
  `personaltrainingsession_id` int NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `time` varchar(45) DEFAULT NULL,
  `personaltraining_id` int DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`personaltrainingsession_id`),
  KEY `personaltraining_id_idx` (`personaltraining_id`),
  CONSTRAINT `personaltraining_id` FOREIGN KEY (`personaltraining_id`) REFERENCES `personaltraining` (`personaltraining_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personaltrainingsession`
--

LOCK TABLES `personaltrainingsession` WRITE;
/*!40000 ALTER TABLE `personaltrainingsession` DISABLE KEYS */;
INSERT INTO `personaltrainingsession` VALUES 
(9000, '20230405', '10:00', 501, 'Booked'),(9001, '20230405', '11:00', 503, 'Booked'),
(9002, '20230406', '7:00', 505, 'Available'),(9003, '20230406', '20:00', 505, 'Available'),(9004, '20230407', '18:00', 506, 'Available'),
(9005, '20230408','10:00', 507, 'Booked'),(9006, '20230409','8:00', 507, 'Available'),
(9007, '20230409', '10:00', 510, 'Available'),(9008, '20230409', '21:00', 510, 'Booked'),
(9009, '20230410', '19:00', 504, 'Booked'), (9010, '20230411', '7:00', 502, 'Available'),
(9011, '20230411', '12:00', 505, 'Booked'), (9012, '20230412', '6:30', 508, 'Booked'),
(9013, '20230412', '17:00', 506, 'Available'), (9014, '20230413', '20:00', 503, 'Booked'),
(9015, '20230414', '7:00', 507, 'Available'), (9016, '20230414', '21:00', 508, 'Booked'), 
(9017, '20230415', '12:00', 503, 'Booked');


/*!40000 ALTER TABLE `personaltrainingsession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainers`
--

DROP TABLE IF EXISTS `trainers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trainers` (
  `trainer_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `trainer_name` varchar(45) NOT NULL,
  `trainer_dob` date DEFAULT NULL,
  `trainer_houseno` varchar(45) DEFAULT NULL,
  `trainer_city` varchar(45) DEFAULT NULL,
  `trainer_gender` varchar(45) DEFAULT NULL,
  `trainer_specialization` varchar(45) DEFAULT NULL,
  `trainer_qualification` varchar(45) DEFAULT NULL,
  `trainer_certification` varchar(45) DEFAULT NULL,
  `trainer_email` varchar(30) DEFAULT NULL,
  `trainer_phone` int(15) NOT NULL,
  PRIMARY KEY (`trainer_id`),
  KEY `user_id_idx` (`user_id`),
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=310 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainers`
--

LOCK TABLES `trainers` WRITE;
/*!40000 ALTER TABLE `trainers` DISABLE KEYS */;
INSERT INTO `trainers` VALUES (300,10000,'David Derick','1989-04-14','Rose villa','Christchurch','M','Yogo','Master',NULL,'davidderick@gmail.com',294568972),(301,10004,'Carol Song','2000-03-07','Carol 202','Danudin','F','wait loss','Dietician',NULL,'carolsong@gmail.com',225436789),(302,10011,'Ray Chen','1996-01-17','M90678','Lincoln','F','',NULL,'Personal Training','chenray@gmail.com',221233298),(303,10012,'Be Linda','1991-11-10','Garlina','Auckland','F','Fitness','Bachelors in Sport and Exercise',NULL,'belinda@gmail.com',275645689),(304,10019,'Elenah Guptha','1988-12-08','C1 Gardens','Christchurch','F','Body Building',NULL,'CPT','elenahguptha@gmail.com',228965432),(305,10022,'Thomas George','1993-09-19','Vinod Villa','Lincoln','M','Fitness',NULL,NULL,'thomasgeorge@gmail.com',234789654),(306,10029,'Jessica G','1990-11-01','6 Seclusion','Parklands','F','Zumba','Level 2 Zumba',NULL,'jessicag@gmail.com',289764532),(307,10024,'Kurian K','1993-08-25','7 Madras','Lincoln','M','Cardio',NULL,NULL,'kuriank@gmail.com',89765432),(308,10020,'Joe Huang','1991-10-10','R1 Villa','Lincoln','M','Body Pump',NULL,NULL,'joehuang@gmail.com',23509123),(309,10006,'Geethu Varghese','1002-05-25','8 carlials','Parklands','F','Kids',NULL,NULL,'geethuvarghese@gmail.com',23456789);
/*!40000 ALTER TABLE `trainers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `securityanswer` varchar(30) NOT NULL,
  `user_type` int NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1031 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (10000,'david03','david03','david03','0'),
(10001,'cheyang','cheyang','cheyang','2'),
(10002,'laneliu','laneliu','laneliu','2'),
(10003,'vishnu99','vishnu99','vishnu99','2'),
(10004,'carolsong','carolsong','carolsong','1'),
(10005,'heatherwang','heatherwang','heatherwang','2'),
(10006,'geethusv','geethusv','geethusv','1'),
(10007,'nabian','nabian','nabian','2'),
(10008,'alexshao','alexshao','alexshao','2'),
(10009,'shruthi','shruthi','shruthi','2'),
(10010,'weijiang','weijiang','weijiang','2'),
(10011,'raychen','raychen','raychen','1'),
(10012,'belinda','belinda','belinda', '1'),
(10013,'patrick','patrick','patrick','2'),
(10014,'elizabeth','elizabeth','elizabeth','2'),
(10015,'annabelle','annabelle','annabelle','2'),
(10016,'jadechen','jadechen','jadechen','2'),
(10017,'gauravk','gauravk','gauravk','2'),
(10018,'sookmin','sookmin','sookmin','2'),
(10019,'elenah','elenah','elenah','1'),
(10020,'joehuang','joehuang','joehuang','1'),
(10021,'encilyu','encilyu','encilyu','2'),
(10022,'thomas','thomas','thomas','1'),
(10023,'daniel','daniel','daniel','2'),
(10024,'kurian','kurian','kurian','1'),
(10025,'mathew','mathew','mathew','2'),
(10026,'peter','peter','peter','2'),
(10027,'raychen','raychen','raychen','2'),
(10028,'simranpreet','simranpreeth','simranpreeth','2'),
(10029,'jessica','jessica','jessica','1');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-09 20:10:06

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
INSERT INTO attendance (attendance_id, member_id, attendance_date, swipe_in, swipe_out, hours, category) 
VALUES (5001, 1001, 20230301, 9.00, 10.00, 1, 'GroupClass'),
(5002, 1002, 20230303, 6.00, 8.00, 2, 'General'),
(5003, 1010, 20230303, 19.00, 20.00, 1, 'PersonalClass'), 
(5004, 1003, 20230303, 20.00, 22.00, 2, 'General'),
(5005, 1015, 20230304, 5.00, 6.00, 1, 'GroupClass'),
(5006, 1005, 20230304, 5.00, 6.00, 1, 'GroupClass'), 
(5007, 1007, 20230305, 6.00, 7.00, 1, 'GroupClass'),
(5008, 1009, 20230306, 21.00, 22.00, 1, 'PersonalClass'), 
(5009, 1020, 20230306, 22.00, 23.00, 1, 'General'),
(5010, 1016, 20230307, 12.00, 15.00, 3, 'General'),
(5011, 1016, 20230307, 16.00, 17.00, 1, 'General'),
(5012, 1004, 20230307, 18.00, 20.00, 2, 'General'),
(5013, 1004, 20230307, 21.00, 22.00, 1, 'PersonalClass'),
(5014, 1009, 20230308, 6.00, 7.00, 1, 'PersonalClass'),
(5015, 1009, 20230308, 20.00, 21.00, 1, 'PersonalClass'),
(5016, 1012, 20230308, 20.00, 22.00, 2, 'General'),
(5017, 1011, 20230309, 6.00, 7.00, 1, 'GroupClass'),
(5018, 1007, 20230309, 6.00, 7.00, 1, 'PersonalClass'),
(5019, 1011, 20230308, 19.00, 20.00, 1, 'PersonalClass'),
(5020, 1015, 20230309, 7.00, 9.00, 2, 'General');
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;


INSERT INTO groupclasssession 
VALUES (6001, 401, 20230302, '8am', 9), (6002, 402, 20230321, '6pm', 8), (6003, 403, 20230322, '7pm', 8),
(6004, 404, 20230323, '6am', 10), (6005, 405, 20230314, '6am', 5), (6006, 406, 20230325, '10am', 8), (6007, 407, 20230325, '2pm', 9),
(6008, 408, 20230326, '1pm', 7), (6009, 409, 20230326, '8pm', 8), (6010, 410, 20230316, '9pm', 6);

INSERT INTO payment
VALUES (7001, 1001, 128, 'Monthly subscription fee', 20230301),
(7002, 1002, 128, 'Monthly subscription fee', 20230301),
(7003, 1003, 128, 'Monthly subscription fee', 20230301),
(7004, 1004, 128, 'Monthly subscription fee', 20230301),
(7005, 1005, 128, 'Monthly subscription fee', 20230301),
(7006, 1006, 128, 'Monthly subscription fee', 20230301),
(7007, 1007, 128, 'Monthly subscription fee', 20230301),
(7008, 1008, 128, 'Monthly subscription fee', 20230301),
(7009, 1009, 128, 'Monthly subscription fee', 20230301),
(7010, 1010, 128, 'Monthly subscription fee', 20230301),
(7011, 1011, 128, 'Monthly subscription fee', 20230301),
(7012, 1012, 128, 'Monthly subscription fee', 20230301),
(7013, 1013, 128, 'Monthly subscription fee', 20230301),
(7014, 1014, 128, 'Monthly subscription fee', 20230301),
(7015, 1015, 128, 'Monthly subscription fee', 20230301),
(7016, 1016, 128, 'Monthly subscription fee', 20230301),
(7017, 1017, 128, 'Monthly subscription fee', 20230301),
(7018, 1018, 128, 'Monthly subscription fee', 20230301),
(7019, 1019, 128, 'Monthly subscription fee', 20230301),
(7020, 1020, 128, 'Monthly subscription fee', 20230301),
(7021, 1013, 60, 'Trainer course', 20230302),
(7022, 1004, 60, 'Trainer course', 20230303),
(7023, 1002, 60, 'Trainer course', 20230303),
(7024, 1010, 60, 'Trainer course', 20230303),
(7025, 1008, 60, 'Trainer course', 20230304),
(7026, 1016, 60, 'Trainer course', 20230304),
(7027, 1014, 60, 'Trainer course', 20230305),
(7028, 1019, 60, 'Trainer course', 20230307),
(7029, 1020, 60, 'Trainer course', 20230307),
(7030, 1011, 60, 'Trainer course', 20230308);

INSERT INTO personalbooking 
VALUES (6101, 1013, 7021, 9000), (6102, 1004, 7022, 9001), (6103, 1002, 7023, 9005),
(6104, 1010, 7024, 9008), (6105, 1008, 7025, 9009), (6106, 1016, 7026, 9011),
(6107, 1014, 7027, 9012), (6108, 1019, 7028, 9014), (6109, 1020, 7029, 9016), 
(6110, 1011, 7030, 9017);

