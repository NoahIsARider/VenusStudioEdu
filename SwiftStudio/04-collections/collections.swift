// =====================================================
// 04-collections/collections.swift
// Swift 集合类型：数组、字典、集合
// =====================================================

import Foundation

func demoCollections() {
    print("\n=== 1. 数组基础 ===")

    // 数组创建
    var numbers: [Int] = [1, 2, 3, 4, 5]
    let fruits: [String] = ["苹果", "香蕉", "橙子"]
    let emptyArray: [Double] = []
    let repeatedArray = Array(repeating: 0, count: 5)

    print("数字数组: \(numbers)")
    print("水果数组: \(fruits)")
    print("空数组: \(emptyArray)")
    print("重复数组: \(repeatedArray)")

    // 数组元素个数
    print("数字数组个数: \(numbers.count)")
    print("数组是否为空: \(emptyArray.isEmpty)")

    print("\n=== 2. 数组操作 ===")

    // 添加元素
    numbers.append(6)
    print("追加 6: \(numbers)")

    numbers += [7, 8]
    print("追加 [7, 8]: \(numbers)")

    numbers.insert(0, at: 0)
    print("在索引 0 插入 0: \(numbers)")

    // 访问元素
    print("第一个元素: \(numbers[0])")
    print("最后一个元素: \(numbers.last!)")

    // 安全访问（返回可选值）
    if let first = numbers.first {
        print("安全访问第一个: \(first)")
    }

    // 修改元素
    numbers[0] = 100
    print("修改索引 0 为 100: \(numbers)")

    // 删除元素
    let removed = numbers.remove(at: 0)
    print("删除索引 0（值 \(removed)）: \(numbers)")
    numbers.removeLast()
    print("删除最后一个: \(numbers)")

    // 判断是否包含
    print("是否包含 3: \(numbers.contains(3))")

    print("\n=== 3. 数组遍历 ===")

    let colors = ["红", "绿", "蓝"]
    for color in colors {
        print("  颜色: \(color)")
    }

    // 遍历带索引
    for (index, color) in colors.enumerated() {
        print("  索引 \(index): \(color)")
    }

    print("\n=== 4. 字典基础 ===")

    // 字典创建
    var scores: [String: Int] = ["小明": 90, "小红": 85, "小刚": 78]
    let emptyDict: [String: Int] = [:]
    let capitals = ["中国": "北京", "日本": "东京", "韩国": "首尔"]

    print("成绩字典: \(scores)")
    print("首都字典: \(capitals)")
    print("空字典: \(emptyDict)")

    print("字典个数: \(scores.count)")
    print("字典是否为空: \(emptyDict.isEmpty)")

    print("\n=== 5. 字典操作 ===")

    // 访问值（返回可选值）
    if let score = scores["小明"] {
        print("小明的成绩: \(score)")
    }
    print("不存在的键: \(scores["小张"] ?? "无")")

    // 添加/修改键值对
    scores["小张"] = 88
    print("添加小张: \(scores)")

    scores["小明"] = 95
    print("修改小明成绩: \(scores)")

    // updateValue 返回旧值
    if let old = scores.updateValue(100, forKey: "小红") {
        print("小红旧成绩: \(old), 新成绩: 100")
    }

    // 删除键值对
    scores.removeValue(forKey: "小刚")
    print("删除小刚: \(scores)")

    scores["小张"] = nil  // 另一种删除方式
    print("删除小张: \(scores)")

    print("\n=== 6. 字典遍历 ===")

    for (name, score) in scores {
        print("  \(name): \(score) 分")
    }

    // 只遍历键或值
    print("所有键: \(Array(scores.keys))")
    print("所有值: \(Array(scores.values))")

    print("\n=== 7. 集合基础 ===")

    // 集合是无序且不重复的集合
    var primes: Set<Int> = [2, 3, 5, 7, 11]
    let evens: Set<Int> = [2, 4, 6, 8]

    print("素数集合: \(primes)")
    print("偶数集合: \(evens)")
    print("集合个数: \(primes.count)")

    // 集合操作
    primes.insert(13)
    print("插入 13: \(primes)")

    primes.remove(2)
    print("删除 2: \(primes)")

    print("是否包含 5: \(primes.contains(5))")

    print("\n=== 8. 集合运算 ===")

    let setA: Set<Int> = [1, 2, 3, 4, 5]
    let setB: Set<Int> = [3, 4, 5, 6, 7]

    // 交集
    print("交集: \(setA.intersection(setB))")
    // 并集
    print("并集: \(setA.union(setB))")
    // 差集
    print("差集 (A-B): \(setA.subtracting(setB))")
    // 对称差集
    print("对称差集: \(setA.symmetricDifference(setB))")

    // 子集判断
    let setC: Set<Int> = [1, 2]
    print("C 是 A 的子集: \(setC.isSubset(of: setA))")
    print("A 是 C 的超集: \(setA.isSuperset(of: setC))")

    print("\n=== 9. 数组与集合转换 ===")

    // 数组转集合（去重）
    let duplicates = [1, 2, 2, 3, 3, 3, 4]
    let unique = Set(duplicates)
    print("原数组: \(duplicates)")
    print("去重集合: \(unique)")
    print("去重数组: \(Array(unique))")

    print("\n=== 10. map 高阶函数 ===")

    let nums = [1, 2, 3, 4, 5]

    // map 对每个元素进行变换
    let squared = nums.map { $0 * $0 }
    print("平方: \(squared)")

    let asStrings = nums.map { String($0) }
    print("转字符串: \(asStrings)")

    print("\n=== 11. filter 高阶函数 ===")

    // filter 筛选满足条件的元素
    let evens2 = nums.filter { $0 % 2 == 0 }
    print("偶数: \(evens2)")

    let bigNums = nums.filter { $0 > 3 }
    print("大于 3: \(bigNums)")

    print("\n=== 12. reduce 高阶函数 ===")

    // reduce 将元素合并为一个值
    let sum = nums.reduce(0) { $0 + $1 }
    print("求和: \(sum)")

    // 简化形式
    let product = nums.reduce(1, *)
    print("乘积: \(product)")

    let maxNum = nums.reduce(Int.min) { max($0, $1) }
    print("最大值: \(maxNum)")

    print("\n=== 13. 组合使用 map / filter / reduce ===")

    // 计算 1-10 中偶数的平方和
    let evenSquaredSum = (1...10).filter { $0 % 2 == 0 }.map { $0 * $0 }.reduce(0, +)
    print("1-10 偶数平方和: \(evenSquaredSum)")

    // 链式调用
    let words = ["Swift", "is", "awesome", "and", "fast"]
    let upperLong = words.filter { $0.count > 2 }.map { $0.uppercased() }
    print("长度 > 2 的词转大写: \(upperLong)")

    print("\n=== 14. sorted 和 contains ===")

    let unsorted = [5, 2, 8, 1, 9, 3]
    print("原始: \(unsorted)")
    print("升序: \(unsorted.sorted())")
    print("降序: \(unsorted.sorted(by: >))")

    print("是否包含 8: \(unsorted.contains(8))")

    // 自定义排序
    let people = [("小明", 20), ("小红", 18), ("小刚", 25)]
    let sortedPeople = people.sorted { $0.1 < $1.1 }
    print("按年龄排序: \(sortedPeople)")

    print("\n=== 15. flatMap 和 compactMap ===")

    // compactMap 过滤 nil 值
    let optionalNums: [Int?] = [1, nil, 3, nil, 5]
    let unwrapped = optionalNums.compactMap { $0 }
    print("compactMap 过滤 nil: \(unwrapped)")

    // flatMap 拍平嵌套数组
    let nested = [[1, 2], [3, 4], [5, 6]]
    let flat = nested.flatMap { $0 }
    print("flatMap 拍平: \(flat)")
}

demoCollections()
