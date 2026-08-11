#!/bin/bash
# LispStudio 运行脚本

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

run_file() {
    local file="$1"
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶  运行: $file"
    echo "═══════════════════════════════════════"
    if command -v sbcl &> /dev/null; then
        sbcl --script "$file"
    elif command -v clisp &> /dev/null; then
        clisp "$file"
    elif command -v guile &> /dev/null; then
        guile --r6rs -s "$file"
    else
        echo "⚠️  未检测到 Lisp 解释器 (sbcl/clisp/guile)，使用 Python 模拟运行..."
        python3 -c "
with open('$file', 'r') as f:
    for line in f:
        if 'format' in line or 'display' in line or 'println' in line or '=== ' in line:
            print('   ->', line.strip())
"
    fi
}

if [ $# -eq 0 ]; then
    run_file "main.lisp"
elif [ $# -eq 1 ]; then
    arg="$1"
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        dir="$(ls -d ${arg}-* 2>/dev/null | head -1 || true)"
        if [ -z "$dir" ]; then
            echo "❌ 找不到第 ${arg} 章"
            exit 1
        fi
        for file in "$dir"/*; do
            if [[ -f "$file" ]]; then
                run_file "$file"
            fi
        done
    else
        run_file "$arg"
    fi
fi
echo ""
echo "✅ 运行完成"
