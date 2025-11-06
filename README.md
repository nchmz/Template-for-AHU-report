# 安徽大学电子信息工程学院 实验报告模板（LaTeX）

本仓库包含安徽大学电子信息工程学院（School of Electronic Information Engineering, Anhui University）使用的实验报告 LaTeX 模板和参考资料。README 提供如何编译、文件结构说明、常见问题处理方法以及后续改进建议。

## 仓库概览

- `template_ex_report.tex` — 主模板文件（LaTeX 源）。
- `template_refs.bib` — 文献数据库（BibTeX 格式）。
- `background.pdf` — 背景水印 PDF 文件。
- `logo/` — 存放封面或学校 Logo 的图片文件夹。
- `pic/` — 存放正文中使用的图片资源。

> 注意：请根据实际需要把图片或引用插入到 `template_ex_report.tex` 中的相应位置。

## 先决条件

在 Windows 上编译本模板，推荐安装以下软件：

- TeX 发行版：TeX Live 或 MiKTeX（包含 `xelatex`, `bibtex`/`biber`）。
- 推荐使用 XeLaTeX（处理中文更友好）。
- 若使用中文字体或 CJK 功能，请确保安装相应字体并在模板中正确配置。


## 如何编辑模板（快速指南）

- 标题与作者：在 `template_ex_report.tex` 中查找 `\title{...}`、`\author{...}` 并修改。
- 插图：把图片放到 `logo/` 或 `pic/`，在 `.tex` 中使用 `\includegraphics[width=...]{}{pic/your_image.png}` 引用。
- 参考文献：编辑 `template_refs.bib`，在正文使用 `\cite{key}`，并按上面的流程运行 BibTeX/Biber。
- 新增章节：按 LaTeX 规范使用 `\section{}`、`\subsection{}` 等。

## 常见问题（FAQ）及解决办法

- 字体/中文显示问题：请使用 XeLaTeX，并在模板中使用 `fontspec` 指定系统字体（如 `\setmainfont{SimSun}` 或其他）。
- 找不到图片：检查路径是否正确，Windows 路径区分反斜杠/正斜杠，LaTeX 中请使用正斜杠 `pic/figure.png`。不要把图片放在受保护或路径包含中文空格外的特殊位置（通常 LaTeX 能处理中文路径，但若有问题建议使用不含空格的路径）。
- 参考文献未出现或编号错误：确保按顺序运行 xelatex -> bibtex/biber -> xelatex -> xelatex；并检查 `.log` 和 `.blg` 文件以获取错误提示。

## 参考文献（默认未启用）

当前模板默认不主动插入参考文献调用（即未在 `.tex` 中自动添加 `\\bibliographystyle`/`\\bibliography` 。如果你需要在报告中使用参考文献，请在 `template_ex_report.tex` 中手动加入对应配置：

- 使用 BibTeX：

  1. 在正文末或合适位置添加：

	  ```tex
	  % 在文档末尾（例如 \end{document} 之前）
	  \bibliographystyle{unsrt} % 或 plain, alpha 等
	  \bibliography{nuclear_refs}
	  ```

  2. 编译顺序（PowerShell）：

	  ```powershell
	  xelatex -interaction=nonstopmode -halt-on-error template_ex_report.tex
	  bibtex template_ex_report
	  xelatex -interaction=nonstopmode -halt-on-error template_ex_report.tex
	  xelatex -interaction=nonstopmode -halt-on-error template_ex_report.tex
	  ```

注意：模板初版未启用参考文献调用以保持简洁。如果你在启用后遇到未找到引用、样式或包缺失等错误，请参考上文“常见问题（FAQ）”中的解决办法，或把相关 `.log`/`.blg` 文件片段贴给我，我可以帮你定位错误。
- 包缺失错误：使用 TeX Live 管理器或 MiKTeX 包管理器安装缺失的包，例如 `graphicx`, `fontspec`, `biblatex` 等。

## 贡献

欢迎提交 issue 或 pull request：

- 报告模板问题或编译错误时，请附上 LaTeX 的 `.log` 文件或错误信息片段。
- 若提交样式改进或新功能（如封面、摘要模板），请保持与现有样式一致并补充示例。

## 许可与作者

仓库中已包含许可证文件 `LICENSE`，请查看该文件以了解具体许可条款并遵循其中的要求。若你希望更改许可，请替换或更新该 `LICENSE` 文件并在 README 中做出相应说明。
