-- 评价功能相关表

-- 订单评价表
DROP TABLE IF EXISTS `order_review`;
CREATE TABLE `order_review` (
  `review_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `order_id` bigint(20) NOT NULL COMMENT '订单ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺ID',
  `service_rating` int(11) NOT NULL COMMENT '服务态度评分（1-5星）',
  `delivery_rating` int(11) NOT NULL COMMENT '配送速度评分（1-5星）',
  `product_rating` int(11) NOT NULL COMMENT '商品满意度评分（1-5星）',
  `overall_rating` decimal(3,1) NOT NULL COMMENT '综合评分',
  `review_text` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文字评价',
  `is_anonymous` tinyint(4) DEFAULT '0' COMMENT '是否匿名：0-否 1-是',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`review_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_shop_id` (`shop_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单评价表';

-- 评价回复表
DROP TABLE IF EXISTS `order_review_reply`;
CREATE TABLE `order_review_reply` (
  `reply_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '回复ID',
  `review_id` bigint(20) NOT NULL COMMENT '评价ID',
  `reply_user_id` bigint(20) NOT NULL COMMENT '回复用户ID',
  `reply_text` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '回复内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`reply_id`),
  KEY `idx_review_id` (`review_id`),
  KEY `idx_reply_user_id` (`reply_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评价回复表';

-- 为order_info表添加是否已评价字段
ALTER TABLE `order_info` ADD COLUMN `is_reviewed` tinyint(4) DEFAULT '0' COMMENT '是否已评价：0-否 1-是' AFTER `is_deleted`;
