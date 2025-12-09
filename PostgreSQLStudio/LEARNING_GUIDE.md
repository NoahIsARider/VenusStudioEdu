# PostgreSQLStudio 学习指南

这是一个系统化的 PostgreSQL 学习路径，帮助你从入门到精通掌握 PostgreSQL 数据库。

## 学习路径

### 第一阶段：基础知识 (1-3章)

1. **基础概念** (01-basics)
   - 了解 PostgreSQL 的历史和特点
   - 掌握基本的安装和配置方法
   - 学会使用 psql 客户端工具
   - 理解数据库、模式、表的关系

2. **数据类型** (02-data-types)
   - 数值类型（整数、浮点数、货币等）
   - 字符类型（CHAR、VARCHAR、TEXT等）
   - 日期/时间类型
   - 布尔类型
   - JSON 类型
   - 自定义类型

3. **表操作** (03-tables)
   - 创建、修改、删除表
   - 约束（主键、外键、唯一性、检查约束）
   - 默认值和自动递增
   - 表空间和分区

### 第二阶段：查询和连接 (4-6章)

4. **基本查询** (04-queries)
   - SELECT 语句基础
   - WHERE 子句过滤数据
   - ORDER BY 排序
   - LIMIT 和 OFFSET 分页
   - DISTINCT 去重

5. **连接查询** (05-joins)
   - 内连接（INNER JOIN）
   - 外连接（LEFT JOIN、RIGHT JOIN、FULL OUTER JOIN）
   - 交叉连接（CROSS JOIN）
   - 自连接
   - 连接优化技巧

6. **聚合函数** (06-aggregates)
   - COUNT、SUM、AVG、MIN、MAX
   - GROUP BY 分组
   - HAVING 子句过滤分组
   - ROLLUP 和 CUBE
   - 窗口函数基础

### 第三阶段：高级查询 (7-9章)

7. **子查询** (07-subqueries)
   - 标量子查询
   - 行子查询
   - 表子查询
   - 相关子查询
   - 子查询优化

8. **视图** (08-views)
   - 创建和管理视图
   - 可更新视图
   - 物化视图
   - 视图的安全性

9. **索引** (09-indexes)
   - B-tree 索引
   - Hash 索引
   - GiST、GIN、BRIN 索引
   - 复合索引
   - 索引优化

### 第四阶段：数据完整性与程序模块 (10-13章)

10. **事务** (10-transactions)
    - ACID 特性
    - 事务控制语句（BEGIN、COMMIT、ROLLBACK）
    - 隔离级别
    - 锁机制

11. **触发器** (11-triggers)
    - 创建和管理触发器
    - 行级触发器 vs 语句级触发器
    - 触发器的应用场景

12. **存储过程** (12-stored-procedures)
    - 创建和调用存储过程
    - 参数传递
    - 错误处理

13. **函数** (13-functions)
    - 内置函数
    - 用户自定义函数
    - 函数重载
    - 聚合函数自定义

### 第五阶段：性能与运维 (14-17章)

14. **性能优化** (14-performance)
    - 查询计划分析（EXPLAIN）
    - 索引优化
    - 查询优化技巧
    - 数据库配置优化

15. **备份与恢复** (15-backup-restore)
    - 逻辑备份（pg_dump）
    - 物理备份
    - 恢复策略
    - 备份自动化

16. **安全管理** (16-security)
    - 用户和角色管理
    - 权限控制
    - SSL 加密连接
    - 审计日志

17. **管理运维** (17-administration)
    - 监控和诊断
    - 日常维护任务
    - 升级和迁移
    - 高可用方案

## 学习建议

### 实践为主
- 每个章节都要动手实践代码示例
- 完成章节后的练习题
- 尝试解决实际问题

### 循序渐进
- 按照学习路径顺序学习
- 不要跳跃章节
- 确保掌握基础知识后再学习高级内容

### 参考资料
- [PostgreSQL 官方文档](https://www.postgresql.org/docs/)
- [PostgreSQL 教程](https://www.postgresqltutorial.com/)
- [PostgreSQL Wiki](https://wiki.postgresql.org/)

## 评估标准

### 初级水平
- 掌握基本的 SQL 语法
- 能够创建和查询表
- 理解基本的数据类型和约束

### 中级水平
- 熟练使用连接查询和聚合函数
- 理解索引和视图的使用
- 掌握事务和触发器

### 高级水平
- 能够进行性能优化
- 熟悉存储过程和函数
- 掌握备份恢复和安全管理

祝你学习愉快！