# PostgreSQL 连接查询

## 学习目标

完成本章学习后，你应该能够：

1. 理解各种连接类型的概念和区别
2. 掌握 INNER JOIN、LEFT JOIN、RIGHT JOIN、FULL OUTER JOIN 的使用方法
3. 学会使用交叉连接和自然连接
4. 能够编写复杂的多表连接查询
5. 理解连接查询的性能优化原则

## 主要内容

### 1. 连接查询基础

连接查询用于从多个相关表中检索数据。通过连接条件将不同表中的行组合在一起。

基本语法：
```sql
SELECT columns
FROM table1
JOIN table2 ON table1.column = table2.column;
```

### 2. 内连接 (INNER JOIN)

内连接返回两个表中满足连接条件的行。

示例：
```sql
SELECT employees.name, departments.name AS department
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;
```

### 3. 左外连接 (LEFT JOIN)

左外连接返回左表的所有行，以及右表中满足连接条件的行。如果右表中没有匹配的行，则对应列为 NULL。

示例：
```sql
SELECT employees.name, departments.name AS department
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id;
```

### 4. 右外连接 (RIGHT JOIN)

右外连接返回右表的所有行，以及左表中满足连接条件的行。如果左表中没有匹配的行，则对应列为 NULL。

示例：
```sql
SELECT employees.name, departments.name AS department
FROM employees
RIGHT JOIN departments ON employees.department_id = departments.id;
```

### 5. 全外连接 (FULL OUTER JOIN)

全外连接返回两个表中的所有行。如果没有匹配的行，则对应列为 NULL。

示例：
```sql
SELECT employees.name, departments.name AS department
FROM employees
FULL OUTER JOIN departments ON employees.department_id = departments.id;
```

### 6. 交叉连接 (CROSS JOIN)

交叉连接返回两个表的笛卡尔积，即左表的每一行与右表的每一行组合。

示例：
```sql
SELECT employees.name, departments.name AS department
FROM employees
CROSS JOIN departments;
```

### 7. 自然连接 (NATURAL JOIN)

自然连接基于两个表中具有相同名称的列进行连接。

示例：
```sql
SELECT *
FROM employees
NATURAL JOIN departments;
```

### 8. 多表连接

可以连接多个表来获取复杂的数据关系。

示例：
```sql
SELECT e.name AS employee, d.name AS department, p.title AS project
FROM employees e
JOIN departments d ON e.department_id = d.id
JOIN projects p ON e.id = p.employee_id;
```

## 最佳实践

1. **明确连接条件**：
   - 始终使用明确的 ON 条件，避免使用旧式的逗号分隔表语法
   - 确保连接条件能够有效利用索引

2. **选择合适的连接类型**：
   - 根据业务需求选择合适的连接类型
   - 注意外连接可能导致的 NULL 值问题

3. **优化连接查询性能**：
   - 确保连接列上有适当的索引
   - 避免不必要的复杂连接
   - 考虑使用 EXISTS 或 IN 替代某些连接查询

4. **使用表别名**：
   - 为表使用简短的别名可以提高查询的可读性
   - 特别是在多表连接时非常有用

## 实践练习

### 练习 1：创建示例表和数据

```sql
-- 创建部门表
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- 创建员工表
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER REFERENCES departments(id)
);

-- 创建项目表
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    employee_id INTEGER REFERENCES employees(id)
);

-- 插入示例数据
INSERT INTO departments (name) VALUES
('技术部'), ('销售部'), ('人事部');

INSERT INTO employees (name, department_id) VALUES
('张三', 1), ('李四', 1), ('王五', 2), ('赵六', NULL);

INSERT INTO projects (title, employee_id) VALUES
('项目A', 1), ('项目B', 2), ('项目C', NULL);
```

### 练习 2：内连接查询

```sql
-- 查询员工及其所属部门
SELECT e.name AS employee, d.name AS department
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
ORDER BY e.name;
```

### 练习 3：左外连接查询

```sql
-- 查询所有员工及其所属部门（包括没有部门的员工）
SELECT e.name AS employee, d.name AS department
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
ORDER BY e.name;
```

### 练习 4：右外连接查询

```sql
-- 查询所有部门及其员工（包括没有员工的部门）
SELECT e.name AS employee, d.name AS department
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id
ORDER BY d.name;
```

### 练习 5：全外连接查询

```sql
-- 查询所有员工和所有部门的完整信息
SELECT e.name AS employee, d.name AS department
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id
ORDER BY e.name, d.name;
```

### 练习 6：多表连接查询

```sql
-- 查询员工、部门和项目的完整信息
SELECT e.name AS employee, d.name AS department, p.title AS project
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
LEFT JOIN projects p ON e.id = p.employee_id
ORDER BY e.name;
```

### 练习 7：复杂连接查询

```sql
-- 查询每个部门的员工数量
SELECT d.name AS department, COUNT(e.id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name
ORDER BY d.name;

-- 查询参与项目的员工及其部门
SELECT DISTINCT e.name AS employee, d.name AS department
FROM employees e
JOIN projects p ON e.id = p.employee_id
JOIN departments d ON e.department_id = d.id
ORDER BY e.name;
```

通过这些练习，你将熟练掌握 PostgreSQL 中各种连接查询的使用方法。