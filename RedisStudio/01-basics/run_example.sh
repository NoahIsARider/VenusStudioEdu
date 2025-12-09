#!/bin/bash

# Redis 基础操作示例运行脚本

echo "Redis 基础操作示例"
echo "=================="

# 检查是否在 Codespace 环境中
if [[ $CODESPACES == true ]]; then
    echo "检测到 Codespace 环境"
    REDIS_HOST="localhost"
else
    echo "本地环境"
    REDIS_HOST="localhost"
fi

# 检查 Redis 是否正在运行
echo "检查 Redis 服务状态..."
if nc -z $REDIS_HOST 6379; then
    echo "Redis 服务正在运行"
else
    echo "Redis 服务未运行，正在启动..."
    cd /workspaces/codespaces-blank/RedisStudio
    docker-compose up -d
    echo "等待 Redis 启动..."
    sleep 10
fi

# 安装 Python 依赖
echo "安装 Python 依赖..."
pip install -r requirements.txt

# 运行示例
echo "运行 Redis 操作示例..."
python example.py

echo "示例执行完成!"