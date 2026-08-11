-- =====================================================
-- 07-coroutines/coroutines.lua
-- Lua 协程（Coroutine）：协作式并发
-- =====================================================

print("\n=== 1. 创建协程 coroutine.create ===")

local co = coroutine.create(function()
    print("  协程开始执行")
    coroutine.yield("第一次挂起")     -- 挂起并返回值给 resume
    print("  协程恢复执行")
    coroutine.yield("第二次挂起")
    print("  协程结束")
    return "协程完成"
end)

print("协程状态:", coroutine.status(co))  -- suspended

-- resume 返回：是否成功 + yield/return 的值
local ok1, value1 = coroutine.resume(co)
print("第一次 resume:", ok1, value1, "状态:", coroutine.status(co))

local ok2, value2 = coroutine.resume(co)
print("第二次 resume:", ok2, value2, "状态:", coroutine.status(co))

local ok3, value3 = coroutine.resume(co)
print("第三次 resume:", ok3, value3, "状态:", coroutine.status(co))

-- 再次 resume 会失败
local ok4, err = coroutine.resume(co)
print("第四次 resume:", ok4, err)

print("\n=== 2. 协程间数据传递 ===")

local producer = coroutine.create(function()
    for i = 1, 3 do
        print("  [生产者] 生产商品 " .. i)
        coroutine.yield(i)  -- 把商品传给消费者
    end
    return "生产完毕"
end)

local ok, item = coroutine.resume(producer)
while ok and coroutine.status(producer) == "suspended" do
    print("[消费者] 收到商品 " .. item)
    ok, item = coroutine.resume(producer)
end
print("最终返回值:", item)

print("\n=== 3. 使用 wrap（更简单的创建方式） ===")

-- coroutine.wrap 返回一个可以直接调用的函数
local wrapped = coroutine.wrap(function()
    for i = 1, 3 do
        coroutine.yield(i * i)
    end
end)

for square in wrapped do
    print("平方:", square)
end

print("\n=== 4. 协程实现迭代器 ===")

-- 生成斐波那契序列的迭代器
function fibonacciIterator(limit)
    local co = coroutine.create(function()
        local a, b = 0, 1
        while a <= limit do
            coroutine.yield(a)
            a, b = b, a + b
        end
    end)
    return function()
        local ok, value = coroutine.resume(co)
        if ok and value then
            return value
        end
        return nil
    end
end

print("斐波那契（<= 100）:")
for n in fibonacciIterator(100) do
    io.write(n, " ")
end
print()

print("\n=== 5. 使用 coroutine 的暂停/恢复协作模型 ===")

-- 两个协程交替执行
local coroutine1 = coroutine.create(function()
    for i = 1, 3 do
        print("  协程A 第" .. i .. "次执行")
        coroutine.yield()
    end
end)

local coroutine2 = coroutine.create(function()
    for i = 1, 3 do
        print("  协程B 第" .. i .. "次执行")
        coroutine.yield()
    end
end)

for i = 1, 3 do
    coroutine.resume(coroutine1)
    coroutine.resume(coroutine2)
end

print("\n=== 6. 协程错误处理 ===")

local bad = coroutine.create(function()
    error("协程内部发生错误")
end)

-- resume 返回 false 和错误信息，不会导致主程序崩溃
local success, errMessage = coroutine.resume(bad)
print("resume 成功:", success)
print("错误信息:", errMessage)
print("协程状态:", coroutine.status(bad))
print("主程序继续正常运行")
