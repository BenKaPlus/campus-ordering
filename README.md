# 校园点餐系统 (Campus Ordering System)

基于 Spring Boot + Vue 的校园点餐系统，提供完整的在线点餐、订单管理、店铺管理等功能。

## 项目简介

这是一个面向校园场景的在线点餐平台，支持学生用户在线浏览店铺、点餐下单，商家用户管理店铺和订单，管理员进行平台管理。系统采用前后端分离架构，支持多角色权限控制。

### 主要功能

#### 🎓 学生端
- 浏览店铺和商品
- 加入购物车、在线下单
- 订单状态跟踪
- 地址管理
- 个人信息管理

#### 🏪 商家端
- 店铺管理（营业状态、店铺信息）
- 商品管理（分类、商品上下架、规格）
- 订单管理（接单、备餐、出餐）
- 经营数据统计

#### 👨‍💼 管理员端
- 用户管理
- 商家审核
- 商品管理
- 订单管理
- 系统配置

## 技术栈

### 后端技术
- **框架**: Spring Boot 2.6.13
- **安全**: Spring Security + JWT
- **ORM**: MyBatis-Plus 3.5.3.1
- **数据库**: MySQL 5.7+
- **缓存**: Redis
- **连接池**: Druid
- **API 文档**: Swagger 3.0.0
- **工具库**: Hutool、Lombok
- **实时通信**: WebSocket

### 前端技术
- **框架**: Vue 2.6.14
- **UI 组件库**: Element UI 2.15.14
- **路由**: Vue Router 3.6.5
- **状态管理**: Vuex 3.6.2
- **HTTP 客户端**: Axios 1.13.6
- **时间处理**: Day.js
- **实时通信**: SockJS + STOMP

## 项目结构

```
campus-ordering/
├── campus-ordering-frontend/     # 前端项目
│   ├── public/                   # 静态资源
│   ├── src/
│   │   ├── api/                  # API 接口
│   │   ├── assets/               # 资源文件
│   │   ├── components/           # 组件
│   │   ├── router/               # 路由配置
│   │   ├── store/                # 状态管理
│   │   ├── utils/                # 工具类
│   │   └── views/                # 页面视图
│   │       ├── admin/            # 管理员页面
│   │       ├── merchant/         # 商家页面
│   │       └── student/          # 学生页面
│   └── package.json
├── campus_ordering_system/       # 后端项目
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   │   └── com/campus/ordering/
│   │   │   │       ├── config/   # 配置类
│   │   │   │       ├── controller/ # 控制器
│   │   │   │       ├── dto/      # 数据传输对象
│   │   │   │       ├── entity/   # 实体类
│   │   │   │       ├── mapper/   # Mapper 接口
│   │   │   │       ├── security/ # 安全相关
│   │   │   │       ├── service/  # 业务逻辑
│   │   │   │       └── vo/       # 视图对象
│   │   │   └── resources/
│   │   │       ├── mapper/       # MyBatis XML
│   │   │       └── application*.yml # 配置文件
│   │   └── test/                 # 测试代码
│   └── pom.xml
└── campus_ordering_system.sql    # 数据库脚本
```

## 快速开始

### 环境要求

- **JDK**: 11 或 17
- **Node.js**: 14.x 或更高版本
- **MySQL**: 5.7 或更高版本
- **Redis**: 5.0 或更高版本
- **Maven**: 3.6+
- **npm**: 6.x 或更高版本

### 数据库初始化

1. 创建数据库并导入数据

```bash
# 使用 MySQL 客户端执行
mysql -u root -p < campus_ordering_system.sql
```

或者手动执行 SQL 文件中的语句。

2. 修改数据库配置

编辑 `campus_ordering_system/src/main/resources/application-dev.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/campus_ordering_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=GMT%2B8
    username: your_username
    password: your_password
```

### Redis 配置

编辑 `campus_ordering_system/src/main/resources/application-dev.yml`：

```yaml
spring:
  redis:
    host: localhost
    port: 6379
    password: # 如有密码请配置
```

### 后端启动

1. 进入后端项目目录

```bash
cd campus_ordering_system
```

2. 使用 Maven 构建并运行

```bash
# 方式一：使用 Maven 命令
mvn spring-boot:run

# 方式二：先打包再运行
mvn clean package -DskipTests
java -jar target/ordering-system-1.0.0.jar
```

3. 验证启动

后端服务启动成功后，访问：
- **应用地址**: http://localhost:8080/api
- **API 文档**: http://localhost:8080/api/swagger-ui/index.html
- **Druid 监控**: http://localhost:8080/api/druid (账号：admin, 密码：admin123)

### 前端启动

1. 进入前端项目目录

```bash
cd campus-ordering-frontend
```

2. 安装依赖

```bash
npm install
```

3. 启动开发服务器

```bash
npm run serve
```

4. 访问应用

前端服务启动后，访问：http://localhost:8080 (如有端口冲突会自动使用其他端口)

## 默认账号

系统初始化后，可使用以下默认账号登录：

- **管理员**: 
  - 账号：admin
  - 密码：092100

- **商家**: 
  - 账号：merchant001
  - 密码：092100

- **学生**: 
  - 账号：student001
  - 密码：092100

> ⚠️ **安全提示**: 首次部署后请立即修改默认密码！

## 配置文件说明

### 后端配置

- `application.yml`: 全局配置文件
- `application-dev.yml`: 开发环境配置
- `application-prod.yml`: 生产环境配置

主要配置项：
- 服务器端口和上下文路径
- 数据库连接信息
- Redis 连接信息
- JWT 密钥和过期时间
- 文件上传路径
- 日志配置

### 前端配置

- `vue.config.js`: Vue CLI 配置
- `.env`: 环境变量配置

## API 接口

系统提供 RESTful API 接口，主要接口包括：

### 认证相关
- `POST /auth/login` - 用户登录
- `POST /auth/logout` - 用户登出
- `POST /auth/register/student` - 学生注册
- `POST /auth/register/merchant` - 商家注册

### 学生端
- `GET /student/shops` - 获取店铺列表
- `GET /student/products` - 获取商品列表
- `POST /student/cart` - 添加购物车
- `POST /student/order` - 创建订单
- `GET /student/orders` - 获取订单列表

### 商家端
- `GET /merchant/shop` - 获取店铺信息
- `POST /merchant/product` - 添加商品
- `PUT /merchant/order/accept` - 接单
- `PUT /merchant/order/complete` - 完成订单

### 管理员端
- `GET /admin/users` - 用户管理
- `GET /admin/merchants` - 商家审核
- `GET /admin/orders` - 订单管理

详细接口文档请访问：http://localhost:8080/api/swagger-ui/index.html

## 数据库表结构

系统主要包含以下数据表：

### 权限与用户
- `sys_role` - 系统角色表
- `sys_menu` - 系统菜单权限表
- `sys_user` - 系统用户表
- `sys_user_role` - 用户角色关联表
- `sys_role_menu` - 角色菜单关联表
- `sys_operation_log` - 操作日志表

### 学生与地址
- `student_info` - 学生详细信息表
- `user_address` - 用户收货地址表

### 商家与店铺
- `shop_category` - 店铺分类表
- `shop_info` - 商家店铺信息表

### 商品相关
- `product_category` - 商品分类表
- `product_info` - 商品信息表
- `product_spec` - 商品规格表

### 购物车与订单
- `shopping_cart` - 购物车表
- `order_info` - 订单主表
- `order_item` - 订单详情表
- `order_status_log` - 订单状态流转日志表
- `order_refund` - 订单退款表

### 支付相关
- `payment_info` - 支付信息表
- `refund_info` - 退款信息表

### 其他
- `message_notice` - 消息通知表
- `sys_announcement` - 系统公告表

## 开发指南

### 后端开发

1. 实体类位于 `entity` 包
2. Mapper 接口位于 `mapper` 包，XML 文件位于 `resources/mapper`
3. Service 接口和实现类位于 `service` 包
4. Controller 位于 `controller` 包
5. 使用 MyBatis-Plus 提供的 BaseMapper 和 Service 简化开发

### 前端开发

1. 页面组件位于 `src/views`
2. API 接口封装位于 `src/api`
3. 路由配置位于 `src/router`
4. 状态管理位于 `src/store`
5. 工具类位于 `src/utils`

## 常见问题

### 1. 后端启动失败

- 检查 MySQL 是否启动
- 检查数据库配置是否正确
- 检查端口 8080 是否被占用

### 2. 前端无法连接后端

- 检查后端服务是否启动
- 检查 `vue.config.js` 中的代理配置
- 检查跨域配置

### 3. 登录失败

- 检查数据库中是否存在对应用户
- 检查 JWT 密钥配置
- 查看后端日志确认错误信息

## 系统部署

### 生产环境配置

1. 修改 `application-prod.yml` 中的配置
2. 使用强 JWT 密钥
3. 配置 HTTPS
4. 配置合适的数据库连接池参数
5. 配置日志文件路径

### 构建部署

```bash
# 后端构建
mvn clean package -DskipTests -P prod

# 前端构建
cd campus-ordering-frontend
npm run build
```

## 许可证

本项目仅供学习和交流使用。

## 联系方式

如有问题或建议，欢迎通过 Issue 反馈。
