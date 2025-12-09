-- PostgreSQL Maintenance Examples
-- This file demonstrates various maintenance tasks for PostgreSQL databases

-- Example 1: VACUUM Operations
-- Demonstrates different types of VACUUM operations

-- Create test tables for vacuum demonstrations
DROP TABLE IF EXISTS vacuum_test CASCADE;
CREATE TABLE vacuum_test (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert sample data
INSERT INTO vacuum_test (name, description)
SELECT 
    'Record ' || g, 
    'Description for record ' || g || ' with some additional text to make it longer'
FROM generate_series(1, 10000) g;

-- Delete some records to create dead tuples
DELETE FROM vacuum_test WHERE id % 5 = 0;

-- Update some records to create more dead tuples
UPDATE vacuum_test SET description = description || ' - Updated' WHERE id % 3 = 0;

-- Standard VACUUM (recovers space and makes it available for reuse)
VACUUM VERBOSE vacuum_test;

-- VACUUM ANALYZE (vacuum + update statistics)
VACUUM ANALYZE VERBOSE vacuum_test;

-- Full VACUUM (locks table, recovers more space, repacks table)
-- Note: This locks the table exclusively and takes longer
VACUUM FULL VERBOSE vacuum_test;

-- VACUUM specific columns (only updates statistics for those columns)
VACUUM (ANALYZE, VERBOSE) vacuum_test;

-- Example 2: Database Statistics Updates
-- Shows how to update database statistics for query planner

-- Create another test table
DROP TABLE IF EXISTS stats_test CASCADE;
CREATE TABLE stats_test (
    id SERIAL PRIMARY KEY,
    category VARCHAR(50),
    value NUMERIC(10,2),
    status VARCHAR(20),
    created_date DATE DEFAULT CURRENT_DATE
);

-- Insert sample data with skewed distribution
INSERT INTO stats_test (category, value, status)
SELECT 
    CASE 
        WHEN g <= 7000 THEN 'A'
        WHEN g <= 9000 THEN 'B'
        WHEN g <= 9500 THEN 'C'
        ELSE 'D'
    END,
    RANDOM() * 1000,
    CASE 
        WHEN g % 2 = 0 THEN 'active'
        ELSE 'inactive'
    END
FROM generate_series(1, 10000) g;

-- Analyze the table to update statistics
ANALYZE VERBOSE stats_test;

-- View current statistics
SELECT 
    schemaname,
    tablename,
    attname,
    n_distinct,
    correlation
FROM pg_stats 
WHERE tablename = 'stats_test';

-- Example 3: Index Maintenance
-- Demonstrates index maintenance operations

-- Create indexes on stats_test
CREATE INDEX idx_stats_category ON stats_test(category);
CREATE INDEX idx_stats_value ON stats_test(value);
CREATE INDEX idx_stats_status ON stats_test(status);
CREATE INDEX idx_stats_created_date ON stats_test(created_date);

-- Check index usage statistics
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes 
WHERE tablename = 'stats_test';

-- Reindex a specific index
REINDEX INDEX idx_stats_category;

-- Reindex an entire table (all indexes)
REINDEX TABLE stats_test;

-- Reindex an entire database
-- REINDEX DATABASE your_database_name;

-- Example 4: Table Reorganization
-- Shows how to reorganize tables for better performance

-- Create a table with fragmentation
DROP TABLE IF EXISTS fragment_test CASCADE;
CREATE TABLE fragment_test (
    id SERIAL PRIMARY KEY,
    data VARCHAR(200),
    category CHAR(10)
);

-- Insert data
INSERT INTO fragment_test (data, category)
SELECT 
    'Data row ' || g,
    CASE WHEN g % 4 = 0 THEN 'A' ELSE 'B' END
FROM generate_series(1, 5000) g;

-- Delete many rows to create fragmentation
DELETE FROM fragment_test WHERE id % 3 = 0;

-- Cluster table based on primary key (reorganizes physically)
CLUSTER VERBOSE fragment_test USING fragment_test_pkey;

-- Alternative: Create a new table and copy data (manual reorganization)
CREATE TABLE fragment_test_new (LIKE fragment_test INCLUDING ALL);
INSERT INTO fragment_test_new SELECT * FROM fragment_test ORDER BY id;
DROP TABLE fragment_test;
ALTER TABLE fragment_test_new RENAME TO fragment_test;

-- Example 5: Database Integrity Checks
-- Demonstrates how to check database integrity

-- Basic integrity check (checks system catalogs)
CHECKPOINT;
-- Note: More thorough checks require file system level tools like pg_checksums

-- Check for constraint violations
-- This creates a function to check for foreign key violations
CREATE OR REPLACE FUNCTION check_fk_violations()
RETURNS TABLE (
    table_name TEXT,
    constraint_name TEXT,
    violation_count BIGINT
) AS $$
DECLARE
    rec RECORD;
    sql_text TEXT;
BEGIN
    FOR rec IN 
        SELECT conname, conrelid::regclass AS tablename
        FROM pg_constraint 
        WHERE contype = 'f'
    LOOP
        sql_text := format(
            'SELECT %L AS table_name, %L AS constraint_name, COUNT(*) AS violation_count FROM %I WHERE NOT EXISTS (SELECT 1 FROM %I WHERE %I = %I)',
            rec.tablename,
            rec.conname,
            rec.tablename
        );
        -- In a real implementation, you would execute this query
        -- RETURN QUERY EXECUTE sql_text;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- Example 6: Log File Maintenance
-- Shows how to manage PostgreSQL log files

-- Check current logging configuration
SHOW log_destination;
SHOW log_directory;
SHOW log_filename;
SHOW log_rotation_age;
SHOW log_rotation_size;

-- Rotate logs manually (requires reloading configuration)
-- SELECT pg_rotate_logfile();

-- Example 7: Autovacuum Configuration
-- Demonstrates autovacuum tuning

-- View current autovacuum settings
SHOW autovacuum;
SHOW autovacuum_naptime;
SHOW autovacuum_max_workers;
SHOW autovacuum_vacuum_threshold;
SHOW autovacuum_vacuum_scale_factor;
SHOW autovacuum_analyze_threshold;
SHOW autovacuum_analyze_scale_factor;

-- Configure autovacuum for a specific table
ALTER TABLE vacuum_test 
SET (autovacuum_vacuum_threshold = 500,
     autovacuum_vacuum_scale_factor = 0.1,
     autovacuum_analyze_threshold = 100,
     autovacuum_analyze_scale_factor = 0.05);

-- View autovacuum statistics
SELECT 
    relname,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze,
    vacuum_count,
    autovacuum_count,
    analyze_count,
    autoanalyze_count
FROM pg_stat_user_tables 
WHERE relname IN ('vacuum_test', 'stats_test', 'fragment_test');

-- Example 8: Performance Monitoring Queries
-- Useful queries for monitoring database maintenance needs

-- Check tables needing vacuum based on dead tuple ratio
SELECT 
    schemaname,
    relname,
    n_tup_ins,
    n_tup_upd,
    n_tup_del,
    n_live_tup,
    n_dead_tup,
    ROUND(n_dead_tup::float / (n_live_tup + 1)::float * 100, 2) AS dead_ratio_percent,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
WHERE n_dead_tup > 0
ORDER BY dead_ratio_percent DESC;

-- Check index usage efficiency
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch,
    CASE 
        WHEN idx_scan = 0 THEN 'Never Used'
        WHEN idx_tup_read::float / NULLIF(idx_scan, 0) > 1000 THEN 'High Read Ratio'
        ELSE 'OK'
    END AS efficiency_note
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC;

-- Check table bloat
SELECT 
    schemaname,
    tblname,
    bs * tblpages AS real_size,
    (tblpages - est_tblpages) * bs AS extra_size,
    CASE 
        WHEN tblpages - est_tblpages > 0 THEN 
            ROUND(100 * (tblpages - est_tblpages) / tblpages::float, 2)::text || '%'
        ELSE '0%'
    END AS extra_ratio,
    fillfactor
FROM (
    SELECT 
        schemaname,
        tblname,
        bs,
        tblpages,
        CEIL(reltuples / ((bs - pagehdr) / rowhdr / fact)) * fact AS est_tblpages,
        fillfactor
    FROM (
        SELECT 
            schemaname,
            tblname,
            bs,
            tblpages,
            reltuples,
            fillfactor,
            CASE 
                WHEN version() ~ 'mingw32' OR version() ~ '64-bit|x86_64|ppc64|ia64|amd64' THEN 8
                ELSE 4
            END AS ma,
            24 AS pagehdr,
            23 + CASE 
                WHEN MAX(coalesce(null_frac, 0)) > 0 THEN (7 + count(*)) / 8
                ELSE 0::int
            END AS rowhdr,
            CASE 
                WHEN SUM((1 - coalesce(null_frac, 0)) * coalesce(avg_width, 1024)) < 1 THEN 1
                ELSE SUM((1 - coalesce(null_frac, 0)) * coalesce(avg_width, 1024))
            END AS fact
        FROM (
            SELECT 
                schemaname,
                tblname,
                bs,
                tblpages,
                reltuples,
                fillfactor,
                null_frac,
                avg_width
            FROM (
                SELECT 
                    schemaname,
                    tblname,
                    bs,
                    tblpages,
                    reltuples,
                    fillfactor,
                    (SELECT SUBSTRING(replace(replace(pg_catalog.pg_get_expr(c.relpartbound, c.oid), 'FOR VALUES FROM (', ''), ') TO (', ','), 1, POSITION(',' IN replace(replace(pg_catalog.pg_get_expr(c.relpartbound, c.oid), 'FOR VALUES FROM (', ''), ') TO (', ',')) - 1) FROM pg_class c WHERE c.oid = a.attrelid) AS partition_lower_bound
                FROM (
                    SELECT 
                        schemaname,
                        tblname,
                        bs,
                        tblpages,
                        reltuples,
                        fillfactor,
                        a.attrelid,
                        a.attnum,
                        a.attname,
                        a.atttypid,
                        a.attstattarget,
                        a.attlen,
                        a.attnum,
                        a.attndims,
                        a.attcacheoff,
                        a.atttypmod,
                        a.attbyval,
                        a.attstorage,
                        a.attalign,
                        a.attnotnull,
                        a.atthasdef,
                        a.atthasmissing,
                        a.attidentity,
                        a.attgenerated,
                        a.attisdropped,
                        a.attislocal,
                        a.attinhcount,
                        a.attcollation,
                        a.attacl,
                        a.attoptions,
                        a.attfdwoptions,
                        s.null_frac,
                        s.avg_width,
                        s.n_distinct,
                        NULL AS correlation
                    FROM pg_stat_user_tables st
                    JOIN pg_class c ON c.oid = st.relid
                    JOIN pg_namespace n ON n.oid = c.relnamespace
                    JOIN pg_attribute a ON a.attrelid = c.oid
                    LEFT JOIN pg_stats s ON s.schemaname = n.nspname AND s.tablename = c.relname AND s.attname = a.attname
                    WHERE a.attnum > 0 AND NOT a.attisdropped
                ) a
            ) b
            GROUP BY schemaname, tblname, bs, tblpages, reltuples, fillfactor
        ) c
    ) d
) e
ORDER BY extra_size DESC;

-- Example 9: Maintenance Window Planning
-- Shows how to schedule maintenance during low-activity periods

-- Create a maintenance log table
DROP TABLE IF EXISTS maintenance_log CASCADE;
CREATE TABLE maintenance_log (
    id SERIAL PRIMARY KEY,
    maintenance_type VARCHAR(50),
    table_name VARCHAR(100),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    duration INTERVAL,
    details TEXT
);

-- Function to log maintenance activities
CREATE OR REPLACE FUNCTION log_maintenance(
    p_type VARCHAR,
    p_table VARCHAR,
    p_start TIMESTAMP,
    p_end TIMESTAMP,
    p_details TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO maintenance_log (maintenance_type, table_name, start_time, end_time, duration, details)
    VALUES (p_type, p_table, p_start, p_end, p_end - p_start, p_details);
END;
$$ LANGUAGE plpgsql;

-- Example usage of maintenance logging
SELECT log_maintenance('VACUUM', 'vacuum_test', NOW(), NOW() + INTERVAL '5 minutes', 'Standard vacuum operation');

-- Example 10: Automated Maintenance Scripts
-- Templates for automated maintenance scripts

-- Sample bash script for automated vacuum
/*
#!/bin/bash
# PostgreSQL Automated Vacuum Script

# Configuration
PG_USER="postgres"
PG_DATABASE="your_database"
PG_HOST="localhost"
LOG_FILE="/var/log/postgresql/maintenance.log"

# Log function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Perform vacuum analyze on all tables
log_message "Starting automated vacuum process"
psql -U $PG_USER -d $PG_DATABASE -h $PG_HOST -c "VACUUM ANALYZE;"
VACUUM_STATUS=$?

if [ $VACUUM_STATUS -eq 0 ]; then
    log_message "Vacuum completed successfully"
else
    log_message "Vacuum failed with exit code $VACUUM_STATUS"
fi

# Check for tables needing attention
TABLES_NEEDING_VACUUM=$(psql -U $PG_USER -d $PG_DATABASE -h $PG_HOST -t -c "
    SELECT relname 
    FROM pg_stat_user_tables 
    WHERE n_dead_tup > (n_live_tup * 0.1 + 50)
")

if [ ! -z "$TABLES_NEEDING_VACUUM" ]; then
    log_message "Tables needing vacuum: $TABLES_NEEDING_VACUUM"
    echo "$TABLES_NEEDING_VACUUM" | while read table; do
        if [ ! -z "$table" ]; then
            psql -U $PG_USER -d $PG_DATABASE -h $PG_HOST -c "VACUUM VERBOSE $table;"
        fi
    done
fi

log_message "Automated vacuum process completed"
*/

-- Sample SQL script for weekly maintenance
/*
-- Weekly PostgreSQL Maintenance Script

-- 1. Full vacuum on heavily updated tables
VACUUM FULL VERBOSE large_transaction_table;

-- 2. Reindex heavily used indexes
REINDEX INDEX idx_transactions_date;

-- 3. Update statistics
ANALYZE VERBOSE;

-- 4. Check for and remove expired data
DELETE FROM session_table WHERE expires < NOW();
VACUUM session_table;

-- 5. Log maintenance activities
INSERT INTO maintenance_log (maintenance_type, table_name, start_time, end_time, duration, details)
VALUES ('WEEKLY_MAINTENANCE', 'ALL_TABLES', NOW() - INTERVAL '1 hour', NOW(), INTERVAL '1 hour', 'Full vacuum, reindex, analyze');
*/