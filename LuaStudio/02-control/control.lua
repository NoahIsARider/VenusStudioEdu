-- =====================================================
-- 02-control/control.lua
-- Lua 控制流：if、while、repeat、for、break、goto
-- =====================================================

function DemoControl()
    print("\n=== 1. if / elseif / else ===")

    local score = 85
    if score >= 90 then
        print("成绩等级: A")
    elseif score >= 80 then
        print("成绩等级: B")
    elseif score >= 60 then
        print("成绩等级: C")
    else
        print("成绩等级: D")
    end

    -- 单行条件（Lua 使用三目运算符的等价写法）
    local age = 18
    local status = age >= 18 and "成年" or "未成年"
    print("年龄", age, ":", status)

    print("\n=== 2. while 循环 ===")

    local i = 1
    while i <= 5 do
        io.write(i, " ")
        i = i + 1
    end
    print()

    print("\n=== 3. repeat...until 循环（至少执行一次） ===")

    local count = 10
    repeat
        io.write(count, " ")
        count = count - 1
    until count < 7
    print()

    print("\n=== 4. 数值型 for 循环 ===")

    -- for 变量 = 起始值, 结束值[, 步长] do ... end
    for j = 1, 5 do
        io.write(j, " ")
    end
    print()

    -- 指定步长
    for j = 10, 1, -2 do
        io.write(j, " ")
    end
    print()

    print("\n=== 5. 泛型 for 循环（遍历表） ===")

    -- ipairs 遍历数组部分
    local fruits = { "苹果", "香蕉", "橙子" }
    print("ipairs 遍历数组:")
    for index, value in ipairs(fruits) do
        print("  fruits[" .. index .. "] = " .. value)
    end

    -- pairs 遍历所有键值对
    local config = { name = "Lua", version = 5.4, open = true }
    print("pairs 遍历键值对:")
    for key, value in pairs(config) do
        print("  " .. key .. " = " .. tostring(value))
    end

    print("\n=== 6. break 和 goto ===")

    -- break 跳出循环
    for n = 1, 10 do
        if n == 4 then
            break
        end
        io.write(n, " ")
    end
    print("（n=4 时 break）")

    -- goto 跳转（Lua 5.2+）
    local x = 1
    ::check::
    x = x + 1
    if x < 4 then
        goto check
    end
    print("goto 跳转后 x =", x)

    print("\n=== 7. 嵌套循环与 continue 模拟 ===")

    -- Lua 5.4 没有 continue，可以用 goto 或条件模拟
    for row = 1, 3 do
        for col = 1, 3 do
            if row == col then
                -- 模拟 continue：跳过对角线
                goto continue
            end
            io.write(row .. "," .. col .. "  ")
        end
        ::continue::
    end
    print()
end

DemoControl()
