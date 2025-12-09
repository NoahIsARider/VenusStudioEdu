# RedisStudio 快速开始指南

欢迎使用 RedisStudio！这是一个系统化的 Redis 学习环境，包含了从基础到高级的所有知识点。

## 项目结构

```
RedisStudio/
├── 01-basics/           # 基础知识
├── 02-data-types/       # 数据类型
├── 03-keys/             # 键操作
├── 04-strings/          # 字符串
├── 05-lists/            # 列表
├── 06-sets/             # 集合
├── 07-sorted-sets/      # 有序集合
├── 08-hashes/           # 哈希
├── 09-transactions/     # 事务
├── 10-persistence/      # 持久化
├── 11-replication/      # 复制
├── 12-sentinel/         # 哨兵
├── 13-cluster/          # 集群
├── 14-performance/      # 性能优化
├── 15-security/         # 安全管理
├── 16-monitoring/       # 监控
├── scripts/             # 实用脚本
├── docker-compose.yml   # Docker 配置
├── redis.conf           # Redis 配置
├── LEARNING_GUIDE.md    # 学习指南
└── README.md           # 项目说明
```

## 环境设置

### 自动设置（推荐）

```bash
# 克隆项目后进入目录
cd RedisStudio

# 运行一键设置脚本
./scripts/setup.sh
```

### 手动设置

1. 启动 Docker 环境：
```bash
docker-compose up -d
```

2. 安装客户端工具：
```bash
./scripts/install-client.sh
```

3. 测试连接：
```bash
./scripts/test-connection.sh
```

## 访问方式

- **RedisInsight Web 界面**: http://localhost:8001
  - 首次访问需要添加数据库连接：
    - Host: redis-studio-db
    - Port: 6379
    - Name: RedisStudio

- **命令行工具**: 
```bash
# 连接到 Redis 数据库
redis-cli -h localhost -p 6379
```

## 学习路径

建议按照以下顺序学习：

1. [01-basics](01-basics/) - Redis 基础知识
2. [02-data-types](02-data-types/) - 数据类型
3. [03-keys](03-keys/) - 键操作
4. [04-strings](04-strings/) - 字符串
5. [05-lists](05-lists/) - 列表
6. [06-sets](06-sets/) - 集合
7. [07-sorted-sets](07-sorted-sets/) - 有序集合
8. [08-hashes](08-hashes/) - 哈希
9. [09-transactions](09-transactions/) - 事务
10. [10-persistence](10-persistence/) - 持久化
11. [11-replication](11-replication/) - 复制
12. [12-sentinel](12-sentinel/) - 哨兵
13. [13-cluster](13-cluster/) - 集群
14. [14-performance](14-performance/) - 性能优化
15. [15-security](15-security/) - 安全管理
16. [16-monitoring](16-monitoring/) - 监控

## 实用脚本

- `scripts/setup.sh` - 完整环境设置
- `scripts/install-client.sh` - 安装客户端工具
- `scripts/test-connection.sh` - 测试 Redis 连接

## 学习资源

- [官方文档](https://redis.io/documentation)
- [Redis 命令参考](https://redis.io/commands)
- [学习指南](LEARNING_GUIDE.md)

开始你的 Redis 学习之旅吧！