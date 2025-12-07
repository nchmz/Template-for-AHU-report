# 安徽大学电子信息工程学院 课程设计/实验报告模板（LaTeX）

本仓库包含安徽大学电子信息工程学院（School of Electronic Information Engineering, Anhui University）使用的课程设计与实验报告 LaTeX 模板。

## 仓库概览

- `ahu_report.cls` — 模板类文件，定义了报告的格式。
- `template_coursedesign.tex` — 课程设计报告模板示例（包含参考文献引用）。
- `template_experiment.tex` — 实验报告模板示例（包含代码块和子图插入）。
- `coursedesign_refs.bib` — 参考文献数据库示例。
- `pic/` — 存放正文中使用的图片资源。
- `logo/` — 存放校徽等图片资源。

## 如何使用模板

本模板基于 `ahu_report.cls` 类文件。在你的 `.tex` 文件开头使用以下命令调用模板：

```latex
\documentclass[选项]{ahu_report}
```

### 可选参数

- `experiment`：用于撰写实验报告（默认）。
- `coursedesign`：用于撰写课程设计报告。
- `nofirstpagebg`：取消第一页的背景水印。

### 示例

**实验报告：**
```latex
\documentclass[experiment]{ahu_report}
```

**课程设计报告：**
```latex
\documentclass[coursedesign]{ahu_report}
```

## 编译指南

推荐使用 **XeLaTeX** 编译器。

### 1. 不包含参考文献

如果你的报告中不需要引用参考文献（通常实验报告不需要），只需运行一次 `xelatex` 即可：

```bash
xelatex template_experiment.tex
```

### 2. 包含参考文献

如果你的报告中使用了参考文献（如 `template_coursedesign.tex` 示例），需要按照以下顺序进行编译，以确保引用和编号正确生成：

1.  `xelatex` (生成辅助文件)
2.  `bibtex` (处理参考文献)
3.  `xelatex` (生成引用)
4.  `xelatex` (生成最终文档，确保交叉引用正确)

**命令行示例：**

```bash
xelatex template_coursedesign
bibtex template_coursedesign
xelatex template_coursedesign
xelatex template_coursedesign
```

> **提示**：在 VS Code 中使用 LaTeX Workshop 插件时，通常会自动处理这些编译链（Recipe）。如果遇到参考文献不显示的问题，请尝试清理辅助文件后重新按上述顺序编译。

## 常见问题

- **字体问题**：请确保操作系统中安装了必要的字体（如宋体、黑体等），模板依赖 `ctex` 宏包调用系统字体。
- **图片路径**：建议将图片放在 `pic/` 目录下，并使用相对路径引用。
