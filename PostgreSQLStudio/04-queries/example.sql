-- PostgreSQL Queries Example File
-- This file demonstrates various query techniques in PostgreSQL

-- 1. Basic SELECT queries with different clauses
-- Create sample tables for demonstration
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    budget DECIMAL(12,2)
);

-- Insert sample data
INSERT INTO departments (name, budget) VALUES 
('Engineering', 500000.00),
('Marketing', 200000.00),
('Sales', 300000.00);

INSERT INTO employees (name, department, salary, hire_date) VALUES 
('Alice Johnson', 'Engineering', 75000.00, '2020-01-15'),
('Bob Smith', 'Marketing', 65000.00, '2019-03-22'),
('Charlie Brown', 'Sales', 70000.00, '2021-07-10'),
('Diana Prince', 'Engineering', 80000.00, '2018-11-05'),
('Eve Wilson', 'Sales', 68000.00, '2020-05-30');

-- Simple select query
SELECT * FROM employees;

-- Select with WHERE clause
SELECT name, salary FROM employees WHERE salary > 70000;

-- Select with ORDER BY
SELECT name, salary FROM employees ORDER BY salary DESC;

-- Select with LIMIT
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 3;

-- 2. JOIN queries
-- Inner join
SELECT e.name, e.salary, d.name as department_name
FROM employees e
INNER JOIN departments d ON e.department = d.name;

-- Left join
SELECT e.name, e.salary, d.name as department_name
FROM employees e
LEFT JOIN departments d ON e.department = d.name;

-- Full outer join
SELECT e.name, e.salary, d.name as department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department = d.name;

-- 3. Aggregate functions and GROUP BY
-- Count employees by department
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department;

-- Average salary by department
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department;

-- Having clause with group by
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 70000;

-- 4. Subqueries
-- Employees with salary above average
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Departments with budgets above average
SELECT name, budget
FROM departments
WHERE budget > (SELECT AVG(budget) FROM departments);

-- 5. UNION and INTERSECT
-- Create another table for comparison
CREATE TABLE IF NOT EXISTS contractors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    contract_start DATE
);

INSERT INTO contractors (name, department, salary, contract_start) VALUES 
('Frank Miller', 'Engineering', 70000.00, '2021-01-01'),
('Grace Lee', 'Marketing', 60000.00, '2020-06-15');

-- Union of employees and contractors
SELECT name, department FROM employees
UNION
SELECT name, department FROM contractors;

-- Intersection of departments
SELECT department FROM employees
INTERSECT
SELECT department FROM contractors;

-- 6. Window functions
-- Rank employees by salary within each department
SELECT name, department, salary,
       ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as rank_in_dept
FROM employees;

-- Running total of salaries
SELECT name, salary,
       SUM(salary) OVER (ORDER BY hire_date) as running_total
FROM employees
ORDER BY hire_date;

-- 7. Common Table Expressions (CTEs)
-- CTE to calculate department statistics
WITH dept_stats AS (
    SELECT department, 
           COUNT(*) as emp_count,
           AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
)
SELECT e.name, e.salary, d.avg_salary
FROM employees e
JOIN dept_stats d ON e.department = d.department
WHERE e.salary > d.avg_salary;

-- 8. Advanced filtering with LIKE, IN, BETWEEN
-- Employees with names starting with 'A' or 'B'
SELECT * FROM employees WHERE name LIKE 'A%' OR name LIKE 'B%';

-- Employees in specific departments
SELECT * FROM employees WHERE department IN ('Engineering', 'Sales');

-- Employees hired between specific dates
SELECT * FROM employees WHERE hire_date BETWEEN '2019-01-01' AND '2020-12-31';

-- 9. CASE expressions
SELECT name, salary,
       CASE 
           WHEN salary >= 75000 THEN 'High'
           WHEN salary >= 65000 THEN 'Medium'
           ELSE 'Low'
       END as salary_level
FROM employees;

-- 10. DISTINCT and NULL handling
-- Distinct departments
SELECT DISTINCT department FROM employees;

-- Handle potential NULL values
INSERT INTO employees (name, department, salary, hire_date) VALUES 
('Henry Ford', NULL, 60000.00, '2022-01-01');

SELECT name, COALESCE(department, 'Unassigned') as department
FROM employees
WHERE department IS NULL OR department IS NOT NULL;

-- Clean up test data (optional - remove in production)
-- DELETE FROM employees WHERE name IN ('Alice Johnson', 'Bob Smith', 'Charlie Brown', 'Diana Prince', 'Eve Wilson', 'Frank Miller', 'Grace Lee', 'Henry Ford');
-- DELETE FROM departments WHERE name IN ('Engineering', 'Marketing', 'Sales');
-- DELETE FROM contractors WHERE name IN ('Frank Miller', 'Grace Lee');