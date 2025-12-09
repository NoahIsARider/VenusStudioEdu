# PostgreSQL 查询语句

## 学习目标
- 掌握 SELECT 语句的基本语法和使用方法
- 学会使用 WHERE 子句进行条件过滤
- 理解 ORDER BY、LIMIT 和 OFFSET 的使用
- 掌握 DISTINCT 关键字去重

## 主要内容

### 基本 SELECT 语句
- SELECT 基本语法
- 查询单个字段、多个字段和所有字段
- 使用别名（AS 关键字）
- 字面量和表达式查询

### WHERE 子句
- 比较操作符 (=, !=, <, >, <=, >=)
- 逻辑操作符 (AND, OR, NOT)
- BETWEEN、IN、LIKE 操作符
- IS NULL、IS NOT NULL 判断空值

### 排序和限制结果集
- ORDER BY 子句（ASC, DESC）
- LIMIT 和 OFFSET 控制返回记录数
- 使用 OFFSET 实现分页查询

### 去重和聚合
- DISTINCT 关键字去除重复记录
- COUNT、SUM、AVG、MIN、MAX 聚合函数基础使用

## 最佳实践
- 编写高效的查询语句
- 合理使用索引提高查询性能
- 避免 SELECT * 查询所有字段

## 实践练习
- 编写各种条件查询语句
- 实现排序和分页功能
- 使用聚合函数统计数据