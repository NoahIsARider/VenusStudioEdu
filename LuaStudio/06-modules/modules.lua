-- =====================================================
-- 06-modules/modules.lua
-- Lua 模块使用：require 与模块加载
-- =====================================================

print("\n=== 1. require 加载模块 ===")

-- 将当前脚本所在目录加入模块搜索路径
local source = debug.getinfo(1, "S").source:sub(2)  -- 去掉 @ 前缀
local script_dir = source:match("^(.*)[/\\][^/\\]+$") or "."
package.path = script_dir .. "/?.lua;" .. package.path

-- 使用相对模块路径（基于 package.path）
local mymath = require("mymath")

print("mymath.PI:", mymath.PI)
print("mymath.add(10, 5):", mymath.add(10, 5))
print("mymath.subtract(10, 5):", mymath.subtract(10, 5))
print("mymath.multiply(4, 3):", mymath.multiply(4, 3))
print("mymath.divide(10, 4):", mymath.divide(10, 4))
print("圆的面积 r=5:", string.format("%.2f", mymath.circleArea(5)))
print("mymath.factorial(5):", mymath.factorial(5))
print("mymath.fibonacci(10):", mymath.fibonacci(10))

print("\n=== 2. 私有函数只能通过接口访问 ===")

print("通过接口访问私有函数:", mymath.getSecretMessage())
-- 直接访问 mymath.secretHelper 会得到 nil
print("secretHelper 是否暴露:", tostring(mymath.secretHelper))

print("\n=== 3. require 只会加载一次（缓存） ===")

local mymath_again = require("mymath")
print("重复 require 返回同一个表:", mymath == mymath_again)

print("\n=== 4. 检查 package.path ===")

print("package.path 内容（部分）:")
for path in string.gmatch(package.path, "([^;]+)") do
    print("  " .. path)
end

print("\n=== 5. 使用内置模块 ===")

-- string 模块
local text = "Lua Programming"
print("字符串大写:", string.upper(text))
print("字符串查找 'Prog':", string.find(text, "Prog"))
print("字符串替换:", string.gsub(text, "Programming", "教程"))

-- math 模块
print("math.floor(3.7):", math.floor(3.7))
print("math.ceil(3.2):", math.ceil(3.2))
print("math.abs(-42):", math.abs(-42))
print("math.max(1,5,9,3):", math.max(1, 5, 9, 3))
print("math.random(1, 100):", math.random(1, 100))

-- table 模块
local list = { 3, 1, 4, 1, 5 }
table.sort(list)
print("table.concat 排序后:", table.concat(list, "-"))

-- os 模块
print("当前时间:", os.date("%Y-%m-%d %H:%M:%S"))

print("\n=== 6. 自定义路径加载 ===")

-- 演示临时添加模块搜索路径
local M2 = {}
function M2.hello()
    return "来自动态添加路径的模块"
end

-- 将模块写入 package.preload
package.preload["dynamic_module"] = function()
    return M2
end

local dynamic = require("dynamic_module")
print(dynamic.hello())
