-- PostgreSQL Common Table Expressions Practice Exercises
-- Complete the following exercises to practice CTEs in PostgreSQL

-- Create sample tables for exercises
DROP TABLE IF EXISTS customers CASCADE;
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE,
    tier VARCHAR(20)
);

DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
);

DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    cost DECIMAL(10,2)
);

DROP TABLE IF EXISTS order_items CASCADE;
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER,
    unit_price DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO customers (name, email, signup_date, tier) VALUES
('Alice Johnson', 'alice@example.com', '2022-01-15', 'Premium'),
('Bob Smith', 'bob@example.com', '2022-02-20', 'Standard'),
('Charlie Brown', 'charlie@example.com', '2022-03-10', 'Premium'),
('Diana Wilson', 'diana@example.com', '2022-01-30', 'Standard'),
('Eve Davis', 'eve@example.com', '2022-04-05', 'VIP'),
('Frank Miller', 'frank@example.com', '2022-02-28', 'Standard'),
('Grace Lee', 'grace@example.com', '2022-03-20', 'Premium'),
('Henry Taylor', 'henry@example.com', '2022-01-25', 'Standard');

INSERT INTO products (name, category, price, cost) VALUES
('Laptop', 'Electronics', 1200.00, 800.00),
('Smartphone', 'Electronics', 800.00, 500.00),
('Tablet', 'Electronics', 500.00, 300.00),
('Desk Chair', 'Furniture', 200.00, 100.00),
('Office Desk', 'Furniture', 400.00, 250.00),
('Coffee Maker', 'Appliances', 100.00, 60.00),
('Blender', 'Appliances', 80.00, 40.00);

INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2023-01-15', 1500.00, 'Completed'),
(2, '2023-01-20', 800.00, 'Completed'),
(3, '2023-02-01', 2200.00, 'Completed'),
(1, '2023-02-10', 1200.00, 'Completed'),
(4, '2023-02-15', 400.00, 'Completed'),
(5, '2023-03-01', 400.00, 'Completed'),
(2, '2023-03-05', 1600.00, 'Completed'),
(6, '2023-03-10', 100.00, 'Completed'),
(7, '2023-03-15', 240.00, 'Completed'),
(3, '2023-03-20', 500.00, 'Pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00),
(1, 6, 3, 100.00),
(2, 2, 1, 800.00),
(3, 1, 1, 1200.00),
(3, 2, 1, 800.00),
(3, 3, 2, 500.00),
(4, 1, 1, 1200.00),
(5, 4, 2, 200.00),
(6, 5, 1, 400.00),
(7, 2, 2, 800.00),
(8, 6, 1, 100.00),
(9, 6, 2, 100.00),
(9, 7, 1, 80.00),
(10, 3, 1, 500.00);

-- Exercise 1: Customer Segmentation Analysis
-- Create a customer segmentation report showing:
-- 1. Total customers by tier
-- 2. Average order value by tier
-- 3. Lifetime value calculations
-- 4. Tier migration opportunities

-- Your solution here:

-- Exercise 2: Product Performance Dashboard
-- Build a product performance dashboard with:
-- 1. Revenue by product category
-- 2. Best selling products
-- 3. Profit margins
-- 4. Inventory turnover rates

-- Your solution here:

-- Exercise 3: Order Fulfillment Analysis
-- Analyze order fulfillment with:
-- 1. Order processing times
-- 2. Status distribution
-- 3. Customer satisfaction metrics
-- 4. Bottleneck identification

-- Your solution here:

-- Exercise 4: Recursive Category Hierarchy
-- Create a recursive CTE to handle product category hierarchies:
-- 1. Support nested categories
-- 2. Calculate category paths
-- 3. Aggregate metrics across category trees
-- 4. Handle circular references

-- Your solution here:

-- Exercise 5: Time Series Forecasting
-- Implement time series analysis with CTEs:
-- 1. Sales trends by month
-- 2. Growth rate calculations
-- 3. Seasonal pattern identification
-- 4. Future sales projections

-- Your solution here:

-- Exercise 6: Complex Business Logic Implementation
-- Model complex business rules using CTEs:
-- 1. Discount eligibility calculations
-- 2. Loyalty program point accrual
-- 3. Cross-selling opportunity identification
-- 4. Churn prediction models

-- Your solution here:

-- Exercise 7: Data Quality Assessment
-- Assess data quality using CTEs:
-- 1. Duplicate detection
-- 2. Inconsistency identification
-- 3. Completeness metrics
-- 4. Anomaly detection

-- Your solution here:

-- Exercise 8: Multi-dimensional Performance Analysis
-- Create a comprehensive performance analysis:
-- 1. Regional performance comparisons
-- 2. Team productivity metrics
-- 3. Individual contributor analysis
-- 4. Goal achievement tracking

-- Your solution here:

-- Exercise 9: Dynamic Reporting Framework
-- Build a dynamic reporting framework:
-- 1. Parameter-driven reports
-- 2. Customizable metrics
-- 3. Ad-hoc analysis capabilities
-- 4. Export-ready formats

-- Your solution here:

-- Exercise 10: Advanced Analytics Pipeline
-- Implement an advanced analytics pipeline:
-- 1. Data preprocessing and cleaning
-- 2. Feature engineering
-- 3. Statistical analysis
-- 4. Insight generation

-- Your solution here:

-- Bonus Exercise:
-- Design a comprehensive business intelligence platform using CTEs that includes:
-- 1. Real-time operational dashboards
-- 2. Predictive analytics models
-- 3. Interactive drill-down capabilities
-- 4. Automated insight generation
-- 5. Cross-functional data integration