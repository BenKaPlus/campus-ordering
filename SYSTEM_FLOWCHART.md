# 校园订餐系统流程图

> 可使用 Mermaid、Draw.io、PlantUML 等工具渲染

## 1. 系统整体架构

```mermaid
flowchart TD
    subgraph 前端 Vue
        A[学生端] 
        B[商家端]
        C[管理端]
    end
    
    subgraph 后端 Spring Boot
        D[认证模块 Auth]
        E[订单模块 Order]
        F[商品模块 Product]
        G[购物车模块 Cart]
        H[支付模块 Pay]
    end
    
    subgraph 数据层
        I[(MySQL)]
        J[(Redis)]
        K[(OSS存储)]
    end
    
    A --> D
    B --> D
    C --> D
    
    A --> E & F & G & H
    B --> F & E
    C --> E & F
    
    D & E & F & G & H --> I
    D & E --> J
    F --> K
```

## 2. 用户认证流程

```mermaid
flowchart TD
    START([开始]) --> A{选择角色}
    
    A -->|学生| B[学生注册]
    A -->|商家| C[商家申请]
    A -->|管理员| D[后台分配账号]
    
    B --> E[填写信息]
    C --> E
    D --> E
    
    E --> F[系统审核]
    F --> G{审核结果}
    
    G -->|通过| H[分配账号]
    G -->|拒绝| I[返回拒绝原因]
    
    H --> J[用户登录]
    I --> A
    
    J --> K[JWT Token生成]
    K --> L([完成])
```

## 3. 学生订餐主流程

```mermaid
flowchart LR
    subgraph 浏览下单流程
        A[浏览首页] --> B[查看店铺列表]
        B --> C[选择店铺]
        C --> D[查看商品详情]
        D --> E[加入购物车]
        E --> F{是否继续选购}
        F -->|是| D
        F -->|否| G[查看购物车]
        G --> H[确认订单]
        H --> I[选择地址]
        I --> J[提交订单]
        J --> K{支付方式}
        K -->|微信支付| L[扫码支付]
        K -->|支付宝| M[扫码支付]
        K -->|校园卡| N[余额扣款]
        L --> O{支付成功}
        M --> O
        N --> O
        O -->|是| P[生成订单]
        O -->|否| Q[支付失败]
        P --> R[订单状态: 待接单]
        Q --> S[返回购物车]
    end
```

## 4. 商家处理订单流程

```mermaid
flowchart TD
    START([新订单]) --> A{收到新订单通知}
    
    A --> B[查看订单详情]
    B --> C{确认接单?}
    
    C -->|拒单| D[填写拒单原因]
    D --> E[通知学生并退款]
    E --> F([流程结束])
    
    C -->|接单| G[开始备餐]
    G --> H[备餐完成]
    H --> I[通知取餐]
    I --> J{取餐方式}
    
    J -->|到店自取| K[学生到店取餐]
    J -->|配送| L[安排配送]
    
    K --> M[确认取餐]
    L --> M
    
    M --> N[订单完成]
    N --> O([流程结束])
```

## 5. 订单状态流转

```mermaid
stateDiagram-v2
    [*] --> 待支付: 提交订单
    待支付 --> 已取消: 超时/用户取消
    已支付 --> 待接单: 支付成功
    已支付 --> 已取消: 申请退款并通过
    待接单 --> 已拒绝: 商家拒单
    待接单 --> 待备餐: 商家接单
    已拒绝 --> 已退款: 自动退款
    待备餐 --> 备餐中: 开始制作
    备餐中 --> 待取餐: 备餐完成
    待取餐 --> 配送中: 骑手取餐
    待取餐 --> 已完成: 到店自取
    配送中 --> 已完成: 骑手送达
    已完成 --> [*]
    已退款 --> [*]
    已取消 --> [*]
```

## 6. 退款流程

```mermaid
flowchart TD
    START([申请退款]) --> A{退款原因}
    
    A -->|商家未接单| B[自动退款]
    A -->|商家已接单| C[商家确认]
    A -->|备餐中| D[协商退款]
    A -->|已完成| E[需要审核]
    
    B --> F[原路退回]
    C --> G{商家同意?}
    D --> H{协商结果}
    E --> I{管理员审核}
    
    G -->|同意| F
    G -->|拒绝| J[拒绝退款]
    H -->|同意| F
    H -->|拒绝| J
    I -->|通过| F
    I -->|拒绝| J
    
    F --> K([退款完成])
    J --> L([退款关闭])
```

## 7. 商家入驻流程

```mermaid
flowchart TD
    START([商家申请]) --> A[填写入驻信息]
    
    A --> B[上传资质证件]
    B --> C[提交申请]
    C --> D{管理员审核}
    
    D -->|通过| E[开通店铺]
    D -->|拒绝| F[填写拒绝原因]
    F --> G([申请失败])
    
    E --> H[设置营业状态]
    H --> I[添加商品]
    I --> J[上架商品]
    J --> K([营业就绪])
```

## 8. 管理员功能模块

```mermaid
flowchart TD
    subgraph 用户管理
        A1[学生管理] --> A2[账号启用/禁用]
        A1 --> A3[信息修改]
    end
    
    subgraph 商家管理
        B1[商家审核] --> B2[资质核查]
        B1 --> B3[入驻批准]
        B2 --> B4[店铺管理]
        B3 --> B4
    end
    
    subgraph 订单管理
        C1[订单查询] --> C2[状态监控]
        C1 --> C3[异常处理]
    end
    
    subgraph 系统配置
        D1[公告管理] --> D2[系统参数]
        D1 --> D3[权限分配]
    end
    
    subgraph 数据统计
        E1[订单统计] --> E2[营收分析]
        E1 --> E3[用户活跃度]
    end
```

## 9. 数据库核心实体关系

```mermaid
erDiagram
    SYS_USER ||--o{ SYS_USER_ROLE : "拥有"
    SYS_ROLE ||--o{ SYS_USER_ROLE : "属于"
    SYS_ROLE ||--o{ SYS_ROLE_MENU : "拥有"
    SYS_MENU ||--o{ SYS_ROLE_MENU : "被分配"
    
    SHOP_INFO ||--o{ PRODUCT_INFO : "经营"
    SHOP_INFO ||--o{ ORDER_INFO : "产生"
    STUDENT_INFO ||--o{ ORDER_INFO : "下单"
    ORDER_INFO ||--o{ ORDER_ITEM : "包含"
    PRODUCT_INFO ||--o{ ORDER_ITEM : "明细"
    
    STUDENT_INFO ||--o{ SHOPPING_CART : "加入"
    PRODUCT_INFO ||--o{ SHOPPING_CART : "被加入"
    
    ORDER_INFO ||--o{ PAYMENT_INFO : "支付"
    ORDER_INFO ||--o{ ORDER_REFUND : "退款"
```

## 10. 关键API接口流程

```mermaid
sequenceDiagram
    participant S as 学生
    participant A as 前端Vue
    participant B as 后端API
    participant D as 数据库
    participant P as 支付平台
    
    S->>A: 浏览商品
    A->>B: GET /product/list
    B->>D: 查询商品
    D-->>B: 商品列表
    B-->>A: 返回数据
    
    S->>A: 加入购物车
    A->>B: POST /cart/add
    B->>D: 保存购物车
    D-->>B: 成功
    B-->>A: 返回购物车
    
    S->>A: 提交订单
    A->>B: POST /order/create
    B->>D: 创建订单
    B-->>A: 订单号
    
    S->>A: 选择支付
    A->>P: 扫码支付
    P-->>A: 支付成功
    A->>B: 回调通知
    B->>D: 更新订单状态
    B-->>P: 回调确认
```
