# PostgreSQL 基础知识

## 学习目标

完成本章学习后，你应该能够：

1. 了解 PostgreSQL 的历史和发展
2. 理解关系型数据库的基本概念
3. 掌握 PostgreSQL 的安装和配置方法
4. 熟悉 psql 命令行工具的基本使用
5. 能够连接到 PostgreSQL 数据库并执行简单查询

## 主要内容

### 1. PostgreSQL 简介

- **历史背景**：PostgreSQL 是一个强大的开源对象关系型数据库系统，起源于加州大学伯克利分校的 POSTGRES 项目。它以其稳定性、功能丰富和符合 SQL 标准而闻名 <mcreference link="https://www.postgresql.org/docs/current/tutorial.html" index="1">1</mcreference>。
- **主要特点**：
  - ACID 兼容
  - 支持复杂查询
  - 外键、触发器、视图
  - 事务完整性
  - 多版本并发控制 (MVCC)
  - 扩展性好

### 2. 安装和配置

- **Docker 环境**：在本环境中，PostgreSQL 已通过 Docker 容器预配置，无需手动安装。
- **连接信息**：
  - Host: localhost
  - Port: 5432
  - Database: postgres
  - Username: postgres
  - Password: postgres

### 3. psql 命令行工具

psql 是 PostgreSQL 的交互式命令行工具，用于执行查询、管理数据库等操作。

常用命令：
- `\l` - 列出所有数据库
- `\c database_name` - 连接到指定数据库
- `\dt` - 列出当前数据库的所有表
- `\d table_name` - 显示表的结构
- `\q` - 退出 psql

### 4. 基本 SQL 操作

- **连接数据库**：使用 psql 连接到 PostgreSQL 数据库
- **创建数据库**：`CREATE DATABASE testdb;`
- **创建表**：定义表结构并插入数据
- **简单查询**：使用 SELECT 语句查询数据

## 实践练习

### 练习 1：连接数据库

使用 psql 连接到 PostgreSQL 数据库，执行以下命令查看数据库列表：

```bash
psql -h localhost -p 5432 -U postgres -d postgres
\l
```

### 练习 2：创建和使用表

在 psql 中执行以下 SQL 语句：

```sql
-- 创建一个名为 employees 的表
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(100),
    salary DECIMAL(10, 2)
);

-- 插入一些示例数据
INSERT INTO employees (name, position, salary) VALUES
('张三', '软件工程师', 8000.00),
('李四', '产品经理', 12000.00),
('王五', '设计师', 9000.00);

-- 查询所有员工信息
SELECT * FROM employees;
```

### 练习 3：基本查询操作

执行以下查询语句来熟悉基本的 SQL 查询：

```sql
-- 查询特定字段
SELECT name, salary FROM employees;

-- 使用 WHERE 条件过滤
SELECT * FROM employees WHERE salary > 10000;

-- 按某种顺序排序
SELECT * FROM employees ORDER BY salary DESC;
```

### 练习 4：更新和删除数据

```sql
-- 更新数据
UPDATE employees SET salary = 8500.00 WHERE name = '张三';

-- 删除数据
DELETE FROM employees WHERE name = '王五';
```

### 练习 5：删除表

完成练习后，清理创建的表：

```sql
DROP TABLE employees;
```

通过这些练习，你将掌握 PostgreSQL 的基本操作，为后续章节的学习打下坚实的基础。