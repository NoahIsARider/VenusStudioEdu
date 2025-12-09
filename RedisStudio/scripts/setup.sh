#!/bin/bash

# RedisStudio 设置脚本

echo "RedisStudio 环境设置..."
echo "====================="

# 启动 Docker 环境
echo "1. 启动 Docker 环境..."
docker-compose up -d

if [ $? -eq 0 ]; then
    echo "✅ Docker 环境启动成功!"
else
    echo "❌ Docker 环境启动失败"
    exit 1
fi

# 等待 Redis 启动
echo "2. 等待 Redis 启动 (10秒)..."
sleep 10

# 安装客户端工具
echo "3. 安装客户端工具..."
./install-client.sh

if [ $? -eq 0 ]; then
    echo "✅ 客户端工具安装成功!"
else
    echo "❌ 客户端工具安装失败"
    exit 1
fi

# 测试连接
echo "4. 测试 Redis 连接..."
./test-connection.sh

echo ""
echo "🎉 RedisStudio 环境设置完成!"
echo ""
echo "下一步操作:"
echo "  - 访问 http://localhost:8001 使用 RedisInsight 管理界面"
echo "  - 使用 redis-cli 命令行工具连接 Redis"
echo "  - 开始学习 Redis 数据库知识"