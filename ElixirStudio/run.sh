#!/bin/bash
# ElixirStudio 运行脚本

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

run_file() {
    local file="$1"
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶  运行: $file"
    echo "═══════════════════════════════════════"
    if command -v elixir &> /dev/null; then
        elixir "$file"
    else
        echo "⚠️  未检测到 Elixir 运行时，使用 Python 模拟输出..."
        python3 -c "print('Simulating Elixir execution for $file')"
    fi
}

if [ $# -eq 0 ]; then
    run_file "main.ex"
elif [ $# -eq 1 ]; then
    arg="$1"
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        dir="$(ls -d ${arg}-* 2>/dev/null | head -1 || true)"
        if [ -z "$dir" ]; then
            echo "❌ 找不到第 ${arg} 章"
            exit 1
        fi
        for file in "$dir"/*.ex; do
            run_file "$file"
        done
    elif [[ "$arg" == *.ex ]]; then
        run_file "$arg"
    else
        for file in "$arg"/*.ex; do
            run_file "$file"
        done
    fi
fi
echo ""
echo "✅ 运行完成"
