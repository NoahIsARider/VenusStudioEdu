-- PostgreSQL Stored Procedures Examples
-- This file demonstrates various stored procedure techniques in PostgreSQL

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

-- 1. Basic Stored Procedure
CREATE OR REPLACE PROCEDURE greet_user(user_name TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Hello, %!', user_name;
END;
$$;

-- Call the procedure
CALL greet_user('Alice');

-- 2. Stored Procedure with Parameters and Variables
CREATE OR REPLACE PROCEDURE calculate_bonus(
    emp_id INTEGER,
    bonus_percentage NUMERIC DEFAULT 10.0
)
LANGUAGE plpgsql
AS $$
DECLARE
    emp_name TEXT;
    emp_salary NUMERIC(10,2);
    bonus_amount NUMERIC(10,2);
BEGIN
    -- Get employee information
    SELECT name, salary INTO emp_name, emp_salary
    FROM employees
    WHERE id = emp_id;
    
    -- Check if employee exists
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee with ID % not found', emp_id;
    END IF;
    
    -- Calculate bonus
    bonus_amount := emp_salary * (bonus_percentage / 100);
    
    -- Output result
    RAISE NOTICE 'Employee: %, Salary: %, Bonus (%): %', 
                 emp_name, emp_salary, bonus_percentage, bonus_amount;
END;
$$;

-- Call the procedure
CALL calculate_bonus(2);
CALL calculate_bonus(3, 15.0);

-- 3. Stored Procedure with Transactions
CREATE OR REPLACE PROCEDURE transfer_employee(
    emp_id INTEGER,
    new_department TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    old_department TEXT;
    emp_name TEXT;
BEGIN
    -- Start transaction
    BEGIN
        -- Get current information
        SELECT name, department INTO emp_name, old_department
        FROM employees
        WHERE id = emp_id;
        
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Employee with ID % not found', emp_id;
        END IF;
        
        -- Update department
        UPDATE employees
        SET department = new_department
        WHERE id = emp_id;
        
        -- Log the transfer
        RAISE NOTICE 'Transferred % from % to % department', 
                     emp_name, old_department, new_department;
        
        -- Commit transaction (implicit in PostgreSQL procedures)
    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback transaction (automatic in PostgreSQL)
            RAISE EXCEPTION 'Failed to transfer employee: %', SQLERRM;
    END;
END;
$$;

-- Call the procedure
CALL transfer_employee(3, 'Marketing');

-- 4. Stored Procedure with Loops and Conditions
CREATE OR REPLACE PROCEDURE process_sales_report(report_month INTEGER, report_year INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    emp_record RECORD;
    total_sales NUMERIC(12,2) := 0;
    avg_sales NUMERIC(12,2) := 0;
    sales_count INTEGER := 0;
BEGIN
    RAISE NOTICE 'Processing sales report for %/%', report_month, report_year;
    
    -- Loop through employees
    FOR emp_record IN
        SELECT e.id, e.name, e.department, COALESCE(SUM(s.sale_amount), 0) as total_sales
        FROM employees e
        LEFT JOIN sales s ON e.id = s.employee_id 
            AND EXTRACT(MONTH FROM s.sale_date) = report_month
            AND EXTRACT(YEAR FROM s.sale_date) = report_year
        GROUP BY e.id, e.name, e.department
        ORDER BY total_sales DESC
    LOOP
        sales_count := sales_count + 1;
        total_sales := total_sales + emp_record.total_sales;
        
        RAISE NOTICE 'Employee: %, Department: %, Sales: %', 
                     emp_record.name, emp_record.department, emp_record.total_sales;
    END LOOP;
    
    -- Calculate averages
    IF sales_count > 0 THEN
        avg_sales := total_sales / sales_count;
    END IF;
    
    RAISE NOTICE 'Total Employees: %, Total Sales: %, Average Sales: %', 
                 sales_count, total_sales, avg_sales;
END;
$$;

-- Call the procedure
CALL process_sales_report(2, 2023);

-- 5. Stored Procedure with OUT Parameters
CREATE OR REPLACE PROCEDURE get_employee_stats(
    emp_id INTEGER,
    OUT emp_name TEXT,
    OUT department TEXT,
    OUT total_sales NUMERIC,
    OUT sales_count INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT e.name, e.department, COALESCE(SUM(s.sale_amount), 0), COUNT(s.id)
    INTO emp_name, department, total_sales, sales_count
    FROM employees e
    LEFT JOIN sales s ON e.id = s.employee_id
    WHERE e.id = emp_id
    GROUP BY e.id, e.name, e.department;
    
    IF emp_name IS NULL THEN
        RAISE EXCEPTION 'Employee with ID % not found', emp_id;
    END IF;
END;
$$;

-- Call the procedure
CALL get_employee_stats(2);

-- 6. Stored Procedure with INOUT Parameters
CREATE OR REPLACE PROCEDURE update_product_stock(
    prod_id INTEGER,
    INOUT quantity_change INTEGER,
    OUT new_stock INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_stock INTEGER;
    product_name TEXT;
BEGIN
    -- Get current stock
    SELECT stock_quantity, name INTO current_stock, product_name
    FROM products
    WHERE id = prod_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Product with ID % not found', prod_id;
    END IF;
    
    -- Update stock
    new_stock := current_stock + quantity_change;
    
    IF new_stock < 0 THEN
        quantity_change := -current_stock; -- Adjust to not go below zero
        new_stock := 0;
        RAISE WARNING 'Stock for % adjusted to prevent negative quantity', product_name;
    END IF;
    
    UPDATE products
    SET stock_quantity = new_stock
    WHERE id = prod_id;
    
    RAISE NOTICE 'Updated stock for %: % -> % (change: %)', 
                 product_name, current_stock, new_stock, quantity_change;
END;
$$;

-- Call the procedure
CALL update_product_stock(1, -5);

-- 7. Recursive Stored Procedure (Simulated)
-- Note: PostgreSQL doesn't support recursive procedures directly, but we can simulate with functions
CREATE OR REPLACE FUNCTION get_subordinates(manager_id INTEGER)
RETURNS TABLE(id INTEGER, name TEXT, level INTEGER) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE subordinates AS (
        SELECT e.id, e.name, 1 as level
        FROM employees e
        WHERE e.manager_id = manager_id
        
        UNION ALL
        
        SELECT e.id, e.name, s.level + 1
        FROM employees e
        JOIN subordinates s ON e.manager_id = s.id
    )
    SELECT s.id, s.name, s.level
    FROM subordinates s;
END;
$$;

-- Create procedure that uses the function
CREATE OR REPLACE PROCEDURE show_org_chart(manager_id INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    subordinate RECORD;
BEGIN
    RAISE NOTICE 'Organizational chart for manager ID %:', manager_id;
    
    FOR subordinate IN
        SELECT * FROM get_subordinates(manager_id)
        ORDER BY level, name
    LOOP
        RAISE NOTICE '% % (Level %)', 
                     REPEAT('-', subordinate.level * 2), 
                     subordinate.name, 
                     subordinate.level;
    END LOOP;
END;
$$;

-- Call the procedure
CALL show_org_chart(2);

-- 8. Stored Procedure with Error Handling
CREATE OR REPLACE PROCEDURE safe_employee_update(
    emp_id INTEGER,
    new_salary NUMERIC DEFAULT NULL,
    new_department TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    emp_exists BOOLEAN;
    current_salary NUMERIC(10,2);
    current_department TEXT;
BEGIN
    -- Check if employee exists
    SELECT EXISTS(SELECT 1 FROM employees WHERE id = emp_id) INTO emp_exists;
    
    IF NOT emp_exists THEN
        RAISE EXCEPTION 'Employee with ID % does not exist', emp_id
        USING ERRCODE = 'no_data_found';
    END IF;
    
    -- Get current values
    SELECT salary, department INTO current_salary, current_department
    FROM employees
    WHERE id = emp_id;
    
    -- Validate inputs
    IF new_salary IS NOT NULL AND new_salary < 0 THEN
        RAISE EXCEPTION 'Salary cannot be negative: %', new_salary
        USING ERRCODE = 'check_violation';
    END IF;
    
    -- Update salary if provided
    IF new_salary IS NOT NULL THEN
        UPDATE employees
        SET salary = new_salary
        WHERE id = emp_id;
        
        RAISE NOTICE 'Updated salary for employee %: % -> %', 
                     emp_id, current_salary, new_salary;
    END IF;
    
    -- Update department if provided
    IF new_department IS NOT NULL THEN
        UPDATE employees
        SET department = new_department
        WHERE id = emp_id;
        
        RAISE NOTICE 'Updated department for employee %: % -> %', 
                     emp_id, current_department, new_department;
    END IF;
    
    -- If no updates were made
    IF new_salary IS NULL AND new_department IS NULL THEN
        RAISE NOTICE 'No updates provided for employee %', emp_id;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error updating employee %: %', emp_id, SQLERRM;
        RAISE;
END;
$$;

-- Call the procedure
CALL safe_employee_update(2, 125000.00);
CALL safe_employee_update(3, NULL, 'Sales');

-- 9. Stored Procedure with Dynamic SQL
CREATE OR REPLACE PROCEDURE dynamic_report(table_name TEXT, condition TEXT DEFAULT '')
LANGUAGE plpgsql
AS $$
DECLARE
    query TEXT;
    record_count INTEGER;
BEGIN
    -- Build dynamic query
    query := 'SELECT COUNT(*) FROM ' || quote_ident(table_name);
    
    IF condition <> '' THEN
        query := query || ' WHERE ' || condition;
    END IF;
    
    -- Execute and get count
    EXECUTE query INTO record_count;
    
    RAISE NOTICE 'Table % has % records', table_name, record_count;
    
    -- Show sample records
    query := 'SELECT * FROM ' || quote_ident(table_name);
    
    IF condition <> '' THEN
        query := query || ' WHERE ' || condition;
    END IF;
    
    query := query || ' LIMIT 3';
    
    RAISE NOTICE 'Sample records from %:', table_name;
    
    -- Note: Dynamic result sets require more complex handling
    -- This is a simplified example
END;
$$;

-- Call the procedure
CALL dynamic_report('employees');
CALL dynamic_report('products', 'category = ''Electronics''');

-- 10. Stored Procedure with Temporary Tables
CREATE OR REPLACE PROCEDURE generate_sales_summary(start_date DATE, end_date DATE)
LANGUAGE plpgsql
AS $$
DECLARE
    total_revenue NUMERIC(12,2);
    transaction_count INTEGER;
BEGIN
    -- Create temporary table for summary
    CREATE TEMP TABLE sales_summary_temp AS
    SELECT 
        e.department,
        COUNT(s.id) as transaction_count,
        SUM(s.sale_amount) as department_revenue,
        AVG(s.sale_amount) as avg_transaction_value
    FROM sales s
    JOIN employees e ON s.employee_id = e.id
    WHERE s.sale_date BETWEEN start_date AND end_date
    GROUP BY e.department;
    
    -- Get overall totals
    SELECT 
        COALESCE(SUM(department_revenue), 0),
        COALESCE(SUM(transaction_count), 0)
    INTO total_revenue, transaction_count
    FROM sales_summary_temp;
    
    -- Display results
    RAISE NOTICE 'Sales Summary (% to %):', start_date, end_date;
    RAISE NOTICE 'Total Revenue: %, Total Transactions: %', total_revenue, transaction_count;
    
    -- Display department breakdown
    RAISE NOTICE 'Department Breakdown:';
    
    -- Loop through temp table
    DECLARE
        dept_record RECORD;
    BEGIN
        FOR dept_record IN SELECT * FROM sales_summary_temp ORDER BY department_revenue DESC
        LOOP
            RAISE NOTICE '  %: % transactions, % revenue, avg %', 
                         dept_record.department,
                         dept_record.transaction_count,
                         dept_record.department_revenue,
                         dept_record.avg_transaction_value;
        END LOOP;
    END;
    
    -- Clean up temp table
    DROP TABLE sales_summary_temp;
END;
$$;

-- Call the procedure
CALL generate_sales_summary('2023-01-01', '2023-12-31');

-- 11. Stored Procedure with Return Query (Using Function)
-- Note: Procedures cannot return result sets directly, but functions can
CREATE OR REPLACE FUNCTION get_top_performers(dept_name TEXT, limit_count INTEGER DEFAULT 5)
RETURNS TABLE(
    employee_name TEXT,
    department TEXT,
    total_sales NUMERIC,
    sales_count INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.name,
        e.department,
        COALESCE(SUM(s.sale_amount), 0)::NUMERIC as total_sales,
        COUNT(s.id)::INTEGER as sales_count
    FROM employees e
    LEFT JOIN sales s ON e.id = s.employee_id
    WHERE e.department = dept_name OR dept_name = 'ALL'
    GROUP BY e.id, e.name, e.department
    ORDER BY total_sales DESC
    LIMIT limit_count;
END;
$$;

-- Create procedure that calls the function
CREATE OR REPLACE PROCEDURE show_top_performers(dept_name TEXT, limit_count INTEGER DEFAULT 5)
LANGUAGE plpgsql
AS $$
DECLARE
    performer RECORD;
BEGIN
    RAISE NOTICE 'Top % performers in % department:', limit_count, dept_name;
    
    FOR performer IN
        SELECT * FROM get_top_performers(dept_name, limit_count)
    LOOP
        RAISE NOTICE '  % (% sales, % transactions)', 
                     performer.employee_name,
                     performer.total_sales,
                     performer.sales_count;
    END LOOP;
END;
$$;

-- Call the procedure
CALL show_top_performers('Engineering');
CALL show_top_performers('ALL', 3);