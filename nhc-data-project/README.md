# NHC Data Project

本 README 文件为 `nhc-data-project` 目录提供说明。

## 简介

`nhc-data-project` 是一个数据处理项目，旨在实现数据的采集、监控和处理。项目整体上分为两个核心模块：数据观察者（`nhc-data-observer`）和数据处理器（`nhc-data-processor`）。

## 模块结构

*   ### `nhc-data-observer/`

    **功能**：负责数据的采集和监控。这是一个基于 TypeScript/Node.js 的项目，它使用 [Puppeteer](https://github.com/puppeteer/puppeteer) 库来自动化浏览器操作，从而实现对网页数据的抓取。同时，它也集成了 `python-shell`，表明它可能会调用 Python 脚本来辅助完成某些任务。

    **技术栈**：
    *   TypeScript / Node.js
    *   Puppeteer (网页抓取)
    *   PythonShell (与 Python 脚本交互)

*   ### `nhc-data-processor/`

    **功能**：负责对 `observer` 模块采集到的原始数据进行清洗、转换、分析和存储。(*注：此模块的具体实现有待探查。*)

## 如何使用

### 环境配置

您需要为每个子项目单独安装依赖。

**对于 `nhc-data-observer`**:

```bash
cd nhc-data-project/nhc-data-observer
npm install
```

### 运行项目

**启动 `nhc-data-observer`**:

`package.json` 中定义了一个 `try-try` 脚本来启动观察者程序。

```bash
cd nhc-data-project/nhc-data-observer
npm run try-try
```

请根据每个子项目的具体文档来执行更详细的操作。

## 开发

### `nhc-data-observer`

*   **源代码**: 位于 `src/main/index.ts`。
*   **依赖管理**: 通过 `package.json` 文件管理 Node.js 依赖。
*   **编译**: 使用 `ts-node` 实时编译和运行 TypeScript 代码。

### `nhc-data-processor`

开发细节请参考该子目录下的 README 文件。
