# PostgreSQL 聚合函数

## 学习目标

完成本章学习后，你应该能够：

1. 掌握常用的聚合函数（COUNT、SUM、AVG、MIN、MAX）的使用方法
2. 理解 GROUP BY 子句的作用和使用场景
3. 学会使用 HAVING 子句过滤分组结果
4. 能够编写复杂的聚合查询
5. 理解窗口函数的基本概念和使用方法

## 主要内容

### 1. 常用聚合函数

PostgreSQL 提供了丰富的聚合函数来对数据进行统计分析：

- **COUNT()**：计算行数
- **SUM()**：计算数值列的总和
- **AVG()**：计算数值列的平均值
- **MIN()**：找出列中的最小值
- **MAX()**：找出列中的最大值

示例：
```sql
SELECT COUNT(*) FROM employees;
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT MIN(salary), MAX(salary) FROM employees;
```

### 2. GROUP BY 子句

GROUP BY 子句用于将结果集按一个或多个列进行分组，通常与聚合函数一起使用。

示例：
```sql
-- 按部门分组统计员工数量
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;

-- 按部门分组计算平均薪资
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;
```

### 3. HAVING 子句

HAVING 子句用于过滤分组后的结果，类似于 WHERE 子句，但作用于分组而不是单行。

示例：
```sql
-- 查询员工数量大于5的部门
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;
```

### 4. 多列分组

可以按多个列进行分组：

```sql
-- 按部门和职位分组统计
SELECT department_id, job_title, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id, job_title;
```

### 5. 聚合函数与 NULL 值

大多数聚合函数会忽略 NULL 值：

```sql
-- COUNT(column) 会忽略 NULL 值
SELECT COUNT(commission_pct) FROM employees;

-- COUNT(*) 会计算所有行，包括 NULL 值
SELECT COUNT(*) FROM employees;
```

### 6. 窗口函数简介

窗口函数允许在不合并行的情况下对每行进行计算，提供了比普通聚合函数更强大的功能。

基本语法：
```sql
function_name() OVER (
    [PARTITION BY partition_expression, ...]
    [ORDER BY sort_expression [ASC | DESC], ...]
    [frame_clause]
)
```

示例：
```sql
-- 计算每个员工在其部门中的薪资排名
SELECT 
    name,
    department_id,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rank_in_dept
FROM employees;
```

## 最佳实践

1. **合理使用聚合函数**：
   - 根据业务需求选择合适的聚合函数
   - 注意聚合函数对 NULL 值的处理方式

2. **优化 GROUP BY 查询**：
   - 确保 GROUP BY 列上有适当的索引
   - 避免在 GROUP BY 中使用表达式

3. **正确使用 HAVING 和 WHERE**：
   - WHERE 用于过滤行
   - HAVING 用于过滤分组

4. **谨慎使用窗口函数**：
   - 窗口函数功能强大但可能影响性能
   - 在大数据集上使用时要注意性能

## 实践练习

### 练习 1：创建示例表和数据

```sql
-- 创建员工表
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER,
    salary NUMERIC(10, 2),
    hire_date DATE
);

-- 插入示例数据
INSERT INTO employees (name, department_id, salary, hire_date) VALUES
('张三', 1, 8000.00, '2020-01-15'),
('李四', 1, 9000.00, '2019-03-22'),
('王五', 2, 7500.00, '2021-07-10'),
('赵六', 2, 8500.00, '2018-11-05'),
('钱七', 1, 9500.00, '2020-05-30'),
('孙八', 3, 7000.00, '2022-02-18'),
('周九', 3, 7200.00, '2021-09-12'),
('吴十', 2, 8800.00, '2019-12-03');
```

### 练习 2：基本聚合函数使用

```sql
-- 统计员工总数
SELECT COUNT(*) AS total_employees FROM employees;

-- 计算所有员工的薪资总和
SELECT SUM(salary) AS total_salary FROM employees;

-- 计算平均薪资
SELECT AVG(salary) AS average_salary FROM employees;

-- 找出最高和最低薪资
SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM employees;
```

### 练习 3：GROUP BY 使用

```sql
-- 按部门分组统计员工数量
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 按部门分组计算平均薪资
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;
```

### 练习 4：HAVING 子句使用

```sql
-- 查询员工数量大于2的部门
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

-- 查询平均薪资超过8000的部门
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 8000;
```

### 练习 5：多列分组

```sql
-- 按年份和部门分组统计入职员工数量
SELECT 
    EXTRACT(YEAR FROM hire_date) AS hire_year,
    department_id,
    COUNT(*) AS employee_count
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date), department_id
ORDER BY hire_year, department_id;
```

### 练习 6：窗口函数使用

```sql
-- 计算每个员工在其部门中的薪资排名
SELECT 
    name,
    department_id,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rank_in_dept
FROM employees
ORDER BY department_id, rank_in_dept;

-- 计算每个员工薪资占部门总薪资的比例
SELECT 
    name,
    department_id,
    salary,
    ROUND(
        salary / SUM(salary) OVER (PARTITION BY department_id) * 100, 
        2
    ) AS salary_percentage
FROM employees
ORDER BY department_id, salary DESC;
```

### 练习 7：复杂聚合查询

```sql
-- 查询各部门的统计信息
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 查询整体和各部门的平均薪资对比
SELECT 
    'Overall' AS category,
    AVG(salary) AS avg_salary
FROM employees
UNION ALL
SELECT 
    'Department ' || department_id AS category,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY category;
```

通过这些练习，你将熟练掌握 PostgreSQL 中聚合函数的使用方法，并理解如何进行数据分析和统计。