# spring-boot-todo-service

## 简介

`spring-boot-todo-service` 是一个基于 Spring Boot 的待办事项（Todo）管理服务。项目采用现代化 Java 技术栈构建，旨在提供一个简单、高效且易于扩展的 RESTful API 服务。

本项目不仅是一个功能完整的待办事项应用，也是一个用于学习和实践以下技术的绝佳范例：

*   Spring Boot 3
*   MyBatis Plus
*   Liquibase 数据库迁移
*   SQLite 数据库
*   RESTful API 设计
*   OpenAPI 3.0 (Swagger) 文档生成
*   Spring Security 认证与授权
*   JWT (JSON Web Token)

## 主要功能

*   **创建待办事项**: 添加新的待办事项。
*   **查询待办事项**: 获取所有或单个待办事项。
*   **更新待办事项**: 修改已有待办事项的内容或状态。
*   **删除待办事项**: 移除不再需要的待办事项。

## 技术栈

*   **核心框架**: Spring Boot 3.5.0
*   **数据持久化**: MyBatis Plus 3.5.7
*   **数据库**: SQLite
*   **数据库迁移**: Liquibase
*   **安全框架**: Spring Security
*   **认证机制**: JWT (JSON Web Token)
*   **API 文档**: SpringDoc (OpenAPI 3.0)
*   **构建工具**: Maven
*   **开发语言**: Java 17

## 快速上手

### 环境要求

*   JDK 17 或更高版本
*   Maven 3.6 或更高版本

### 构建与运行

1.  **克隆项目**
    ```bash
    git clone <repository-url>
    cd spring-boot-todo-service
    ```

2.  **数据库迁移**
    项目使用 Liquibase 管理数据库结构。在首次运行前，请执行以下命令来初始化数据库：
    ```bash
    mvn liquibase:update
    ```

3.  **打包并运行项目**
    ```bash
    mvn clean package -Dmaven.test.skip=true
    java -jar target/spring-boot-todo-service-0.0.1-SNAPSHOT.jar
    ```
    或者，你也可以直接通过 Spring Boot Maven 插件运行：
    ```bash
    mvn spring-boot:run
    ```

当服务启动成功后，你可以访问 [http://localhost:8080](http://localhost:8080) 来查看 API。

## API 使用示例

本项目启用了安全认证，访问受保护的 API（如 CRUD 操作）需要携带 JWT 令牌。

### 1. 用户认证

#### 1.1 注册新用户

```bash
curl -X POST http://localhost:8080/api/auth/register \
-H "Content-Type: application/json" \
-d '{"username": "user", "password": "password"}'
```

#### 1.2 登录获取 Token

```bash
curl -X POST http://localhost:8080/api/auth/login \
-H "Content-Type: application/json" \
-d '{"username": "user", "password": "password"}'
```

响应示例：
```json
{
    "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

**注意**：请保存响应中的 `token`，后续请求需要在 Header 中携带：`Authorization: Bearer <token>`。

### 2. 待办事项管理 (需要认证)

以下示例假设你已经获取了 Token，并将其设置为环境变量 `TOKEN`。
(或者手动替换 `<your_token>`)

#### 2.1 创建一个新的待办事项

```bash
curl -X POST http://localhost:8080/api/todos \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your_token>" \
-d '{"title": "学习 Spring Boot", "description": "完成 README 的编写"}'
```

#### 2.2 获取所有待办事项

```bash
curl -X GET http://localhost:8080/api/todos \
-H "Authorization: Bearer <your_token>"
```

#### 2.3 获取单个待办事项

```bash
curl -X GET http://localhost:8080/api/todos/1 \
-H "Authorization: Bearer <your_token>"
```

#### 2.4 更新待办事项

```bash
curl -X PUT http://localhost:8080/api/todos/1 \
-H "Content-Type: application/json" \
-H "Authorization: Bearer <your_token>" \
-d '{"title": "学习 Spring Boot", "description": "完成 README 的编写，并提交", "completed": true}'
```

#### 2.5 删除待办事项

```bash
curl -X DELETE http://localhost:8080/api/todos/1 \
-H "Authorization: Bearer <your_token>"
```

你也可以通过浏览器访问 [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html) 来查看和测试所有 API。

## MCP (Model Context Protocol) 功能

本项目集成了 MCP (Model Context Protocol) 服务器功能，允许 AI 模型和 MCP 客户端通过标准化协议访问待办事项和用户管理功能。

### MCP 概述

MCP 是一个标准化协议，使 AI 模型能够与外部工具和数据源进行交互。本项目通过 Spring AI MCP 框架暴露了以下功能：

### 可用的 MCP 工具

#### 用户管理工具

1. **register_user** - 注册新用户
   - 参数：`username` (用户名), `password` (密码)
   - 返回：用户 ID 和注册成功消息

2. **login_user** - 用户登录并获取 JWT 令牌
   - 参数：`username` (用户名), `password` (密码)
   - 返回：JWT 令牌用于后续认证请求

3. **get_current_user** - 获取当前认证用户信息
   - 参数：无（需要认证）
   - 返回：用户 ID、用户名和创建时间

#### 待办事项管理工具

1. **list_todos** - 列出当前用户的所有待办事项
   - 参数：无（需要认证）
   - 返回：待办事项列表

2. **get_todo** - 获取指定 ID 的待办事项
   - 参数：`id` (待办事项 ID)
   - 返回：待办事项详情

3. **create_todo** - 创建新的待办事项
   - 参数：
     - `title` (必填) - 标题
     - `description` (可选) - 描述
     - `priority` (可选) - 优先级：LOW, MEDIUM, HIGH
     - `dueDate` (可选) - 截止日期 (ISO 格式)
   - 返回：创建的待办事项

4. **update_todo** - 更新现有待办事项
   - 参数：
     - `id` (必填) - 待办事项 ID
     - `title` (可选) - 新标题
     - `description` (可选) - 新描述
     - `status` (可选) - 新状态：PENDING, IN_PROGRESS, COMPLETED
     - `priority` (可选) - 新优先级：LOW, MEDIUM, HIGH
     - `dueDate` (可选) - 新截止日期 (ISO 格式)
   - 返回：更新后的待办事项

5. **delete_todo** - 删除待办事项
   - 参数：`id` (待办事项 ID)
   - 返回：删除成功消息

### 连接 MCP 客户端

MCP 服务器通过 SSE (Server-Sent Events) 在以下端点提供服务：

```
http://localhost:8080/mcp/sse
```

#### 使用 Claude Desktop 连接

在 Claude Desktop 的配置文件中添加以下配置：

```json
{
  "mcpServers": {
    "spring-boot-todo-service": {
      "url": "http://localhost:8080/mcp/sse"
    }
  }
}
```

#### 认证说明

- 用户管理工具（`register_user`, `login_user`）无需认证
- 待办事项管理工具和 `get_current_user` 需要 JWT 认证
- 使用 `login_user` 工具获取 JWT 令牌后，MCP 客户端需要在后续请求中携带该令牌

### MCP 使用示例

1. **注册并登录**：
   - 使用 `register_user` 创建账户
   - 使用 `login_user` 获取 JWT 令牌

2. **管理待办事项**：
   - 使用 `create_todo` 创建新任务
   - 使用 `list_todos` 查看所有任务
   - 使用 `update_todo` 更新任务状态
   - 使用 `delete_todo` 删除完成的任务


## 开发指南

### 项目结构

```
.
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com/example/todo/service
│   │   │       ├── controller  # API 控制器
│   │   │       ├── dto         # 数据传输对象
│   │   │       ├── exception   # 自定义异常
│   │   │       ├── mapper      # MyBatis Plus Mapper 接口
│   │   │       ├── model       # 数据库实体模型
│   │   │       └── service     # 业务逻辑服务
│   │   └── resources
│   │       ├── db/changelog    # Liquibase 变更日志
│   │       └── application.yml # Spring Boot 配置文件
│   └── test
└── pom.xml                     # Maven 配置文件
```

### 如何添加一个新的 API

1.  **定义 DTO**: 在 `dto` 包下创建请求和响应的数据传输对象。
2.  **定义实体和 Mapper**: 如果需要新的数据表，请在 `model` 包下创建实体类，并在 `mapper` 包下创建对应的 MyBatis Plus Mapper 接口。
3.  **定义 Service**: 在 `service` 包下创建业务逻辑接口和实现。
4.  **定义 Controller**: 在 `controller` 包下创建控制器，并定义新的 API 端点。
5.  **（如果需要）更新数据库**: 在 `resources/db/changelog` 目录下创建一个新的 XML 或 SQL 变更集文件，并在 `db.changelog-master.xml` 中引入它。

## 贡献指南

欢迎任何形式的贡献！如果你有好的想法或发现了问题，请随时提交 Pull Request 或创建 Issue。

## 许可证

本项目采用 [MIT](LICENSE) 许可证。
