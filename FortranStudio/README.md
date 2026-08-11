# FortranStudio - Fortran 语言学习项目

欢迎来到 FortranStudio！这是一个全面的 Fortran 编程语言学习项目，通过 7 个章节带你掌握 Fortran 语言的核心语法和编程技巧。

## 📚 项目结构

```
FortranStudio/
├── 01-basics/           # 基础语法
│   └── variables.f90    # 变量、数据类型、运算符、kind 参数
├── 02-control/          # 控制流
│   └── control.f90      # if/then/else、select case、do 循环、cycle、exit
├── 03-arrays/           # 数组
│   └── arrays.f90       # 数组声明、数组语法、动态数组、数组内置函数
├── 04-functions/        # 函数与子程序
│   └── functions.f90    # 函数、子程序、intent、可选参数、接口、模块
├── 05-derived-types/    # 派生类型
│   └── types.f90        # 派生类型、类型组件、类型绑定过程、构造器、嵌套类型
├── 06-io/               # 输入输出
│   └── io.f90           # 格式化 I/O、列表导向 I/O、文件 I/O、namelist
├── 07-parallel/         # 并行编程
│   └── parallel.f90     # 协数组、image_index、sync all
├── main.f90             # 主程序入口
├── run.sh               # 运行脚本
└── README.md            # 本文件
```

## 🚀 快速开始

### 运行所有示例

```bash
cd FortranStudio
bash run.sh
```

或直接：

```bash
gfortran main.f90 -o main && ./main
```

### 运行特定章节

```bash
# 运行第 1 章（基础语法）
bash run.sh 01

# 运行指定文件
bash run.sh 03-arrays/arrays.f90

# 运行指定目录
bash run.sh 04-functions
```

## 📖 学习路径

1. **基础语法** (`01-basics/`) - 变量、5 种数据类型、运算符、kind 参数
2. **控制流** (`02-control/`) - if/then/else、select case、do 循环、cycle、exit
3. **数组** (`03-arrays/`) - 数组声明、数组语法、动态数组、内置函数
4. **函数与子程序** (`04-functions/`) - 函数、子程序、intent、可选参数、接口、模块
5. **派生类型** (`05-derived-types/`) - 派生类型、类型绑定过程、构造器、嵌套类型
6. **输入输出** (`06-io/`) - 格式化 I/O、列表导向 I/O、文件 I/O、namelist
7. **并行编程** (`07-parallel/`) - 协数组、image_index、sync all

## 💡 Fortran 语言特色

- **科学计算**：天生为数值计算和科学计算设计，高性能矩阵运算
- **静态类型**：编译时确定类型，强类型检查，运行效率高
- **数组优先**：原生支持数组运算和向量化操作，无需循环
- **隐式无声明**：`implicit none` 强制显式声明，避免隐式类型陷阱
- **模块系统**：module 提供封装、接口、类型绑定过程
- **并行支持**：协数组（Coarray）原生并行编程模型

## 🛠️ 环境要求

- gfortran 7+（推荐 11+）
- 验证安装：`gfortran --version`
- 协数组支持（第 7 章）需要：`gfortran -fcoarray=lib`（需安装 OpenCoarrays）

## 📝 额外资源

- [Fortran 官方文档](https://fortran-lang.org/)
- [Fortran Wiki](https://fortranwiki.org/fortran/show/HomePage)
- [GNU Fortran 文档](https://gcc.gnu.org/onlinedocs/gfortran/)

祝你学习愉快！
