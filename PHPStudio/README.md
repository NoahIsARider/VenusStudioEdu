# PHPStudio - PHP 语言学习项目

欢迎来到 PHPStudio！这是一个全面的 PHP 编程语言学习项目，通过 7 个章节带你掌握 PHP 语言的核心语法和编程技巧。

## 📚 项目结构

```
PHPStudio/
├── 01-basics/           # 基础语法
│   └── variables.php    # 变量、数据类型、类型转换、运算符、常量
├── 02-control/          # 控制流
│   └── control.php      # if/elseif/else、switch、match、for、while、foreach
├── 03-functions/        # 函数
│   └── functions.php    # 默认参数、可变参数、命名参数、箭头函数、闭包
├── 04-arrays/           # 数组
│   └── arrays.php       # 索引数组、关联数组、多维数组、数组函数、解构
├── 05-oop/              # 面向对象
│   └── oop.php          # 类、属性、方法、继承、抽象类、接口、trait
├── 06-strings/          # 字符串
│   └── strings.php      # 字符串函数、格式化、正则表达式
├── 07-web/             # Web 开发
│   └── web.php          # 超全局变量、会话、Cookie、JSON、文件上传
├── main.php            # 主程序入口
├── run.sh              # 运行脚本
└── README.md           # 本文件
```

## 🚀 快速开始

### 运行所有示例

```bash
cd PHPStudio
bash run.sh
```

或直接：

```bash
php main.php
```

### 运行特定章节

```bash
# 运行第 1 章（基础语法）
bash run.sh 01

# 运行指定文件
bash run.sh 03-functions/functions.php

# 运行指定目录
bash run.sh 04-arrays
```

## 📖 学习路径

1. **基础语法** (`01-basics/`) - 变量、数据类型、类型自动转换、运算符、常量
2. **控制流** (`02-control/`) - if/elseif/else、switch、match 表达式、循环
3. **函数** (`03-functions/`) - 默认参数、可变参数、命名参数、箭头函数、闭包
4. **数组** (`04-arrays/`) - 索引数组、关联数组、多维数组、数组函数、解构
5. **面向对象** (`05-oop/`) - 类、继承、抽象类、接口、trait、静态成员
6. **字符串** (`06-strings/`) - 字符串函数、格式化、正则表达式
7. **Web 开发** (`07-web/`) - 超全局变量、会话、Cookie、JSON、文件上传

## 💡 PHP 语言特色

- **Web 之王**：全球最流行的服务端 Web 开发语言之一
- **弱类型**：变量无需声明类型，自动类型转换（类型隐式转换）
- **数组万能**：索引数组、关联数组、多维数组统一为数组类型
- **第一类函数**：函数可赋值、传参、作为返回值，支持闭包和箭头函数
- **面向对象**：完整的 OOP 支持，类、接口、trait、抽象类、继承
- **超全局变量**：$_GET、$_POST、$_SERVER 等内置 Web 请求处理
- **match 表达式**：PHP 8.0 引入的强大条件匹配表达式

## 🛠️ 环境要求

- PHP 8.0+（推荐）
- 验证安装：`php -v`

## 📝 额外资源

- [PHP 官方文档](https://www.php.net/manual/zh/)
- [PHP 8 新特性](https://www.php.net/releases/8.0/)
- [PHP 中文教程](https://www.php.net/manual/zh/langref.php)

祝你学习愉快！
