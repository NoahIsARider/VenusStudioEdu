#!/bin/bash

# Docker 环境设置脚本

set -e

echo "=========================================="
echo "  DockerStudio 环境设置"
echo "=========================================="

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装"
    echo "请访问 https://docs.docker.com/get-docker/ 安装 Docker"
    exit 1
fi

echo "✅ Docker 版本: $(docker --version)"

# 检查 Docker Compose
if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose 未安装"
    exit 1
fi

echo "✅ Docker Compose 版本: $(docker compose version)"

# 检查 Docker 服务状态
if ! docker info &> /dev/null; then
    echo "❌ Docker 服务未运行"
    echo "请启动 Docker 服务"
    exit 1
fi

echo "✅ Docker 服务运行正常"

# 拉取常用镜像
echo ""
echo "📦 拉取常用 Docker 镜像..."

images=(
    "alpine:latest"
    "nginx:alpine"
    "python:3.11-slim"
    "node:20-alpine"
    "mysql:8.0"
    "postgres:15"
    "redis:7-alpine"
)

for image in "${images[@]}"; do
    echo "  拉取 $image..."
    docker pull "$image" > /dev/null 2>&1 || echo "    ⚠️  拉取失败"
done

echo ""
echo "=========================================="
echo "✅ 环境设置完成！"
echo "=========================================="
echo ""
echo "开始学习："
echo "  1. 查看 README.md 了解项目结构"
echo "  2. 从 01-basics 开始学习"
echo "  3. 每个章节都有 README.md 和练习脚本"
echo ""
echo "快速开始："
echo "  cd 01-basics"
echo "  bash practice.sh"
echo ""
