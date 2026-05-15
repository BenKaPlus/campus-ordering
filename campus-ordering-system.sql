-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: campus_ordering_system
-- ------------------------------------------------------
-- Server version	5.7.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `campus_ordering_system`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `campus_ordering_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `campus_ordering_system`;

--
-- Table structure for table `merchant_apply`
--

DROP TABLE IF EXISTS `merchant_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_apply` (
  `apply_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '申请人用户ID',
  `applicant_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '申请人姓名',
  `applicant_phone` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '申请人手机号',
  `applicant_id_card` varchar(18) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '申请人身份证号',
  `shop_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '店铺名称',
  `shop_description` text COLLATE utf8mb4_unicode_ci COMMENT '店铺描述',
  `shop_type` int(11) DEFAULT NULL COMMENT '店铺类型：1-快餐 2-小吃 3-饮品 4-水果 5-超市 6-其他',
  `delivery_fee` decimal(10,2) DEFAULT '0.00' COMMENT '预计配送费',
  `business_license` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '营业执照URL',
  `id_card_front` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证正面URL',
  `id_card_back` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证反面URL',
  `audit_status` int(11) DEFAULT '0' COMMENT '审核状态：0-待审核 1-已通过 2-已拒绝',
  `audit_remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核意见',
  `audit_user_id` bigint(20) DEFAULT NULL COMMENT '审核人ID',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` int(11) DEFAULT '0',
  PRIMARY KEY (`apply_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merchant_apply`
--

LOCK TABLES `merchant_apply` WRITE;
/*!40000 ALTER TABLE `merchant_apply` DISABLE KEYS */;
INSERT INTO `merchant_apply` VALUES (1,7,'张老板','13900139001',NULL,'第一食堂快餐','校园第一食堂，提供美味实惠的快餐',1,1.00,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',1,'审核通过',NULL,NULL,'2024-01-15 10:00:00','2026-05-05 17:34:45',0);
INSERT INTO `merchant_apply` VALUES (2,8,'李老板','13900139002',NULL,'快乐奶茶店','新鲜奶茶，快乐每一天',3,0.00,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',1,'审核通过',NULL,NULL,'2024-01-16 14:30:00','2026-05-05 17:34:45',0);
INSERT INTO `merchant_apply` VALUES (3,9,'王老板','13900139003',NULL,'早餐小铺','营养早餐，开启美好一天',3,0.50,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',1,'审核通过',NULL,NULL,'2024-01-17 09:00:00','2026-05-05 17:34:45',0);
INSERT INTO `merchant_apply` VALUES (4,10,'赵老板','13900139004',NULL,'零食小卖部','各种零食，满足你的味蕾',2,1.50,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',1,'审核通过',NULL,NULL,'2024-01-18 16:00:00','2026-05-05 17:34:45',0);
INSERT INTO `merchant_apply` VALUES (5,11,'刘老板','13900139005',NULL,'川味家常菜','正宗川菜，麻辣鲜香',1,2.00,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',1,'审核通过',NULL,NULL,'2024-01-19 11:00:00','2026-05-05 17:34:45',0);
INSERT INTO `merchant_apply` VALUES (6,2,'张三','13800138001',NULL,'学生创业小店','学生自主创业，售卖文具用品',6,1.00,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',0,NULL,NULL,NULL,'2024-03-20 10:00:00','2026-05-05 17:34:45',0);
INSERT INTO `merchant_apply` VALUES (7,3,'李四','13800138002',NULL,'李四水果摊','新鲜水果，每日配送',4,0.00,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',2,'资质不全，请补充营业执照',NULL,NULL,'2024-03-15 14:00:00','2026-05-05 17:34:45',0);
/*!40000 ALTER TABLE `merchant_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_info`
--

DROP TABLE IF EXISTS `order_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_info` (
  `order_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号（唯一，幂等用）',
  `user_id` bigint(20) NOT NULL COMMENT '下单用户ID',
  `shop_id` bigint(20) NOT NULL COMMENT '所属店铺ID',
  `receiver_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人手机号',
  `receiver_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货地址',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单总金额',
  `product_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品总金额',
  `delivery_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送费',
  `discount_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `pay_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实付金额',
  `pay_type` tinyint(4) DEFAULT NULL COMMENT '支付方式：1-微信支付 2-支付宝支付',
  `order_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '订单状态：0-待支付 1-待接单 2-待备餐 3-待出餐 4-配送中 5-已完成 6-已取消 7-退款中 8-已退款',
  `pay_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '支付状态：0-未支付 1-已支付 2-已退款',
  `order_remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '订单备注',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `accept_time` datetime DEFAULT NULL COMMENT '商家接单时间',
  `delivery_time` datetime DEFAULT NULL COMMENT '出餐/配送时间',
  `finish_time` datetime DEFAULT NULL COMMENT '订单完成时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '订单取消时间',
  `cancel_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '取消原因',
  `expire_time` datetime NOT NULL COMMENT '订单支付过期时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_shop_id` (`shop_id`),
  KEY `idx_pay_type` (`pay_type`),
  KEY `idx_order_status` (`order_status`),
  KEY `idx_pay_status` (`pay_status`),
  KEY `idx_expire_time` (`expire_time`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_shop_status_time` (`shop_id`,`order_status`,`create_time`),
  KEY `idx_user_status_time` (`user_id`,`order_status`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_info`
--

LOCK TABLES `order_info` WRITE;
/*!40000 ALTER TABLE `order_info` DISABLE KEYS */;
INSERT INTO `order_info` VALUES (1,'202403200001',2,1,'张三','13800138001','东校区3号楼502室',31.00,30.00,1.00,0.00,31.00,1,5,1,'多放辣椒','2024-03-20 12:05:00',NULL,NULL,NULL,NULL,'','2024-03-20 12:30:00','2026-04-17 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (2,'202403200002',3,2,'李四','13800138002','东校区3号楼503室',25.00,25.00,0.00,0.00,25.00,2,5,1,'少糖','2024-03-20 14:03:00',NULL,NULL,NULL,NULL,'','2024-03-20 14:30:00','2026-04-08 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (3,'202403200003',4,3,'王五','13800138003','西校区5号楼301室',15.50,15.00,0.50,0.00,15.50,1,4,1,'','2024-03-20 18:02:00',NULL,NULL,NULL,NULL,'','2024-03-20 18:30:00','2026-04-14 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (4,'202403210001',2,5,'张三','13800138001','东校区3号楼502室',50.00,48.00,2.00,0.00,50.00,1,5,1,'不要香菜','2024-03-21 12:04:00',NULL,NULL,NULL,NULL,'','2024-03-21 12:30:00','2026-04-11 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (5,'202403210002',5,4,'赵六','13800138004','西校区5号楼302室',22.50,21.00,1.50,0.00,22.50,2,3,1,'','2024-03-21 15:01:00',NULL,NULL,NULL,NULL,'','2024-03-21 15:30:00','2026-05-05 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (6,'202403220001',6,1,'钱七','13800138005','东校区4号楼201室',16.00,15.00,1.00,0.00,16.00,1,1,1,'','2024-03-22 11:32:00',NULL,NULL,NULL,NULL,'','2024-03-22 12:00:00','2026-04-17 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (7,'202403220002',2,2,'张三','13800138001','东校区3号楼502室',36.00,36.00,0.00,0.00,36.00,1,6,0,'加珍珠',NULL,NULL,NULL,NULL,'2026-05-09 20:49:09','用户主动取消','2024-03-22 16:30:00','2026-05-04 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (8,'202403220003',3,3,'李四','13800138002','东校区3号楼503室',10.50,10.00,0.50,0.00,10.50,2,6,0,'',NULL,NULL,NULL,NULL,NULL,'','2024-03-22 09:30:00','2026-04-26 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (9,'202403230001',12,1,'孙八','13800138006','东校区6号楼101室',28.00,27.00,1.00,0.00,28.00,1,5,1,'微辣','2024-03-23 12:35:00',NULL,NULL,NULL,NULL,'','2024-03-23 13:00:00','2026-04-21 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (10,'202403230002',13,2,'周九','13800138007','西校区7号楼202室',27.00,27.00,0.00,0.00,27.00,2,5,1,'','2024-03-23 14:05:00',NULL,NULL,NULL,NULL,'','2024-03-23 14:30:00','2026-04-21 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (11,'202403230003',14,3,'吴十','13800138008','东校区8号楼303室',12.00,11.00,1.00,0.00,12.00,1,4,1,'多加葱花','2024-03-23 08:05:00',NULL,NULL,NULL,NULL,'','2024-03-23 08:30:00','2026-05-05 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (12,'202403230004',15,4,'郑十一','13800138009','西校区9号楼404室',35.00,33.00,2.00,0.00,35.00,1,5,1,'','2024-03-23 16:08:00',NULL,NULL,NULL,NULL,'','2024-03-23 16:30:00','2026-04-18 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (13,'202403240001',16,5,'冯十二','13800138010','东校区10号楼505室',68.00,66.00,2.00,0.00,68.00,1,5,1,'水煮鱼要特辣','2024-03-24 12:10:00',NULL,NULL,NULL,NULL,'','2024-03-24 12:30:00','2026-04-09 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (14,'202403240002',17,1,'陈十三','13800138011','西校区11号楼606室',45.00,44.00,1.00,0.00,45.00,1,4,1,'','2024-03-24 18:35:00',NULL,NULL,NULL,NULL,'','2024-03-24 19:00:00','2026-04-15 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (15,'202403240003',18,2,'褚十四','13800138012','东校区12号楼707室',42.00,42.00,0.00,0.00,42.00,2,5,1,'去冰','2024-03-24 15:03:00',NULL,NULL,NULL,NULL,'','2024-03-24 15:30:00','2026-04-14 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (16,'202403250001',19,3,'卫十五','13800138013','西校区13号楼808室',18.00,17.00,1.00,0.00,18.00,1,4,1,'','2024-03-25 07:35:00',NULL,NULL,NULL,NULL,'','2024-03-25 08:00:00','2026-04-18 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (17,'202403250002',20,4,'蒋十六','13800138014','东校区14号楼909室',28.00,26.00,2.00,0.00,28.00,1,5,1,'要保温袋','2024-03-25 20:05:00',NULL,NULL,NULL,NULL,'','2024-03-25 20:30:00','2026-04-14 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (18,'202403250003',21,5,'沈十七','13800138015','西校区15号楼1010室',56.00,54.00,2.00,0.00,56.00,1,2,1,'','2024-03-25 12:08:00',NULL,NULL,NULL,NULL,'','2024-03-25 12:30:00','2026-04-09 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (19,'202403260001',22,1,'韩十八','13800138016','东校区16号楼1111室',33.00,32.00,1.00,0.00,33.00,1,5,1,'少盐','2024-03-26 12:35:00',NULL,NULL,NULL,NULL,'','2024-03-26 13:00:00','2026-04-28 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (20,'202403260002',23,2,'杨十九','13800138017','西校区17号楼1212室',24.00,24.00,0.00,0.00,24.00,2,1,1,'','2024-03-26 10:02:00',NULL,NULL,NULL,NULL,'','2024-03-26 10:30:00','2026-04-16 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (21,'202403260003',24,3,'朱二十','13800138018','东校区18号楼1313室',15.50,15.00,0.50,0.00,15.50,1,6,1,'加辣','2024-03-26 08:03:00',NULL,NULL,NULL,NULL,'','2024-03-26 08:30:00','2026-04-23 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (22,'202403270001',25,4,'秦二一','13800138019','西校区19号楼1414室',19.00,18.00,1.00,0.00,19.00,1,5,1,'','2024-03-27 14:05:00',NULL,NULL,NULL,NULL,'','2024-03-27 14:30:00','2026-05-01 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (23,'202403270002',26,5,'尤二二','13800138020','东校区20号楼1515室',42.00,40.00,2.00,0.00,42.00,1,3,1,'不要花椒','2024-03-27 19:08:00',NULL,NULL,NULL,NULL,'','2024-03-27 19:30:00','2026-04-20 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (24,'202403270003',27,1,'许二三','13800138021','西校区21号楼1616室',26.00,25.00,1.00,0.00,26.00,1,4,1,'','2024-03-27 12:05:00',NULL,NULL,NULL,NULL,'','2024-03-27 12:30:00','2026-05-04 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (25,'202403280001',28,2,'何二四','13800138022','东校区22号楼1717室',31.00,31.00,0.00,0.00,31.00,2,5,1,'半糖','2024-03-28 15:03:00',NULL,NULL,NULL,NULL,'','2024-03-28 15:30:00','2026-04-11 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (26,'202403280002',29,3,'吕二五','13800138023','西校区23号楼1818室',22.00,21.00,1.00,0.00,22.00,1,2,1,'','2024-03-28 07:05:00',NULL,NULL,NULL,NULL,'','2024-03-28 07:30:00','2026-04-10 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (27,'202403280003',30,4,'施二六','13800138024','东校区24号楼1919室',46.00,44.00,2.00,0.00,46.00,1,5,1,'','2024-03-28 17:08:00',NULL,NULL,NULL,NULL,'','2024-03-28 17:30:00','2026-04-09 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (28,'202403290001',31,5,'张二七','13800138025','西校区25号楼2020室',38.00,36.00,2.00,0.00,38.00,1,1,1,'微辣就好','2024-03-29 12:05:00',NULL,NULL,NULL,NULL,'','2024-03-29 12:30:00','2026-04-11 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (29,'202403290002',32,1,'孔二八','13800138026','东校区26号楼2121室',17.00,16.00,1.00,0.00,17.00,1,6,0,'',NULL,NULL,NULL,NULL,NULL,'','2024-03-29 18:30:00','2026-04-22 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (30,'202403290003',33,2,'曹二九','13800138027','西校区27号楼2222室',25.00,25.00,0.00,0.00,25.00,2,0,0,'正常冰',NULL,NULL,NULL,NULL,NULL,'','2024-03-29 14:30:00','2026-04-14 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (31,'202403300001',34,3,'严三十','13800138028','东校区28号楼2323室',8.50,8.00,0.50,0.00,8.50,1,5,1,'','2024-03-30 07:32:00',NULL,NULL,NULL,NULL,'','2024-03-30 08:00:00','2026-04-26 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (32,'202403300002',35,4,'华三十一','13800138029','西校区29号楼2424室',14.00,12.00,2.00,0.00,14.00,1,4,1,'','2024-03-30 16:05:00',NULL,NULL,NULL,NULL,'','2024-03-30 16:30:00','2026-04-23 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (33,'202403300003',36,5,'金三二','13800138030','东校区30号楼2525室',52.00,50.00,2.00,0.00,52.00,1,5,1,'多放辣','2024-03-30 19:08:00',NULL,NULL,NULL,NULL,'','2024-03-30 19:30:00','2026-04-30 19:49:44','2026-05-05 19:49:44',0);
INSERT INTO `order_info` VALUES (51,'2053160649143365632',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:45:10','用户主动取消','2026-05-10 01:25:19','2026-05-10 01:10:19','2026-05-10 01:10:19',0);
INSERT INTO `order_info` VALUES (52,'2053160678260224000',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 01:20:18','用户主动取消','2026-05-10 01:25:26','2026-05-10 01:10:26','2026-05-10 01:10:26',0);
INSERT INTO `order_info` VALUES (53,'2053160692382445568',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,2,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 01:20:16','用户主动取消','2026-05-10 01:25:30','2026-05-10 01:10:30','2026-05-10 01:10:30',0);
INSERT INTO `order_info` VALUES (54,'2053161032418865152',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 01:20:14','用户主动取消','2026-05-10 01:26:51','2026-05-10 01:11:51','2026-05-10 17:22:09',1);
INSERT INTO `order_info` VALUES (55,'2053161052308254720',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,2,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 01:20:07','用户主动取消','2026-05-10 01:26:55','2026-05-10 01:11:55','2026-05-10 17:22:03',1);
INSERT INTO `order_info` VALUES (56,'2053161198177759232',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,2,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 01:20:11','用户主动取消','2026-05-10 01:27:30','2026-05-10 01:12:30','2026-05-10 17:22:03',1);
INSERT INTO `order_info` VALUES (57,'2053161215290519552',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 01:20:09','用户主动取消','2026-05-10 01:27:34','2026-05-10 01:12:34','2026-05-10 17:22:03',1);
INSERT INTO `order_info` VALUES (58,'2053161348199624704',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:45:06','用户主动取消','2026-05-10 01:28:06','2026-05-10 01:13:06','2026-05-10 17:22:03',1);
INSERT INTO `order_info` VALUES (59,'2053161366839111680',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,2,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:45:04','用户主动取消','2026-05-10 01:28:10','2026-05-10 01:13:10','2026-05-10 17:22:03',1);
INSERT INTO `order_info` VALUES (60,'2053161386090967040',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:45:02','用户主动取消','2026-05-10 01:28:15','2026-05-10 01:13:15','2026-05-10 17:22:03',1);
INSERT INTO `order_info` VALUES (61,'2053161404801757184',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,2,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:59','用户主动取消','2026-05-10 01:28:19','2026-05-10 01:13:19','2026-05-10 17:22:03',1);
INSERT INTO `order_info` VALUES (62,'2053161678509453312',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:57','用户主动取消','2026-05-10 01:29:25','2026-05-10 01:14:25','2026-05-10 17:22:03',1);
INSERT INTO `order_info` VALUES (63,'2053161696368799744',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,2,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:55','用户主动取消','2026-05-10 01:29:29','2026-05-10 01:14:29','2026-05-10 17:22:03',1);
INSERT INTO `order_info` VALUES (64,'2053161718397284352',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:52','用户主动取消','2026-05-10 01:29:34','2026-05-10 01:14:34','2026-05-10 17:22:03',1);
INSERT INTO `order_info` VALUES (65,'2053161764266192896',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,2,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:50','用户主动取消','2026-05-10 01:29:45','2026-05-10 01:14:45','2026-05-10 17:21:54',1);
INSERT INTO `order_info` VALUES (66,'2053162052305825792',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:47','用户主动取消','2026-05-10 01:30:54','2026-05-10 01:15:54','2026-05-10 17:21:54',1);
INSERT INTO `order_info` VALUES (67,'2053162070764957696',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,2,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:45','用户主动取消','2026-05-10 01:30:58','2026-05-10 01:15:58','2026-05-10 17:21:54',1);
INSERT INTO `order_info` VALUES (68,'2053167779875414016',2,1,'小明','13224343456','东区东校区',18.00,17.00,1.00,0.00,18.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:42','用户主动取消','2026-05-10 01:53:39','2026-05-10 01:38:39','2026-05-10 17:21:54',1);
INSERT INTO `order_info` VALUES (69,'2053167814918823936',2,1,'小明','13224343456','东区东校区',18.00,17.00,1.00,0.00,18.00,2,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:40','用户主动取消','2026-05-10 01:53:48','2026-05-10 01:38:48','2026-05-10 17:21:54',1);
INSERT INTO `order_info` VALUES (70,'2053167831872200704',2,1,'小明','13224343456','东区东校区',18.00,17.00,1.00,0.00,18.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:38','用户主动取消','2026-05-10 01:53:52','2026-05-10 01:38:52','2026-05-10 17:21:54',1);
INSERT INTO `order_info` VALUES (71,'2053167847353376768',2,1,'张三','13800138001','东校区3号楼502室',18.00,17.00,1.00,0.00,18.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:36','用户主动取消','2026-05-10 01:53:55','2026-05-10 01:38:55','2026-05-10 17:21:54',1);
INSERT INTO `order_info` VALUES (72,'2053168118083117056',2,1,'张三','13800138001','东校区3号楼502室',18.00,17.00,1.00,0.00,18.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:34','用户主动取消','2026-05-10 01:55:00','2026-05-10 01:40:00','2026-05-10 17:21:54',1);
INSERT INTO `order_info` VALUES (73,'2053168132406665216',2,1,'张三','13800138001','东校区3号楼502室',18.00,17.00,1.00,0.00,18.00,2,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:32','用户主动取消','2026-05-10 01:55:03','2026-05-10 01:40:03','2026-05-10 17:21:54',1);
INSERT INTO `order_info` VALUES (74,'2053169287610261504',2,1,'张三','13800138001','东校区3号楼502室',18.00,17.00,1.00,0.00,18.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:41:45','用户主动取消','2026-05-10 01:59:39','2026-05-10 01:44:39','2026-05-10 17:21:46',1);
INSERT INTO `order_info` VALUES (75,'2053169287689953280',2,2,'张三','13800138001','东校区3号楼502室',15.00,15.00,0.00,0.00,15.00,1,6,0,'',NULL,NULL,NULL,NULL,'2026-05-10 02:44:30','用户主动取消','2026-05-10 01:59:39','2026-05-10 01:44:39','2026-05-10 17:21:54',1);
INSERT INTO `order_info` VALUES (78,'2053413775872208896',2,1,'张三','13800138001','东校区3号楼502室',17.00,16.00,1.00,0.00,17.00,2,1,0,'','2026-05-14 20:40:38',NULL,NULL,NULL,NULL,'','2026-05-10 18:11:09','2026-05-10 17:56:09','2026-05-10 17:56:09',0);
INSERT INTO `order_info` VALUES (79,'2053413775909957632',2,4,'张三','13800138001','东校区3号楼502室',16.50,15.00,1.50,0.00,16.50,1,0,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:11:09','2026-05-10 17:56:09','2026-05-14 20:41:04',1);
INSERT INTO `order_info` VALUES (80,'2053415580823826432',2,1,'张三','13800138001','东校区3号楼502室',17.00,16.00,1.00,0.00,17.00,2,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:18:20','2026-05-10 18:03:20','2026-05-14 19:18:46',1);
INSERT INTO `order_info` VALUES (81,'2053415580869963776',2,4,'张三','13800138001','东校区3号楼502室',16.50,15.00,1.50,0.00,16.50,1,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:18:20','2026-05-10 18:03:20','2026-05-14 19:18:46',1);
INSERT INTO `order_info` VALUES (82,'2053418200305094656',2,1,'张三','13800138001','东校区3号楼502室',17.00,16.00,1.00,0.00,17.00,2,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:28:44','2026-05-10 18:13:44','2026-05-14 19:18:46',1);
INSERT INTO `order_info` VALUES (83,'2053418200464478208',2,4,'张三','13800138001','东校区3号楼502室',16.50,15.00,1.50,0.00,16.50,1,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:28:44','2026-05-10 18:13:44','2026-05-14 19:18:46',1);
INSERT INTO `order_info` VALUES (84,'2053418233175855104',2,1,'张三','13800138001','东校区3号楼502室',17.00,16.00,1.00,0.00,17.00,1,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:28:52','2026-05-10 18:13:52','2026-05-14 19:18:38',1);
INSERT INTO `order_info` VALUES (85,'2053418233234575360',2,4,'张三','13800138001','东校区3号楼502室',16.50,15.00,1.50,0.00,16.50,2,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:28:52','2026-05-10 18:13:52','2026-05-14 19:18:38',1);
INSERT INTO `order_info` VALUES (86,'2053418814657384448',2,1,'张三','13800138001','东校区3号楼502室',17.00,16.00,1.00,0.00,17.00,1,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:31:11','2026-05-10 18:16:11','2026-05-14 19:18:38',1);
INSERT INTO `order_info` VALUES (87,'2053418814690938880',2,4,'张三','13800138001','东校区3号楼502室',16.50,15.00,1.50,0.00,16.50,2,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:31:11','2026-05-10 18:16:11','2026-05-14 19:18:38',1);
INSERT INTO `order_info` VALUES (88,'2053418961411887104',2,1,'张三','13800138001','东校区3号楼502室',17.00,16.00,1.00,0.00,17.00,2,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:31:46','2026-05-10 18:16:46','2026-05-14 19:18:38',1);
INSERT INTO `order_info` VALUES (89,'2053418961462218752',2,4,'张三','13800138001','东校区3号楼502室',16.50,15.00,1.50,0.00,16.50,1,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:31:46','2026-05-10 18:16:46','2026-05-14 19:18:38',1);
INSERT INTO `order_info` VALUES (90,'2053419374383058944',2,1,'张三','13800138001','东校区3号楼502室',17.00,16.00,1.00,0.00,17.00,2,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:33:24','2026-05-10 18:18:24','2026-05-14 19:18:38',1);
INSERT INTO `order_info` VALUES (91,'2053419374408224768',2,4,'张三','13800138001','东校区3号楼502室',16.50,15.00,1.50,0.00,16.50,1,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:33:24','2026-05-10 18:18:24','2026-05-14 19:18:38',1);
INSERT INTO `order_info` VALUES (92,'2053419465231683584',2,1,'张三','13800138001','东校区3号楼502室',17.00,16.00,1.00,0.00,17.00,2,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:33:46','2026-05-10 18:18:46','2026-05-14 19:18:38',1);
INSERT INTO `order_info` VALUES (93,'2053419465286209536',2,4,'张三','13800138001','东校区3号楼502室',16.50,15.00,1.50,0.00,16.50,1,1,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-10 18:33:46','2026-05-10 18:18:46','2026-05-14 19:18:38',1);
INSERT INTO `order_info` VALUES (94,'2054904873937305600',2,1,'张三','13800138001','东校区3号楼502室',59.00,58.00,1.00,0.00,59.00,1,0,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-14 20:56:15','2026-05-14 20:41:15','2026-05-14 20:41:15',0);
INSERT INTO `order_info` VALUES (95,'2054904874126049280',2,2,'张三','13800138001','东校区3号楼502室',28.00,28.00,0.00,0.00,28.00,1,0,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-14 20:56:15','2026-05-14 20:41:15','2026-05-14 20:41:15',0);
INSERT INTO `order_info` VALUES (96,'2054904898885025792',2,1,'张三','13800138001','东校区3号楼502室',59.00,58.00,1.00,0.00,59.00,2,0,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-14 20:56:21','2026-05-14 20:41:21','2026-05-14 20:41:21',0);
INSERT INTO `order_info` VALUES (97,'2054904899040215040',2,2,'张三','13800138001','东校区3号楼502室',28.00,28.00,0.00,0.00,28.00,1,0,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-14 20:56:21','2026-05-14 20:41:21','2026-05-14 20:41:21',0);
INSERT INTO `order_info` VALUES (98,'2054904919042850816',2,1,'张三','13800138001','东校区3号楼502室',59.00,58.00,1.00,0.00,59.00,2,0,0,'',NULL,NULL,NULL,NULL,NULL,'','2026-05-14 20:56:26','2026-05-14 20:41:26','2026-05-14 20:41:26',0);
INSERT INTO `order_info` VALUES (99,'2054904919164485632',2,2,'张三','13800138001','东校区3号楼502室',28.00,28.00,0.00,0.00,28.00,2,1,0,'','2026-05-14 20:53:52',NULL,NULL,NULL,NULL,'','2026-05-14 20:56:26','2026-05-14 20:41:26','2026-05-14 20:41:26',0);
INSERT INTO `order_info` VALUES (100,'2054905065893822464',2,1,'张三','13800138001','东校区3号楼502室',59.00,58.00,1.00,0.00,59.00,1,1,0,'','2026-05-14 20:53:38',NULL,NULL,NULL,NULL,'','2026-05-14 20:57:01','2026-05-14 20:42:01','2026-05-14 20:42:01',0);
INSERT INTO `order_info` VALUES (101,'2054905065998680064',2,2,'张三','13800138001','东校区3号楼502室',28.00,28.00,0.00,0.00,28.00,1,1,0,'','2026-05-14 20:53:24',NULL,NULL,NULL,NULL,'','2026-05-14 20:57:01','2026-05-14 20:42:01','2026-05-14 20:42:01',0);
INSERT INTO `order_info` VALUES (102,'2054906905507135488',2,1,'张三','13800138001','东校区3号楼502室',59.00,58.00,1.00,0.00,59.00,1,1,0,'','2026-05-14 20:52:39',NULL,NULL,NULL,NULL,'','2026-05-14 21:04:19','2026-05-14 20:49:19','2026-05-14 20:49:19',0);
INSERT INTO `order_info` VALUES (103,'2054906905616187392',2,2,'张三','13800138001','东校区3号楼502室',28.00,28.00,0.00,0.00,28.00,1,1,0,'','2026-05-14 20:52:47',NULL,NULL,NULL,NULL,'','2026-05-14 21:04:19','2026-05-14 20:49:19','2026-05-14 20:49:19',0);
INSERT INTO `order_info` VALUES (104,'2054912540558786560',2,1,'张三','13800138001','东校区3号楼502室',59.00,58.00,1.00,0.00,59.00,1,1,0,'','2026-05-14 21:12:08',NULL,NULL,NULL,NULL,'','2026-05-14 21:26:43','2026-05-14 21:11:43','2026-05-14 21:11:43',0);
INSERT INTO `order_info` VALUES (105,'2054912540856582144',2,2,'张三','13800138001','东校区3号楼502室',28.00,28.00,0.00,0.00,28.00,1,1,0,'','2026-05-14 21:20:13',NULL,NULL,NULL,NULL,'','2026-05-14 21:26:43','2026-05-14 21:11:43','2026-05-14 21:11:43',0);
INSERT INTO `order_info` VALUES (106,'2054912549836587008',2,1,'张三','13800138001','东校区3号楼502室',59.00,58.00,1.00,0.00,59.00,1,1,0,'','2026-05-14 21:11:47',NULL,NULL,NULL,NULL,'','2026-05-14 21:26:45','2026-05-14 21:11:45','2026-05-14 21:11:45',0);
INSERT INTO `order_info` VALUES (107,'2054912549974999040',2,2,'张三','13800138001','东校区3号楼502室',28.00,28.00,0.00,0.00,28.00,1,1,0,'','2026-05-14 21:11:48',NULL,NULL,NULL,NULL,'','2026-05-14 21:26:45','2026-05-14 21:11:45','2026-05-14 21:11:45',0);
INSERT INTO `order_info` VALUES (108,'2054914640642682880',2,1,'张三','13800138001','东校区3号楼502室',34.00,33.00,1.00,0.00,34.00,1,1,0,'','2026-05-14 21:20:05',NULL,NULL,NULL,NULL,'','2026-05-14 21:35:03','2026-05-14 21:20:03','2026-05-14 21:20:03',0);
/*!40000 ALTER TABLE `order_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `item_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '详情ID',
  `order_id` bigint(20) NOT NULL COMMENT '所属订单ID',
  `order_no` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `product_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `product_image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '商品图片',
  `spec_id` bigint(20) DEFAULT NULL COMMENT '规格ID',
  `spec_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '规格名称',
  `product_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品单价',
  `product_num` int(11) NOT NULL DEFAULT '1' COMMENT '商品数量',
  `total_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品小计金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`item_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_order_no` (`order_no`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_order_shop` (`order_id`,`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,1,'202403200001',1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',15.00,1,15.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (2,1,'202403200001',7,'麻婆豆腐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',8.00,1,8.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (3,1,'202403200001',12,'紫菜蛋花汤','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',3.00,1,3.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (4,1,'202403200001',16,'米饭','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.00,2,4.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (5,2,'202403200002',21,'珍珠奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',12.00,2,24.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (6,2,'202403200002',34,'波霸','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.00,1,2.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (7,3,'202403200003',37,'鲜肉包子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.50,2,5.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (8,3,'202403200003',42,'豆浆','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',3.00,1,3.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (9,3,'202403200003',46,'油条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.00,3,6.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (10,4,'202403210001',72,'水煮鱼','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',38.00,1,38.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (11,4,'202403210001',82,'酸辣汤','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',12.00,1,12.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (12,4,'202403210001',88,'米饭','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.00,2,4.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (13,5,'202403210002',53,'薯片','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',6.00,2,12.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (14,5,'202403210002',57,'巧克力','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',12.00,1,12.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (15,5,'202403210002',61,'可乐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',4.00,2,8.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (16,6,'202403220001',2,'糖醋里脊套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',14.00,1,14.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (17,7,'202403220002',22,'椰果奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',13.00,2,26.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (18,7,'202403220002',26,'柠檬红茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',10.00,1,10.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (19,8,'202403220003',37,'鲜肉包子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.50,4,10.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (20,9,'202403230001',1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',15.00,1,15.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (21,9,'202403230001',6,'鱼香肉丝','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',12.00,1,12.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (22,10,'202403230002',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',15.00,1,15.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (23,10,'202403230002',27,'百香果茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',12.00,1,12.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (24,11,'202403230003',45,'煎饼果子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',8.00,1,8.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (25,11,'202403230003',42,'豆浆','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',3.00,1,3.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (26,12,'202403230004',57,'巧克力','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',12.00,2,24.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (27,12,'202403230004',61,'可乐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',4.00,2,8.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (28,13,'202403240001',72,'水煮鱼','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',38.00,1,38.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (29,13,'202403240001',77,'青椒肉丝','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',22.00,1,22.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (30,13,'202403240001',88,'米饭','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.00,2,4.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (31,14,'202403240002',1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',15.00,2,30.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (32,14,'202403240002',9,'尖椒土豆丝','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',6.00,2,12.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (33,15,'202403240003',23,'布丁奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',14.00,2,28.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (34,15,'202403240003',35,'椰果','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',1.50,2,3.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (35,15,'202403240003',33,'摩卡咖啡','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',19.00,1,19.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (36,16,'202403250001',37,'鲜肉包子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.50,3,7.50,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (37,16,'202403250001',46,'油条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.00,3,6.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (38,16,'202403250001',42,'豆浆','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',3.00,1,3.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (39,17,'202403250002',53,'薯片','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',6.00,3,18.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (40,17,'202403250002',65,'泡面','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',5.00,2,10.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (41,18,'202403250003',73,'回锅肉','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',28.00,1,28.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (42,18,'202403250003',74,'辣子鸡','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',32.00,1,32.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (43,19,'202403260001',3,'宫保鸡丁套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',13.00,2,26.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (44,19,'202403260001',14,'酸辣汤','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',4.00,1,4.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (45,20,'202403260002',21,'珍珠奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',12.00,2,24.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (46,21,'202403260003',37,'鲜肉包子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.50,2,5.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (47,21,'202403260003',48,'鸡蛋灌饼','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',5.00,1,5.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (48,22,'202403270001',57,'巧克力','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',12.00,1,12.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (49,22,'202403270001',62,'雪碧','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',4.00,2,8.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (50,23,'202403270002',72,'水煮鱼','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',38.00,1,38.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (51,23,'202403270002',79,'蒜蓉西兰花','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',16.00,1,16.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (52,24,'202403270003',2,'糖醋里脊套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',14.00,1,14.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (53,24,'202403270003',7,'麻婆豆腐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',8.00,1,8.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (54,25,'202403280001',22,'椰果奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',13.00,1,13.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (55,25,'202403280001',25,'红豆奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',13.00,1,13.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (56,26,'202403280002',37,'鲜肉包子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',2.50,4,10.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (57,26,'202403280002',42,'豆浆','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',3.00,1,3.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (58,27,'202403280003',53,'薯片','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',6.00,3,18.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (59,27,'202403280003',67,'瓜子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',8.00,2,16.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (60,28,'202403290001',76,'宫保鸡丁','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',26.00,1,26.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (61,28,'202403290001',75,'麻婆豆腐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',18.00,1,18.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (62,29,'202403290002',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',16.00,1,16.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (63,30,'202403290003',28,'芒果多多','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',14.00,1,14.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (64,30,'202403290003',31,'拿铁咖啡','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',18.00,1,18.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (65,31,'202403300001',45,'煎饼果子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',8.00,1,8.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (66,32,'202403300002',54,'虾条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',5.00,2,10.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (67,33,'202403300003',72,'水煮鱼','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',38.00,1,38.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (68,33,'202403300003',73,'回锅肉','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'',28.00,1,28.00,'2026-05-05 17:16:53','2026-05-05 17:33:35',0);
INSERT INTO `order_item` VALUES (69,51,'2053160649143365632',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:10:19','2026-05-10 01:10:19',0);
INSERT INTO `order_item` VALUES (70,52,'2053160678260224000',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:10:26','2026-05-10 01:10:26',0);
INSERT INTO `order_item` VALUES (71,53,'2053160692382445568',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:10:29','2026-05-10 01:10:29',0);
INSERT INTO `order_item` VALUES (72,54,'2053161032418865152',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:11:50','2026-05-10 01:11:50',0);
INSERT INTO `order_item` VALUES (73,55,'2053161052308254720',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:11:55','2026-05-10 01:11:55',0);
INSERT INTO `order_item` VALUES (74,56,'2053161198177759232',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:12:30','2026-05-10 01:12:30',0);
INSERT INTO `order_item` VALUES (75,57,'2053161215290519552',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:12:34','2026-05-10 01:12:34',0);
INSERT INTO `order_item` VALUES (76,58,'2053161348199624704',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:13:05','2026-05-10 01:13:05',0);
INSERT INTO `order_item` VALUES (77,59,'2053161366839111680',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:13:10','2026-05-10 01:13:10',0);
INSERT INTO `order_item` VALUES (78,60,'2053161386090967040',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:13:15','2026-05-10 01:13:15',0);
INSERT INTO `order_item` VALUES (79,61,'2053161404801757184',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:13:19','2026-05-10 01:13:19',0);
INSERT INTO `order_item` VALUES (80,62,'2053161678509453312',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:14:24','2026-05-10 01:14:24',0);
INSERT INTO `order_item` VALUES (81,63,'2053161696368799744',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:14:28','2026-05-10 01:14:28',0);
INSERT INTO `order_item` VALUES (82,64,'2053161718397284352',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:14:34','2026-05-10 01:14:34',0);
INSERT INTO `order_item` VALUES (83,65,'2053161764266192896',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:14:45','2026-05-10 01:14:45',0);
INSERT INTO `order_item` VALUES (84,66,'2053162052305825792',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:15:53','2026-05-10 01:15:53',0);
INSERT INTO `order_item` VALUES (85,67,'2053162070764957696',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:15:58','2026-05-10 01:15:58',0);
INSERT INTO `order_item` VALUES (86,68,'2053167779875414016',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-10 01:38:39','2026-05-10 01:38:39',0);
INSERT INTO `order_item` VALUES (87,69,'2053167814918823936',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-10 01:38:47','2026-05-10 01:38:47',0);
INSERT INTO `order_item` VALUES (88,70,'2053167831872200704',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-10 01:38:51','2026-05-10 01:38:51',0);
INSERT INTO `order_item` VALUES (89,71,'2053167847353376768',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-10 01:38:55','2026-05-10 01:38:55',0);
INSERT INTO `order_item` VALUES (90,72,'2053168118083117056',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-10 01:40:00','2026-05-10 01:40:00',0);
INSERT INTO `order_item` VALUES (91,73,'2053168132406665216',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-10 01:40:03','2026-05-10 01:40:03',0);
INSERT INTO `order_item` VALUES (92,74,'2053169287610261504',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-10 01:44:38','2026-05-10 01:44:38',0);
INSERT INTO `order_item` VALUES (93,75,'2053169287689953280',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-10 01:44:38','2026-05-10 01:44:38',0);
INSERT INTO `order_item` VALUES (96,78,'2053413775872208896',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-10 17:56:09','2026-05-10 17:56:09',0);
INSERT INTO `order_item` VALUES (97,79,'2053413775909957632',54,'虾条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,5.00,3,15.00,'2026-05-10 17:56:09','2026-05-10 17:56:09',0);
INSERT INTO `order_item` VALUES (98,80,'2053415580823826432',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-10 18:03:19','2026-05-10 18:03:19',0);
INSERT INTO `order_item` VALUES (99,81,'2053415580869963776',54,'虾条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,5.00,3,15.00,'2026-05-10 18:03:19','2026-05-10 18:03:19',0);
INSERT INTO `order_item` VALUES (100,82,'2053418200305094656',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-10 18:13:44','2026-05-10 18:13:44',0);
INSERT INTO `order_item` VALUES (101,83,'2053418200464478208',54,'虾条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,5.00,3,15.00,'2026-05-10 18:13:44','2026-05-10 18:13:44',0);
INSERT INTO `order_item` VALUES (102,84,'2053418233175855104',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-10 18:13:52','2026-05-10 18:13:52',0);
INSERT INTO `order_item` VALUES (103,85,'2053418233234575360',54,'虾条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,5.00,3,15.00,'2026-05-10 18:13:52','2026-05-10 18:13:52',0);
INSERT INTO `order_item` VALUES (104,86,'2053418814657384448',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-10 18:16:10','2026-05-10 18:16:10',0);
INSERT INTO `order_item` VALUES (105,87,'2053418814690938880',54,'虾条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,5.00,3,15.00,'2026-05-10 18:16:10','2026-05-10 18:16:10',0);
INSERT INTO `order_item` VALUES (106,88,'2053418961411887104',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-10 18:16:45','2026-05-10 18:16:45',0);
INSERT INTO `order_item` VALUES (107,89,'2053418961462218752',54,'虾条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,5.00,3,15.00,'2026-05-10 18:16:45','2026-05-10 18:16:45',0);
INSERT INTO `order_item` VALUES (108,90,'2053419374383058944',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-10 18:18:24','2026-05-10 18:18:24',0);
INSERT INTO `order_item` VALUES (109,91,'2053419374408224768',54,'虾条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,5.00,3,15.00,'2026-05-10 18:18:24','2026-05-10 18:18:24',0);
INSERT INTO `order_item` VALUES (110,92,'2053419465231683584',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-10 18:18:45','2026-05-10 18:18:45',0);
INSERT INTO `order_item` VALUES (111,93,'2053419465286209536',54,'虾条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,5.00,3,15.00,'2026-05-10 18:18:45','2026-05-10 18:18:45',0);
INSERT INTO `order_item` VALUES (112,94,'2054904873937305600',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-14 20:41:14','2026-05-14 20:41:14',0);
INSERT INTO `order_item` VALUES (113,94,'2054904873937305600',1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 20:41:14','2026-05-14 20:41:14',0);
INSERT INTO `order_item` VALUES (114,94,'2054904873937305600',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-14 20:41:14','2026-05-14 20:41:14',0);
INSERT INTO `order_item` VALUES (115,94,'2054904873937305600',10,'地三鲜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,10.00,1,10.00,'2026-05-14 20:41:14','2026-05-14 20:41:14',0);
INSERT INTO `order_item` VALUES (116,95,'2054904874126049280',25,'红豆奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,13.00,1,13.00,'2026-05-14 20:41:14','2026-05-14 20:41:14',0);
INSERT INTO `order_item` VALUES (117,95,'2054904874126049280',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 20:41:14','2026-05-14 20:41:14',0);
INSERT INTO `order_item` VALUES (118,96,'2054904898885025792',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-14 20:41:20','2026-05-14 20:41:20',0);
INSERT INTO `order_item` VALUES (119,96,'2054904898885025792',1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 20:41:20','2026-05-14 20:41:20',0);
INSERT INTO `order_item` VALUES (120,96,'2054904898885025792',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-14 20:41:20','2026-05-14 20:41:20',0);
INSERT INTO `order_item` VALUES (121,96,'2054904898885025792',10,'地三鲜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,10.00,1,10.00,'2026-05-14 20:41:20','2026-05-14 20:41:20',0);
INSERT INTO `order_item` VALUES (122,97,'2054904899040215040',25,'红豆奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,13.00,1,13.00,'2026-05-14 20:41:20','2026-05-14 20:41:20',0);
INSERT INTO `order_item` VALUES (123,97,'2054904899040215040',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 20:41:20','2026-05-14 20:41:20',0);
INSERT INTO `order_item` VALUES (124,98,'2054904919042850816',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-14 20:41:25','2026-05-14 20:41:25',0);
INSERT INTO `order_item` VALUES (125,98,'2054904919042850816',1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 20:41:25','2026-05-14 20:41:25',0);
INSERT INTO `order_item` VALUES (126,98,'2054904919042850816',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-14 20:41:25','2026-05-14 20:41:25',0);
INSERT INTO `order_item` VALUES (127,98,'2054904919042850816',10,'地三鲜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,10.00,1,10.00,'2026-05-14 20:41:25','2026-05-14 20:41:25',0);
INSERT INTO `order_item` VALUES (128,99,'2054904919164485632',25,'红豆奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,13.00,1,13.00,'2026-05-14 20:41:25','2026-05-14 20:41:25',0);
INSERT INTO `order_item` VALUES (129,99,'2054904919164485632',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 20:41:25','2026-05-14 20:41:25',0);
INSERT INTO `order_item` VALUES (130,100,'2054905065893822464',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-14 20:42:00','2026-05-14 20:42:00',0);
INSERT INTO `order_item` VALUES (131,100,'2054905065893822464',1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 20:42:00','2026-05-14 20:42:00',0);
INSERT INTO `order_item` VALUES (132,100,'2054905065893822464',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-14 20:42:00','2026-05-14 20:42:00',0);
INSERT INTO `order_item` VALUES (133,100,'2054905065893822464',10,'地三鲜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,10.00,1,10.00,'2026-05-14 20:42:00','2026-05-14 20:42:00',0);
INSERT INTO `order_item` VALUES (134,101,'2054905065998680064',25,'红豆奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,13.00,1,13.00,'2026-05-14 20:42:00','2026-05-14 20:42:00',0);
INSERT INTO `order_item` VALUES (135,101,'2054905065998680064',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 20:42:00','2026-05-14 20:42:00',0);
INSERT INTO `order_item` VALUES (136,102,'2054906905507135488',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-14 20:49:19','2026-05-14 20:49:19',0);
INSERT INTO `order_item` VALUES (137,102,'2054906905507135488',1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 20:49:19','2026-05-14 20:49:19',0);
INSERT INTO `order_item` VALUES (138,102,'2054906905507135488',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-14 20:49:19','2026-05-14 20:49:19',0);
INSERT INTO `order_item` VALUES (139,102,'2054906905507135488',10,'地三鲜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,10.00,1,10.00,'2026-05-14 20:49:19','2026-05-14 20:49:19',0);
INSERT INTO `order_item` VALUES (140,103,'2054906905616187392',25,'红豆奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,13.00,1,13.00,'2026-05-14 20:49:19','2026-05-14 20:49:19',0);
INSERT INTO `order_item` VALUES (141,103,'2054906905616187392',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 20:49:19','2026-05-14 20:49:19',0);
INSERT INTO `order_item` VALUES (142,104,'2054912540558786560',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-14 21:11:42','2026-05-14 21:11:42',0);
INSERT INTO `order_item` VALUES (143,104,'2054912540558786560',1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 21:11:42','2026-05-14 21:11:42',0);
INSERT INTO `order_item` VALUES (144,104,'2054912540558786560',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-14 21:11:42','2026-05-14 21:11:42',0);
INSERT INTO `order_item` VALUES (145,104,'2054912540558786560',10,'地三鲜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,10.00,1,10.00,'2026-05-14 21:11:42','2026-05-14 21:11:42',0);
INSERT INTO `order_item` VALUES (146,105,'2054912540856582144',25,'红豆奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,13.00,1,13.00,'2026-05-14 21:11:42','2026-05-14 21:11:42',0);
INSERT INTO `order_item` VALUES (147,105,'2054912540856582144',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 21:11:42','2026-05-14 21:11:42',0);
INSERT INTO `order_item` VALUES (148,106,'2054912549836587008',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-14 21:11:44','2026-05-14 21:11:44',0);
INSERT INTO `order_item` VALUES (149,106,'2054912549836587008',1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 21:11:44','2026-05-14 21:11:44',0);
INSERT INTO `order_item` VALUES (150,106,'2054912549836587008',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-14 21:11:44','2026-05-14 21:11:44',0);
INSERT INTO `order_item` VALUES (151,106,'2054912549836587008',10,'地三鲜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,10.00,1,10.00,'2026-05-14 21:11:44','2026-05-14 21:11:44',0);
INSERT INTO `order_item` VALUES (152,107,'2054912549974999040',25,'红豆奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,13.00,1,13.00,'2026-05-14 21:11:45','2026-05-14 21:11:45',0);
INSERT INTO `order_item` VALUES (153,107,'2054912549974999040',24,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,15.00,1,15.00,'2026-05-14 21:11:45','2026-05-14 21:11:45',0);
INSERT INTO `order_item` VALUES (154,108,'2054914640642682880',5,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,17.00,1,17.00,'2026-05-14 21:20:03','2026-05-14 21:20:03',0);
INSERT INTO `order_item` VALUES (155,108,'2054914640642682880',4,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,NULL,16.00,1,16.00,'2026-05-14 21:20:03','2026-05-14 21:20:03',0);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_status_log`
--

DROP TABLE IF EXISTS `order_status_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_status_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `order_id` bigint(20) NOT NULL COMMENT '订单ID',
  `order_no` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号',
  `pre_status` tinyint(4) DEFAULT NULL COMMENT '变更前状态',
  `current_status` tinyint(4) NOT NULL COMMENT '变更后状态',
  `operation_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型（如：用户下单、商家接单、用户取消）',
  `operation_user_id` bigint(20) NOT NULL COMMENT '操作人ID',
  `operation_user_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作人名称',
  `operation_remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作备注',
  `operation_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`log_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_order_no` (`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单状态流转日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_status_log`
--

LOCK TABLES `order_status_log` WRITE;
/*!40000 ALTER TABLE `order_status_log` DISABLE KEYS */;
INSERT INTO `order_status_log` VALUES (1,14,'202403240002',3,4,'订单状态更新',7,'第一食堂快餐','','2026-05-05 20:36:26');
INSERT INTO `order_status_log` VALUES (2,7,'202403220002',0,6,'用户取消订单',2,'张三','','2026-05-09 20:49:09');
INSERT INTO `order_status_log` VALUES (3,51,'2053160649143365632',NULL,0,'用户下单',2,'张三','','2026-05-10 01:10:19');
INSERT INTO `order_status_log` VALUES (4,52,'2053160678260224000',NULL,0,'用户下单',2,'张三','','2026-05-10 01:10:26');
INSERT INTO `order_status_log` VALUES (5,53,'2053160692382445568',NULL,0,'用户下单',2,'张三','','2026-05-10 01:10:30');
INSERT INTO `order_status_log` VALUES (6,54,'2053161032418865152',NULL,0,'用户下单',2,'张三','','2026-05-10 01:11:51');
INSERT INTO `order_status_log` VALUES (7,55,'2053161052308254720',NULL,0,'用户下单',2,'张三','','2026-05-10 01:11:55');
INSERT INTO `order_status_log` VALUES (8,56,'2053161198177759232',NULL,0,'用户下单',2,'张三','','2026-05-10 01:12:30');
INSERT INTO `order_status_log` VALUES (9,57,'2053161215290519552',NULL,0,'用户下单',2,'张三','','2026-05-10 01:12:34');
INSERT INTO `order_status_log` VALUES (10,58,'2053161348199624704',NULL,0,'用户下单',2,'张三','','2026-05-10 01:13:06');
INSERT INTO `order_status_log` VALUES (11,59,'2053161366839111680',NULL,0,'用户下单',2,'张三','','2026-05-10 01:13:10');
INSERT INTO `order_status_log` VALUES (12,60,'2053161386090967040',NULL,0,'用户下单',2,'张三','','2026-05-10 01:13:15');
INSERT INTO `order_status_log` VALUES (13,61,'2053161404801757184',NULL,0,'用户下单',2,'张三','','2026-05-10 01:13:19');
INSERT INTO `order_status_log` VALUES (14,62,'2053161678509453312',NULL,0,'用户下单',2,'张三','','2026-05-10 01:14:25');
INSERT INTO `order_status_log` VALUES (15,63,'2053161696368799744',NULL,0,'用户下单',2,'张三','','2026-05-10 01:14:29');
INSERT INTO `order_status_log` VALUES (16,64,'2053161718397284352',NULL,0,'用户下单',2,'张三','','2026-05-10 01:14:34');
INSERT INTO `order_status_log` VALUES (17,65,'2053161764266192896',NULL,0,'用户下单',2,'张三','','2026-05-10 01:14:45');
INSERT INTO `order_status_log` VALUES (18,66,'2053162052305825792',NULL,0,'用户下单',2,'张三','','2026-05-10 01:15:54');
INSERT INTO `order_status_log` VALUES (19,67,'2053162070764957696',NULL,0,'用户下单',2,'张三','','2026-05-10 01:15:58');
INSERT INTO `order_status_log` VALUES (20,55,'2053161052308254720',0,6,'用户取消订单',2,'张三','','2026-05-10 01:20:07');
INSERT INTO `order_status_log` VALUES (21,57,'2053161215290519552',0,6,'用户取消订单',2,'张三','','2026-05-10 01:20:09');
INSERT INTO `order_status_log` VALUES (22,56,'2053161198177759232',0,6,'用户取消订单',2,'张三','','2026-05-10 01:20:11');
INSERT INTO `order_status_log` VALUES (23,54,'2053161032418865152',0,6,'用户取消订单',2,'张三','','2026-05-10 01:20:14');
INSERT INTO `order_status_log` VALUES (24,53,'2053160692382445568',0,6,'用户取消订单',2,'张三','','2026-05-10 01:20:16');
INSERT INTO `order_status_log` VALUES (25,52,'2053160678260224000',0,6,'用户取消订单',2,'张三','','2026-05-10 01:20:18');
INSERT INTO `order_status_log` VALUES (26,68,'2053167779875414016',NULL,0,'用户下单',2,'张三','','2026-05-10 01:38:39');
INSERT INTO `order_status_log` VALUES (27,69,'2053167814918823936',NULL,0,'用户下单',2,'张三','','2026-05-10 01:38:48');
INSERT INTO `order_status_log` VALUES (28,70,'2053167831872200704',NULL,0,'用户下单',2,'张三','','2026-05-10 01:38:52');
INSERT INTO `order_status_log` VALUES (29,71,'2053167847353376768',NULL,0,'用户下单',2,'张三','','2026-05-10 01:38:55');
INSERT INTO `order_status_log` VALUES (30,72,'2053168118083117056',NULL,0,'用户下单',2,'张三','','2026-05-10 01:40:00');
INSERT INTO `order_status_log` VALUES (31,73,'2053168132406665216',NULL,0,'用户下单',2,'张三','','2026-05-10 01:40:03');
INSERT INTO `order_status_log` VALUES (32,74,'2053169287610261504',NULL,0,'用户下单',2,'张三','','2026-05-10 01:44:39');
INSERT INTO `order_status_log` VALUES (33,75,'2053169287689953280',NULL,0,'用户下单',2,'张三','','2026-05-10 01:44:39');
INSERT INTO `order_status_log` VALUES (34,74,'2053169287610261504',0,6,'用户取消订单',2,'张三','','2026-05-10 02:41:45');
INSERT INTO `order_status_log` VALUES (35,75,'2053169287689953280',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:30');
INSERT INTO `order_status_log` VALUES (36,73,'2053168132406665216',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:32');
INSERT INTO `order_status_log` VALUES (37,72,'2053168118083117056',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:34');
INSERT INTO `order_status_log` VALUES (38,71,'2053167847353376768',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:36');
INSERT INTO `order_status_log` VALUES (39,70,'2053167831872200704',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:38');
INSERT INTO `order_status_log` VALUES (40,69,'2053167814918823936',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:40');
INSERT INTO `order_status_log` VALUES (41,68,'2053167779875414016',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:42');
INSERT INTO `order_status_log` VALUES (42,67,'2053162070764957696',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:45');
INSERT INTO `order_status_log` VALUES (43,66,'2053162052305825792',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:47');
INSERT INTO `order_status_log` VALUES (44,65,'2053161764266192896',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:50');
INSERT INTO `order_status_log` VALUES (45,64,'2053161718397284352',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:52');
INSERT INTO `order_status_log` VALUES (46,63,'2053161696368799744',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:55');
INSERT INTO `order_status_log` VALUES (47,62,'2053161678509453312',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:57');
INSERT INTO `order_status_log` VALUES (48,61,'2053161404801757184',0,6,'用户取消订单',2,'张三','','2026-05-10 02:44:59');
INSERT INTO `order_status_log` VALUES (49,60,'2053161386090967040',0,6,'用户取消订单',2,'张三','','2026-05-10 02:45:02');
INSERT INTO `order_status_log` VALUES (50,59,'2053161366839111680',0,6,'用户取消订单',2,'张三','','2026-05-10 02:45:04');
INSERT INTO `order_status_log` VALUES (51,58,'2053161348199624704',0,6,'用户取消订单',2,'张三','','2026-05-10 02:45:06');
INSERT INTO `order_status_log` VALUES (52,51,'2053160649143365632',0,6,'用户取消订单',2,'张三','','2026-05-10 02:45:10');
INSERT INTO `order_status_log` VALUES (55,78,'2053413775872208896',NULL,0,'用户下单',2,'张三','','2026-05-10 17:56:09');
INSERT INTO `order_status_log` VALUES (56,79,'2053413775909957632',NULL,0,'用户下单',2,'张三','','2026-05-10 17:56:09');
INSERT INTO `order_status_log` VALUES (57,80,'2053415580823826432',NULL,0,'用户下单',2,'张三','','2026-05-10 18:03:20');
INSERT INTO `order_status_log` VALUES (58,81,'2053415580869963776',NULL,0,'用户下单',2,'张三','','2026-05-10 18:03:20');
INSERT INTO `order_status_log` VALUES (59,80,'2053415580823826432',0,1,'订单状态更新',2,'张三','','2026-05-10 18:08:43');
INSERT INTO `order_status_log` VALUES (60,81,'2053415580869963776',0,1,'订单状态更新',2,'张三','','2026-05-10 18:08:47');
INSERT INTO `order_status_log` VALUES (61,82,'2053418200305094656',NULL,0,'用户下单',2,'张三','','2026-05-10 18:13:44');
INSERT INTO `order_status_log` VALUES (62,83,'2053418200464478208',NULL,0,'用户下单',2,'张三','','2026-05-10 18:13:44');
INSERT INTO `order_status_log` VALUES (63,82,'2053418200305094656',0,1,'订单状态更新',2,'张三','','2026-05-10 18:13:46');
INSERT INTO `order_status_log` VALUES (64,83,'2053418200464478208',0,1,'订单状态更新',2,'张三','','2026-05-10 18:13:48');
INSERT INTO `order_status_log` VALUES (65,84,'2053418233175855104',NULL,0,'用户下单',2,'张三','','2026-05-10 18:13:52');
INSERT INTO `order_status_log` VALUES (66,85,'2053418233234575360',NULL,0,'用户下单',2,'张三','','2026-05-10 18:13:52');
INSERT INTO `order_status_log` VALUES (67,84,'2053418233175855104',0,1,'订单状态更新',2,'张三','','2026-05-10 18:13:53');
INSERT INTO `order_status_log` VALUES (68,85,'2053418233234575360',0,1,'订单状态更新',2,'张三','','2026-05-10 18:13:55');
INSERT INTO `order_status_log` VALUES (69,86,'2053418814657384448',NULL,0,'用户下单',2,'张三','','2026-05-10 18:16:11');
INSERT INTO `order_status_log` VALUES (70,87,'2053418814690938880',NULL,0,'用户下单',2,'张三','','2026-05-10 18:16:11');
INSERT INTO `order_status_log` VALUES (71,86,'2053418814657384448',0,1,'订单状态更新',2,'张三','','2026-05-10 18:16:12');
INSERT INTO `order_status_log` VALUES (72,87,'2053418814690938880',0,1,'订单状态更新',2,'张三','','2026-05-10 18:16:13');
INSERT INTO `order_status_log` VALUES (73,88,'2053418961411887104',NULL,0,'用户下单',2,'张三','','2026-05-10 18:16:46');
INSERT INTO `order_status_log` VALUES (74,89,'2053418961462218752',NULL,0,'用户下单',2,'张三','','2026-05-10 18:16:46');
INSERT INTO `order_status_log` VALUES (75,88,'2053418961411887104',0,1,'订单状态更新',2,'张三','','2026-05-10 18:16:47');
INSERT INTO `order_status_log` VALUES (76,89,'2053418961462218752',0,1,'订单状态更新',2,'张三','','2026-05-10 18:16:48');
INSERT INTO `order_status_log` VALUES (77,90,'2053419374383058944',NULL,0,'用户下单',2,'张三','','2026-05-10 18:18:24');
INSERT INTO `order_status_log` VALUES (78,91,'2053419374408224768',NULL,0,'用户下单',2,'张三','','2026-05-10 18:18:24');
INSERT INTO `order_status_log` VALUES (79,90,'2053419374383058944',0,1,'订单状态更新',2,'张三','','2026-05-10 18:18:25');
INSERT INTO `order_status_log` VALUES (80,91,'2053419374408224768',0,1,'订单状态更新',2,'张三','','2026-05-10 18:18:26');
INSERT INTO `order_status_log` VALUES (81,92,'2053419465231683584',NULL,0,'用户下单',2,'张三','','2026-05-10 18:18:46');
INSERT INTO `order_status_log` VALUES (82,93,'2053419465286209536',NULL,0,'用户下单',2,'张三','','2026-05-10 18:18:46');
INSERT INTO `order_status_log` VALUES (83,92,'2053419465231683584',0,1,'订单状态更新',2,'张三','','2026-05-10 18:18:47');
INSERT INTO `order_status_log` VALUES (84,93,'2053419465286209536',0,1,'订单状态更新',2,'张三','','2026-05-10 18:18:48');
INSERT INTO `order_status_log` VALUES (85,78,'2053413775872208896',0,1,'订单状态更新',2,'张三','','2026-05-14 20:40:38');
INSERT INTO `order_status_log` VALUES (86,94,'2054904873937305600',NULL,0,'用户下单',2,'张三','','2026-05-14 20:41:15');
INSERT INTO `order_status_log` VALUES (87,95,'2054904874126049280',NULL,0,'用户下单',2,'张三','','2026-05-14 20:41:15');
INSERT INTO `order_status_log` VALUES (88,96,'2054904898885025792',NULL,0,'用户下单',2,'张三','','2026-05-14 20:41:21');
INSERT INTO `order_status_log` VALUES (89,97,'2054904899040215040',NULL,0,'用户下单',2,'张三','','2026-05-14 20:41:21');
INSERT INTO `order_status_log` VALUES (90,98,'2054904919042850816',NULL,0,'用户下单',2,'张三','','2026-05-14 20:41:26');
INSERT INTO `order_status_log` VALUES (91,99,'2054904919164485632',NULL,0,'用户下单',2,'张三','','2026-05-14 20:41:26');
INSERT INTO `order_status_log` VALUES (92,100,'2054905065893822464',NULL,0,'用户下单',2,'张三','','2026-05-14 20:42:01');
INSERT INTO `order_status_log` VALUES (93,101,'2054905065998680064',NULL,0,'用户下单',2,'张三','','2026-05-14 20:42:01');
INSERT INTO `order_status_log` VALUES (94,102,'2054906905507135488',NULL,0,'用户下单',2,'张三','','2026-05-14 20:49:19');
INSERT INTO `order_status_log` VALUES (95,103,'2054906905616187392',NULL,0,'用户下单',2,'张三','','2026-05-14 20:49:19');
INSERT INTO `order_status_log` VALUES (96,102,'2054906905507135488',0,1,'订单状态更新',2,'张三','','2026-05-14 20:52:40');
INSERT INTO `order_status_log` VALUES (97,103,'2054906905616187392',0,1,'订单状态更新',2,'张三','','2026-05-14 20:52:47');
INSERT INTO `order_status_log` VALUES (98,101,'2054905065998680064',0,1,'订单状态更新',2,'张三','','2026-05-14 20:53:24');
INSERT INTO `order_status_log` VALUES (99,100,'2054905065893822464',0,1,'订单状态更新',2,'张三','','2026-05-14 20:53:38');
INSERT INTO `order_status_log` VALUES (100,99,'2054904919164485632',0,1,'订单状态更新',2,'张三','','2026-05-14 20:53:52');
INSERT INTO `order_status_log` VALUES (101,104,'2054912540558786560',NULL,0,'用户下单',2,'张三','','2026-05-14 21:11:43');
INSERT INTO `order_status_log` VALUES (102,105,'2054912540856582144',NULL,0,'用户下单',2,'张三','','2026-05-14 21:11:43');
INSERT INTO `order_status_log` VALUES (103,106,'2054912549836587008',NULL,0,'用户下单',2,'张三','','2026-05-14 21:11:45');
INSERT INTO `order_status_log` VALUES (104,107,'2054912549974999040',NULL,0,'用户下单',2,'张三','','2026-05-14 21:11:45');
INSERT INTO `order_status_log` VALUES (105,106,'2054912549836587008',0,1,'订单状态更新',2,'张三','','2026-05-14 21:11:47');
INSERT INTO `order_status_log` VALUES (106,107,'2054912549974999040',0,1,'订单状态更新',2,'张三','','2026-05-14 21:11:48');
INSERT INTO `order_status_log` VALUES (107,104,'2054912540558786560',0,1,'订单状态更新',2,'张三','','2026-05-14 21:12:08');
INSERT INTO `order_status_log` VALUES (108,108,'2054914640642682880',NULL,0,'用户下单',2,'张三','','2026-05-14 21:20:04');
INSERT INTO `order_status_log` VALUES (109,108,'2054914640642682880',0,1,'订单状态更新',2,'张三','','2026-05-14 21:20:05');
INSERT INTO `order_status_log` VALUES (110,105,'2054912540856582144',0,1,'订单状态更新',2,'张三','','2026-05-14 21:20:13');
/*!40000 ALTER TABLE `order_status_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_info`
--

DROP TABLE IF EXISTS `payment_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_info` (
  `payment_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '支付记录ID',
  `out_trade_no` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商户订单号（对应order_no）',
  `transaction_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '第三方支付流水号',
  `order_id` bigint(20) NOT NULL COMMENT '订单ID',
  `user_id` bigint(20) NOT NULL COMMENT '支付用户ID',
  `pay_type` tinyint(4) NOT NULL COMMENT '支付方式：1-微信支付 2-支付宝支付',
  `pay_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `pay_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '支付状态：0-待支付 1-支付成功 2-支付失败 3-已关闭 4-已退款',
  `pay_time` datetime DEFAULT NULL COMMENT '支付完成时间',
  `callback_content` text COLLATE utf8mb4_unicode_ci COMMENT '支付回调原始数据',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `uk_out_trade_no` (`out_trade_no`),
  UNIQUE KEY `uk_transaction_id` (`transaction_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_pay_type` (`pay_type`),
  KEY `idx_pay_status` (`pay_status`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_info`
--

LOCK TABLES `payment_info` WRITE;
/*!40000 ALTER TABLE `payment_info` DISABLE KEYS */;
INSERT INTO `payment_info` VALUES (1,'2053413775872208896','',78,2,2,17.00,1,'2026-05-14 20:40:38',NULL,'2026-05-14 20:40:38','2026-05-14 20:40:38',0);
INSERT INTO `payment_info` VALUES (12,'2054906905507135488','2054907745663983616',102,2,1,59.00,1,'2026-05-14 20:52:40',NULL,'2026-05-14 20:52:40','2026-05-14 20:52:40',0);
INSERT INTO `payment_info` VALUES (13,'2054906905616187392','2054907775233826816',103,2,1,28.00,1,'2026-05-14 20:52:47',NULL,'2026-05-14 20:52:47','2026-05-14 20:52:47',0);
INSERT INTO `payment_info` VALUES (14,'2054905065998680064','2054907930490183680',101,2,1,28.00,1,'2026-05-14 20:53:24',NULL,'2026-05-14 20:53:24','2026-05-14 20:53:24',0);
INSERT INTO `payment_info` VALUES (15,'2054905065893822464','2054907990951075840',100,2,1,59.00,1,'2026-05-14 20:53:38',NULL,'2026-05-14 20:53:38','2026-05-14 20:53:38',0);
INSERT INTO `payment_info` VALUES (16,'2054904919164485632','2054908048098467840',99,2,2,28.00,1,'2026-05-14 20:53:52',NULL,'2026-05-14 20:53:52','2026-05-14 20:53:52',0);
INSERT INTO `payment_info` VALUES (17,'2054912549836587008','2054912556820103168',106,2,1,59.00,1,'2026-05-14 21:11:47',NULL,'2026-05-14 21:11:47','2026-05-14 21:11:47',0);
INSERT INTO `payment_info` VALUES (18,'2054912549974999040','2054912560867606528',107,2,1,28.00,1,'2026-05-14 21:11:48',NULL,'2026-05-14 21:11:48','2026-05-14 21:11:48',0);
INSERT INTO `payment_info` VALUES (19,'2054912540558786560','2054912647526121472',104,2,1,59.00,1,'2026-05-14 21:12:08',NULL,'2026-05-14 21:12:08','2026-05-14 21:12:08',0);
INSERT INTO `payment_info` VALUES (20,'2054914640642682880','2054914647223545856',108,2,1,34.00,1,'2026-05-14 21:20:05',NULL,'2026-05-14 21:20:05','2026-05-14 21:20:05',0);
INSERT INTO `payment_info` VALUES (21,'2054912540856582144','2054914680555679744',105,2,1,28.00,1,'2026-05-14 21:20:13',NULL,'2026-05-14 21:20:13','2026-05-14 21:20:13',0);
/*!40000 ALTER TABLE `payment_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_category`
--

DROP TABLE IF EXISTS `product_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category` (
  `category_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `shop_id` bigint(20) NOT NULL COMMENT '所属店铺ID',
  `category_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称（如：主食、小吃、饮品）',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uk_shop_category` (`shop_id`,`category_name`),
  KEY `idx_shop_id` (`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_category`
--

LOCK TABLES `product_category` WRITE;
/*!40000 ALTER TABLE `product_category` DISABLE KEYS */;
INSERT INTO `product_category` VALUES (1,1,'热销套餐',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (2,1,'单品菜肴',2,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (3,1,'汤品',3,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (4,2,'奶茶系列',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (5,2,'果茶系列',2,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (6,2,'咖啡系列',3,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (7,3,'包子馒头',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (8,3,'豆浆粥品',2,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (9,3,'煎饼油条',3,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (10,4,'膨化食品',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (11,4,'糖果巧克力',2,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (12,4,'饮料',3,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (13,5,'经典川菜',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (14,5,'家常小炒',2,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (15,5,'汤羹',3,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (16,1,'主食',4,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (17,1,'凉菜',5,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (18,2,'奶茶配料',4,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (19,3,'面食',4,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (20,3,'粥品',5,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (21,4,'方便食品',4,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (22,4,'坚果',5,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (23,4,'奶制品',6,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (24,5,'凉菜',4,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `product_category` VALUES (25,5,'主食',5,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
/*!40000 ALTER TABLE `product_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_info`
--

DROP TABLE IF EXISTS `product_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_info` (
  `product_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `shop_id` bigint(20) NOT NULL COMMENT '所属店铺ID',
  `category_id` bigint(20) NOT NULL COMMENT '所属商品分类ID',
  `product_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `product_image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '商品主图URL',
  `product_images` text COLLATE utf8mb4_unicode_ci COMMENT '商品轮播图URL数组（JSON格式）',
  `product_desc` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '商品描述',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '商品售价',
  `original_price` decimal(10,2) DEFAULT '0.00' COMMENT '商品原价',
  `unit` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '份' COMMENT '商品单位（份、杯、个等）',
  `monthly_sales` int(11) NOT NULL DEFAULT '0' COMMENT '月销量',
  `product_status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '商品状态：0-下架 1-上架',
  `is_hot` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否热销：0-否 1-是',
  `is_recommend` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否推荐：0-否 1-是',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`product_id`),
  KEY `idx_shop_id` (`shop_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_product_status` (`product_status`),
  KEY `idx_is_hot` (`is_hot`),
  KEY `idx_is_recommend` (`is_recommend`),
  KEY `idx_product_name` (`product_name`),
  KEY `idx_shop_category_status` (`shop_id`,`category_id`,`product_status`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_info`
--

LOCK TABLES `product_info` WRITE;
/*!40000 ALTER TABLE `product_info` DISABLE KEYS */;
INSERT INTO `product_info` VALUES (1,1,1,'红烧肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'肥瘦相间，入口即化',15.00,18.00,'份',230,1,1,1,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (2,1,1,'糖醋里脊套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酸甜可口，老少皆宜',14.00,16.00,'份',180,1,1,1,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (3,1,1,'宫保鸡丁套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'经典川菜，麻辣鲜香',13.00,15.00,'份',150,1,1,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (4,1,1,'东坡肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'皮薄肉嫩，酥而不烂',16.00,20.00,'份',160,1,1,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (5,1,1,'梅菜扣肉套餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'梅菜清香，扣肉软糯',17.00,22.00,'份',140,1,0,0,5,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (6,1,2,'鱼香肉丝','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酸甜微辣，下饭神器',12.00,14.00,'份',120,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (7,1,2,'麻婆豆腐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'麻辣鲜香，嫩滑爽口',8.00,10.00,'份',200,1,1,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (8,1,2,'番茄炒蛋','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'家常美味，营养丰富',7.00,9.00,'份',180,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (9,1,2,'尖椒土豆丝','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清脆爽口，下饭好菜',6.00,8.00,'份',160,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (10,1,2,'地三鲜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'茄子土豆青椒，家常经典',10.00,12.00,'份',130,1,0,0,5,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (11,1,2,'干煸四季豆','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'干香入味，越嚼越香',9.00,11.00,'份',110,1,0,0,6,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (12,1,3,'紫菜蛋花汤','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清淡爽口，营养健康',3.00,4.00,'份',300,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (13,1,3,'番茄蛋汤','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酸甜开胃，家常味道',3.00,4.00,'份',250,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (14,1,3,'酸辣汤','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酸辣开胃，暖胃暖心',4.00,5.00,'份',200,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (15,1,3,'青菜豆腐汤','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清淡养生，绿色健康',3.00,4.00,'份',150,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (16,1,16,'米饭','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'东北大米，香软可口',2.00,2.50,'份',500,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (17,1,16,'馒头','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'松软可口，麦香浓郁',1.00,1.50,'个',300,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (18,1,16,'面条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'手工面条，劲道爽滑',3.00,4.00,'份',200,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (19,1,17,'凉拌黄瓜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清脆爽口，夏日必备',4.00,5.00,'份',120,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (20,1,17,'凉拌木耳','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'黑木耳，脆嫩爽口',5.00,6.00,'份',100,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (21,2,4,'珍珠奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'Q弹珍珠，香浓奶茶',12.00,15.00,'杯',350,1,1,1,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (22,2,4,'椰果奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'椰果香甜，奶茶浓郁',13.00,16.00,'杯',280,1,1,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (23,2,4,'布丁奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'嫩滑布丁，奶香四溢',14.00,17.00,'杯',220,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (24,2,4,'芋泥奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'芋泥浓郁，口感丰富',15.00,18.00,'杯',200,1,1,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (25,2,4,'红豆奶茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'软糯红豆，甜蜜可口',13.00,16.00,'杯',190,1,0,0,5,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (26,2,5,'柠檬红茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清新柠檬，醇香红茶',10.00,12.00,'杯',180,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (27,2,5,'百香果茶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酸甜百香，清爽解渴',12.00,14.00,'杯',150,1,1,1,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (28,2,5,'芒果多多','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'新鲜芒果，浓郁果香',14.00,17.00,'杯',140,1,1,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (29,2,5,'草莓奶昔','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'香甜草莓，丝滑奶昔',13.00,16.00,'杯',130,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (30,2,6,'美式咖啡','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'醇香咖啡，提神醒脑',15.00,18.00,'杯',120,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (31,2,6,'拿铁咖啡','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'奶香浓郁，咖啡醇厚',18.00,22.00,'杯',100,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (32,2,6,'卡布奇诺','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'绵密奶泡，经典意式',17.00,21.00,'杯',90,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (33,2,6,'摩卡咖啡','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'巧克力咖啡，香甜浓郁',19.00,24.00,'杯',85,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (34,2,18,'波霸','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'大颗波霸，Q弹有嚼劲',2.00,3.00,'份',300,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (35,2,18,'椰果','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'椰果果肉，清爽Q弹',1.50,2.00,'份',250,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (36,2,18,'布丁','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'嫩滑布丁，奶香浓郁',2.00,3.00,'份',200,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (37,3,7,'鲜肉包子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'皮薄馅大，鲜香多汁',2.50,3.00,'个',500,1,1,1,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (38,3,7,'菜包','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'新鲜蔬菜，健康美味',2.00,2.50,'个',400,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (39,3,7,'豆沙包','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'香甜豆沙，软糯可口',2.00,2.50,'个',350,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (40,3,7,'肉龙','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'层层肉香，回味无穷',4.00,5.00,'个',200,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (41,3,7,'奶黄包','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'奶香浓郁，甜而不腻',2.50,3.00,'个',180,1,0,0,5,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (42,3,8,'豆浆','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'现磨豆浆，香浓营养',3.00,4.00,'杯',450,1,1,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (43,3,8,'小米粥','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'养胃小米粥，温暖身心',4.00,5.00,'碗',300,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (44,3,8,'八宝粥','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'多种谷物，养生健康',5.00,6.00,'碗',250,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (45,3,9,'煎饼果子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'香脆可口，早餐首选',8.00,10.00,'份',380,1,1,1,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (46,3,9,'油条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'金黄酥脆，传统美味',2.00,2.50,'根',420,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (47,3,9,'手抓饼','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酥脆千层，酱香四溢',6.00,8.00,'份',300,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (48,3,9,'鸡蛋灌饼','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'鸡蛋香嫩，饼皮酥脆',5.00,6.00,'份',280,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (49,3,19,'阳春面','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清淡爽口，简单美味',8.00,10.00,'碗',150,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (50,3,19,'馄饨','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'皮薄馅嫩，汤鲜味美',10.00,12.00,'碗',140,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (51,3,20,'皮蛋瘦肉粥','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'皮蛋独特，瘦肉鲜香',8.00,10.00,'碗',130,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (52,3,20,'南瓜粥','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'香甜软糯，营养丰富',4.00,5.00,'碗',120,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (53,4,10,'薯片','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酥脆爽口，多种口味',6.00,8.00,'袋',280,1,1,1,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (54,4,10,'虾条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'鲜香虾味，童年回忆',5.00,6.00,'袋',200,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (55,4,10,'薯条','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'金黄酥脆，追剧必备',5.00,7.00,'袋',180,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (56,4,10,'爆米花','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'香甜爆裂，电影搭档',8.00,10.00,'袋',160,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (57,4,11,'巧克力','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'丝滑浓郁，甜蜜享受',12.00,15.00,'块',150,1,1,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (58,4,11,'水果糖','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'多种口味，甜蜜滋味',3.00,4.00,'袋',220,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (59,4,11,'奶糖','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'奶香浓郁，柔软香甜',4.00,5.00,'袋',190,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (60,4,11,'薄荷糖','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清新口气，提神醒脑',2.00,3.00,'盒',170,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (61,4,12,'可乐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'畅爽气泡，经典味道',4.00,5.00,'瓶',350,1,1,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (62,4,12,'雪碧','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清爽柠檬，解渴神器',4.00,5.00,'瓶',300,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (63,4,12,'橙汁','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'新鲜橙汁，维C满满',5.00,6.00,'瓶',250,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (64,4,12,'农夫山泉','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'天然矿泉水，健康生活',2.00,3.00,'瓶',400,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (65,4,21,'泡面','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'方便快捷，宵夜首选',5.00,6.00,'桶',200,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (66,4,21,'自热米饭','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'随时随地，享受美食',15.00,18.00,'份',150,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (67,4,22,'瓜子','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'香脆瓜子，休闲必备',8.00,10.00,'袋',180,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (68,4,22,'花生','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'香脆花生，下酒好菜',7.00,9.00,'袋',160,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (69,4,22,'开心果','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'营养坚果，健康零食',15.00,18.00,'袋',120,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (70,4,23,'牛奶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'纯正牛奶，营养早餐',6.00,7.00,'盒',300,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (71,4,23,'酸奶','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酸甜可口，助消化',7.00,8.00,'盒',280,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (72,5,13,'水煮鱼','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'鲜嫩鱼肉，麻辣过瘾',38.00,48.00,'份',120,1,1,1,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (73,5,13,'回锅肉','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'肥而不腻，川菜经典',28.00,35.00,'份',150,1,1,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (74,5,13,'辣子鸡','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'香辣酥脆，越吃越香',32.00,40.00,'份',130,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (75,5,13,'麻婆豆腐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'麻辣鲜香，豆腐嫩滑',18.00,22.00,'份',110,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (76,5,13,'宫保鸡丁','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'香辣酸甜，鸡肉嫩滑',26.00,32.00,'份',100,1,0,0,5,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (77,5,14,'青椒肉丝','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'家常小炒，下饭神器',22.00,28.00,'份',180,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (78,5,14,'鱼香肉丝','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酸甜微辣，开胃下饭',24.00,30.00,'份',160,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (79,5,14,'蒜蓉西兰花','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清爽健康，蒜香四溢',16.00,20.00,'份',140,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (80,5,14,'干煸四季豆','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'干香入味，越嚼越香',18.00,22.00,'份',130,1,0,0,4,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (81,5,14,'番茄炒蛋','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酸甜可口，家常必备',15.00,18.00,'份',150,1,0,0,5,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (82,5,15,'酸辣汤','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酸辣开胃，暖胃暖心',12.00,15.00,'份',100,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (83,5,15,'紫菜蛋花汤','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清淡爽口，营养丰富',8.00,10.00,'份',90,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (84,5,15,'番茄蛋汤','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'酸甜开胃，简单美味',10.00,12.00,'份',85,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (85,5,24,'凉拌黄瓜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'清脆爽口，夏日凉菜',10.00,12.00,'份',80,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (86,5,24,'夫妻肺片','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'麻辣鲜香，下饭神器',28.00,35.00,'份',75,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (87,5,24,'口水鸡','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'麻辣鲜香，鸡肉嫩滑',26.00,32.00,'份',70,1,0,0,3,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (88,5,25,'米饭','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'香软可口，东北大米',2.00,3.00,'份',200,1,0,0,1,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
INSERT INTO `product_info` VALUES (89,5,25,'馒头','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',NULL,'松软可口，麦香浓郁',1.00,1.50,'个',150,1,0,0,2,'2026-05-05 17:16:53','2026-05-05 17:33:17',0);
/*!40000 ALTER TABLE `product_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_spec`
--

DROP TABLE IF EXISTS `product_spec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_spec` (
  `spec_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '规格ID',
  `product_id` bigint(20) NOT NULL COMMENT '所属商品ID',
  `spec_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规格名称（如：少冰、正常冰、大份、小份）',
  `spec_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '规格加价/售价',
  `stock` int(11) NOT NULL DEFAULT '0' COMMENT '规格库存',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`spec_id`),
  KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品规格表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_spec`
--

LOCK TABLES `product_spec` WRITE;
/*!40000 ALTER TABLE `product_spec` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_spec` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_category`
--

DROP TABLE IF EXISTS `shop_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_category` (
  `category_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称（如：快餐、奶茶、早餐）',
  `category_icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '分类图标URL',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uk_category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='店铺分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_category`
--

LOCK TABLES `shop_category` WRITE;
/*!40000 ALTER TABLE `shop_category` DISABLE KEYS */;
INSERT INTO `shop_category` VALUES (1,'快餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',1,'2026-05-05 17:16:53','2026-05-05 17:33:44',0);
INSERT INTO `shop_category` VALUES (2,'奶茶饮品','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',2,'2026-05-05 17:16:53','2026-05-05 17:33:44',0);
INSERT INTO `shop_category` VALUES (3,'早餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',3,'2026-05-05 17:16:53','2026-05-05 17:33:44',0);
INSERT INTO `shop_category` VALUES (4,'小吃零食','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',4,'2026-05-05 17:16:53','2026-05-05 17:33:44',0);
INSERT INTO `shop_category` VALUES (5,'正餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',5,'2026-05-05 17:16:53','2026-05-05 17:33:44',0);
/*!40000 ALTER TABLE `shop_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_info`
--

DROP TABLE IF EXISTS `shop_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_info` (
  `shop_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '店铺ID',
  `merchant_user_id` bigint(20) NOT NULL COMMENT '关联商家用户ID',
  `shop_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '店铺名称',
  `shop_logo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '店铺LOGO URL',
  `shop_cover` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '店铺封面图URL',
  `shop_category_id` bigint(20) NOT NULL COMMENT '店铺分类ID',
  `business_license` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '营业执照URL',
  `food_license` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '食品经营许可证URL',
  `shop_desc` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '店铺简介',
  `business_hours` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '营业时间（如：10:00-22:00）',
  `contact_phone` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '店铺联系电话',
  `shop_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '店铺地址（校园内位置）',
  `delivery_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送费',
  `min_order_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '起送金额',
  `shop_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '店铺状态：0-待审核 1-营业中 2-已打烊 3-审核驳回 4-已禁用',
  `audit_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '审核状态：0-待审核 1-审核通过 2-审核驳回',
  `audit_remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '审核备注',
  `monthly_sales` int(11) NOT NULL DEFAULT '0' COMMENT '月销量',
  `shop_score` decimal(2,1) NOT NULL DEFAULT '5.0' COMMENT '店铺评分（满分5.0）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `wx_qrcode` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '微信收款码URL',
  `ali_qrcode` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '支付宝收款码URL',
  PRIMARY KEY (`shop_id`),
  UNIQUE KEY `uk_merchant_user_id` (`merchant_user_id`),
  KEY `idx_shop_category_id` (`shop_category_id`),
  KEY `idx_shop_status` (`shop_status`),
  KEY `idx_audit_status` (`audit_status`),
  KEY `idx_shop_score` (`shop_score`),
  KEY `idx_shop_name` (`shop_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商家店铺信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_info`
--

LOCK TABLES `shop_info` WRITE;
/*!40000 ALTER TABLE `shop_info` DISABLE KEYS */;
INSERT INTO `shop_info` VALUES (1,7,'第一食堂快餐','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',1,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','校园第一食堂，提供美味实惠的快餐','07:00-21:00','13900139001','第一食堂一楼',1.00,8.00,1,1,'',1250,4.8,'2026-05-05 17:16:53','2026-05-10 00:40:42',0,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/mm_facetoface_collect_qrcode_1778341191734.png','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/1778341210640.jpg');
INSERT INTO `shop_info` VALUES (2,8,'快乐奶茶店','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',2,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','新鲜奶茶，快乐每一天','09:00-22:00','13900139002','商业街A区3号',0.00,15.00,1,1,'',980,4.9,'2026-05-05 17:16:53','2026-05-10 00:43:08',0,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/mm_facetoface_collect_qrcode_1778341191734.png','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/1778341210640.jpg');
INSERT INTO `shop_info` VALUES (3,9,'早餐小铺','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',3,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','营养早餐，开启美好一天','06:00-10:00','13900139003','第二食堂门口',0.50,5.00,1,1,'',850,4.7,'2026-05-05 17:16:53','2026-05-10 00:43:08',0,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/mm_facetoface_collect_qrcode_1778341191734.png','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/1778341210640.jpg');
INSERT INTO `shop_info` VALUES (4,10,'零食小卖部','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',4,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','各种零食，满足你的味蕾','08:00-23:00','13900139004','宿舍区B区1号',1.50,10.00,1,1,'',650,4.6,'2026-05-05 17:16:53','2026-05-10 00:43:08',0,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/mm_facetoface_collect_qrcode_1778341191734.png','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/1778341210640.jpg');
INSERT INTO `shop_info` VALUES (5,11,'川味家常菜','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg',5,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg','正宗川菜，麻辣鲜香','10:00-21:00','13900139005','商业街B区5号',2.00,20.00,1,1,'',720,4.8,'2026-05-05 17:16:53','2026-05-10 00:43:08',0,'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/mm_facetoface_collect_qrcode_1778341191734.png','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/1778341210640.jpg');
/*!40000 ALTER TABLE `shop_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopping_cart`
--

DROP TABLE IF EXISTS `shopping_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_cart` (
  `cart_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` bigint(20) NOT NULL COMMENT '所属用户ID',
  `shop_id` bigint(20) NOT NULL COMMENT '所属店铺ID',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `spec_id` bigint(20) DEFAULT NULL COMMENT '商品规格ID',
  `product_num` int(11) NOT NULL DEFAULT '1' COMMENT '商品数量',
  `is_checked` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否选中：0-未选中 1-选中',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`cart_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_shop_id` (`shop_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_user_shop` (`user_id`,`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopping_cart`
--

LOCK TABLES `shopping_cart` WRITE;
/*!40000 ALTER TABLE `shopping_cart` DISABLE KEYS */;
INSERT INTO `shopping_cart` VALUES (1,2,1,3,NULL,1,1,'2026-05-05 17:16:53','2026-05-09 22:14:57',1);
INSERT INTO `shopping_cart` VALUES (2,2,1,6,NULL,1,1,'2026-05-05 17:16:53','2026-05-09 22:15:02',1);
INSERT INTO `shopping_cart` VALUES (3,2,2,13,NULL,1,0,'2026-05-05 17:16:53','2026-05-09 22:15:00',1);
INSERT INTO `shopping_cart` VALUES (4,3,3,17,NULL,3,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (5,4,5,30,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (6,5,4,24,NULL,2,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (7,6,2,15,NULL,1,0,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (8,12,1,5,NULL,2,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (9,13,2,27,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (10,14,3,45,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (11,15,4,53,NULL,2,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (12,16,5,72,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (13,17,1,2,NULL,1,0,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (14,18,2,22,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (15,19,3,37,NULL,3,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (16,20,4,61,NULL,2,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (17,21,5,73,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (18,22,1,7,NULL,2,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (19,23,2,28,NULL,1,0,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (20,24,3,42,NULL,2,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (21,25,4,57,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (22,26,5,74,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (23,27,1,1,NULL,1,0,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (24,28,2,30,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (25,29,3,46,NULL,2,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (26,30,4,65,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (27,31,5,77,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (28,32,1,14,NULL,1,0,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (29,33,2,33,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (30,34,3,38,NULL,2,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (31,35,4,70,NULL,1,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (32,36,5,88,NULL,2,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `shopping_cart` VALUES (33,2,1,3,NULL,1,1,'2026-05-09 22:15:09','2026-05-09 22:15:14',1);
INSERT INTO `shopping_cart` VALUES (34,2,1,2,NULL,1,1,'2026-05-09 22:15:11','2026-05-09 22:15:14',1);
INSERT INTO `shopping_cart` VALUES (35,2,1,5,NULL,1,1,'2026-05-09 23:35:14','2026-05-10 02:44:24',1);
INSERT INTO `shopping_cart` VALUES (36,2,2,24,NULL,1,1,'2026-05-10 00:41:12','2026-05-10 02:44:24',1);
INSERT INTO `shopping_cart` VALUES (37,2,1,5,NULL,1,1,'2026-05-10 02:41:57','2026-05-10 02:44:24',1);
INSERT INTO `shopping_cart` VALUES (38,2,1,4,NULL,1,1,'2026-05-10 12:42:46','2026-05-14 19:19:08',1);
INSERT INTO `shopping_cart` VALUES (39,2,4,54,NULL,3,1,'2026-05-10 17:55:31','2026-05-14 19:19:08',1);
INSERT INTO `shopping_cart` VALUES (40,2,1,5,NULL,1,1,'2026-05-14 20:40:18','2026-05-14 21:11:42',1);
INSERT INTO `shopping_cart` VALUES (41,2,1,1,NULL,1,1,'2026-05-14 20:40:19','2026-05-14 21:11:42',1);
INSERT INTO `shopping_cart` VALUES (42,2,1,4,NULL,1,1,'2026-05-14 20:40:20','2026-05-14 21:11:42',1);
INSERT INTO `shopping_cart` VALUES (43,2,1,10,NULL,1,1,'2026-05-14 20:40:22','2026-05-14 21:11:42',1);
INSERT INTO `shopping_cart` VALUES (44,2,2,25,NULL,1,1,'2026-05-14 20:40:26','2026-05-14 21:11:42',1);
INSERT INTO `shopping_cart` VALUES (45,2,2,24,NULL,1,1,'2026-05-14 20:40:27','2026-05-14 21:11:42',1);
INSERT INTO `shopping_cart` VALUES (46,2,1,5,NULL,1,1,'2026-05-14 21:19:55','2026-05-14 21:20:03',1);
INSERT INTO `shopping_cart` VALUES (47,2,1,4,NULL,1,1,'2026-05-14 21:19:56','2026-05-14 21:20:03',1);
/*!40000 ALTER TABLE `shopping_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_info`
--

DROP TABLE IF EXISTS `student_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_info` (
  `student_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) NOT NULL COMMENT '关联系统用户ID',
  `student_no` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学号',
  `college` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '所属学院',
  `major` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '所属专业',
  `grade` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '年级',
  `dormitory` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '宿舍地址',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  UNIQUE KEY `uk_student_no` (`student_no`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学生详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_info`
--

LOCK TABLES `student_info` WRITE;
/*!40000 ALTER TABLE `student_info` DISABLE KEYS */;
INSERT INTO `student_info` VALUES (1,2,'2021001001','计算机学院','软件工程','2021级','东区3号楼503','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (2,3,'2021001002','计算机学院','计算机科学与技术','2021级','东区3号楼503','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (3,4,'2021001003','经济管理学院','工商管理','2021级','西区5号楼301','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (4,5,'2021001004','外国语学院','英语','2021级','西区5号楼302','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (5,6,'2021001005','机械工程学院','机械设计','2021级','东区4号楼201','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (6,12,'2021001006','计算机学院','信息安全','2021级','东区6号楼101','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (7,13,'2021001007','经济管理学院','市场营销','2021级','西区7号楼202','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (8,14,'2021001008','文学院','汉语言文学','2021级','东区8号楼303','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (9,15,'2021001009','理学院','数学与应用数学','2021级','西区9号楼404','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (10,16,'2021001010','计算机学院','物联网工程','2022级','东区10号楼505','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (11,17,'2021001011','机械工程学院','车辆工程','2022级','西区11号楼606','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (12,18,'2021001012','电气工程学院','电气工程','2022级','东区12号楼707','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (13,19,'2021001013','土木工程学院','土木工程','2022级','西区13号楼808','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (14,20,'2021001014','化学化工学院','应用化学','2022级','东区14号楼909','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (15,21,'2021001015','生命科学学院','生物科学','2023级','西区15号楼1010','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (16,22,'2021001016','美术学院','视觉传达设计','2023级','东区16号楼1111','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (17,23,'2021001017','音乐学院','音乐学','2023级','西区17号楼1212','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (18,24,'2021001018','体育学院','体育教育','2023级','东区18号楼1313','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (19,25,'2021001019','教育学院','教育技术学','2023级','西区19号楼1414','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (20,26,'2021001020','法学院','法学','2020级','东区20号楼1515','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (21,27,'2021001021','公共管理学院','行政管理','2020级','西区21号楼1616','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (22,28,'2021001022','新闻与传播学院','新闻学','2020级','东区22号楼1717','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (23,29,'2021001023','旅游学院','旅游管理','2020级','西区23号楼1818','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (24,30,'2021001024','材料科学与工程学院','材料科学','2020级','东区24号楼1919','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (25,31,'2021001025','航空航天学院','航空航天工程','2024级','西区25号楼2020','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (26,32,'2021001026','光子与量子技术学院','光电信息科学','2024级','东区26号楼2121','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (27,33,'2021001027','人工智能学院','人工智能','2024级','西区27号楼2222','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (28,34,'2021001028','网络空间安全学院','网络空间安全','2024级','东区28号楼2323','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (29,35,'2021001029','大数据与人工智能学院','数据科学与大数据技术','2024级','西区29号楼2424','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `student_info` VALUES (30,36,'2021001030','马克思主义学院','思想政治教育','2024级','东区30号楼2525','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
/*!40000 ALTER TABLE `student_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键名',
  `config_value` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键值',
  `config_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置名称',
  `config_desc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '配置描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'order.expire.minutes','30','订单支付过期时间（分钟）','用户创建订单后需在该时间内完成支付，否则订单自动取消','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_config` VALUES (2,'file.upload.path','/data/upload','文件上传路径','图片等文件的服务器存储路径','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_config` VALUES (3,'file.upload.max.size','10485760','文件上传最大大小（字节）','默认10MB','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_config` VALUES (4,'system.name','校园点餐系统','系统名称','平台系统名称','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_config` VALUES (5,'system.notice','你好','系统公告','平台系统公告内容','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_config` VALUES (6,'max.delivery.fee','10','配送费上限','订单配送费上限金额','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色唯一ID',
  `role_code` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色编码：STUDENT-学生 MERCHANT-商家 ADMIN-管理员',
  `role_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_desc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '角色描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删除 1-已删除',
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统角色表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'STUDENT','学生','校园点餐系统学生用户','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_role` VALUES (2,'MERCHANT','商家','校园点餐系统商家用户','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_role` VALUES (3,'ADMIN','管理员','校园点餐系统平台管理员','2026-05-05 17:16:53','2026-05-05 17:16:53',0);
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户唯一ID',
  `user_no` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录账号（学生学号/商家账号/管理员账号）',
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '加密存储密码（BCrypt加密）',
  `phone` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户头像URL',
  `user_name` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户姓名',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '账号状态：0-禁用 1-正常',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删除 1-已删除',
  `user_type` int(11) DEFAULT '1' COMMENT '用户类型：1-学生 2-商家 3-管理员',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_user_no` (`user_no`),
  UNIQUE KEY `uk_phone` (`phone`),
  KEY `idx_status` (`status`),
  KEY `idx_is_deleted` (`is_deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'admin','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138000','','系统管理员',1,'2026-05-16 03:56:35','2026-05-05 17:16:53','2026-05-14 19:27:25',0,3);
INSERT INTO `sys_user` VALUES (2,'2021001001','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138001','https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260516/cf7666794247407e935fb1fd245145af.png','张三',1,'2026-05-16 03:55:46','2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (3,'2021001002','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138002','','李四',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (4,'2021001003','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138003','','王五',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (5,'2021001004','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138004','','赵六',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (6,'2021001005','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138005','','钱七',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (7,'merchant01','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13900139001','','张老板',1,'2026-05-16 03:57:10','2026-05-05 17:16:53','2026-05-05 17:17:02',0,2);
INSERT INTO `sys_user` VALUES (8,'merchant02','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13900139002','','李老板',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,2);
INSERT INTO `sys_user` VALUES (9,'merchant03','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13900139003','','王老板',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,2);
INSERT INTO `sys_user` VALUES (10,'merchant04','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13900139004','','赵老板',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,2);
INSERT INTO `sys_user` VALUES (11,'merchant05','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13900139005','','刘老板',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,2);
INSERT INTO `sys_user` VALUES (12,'2021001006','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138006','','孙八',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (13,'2021001007','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138007','','周九',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (14,'2021001008','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138008','','吴十',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (15,'2021001009','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138009','','郑十一',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (16,'2021001010','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138010','','冯十二',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (17,'2021001011','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138011','','陈十三',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (18,'2021001012','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138012','','褚十四',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (19,'2021001013','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138013','','卫十五',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (20,'2021001014','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138014','','蒋十六',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (21,'2021001015','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138015','','沈十七',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (22,'2021001016','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138016','','韩十八',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (23,'2021001017','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138017','','杨十九',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (24,'2021001018','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138018','','朱二十',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (25,'2021001019','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138019','','秦二一',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (26,'2021001020','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138020','','尤二二',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (27,'2021001021','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138021','','许二三',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (28,'2021001022','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138022','','何二四',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (29,'2021001023','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138023','','吕二五',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (30,'2021001024','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138024','','施二六',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (31,'2021001025','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138025','','张二七',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (32,'2021001026','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138026','','孔二八',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (33,'2021001027','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138027','','曹二九',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (34,'2021001028','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138028','','严三十',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (35,'2021001029','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138029','','华三十一',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
INSERT INTO `sys_user` VALUES (36,'2021001030','$2a$10$0xEvtnj2DaccPqwRPbB.3u9tUAo0IPRfs9QMV8giJYXUl/9fp9dyi','13800138030','','金三二',1,NULL,'2026-05-05 17:16:53','2026-05-05 17:17:02',0,1);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户 ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色 ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`,`role_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1,3,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (2,2,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (3,3,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (4,4,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (5,5,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (6,6,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (7,12,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (8,13,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (9,14,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (10,15,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (11,16,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (12,17,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (13,18,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (14,19,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (15,20,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (16,21,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (17,22,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (18,23,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (19,24,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (20,25,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (21,26,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (22,27,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (23,28,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (24,29,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (25,30,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (26,31,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (27,32,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (28,33,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (29,34,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (30,35,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (31,36,1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (32,7,2,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (33,8,2,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (34,9,2,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (35,10,2,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `sys_user_role` VALUES (36,11,2,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_address`
--

DROP TABLE IF EXISTS `user_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_address` (
  `address_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` bigint(20) NOT NULL COMMENT '关联用户ID',
  `receiver_name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人手机号',
  `campus_area` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '校区/园区',
  `address_detail` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '详细地址（如：XX宿舍楼XX室）',
  `is_default` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否默认地址：0-否 1-是',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`address_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_default` (`is_default`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户收货地址表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_address`
--

LOCK TABLES `user_address` WRITE;
/*!40000 ALTER TABLE `user_address` DISABLE KEYS */;
INSERT INTO `user_address` VALUES (1,2,'张三','13800138001','东校区','3号楼502室',1,'2026-05-05 17:16:53','2026-05-14 14:54:19',0);
INSERT INTO `user_address` VALUES (2,2,'张三','13800138001','东校区','图书馆自习室',0,'2026-05-05 17:16:53','2026-05-10 00:13:34',0);
INSERT INTO `user_address` VALUES (3,3,'李四','13800138002','东校区','3号楼503室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (4,4,'王五','13800138003','西校区','5号楼301室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (5,5,'赵六','13800138004','西校区','5号楼302室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (6,6,'钱七','13800138005','东校区','4号楼201室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (7,12,'孙八','13800138006','东校区','6号楼101室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (8,13,'周九','13800138007','西校区','7号楼202室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (9,14,'吴十','13800138008','东校区','8号楼303室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (10,15,'郑十一','13800138009','西校区','9号楼404室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (11,16,'冯十二','13800138010','东校区','10号楼505室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (12,17,'陈十三','13800138011','西校区','11号楼606室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (13,18,'褚十四','13800138012','东校区','12号楼707室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (14,19,'卫十五','13800138013','西校区','13号楼808室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (15,20,'蒋十六','13800138014','东校区','14号楼909室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (16,21,'沈十七','13800138015','西校区','15号楼1010室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (17,22,'韩十八','13800138016','东校区','16号楼1111室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (18,23,'杨十九','13800138017','西校区','17号楼1212室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (19,24,'朱二十','13800138018','东校区','18号楼1313室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (20,25,'秦二一','13800138019','西校区','19号楼1414室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (21,26,'尤二二','13800138020','东校区','20号楼1515室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (22,27,'许二三','13800138021','西校区','21号楼1616室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (23,28,'何二四','13800138022','东校区','22号楼1717室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (24,29,'吕二五','13800138023','西校区','23号楼1818室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (25,30,'施二六','13800138024','东校区','24号楼1919室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (26,31,'张二七','13800138025','西校区','25号楼2020室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (27,32,'孔二八','13800138026','东校区','26号楼2121室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (28,33,'曹二九','13800138027','西校区','27号楼2222室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (29,34,'严三十','13800138028','东校区','28号楼2323室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (30,35,'华三十一','13800138029','西校区','29号楼2424室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (31,36,'金三二','13800138030','东校区','30号楼2525室',1,'2026-05-05 17:16:53','2026-05-05 17:16:53',0);
INSERT INTO `user_address` VALUES (32,2,'小明','13234345656','东区','东校区',0,'2026-05-10 00:02:12','2026-05-10 00:11:08',1);
INSERT INTO `user_address` VALUES (33,2,'小明','13224343456','东区','东校区',0,'2026-05-10 01:38:26','2026-05-14 14:54:19',0);
/*!40000 ALTER TABLE `user_address` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-16  4:23:32
