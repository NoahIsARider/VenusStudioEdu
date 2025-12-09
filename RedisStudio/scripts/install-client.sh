#!/bin/bash

# 安装 Redis 客户端的脚本

echo "安装 Redis 客户端..."
echo "==================="

# 更新包索引
sudo apt-get update

# 安装 Redis 客户端
sudo apt-get install -y redis-tools

if [ $? -eq 0 ]; then
    echo "✅ Redis 客户端安装成功!"
    echo ""
    echo "验证安装:"
    redis-cli --version
else
    echo "❌ Redis 客户端安装失败"
    exit 1
fi