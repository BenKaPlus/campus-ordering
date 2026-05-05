-- =============================================
-- 鏍″洯鐐归绯荤粺鏁版嵁搴撳缓搴撳缓琛ㄨ剼鏈?
-- 鏁版嵁搴撶増鏈細MySQL 5.7+
-- 瀛楃闆嗭細utf8mb4
-- 瀛樺偍寮曟搸锛欼nnoDB
-- =============================================

-- 鍒涘缓鏁版嵁搴?
CREATE DATABASE IF NOT EXISTS campus_ordering_system 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 浣跨敤鏁版嵁搴?
USE campus_ordering_system;

-- =============================================
-- 1. 鏉冮檺涓庣敤鎴锋牳蹇冭〃
-- =============================================

-- 1.1 绯荤粺瑙掕壊琛?
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role (
  role_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '瑙掕壊鍞竴ID',
  role_code VARCHAR(32) NOT NULL COMMENT '瑙掕壊缂栫爜锛歋TUDENT-瀛︾敓 MERCHANT-鍟嗗 ADMIN-绠＄悊鍛?,
  role_name VARCHAR(32) NOT NULL COMMENT '瑙掕壊鍚嶇О',
  role_desc VARCHAR(255) DEFAULT '' COMMENT '瑙掕壊鎻忚堪',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎锛?-鏈垹闄?1-宸插垹闄?,
  PRIMARY KEY (role_id),
  UNIQUE KEY uk_role_code (role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='绯荤粺瑙掕壊琛?;

-- 1.2 绯荤粺鑿滃崟鏉冮檺琛?
DROP TABLE IF EXISTS sys_menu;
CREATE TABLE sys_menu (
  menu_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '鑿滃崟/鏉冮檺ID',
  parent_id BIGINT NOT NULL DEFAULT 0 COMMENT '鐖惰彍鍗旾D锛岄《绾ц彍鍗曚负0',
  menu_name VARCHAR(64) NOT NULL COMMENT '鑿滃崟/鏉冮檺鍚嶇О',
  permission VARCHAR(128) DEFAULT '' COMMENT '鏉冮檺鏍囪瘑锛堝锛歮erchant:product:add锛?,
  menu_type TINYINT NOT NULL DEFAULT 1 COMMENT '绫诲瀷锛?-鐩綍 1-鑿滃崟 2-鎸夐挳',
  path VARCHAR(255) DEFAULT '' COMMENT '璺敱璺緞',
  icon VARCHAR(128) DEFAULT '' COMMENT '鑿滃崟鍥炬爣',
  sort INT NOT NULL DEFAULT 0 COMMENT '鎺掑簭鍙?,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (menu_id),
  UNIQUE KEY uk_permission (permission),
  KEY idx_parent_id (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='绯荤粺鑿滃崟鏉冮檺琛?;

-- 1.3 绯荤粺鐢ㄦ埛琛?
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user (
  user_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '鐢ㄦ埛鍞竴ID',
  user_no VARCHAR(64) NOT NULL COMMENT '鐧诲綍璐﹀彿锛堝鐢熷鍙?鍟嗗璐﹀彿/绠＄悊鍛樿处鍙凤級',
  password VARCHAR(128) NOT NULL COMMENT '鍔犲瘑瀛樺偍瀵嗙爜锛圔Crypt鍔犲瘑锛?,
  phone VARCHAR(11) NOT NULL COMMENT '鎵嬫満鍙?,
  avatar VARCHAR(255) DEFAULT '' COMMENT '鐢ㄦ埛澶村儚URL',
  user_name VARCHAR(32) DEFAULT '' COMMENT '鐢ㄦ埛濮撳悕',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '璐﹀彿鐘舵€侊細0-绂佺敤 1-姝ｅ父',
  last_login_time DATETIME DEFAULT NULL COMMENT '鏈€鍚庣櫥褰曟椂闂?,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎锛?-鏈垹闄?1-宸插垹闄?,
  PRIMARY KEY (user_id),
  UNIQUE KEY uk_user_no (user_no),
  UNIQUE KEY uk_phone (phone),
  KEY idx_status (status),
  KEY idx_is_deleted (is_deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='绯荤粺鐢ㄦ埛琛?;

-- 1.4 鐢ㄦ埛瑙掕壊鍏宠仈琛?
DROP TABLE IF EXISTS sys_user_role;
CREATE TABLE sys_user_role (
  id BIGINT NOT NULL AUTO_INCREMENT COMMENT '涓婚敭 ID',
  user_id BIGINT NOT NULL COMMENT '鐢ㄦ埛 ID',
  role_id BIGINT NOT NULL COMMENT '瑙掕壊 ID',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (id),
  UNIQUE KEY uk_user_role (user_id, role_id),
  KEY idx_user_id (user_id),
  KEY idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='鐢ㄦ埛瑙掕壊鍏宠仈琛?;

-- 1.5 瑙掕壊鑿滃崟鍏宠仈琛?
DROP TABLE IF EXISTS sys_role_menu;
CREATE TABLE sys_role_menu (
  id BIGINT NOT NULL AUTO_INCREMENT COMMENT '涓婚敭ID',
  role_id BIGINT NOT NULL COMMENT '瑙掕壊ID',
  menu_id BIGINT NOT NULL COMMENT '鑿滃崟ID',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (id),
  UNIQUE KEY uk_role_menu (role_id, menu_id),
  KEY idx_role_id (role_id),
  KEY idx_menu_id (menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='瑙掕壊鑿滃崟鍏宠仈琛?;

-- 1.6 鎿嶄綔鏃ュ織琛?
DROP TABLE IF EXISTS sys_operation_log;
CREATE TABLE sys_operation_log (
  log_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '鏃ュ織ID',
  user_id BIGINT DEFAULT NULL COMMENT '鎿嶄綔鐢ㄦ埛ID',
  user_no VARCHAR(64) DEFAULT '' COMMENT '鎿嶄綔鐢ㄦ埛璐﹀彿',
  operation_module VARCHAR(64) NOT NULL COMMENT '鎿嶄綔妯″潡锛堝锛氬晢鍝佺鐞嗐€佽鍗曠鐞嗭級',
  operation_type VARCHAR(32) NOT NULL COMMENT '鎿嶄綔绫诲瀷锛堝锛氭柊澧炪€佺紪杈戙€佸垹闄ゃ€佹煡璇級',
  operation_desc VARCHAR(512) DEFAULT '' COMMENT '鎿嶄綔鎻忚堪',
  request_method VARCHAR(16) NOT NULL COMMENT '璇锋眰鏂瑰紡锛圙ET/POST/PUT/DELETE锛?,
  request_url VARCHAR(255) NOT NULL COMMENT '璇锋眰URL',
  request_params TEXT DEFAULT NULL COMMENT '璇锋眰鍙傛暟',
  response_result TEXT DEFAULT NULL COMMENT '鍝嶅簲缁撴灉',
  ip_address VARCHAR(64) DEFAULT '' COMMENT '鎿嶄綔IP鍦板潃',
  operation_status TINYINT NOT NULL DEFAULT 1 COMMENT '鎿嶄綔鐘舵€侊細0-澶辫触 1-鎴愬姛',
  error_msg TEXT DEFAULT NULL COMMENT '閿欒淇℃伅',
  operation_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鎿嶄綔鏃堕棿',
  cost_time BIGINT NOT NULL DEFAULT 0 COMMENT '鑰楁椂锛堟绉掞級',
  PRIMARY KEY (log_id),
  KEY idx_user_id (user_id),
  KEY idx_operation_time (operation_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='鎿嶄綔鏃ュ織琛?;

-- =============================================
-- 2. 瀛︾敓涓庡湴鍧€鐩稿叧琛?
-- =============================================

-- 2.1 瀛︾敓璇︾粏淇℃伅琛?
DROP TABLE IF EXISTS student_info;
CREATE TABLE student_info (
  student_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '涓婚敭ID',
  user_id BIGINT NOT NULL COMMENT '鍏宠仈绯荤粺鐢ㄦ埛ID',
  student_no VARCHAR(32) NOT NULL COMMENT '瀛﹀彿',
  college VARCHAR(128) DEFAULT '' COMMENT '鎵€灞炲闄?,
  major VARCHAR(128) DEFAULT '' COMMENT '鎵€灞炰笓涓?,
  grade VARCHAR(32) DEFAULT '' COMMENT '骞寸骇',
  dormitory VARCHAR(128) DEFAULT '' COMMENT '瀹胯垗鍦板潃',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (student_id),
  UNIQUE KEY uk_user_id (user_id),
  UNIQUE KEY uk_student_no (student_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='瀛︾敓璇︾粏淇℃伅琛?;

-- 2.2 鐢ㄦ埛鏀惰揣鍦板潃琛?
DROP TABLE IF EXISTS user_address;
CREATE TABLE user_address (
  address_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '鍦板潃ID',
  user_id BIGINT NOT NULL COMMENT '鍏宠仈鐢ㄦ埛ID',
  receiver_name VARCHAR(32) NOT NULL COMMENT '鏀惰揣浜哄鍚?,
  receiver_phone VARCHAR(11) NOT NULL COMMENT '鏀惰揣浜烘墜鏈哄彿',
  campus_area VARCHAR(64) NOT NULL COMMENT '鏍″尯/鍥尯',
  address_detail VARCHAR(255) NOT NULL COMMENT '璇︾粏鍦板潃锛堝锛歑X瀹胯垗妤糥X瀹わ級',
  is_default TINYINT NOT NULL DEFAULT 0 COMMENT '鏄惁榛樿鍦板潃锛?-鍚?1-鏄?,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (address_id),
  KEY idx_user_id (user_id),
  KEY idx_is_default (is_default)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='鐢ㄦ埛鏀惰揣鍦板潃琛?;

-- =============================================
-- 3. 鍟嗗涓庡簵閾虹浉鍏宠〃
-- =============================================

-- 3.1 搴楅摵鍒嗙被琛?
DROP TABLE IF EXISTS shop_category;
CREATE TABLE shop_category (
  category_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '鍒嗙被ID',
  category_name VARCHAR(32) NOT NULL COMMENT '鍒嗙被鍚嶇О锛堝锛氬揩椁愩€佸ザ鑼躲€佹棭椁愶級',
  category_icon VARCHAR(255) DEFAULT '' COMMENT '鍒嗙被鍥炬爣URL',
  sort INT NOT NULL DEFAULT 0 COMMENT '鎺掑簭鍙?,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (category_id),
  UNIQUE KEY uk_category_name (category_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='搴楅摵鍒嗙被琛?;

-- 3.2 鍟嗗搴楅摵淇℃伅琛?
DROP TABLE IF EXISTS shop_info;
CREATE TABLE shop_info (
  shop_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '搴楅摵ID',
  merchant_user_id BIGINT NOT NULL COMMENT '鍏宠仈鍟嗗鐢ㄦ埛ID',
  shop_name VARCHAR(128) NOT NULL COMMENT '搴楅摵鍚嶇О',
  shop_logo VARCHAR(255) NOT NULL DEFAULT '' COMMENT '搴楅摵LOGO URL',
  shop_cover VARCHAR(255) DEFAULT '' COMMENT '搴楅摵灏侀潰鍥綰RL',
  shop_category_id BIGINT NOT NULL COMMENT '搴楅摵鍒嗙被ID',
  business_license VARCHAR(255) NOT NULL DEFAULT '' COMMENT '钀ヤ笟鎵х収URL',
  food_license VARCHAR(255) NOT NULL DEFAULT '' COMMENT '椋熷搧缁忚惀璁稿彲璇乁RL',
  shop_desc VARCHAR(512) DEFAULT '' COMMENT '搴楅摵绠€浠?,
  business_hours VARCHAR(128) NOT NULL DEFAULT '' COMMENT '钀ヤ笟鏃堕棿锛堝锛?0:00-22:00锛?,
  contact_phone VARCHAR(11) NOT NULL COMMENT '搴楅摵鑱旂郴鐢佃瘽',
  shop_address VARCHAR(255) NOT NULL COMMENT '搴楅摵鍦板潃锛堟牎鍥唴浣嶇疆锛?,
  delivery_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '閰嶉€佽垂',
  min_order_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '璧烽€侀噾棰?,
  shop_status TINYINT NOT NULL DEFAULT 0 COMMENT '搴楅摵鐘舵€侊細0-寰呭鏍?1-钀ヤ笟涓?2-宸叉墦鐑?3-瀹℃牳椹冲洖 4-宸茬鐢?,
  audit_status TINYINT NOT NULL DEFAULT 0 COMMENT '瀹℃牳鐘舵€侊細0-寰呭鏍?1-瀹℃牳閫氳繃 2-瀹℃牳椹冲洖',
  audit_remark VARCHAR(255) DEFAULT '' COMMENT '瀹℃牳澶囨敞',
  monthly_sales INT NOT NULL DEFAULT 0 COMMENT '鏈堥攢閲?,
  shop_score DECIMAL(2,1) NOT NULL DEFAULT 5.0 COMMENT '搴楅摵璇勫垎锛堟弧鍒?.0锛?,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (shop_id),
  UNIQUE KEY uk_merchant_user_id (merchant_user_id),
  KEY idx_shop_category_id (shop_category_id),
  KEY idx_shop_status (shop_status),
  KEY idx_audit_status (audit_status),
  KEY idx_shop_score (shop_score),
  KEY idx_shop_name (shop_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='鍟嗗搴楅摵淇℃伅琛?;

-- =============================================
-- 4. 鍟嗗搧鐩稿叧琛?
-- =============================================

-- 4.1 鍟嗗搧鍒嗙被琛?
DROP TABLE IF EXISTS product_category;
CREATE TABLE product_category (
  category_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '鍒嗙被ID',
  shop_id BIGINT NOT NULL COMMENT '鎵€灞炲簵閾篒D',
  category_name VARCHAR(32) NOT NULL COMMENT '鍒嗙被鍚嶇О锛堝锛氫富椋熴€佸皬鍚冦€侀ギ鍝侊級',
  sort INT NOT NULL DEFAULT 0 COMMENT '鎺掑簭鍙?,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (category_id),
  UNIQUE KEY uk_shop_category (shop_id, category_name),
  KEY idx_shop_id (shop_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='鍟嗗搧鍒嗙被琛?;

-- 4.2 鍟嗗搧淇℃伅琛?
DROP TABLE IF EXISTS product_info;
CREATE TABLE product_info (
  product_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '鍟嗗搧ID',
  shop_id BIGINT NOT NULL COMMENT '鎵€灞炲簵閾篒D',
  category_id BIGINT NOT NULL COMMENT '鎵€灞炲晢鍝佸垎绫籌D',
  product_name VARCHAR(128) NOT NULL COMMENT '鍟嗗搧鍚嶇О',
  product_image VARCHAR(255) NOT NULL DEFAULT '' COMMENT '鍟嗗搧涓诲浘URL',
  product_images TEXT DEFAULT NULL COMMENT '鍟嗗搧杞挱鍥綰RL鏁扮粍锛圝SON鏍煎紡锛?,
  product_desc VARCHAR(512) DEFAULT '' COMMENT '鍟嗗搧鎻忚堪',
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '鍟嗗搧鍞环',
  original_price DECIMAL(10,2) DEFAULT 0.00 COMMENT '鍟嗗搧鍘熶环',
  unit VARCHAR(16) NOT NULL DEFAULT '浠? COMMENT '鍟嗗搧鍗曚綅锛堜唤銆佹澂銆佷釜绛夛級',
  monthly_sales INT NOT NULL DEFAULT 0 COMMENT '鏈堥攢閲?,
  product_status TINYINT NOT NULL DEFAULT 1 COMMENT '鍟嗗搧鐘舵€侊細0-涓嬫灦 1-涓婃灦',
  is_hot TINYINT NOT NULL DEFAULT 0 COMMENT '鏄惁鐑攢锛?-鍚?1-鏄?,
  is_recommend TINYINT NOT NULL DEFAULT 0 COMMENT '鏄惁鎺ㄨ崘锛?-鍚?1-鏄?,
  sort INT NOT NULL DEFAULT 0 COMMENT '鎺掑簭鍙?,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (product_id),
  KEY idx_shop_id (shop_id),
  KEY idx_category_id (category_id),
  KEY idx_product_status (product_status),
  KEY idx_is_hot (is_hot),
  KEY idx_is_recommend (is_recommend),
  KEY idx_product_name (product_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='鍟嗗搧淇℃伅琛?;

-- 4.3 鍟嗗搧瑙勬牸琛?
DROP TABLE IF EXISTS product_spec;
CREATE TABLE product_spec (
  spec_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '瑙勬牸ID',
  product_id BIGINT NOT NULL COMMENT '鎵€灞炲晢鍝両D',
  spec_name VARCHAR(64) NOT NULL COMMENT '瑙勬牸鍚嶇О锛堝锛氬皯鍐般€佹甯稿啺銆佸ぇ浠姐€佸皬浠斤級',
  spec_price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '瑙勬牸鍔犱环/鍞环',
  stock INT NOT NULL DEFAULT 0 COMMENT '瑙勬牸搴撳瓨',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (spec_id),
  KEY idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='鍟嗗搧瑙勬牸琛?;

-- =============================================
-- 5. 璐墿杞︾浉鍏宠〃
-- =============================================

-- 5.1 璐墿杞﹁〃
DROP TABLE IF EXISTS shopping_cart;
CREATE TABLE shopping_cart (
  cart_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '璐墿杞D',
  user_id BIGINT NOT NULL COMMENT '鎵€灞炵敤鎴稩D',
  shop_id BIGINT NOT NULL COMMENT '鎵€灞炲簵閾篒D',
  product_id BIGINT NOT NULL COMMENT '鍟嗗搧ID',
  spec_id BIGINT DEFAULT NULL COMMENT '鍟嗗搧瑙勬牸ID',
  product_num INT NOT NULL DEFAULT 1 COMMENT '鍟嗗搧鏁伴噺',
  is_checked TINYINT NOT NULL DEFAULT 1 COMMENT '鏄惁閫変腑锛?-鏈€変腑 1-閫変腑',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (cart_id),
  KEY idx_user_id (user_id),
  KEY idx_shop_id (shop_id),
  KEY idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='璐墿杞﹁〃';

-- =============================================
-- 6. 璁㈠崟鏍稿績鐩稿叧琛?
-- =============================================

-- 6.1 璁㈠崟涓昏〃
DROP TABLE IF EXISTS order_info;
CREATE TABLE order_info (
  order_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '璁㈠崟ID',
  order_no VARCHAR(32) NOT NULL COMMENT '璁㈠崟缂栧彿锛堝敮涓€锛屽箓绛夌敤锛?,
  user_id BIGINT NOT NULL COMMENT '涓嬪崟鐢ㄦ埛ID',
  shop_id BIGINT NOT NULL COMMENT '鎵€灞炲簵閾篒D',
  receiver_name VARCHAR(32) NOT NULL COMMENT '鏀惰揣浜哄鍚?,
  receiver_phone VARCHAR(11) NOT NULL COMMENT '鏀惰揣浜烘墜鏈哄彿',
  receiver_address VARCHAR(255) NOT NULL COMMENT '鏀惰揣鍦板潃',
  total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '璁㈠崟鎬婚噾棰?,
  product_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '鍟嗗搧鎬婚噾棰?,
  delivery_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '閰嶉€佽垂',
  discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '浼樻儬閲戦',
  pay_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '瀹炰粯閲戦',
  pay_type TINYINT DEFAULT NULL COMMENT '鏀粯鏂瑰紡锛?-寰俊鏀粯 2-鏀粯瀹濇敮浠?,
  order_status TINYINT NOT NULL DEFAULT 0 COMMENT '璁㈠崟鐘舵€侊細0-寰呮敮浠?1-寰呮帴鍗?2-寰呭椁?3-寰呭嚭椁?4-閰嶉€佷腑 5-宸插畬鎴?6-宸插彇娑?7-閫€娆句腑 8-宸查€€娆?,
  pay_status TINYINT NOT NULL DEFAULT 0 COMMENT '鏀粯鐘舵€侊細0-鏈敮浠?1-宸叉敮浠?2-宸查€€娆?,
  order_remark VARCHAR(255) DEFAULT '' COMMENT '璁㈠崟澶囨敞',
  pay_time DATETIME DEFAULT NULL COMMENT '鏀粯鏃堕棿',
  accept_time DATETIME DEFAULT NULL COMMENT '鍟嗗鎺ュ崟鏃堕棿',
  delivery_time DATETIME DEFAULT NULL COMMENT '鍑洪/閰嶉€佹椂闂?,
  finish_time DATETIME DEFAULT NULL COMMENT '璁㈠崟瀹屾垚鏃堕棿',
  cancel_time DATETIME DEFAULT NULL COMMENT '璁㈠崟鍙栨秷鏃堕棿',
  cancel_reason VARCHAR(255) DEFAULT '' COMMENT '鍙栨秷鍘熷洜',
  expire_time DATETIME NOT NULL COMMENT '璁㈠崟鏀粯杩囨湡鏃堕棿',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (order_id),
  UNIQUE KEY uk_order_no (order_no),
  KEY idx_user_id (user_id),
  KEY idx_shop_id (shop_id),
  KEY idx_pay_type (pay_type),
  KEY idx_order_status (order_status),
  KEY idx_pay_status (pay_status),
  KEY idx_expire_time (expire_time),
  KEY idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='璁㈠崟涓昏〃';

-- 6.2 璁㈠崟璇︽儏琛?
DROP TABLE IF EXISTS order_item;
CREATE TABLE order_item (
  item_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '璇︽儏ID',
  order_id BIGINT NOT NULL COMMENT '鎵€灞炶鍗旾D',
  order_no VARCHAR(32) NOT NULL COMMENT '璁㈠崟缂栧彿',
  product_id BIGINT NOT NULL COMMENT '鍟嗗搧ID',
  product_name VARCHAR(128) NOT NULL COMMENT '鍟嗗搧鍚嶇О',
  product_image VARCHAR(255) NOT NULL DEFAULT '' COMMENT '鍟嗗搧鍥剧墖',
  spec_id BIGINT DEFAULT NULL COMMENT '瑙勬牸ID',
  spec_name VARCHAR(64) DEFAULT '' COMMENT '瑙勬牸鍚嶇О',
  product_price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '鍟嗗搧鍗曚环',
  product_num INT NOT NULL DEFAULT 1 COMMENT '鍟嗗搧鏁伴噺',
  total_price DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '鍟嗗搧灏忚閲戦',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (item_id),
  KEY idx_order_id (order_id),
  KEY idx_order_no (order_no),
  KEY idx_product_id (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='璁㈠崟璇︽儏琛?;

-- 6.3 璁㈠崟鐘舵€佹祦杞棩蹇楄〃
DROP TABLE IF EXISTS order_status_log;
CREATE TABLE order_status_log (
  log_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '鏃ュ織ID',
  order_id BIGINT NOT NULL COMMENT '璁㈠崟ID',
  order_no VARCHAR(32) NOT NULL COMMENT '璁㈠崟缂栧彿',
  pre_status TINYINT DEFAULT NULL COMMENT '鍙樻洿鍓嶇姸鎬?,
  current_status TINYINT NOT NULL COMMENT '鍙樻洿鍚庣姸鎬?,
  operation_type VARCHAR(32) NOT NULL COMMENT '鎿嶄綔绫诲瀷锛堝锛氱敤鎴蜂笅鍗曘€佸晢瀹舵帴鍗曘€佺敤鎴峰彇娑堬級',
  operation_user_id BIGINT NOT NULL COMMENT '鎿嶄綔浜篒D',
  operation_user_name VARCHAR(64) NOT NULL COMMENT '鎿嶄綔浜哄悕绉?,
  operation_remark VARCHAR(255) DEFAULT '' COMMENT '鎿嶄綔澶囨敞',
  operation_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鎿嶄綔鏃堕棿',
  PRIMARY KEY (log_id),
  KEY idx_order_id (order_id),
  KEY idx_order_no (order_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='璁㈠崟鐘舵€佹祦杞棩蹇楄〃';

-- 6.4 璁㈠崟閫€娆剧敵璇疯〃
DROP TABLE IF EXISTS order_refund;
CREATE TABLE order_refund (
  refund_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '閫€娆剧敵璇稩D',
  refund_no VARCHAR(32) NOT NULL COMMENT '閫€娆剧紪鍙凤紙鍞竴锛屽箓绛夌敤锛?,
  order_id BIGINT NOT NULL COMMENT '鎵€灞炶鍗旾D',
  order_no VARCHAR(32) NOT NULL COMMENT '璁㈠崟缂栧彿',
  user_id BIGINT NOT NULL COMMENT '鐢宠浜虹敤鎴稩D',
  shop_id BIGINT NOT NULL COMMENT '鎵€灞炲簵閾篒D',
  refund_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '鐢宠閫€娆鹃噾棰?,
  refund_reason VARCHAR(255) NOT NULL COMMENT '閫€娆惧師鍥?,
  refund_desc VARCHAR(512) DEFAULT '' COMMENT '閫€娆捐鏄?,
  refund_images TEXT DEFAULT NULL COMMENT '閫€娆惧嚟璇佸浘鐗嘦RL鏁扮粍锛圝SON鏍煎紡锛?,
  refund_status TINYINT NOT NULL DEFAULT 0 COMMENT '閫€娆剧姸鎬侊細0-寰呭鏍?1-鍟嗗鍚屾剰 2-鍟嗗鎷掔粷 3-閫€娆句腑 4-閫€娆炬垚鍔?5-閫€娆惧け璐?,
  audit_time DATETIME DEFAULT NULL COMMENT '鍟嗗瀹℃牳鏃堕棿',
  audit_remark VARCHAR(255) DEFAULT '' COMMENT '瀹℃牳澶囨敞',
  refund_time DATETIME DEFAULT NULL COMMENT '閫€娆惧畬鎴愭椂闂?,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (refund_id),
  UNIQUE KEY uk_refund_no (refund_no),
  UNIQUE KEY uk_order_no (order_no),
  KEY idx_order_id (order_id),
  KEY idx_user_id (user_id),
  KEY idx_shop_id (shop_id),
  KEY idx_refund_status (refund_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='璁㈠崟閫€娆剧敵璇疯〃';

-- =============================================
-- 7. 鏀粯鐩稿叧琛?
-- =============================================

-- 7.1 鏀粯璁板綍琛?
DROP TABLE IF EXISTS payment_info;
CREATE TABLE payment_info (
  payment_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '鏀粯璁板綍ID',
  out_trade_no VARCHAR(32) NOT NULL COMMENT '鍟嗘埛璁㈠崟鍙凤紙瀵瑰簲order_no锛?,
  transaction_id VARCHAR(64) DEFAULT '' COMMENT '绗笁鏂规敮浠樻祦姘村彿',
  order_id BIGINT NOT NULL COMMENT '璁㈠崟ID',
  user_id BIGINT NOT NULL COMMENT '鏀粯鐢ㄦ埛ID',
  pay_type TINYINT NOT NULL COMMENT '鏀粯鏂瑰紡锛?-寰俊鏀粯 2-鏀粯瀹濇敮浠?,
  pay_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '鏀粯閲戦',
  pay_status TINYINT NOT NULL DEFAULT 0 COMMENT '鏀粯鐘舵€侊細0-寰呮敮浠?1-鏀粯鎴愬姛 2-鏀粯澶辫触 3-宸插叧闂?4-宸查€€娆?,
  pay_time DATETIME DEFAULT NULL COMMENT '鏀粯瀹屾垚鏃堕棿',
  callback_content TEXT DEFAULT NULL COMMENT '鏀粯鍥炶皟鍘熷鏁版嵁',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (payment_id),
  UNIQUE KEY uk_out_trade_no (out_trade_no),
  UNIQUE KEY uk_transaction_id (transaction_id),
  KEY idx_order_id (order_id),
  KEY idx_user_id (user_id),
  KEY idx_pay_type (pay_type),
  KEY idx_pay_status (pay_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='鏀粯璁板綍琛?;

-- 7.2 閫€娆捐褰曡〃
DROP TABLE IF EXISTS refund_info;
CREATE TABLE refund_info (
  id BIGINT NOT NULL AUTO_INCREMENT COMMENT '涓婚敭ID',
  out_refund_no VARCHAR(32) NOT NULL COMMENT '鍟嗘埛閫€娆惧崟鍙凤紙瀵瑰簲refund_no锛?,
  refund_id BIGINT NOT NULL COMMENT '閫€娆剧敵璇稩D',
  order_id BIGINT NOT NULL COMMENT '璁㈠崟ID',
  out_trade_no VARCHAR(32) NOT NULL COMMENT '鍟嗘埛璁㈠崟鍙?,
  transaction_id VARCHAR(64) DEFAULT '' COMMENT '鍘熸敮浠樻祦姘村彿',
  refund_transaction_id VARCHAR(64) DEFAULT '' COMMENT '绗笁鏂归€€娆炬祦姘村彿',
  refund_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '閫€娆鹃噾棰?,
  refund_type TINYINT NOT NULL DEFAULT 1 COMMENT '閫€娆炬笭閬擄細1-寰俊閫€娆?2-鏀粯瀹濋€€娆?,
  refund_status TINYINT NOT NULL DEFAULT 0 COMMENT '閫€娆剧姸鎬侊細0-閫€娆句腑 1-閫€娆炬垚鍔?2-閫€娆惧け璐?,
  refund_time DATETIME DEFAULT NULL COMMENT '閫€娆惧畬鎴愭椂闂?,
  callback_content TEXT DEFAULT NULL COMMENT '閫€娆惧洖璋冨師濮嬫暟鎹?,
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (id),
  UNIQUE KEY uk_out_refund_no (out_refund_no),
  UNIQUE KEY uk_refund_transaction_id (refund_transaction_id),
  KEY idx_refund_id (refund_id),
  KEY idx_order_id (order_id),
  KEY idx_out_trade_no (out_trade_no),
  KEY idx_refund_status (refund_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='閫€娆捐褰曡〃';

-- =============================================
-- 8. 娑堟伅涓庣郴缁熼厤缃〃
-- =============================================

-- 8.1 娑堟伅閫氱煡琛?
DROP TABLE IF EXISTS message_notice;
CREATE TABLE message_notice (
  message_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '娑堟伅ID',
  receive_user_id BIGINT NOT NULL COMMENT '鎺ユ敹鐢ㄦ埛ID',
  send_user_id BIGINT DEFAULT 0 COMMENT '鍙戦€佺敤鎴稩D锛岀郴缁熷彂閫佷负0',
  message_type TINYINT NOT NULL COMMENT '娑堟伅绫诲瀷锛?-璁㈠崟閫氱煡 2-绯荤粺閫氱煡 3-鍏憡閫氱煡',
  message_title VARCHAR(128) NOT NULL COMMENT '娑堟伅鏍囬',
  message_content VARCHAR(512) NOT NULL COMMENT '娑堟伅鍐呭',
  relation_id BIGINT DEFAULT NULL COMMENT '鍏宠仈ID锛堝璁㈠崟ID銆佸叕鍛奍D锛?,
  is_read TINYINT NOT NULL DEFAULT 0 COMMENT '鏄惁宸茶锛?-鏈 1-宸茶',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (message_id),
  KEY idx_receive_user_id (receive_user_id),
  KEY idx_message_type (message_type),
  KEY idx_is_read (is_read),
  KEY idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='娑堟伅閫氱煡琛?;

-- 8.2 绯荤粺鍏憡琛?
DROP TABLE IF EXISTS sys_announcement;
CREATE TABLE sys_announcement (
  announcement_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '鍏憡ID',
  announcement_title VARCHAR(128) NOT NULL COMMENT '鍏憡鏍囬',
  announcement_content TEXT NOT NULL COMMENT '鍏憡鍐呭',
  publisher_id BIGINT NOT NULL COMMENT '鍙戝竷浜篒D',
  publisher_name VARCHAR(64) NOT NULL COMMENT '鍙戝竷浜哄悕绉?,
  is_top TINYINT NOT NULL DEFAULT 0 COMMENT '鏄惁缃《锛?-鍚?1-鏄?,
  status TINYINT NOT NULL DEFAULT 1 COMMENT '鐘舵€侊細0-涓嬫灦 1-鍙戝竷',
  publish_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍙戝竷鏃堕棿',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (announcement_id),
  KEY idx_is_top (is_top),
  KEY idx_status (status),
  KEY idx_publish_time (publish_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='绯荤粺鍏憡琛?;

-- 8.3 绯荤粺鍙傛暟閰嶇疆琛?
DROP TABLE IF EXISTS sys_config;
CREATE TABLE sys_config (
  config_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '閰嶇疆ID',
  config_key VARCHAR(64) NOT NULL COMMENT '閰嶇疆閿悕',
  config_value VARCHAR(512) NOT NULL COMMENT '閰嶇疆閿€?,
  config_name VARCHAR(128) NOT NULL COMMENT '閰嶇疆鍚嶇О',
  config_desc VARCHAR(255) DEFAULT '' COMMENT '閰嶇疆鎻忚堪',
  create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '閫昏緫鍒犻櫎',
  PRIMARY KEY (config_id),
  UNIQUE KEY uk_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='绯荤粺鍙傛暟閰嶇疆琛?;

-- =============================================
-- 鍒濆鏁版嵁鎻掑叆
-- =============================================

-- 鎻掑叆鍒濆瑙掕壊鏁版嵁
INSERT INTO sys_role (role_id, role_code, role_name, role_desc) VALUES
(1, 'STUDENT', '瀛︾敓', '鏍″洯鐐归绯荤粺瀛︾敓鐢ㄦ埛'),
(2, 'MERCHANT', '鍟嗗', '鏍″洯鐐归绯荤粺鍟嗗鐢ㄦ埛'),
(3, 'ADMIN', '绠＄悊鍛?, '鏍″洯鐐归绯荤粺骞冲彴绠＄悊鍛?);

-- 鎻掑叆鍒濆搴楅摵鍒嗙被鏁版嵁
INSERT INTO shop_category (category_id, category_name, category_icon, sort) VALUES
(1, '蹇', '', 1),
(2, '濂惰尪楗搧', '', 2),
(3, '鏃╅', '', 3),
(4, '灏忓悆闆堕', '', 4),
(5, '姝ｉ', '', 5);

-- 鎻掑叆鍒濆绯荤粺閰嶇疆鏁版嵁
INSERT INTO sys_config (config_id, config_key, config_value, config_name, config_desc) VALUES
(1, 'order.expire.minutes', '30', '璁㈠崟鏀粯杩囨湡鏃堕棿锛堝垎閽燂級', '鐢ㄦ埛鍒涘缓璁㈠崟鍚庨渶鍦ㄨ鏃堕棿鍐呭畬鎴愭敮浠橈紝鍚﹀垯璁㈠崟鑷姩鍙栨秷'),
(2, 'file.upload.path', '/data/upload', '鏂囦欢涓婁紶璺緞', '鍥剧墖绛夋枃浠剁殑鏈嶅姟鍣ㄥ瓨鍌ㄨ矾寰?),
(3, 'file.upload.max.size', '10485760', '鏂囦欢涓婁紶鏈€澶уぇ灏忥紙瀛楄妭锛?, '榛樿10MB'),
(4, 'system.name', '鏍″洯鐐归绯荤粺', '绯荤粺鍚嶇О', '骞冲彴绯荤粺鍚嶇О'),
(5, 'system.notice', '', '绯荤粺鍏憡', '骞冲彴绯荤粺鍏憡鍐呭'),
(6, 'max.delivery.fee', '10', '閰嶉€佽垂涓婇檺', '璁㈠崟閰嶉€佽垂涓婇檺閲戦');

-- 鎻掑叆鍒濆绠＄悊鍛樿处鍙凤紙瀵嗙爜锛歛dmin123锛岄渶浣跨敤BCrypt鍔犲瘑锛屾澶勪负绀轰緥鍔犲瘑鍚庡瓧绗︿覆锛?
-- 娉ㄦ剰锛氬疄闄呬娇鐢ㄦ椂璇风敓鎴愯嚜宸辩殑BCrypt鍔犲瘑瀵嗙爜
INSERT INTO sys_user (user_id, user_no, password, phone, user_name, status) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138000', '绯荤粺绠＄悊鍛?, 1);

-- 鍏宠仈绠＄悊鍛樿鑹?
INSERT INTO sys_user_role (user_id, role_id) VALUES
(1, 3);
-- 1. 缁?sys_user 琛ㄦ坊鍔?user_type 瀛楁
ALTER TABLE sys_user ADD COLUMN user_type INT DEFAULT 1 COMMENT '鐢ㄦ埛绫诲瀷锛?-瀛︾敓 2-鍟嗗 3-绠＄悊鍛?;

-- 2. 鍒涘缓鍟嗗鍏ラ┗鐢宠琛?
CREATE TABLE merchant_apply (
                                apply_id BIGINT PRIMARY KEY AUTO_INCREMENT,
                                user_id BIGINT NOT NULL COMMENT '鐢宠浜虹敤鎴稩D',
                                applicant_name VARCHAR(50) COMMENT '鐢宠浜哄鍚?,
                                applicant_phone VARCHAR(11) COMMENT '鐢宠浜烘墜鏈哄彿',
                                applicant_id_card VARCHAR(18) COMMENT '鐢宠浜鸿韩浠借瘉鍙?,
                                shop_name VARCHAR(100) NOT NULL COMMENT '搴楅摵鍚嶇О',
                                shop_description TEXT COMMENT '搴楅摵鎻忚堪',
                                shop_type INT COMMENT '搴楅摵绫诲瀷锛?-蹇 2-灏忓悆 3-楗搧 4-姘存灉 5-瓒呭競 6-鍏朵粬',
                                delivery_fee DECIMAL(10,2) DEFAULT 0 COMMENT '棰勮閰嶉€佽垂',
                                business_license VARCHAR(500) COMMENT '钀ヤ笟鎵х収URL',
                                id_card_front VARCHAR(500) COMMENT '韬唤璇佹闈RL',
                                id_card_back VARCHAR(500) COMMENT '韬唤璇佸弽闈RL',
                                audit_status INT DEFAULT 0 COMMENT '瀹℃牳鐘舵€侊細0-寰呭鏍?1-宸查€氳繃 2-宸叉嫆缁?,
                                audit_remark VARCHAR(500) COMMENT '瀹℃牳鎰忚',
                                audit_user_id BIGINT COMMENT '瀹℃牳浜篒D',
                                audit_time DATETIME COMMENT '瀹℃牳鏃堕棿',
                                create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                                update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                is_deleted INT DEFAULT 0
);

-- =============================================
-- 鏇村娴嬭瘯鏁版嵁鎻掑叆
-- =============================================

-- 鎻掑叆瀛︾敓鐢ㄦ埛鏁版嵁锛堝瘑鐮侀兘鏄?student123锛?
INSERT INTO sys_user (user_id, user_no, password, phone, user_name, status, user_type) VALUES
(2, '2021001001', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138001', '寮犱笁', 1, 1),
(3, '2021001002', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138002', '鏉庡洓', 1, 1),
(4, '2021001003', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138003', '鐜嬩簲', 1, 1),
(5, '2021001004', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138004', '璧靛叚', 1, 1),
(6, '2021001005', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138005', '閽变竷', 1, 1),
(12, '2021001006', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138006', '瀛欏叓', 1, 1),
(13, '2021001007', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138007', '鍛ㄤ節', 1, 1),
(14, '2021001008', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138008', '鍚村崄', 1, 1),
(15, '2021001009', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138009', '閮戝崄涓€', 1, 1),
(16, '2021001010', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138010', '鍐崄浜?, 1, 1),
(17, '2021001011', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138011', '闄堝崄涓?, 1, 1),
(18, '2021001012', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138012', '瑜氬崄鍥?, 1, 1),
(19, '2021001013', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138013', '鍗崄浜?, 1, 1),
(20, '2021001014', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138014', '钂嬪崄鍏?, 1, 1),
(21, '2021001015', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138015', '娌堝崄涓?, 1, 1),
(22, '2021001016', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138016', '闊╁崄鍏?, 1, 1),
(23, '2021001017', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138017', '鏉ㄥ崄涔?, 1, 1),
(24, '2021001018', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138018', '鏈变簩鍗?, 1, 1),
(25, '2021001019', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138019', '绉︿簩涓€', 1, 1),
(26, '2021001020', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138020', '灏や簩浜?, 1, 1),
(27, '2021001021', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138021', '璁镐簩涓?, 1, 1),
(28, '2021001022', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138022', '浣曚簩鍥?, 1, 1),
(29, '2021001023', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138023', '鍚曚簩浜?, 1, 1),
(30, '2021001024', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138024', '鏂戒簩鍏?, 1, 1),
(31, '2021001025', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138025', '寮犱簩涓?, 1, 1),
(32, '2021001026', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138026', '瀛斾簩鍏?, 1, 1),
(33, '2021001027', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138027', '鏇逛簩涔?, 1, 1),
(34, '2021001028', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138028', '涓ヤ笁鍗?, 1, 1),
(35, '2021001029', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138029', '鍗庝笁鍗佷竴', 1, 1),
(36, '2021001030', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13800138030', '閲戜笁浜?, 1, 1);

-- 鎻掑叆瀛︾敓璇︾粏淇℃伅
INSERT INTO student_info (student_id, user_id, student_no, college, major, grade, dormitory) VALUES
(1, 2, '2021001001', '璁＄畻鏈哄闄?, '杞欢宸ョ▼', '2021绾?, '涓滃尯3鍙锋ゼ502'),
(2, 3, '2021001002', '璁＄畻鏈哄闄?, '璁＄畻鏈虹瀛︿笌鎶€鏈?, '2021绾?, '涓滃尯3鍙锋ゼ503'),
(3, 4, '2021001003', '缁忔祹绠＄悊瀛﹂櫌', '宸ュ晢绠＄悊', '2021绾?, '瑗垮尯5鍙锋ゼ301'),
(4, 5, '2021001004', '澶栧浗璇闄?, '鑻辫', '2021绾?, '瑗垮尯5鍙锋ゼ302'),
(5, 6, '2021001005', '鏈烘宸ョ▼瀛﹂櫌', '鏈烘璁捐', '2021绾?, '涓滃尯4鍙锋ゼ201'),
(6, 12, '2021001006', '璁＄畻鏈哄闄?, '淇℃伅瀹夊叏', '2021绾?, '涓滃尯6鍙锋ゼ101'),
(7, 13, '2021001007', '缁忔祹绠＄悊瀛﹂櫌', '甯傚満钀ラ攢', '2021绾?, '瑗垮尯7鍙锋ゼ202'),
(8, 14, '2021001008', '鏂囧闄?, '姹夎瑷€鏂囧', '2021绾?, '涓滃尯8鍙锋ゼ303'),
(9, 15, '2021001009', '鐞嗗闄?, '鏁板涓庡簲鐢ㄦ暟瀛?, '2021绾?, '瑗垮尯9鍙锋ゼ404'),
(10, 16, '2021001010', '璁＄畻鏈哄闄?, '鐗╄仈缃戝伐绋?, '2022绾?, '涓滃尯10鍙锋ゼ505'),
(11, 17, '2021001011', '鏈烘宸ョ▼瀛﹂櫌', '杞﹁締宸ョ▼', '2022绾?, '瑗垮尯11鍙锋ゼ606'),
(12, 18, '2021001012', '鐢垫皵宸ョ▼瀛﹂櫌', '鐢垫皵宸ョ▼', '2022绾?, '涓滃尯12鍙锋ゼ707'),
(13, 19, '2021001013', '鍦熸湪宸ョ▼瀛﹂櫌', '鍦熸湪宸ョ▼', '2022绾?, '瑗垮尯13鍙锋ゼ808'),
(14, 20, '2021001014', '鍖栧鍖栧伐瀛﹂櫌', '搴旂敤鍖栧', '2022绾?, '涓滃尯14鍙锋ゼ909'),
(15, 21, '2021001015', '鐢熷懡绉戝瀛﹂櫌', '鐢熺墿绉戝', '2023绾?, '瑗垮尯15鍙锋ゼ1010'),
(16, 22, '2021001016', '缇庢湳瀛﹂櫌', '瑙嗚浼犺揪璁捐', '2023绾?, '涓滃尯16鍙锋ゼ1111'),
(17, 23, '2021001017', '闊充箰瀛﹂櫌', '闊充箰瀛?, '2023绾?, '瑗垮尯17鍙锋ゼ1212'),
(18, 24, '2021001018', '浣撹偛瀛﹂櫌', '浣撹偛鏁欒偛', '2023绾?, '涓滃尯18鍙锋ゼ1313'),
(19, 25, '2021001019', '鏁欒偛瀛﹂櫌', '鏁欒偛鎶€鏈', '2023绾?, '瑗垮尯19鍙锋ゼ1414'),
(20, 26, '2021001020', '娉曞闄?, '娉曞', '2020绾?, '涓滃尯20鍙锋ゼ1515'),
(21, 27, '2021001021', '鍏叡绠＄悊瀛﹂櫌', '琛屾斂绠＄悊', '2020绾?, '瑗垮尯21鍙锋ゼ1616'),
(22, 28, '2021001022', '鏂伴椈涓庝紶鎾闄?, '鏂伴椈瀛?, '2020绾?, '涓滃尯22鍙锋ゼ1717'),
(23, 29, '2021001023', '鏃呮父瀛﹂櫌', '鏃呮父绠＄悊', '2020绾?, '瑗垮尯23鍙锋ゼ1818'),
(24, 30, '2021001024', '鏉愭枡绉戝涓庡伐绋嬪闄?, '鏉愭枡绉戝', '2020绾?, '涓滃尯24鍙锋ゼ1919'),
(25, 31, '2021001025', '鑸┖鑸ぉ瀛﹂櫌', '鑸┖鑸ぉ宸ョ▼', '2024绾?, '瑗垮尯25鍙锋ゼ2020'),
(26, 32, '2021001026', '鍏夊瓙涓庨噺瀛愭妧鏈闄?, '鍏夌數淇℃伅绉戝', '2024绾?, '涓滃尯26鍙锋ゼ2121'),
(27, 33, '2021001027', '浜哄伐鏅鸿兘瀛﹂櫌', '浜哄伐鏅鸿兘', '2024绾?, '瑗垮尯27鍙锋ゼ2222'),
(28, 34, '2021001028', '缃戠粶绌洪棿瀹夊叏瀛﹂櫌', '缃戠粶绌洪棿瀹夊叏', '2024绾?, '涓滃尯28鍙锋ゼ2323'),
(29, 35, '2021001029', '澶ф暟鎹笌浜哄伐鏅鸿兘瀛﹂櫌', '鏁版嵁绉戝涓庡ぇ鏁版嵁鎶€鏈?, '2024绾?, '瑗垮尯29鍙锋ゼ2424'),
(30, 36, '2021001030', '椹厠鎬濅富涔夊闄?, '鎬濇兂鏀挎不鏁欒偛', '2024绾?, '涓滃尯30鍙锋ゼ2525');

-- 鍏宠仈瀛︾敓瑙掕壊
INSERT INTO sys_user_role (user_id, role_id) VALUES
(2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (12, 1), (13, 1), (14, 1), (15, 1), (16, 1),
(17, 1), (18, 1), (19, 1), (20, 1), (21, 1), (22, 1), (23, 1), (24, 1), (25, 1), (26, 1),
(27, 1), (28, 1), (29, 1), (30, 1), (31, 1), (32, 1), (33, 1), (34, 1), (35, 1), (36, 1);

-- 鎻掑叆鍟嗗鐢ㄦ埛鏁版嵁锛堝瘑鐮侀兘鏄?merchant123锛?
INSERT INTO sys_user (user_id, user_no, password, phone, user_name, status, user_type) VALUES
(7, 'merchant01', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13900139001', '寮犺€佹澘', 1, 2),
(8, 'merchant02', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13900139002', '鏉庤€佹澘', 1, 2),
(9, 'merchant03', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13900139003', '鐜嬭€佹澘', 1, 2),
(10, 'merchant04', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13900139004', '璧佃€佹澘', 1, 2),
(11, 'merchant05', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '13900139005', '鍒樿€佹澘', 1, 2);

-- 鍏宠仈鍟嗗瑙掕壊
INSERT INTO sys_user_role (user_id, role_id) VALUES
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2);

-- 鎻掑叆搴楅摵淇℃伅
INSERT INTO shop_info (shop_id, merchant_user_id, shop_name, shop_logo, shop_category_id, business_license, shop_desc, business_hours, contact_phone, shop_address, delivery_fee, min_order_amount, shop_status, audit_status, monthly_sales, shop_score) VALUES
(1, 7, '绗竴椋熷爞蹇', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 1, '', '鏍″洯绗竴椋熷爞锛屾彁渚涚編鍛冲疄鎯犵殑蹇', '07:00-21:00', '13900139001', '绗竴椋熷爞涓€妤?, 1.00, 8.00, 1, 1, 1250, 4.8),
(2, 8, '蹇箰濂惰尪搴?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2, '', '鏂伴矞濂惰尪锛屽揩涔愭瘡涓€澶?, '09:00-22:00', '13900139002', '鍟嗕笟琛桝鍖?鍙?, 0.00, 15.00, 1, 1, 980, 4.9),
(3, 9, '鏃╅灏忛摵', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 3, '', '钀ュ吇鏃╅锛屽紑鍚編濂戒竴澶?, '06:00-10:00', '13900139003', '绗簩椋熷爞闂ㄥ彛', 0.50, 5.00, 1, 1, 850, 4.7),
(4, 10, '闆堕灏忓崠閮?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 4, '', '鍚勭闆堕锛屾弧瓒充綘鐨勫懗钑?, '08:00-23:00', '13900139004', '瀹胯垗鍖築鍖?鍙?, 1.50, 10.00, 1, 1, 650, 4.6),
(5, 11, '宸濆懗瀹跺父鑿?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 5, '', '姝ｅ畻宸濊彍锛岄夯杈ｉ矞棣?, '10:00-21:00', '13900139005', '鍟嗕笟琛桞鍖?鍙?, 2.00, 20.00, 1, 1, 720, 4.8);

-- 鎻掑叆鍟嗗搧鍒嗙被
INSERT INTO product_category (category_id, shop_id, category_name, sort) VALUES
(1, 1, '鐑攢濂楅', 1),
(2, 1, '鍗曞搧鑿滆偞', 2),
(3, 1, '姹ゅ搧', 3),
(4, 2, '濂惰尪绯诲垪', 1),
(5, 2, '鏋滆尪绯诲垪', 2),
(6, 2, '鍜栧暋绯诲垪', 3),
(7, 3, '鍖呭瓙棣掑ご', 1),
(8, 3, '璞嗘祮绮ュ搧', 2),
(9, 3, '鐓庨ゼ娌规潯', 3),
(10, 4, '鑶ㄥ寲椋熷搧', 1),
(11, 4, '绯栨灉宸у厠鍔?, 2),
(12, 4, '楗枡', 3),
(13, 5, '缁忓吀宸濊彍', 1),
(14, 5, '瀹跺父灏忕倰', 2),
(15, 5, '姹ょ竟', 3),
(16, 1, '涓婚', 4),
(17, 1, '鍑夎彍', 5),
(18, 2, '濂惰尪閰嶆枡', 4),
(19, 3, '闈㈤', 4),
(20, 3, '绮ュ搧', 5),
(21, 4, '鏂逛究椋熷搧', 4),
(22, 4, '鍧氭灉', 5),
(23, 4, '濂跺埗鍝?, 6),
(24, 5, '鍑夎彍', 4),
(25, 5, '涓婚', 5);

-- 鎻掑叆鍟嗗搧淇℃伅
INSERT INTO product_info (product_id, shop_id, category_id, product_name, product_image, product_desc, price, original_price, unit, monthly_sales, product_status, is_hot, is_recommend, sort) VALUES
-- 绗竴椋熷爞蹇鍟嗗搧
(1, 1, 1, '绾㈢儳鑲夊椁?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鑲ョ槮鐩搁棿锛屽叆鍙ｅ嵆鍖?, 15.00, 18.00, '浠?, 230, 1, 1, 1, 1),
(2, 1, 1, '绯栭唻閲岃剨濂楅', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰哥敎鍙彛锛岃€佸皯鐨嗗疁', 14.00, 16.00, '浠?, 180, 1, 1, 1, 2),
(3, 1, 1, '瀹繚楦′竵濂楅', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '缁忓吀宸濊彍锛岄夯杈ｉ矞棣?, 13.00, 15.00, '浠?, 150, 1, 1, 0, 3),
(4, 1, 1, '涓滃潯鑲夊椁?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鐨杽鑲夊锛岄叆鑰屼笉鐑?, 16.00, 20.00, '浠?, 160, 1, 1, 0, 4),
(5, 1, 1, '姊呰彍鎵ｈ倝濂楅', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '姊呰彍娓呴锛屾墸鑲夎蒋绯?, 17.00, 22.00, '浠?, 140, 1, 0, 0, 5),
(6, 1, 2, '楸奸鑲変笣', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰哥敎寰荆锛屼笅楗鍣?, 12.00, 14.00, '浠?, 120, 1, 0, 0, 1),
(7, 1, 2, '楹诲﹩璞嗚厫', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '楹昏荆椴滈锛屽婊戠埥鍙?, 8.00, 10.00, '浠?, 200, 1, 1, 0, 2),
(8, 1, 2, '鐣寗鐐掕泲', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '瀹跺父缇庡懗锛岃惀鍏讳赴瀵?, 7.00, 9.00, '浠?, 180, 1, 0, 0, 3),
(9, 1, 2, '灏栨鍦熻眴涓?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呰剢鐖藉彛锛屼笅楗ソ鑿?, 6.00, 8.00, '浠?, 160, 1, 0, 0, 4),
(10, 1, 2, '鍦颁笁椴?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鑼勫瓙鍦熻眴闈掓锛屽甯哥粡鍏?, 10.00, 12.00, '浠?, 130, 1, 0, 0, 5),
(11, 1, 2, '骞茬吀鍥涘璞?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '骞查鍏ュ懗锛岃秺鍤艰秺棣?, 9.00, 11.00, '浠?, 110, 1, 0, 0, 6),
(12, 1, 3, '绱彍铔嬭姳姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呮贰鐖藉彛锛岃惀鍏诲仴搴?, 3.00, 4.00, '浠?, 300, 1, 0, 0, 1),
(13, 1, 3, '鐣寗铔嬫堡', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰哥敎寮€鑳冿紝瀹跺父鍛抽亾', 3.00, 4.00, '浠?, 250, 1, 0, 0, 2),
(14, 1, 3, '閰歌荆姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰歌荆寮€鑳冿紝鏆栬儍鏆栧績', 4.00, 5.00, '浠?, 200, 1, 0, 0, 3),
(15, 1, 3, '闈掕彍璞嗚厫姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呮贰鍏荤敓锛岀豢鑹插仴搴?, 3.00, 4.00, '浠?, 150, 1, 0, 0, 4),
(16, 1, 16, '绫抽キ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '涓滃寳澶х背锛岄杞彲鍙?, 2.00, 2.50, '浠?, 500, 1, 0, 0, 1),
(17, 1, 16, '棣掑ご', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鏉捐蒋鍙彛锛岄害棣欐祿閮?, 1.00, 1.50, '涓?, 300, 1, 0, 0, 2),
(18, 1, 16, '闈㈡潯', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鎵嬪伐闈㈡潯锛屽姴閬撶埥婊?, 3.00, 4.00, '浠?, 200, 1, 0, 0, 3),
(19, 1, 17, '鍑夋媽榛勭摐', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呰剢鐖藉彛锛屽鏃ュ繀澶?, 4.00, 5.00, '浠?, 120, 1, 0, 0, 1),
(20, 1, 17, '鍑夋媽鏈ㄨ€?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '榛戞湪鑰筹紝鑴嗗鐖藉彛', 5.00, 6.00, '浠?, 100, 1, 0, 0, 2),

-- 蹇箰濂惰尪搴楀晢鍝?
(21, 2, 4, '鐝嶇彔濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 'Q寮圭弽鐝狅紝棣欐祿濂惰尪', 12.00, 15.00, '鏉?, 350, 1, 1, 1, 1),
(22, 2, 4, '妞版灉濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '妞版灉棣欑敎锛屽ザ鑼舵祿閮?, 13.00, 16.00, '鏉?, 280, 1, 1, 0, 2),
(23, 2, 4, '甯冧竵濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '瀚╂粦甯冧竵锛屽ザ棣欏洓婧?, 14.00, 17.00, '鏉?, 220, 1, 0, 0, 3),
(24, 2, 4, '鑺嬫偿濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鑺嬫偿娴撻儊锛屽彛鎰熶赴瀵?, 15.00, 18.00, '鏉?, 200, 1, 1, 0, 4),
(25, 2, 4, '绾㈣眴濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '杞朝绾㈣眴锛岀敎铚滃彲鍙?, 13.00, 16.00, '鏉?, 190, 1, 0, 0, 5),
(26, 2, 5, '鏌犳绾㈣尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呮柊鏌犳锛岄唶棣欑孩鑼?, 10.00, 12.00, '鏉?, 180, 1, 0, 0, 1),
(27, 2, 5, '鐧鹃鏋滆尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰哥敎鐧鹃锛屾竻鐖借В娓?, 12.00, 14.00, '鏉?, 150, 1, 1, 1, 2),
(28, 2, 5, '鑺掓灉澶氬', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鏂伴矞鑺掓灉锛屾祿閮佹灉棣?, 14.00, 17.00, '鏉?, 140, 1, 1, 0, 3),
(29, 2, 5, '鑽夎帗濂舵様', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '棣欑敎鑽夎帗锛屼笣婊戝ザ鏄?, 13.00, 16.00, '鏉?, 130, 1, 0, 0, 4),
(30, 2, 6, '缇庡紡鍜栧暋', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閱囬鍜栧暋锛屾彁绁為啋鑴?, 15.00, 18.00, '鏉?, 120, 1, 0, 0, 1),
(31, 2, 6, '鎷块搧鍜栧暋', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '濂堕娴撻儊锛屽挅鍟￠唶鍘?, 18.00, 22.00, '鏉?, 100, 1, 0, 0, 2),
(32, 2, 6, '鍗″竷濂囪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '缁靛瘑濂舵场锛岀粡鍏告剰寮?, 17.00, 21.00, '鏉?, 90, 1, 0, 0, 3),
(33, 2, 6, '鎽╁崱鍜栧暋', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '宸у厠鍔涘挅鍟★紝棣欑敎娴撻儊', 19.00, 24.00, '鏉?, 85, 1, 0, 0, 4),
(34, 2, 18, '娉㈤湼', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '澶ч娉㈤湼锛孮寮规湁鍤煎姴', 2.00, 3.00, '浠?, 300, 1, 0, 0, 1),
(35, 2, 18, '妞版灉', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '妞版灉鏋滆倝锛屾竻鐖絈寮?, 1.50, 2.00, '浠?, 250, 1, 0, 0, 2),
(36, 2, 18, '甯冧竵', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '瀚╂粦甯冧竵锛屽ザ棣欐祿閮?, 2.00, 3.00, '浠?, 200, 1, 0, 0, 3),

-- 鏃╅灏忛摵鍟嗗搧
(37, 3, 7, '椴滆倝鍖呭瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鐨杽棣呭ぇ锛岄矞棣欏姹?, 2.50, 3.00, '涓?, 500, 1, 1, 1, 1),
(38, 3, 7, '鑿滃寘', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鏂伴矞钄彍锛屽仴搴风編鍛?, 2.00, 2.50, '涓?, 400, 1, 0, 0, 2),
(39, 3, 7, '璞嗘矙鍖?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '棣欑敎璞嗘矙锛岃蒋绯彲鍙?, 2.00, 2.50, '涓?, 350, 1, 0, 0, 3),
(40, 3, 7, '鑲夐緳', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '灞傚眰鑲夐锛屽洖鍛虫棤绌?, 4.00, 5.00, '涓?, 200, 1, 0, 0, 4),
(41, 3, 7, '濂堕粍鍖?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '濂堕娴撻儊锛岀敎鑰屼笉鑵?, 2.50, 3.00, '涓?, 180, 1, 0, 0, 5),
(42, 3, 8, '璞嗘祮', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鐜扮（璞嗘祮锛岄娴撹惀鍏?, 3.00, 4.00, '鏉?, 450, 1, 1, 0, 1),
(43, 3, 8, '灏忕背绮?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鍏昏儍灏忕背绮ワ紝娓╂殩韬績', 4.00, 5.00, '纰?, 300, 1, 0, 0, 2),
(44, 3, 8, '鍏疂绮?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '澶氱璋风墿锛屽吇鐢熷仴搴?, 5.00, 6.00, '纰?, 250, 1, 0, 0, 3),
(45, 3, 9, '鐓庨ゼ鏋滃瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '棣欒剢鍙彛锛屾棭椁愰閫?, 8.00, 10.00, '浠?, 380, 1, 1, 1, 1),
(46, 3, 9, '娌规潯', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閲戦粍閰ヨ剢锛屼紶缁熺編鍛?, 2.00, 2.50, '鏍?, 420, 1, 0, 0, 2),
(47, 3, 9, '鎵嬫姄楗?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰ヨ剢鍗冨眰锛岄叡棣欏洓婧?, 6.00, 8.00, '浠?, 300, 1, 0, 0, 3),
(48, 3, 9, '楦¤泲鐏岄ゼ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '楦¤泲棣欏锛岄ゼ鐨叆鑴?, 5.00, 6.00, '浠?, 280, 1, 0, 0, 4),
(49, 3, 19, '闃虫槬闈?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呮贰鐖藉彛锛岀畝鍗曠編鍛?, 8.00, 10.00, '纰?, 150, 1, 0, 0, 1),
(50, 3, 19, '棣勯エ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鐨杽棣呭锛屾堡椴滃懗缇?, 10.00, 12.00, '纰?, 140, 1, 0, 0, 2),
(51, 3, 20, '鐨泲鐦﹁倝绮?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鐨泲鐙壒锛岀槮鑲夐矞棣?, 8.00, 10.00, '纰?, 130, 1, 0, 0, 1),
(52, 3, 20, '鍗楃摐绮?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '棣欑敎杞朝锛岃惀鍏讳赴瀵?, 4.00, 5.00, '纰?, 120, 1, 0, 0, 2),

-- 闆堕灏忓崠閮ㄥ晢鍝?
(53, 4, 10, '钖墖', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰ヨ剢鐖藉彛锛屽绉嶅彛鍛?, 6.00, 8.00, '琚?, 280, 1, 1, 1, 1),
(54, 4, 10, '铏炬潯', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '椴滈铏惧懗锛岀骞村洖蹇?, 5.00, 6.00, '琚?, 200, 1, 0, 0, 2),
(55, 4, 10, '钖潯', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閲戦粍閰ヨ剢锛岃拷鍓у繀澶?, 5.00, 7.00, '琚?, 180, 1, 0, 0, 3),
(56, 4, 10, '鐖嗙背鑺?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '棣欑敎鐖嗚锛岀數褰辨惌妗?, 8.00, 10.00, '琚?, 160, 1, 0, 0, 4),
(57, 4, 11, '宸у厠鍔?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '涓濇粦娴撻儊锛岀敎铚滀韩鍙?, 12.00, 15.00, '鍧?, 150, 1, 1, 0, 1),
(58, 4, 11, '姘存灉绯?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '澶氱鍙ｅ懗锛岀敎铚滄粙鍛?, 3.00, 4.00, '琚?, 220, 1, 0, 0, 2),
(59, 4, 11, '濂剁硸', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '濂堕娴撻儊锛屾煍杞鐢?, 4.00, 5.00, '琚?, 190, 1, 0, 0, 3),
(60, 4, 11, '钖勮嵎绯?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呮柊鍙ｆ皵锛屾彁绁為啋鑴?, 2.00, 3.00, '鐩?, 170, 1, 0, 0, 4),
(61, 4, 12, '鍙箰', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鐣呯埥姘旀场锛岀粡鍏稿懗閬?, 4.00, 5.00, '鐡?, 350, 1, 1, 0, 1),
(62, 4, 12, '闆ⅶ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呯埥鏌犳锛岃В娓寸鍣?, 4.00, 5.00, '鐡?, 300, 1, 0, 0, 2),
(63, 4, 12, '姗欐眮', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鏂伴矞姗欐眮锛岀淮C婊℃弧', 5.00, 6.00, '鐡?, 250, 1, 0, 0, 3),
(64, 4, 12, '鍐滃か灞辨硥', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '澶╃劧鐭挎硥姘达紝鍋ュ悍鐢熸椿', 2.00, 3.00, '鐡?, 400, 1, 0, 0, 4),
(65, 4, 21, '娉￠潰', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鏂逛究蹇嵎锛屽澶滈閫?, 5.00, 6.00, '妗?, 200, 1, 0, 0, 1),
(66, 4, 21, '鑷儹绫抽キ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '闅忔椂闅忓湴锛屼韩鍙楃編椋?, 15.00, 18.00, '浠?, 150, 1, 0, 0, 2),
(67, 4, 22, '鐡滃瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '棣欒剢鐡滃瓙锛屼紤闂插繀澶?, 8.00, 10.00, '琚?, 180, 1, 0, 0, 1),
(68, 4, 22, '鑺辩敓', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '棣欒剢鑺辩敓锛屼笅閰掑ソ鑿?, 7.00, 9.00, '琚?, 160, 1, 0, 0, 2),
(69, 4, 22, '寮€蹇冩灉', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '钀ュ吇鍧氭灉锛屽仴搴烽浂椋?, 15.00, 18.00, '琚?, 120, 1, 0, 0, 3),
(70, 4, 23, '鐗涘ザ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '绾鐗涘ザ锛岃惀鍏绘棭椁?, 6.00, 7.00, '鐩?, 300, 1, 0, 0, 1),
(71, 4, 23, '閰稿ザ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰哥敎鍙彛锛屽姪娑堝寲', 7.00, 8.00, '鐩?, 280, 1, 0, 0, 2),

-- 宸濆懗瀹跺父鑿滃晢鍝?
(72, 5, 13, '姘寸叜楸?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '椴滃楸艰倝锛岄夯杈ｈ繃鐦?, 38.00, 48.00, '浠?, 120, 1, 1, 1, 1),
(73, 5, 13, '鍥為攨鑲?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鑲ヨ€屼笉鑵伙紝宸濊彍缁忓吀', 28.00, 35.00, '浠?, 150, 1, 1, 0, 2),
(74, 5, 13, '杈ｅ瓙楦?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '棣欒荆閰ヨ剢锛岃秺鍚冭秺棣?, 32.00, 40.00, '浠?, 130, 1, 0, 0, 3),
(75, 5, 13, '楹诲﹩璞嗚厫', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '楹昏荆椴滈锛岃眴鑵愬婊?, 18.00, 22.00, '浠?, 110, 1, 0, 0, 4),
(76, 5, 13, '瀹繚楦′竵', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '棣欒荆閰哥敎锛岄浮鑲夊婊?, 26.00, 32.00, '浠?, 100, 1, 0, 0, 5),
(77, 5, 14, '闈掓鑲変笣', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '瀹跺父灏忕倰锛屼笅楗鍣?, 22.00, 28.00, '浠?, 180, 1, 0, 0, 1),
(78, 5, 14, '楸奸鑲変笣', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰哥敎寰荆锛屽紑鑳冧笅楗?, 24.00, 30.00, '浠?, 160, 1, 0, 0, 2),
(79, 5, 14, '钂滆搲瑗垮叞鑺?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呯埥鍋ュ悍锛岃挏棣欏洓婧?, 16.00, 20.00, '浠?, 140, 1, 0, 0, 3),
(80, 5, 14, '骞茬吀鍥涘璞?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '骞查鍏ュ懗锛岃秺鍤艰秺棣?, 18.00, 22.00, '浠?, 130, 1, 0, 0, 4),
(81, 5, 14, '鐣寗鐐掕泲', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰哥敎鍙彛锛屽甯稿繀澶?, 15.00, 18.00, '浠?, 150, 1, 0, 0, 5),
(82, 5, 15, '閰歌荆姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰歌荆寮€鑳冿紝鏆栬儍鏆栧績', 12.00, 15.00, '浠?, 100, 1, 0, 0, 1),
(83, 5, 15, '绱彍铔嬭姳姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呮贰鐖藉彛锛岃惀鍏讳赴瀵?, 8.00, 10.00, '浠?, 90, 1, 0, 0, 2),
(84, 5, 15, '鐣寗铔嬫堡', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰哥敎寮€鑳冿紝绠€鍗曠編鍛?, 10.00, 12.00, '浠?, 85, 1, 0, 0, 3),
(85, 5, 24, '鍑夋媽榛勭摐', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呰剢鐖藉彛锛屽鏃ュ噳鑿?, 10.00, 12.00, '浠?, 80, 1, 0, 0, 1),
(86, 5, 24, '澶鑲虹墖', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '楹昏荆椴滈锛屼笅楗鍣?, 28.00, 35.00, '浠?, 75, 1, 0, 0, 2),
(87, 5, 24, '鍙ｆ按楦?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '楹昏荆椴滈锛岄浮鑲夊婊?, 26.00, 32.00, '浠?, 70, 1, 0, 0, 3),
(88, 5, 25, '绫抽キ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '棣欒蒋鍙彛锛屼笢鍖楀ぇ绫?, 2.00, 3.00, '浠?, 200, 1, 0, 0, 1),
(89, 5, 25, '棣掑ご', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鏉捐蒋鍙彛锛岄害棣欐祿閮?, 1.00, 1.50, '涓?, 150, 1, 0, 0, 2);

-- 鎻掑叆鐢ㄦ埛鏀惰揣鍦板潃
INSERT INTO user_address (address_id, user_id, receiver_name, receiver_phone, campus_area, address_detail, is_default) VALUES
(1, 2, '寮犱笁', '13800138001', '涓滄牎鍖?, '3鍙锋ゼ502瀹?, 1),
(2, 2, '寮犱笁', '13800138001', '涓滄牎鍖?, '鍥句功棣嗚嚜涔犲', 0),
(3, 3, '鏉庡洓', '13800138002', '涓滄牎鍖?, '3鍙锋ゼ503瀹?, 1),
(4, 4, '鐜嬩簲', '13800138003', '瑗挎牎鍖?, '5鍙锋ゼ301瀹?, 1),
(5, 5, '璧靛叚', '13800138004', '瑗挎牎鍖?, '5鍙锋ゼ302瀹?, 1),
(6, 6, '閽变竷', '13800138005', '涓滄牎鍖?, '4鍙锋ゼ201瀹?, 1),
(7, 12, '瀛欏叓', '13800138006', '涓滄牎鍖?, '6鍙锋ゼ101瀹?, 1),
(8, 13, '鍛ㄤ節', '13800138007', '瑗挎牎鍖?, '7鍙锋ゼ202瀹?, 1),
(9, 14, '鍚村崄', '13800138008', '涓滄牎鍖?, '8鍙锋ゼ303瀹?, 1),
(10, 15, '閮戝崄涓€', '13800138009', '瑗挎牎鍖?, '9鍙锋ゼ404瀹?, 1),
(11, 16, '鍐崄浜?, '13800138010', '涓滄牎鍖?, '10鍙锋ゼ505瀹?, 1),
(12, 17, '闄堝崄涓?, '13800138011', '瑗挎牎鍖?, '11鍙锋ゼ606瀹?, 1),
(13, 18, '瑜氬崄鍥?, '13800138012', '涓滄牎鍖?, '12鍙锋ゼ707瀹?, 1),
(14, 19, '鍗崄浜?, '13800138013', '瑗挎牎鍖?, '13鍙锋ゼ808瀹?, 1),
(15, 20, '钂嬪崄鍏?, '13800138014', '涓滄牎鍖?, '14鍙锋ゼ909瀹?, 1),
(16, 21, '娌堝崄涓?, '13800138015', '瑗挎牎鍖?, '15鍙锋ゼ1010瀹?, 1),
(17, 22, '闊╁崄鍏?, '13800138016', '涓滄牎鍖?, '16鍙锋ゼ1111瀹?, 1),
(18, 23, '鏉ㄥ崄涔?, '13800138017', '瑗挎牎鍖?, '17鍙锋ゼ1212瀹?, 1),
(19, 24, '鏈变簩鍗?, '13800138018', '涓滄牎鍖?, '18鍙锋ゼ1313瀹?, 1),
(20, 25, '绉︿簩涓€', '13800138019', '瑗挎牎鍖?, '19鍙锋ゼ1414瀹?, 1),
(21, 26, '灏や簩浜?, '13800138020', '涓滄牎鍖?, '20鍙锋ゼ1515瀹?, 1),
(22, 27, '璁镐簩涓?, '13800138021', '瑗挎牎鍖?, '21鍙锋ゼ1616瀹?, 1),
(23, 28, '浣曚簩鍥?, '13800138022', '涓滄牎鍖?, '22鍙锋ゼ1717瀹?, 1),
(24, 29, '鍚曚簩浜?, '13800138023', '瑗挎牎鍖?, '23鍙锋ゼ1818瀹?, 1),
(25, 30, '鏂戒簩鍏?, '13800138024', '涓滄牎鍖?, '24鍙锋ゼ1919瀹?, 1),
(26, 31, '寮犱簩涓?, '13800138025', '瑗挎牎鍖?, '25鍙锋ゼ2020瀹?, 1),
(27, 32, '瀛斾簩鍏?, '13800138026', '涓滄牎鍖?, '26鍙锋ゼ2121瀹?, 1),
(28, 33, '鏇逛簩涔?, '13800138027', '瑗挎牎鍖?, '27鍙锋ゼ2222瀹?, 1),
(29, 34, '涓ヤ笁鍗?, '13800138028', '涓滄牎鍖?, '28鍙锋ゼ2323瀹?, 1),
(30, 35, '鍗庝笁鍗佷竴', '13800138029', '瑗挎牎鍖?, '29鍙锋ゼ2424瀹?, 1),
(31, 36, '閲戜笁浜?, '13800138030', '涓滄牎鍖?, '30鍙锋ゼ2525瀹?, 1);

-- 鎻掑叆鍟嗗鍏ラ┗鐢宠鏁版嵁
INSERT INTO merchant_apply (apply_id, user_id, applicant_name, applicant_phone, shop_name, shop_description, shop_type, delivery_fee, audit_status, audit_remark, create_time) VALUES
(1, 7, '寮犺€佹澘', '13900139001', '绗竴椋熷爞蹇', '鏍″洯绗竴椋熷爞锛屾彁渚涚編鍛冲疄鎯犵殑蹇', 1, 1.00, 1, '瀹℃牳閫氳繃', '2024-01-15 10:00:00'),
(2, 8, '鏉庤€佹澘', '13900139002', '蹇箰濂惰尪搴?, '鏂伴矞濂惰尪锛屽揩涔愭瘡涓€澶?, 3, 0.00, 1, '瀹℃牳閫氳繃', '2024-01-16 14:30:00'),
(3, 9, '鐜嬭€佹澘', '13900139003', '鏃╅灏忛摵', '钀ュ吇鏃╅锛屽紑鍚編濂戒竴澶?, 3, 0.50, 1, '瀹℃牳閫氳繃', '2024-01-17 09:00:00'),
(4, 10, '璧佃€佹澘', '13900139004', '闆堕灏忓崠閮?, '鍚勭闆堕锛屾弧瓒充綘鐨勫懗钑?, 2, 1.50, 1, '瀹℃牳閫氳繃', '2024-01-18 16:00:00'),
(5, 11, '鍒樿€佹澘', '13900139005', '宸濆懗瀹跺父鑿?, '姝ｅ畻宸濊彍锛岄夯杈ｉ矞棣?, 1, 2.00, 1, '瀹℃牳閫氳繃', '2024-01-19 11:00:00'),
(6, 2, '寮犱笁', '13800138001', '瀛︾敓鍒涗笟灏忓簵', '瀛︾敓鑷富鍒涗笟锛屽敭鍗栨枃鍏风敤鍝?, 6, 1.00, 0, NULL, '2024-03-20 10:00:00'),
(7, 3, '鏉庡洓', '13800138002', '鏉庡洓姘存灉鎽?, '鏂伴矞姘存灉锛屾瘡鏃ラ厤閫?, 4, 0.00, 2, '璧勮川涓嶅叏锛岃琛ュ厖钀ヤ笟鎵х収', '2024-03-15 14:00:00');

-- 鎻掑叆璁㈠崟鏁版嵁
INSERT INTO order_info (order_id, order_no, user_id, shop_id, receiver_name, receiver_phone, receiver_address, total_amount, product_amount, delivery_fee, discount_amount, pay_amount, pay_type, order_status, pay_status, order_remark, create_time, pay_time) VALUES
(1, '202403200001', 2, 1, '寮犱笁', '13800138001', '涓滄牎鍖?鍙锋ゼ502瀹?, 31.00, 30.00, 1.00, 0.00, 31.00, 1, 5, 1, '澶氭斁杈ｆ', '2024-03-20 12:00:00', '2024-03-20 12:05:00'),
(2, '202403200002', 3, 2, '鏉庡洓', '13800138002', '涓滄牎鍖?鍙锋ゼ503瀹?, 25.00, 25.00, 0.00, 0.00, 25.00, 2, 5, 1, '灏戠硸', '2024-03-20 14:00:00', '2024-03-20 14:03:00'),
(3, '202403200003', 4, 3, '鐜嬩簲', '13800138003', '瑗挎牎鍖?鍙锋ゼ301瀹?, 15.50, 15.00, 0.50, 0.00, 15.50, 1, 4, 1, '', '2024-03-20 18:00:00', '2024-03-20 18:02:00'),
(4, '202403210001', 2, 5, '寮犱笁', '13800138001', '涓滄牎鍖?鍙锋ゼ502瀹?, 50.00, 48.00, 2.00, 0.00, 50.00, 1, 5, 1, '涓嶈棣欒彍', '2024-03-21 12:00:00', '2024-03-21 12:04:00'),
(5, '202403210002', 5, 4, '璧靛叚', '13800138004', '瑗挎牎鍖?鍙锋ゼ302瀹?, 22.50, 21.00, 1.50, 0.00, 22.50, 2, 3, 1, '', '2024-03-21 15:00:00', '2024-03-21 15:01:00'),
(6, '202403220001', 6, 1, '閽变竷', '13800138005', '涓滄牎鍖?鍙锋ゼ201瀹?, 16.00, 15.00, 1.00, 0.00, 16.00, 1, 1, 1, '', '2024-03-22 11:30:00', '2024-03-22 11:32:00'),
(7, '202403220002', 2, 2, '寮犱笁', '13800138001', '涓滄牎鍖?鍙锋ゼ502瀹?, 36.00, 36.00, 0.00, 0.00, 36.00, 1, 0, 0, '鍔犵弽鐝?, '2024-03-22 16:00:00', NULL),
(8, '202403220003', 3, 3, '鏉庡洓', '13800138002', '涓滄牎鍖?鍙锋ゼ503瀹?, 10.50, 10.00, 0.50, 0.00, 10.50, 2, 6, 0, '', '2024-03-22 09:00:00', NULL),
(9, '202403230001', 12, 1, '瀛欏叓', '13800138006', '涓滄牎鍖?鍙锋ゼ101瀹?, 28.00, 27.00, 1.00, 0.00, 28.00, 1, 5, 1, '寰荆', '2024-03-23 12:30:00', '2024-03-23 12:35:00'),
(10, '202403230002', 13, 2, '鍛ㄤ節', '13800138007', '瑗挎牎鍖?鍙锋ゼ202瀹?, 27.00, 27.00, 0.00, 0.00, 27.00, 2, 5, 1, '', '2024-03-23 14:00:00', '2024-03-23 14:05:00'),
(11, '202403230003', 14, 3, '鍚村崄', '13800138008', '涓滄牎鍖?鍙锋ゼ303瀹?, 12.00, 11.00, 1.00, 0.00, 12.00, 1, 4, 1, '澶氬姞钁辫姳', '2024-03-23 08:00:00', '2024-03-23 08:05:00'),
(12, '202403230004', 15, 4, '閮戝崄涓€', '13800138009', '瑗挎牎鍖?鍙锋ゼ404瀹?, 35.00, 33.00, 2.00, 0.00, 35.00, 1, 5, 1, '', '2024-03-23 16:00:00', '2024-03-23 16:08:00'),
(13, '202403240001', 16, 5, '鍐崄浜?, '13800138010', '涓滄牎鍖?0鍙锋ゼ505瀹?, 68.00, 66.00, 2.00, 0.00, 68.00, 1, 5, 1, '姘寸叜楸艰鐗硅荆', '2024-03-24 12:00:00', '2024-03-24 12:10:00'),
(14, '202403240002', 17, 1, '闄堝崄涓?, '13800138011', '瑗挎牎鍖?1鍙锋ゼ606瀹?, 45.00, 44.00, 1.00, 0.00, 45.00, 1, 3, 1, '', '2024-03-24 18:30:00', '2024-03-24 18:35:00'),
(15, '202403240003', 18, 2, '瑜氬崄鍥?, '13800138012', '涓滄牎鍖?2鍙锋ゼ707瀹?, 42.00, 42.00, 0.00, 0.00, 42.00, 2, 5, 1, '鍘诲啺', '2024-03-24 15:00:00', '2024-03-24 15:03:00'),
(16, '202403250001', 19, 3, '鍗崄浜?, '13800138013', '瑗挎牎鍖?3鍙锋ゼ808瀹?, 18.00, 17.00, 1.00, 0.00, 18.00, 1, 4, 1, '', '2024-03-25 07:30:00', '2024-03-25 07:35:00'),
(17, '202403250002', 20, 4, '钂嬪崄鍏?, '13800138014', '涓滄牎鍖?4鍙锋ゼ909瀹?, 28.00, 26.00, 2.00, 0.00, 28.00, 1, 5, 1, '瑕佷繚娓╄', '2024-03-25 20:00:00', '2024-03-25 20:05:00'),
(18, '202403250003', 21, 5, '娌堝崄涓?, '13800138015', '瑗挎牎鍖?5鍙锋ゼ1010瀹?, 56.00, 54.00, 2.00, 0.00, 56.00, 1, 2, 1, '', '2024-03-25 12:00:00', '2024-03-25 12:08:00'),
(19, '202403260001', 22, 1, '闊╁崄鍏?, '13800138016', '涓滄牎鍖?6鍙锋ゼ1111瀹?, 33.00, 32.00, 1.00, 0.00, 33.00, 1, 5, 1, '灏戠洂', '2024-03-26 12:30:00', '2024-03-26 12:35:00'),
(20, '202403260002', 23, 2, '鏉ㄥ崄涔?, '13800138017', '瑗挎牎鍖?7鍙锋ゼ1212瀹?, 24.00, 24.00, 0.00, 0.00, 24.00, 2, 1, 1, '', '2024-03-26 10:00:00', '2024-03-26 10:02:00'),
(21, '202403260003', 24, 3, '鏈变簩鍗?, '13800138018', '涓滄牎鍖?8鍙锋ゼ1313瀹?, 15.50, 15.00, 0.50, 0.00, 15.50, 1, 6, 1, '鍔犺荆', '2024-03-26 08:00:00', '2024-03-26 08:03:00'),
(22, '202403270001', 25, 4, '绉︿簩涓€', '13800138019', '瑗挎牎鍖?9鍙锋ゼ1414瀹?, 19.00, 18.00, 1.00, 0.00, 19.00, 1, 5, 1, '', '2024-03-27 14:00:00', '2024-03-27 14:05:00'),
(23, '202403270002', 26, 5, '灏や簩浜?, '13800138020', '涓滄牎鍖?0鍙锋ゼ1515瀹?, 42.00, 40.00, 2.00, 0.00, 42.00, 1, 3, 1, '涓嶈鑺辨', '2024-03-27 19:00:00', '2024-03-27 19:08:00'),
(24, '202403270003', 27, 1, '璁镐簩涓?, '13800138021', '瑗挎牎鍖?1鍙锋ゼ1616瀹?, 26.00, 25.00, 1.00, 0.00, 26.00, 1, 4, 1, '', '2024-03-27 12:00:00', '2024-03-27 12:05:00'),
(25, '202403280001', 28, 2, '浣曚簩鍥?, '13800138022', '涓滄牎鍖?2鍙锋ゼ1717瀹?, 31.00, 31.00, 0.00, 0.00, 31.00, 2, 5, 1, '鍗婄硸', '2024-03-28 15:00:00', '2024-03-28 15:03:00'),
(26, '202403280002', 29, 3, '鍚曚簩浜?, '13800138023', '瑗挎牎鍖?3鍙锋ゼ1818瀹?, 22.00, 21.00, 1.00, 0.00, 22.00, 1, 2, 1, '', '2024-03-28 07:00:00', '2024-03-28 07:05:00'),
(27, '202403280003', 30, 4, '鏂戒簩鍏?, '13800138024', '涓滄牎鍖?4鍙锋ゼ1919瀹?, 46.00, 44.00, 2.00, 0.00, 46.00, 1, 5, 1, '', '2024-03-28 17:00:00', '2024-03-28 17:08:00'),
(28, '202403290001', 31, 5, '寮犱簩涓?, '13800138025', '瑗挎牎鍖?5鍙锋ゼ2020瀹?, 38.00, 36.00, 2.00, 0.00, 38.00, 1, 1, 1, '寰荆灏卞ソ', '2024-03-29 12:00:00', '2024-03-29 12:05:00'),
(29, '202403290002', 32, 1, '瀛斾簩鍏?, '13800138026', '涓滄牎鍖?6鍙锋ゼ2121瀹?, 17.00, 16.00, 1.00, 0.00, 17.00, 1, 6, 0, '', '2024-03-29 18:00:00', NULL),
(30, '202403290003', 33, 2, '鏇逛簩涔?, '13800138027', '瑗挎牎鍖?7鍙锋ゼ2222瀹?, 25.00, 25.00, 0.00, 0.00, 25.00, 2, 0, 0, '姝ｅ父鍐?, '2024-03-29 14:00:00', NULL),
(31, '202403300001', 34, 3, '涓ヤ笁鍗?, '13800138028', '涓滄牎鍖?8鍙锋ゼ2323瀹?, 8.50, 8.00, 0.50, 0.00, 8.50, 1, 5, 1, '', '2024-03-30 07:30:00', '2024-03-30 07:32:00'),
(32, '202403300002', 35, 4, '鍗庝笁鍗佷竴', '13800138029', '瑗挎牎鍖?9鍙锋ゼ2424瀹?, 14.00, 12.00, 2.00, 0.00, 14.00, 1, 4, 1, '', '2024-03-30 16:00:00', '2024-03-30 16:05:00'),
(33, '202403300003', 36, 5, '閲戜笁浜?, '13800138030', '涓滄牎鍖?0鍙锋ゼ2525瀹?, 52.00, 50.00, 2.00, 0.00, 52.00, 1, 5, 1, '澶氭斁杈?, '2024-03-30 19:00:00', '2024-03-30 19:08:00');

-- 鎻掑叆璁㈠崟璇︽儏鏁版嵁
INSERT INTO order_item (item_id, order_id, order_no, product_id, product_name, product_image, product_price, product_num, total_price) VALUES
(1, 1, '202403200001', 1, '绾㈢儳鑲夊椁?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 15.00, 1, 15.00),
(2, 1, '202403200001', 7, '楹诲﹩璞嗚厫', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 8.00, 1, 8.00),
(3, 1, '202403200001', 12, '绱彍铔嬭姳姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 3.00, 1, 3.00),
(4, 1, '202403200001', 16, '绫抽キ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.00, 2, 4.00),
(5, 2, '202403200002', 21, '鐝嶇彔濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 12.00, 2, 24.00),
(6, 2, '202403200002', 34, '娉㈤湼', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.00, 1, 2.00),
(7, 3, '202403200003', 37, '椴滆倝鍖呭瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.50, 2, 5.00),
(8, 3, '202403200003', 42, '璞嗘祮', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 3.00, 1, 3.00),
(9, 3, '202403200003', 46, '娌规潯', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.00, 3, 6.00),
(10, 4, '202403210001', 72, '姘寸叜楸?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 38.00, 1, 38.00),
(11, 4, '202403210001', 82, '閰歌荆姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 12.00, 1, 12.00),
(12, 4, '202403210001', 88, '绫抽キ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.00, 2, 4.00),
(13, 5, '202403210002', 53, '钖墖', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 6.00, 2, 12.00),
(14, 5, '202403210002', 57, '宸у厠鍔?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 12.00, 1, 12.00),
(15, 5, '202403210002', 61, '鍙箰', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 4.00, 2, 8.00),
(16, 6, '202403220001', 2, '绯栭唻閲岃剨濂楅', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 14.00, 1, 14.00),
(17, 7, '202403220002', 22, '妞版灉濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 13.00, 2, 26.00),
(18, 7, '202403220002', 26, '鏌犳绾㈣尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 10.00, 1, 10.00),
(19, 8, '202403220003', 37, '椴滆倝鍖呭瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.50, 4, 10.00),
(20, 9, '202403230001', 1, '绾㈢儳鑲夊椁?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 15.00, 1, 15.00),
(21, 9, '202403230001', 6, '楸奸鑲変笣', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 12.00, 1, 12.00),
(22, 10, '202403230002', 24, '鑺嬫偿濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 15.00, 1, 15.00),
(23, 10, '202403230002', 27, '鐧鹃鏋滆尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 12.00, 1, 12.00),
(24, 11, '202403230003', 45, '鐓庨ゼ鏋滃瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 8.00, 1, 8.00),
(25, 11, '202403230003', 42, '璞嗘祮', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 3.00, 1, 3.00),
(26, 12, '202403230004', 57, '宸у厠鍔?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 12.00, 2, 24.00),
(27, 12, '202403230004', 61, '鍙箰', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 4.00, 2, 8.00),
(28, 13, '202403240001', 72, '姘寸叜楸?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 38.00, 1, 38.00),
(29, 13, '202403240001', 77, '闈掓鑲変笣', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 22.00, 1, 22.00),
(30, 13, '202403240001', 88, '绫抽キ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.00, 2, 4.00),
(31, 14, '202403240002', 1, '绾㈢儳鑲夊椁?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 15.00, 2, 30.00),
(32, 14, '202403240002', 9, '灏栨鍦熻眴涓?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 6.00, 2, 12.00),
(33, 15, '202403240003', 23, '甯冧竵濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 14.00, 2, 28.00),
(34, 15, '202403240003', 35, '妞版灉', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 1.50, 2, 3.00),
(35, 15, '202403240003', 33, '鎽╁崱鍜栧暋', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 19.00, 1, 19.00),
(36, 16, '202403250001', 37, '椴滆倝鍖呭瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.50, 3, 7.50),
(37, 16, '202403250001', 46, '娌规潯', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.00, 3, 6.00),
(38, 16, '202403250001', 42, '璞嗘祮', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 3.00, 1, 3.00),
(39, 17, '202403250002', 53, '钖墖', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 6.00, 3, 18.00),
(40, 17, '202403250002', 65, '娉￠潰', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 5.00, 2, 10.00),
(41, 18, '202403250003', 73, '鍥為攨鑲?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 28.00, 1, 28.00),
(42, 18, '202403250003', 74, '杈ｅ瓙楦?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 32.00, 1, 32.00),
(43, 19, '202403260001', 3, '瀹繚楦′竵濂楅', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 13.00, 2, 26.00),
(44, 19, '202403260001', 14, '閰歌荆姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 4.00, 1, 4.00),
(45, 20, '202403260002', 21, '鐝嶇彔濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 12.00, 2, 24.00),
(46, 21, '202403260003', 37, '椴滆倝鍖呭瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.50, 2, 5.00),
(47, 21, '202403260003', 48, '楦¤泲鐏岄ゼ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 5.00, 1, 5.00),
(48, 22, '202403270001', 57, '宸у厠鍔?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 12.00, 1, 12.00),
(49, 22, '202403270001', 62, '闆ⅶ', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 4.00, 2, 8.00),
(50, 23, '202403270002', 72, '姘寸叜楸?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 38.00, 1, 38.00),
(51, 23, '202403270002', 79, '钂滆搲瑗垮叞鑺?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 16.00, 1, 16.00),
(52, 24, '202403270003', 2, '绯栭唻閲岃剨濂楅', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 14.00, 1, 14.00),
(53, 24, '202403270003', 7, '楹诲﹩璞嗚厫', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 8.00, 1, 8.00),
(54, 25, '202403280001', 22, '妞版灉濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 13.00, 1, 13.00),
(55, 25, '202403280001', 25, '绾㈣眴濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 13.00, 1, 13.00),
(56, 26, '202403280002', 37, '椴滆倝鍖呭瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.50, 4, 10.00),
(57, 26, '202403280002', 42, '璞嗘祮', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 3.00, 1, 3.00),
(58, 27, '202403280003', 53, '钖墖', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 6.00, 3, 18.00),
(59, 27, '202403280003', 67, '鐡滃瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 8.00, 2, 16.00),
(60, 28, '202403290001', 76, '瀹繚楦′竵', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 26.00, 1, 26.00),
(61, 28, '202403290001', 75, '楹诲﹩璞嗚厫', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 18.00, 1, 18.00),
(62, 29, '202403290002', 4, '涓滃潯鑲夊椁?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 16.00, 1, 16.00),
(63, 30, '202403290003', 28, '鑺掓灉澶氬', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 14.00, 1, 14.00),
(64, 30, '202403290003', 31, '鎷块搧鍜栧暋', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 18.00, 1, 18.00),
(65, 31, '202403300001', 45, '鐓庨ゼ鏋滃瓙', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 8.00, 1, 8.00),
(66, 32, '202403300002', 54, '铏炬潯', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 5.00, 2, 10.00),
(67, 33, '202403300003', 72, '姘寸叜楸?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 38.00, 1, 38.00),
(68, 33, '202403300003', 73, '鍥為攨鑲?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 28.00, 1, 28.00);

-- 鎻掑叆璐墿杞︽暟鎹?
INSERT INTO shopping_cart (cart_id, user_id, shop_id, product_id, product_num, is_checked) VALUES
(1, 2, 1, 3, 1, 1),
(2, 2, 1, 6, 2, 1),
(3, 2, 2, 13, 1, 0),
(4, 3, 3, 17, 3, 1),
(5, 4, 5, 30, 1, 1),
(6, 5, 4, 24, 2, 1),
(7, 6, 2, 15, 1, 0),
(8, 12, 1, 5, 2, 1),
(9, 13, 2, 27, 1, 1),
(10, 14, 3, 45, 1, 1),
(11, 15, 4, 53, 2, 1),
(12, 16, 5, 72, 1, 1),
(13, 17, 1, 2, 1, 0),
(14, 18, 2, 22, 1, 1),
(15, 19, 3, 37, 3, 1),
(16, 20, 4, 61, 2, 1),
(17, 21, 5, 73, 1, 1),
(18, 22, 1, 7, 2, 1),
(19, 23, 2, 28, 1, 0),
(20, 24, 3, 42, 2, 1),
(21, 25, 4, 57, 1, 1),
(22, 26, 5, 74, 1, 1),
(23, 27, 1, 1, 1, 0),
(24, 28, 2, 30, 1, 1),
(25, 29, 3, 46, 2, 1),
(26, 30, 4, 65, 1, 1),
(27, 31, 5, 77, 1, 1),
(28, 32, 1, 14, 1, 0),
(29, 33, 2, 33, 1, 1),
(30, 34, 3, 38, 2, 1),
(31, 35, 4, 70, 1, 1),
(32, 36, 5, 88, 2, 1);


-- =============================================
-- 添加更多测试数据
-- =============================================

INSERT INTO sys_user (user_no, password, phone, user_name, status, user_type) VALUES
('2021001021', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '15900159001', '璁镐簩鍗佷笁', 1, 1),
('2021001022', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '15900159002', '浣曚簩鍗佸洓', 1, 1),
('2021001023', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '15900159003', '鍚曚簩鍗佷簲', 1, 1),
('2021001024', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '15900159004', '鏂戒簩鍗佸叚', 1, 1),
('2021001025', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '15900159005', '寮犱簩鍗佷竷', 1, 1),
('2021001026', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '15900159006', '瀛斾簩鍗佸叓', 1, 1),
('2021001027', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '15900159007', '鏇逛簩鍗佷節', 1, 1),
('2021001028', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '15900159008', '涓ヤ笁鍗?, 1, 1),
('2021001029', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '15900159009', '鍗庝笁鍗佷竴', 1, 1),
('2021001030', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '15900159010', '閲戜笁鍗佷簩', 1, 1);

-- =============================================
-- 2. 娣诲姞鏇村鍟嗗搧鏁版嵁锛堜娇鐢ㄧ幇鏈夊垎绫伙級
-- =============================================
INSERT INTO product_info (category_id, shop_id, product_name, product_image, product_desc, original_price, price, unit, sort, is_hot, is_recommend) VALUES
(1, 1, '棣欒荆楦¤吙濂楅', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '澶栭叆閲屽锛岄杈ｅ彲鍙?, 30.00, 26.00, '浠?, 17, 1, 1),
(2, 1, '钂滆搲瑗垮叞鑺?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '钂滈娴撻儊锛岃惀鍏诲仴搴?, 16.00, 13.00, '浠?, 16, 0, 0),
(3, 1, '娴峰甫璞嗚厫姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '娓呮贰鐖藉彛锛岃ˉ鍏呯璐?, 10.00, 8.00, '浠?, 17, 0, 0),
(4, 2, '鑽夎帗濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鏂伴矞鑽夎帗锛屽ザ棣欐祿閮?, 18.00, 15.00, '鏉?, 16, 0, 1),
(5, 2, '鑻规灉姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鏂伴矞鑻规灉锛岀幇姒ㄧ幇鍗?, 12.00, 10.00, '鏉?, 15, 0, 0),
(6, 2, '鎽╁崱鍜栧暋', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '宸у厠鍔涗笌鍜栧暋鐨勫畬缇庣粨鍚?, 24.00, 20.00, '鏉?, 16, 0, 1),
(7, 3, '濂堕粍鍖?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '濂堕娴撻儊锛屽彛鎰熺粏鑵?, 3.50, 3.00, '涓?, 16, 0, 0),
(8, 3, '榛戠背绮?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '鍏荤敓鍋ュ悍锛岃惀鍏讳赴瀵?, 10.00, 8.00, '纰?, 17, 0, 0),
(9, 3, '鎵嬫姄楗?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰ヨ剢鍙彛锛屽彲鍔犺泲鍔犺偁', 10.00, 8.00, '浠?, 16, 1, 0),
(10, 4, '鑶ㄥ寲铏炬潯', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '閰ヨ剢椴滈锛屽効鏃跺懗閬?, 9.00, 7.00, '琚?, 16, 0, 0),
(11, 4, '濂剁硸', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '濂堕娴撻儊锛岀敎铚滃洖鍛?, 10.00, 8.00, '琚?, 15, 0, 0),
(12, 4, '鐭挎硥姘?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '绾噣姘存簮锛岃В娓村繀澶?, 2.00, 1.50, '鐡?, 16, 1, 0),
(13, 5, '姣涜鏃?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '楹昏荆椴滈锛屽窛鑿滅粡鍏?, 58.00, 48.00, '浠?, 16, 1, 1),
(14, 5, '楹诲﹩璞嗚厫', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '楹昏荆瀚╂粦锛屼笅楗鍣?, 18.00, 15.00, '浠?, 15, 1, 0),
(15, 5, '娴峰甫鎺掗姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', '钀ュ吇涓板瘜锛屽懗閬撻矞缇?, 22.00, 18.00, '浠?, 16, 0, 0);

-- =============================================
-- 3. 娣诲姞鏇村璁㈠崟鏁版嵁
-- =============================================
INSERT INTO order_info (order_no, user_id, shop_id, receiver_name, receiver_phone, receiver_address, product_amount, delivery_fee, discount_amount, pay_amount, order_status, pay_type, pay_status, order_remark, expire_time) VALUES
('202403240006', 29, 1, '璁镐簩鍗佷笁', '15900159001', '涓滄牎鍖?1鍙锋ゼ301瀹?, 45.00, 0.00, 0.00, 45.00, 2, 1, 1, '', '2024-03-24 15:00:00'),
('202403240007', 30, 2, '浣曚簩鍗佸洓', '15900159002', '瑗挎牎鍖?2鍙锋ゼ402瀹?, 25.00, 0.00, 0.00, 25.00, 3, 1, 1, '', '2024-03-24 16:00:00'),
('202403240008', 31, 3, '鍚曚簩鍗佷簲', '15900159003', '鍗楁牎鍖?3鍙锋ゼ203瀹?, 18.00, 0.00, 0.00, 18.00, 4, 1, 1, '', '2024-03-24 17:00:00'),
('202403240009', 32, 4, '鏂戒簩鍗佸叚', '15900159004', '鍖楁牎鍖?4鍙锋ゼ104瀹?, 30.00, 0.00, 0.00, 30.00, 5, 1, 1, '', '2024-03-24 18:00:00'),
('202403240010', 33, 5, '寮犱簩鍗佷竷', '15900159005', '涓滄牎鍖?5鍙锋ゼ501瀹?, 68.00, 0.00, 0.00, 68.00, 2, 1, 1, '涓嶈杈?, '2024-03-24 19:00:00'),
('202403250001', 34, 1, '瀛斾簩鍗佸叓', '15900159006', '瑗挎牎鍖?6鍙锋ゼ302瀹?, 36.00, 0.00, 0.00, 36.00, 3, 1, 1, '', '2024-03-25 10:00:00'),
('202403250002', 35, 2, '鏇逛簩鍗佷節', '15900159007', '鍗楁牎鍖?7鍙锋ゼ201瀹?, 22.00, 0.00, 0.00, 22.00, 4, 1, 1, '', '2024-03-25 11:00:00'),
('202403250003', 36, 3, '涓ヤ笁鍗?, '15900159008', '鍖楁牎鍖?8鍙锋ゼ403瀹?, 20.00, 0.00, 0.00, 20.00, 5, 1, 1, '', '2024-03-25 12:00:00'),
('202403250004', 37, 4, '鍗庝笁鍗佷竴', '15900159009', '涓滄牎鍖?9鍙锋ゼ102瀹?, 40.00, 0.00, 0.00, 40.00, 1, 1, 0, '', '2024-03-25 13:00:00'),
('202403250005', 38, 5, '閲戜笁鍗佷簩', '15900159010', '瑗挎牎鍖?0鍙锋ゼ504瀹?, 52.00, 0.00, 0.00, 52.00, 1, 1, 0, '', '2024-03-25 14:00:00');

-- =============================================
-- 4. 娣诲姞鏇村璁㈠崟璇︽儏鏁版嵁
-- =============================================
INSERT INTO order_item (order_id, order_no, product_id, product_name, product_image, product_price, product_num, total_price) VALUES
(26, '202403240006', 1, '绾㈢儳鑲夊椁?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 15.00, 2, 30.00),
(26, '202403240006', 6, '楸奸鑲変笣', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 12.00, 1, 12.00),
(27, '202403240007', 14, '鐝嶇彔濂惰尪', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 12.00, 1, 12.00),
(27, '202403240007', 15, '鑺掓灉姹?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 10.00, 1, 10.00),
(28, '202403240008', 20, '璞嗘祮', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 3.00, 2, 6.00),
(28, '202403240008', 22, '娌规潯', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.50, 4, 10.00),
(29, '202403240009', 25, '涔愪簨钖墖', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 8.00, 2, 16.00),
(29, '202403240009', 27, '鍙彛鍙箰', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 5.00, 2, 10.00),
(30, '202403240010', 30, '姘寸叜楸?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 38.00, 1, 38.00),
(30, '202403240010', 33, '鍥為攨鑲?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 28.00, 1, 28.00),
(31, '202403250001', 2, '瀹繚楦′竵濂楅', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 14.00, 2, 28.00),
(31, '202403250001', 7, '閰歌荆鍦熻眴涓?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 8.00, 1, 8.00),
(32, '202403250002', 17, '鎷块搧鍜栧暋', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 18.00, 1, 18.00),
(33, '202403250003', 22, '娌规潯', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 2.50, 4, 10.00),
(33, '202403250003', 20, '璞嗘祮', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 3.00, 2, 6.00),
(34, '202403250004', 25, '涔愪簨钖墖', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 8.00, 3, 24.00),
(34, '202403250004', 27, '鍙彛鍙箰', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 5.00, 3, 15.00),
(35, '202403250005', 30, '姘寸叜楸?, 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 38.00, 1, 38.00),
(35, '202403250005', 34, '闈掓鑲変笣', 'https://firstaliyun-twk.oss-cn-beijing.aliyuncs.com/images/20260505/8fe8d54549c74b41a316ab889feae966.jpeg', 18.00, 1, 18.00);

-- =============================================
-- 鏁版嵁娣诲姞瀹屾垚
-- =============================================
SELECT '鏁版嵁娣诲姞瀹屾垚' as 缁撴灉;
