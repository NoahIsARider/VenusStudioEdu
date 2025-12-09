-- PostgreSQL Triggers Examples
-- This file demonstrates various trigger techniques in PostgreSQL

-- Create sample tables for demonstration
DROP TABLE IF EXISTS employees CASCADE;
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS employee_audit CASCADE;
CREATE TABLE employee_audit (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER,
    action VARCHAR(20),
    old_data JSONB,
    new_data JSONB,
    changed_by TEXT DEFAULT USER,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INTEGER CHECK (stock_quantity >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS inventory_log CASCADE;
CREATE TABLE inventory_log (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    change_amount INTEGER,
    reason VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO employees (name, email, department, salary, hire_date) VALUES
('John CEO', 'john@company.com', 'Executive', 150000.00, '2020-01-01'),
('Sarah Manager', 'sarah@company.com', 'Engineering', 120000.00, '2020-02-01'),
('Mike Developer', 'mike@company.com', 'Engineering', 90000.00, '2020-03-01');

INSERT INTO products (name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 1200.00, 50),
('Mouse', 'Electronics', 25.00, 100),
('Keyboard', 'Electronics', 75.00, 75);

-- 1. Basic Row-Level Trigger
-- Create function for trigger
CREATE OR REPLACE FUNCTION update_employee_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER employee_update_trigger
    BEFORE UPDATE ON employees
    FOR EACH ROW
    EXECUTE FUNCTION update_employee_timestamp();

-- Test the trigger
UPDATE employees SET salary = 95000.00 WHERE id = 3;
SELECT * FROM employees WHERE id = 3;

-- 2. Audit Trail Trigger
-- Create function for audit trail
CREATE OR REPLACE FUNCTION audit_employee_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employee_audit (employee_id, action, new_data)
        VALUES (NEW.id, 'INSERT', to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO employee_audit (employee_id, action, old_data, new_data)
        VALUES (NEW.id, 'UPDATE', to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO employee_audit (employee_id, action, old_data)
        VALUES (OLD.id, 'DELETE', to_jsonb(OLD));
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create audit trigger
CREATE TRIGGER employee_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON employees
    FOR EACH ROW
    EXECUTE FUNCTION audit_employee_changes();

-- Test audit trigger
INSERT INTO employees (name, email, department, salary, hire_date)
VALUES ('Alice Designer', 'alice@company.com', 'Design', 80000.00, '2023-01-15');

UPDATE employees SET salary = 85000.00 WHERE id = 4;

DELETE FROM employees WHERE id = 4;

-- View audit trail
SELECT * FROM employee_audit ORDER BY changed_at;

-- 3. Conditional Trigger
-- Create function for conditional logic
CREATE OR REPLACE FUNCTION validate_salary_increase()
RETURNS TRIGGER AS $$
BEGIN
    -- Only allow salary increases of 10% or less
    IF NEW.salary > OLD.salary * 1.1 THEN
        RAISE EXCEPTION 'Salary increase cannot exceed 10%%. Current: %, Requested: %', 
                        OLD.salary, NEW.salary;
    END IF;
    
    -- Log significant changes
    IF NEW.salary > OLD.salary * 1.05 THEN
        RAISE NOTICE 'Significant salary increase for employee %: % -> %', 
                     NEW.id, OLD.salary, NEW.salary;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create conditional trigger
CREATE TRIGGER salary_validation_trigger
    BEFORE UPDATE OF salary ON employees
    FOR EACH ROW
    WHEN (OLD.salary IS DISTINCT FROM NEW.salary)
    EXECUTE FUNCTION validate_salary_increase();

-- Test conditional trigger
UPDATE employees SET salary = 99000.00 WHERE id = 3; -- 10% increase, should work
-- UPDATE employees SET salary = 100000.00 WHERE id = 3; -- >10% increase, should fail

-- 4. Inventory Management Trigger
-- Create function for inventory tracking
CREATE OR REPLACE FUNCTION track_inventory_changes()
RETURNS TRIGGER AS $$
BEGIN
    -- Only track changes to stock_quantity
    IF OLD.stock_quantity IS DISTINCT FROM NEW.stock_quantity THEN
        -- Log the change
        INSERT INTO inventory_log (product_id, change_amount, reason)
        VALUES (
            NEW.id, 
            NEW.stock_quantity - OLD.stock_quantity, 
            'Stock update'
        );
        
        -- Notify if stock is low
        IF NEW.stock_quantity < 10 THEN
            RAISE NOTICE 'Low stock alert for product % (%): % units remaining', 
                         NEW.id, NEW.name, NEW.stock_quantity;
        END IF;
    END IF;
    
    -- Update last_updated timestamp
    NEW.last_updated = CURRENT_TIMESTAMP;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create inventory trigger
CREATE TRIGGER inventory_tracking_trigger
    BEFORE UPDATE OF stock_quantity ON products
    FOR EACH ROW
    EXECUTE FUNCTION track_inventory_changes();

-- Test inventory trigger
UPDATE products SET stock_quantity = 5 WHERE id = 1; -- Should trigger low stock alert

-- View inventory log
SELECT p.name, il.change_amount, il.reason, il.changed_at
FROM inventory_log il
JOIN products p ON il.product_id = p.id
ORDER BY il.changed_at;

-- 5. Preventive Trigger
-- Create function to prevent deletion of active employees
CREATE OR REPLACE FUNCTION prevent_active_employee_deletion()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if employee has active orders
    IF EXISTS (SELECT 1 FROM orders WHERE customer_name = OLD.name AND status = 'pending') THEN
        RAISE EXCEPTION 'Cannot delete employee % who has active orders', OLD.name;
    END IF;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Create preventive trigger
CREATE TRIGGER prevent_employee_deletion_trigger
    BEFORE DELETE ON employees
    FOR EACH ROW
    EXECUTE FUNCTION prevent_active_employee_deletion();

-- Test preventive trigger
-- First create an order for the employee
INSERT INTO orders (customer_name, total_amount, status)
VALUES ('Sarah Manager', 5000.00, 'pending');

-- This should fail
-- DELETE FROM employees WHERE name = 'Sarah Manager';

-- 6. Cascading Trigger
-- Create function for cascading updates
CREATE OR REPLACE FUNCTION update_related_records()
RETURNS TRIGGER AS $$
BEGIN
    -- If employee department changes, update related records
    IF OLD.department IS DISTINCT FROM NEW.department THEN
        RAISE NOTICE 'Updating department for employee %: % -> %', 
                     NEW.name, OLD.department, NEW.department;
        
        -- In a real scenario, you might update related tables here
        -- For example, updating project assignments, access permissions, etc.
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create cascading trigger
CREATE TRIGGER cascading_update_trigger
    AFTER UPDATE OF department ON employees
    FOR EACH ROW
    EXECUTE FUNCTION update_related_records();

-- Test cascading trigger
UPDATE employees SET department = 'Research' WHERE id = 2;

-- 7. Statement-Level Trigger
-- Create function for statement-level operations
CREATE OR REPLACE FUNCTION log_bulk_operations()
RETURNS TRIGGER AS $$
DECLARE
    row_count INTEGER;
BEGIN
    -- Get the number of affected rows
    GET DIAGNOSTICS row_count = ROW_COUNT;
    
    -- Log the operation
    RAISE NOTICE '% operation on % affected % rows', 
                 TG_OP, TG_TABLE_NAME, row_count;
    
    RETURN NULL; -- Statement-level triggers should return NULL
END;
$$ LANGUAGE plpgsql;

-- Create statement-level trigger
CREATE TRIGGER bulk_operation_logger
    AFTER INSERT OR UPDATE OR DELETE ON employees
    FOR EACH STATEMENT
    EXECUTE FUNCTION log_bulk_operations();

-- Test statement-level trigger
INSERT INTO employees (name, email, department, salary, hire_date) VALUES
('Test User 1', 'test1@company.com', 'Testing', 50000.00, '2023-01-01'),
('Test User 2', 'test2@company.com', 'Testing', 55000.00, '2023-01-02');

-- 8. Custom Validation Trigger
-- Create function for custom email validation
CREATE OR REPLACE FUNCTION validate_employee_email()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if email domain is company domain
    IF NEW.email !~ '^[a-zA-Z0-9._%+-]+@company\.com$' THEN
        RAISE EXCEPTION 'Email must be a company domain (@company.com): %', NEW.email;
    END IF;
    
    -- Check for duplicate emails (case-insensitive)
    IF EXISTS (SELECT 1 FROM employees WHERE LOWER(email) = LOWER(NEW.email) AND id != NEW.id) THEN
        RAISE EXCEPTION 'Email already exists: %', NEW.email;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create validation trigger
CREATE TRIGGER employee_email_validation
    BEFORE INSERT OR UPDATE OF email ON employees
    FOR EACH ROW
    EXECUTE FUNCTION validate_employee_email();

-- Test validation trigger
-- This should fail
-- INSERT INTO employees (name, email, department, salary, hire_date)
-- VALUES ('Invalid User', 'invalid@gmail.com', 'Testing', 50000.00, '2023-01-01');

-- 9. Time-Based Trigger
-- Create function for business hours validation
CREATE OR REPLACE FUNCTION enforce_business_hours()
RETURNS TRIGGER AS $$
DECLARE
    current_hour INTEGER;
BEGIN
    -- Get current hour (24-hour format)
    current_hour := EXTRACT(HOUR FROM CURRENT_TIME);
    
    -- Only allow changes during business hours (9 AM to 5 PM)
    IF current_hour < 9 OR current_hour >= 17 THEN
        RAISE EXCEPTION 'Database changes only allowed during business hours (9 AM - 5 PM). Current hour: %', current_hour;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create time-based trigger (commented out for testing convenience)
/*
CREATE TRIGGER business_hours_enforcement
    BEFORE INSERT OR UPDATE OR DELETE ON employees
    FOR EACH ROW
    EXECUTE FUNCTION enforce_business_hours();
*/

-- 10. Complex Trigger with External Actions
-- Create function for complex business logic
CREATE OR REPLACE FUNCTION handle_employee_promotion()
RETURNS TRIGGER AS $$
DECLARE
    salary_increase_percent NUMERIC;
BEGIN
    -- Calculate salary increase percentage
    salary_increase_percent := ((NEW.salary - OLD.salary) / OLD.salary) * 100;
    
    -- If salary increase is more than 20%, log special event
    IF salary_increase_percent > 20 THEN
        -- Insert into a special promotions table (simulated)
        RAISE NOTICE 'Special promotion detected for employee %: %%% salary increase', 
                     NEW.name, ROUND(salary_increase_percent, 2);
        
        -- In a real scenario, you might send an email, update HR systems, etc.
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create complex trigger
CREATE TRIGGER employee_promotion_handler
    AFTER UPDATE OF salary ON employees
    FOR EACH ROW
    WHEN (NEW.salary > OLD.salary * 1.2) -- Only trigger for >20% increases
    EXECUTE FUNCTION handle_employee_promotion();

-- Test complex trigger
UPDATE employees SET salary = 150000.00 WHERE id = 3; -- ~66% increase, should trigger

-- 11. Trigger Management
-- View all triggers
SELECT 
    tgname AS trigger_name,
    relname AS table_name,
    pg_get_triggerdef(t.oid) AS trigger_definition
FROM pg_trigger t
JOIN pg_class c ON t.tgrelid = c.oid
WHERE NOT t.tgisinternal
ORDER BY relname, tgname;

-- Disable a trigger
ALTER TABLE employees DISABLE TRIGGER employee_update_trigger;

-- Enable a trigger
ALTER TABLE employees ENABLE TRIGGER employee_update_trigger;

-- Drop a trigger
-- DROP TRIGGER IF EXISTS employee_update_trigger ON employees;

-- 12. Performance Considerations
-- Create function with minimal overhead
CREATE OR REPLACE FUNCTION lightweight_audit()
RETURNS TRIGGER AS $$
BEGIN
    -- Simple audit without JSON serialization for better performance
    INSERT INTO employee_audit (employee_id, action)
    VALUES (
        CASE TG_OP 
            WHEN 'INSERT' THEN NEW.id
            WHEN 'UPDATE' THEN NEW.id
            WHEN 'DELETE' THEN OLD.id
        END,
        TG_OP
    );
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Best Practices Summary:
-- 1. Keep trigger functions lightweight
-- 2. Use statement-level triggers for bulk operations
-- 3. Be careful with recursive triggers
-- 4. Test triggers thoroughly
-- 5. Document trigger behavior
-- 6. Monitor trigger performance
-- 7. Handle errors gracefully
-- 8. Use appropriate trigger timing (BEFORE/AFTER)