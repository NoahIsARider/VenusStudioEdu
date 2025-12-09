-- PostgreSQL Functions Practice Exercises
-- This file contains hands-on exercises for practicing PostgreSQL functions

-- Create sample tables for exercises
DROP TABLE IF EXISTS customers CASCADE;
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    registration_date DATE,
    status VARCHAR(20) DEFAULT 'active',
    total_spent DECIMAL(12,2) DEFAULT 0.00
);

DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending'
);

DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INTEGER
);

DROP TABLE IF EXISTS inventory_logs CASCADE;
CREATE TABLE inventory_logs (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    change_amount INTEGER,
    reason VARCHAR(100),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO customers (name, email, registration_date, total_spent) VALUES
('Alice Johnson', 'alice@example.com', '2023-01-15', 1250.00),
('Bob Smith', 'bob@example.com', '2023-02-20', 890.50),
('Carol Williams', 'carol@example.com', '2023-03-10', 2100.75),
('David Brown', 'david@example.com', '2023-01-30', 450.25),
('Eve Davis', 'eve@example.com', '2023-03-25', 3200.00);

INSERT INTO products (name, category, price, stock_quantity) VALUES
('Laptop Pro', 'Electronics', 1200.00, 25),
('Wireless Mouse', 'Electronics', 25.00, 100),
('Mechanical Keyboard', 'Electronics', 80.00, 50),
('Office Chair', 'Furniture', 150.00, 20),
('Desk Lamp', 'Furniture', 35.00, 40);

INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2023-04-01', 1225.00, 'completed'),
(2, '2023-04-02', 890.50, 'completed'),
(3, '2023-04-03', 2100.75, 'completed'),
(1, '2023-04-05', 25.00, 'completed'),
(4, '2023-04-06', 185.00, 'pending'),
(5, '2023-04-07', 3200.00, 'completed');

-- Exercise 1: Customer Loyalty Points Calculator
-- Create a function that calculates loyalty points based on customer spending
-- Rules: 1 point per $10 spent, plus 50 bonus points for spending over $1000
-- Return: Integer representing loyalty points

-- Your implementation here:

-- Test your function:
-- SELECT name, total_spent, calculate_loyalty_points(total_spent) as points
-- FROM customers;

-- Exercise 2: Inventory Adjustment Function
-- Create a function that adjusts inventory and logs the change
-- Parameters: product_id, quantity_change, reason
-- Requirements:
-- 1. Update product stock quantity
-- 2. Log the change in inventory_logs table
-- 3. Handle cases where adjustment would result in negative stock
-- Return: Success message or error message

-- Your implementation here:

-- Test your function:
-- SELECT adjust_inventory(1, -5, 'Sale');
-- SELECT adjust_inventory(2, 10, 'Restock');

-- Exercise 3: Order Status Summary Function
-- Create a function that returns a summary of order statuses for a given date range
-- Return: Table with status and count columns

-- Your implementation here:

-- Test your function:
-- SELECT * FROM get_order_status_summary('2023-04-01', '2023-04-07');

-- Exercise 4: Customer Segmentation Function
-- Create a function that categorizes customers based on spending
-- Categories: 'Bronze' (<$500), 'Silver' ($500-$1500), 'Gold' ($1500-$3000), 'Platinum' (>$3000)
-- Return: Customer details with segmentation category

-- Your implementation here:

-- Test your function:
-- SELECT *, segment_customer(total_spent) as category FROM customers;

-- Exercise 5: Product Recommendation Function
-- Create a function that recommends products based on a customer's purchase history
-- Parameters: customer_id, limit (number of recommendations)
-- Logic: Recommend products in the same categories as customer's previous purchases
-- Return: Set of recommended products

-- Your implementation here:

-- Test your function:
-- SELECT * FROM recommend_products(1, 3);

-- Exercise 6: Monthly Sales Report Function
-- Create a function that generates a monthly sales report
-- Parameters: year, month
-- Return: JSON object containing:
-- - Total revenue
-- - Number of orders
-- - Average order value
-- - Top selling product
-- - Customer with highest spending

-- Your implementation here:

-- Test your function:
-- SELECT generate_monthly_report(2023, 4);

-- Exercise 7: Price Comparison Function
-- Create a function that compares prices of products across categories
-- Parameters: array of product IDs
-- Return: Table with product name, price, category average, and price difference from category average

-- Your implementation here:

-- Test your function:
-- SELECT * FROM compare_prices(ARRAY[1, 2, 3]);

-- Exercise 8: Customer Lifetime Value Function
-- Create a function that calculates customer lifetime value
-- Parameters: customer_id, average_margin_percentage
-- Formula: Total spent * (1 + average_margin_percentage/100)
-- Return: Numeric CLV value

-- Your implementation here:

-- Test your function:
-- SELECT name, total_spent, calculate_clv(id, 20) as clv FROM customers;

-- Exercise 9: Automatic Discount Function
-- Create a function that applies automatic discounts based on order amount
-- Rules: 5% off for >$500, 10% off for >$1000, 15% off for >$2000
-- Parameters: order_amount
-- Return: Final price after discount

-- Your implementation here:

-- Test your function:
-- SELECT 1000 as original_price, apply_discount(1000) as discounted_price;

-- Exercise 10: Data Validation Function
-- Create a function that validates customer data before insertion
-- Parameters: name, email, registration_date
-- Requirements:
-- 1. Name must not be empty
-- 2. Email must be valid format
-- 3. Registration date must not be in the future
-- Return: JSON with validation result and error messages if any

-- Your implementation here:

-- Test your function:
-- SELECT validate_customer_data('John Doe', 'john@example.com', CURRENT_DATE);
-- SELECT validate_customer_data('', 'invalid-email', '2025-01-01');

-- Bonus Exercise: Comprehensive E-commerce Analytics Suite
-- Create a comprehensive analytics function that combines several of the above concepts
-- Requirements:
-- 1. Accept parameters for date range
-- 2. Calculate key metrics: revenue, orders, customers, avg order value
-- 3. Identify top products and customers
-- 4. Generate customer segmentation analysis
-- 5. Return structured JSON report

-- Your implementation here:

-- Test your function:
-- SELECT generate_comprehensive_report('2023-04-01', '2023-04-07');

-- Additional Practice Tips:
-- 1. Implement proper error handling in all functions
-- 2. Use appropriate volatility classifications
-- 3. Consider performance optimization for complex functions
-- 4. Add detailed comments to explain logic
-- 5. Test edge cases and invalid inputs
-- 6. Review PostgreSQL documentation for advanced function features