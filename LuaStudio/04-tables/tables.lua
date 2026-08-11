-- =====================================================
-- 04-tables/tables.lua
-- Lua 表（Table）：Lua 唯一的数据结构
-- =====================================================

-- Lua 的 table 既可以当作数组，也可以当作字典，
-- 甚至可以当作对象（面向对象编程的基础）。

print("\n=== 1. 数组（数组部分） ===")

-- 数组从索引 1 开始（Lua 约定）
local fruits = { "苹果", "香蕉", "橙子", "葡萄" }

print("第1个元素:", fruits[1])
print("第3个元素:", fruits[3])

-- 获取数组长度（# 运算符）
print("数组长度:", #fruits)

-- 遍历数组
for i = 1, #fruits do
    io.write(fruits[i], " ")
end
print()

-- 添加元素
table.insert(fruits, "西瓜")
print("插入后长度:", #fruits)

-- 删除元素
table.remove(fruits, 2)
print("删除索引2后:", fruits[2])

print("\n=== 2. 字典（键值对部分） ===")

local person = {
    name = "张三",
    age = 25,
    city = "北京"
}

-- 两种访问方式
print("person.name:", person.name)
print("person['age']:", person["age"])

-- 新增键值
person.occupation = "工程师"
print("新增字段:", person.occupation)

-- 删除键值
person.city = nil
print("删除 city 后:", tostring(person.city))

-- 数字键（不连续）
local mixed = { [1] = "one", [2] = "two", [10] = "ten" }
print("mixed[10]:", mixed[10])

-- 布尔/函数等都可以作为键
local funcKey = function() return "值" end
local special = { [funcKey] = "函数键的值" }
print("函数作为键:", special[funcKey])

print("\n=== 3. 多维表（嵌套表） ===")

local matrix = {
    { 1, 2, 3 },
    { 4, 5, 6 },
    { 7, 8, 9 }
}

print("matrix[2][3]:", matrix[2][3])

-- 学生记录嵌套表
local students = {
    { name = "李雷", scores = { math = 90, english = 85 } },
    { name = "韩梅梅", scores = { math = 88, english = 95 } }
}
print("李雷的数学成绩:", students[1].scores.math)

print("\n=== 4. table 库常用函数 ===")

-- sort 排序
local numbers = { 5, 2, 8, 1, 9, 3 }
table.sort(numbers)
for _, v in ipairs(numbers) do
    io.write(v, " ")
end
print("（升序排序）")

table.sort(numbers, function(a, b) return a > b end)
for _, v in ipairs(numbers) do
    io.write(v, " ")
end
print("（降序排序）")

-- concat 连接
local parts = { "Lua", "is", "awesome" }
print("连接:", table.concat(parts, " "))

-- unpack 解包（Lua 5.1 为 table.unpack）
local a, b, c = table.unpack({ 1, 2, 3 })
print("unpack: a=", a, "b=", b, "c=", c)

print("\n=== 5. 遍历表的所有方式 ===")

local inventory = {
    apple = 10,
    banana = 5,
    orange = 20
}

-- pairs 遍历（无顺序保证）
print("pairs 遍历:")
for key, value in pairs(inventory) do
    print("  " .. key .. ": " .. value)
end

-- 有序遍历：收集键再排序
print("按键名排序遍历:")
local keys = {}
for k in pairs(inventory) do
    table.insert(keys, k)
end
table.sort(keys)
for _, k in ipairs(keys) do
    print("  " .. k .. ": " .. inventory[k])
end

print("\n=== 6. 集合与计数 ===")

-- 用 table 实现集合
local visited = {}
visited["北京"] = true
visited["上海"] = true

if visited["北京"] then
    print("已访问过北京")
end

-- 词频统计
local words = { "hello", "world", "hello", "lua", "hello" }
local freq = {}
for _, word in ipairs(words) do
    freq[word] = (freq[word] or 0) + 1
end
for word, count in pairs(freq) do
    print(word .. ": " .. count .. "次")
end

print("\n=== 7. 队列/栈操作 ===")

local stack = {}
-- 压栈
table.insert(stack, "A")
table.insert(stack, "B")
table.insert(stack, "C")
-- 出栈（LIFO）
print("出栈:", table.remove(stack))  -- C
print("出栈:", table.remove(stack))  -- B

-- 队列（FIFO）
local queue = {}
table.insert(queue, "客户1")
table.insert(queue, "客户2")
table.insert(queue, "客户3")
print("出队:", table.remove(queue, 1))  -- 客户1
print("出队:", table.remove(queue, 1))  -- 客户2
