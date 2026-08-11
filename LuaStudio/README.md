# LuaStudio - Lua 语言学习项目

欢迎来到 LuaStudio！这是一个全面的 Lua 编程语言学习项目，通过 7 个章节带你掌握 Lua 语言的核心语法和编程技巧。

## 📚 项目结构

```
LuaStudio/
├── 01-basics/           # 基础语法
│   └── variables.lua    # 变量、数据类型、运算符
├── 02-control/          # 控制流
│   └── control.lua      # if、while、repeat、for、break、goto
├── 03-functions/        # 函数
│   └── functions.lua    # 定义、闭包、可变参数、尾调用
├── 04-tables/           # 表（Lua 唯一的数据结构）
│   └── tables.lua       # 数组、字典、多维表、table 库
├── 05-metatables/       # 元表与面向对象
│   └── metatables.lua   # __index、__add、__call、继承
├── 06-modules/          # 模块系统
│   ├── mymath.lua       # 自定义模块（被引用）
│   └── modules.lua      # require 加载模块
├── 07-coroutines/       # 协程
│   └── coroutines.lua   # create、yield、resume、wrap
├── main.lua             # 主程序入口
├── run.sh               # 运行脚本
└── README.md            # 本文件
```

## 🚀 快速开始

### 运行所有示例

```bash
cd LuaStudio
bash run.sh
```

或直接：

```bash
lua main.lua
```

### 运行特定章节

```bash
# 运行第 1 章（基础语法）
bash run.sh 01

# 运行指定文件
bash run.sh 03-functions/functions.lua

# 运行指定目录
bash run.sh 04-tables
```

## 📖 学习路径

1. **基础语法** (`01-basics/`) - 变量、8 种数据类型、运算符
2. **控制流** (`02-control/`) - if、while、repeat、for 循环
3. **函数** (`03-functions/`) - 多返回值、闭包、可变参数、尾调用
4. **表** (`04-tables/`) - Lua 唯一的数据结构，数组/字典二合一
5. **元表与面向对象** (`05-metatables/`) - __index、运算符重载、继承
6. **模块** (`06-modules/`) - require 加载、模块缓存、内置库
7. **协程** (`07-coroutines/`) - 协作式并发、迭代器生成

## 💡 Lua 语言特色

- **轻量快速**：嵌入式脚本语言，解释器只有几百 KB
- **动态类型**：变量无需声明类型，运行时决定
- **table 万能**：数组、字典、对象都用 table 实现
- **第一类函数**：函数可赋值、传参、作为返回值
- **元表机制**：通过元表实现继承和运算符重载
- **协程支持**：天然的协作式并发模型

## 🛠️ 环境要求

- Lua 5.4+（推荐）
- 验证安装：`lua -v`

## 📝 额外资源

- [Lua 官方文档](https://www.lua.org/manual/5.4/)
- [Programming in Lua](https://www.lua.org/pil/)
- [Lua 用户 Wiki](http://lua-users.org/wiki/)

祝你学习愉快！
