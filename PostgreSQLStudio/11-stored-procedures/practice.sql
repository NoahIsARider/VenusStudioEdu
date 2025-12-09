-- PostgreSQL Stored Procedures Practice Exercises
-- This file contains 10 practical exercises for learning stored procedures in PostgreSQL

-- Create sample tables for exercises
DROP TABLE IF EXISTS customers CASCADE;
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    status VARCHAR(20) DEFAULT 'active'
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
INSERT INTO customers (name, email, registration_date) VALUES
('Alice Johnson', 'alice@example.com', '2023-01-15'),
('Bob Smith', 'bob@example.com', '2023-02-20'),
('Carol Davis', 'carol@example.com', '2023-03-10'),
('David Wilson', 'david@example.com', '2023-01-30'),
('Eva Brown', 'eva@example.com', '2023-02-28');

INSERT INTO products (name, category, price, stock_quantity) VALUES
('Laptop Pro', 'Electronics', 1200.00, 25),
('Wireless Mouse', 'Electronics', 25.00, 100),
('Mechanical Keyboard', 'Electronics', 80.00, 50),
('Office Chair', 'Furniture', 150.00, 20),
('Desk Lamp', 'Furniture', 30.00, 40);

INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2023-03-01', 1225.00, 'completed'),
(2, '2023-03-05', 105.00, 'completed'),
(3, '2023-03-10', 150.00, 'pending'),
(1, '2023-03-15', 30.00, 'completed'),
(4, '2023-03-20', 1280.00, 'cancelled');

-- Exercise 1: Customer Registration Procedure
-- Create a stored procedure that registers a new customer with validation
-- Requirements:
-- 1. Check if email already exists
-- 2. Validate email format (basic check)
-- 3. Insert new customer with registration date
-- 4. Return success message or error

-- Your solution here:

-- Exercise 2: Order Processing Procedure
-- Create a stored procedure that processes an order with inventory management
-- Requirements:
-- 1. Check if customer exists
-- 2. Validate product availability
-- 3. Update product stock
-- 4. Create order record
-- 5. Log inventory changes
-- 6. Handle errors appropriately

-- Your solution here:

-- Exercise 3: Bulk Customer Status Update
-- Create a stored procedure that updates customer statuses based on registration date
-- Requirements:
-- 1. Accept date threshold and new status
-- 2. Update all customers registered before the threshold date
-- 3. Count and return number of updated records
-- 4. Log the operation

-- Your solution here:

-- Exercise 4: Product Price Adjustment
-- Create a stored procedure that adjusts prices for a category with logging
-- Requirements:
-- 1. Accept category and percentage adjustment (+/-)
-- 2. Validate adjustment percentage (-50% to +100%)
-- 3. Update prices for all products in category
-- 4. Log changes in a separate audit table
-- 5. Return summary statistics

-- Your solution here:

-- Exercise 5: Monthly Report Generator
-- Create a stored procedure that generates a monthly sales report
-- Requirements:
-- 1. Accept month and year parameters
-- 2. Calculate total sales, order count, average order value
-- 3. Identify top 3 selling products
-- 4. Identify top 3 customers by spending
-- 5. Output formatted report

-- Your solution here:

-- Exercise 6: Customer Loyalty Program
-- Create a stored procedure that assigns loyalty tiers based on purchase history
-- Requirements:
-- 1. Calculate total purchases per customer
-- 2. Assign tier: Bronze (<1000), Silver (1000-5000), Gold (>5000)
-- 3. Update customer records with tier information
-- 4. Generate summary of tier distribution

-- Your solution here:

-- Exercise 7: Inventory Replenishment Alert
-- Create a stored procedure that checks inventory levels and generates alerts
-- Requirements:
-- 1. Check all products with stock below threshold (e.g., 10 units)
-- 2. Generate alert messages for low stock items
-- 3. Include product name, current stock, and reorder suggestion
-- 4. Return list of products needing replenishment

-- Your solution here:

-- Exercise 8: Data Archiving Procedure
-- Create a stored procedure that archives old orders to a separate table
-- Requirements:
-- 1. Move orders older than specified date to archive table
-- 2. Remove archived orders from main table
-- 3. Log archiving operation with count of moved records
-- 4. Handle errors and rollback if needed

-- Your solution here:

-- Exercise 9: Customer Segmentation Analysis
-- Create a stored procedure that segments customers based on purchasing behavior
-- Requirements:
-- 1. Categorize customers: Active, Inactive, New, VIP
-- 2. Define criteria for each segment
-- 3. Update customer segmentation field
-- 4. Generate segment distribution report

-- Your solution here:

-- Exercise 10: Automated Discount Campaign
-- Create a stored procedure that applies discounts based on business rules
-- Requirements:
-- 1. Apply 10% discount to Electronics if stock > 50
-- 2. Apply 15% discount to Furniture if stock < 25
-- 3. Apply 5% discount to all other products
-- 4. Log discount applications
-- 5. Return summary of applied discounts

-- Your solution here:

-- Extra Challenge: E-commerce Platform Automation Suite
-- Create a comprehensive set of stored procedures that automate common e-commerce operations:
-- 1. Automated order fulfillment procedure
-- 2. Customer churn prediction and retention procedure
-- 3. Dynamic pricing optimization procedure
-- 4. Fraud detection and prevention procedure
-- 5. Real-time inventory synchronization procedure
-- 6. Customer service ticket escalation procedure
-- 7. Marketing campaign personalization procedure
-- 8. Financial reconciliation procedure
-- 9. Performance analytics dashboard procedure
-- 10. System maintenance and cleanup procedure

-- Implementation guidelines:
-- - Use proper error handling in all procedures
-- - Implement transaction control where appropriate
-- - Include detailed logging for audit purposes
-- - Optimize for performance with appropriate indexing
-- - Document all procedures with clear comments
-- - Test edge cases and error conditions thoroughly

-- Your solution here: