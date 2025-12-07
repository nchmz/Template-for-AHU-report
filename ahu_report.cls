\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ahu_report}[2025/12/07 Anhui University Experiment Report Class]

% =========================================================
% 1. 选项定义
% =========================================================
\newif\if@firstpagebg
\@firstpagebgtrue % 默认开启第一页背景

\newif\if@enablebg % 全局背景开关
\@enablebgtrue

\newif\if@coursedesign
\@coursedesignfalse % 默认是实验报告

\DeclareOption{nofirstpagebg}{\@firstpagebgfalse}
\DeclareOption{nobg}{\@enablebgfalse} % 关闭背景选项
\DeclareOption{experiment}{\@coursedesignfalse}
\DeclareOption{coursedesign}{%
  \@coursedesigntrue
  % \@firstpagebgfalse % 课设报告默认不显示第一页背景
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[a4paper]{article}

% =========================================================
% 2. 宏包加载 (补全了之前遗漏的常用包)
% =========================================================
\RequirePackage[fontset=windows,zihao={-4}]{ctex}
\RequirePackage{setspace}
\RequirePackage{graphicx}
\RequirePackage{listings}
\RequirePackage[table]{xcolor}
\RequirePackage{amsmath}
\RequirePackage{booktabs}
\RequirePackage{pdflscape} % 之前漏了这个
\RequirePackage{float}     % 之前漏了这个
\RequirePackage{subfigure} % 【关键修复】之前漏了导致 \subfigure 报错
\RequirePackage{wrapfig}   % 之前漏了这个
\RequirePackage{caption}   % 之前漏了这个
\RequirePackage{geometry}
\RequirePackage{tikz}
\RequirePackage{hyperref}

% 使用 scrlayer-scrpage 替代 fancyhdr (更稳健的背景支持)
\RequirePackage{scrlayer-scrpage}

% =========================================================
% 3. 页面设置
% =========================================================
\hypersetup{hidelinks}

% 【修复 head height 警告】增加 headheight 设置
\geometry{left=3.17cm, right=3.17cm, top=2.54cm, bottom=2.54cm, headheight=22pt}

\setmainfont{Times New Roman}
\graphicspath{{logo/}}
\graphicspath{{pic/}}

% 【修复字体警告】开启伪粗体，解决 "Font shape undefined"
\newCJKfontfamily\HWST{华文宋体}[AutoFakeBold]

% =========================================================
% 4. 背景绘制核心逻辑 (scrlayer 方案)
% =========================================================
\newcommand{\@bgopacity}{1.0}
\newcommand{\setbgopacity}[1]{\renewcommand{\@bgopacity}{#1}}

% 定义图层：report.background
\DeclareNewLayer[
    background,     % 位于内容下方
    mode=picture,   % 使用 picture 模式定位
    contents={%
      \if@enablebg
        % 逻辑控制：第一页开关
        \if@firstpagebg
            \ahu@drawbgcontent % 允许第一页：直接画
        \else
            \ifnum\value{page}>1
                \ahu@drawbgcontent % 禁止第一页：页码>1才画
            \fi
        \fi
      \fi
    }
]{report.background}

% 具体的绘图内容 (图片 + 蒙版)
\newcommand{\ahu@drawbgcontent}{%
    % 1. 放置背景图 (使用 put(0,0) 绝对定位)
    \put(0,0){%
        \parbox[b][\paperheight]{\paperwidth}{%
            \vfill
            \centering
            % 强制图片填满页面
            \includegraphics[width=\paperwidth,height=\paperheight]{backgroundwps}%
            \vfill
        }%
    }%
    % 2. 放置白色蒙版 (使用 TikZ 绝对坐标)
    \put(0,0){%
        \begin{tikzpicture}[overlay]
             \pgfmathsetmacro{\@maskopacity}{1 - \@bgopacity}
             % 从(0,0)到(纸宽,纸高)画一个半透明白矩形
             \fill[white, opacity=\@maskopacity] (0,0) rectangle (\paperwidth, \paperheight);
        \end{tikzpicture}%
    }%
}

% 将背景层添加到 scrlayer-scrpage 管理的样式中
\AddLayersToPageStyle{scrheadings}{report.background}
\AddLayersToPageStyle{plain.scrheadings}{report.background}

% =========================================================
% 5. 页眉页脚设置 (scrlayer-scrpage 语法)
% =========================================================
\clearpairofpagestyles

% 强制页眉页脚不使用斜体
\setkomafont{pageheadfoot}{\normalfont}

% 设置页脚
\cfoot{\thepage}

% 设置页眉线
\KOMAoptions{headsepline=0.4pt}

\if@coursedesign
  % 课设报告模式：左上角显示章节标题
  \automark[section]{section}
  \ihead{\zihao{-5}\songti\headmark}
\else
  % 实验报告模式：居中显示学院和报告类型
  \chead{\zihao{-5}\songti 安徽大学电子信息工程学院\quad 实验报告}
\fi

% =========================================================
% 6. 变量与标题页
% =========================================================
% 变量定义
\newcommand{\@course}{微机原理}
\newcommand{\course}[1]{\renewcommand{\@course}{#1}}
\newcommand{\@stuid}{}
\newcommand{\stuid}[1]{\renewcommand{\@stuid}{#1}}
\newcommand{\@major}{}
\newcommand{\major}[1]{\renewcommand{\@major}{#1}}
\newcommand{\@name}{}
\newcommand{\name}[1]{\renewcommand{\@name}{#1}}
\newcommand{\@expdate}{}
\newcommand{\expdate}[1]{\renewcommand{\@expdate}{#1}}
\newcommand{\@grade}{}
\newcommand{\grade}[1]{\renewcommand{\@grade}{#1}}
\newcommand{\@academy}{电子信息工程学院}
\newcommand{\academy}[1]{\renewcommand{\@academy}{#1}}

% 标题页命令
\newcommand{\makeahutitle}{
  \if@coursedesign
    % --- 课设报告封面 ---
    \begin{titlepage}
       \centering
       \vspace*{20pt}
       % 确保 logo 存在，否则用文字代替
       \IfFileExists{logo/ahu.bmp}{\includegraphics[width=1\linewidth]{logo/ahu.bmp}}{%
         \IfFileExists{logo/ahu.jpg}{\includegraphics[width=1\linewidth]{logo/ahu.jpg}}{%
            \IfFileExists{logo/ahu.pdf}{\includegraphics[width=1\linewidth]{logo/ahu.pdf}}{%
               {\zihao{1}\bfseries 安徽大学}
            }%
         }%
       }\\[4cm]
       
       {\zihao{2} \heiti \@title }
       \\[2cm]
       {\zihao{2} \heiti \@course }\\[4cm]
       
       % 内部定义的辅助命令
       \newcommand{\ahu@reportinfo}[2]{%
          \large\makebox[4em]{\textsf{##1}}\quad\underline{\makebox[15em]{##2}}%
       }
       
       \ahu@reportinfo{\zihao{-2}\songti 学\hspace{\fill}院}{\zihao{-2}\songti \@academy}\\[10pt]
       \ahu@reportinfo{\zihao{-2}\songti 专\hspace{\fill}业}{\zihao{-2}\songti \@major}\\[8pt]
       \ahu@reportinfo{\zihao{-2}\songti 年\hspace{\fill}级}{\zihao{-2} \songti \@grade}\\[8pt]
       \ahu@reportinfo{\zihao{-2}\songti 学\hspace{\fill}号}{\zihao{-2}\songti \@stuid}\\[8pt]
       \ahu@reportinfo{\zihao{-2}\songti 姓\hspace{\fill}名}{\zihao{-2}\songti \@name}\\
       \vspace*{\fill}
    \end{titlepage}
  \else
    % --- 实验报告封面 ---
    \begin{center}
      {\HWST\zihao{-1}\bfseries 安徽大学电子信息工程学院}\\[8pt]
      \makebox[\linewidth][c]{%
        \underline{\HWST\zihao{-1}\bfseries \@course}%
        {\HWST\zihao{-1}\bfseries 实验报告}%
      }\\[8pt]
    \end{center}
  
    \songti
    \begin{center}
      \vspace{6pt}
      \begin{tabular}{@{}c@{}c@{}c@{}}
        \makebox[0.33\textwidth][c]{\zihao{5}\songti 学号\underline{\HWST\zihao{5} \@stuid}} &
        \makebox[0.33\textwidth][c]{\zihao{5}\songti 专业\underline{\HWST\zihao{5} \@major}} &
        \makebox[0.33\textwidth][c]{\zihao{5}\songti 姓名\underline{\HWST\zihao{5} \@name}} \\\vspace{6pt}
        \makebox[0.33\textwidth][c]{\zihao{5}\songti 实验日期\underline{\HWST\zihao{5} \@expdate}} &
        \makebox[0.33\textwidth][c]{\zihao{5}\songti 实验成绩\underline{\HWST\zihao{5} \phantom{空格}}} &
        \makebox[0.33\textwidth][c]{\zihao{5}\songti 教师签字\underline{\HWST\zihao{5} \phantom{空格}}} \\
      \end{tabular}
    \end{center}
  \fi
}