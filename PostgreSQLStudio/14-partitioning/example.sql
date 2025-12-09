-- PostgreSQL Partitioning Examples
-- This file demonstrates various partitioning techniques in PostgreSQL

-- Create sample tables for demonstration
DROP TABLE IF EXISTS sales_old CASCADE;
DROP TABLE IF EXISTS sales_2022 CASCADE;
DROP TABLE IF EXISTS sales_2023 CASCADE;
DROP TABLE IF EXISTS sales_2024 CASCADE;
DROP TABLE IF EXISTS sales CASCADE;

-- 1. Range Partitioning
-- Create master table
CREATE TABLE sales (
    id SERIAL,
    sale_date DATE NOT NULL,
    product_id INTEGER,
    customer_id INTEGER,
    amount DECIMAL(10,2)
) PARTITION BY RANGE (sale_date);

-- Create partitions for different years
CREATE TABLE sales_2022 PARTITION OF sales
FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE sales_2023 PARTITION OF sales
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE sales_2024 PARTITION OF sales
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Add indexes to partitions
CREATE INDEX ON sales_2022 (sale_date);
CREATE INDEX ON sales_2023 (sale_date);
CREATE INDEX ON sales_2024 (sale_date);

-- Insert sample data
INSERT INTO sales (sale_date, product_id, customer_id, amount) VALUES
('2022-01-15', 1, 100, 150.00),
('2022-03-22', 2, 101, 89.50),
('2022-06-10', 3, 102, 200.00),
('2022-12-05', 1, 103, 75.25),
('2023-02-14', 2, 104, 120.75),
('2023-05-30', 3, 105, 300.00),
('2023-08-19', 1, 106, 95.50),
('2023-11-11', 2, 107, 175.25),
('2024-01-20', 3, 108, 250.00),
('2024-04-05', 1, 109, 110.00);

-- Verify partitioning
SELECT 
    schemaname,
    tablename,
    partitionbounds
FROM pg_tables 
WHERE tablename LIKE 'sales%' 
ORDER BY tablename;

-- Query demonstrating partition pruning
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM sales WHERE sale_date BETWEEN '2023-01-01' AND '2023-12-31';

-- 2. List Partitioning
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS users_north_america CASCADE;
DROP TABLE IF EXISTS users_europe CASCADE;
DROP TABLE IF EXISTS users_asia CASCADE;
DROP TABLE IF EXISTS users_other CASCADE;

CREATE TABLE users (
    id SERIAL,
    name VARCHAR(100),
    email VARCHAR(100),
    region VARCHAR(20)
) PARTITION BY LIST (region);

-- Create partitions for different regions
CREATE TABLE users_north_america PARTITION OF users
FOR VALUES IN ('US', 'CA', 'MX');

CREATE TABLE users_europe PARTITION OF users
FOR VALUES IN ('UK', 'DE', 'FR', 'IT');

CREATE TABLE users_asia PARTITION OF users
FOR VALUES IN ('CN', 'JP', 'IN', 'KR');

CREATE TABLE users_other PARTITION OF users
DEFAULT;

-- Insert sample data
INSERT INTO users (name, email, region) VALUES
('John Smith', 'john@company.com', 'US'),
('Jane Doe', 'jane@company.com', 'CA'),
('Hans Mueller', 'hans@company.de', 'DE'),
('Marie Dubois', 'marie@company.fr', 'FR'),
('Tanaka-san', 'tanaka@company.jp', 'JP'),
('Zhang Wei', 'zhang@company.cn', 'CN'),
('Carlos Garcia', 'carlos@company.mx', 'MX'),
('Other User', 'other@company.com', 'AU');

-- Query demonstrating list partitioning
SELECT tableoid::regclass AS partition_name, COUNT(*) 
FROM users 
GROUP BY tableoid::regclass;

-- 3. Hash Partitioning
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS orders_0 CASCADE;
DROP TABLE IF EXISTS orders_1 CASCADE;
DROP TABLE IF EXISTS orders_2 CASCADE;
DROP TABLE IF EXISTS orders_3 CASCADE;

CREATE TABLE orders (
    id SERIAL,
    customer_id INTEGER,
    order_date DATE,
    total_amount DECIMAL(10,2)
) PARTITION BY HASH (customer_id);

-- Create hash partitions
CREATE TABLE orders_0 PARTITION OF orders FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE orders_1 PARTITION OF orders FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE orders_2 PARTITION OF orders FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE orders_3 PARTITION OF orders FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Insert sample data
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1001, '2023-01-15', 150.00),
(1002, '2023-02-20', 89.50),
(1003, '2023-03-10', 200.00),
(1004, '2023-04-05', 75.25),
(1005, '2023-05-12', 120.75),
(1006, '2023-06-18', 300.00),
(1007, '2023-07-22', 95.50),
(1008, '2023-08-30', 175.25);

-- Check distribution across partitions
SELECT tableoid::regclass AS partition_name, COUNT(*) 
FROM orders 
GROUP BY tableoid::regclass;

-- 4. Multi-level Partitioning (Subpartitioning)
DROP TABLE IF EXISTS measurements CASCADE;
DROP TABLE IF EXISTS measurements_2023_01 CASCADE;
DROP TABLE IF EXISTS measurements_2023_02 CASCADE;
DROP TABLE IF EXISTS measurements_2024_01 CASCADE;
DROP TABLE IF EXISTS measurements_2024_02 CASCADE;

CREATE TABLE measurements (
    id SERIAL,
    log_date DATE NOT NULL,
    sensor_id INTEGER,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2)
) PARTITION BY RANGE (log_date);

-- Create yearly partitions
CREATE TABLE measurements_2023 PARTITION OF measurements
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01')
PARTITION BY RANGE (sensor_id);

CREATE TABLE measurements_2024 PARTITION OF measurements
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01')
PARTITION BY RANGE (sensor_id);

-- Create subpartitions by sensor_id ranges
CREATE TABLE measurements_2023_01 PARTITION OF measurements_2023
FOR VALUES FROM (1) TO (100);

CREATE TABLE measurements_2023_02 PARTITION OF measurements_2023
FOR VALUES FROM (100) TO (200);

CREATE TABLE measurements_2024_01 PARTITION OF measurements_2024
FOR VALUES FROM (1) TO (100);

CREATE TABLE measurements_2024_02 PARTITION OF measurements_2024
FOR VALUES FROM (100) TO (200);

-- Insert sample data
INSERT INTO measurements (log_date, sensor_id, temperature, humidity) VALUES
('2023-01-15', 50, 22.5, 45.2),
('2023-02-20', 75, 24.1, 42.8),
('2023-03-10', 150, 20.8, 48.5),
('2023-04-05', 175, 23.2, 46.1),
('2024-01-12', 25, 21.9, 47.3),
('2024-02-18', 125, 25.4, 41.7);

-- Check partition hierarchy
SELECT 
    schemaname,
    tablename,
    partitionbounds
FROM pg_tables 
WHERE tablename LIKE 'measurements%' 
ORDER BY tablename;

-- 5. Partition Maintenance
-- Add new partition for 2025
CREATE TABLE sales_2025 PARTITION OF sales
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Detach a partition (without dropping data)
CREATE TABLE sales_2021 (
    LIKE sales INCLUDING ALL
);

-- Move data older than 2022 to archive table
INSERT INTO sales_2021 
SELECT * FROM sales WHERE sale_date < '2022-01-01';

-- Detach the partition
ALTER TABLE sales DETACH PARTITION sales_2022;

-- Attach archived data as new partition
ALTER TABLE sales ATTACH PARTITION sales_2021
FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

-- 6. Partition Indexes
-- Global indexes (on parent table)
CREATE INDEX idx_sales_product_id ON sales (product_id);

-- Local indexes (on individual partitions)
CREATE INDEX idx_sales_2023_customer_id ON sales_2023 (customer_id);
CREATE INDEX idx_sales_2024_customer_id ON sales_2024 (customer_id);

-- 7. Partition Statistics and Monitoring
-- View partition statistics
SELECT 
    schemaname,
    tablename,
    n_tup_ins AS inserted_rows,
    n_tup_upd AS updated_rows,
    n_tup_del AS deleted_rows
FROM pg_stat_user_tables 
WHERE tablename LIKE 'sales%'
ORDER BY tablename;

-- Check partition sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) AS table_size
FROM pg_tables 
WHERE tablename LIKE 'sales%'
ORDER BY tablename;

-- 8. Constraint Exclusion
-- Query that benefits from constraint exclusion
EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) FROM sales WHERE sale_date < '2023-01-01';

-- 9. Partition-wise Joins
-- Create another partitioned table for join demonstration
DROP TABLE IF EXISTS products_partitioned CASCADE;
DROP TABLE IF EXISTS products_2023 CASCADE;
DROP TABLE IF EXISTS products_2024 CASCADE;

CREATE TABLE products_partitioned (
    id SERIAL,
    sale_id INTEGER,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    sale_date DATE
) PARTITION BY RANGE (sale_date);

CREATE TABLE products_2023 PARTITION OF products_partitioned
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE products_2024 PARTITION OF products_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Insert sample data
INSERT INTO products_partitioned (sale_id, product_name, category, price, sale_date) VALUES
(1, 'Laptop', 'Electronics', 1200.00, '2023-02-15'),
(2, 'Mouse', 'Electronics', 25.00, '2023-03-20'),
(3, 'Keyboard', 'Electronics', 80.00, '2024-01-10'),
(4, 'Monitor', 'Electronics', 300.00, '2024-02-05');

-- Enable partition-wise joins
SET enable_partitionwise_join = on;

-- Query demonstrating partition-wise joins
EXPLAIN (ANALYZE, BUFFERS)
SELECT s.sale_date, p.product_name, s.amount, p.price
FROM sales s
JOIN products_partitioned p ON s.id = p.sale_id
WHERE s.sale_date BETWEEN '2023-01-01' AND '2024-12-31';

-- 10. Partition Pruning Examples
-- Range pruning
EXPLAIN (COSTS OFF)
SELECT * FROM sales WHERE sale_date = '2023-06-15';

-- List pruning
EXPLAIN (COSTS OFF)
SELECT * FROM users WHERE region = 'DE';

-- Hash pruning
EXPLAIN (COSTS OFF)
SELECT * FROM orders WHERE customer_id = 1001;

-- 11. Performance Benefits Demonstration
-- Create large dataset for performance comparison
DROP TABLE IF EXISTS large_sales_old CASCADE;
DROP TABLE IF EXISTS large_sales CASCADE;

-- Non-partitioned table
CREATE TABLE large_sales_old (
    id SERIAL,
    sale_date DATE NOT NULL,
    product_id INTEGER,
    customer_id INTEGER,
    amount DECIMAL(10,2)
);

-- Partitioned table
CREATE TABLE large_sales (
    id SERIAL,
    sale_date DATE NOT NULL,
    product_id INTEGER,
    customer_id INTEGER,
    amount DECIMAL(10,2)
) PARTITION BY RANGE (sale_date);

CREATE TABLE large_sales_2022 PARTITION OF large_sales
FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE large_sales_2023 PARTITION OF large_sales
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE large_sales_2024 PARTITION OF large_sales
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Insert large datasets (simulated)
-- In practice, you would insert millions of rows for meaningful comparison
INSERT INTO large_sales_old (sale_date, product_id, customer_id, amount)
SELECT 
    '2022-01-01'::DATE + (random() * 730)::INTEGER,
    (random() * 100)::INTEGER,
    (random() * 1000)::INTEGER,
    (random() * 1000)::DECIMAL(10,2)
FROM generate_series(1, 100000);

INSERT INTO large_sales (sale_date, product_id, customer_id, amount)
SELECT 
    '2022-01-01'::DATE + (random() * 730)::INTEGER,
    (random() * 100)::INTEGER,
    (random() * 1000)::INTEGER,
    (random() * 1000)::DECIMAL(10,2)
FROM generate_series(1, 100000);

-- Compare query performance
EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) FROM large_sales_old WHERE sale_date BETWEEN '2023-01-01' AND '2023-12-31';

EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) FROM large_sales WHERE sale_date BETWEEN '2023-01-01' AND '2023-12-31';

-- 12. Best Practices Summary
/*
Partitioning Best Practices:

1. Choose the Right Partitioning Strategy:
   - Range: For time-series or ordered data
   - List: For discrete categories
   - Hash: For even distribution

2. Plan Partition Granularity:
   - Too many small partitions: Management overhead
   - Too few large partitions: Reduced benefits

3. Indexing Strategy:
   - Local indexes on partitions
   - Global indexes on parent table when needed

4. Maintenance:
   - Regularly add new partitions
   - Archive/remove old partitions
   - Monitor partition sizes and performance

5. Query Optimization:
   - Write queries that benefit from partition pruning
   - Use constraint-aware queries

6. Monitoring:
   - Track partition sizes
   - Monitor query performance
   - Check for data skew
*/

-- Clean up demonstration tables
-- DROP TABLE IF EXISTS sales CASCADE;
-- DROP TABLE IF EXISTS users CASCADE;
-- DROP TABLE IF EXISTS orders CASCADE;
-- DROP TABLE IF EXISTS measurements CASCADE;
-- DROP TABLE IF EXISTS large_sales_old CASCADE;
-- DROP TABLE IF EXISTS large_sales CASCADE;
-- DROP TABLE IF EXISTS products_partitioned CASCADE;