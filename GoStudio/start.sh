#!/bin/bash

# GoStudio 快速开始脚本

clear

echo "╔════════════════════════════════════════════════════╗"
echo "║                                                    ║"
echo "║          🚀 欢迎使用 GoStudio 学习项目！          ║"
echo "║                                                    ║"
echo "║     这是一个完整的 Go 语言学习教程项目             ║"
echo "║     包含 22+ 个核心概念和 24 个实战示例            ║"
echo "║                                                    ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# 检查 Go 是否安装
echo "🔍 检查环境..."
if ! command -v go &> /dev/null; then
    echo "❌ Go 未安装！请先安装 Go (https://golang.org/dl/)"
    exit 1
fi

GO_VERSION=$(go version)
echo "✅ Go 已安装: $GO_VERSION"
echo ""

# 显示项目结构
echo "📁 项目结构："
echo ""
cat << 'EOF'
GoStudio/
├── 01-basics/           # 基础语法（变量、类型、运算符）
├── 02-control/          # 控制流（条件、循环、switch）
├── 03-functions/        # 函数（基础、高级、闭包）
├── 04-data-structures/  # 数据结构（数组、切片、映射、结构体）
├── 05-methods/          # 方法和接口
├── 06-concurrency/      # 并发编程（goroutines、channels、select）
├── 07-errors/           # 错误处理（errors、panic）
├── 09-advanced/         # 高级特性（指针、泛型）
├── main.go              # 交互式主程序
├── run.sh               # 运行脚本
├── README.md            # 项目说明
├── LEARNING_GUIDE.md    # 学习指南
└── TEST_CHECKLIST.md    # 测试清单
EOF
echo ""

# 显示快速开始选项
echo "🎯 快速开始选项："
echo ""
echo "1️⃣  运行交互式主程序"
echo "   go run main.go"
echo ""
echo "2️⃣  运行特定模块"
echo "   ./run.sh basics        # 基础语法"
echo "   ./run.sh control       # 控制流"
echo "   ./run.sh functions     # 函数"
echo "   ./run.sh data          # 数据结构"
echo "   ./run.sh methods       # 方法和接口"
echo "   ./run.sh concurrency   # 并发编程"
echo "   ./run.sh errors        # 错误处理"
echo "   ./run.sh advanced      # 高级特性"
echo ""
echo "3️⃣  运行单个示例"
echo "   go run 01-basics/variables.go"
echo "   go run 06-concurrency/channels.go"
echo ""
echo "4️⃣  运行所有示例"
echo "   ./run.sh all"
echo ""

# 询问用户想做什么
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "👉 你想如何开始？(1-4, 或按 Enter 查看第一个示例): " choice
echo ""

case $choice in
    1)
        echo "🚀 启动交互式主程序..."
        go run main.go
        ;;
    2)
        echo "📚 请运行: ./run.sh [模块名]"
        echo "   例如: ./run.sh basics"
        ;;
    3)
        echo "📝 请运行: go run [文件路径]"
        echo "   例如: go run 01-basics/variables.go"
        ;;
    4)
        echo "🎬 运行所有示例..."
        ./run.sh all
        ;;
    *)
        echo "🎓 运行第一个示例：变量和常量"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        go run 01-basics/variables.go
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "💡 提示："
        echo "   - 继续学习：go run 01-basics/types.go"
        echo "   - 查看完整指南：cat LEARNING_GUIDE.md"
        echo "   - 使用交互式程序：go run main.go"
        ;;
esac

echo ""
echo "📖 更多信息："
echo "   - 学习指南: cat LEARNING_GUIDE.md"
echo "   - 测试清单: cat TEST_CHECKLIST.md"
echo "   - 项目说明: cat README.md"
echo ""
echo "🎉 祝你学习愉快！有问题欢迎查看文档。"
echo ""
