-- PostgreSQL Grouping Sets Examples
-- This file demonstrates various grouping sets techniques in PostgreSQL

-- Create sample tables for demonstration
DROP TABLE IF EXISTS sales CASCADE;
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    product_category VARCHAR(50),
    region VARCHAR(50),
    salesperson VARCHAR(100),
    sale_date DATE,
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
    salary DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO sales (product_category, region, salesperson, sale_date, amount, quantity) VALUES
('Electronics', 'North', 'Alice', '2023-01-15', 1500.00, 2),
('Electronics', 'North', 'Bob', '2023-01-20', 2000.00, 3),
('Electronics', 'South', 'Charlie', '2023-02-01', 1800.00, 2),
('Electronics', 'South', 'Diana', '2023-02-10', 2200.00, 4),
('Clothing', 'North', 'Alice', '2023-02-15', 800.00, 5),
('Clothing', 'North', 'Bob', '2023-03-01', 1200.00, 8),
('Clothing', 'South', 'Charlie', '2023-03-05', 900.00, 6),
('Clothing', 'South', 'Diana', '2023-03-10', 1100.00, 7),
('Home Goods', 'North', 'Alice', '2023-03-15', 3000.00, 3),
('Home Goods', 'North', 'Bob', '2023-03-20', 2500.00, 2),
('Home Goods', 'South', 'Charlie', '2023-03-25', 3200.00, 4),
('Home Goods', 'South', 'Diana', '2023-03-30', 2800.00, 3);

INSERT INTO employees (name, department, position, hire_date, salary) VALUES
('John Manager', 'Sales', 'Manager', '2020-01-15', 80000.00),
('Jane Specialist', 'Sales', 'Specialist', '2020-02-01', 60000.00),
('Mike Manager', 'Marketing', 'Manager', '2020-01-20', 85000.00),
('Sarah Specialist', 'Marketing', 'Specialist', '2020-03-01', 55000.00),
('Tom Manager', 'Engineering', 'Manager', '2020-01-10', 90000.00),
('Lisa Developer', 'Engineering', 'Developer', '2020-02-15', 75000.00),
('Bob Analyst', 'Finance', 'Analyst', '2020-03-10', 65000.00),
('Amy Manager', 'Finance', 'Manager', '2020-01-25', 82000.00);

-- 1. Basic GROUP BY
SELECT 
    product_category,
    SUM(amount) as total_sales,
    COUNT(*) as transaction_count
FROM sales
GROUP BY product_category;

-- 2. GROUPING SETS - Multiple Groupings in One Query
SELECT 
    product_category,
    region,
    SUM(amount) as total_sales,
    COUNT(*) as transaction_count
FROM sales
GROUP BY GROUPING SETS (
    (product_category),
    (region),
    ()
);

-- 3. ROLLUP - Hierarchical Grouping
SELECT 
    product_category,
    region,
    salesperson,
    SUM(amount) as total_sales
FROM sales
GROUP BY ROLLUP (product_category, region, salesperson)
ORDER BY product_category, region, salesperson;

-- 4. CUBE - All Possible Combinations
SELECT 
    product_category,
    region,
    SUM(amount) as total_sales,
    COUNT(*) as transaction_count
FROM sales
GROUP BY CUBE (product_category, region)
ORDER BY product_category, region;

-- 5. Complex GROUPING SETS
SELECT 
    product_category,
    region,
    salesperson,
    SUM(amount) as total_sales,
    AVG(amount) as avg_sale,
    COUNT(*) as transaction_count
FROM sales
GROUP BY GROUPING SETS (
    (product_category, region),
    (product_category, salesperson),
    (region, salesperson),
    (product_category),
    (region),
    (salesperson),
    ()
)
ORDER BY product_category, region, salesperson;

-- 6. Using GROUPING() Function
SELECT 
    product_category,
    region,
    GROUPING(product_category) as cat_grouping,
    GROUPING(region) as reg_grouping,
    SUM(amount) as total_sales
FROM sales
GROUP BY CUBE (product_category, region)
ORDER BY product_category, region;

-- 7. GROUPING_ID() Function
SELECT 
    product_category,
    region,
    salesperson,
    GROUPING_ID(product_category, region, salesperson) as grouping_id,
    SUM(amount) as total_sales
FROM sales
GROUP BY GROUPING SETS (
    (product_category, region, salesperson),
    (product_category, region),
    (product_category),
    ()
)
ORDER BY grouping_id;

-- 8. Combining Regular GROUP BY with GROUPING SETS
SELECT 
    EXTRACT(YEAR FROM sale_date) as sale_year,
    product_category,
    region,
    SUM(amount) as total_sales
FROM sales
GROUP BY 
    EXTRACT(YEAR FROM sale_date),
    GROUPING SETS ((product_category), (region), ());

-- 9. GROUPING SETS with HAVING Clause
SELECT 
    product_category,
    region,
    SUM(amount) as total_sales
FROM sales
GROUP BY GROUPING SETS ((product_category), (region))
HAVING SUM(amount) > 2000
ORDER BY total_sales DESC;

-- 10. Practical Business Intelligence Example
-- Sales Analysis Dashboard with Multiple Dimensions
SELECT 
    COALESCE(product_category, 'All Categories') as category,
    COALESCE(region, 'All Regions') as region,
    COALESCE(salesperson, 'All Salespeople') as salesperson,
    GROUPING_ID(product_category, region, salesperson) as group_level,
    SUM(amount) as total_sales,
    COUNT(*) as transaction_count,
    AVG(amount) as avg_transaction_value,
    MAX(amount) as largest_sale,
    MIN(sale_date) as first_sale_date,
    MAX(sale_date) as last_sale_date
FROM sales
GROUP BY GROUPING SETS (
    (), -- Grand total
    (product_category), -- By category
    (region), -- By region
    (salesperson), -- By salesperson
    (product_category, region), -- Category-Region combination
    (product_category, salesperson), -- Category-Salesperson combination
    (region, salesperson) -- Region-Salesperson combination
)
ORDER BY group_level, total_sales DESC;

-- 11. Multi-dimensional Employee Analysis
SELECT 
    COALESCE(department, 'All Departments') as department,
    COALESCE(position, 'All Positions') as position,
    GROUPING_ID(department, position) as group_level,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    SUM(salary) as total_payroll,
    MIN(hire_date) as earliest_hire,
    MAX(hire_date) as latest_hire
FROM employees
GROUP BY GROUPING SETS (
    (), -- Overall company stats
    (department), -- By department
    (position), -- By position
    (department, position) -- Department-Position combination
)
ORDER BY group_level, department, position;

-- 12. Time-based Grouping Sets
SELECT 
    EXTRACT(YEAR FROM sale_date) as sale_year,
    EXTRACT(MONTH FROM sale_date) as sale_month,
    product_category,
    SUM(amount) as monthly_sales,
    COUNT(*) as transactions
FROM sales
GROUP BY GROUPING SETS (
    (EXTRACT(YEAR FROM sale_date)), -- Yearly totals
    (EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)), -- Monthly totals
    (product_category), -- Category totals
    (EXTRACT(YEAR FROM sale_date), product_category) -- Yearly by category
)
ORDER BY sale_year, sale_month, product_category;

-- 13. Advanced Grouping with Calculated Fields
SELECT 
    CASE 
        WHEN GROUPING(product_category) = 1 THEN 'All Categories'
        ELSE product_category 
    END as category,
    CASE 
        WHEN GROUPING(region) = 1 THEN 'All Regions'
        ELSE region 
    END as region,
    SUM(amount) as total_sales,
    ROUND(AVG(amount), 2) as avg_sale,
    COUNT(*) as transaction_count,
    ROUND(SUM(amount) * 100.0 / SUM(SUM(amount)) OVER (), 2) as pct_of_total
FROM sales
GROUP BY CUBE (product_category, region)
ORDER BY total_sales DESC;

-- 14. Performance Comparison: GROUP BY vs GROUPING SETS
-- Traditional approach with multiple queries
-- Query 1: By category
SELECT 'category' as dimension, product_category as value, SUM(amount) as total_sales
FROM sales GROUP BY product_category
UNION ALL
-- Query 2: By region
SELECT 'region' as dimension, region as value, SUM(amount) as total_sales
FROM sales GROUP BY region
UNION ALL
-- Query 3: Total
SELECT 'total' as dimension, 'All' as value, SUM(amount) as total_sales
FROM sales
ORDER BY dimension, total_sales DESC;

-- Single query with GROUPING SETS
SELECT 
    CASE 
        WHEN GROUPING(product_category) = 0 THEN 'category'
        WHEN GROUPING(region) = 0 THEN 'region'
        ELSE 'total'
    END as dimension,
    COALESCE(product_category, region, 'All') as value,
    SUM(amount) as total_sales
FROM sales
GROUP BY GROUPING SETS ((product_category), (region), ())
ORDER BY dimension, total_sales DESC;

-- 15. Handling NULL Values in Grouping Sets
SELECT 
    COALESCE(product_category, 'Unknown Category') as category,
    COALESCE(region, 'Unknown Region') as region,
    SUM(amount) as total_sales
FROM sales
GROUP BY CUBE (product_category, region)
ORDER BY total_sales DESC;