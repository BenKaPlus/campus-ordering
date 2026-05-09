-- =============================================
-- 校园点餐系统数据库建表脚本
-- 数据库引擎：MySQL 5.7+
-- 字符集：utf8mb4
-- 存储引擎：InnoDB
-- =============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS campus_ordering_system 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE campus_ordering_system;

-- =============================================
-- 1. 权限与用户核心表
-- =============================================

-- 1.1 系统角色表
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role (
  role_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '角色唯一ID',
  role_code VARCHAR(32) NOT NULL COMMENT '角色编码：STUDENT-学生 MERCHANT-商户 ADMIN-管理员',
  role_name VARCHAR(32) NOT NULL COMMENT '角色名称',
  role_desc VARCHAR(255) DEFAULT '' COMMENT '角色描述',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除 1-已删除',
  PRIMARY KEY (role_id),
  UNIQUE KEY uk_role_code (role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统角色表';

-- 1.2 系统菜单权限表
DROP TABLE IF EXISTS sys_menu;
CREATE TABLE sys_menu (
  menu_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '菜单/权限ID',
  parent_id BIGINT NOT NULL DEFAULT 0 COMMENT '上级菜单ID，顶级菜单为0',
  menu_name VARCHAR(64) NOT NULL COMMENT '菜单/权限名称',
  permission VARCHAR(128) DEFAULT '' COMMENT '权限标识（如：merchant:product:add）',
  menu_type TINYINT NOT NULL DEFAULT 1 COMMENT '类型：0-目录 1-菜单 2-按钮',
  path VARCHAR(255) DEFAULT '' COMMENT '路由路径',
  icon VARCHAR(128) DEFAULT '' COMMENT '菜单图标',
  sort INT NOT NULL DEFAULT 0 COMMENT '排序号',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (menu_id),
  UNIQUE KEY uk_permission (permission),
  KEY idx_parent_id (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统菜单权限表';

-- 1.3 系统用户表
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user (
  user_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户唯一ID',
  user_no VARCHAR(64) NOT NULL COMMENT '登录账号（学生学号/商户账号/管理员账号）',
  password VARCHAR(128) NOT NULL COMMENT '加密存储密码（BCrypt加密）',
  phone VARCHAR(11) NOT NULL COMMENT '手机号码',
  avatar VARCHAR(255) DEFAULT '' COMMENT '用户头像URL',
  user_name VARCHAR(32) DEFAULT '' COMMENT '用户姓名',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '账号状态：0-禁用 1-正常',
  last_login_time DATETIME DEFAULT NULL COMMENT '最后登录时间',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除 1-已删除',
  PRIMARY KEY (user_id),
  UNIQUE KEY uk_user_no (user_no),
  UNIQUE KEY uk_phone (phone),
  KEY idx_status (status),
  KEY idx_is_deleted (is_deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统用户表';

-- 1.4 用户角色关联表
DROP TABLE IF EXISTS sys_user_role;
CREATE TABLE sys_user_role (
  id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  user_id BIGINT NOT NULL COMMENT '用户 ID',
  role_id BIGINT NOT NULL COMMENT '角色 ID',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (id),
  UNIQUE KEY uk_user_role (user_id, role_id),
  KEY idx_user_id (user_id),
  KEY idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- 1.5 角色菜单关联表
DROP TABLE IF EXISTS sys_role_menu;
CREATE TABLE sys_role_menu (
  id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  role_id BIGINT NOT NULL COMMENT '角色ID',
  menu_id BIGINT NOT NULL COMMENT '菜单ID',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (id),
  UNIQUE KEY uk_role_menu (role_id, menu_id),
  KEY idx_role_id (role_id),
  KEY idx_menu_id (menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色菜单关联表';

-- 1.6 操作日志表
DROP TABLE IF EXISTS sys_operation_log;
CREATE TABLE sys_operation_log (
  log_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  user_id BIGINT DEFAULT NULL COMMENT '操作用户ID',
  user_no VARCHAR(64) DEFAULT '' COMMENT '操作用户账号',
  operation_module VARCHAR(64) NOT NULL COMMENT '操作模块（如：商品管理、订单管理）',
  operation_type VARCHAR(32) NOT NULL COMMENT '操作类型（如：新增、编辑、删除、查询）',
  operation_desc VARCHAR(512) DEFAULT '' COMMENT '操作描述',
  request_method VARCHAR(16) NOT NULL COMMENT '请求方法（GET/POST/PUT/DELETE）',
  request_url VARCHAR(255) NOT NULL COMMENT '请求URL',
  request_params TEXT DEFAULT NULL COMMENT '请求参数',
  response_result TEXT DEFAULT NULL COMMENT '响应结果',
  ip_address VARCHAR(64) DEFAULT '' COMMENT '操作IP地址',
  operation_status TINYINT NOT NULL DEFAULT 1 COMMENT '操作状态：0-失败 1-成功',
  error_msg TEXT DEFAULT NULL COMMENT '错误信息',
  operation_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  cost_time BIGINT NOT NULL DEFAULT 0 COMMENT '耗时（毫秒）',
  PRIMARY KEY (log_id),
  KEY idx_user_id (user_id),
  KEY idx_operation_time (operation_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- =============================================
-- 2. 学生与地址相关表
-- =============================================

-- 2.1 学生详细信息表
DROP TABLE IF EXISTS student_info;
CREATE TABLE student_info (
  student_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  user_id BIGINT NOT NULL COMMENT '关联系统用户ID',
  student_no VARCHAR(32) NOT NULL COMMENT '学号',
  college VARCHAR(128) DEFAULT '' COMMENT '所属学院',
  major VARCHAR(128) DEFAULT '' COMMENT '所属专业',
  grade VARCHAR(32) DEFAULT '' COMMENT '年级',
  dormitory VARCHAR(128) DEFAULT '' COMMENT '宿舍地址',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (student_id),
  UNIQUE KEY uk_user_id (user_id),
  UNIQUE KEY uk_student_no (student_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学生详细信息表';

-- 2.2 用户收货地址表
DROP TABLE IF EXISTS user_address;
CREATE TABLE user_address (
  address_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  user_id BIGINT NOT NULL COMMENT '关联用户ID',
  receiver_name VARCHAR(32) NOT NULL COMMENT '收货人姓名',
  receiver_phone VARCHAR(11) NOT NULL COMMENT '收货人手机号',
  campus_area VARCHAR(64) NOT NULL COMMENT '校区/园区',
  address_detail VARCHAR(255) NOT NULL COMMENT '详细地址（如：XX宿舍楼X号）',
  is_default TINYINT NOT NULL DEFAULT 0 COMMENT '是否默认地址：0-否 1-是',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (address_id),
  KEY idx_user_id (user_id),
  KEY idx_is_default (is_default)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户收货地址表';

-- =============================================
-- 3. 商户与店铺相关表
-- =============================================

-- 3.1 店铺分类表
DROP TABLE IF EXISTS shop_category;
CREATE TABLE shop_category (
  category_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  category_name VARCHAR(32) NOT NULL COMMENT '分类名称（如：快餐、火锅、甜点）',
  category_icon VARCHAR(255) DEFAULT '' COMMENT '分类图标URL',
  sort INT NOT NULL DEFAULT 0 COMMENT '排序号',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (category_id),
  UNIQUE KEY uk_category_name (category_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='店铺分类表';

-- 3.2 商户店铺信息表
DROP TABLE IF EXISTS shop_info;
CREATE TABLE shop_info (
  shop_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '店铺ID',
  merchant_user_id BIGINT NOT NULL COMMENT '关联商户用户ID',
  shop_name VARCHAR(128) NOT NULL COMMENT '店铺名称',
  shop_logo VARCHAR(255) NOT NULL DEFAULT '' COMMENT '店铺LOGO URL',
  shop_cover VARCHAR(255) DEFAULT '' COMMENT '店铺封面图URL',
  shop_category_id BIGINT NOT NULL COMMENT '店铺分类ID',
  business_license VARCHAR(255) NOT NULL DEFAULT '' COMMENT '营业执照URL',
  food_license VARCHAR(255) NOT NULL DEFAULT '' COMMENT '食品经营许可证URL',
  shop_desc VARCHAR(512) DEFAULT '' COMMENT '店铺简介',
  business_hours VARCHAR(128) NOT NULL DEFAULT '' COMMENT '营业时间（如：10:00-22:00）',
  contact_phone VARCHAR(11) NOT NULL COMMENT '店铺联系电话',
  shop_address VARCHAR(255) NOT NULL COMMENT '店铺地址（校内位置）',
  delivery_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '配送费',
  min_order_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '起送金额',
  shop_status TINYINT NOT NULL DEFAULT 0 COMMENT '店铺状态：0-待审核 1-营业中 2-已打烊 3-审核退回 4-已关闭',
  audit_status TINYINT NOT NULL DEFAULT 0 COMMENT '审核状态：0-待审核 1-审核通过 2-审核退回',
  audit_remark VARCHAR(255) DEFAULT '' COMMENT '审核备注',
  monthly_sales INT NOT NULL DEFAULT 0 COMMENT '月销量',
  shop_score DECIMAL(2,1) NOT NULL DEFAULT 5.0 COMMENT '店铺评分（满分5.0）',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (shop_id),
  UNIQUE KEY uk_merchant_user_id (merchant_user_id),
  KEY idx_shop_category_id (shop_category_id),
  KEY idx_shop_status (shop_status),
  KEY idx_audit_status (audit_status),
  KEY idx_shop_score (shop_score),
  KEY idx_shop_name (shop_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商户店铺信息表';

-- =============================================
-- 4. 商品相关表
-- =============================================

-- 4.1 商品分类表
DROP TABLE IF EXISTS product_category;
CREATE TABLE product_category (
  category_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  shop_id BIGINT NOT NULL COMMENT '所属店铺ID',
  category_name VARCHAR(32) NOT NULL COMMENT '分类名称（如：主食、小吃、饮料）',
  sort INT NOT NULL DEFAULT 0 COMMENT '排序号',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (category_id),
  UNIQUE KEY uk_shop_category (shop_id, category_name),
  KEY idx_shop_id (shop_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品分类表';

-- 4.2 商品信息表
DROP TABLE IF EXISTS product_info;
CREATE TABLE product_info (
  product_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  shop_id BIGINT NOT NULL COMMENT '所属店铺ID',
  category_id BIGINT NOT NULL COMMENT '所属商品分类ID',
  product_name VARCHAR(128) NOT NULL COMMENT '商品名称',
  product_image VARCHAR(255) NOT NULL DEFAULT '' COMMENT '商品主图URL',
  product_images TEXT DEFAULT NULL COMMENT '商品附图URL数组（JSON格式）',
  product_desc VARCHAR(512) DEFAULT '' COMMENT '商品描述',
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '商品售价',
  original_price DECIMAL(10,2) DEFAULT 0.00 COMMENT '商品原价',
  unit VARCHAR(16) NOT NULL DEFAULT '份' COMMENT '商品单位（份、碗、个等）',
  monthly_sales INT NOT NULL DEFAULT 0 COMMENT '月销量',
  product_status TINYINT NOT NULL DEFAULT 1 COMMENT '商品状态：0-下架 1-上架',
  is_hot TINYINT NOT NULL DEFAULT 0 COMMENT '是否热销：0-否 1-是',
  is_recommend TINYINT NOT NULL DEFAULT 0 COMMENT '是否推荐：0-否 1-是',
  sort INT NOT NULL DEFAULT 0 COMMENT '排序号',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (product_id),
  KEY idx_shop_id (shop_id),
  KEY idx_category_id (category_id),
  KEY idx_product_status (product_status),
  KEY idx_is_hot (is_hot),
  KEY idx_is_recommend (is_recommend),
  KEY idx_product_name (product_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品信息表';

-- 4.3 商品规格表
DROP TABLE IF EXISTS product_spec;
CREATE TABLE product_spec (
  spec_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '规格ID',
  product_id BIGINT NOT NULL COMMENT '所属商品ID',
  spec_name VARCHAR(64) NOT NULL COMMENT '规格名称（如：少辣、正常辣、大碗、小碗）',
  spec_price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '规格加价/售价',
  stock INT NOT NULL DEFAULT 0 COMMENT '规格库存',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (spec_id),
  KEY idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品规格表';

-- =============================================
-- 5. 购物车相关表
-- =============================================

-- 5.1 购物车表
DROP TABLE IF EXISTS shopping_cart;
CREATE TABLE shopping_cart (
  cart_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  user_id BIGINT NOT NULL COMMENT '所属用户ID',
  shop_id BIGINT NOT NULL COMMENT '所属店铺ID',
  product_id BIGINT NOT NULL COMMENT '商品ID',
  spec_id BIGINT DEFAULT NULL COMMENT '商品规格ID',
  product_num INT NOT NULL DEFAULT 1 COMMENT '商品数量',
  is_checked TINYINT NOT NULL DEFAULT 1 COMMENT '是否选中：0-未选中 1-选中',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (cart_id),
  KEY idx_user_id (user_id),
  KEY idx_shop_id (shop_id),
  KEY idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车表';

-- =============================================
-- 6. 订单核心相关表
-- =============================================

-- 6.1 订单主表
DROP TABLE IF EXISTS order_info;
CREATE TABLE order_info (
  order_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  order_no VARCHAR(32) NOT NULL COMMENT '订单编号（唯一，订单用）',
  user_id BIGINT NOT NULL COMMENT '下单用户ID',
  shop_id BIGINT NOT NULL COMMENT '所属店铺ID',
  receiver_name VARCHAR(32) NOT NULL COMMENT '收货人姓名',
  receiver_phone VARCHAR(11) NOT NULL COMMENT '收货人手机号',
  receiver_address VARCHAR(255) NOT NULL COMMENT '收货地址',
  total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '订单总金额',
  product_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '商品总金额',
  delivery_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '配送费',
  discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '优惠金额',
  pay_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '实付金额',
  pay_type TINYINT DEFAULT NULL COMMENT '支付方式：1-微信支付 2-支付宝支付',
  order_status TINYINT NOT NULL DEFAULT 0 COMMENT '订单状态：0-待支付 1-待接单 2-待备货 3-待出餐 4-配送中 5-已完成 6-已取消 7-退款中 8-已退款',
  pay_status TINYINT NOT NULL DEFAULT 0 COMMENT '支付状态：0-未支付 1-已支付 2-已退款',
  order_remark VARCHAR(255) DEFAULT '' COMMENT '订单备注',
  pay_time DATETIME DEFAULT NULL COMMENT '支付时间',
  accept_time DATETIME DEFAULT NULL COMMENT '商家接单时间',
  delivery_time DATETIME DEFAULT NULL COMMENT '出餐/配送时间',
  finish_time DATETIME DEFAULT NULL COMMENT '订单完成时间',
  cancel_time DATETIME DEFAULT NULL COMMENT '订单取消时间',
  cancel_reason VARCHAR(255) DEFAULT '' COMMENT '取消原因',
  expire_time DATETIME NOT NULL COMMENT '订单支付过期时间',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (order_id),
  UNIQUE KEY uk_order_no (order_no),
  KEY idx_user_id (user_id),
  KEY idx_shop_id (shop_id),
  KEY idx_pay_type (pay_type),
  KEY idx_order_status (order_status),
  KEY idx_pay_status (pay_status),
  KEY idx_expire_time (expire_time),
  KEY idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单主表';

-- 6.2 订单详情表
DROP TABLE IF EXISTS order_item;
CREATE TABLE order_item (
  item_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '详情ID',
  order_id BIGINT NOT NULL COMMENT '所属订单ID',
  order_no VARCHAR(32) NOT NULL COMMENT '订单编号',
  product_id BIGINT NOT NULL COMMENT '商品ID',
  product_name VARCHAR(128) NOT NULL COMMENT '商品名称',
  product_image VARCHAR(255) NOT NULL DEFAULT '' COMMENT '商品图片',
  spec_id BIGINT DEFAULT NULL COMMENT '规格ID',
  spec_name VARCHAR(64) DEFAULT '' COMMENT '规格名称',
  product_price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '商品单价',
  product_num INT NOT NULL DEFAULT 1 COMMENT '商品数量',
  total_price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '商品小计金额',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (item_id),
  KEY idx_order_id (order_id),
  KEY idx_order_no (order_no),
  KEY idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单详情表';

-- 6.3 订单状态流转日志表
DROP TABLE IF EXISTS order_status_log;
CREATE TABLE order_status_log (
  log_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  order_id BIGINT NOT NULL COMMENT '订单ID',
  order_no VARCHAR(32) NOT NULL COMMENT '订单编号',
  pre_status TINYINT DEFAULT NULL COMMENT '变更前状态',
  current_status TINYINT NOT NULL COMMENT '变更后状态',
  operation_type VARCHAR(32) NOT NULL COMMENT '操作类型（如：用户下单、商家接单、用户取消）',
  operation_user_id BIGINT NOT NULL COMMENT '操作人ID',
  operation_user_name VARCHAR(64) NOT NULL COMMENT '操作人姓名',
  operation_remark VARCHAR(255) DEFAULT '' COMMENT '操作备注',
  operation_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (log_id),
  KEY idx_order_id (order_id),
  KEY idx_order_no (order_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单状态流转日志表';

-- 6.4 订单退款申请表
DROP TABLE IF EXISTS order_refund;
CREATE TABLE order_refund (
  refund_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '退款申请ID',
  refund_no VARCHAR(32) NOT NULL COMMENT '退款编号（唯一，订单用）',
  order_id BIGINT NOT NULL COMMENT '所属订单ID',
  order_no VARCHAR(32) NOT NULL COMMENT '订单编号',
  user_id BIGINT NOT NULL COMMENT '申请人用户ID',
  shop_id BIGINT NOT NULL COMMENT '所属店铺ID',
  refund_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '申请退款金额',
  refund_reason VARCHAR(255) NOT NULL COMMENT '退款原因',
  refund_desc VARCHAR(512) DEFAULT '' COMMENT '退款说明',
  refund_images TEXT DEFAULT NULL COMMENT '退款举证图片URL数组（JSON格式）',
  refund_status TINYINT NOT NULL DEFAULT 0 COMMENT '退款状态：0-待审核 1-商家同意 2-商家拒绝 3-退款中 4-退款成功 5-退款失败',
  audit_time DATETIME DEFAULT NULL COMMENT '商家审核时间',
  audit_remark VARCHAR(255) DEFAULT '' COMMENT '审核备注',
  refund_time DATETIME DEFAULT NULL COMMENT '退款完成时间',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (refund_id),
  UNIQUE KEY uk_refund_no (refund_no),
  UNIQUE KEY uk_order_no (order_no),
  KEY idx_order_id (order_id),
  KEY idx_user_id (user_id),
  KEY idx_shop_id (shop_id),
  KEY idx_refund_status (refund_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单退款申请表';

-- =============================================
-- 7. 支付相关表
-- =============================================

-- 7.1 支付记录表
DROP TABLE IF EXISTS payment_info;
CREATE TABLE payment_info (
  payment_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '支付记录ID',
  out_trade_no VARCHAR(32) NOT NULL COMMENT '商户订单号（对应order_no）',
  transaction_id VARCHAR(64) DEFAULT '' COMMENT '第三方支付流水号',
  order_id BIGINT NOT NULL COMMENT '订单ID',
  user_id BIGINT NOT NULL COMMENT '支付用户ID',
  pay_type TINYINT NOT NULL COMMENT '支付方式：1-微信支付 2-支付宝支付',
  pay_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
  pay_status TINYINT NOT NULL DEFAULT 0 COMMENT '支付状态：0-待支付 1-支付成功 2-支付失败 3-已关闭 4-已退款',
  pay_time DATETIME DEFAULT NULL COMMENT '支付完成时间',
  callback_content TEXT DEFAULT NULL COMMENT '支付回调原始数据',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (payment_id),
  UNIQUE KEY uk_out_trade_no (out_trade_no),
  UNIQUE KEY uk_transaction_id (transaction_id),
  KEY idx_order_id (order_id),
  KEY idx_user_id (user_id),
  KEY idx_pay_type (pay_type),
  KEY idx_pay_status (pay_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付记录表';

-- 7.2 退款记录表
DROP TABLE IF EXISTS refund_info;
CREATE TABLE refund_info (
  id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  out_refund_no VARCHAR(32) NOT NULL COMMENT '商户退款单号（对应refund_no）',
  refund_id BIGINT NOT NULL COMMENT '退款申请ID',
  order_id BIGINT NOT NULL COMMENT '订单ID',
  out_trade_no VARCHAR(32) NOT NULL COMMENT '商户订单号',
  transaction_id VARCHAR(64) DEFAULT '' COMMENT '原支付流水号',
  refund_transaction_id VARCHAR(64) DEFAULT '' COMMENT '第三方退款流水号',
  refund_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '退款金额',
  refund_type TINYINT NOT NULL DEFAULT 1 COMMENT '退款渠道：1-微信退款 2-支付宝退款',
  refund_status TINYINT NOT NULL DEFAULT 0 COMMENT '退款状态：0-退款中 1-退款成功 2-退款失败',
  refund_time DATETIME DEFAULT NULL COMMENT '退款完成时间',
  callback_content TEXT DEFAULT NULL COMMENT '退款回调原始数据',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (id),
  UNIQUE KEY uk_out_refund_no (out_refund_no),
  UNIQUE KEY uk_refund_transaction_id (refund_transaction_id),
  KEY idx_refund_id (refund_id),
  KEY idx_order_id (order_id),
  KEY idx_out_trade_no (out_trade_no),
  KEY idx_refund_status (refund_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='退款记录表';

-- =============================================
-- 8. 消息与系统配置表
-- =============================================

-- 8.1 消息通知表
DROP TABLE IF EXISTS message_notice;
CREATE TABLE message_notice (
  message_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  receive_user_id BIGINT NOT NULL COMMENT '接收用户ID',
  send_user_id BIGINT DEFAULT 0 COMMENT '发送用户ID（系统发送为0）',
  message_type TINYINT NOT NULL COMMENT '消息类型：1-订单通知 2-系统通知 3-公告通知',
  message_title VARCHAR(128) NOT NULL COMMENT '消息标题',
  message_content VARCHAR(512) NOT NULL COMMENT '消息内容',
  relation_id BIGINT DEFAULT NULL COMMENT '关联ID（如订单ID、公告ID）',
  is_read TINYINT NOT NULL DEFAULT 0 COMMENT '是否已读：0-未读 1-已读',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (message_id),
  KEY idx_receive_user_id (receive_user_id),
  KEY idx_message_type (message_type),
  KEY idx_is_read (is_read),
  KEY idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息通知表';

-- 8.2 系统公告表
DROP TABLE IF EXISTS sys_announcement;
CREATE TABLE sys_announcement (
  announcement_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  announcement_title VARCHAR(128) NOT NULL COMMENT '公告标题',
  announcement_content TEXT NOT NULL COMMENT '公告内容',
  publisher_id BIGINT NOT NULL COMMENT '发布人ID',
  publisher_name VARCHAR(64) NOT NULL COMMENT '发布人姓名',
  is_top TINYINT NOT NULL DEFAULT 0 COMMENT '是否置顶：0-否 1-是',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-下架 1-发布',
  publish_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (announcement_id),
  KEY idx_is_top (is_top),
  KEY idx_status (status),
  KEY idx_publish_time (publish_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统公告表';

-- 8.3 系统参数配置表
DROP TABLE IF EXISTS sys_config;
CREATE TABLE sys_config (
  config_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  config_key VARCHAR(64) NOT NULL COMMENT '配置键名',
  config_value VARCHAR(512) NOT NULL COMMENT '配置键值',
  config_name VARCHAR(128) NOT NULL COMMENT '配置名称',
  config_desc VARCHAR(255) DEFAULT '' COMMENT '配置描述',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (config_id),
  UNIQUE KEY uk_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统参数配置表';

-- =============================================
-- 初始数据插入
-- =============================================

-- 插入初始角色数据
INSERT INTO sys_role (role_id, role_code, role_name, role_desc) VALUES
(1, 'STUDENT', '学生', '校园点餐系统学生用户'),
(2, 'MERCHANT', '商户', '校园点餐系统商户用户'),
(3, 'ADMIN', '管理员', '校园点餐系统后台管理员');

-- 插入初始店铺分类数据
INSERT INTO shop_category (category_id, category_name, category_icon, sort) VALUES
(1, '正餐', '', 1),
(2, '奶茶饮品', '', 2),
(3, '早餐', '', 3),
(4, '小吃零食', '', 4),
(5, '甜点', '', 5);

-- 插入初始系统配置数据
INSERT INTO sys_config (config_id, config_key, config_value, config_name, config_desc) VALUES
(1, 'order.expire.minutes', '30', '订单支付过期时间（分钟）', '用户创建订单后需在此时间内完成支付，否则订单自动取消'),
(2, 'file.upload.path', '/data/upload', '文件上传路径', '图片等文件的服务器存储路径'),
(3, 'file.upload.max.size', '10485760', '文件上传最大大小（字节）', '默认10MB'),
(4, 'system.name', '校园点餐系统', '系统名称', '后台系统名称'),
(5, 'system.notice', '', '系统公告', '后台系统公告内容'),
(6, 'max.delivery.fee', '10', '配送费上限', '订单配送费上限金额');

-- 插入初始管理员账号（密码：admin123，实际使用时请生成自己的BCrypt加密密码）
-- 注意：实际使用时请生成自己的BCrypt加密密码
INSERT INTO sys_user (user_id, user_no, password, phone, user_name, status) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138000', '系统管理员', 1);

-- 关联管理员角色
INSERT INTO sys_user_role (user_id, role_id) VALUES
(1, 3);

-- 1. 给sys_user 表添加 user_type 字段
ALTER TABLE sys_user ADD COLUMN user_type INT DEFAULT 1 COMMENT '用户类型：1-学生 2-商户 3-管理员';

-- 2. 创建商户入驻申请表
CREATE TABLE merchant_apply (
                                apply_id BIGINT PRIMARY KEY AUTO_INCREMENT,
                                user_id BIGINT NOT NULL COMMENT '申请人用户ID',
                                applicant_name VARCHAR(50) COMMENT '申请人姓名',
                                applicant_phone VARCHAR(11) COMMENT '申请人手机号',
                                applicant_id_card VARCHAR(18) COMMENT '申请人身份证号',
                                shop_name VARCHAR(100) NOT NULL COMMENT '店铺名称',
                                shop_description TEXT COMMENT '店铺描述',
                                shop_type INT COMMENT '店铺类型：1-正餐 2-小吃 3-饮品 4-水果 5-超市 6-其他',
                                delivery_fee DECIMAL(10,2) DEFAULT 0 COMMENT '预估配送费',
                                business_license VARCHAR(500) COMMENT '营业执照URL',
                                id_card_front VARCHAR(500) COMMENT '身份证正面URL',
                                id_card_back VARCHAR(500) COMMENT '身份证反面URL',
                                audit_status INT DEFAULT 0 COMMENT '审核状态：0-待审核 1-已通过 2-已拒绝',
                                audit_remark VARCHAR(500) COMMENT '审核意见',
                                audit_user_id BIGINT COMMENT '审核人ID',
                                audit_time DATETIME COMMENT '审核时间',
                                create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                                update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                is_deleted INT DEFAULT 0
);

-- =============================================
-- 更多测试数据插入
-- =============================================

-- 插入学生用户数据（密码都是student123）
INSERT INTO sys_user (user_id, user_no, password, phone, user_name, status, user_type) VALUES
(2, '2021001001', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138001', '张三', 1, 1),
(3, '2021001002', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138002', '李四', 1, 1),
(4, '2021001003', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138003', '王五', 1, 1),
(5, '2021001004', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138004', '赵六', 1, 1),
(6, '2021001005', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '孙七', 1, 1),
(12, '2021001006', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138006', '周八', 1, 1),
(13, '2021001007', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138007', '吴九', 1, 1),
(14, '2021001008', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138008', '郑十', 1, 1),
(15, '2021001009', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138009', '陈十一', 1, 1),
(16, '2021001010', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138010', '黄十二', 1, 1),
(17, '2021001011', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138011', '杨十三', 1, 1),
(18, '2021001012', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138012', '刘十四', 1, 1),
(19, '2021001013', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138013', '赵十五', 1, 1),
(20, '2021001014', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138014', '钱十六', 1, 1),
(21, '2021001015', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138015', '孙十七', 1, 1),
(22, '2021001016', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138016', '李十八', 1, 1),
(23, '2021001017', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138017', '周十九', 1, 1),
(24, '2021001018', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138018', '吴二十', 1, 1),
(25, '2021001019', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138019', '郑二十一', 1, 1),
(26, '2021001020', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138020', '黄二十二', 1, 1),
(27, '2021001021', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138021', '陈二十三', 1, 1),
(28, '2021001022', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138022', '杨二十四', 1, 1),
(29, '2021001023', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138023', '刘二十五', 1, 1),
(30, '2021001024', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138024', '赵二十六', 1, 1),
(31, '2021001025', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138025', '钱二十七', 1, 1),
(32, '2021001026', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138026', '孙二十八', 1, 1),
(33, '2021001027', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138027', '李二十九', 1, 1),
(34, '2021001028', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138028', '周三十', 1, 1),
(35, '2021001029', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138029', '吴三十一', 1, 1),
(36, '2021001030', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138030', '郑三十二', 1, 1);

-- 插入学生详细信息
INSERT INTO student_info (student_id, user_id, student_no, college, major, grade, dormitory) VALUES
(1, 2, '2021001001', '计算机学院', '软件工程', '2021级', '东区3号楼502'),
(2, 3, '2021001002', '计算机学院', '计算机科学与技术', '2021级', '东区3号楼503'),
(3, 4, '2021001003', '经济管理学院', '工商管理', '2021级', '西区5号楼301'),
(4, 5, '2021001004', '外国语学院', '英语', '2021级', '西区5号楼302'),
(5, 6, '2021001005', '机械工程学院', '机械设计', '2021级', '东区4号楼201'),
(6, 12, '2021001006', '计算机学院', '信息安全', '2021级', '东区6号楼101'),
(7, 13, '2021001007', '经济管理学院', '市场营销', '2021级', '西区7号楼202');

-- 插入收货地址数据
INSERT INTO user_address (address_id, user_id, receiver_name, receiver_phone, campus_area, address_detail, is_default) VALUES
(1, 2, '张三', '13800138001', '东区', '3号楼502宿舍', 1),
(2, 2, '张三', '13800138001', '西区', '图书馆门口', 0),
(3, 3, '李四', '13800138002', '东区', '3号楼503宿舍', 1),
(4, 4, '王五', '13800138003', '西区', '5号楼301宿舍', 1),
(5, 5, '赵六', '13800138004', '西区', '5号楼302宿舍', 1);

-- 插入商户用户数据（密码都是merchant123）
INSERT INTO sys_user (user_id, user_no, password, phone, user_name, status, user_type) VALUES
(7, 'merchant001', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13900139001', '张老板', 1, 2),
(8, 'merchant002', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13900139002', '李老板', 1, 2),
(9, 'merchant003', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13900139003', '王老板', 1, 2),
(10, 'merchant004', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13900139004', '赵老板', 1, 2),
(11, 'merchant005', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13900139005', '孙老板', 1, 2);

-- 关联商户角色
INSERT INTO sys_user_role (user_id, role_id) VALUES
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2);

-- 插入店铺信息
INSERT INTO shop_info (shop_id, merchant_user_id, shop_name, shop_logo, shop_category_id, business_hours, contact_phone, shop_address, delivery_fee, min_order_amount, shop_status, audit_status, monthly_sales, shop_score) VALUES
(1, 7, '美味餐厅', '', 1, '10:00-22:00', '13900139001', '东区食堂二楼', 2.00, 15.00, 1, 1, 1250, 4.8),
(2, 8, '奶茶小屋', '', 2, '09:00-23:00', '13900139002', '西区商业街A12', 3.00, 10.00, 1, 1, 2380, 4.9),
(3, 9, '早餐驿站', '', 3, '06:00-10:30', '13900139003', '东区食堂一楼', 1.00, 5.00, 1, 1, 890, 4.7),
(4, 10, '零食天地', '', 4, '08:00-22:00', '13900139004', '西区超市旁', 2.00, 20.00, 1, 1, 1560, 4.6),
(5, 11, '甜品工坊', '', 5, '11:00-21:00', '13900139005', '东区商业街B08', 3.00, 25.00, 1, 1, 980, 4.9);

-- 插入商品分类
INSERT INTO product_category (category_id, shop_id, category_name, sort) VALUES
(1, 1, '主食', 1),
(2, 1, '炒菜', 2),
(3, 1, '汤品', 3),
(4, 2, '奶茶', 1),
(5, 2, '果茶', 2),
(6, 2, '咖啡', 3),
(7, 3, '包子', 1),
(8, 3, '粥类', 2),
(9, 3, '油条豆浆', 3),
(10, 4, '膨化食品', 1),
(11, 4, '坚果炒货', 2),
(12, 5, '蛋糕', 1),
(13, 5, '冰淇淋', 2),
(14, 5, '布丁', 3);

-- 插入商品信息
INSERT INTO product_info (product_id, shop_id, category_id, product_name, product_image, product_desc, price, original_price, unit, monthly_sales, product_status, is_hot, is_recommend) VALUES
(1, 1, 1, '番茄炒蛋饭', '', '新鲜番茄搭配嫩滑炒蛋，香气扑鼻', 12.00, 15.00, '份', 320, 1, 1, 1),
(2, 1, 1, '红烧肉饭', '', '精选五花肉，肥而不腻', 18.00, 22.00, '份', 280, 1, 1, 1),
(3, 1, 1, '宫保鸡丁饭', '', '经典川菜，花生酥脆', 15.00, 18.00, '份', 250, 1, 1, 0),
(4, 1, 2, '蒜蓉西兰花', '', '清爽可口，营养健康', 10.00, 12.00, '份', 180, 1, 0, 0),
(5, 1, 2, '鱼香茄子', '', '酸甜微辣，下饭神器', 12.00, 14.00, '份', 220, 1, 0, 1),
(6, 1, 3, '紫菜蛋花汤', '', '清淡鲜美，老少皆宜', 5.00, 6.00, '份', 150, 1, 0, 0),
(7, 2, 4, '珍珠奶茶', '', 'Q弹珍珠，奶香浓郁', 12.00, 15.00, '杯', 580, 1, 1, 1),
(8, 2, 4, '芋泥波波奶茶', '', '香甜芋泥，口感细腻', 15.00, 18.00, '杯', 420, 1, 1, 1),
(9, 2, 5, '百香果绿茶', '', '清新果香，酸甜可口', 10.00, 12.00, '杯', 380, 1, 0, 1),
(10, 2, 5, '芒果冰沙', '', '新鲜芒果，清凉解暑', 16.00, 19.00, '杯', 320, 1, 1, 0),
(11, 2, 6, '美式咖啡', '', '醇香浓郁，提神醒脑', 18.00, 22.00, '杯', 250, 1, 0, 0),
(12, 3, 7, '猪肉包子', '', '鲜嫩多汁，口感松软', 2.50, 3.00, '个', 450, 1, 1, 1),
(13, 3, 7, '豆沙包子', '', '香甜细腻，老少皆宜', 2.00, 2.50, '个', 380, 1, 0, 0),
(14, 3, 8, '皮蛋瘦肉粥', '', '经典早餐，营养丰富', 6.00, 8.00, '碗', 320, 1, 1, 1),
(15, 3, 8, '小米粥', '', '养胃佳品，清淡可口', 4.00, 5.00, '碗', 280, 1, 0, 0),
(16, 3, 9, '油条', '', '酥脆可口，经典搭配', 2.00, 2.50, '根', 420, 1, 1, 0),
(17, 3, 9, '豆浆', '', '现磨豆浆，香浓可口', 3.00, 4.00, '杯', 520, 1, 1, 1),
(18, 4, 10, '薯片', '', '香脆可口，追剧必备', 8.00, 10.00, '包', 350, 1, 0, 1),
(19, 4, 10, '辣条', '', '麻辣鲜香，童年回忆', 5.00, 6.00, '包', 480, 1, 1, 1),
(20, 4, 11, '开心果', '', '营养丰富，颗颗饱满', 25.00, 30.00, '袋', 180, 1, 0, 0),
(21, 4, 11, '杏仁', '', '香脆可口，健康零食', 20.00, 24.00, '袋', 220, 1, 0, 1),
(22, 5, 12, '提拉米苏', '', '意大利经典甜品', 28.00, 35.00, '份', 150, 1, 1, 1),
(23, 5, 12, '草莓蛋糕', '', '新鲜草莓，香甜可口', 32.00, 38.00, '份', 180, 1, 1, 1),
(24, 5, 13, '香草冰淇淋', '', '浓郁奶香，丝滑口感', 12.00, 15.00, '球', 280, 1, 0, 0),
(25, 5, 13, '巧克力冰淇淋', '', '比利时巧克力，醇厚香浓', 14.00, 17.00, '球', 320, 1, 1, 1),
(26, 5, 14, '芒果布丁', '', '嫩滑爽口，果香四溢', 10.00, 12.00, '杯', 220, 1, 0, 1);

-- 插入商品规格
INSERT INTO product_spec (spec_id, product_id, spec_name, spec_price) VALUES
(1, 7, '大杯', 3.00),
(2, 7, '中杯', 0.00),
(3, 7, '小杯', -2.00),
(4, 8, '大杯', 3.00),
(5, 8, '中杯', 0.00),
(6, 9, '少糖', 0.00),
(7, 9, '正常糖', 0.00),
(8, 9, '多糖', 0.00),
(9, 16, '单根', 2.00),
(10, 16, '两根', 3.50),
(11, 24, '单球', 12.00),
(12, 24, '双球', 20.00),
(13, 24, '三球', 28.00);

-- 插入购物车数据
INSERT INTO shopping_cart (cart_id, user_id, shop_id, product_id, spec_id, product_num, is_checked) VALUES
(1, 2, 1, 1, NULL, 2, 1),
(2, 2, 1, 6, NULL, 1, 1),
(3, 2, 2, 7, 1, 1, 1),
(4, 3, 3, 12, NULL, 2, 1),
(5, 3, 3, 17, NULL, 1, 1),
(6, 4, 4, 18, NULL, 3, 1),
(7, 4, 5, 22, NULL, 1, 1);

-- =============================================
-- 订单测试数据
-- =============================================

-- 插入订单数据
INSERT INTO order_info (order_id, order_no, user_id, shop_id, receiver_name, receiver_phone, receiver_address, total_amount, product_amount, delivery_fee, discount_amount, pay_amount, pay_type, order_status, pay_status, expire_time) VALUES
(1, '20240115000001', 2, 1, '张三', '13800138001', '东区3号楼502宿舍', 31.00, 29.00, 2.00, 0.00, 31.00, 1, 5, 1, '2024-01-15 12:30:00'),
(2, '20240115000002', 3, 3, '李四', '13800138002', '东区3号楼503宿舍', 8.00, 7.00, 1.00, 0.00, 8.00, 1, 5, 1, '2024-01-15 08:30:00'),
(3, '20240115000003', 4, 2, '王五', '13800138003', '西区5号楼301宿舍', 18.00, 15.00, 3.00, 0.00, 18.00, 2, 5, 1, '20240115103000'),
(4, '20240115000004', 5, 5, '赵六', '13800138004', '西区5号楼302宿舍', 46.00, 43.00, 3.00, 0.00, 46.00, 1, 4, 1, '20240115193000'),
(5, '20240115000005', 2, 4, '张三', '13800138001', '东区3号楼502宿舍', 26.00, 24.00, 2.00, 0.00, 26.00, 1, 2, 1, '20240115143000');

-- 插入订单详情数据
INSERT INTO order_item (item_id, order_id, order_no, product_id, product_name, product_image, spec_id, spec_name, product_price, product_num, total_price) VALUES
(1, 1, '20240115000001', 1, '番茄炒蛋饭', '', NULL, '', 12.00, 2, 24.00),
(2, 1, '20240115000001', 5, '鱼香茄子', '', NULL, '', 12.00, 1, 12.00),
(3, 2, '20240115000002', 12, '猪肉包子', '', NULL, '', 2.50, 2, 5.00),
(4, 2, '20240115000002', 17, '豆浆', '', NULL, '', 3.00, 1, 3.00),
(5, 3, '20240115000003', 8, '芋泥波波奶茶', '', 1, '大杯', 18.00, 1, 18.00),
(6, 4, '20240115000004', 22, '提拉米苏', '', NULL, '', 28.00, 1, 28.00),
(7, 4, '20240115000004', 25, '巧克力冰淇淋', '', 11, '单球', 14.00, 1, 14.00),
(8, 5, '20240115000005', 18, '薯片', '', NULL, '', 8.00, 3, 24.00);