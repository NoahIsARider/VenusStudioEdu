-- =====================================================
-- 05-metatables/metatables.lua
-- Lua 元表（Metatable）与面向对象编程
-- =====================================================

-- 元表可以改变表的默认行为（如加法、索引、比较等）。

print("\n=== 1. __index：访问不存在的键 ===")

-- 定义基表
local Animal = { kind = "未知动物" }

-- 定义子表，并设置元表指向 Animal
local dog = setmetatable({ name = "旺财", sound = "汪汪" }, { __index = Animal })
local cat = setmetatable({ name = "咪咪", sound = "喵喵" }, { __index = Animal })

-- 子表自己的字段直接访问
print("dog.name:", dog.name)
-- 子表没有的字段通过 __index 向上查找
print("dog.kind:", dog.kind)
print("cat.kind:", cat.kind)

print("\n=== 2. 使用 __index 实现继承 ===")

-- 继承函数
function inherit(parent)
    local child = {}
    setmetatable(child, { __index = parent })
    return child
end

-- 父类
local Shape = { shapeName = "形状" }
function Shape:area()
    return 0
end
function Shape:describe()
    return "我是一个" .. self.shapeName
end

-- 子类 Rectangle
local Rectangle = inherit(Shape)
Rectangle.shapeName = "矩形"
function Rectangle:area()
    return self.width * self.height
end

local rect = inherit(Rectangle)
rect.width = 5
rect.height = 3
print(rect:describe())
print("矩形面积:", rect:area())

print("\n=== 3. __add：运算符重载 ===")

-- 向量类
local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    return setmetatable({ x = x, y = y }, Vector)
end

function Vector.__add(v1, v2)
    return Vector.new(v1.x + v2.x, v1.y + v2.y)
end

function Vector.__tostring(v)
    return "(" .. v.x .. ", " .. v.y .. ")"
end

function Vector.__eq(v1, v2)
    return v1.x == v2.x and v1.y == v2.y
end

local v1 = Vector.new(2, 3)
local v2 = Vector.new(4, 5)
local v3 = v1 + v2

print("v1:", tostring(v1))
print("v2:", tostring(v2))
print("v1 + v2:", tostring(v3))
print("v1 == v2:", v1 == v2)

-- 同时重载 __mul 和 __tostring
function Vector.__mul(v, scalar)
    return Vector.new(v.x * scalar, v.y * scalar)
end

local scaled = v1 * 3
print("v1 * 3:", tostring(scaled))

print("\n=== 4. __call：让表可以像函数一样调用 ===")

local Counter = {}
Counter.__index = Counter

-- 给 Counter 自身设置 __call 元方法，使 Counter 可以直接调用
local callable_mt = {
    __call = function(cls, initValue)
        return setmetatable({ count = initValue or 0 }, Counter)
    end
}
setmetatable(Counter, callable_mt)

function Counter:increment()
    self.count = self.count + 1
    return self.count
end

function Counter:value()
    return self.count
end

-- 直接调用 Counter（无需 .new）
local counter = Counter(100)
counter:increment()
counter:increment()
print("计数器值:", counter:value())

print("\n=== 5. __tostring：自定义输出 ===")

local Point = {}
Point.__index = Point

local point_mt = {
    __index = Point,
    __tostring = function(p)
        return string.format("Point(%d, %d)", p.x, p.y)
    end
}

function Point.new(x, y)
    return setmetatable({ x = x, y = y }, point_mt)
end

local p1 = Point.new(3, 4)
print("自定义 __tostring:", tostring(p1))

print("\n=== 6. __metatable：保护元表 ===")

local Protected = setmetatable({ secret = "机密数据" }, {
    __metatable = "locked"
})

-- 无法通过 getmetatable 获取真实元表
print("getmetatable 结果:", getmetatable(Protected))
-- 无法修改元表
local success = pcall(function()
    setmetatable(Protected, {})
end)
print("尝试修改受保护元表:", success and "成功" or "被阻止")

print("\n=== 7. __newindex：拦截新键赋值 ===")

local tracked = {}
local tracked_mt = {
    __newindex = function(t, key, value)
        rawset(t, key, value)  -- 真正写入
        print("  拦截赋值: " .. key .. " = " .. tostring(value))
    end
}
setmetatable(tracked, tracked_mt)

tracked.name = "被跟踪的字段"
tracked.score = 95
print("tracked.name:", tracked.name)
