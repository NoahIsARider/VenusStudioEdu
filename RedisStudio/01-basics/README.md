# Redis 基础知识

## 学习目标

完成本章学习后，你应该能够：

1. 了解 Redis 的历史和发展
2. 理解内存数据库的基本概念和特点
3. 掌握 Redis 的安装和配置方法
4. 熟悉 redis-cli 命令行工具的基本使用
5. 能够连接到 Redis 数据库并执行基本操作

## 主要内容

### 1. Redis 简介

- **历史背景**：Redis (Remote Dictionary Server) 是一个开源的内存数据结构存储系统，由 Salvatore Sanfilippo 于 2009 年创建。它可以用作数据库、缓存和消息中间件 <mcreference link="https://redis.io/docs/" index="1">1</mcreference>。
- **主要特点**：
  - 内存存储，高性能读写
  - 支持多种数据结构（字符串、哈希、列表、集合、有序集合等）
  - 持久化选项（RDB 快照和 AOF 日志）
  - 主从复制和高可用性支持
  - 事务支持
  - Lua 脚本支持
  - 发布/订阅模式

### 2. 安装和配置

- **Docker 环境**：在本环境中，Redis 已通过 Docker 容器预配置，无需手动安装。
- **连接信息**：
  - Host: localhost
  - Port: 6379
  - 默认无密码认证

### 3. redis-cli 命令行工具

redis-cli 是 Redis 的官方命令行客户端，用于与 Redis 服务器交互。

常用命令：
- `redis-cli` - 连接到 Redis 服务器
- `redis-cli ping` - 测试连接状态
- `redis-cli shutdown` - 关闭 Redis 服务器
- `help @topic` - 获取特定主题的帮助信息
- `exit` 或 `quit` - 退出 redis-cli

### 4. 基本命令操作

- **键操作**：
  - `SET key value` - 设置键值对
  - `GET key` - 获取键的值
  - `DEL key` - 删除键
  - `EXISTS key` - 检查键是否存在
  - `KEYS pattern` - 查找所有符合给定模式的键

- **服务器信息**：
  - `INFO` - 获取服务器信息和统计信息
  - `CLIENT LIST` - 获取客户端连接列表

## 实践练习

### 练习 1：连接 Redis 数据库

使用 redis-cli 连接到 Redis 数据库并测试连接：

```bash
redis-cli
ping
```

### 练习 2：基本键值操作

在 redis-cli 中执行以下命令：

```bash
# 设置键值对
SET name "Redis学习者"
SET age 25

# 获取键值
GET name
GET age

# 检查键是否存在
EXISTS name
EXISTS email

# 查看所有键
KEYS *

# 删除键
DEL age
```

### 练习 3：不同数据类型操作

```bash
# 字符串操作
SET counter 10
INCR counter
DECR counter

# 列表操作
LPUSH fruits "apple"
LPUSH fruits "banana"
RPUSH fruits "orange"
LRANGE fruits 0 -1

# 集合操作
SADD colors "red"
SADD colors "blue"
SADD colors "green"
SMEMBERS colors
```

### 练习 4：查看服务器信息

```bash
# 查看服务器基本信息
INFO server

# 查看内存使用情况
INFO memory

# 查看客户端连接
CLIENT LIST
```

### 练习 5：使用帮助命令

```bash
# 获取关于字符串命令的帮助
help @string

# 获取特定命令的帮助
help SET
help GET
```

通过这些练习，你将掌握 Redis 的基本操作，为后续章节的学习打下坚实的基础。