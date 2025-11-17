# Monkey Scripts

本 README 文件为 `monkey-script` 目录提供说明。

## 简介

此目录包含一系列的“用户脚本”（Userscripts），它们是为浏览器扩展（如 [Tampermonkey](https://www.tampermonkey.net/) 或 [Greasemonkey](https://www.greasespot.net/)）设计的 JavaScript 文件。这些脚本可以在特定网页上运行，以增强页面功能、自动化操作或改善用户体验。

## 脚本列表

*   **`beike.enhance.user.js`**: 增强贝壳网的页面功能。
*   **`copy.douyin.video.data.user.js`**: 用于复制抖音视频的相关数据。
*   **`crawl.keyword.user.js`**: 用于抓取关键词数据。
*   **`douhot.enhance.user.js`**: 增强抖音热门页面的功能。
*   **`hello.user.js`**: 一个简单的示例脚本。
*   **`jinritemai.coop.user.js`**: 针对今日特卖合作平台的脚本。
*   **`market.value.copy.user.js`**: 用于复制市值数据。

## 如何使用

### 1. 安装浏览器扩展

您需要先在您的浏览器中安装一个用户脚本管理器。最常用的是 [Tampermonkey](https://www.tampermonkey.net/)，它支持 Chrome, Firefox, Safari, Edge 等主流浏览器。

### 2. 安装脚本

安装好 Tampermonkey 之后，您可以直接点击此目录中的 `.user.js` 文件链接（例如，在 GitHub 上查看此文件），Tampermonkey 将会自动识别并提示您安装。

您也可以：

1.  打开 Tampermonkey 的管理面板。
2.  进入“实用工具”标签页。
3.  将 `.user.js` 文件的内容粘贴到文本框中，或通过 URL 安装。

### 3. 启用脚本

安装完成后，脚本会自动在它们指定的目标网站上运行。您可以在 Tampermonkey 的图标上看到正在运行的脚本数量。

## 开发

### 创建新脚本

所有用户脚本都以一个元数据块（metadata block）开始，用于声明脚本的名称、描述、运行的网站等信息。例如：

```javascript
// ==UserScript==
// @name         New Script
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        http://*/*
// @grant        none
// ==/UserScript==

(function() {
    'use-strict';

    // Your code here...
})();
```

### 本地开发

您可以直接在 Tampermonkey 的编辑器中修改脚本，也可以在本地编辑器中修改后，将文件内容复制粘贴到 Tampermonkey 中进行测试。
