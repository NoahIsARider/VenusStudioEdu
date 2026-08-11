-- =====================================================
-- 06-modules/mymath.lua
-- Lua 模块定义（被 modules.lua 引用）
-- =====================================================

-- Lua 模块就是一个 table，包含若干函数和常量。
-- 使用 return table 将内容暴露出去。

local M = {}

-- 常量
M.PI = 3.14159265
M.E = 2.71828

-- 工具函数
function M.add(a, b)
    return a + b
end

function M.subtract(a, b)
    return a - b
end

function M.multiply(a, b)
    return a * b
end

function M.divide(a, b)
    if b == 0 then
        error("除数不能为零")
    end
    return a / b
end

-- 圆的面积
function M.circleArea(radius)
    return M.PI * radius * radius
end

-- 阶乘
function M.factorial(n)
    if n < 0 then
        error("负数没有阶乘")
    end
    local result = 1
    for i = 2, n do
        result = result * i
    end
    return result
end

-- 斐波那契
function M.fibonacci(n)
    if n <= 1 then
        return n
    end
    return M.fibonacci(n - 1) + M.fibonacci(n - 2)
end

-- 模块私有函数（不导出）
local function secretHelper()
    return "这是模块内部私有函数"
end

-- 通过导出的接口暴露私有能力
function M.getSecretMessage()
    return secretHelper()
end

return M
