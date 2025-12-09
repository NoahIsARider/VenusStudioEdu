#!/bin/bash

# 测试 PostgreSQL 连接的脚本

echo "测试 PostgreSQL 连接..."
echo "======================"

# 检查是否安装了 psql 客户端
if ! command -v psql &> /dev/null
then
    echo "错误: 未找到 psql 客户端，请先安装 PostgreSQL 客户端"
    exit 1
fi

# 测试连接
echo "正在连接到 PostgreSQL 数据库..."
PGPASSWORD=postgres psql -h localhost -p 5432 -U postgres -d postgres -t -A -c "SELECT version();" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ 成功连接到 PostgreSQL 数据库!"
    echo ""
    echo "PostgreSQL 服务器信息:"
    PGPASSWORD=postgres psql -h localhost -p 5432 -U postgres -d postgres -t -A -c "SELECT version();"
    
    echo ""
    echo "数据库列表:"
    PGPASSWORD=postgres psql -h localhost -p 5432 -U postgres -d postgres -t -A -c "SELECT datname FROM pg_database WHERE datistemplate = false;"
    
    echo ""
    echo "简单测试命令:"
    PGPASSWORD=postgres psql -h localhost -p 5432 -U postgres -d postgres -c "CREATE TABLE IF NOT EXISTS test_table (id SERIAL PRIMARY KEY, name VARCHAR(50));" >/dev/null 2>&1
    PGPASSWORD=postgres psql -h localhost -p 5432 -U postgres -d postgres -c "INSERT INTO test_table (name) VALUES ('Test Entry');" >/dev/null 2>&1
    PGPASSWORD=postgres psql -h localhost -p 5432 -U postgres -d postgres -t -A -c "SELECT * FROM test_table;"
    PGPASSWORD=postgres psql -h localhost -p 5432 -U postgres -d postgres -c "DROP TABLE test_table;" >/dev/null 2>&1
else
    echo "❌ 连接失败，请检查以下几点:"
    echo "  1. PostgreSQL 服务是否正在运行 (docker-compose up -d)"
    echo "  2. 端口 5432 是否被正确映射"
    echo "  3. 用户名和密码是否正确 (默认: postgres/postgres)"
fi