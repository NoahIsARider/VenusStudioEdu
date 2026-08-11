-- =====================================================
-- main.lua
-- LuaStudio 主程序入口，依次演示所有章节内容
-- =====================================================

print("╔════════════════════════════════════════╗")
print("║     欢迎来到 LuaStudio 学习项目！       ║")
print("║     Lua 语言完整学习教程                ║")
print("╚════════════════════════════════════════╝")

local chapters = {
    { "01. 基础语法", "01-basics/variables.lua" },
    { "02. 控制流", "02-control/control.lua" },
    { "03. 函数", "03-functions/functions.lua" },
    { "04. 表（数据结构）", "04-tables/tables.lua" },
    { "05. 元表与面向对象", "05-metatables/metatables.lua" },
    { "06. 模块", "06-modules/modules.lua" },
    { "07. 协程", "07-coroutines/coroutines.lua" }
}

print("\n================= 教程章节 =================")
for _, chapter in ipairs(chapters) do
    print(chapter[1] .. " -> " .. chapter[2])
end
print("===========================================")

print("\n>>> 开始运行第 1 章：基础语法")
dofile("01-basics/variables.lua")

print("\n>>> 开始运行第 2 章：控制流")
dofile("02-control/control.lua")

print("\n>>> 开始运行第 3 章：函数")
dofile("03-functions/functions.lua")

print("\n>>> 开始运行第 4 章：表（数据结构）")
dofile("04-tables/tables.lua")

print("\n>>> 开始运行第 5 章：元表与面向对象")
dofile("05-metatables/metatables.lua")

print("\n>>> 开始运行第 6 章：模块")
dofile("06-modules/modules.lua")

print("\n>>> 开始运行第 7 章：协程")
dofile("07-coroutines/coroutines.lua")

print("\n╔════════════════════════════════════════╗")
print("║     LuaStudio 全部章节演示完成！       ║")
print("╚════════════════════════════════════════╝")
