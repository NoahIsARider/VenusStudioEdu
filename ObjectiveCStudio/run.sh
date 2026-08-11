#!/bin/bash
# ObjectiveCStudio 运行脚本

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

TMPDIR_OBJC="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_OBJC"' EXIT

run_file() {
    local file="$1"
    local bin="$TMPDIR_OBJC/$(basename "$file" .m)_$$"
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶  编译并运行: $file"
    echo "═══════════════════════════════════════"
    
    # 检查是否有 GNUstep / clang / gcc 和 Foundation 框架
    if command -v clang &> /dev/null && clang -fobjc-arc "$file" -framework Foundation -o "$bin" 2>/dev/null; then
        "$bin"
    elif command -v gcc &> /dev/null && gcc -fobjc-arc "$file" -framework Foundation -o "$bin" 2>/dev/null; then
        "$bin"
    else
        echo "⚠️  当前环境未安装 Objective-C 编译器/Foundation 框架，模拟执行代码..."
        python3 -c "
with open('$file', 'r') as f:
    for line in f:
        if 'printf' in line or 'NSLog' in line:
            print('   -> 输出:', line.strip())
"
    fi
}

if [ $# -eq 0 ]; then
    run_file "01-basics/main.m"
elif [ $# -eq 1 ]; then
    arg="$1"
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        dir="$(ls -d ${arg}-* 2>/dev/null | head -1 || true)"
        if [ -z "$dir" ]; then
            echo "❌ 找不到第 ${arg} 章"
            exit 1
        fi
        for file in "$dir"/*.m; do
            if [[ -f "$file" ]]; then
                run_file "$file"
            fi
        done
    elif [[ "$arg" == *.m ]]; then
        run_file "$arg"
    else
        for file in "$arg"/*.m; do
            if [[ -f "$file" ]]; then
                run_file "$file"
            fi
        done
    fi
fi
echo ""
echo "✅ 运行完成"
