#!/bin/bash
# RubyStudio 运行脚本

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

run_file() {
    local file="$1"
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶  运行: $file"
    echo "═══════════════════════════════════════"
    if command -v ruby &> /dev/null; then
        ruby "$file"
    else
        echo "⚠️  未检测到 ruby 运行时，使用 Python 模拟输出..."
        python3 -c "
with open('$file', 'r') as f:
    for line in f:
        if 'puts' in line or 'print' in line or '=== ' in line:
            print('   -> 输出:', line.strip())
"
    fi
}

if [ $# -eq 0 ]; then
    if command -v ruby &> /dev/null; then
        ruby main.rb
    else
        echo "⚠️  未检测到 ruby 运行时，使用 Python 模拟运行..."
        python3 -c "
with open('main.rb', 'r') as f:
    for line in f:
        if 'puts' in line or 'print' in line or '=== ' in line:
            print('   -> 输出:', line.strip())
"
    fi
elif [ $# -eq 1 ]; then
    arg="$1"
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        dir="$(ls -d ${arg}-* 2>/dev/null | head -1 || true)"
        if [ -z "$dir" ]; then
            echo "❌ 找不到第 ${arg} 章"
            exit 1
        fi
        for file in "$dir"/*.rb; do
            run_file "$file"
        done
    elif [[ "$arg" == *.rb ]]; then
        run_file "$arg"
    else
        for file in "$arg"/*.rb; do
            run_file "$file"
        done
    fi
fi
echo ""
echo "✅ 运行完成"
