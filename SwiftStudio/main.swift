// =====================================================
// main.swift
// SwiftStudio 主程序入口，打印欢迎横幅和章节列表
// =====================================================

import Foundation

print("╔════════════════════════════════════════╗")
print("║     欢迎来到 SwiftStudio 学习项目！     ║")
print("║     Swift 语言完整学习教程              ║")
print("╚════════════════════════════════════════╝")

let chapters: [(String, String)] = [
    ("01. 基础语法", "01-basics/variables.swift"),
    ("02. 控制流", "02-control/control.swift"),
    ("03. 函数", "03-functions/functions.swift"),
    ("04. 集合类型", "04-collections/collections.swift"),
    ("05. 可选类型", "05-optionals/optionals.swift"),
    ("06. 协议", "06-protocols/protocols.swift"),
    ("07. 错误处理", "07-error-handling/errors.swift")
]

print("\n================= 教程章节 =================")
for (title, path) in chapters {
    print("\(title) -> \(path)")
}
print("===========================================")

print("\n📌 说明：Swift 没有类似 Lua 的 dofile，每个章节文件都是独立脚本。")
print("📌 请使用 bash run.sh 依次运行各章节，或运行指定章节：")
print("   bash run.sh 01      # 运行第 1 章")
print("   bash run.sh          # 运行所有章节")
print("   swift main.swift     # 仅打印本横幅和章节列表")

print("\n╔════════════════════════════════════════╗")
print("║   请使用 bash run.sh 开始运行各章节演示  ║")
print("╚════════════════════════════════════════╝")
