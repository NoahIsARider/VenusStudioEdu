#!/bin/bash

# Docker 环境清理脚本

set -e

echo "=========================================="
echo "  DockerStudio 环境清理"
echo "=========================================="

read -p "确定要清理所有 Docker 资源吗？(y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "取消清理"
    exit 0
fi

echo ""
echo "🧹 开始清理..."

# 停止所有容器
echo "  停止所有容器..."
docker stop $(docker ps -aq) 2>/dev/null || echo "    没有运行的容器"

# 删除所有容器
echo "  删除所有容器..."
docker rm $(docker ps -aq) 2>/dev/null || echo "    没有容器需要删除"

# 删除未使用的镜像
echo "  删除未使用的镜像..."
docker image prune -af

# 删除未使用的卷
echo "  删除未使用的卷..."
docker volume prune -f

# 删除未使用的网络
echo "  删除未使用的网络..."
docker network prune -f

# 清理构建缓存
echo "  清理构建缓存..."
docker builder prune -af

# 显示清理后的状态
echo ""
echo "=========================================="
echo "✅ 清理完成"
echo "=========================================="
echo ""
echo "剩余资源："
echo ""
echo "镜像："
docker images
echo ""
echo "容器："
docker ps -a
echo ""
echo "卷："
docker volume ls
echo ""
echo "网络："
docker network ls
echo ""
