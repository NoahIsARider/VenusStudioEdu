-- PostgreSQL Triggers Practice Exercises
-- This file contains 10 practical exercises for learning triggers in PostgreSQL

-- Create sample tables for exercises
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(100),
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

DROP TABLE IF EXISTS posts CASCADE;
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(200),
    content TEXT,
    status VARCHAR(20) DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMP,
    view_count INTEGER DEFAULT 0
);

DROP TABLE IF EXISTS comments CASCADE;
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER REFERENCES posts(id),
    user_id INTEGER REFERENCES users(id),
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_approved BOOLEAN DEFAULT true
);

DROP TABLE IF EXISTS transactions CASCADE;
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    amount DECIMAL(12,2),
    type VARCHAR(20), -- 'credit' or 'debit'
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    balance_after DECIMAL(12,2)
);

DROP TABLE IF EXISTS user_sessions CASCADE;
CREATE TABLE user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    session_token VARCHAR(255),
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP
);

-- Insert sample data
INSERT INTO users (username, email, password_hash) VALUES
('alice', 'alice@example.com', 'hash1'),
('bob', 'bob@example.com', 'hash2'),
('charlie', 'charlie@example.com', 'hash3');

INSERT INTO posts (user_id, title, content, status) VALUES
(1, 'First Post', 'This is my first post', 'published'),
(2, 'Second Post', 'This is my second post', 'draft');

-- Exercise 1: User Activity Tracking
-- Create triggers to track user login times and activity
-- Requirements:
-- 1. Update last_login timestamp on successful login
-- 2. Track user session creation and expiration
-- 3. Log user activities (login, logout, profile update)
-- 4. Prevent inactive users from logging in

-- Your solution here:

-- Exercise 2: Content Moderation System
-- Create triggers for content validation and moderation
-- Requirements:
-- 1. Validate post titles and content for prohibited words
-- 2. Automatically approve posts from trusted users
-- 3. Flag suspicious content for manual review
-- 4. Track content modification history

-- Your solution here:

-- Exercise 3: Financial Transaction Integrity
-- Create triggers to maintain financial data integrity
-- Requirements:
-- 1. Validate transaction amounts (no negative values)
-- 2. Calculate and store running balance after each transaction
-- 3. Prevent overdrafts by checking available balance
-- 4. Log all transaction modifications for audit

-- Your solution here:

-- Exercise 4: Data Change Auditing
-- Create comprehensive audit trail for all data changes
-- Requirements:
-- 1. Track all INSERT, UPDATE, DELETE operations on key tables
-- 2. Record old and new values for updates
-- 3. Capture user identity and timestamp for each change
-- 4. Store audit data in separate audit tables

-- Your solution here:

-- Exercise 5: Automatic Data Cleanup
-- Create triggers for automatic data maintenance
-- Requirements:
-- 1. Automatically delete expired user sessions
-- 2. Archive old posts after a certain period
-- 3. Clean up unused temporary data
-- 4. Enforce data retention policies

-- Your solution here:

-- Exercise 6: Business Rule Enforcement
-- Create triggers to enforce complex business rules
-- Requirements:
-- 1. Limit number of posts per user per day
-- 2. Enforce unique constraints across related tables
-- 3. Validate data relationships and dependencies
-- 4. Prevent conflicting operations

-- Your solution here:

-- Exercise 7: Performance Monitoring
-- Create triggers to monitor and log performance metrics
-- Requirements:
-- 1. Track execution time of critical operations
-- 2. Log slow queries and operations
-- 3. Monitor table growth and data volume
-- 4. Generate alerts for performance degradation

-- Your solution here:

-- Exercise 8: Security Enhancement
-- Create triggers to enhance database security
-- Requirements:
-- 1. Prevent unauthorized data access attempts
-- 2. Log all data access and modification attempts
-- 3. Implement row-level security policies
-- 4. Detect and prevent SQL injection attempts

-- Your solution here:

-- Exercise 9: Data Validation and Sanitization
-- Create triggers to validate and sanitize input data
-- Requirements:
-- 1. Validate email formats and domains
-- 2. Sanitize user input to prevent XSS attacks
-- 3. Normalize data formats (dates, phone numbers, etc.)
-- 4. Reject invalid or malformed data

-- Your solution here:

-- Exercise 10: Complex Workflow Automation
-- Create triggers to automate complex business workflows
-- Requirements:
-- 1. Automate approval workflows for content
-- 2. Trigger notifications for important events
-- 3. Synchronize data across related systems
-- 4. Handle error recovery and rollback scenarios

-- Your solution here:

-- Extra Challenge: Enterprise-Grade Database Management System
-- Create a comprehensive trigger system for enterprise database management:
-- 1. Multi-layered security and access control
-- 2. Advanced auditing and compliance reporting
-- 3. Real-time data quality monitoring
-- 4. Automated backup and disaster recovery
-- 5. Performance optimization and tuning
-- 6. Cross-database synchronization
-- 7. Machine learning-based anomaly detection
-- 8. Blockchain-based immutable logging
-- 9. AI-powered predictive maintenance
-- 10. Quantum-resistant encryption integration

-- Implementation guidelines:
-- - Implement proper error handling in all triggers
-- - Design for high availability and fault tolerance
-- - Optimize for performance with minimal overhead
-- - Include comprehensive logging for debugging
-- - Handle edge cases and exceptional conditions
-- - Ensure data consistency and integrity
-- - Document all triggers with clear specifications
-- - Test thoroughly under various load conditions

-- Your solution here: