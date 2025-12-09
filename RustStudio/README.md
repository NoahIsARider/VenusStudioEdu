# RustStudio - Rust 语法学习项目 🦀

欢迎来到 RustStudio！这是一个全面的 Rust 编程语言学习项目，通过 14 个精心设计的模块，帮助你掌握 Rust 的所有重要语法和概念。

## 📚 项目结构

```
RustStudio/
├── src/
│   ├── main.rs              # 主程序入口
│   ├── basics.rs            # 第1章：基础语法
│   ├── ownership.rs         # 第2章：所有权系统
│   ├── structs_enums.rs     # 第3章：结构体和枚举
│   ├── collections.rs       # 第4章：集合类型
│   ├── error_handling.rs    # 第5章：错误处理
│   ├── generics.rs          # 第6章：泛型
│   ├── traits.rs            # 第7章：特征
│   ├── lifetimes.rs         # 第8章：生命周期
│   ├── closures.rs          # 第9章：闭包
│   ├── iterators.rs         # 第10章：迭代器
│   ├── smart_pointers.rs    # 第11章：智能指针
│   ├── concurrency.rs       # 第12章：并发编程
│   ├── async_programming.rs # 第13章：异步编程
│   └── macros.rs            # 第14章：宏
├── Cargo.toml               # 项目配置文件
└── README.md                # 本文件
```

## 🚀 快速开始

### 1. 环境准备

项目已自动安装 Rust 工具链。验证安装：

```bash
rustc --version
cargo --version
```

如果需要手动安装，运行：

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### 2. 运行项目

进入项目目录：

```bash
cd /workspaces/codespaces-blank/RustStudio
```

运行完整项目（自动演示所有模块）：

```bash
cargo run
```

### 3. 编译优化版本

```bash
cargo build --release
./target/release/rust_studio
```

## 📖 学习内容

### 第1章：基础语法 (Basics)
- ✅ 变量和可变性
- ✅ 数据类型（整数、浮点、布尔、字符、元组、数组）
- ✅ 函数定义和调用
- ✅ 控制流（if、loop、while、for）
- ✅ 注释

### 第2章：所有权系统 (Ownership)
- ✅ 所有权规则
- ✅ 移动（Move）和克隆（Clone）
- ✅ 引用和借用
- ✅ 可变引用
- ✅ 切片（Slice）

### 第3章：结构体和枚举 (Structs & Enums)
- ✅ 结构体定义和实例化
- ✅ 方法和关联函数
- ✅ 枚举定义
- ✅ 模式匹配（match）
- ✅ Option 枚举

### 第4章：集合类型 (Collections)
- ✅ Vector（动态数组）
- ✅ String（可增长字符串）
- ✅ HashMap（哈希映射）

### 第5章：错误处理 (Error Handling)
- ✅ panic! 宏
- ✅ Result<T, E> 类型
- ✅ ? 运算符
- ✅ 自定义错误类型

### 第6章：泛型 (Generics)
- ✅ 泛型函数
- ✅ 泛型结构体
- ✅ 泛型枚举
- ✅ 泛型方法

### 第7章：特征 (Traits)
- ✅ 定义和实现 trait
- ✅ 默认实现
- ✅ trait 作为参数
- ✅ trait bounds
- ✅ 标准库 traits

### 第8章：生命周期 (Lifetimes)
- ✅ 生命周期注解
- ✅ 函数中的生命周期
- ✅ 结构体中的生命周期
- ✅ 生命周期省略规则
- ✅ 静态生命周期

### 第9章：闭包 (Closures)
- ✅ 闭包语法
- ✅ 类型推断
- ✅ 捕获环境
- ✅ Fn traits（FnOnce、FnMut、Fn）
- ✅ 闭包作为参数和返回值

### 第10章：迭代器 (Iterators)
- ✅ Iterator trait
- ✅ iter()、iter_mut()、into_iter()
- ✅ 消费适配器（sum、collect、find）
- ✅ 迭代器适配器（map、filter、zip）
- ✅ 自定义迭代器

### 第11章：智能指针 (Smart Pointers)
- ✅ Box<T>（堆上分配）
- ✅ Rc<T>（引用计数）
- ✅ RefCell<T>（内部可变性）
- ✅ Weak<T>（弱引用）

### 第12章：并发编程 (Concurrency)
- ✅ 线程创建和管理
- ✅ 消息传递（Channel）
- ✅ 共享状态（Mutex）
- ✅ Arc<Mutex<T>> 模式
- ✅ Sync 和 Send traits

### 第13章：异步编程 (Async Programming)
- ✅ async/await 语法
- ✅ Future trait
- ✅ 异步运行时（tokio）
- ✅ 常见异步模式

### 第14章：宏 (Macros)
- ✅ 声明宏（macro_rules!）
- ✅ 标准宏使用
- ✅ 自定义宏
- ✅ 过程宏概念

## 🛠️ 常用命令

```bash
# 运行项目
cargo run

# 检查代码（不编译）
cargo check

# 编译项目
cargo build

# 发布版本编译
cargo build --release

# 运行测试
cargo test

# 格式化代码
cargo fmt

# 代码检查（Clippy）
cargo clippy

# 查看文档
cargo doc --open

# 清理编译产物
cargo clean
```

## 💡 学习建议

1. **循序渐进**：按照章节顺序学习，每个章节都建立在前面的基础上
2. **动手实践**：阅读代码后，尝试修改和扩展示例
3. **理解概念**：特别关注所有权、借用、生命周期等 Rust 独特概念
4. **查阅文档**：遇到问题查看 [Rust 官方文档](https://doc.rust-lang.org/)
5. **编写代码**：在 src/ 目录下创建自己的练习文件

## 📚 推荐资源

- [The Rust Programming Language](https://doc.rust-lang.org/book/) - 官方书籍
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/) - 示例学习
- [Rustlings](https://github.com/rust-lang/rustlings) - 交互式练习
- [Rust Playground](https://play.rust-lang.org/) - 在线编辑器

## 🎯 下一步

完成本项目的学习后，你可以：

1. 尝试构建实际项目（CLI 工具、Web 服务、系统程序）
2. 学习流行的 Rust 框架（Tokio、Actix、Rocket）
3. 参与开源项目
4. 阅读 Rust 标准库源码

## ⚠️ 注意事项

- 某些示例（如 panic!）在注释中，取消注释会导致程序终止
- 异步编程模块展示概念，实际运行需要添加 tokio 依赖
- 建议使用最新稳定版 Rust（本项目使用 Rust 1.91.1）

## 🤝 贡献

欢迎提出建议和改进！

## 📄 许可证

本项目仅用于学习目的。

---

**祝你学习愉快！享受 Rust 编程的乐趣！** 🦀✨
