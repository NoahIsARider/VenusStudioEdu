-- PostgreSQL Replication Examples
-- This file demonstrates various replication techniques in PostgreSQL

-- Note: These examples require multiple PostgreSQL instances
-- For demonstration purposes, we'll show the configuration and SQL commands
-- Actual setup would require separate server instances

-- 1. Streaming Replication Setup (Primary Server Configuration)
-- In postgresql.conf on primary server:
/*
listen_addresses = '*'
wal_level = replica
max_wal_senders = 3
max_replication_slots = 3
archive_mode = on
archive_command = 'cp %p /var/lib/postgresql/archive/%f'
*/

-- In pg_hba.conf on primary server:
/*
# Replication connections
host replication replicator 192.168.1.101/32 md5
*/

-- Create replication user
CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replicator_password';

-- 2. Streaming Replication Setup (Standby Server Configuration)
-- On standby server, create recovery.conf (PostgreSQL < 12) or postgresql.auto.conf (PostgreSQL >= 12):
/*
standby_mode = 'on'
primary_conninfo = 'host=192.168.1.100 port=5432 user=replicator password=replicator_password'
restore_command = 'cp /var/lib/postgresql/archive/%f %p'
*/

-- For PostgreSQL 12+, use standby.signal file and postgresql.auto.conf:
-- touch standby.signal
-- In postgresql.auto.conf:
/*
primary_conninfo = 'host=192.168.1.100 port=5432 user=replicator password=replicator_password'
*/

-- 3. Logical Replication Setup
-- On primary server, enable logical replication:
/*
wal_level = logical
*/

-- Create publication
CREATE PUBLICATION sales_publication FOR TABLE sales;
CREATE PUBLICATION hr_publication FOR TABLE employees, departments;

-- Create publication for all tables in schema
CREATE PUBLICATION all_tables_publication FOR ALL TABLES;

-- View publications
SELECT * FROM pg_publication;

-- 4. Logical Replication Subscriber Setup
-- On subscriber server, create subscription
CREATE SUBSCRIPTION sales_subscription
CONNECTION 'host=192.168.1.100 port=5432 dbname=mydb user=replicator password=replicator_password'
PUBLICATION sales_publication;

-- Create subscription with specific options
CREATE SUBSCRIPTION hr_subscription
CONNECTION 'host=192.168.1.100 port=5432 dbname=mydb user=replicator password=replicator_password'
PUBLICATION hr_publication
WITH (
    copy_data = true,
    create_slot = true,
    enabled = true,
    slot_name = 'hr_replication_slot'
);

-- View subscriptions
SELECT * FROM pg_subscription;

-- 5. Replication Slot Management
-- Create replication slot
SELECT pg_create_physical_replication_slot('standby_slot_1');
SELECT pg_create_logical_replication_slot('logical_slot_1', 'pgoutput');

-- View replication slots
SELECT slot_name, plugin, slot_type, active, restart_lsn FROM pg_replication_slots;

-- Drop replication slot
SELECT pg_drop_replication_slot('standby_slot_1');

-- 6. Monitoring Replication
-- Check replication status on primary
SELECT 
    client_addr,
    usename,
    application_name,
    state,
    sync_priority,
    sync_state,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn)) AS pending_bytes
FROM pg_stat_replication;

-- Check replication lag on standby
SELECT 
    pg_last_wal_receive_lsn() AS receive_lsn,
    pg_last_wal_replay_lsn() AS replay_lsn,
    pg_wal_lsn_diff(pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn()) AS replay_lag_bytes,
    EXTRACT(EPOCH FROM (now() - pg_last_xact_replay_timestamp())) AS replay_lag_seconds;

-- 7. Failover and Switchover Procedures
-- Promote standby to primary (manual failover)
-- On standby server, run: pg_ctl promote

-- Or using trigger file method:
-- Create a trigger file as specified in recovery.conf:
-- trigger_file = '/tmp/postgresql.trigger.5432'

-- 8. Point-in-Time Recovery (PITR)
-- In postgresql.conf:
/*
restore_command = 'cp /var/lib/postgresql/archive/%f %p'
archive_cleanup_command = 'pg_archivecleanup /var/lib/postgresql/archive %r'
*/

-- To perform PITR, create recovery.conf:
/*
restore_command = 'cp /var/lib/postgresql/archive/%f %p'
recovery_target_time = '2023-04-01 12:00:00'
recovery_target_timeline = 'latest'
*/

-- 9. Cascading Replication
-- Intermediate standby can act as primary for downstream standbys
-- In intermediate standby's postgresql.conf:
/*
hot_standby = on
*/

-- Downstream standby connects to intermediate standby:
/*
primary_conninfo = 'host=192.168.1.101 port=5432 user=replicator password=replicator_password'
*/

-- 10. Synchronous Replication
-- In primary's postgresql.conf:
/*
synchronous_commit = on
synchronous_standby_names = 'standby1,standby2'
*/

-- Check synchronous replication status
SELECT 
    application_name,
    state,
    sync_priority,
    sync_state
FROM pg_stat_replication
WHERE sync_state IN ('sync', 'potential');

-- 11. Replication Conflict Resolution
-- Handle query cancels on standby due to conflicts
-- In postgresql.conf on standby:
/*
hot_standby_feedback = on
max_standby_archive_delay = 30s
max_standby_streaming_delay = 30s
*/

-- Monitor replication conflicts
SELECT 
    datname,
    confl_tablespace,
    confl_lock,
    confl_snapshot,
    confl_bufferpin,
    confl_deadlock
FROM pg_stat_database_conflicts;

-- 12. Backup and Replication Integration
-- Create base backup for new standby
-- On primary server, run: pg_basebackup -h localhost -D /var/lib/postgresql/standby -U replicator -P

-- 13. Replication Testing
-- Create test tables and data
DROP TABLE IF EXISTS replication_test CASCADE;
CREATE TABLE replication_test (
    id SERIAL PRIMARY KEY,
    data TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert test data
INSERT INTO replication_test (data) VALUES 
('Test row 1'),
('Test row 2'),
('Test row 3');

-- Monitor replication progress
SELECT * FROM replication_test;

-- 14. Replication Performance Tuning
-- Adjust WAL settings for performance
-- In postgresql.conf:
/*
wal_buffers = 16MB
checkpoint_completion_target = 0.9
checkpoint_timeout = 15min
max_wal_size = 4GB
min_wal_size = 1GB
*/

-- 15. Logical Replication Features
-- Add table to existing publication
ALTER PUBLICATION sales_publication ADD TABLE orders;

-- Remove table from publication
ALTER PUBLICATION sales_publication DROP TABLE orders;

-- View publication tables
SELECT pubname, schemaname, tablename 
FROM pg_publication_tables;

-- Refresh subscription to sync schema changes
ALTER SUBSCRIPTION sales_subscription REFRESH PUBLICATION;

-- Disable subscription temporarily
ALTER SUBSCRIPTION sales_subscription DISABLE;

-- Enable subscription
ALTER SUBSCRIPTION sales_subscription ENABLE;

-- 16. Replication Security
-- Create dedicated replication user with minimal privileges
CREATE USER rep_user WITH REPLICATION CONNECTION LIMIT 5 ENCRYPTED PASSWORD 'strong_password';

-- Restrict replication connections in pg_hba.conf:
/*
# Only allow replication from specific IPs
host replication rep_user 192.168.1.0/24 md5
host replication rep_user 10.0.0.0/8 cert
*/

-- 17. High Availability with Replication
-- Check if server is in recovery (standby) mode
SELECT pg_is_in_recovery();

-- Get current WAL location
SELECT pg_current_wal_lsn();

-- Get last replayed WAL location
SELECT pg_last_wal_replay_lsn();

-- 18. Replication Diagnostics
-- Check replication connection statistics
SELECT 
    pid,
    usesysid,
    usename,
    application_name,
    client_addr,
    client_hostname,
    client_port,
    backend_start,
    state,
    sent_lsn,
    write_lsn,
    flush_lsn,
    replay_lsn
FROM pg_stat_replication;

-- Check WAL sender process stats
SELECT 
    pid,
    state,
    sent_lsn,
    write_lsn,
    flush_lsn,
    replay_lsn,
    sync_priority,
    sync_state
FROM pg_stat_replication;

-- 19. Logical Decoding
-- Create logical replication slot
SELECT pg_create_logical_replication_slot('test_slot', 'pgoutput');

-- Get changes from logical slot
SELECT * FROM pg_logical_slot_get_changes('test_slot', NULL, NULL);

-- Drop logical replication slot
SELECT pg_drop_replication_slot('test_slot');

-- 20. Replication Best Practices Summary
/*
Replication Best Practices:

1. Physical Replication:
   - Use for disaster recovery and high availability
   - Monitor replication lag regularly
   - Implement proper failover procedures
   - Test failover scenarios periodically

2. Logical Replication:
   - Use for selective data replication
   - Supports cross-version replication
   - Allows replication between different table schemas
   - Requires careful conflict resolution planning

3. Security:
   - Use dedicated replication users
   - Encrypt replication traffic with SSL/TLS
   - Restrict network access to replication endpoints
   - Regularly rotate replication credentials

4. Monitoring:
   - Monitor replication lag and throughput
   - Alert on replication failures
   - Track replication conflicts
   - Monitor disk space for WAL archives

5. Performance:
   - Tune WAL settings for your workload
   - Use appropriate checkpoint settings
   - Consider synchronous commit settings
   - Monitor network bandwidth usage

6. Maintenance:
   - Regularly review and clean up replication slots
   - Monitor and maintain WAL archive storage
   - Update replication configurations as needed
   - Document failover procedures
*/

-- Clean up test objects
-- DROP TABLE IF EXISTS replication_test CASCADE;
-- DROP PUBLICATION IF EXISTS sales_publication, hr_publication, all_tables_publication;
-- DROP SUBSCRIPTION IF EXISTS sales_subscription, hr_subscription;