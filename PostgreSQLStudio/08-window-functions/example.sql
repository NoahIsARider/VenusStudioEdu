-- PostgreSQL Window Functions Examples
-- This file demonstrates various window function techniques in PostgreSQL

-- Create sample tables for demonstration
DROP TABLE IF EXISTS employees CASCADE;
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INTEGER
);

DROP TABLE IF EXISTS sales CASCADE;
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER,
    sale_amount DECIMAL(10,2),
    sale_date DATE
);

-- Insert sample data
INSERT INTO employees (name, department, salary, hire_date, manager_id) VALUES
('Alice Johnson', 'Engineering', 95000.00, '2020-01-15', NULL),
('Bob Smith', 'Engineering', 85000.00, '2020-03-20', 1),
('Charlie Brown', 'Engineering', 90000.00, '2020-06-10', 1),
('Diana Wilson', 'Marketing', 75000.00, '2020-02-01', NULL),
('Eve Davis', 'Marketing', 70000.00, '2020-04-15', 4),
('Frank Miller', 'Sales', 80000.00, '2020-01-30', NULL),
('Grace Lee', 'Sales', 72000.00, '2020-05-20', 6),
('Henry Taylor', 'Sales', 78000.00, '2020-07-10', 6),
('Ivy Chen', 'HR', 65000.00, '2020-03-01', NULL),
('Jack Anderson', 'Finance', 85000.00, '2020-02-15', NULL);

INSERT INTO sales (employee_id, sale_amount, sale_date) VALUES
(6, 15000.00, '2023-01-15'),
(6, 20000.00, '2023-02-20'),
(7, 12000.00, '2023-01-25'),
(7, 18000.00, '2023-03-10'),
(8, 25000.00, '2023-02-05'),
(8, 22000.00, '2023-03-15');

-- 1. Basic Window Functions
-- ROW_NUMBER() - Assigns unique sequential numbers
SELECT 
    name,
    department,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num
FROM employees;

-- RANK() - Assigns rank with gaps for ties
SELECT 
    name,
    department,
    salary,
    RANK() OVER (ORDER BY salary DESC) as salary_rank
FROM employees;

-- DENSE_RANK() - Assigns rank without gaps for ties
SELECT 
    name,
    department,
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) as dense_salary_rank
FROM employees;

-- 2. Partitioned Window Functions
-- Ranking within departments
SELECT 
    name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank
FROM employees;

-- 3. Frame Clause Examples
-- Running total of salaries
SELECT 
    name,
    department,
    salary,
    SUM(salary) OVER (ORDER BY hire_date 
                     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM employees
ORDER BY hire_date;

-- Moving average (3-row window)
SELECT 
    name,
    salary,
    AVG(salary) OVER (ORDER BY hire_date 
                     ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as moving_avg
FROM employees
ORDER BY hire_date;

-- 4. Advanced Window Functions
-- LAG() and LEAD() - Access previous/next rows
SELECT 
    name,
    salary,
    LAG(salary, 1) OVER (ORDER BY hire_date) as prev_salary,
    LEAD(salary, 1) OVER (ORDER BY hire_date) as next_salary,
    salary - LAG(salary, 1) OVER (ORDER BY hire_date) as salary_diff
FROM employees
ORDER BY hire_date;

-- FIRST_VALUE() and LAST_VALUE()
SELECT 
    name,
    department,
    salary,
    FIRST_VALUE(name) OVER (PARTITION BY department ORDER BY salary DESC) as highest_paid,
    LAST_VALUE(name) OVER (PARTITION BY department ORDER BY salary DESC 
                          RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as lowest_paid
FROM employees;

-- 5. NTILE() - Distribute rows into buckets
SELECT 
    name,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC) as quartile
FROM employees;

-- 6. Complex Window Function Examples
-- Percent rank and cumulative distribution
SELECT 
    name,
    salary,
    PERCENT_RANK() OVER (ORDER BY salary) as percent_rank,
    CUME_DIST() OVER (ORDER BY salary) as cumulative_dist
FROM employees;

-- NTH_VALUE() - Get nth value in window
SELECT 
    name,
    salary,
    NTH_VALUE(name, 2) OVER (ORDER BY salary DESC 
                            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as second_highest_paid
FROM employees;

-- 7. Window Function with Joins
-- Sales performance with ranking
SELECT 
    e.name,
    s.sale_amount,
    s.sale_date,
    RANK() OVER (PARTITION BY e.department ORDER BY s.sale_amount DESC) as sales_rank_in_dept,
    SUM(s.sale_amount) OVER (PARTITION BY e.id) as total_sales_per_employee
FROM employees e
JOIN sales s ON e.id = s.employee_id
ORDER BY e.department, sales_rank_in_dept;

-- 8. Multiple Window Functions in One Query
SELECT 
    name,
    department,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as dept_row_num,
    RANK() OVER (ORDER BY salary DESC) as overall_rank,
    AVG(salary) OVER (PARTITION BY department) as dept_avg_salary,
    salary - AVG(salary) OVER (PARTITION BY department) as salary_diff_from_dept_avg
FROM employees;

-- 9. Conditional Window Functions
-- Using CASE within window functions
SELECT 
    name,
    department,
    salary,
    COUNT(*) OVER (PARTITION BY department) as dept_size,
    AVG(CASE WHEN salary > 80000 THEN salary ELSE NULL END) 
         OVER (PARTITION BY department) as high_earner_avg
FROM employees;

-- 10. Recursive Window Functions with Hierarchies
-- Employee hierarchy with level counting
WITH RECURSIVE employee_hierarchy AS (
    SELECT id, name, manager_id, 1 as level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id, e.name, e.manager_id, eh.level + 1
    FROM employees e
    JOIN employee_hierarchy eh ON e.manager_id = eh.id
)
SELECT 
    name,
    level,
    COUNT(*) OVER (PARTITION BY level) as employees_at_level
FROM employee_hierarchy
ORDER BY level, name;