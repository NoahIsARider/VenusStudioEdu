#!/bin/bash

# 测试所有示例

set -e

echo "=========================================="
echo "  DockerStudio 全面测试"
echo "=========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

test_count=0
pass_count=0
fail_count=0

# 测试函数
run_test() {
    local chapter=$1
    local test_name=$2
    local test_cmd=$3
    
    echo ""
    echo "📝 测试: $chapter - $test_name"
    ((test_count++))
    
    if eval "$test_cmd"; then
        echo "  ✅ 通过"
        ((pass_count++))
    else
        echo "  ❌ 失败"
        ((fail_count++))
    fi
}

# 第1章：基础测试
echo ""
echo "=== 第1章：Docker 基础 ==="
run_test "01-basics" "Hello World" \
    "docker run --rm hello-world"

run_test "01-basics" "Alpine 测试" \
    "docker run --rm alpine echo 'Alpine works'"

# 第2章：镜像测试
echo ""
echo "=== 第2章：镜像管理 ==="
if [ -f "$PROJECT_ROOT/02-images/custom-image/Dockerfile" ]; then
    run_test "02-images" "构建自定义镜像" \
        "cd $PROJECT_ROOT/02-images/custom-image && docker build -t test-custom:v1 . && docker rmi test-custom:v1"
fi

# 第3章：容器测试
echo ""
echo "=== 第3章：容器操作 ==="
run_test "03-containers" "容器生命周期" \
    "docker run -d --name test-nginx nginx:alpine && docker stop test-nginx && docker rm test-nginx"

run_test "03-containers" "资源限制" \
    "docker run --rm --memory 256m --cpus 0.5 alpine echo 'Resource limits work'"

# 第4章：网络测试
echo ""
echo "=== 第4章：Docker 网络 ==="
run_test "04-network" "创建网络" \
    "docker network create test-net && docker network rm test-net"

run_test "04-network" "容器通信" \
    "docker network create test-net && \
     docker run -d --name c1 --network test-net alpine sleep 10 && \
     docker run --rm --network test-net alpine ping -c 2 c1 && \
     docker rm -f c1 && \
     docker network rm test-net"

# 第5章：数据持久化测试
echo ""
echo "=== 第5章：数据持久化 ==="
run_test "05-volumes" "卷操作" \
    "docker volume create test-vol && \
     docker run --rm -v test-vol:/data alpine sh -c 'echo test > /data/test.txt' && \
     docker run --rm -v test-vol:/data alpine cat /data/test.txt && \
     docker volume rm test-vol"

# 第6章：Docker Compose 测试
echo ""
echo "=== 第6章：Docker Compose ==="
if [ -f "$PROJECT_ROOT/06-compose/examples/simple/docker-compose.yml" ]; then
    run_test "06-compose" "Compose 启动" \
        "cd $PROJECT_ROOT/06-compose/examples/simple && \
         docker compose up -d && \
         docker compose ps && \
         docker compose down"
fi

# 输出总结
echo ""
echo "=========================================="
echo "  测试总结"
echo "=========================================="
echo "总测试数: $test_count"
echo "通过: $pass_count"
echo "失败: $fail_count"
echo ""

if [ $fail_count -eq 0 ]; then
    echo "🎉 所有测试通过！"
    exit 0
else
    echo "⚠️  有测试失败，请检查"
    exit 1
fi
