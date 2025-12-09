#!/bin/bash

# 安装 PostgreSQL 客户端的脚本

echo "安装 PostgreSQL 客户端..."
echo "========================"

# 更新包索引
sudo apt-get update

# 安装 PostgreSQL 客户端
sudo apt-get install -y postgresql-client

if [ $? -eq 0 ]; then
    echo "✅ PostgreSQL 客户端安装成功!"
    echo ""
    echo "验证安装:"
    psql --version
else
    echo "❌ PostgreSQL 客户端安装失败"
    exit 1
fi