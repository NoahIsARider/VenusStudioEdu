-- PostgreSQL Tables Examples

-- 1. Creating Tables with Different Constraints
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE DEFAULT CURRENT_DATE,
    salary DECIMAL(10, 2) CHECK (salary > 0),
    department_id INTEGER,
    manager_id INTEGER REFERENCES employees(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Creating Tables with Foreign Keys
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    budget DECIMAL(12, 2) CHECK (budget > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key constraint to employees table
ALTER TABLE employees 
ADD CONSTRAINT fk_department 
FOREIGN KEY (department_id) REFERENCES departments(id);

-- 3. Creating Tables with Check Constraints
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) CHECK (category IN ('Electronics', 'Clothing', 'Books', 'Home')),
    price DECIMAL(10, 2) CHECK (price > 0),
    stock_quantity INTEGER CHECK (stock_quantity >= 0),
    weight DECIMAL(8, 2) CHECK (weight > 0),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Creating Tables with NOT NULL and DEFAULT Constraints
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
    total_amount DECIMAL(10, 2) DEFAULT 0.00,
    shipping_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Inserting Sample Data
INSERT INTO departments (name, budget) VALUES
('Engineering', 1000000.00),
('Marketing', 500000.00),
('Sales', 750000.00),
('Human Resources', 300000.00);

INSERT INTO employees (first_name, last_name, email, salary, department_id) VALUES
('John', 'Doe', 'john.doe@company.com', 75000.00, 1),
('Jane', 'Smith', 'jane.smith@company.com', 65000.00, 2),
('Robert', 'Johnson', 'robert.johnson@company.com', 80000.00, 1),
('Emily', 'Williams', 'emily.williams@company.com', 70000.00, 3),
('Michael', 'Brown', 'michael.brown@company.com', 90000.00, 1);

INSERT INTO products (name, category, price, stock_quantity, weight) VALUES
('Laptop', 'Electronics', 1200.00, 50, 2.5),
('T-Shirt', 'Clothing', 25.00, 200, 0.3),
('Python Programming Book', 'Books', 45.00, 100, 1.2),
('Coffee Mug', 'Home', 12.00, 300, 0.5);

INSERT INTO orders (customer_id, total_amount, shipping_address) VALUES
(1001, 1250.00, '123 Main St, City, State 12345'),
(1002, 75.00, '456 Oak Ave, Town, State 67890'),
(1003, 45.00, '789 Pine Rd, Village, State 54321');

-- 6. Demonstrating Table Alterations
-- Add a new column
ALTER TABLE employees ADD COLUMN phone VARCHAR(20);

-- Add a check constraint
ALTER TABLE employees ADD CONSTRAINT chk_salary CHECK (salary >= 30000);

-- Rename a column
ALTER TABLE employees RENAME COLUMN phone TO contact_number;

-- Change column type
ALTER TABLE employees ALTER COLUMN contact_number TYPE VARCHAR(30);

-- 7. Creating Table with Composite Primary Key
CREATE TABLE order_items (
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) CHECK (unit_price > 0),
    PRIMARY KEY (order_id, product_id)
);

-- Insert sample data for order_items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00),
(1, 4, 5, 12.00),
(2, 2, 3, 25.00),
(3, 3, 1, 45.00);

-- 8. Creating Table with Index
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE DEFAULT CURRENT_DATE,
    loyalty_points INTEGER DEFAULT 0
);

-- Create indexes for better performance
CREATE INDEX idx_customers_last_name ON customers(last_name);
CREATE INDEX idx_customers_email ON customers(email);

-- Insert sample data for customers
INSERT INTO customers (first_name, last_name, email, loyalty_points) VALUES
('Alice', 'Anderson', 'alice.anderson@email.com', 150),
('Brian', 'Bell', 'brian.bell@email.com', 300),
('Catherine', 'Clark', 'catherine.clark@email.com', 75);

-- 9. Querying Tables with Joins
-- Simple join
SELECT e.first_name, e.last_name, d.name as department
FROM employees e
JOIN departments d ON e.department_id = d.id;

-- Join with aggregation
SELECT d.name, COUNT(e.id) as employee_count, AVG(e.salary) as avg_salary
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.id, d.name;

-- Complex join with multiple tables
SELECT 
    o.id as order_id,
    c.first_name,
    c.last_name,
    p.name as product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) as line_total
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id;

-- 10. Demonstrating Table Inheritance (PostgreSQL-specific feature)
CREATE TABLE measurement (
    id SERIAL,
    logdate DATE NOT NULL,
    peaktemp INT,
    unitsales INT
);

CREATE TABLE measurement_y2023 (
    CHECK (logdate >= DATE '2023-01-01' AND logdate < DATE '2024-01-01')
) INHERITS (measurement);

CREATE TABLE measurement_y2024 (
    CHECK (logdate >= DATE '2024-01-01' AND logdate < DATE '2025-01-01')
) INHERITS (measurement);

-- Insert sample data
INSERT INTO measurement_y2023 (logdate, peaktemp, unitsales) VALUES
('2023-06-15', 85, 120),
('2023-07-20', 92, 150);

INSERT INTO measurement_y2024 (logdate, peaktemp, unitsales) VALUES
('2024-01-10', 78, 100),
('2024-02-15', 82, 110);

-- Query data from parent table (will include child tables)
SELECT * FROM measurement;

-- Query data from specific child table
SELECT * FROM measurement_y2023;

-- Clean up (optional - uncomment to delete created tables)
-- DROP TABLE order_items, orders, products, employees, departments, customers, measurement_y2024, measurement_y2023, measurement;