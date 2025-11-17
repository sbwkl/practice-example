# Understand JVM Example

本 README 文件为 `understand-jvm-example` 目录提供说明。

## 简介

此项目是为了学习和实践《深入理解 Java 虚拟机》一书中的概念而创建的 Java 示例代码库。项目使用 Gradle 构建，包含了用于演示特定 JVM 特性（如内存管理、类加载、字节码操作等）的代码。

## 技术栈

*   **Java**: 主要编程语言。
*   **Gradle**: 项目构建和依赖管理工具。
*   **CGLIB**: 一个强大的代码生成库，常用于演示动态代理和方法区相关的 JVM 行为。

## 如何使用

### 环境配置

1.  **安装 Java**: 确保您的开发环境已安装 JDK。
2.  **无需安装 Gradle**: 项目自带了 Gradle Wrapper (`gradlew`)，它会自动下载并使用正确的 Gradle 版本。

### 构建项目

在项目根目录下，使用 Gradle Wrapper 来构建项目。

*   在 Linux/macOS 上:
    ```bash
    ./gradlew build
    ```
*   在 Windows 上:
    ```bash
    .\\gradlew.bat build
    ```
这将编译所有 Java 源代码，并运行测试。构建产物将位于 `build/` 目录下。

### 运行示例

您可以直接在您的 IDE (如 IntelliJ IDEA 或 Eclipse) 中导入此 Gradle 项目，并运行 `src/main/java` 目录下的具体示例类。

或者，您也可以通过 Gradle 来运行一个特定的主类：

```bash
./gradlew run -PmainClass=io.github.sbwkl.jvm.example.YourMainClass
```
*请将 `io.github.sbwkl.jvm.example.YourMainClass` 替换为您想要运行的实际类名。*

## 开发

这是一个学习型项目，您可以：

*   在 `src/main/java` 目录下添加新的 Java 类来复现书中的实验。
*   在 `build.gradle` 的 `dependencies` 部分添加新的库，以支持更复杂的 JVM 实验。
*   为您的实验编写 JUnit 测试，并将它们放在 `src/test/java` 目录下。
