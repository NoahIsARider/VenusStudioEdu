# Redis 数据类型

## 学习目标

完成本章学习后，你应该能够：

1. 理解 Redis 支持的各种数据类型及其特点
2. 掌握字符串、哈希、列表、集合、有序集合的使用方法
3. 了解 HyperLogLog、Bitmaps、Geospatial Indexes 等特殊数据类型
4. 能够根据业务需求选择合适的数据类型
5. 理解各种数据类型的内部编码和内存优化

## 主要内容

### 1. 字符串 (Strings)

字符串是 Redis 最基本的数据类型，可以存储文本、数字或二进制数据。

特点：
- 最大长度为 512 MB
- 支持原子操作
- 可以进行数值操作（INCR、DECR 等）

常用命令：
```bash
SET key value
GET key
INCR key
DECR key
INCRBY key increment
DECRBY key decrement
APPEND key value
STRLEN key
```

### 2. 哈希 (Hashes)

哈希是一个键值对集合，适合存储对象。

特点：
- 每个哈希可以存储多达 2^32 - 1 个键值对
- 可以单独获取或设置某个字段的值

常用命令：
```bash
HSET key field value
HGET key field
HMSET key field1 value1 field2 value2
HMGET key field1 field2
HGETALL key
HDEL key field
HEXISTS key field
HLEN key
```

### 3. 列表 (Lists)

列表是简单的字符串列表，按照插入顺序排序。

特点：
- 可以从两端推入或弹出元素
- 支持阻塞式操作

常用命令：
```bash
LPUSH key value
RPUSH key value
LPOP key
RPOP key
LRANGE key start stop
LLEN key
LINDEX key index
LREM key count value
BLPOP key timeout
BRPOP key timeout
```

### 4. 集合 (Sets)

集合是字符串类型的无序集合，成员是唯一的。

特点：
- 成员不可重复
- 支持集合间的交集、并集、差集操作

常用命令：
```bash
SADD key member
SMEMBERS key
SISMEMBER key member
SCARD key
SREM key member
SPOP key
SRANDMEMBER key
SDIFF key1 key2
SINTER key1 key2
SUNION key1 key2
```

### 5. 有序集合 (Sorted Sets)

有序集合是集合的一个升级版，每个成员都会关联一个分数。

特点：
- 成员唯一，但分数可以重复
- 根据分数自动排序

常用命令：
```bash
ZADD key score member
ZRANGE key start stop
ZREM key member
ZSCORE key member
ZCARD key
ZCOUNT key min max
ZRANK key member
ZREVRANGE key start stop
ZINCRBY key increment member
```

### 6. 特殊数据类型

#### HyperLogLog
用于基数统计，例如统计网站的 UV（独立访客）。

```bash
PFADD key element
PFCOUNT key
PFMERGE destkey sourcekey
```

#### Bitmaps
通过特殊的命令来处理字符串值，将其视为位数组。

```bash
SETBIT key offset value
GETBIT key offset
BITCOUNT key
BITOP operation destkey key
```

#### Geospatial Indexes
用于存储地理位置信息，并支持计算地理位置距离等操作。

```bash
GEOADD key longitude latitude member
GEODIST key member1 member2
GEOHASH key member
GEOPOS key member
GEORADIUS key longitude latitude radius
```

## 最佳实践

1. **选择合适的数据类型**：
   - 根据数据特性和访问模式选择最合适的数据类型
   - 避免滥用字符串类型存储结构化数据

2. **合理设计键名**：
   - 使用一致的命名约定
   - 避免过长的键名以节省内存

3. **注意内存使用**：
   - 了解不同数据类型的内存消耗
   - 定期清理不需要的数据

4. **利用批量操作**：
   - 使用 MGET、MSET 等批量操作减少网络往返次数

## 实践练习

### 练习 1：字符串操作

```bash
# 基本字符串操作
SET greeting "Hello Redis"
GET greeting

# 数值操作
SET counter 10
INCR counter
DECR counter
INCRBY counter 5
GET counter

# 字符串拼接
APPEND greeting " World"
GET greeting
```

### 练习 2：哈希操作

```bash
# 创建用户信息哈希
HSET user:1000 name "Alice" email "alice@example.com" age 25
HSET user:1000 city "Beijing"

# 获取用户信息
HGET user:1000 name
HMGET user:1000 name email age
HGETALL user:1000

# 更新用户信息
HINCRBY user:1000 age 1
HDEL user:1000 city

# 检查字段是否存在
HEXISTS user:1000 city
```

### 练习 3：列表操作

```bash
# 创建任务队列
LPUSH tasks "task1" "task2" "task3"
RPUSH tasks "task4" "task5"

# 查看队列内容
LRANGE tasks 0 -1
LLEN tasks

# 处理任务
LPOP tasks
RPOP tasks

# 阻塞式弹出（可在另一个终端测试）
BLPOP tasks 10
```

### 练习 4：集合操作

```bash
# 创建标签集合
SADD tags:post1 "redis" "database" "nosql"
SADD tags:post2 "redis" "cache" "performance"

# 查看标签
SMEMBERS tags:post1

# 集合运算
SINTER tags:post1 tags:post2  # 交集
SUNION tags:post1 tags:post2  # 并集
SDIFF tags:post1 tags:post2   # 差集

# 检查标签
SISMEMBER tags:post1 "redis"
SCARD tags:post1
```

### 练习 5：有序集合操作

```bash
# 创建排行榜
ZADD leaderboard 100 "player1"
ZADD leaderboard 200 "player2"
ZADD leaderboard 150 "player3"
ZADD leaderboard 300 "player4"

# 查看排行榜
ZRANGE leaderboard 0 -1 WITHSCORES
ZREVRANGE leaderboard 0 -1 WITHSCORES

# 获取玩家排名
ZRANK leaderboard "player3"
ZSCORE leaderboard "player3"

# 更新分数
ZINCRBY leaderboard 50 "player1"

# 获取指定分数范围的玩家
ZCOUNT leaderboard 100 200
```

通过这些练习，你将深入理解 Redis 中各种数据类型的使用方法和适用场景。