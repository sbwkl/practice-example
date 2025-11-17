# Puppeteer Example

本 README 文件为 `puppeteer-example` 目录提供说明。

## 简介

此项目是一个使用 [Puppeteer](https://github.com/puppeteer/puppeteer) 的示例，旨在演示如何通过 Node.js 控制一个无头（Headless）Chrome 浏览器。项目使用 TypeScript 编写，可以作为学习和实践 Puppeteer 的起点。

Puppeteer 可用于：

*   网页截图和 PDF 生成。
*   自动化表单提交、UI 测试和键盘输入等操作。
*   创建一个最新的自动化测试环境。
*   抓取和爬取网页内容。

## 技术栈

*   **TypeScript**: 项目的主要编程语言。
*   **Node.js**: 运行环境。
*   **Puppeteer**: 核心库，用于浏览器自动化。
*   **ts-node**: 用于直接运行 TypeScript 代码，无需手动编译。

## 如何使用

### 环境配置

1.  **安装 Node.js**: 确保您的系统已安装 Node.js (建议 LTS 版本)。
2.  **安装依赖**: 在项目根目录下运行以下命令，以安装 `package.json` 中定义的所有依赖。
    ```bash
    cd puppeteer-example
    npm install
    ```
    *注意：`npm install` 会下载 Chromium 浏览器，这可能需要一些时间。*

### 运行示例

`package.json` 中提供了一个 `try-try` 脚本来运行主程序。

```bash
npm run try-try
```

这将执行 `src/main/index.ts` 文件中的代码。

## 开发

### 源代码

*   项目的主入口文件位于 `src/main/index.ts`。您可以在此文件中编写和测试您的 Puppeteer 代码。

### 修改与扩展

*   您可以修改 `index.ts` 来实现不同的浏览器自动化任务。
*   通过 `npm install <package_name>` 来添加新的 Node.js 依赖。

### 调试

如果您想在有头（Headful）模式下运行浏览器以观察操作过程，可以在 Puppeteer 的 `launch` 选项中设置 `headless: false`。

```typescript
import puppeteer from 'puppeteer';

(async () => {
  const browser = await puppeteer.launch({ headless: false }); // 设置为 false
  const page = await browser.newPage();
  await page.goto('https://example.com');
  // ...
  await browser.close();
})();
```
