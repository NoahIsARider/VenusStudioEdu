-- =====================================================
-- 03-functions/functions.lua
-- Lua 函数：定义、参数、返回值、闭包、可变参数
-- =====================================================

-- Lua 中函数是第一类值（First-Class Value），
-- 可以赋值给变量、作为参数传递、作为返回值。

print("\n=== 1. 函数定义 ===")

-- 基本函数定义
function add(a, b)
    return a + b
end

-- 等价的匿名函数赋值写法
local subtract = function(a, b)
    return a - b
end

print("add(3, 5) =", add(3, 5))
print("subtract(10, 4) =", subtract(10, 4))

print("\n=== 2. 多返回值 ===")

-- Lua 函数可以返回多个值
function divide(a, b)
    if b == 0 then
        return nil, "除数不能为零"
    end
    return a / b, "成功"
end

local result, message = divide(10, 2)
print("divide(10, 2):", result, message)

local result2, message2 = divide(10, 0)
print("divide(10, 0):", tostring(result2), message2)

print("\n=== 3. 默认参数与参数个数 ===")

function greet(name, greeting)
    greeting = greeting or "你好"  -- 使用 or 设置默认值
    print(greeting .. "，" .. name .. "！")
end

greet("小明")
greet("小明", "Hello")

print("\n=== 4. 可变参数 (...) ===")

function sum(...)
    local total = 0
    for _, v in ipairs({ ... }) do
        total = total + v
    end
    return total
end

print("sum(1,2,3,4,5) =", sum(1, 2, 3, 4, 5))
print("sum() =", sum())

-- select 获取参数个数和特定参数
function showArgs(...)
    print("参数个数:", select("#", ...))
    print("第2个参数:", select(2, ...))
end
showArgs("a", "b", "c", "d")

print("\n=== 5. 闭包（Closure） ===")

-- 计数器闭包
function createCounter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

local counter = createCounter()
print("计数器调用1:", counter())
print("计数器调用2:", counter())
print("计数器调用3:", counter())

-- 独立的闭包实例
local counter2 = createCounter()
print("独立计数器:", counter2())

print("\n=== 6. 函数作为参数 ===")

function applyOperation(a, b, operation)
    return operation(a, b)
end

print("applyOperation(6, 3, add) =", applyOperation(6, 3, add))
print("applyOperation(6, 3, function(x, y) return x * y end) =",
    applyOperation(6, 3, function(x, y) return x * y end))

print("\n=== 7. 尾调用（Tail Call） ===")

-- 递归实现阶乘（尾递归优化）
function factorial(n, accumulator)
    accumulator = accumulator or 1
    if n <= 1 then
        return accumulator
    end
    return factorial(n - 1, n * accumulator)
end

print("factorial(5) =", factorial(5))
print("factorial(10) =", factorial(10))

print("\n=== 8. 局部函数（递归定义） ===")

-- 局部函数定义递归时，需要先声明再赋值
local fibonacci
fibonacci = function(n)
    if n <= 1 then
        return n
    end
    return fibonacci(n - 1) + fibonacci(n - 2)
end

for i = 0, 8 do
    io.write(fibonacci(i), " ")
end
print("（斐波那契数列）")
