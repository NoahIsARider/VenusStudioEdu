-- PostgreSQL Replication Practice Exercises
-- This file contains hands-on exercises for practicing PostgreSQL replication

-- Exercise 1: Physical Replication Setup
-- Task: Configure streaming replication between two PostgreSQL instances
-- Requirements:
-- 1. Set up primary server configuration
-- 2. Configure standby server
-- 3. Verify replication is working

-- Primary server configuration (postgresql.conf)
-- Your implementation here:
/*
# Add required settings for physical replication
*/

-- Primary server authentication (pg_hba.conf)
-- Your implementation here:
/*
# Add replication user access rules
*/

-- Create replication user
-- Your implementation here:

-- Standby server configuration
-- Your implementation here:
/*
# Configure standby to connect to primary
*/

-- Verification queries
-- Your implementation here:
/*
-- Check replication status on primary
SELECT * FROM pg_stat_replication;

-- Check standby status
SELECT pg_is_in_recovery();
*/

-- Exercise 2: Logical Replication Implementation
-- Task: Set up logical replication for selective table replication
-- Requirements:
-- 1. Create publication for specific tables
-- 2. Set up subscription on another database
-- 3. Test data replication

-- Create test tables
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100)
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INTEGER REFERENCES categories(id),
    supplier_id INTEGER REFERENCES suppliers(id),
    price DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO categories (name) VALUES ('Electronics'), ('Clothing'), ('Books');
INSERT INTO suppliers (name, contact_email) VALUES 
('TechCorp', 'contact@techcorp.com'),
('FashionHouse', 'info@fashionhouse.com');
INSERT INTO products (name, category_id, supplier_id, price) VALUES
('Laptop', 1, 1, 999.99),
('T-Shirt', 2, 2, 19.99),
('PostgreSQL Guide', 3, 1, 49.99);

-- Create publication for products and categories only
-- Your implementation here:

-- Create subscription on target database
-- Your implementation here:

-- Test replication
-- Your implementation here:
/*
-- Insert data on primary and verify on subscriber
INSERT INTO products (name, category_id, supplier_id, price) VALUES
('Smartphone', 1, 1, 699.99);

-- Check data appears on subscriber
SELECT * FROM products WHERE name = 'Smartphone';
*/

-- Exercise 3: Replication Slot Management
-- Task: Manage replication slots for different replication scenarios
-- Requirements:
-- 1. Create physical and logical replication slots
-- 2. Monitor slot usage
-- 3. Clean up unused slots

-- Create replication slots
-- Your implementation here:
/*
-- Create physical replication slot
SELECT pg_create_physical_replication_slot('phys_slot_1');

-- Create logical replication slot
SELECT pg_create_logical_replication_slot('logic_slot_1', 'pgoutput');
*/

-- View replication slots
-- Your implementation here:

-- Monitor slot activity
-- Your implementation here:
/*
SELECT 
    slot_name,
    slot_type,
    active,
    restart_lsn,
    confirmed_flush_lsn
FROM pg_replication_slots;
*/

-- Drop unused slots
-- Your implementation here:

-- Exercise 4: Replication Monitoring and Troubleshooting
-- Task: Implement comprehensive replication monitoring
-- Requirements:
-- 1. Create monitoring queries for replication health
-- 2. Identify and resolve common replication issues
-- 3. Set up alerting for replication problems

-- Primary server monitoring
-- Your implementation here:
/*
-- Check connected replicas
SELECT 
    application_name,
    client_addr,
    state,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn)) AS data_lag
FROM pg_stat_replication;

-- Check replication slot status
SELECT 
    slot_name,
    slot_type,
    active,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) AS retained_data
FROM pg_replication_slots;
*/

-- Standby server monitoring
-- Your implementation here:
/*
-- Check replication lag
SELECT 
    EXTRACT(EPOCH FROM (now() - pg_last_xact_replay_timestamp())) AS replay_lag_seconds;

-- Check if in recovery mode
SELECT pg_is_in_recovery();
*/

-- Common troubleshooting queries
-- Your implementation here:
/*
-- Check for replication conflicts
SELECT * FROM pg_stat_database_conflicts;

-- Check WAL sender/receiver processes
SELECT * FROM pg_stat_replication;
SELECT * FROM pg_stat_wal_receiver;
*/

-- Exercise 5: Failover and Switchover Procedures
-- Task: Implement failover and switchover procedures
-- Requirements:
-- 1. Plan manual failover procedure
-- 2. Implement automated failover (conceptually)
-- 3. Test switchover process

-- Manual failover steps
-- Your implementation here:
/*
-- On standby server, promote to primary
-- Command: pg_ctl promote

-- Or create trigger file
-- echo "promote" > /tmp/postgresql.trigger.5432
*/

-- Verify promotion
-- Your implementation here:
/*
SELECT pg_is_in_recovery(); -- Should return false after promotion
*/

-- Update former primary to become standby
-- Your implementation here:
/*
-- Stop PostgreSQL on former primary
-- Update configuration to point to new primary
-- Start PostgreSQL
*/

-- Exercise 6: Point-in-Time Recovery (PITR)
-- Task: Implement and test PITR setup
-- Requirements:
-- 1. Configure WAL archiving
-- 2. Perform base backup
-- 3. Test recovery to specific point in time

-- WAL archiving configuration (postgresql.conf)
-- Your implementation here:
/*
# Enable WAL archiving
archive_mode = on
archive_command = 'cp %p /var/lib/postgresql/archive/%f'
*/

-- Base backup command
-- Your implementation here:
/*
-- Command to run: pg_basebackup -h localhost -D /var/lib/postgresql/standby -U replicator -P
*/

-- Recovery configuration
-- Your implementation here:
/*
-- Create recovery.conf or use postgresql.auto.conf for recovery settings
*/

-- Exercise 7: Cascading Replication
-- Task: Set up cascading replication topology
-- Requirements:
-- 1. Configure intermediate standby
-- 2. Set up downstream standby
-- 3. Verify data flows through the cascade

-- Intermediate standby configuration
-- Your implementation here:
/*
-- Enable hot standby
hot_standby = on
*/

-- Downstream standby configuration
-- Your implementation here:
/*
-- Connect to intermediate standby instead of primary
primary_conninfo = 'host=intermediate_server_ip port=5432 user=replicator password=password'
*/

-- Verify cascade replication
-- Your implementation here:
/*
-- Check replication status on primary
-- Check replication status on intermediate
-- Check data consistency on downstream
*/

-- Exercise 8: Synchronous Replication
-- Task: Configure synchronous replication for strong consistency
-- Requirements:
-- 1. Set up synchronous replication
-- 2. Test commit behavior
-- 3. Monitor synchronous replica status

-- Primary configuration for synchronous replication
-- Your implementation here:
/*
synchronous_commit = on
synchronous_standby_names = 'standby1,standby2'
*/

-- Verify synchronous replication
-- Your implementation here:
/*
SELECT 
    application_name,
    state,
    sync_priority,
    sync_state
FROM pg_stat_replication
WHERE sync_state IN ('sync', 'potential');
*/

-- Test commit behavior
-- Your implementation here:
/*
-- Time COMMIT operations with synchronous vs asynchronous settings
BEGIN;
INSERT INTO products (name, category_id, supplier_id, price) VALUES ('Test Product', 1, 1, 99.99);
COMMIT;
*/

-- Exercise 9: Logical Replication Advanced Features
-- Task: Use advanced logical replication features
-- Requirements:
-- 1. Implement replication of DDL changes
-- 2. Handle conflict resolution
-- 3. Use replication sets for granular control

-- Create publication with additional options
-- Your implementation here:
/*
CREATE PUBLICATION advanced_pub
FOR TABLE products, categories
WITH (publish = 'insert,update,delete,truncate');
*/

-- Modify publication
-- Your implementation here:
/*
-- Add table to existing publication
ALTER PUBLICATION advanced_pub ADD TABLE suppliers;

-- Remove table from publication
ALTER PUBLICATION advanced_pub DROP TABLE categories;
*/

-- Refresh subscription for schema changes
-- Your implementation here:
/*
ALTER SUBSCRIPTION advanced_sub REFRESH PUBLICATION;
*/

-- Exercise 10: Replication Performance Tuning
-- Task: Optimize replication performance
-- Requirements:
-- 1. Tune WAL and checkpoint settings
-- 2. Monitor replication throughput
-- 3. Optimize network usage

-- Performance tuning configuration
-- Your implementation here:
/*
wal_buffers = 16MB
checkpoint_completion_target = 0.9
checkpoint_timeout = 15min
max_wal_size = 4GB
min_wal_size = 1GB
*/

-- Monitor replication performance
-- Your implementation here:
/*
-- Check WAL generation rate
SELECT 
    now() as current_time,
    pg_current_wal_lsn() as current_lsn,
    pg_size_pretty(pg_current_wal_lsn() - '0/0'::pg_lsn) as wal_position;

-- Monitor replication throughput
SELECT 
    client_addr,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn)) as pending_bytes,
    pg_size_pretty(pg_wal_lsn_diff(sent_lsn, flush_lsn)) as flush_lag,
    pg_size_pretty(pg_wal_lsn_diff(flush_lsn, replay_lsn)) as replay_lag
FROM pg_stat_replication;
*/

-- Bonus Exercise: Multi-Master Replication with BDR
-- Task: Explore bi-directional replication setup (conceptual)
-- Requirements:
-- 1. Understand BDR architecture
-- 2. Plan multi-master replication
-- 3. Handle conflict resolution strategies

-- Note: This requires BDR (Bi-Directional Replication) extension
-- Your implementation here:
/*
-- Install BDR extension (conceptual)
CREATE EXTENSION bdr;

-- Create BDR group
SELECT bdr.bdr_group_create(
    local_node_name := 'node1',
    node_external_dsn := 'host=node1_ip port=5432 dbname=mydb'
);

-- Join nodes to BDR group
SELECT bdr.bdr_node_join(
    local_node_name := 'node2',
    node_external_dsn := 'host=node2_ip port=5432 dbname=mydb',
    join_using_dsn := 'host=node1_ip port=5432 dbname=mydb'
);
*/

-- Additional Practice Tips:
-- 1. Practice replication setup in a test environment
-- 2. Test failover procedures regularly
-- 3. Monitor replication lag and resolve issues promptly
-- 4. Document all replication configurations and procedures
-- 5. Test backup and recovery procedures with replicated systems
-- 6. Review PostgreSQL documentation for version-specific features