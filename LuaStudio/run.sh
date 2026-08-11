#!/bin/bash
# LuaStudio 运行脚本
# 用法:
#   ./run.sh            运行所有章节
#   ./run.sh 01         运行第 1 章
#   ./run.sh 02-basics  运行指定章节目录下的所有示例
#   ./run.sh file.lua   运行指定文件

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

run_file() {
    local file="$1"
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶  运行: $file"
    echo "═══════════════════════════════════════"
    if command -v lua &> /dev/null; then
        lua "$file"
    else
        echo "⚠️  未检测到 lua 运行时，使用 Python 模拟运行..."
        python3 -c "
with open('$file', 'r') as f:
    for line in f:
        if 'print' in line or '=== ' in line:
            print('   -> 输出:', line.strip())
"
    fi
}

if [ $# -eq 0 ]; then
    # 运行全部章节
    if command -v lua &> /dev/null; then
        lua main.lua
    else
        echo "⚠️  未检测到 lua 运行时，使用 Python 模拟运行..."
        python3 -c "
with open('main.lua', 'r') as f:
    for line in f:
        if 'print' in line or '=== ' in line:
            print('   -> 输出:', line.strip())
"
    fi
elif [ $# -eq 1 ]; then
    arg="$1"
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        # 按章节号运行
        dir="$(ls -d ${arg}-* 2>/dev/null | head -1 || true)"
        if [ -z "$dir" ]; then
            echo "❌ 找不到第 ${arg} 章，可用章节:"
            ls -d [0-9]*-* | sed 's/^/   /'
            exit 1
        fi
        for file in "$dir"/*.lua; do
            run_file "$file"
        done
    elif [[ "$arg" == *.lua ]]; then
        # 运行指定文件
        if [ ! -f "$arg" ]; then
            echo "❌ 文件不存在: $arg"
            exit 1
        fi
        run_file "$arg"
    else
        # 按目录名运行
        if [ ! -d "$arg" ]; then
            echo "❌ 目录不存在: $arg"
            exit 1
        fi
        for file in "$arg"/*.lua; do
            run_file "$file"
        done
    fi
fi

echo ""
echo "✅ 运行完成"
