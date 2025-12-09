#!/usr/bin/env python3
"""
Redis Security Practice Exercises

This script contains hands-on exercises for securing Redis deployments.
Each exercise focuses on a different aspect of Redis security.
"""

import redis
import hashlib
import secrets
import time
from datetime import datetime, timedelta


def test_redis_connection():
    """Test Redis connection"""
    try:
        r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)
        r.ping()
        print("✓ Connected to Redis successfully")
        return r
    except Exception as e:
        print(f"✗ Failed to connect to Redis: {e}")
        return None


# Exercise 1: Password Security Implementation
# Task: Implement secure password handling for Redis connections
# Requirements:
# 1. Generate strong passwords
# 2. Store passwords securely
# 3. Implement password rotation

def exercise_1_password_security():
    """Exercise 1: Password Security Implementation"""
    print("\n=== Exercise 1: Password Security Implementation ===")
    
    # Your implementation here:
    # 1. Create a function to generate cryptographically secure passwords
    # 2. Implement secure storage of Redis credentials
    # 3. Create password rotation mechanism
    
    pass  # Replace with your implementation


# Exercise 2: ACL Rule Design
# Task: Design comprehensive ACL rules for different user roles
# Requirements:
# 1. Create roles: admin, developer, readonly, restricted
# 2. Define appropriate permissions for each role
# 3. Implement role-based access control

def exercise_2_acl_design(redis_client):
    """Exercise 2: ACL Rule Design"""
    print("\n=== Exercise 2: ACL Rule Design ===")
    
    # Your implementation here:
    # 1. Define ACL rules for different user roles:
    #    - Admin: Full access
    #    - Developer: Read/write to development keys
    #    - Readonly: Only read operations
    #    - Restricted: Limited access to specific patterns
    # 2. Implement functions to create and manage these roles
    
    pass  # Replace with your implementation


# Exercise 3: TLS Configuration
# Task: Implement secure TLS connections
# Requirements:
# 1. Configure Redis for TLS
# 2. Establish secure client connections
# 3. Verify certificate authenticity

def exercise_3_tls_configuration():
    """Exercise 3: TLS Configuration"""
    print("\n=== Exercise 3: TLS Configuration ===")
    
    # Your implementation here:
    # 1. Create a function to establish TLS connections
    # 2. Implement certificate verification
    # 3. Handle TLS-related errors appropriately
    
    pass  # Replace with your implementation


# Exercise 4: Data Encryption Implementation
# Task: Implement application-level encryption for sensitive data
# Requirements:
# 1. Create encryption/decryption functions
# 2. Store encryption keys securely
# 3. Implement key rotation

class SecureDataStore:
    """Exercise 4: Secure Data Storage with Encryption"""
    def __init__(self, redis_client):
        self.redis = redis_client
        # In practice, use a proper key management system
        self.encryption_key = "your-secure-encryption-key-change-this"
        
    # Your implementation here:
    # 1. Implement encrypt/decrypt methods
    # 2. Store/retrieve encrypted data in Redis
    # 3. Handle encryption key management
    
    def encrypt_store(self, key, value):
        # Your implementation
        pass
    
    def decrypt_retrieve(self, key):
        # Your implementation
        pass


# Exercise 5: Network Security Hardening
# Task: Implement network-level security measures
# Requirements:
# 1. Configure Redis binding restrictions
# 2. Implement connection rate limiting
# 3. Set up firewall rules

def exercise_5_network_security(redis_client):
    """Exercise 5: Network Security Hardening"""
    print("\n=== Exercise 5: Network Security Hardening ===")
    
    # Your implementation here:
    # 1. Create functions to check network binding configuration
    # 2. Implement basic connection monitoring
    # 3. Simulate firewall rule enforcement
    
    pass  # Replace with your implementation


# Exercise 6: Session Security
# Task: Implement secure session management
# Requirements:
# 1. Create secure session tokens
# 2. Implement session validation
# 3. Handle session expiration and cleanup

class SecureSessionManager:
    """Exercise 6: Secure Session Management"""
    def __init__(self, redis_client):
        self.redis = redis_client
        
    # Your implementation here:
    # 1. Implement secure session creation with random tokens
    # 2. Create session validation methods
    # 3. Implement secure session destruction
    # 4. Handle session timeout and automatic cleanup
    
    def create_session(self, user_id, timeout=3600):
        # Your implementation
        pass
    
    def validate_session(self, session_token):
        # Your implementation
        pass
    
    def destroy_session(self, session_token):
        # Your implementation
        pass


# Exercise 7: Audit Logging
# Task: Implement comprehensive audit logging
# Requirements:
# 1. Log all security-sensitive operations
# 2. Include relevant metadata (user, timestamp, IP, etc.)
# 3. Implement log retention policies

class AuditLogger:
    """Exercise 7: Audit Logging Implementation"""
    def __init__(self, redis_client):
        self.redis = redis_client
        
    # Your implementation here:
    # 1. Implement logging for key operations (SET, GET, DEL, etc.)
    # 2. Include user context and timestamps
    # 3. Create log querying capabilities
    # 4. Implement log cleanup/retention
    
    def log_operation(self, user, operation, key, metadata=None):
        # Your implementation
        pass
    
    def get_audit_logs(self, start_time=None, end_time=None, user=None):
        # Your implementation
        pass


# Exercise 8: Vulnerability Protection
# Task: Implement protection against common vulnerabilities
# Requirements:
# 1. Prevent injection attacks
# 2. Implement input validation
# 3. Protect against DoS attacks

def exercise_8_vulnerability_protection(redis_client):
    """Exercise 8: Vulnerability Protection"""
    print("\n=== Exercise 8: Vulnerability Protection ===")
    
    # Your implementation here:
    # 1. Create input sanitization functions
    # 2. Implement command whitelisting/blacklisting
    # 3. Add rate limiting for operations
    # 4. Protect against large data operations
    
    pass  # Replace with your implementation


# Exercise 9: Security Monitoring
# Task: Implement security monitoring and alerting
# Requirements:
# 1. Monitor for suspicious activities
# 2. Implement alerting mechanisms
# 3. Create security dashboards

def exercise_9_security_monitoring(redis_client):
    """Exercise 9: Security Monitoring"""
    print("\n=== Exercise 9: Security Monitoring ===")
    
    # Your implementation here:
    # 1. Create functions to monitor Redis security metrics
    # 2. Implement anomaly detection
    # 3. Create alerting for security events
    
    pass  # Replace with your implementation


# Exercise 10: Compliance Implementation
# Task: Implement security controls for compliance requirements
# Requirements:
# 1. Implement data retention policies
# 2. Create audit trails for compliance
# 3. Handle data privacy requirements

def exercise_10_compliance(redis_client):
    """Exercise 10: Compliance Implementation"""
    print("\n=== Exercise 10: Compliance Implementation ===")
    
    # Your implementation here:
    # 1. Implement data retention and deletion policies
    # 2. Create compliance reporting functions
    # 3. Handle privacy-related data operations
    
    pass  # Replace with your implementation


# Bonus Exercise: Complete Security Framework
# Task: Design and implement a comprehensive Redis security framework
# Requirements:
# 1. Integrate all security measures from previous exercises
# 2. Create a unified security management interface
# 3. Implement security testing capabilities

class RedisSecurityFramework:
    """Bonus Exercise: Complete Security Framework"""
    def __init__(self, redis_client):
        self.redis = redis_client
        self.session_manager = SecureSessionManager(redis_client)
        self.audit_logger = AuditLogger(redis_client)
        # Initialize other components
        
    # Your implementation here:
    # 1. Create a unified interface for all security functions
    # 2. Implement security configuration management
    # 3. Add security testing and validation methods
    # 4. Create security reporting capabilities
    
    def security_assessment(self):
        # Your implementation
        pass
    
    def apply_security_policy(self, policy_config):
        # Your implementation
        pass
    
    def generate_security_report(self):
        # Your implementation
        pass


def main():
    """Main function to run practice exercises"""
    print("Redis Security Practice Exercises")
    print("===============================")
    
    # Test Redis connection
    r = test_redis_connection()
    if not r:
        return
    
    # Clear database for clean testing
    r.flushdb()
    
    # Run exercises
    exercise_1_password_security()
    exercise_2_acl_design(r)
    exercise_3_tls_configuration()
    
    # Initialize components
    secure_store = SecureDataStore(r)
    session_manager = SecureSessionManager(r)
    audit_logger = AuditLogger(r)
    
    exercise_5_network_security(r)
    exercise_8_vulnerability_protection(r)
    exercise_9_security_monitoring(r)
    exercise_10_compliance(r)
    
    # Initialize bonus exercise
    security_framework = RedisSecurityFramework(r)
    
    print("\n=== Practice Complete ===")
    print("Remember to:")
    print("1. Test your implementations in a secure environment")
    print("2. Follow security best practices for production deployments")
    print("3. Regularly review and update security measures")
    print("4. Stay informed about new security threats and mitigations")
    print("5. Implement proper incident response procedures")


if __name__ == "__main__":
    main()