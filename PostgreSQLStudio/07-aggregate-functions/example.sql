-- PostgreSQL Aggregate Functions Example File
-- This file demonstrates various aggregate functions in PostgreSQL

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
    hire_date DATE,
    position VARCHAR(50)
);

-- Create sales table
CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER,
    amount DECIMAL(10,2),
    sale_date DATE
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- 2. Insert sample data
INSERT INTO departments (name, budget) VALUES
('Engineering', 500000.00),
('Marketing', 200000.00),
('Sales', 300000.00),
('HR', 150000.00);

INSERT INTO employees (name, department_id, salary, hire_date, position) VALUES
('Alice Johnson', 1, 75000.00, '2020-01-15', 'Software Engineer'),
('Bob Smith', 2, 65000.00, '2019-03-22', 'Marketing Specialist'),
('Charlie Brown', 3, 70000.00, '2021-07-10', 'Sales Representative'),
('Diana Prince', 1, 80000.00, '2018-11-05', 'Senior Engineer'),
('Eve Wilson', 3, 68000.00, '2020-05-30', 'Sales Representative'),
('Frank Miller', 1, 72000.00, '2021-02-20', 'Software Engineer'),
('Grace Lee', 2, 67000.00, '2020-09-15', 'Marketing Specialist'),
('Henry Ford', 3, 71000.00, '2019-12-01', 'Sales Manager');

INSERT INTO sales (employee_id, amount, sale_date) VALUES
(3, 1500.00, '2023-01-15'),
(3, 2200.00, '2023-01-20'),
(5, 1800.00, '2023-01-18'),
(3, 900.00, '2023-02-05'),
(5, 3100.00, '2023-02-10'),
(3, 1200.00, '2023-02-15'),
(7, 2500.00, '2023-01-25'),
(7, 1700.00, '2023-02-08');

INSERT INTO products (name, category, price) VALUES
('Laptop', 'Electronics', 999.99),
('Mouse', 'Electronics', 29.99),
('Keyboard', 'Electronics', 79.99),
('Desk Chair', 'Furniture', 199.99),
('Monitor', 'Electronics', 299.99),
('Bookshelf', 'Furniture', 149.99),
('Desk Lamp', 'Furniture', 39.99);

-- 3. Basic Aggregate Functions
-- COUNT - Count rows
SELECT COUNT(*) AS total_employees FROM employees;
SELECT COUNT(department_id) AS employees_with_departments FROM employees;
SELECT COUNT(DISTINCT department_id) AS unique_departments FROM employees;

-- SUM - Sum values
SELECT SUM(salary) AS total_salary_expense FROM employees;
SELECT SUM(amount) AS total_sales FROM sales;

-- AVG - Average values
SELECT AVG(salary) AS average_salary FROM employees;
SELECT AVG(amount) AS average_sale_amount FROM sales;

-- MIN/MAX - Minimum and maximum values
SELECT MIN(salary) AS lowest_salary, MAX(salary) AS highest_salary FROM employees;
SELECT MIN(amount) AS smallest_sale, MAX(amount) AS largest_sale FROM sales;

-- 4. Aggregate Functions with GROUP BY
-- Group by department
SELECT d.name AS department, 
       COUNT(e.id) AS employee_count,
       AVG(e.salary) AS average_salary,
       SUM(e.salary) AS total_salary
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name;

-- Group by position
SELECT position, 
       COUNT(*) AS count,
       AVG(salary) AS average_salary,
       MIN(salary) AS min_salary,
       MAX(salary) AS max_salary
FROM employees
GROUP BY position;

-- Group by category
SELECT category,
       COUNT(*) AS product_count,
       AVG(price) AS average_price,
       MIN(price) AS min_price,
       MAX(price) AS max_price
FROM products
GROUP BY category;

-- 5. Aggregate Functions with Filtering (HAVING)
-- Departments with more than 2 employees
SELECT d.name AS department, COUNT(e.id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name
HAVING COUNT(e.id) > 2;

-- Positions with average salary above 70000
SELECT position, AVG(salary) AS average_salary
FROM employees
GROUP BY position
HAVING AVG(salary) > 70000;

-- Categories with more than 2 products
SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING COUNT(*) > 2;

-- 6. Advanced Aggregate Functions
-- STRING_AGG - Concatenate values
SELECT department_id, STRING_AGG(name, ', ') AS employee_names
FROM employees
GROUP BY department_id;

-- ARRAY_AGG - Aggregate values into arrays
SELECT department_id, ARRAY_AGG(name) AS employee_names
FROM employees
GROUP BY department_id;

-- BOOL_AND/BOOL_OR - Boolean aggregates
-- Add a boolean column for demonstration
ALTER TABLE employees ADD COLUMN IF NOT EXISTS is_manager BOOLEAN DEFAULT FALSE;
UPDATE employees SET is_manager = TRUE WHERE position LIKE '%Manager%';

SELECT department_id, 
       BOOL_AND(is_manager) AS all_managers,
       BOOL_OR(is_manager) AS any_managers
FROM employees
GROUP BY department_id;

-- 7. Statistical Aggregate Functions
-- STDDEV - Standard deviation
SELECT STDDEV(salary) AS salary_stddev FROM employees;

-- VARIANCE - Variance
SELECT VARIANCE(salary) AS salary_variance FROM employees;

-- CORR - Correlation coefficient
-- Create a table with correlated data for demonstration
CREATE TABLE IF NOT EXISTS employee_experience (
    employee_id INTEGER,
    years_experience INTEGER,
    salary DECIMAL(10,2)
);

INSERT INTO employee_experience (employee_id, years_experience, salary) VALUES
(1, 3, 75000.00),
(2, 4, 65000.00),
(3, 2, 70000.00),
(4, 5, 80000.00),
(5, 3, 68000.00),
(6, 2, 72000.00),
(7, 3, 67000.00),
(8, 4, 71000.00);

SELECT CORR(years_experience, salary) AS experience_salary_correlation
FROM employee_experience;

-- 8. Ordered Aggregates
-- Create a table with time series data
CREATE TABLE IF NOT EXISTS daily_sales (
    sale_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO daily_sales (sale_date, amount) VALUES
('2023-01-01', 1000.00),
('2023-01-02', 1200.00),
('2023-01-03', 800.00),
('2023-01-04', 1500.00),
('2023-01-05', 1100.00);

-- Running sum
SELECT sale_date, amount,
       SUM(amount) OVER (ORDER BY sale_date) AS running_total
FROM daily_sales
ORDER BY sale_date;

-- Moving average (3-day window)
SELECT sale_date, amount,
       AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM daily_sales
ORDER BY sale_date;

-- 9. Custom Aggregate Functions
-- Using built-in aggregates with conditions
SELECT 
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE salary > 70000) AS high_earners,
    AVG(salary) FILTER (WHERE department_id = 1) AS engineering_avg_salary
FROM employees;

-- 10. GROUPING SETS, CUBE, ROLLUP
-- Sales by employee and month
CREATE TABLE IF NOT EXISTS monthly_sales (
    employee_id INTEGER,
    sale_month DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO monthly_sales (employee_id, sale_month, total_amount) VALUES
(3, '2023-01-01', 4600.00),
(5, '2023-01-01', 4900.00),
(7, '2023-01-01', 4200.00),
(3, '2023-02-01', 2100.00),
(5, '2023-02-01', 3100.00),
(7, '2023-02-01', 1700.00);

-- GROUPING SETS
SELECT employee_id, DATE_TRUNC('month', sale_month) AS month, SUM(total_amount) AS total_sales
FROM monthly_sales
GROUP BY GROUPING SETS ((employee_id), (DATE_TRUNC('month', sale_month)), ());

-- ROLLUP
SELECT employee_id, DATE_TRUNC('month', sale_month) AS month, SUM(total_amount) AS total_sales
FROM monthly_sales
GROUP BY ROLLUP (employee_id, DATE_TRUNC('month', sale_month));

-- 11. DISTINCT Aggregates
SELECT AVG(DISTINCT salary) AS distinct_avg_salary FROM employees;
SELECT COUNT(DISTINCT department_id) AS distinct_departments FROM employees;

-- 12. Aggregates with NULL Handling
-- Add some NULL values for demonstration
INSERT INTO employees (name, department_id, salary, hire_date, position) VALUES
('John Doe', NULL, NULL, '2022-01-01', 'Intern'),
('Jane Smith', 1, 50000.00, '2022-02-01', 'Junior Engineer');

-- Show how aggregates handle NULLs
SELECT 
    COUNT(*) AS count_all_rows,
    COUNT(salary) AS count_non_null_salaries,
    COUNT(DISTINCT salary) AS count_distinct_salaries,
    AVG(salary) AS avg_salary,
    SUM(salary) AS sum_salary
FROM employees;

-- Clean up (uncomment if needed)
-- DROP TABLE IF EXISTS monthly_sales, daily_sales, employee_experience, products, sales, employees, departments;