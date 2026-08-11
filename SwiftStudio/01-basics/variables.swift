// =====================================================
// 01-basics/variables.swift
// Swift 变量和数据类型基础
// =====================================================

import Foundation

// Swift 是一种强类型语言，拥有类型推断机制。
// 使用 var 声明变量（可变），使用 let 声明常量（不可变，推荐）。

func demoVariables() {
    print("\n=== 1. 变量与常量（var / let） ===")

    // 1. var 声明可变变量
    var name = "SwiftStudio"
    print("变量 name = \(name)")
    name = "Swift"  // var 可以重新赋值
    print("修改后 name = \(name)")

    // 2. let 声明常量（不可变，Swift 推荐优先使用 let）
    let version = "5.9"
    print("常量 version = \(version)")
    // version = "6.0"  // ❌ 编译错误：let 声明的常量不能修改

    // 3. 一行声明多个变量
    var a = 1, b = 2, c = 3
    print("多变量声明: a = \(a), b = \(b), c = \(c)")

    // 4. 变量交换（Swift 原生支持元组交换，无需临时变量）
    (a, b) = (b, a)
    print("交换后: a = \(a), b = \(b)")

    print("\n=== 2. 类型推断与类型标注 ===")

    // Swift 会自动推断变量类型（类型推断）
    let integer = 42          // 推断为 Int
    let double = 3.14159      // 推断为 Double
    let text = "你好，Swift！"  // 推断为 String
    let boolean = true        // 推断为 Bool

    print("整数 \(integer) 类型: \(type(of: integer))")
    print("浮点 \(double) 类型: \(type(of: double))")
    print("字符串 \"\(text)\" 类型: \(type(of: text))")
    print("布尔 \(boolean) 类型: \(type(of: boolean))")

    // 显式类型标注（类型注解）
    let explicitInt: Int = 100
    let explicitDouble: Double = 3.14
    let explicitString: String = "显式类型"
    print("显式标注: \(explicitInt), \(explicitDouble), \(explicitString)")

    print("\n=== 3. 基本数据类型 ===")

    // 整数类型：Int（根据平台为 32 或 64 位）
    let intValue: Int = 42
    let uintValue: UInt = 100      // 无符号整数
    let int8: Int8 = 127            // 8 位整数
    let int64: Int64 = 9_223_372_036_854_775_807  // 下划线提高可读性
    print("Int: \(intValue), UInt: \(uintValue), Int8: \(int8), Int64: \(int64)")

    // 浮点类型
    let doubleValue: Double = 3.14159265358979  // 64 位浮点（15 位精度）
    let floatValue: Float = 3.14               // 32 位浮点（6 位精度）
    print("Double: \(doubleValue), Float: \(floatValue)")

    // 布尔类型
    let isTrue: Bool = true
    let isFalse = false
    print("布尔: \(isTrue), \(isFalse)")

    // 字符串
    let greeting = "Hello, World!"
    let multiLine = """
        多行字符串
        第二行
        第三行
        """
    print("单行字符串: \(greeting)")
    print("多行字符串:\n\(multiLine)")

    // 字符类型
    let char: Character = "S"
    print("字符: \(char)")

    print("\n=== 4. 字符串插值 ===")

    // Swift 使用 \(表达式) 进行字符串插值
    let name2 = "小明"
    let age = 18
    let height = 1.75
    print("姓名: \(name2), 年龄: \(age) 岁, 身高: \(height) 米")
    print("明年年龄: \(age + 1) 岁")
    print("数学运算: \(2 * 3 + 4)")

    // 字符串拼接（+ 运算符）
    let firstName = "张"
    let lastName = "三"
    let fullName = firstName + lastName
    print("拼接全名: \(fullName)")

    // 字符串重复
    let separator = String(repeating: "-", count: 10)
    print("重复字符串: \(separator)")

    // 字符串长度
    let str = "Swift"
    print("字符串 \"\(str)\" 的字符数: \(str.count)")

    print("\n=== 5. 运算符 ===")

    // 算术运算符
    print("加法 10 + 3 = \(10 + 3)")
    print("减法 10 - 3 = \(10 - 3)")
    print("乘法 10 * 3 = \(10 * 3)")
    print("除法 10 / 3 = \(10 / 3)")        // 整数除法，结果为 3
    print("取余 10 % 3 = \(10 % 3)")

    // 浮点除法
    print("浮点除法 10.0 / 3.0 = \(10.0 / 3.0)")

    // 比较运算符
    print("\n比较运算符:")
    print("10 > 3: \(10 > 3)")
    print("10 < 3: \(10 < 3)")
    print("10 == 3: \(10 == 3)")
    print("10 != 3: \(10 != 3)")

    // 逻辑运算符
    print("\n逻辑运算符:")
    print("true && false: \(true && false)")
    print("true || false: \(true || false)")
    print("!true: \(!true)")

    // 区间运算符（Swift 特色）
    print("\n区间运算符:")
    for i in 1...5 {  // 闭区间 [1, 5]
        print("闭区间 1...5: \(i)", terminator: " ")
    }
    print("")
    for i in 1..<5 {  // 半开区间 [1, 5)
        print("半开区间 1..<5: \(i)", terminator: " ")
    }
    print("")

    // nil 合并运算符（简介，详见第 5 章）
    let optionalValue: Int? = nil
    let defaultValue = optionalValue ?? 0
    print("nil 合并: nil ?? 0 = \(defaultValue)")

    print("\n=== 6. 可选类型基础 ===")

    // 可选类型（Optional）是 Swift 处理 nil 的核心机制
    // 类型后加 ? 表示可选类型，可以为 nil
    var optionalName: String? = "Swift"
    print("可选类型: \(optionalName ?? "无值")")

    optionalName = nil
    print("设为 nil 后: \(optionalName ?? "无值")")

    // 强制解包（!）：确定有值时使用，否则运行时崩溃
    let forcedValue: Int? = 42
    if forcedValue != nil {
        print("强制解包: \(forcedValue!)")
    }

    print("\n=== 7. 类型别名 ===")

    // 使用 typealias 为类型起别名
    typealias Distance = Double
    let distance: Distance = 100.5
    print("类型别名 Distance = \(distance)")

    print("\n=== 8. 元组（Tuple） ===")

    // 元组可将多个值组合为一个复合值
    let person = (name: "小明", age: 18, height: 1.75)
    print("元组: \(person)")
    print("姓名: \(person.name), 年龄: \(person.age), 身高: \(person.height)")

    // 元组分解
    let (pName, pAge, _) = person
    print("分解: 姓名 = \(pName), 年龄 = \(pAge)")
}

demoVariables()
