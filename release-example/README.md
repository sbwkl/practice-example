# Release Example

本 README 文件为 `release-example` 目录提供说明。

## 简介

`release-example` 是一个多模块的 Maven 项目，旨在演示如何使用 `maven-release-plugin` 插件来自动化项目的发布流程。

该项目展示了一个典型的父子模块结构，并配置了 SCM (源码控制管理) 和分发管理，以模拟一个完整的 CI/CD 发布场景。

## 项目结构

*   **`parent/`**: 父 POM 模块，定义了所有子模块共享的依赖、插件和配置。
*   **`model/`**: 数据模型模块，通常包含实体类和 DTO。
*   **`web/`**: Web 应用模块，负责业务逻辑和 API 接口。
*   **`pom.xml`**: 顶层 POM 文件，聚合了所有模块，并配置了 `maven-release-plugin`。

## 如何使用

### 环境配置

1.  **安装 Java 和 Maven**: 确保您的开发环境已安装 JDK 和 Apache Maven。
2.  **配置 Maven `settings.xml`**: 您需要在 Maven 的 `settings.xml` 文件中配置访问 Nexus 仓库所需的服务器认证信息（用户名和密码）。

    ```xml
    <servers>
      <server>
        <id>nexus-releases</id>
        <username>your-username</username>
        <password>your-password</password>
      </server>
      <server>
        <id>nexus-snapshots</id>
        <username>your-username</username>
        <password>your-password</password>
      </server>
    </servers>
    ```

### 发布流程

`maven-release-plugin` 将发布过程分为两个主要步骤：`release:prepare` 和 `release:perform`。

1.  **准备发布 (`release:prepare`)**

    此命令会执行一系列检查，更新版本号（从 `SNAPSHOT` 到正式版），创建 Git 标签，然后再将版本号更新到下一个 `SNAPSHOT` 版本。

    ```bash
    mvn release:prepare
    ```
    在执行过程中，插件会提示您确认发布的版本号和下一个开发版本号。

2.  **执行发布 (`release:perform`)**

    此命令会检出 `release:prepare` 步骤中创建的 Git 标签，运行 `mvn deploy` 命令来构建项目，并将构建产物（如 JAR, WAR 文件）部署到 `distributionManagement` 中配置的 Nexus Release 仓库。

    ```bash
    mvn release:perform
    ```

### 清理

如果发布过程中出现问题，您可以使用以下命令来清理本地的 Git 提交和标签：

```bash
mvn release:rollback
# 或者
mvn release:clean
```

## 开发

您可以修改 `pom.xml` 文件来调整发布插件的行为，或在子模块中添加自己的业务代码，以测试不同场景下的发布流程。
