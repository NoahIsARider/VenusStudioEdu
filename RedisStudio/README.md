# RedisStudio

这是一个全面的 Redis 学习项目，涵盖了从基础到高级的所有重要 Redis 知识。

## 项目结构

```
RedisStudio/
├── 01-basics/           # Redis 基础知识
├── 02-data-types/       # Redis 数据类型
├── 03-keys/             # 键操作
├── 04-strings/          # 字符串操作
├── 05-lists/            # 列表操作
├── 06-sets/             # 集合操作
├── 07-sorted-sets/      # 有序集合操作
├── 08-hashes/           # 哈希操作
├── 09-transactions/     # 事务处理
├── 10-persistence/      # 持久化
├── 11-replication/      # 主从复制
├── 12-sentinel/         # 哨兵模式
├── 13-cluster/          # 集群模式
├── 14-performance/      # 性能优化
├── 15-security/         # 安全管理
├── 16-monitoring/       # 监控运维
├── docker-compose.yml   # Docker 部署配置
├── QUICKSTART.md        # 快速开始指南
└── LEARNING_GUIDE.md    # 学习指南
```

## 学习目标

通过本项目，您将掌握：
- Redis 的安装与配置
- 五种基本数据类型的使用场景
- Redis 持久化机制
- 高可用方案（主从复制、哨兵、集群）
- 性能优化技巧
- 实际应用场景的最佳实践

## 部署环境

使用 Docker Compose 可以快速部署 Redis 环境，请参考 `docker-compose.yml` 文件。