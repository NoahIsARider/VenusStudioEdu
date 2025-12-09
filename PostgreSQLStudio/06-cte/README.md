# PostgreSQL 公用表表达式 (CTE)

## 学习目标

完成本章学习后，你应该能够：

1. 理解公用表表达式（CTE）的概念和作用
2. 掌握基本 CTE 的定义和使用方法
3. 学会使用递归 CTE 处理层次结构数据
4. 能够编写复杂的多层 CTE 查询
5. 理解 CTE 与子查询的区别和优势

## 主要内容

### 1. 公用表表达式基础

公用表表达式（Common Table Expressions，CTE）是一种临时的结果集，可以在 SELECT、INSERT、UPDATE 或 DELETE 语句中引用。CTE 使用 WITH 子句定义。

基本语法：
```sql
WITH cte_name AS (
    SELECT ...
)
SELECT * FROM cte_name;
```

### 2. 基本 CTE 示例

```sql
-- 定义一个简单的 CTE 来获取高薪员工
WITH high_salary_employees AS (
    SELECT id, name, salary
    FROM employees
    WHERE salary > 8000
)
SELECT * FROM high_salary_employees
ORDER BY salary DESC;
```

### 3. 多个 CTE

可以在一个查询中定义多个 CTE：

```sql
WITH 
dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
),
high_departments AS (
    SELECT department_id
    FROM dept_avg
    WHERE avg_salary > 8000
)
SELECT e.name, e.salary, e.department_id
FROM employees e
JOIN high_departments hd ON e.department_id = hd.department_id
ORDER BY e.salary DESC;
```

### 4. 递归 CTE

递归 CTE 用于处理层次结构数据，如组织结构、分类树等。递归 CTE 包含两个部分：非递归项和递归项。

基本语法：
```sql
WITH RECURSIVE cte_name AS (
    -- 非递归项（基础查询）
    SELECT ...
    UNION ALL
    -- 递归项
    SELECT ...
    FROM cte_name
    WHERE condition
)
SELECT * FROM cte_name;
```

### 5. 递归 CTE 示例

```sql
-- 创建组织结构表示例数据
CREATE TABLE org_structure (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    parent_id INTEGER REFERENCES org_structure(id)
);

INSERT INTO org_structure (name, parent_id) VALUES
('CEO', NULL),
('技术部', 1),
('销售部', 1),
('人事部', 1),
('前端团队', 2),
('后端团队', 2),
('市场团队', 3),
('招聘团队', 4);

-- 使用递归 CTE 查询组织结构
WITH RECURSIVE org_tree AS (
    -- 非递归项：查找根节点
    SELECT id, name, parent_id, 0 AS level, name::TEXT AS path
    FROM org_structure
    WHERE parent_id IS NULL
    
    UNION ALL
    
    -- 递归项：查找子节点
    SELECT os.id, os.name, os.parent_id, ot.level + 1, ot.path || ' -> ' || os.name
    FROM org_structure os
    JOIN org_tree ot ON os.parent_id = ot.id
)
SELECT name, level, path
FROM org_tree
ORDER BY path;
```

### 6. CTE 与子查询的区别

CTE 相比子查询有以下优势：
- 可读性更好，特别是复杂查询
- 可以在多个地方引用同一个 CTE
- 递归查询只能使用 CTE 实现
- 更容易调试和维护

## 最佳实践

1. **提高查询可读性**：
   - 使用有意义的 CTE 名称
   - 将复杂的子查询重构为 CTE

2. **合理使用递归 CTE**：
   - 确保递归终止条件正确
   - 避免无限递归
   - 注意递归深度限制

3. **性能考虑**：
   - CTE 可能不会像预期那样优化性能
   - 在大数据集上使用时要考虑性能影响
   - 必要时使用物化 CTE（MATERIALIZED）

4. **避免重复计算**：
   - 当需要多次使用相同的结果集时，使用 CTE 可以避免重复计算

## 实践练习

### 练习 1：创建示例表和数据

```sql
-- 创建员工表
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager_id INTEGER REFERENCES employees(id),
    department_id INTEGER,
    salary NUMERIC(10, 2)
);

-- 插入示例数据
INSERT INTO employees (name, manager_id, department_id, salary) VALUES
('张总', NULL, 1, 20000.00),
('李经理', 1, 1, 15000.00),
('王主管', 2, 1, 12000.00),
('赵工程师', 3, 1, 10000.00),
('钱工程师', 3, 1, 9000.00),
('孙经理', 1, 2, 14000.00),
('周主管', 6, 2, 11000.00),
('吴销售员', 7, 2, 8000.00);
```

### 练习 2：基本 CTE 使用

```sql
-- 使用 CTE 查询各部门平均薪资
WITH dept_avg_salary AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT department_id, ROUND(avg_salary, 2) AS average_salary
FROM dept_avg_salary
ORDER BY department_id;
```

### 练习 3：多层 CTE 使用

```sql
-- 使用多层 CTE 分析员工薪资情况
WITH 
-- 计算各部门平均薪资
dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
),
-- 找出高于部门平均薪资的员工
above_avg_employees AS (
    SELECT e.id, e.name, e.salary, e.department_id
    FROM employees e
    JOIN dept_avg da ON e.department_id = da.department_id
    WHERE e.salary > da.avg_salary
)
-- 查询这些员工的信息
SELECT name, salary, department_id
FROM above_avg_employees
ORDER BY department_id, salary DESC;
```

### 练习 4：递归 CTE 查询组织结构

```sql
-- 使用递归 CTE 查询员工的汇报关系
WITH RECURSIVE employee_hierarchy AS (
    -- 非递归项：查找顶级管理者
    SELECT id, name, manager_id, 0 AS level, name::TEXT AS hierarchy_path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- 递归项：查找下属员工
    SELECT e.id, e.name, e.manager_id, eh.level + 1, eh.hierarchy_path || ' -> ' || e.name
    FROM employees e
    JOIN employee_hierarchy eh ON e.manager_id = eh.id
)
SELECT name, level, hierarchy_path
FROM employee_hierarchy
ORDER BY hierarchy_path;
```

### 练习 5：使用 CTE 进行复杂数据分析

```sql
-- 使用 CTE 分析公司薪资结构
WITH 
-- 计算总体统计数据
company_stats AS (
    SELECT 
        COUNT(*) AS total_employees,
        AVG(salary) AS avg_salary,
        MIN(salary) AS min_salary,
        MAX(salary) AS max_salary
    FROM employees
),
-- 计算各部门统计数据
department_stats AS (
    SELECT 
        department_id,
        COUNT(*) AS dept_employees,
        AVG(salary) AS dept_avg_salary
    FROM employees
    GROUP BY department_id
)
-- 综合查询结果
SELECT 
    ds.department_id,
    ds.dept_employees,
    ROUND(ds.dept_avg_salary, 2) AS dept_avg_salary,
    cs.total_employees,
    ROUND(cs.avg_salary, 2) AS company_avg_salary,
    ROUND((ds.dept_avg_salary - cs.avg_salary) / cs.avg_salary * 100, 2) AS pct_diff_from_company_avg
FROM department_stats ds
CROSS JOIN company_stats cs
ORDER BY ds.department_id;
```

### 练习 6：递归 CTE 查询路径

```sql
-- 使用递归 CTE 查询从某个员工到 CEO 的完整汇报路径
WITH RECURSIVE reporting_path AS (
    -- 非递归项：从指定员工开始
    SELECT id, name, manager_id, 0 AS steps, name::TEXT AS path
    FROM employees
    WHERE name = '钱工程师'
    
    UNION ALL
    
    -- 递归项：向上查找管理者
    SELECT e.id, e.name, e.manager_id, rp.steps + 1, e.name || ' -> ' || rp.path
    FROM employees e
    JOIN reporting_path rp ON e.id = rp.manager_id
)
SELECT path, steps
FROM reporting_path
WHERE manager_id IS NULL;  -- 只显示到达顶层的路径
```

通过这些练习，你将熟练掌握 PostgreSQL 中公用表表达式的使用方法，包括基本 CTE 和递归 CTE，能够在实际项目中运用这些技术解决复杂的数据查询问题。