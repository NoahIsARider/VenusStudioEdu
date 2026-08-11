# PerlStudio - Perl 语言学习项目

欢迎来到 PerlStudio！这是一个全面的 Perl 编程语言学习项目，通过 8 个章节带你掌握 Perl 语言的核心语法和编程技巧。

## 📚 项目结构

```
PerlStudio/
├── 01-basics/             # 基础语法
│   └── variables.pl       # 标量、数组、哈希、上下文、运算符
├── 02-control/            # 控制流
│   └── control.pl         # if/unless、for/foreach、while、last/next
├── 03-functions/          # 函数
│   └── functions.pl       # 子例程、闭包、回调、wantarray
├── 04-data-structures/    # 数据结构
│   └── data.pl            # 数组、哈希、引用、复杂结构
├── 05-regex/              # 正则表达式
│   └── regex.pl           # 匹配、捕获、替换、量词
├── 06-oop/                # 面向对象
│   └── oop.pl             # bless、继承、多态、访问器
├── 07-modules/            # 模块系统
│   ├── MyUtils.pm         # 自定义模块（被引用）
│   └── modules.pl         # use 导入、CPAN 模块
├── 08-advanced/           # 高级特性
│   └── advanced.pl        # 文件 IO、异常、特殊变量、map/grep
├── main.pl                # 主程序入口
├── run.sh                 # 运行脚本
└── README.md              # 本文件
```

## 🚀 快速开始

```bash
cd PerlStudio
bash run.sh
```

或直接：

```bash
perl main.pl
```

### 运行特定章节

```bash
bash run.sh 01        # 运行第 1 章
bash run.sh 05-regex/regex.pl
bash run.sh 08-advanced
```

## 📖 学习路径

1. **基础语法** (`01-basics/`) - 三种变量类型、上下文、运算符
2. **控制流** (`02-control/`) - 条件、循环、语句修饰符
3. **函数** (`03-functions/`) - 子例程、闭包、函数引用
4. **数据结构** (`04-data-structures/`) - 数组、哈希、引用
5. **正则表达式** (`05-regex/`) - Perl 最强大的文本处理能力
6. **面向对象** (`06-oop/`) - bless、继承、多态
7. **模块** (`07-modules/`) - use 导入、CPAN 生态
8. **高级特性** (`08-advanced/`) - 文件 IO、异常、特殊变量

## 💡 Perl 语言特色

- **正则之王**：内置最强正则表达式引擎
- **TMTOWTDI**：同一件事有多种写法
- **三种变量**：标量（$）、数组（@）、哈希（%）
- **上下文感知**：同一代码在不同上下文返回不同结果
- **CPAN 生态**：全球最大的语言库之一
- **文本处理**：系统管理员和运维的利器

## 🛠️ 环境要求

- Perl 5.30+（推荐）
- 验证安装：`perl -v`

## 📝 额外资源

- [Perl 官方文档](https://www.perl.org/)
- [CPAN](https://www.cpan.org/)
- [Perl 中文教程](https://learn.perl.org/docs/)

祝你学习愉快！
