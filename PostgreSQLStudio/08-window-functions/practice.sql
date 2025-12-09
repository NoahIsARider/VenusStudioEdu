-- PostgreSQL Window Functions Practice Exercises
-- Complete the following exercises to practice window functions in PostgreSQL

-- Create sample tables for exercises
DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INTEGER
);

DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_id INTEGER,
    customer_id INTEGER,
    order_date DATE,
    quantity INTEGER,
    total_amount DECIMAL(10,2)
);

DROP TABLE IF EXISTS employees CASCADE;
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    hire_date DATE,
    salary DECIMAL(10,2),
    manager_id INTEGER
);

-- Insert sample data
INSERT INTO products (name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 1200.00, 50),
('Smartphone', 'Electronics', 800.00, 100),
('Tablet', 'Electronics', 500.00, 75),
('Desk Chair', 'Furniture', 200.00, 30),
('Office Desk', 'Furniture', 400.00, 20),
('Coffee Maker', 'Appliances', 100.00, 40),
('Blender', 'Appliances', 80.00, 60);

INSERT INTO orders (product_id, customer_id, order_date, quantity, total_amount) VALUES
(1, 101, '2023-01-15', 2, 2400.00),
(2, 102, '2023-01-20', 1, 800.00),
(3, 103, '2023-02-01', 3, 1500.00),
(1, 104, '2023-02-10', 1, 1200.00),
(4, 105, '2023-02-15', 2, 400.00),
(5, 106, '2023-03-01', 1, 400.00),
(2, 107, '2023-03-05', 2, 1600.00),
(6, 108, '2023-03-10', 1, 100.00),
(7, 109, '2023-03-15', 3, 240.00),
(3, 110, '2023-03-20', 1, 500.00);

INSERT INTO employees (name, department, hire_date, salary, manager_id) VALUES
('John CEO', 'Executive', '2020-01-01', 150000.00, NULL),
('Sarah Manager', 'Engineering', '2020-02-01', 120000.00, 1),
('Mike Developer', 'Engineering', '2020-03-01', 90000.00, 2),
('Lisa Developer', 'Engineering', '2020-04-01', 95000.00, 2),
('Tom Manager', 'Marketing', '2020-02-15', 110000.00, 1),
('Amy Specialist', 'Marketing', '2020-03-15', 75000.00, 5),
('Bob Manager', 'Sales', '2020-02-10', 100000.00, 1),
('Carol Rep', 'Sales', '2020-04-10', 65000.00, 7),
('Dave Rep', 'Sales', '2020-05-10', 70000.00, 7);

-- Exercise 1: Basic Ranking
-- Write a query to show products ranked by price within each category
-- Include: product name, category, price, and rank within category

-- Your solution here:

-- Exercise 2: Running Totals
-- Calculate running totals of order amounts ordered by date
-- Include: order date, amount, and running total

-- Your solution here:

-- Exercise 3: Comparative Analysis
-- Show each employee's salary compared to the average salary in their department
-- Include: employee name, department, salary, department avg, and difference

-- Your solution here:

-- Exercise 4: Time-based Analysis
-- For each product, show the current order amount and the previous order amount
-- Include: product name, order date, amount, and previous amount

-- Your solution here:

-- Exercise 5: Percentiles and Distribution
-- Calculate the percentile rank of each product's price within its category
-- Include: product name, category, price, and percentile rank

-- Your solution here:

-- Exercise 6: Moving Averages
-- Calculate a 3-month moving average of total sales per month
-- Include: month, total sales, and moving average

-- Your solution here:

-- Exercise 7: Top Performers
-- Identify the top 2 salespeople in each department by total sales
-- Include: employee name, department, total sales, and rank

-- Your solution here:

-- Exercise 8: Stock Analysis
-- Show products with their stock rank within category and overall
-- Include: product name, category, stock quantity, category rank, overall rank

-- Your solution here:

-- Exercise 9: Growth Analysis
-- Calculate month-over-month growth percentage for each product category
-- Include: category, month, sales, previous month sales, and growth percentage

-- Your solution here:

-- Exercise 10: Complex Hierarchical Analysis
-- Show employee hierarchy with cumulative salary totals by level
-- Include: employee name, level, manager name, and cumulative salary at level

-- Your solution here:

-- Bonus Exercise:
-- Design a comprehensive business intelligence dashboard query that combines:
-- 1. Customer lifetime value calculations with percentiles
-- 2. Product performance metrics with trend analysis
-- 3. Employee productivity measures with benchmarking
-- 4. Inventory turnover rates with forecasting
-- 5. Market basket analysis with association rules