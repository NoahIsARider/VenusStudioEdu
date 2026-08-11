# SwiftStudio - Swift 语言学习项目

欢迎来到 SwiftStudio！这是一个全面的 Swift 编程语言学习项目，通过 7 个章节带你掌握 Swift 语言的核心语法和现代编程技巧。

## 📚 项目结构

```
SwiftStudio/
├── 01-basics/              # 基础语法
│   └── variables.swift     # var/let、类型推断、基本类型、字符串插值、可选类型基础
├── 02-control/             # 控制流
│   └── control.swift       # if/else、switch、for-in、while、guard、标签语句
├── 03-functions/           # 函数
│   └── functions.swift     # 参数、返回值、参数标签、默认值、可变参数、inout、闭包
├── 04-collections/         # 集合类型
│   └── collections.swift   # 数组、字典、集合、下标、map/filter/reduce
├── 05-optionals/           # 可选类型
│   └── optionals.swift     # if let、guard let、可选链、nil 合并、强制解包
├── 06-protocols/           # 协议与面向协议编程
│   └── protocols.swift     # 协议定义、一致性、扩展、默认实现、协议作为类型
├── 07-error-handling/      # 错误处理
│   └── errors.swift        # Error 协议、抛出函数、do-catch、try/try?/try!、defer
├── main.swift              # 主程序入口（打印横幅和章节列表）
├── run.sh                  # 运行脚本
└── README.md               # 本文件
```

## 🚀 快速开始

### 运行所有示例

```bash
cd SwiftStudio
bash run.sh
```

或直接运行主程序入口：

```bash
swift main.swift
```

### 运行特定章节

```bash
# 运行第 1 章（基础语法）
bash run.sh 01

# 运行指定文件
bash run.sh 03-functions/functions.swift

# 运行指定目录下的所有 .swift 文件
bash run.sh 04-collections
```

## 📖 学习路径

1. **基础语法** (`01-basics/`) - var/let、类型推断、基本类型、字符串插值
2. **控制流** (`02-control/`) - if/else、switch、for-in、while、guard
3. **函数** (`03-functions/`) - 参数标签、默认值、可变参数、inout、闭包
4. **集合类型** (`04-collections/`) - 数组、字典、集合、map/filter/reduce
5. **可选类型** (`05-optionals/`) - if let、guard let、可选链、nil 合并运算符
6. **协议** (`06-protocols/`) - 面向协议编程、扩展、默认实现
7. **错误处理** (`07-error-handling/`) - Error 协议、do-catch、try/try?/try!、defer

## 💡 Swift 语言特色

- **类型安全**：强类型语言，编译期类型检查，极少运行时错误
- **类型推断**：无需显式声明类型，编译器自动推断
- **可选类型**：用类型系统显式处理 nil，告别空指针崩溃
- **值类型优先**：struct 和 enum 是值类型，复制语义清晰
- **面向协议编程**：协议 + 扩展实现代码复用，灵活强大
- **闭包表达式**：简洁的闭包语法，支持尾随闭包
- **错误处理**：throwing 函数 + do-catch，错误处理显式且安全
- **现代语法**：区间运算符、字符串插值、属性观察者等现代特性

## 🛠️ 环境要求

- Swift 5.7+（推荐 5.9+）
- 验证安装：`swift --version`
- macOS 自带 Xcode，Linux 可从 [swift.org](https://swift.org) 安装

## 📝 额外资源

- [Swift 官方文档](https://www.swift.org/documentation/)
- [The Swift Programming Language](https://docs.swift.org/swift-book/)
- [Swift by Sundell](https://www.swiftbysundell.com/)
- [Hacking with Swift](https://www.hackingwithswift.com/)

祝你学习愉快！
