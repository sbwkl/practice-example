# Notebook

本 README 文件为 `notebook` 目录提供说明。

## 简介

此目录是一个 Jupyter Notebook 工作区，用于存放数据分析、算法实现、编程学习和各种实验性代码。每个 `.ipynb` 文件都是一个独立的笔记或项目。

## 主要内容

### Notebook 文件

*   **`moneywiz-4-alibaba.ipynb`**: 用于处理阿里巴巴相关的 MoneyWiz 4 财务数据。
*   **`moneywiz-4-cmb-credit.ipynb`**: 用于处理招商银行信用卡相关的 MoneyWiz 4 财务数据。
*   **`playground.ipynb`**: 一个通用的代码实验和测试笔记。
*   **`weibo-spider.ipynb`**: 包含一个微博爬虫的实现或分析过程。

### 主题目录

*   **`assets/`**: 存放 Notebook 中使用的图片、数据文件等静态资源。
*   **`compilers/`**: 与编译原理相关的笔记和代码实现。
*   **`data-analysis/`**: 包含各类数据分析项目的笔记。
*   **`grokking-algorithms/`**: 《算法图解》一书的学习笔记和代码实现。
*   **`introduction-to-algorithms/`**: 《算法导论》的学习笔记和代码实现。
*   **`other/`**: 其他未分类的笔记和实验。

## 如何使用

### 环境配置

要运行这些 Notebook，您需要安装 Jupyter Notebook 或 JupyterLab。

1.  **安装 Python**: 确保您的系统已安装 Python 3。
2.  **安装 Jupyter**:
    ```bash
    pip install notebook
    # 或者安装 JupyterLab
    # pip install jupyterlab
    ```
3.  **安装依赖**: 每个 Notebook 可能有其自身的数据科学库依赖（如 `pandas`, `numpy`, `matplotlib`）。请根据 Notebook 中的 `import` 语句，使用 `pip` 安装所需的库。
    ```bash
    pip install pandas numpy matplotlib
    ```

### 启动 Jupyter

在 `notebook` 目录下运行以下命令，即可在浏览器中打开 Jupyter：

```bash
jupyter notebook
# 或者
# jupyter lab
```

然后，您可以点击任意 `.ipynb` 文件来查看和运行它。

## 开发

您可以自由地创建新的 Notebook 来进行自己的分析和实验。建议将新的 Notebook 文件存放在最相关的主题目录下，以保持工作区的整洁。
