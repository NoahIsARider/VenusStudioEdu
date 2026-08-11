// =====================================================
// 03-functions/functions.swift
// Swift 函数：参数、返回值、闭包
// =====================================================

import Foundation

func demoFunctions() {
    print("\n=== 1. 函数定义与调用 ===")

    // 基本函数定义：func 函数名(参数) -> 返回类型
    func greet(name: String) -> String {
        return "你好，\(name)！"
    }
    print(greet(name: "Swift"))

    // 无返回值的函数（Void 或省略）
    func sayHello() {
        print("Hello, World!")
    }
    sayHello()

    // 无参数无返回值
    func printLine() {
        print("----------")
    }
    printLine()

    print("\n=== 2. 参数与返回值 ===")

    // 多参数函数
    func add(a: Int, b: Int) -> Int {
        return a + b
    }
    print("加法: \(add(a: 10, b: 20))")

    // 多返回值（元组）
    func minMax(_ array: [Int]) -> (min: Int, max: Int)? {
        if array.isEmpty { return nil }
        var currentMin = array[0]
        var currentMax = array[0]
        for value in array[1...] {
            if value < currentMin {
                currentMin = value
            } else if value > currentMax {
                currentMax = value
            }
        }
        return (currentMin, currentMax)
    }
    if let result = minMax([3, 7, 1, 9, 4]) {
        print("最小值: \(result.min), 最大值: \(result.max)")
    }

    // 隐式返回（函数体只有一行表达式时可省略 return）
    func square(_ x: Int) -> Int {
        x * x  // 隐式返回
    }
    print("平方: \(square(5))")

    print("\n=== 3. 参数标签 ===")

    // 参数标签（外部名）和参数名（内部名）
    func greetPerson(_ person: String, on day: String) -> String {
        return "你好 \(person)，今天是 \(day)"
    }
    // 第一个参数省略标签（_），第二个使用标签 on
    print(greetPerson("小明", on: "星期一"))

    // 自定义参数标签
    func say(to name: String, with greeting: String) {
        print("\(greeting)，\(name)！")
    }
    say(to: "小红", with: "你好")

    print("\n=== 4. 默认参数值 ===")

    func introduce(name: String, age: Int = 18, city: String = "北京") {
        print("我是 \(name)，\(age) 岁，来自 \(city)")
    }
    introduce(name: "小明")
    introduce(name: "小红", age: 20)
    introduce(name: "小刚", age: 25, city: "上海")

    print("\n=== 5. 可变参数 ===")

    // 可变参数接受 0 个或多个值，在函数内作为数组使用
    func sum(_ numbers: Double...) -> Double {
        var total: Double = 0
        for n in numbers {
            total += n
        }
        return total
    }
    print("求和: \(sum(1, 2, 3))")
    print("求和: \(sum(1.5, 2.5, 3.5, 4.5))")
    print("空求和: \(sum())")

    print("\n=== 6. inout 参数 ===")

    // inout 参数允许函数修改外部变量（按引用传递）
    func swapTwoInts(_ a: inout Int, _ b: inout Int) {
        let temp = a
        a = b
        b = temp
    }
    var x = 10, y = 20
    print("交换前: x = \(x), y = \(y)")
    swapTwoInts(&x, &y)
    print("交换后: x = \(x), y = \(y)")

    print("\n=== 7. 函数类型 ===")

    // 函数也是一种类型
    func addFunc(_ a: Int, _ b: Int) -> Int { a + b }
    func multiplyFunc(_ a: Int, _ b: Int) -> Int { a * b }

    var mathFunction: (Int, Int) -> Int = addFunc
    print("加法: \(mathFunction(3, 4))")
    mathFunction = multiplyFunc
    print("乘法: \(mathFunction(3, 4))")

    // 函数作为参数
    func apply(_ a: Int, _ b: Int, using function: (Int, Int) -> Int) -> Int {
        function(a, b)
    }
    print("应用加法: \(apply(10, 5, using: addFunc))")
    print("应用乘法: \(apply(10, 5, using: multiplyFunc))")

    // 函数作为返回值
    func makeIncrementer(by amount: Int) -> (Int) -> Int {
        func incrementer(_ value: Int) -> Int {
            value + amount
        }
        return incrementer
    }
    let incBy10 = makeIncrementer(by: 10)
    print("增量器: \(incBy10(5))")
    print("增量器: \(incBy10(20))")

    print("\n=== 8. 闭包基础 ===")

    // 闭包是自包含的函数代码块
    let names = ["Charlie", "Alice", "Bob", "David"]

    // 完整闭包语法
    let sorted1 = names.sorted(by: { (s1: String, s2: String) -> Bool in
        return s1 < s2
    })
    print("排序（完整闭包）: \(sorted1)")

    // 类型推断（省略类型和返回值）
    let sorted2 = names.sorted(by: { s1, s2 in s1 < s2 })
    print("排序（简化闭包）: \(sorted2)")

    // 简化参数名 $0, $1
    let sorted3 = names.sorted(by: { $0 < $1 })
    print("排序（$ 参数）: \(sorted3)")

    // 最简形式：仅传运算符
    let sorted4 = names.sorted(by: <)
    print("排序（运算符方法）: \(sorted4)")

    print("\n=== 9. 尾随闭包 ===")

    // 尾随闭包：闭包是最后一个参数时可写在括号外
    let result = names.sorted { $0 < $1 }
    print("尾随闭包排序: \(result)")

    // map 使用尾随闭包
    let numbers = [1, 2, 3, 4, 5]
    let doubled = numbers.map { $0 * 2 }
    print("map 翻倍: \(doubled)")

    let strings = numbers.map { "数字 \($0)" }
    print("map 转字符串: \(strings)")

    print("\n=== 10. 闭包捕获值 ===")

    // 闭包会捕获其上下文中的变量
    func makeCounter() -> () -> Int {
        var count = 0
        return {
            count += 1
            return count
        }
    }
    let counter = makeCounter()
    print("计数器: \(counter())")
    print("计数器: \(counter())")
    print("计数器: \(counter())")

    print("\n=== 11. 逃逸闭包 ===")

    // @escaping 标记闭包会逃逸出函数（存储或在异步中调用）
    var storedClosures: [() -> Void] = []
    func storeClosure(_ closure: @escaping () -> Void) {
        storedClosures.append(closure)
    }
    storeClosure { print("  被存储的闭包被调用") }
    for closure in storedClosures {
        closure()
    }

    print("\n=== 12. 自动闭包 ===")

    // @autoclosure 自动将表达式包装为闭包（延迟求值）
    func logIfTrue(_ condition: @autoclosure () -> Bool) {
        if condition() {
            print("  条件为真")
        }
    }
    logIfTrue(2 > 1)  // 表达式自动包装为闭包
}

demoFunctions()
