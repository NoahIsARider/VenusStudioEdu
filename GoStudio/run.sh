#!/bin/bash

# GoStudio 运行脚本
# 用法: ./run.sh [模块名]

echo "╔════════════════════════════════════════╗"
echo "║       GoStudio - Go 学习项目          ║"
echo "╚════════════════════════════════════════╝"
echo ""

# 如果没有参数，显示帮助
if [ $# -eq 0 ]; then
    echo "用法: ./run.sh [选项]"
    echo ""
    echo "选项:"
    echo "  all           - 运行所有示例"
    echo "  basics        - 运行基础语法示例"
    echo "  control       - 运行控制流示例"
    echo "  functions     - 运行函数示例"
    echo "  data          - 运行数据结构示例"
    echo "  methods       - 运行方法和接口示例"
    echo "  concurrency   - 运行并发编程示例"
    echo "  errors        - 运行错误处理示例"
    echo "  advanced      - 运行高级特性示例"
    echo ""
    echo "或者直接运行特定文件:"
    echo "  ./run.sh 01-basics/variables"
    echo ""
    exit 0
fi

case "$1" in
    "all")
        echo "🚀 运行所有示例..."
        echo ""
        for dir in 01-basics 02-control 03-functions 04-data-structures 05-methods 06-concurrency 07-errors 09-advanced; do
            for file in $dir/*.go; do
                if [ -f "$file" ]; then
                    echo "▶️  运行: $file"
                    go run "$file"
                    echo ""
                fi
            done
        done
        ;;
    "basics")
        echo "🔤 运行基础语法示例..."
        go run 01-basics/variables.go
        go run 01-basics/types.go
        go run 01-basics/operators.go
        ;;
    "control")
        echo "🔀 运行控制流示例..."
        go run 02-control/conditions.go
        go run 02-control/loops.go
        go run 02-control/switch.go
        ;;
    "functions")
        echo "⚙️  运行函数示例..."
        go run 03-functions/basic.go
        go run 03-functions/advanced.go
        go run 03-functions/closures.go
        ;;
    "data")
        echo "📦 运行数据结构示例..."
        go run 04-data-structures/arrays.go
        go run 04-data-structures/slices.go
        go run 04-data-structures/maps.go
        go run 04-data-structures/structs.go
        ;;
    "methods")
        echo "🎯 运行方法和接口示例..."
        go run 05-methods/methods.go
        go run 05-methods/interfaces.go
        ;;
    "concurrency")
        echo "🔄 运行并发编程示例..."
        go run 06-concurrency/goroutines.go
        go run 06-concurrency/channels.go
        go run 06-concurrency/select.go
        ;;
    "errors")
        echo "⚠️  运行错误处理示例..."
        go run 07-errors/errors.go
        go run 07-errors/panic.go
        ;;
    "advanced")
        echo "🚀 运行高级特性示例..."
        go run 09-advanced/pointers.go
        go run 09-advanced/generics.go
        ;;
    *)
        # 尝试作为文件路径运行
        if [ -f "$1.go" ]; then
            echo "▶️  运行: $1.go"
            go run "$1.go"
        else
            echo "❌ 未知选项: $1"
            echo "使用 ./run.sh 查看帮助"
            exit 1
        fi
        ;;
esac

echo ""
echo "✅ 完成！"
