# GoStudio 学习指南

## 📚 完整的 Go 语言学习路径

### 快速导航

- [开始学习](#开始学习)
- [模块说明](#模块说明)
- [运行方式](#运行方式)
- [学习建议](#学习建议)
- [练习题](#练习题)

---

## 开始学习

### 前置要求
- Go 1.18+ 已安装
- 基本的编程概念理解
- 文本编辑器或 IDE（推荐 VS Code + Go 扩展）

### 第一步
```bash
# 克隆或进入项目目录
cd GoStudio

# 运行主程序
go run main.go

# 或给脚本添加执行权限并运行
chmod +x run.sh
./run.sh
```

---

## 模块说明

### 📦 01-basics - 基础语法
学习 Go 的基本构建块

**variables.go** - 变量和常量
- var 声明
- 短变量声明 (:=)
- 常量 (const)
- iota 常量生成器
- 零值概念

**types.go** - 数据类型
- 基本类型（布尔、整数、浮点、字符串）
- 复数类型
- 数组、切片、映射
- 结构体、接口
- 类型转换

**operators.go** - 运算符
- 算术运算符
- 比较运算符
- 逻辑运算符
- 位运算符
- 赋值运算符

### 🔀 02-control - 控制流
掌握程序流程控制

**conditions.go** - 条件语句
- if-else 语句
- if 简短语句
- 嵌套条件
- 卫语句模式

**loops.go** - 循环
- for 循环的三种形式
- range 遍历
- break 和 continue
- 标签和嵌套循环

**switch.go** - Switch 语句
- 基本 switch
- 无表达式 switch
- fallthrough
- 类型 switch

### ⚙️ 03-functions - 函数
深入理解函数式编程

**basic.go** - 基本函数
- 函数定义和调用
- 多返回值
- 命名返回值
- 可变参数
- defer 语句

**advanced.go** - 高级函数
- 高阶函数
- 函数作为值
- 函数组合
- 柯里化
- 记忆化

**closures.go** - 闭包
- 闭包概念
- 捕获外部变量
- 工厂函数
- 延迟计算
- 生成器模式

### 📦 04-data-structures - 数据结构
掌握 Go 的核心数据结构

**arrays.go** - 数组
- 数组声明和初始化
- 多维数组
- 数组作为参数

**slices.go** - 切片
- 切片创建和操作
- append 和 copy
- 切片技巧
- 容量和长度

**maps.go** - 映射
- 映射创建和操作
- 键值对遍历
- 映射作为集合
- 嵌套映射

**structs.go** - 结构体
- 结构体定义
- 匿名字段
- 嵌套结构体
- 结构体标签
- JSON 序列化

### 🎯 05-methods - 方法和接口
面向对象编程概念

**methods.go** - 方法
- 方法定义
- 值接收者 vs 指针接收者
- 方法链
- 方法表达式和方法值

**interfaces.go** - 接口
- 接口定义和实现
- 空接口
- 类型断言和类型选择
- 接口组合
- 多态性

### 🔄 06-concurrency - 并发编程
Go 的杀手级特性

**goroutines.go** - Goroutines
- goroutine 创建
- 并发执行
- goroutine 同步
- 常见陷阱

**channels.go** - Channels
- channel 创建和使用
- 缓冲 channel
- channel 关闭
- 单向 channel
- WaitGroup

**select.go** - Select 语句
- select 多路复用
- 超时处理
- 非阻塞操作
- 退出信号

### ⚠️ 07-errors - 错误处理
健壮的错误处理机制

**errors.go** - 错误处理
- error 接口
- 自定义错误
- 错误包装
- errors.Is 和 errors.As
- 最佳实践

**panic.go** - Panic 和 Recover
- panic 机制
- recover 恢复
- defer 中的 recover
- 使用场景

### 🚀 09-advanced - 高级特性
深入 Go 的高级概念

**pointers.go** - 指针
- 指针基础
- 指针传递
- 指针与结构体
- 使用场景

**generics.go** - 泛型
- 泛型函数
- 泛型类型
- 类型约束
- 泛型应用

---

## 运行方式

### 方式 1: 交互式主程序
```bash
go run main.go
```
通过菜单选择要学习的模块

### 方式 2: 使用脚本
```bash
# 运行所有示例
./run.sh all

# 运行特定模块
./run.sh basics
./run.sh control
./run.sh functions
./run.sh data
./run.sh methods
./run.sh concurrency
./run.sh errors
./run.sh advanced

# 运行单个文件
./run.sh 01-basics/variables
```

### 方式 3: 直接运行
```bash
# 运行单个文件
go run 01-basics/variables.go
go run 02-control/loops.go
go run 06-concurrency/channels.go
```

---

## 学习建议

### 📖 学习顺序
1. **按照目录顺序学习**（01 → 09）
2. **每个模块完成后做练习**
3. **修改代码，观察变化**
4. **尝试组合不同概念**

### 💡 学习技巧
- ✅ 运行代码，观察输出
- ✅ 修改参数，看看会发生什么
- ✅ 添加打印语句调试
- ✅ 尝试自己实现类似功能
- ✅ 阅读 Go 官方文档
- ✅ 参与 Go 社区讨论

### ⚡ 重点关注
- **并发编程** - Go 的核心优势
- **接口** - Go 的灵活性来源
- **错误处理** - 写出健壮的代码
- **切片和映射** - 最常用的数据结构

---

## 练习题

### Level 1 - 基础练习

**练习 1.1: 温度转换器**
```
编写程序转换摄氏度和华氏度
- 使用函数实现转换逻辑
- 支持批量转换（切片）
```

**练习 1.2: 数字分类**
```
给定一个整数切片，分类为：
- 正数、负数、零
- 奇数、偶数
- 质数、合数
```

**练习 1.3: 字符串处理**
```
实现字符串工具函数：
- 反转字符串
- 统计词频
- 判断回文
```

### Level 2 - 中级练习

**练习 2.1: 学生管理系统**
```
使用结构体和映射实现：
- 添加/删除/查询学生
- 计算平均分
- 排序功能
```

**练习 2.2: 并发下载器**
```
使用 goroutines 和 channels：
- 模拟并发下载多个文件
- 显示下载进度
- 处理超时和错误
```

**练习 2.3: 泛型数据结构**
```
实现泛型数据结构：
- 泛型队列
- 泛型链表
- 泛型二叉树
```

### Level 3 - 高级练习

**练习 3.1: HTTP 服务器**
```
创建简单的 HTTP 服务：
- RESTful API 端点
- JSON 处理
- 错误处理中间件
```

**练习 3.2: 并发爬虫**
```
实现网页爬虫：
- 并发抓取多个页面
- URL 去重
- 限制并发数量
```

**练习 3.3: 任务调度器**
```
实现任务调度系统：
- 定时任务
- 并发执行
- 优先级队列
```

---

## 其他资源

### 📚 推荐阅读
- [Go 官方文档](https://golang.org/doc/)
- [Go by Example](https://gobyexample.com/)
- [Effective Go](https://golang.org/doc/effective_go)
- [Go 语言圣经](https://gopl.io/)

### 🛠️ 工具推荐
- **VS Code** + Go 扩展
- **GoLand** - JetBrains IDE
- **go fmt** - 代码格式化
- **go vet** - 代码检查
- **golint** - 代码规范检查

### 🌐 社区
- [Go 官方论坛](https://forum.golangbridge.org/)
- [r/golang](https://reddit.com/r/golang)
- [Gopher Slack](https://gophers.slack.com/)

---

## 🎯 学习目标

完成本项目后，你将能够：

✅ 理解 Go 的基本语法和概念  
✅ 编写清晰、惯用的 Go 代码  
✅ 使用 goroutines 和 channels 进行并发编程  
✅ 设计和实现接口  
✅ 处理错误和异常情况  
✅ 使用泛型编写可复用代码  
✅ 构建完整的 Go 应用程序  

---

祝你学习愉快！如有问题，欢迎提 Issue 或 PR。🚀
