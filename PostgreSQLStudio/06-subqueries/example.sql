-- PostgreSQL Subqueries Example File
-- This file demonstrates various subquery techniques in PostgreSQL

-- 1. Setup sample tables for demonstration
-- Create departments table
CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    budget DECIMAL(12,2)
);

-- Create employees table
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER,
    salary DECIMAL(10,2),
    hire_date DATE
);

-- Create projects table
CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER,
    start_date DATE,
    end_date DATE
);

-- Create employee_projects table (many-to-many relationship)
CREATE TABLE IF NOT EXISTS employee_projects (
    employee_id INTEGER,
    project_id INTEGER,
    hours_worked DECIMAL(6,2),
    PRIMARY KEY (employee_id, project_id)
);

-- 2. Insert sample data
INSERT INTO departments (name, budget) VALUES
('Engineering', 500000.00),
('Marketing', 200000.00),
('Sales', 300000.00),
('HR', 150000.00);

INSERT INTO employees (name, department_id, salary, hire_date) VALUES
('Alice Johnson', 1, 75000.00, '2020-01-15'),
('Bob Smith', 2, 65000.00, '2019-03-22'),
('Charlie Brown', 3, 70000.00, '2021-07-10'),
('Diana Prince', 1, 80000.00, '2018-11-05'),
('Eve Wilson', 3, 68000.00, '2020-05-30'),
('Frank Miller', 1, 72000.00, '2021-02-20'),
('Grace Lee', 2, 67000.00, '2020-09-15'),
('Henry Ford', 3, 71000.00, '2019-12-01');

INSERT INTO projects (name, department_id, start_date, end_date) VALUES
('Website Redesign', 1, '2023-01-01', '2023-06-30'),
('Marketing Campaign', 2, '2023-02-01', '2023-05-31'),
('Sales Tool Development', 3, '2023-03-01', '2023-09-30'),
('HR System Upgrade', 4, '2023-04-01', '2023-08-31');

INSERT INTO employee_projects (employee_id, project_id, hours_worked) VALUES
(1, 1, 120.50),  -- Alice on Website Redesign
(2, 2, 80.25),   -- Bob on Marketing Campaign
(3, 3, 95.75),   -- Charlie on Sales Tool Development
(4, 1, 110.00),  -- Diana on Website Redesign
(1, 3, 45.50),   -- Alice also on Sales Tool Development
(5, 3, 60.00),   -- Eve on Sales Tool Development
(6, 1, 75.25),   -- Frank on Website Redesign
(7, 2, 55.75);   -- Grace on Marketing Campaign

-- 3. Scalar Subqueries (return single value)
-- Find employees with salary higher than average
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Find departments with budgets higher than average
SELECT name, budget
FROM departments
WHERE budget > (SELECT AVG(budget) FROM departments);

-- 4. Row Subqueries (return single row)
-- Find employee with exact same name and salary as another record
SELECT *
FROM employees
WHERE (name, salary) = (SELECT name, salary FROM employees WHERE id = 1);

-- 5. Table Subqueries (return multiple rows/columns)
-- Find employees in departments with budgets over 250000
SELECT name, salary, department_id
FROM employees
WHERE department_id IN (
    SELECT id 
    FROM departments 
    WHERE budget > 250000
);

-- 6. Correlated Subqueries (subquery references outer query)
-- Find employees earning more than average in their department
SELECT e1.name, e1.salary, d.name as department_name
FROM employees e1
JOIN departments d ON e1.department_id = d.id
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

-- Find departments with more employees than average
SELECT d.name, COUNT(e.id) as employee_count
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name
HAVING COUNT(e.id) > (
    SELECT AVG(emp_count)
    FROM (
        SELECT COUNT(e2.id) as emp_count
        FROM departments d2
        LEFT JOIN employees e2 ON d2.id = e2.department_id
        GROUP BY d2.id
    ) dept_counts
);

-- 7. Subqueries in SELECT clause
-- Show employee name and how their salary compares to average
SELECT name, 
       salary,
       (SELECT AVG(salary) FROM employees) as avg_salary,
       salary - (SELECT AVG(salary) FROM employees) as diff_from_avg
FROM employees;

-- Show department name and employee count
SELECT name,
       (SELECT COUNT(*) FROM employees e WHERE e.department_id = d.id) as employee_count
FROM departments d;

-- 8. Subqueries in FROM clause (Derived Tables)
-- Find departments with above-average employee counts
SELECT dept_stats.name, dept_stats.emp_count
FROM (
    SELECT d.name, COUNT(e.id) as emp_count
    FROM departments d
    LEFT JOIN employees e ON d.id = e.department_id
    GROUP BY d.id, d.name
) dept_stats
WHERE dept_stats.emp_count > (
    SELECT AVG(emp_count)
    FROM (
        SELECT COUNT(e2.id) as emp_count
        FROM departments d2
        LEFT JOIN employees e2 ON d2.id = e2.department_id
        GROUP BY d2.id
    ) averages
);

-- 9. Subqueries with EXISTS/NOT EXISTS
-- Find departments that have employees
SELECT name
FROM departments d
WHERE EXISTS (
    SELECT 1 
    FROM employees e 
    WHERE e.department_id = d.id
);

-- Find departments with no employees
SELECT name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 
    FROM employees e 
    WHERE e.department_id = d.id
);

-- Find employees working on projects
SELECT name
FROM employees e
WHERE EXISTS (
    SELECT 1 
    FROM employee_projects ep 
    WHERE ep.employee_id = e.id
);

-- 10. Subqueries with ALL/ANY/SOME
-- Find employees with salary higher than ALL employees in Marketing
SELECT name, salary
FROM employees
WHERE salary > ALL (
    SELECT salary 
    FROM employees e
    JOIN departments d ON e.department_id = d.id
    WHERE d.name = 'Marketing'
);

-- Find employees with salary higher than ANY employee in Engineering
SELECT name, salary
FROM employees
WHERE salary > ANY (
    SELECT salary 
    FROM employees e
    JOIN departments d ON e.department_id = d.id
    WHERE d.name = 'Engineering'
);

-- 11. Nested Subqueries
-- Find employees in departments with budgets higher than average, 
-- who also work on projects with more than 70 hours
SELECT e.name, e.salary
FROM employees e
WHERE e.department_id IN (
    SELECT d.id
    FROM departments d
    WHERE d.budget > (SELECT AVG(budget) FROM departments)
)
AND e.id IN (
    SELECT ep.employee_id
    FROM employee_projects ep
    WHERE ep.hours_worked > 70
);

-- 12. Subqueries with Aggregation
-- Find departments where average salary is in top 2
SELECT d.name, dept_avg.avg_salary
FROM (
    SELECT department_id, AVG(salary) as avg_salary
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id
) dept_avg
JOIN departments d ON dept_avg.department_id = d.id
WHERE dept_avg.avg_salary IN (
    SELECT avg_salary
    FROM (
        SELECT AVG(salary) as avg_salary
        FROM employees
        WHERE department_id IS NOT NULL
        GROUP BY department_id
        ORDER BY AVG(salary) DESC
        LIMIT 2
    ) top_salaries
);

-- 13. Subqueries for Data Modification
-- Update salaries of employees in departments with below-average budgets
UPDATE employees
SET salary = salary * 1.05
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE budget < (SELECT AVG(budget) FROM departments)
);

-- Delete employees who haven't worked on any projects
DELETE FROM employees
WHERE id NOT IN (
    SELECT DISTINCT employee_id
    FROM employee_projects
    WHERE employee_id IS NOT NULL
);

-- 14. Common Table Expressions (CTE) vs Subqueries
-- Using subquery
SELECT e.name, e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Equivalent using CTE (more readable for complex cases)
WITH avg_salary AS (
    SELECT AVG(salary) as avg_val
    FROM employees
)
SELECT e.name, e.salary
FROM employees e
CROSS JOIN avg_salary a
WHERE e.salary > a.avg_val;

-- Clean up (uncomment if needed)
-- DROP TABLE IF EXISTS employee_projects, projects, employees, departments;