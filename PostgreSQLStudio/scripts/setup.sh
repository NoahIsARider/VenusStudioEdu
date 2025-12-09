#!/bin/bash

# PostgreSQLStudio 设置脚本

echo "PostgreSQLStudio 环境设置..."
echo "=========================="

# 启动 Docker 环境
echo "1. 启动 Docker 环境..."
docker-compose up -d

if [ $? -eq 0 ]; then
    echo "✅ Docker 环境启动成功!"
else
    echo "❌ Docker 环境启动失败"
    exit 1
fi

# 等待数据库启动
echo "2. 等待数据库启动 (30秒)..."
sleep 30

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
echo "4. 测试数据库连接..."
./test-connection.sh

echo ""
echo "🎉 PostgreSQLStudio 环境设置完成!"
echo ""
echo "下一步操作:"
echo "  - 访问 http://localhost:5050 登录 pgAdmin (默认账号: admin@admin.com / postgres)"
echo "  - 使用 psql 命令行工具连接数据库"
echo "  - 开始学习 PostgreSQL 数据库知识"