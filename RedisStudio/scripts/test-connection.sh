#!/bin/bash

# 测试 Redis 连接的脚本

echo "测试 Redis 连接..."
echo "=================="

# 检查是否安装了 redis-cli 客户端
if ! command -v redis-cli &> /dev/null
then
    echo "错误: 未找到 redis-cli 客户端，请先安装 Redis 客户端"
    exit 1
fi

# 测试连接
echo "正在连接到 Redis 数据库..."
redis-cli -h localhost -p 6379 ping > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ 成功连接到 Redis 数据库!"
    echo ""
    echo "Redis 服务器信息:"
    redis-cli -h localhost -p 6379 info server | grep -E "redis_version|redis_mode|os"
    
    echo ""
    echo "Redis 连接测试:"
    redis-cli -h localhost -p 6379 ping
    
    echo ""
    echo "简单测试命令:"
    redis-cli -h localhost -p 6379 set test_key "Hello Redis"
    redis-cli -h localhost -p 6379 get test_key
    redis-cli -h localhost -p 6379 del test_key
else
    echo "❌ 连接失败，请检查以下几点:"
    echo "  1. Redis 服务是否正在运行 (docker-compose up -d)"
    echo "  2. 端口 6379 是否被正确映射"
fi