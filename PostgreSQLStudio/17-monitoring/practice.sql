-- PostgreSQL Monitoring Practice Exercises
-- This script contains hands-on exercises for PostgreSQL monitoring operations

-- Connect to PostgreSQL (adjust connection parameters as needed)
-- psql -h localhost -p 5432 -U postgres -d postgres

-- Exercise 1: Implement a Comprehensive Monitoring Dashboard
/*
Exercise 1: Create a comprehensive monitoring dashboard
Requirements:
1. Create views for key performance indicators
2. Develop functions to collect monitoring data
3. Build a dashboard query that aggregates all metrics
4. Include database health indicators
*/

-- Solution for Exercise 1
-- 1.1 Create a view for active sessions
CREATE OR REPLACE VIEW monitoring_active_sessions AS
SELECT 
    pid,
    usename,
    application_name,
    client_addr,
    backend_start,
    state,
    query_start,
    EXTRACT(EPOCH FROM (NOW() - query_start)) AS query_duration_seconds,
    query
FROM pg_stat_activity
WHERE state = 'active'
AND query NOT ILIKE '%pg_stat_activity%';

-- 1.2 Create a view for table statistics
CREATE OR REPLACE VIEW monitoring_table_stats AS
SELECT 
    schemaname,
    tablename,
    seq_scan,
    seq_tup_read,
    idx_scan,
    idx_tup_fetch,
    n_tup_ins,
    n_tup_upd,
    n_tup_del,
    n_live_tup,
    n_dead_tup,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables;

-- 1.3 Create a function to get database size information
CREATE OR REPLACE FUNCTION monitoring_get_database_sizes()
RETURNS TABLE(
    database_name TEXT,
    size_text TEXT,
    size_bytes BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        datname::TEXT AS database_name,
        pg_size_pretty(pg_database_size(datname))::TEXT AS size_text,
        pg_database_size(datname) AS size_bytes
    FROM pg_database
    WHERE datname NOT IN ('template0', 'template1')
    ORDER BY pg_database_size(datname) DESC;
END;
$$ LANGUAGE plpgsql;

-- 1.4 Create a dashboard query that aggregates key metrics
CREATE OR REPLACE VIEW monitoring_dashboard AS
SELECT 
    -- Server information
    (SELECT version()) AS server_version,
    (SELECT pg_postmaster_start_time()) AS server_start_time,
    EXTRACT(EPOCH FROM (NOW() - (SELECT pg_postmaster_start_time())))::INTEGER/3600 AS uptime_hours,
    
    -- Connection information
    (SELECT COUNT(*) FROM pg_stat_activity) AS total_connections,
    (SELECT COUNT(*) FROM pg_stat_activity WHERE state = 'active') AS active_connections,
    
    -- Database size (using our function)
    (SELECT STRING_AGG(database_name || ': ' || size_text, ', ') 
     FROM monitoring_get_database_sizes()) AS database_sizes,
     
    -- Query performance
    (SELECT COALESCE(SUM(calls), 0) FROM pg_stat_statements) AS total_queries_executed,
    (SELECT COALESCE(MAX(mean_time), 0) FROM pg_stat_statements) AS max_avg_query_time,
    
    -- Transaction information
    (SELECT xact_commit FROM pg_stat_database WHERE datname = current_database()) AS transactions_committed,
    (SELECT xact_rollback FROM pg_stat_database WHERE datname = current_database()) AS transactions_rolled_back;

-- Exercise 2: Set Up Automated Performance Alerts
/*
Exercise 2: Implement automated performance alerts
Requirements:
1. Create functions to check performance thresholds
2. Set up scheduled jobs to run checks
3. Implement alert logging mechanism
4. Create procedures to handle different alert types
*/

-- Solution for Exercise 2
-- 2.1 Create table for alert logs
CREATE TABLE IF NOT EXISTS monitoring_alerts (
    id SERIAL PRIMARY KEY,
    alert_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    alert_type TEXT NOT NULL,
    severity TEXT CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    message TEXT NOT NULL,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_time TIMESTAMP WITH TIME ZONE
);

-- 2.2 Create function to check for long running queries
CREATE OR REPLACE FUNCTION monitoring_check_long_running_queries(threshold_seconds INTEGER DEFAULT 30)
RETURNS TABLE(
    alert_generated BOOLEAN,
    message TEXT
) AS $$
DECLARE
    long_running_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO long_running_count
    FROM pg_stat_activity
    WHERE state = 'active' 
    AND query_start < NOW() - INTERVAL '1 second' * threshold_seconds;
    
    IF long_running_count > 0 THEN
        INSERT INTO monitoring_alerts (alert_type, severity, message)
        VALUES ('LONG_RUNNING_QUERIES', 'HIGH', 
                format('Detected %s queries running longer than %s seconds', 
                       long_running_count, threshold_seconds));
        
        RETURN QUERY SELECT TRUE, format('Alert generated for %s long running queries', long_running_count);
    ELSE
        RETURN QUERY SELECT FALSE, 'No long running queries detected';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 2.3 Create function to check connection count
CREATE OR REPLACE FUNCTION monitoring_check_connection_count(max_connections INTEGER DEFAULT 100)
RETURNS TABLE(
    alert_generated BOOLEAN,
    message TEXT
) AS $$
DECLARE
    current_connections INTEGER;
BEGIN
    SELECT COUNT(*) INTO current_connections FROM pg_stat_activity;
    
    IF current_connections > max_connections THEN
        INSERT INTO monitoring_alerts (alert_type, severity, message)
        VALUES ('HIGH_CONNECTION_COUNT', 'MEDIUM', 
                format('Connection count (%s) exceeds threshold (%s)', 
                       current_connections, max_connections));
        
        RETURN QUERY SELECT TRUE, format('Alert generated for high connection count: %s', current_connections);
    ELSE
        RETURN QUERY SELECT FALSE, format('Connection count (%s) within acceptable limits', current_connections);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 2.4 Create procedure to run all checks
CREATE OR REPLACE PROCEDURE monitoring_run_all_checks()
AS $$
DECLARE
    result RECORD;
BEGIN
    -- Check long running queries
    SELECT * INTO result FROM monitoring_check_long_running_queries(30);
    RAISE NOTICE 'Long running queries check: %', result.message;
    
    -- Check connection count
    SELECT * INTO result FROM monitoring_check_connection_count(100);
    RAISE NOTICE 'Connection count check: %', result.message;
    
    -- In a real implementation, you would add more checks here
    -- For example: check for table bloat, index usage, autovacuum activity, etc.
    
    RAISE NOTICE 'All monitoring checks completed';
END;
$$ LANGUAGE plpgsql;

-- Exercise 3: Implement Database Growth Tracking
/*
Exercise 3: Track database growth over time
Requirements:
1. Create tables to store historical size data
2. Develop procedures to capture size snapshots
3. Build reports showing growth trends
4. Implement retention policies for historical data
*/

-- Solution for Exercise 3
-- 3.1 Create table for database size history
CREATE TABLE IF NOT EXISTS monitoring_database_size_history (
    id SERIAL PRIMARY KEY,
    snapshot_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    database_name TEXT NOT NULL,
    size_bytes BIGINT NOT NULL,
    size_text TEXT
);

-- 3.2 Create table for table size history
CREATE TABLE IF NOT EXISTS monitoring_table_size_history (
    id SERIAL PRIMARY KEY,
    snapshot_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    schema_name TEXT NOT NULL,
    table_name TEXT NOT NULL,
    size_bytes BIGINT NOT NULL,
    size_text TEXT
);

-- 3.3 Create procedure to capture database size snapshot
CREATE OR REPLACE PROCEDURE monitoring_capture_database_size_snapshot()
AS $$
BEGIN
    -- Insert current database sizes
    INSERT INTO monitoring_database_size_history (database_name, size_bytes, size_text)
    SELECT 
        datname,
        pg_database_size(datname),
        pg_size_pretty(pg_database_size(datname))
    FROM pg_database
    WHERE datname NOT IN ('template0', 'template1');
    
    RAISE NOTICE 'Database size snapshot captured';
END;
$$ LANGUAGE plpgsql;

-- 3.4 Create procedure to capture table size snapshot
CREATE OR REPLACE PROCEDURE monitoring_capture_table_size_snapshot()
AS $$
BEGIN
    -- Insert current table sizes for user tables
    INSERT INTO monitoring_table_size_history (schema_name, table_name, size_bytes, size_text)
    SELECT 
        schemaname,
        tablename,
        pg_total_relation_size(schemaname||'.'||tablename),
        pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename))
    FROM pg_tables
    WHERE schemaname NOT IN ('information_schema', 'pg_catalog');
    
    RAISE NOTICE 'Table size snapshot captured';
END;
$$ LANGUAGE plpgsql;

-- 3.5 Create function to generate growth report
CREATE OR REPLACE FUNCTION monitoring_generate_growth_report(days_back INTEGER DEFAULT 30)
RETURNS TABLE(
    database_name TEXT,
    earliest_size TEXT,
    latest_size TEXT,
    growth_amount TEXT,
    growth_percentage NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH size_data AS (
        SELECT 
            database_name,
            FIRST_VALUE(size_bytes) OVER (PARTITION BY database_name ORDER BY snapshot_time) as earliest_size,
            LAST_VALUE(size_bytes) OVER (PARTITION BY database_name ORDER BY snapshot_time 
                                        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as latest_size
        FROM monitoring_database_size_history
        WHERE snapshot_time >= NOW() - INTERVAL '1 day' * days_back
    )
    SELECT 
        database_name,
        pg_size_pretty(MIN(earliest_size)) as earliest_size,
        pg_size_pretty(MAX(latest_size)) as latest_size,
        pg_size_pretty(MAX(latest_size) - MIN(earliest_size)) as growth_amount,
        ROUND(((MAX(latest_size)::NUMERIC - MIN(earliest_size)::NUMERIC) / 
               GREATEST(MIN(earliest_size)::NUMERIC, 1)) * 100, 2) as growth_percentage
    FROM size_data
    GROUP BY database_name
    HAVING MIN(earliest_size) > 0;
END;
$$ LANGUAGE plpgsql;

-- 3.6 Create procedure to clean old history data
CREATE OR REPLACE PROCEDURE monitoring_cleanup_old_data(retention_days INTEGER DEFAULT 90)
AS $$
BEGIN
    DELETE FROM monitoring_database_size_history 
    WHERE snapshot_time < NOW() - INTERVAL '1 day' * retention_days;
    
    DELETE FROM monitoring_table_size_history 
    WHERE snapshot_time < NOW() - INTERVAL '1 day' * retention_days;
    
    DELETE FROM monitoring_alerts 
    WHERE alert_time < NOW() - INTERVAL '1 day' * retention_days;
    
    RAISE NOTICE 'Cleaned up monitoring data older than % days', retention_days;
END;
$$ LANGUAGE plpgsql;

-- Exercise 4: Create Custom Monitoring Extensions
/*
Exercise 4: Develop custom monitoring extensions
Requirements:
1. Create custom functions for specialized monitoring
2. Implement data collection for business metrics
3. Build reporting procedures for custom metrics
4. Integrate with existing monitoring framework
*/

-- Solution for Exercise 4
-- 4.1 Create a table for application-specific metrics
CREATE TABLE IF NOT EXISTS monitoring_application_metrics (
    id SERIAL PRIMARY KEY,
    metric_name TEXT NOT NULL,
    metric_value NUMERIC NOT NULL,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    context JSONB
);

-- 4.2 Create function to record application metrics
CREATE OR REPLACE FUNCTION monitoring_record_app_metric(
    metric_name TEXT,
    metric_value NUMERIC,
    context JSONB DEFAULT '{}'
) RETURNS VOID AS $$
BEGIN
    INSERT INTO monitoring_application_metrics (metric_name, metric_value, context)
    VALUES (metric_name, metric_value, context);
END;
$$ LANGUAGE plpgsql;

-- 4.3 Create a view for recent application metrics
CREATE OR REPLACE VIEW monitoring_recent_app_metrics AS
SELECT 
    metric_name,
    AVG(metric_value) as avg_value,
    MIN(metric_value) as min_value,
    MAX(metric_value) as max_value,
    COUNT(*) as sample_count,
    MIN(recorded_at) as first_recorded,
    MAX(recorded_at) as last_recorded
FROM monitoring_application_metrics
WHERE recorded_at >= NOW() - INTERVAL '1 hour'
GROUP BY metric_name;

-- 4.4 Create function to generate application performance report
CREATE OR REPLACE FUNCTION monitoring_app_performance_report(hours_back INTEGER DEFAULT 24)
RETURNS TABLE(
    metric_name TEXT,
    period TEXT,
    avg_value NUMERIC,
    min_value NUMERIC,
    max_value NUMERIC,
    sample_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.metric_name,
        format('Last %s hours', hours_back) as period,
        ROUND(AVG(m.metric_value), 2) as avg_value,
        MIN(m.metric_value) as min_value,
        MAX(m.metric_value) as max_value,
        COUNT(*) as sample_count
    FROM monitoring_application_metrics m
    WHERE m.recorded_at >= NOW() - INTERVAL '1 hour' * hours_back
    GROUP BY m.metric_name
    ORDER BY m.metric_name;
END;
$$ LANGUAGE plpgsql;

-- Exercise 5: Implement Security and Compliance Monitoring
/*
Exercise 5: Set up security and compliance monitoring
Requirements:
1. Monitor user access and authentication attempts
2. Track privilege changes and role assignments
3. Implement audit logging for sensitive operations
4. Create compliance reports for regulatory requirements
*/

-- Solution for Exercise 5
-- 5.1 Create table for audit logs
CREATE TABLE IF NOT EXISTS monitoring_audit_log (
    id SERIAL PRIMARY KEY,
    event_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_name TEXT,
    database_name TEXT,
    operation TEXT,
    object_name TEXT,
    details JSONB
);

-- 5.2 Create function to log security events
CREATE OR REPLACE FUNCTION monitoring_log_security_event(
    operation TEXT,
    object_name TEXT DEFAULT '',
    details JSONB DEFAULT '{}'
) RETURNS VOID AS $$
BEGIN
    INSERT INTO monitoring_audit_log (user_name, database_name, operation, object_name, details)
    VALUES (CURRENT_USER, CURRENT_DATABASE(), operation, object_name, details);
END;
$$ LANGUAGE plpgsql;

-- 5.3 Create triggers to log privilege changes
-- First, create a function to handle the trigger
CREATE OR REPLACE FUNCTION monitoring_log_privilege_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'GRANT' THEN
        PERFORM monitoring_log_security_event(
            'PRIVILEGE_GRANTED',
            NEW.grantee,
            jsonb_build_object(
                'privilege', NEW.privilege_type,
                'object', NEW.object_name,
                'grantor', NEW.grantor
            )
        );
        RETURN NEW;
    ELSIF TG_OP = 'REVOKE' THEN
        PERFORM monitoring_log_security_event(
            'PRIVILEGE_REVOKED',
            OLD.grantee,
            jsonb_build_object(
                'privilege', OLD.privilege_type,
                'object', OLD.object_name,
                'revoker', CURRENT_USER
            )
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Note: In practice, you would need to create actual triggers on system catalogs
-- which is complex and potentially not advisable. This is a simplified example.

-- 5.4 Create view for security events
CREATE OR REPLACE VIEW monitoring_security_events AS
SELECT 
    event_time,
    user_name,
    operation,
    object_name,
    details
FROM monitoring_audit_log
WHERE operation IN ('PRIVILEGE_GRANTED', 'PRIVILEGE_REVOKED', 'LOGIN_ATTEMPT', 'PASSWORD_CHANGE')
ORDER BY event_time DESC
LIMIT 100;

-- 5.5 Create function for compliance reporting
CREATE OR REPLACE FUNCTION monitoring_compliance_report(days_back INTEGER DEFAULT 30)
RETURNS TABLE(
    report_date DATE,
    event_type TEXT,
    event_count BIGINT,
    unique_users BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        event_time::DATE as report_date,
        operation as event_type,
        COUNT(*) as event_count,
        COUNT(DISTINCT user_name) as unique_users
    FROM monitoring_audit_log
    WHERE event_time >= NOW() - INTERVAL '1 day' * days_back
    GROUP BY event_time::DATE, operation
    ORDER BY report_date DESC, event_count DESC;
END;
$$ LANGUAGE plpgsql;

-- Exercise 6: Performance Tuning Monitoring
/*
Exercise 6: Monitor and analyze performance tuning opportunities
Requirements:
1. Identify unused indexes and tables
2. Monitor query performance and execution plans
3. Track buffer cache efficiency
4. Provide optimization recommendations
*/

-- Solution for Exercise 6
-- 6.1 Create view for unused indexes
CREATE OR REPLACE VIEW monitoring_unused_indexes AS
SELECT 
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes ui
JOIN pg_index i ON ui.indexrelid = i.indexrelid
WHERE idx_scan = 0 AND indisunique IS FALSE
ORDER BY pg_relation_size(indexrelid) DESC;

-- 6.2 Create view for table bloat analysis
CREATE OR REPLACE VIEW monitoring_table_bloat AS
WITH constants AS (
    SELECT current_setting('block_size')::numeric AS bs, 23 AS hdr, 4 AS ma
), bloat_info AS (
    SELECT
        ma,bs,hdr,reltuples::numeric,relpages::numeric,otta,
        CASE WHEN relpages < otta THEN 0 ELSE bs*(relpages-otta)::bigint END AS wastedbytes,
        CASE WHEN relpages < otta THEN 0 ELSE relpages::float/otta END AS bloat_ratio
    FROM (
        SELECT
            hdr, ma, bs, reltuples, relpages, CEIL((reltuples*((datahdr+ma-
              (CASE WHEN datahdr%ma=0 THEN ma ELSE datahdr%ma END))+nullhdr2+4))/(bs-20::float)) AS otta
        FROM (
            SELECT
                hdr, ma, bs, reltuples, relpages,
                datahdr,
                (datahdr+(SELECT 1+count(*)/8
                          FROM pg_stats s2
                          WHERE null_frac<>0 AND s2.schemaname = s.schemaname AND s2.tablename = s.tablename)
                 ) AS nullhdr2
            FROM (
                SELECT
                    schemaname, tablename, hdr, ma, bs,
                    SUM((1-null_frac)*avg_width) AS datawidth,
                    MAX(null_frac) AS maxfracsum,
                    hdr+(
                      SELECT 1+count(*)/8
                      FROM pg_stats s2
                      WHERE null_frac<>0 AND s2.schemaname = s.schemaname AND s2.tablename = s.tablename
                    ) AS nullhdr2
                FROM pg_stats s, constants
                GROUP BY 1,2,3,4,5
                ORDER BY schemaname, tablename
            ) AS foo
        ) AS rs
    ) AS sml
)
SELECT
    schemaname, tablename,
    bs*(relpages)::bigint AS table_bytes,
    pg_size_pretty((bs*(relpages)::bigint)) AS table_size,
    CASE WHEN relpages < otta THEN '0' ELSE (bs*(relpages-otta)::bigint)::text END AS wastedbytes,
    CASE WHEN relpages < otta THEN '0 bytes' ELSE pg_size_pretty((bs*(relpages-otta)::bigint)) END AS wastedsize,
    CASE WHEN relpages < otta THEN 0 ELSE ROUND(100*(relpages-otta)/relpages::float) END AS percent_bloat
FROM bloat_info
WHERE schemaname NOT IN ('information_schema', 'pg_catalog')
AND (relpages-otta) > 0
ORDER BY wastedbytes DESC;

-- 6.3 Create function to recommend index optimizations
CREATE OR REPLACE FUNCTION monitoring_index_recommendations()
RETURNS TABLE(
    recommendation_type TEXT,
    object_name TEXT,
    current_state TEXT,
    recommendation TEXT
) AS $$
BEGIN
    -- Recommendation for unused indexes
    RETURN QUERY
    SELECT 
        'UNUSED_INDEX'::TEXT as recommendation_type,
        (schemaname || '.' || indexname)::TEXT as object_name,
        (idx_scan || ' scans')::TEXT as current_state,
        'Consider dropping this unused index to improve write performance'::TEXT as recommendation
    FROM monitoring_unused_indexes
    LIMIT 10;
    
    -- Additional recommendations could be added here
    -- For example, missing indexes based on query patterns
END;
$$ LANGUAGE plpgsql;

-- 6.4 Create view for buffer cache efficiency
CREATE OR REPLACE VIEW monitoring_buffer_cache_efficiency AS
SELECT
    SUM(blks_read) AS blocks_read,
    SUM(blks_hit) AS blocks_hit,
    SUM(blks_hit)*100/GREATEST(SUM(blks_read)+SUM(blks_hit),1) AS cache_hit_ratio
FROM pg_stat_database
WHERE datname NOT IN ('template0', 'template1');

-- Exercise 7: Replication and HA Monitoring
/*
Exercise 7: Monitor replication and high availability setup
Requirements:
1. Track replication lag and status
2. Monitor standby server health
3. Implement failover readiness checks
4. Create replication performance reports
*/

-- Solution for Exercise 7
-- 7.1 Create view for replication status
CREATE OR REPLACE VIEW monitoring_replication_status AS
SELECT 
    client_addr,
    state,
    sync_state,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn)) AS sent_lag,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), write_lsn)) AS write_lag,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), flush_lsn)) AS flush_lag,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn)) AS replay_lag,
    backend_start,
    EXTRACT(EPOCH FROM (NOW() - backend_start))/3600 AS connection_age_hours
FROM pg_stat_replication;

-- 7.2 Create function to check replication health
CREATE OR REPLACE FUNCTION monitoring_check_replication_health(max_lag_mb INTEGER DEFAULT 100)
RETURNS TABLE(
    status TEXT,
    message TEXT
) AS $$
DECLARE
    max_lag_bytes BIGINT := max_lag_mb * 1024 * 1024;
    current_lag_bytes BIGINT;
BEGIN
    -- Check replay lag
    SELECT COALESCE(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn), 0) INTO current_lag_bytes
    FROM pg_stat_replication
    LIMIT 1;
    
    IF current_lag_bytes IS NULL THEN
        RETURN QUERY SELECT 'NO_REPLICA'::TEXT, 'No replica connected'::TEXT;
    ELSIF current_lag_bytes > max_lag_bytes THEN
        RETURN QUERY SELECT 'LAGGING'::TEXT, 
                     format('Replica is lagging by %s MB, exceeds threshold of %s MB', 
                            pg_size_pretty(current_lag_bytes), max_lag_mb)::TEXT;
    ELSE
        RETURN QUERY SELECT 'HEALTHY'::TEXT, 
                     format('Replica lag is %s MB, within acceptable limits', 
                            pg_size_pretty(current_lag_bytes))::TEXT;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 7.3 Create table for replication monitoring history
CREATE TABLE IF NOT EXISTS monitoring_replication_history (
    id SERIAL PRIMARY KEY,
    check_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    primary_lsn PG_LSN,
    replica_lsn PG_LSN,
    lag_bytes BIGINT,
    replica_host INET
);

-- 7.4 Create procedure to record replication status
CREATE OR REPLACE PROCEDURE monitoring_record_replication_status()
AS $$
DECLARE
    primary_lsn PG_LSN;
    replica_lsn PG_LSN;
    lag_bytes BIGINT;
    replica_host INET;
BEGIN
    SELECT pg_current_wal_lsn() INTO primary_lsn;
    
    -- Get info from first replica (in practice, you might loop through all replicas)
    SELECT replay_lsn, client_addr INTO replica_lsn, replica_host
    FROM pg_stat_replication
    LIMIT 1;
    
    IF replica_lsn IS NOT NULL THEN
        SELECT pg_wal_lsn_diff(primary_lsn, replica_lsn) INTO lag_bytes;
        
        INSERT INTO monitoring_replication_history 
            (primary_lsn, replica_lsn, lag_bytes, replica_host)
        VALUES 
            (primary_lsn, replica_lsn, lag_bytes, replica_host);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Exercise 8: Resource Utilization Monitoring
/*
Exercise 8: Monitor system resource utilization
Requirements:
1. Track CPU, memory, and I/O usage
2. Monitor connection pool utilization
3. Implement resource saturation alerts
4. Create resource usage trend reports
*/

-- Solution for Exercise 8
-- 8.1 Create table for resource usage history
CREATE TABLE IF NOT EXISTS monitoring_resource_usage (
    id SERIAL PRIMARY KEY,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    cpu_percent NUMERIC(5,2),
    memory_percent NUMERIC(5,2),
    io_wait_time NUMERIC,
    active_connections INTEGER,
    connection_utilization_percent NUMERIC(5,2)
);

-- Since we can't directly monitor system resources from PostgreSQL,
-- we'll create a function that accepts these values from an external collector
CREATE OR REPLACE FUNCTION monitoring_record_resource_usage(
    cpu_percent NUMERIC(5,2),
    memory_percent NUMERIC(5,2),
    io_wait_time NUMERIC,
    active_connections INTEGER,
    max_connections INTEGER
) RETURNS VOID AS $$
BEGIN
    INSERT INTO monitoring_resource_usage (
        cpu_percent, 
        memory_percent, 
        io_wait_time, 
        active_connections,
        connection_utilization_percent
    ) VALUES (
        cpu_percent,
        memory_percent,
        io_wait_time,
        active_connections,
        ROUND((active_connections::NUMERIC / GREATEST(max_connections, 1)) * 100, 2)
    );
END;
$$ LANGUAGE plpgsql;

-- 8.2 Create view for recent resource usage
CREATE OR REPLACE VIEW monitoring_recent_resource_usage AS
SELECT 
    recorded_at,
    cpu_percent,
    memory_percent,
    io_wait_time,
    active_connections,
    connection_utilization_percent
FROM monitoring_resource_usage
WHERE recorded_at >= NOW() - INTERVAL '1 hour'
ORDER BY recorded_at DESC;

-- 8.3 Create function to check for resource saturation
CREATE OR REPLACE FUNCTION monitoring_check_resource_saturation()
RETURNS TABLE(
    resource TEXT,
    current_value NUMERIC,
    threshold NUMERIC,
    status TEXT
) AS $$
DECLARE
    current_cpu NUMERIC;
    current_memory NUMERIC;
    current_conn_util NUMERIC;
BEGIN
    -- Get most recent values
    SELECT cpu_percent, memory_percent, connection_utilization_percent 
    INTO current_cpu, current_memory, current_conn_util
    FROM monitoring_resource_usage
    ORDER BY recorded_at DESC
    LIMIT 1;
    
    -- Check CPU (threshold 80%)
    IF current_cpu > 80 THEN
        RETURN QUERY SELECT 'CPU'::TEXT, current_cpu, 80::NUMERIC, 'SATURATED'::TEXT;
    ELSE
        RETURN QUERY SELECT 'CPU'::TEXT, current_cpu, 80::NUMERIC, 'NORMAL'::TEXT;
    END IF;
    
    -- Check Memory (threshold 85%)
    IF current_memory > 85 THEN
        RETURN QUERY SELECT 'MEMORY'::TEXT, current_memory, 85::NUMERIC, 'SATURATED'::TEXT;
    ELSE
        RETURN QUERY SELECT 'MEMORY'::TEXT, current_memory, 85::NUMERIC, 'NORMAL'::TEXT;
    END IF;
    
    -- Check Connection Utilization (threshold 90%)
    IF current_conn_util > 90 THEN
        RETURN QUERY SELECT 'CONNECTIONS'::TEXT, current_conn_util, 90::NUMERIC, 'SATURATED'::TEXT;
    ELSE
        RETURN QUERY SELECT 'CONNECTIONS'::TEXT, current_conn_util, 90::NUMERIC, 'NORMAL'::TEXT;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Exercise 9: Query Performance Analysis
/*
Exercise 9: Analyze and optimize query performance
Requirements:
1. Identify slow queries and execution patterns
2. Analyze query plans and resource consumption
3. Implement query performance trending
4. Create optimization recommendations
*/

-- Solution for Exercise 9
-- 9.1 Create table for query performance history
CREATE TABLE IF NOT EXISTS monitoring_query_performance (
    id SERIAL PRIMARY KEY,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    query_hash TEXT,
    query_text TEXT,
    total_time DOUBLE PRECISION,
    calls BIGINT,
    mean_time DOUBLE PRECISION,
    rows BIGINT,
    hit_percent DOUBLE PRECISION
);

-- 9.2 Create procedure to capture query performance data
CREATE OR REPLACE PROCEDURE monitoring_capture_query_performance()
AS $$
BEGIN
    -- Requires pg_stat_statements extension to be installed
    INSERT INTO monitoring_query_performance (
        query_hash,
        query_text,
        total_time,
        calls,
        mean_time,
        rows,
        hit_percent
    )
    SELECT
        md5(query) as query_hash,
        LEFT(query, 500) as query_text,  -- Limiting size for storage
        total_time,
        calls,
        mean_time,
        rows,
        100.0 * shared_blks_hit / nullif(shared_blks_hit + shared_blks_read, 0) AS hit_percent
    FROM pg_stat_statements
    WHERE calls > 0;
    
    RAISE NOTICE 'Query performance data captured';
END;
$$ LANGUAGE plpgsql;

-- 9.3 Create view for slowest queries
CREATE OR REPLACE VIEW monitoring_slowest_queries AS
SELECT 
    LEFT(query_text, 100) as query_snippet,
    calls,
    total_time,
    mean_time,
    rows,
    hit_percent,
    recorded_at
FROM monitoring_query_performance
WHERE recorded_at >= NOW() - INTERVAL '1 day'
ORDER BY mean_time DESC
LIMIT 20;

-- 9.4 Create function to identify queries for optimization
CREATE OR REPLACE FUNCTION monitoring_queries_for_optimization(min_calls INTEGER DEFAULT 10)
RETURNS TABLE(
    query_snippet TEXT,
    calls BIGINT,
    avg_execution_time DOUBLE PRECISION,
    total_time DOUBLE PRECISION,
    optimization_potential TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        LEFT(query_text, 100) as query_snippet,
        calls,
        mean_time as avg_execution_time,
        total_time,
        CASE 
            WHEN mean_time > 1000 THEN 'HIGH - Consider query rewrite or indexing'
            WHEN mean_time > 100 THEN 'MEDIUM - Review execution plan'
            ELSE 'LOW - Monitor for changes'
        END as optimization_potential
    FROM monitoring_query_performance
    WHERE calls >= min_calls
    AND recorded_at >= NOW() - INTERVAL '1 day'
    ORDER BY total_time DESC
    LIMIT 20;
END;
$$ LANGUAGE plpgsql;

-- Exercise 10: Backup and Recovery Monitoring
/*
Exercise 10: Monitor backup and recovery processes
Requirements:
1. Track backup completion and verification
2. Monitor WAL archiving and replay
3. Implement backup age alerts
4. Create backup success rate reports
*/

-- Solution for Exercise 10
-- 10.1 Create table for backup monitoring
CREATE TABLE IF NOT EXISTS monitoring_backup_status (
    id SERIAL PRIMARY KEY,
    backup_time TIMESTAMP WITH TIME ZONE,
    backup_type TEXT CHECK (backup_type IN ('FULL', 'INCREMENTAL', 'WAL')),
    status TEXT CHECK (status IN ('STARTED', 'COMPLETED', 'FAILED', 'VERIFIED')),
    size_bytes BIGINT,
    duration_seconds INTEGER,
    verified_checksum BOOLEAN,
    error_message TEXT
);

-- 10.2 Create function to record backup status
CREATE OR REPLACE FUNCTION monitoring_record_backup(
    backup_type TEXT,
    status TEXT,
    size_bytes BIGINT DEFAULT NULL,
    duration_seconds INTEGER DEFAULT NULL,
    verified_checksum BOOLEAN DEFAULT NULL,
    error_message TEXT DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
    INSERT INTO monitoring_backup_status (
        backup_time,
        backup_type,
        status,
        size_bytes,
        duration_seconds,
        verified_checksum,
        error_message
    ) VALUES (
        NOW(),
        backup_type,
        status,
        size_bytes,
        duration_seconds,
        verified_checksum,
        error_message
    );
END;
$$ LANGUAGE plpgsql;

-- 10.3 Create view for backup status overview
CREATE OR REPLACE VIEW monitoring_backup_overview AS
SELECT 
    backup_type,
    status,
    COUNT(*) as backup_count,
    MAX(backup_time) as last_backup,
    AVG(size_bytes) as avg_size_bytes,
    AVG(duration_seconds) as avg_duration_seconds
FROM monitoring_backup_status
WHERE backup_time >= NOW() - INTERVAL '7 days'
GROUP BY backup_type, status
ORDER BY backup_type, last_backup DESC;

-- 10.4 Create function to check backup health
CREATE OR REPLACE FUNCTION monitoring_check_backup_health()
RETURNS TABLE(
    backup_type TEXT,
    status TEXT,
    message TEXT
) AS $$
DECLARE
    last_full_backup TIMESTAMP WITH TIME ZONE;
    last_wal_backup TIMESTAMP WITH TIME ZONE;
BEGIN
    SELECT MAX(backup_time) INTO last_full_backup
    FROM monitoring_backup_status
    WHERE backup_type = 'FULL' AND status = 'COMPLETED';
    
    SELECT MAX(backup_time) INTO last_wal_backup
    FROM monitoring_backup_status
    WHERE backup_type = 'WAL' AND status = 'COMPLETED';
    
    -- Check full backup age (should be less than 24 hours)
    IF last_full_backup IS NULL THEN
        RETURN QUERY SELECT 'FULL'::TEXT, 'ERROR'::TEXT, 'No full backup found'::TEXT;
    ELSIF last_full_backup < NOW() - INTERVAL '24 hours' THEN
        RETURN QUERY SELECT 'FULL'::TEXT, 'WARNING'::TEXT, 
                     format('Last full backup is %s hours old', 
                            EXTRACT(EPOCH FROM (NOW() - last_full_backup))/3600)::TEXT;
    ELSE
        RETURN QUERY SELECT 'FULL'::TEXT, 'OK'::TEXT, 'Full backup is current'::TEXT;
    END IF;
    
    -- Check WAL backup age (should be less than 1 hour)
    IF last_wal_backup IS NULL THEN
        RETURN QUERY SELECT 'WAL'::TEXT, 'ERROR'::TEXT, 'No WAL backup found'::TEXT;
    ELSIF last_wal_backup < NOW() - INTERVAL '1 hour' THEN
        RETURN QUERY SELECT 'WAL'::TEXT, 'WARNING'::TEXT, 
                     format('Last WAL backup is %s minutes old', 
                            EXTRACT(EPOCH FROM (NOW() - last_wal_backup))/60)::TEXT;
    ELSE
        RETURN QUERY SELECT 'WAL'::TEXT, 'OK'::TEXT, 'WAL backup is current'::TEXT;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Additional Exercise: Enterprise Monitoring Framework
/*
Additional Exercise: Design an enterprise monitoring framework
Requirements:
1. Create a unified monitoring schema
2. Implement role-based access controls
3. Design multi-tenant monitoring capabilities
4. Build integration APIs for external tools
*/

-- Solution for Additional Exercise
-- Create a dedicated schema for monitoring
CREATE SCHEMA IF NOT EXISTS monitoring_framework;

-- Grant usage to monitoring roles (these would be created in a real environment)
-- CREATE ROLE monitoring_reader;
-- CREATE ROLE monitoring_admin;
-- GRANT USAGE ON SCHEMA monitoring_framework TO monitoring_reader;
-- GRANT ALL PRIVILEGES ON SCHEMA monitoring_framework TO monitoring_admin;

-- Create a configuration table for the monitoring framework
CREATE TABLE IF NOT EXISTS monitoring_framework.config (
    id SERIAL PRIMARY KEY,
    config_key TEXT UNIQUE NOT NULL,
    config_value TEXT,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default configuration values
INSERT INTO monitoring_framework.config (config_key, config_value, description) VALUES
    ('retention_days', '90', 'Default retention period for monitoring data in days'),
    ('slow_query_threshold_ms', '1000', 'Threshold for identifying slow queries in milliseconds'),
    ('connection_alert_threshold', '80', 'Percentage threshold for connection count alerts'),
    ('backup_check_interval_hours', '1', 'How often to check backup status in hours')
ON CONFLICT (config_key) DO NOTHING;

-- Create a function to get configuration values
CREATE OR REPLACE FUNCTION monitoring_framework.get_config(config_key TEXT)
RETURNS TEXT AS $$
DECLARE
    config_value TEXT;
BEGIN
    SELECT c.config_value INTO config_value
    FROM monitoring_framework.config c
    WHERE c.config_key = config_key;
    
    RETURN config_value;
END;
$$ LANGUAGE plpgsql;

-- Create a view for monitoring framework health
CREATE OR REPLACE VIEW monitoring_framework.health_status AS
SELECT 
    'Database Connection' as component,
    CASE WHEN pg_is_in_recovery() THEN 'STANDBY' ELSE 'PRIMARY' END as status,
    NOW() as last_checked
UNION ALL
SELECT 
    'Extensions' as component,
    CASE WHEN EXISTS(SELECT 1 FROM pg_extension WHERE extname = 'pg_stat_statements') 
         THEN 'INSTALLED' ELSE 'MISSING' END as status,
    NOW() as last_checked
UNION ALL
SELECT 
    'Monitoring Schema' as component,
    CASE WHEN EXISTS(SELECT 1 FROM information_schema.schemata WHERE schema_name = 'monitoring_framework') 
         THEN 'READY' ELSE 'NOT FOUND' END as status,
    NOW() as last_checked;

-- Sample Data for Testing
-- Create sample tables for testing the monitoring system
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO employees (name, department, salary, hire_date) VALUES
('Alice Johnson', 'Engineering', 75000, '2020-01-15'),
('Bob Smith', 'Marketing', 65000, '2019-03-22'),
('Carol Williams', 'Engineering', 80000, '2021-07-10'),
('David Brown', 'Sales', 60000, '2020-11-05'),
('Eve Davis', 'HR', 68000, '2018-09-18');

INSERT INTO orders (employee_id, order_date, amount) VALUES
(1, '2023-01-15', 1500.00),
(2, '2023-01-16', 2300.50),
(3, '2023-01-17', 980.75),
(1, '2023-01-18', 1250.00),
(4, '2023-01-19', 3100.25);

-- Create indexes for testing
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department);
CREATE INDEX IF NOT EXISTS idx_orders_employee_id ON orders(employee_id);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(order_date);

-- Create a materialized view for testing performance monitoring
CREATE MATERIALIZED VIEW IF NOT EXISTS employee_sales_summary AS
SELECT 
    e.id,
    e.name,
    e.department,
    COUNT(o.id) as order_count,
    SUM(o.amount) as total_sales,
    AVG(o.amount) as avg_order_value
FROM employees e
LEFT JOIN orders o ON e.id = o.employee_id
GROUP BY e.id, e.name, e.department;

-- Refresh the materialized view
REFRESH MATERIALIZED VIEW employee_sales_summary;

-- Test Queries for Monitoring
-- These queries can be used to test the monitoring system

-- Query 1: Simple select (fast)
SELECT * FROM employees WHERE department = 'Engineering';

-- Query 2: Join query (moderate)
SELECT e.name, e.department, COUNT(o.id) as order_count
FROM employees e
LEFT JOIN orders o ON e.id = o.employee_id
GROUP BY e.id, e.name, e.department;

-- Query 3: Complex aggregation (slower)
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    SUM(total_sales) as dept_total_sales
FROM employee_sales_summary
GROUP BY department;

-- End of PostgreSQL Monitoring Practice Exercises