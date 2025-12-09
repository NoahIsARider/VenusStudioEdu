# PostgreSQLStudio 快速开始指南

欢迎使用 PostgreSQLStudio！这是一个系统化的 PostgreSQL 学习环境，包含了从基础到高级的所有知识点。

## 项目结构

```
PostgreSQLStudio/
├── 01-basics/           # 基础知识
├── 02-data-types/       # 数据类型
├── 03-tables/           # 表操作
├── 04-queries/          # 基本查询
├── 05-joins/            # 连接查询
├── 06-aggregates/       # 聚合函数
├── 07-subqueries/       # 子查询
├── 08-views/            # 视图
├── 09-indexes/          # 索引
├── 10-transactions/     # 事务
├── 11-triggers/         # 触发器
├── 12-stored-procedures/# 存储过程
├── 13-functions/        # 函数
├── 14-performance/      # 性能优化
├── 15-backup-restore/   # 备份恢复
├── 16-security/         # 安全管理
├── 17-administration/   # 管理运维
├── scripts/             # 实用脚本
├── init-scripts/        # 初始化脚本
├── docker-compose.yml   # Docker 配置
├── LEARNING_GUIDE.md    # 学习指南
└── README.md           # 项目说明
```

## 环境设置

### 自动设置（推荐）

```bash
# 克隆项目后进入目录
cd PostgreSQLStudio

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

- **pgAdmin Web 界面**: http://localhost:5050
  - 用户名: admin@admin.com
  - 密码: postgres

- **命令行工具**: 
```bash
# 连接到 PostgreSQL 数据库
psql -h localhost -p 5432 -U postgres -d postgres
```

## 学习路径

建议按照以下顺序学习：

1. [01-basics](01-basics/) - PostgreSQL 基础知识
2. [02-data-types](02-data-types/) - 数据类型
3. [03-tables](03-tables/) - 表操作
4. [04-queries](04-queries/) - 基本查询
5. [05-joins](05-joins/) - 连接查询
6. [06-aggregates](06-aggregates/) - 聚合函数
7. [07-subqueries](07-subqueries/) - 子查询
8. [08-views](08-views/) - 视图
9. [09-indexes](09-indexes/) - 索引
10. [10-transactions](10-transactions/) - 事务
11. [11-triggers](11-triggers/) - 触发器
12. [12-stored-procedures](12-stored-procedures/) - 存储过程
13. [13-functions](13-functions/) - 函数
14. [14-performance](14-performance/) - 性能优化
15. [15-backup-restore](15-backup-restore/) - 备份恢复
16. [16-security](16-security/) - 安全管理
17. [17-administration](17-administration/) - 管理运维

## 实用脚本

- `scripts/setup.sh` - 完整环境设置
- `scripts/install-client.sh` - 安装客户端工具
- `scripts/test-connection.sh` - 测试数据库连接

## 学习资源

- [官方文档](https://www.postgresql.org/docs/)
- [PostgreSQL 教程](https://www.postgresqltutorial.com/)
- [学习指南](LEARNING_GUIDE.md)

开始你的 PostgreSQL 学习之旅吧！