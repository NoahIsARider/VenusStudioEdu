# GoStudio - Go 语言学习项目

欢迎来到 GoStudio！这是一个全面的 Go 语言学习项目，涵盖了 Go 语言的所有重要语法和概念。

## 📚 项目结构

```
GoStudio/
├── 01-basics/           # 基础语法
│   ├── variables.go     # 变量和常量
│   ├── types.go         # 数据类型
│   └── operators.go     # 运算符
├── 02-control/          # 控制流
│   ├── conditions.go    # 条件语句
│   ├── loops.go         # 循环
│   └── switch.go        # Switch 语句
├── 03-functions/        # 函数
│   ├── basic.go         # 基础函数
│   ├── advanced.go      # 高级特性
│   └── closures.go      # 闭包
├── 04-data-structures/  # 数据结构
│   ├── arrays.go        # 数组
│   ├── slices.go        # 切片
│   ├── maps.go          # 映射
│   └── structs.go       # 结构体
├── 05-methods/          # 方法和接口
│   ├── methods.go       # 方法
│   └── interfaces.go    # 接口
├── 06-concurrency/      # 并发编程
│   ├── goroutines.go    # Goroutines
│   ├── channels.go      # Channels
│   └── select.go        # Select 语句
├── 07-errors/           # 错误处理
│   ├── errors.go        # 错误处理
│   └── panic.go         # Panic 和 Recover
├── 08-packages/         # 包管理
│   ├── math/            # 自定义包示例
│   └── utils/           # 工具包
├── 09-advanced/         # 高级特性
│   ├── pointers.go      # 指针
│   ├── reflection.go    # 反射
│   └── generics.go      # 泛型
└── main.go              # 主程序入口
```

## 🚀 快速开始

### 运行所有示例
```bash
go run main.go
```

### 运行特定模块
```bash
# 运行基础语法示例
go run 01-basics/variables.go

# 运行并发示例
go run 06-concurrency/goroutines.go
```

### 运行测试
```bash
go test ./...
```

## 📖 学习路径

1. **基础语法** (`01-basics/`) - 从这里开始，了解 Go 的基本语法
2. **控制流** (`02-control/`) - 学习条件和循环
3. **函数** (`03-functions/`) - 掌握函数的使用
4. **数据结构** (`04-data-structures/`) - 学习数组、切片、映射和结构体
5. **方法和接口** (`05-methods/`) - 理解 Go 的面向对象编程
6. **并发编程** (`06-concurrency/`) - Go 的核心特性
7. **错误处理** (`07-errors/`) - 学习正确的错误处理方式
8. **包管理** (`08-packages/`) - 创建和使用包
9. **高级特性** (`09-advanced/`) - 深入学习指针、反射和泛型

## 💡 学习建议

- 按照顺序学习每个模块
- 运行代码，观察输出
- 修改代码，尝试不同的变化
- 阅读代码注释，理解每个概念
- 完成每个模块后的练习

## 🛠️ 开发环境

- Go 版本: 1.25.4+
- 编辑器: VS Code (推荐安装 Go 扩展)

## 📝 额外资源

- [Go 官方文档](https://golang.org/doc/)
- [Go by Example](https://gobyexample.com/)
- [Effective Go](https://golang.org/doc/effective_go)

祝你学习愉快！🎉
