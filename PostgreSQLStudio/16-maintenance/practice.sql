-- PostgreSQL Maintenance Practice Exercises
-- This file contains hands-on exercises for practicing PostgreSQL maintenance tasks

-- Exercise 1: VACUUM Strategy Implementation
-- Task: Develop and implement an effective VACUUM strategy for a high-transaction database
-- Requirements:
-- 1. Configure autovacuum parameters for different table workloads
-- 2. Create manual VACUUM schedules
-- 3. Monitor VACUUM effectiveness

-- Create test tables representing different workload patterns
DROP TABLE IF EXISTS high_update_table CASCADE;
DROP TABLE IF EXISTS moderate_insert_table CASCADE;
DROP TABLE IF EXISTS archive_table CASCADE;

CREATE TABLE high_update_table (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    transaction_amount DECIMAL(10,2),
    transaction_date TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20)
);

CREATE TABLE moderate_insert_table (
    id SERIAL PRIMARY KEY,
    log_message TEXT,
    log_level VARCHAR(10),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE archive_table (
    id SERIAL PRIMARY KEY,
    historical_data JSONB,
    archived_date DATE DEFAULT CURRENT_DATE
);

-- Insert sample data
INSERT INTO high_update_table (user_id, transaction_amount, status)
SELECT 
    (RANDOM() * 1000)::INTEGER,
    (RANDOM() * 10000)::DECIMAL(10,2),
    CASE 
        WHEN g % 3 = 0 THEN 'completed'
        WHEN g % 3 = 1 THEN 'pending'
        ELSE 'failed'
    END
FROM generate_series(1, 50000) g;

INSERT INTO moderate_insert_table (log_message, log_level)
SELECT 
    'Log entry ' || g,
    CASE 
        WHEN g % 10 = 0 THEN 'ERROR'
        WHEN g % 5 = 0 THEN 'WARN'
        ELSE 'INFO'
    END
FROM generate_series(1, 100000) g;

INSERT INTO archive_table (historical_data)
SELECT 
    jsonb_build_object(
        'record_id', g,
        'data', 'Historical data for record ' || g,
        'year', 2020 + (g % 4)
    )
FROM generate_series(1, 20000) g;

-- Your implementation here:
-- 1. Configure autovacuum for high_update_table (more frequent)
-- 2. Configure autovacuum for moderate_insert_table (standard settings)
-- 3. Configure autovacuum for archive_table (less frequent)
-- 4. Create manual VACUUM schedule
-- 5. Write queries to monitor VACUUM effectiveness

-- Example configuration (implement your own):
/*
ALTER TABLE high_update_table 
SET (autovacuum_vacuum_threshold = 100,
     autovacuum_vacuum_scale_factor = 0.05,
     autovacuum_analyze_threshold = 50,
     autovacuum_analyze_scale_factor = 0.02);

ALTER TABLE archive_table 
SET (autovacuum_vacuum_threshold = 1000,
     autovacuum_vacuum_scale_factor = 0.2,
     autovacuum_analyze_threshold = 500,
     autovacuum_analyze_scale_factor = 0.1);
*/

-- Exercise 2: Statistics Management
-- Task: Implement a comprehensive statistics management strategy
-- Requirements:
-- 1. Create custom statistics for complex queries
-- 2. Implement statistics update schedules
-- 3. Monitor statistics accuracy

-- Create tables with complex relationships
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    region VARCHAR(50),
    customer_type VARCHAR(20),
    registration_date DATE
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    supplier_id INTEGER
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER,
    order_date DATE,
    status VARCHAR(20)
);

-- Insert sample data with skewed distributions
INSERT INTO customers (name, region, customer_type, registration_date)
SELECT 
    'Customer ' || g,
    CASE 
        WHEN g <= 60000 THEN 'North'
        WHEN g <= 80000 THEN 'South'
        WHEN g <= 90000 THEN 'East'
        ELSE 'West'
    END,
    CASE 
        WHEN g <= 70000 THEN 'Retail'
        ELSE 'Wholesale'
    END,
    CURRENT_DATE - INTERVAL '1 day' * (RANDOM() * 365 * 5)::INTEGER
FROM generate_series(1, 100000) g;

INSERT INTO products (name, category, price, supplier_id)
SELECT 
    'Product ' || g,
    CASE 
        WHEN g <= 40000 THEN 'Electronics'
        WHEN g <= 70000 THEN 'Clothing'
        WHEN g <= 90000 THEN 'Home'
        ELSE 'Sports'
    END,
    (RANDOM() * 1000)::DECIMAL(10,2),
    (RANDOM() * 1000)::INTEGER
FROM generate_series(1, 100000) g;

INSERT INTO orders (customer_id, product_id, quantity, order_date, status)
SELECT 
    (RANDOM() * 100000)::INTEGER + 1,
    (RANDOM() * 100000)::INTEGER + 1,
    (RANDOM() * 10)::INTEGER + 1,
    CURRENT_DATE - INTERVAL '1 day' * (RANDOM() * 365 * 2)::INTEGER,
    CASE 
        WHEN g % 20 = 0 THEN 'Cancelled'
        WHEN g % 10 = 0 THEN 'Shipped'
        ELSE 'Completed'
    END
FROM generate_series(1, 500000) g;

-- Your implementation here:
-- 1. Create multi-column statistics for orders (customer_id, product_id, order_date)
-- 2. Create expression statistics for date-based queries
-- 3. Implement a statistics update schedule
-- 4. Write queries to verify statistics accuracy

-- Example implementation (implement your own):
/*
CREATE STATISTICS orders_customer_product_stats (dependencies, ndistinct)
ON customer_id, product_id
FROM orders;

CREATE STATISTICS orders_date_stats (dependencies)
ON DATE_TRUNC('month', order_date), status
FROM orders;

ANALYZE orders;
ANALYZE customers;
ANALYZE products;
*/

-- Exercise 3: Index Maintenance Plan
-- Task: Develop and implement a comprehensive index maintenance plan
-- Requirements:
-- 1. Identify fragmented indexes
-- 2. Schedule index rebuilds/reorgs
-- 3. Monitor index usage and effectiveness

-- Create tables with various index types
DROP TABLE IF EXISTS indexed_data CASCADE;
CREATE TABLE indexed_data (
    id SERIAL PRIMARY KEY,
    category VARCHAR(50),
    subcategory VARCHAR(50),
    value NUMERIC(12,2),
    created_date TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20),
    metadata JSONB
);

-- Create various index types
CREATE INDEX idx_category ON indexed_data(category);
CREATE INDEX idx_category_subcategory ON indexed_data(category, subcategory);
CREATE INDEX idx_value ON indexed_data(value);
CREATE INDEX idx_created_date ON indexed_data(created_date);
CREATE INDEX idx_status ON indexed_data(status);
CREATE INDEX idx_metadata_gin ON indexed_data USING GIN(metadata);

-- Insert sample data
INSERT INTO indexed_data (category, subcategory, value, status, metadata)
SELECT 
    'Category_' || ((g % 20) + 1),
    'Subcategory_' || ((g % 5) + 1),
    (RANDOM() * 10000)::NUMERIC(12,2),
    CASE 
        WHEN g % 10 = 0 THEN 'Inactive'
        ELSE 'Active'
    END,
    jsonb_build_object(
        'tag', 'tag_' || (g % 100),
        'priority', (g % 5) + 1
    )
FROM generate_series(1, 200000) g;

-- Perform updates to cause index fragmentation
UPDATE indexed_data 
SET value = value * 1.1, 
    metadata = metadata || jsonb_build_object('updated', true)
WHERE id % 7 = 0;

DELETE FROM indexed_data WHERE id % 13 = 0;

-- Your implementation here:
-- 1. Write queries to identify fragmented indexes
-- 2. Create a schedule for index maintenance
-- 3. Implement index rebuild vs reorg decision logic
-- 4. Monitor index usage statistics

-- Example implementation (implement your own):
/*
-- Query to identify potentially fragmented indexes
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch,
    CASE 
        WHEN idx_scan > 0 AND idx_tup_read::float / idx_scan > 100 THEN 'High Fragmentation'
        WHEN idx_scan > 0 AND idx_tup_read::float / idx_scan > 50 THEN 'Medium Fragmentation'
        ELSE 'Low Fragmentation'
    END AS fragmentation_level
FROM pg_stat_user_indexes
WHERE idx_scan > 0
ORDER BY idx_tup_read::float / NULLIF(idx_scan, 0) DESC;
*/

-- Exercise 4: Database Integrity Checks
-- Task: Implement comprehensive database integrity checking procedures
-- Requirements:
-- 1. Create automated integrity check scripts
-- 2. Implement constraint validation
-- 3. Set up alerting for integrity issues

-- Your implementation here:
-- 1. Write functions to check for common integrity issues
-- 2. Create a comprehensive integrity check procedure
-- 3. Implement alerting mechanisms

-- Example implementation outline:
/*
-- Function to check for foreign key violations
CREATE OR REPLACE FUNCTION check_foreign_key_integrity()
RETURNS TABLE (
    table_name TEXT,
    constraint_name TEXT,
    violation_count BIGINT
) AS $$
BEGIN
    -- Implementation would dynamically check all FK constraints
    -- This is a simplified example
    RETURN QUERY SELECT 'example_table', 'example_constraint', 0::BIGINT;
END;
$$ LANGUAGE plpgsql;

-- Function to check for data consistency
CREATE OR REPLACE FUNCTION check_data_consistency()
RETURNS TABLE (
    check_name TEXT,
    status TEXT,
    details TEXT
) AS $$
BEGIN
    -- Implementation would check various data consistency rules
    RETURN QUERY SELECT 'sample_check', 'PASS', 'No issues found'::TEXT;
END;
$$ LANGUAGE plpgsql;
*/

-- Exercise 5: Performance Monitoring Dashboard
-- Task: Create a performance monitoring dashboard for maintenance activities
-- Requirements:
-- 1. Design monitoring queries for key metrics
-- 2. Create views for easy reporting
-- 3. Implement alert thresholds

-- Your implementation here:
-- 1. Create views for maintenance metrics
-- 2. Write monitoring queries
-- 3. Define alert thresholds

-- Example implementation (implement your own):
/*
-- View for table bloat monitoring
CREATE OR REPLACE VIEW table_bloat_monitor AS
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) AS table_size,
    CASE 
        WHEN pg_total_relation_size(schemaname||'.'||tablename) > 0 THEN
            ROUND(
                (pg_total_relation_size(schemaname||'.'||tablename) - pg_relation_size(schemaname||'.'||tablename))::numeric 
                / pg_total_relation_size(schemaname||'.'||tablename) * 100, 2
            )
        ELSE 0
    END AS bloat_percentage
FROM pg_tables
WHERE schemaname NOT IN ('information_schema', 'pg_catalog')
ORDER BY bloat_percentage DESC;

-- View for autovacuum monitoring
CREATE OR REPLACE VIEW autovacuum_monitor AS
SELECT 
    schemaname,
    tablename,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze,
    vacuum_count,
    autovacuum_count,
    analyze_count,
    autoanalyze_count,
    n_tup_ins,
    n_tup_upd,
    n_tup_del,
    n_live_tup,
    n_dead_tup,
    ROUND(n_dead_tup::float / NULLIF(n_live_tup, 0) * 100, 2) AS dead_tuple_percentage
FROM pg_stat_user_tables
ORDER BY last_autovacuum NULLS FIRST;
*/

-- Exercise 6: Log Management and Analysis
-- Task: Implement log management and analysis for maintenance optimization
-- Requirements:
-- 1. Configure PostgreSQL logging for maintenance insights
-- 2. Create log analysis scripts
-- 3. Implement log-based alerting

-- Your implementation here:
-- 1. Configure appropriate logging parameters
-- 2. Create log parsing and analysis functions
-- 3. Set up alerts based on log patterns

-- Example configuration (would be in postgresql.conf):
/*
log_min_duration_statement = 1000  # Log statements taking longer than 1 second
log_checkpoints = on
log_connections = on
log_disconnections = on
log_lock_waits = on
log_temp_files = 0
log_autovacuum_min_duration = 0
*/

-- Exercise 7: Backup and Recovery Integration
-- Task: Integrate maintenance activities with backup and recovery procedures
-- Requirements:
-- 1. Schedule maintenance before backups
-- 2. Verify backup integrity after maintenance
-- 3. Document maintenance impact on recovery procedures

-- Your implementation here:
-- 1. Create maintenance procedures that integrate with backup schedules
-- 2. Implement backup verification after maintenance
-- 3. Document procedures and dependencies

-- Example implementation outline:
/*
-- Function to perform pre-backup maintenance
CREATE OR REPLACE FUNCTION pre_backup_maintenance()
RETURNS VOID AS $$
BEGIN
    -- Perform ANALYZE on all tables
    ANALYZE;
    
    -- Log maintenance activity
    INSERT INTO maintenance_log (maintenance_type, table_name, start_time, end_time, duration, details)
    VALUES ('PRE_BACKUP', 'ALL_TABLES', NOW(), NOW(), '0', 'Pre-backup ANALYZE completed');
END;
$$ LANGUAGE plpgsql;
*/

-- Exercise 8: Resource Usage Optimization
-- Task: Optimize maintenance resource usage to minimize impact on production
-- Requirements:
-- 1. Configure maintenance resource limits
-- 2. Schedule maintenance during low-usage periods
-- 3. Monitor resource consumption during maintenance

-- Your implementation here:
-- 1. Configure maintenance workers and resource limits
-- 2. Create resource monitoring queries
-- 3. Implement adaptive maintenance scheduling

-- Example configuration (would be in postgresql.conf):
/*
maintenance_work_mem = 256MB
autovacuum_work_mem = 128MB
max_parallel_maintenance_workers = 4
*/

-- Exercise 9: Maintenance Automation Script
-- Task: Create a comprehensive maintenance automation script
-- Requirements:
-- 1. Automate routine maintenance tasks
-- 2. Include error handling and logging
-- 3. Provide detailed reporting

-- Your implementation here:
-- Create a comprehensive maintenance script that performs:
-- 1. VACUUM ANALYZE on tables with significant changes
-- 2. REINDEX on fragmented indexes
-- 3. Update statistics
-- 4. Log all activities
-- 5. Report on maintenance outcomes

-- Example implementation outline:
/*
-- This would typically be a shell script or PL/pgSQL function that:
-- 1. Checks maintenance prerequisites
-- 2. Executes maintenance tasks in proper order
-- 3. Monitors progress and handles errors
-- 4. Logs results and sends notifications
*/

-- Exercise 10: Compliance and Audit Trail
-- Task: Implement maintenance procedures that meet compliance requirements
-- Requirements:
-- 1. Create audit trails for all maintenance activities
-- 2. Implement compliance checks
-- 3. Generate compliance reports

-- Your implementation here:
-- 1. Enhance maintenance_log table with compliance fields
-- 2. Create compliance verification procedures
-- 3. Generate audit reports

-- Enhanced maintenance log table for compliance
DROP TABLE IF EXISTS compliance_maintenance_log CASCADE;
CREATE TABLE compliance_maintenance_log (
    id SERIAL PRIMARY KEY,
    maintenance_type VARCHAR(50),
    table_name VARCHAR(100),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    duration INTERVAL,
    details TEXT,
    performed_by VARCHAR(100),
    approval_reference VARCHAR(100),
    compliance_status VARCHAR(20),
    audit_trail JSONB
);

-- Example implementation (implement your own):
/*
-- Function to log compliant maintenance
CREATE OR REPLACE FUNCTION log_compliant_maintenance(
    p_type VARCHAR,
    p_table VARCHAR,
    p_performed_by VARCHAR,
    p_approval_ref VARCHAR
) RETURNS VOID AS $$
BEGIN
    INSERT INTO compliance_maintenance_log (
        maintenance_type, 
        table_name, 
        start_time, 
        end_time, 
        duration, 
        details, 
        performed_by, 
        approval_reference, 
        compliance_status,
        audit_trail
    )
    VALUES (
        p_type, 
        p_table, 
        NOW(), 
        NOW(), 
        '0', 
        'Maintenance operation completed', 
        p_performed_by, 
        p_approval_ref, 
        'COMPLIANT',
        jsonb_build_object(
            'script_version', '1.0',
            'environment', 'PRODUCTION',
            'change_control_ticket', p_approval_ref
        )
    );
END;
$$ LANGUAGE plpgsql;
*/

-- Bonus Exercise: Enterprise Maintenance Framework
-- Task: Design an enterprise-scale maintenance framework
-- Requirements:
-- 1. Multi-database maintenance coordination
-- 2. Cross-platform compatibility
-- 3. Advanced scheduling and dependency management
-- 4. Comprehensive reporting and alerting

-- Your implementation here:
-- Design a framework that includes:
-- 1. Centralized maintenance job management
-- 2. Dependency-aware scheduling
-- 3. Multi-database coordination
-- 4. Advanced monitoring and alerting
-- 5. Self-tuning capabilities

-- Example framework components (conceptual):
/*
-- Maintenance job registry
CREATE TABLE maintenance_jobs (
    job_id SERIAL PRIMARY KEY,
    job_name VARCHAR(100),
    database_name VARCHAR(100),
    job_type VARCHAR(50),
    schedule_expression VARCHAR(100),
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP,
    last_status VARCHAR(20),
    dependency_job_ids INTEGER[],
    resource_requirements JSONB
);

-- Maintenance job execution log
CREATE TABLE maintenance_job_executions (
    execution_id SERIAL PRIMARY KEY,
    job_id INTEGER REFERENCES maintenance_jobs(job_id),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status VARCHAR(20),
    output_text TEXT,
    error_text TEXT,
    performance_metrics JSONB
);

-- Framework management functions would go here...
*/

-- Additional Practice Tips:
-- 1. Practice maintenance procedures in a test environment first
-- 2. Monitor system performance during maintenance windows
-- 3. Document all maintenance procedures and schedules
-- 4. Regularly review and optimize maintenance strategies
-- 5. Test recovery procedures after major maintenance activities
-- 6. Keep PostgreSQL documentation handy for version-specific features