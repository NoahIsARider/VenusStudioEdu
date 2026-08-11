#!/bin/bash
# ScalaStudio 运行脚本

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

run_file() {
    local file="$1"
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶  运行: $file"
    echo "═══════════════════════════════════════"
    if command -v scala &> /dev/null; then
        scala "$file"
    elif command -v scala-cli &> /dev/null; then
        scala-cli run "$file"
    else
        echo "⚠️  未检测到 Scala 运行时，使用 Node/Python 模拟或直接展示源码执行效果..."
        # 兜底：如果没安装 scala，打印文件并用 python 执行简易解析输出模拟
        python3 -c "
import glob, os
print('正在读取并执行 Scala 示例文件:', '$file')
with open('$file', 'r') as f:
    code = f.read()
# 简单提取println并打印模拟输出
import re
for m in re.findall(r'println\((.*?)\)', code):
    print('   -> 输出:', m.strip('\"').strip('\'').replace('s\"', '').replace('s\\\"', ''))
"
    fi
}

if [ $# -eq 0 ]; then
    run_file "main.scala"
elif [ $# -eq 1 ]; then
    arg="$1"
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        dir="$(ls -d ${arg}-* 2>/dev/null | head -1 || true)"
        if [ -z "$dir" ]; then
            echo "❌ 找不到第 ${arg} 章"
            exit 1
        fi
        for file in "$dir"/*.scala; do
            run_file "$file"
        done
    elif [[ "$arg" == *.scala ]]; then
        run_file "$arg"
    else
        for file in "$arg"/*.scala; do
            run_file "$file"
        done
    fi
fi
echo ""
echo "✅ 运行完成"
