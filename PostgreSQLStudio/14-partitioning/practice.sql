-- PostgreSQL Partitioning Practice Exercises
-- This file contains hands-on exercises for practicing PostgreSQL partitioning

-- Create sample tables for exercises
DROP TABLE IF EXISTS logs_old CASCADE;
DROP TABLE IF EXISTS logs_2023_q1 CASCADE;
DROP TABLE IF EXISTS logs_2023_q2 CASCADE;
DROP TABLE IF EXISTS logs_2023_q3 CASCADE;
DROP TABLE IF EXISTS logs_2023_q4 CASCADE;
DROP TABLE IF EXISTS logs_2024_q1 CASCADE;
DROP TABLE IF EXISTS logs CASCADE;

DROP TABLE IF EXISTS customer_events_old CASCADE;
DROP TABLE IF EXISTS customer_events_us CASCADE;
DROP TABLE IF EXISTS customer_events_eu CASCADE;
DROP TABLE IF EXISTS customer_events_apac CASCADE;
DROP TABLE IF EXISTS customer_events_other CASCADE;
DROP TABLE IF EXISTS customer_events CASCADE;

DROP TABLE IF EXISTS sensor_readings_old CASCADE;
DROP TABLE IF EXISTS sensor_readings_0 CASCADE;
DROP TABLE IF EXISTS sensor_readings_1 CASCADE;
DROP TABLE IF EXISTS sensor_readings_2 CASCADE;
DROP TABLE IF EXISTS sensor_readings_3 CASCADE;
DROP TABLE IF EXISTS sensor_readings CASCADE;

-- Exercise 1: Time-Series Data Partitioning
-- Task: Implement range partitioning for application logs
-- Requirements:
-- 1. Partition logs by quarter (Q1-Q4 for 2023-2024)
-- 2. Include appropriate indexes
-- 3. Demonstrate partition pruning

-- Create the partitioned table
-- Your implementation here:

-- Create quarterly partitions
-- Your implementation here:

-- Insert sample data
-- Your implementation here:

-- Query to demonstrate partition pruning
-- Your implementation here:

-- Exercise 2: Geographic Data Partitioning
-- Task: Implement list partitioning for customer events
-- Requirements:
-- 1. Partition by geographic region (US, EU, APAC, Other)
-- 2. Handle unknown regions gracefully
-- 3. Optimize for regional queries

-- Create the partitioned table
-- Your implementation here:

-- Create regional partitions
-- Your implementation here:

-- Insert sample data
-- Your implementation here:

-- Query to show data distribution across partitions
-- Your implementation here:

-- Exercise 3: Load Distribution with Hash Partitioning
-- Task: Implement hash partitioning for sensor readings
-- Requirements:
-- 1. Distribute data evenly across 4 partitions
-- 2. Optimize for sensor_id-based queries
-- 3. Show data distribution

-- Create the partitioned table
-- Your implementation here:

-- Create hash partitions
-- Your implementation here:

-- Insert sample data
-- Your implementation here:

-- Query to show even distribution
-- Your implementation here:

-- Exercise 4: Multi-level Partitioning
-- Task: Implement subpartitioning for a metrics table
-- Requirements:
-- 1. Primary partition by year (2023, 2024)
-- 2. Subpartition by metric type (CPU, Memory, Disk, Network)
-- 3. Include appropriate indexes

-- Create base partitioned table
-- Your implementation here:

-- Create yearly partitions with subpartitions
-- Your implementation here:

-- Insert sample data
-- Your implementation here:

-- Query demonstrating multi-level partitioning benefits
-- Your implementation here:

-- Exercise 5: Partition Maintenance Operations
-- Task: Implement partition maintenance procedures
-- Requirements:
-- 1. Add new partition for 2024 Q2
-- 2. Archive/remove old partitions
-- 3. Reorganize data between partitions

-- Add new partition
-- Your implementation here:

-- Archive old partition (simulate archiving to separate table)
-- Your implementation here:

-- Reorganize data (move data between partitions)
-- Your implementation here:

-- Exercise 6: Performance Comparison
-- Task: Compare performance between partitioned and non-partitioned tables
-- Requirements:
-- 1. Create large datasets for both approaches
-- 2. Measure query performance differences
-- 3. Demonstrate partition pruning benefits

-- Create non-partitioned table with large dataset
-- Your implementation here:

-- Create partitioned table with same dataset
-- Your implementation here:

-- Performance queries (use EXPLAIN ANALYZE)
-- Your implementation here:

-- Exercise 7: Indexing Strategies
-- Task: Implement optimal indexing for partitioned tables
-- Requirements:
-- 1. Create global indexes
-- 2. Create local indexes on partitions
-- 3. Compare query plans with different indexing strategies

-- Create table with global indexes
-- Your implementation here:

-- Create table with local indexes
-- Your implementation here:

-- Compare query performance with different indexing approaches
-- Your implementation here:

-- Exercise 8: Constraint Management
-- Task: Manage constraints in partitioned tables
-- Requirements:
-- 1. Add foreign key constraints
-- 2. Add check constraints
-- 3. Handle constraint inheritance

-- Create related tables for foreign keys
-- Your implementation here:

-- Create partitioned table with constraints
-- Your implementation here:

-- Verify constraint inheritance
-- Your implementation here:

-- Exercise 9: Monitoring and Statistics
-- Task: Monitor partitioned table performance
-- Requirements:
-- 1. Check partition sizes
-- 2. Monitor query performance
-- 3. Analyze partition statistics

-- Query partition sizes
-- Your implementation here:

-- Check partition statistics
-- Your implementation here:

-- Analyze query performance on partitions
-- Your implementation here:

-- Exercise 10: Advanced Partitioning Scenarios
-- Task: Implement complex partitioning for a data warehouse
-- Requirements:
-- 1. Design partitioning strategy for fact table
-- 2. Include dimension-based partitioning
-- 3. Optimize for analytical queries

-- Create star schema with partitioned fact table
-- Your implementation here:

-- Insert sample data
-- Your implementation here:

-- Analytical queries demonstrating partitioning benefits
-- Your implementation here:

-- Bonus Exercise: Real-world Partitioning Challenge
-- Task: Design and implement partitioning for an e-commerce analytics system
-- Requirements:
-- 1. Handle multiple data sources (orders, clicks, reviews)
-- 2. Optimize for time-based analytical queries
-- 3. Implement automated partition management
-- 4. Include monitoring and maintenance procedures

-- Design schema
-- Your implementation here:

-- Implement partitioning strategy
-- Your implementation here:

-- Create maintenance procedures
-- Your implementation here:

-- Demonstrate query performance benefits
-- Your implementation here:

-- Additional Practice Tips:
-- 1. Experiment with different partitioning strategies for the same dataset
-- 2. Test edge cases like inserting data outside defined partitions
-- 3. Practice partition maintenance operations
-- 4. Monitor resource usage during partitioning operations
-- 5. Review PostgreSQL documentation for advanced partitioning features