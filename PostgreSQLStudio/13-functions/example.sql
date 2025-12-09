-- PostgreSQL Functions Examples
-- This file demonstrates various function techniques in PostgreSQL

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
    stock_quantity INTEGER
);

-- Insert sample data
INSERT INTO employees (name, department, salary, hire_date, manager_id) VALUES
('CEO John', 'Executive', 150000.00, '2020-01-01', NULL),
('Sarah Manager', 'Engineering', 120000.00, '2020-02-01', 1),
('Mike Developer', 'Engineering', 90000.00, '2020-03-01', 2),
('Lisa Developer', 'Engineering', 95000.00, '2020-04-01', 2),
('Tom Manager', 'Marketing', 110000.00, '2020-02-15', 1),
('Amy Specialist', 'Marketing', 75000.00, '2020-03-15', 5);

INSERT INTO sales (employee_id, sale_amount, sale_date) VALUES
(2, 15000.00, '2023-01-15'),
(2, 20000.00, '2023-02-20'),
(3, 12000.00, '2023-01-25'),
(3, 18000.00, '2023-03-10'),
(4, 25000.00, '2023-02-05'),
(4, 22000.00, '2023-03-15');

INSERT INTO products (name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 1200.00, 50),
('Smartphone', 'Electronics', 800.00, 100),
('Tablet', 'Electronics', 500.00, 75),
('Desk Chair', 'Furniture', 200.00, 30),
('Office Desk', 'Furniture', 400.00, 20);

-- 1. Basic Scalar Function
CREATE OR REPLACE FUNCTION calculate_annual_bonus(salary DECIMAL(10,2), bonus_percentage NUMERIC DEFAULT 10.0)
RETURNS DECIMAL(10,2) AS $$
BEGIN
    RETURN salary * (bonus_percentage / 100);
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT 
    name,
    salary,
    calculate_annual_bonus(salary) as default_bonus,
    calculate_annual_bonus(salary, 15.0) as custom_bonus
FROM employees;

-- 2. Function with Table Return
CREATE OR REPLACE FUNCTION get_employee_sales(emp_id INTEGER)
RETURNS TABLE (
    sale_id INTEGER,
    amount DECIMAL(10,2),
    sale_date DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT s.id, s.sale_amount, s.sale_date
    FROM sales s
    WHERE s.employee_id = emp_id
    ORDER BY s.sale_date;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT * FROM get_employee_sales(3);

-- 3. Function with Multiple Return Values (Using OUT Parameters)
CREATE OR REPLACE FUNCTION get_employee_summary(emp_id INTEGER, 
                                               OUT emp_name TEXT,
                                               OUT total_sales DECIMAL(12,2),
                                               OUT sales_count INTEGER,
                                               OUT avg_sale DECIMAL(10,2))
AS $$
BEGIN
    SELECT e.name INTO emp_name
    FROM employees e
    WHERE e.id = emp_id;
    
    SELECT 
        COALESCE(SUM(s.sale_amount), 0),
        COUNT(s.id),
        COALESCE(AVG(s.sale_amount), 0)
    INTO total_sales, sales_count, avg_sale
    FROM sales s
    WHERE s.employee_id = emp_id;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT * FROM get_employee_summary(4);

-- 4. Set-Returning Function
CREATE OR REPLACE FUNCTION get_department_employees(dept_name TEXT)
RETURNS SETOF employees AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM employees 
    WHERE department = dept_name
    ORDER BY name;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT * FROM get_department_employees('Engineering');

-- 5. Function with Complex Logic and Error Handling
CREATE OR REPLACE FUNCTION transfer_employee_safe(emp_id INTEGER, new_dept TEXT)
RETURNS TEXT AS $$
DECLARE
    emp_exists BOOLEAN;
    current_dept TEXT;
    result_message TEXT;
BEGIN
    -- Check if employee exists
    SELECT EXISTS(SELECT 1 FROM employees WHERE id = emp_id) INTO emp_exists;
    
    IF NOT emp_exists THEN
        RETURN 'Error: Employee not found';
    END IF;
    
    -- Get current department
    SELECT department INTO current_dept FROM employees WHERE id = emp_id;
    
    -- Check if already in department
    IF current_dept = new_dept THEN
        RETURN 'Warning: Employee already in department ' || new_dept;
    END IF;
    
    -- Perform transfer
    UPDATE employees 
    SET department = new_dept 
    WHERE id = emp_id;
    
    result_message := 'Success: Transferred employee from ' || current_dept || ' to ' || new_dept;
    RAISE NOTICE '%', result_message;
    
    RETURN result_message;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT transfer_employee_safe(3, 'Marketing');
SELECT transfer_employee_safe(999, 'HR'); -- Non-existent employee

-- 6. Function with JSON Return
CREATE OR REPLACE FUNCTION get_employee_performance_report(emp_id INTEGER)
RETURNS JSON AS $$
DECLARE
    emp_record RECORD;
    sales_data JSON;
    performance_metrics JSON;
BEGIN
    -- Get employee info
    SELECT id, name, department, salary INTO emp_record
    FROM employees 
    WHERE id = emp_id;
    
    IF NOT FOUND THEN
        RETURN json_build_object('error', 'Employee not found');
    END IF;
    
    -- Get sales data
    SELECT json_agg(
        json_build_object(
            'date', sale_date,
            'amount', sale_amount
        ) ORDER BY sale_date
    ) INTO sales_data
    FROM sales 
    WHERE employee_id = emp_id;
    
    -- Build performance metrics
    performance_metrics := json_build_object(
        'total_sales', COALESCE((SELECT SUM(sale_amount) FROM sales WHERE employee_id = emp_id), 0),
        'sales_count', COALESCE((SELECT COUNT(*) FROM sales WHERE employee_id = emp_id), 0),
        'avg_sale', COALESCE((SELECT AVG(sale_amount) FROM sales WHERE employee_id = emp_id), 0)
    );
    
    -- Return complete report
    RETURN json_build_object(
        'employee', json_build_object(
            'id', emp_record.id,
            'name', emp_record.name,
            'department', emp_record.department,
            'salary', emp_record.salary
        ),
        'performance', performance_metrics,
        'sales_history', COALESCE(sales_data, '[]'::JSON)
    );
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT get_employee_performance_report(4) AS performance_report;

-- 7. Recursive Function (Factorial)
CREATE OR REPLACE FUNCTION factorial(n INTEGER)
RETURNS BIGINT AS $$
BEGIN
    IF n <= 1 THEN
        RETURN 1;
    ELSE
        RETURN n * factorial(n - 1);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT factorial(5) AS five_factorial;

-- 8. Function with Dynamic SQL
CREATE OR REPLACE FUNCTION count_records_in_table(table_name TEXT)
RETURNS INTEGER AS $$
DECLARE
    record_count INTEGER;
    query TEXT;
BEGIN
    query := 'SELECT COUNT(*) FROM ' || quote_ident(table_name);
    EXECUTE query INTO record_count;
    RETURN record_count;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error counting records in table %: %', table_name, SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT count_records_in_table('employees') AS employee_count;
SELECT count_records_in_table('nonexistent_table') AS error_test;

-- 9. Function with Array Parameters
CREATE OR REPLACE FUNCTION calculate_total_price(product_ids INTEGER[])
RETURNS DECIMAL(12,2) AS $$
DECLARE
    total_price DECIMAL(12,2) := 0;
    product_price DECIMAL(10,2);
    pid INTEGER;
BEGIN
    FOREACH pid IN ARRAY product_ids
    LOOP
        SELECT price INTO product_price
        FROM products
        WHERE id = pid;
        
        IF FOUND THEN
            total_price := total_price + product_price;
        ELSE
            RAISE NOTICE 'Product ID % not found', pid;
        END IF;
    END LOOP;
    
    RETURN total_price;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT calculate_total_price(ARRAY[1, 2, 3]) AS total_for_products_123;
SELECT calculate_total_price(ARRAY[1, 999, 3]) AS total_with_missing_product;

-- 10. Function with Window Logic
CREATE OR REPLACE FUNCTION get_employee_rankings()
RETURNS TABLE (
    employee_name TEXT,
    department TEXT,
    total_sales DECIMAL(12,2),
    rank_in_company INTEGER,
    rank_in_department INTEGER
) AS $$
BEGIN
    RETURN QUERY
    WITH employee_sales AS (
        SELECT 
            e.id,
            e.name,
            e.department,
            COALESCE(SUM(s.sale_amount), 0) as total_sales
        FROM employees e
        LEFT JOIN sales s ON e.id = s.employee_id
        GROUP BY e.id, e.name, e.department
    )
    SELECT 
        es.name,
        es.department,
        es.total_sales,
        ROW_NUMBER() OVER (ORDER BY es.total_sales DESC) as company_rank,
        ROW_NUMBER() OVER (PARTITION BY es.department ORDER BY es.total_sales DESC) as dept_rank
    FROM employee_sales es
    ORDER BY es.total_sales DESC;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT * FROM get_employee_rankings();

-- 11. Function with Temporary Tables
CREATE OR REPLACE FUNCTION generate_sales_report(start_date DATE, end_date DATE)
RETURNS TABLE (
    department TEXT,
    total_revenue DECIMAL(12,2),
    transaction_count INTEGER,
    avg_transaction DECIMAL(10,2)
) AS $$
BEGIN
    -- Create temporary table for calculations
    CREATE TEMP TABLE temp_sales_summary AS
    SELECT 
        e.department,
        COUNT(s.id) as transaction_count,
        SUM(s.sale_amount) as total_revenue,
        AVG(s.sale_amount) as avg_transaction
    FROM sales s
    JOIN employees e ON s.employee_id = e.id
    WHERE s.sale_date BETWEEN start_date AND end_date
    GROUP BY e.department;
    
    -- Return results
    RETURN QUERY
    SELECT 
        t.department,
        COALESCE(t.total_revenue, 0.00),
        COALESCE(t.transaction_count, 0),
        COALESCE(t.avg_transaction, 0.00)
    FROM temp_sales_summary t
    ORDER BY t.total_revenue DESC;
    
    -- Clean up
    DROP TABLE temp_sales_summary;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT * FROM generate_sales_report('2023-01-01', '2023-12-31');

-- 12. Function with Security Definer
CREATE OR REPLACE FUNCTION get_all_employees_secure()
RETURNS SETOF employees AS $$
BEGIN
    -- This function runs with the privileges of the function creator
    RETURN QUERY SELECT * FROM employees ORDER BY id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 13. Function with Volatility Classification
-- Immutable function (same result for same input, no DB access)
CREATE OR REPLACE FUNCTION calculate_square(x NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN x * x;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Stable function (same result for same input in same transaction)
CREATE OR REPLACE FUNCTION get_current_date_formatted()
RETURNS TEXT AS $$
BEGIN
    RETURN TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD');
END;
$$ LANGUAGE plpgsql STABLE;

-- Volatile function (can return different results for same input)
CREATE OR REPLACE FUNCTION get_random_number()
RETURNS INTEGER AS $$
BEGIN
    RETURN FLOOR(RANDOM() * 100) + 1;
END;
$$ LANGUAGE plpgsql VOLATILE;

-- Test volatility functions
SELECT calculate_square(5) AS square_of_5;
SELECT get_current_date_formatted() AS today;
SELECT get_random_number() AS random_num1, get_random_number() AS random_num2;

-- 14. Function with Default Parameters and Overloading
-- Note: PostgreSQL doesn't support true function overloading,
-- but we can simulate it with default parameters

CREATE OR REPLACE FUNCTION search_employees(search_term TEXT DEFAULT '', 
                                          dept_filter TEXT DEFAULT '',
                                          min_salary DECIMAL(10,2) DEFAULT 0)
RETURNS SETOF employees AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM employees
    WHERE (search_term = '' OR name ILIKE '%' || search_term || '%')
      AND (dept_filter = '' OR department = dept_filter)
      AND salary >= min_salary
    ORDER BY name;
END;
$$ LANGUAGE plpgsql;

-- Test overloaded-like function
SELECT * FROM search_employees('Mike');
SELECT * FROM search_employees('', 'Engineering');
SELECT * FROM search_employees('A', '', 80000);

-- 15. Function Management
-- View all functions
SELECT 
    proname AS function_name,
    pg_get_function_arguments(p.oid) AS arguments,
    pg_get_function_result(p.oid) AS return_type,
    prosecdef AS security_definer,
    provolatile AS volatility
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
  AND proname NOT LIKE 'pg_%'
ORDER BY proname;

-- Drop a function
-- DROP FUNCTION IF EXISTS calculate_annual_bonus(DECIMAL(10,2), NUMERIC);

-- Best Practices Summary:
-- 1. Use appropriate volatility classifications
-- 2. Handle errors gracefully
-- 3. Document functions well
-- 4. Use SECURITY DEFINER carefully
-- 5. Optimize for performance
-- 6. Test functions thoroughly
-- 7. Use meaningful names and parameter names
-- 8. Consider function complexity and maintenance