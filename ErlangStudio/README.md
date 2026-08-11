# ErlangStudio - Erlang 语言学习项目

欢迎来到 ErlangStudio！这是一个全面的 Erlang 编程语言学习项目，通过 8 个章节带你掌握函数式编程和并发编程的核心概念。

## 📚 项目结构

```
ErlangStudio/
├── 01-basics/                # 基础语法
│   └── basics.escript        # 变量、原子、模式匹配、io
├── 02-control/               # 控制流
│   └── control.escript       # if、case、守卫、列表推导
├── 03-functions/             # 函数
│   └── functions.escript     # 多子句、匿名函数、高阶函数
├── 04-data-structures/       # 数据结构
│   └── data.escript          # 列表、元组、映射、记录
├── 05-recursion/             # 递归
│   └── recursion.escript     # 尾递归、快速排序、累加器
├── 06-concurrency/           # 并发编程
│   └── concurrency.escript   # spawn、消息传递、监控
├── 07-errors/                # 错误处理
│   └── errors.escript        # throw/error/exit、try/catch
├── 08-higher-order/          # 高阶与实战
│   └── higher_order.escript  # 管道、位语法、ETS、OTP 模式
├── run.sh                    # 运行脚本
└── README.md                 # 本文件
```

## 🚀 快速开始

```bash
cd ErlangStudio
bash run.sh
```

或运行指定章节：

```bash
bash run.sh 01       # 运行第 1 章
bash run.sh 06-concurrency/concurrency.escript
```

## 📖 学习路径

1. **基础语法** (`01-basics/`) - 不可变变量、原子、模式匹配
2. **控制流** (`02-control/`) - if/case 表达式、守卫、列表推导
3. **函数** (`03-functions/`) - 多子句分派、匿名函数、闭包
4. **数据结构** (`04-data-structures/`) - 列表、元组、映射、记录
5. **递归** (`05-recursion/`) - 尾递归优化、分治算法
6. **并发编程** (`06-concurrency/`) - 进程、消息传递、监控
7. **错误处理** (`07-errors/`) - 三种异常、try/catch
8. **高阶与实战** (`08-higher-order/`) - 管道、位语法、ETS、OTP

## 💡 Erlang 语言特色

- **函数式**：变量不可变，纯函数式编程
- **并发模型**：Actor 模型，进程间消息传递
- **容错设计**："让它崩溃"哲学，监督树
- **模式匹配**：强大的模式匹配贯穿所有语法
- **OTP 框架**：构建高可用分布式系统的框架
- **软实时**：适合电信和实时系统

## 🛠️ 环境要求

- Erlang/OTP 22+（推荐 25+）
- 验证安装：`erl -version`

## 📝 额外资源

- [Erlang 官方文档](https://www.erlang.org/docs)
- [Learn You Some Erlang](https://learnyousomeerlang.com/)
- [OTP Design Principles](https://www.erlang.org/doc/design_principles/des_princ.html)

祝你学习愉快！
