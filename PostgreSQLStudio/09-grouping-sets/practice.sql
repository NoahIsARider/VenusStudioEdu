-- PostgreSQL Grouping Sets Practice Exercises
-- Complete the following exercises to practice grouping sets in PostgreSQL

-- Create sample tables for exercises
DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    product_category VARCHAR(50),
    region VARCHAR(50),
    order_date DATE,
    amount DECIMAL(10,2),
    quantity INTEGER
);

DROP TABLE IF EXISTS employees CASCADE;
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    hire_date DATE,
    salary DECIMAL(10,2),
    office_location VARCHAR(50)
);

DROP TABLE IF EXISTS inventory CASCADE;
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    supplier VARCHAR(100),
    stock_quantity INTEGER,
    unit_price DECIMAL(10,2),
    reorder_level INTEGER
);

-- Insert sample data
INSERT INTO orders (customer_id, product_category, region, order_date, amount, quantity) VALUES
(101, 'Electronics', 'North', '2023-01-15', 1500.00, 2),
(102, 'Electronics', 'South', '2023-01-20', 2000.00, 3),
(103, 'Clothing', 'North', '2023-02-01', 800.00, 5),
(104, 'Clothing', 'South', '2023-02-10', 1200.00, 8),
(105, 'Home Goods', 'North', '2023-02-15', 3000.00, 3),
(106, 'Home Goods', 'South', '2023-03-01', 2500.00, 2),
(107, 'Electronics', 'East', '2023-03-05', 1800.00, 2),
(108, 'Clothing', 'East', '2023-03-10', 900.00, 6),
(109, 'Home Goods', 'West', '2023-03-15', 3200.00, 4),
(110, 'Electronics', 'West', '2023-03-20', 2200.00, 4);

INSERT INTO employees (name, department, position, hire_date, salary, office_location) VALUES
('Alice Manager', 'Sales', 'Manager', '2020-01-15', 80000.00, 'New York'),
('Bob Specialist', 'Sales', 'Specialist', '2020-02-01', 60000.00, 'New York'),
('Charlie Manager', 'Marketing', 'Manager', '2020-01-20', 85000.00, 'London'),
('Diana Specialist', 'Marketing', 'Specialist', '2020-03-01', 55000.00, 'London'),
('Eve Manager', 'Engineering', 'Manager', '2020-01-10', 90000.00, 'San Francisco'),
('Frank Developer', 'Engineering', 'Developer', '2020-02-15', 75000.00, 'San Francisco'),
('Grace Analyst', 'Finance', 'Analyst', '2020-03-10', 65000.00, 'Tokyo'),
('Henry Manager', 'Finance', 'Manager', '2020-01-25', 82000.00, 'Tokyo');

INSERT INTO inventory (product_name, category, supplier, stock_quantity, unit_price, reorder_level) VALUES
('Laptop', 'Electronics', 'TechCorp', 50, 1200.00, 10),
('Smartphone', 'Electronics', 'MobileInc', 100, 800.00, 20),
('Desk Chair', 'Furniture', 'OfficePlus', 30, 200.00, 5),
('Office Desk', 'Furniture', 'OfficePlus', 20, 400.00, 3),
('Coffee Maker', 'Appliances', 'HomeGoods', 40, 100.00, 8),
('Blender', 'Appliances', 'HomeGoods', 60, 80.00, 10);

-- Exercise 1: Sales Analysis Dashboard
-- Create a comprehensive sales report showing totals by:
-- 1. Product category
-- 2. Region
-- 3. Category-Region combination
-- 4. Overall total
-- Include: total sales amount, transaction count, average transaction value

-- Your solution here:

-- Exercise 2: Employee Headcount Report
-- Generate a report showing employee counts by:
-- 1. Department
-- 2. Office location
-- 3. Position
-- 4. Department-Location combination
-- 5. Overall total
-- Include: employee count, average salary, salary range

-- Your solution here:

-- Exercise 3: Inventory Analysis
-- Analyze inventory data showing:
-- 1. By category
-- 2. By supplier
-- 3. Category-Supplier combination
-- 4. Overall summary
-- Include: item count, total stock value, average unit price, low stock items count

-- Your solution here:

-- Exercise 4: Time-based Sales Analysis
-- Create a time-based analysis showing sales by:
-- 1. Year
-- 2. Quarter
-- 3. Month
-- 4. Year-Category combination
-- 5. Overall total
-- Include: total sales, transaction count, growth percentage

-- Your solution here:

-- Exercise 5: Multi-dimensional Customer Analysis
-- Assuming customer demographics data, create analysis by:
-- 1. Age group
-- 2. Gender
-- 3. Location
-- 4. Age-Gender combination
-- 5. Location-Gender combination
-- 6. Overall total

-- Your solution here:

-- Exercise 6: Performance Benchmarking
-- Compare actual performance against targets using grouping sets:
-- 1. By department
-- 2. By region
-- 3. By product line
-- 4. Overall company performance
-- Include: actual vs target variance, percentage achievement

-- Your solution here:

-- Exercise 7: Hierarchical Organization Structure
-- Analyze organizational data with hierarchical grouping:
-- 1. By executive level
-- 2. By department
-- 3. By team
-- 4. Overall organization
-- Include: employee count, cost center expenses, reporting structure

-- Your solution here:

-- Exercise 8: Financial Reporting Cube
-- Create a financial reporting cube with dimensions:
-- 1. Revenue streams
-- 2. Business units
-- 3. Geographic regions
-- 4. Time periods
-- 5. Various combinations for drill-down analysis

-- Your solution here:

-- Exercise 9: Marketing Campaign Effectiveness
-- Analyze marketing data by:
-- 1. Campaign type
-- 2. Channel
-- 3. Target demographic
-- 4. Campaign-Channel combination
-- 5. Overall effectiveness metrics

-- Your solution here:

-- Exercise 10: Supply Chain Analysis
-- Analyze supply chain metrics by:
-- 1. Supplier
-- 2. Product category
-- 3. Shipping method
-- 4. Destination region
-- 5. Various combinations for optimization

-- Your solution here:

-- Bonus Exercise:
-- Design a comprehensive business intelligence solution that combines:
-- 1. Real-time operational dashboards with ROLLUP hierarchies
-- 2. Predictive analytics with CUBE multidimensional analysis
-- 3. Interactive drill-through capabilities
-- 4. Automated exception reporting
-- 5. Cross-functional KPI integration