#!/bin/bash
# FortranStudio 运行脚本
# 用法:
#   ./run.sh            运行所有章节
#   ./run.sh 01         运行第 1 章
#   ./run.sh 02-basics  运行指定章节目录下的所有示例
#   ./run.sh file.f90   运行指定文件

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 临时目录用于存放编译后的可执行文件
TMPDIR_F90="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_F90"' EXIT

run_file() {
    local file="$1"
    local bin="$TMPDIR_F90/$(basename "$file" .f90)_$$"
    echo ""
    echo "═══════════════════════════════════════"
    echo "▶  编译并运行: $file"
    echo "═══════════════════════════════════════"
    if gfortran "$file" -o "$bin" 2>&1; then
        "$bin"
    else
        echo "❌ 编译失败: $file"
        return 1
    fi
}

if [ $# -eq 0 ]; then
    # 运行全部章节（编译运行 main.f90）
    bin="$TMPDIR_F90/main_$$"
    gfortran main.f90 -o "$bin" && "$bin"
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
        for file in "$dir"/*.f90; do
            run_file "$file"
        done
    elif [[ "$arg" == *.f90 ]]; then
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
        for file in "$arg"/*.f90; do
            run_file "$file"
        done
    fi
fi

echo ""
echo "✅ 运行完成"
