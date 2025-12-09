-- PostgreSQL Common Table Expressions (CTEs) Examples
-- This file demonstrates various CTE techniques in PostgreSQL

-- Create sample tables for demonstration
DROP TABLE IF EXISTS employees CASCADE;
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INTEGER REFERENCES employees(id)
);

DROP TABLE IF EXISTS sales CASCADE;
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id),
    sale_amount DECIMAL(10,2),
    sale_date DATE
);

DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    cost DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO employees (name, department, salary, hire_date, manager_id) VALUES
('CEO John', 'Executive', 150000.00, '2020-01-01', NULL),
('Sarah Manager', 'Engineering', 120000.00, '2020-02-01', 1),
('Mike Developer', 'Engineering', 90000.00, '2020-03-01', 2),
('Lisa Developer', 'Engineering', 95000.00, '2020-04-01', 2),
('Tom Manager', 'Marketing', 110000.00, '2020-02-15', 1),
('Amy Specialist', 'Marketing', 75000.00, '2020-03-15', 5),
('Bob Manager', 'Sales', 100000.00, '2020-02-10', 1),
('Carol Rep', 'Sales', 65000.00, '2020-04-10', 7),
('Dave Rep', 'Sales', 70000.00, '2020-05-10', 7);

INSERT INTO sales (employee_id, sale_amount, sale_date) VALUES
(7, 15000.00, '2023-01-15'),
(7, 20000.00, '2023-02-20'),
(8, 12000.00, '2023-01-25'),
(8, 18000.00, '2023-03-10'),
(9, 25000.00, '2023-02-05'),
(9, 22000.00, '2023-03-15');

INSERT INTO products (name, category, price, cost) VALUES
('Laptop', 'Electronics', 1200.00, 800.00),
('Smartphone', 'Electronics', 800.00, 500.00),
('Tablet', 'Electronics', 500.00, 300.00),
('Desk Chair', 'Furniture', 200.00, 100.00),
('Office Desk', 'Furniture', 400.00, 250.00);

-- 1. Basic CTE (Non-Recursive)
WITH department_stats AS (
    SELECT 
        department,
        COUNT(*) as employee_count,
        AVG(salary) as avg_salary,
        MAX(salary) as max_salary
    FROM employees
    GROUP BY department
)
SELECT 
    department,
    employee_count,
    ROUND(avg_salary, 2) as average_salary,
    max_salary
FROM department_stats
ORDER BY average_salary DESC;

-- 2. Multiple CTEs in One Query
WITH high_earners AS (
    SELECT id, name, department, salary
    FROM employees
    WHERE salary > 80000
),
dept_counts AS (
    SELECT department, COUNT(*) as total_employees
    FROM employees
    GROUP BY department
)
SELECT 
    he.name,
    he.department,
    he.salary,
    dc.total_employees,
    ROUND(he.salary * 100.0 / AVG(he.salary) OVER (PARTITION BY he.department), 2) as salary_percent_of_dept_avg
FROM high_earners he
JOIN dept_counts dc ON he.department = dc.department
ORDER BY he.department, he.salary DESC;

-- 3. CTE with Joins and Aggregations
WITH employee_sales AS (
    SELECT 
        e.id,
        e.name,
        e.department,
        COALESCE(SUM(s.sale_amount), 0) as total_sales,
        COUNT(s.id) as sales_count
    FROM employees e
    LEFT JOIN sales s ON e.id = s.employee_id
    GROUP BY e.id, e.name, e.department
),
performance_metrics AS (
    SELECT 
        *,
        CASE 
            WHEN sales_count > 2 THEN 'High Performer'
            WHEN sales_count > 0 THEN 'Active'
            ELSE 'Inactive'
        END as performance_level
    FROM employee_sales
)
SELECT 
    name,
    department,
    total_sales,
    sales_count,
    performance_level
FROM performance_metrics
ORDER BY total_sales DESC;

-- 4. Recursive CTE - Organizational Hierarchy
WITH RECURSIVE org_hierarchy AS (
    -- Base case: Top-level managers (no manager)
    SELECT 
        id,
        name,
        department,
        manager_id,
        1 as level,
        CAST(name AS VARCHAR(1000)) as hierarchy_path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: Employees under managers
    SELECT 
        e.id,
        e.name,
        e.department,
        e.manager_id,
        oh.level + 1,
        CAST(oh.hierarchy_path || ' -> ' || e.name AS VARCHAR(1000))
    FROM employees e
    JOIN org_hierarchy oh ON e.manager_id = oh.id
)
SELECT 
    level,
    hierarchy_path,
    department
FROM org_hierarchy
ORDER BY level, hierarchy_path;

-- 5. Recursive CTE - Date Series Generation
WITH RECURSIVE date_series AS (
    SELECT 
        DATE('2023-01-01') as sale_date,
        1 as day_counter
    
    UNION ALL
    
    SELECT 
        sale_date + INTERVAL '1 day',
        day_counter + 1
    FROM date_series
    WHERE day_counter < 30
)
SELECT 
    ds.sale_date,
    COUNT(s.id) as sales_count,
    COALESCE(SUM(s.sale_amount), 0) as daily_revenue
FROM date_series ds
LEFT JOIN sales s ON ds.sale_date = s.sale_date
GROUP BY ds.sale_date
ORDER BY ds.sale_date;

-- 6. CTE for Complex Calculations
WITH sales_summary AS (
    SELECT 
        e.department,
        e.name as employee_name,
        SUM(s.sale_amount) as total_sales,
        COUNT(s.id) as sales_count,
        AVG(s.sale_amount) as avg_sale
    FROM employees e
    JOIN sales s ON e.id = s.employee_id
    GROUP BY e.department, e.name
),
department_totals AS (
    SELECT 
        department,
        SUM(total_sales) as dept_total_sales,
        AVG(total_sales) as dept_avg_sales
    FROM sales_summary
    GROUP BY department
)
SELECT 
    ss.department,
    ss.employee_name,
    ss.total_sales,
    ss.sales_count,
    ROUND(ss.avg_sale, 2) as average_sale,
    dt.dept_total_sales,
    ROUND(ss.total_sales * 100.0 / dt.dept_total_sales, 2) as percent_of_dept_total
FROM sales_summary ss
JOIN department_totals dt ON ss.department = dt.department
ORDER BY ss.department, ss.total_sales DESC;

-- 7. CTE with Window Functions
WITH ranked_employees AS (
    SELECT 
        name,
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank,
        RANK() OVER (ORDER BY salary DESC) as overall_rank,
        DENSE_RANK() OVER (ORDER BY salary DESC) as dense_overall_rank
    FROM employees
)
SELECT 
    name,
    department,
    salary,
    dept_rank,
    overall_rank,
    dense_overall_rank
FROM ranked_employees
WHERE dept_rank <= 2
ORDER BY department, dept_rank;

-- 8. Materialized CTE (PostgreSQL 12+)
-- Note: This is a PostgreSQL 12+ feature that materializes the CTE result
WITH materialized_cte AS MATERIALIZED (
    SELECT 
        e.name,
        e.department,
        e.salary,
        COUNT(s.id) as sales_count,
        COALESCE(SUM(s.sale_amount), 0) as total_sales
    FROM employees e
    LEFT JOIN sales s ON e.id = s.employee_id
    GROUP BY e.id, e.name, e.department, e.salary
)
SELECT 
    name,
    department,
    salary,
    sales_count,
    total_sales,
    ROUND(COALESCE(total_sales / NULLIF(sales_count, 0), 0), 2) as avg_sale_per_transaction
FROM materialized_cte
ORDER BY total_sales DESC;

-- 9. CTE for Data Cleaning and Transformation
WITH cleaned_data AS (
    SELECT 
        id,
        TRIM(UPPER(name)) as clean_name,
        INITCAP(TRIM(department)) as clean_department,
        ROUND(salary, 2) as rounded_salary,
        hire_date
    FROM employees
    WHERE name IS NOT NULL AND department IS NOT NULL
),
enriched_data AS (
    SELECT 
        *,
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) as years_employed,
        CASE 
            WHEN salary > 100000 THEN 'Senior'
            WHEN salary > 70000 THEN 'Mid-level'
            ELSE 'Junior'
        END as pay_grade
    FROM cleaned_data
)
SELECT 
    clean_name,
    clean_department,
    rounded_salary,
    years_employed,
    pay_grade
FROM enriched_data
ORDER BY rounded_salary DESC;

-- 10. Nested CTEs
WITH outer_cte AS (
    WITH inner_cte AS (
        SELECT 
            category,
            COUNT(*) as product_count,
            AVG(price) as avg_price
        FROM products
        GROUP BY category
    )
    SELECT 
        category,
        product_count,
        ROUND(avg_price, 2) as average_price,
        avg_price * product_count as total_category_value
    FROM inner_cte
)
SELECT 
    category,
    product_count,
    average_price,
    total_category_value,
    ROUND(total_category_value * 100.0 / SUM(total_category_value) OVER(), 2) as pct_of_total_value
FROM outer_cte
ORDER BY total_category_value DESC;

-- 11. CTE with Conditional Logic
WITH sales_performance AS (
    SELECT 
        e.name,
        e.department,
        COUNT(s.id) as sales_count,
        SUM(s.sale_amount) as total_sales,
        AVG(s.sale_amount) as avg_sale
    FROM employees e
    LEFT JOIN sales s ON e.id = s.employee_id
    GROUP BY e.id, e.name, e.department
),
performance_tiers AS (
    SELECT 
        *,
        CASE 
            WHEN total_sales > 30000 THEN 'Elite'
            WHEN total_sales > 15000 THEN 'High'
            WHEN total_sales > 5000 THEN 'Medium'
            ELSE 'Low'
        END as performance_tier,
        CASE 
            WHEN sales_count = 0 THEN 'No Sales'
            WHEN avg_sale > 20000 THEN 'High Value'
            WHEN avg_sale > 10000 THEN 'Medium Value'
            ELSE 'Standard'
        END as sale_type
    FROM sales_performance
)
SELECT 
    name,
    department,
    sales_count,
    total_sales,
    ROUND(avg_sale, 2) as average_sale,
    performance_tier,
    sale_type
FROM performance_tiers
ORDER BY total_sales DESC NULLS LAST;

-- 12. CTE for Reporting and Dashboards
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', sale_date) as sale_month,
        COUNT(*) as transactions,
        SUM(sale_amount) as revenue,
        AVG(sale_amount) as avg_transaction_value
    FROM sales
    GROUP BY DATE_TRUNC('month', sale_date)
),
monthly_growth AS (
    SELECT 
        *,
        LAG(revenue) OVER (ORDER BY sale_month) as prev_month_revenue,
        ROUND(
            (revenue - LAG(revenue) OVER (ORDER BY sale_month)) * 100.0 / 
            NULLIF(LAG(revenue) OVER (ORDER BY sale_month), 0), 
            2
        ) as growth_percentage
    FROM monthly_sales
)
SELECT 
    TO_CHAR(sale_month, 'YYYY-MM') as month,
    transactions,
    revenue,
    ROUND(avg_transaction_value, 2) as avg_transaction_value,
    COALESCE(growth_percentage, 0) as growth_percentage
FROM monthly_growth
ORDER BY sale_month;