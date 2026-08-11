#!/bin/bash
# ErlangStudio 运行脚本
# 用法:
#   ./run.sh            运行所有章节
#   ./run.sh 01         运行第 1 章
#   ./run.sh file.escript 运行指定文件

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

run_file() {
    local file="$1"
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶  运行: $file"
    echo "═══════════════════════════════════════"
    escript "$file"
}

if [ $# -eq 0 ]; then
    for file in $(find . -name '*.escript' -not -path './main*' | sort); do
        run_file "$file"
    done
elif [ $# -eq 1 ]; then
    arg="$1"
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        dir="$(ls -d ${arg}-* 2>/dev/null | head -1 || true)"
        if [ -z "$dir" ]; then
            echo "❌ 找不到第 ${arg} 章，可用章节:"
            ls -d [0-9]*-* | sed 's/^/   /'
            exit 1
        fi
        for file in "$dir"/*.escript; do
            run_file "$file"
        done
    elif [[ "$arg" == *.escript ]]; then
        if [ ! -f "$arg" ]; then
            echo "❌ 文件不存在: $arg"
            exit 1
        fi
        run_file "$arg"
    else
        if [ ! -d "$arg" ]; then
            echo "❌ 目录不存在: $arg"
            exit 1
        fi
        for file in "$arg"/*.escript; do
            run_file "$file"
        done
    fi
fi

echo ""
echo "✅ 运行完成"
