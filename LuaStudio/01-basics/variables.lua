-- =====================================================
-- 01-basics/variables.lua
-- Lua 变量和数据类型基础
-- =====================================================

-- Lua 是一种动态类型语言，变量不需要声明类型。
-- 使用 local 声明局部变量（推荐），不使用 local 则是全局变量。

function DemoVariables()
    print("\n=== 1. 变量声明 ===")

    -- 1. 简单赋值（全局变量）
    name = "LuaStudio"
    print("全局变量: name =", name)

    -- 2. 局部变量
    local version = "5.4"
    print("局部变量: version =", version)

    -- 3. 多重赋值（同时赋值多个变量）
    local a, b, c = 1, 2, 3
    print("多重赋值: a =", a, ", b =", b, ", c =", c)

    -- 4. 变量交换（Lua 特性，无需临时变量）
    a, b = b, a
    print("交换后: a =", a, ", b =", b)

    -- 5. 未初始化的变量值为 nil
    local nothing
    print("未初始化变量: ", nothing, "（nil）")

    print("\n=== 2. 数据类型 ===")

    -- 8 种基本类型
    local integer = 42          -- number（整数）
    local float = 3.14159       -- number（浮点数）
    local text = "你好，Lua！"   -- string
    local boolean = true        -- boolean
    local empty = nil           -- nil
    local func = function() end -- function

    print("整数:", integer, "类型:", type(integer))
    print("浮点:", float, "类型:", type(float))
    print("字符串:", text, "类型:", type(text))
    print("布尔:", boolean, "类型:", type(boolean))
    print("nil:", empty, "类型:", type(empty))
    print("函数:", func, "类型:", type(func))

    -- table 类型（Lua 唯一的数据结构）
    local t = { 1, 2, 3 }
    print("表:", t, "类型:", type(t))

    print("\n=== 3. 运算符 ===")

    -- 算术运算符
    print("加法 10 + 3 =", 10 + 3)
    print("减法 10 - 3 =", 10 - 3)
    print("乘法 10 * 3 =", 10 * 3)
    print("除法 10 / 3 =", 10 / 3)      -- Lua 5.3+ 浮点除法
    print("整除 10 // 3 =", 10 // 3)     -- Lua 5.3+ 地板除法
    print("取模 10 % 3 =", 10 % 3)
    print("幂 10 ^ 2 =", 10 ^ 2)
    print("取负 -10 =", -10)

    -- 关系运算符
    print("\n关系运算符:")
    print("10 > 3:", 10 > 3)
    print("10 < 3:", 10 < 3)
    print("10 == 3:", 10 == 3)
    print("10 ~= 3:", 10 ~= 3)           -- Lua 的不等于

    -- 逻辑运算符（and / or / not）
    print("\n逻辑运算符:")
    print("true and false:", true and false)
    print("true or false:", true or false)
    print("not true:", not true)
    -- and/or 短路求值：x and y 若 x 为假返回 x，否则返回 y
    print("1 and 2:", 1 and 2)
    -- or 常用于设置默认值
    local value = nil or "默认值"
    print("nil or 默认值:", value)

    -- 字符串连接（..）
    print("\n字符串连接:")
    local greeting = "Hello" .. " " .. "Lua"
    print(greeting)

    -- 字符串重复
    print("重复: ", string.rep("-", 10))

    print("\n=== 4. 类型转换 ===")

    -- 数字转字符串
    local num = 123
    print("数字转字符串:", tostring(num), "类型:", type(tostring(num)))

    -- 字符串转数字
    local str = "456"
    print("字符串转数字:", tonumber(str), "类型:", type(tonumber(str)))

    -- 字符串数字混合运算会尝试转换
    print("\"10\" + 5 =", "10" + 5)

    print("\n=== 5. 常量（使用不可变约定） ===")
    -- Lua 没有内置 const，通常用全大写命名约定
    local MAX_SIZE = 100
    local PI = 3.1415926
    print("约定常量: MAX_SIZE =", MAX_SIZE, ", PI =", PI)
end

DemoVariables()
