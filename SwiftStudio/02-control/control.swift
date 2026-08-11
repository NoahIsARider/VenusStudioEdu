// =====================================================
// 02-control/control.swift
// Swift 控制流：if/else、switch、循环、guard
// =====================================================

import Foundation

func demoControl() {
    print("\n=== 1. if / else 语句 ===")

    let score = 85
    if score >= 90 {
        print("成绩 \(score) 分，等级：优秀")
    } else if score >= 80 {
        print("成绩 \(score) 分，等级：良好")
    } else if score >= 60 {
        print("成绩 \(score) 分，等级：及格")
    } else {
        print("成绩 \(score) 分，等级：不及格")
    }

    // if 表达式（Swift 5.9+，if 可作为表达式使用）
    let grade = if score >= 60 { "及格" } else { "不及格" }
    print("if 表达式结果: \(grade)")

    print("\n=== 2. switch 语句 ===")

    // Swift 的 switch 不需要 break（默认不穿透）
    let day = 3
    switch day {
    case 1:
        print("星期一")
    case 2:
        print("星期二")
    case 3:
        print("星期三")
    case 4:
        print("星期四")
    case 5:
        print("星期五")
    case 6, 7:  // 多值匹配
        print("周末")
    default:
        print("无效日期")
    }

    // switch 区间匹配
    let temperature = 25
    switch temperature {
    case ..<0:
        print("温度 \(temperature)°C：冰冻")
    case 0...10:
        print("温度 \(temperature)°C：寒冷")
    case 11...25:
        print("温度 \(temperature)°C：凉爽")
    case 26...35:
        print("温度 \(temperature)°C：温暖")
    default:
        print("温度 \(temperature)°C：炎热")
    }

    // switch 元组匹配
    let point = (2, 0)
    switch point {
    case (0, 0):
        print("原点")
    case (_, 0):
        print("在 X 轴上")
    case (0, _):
        print("在 Y 轴上")
    case (let x, let y) where x == y:
        print("在对角线上")
    default:
        print("普通点 (\(point.0), \(point.1))")
    }

    // switch 值绑定
    let anotherPoint = (2, 3)
    switch anotherPoint {
    case (let x, 0):
        print("在 X 轴，x = \(x)")
    case (0, let y):
        print("在 Y 轴，y = \(y)")
    case let (x, y):
        print("普通点: x = \(x), y = \(y)")
    }

    // switch 枚举（字符串）
    let direction = "up"
    switch direction {
    case "up", "down":
        print("垂直方向")
    case "left", "right":
        print("水平方向")
    default:
        print("未知方向")
    }

    print("\n=== 3. for-in 循环 ===")

    // 遍历区间
    print("闭区间 1...5:")
    for i in 1...5 {
        print("  i = \(i)")
    }

    // 半开区间
    print("半开区间 1..<5:")
    for i in 1..<5 {
        print("  i = \(i)")
    }

    // 不需要索引时用下划线
    print("忽略索引:")
    for _ in 1...3 {
        print("  执行一次")
    }

    // 遍历数组
    let fruits = ["苹果", "香蕉", "橙子"]
    print("遍历数组:")
    for fruit in fruits {
        print("  水果: \(fruit)")
    }

    // 遍历字典
    let scores = ["小明": 90, "小红": 85, "小刚": 78]
    print("遍历字典:")
    for (name, sc) in scores {
        print("  \(name): \(sc) 分")
    }

    // stride 步长
    print("步长为 2 的区间:")
    for i in stride(from: 0, through: 10, by: 2) {
        print("  i = \(i)", terminator: " ")
    }
    print("")

    print("\n=== 4. while 循环 ===")

    var count = 3
    print("while 循环倒计时:")
    while count > 0 {
        print("  倒计时: \(count)")
        count -= 1
    }
    print("  发射！")

    print("\n=== 5. repeat-while 循环 ===")

    // repeat-while 类似其他语言的 do-while，至少执行一次
    var num = 5
    print("repeat-while 循环:")
    repeat {
        print("  num = \(num)")
        num -= 1
    } while num > 0

    print("\n=== 6. guard 语句 ===")

    // guard 用于提前退出，必须包含 else 分支
    func checkAge(_ age: Int) {
        guard age >= 18 else {
            print("  未成年（\(age) 岁），禁止进入")
            return
        }
        print("  已成年（\(age) 岁），允许进入")
    }

    print("guard 语句示例:")
    checkAge(20)
    checkAge(15)

    // guard let 解包可选值（详见第 5 章）
    func printName(_ name: String?) {
        guard let n = name else {
            print("  名字为空")
            return
        }
        print("  名字是: \(n)")
    }
    print("guard let 示例:")
    printName("Swift")
    printName(nil)

    print("\n=== 7. break 和 continue ===")

    // break 跳出循环
    print("break 示例（遇到 3 停止）:")
    for i in 1...10 {
        if i == 3 {
            break
        }
        print("  i = \(i)")
    }

    // continue 跳过本次循环
    print("continue 示例（跳过偶数）:")
    for i in 1...10 {
        if i % 2 == 0 {
            continue
        }
        print("  奇数: \(i)", terminator: " ")
    }
    print("")

    print("\n=== 8. 标签语句 ===")

    // 标签语句用于在嵌套循环中跳出或跳过指定层级的循环
    outerLoop: for i in 1...3 {
        for j in 1...3 {
            if i == 2 && j == 2 {
                print("  跳出外层循环 (i=\(i), j=\(j))")
                break outerLoop
            }
            print("  i=\(i), j=\(j)")
        }
    }

    // continue 标签
    print("continue 标签示例:")
    outerLoop2: for i in 1...3 {
        for j in 1...3 {
            if j == 2 {
                continue outerLoop2  // 跳过外层循环本次迭代
            }
            print("  i=\(i), j=\(j)")
        }
    }

    print("\n=== 9. fallthrough ===")

    // Swift 的 switch 默认不穿透，使用 fallthrough 可强制穿透到下一个 case
    let level = 1
    switch level {
    case 1:
        print("  级别 1：基础权限")
        fallthrough
    case 2:
        print("  级别 2：中级权限")
        fallthrough
    case 3:
        print("  级别 3：高级权限")
    default:
        break
    }
}

demoControl()
