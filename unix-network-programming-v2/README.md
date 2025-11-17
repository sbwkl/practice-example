# UNIX Network Programming, Volume 2: Interprocess Communications

本 README 文件为 `unix-network-programming-v2` 目录提供说明。

## 简介

此目录包含了经典书籍《UNIX 网络编程卷2：进程间通信》（UNIX Network Programming, Volume 2: Interprocess Communications）中的示例代码。

该代码库旨在为学习 UNIX 系统下各种进程间通信（IPC）机制提供可运行的参考实现。

## 结构

代码库根据原书的章节进行组织：

*   **`chapter4/`**: 包含第四章“记录上锁”相关的示例代码。
*   **`chapter5/`**: 包含第五章“System V IPC”或相关主题的示例代码。

每个章节目录中都包含了该章节所讲解的 IPC 技术的 C 语言实现。

## 如何使用

### 环境配置

要编译和运行这些示例，您需要一个 UNIX-like 操作系统（如 Linux 或 macOS）以及一个 C 语言编译器（如 `gcc`）。

### 编译和运行

1.  **进入章节目录**:
    ```bash
    cd chapter4
    ```
2.  **编译源代码**:
    由于书中的示例代码可能依赖于作者提供的头文件和库，建议为每个章节创建一个 `Makefile` 来管理编译过程。一个简单的编译命令如下：
    ```bash
    gcc -o program program.c -lunp
    ```
    *注：`-lunp` 是链接作者提供的 unp 库，您可能需要先编译和安装该库。*

3.  **运行程序**:
    ```bash
    ./program
    ```
    具体的编译和运行参数请参考每个示例文件的说明或书中的讲解。

## 开发

这是一个学习型的代码库。您可以：

*   **动手实践**：亲自编译和运行每个示例，观察其行为，加深理解。
*   **修改和扩展**：在现有代码的基础上进行修改，测试不同的参数和边界情况。
*   **添加新代码**：随着您学习的深入，可以添加后续章节的示例代码。
