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

你可以使用 `curl` 或任何 API 测试工具与服务进行交互。

### 1. 创建一个新的待办事项

```bash
curl -X POST http://localhost:8080/api/todos \
-H "Content-Type: application/json" \
-d '{"title": "学习 Spring Boot", "description": "完成 README 的编写"}'
```

### 2. 获取所有待办事项

```bash
curl -X GET http://localhost:8080/api/todos
```

### 3. 获取单个待办事项

```bash
curl -X GET http://localhost:8080/api/todos/1
```

### 4. 更新待办事项

```bash
curl -X PUT http://localhost:8080/api/todos/1 \
-H "Content-Type: application/json" \
-d '{"title": "学习 Spring Boot", "description": "完成 README 的编写，并提交", "completed": true}'
```

### 5. 删除待办事项

```bash
curl -X DELETE http://localhost:8080/api/todos/1
```

你也可以通过浏览器访问 [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html) 来查看和测试所有 API。

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
