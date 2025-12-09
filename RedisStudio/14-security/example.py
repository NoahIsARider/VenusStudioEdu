#!/usr/bin/env python3
"""
Redis Security Examples

This script demonstrates various security techniques for Redis,
including authentication, encryption, access control, and more.
"""

import redis
import ssl
import hashlib
import secrets
import time
from datetime import datetime, timedelta


def test_redis_connection():
    """Test basic Redis connection"""
    try:
        # Basic connection (assuming Redis is running locally)
        r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)
        r.ping()
        print("✓ Connected to Redis successfully")
        return r
    except Exception as e:
        print(f"✗ Failed to connect to Redis: {e}")
        return None


def example_1_authentication(r):
    """Example 1: Redis Authentication"""
    print("\n=== Example 1: Redis Authentication ===")
    
    # Note: This example assumes Redis is configured with requirepass
    # In practice, you would set this in redis.conf:
    # requirepass your_secure_password
    
    try:
        # Connect with password
        r_auth = redis.Redis(
            host='localhost', 
            port=6379, 
            db=0, 
            password='your_secure_password',  # Replace with actual password
            decode_responses=True
        )
        r_auth.ping()
        print("✓ Authenticated connection successful")
        
        # Set a test key
        r_auth.set('auth_test', 'authenticated_value')
        value = r_auth.get('auth_test')
        print(f"Retrieved value: {value}")
        
    except Exception as e:
        print(f"Authentication example requires Redis to be configured with a password: {e}")


def example_2_acl_management(r):
    """Example 2: ACL (Access Control List) Management"""
    print("\n=== Example 2: ACL Management ===")
    
    try:
        # Create a restricted user
        username = "restricted_user"
        password = "secure_password_123"
        
        # Add user with specific permissions
        # This user can only access keys starting with "user:" and can only GET/SET
        r.execute_command(
            'ACL', 'SETUSER', username,
            'on',  # Enable user
            f'>{password}',  # Set password
            '~user:*',  # Allow access to keys matching pattern
            '+get', '+set', '+ping',  # Allow specific commands
            'allkeys'  # Allow access to all keys (you can restrict further)
        )
        print(f"✓ Created user: {username}")
        
        # Test the restricted user
        restricted_client = redis.Redis(
            host='localhost',
            port=6379,
            username=username,
            password=password,
            decode_responses=True
        )
        
        # This should work
        restricted_client.set('user:test', 'allowed_value')
        value = restricted_client.get('user:test')
        print(f"Restricted user set/get successful: {value}")
        
        # Clean up
        r.execute_command('ACL', 'DELUSER', username)
        print(f"✓ Removed user: {username}")
        
    except Exception as e:
        print(f"ACL example requires Redis 6.0+ with ACL support: {e}")


def example_3_encryption_in_transit(r):
    """Example 3: Encryption in Transit (TLS/SSL)"""
    print("\n=== Example 3: Encryption in Transit ===")
    
    # Note: This example requires Redis to be configured with TLS
    # Configuration in redis.conf:
    # tls-port 6380
    # tls-cert-file /path/to/server.crt
    # tls-key-file /path/to/server.key
    # tls-ca-cert-file /path/to/ca.crt
    
    try:
        # Connect using SSL/TLS
        r_ssl = redis.Redis(
            host='localhost',
            port=6380,  # TLS port
            ssl=True,
            ssl_certfile='/path/to/client.crt',  # Client certificate
            ssl_keyfile='/path/to/client.key',    # Client private key
            ssl_ca_certs='/path/to/ca.crt',       # CA certificate
            decode_responses=True
        )
        r_ssl.ping()
        print("✓ SSL/TLS connection successful")
        
    except Exception as e:
        print(f"SSL/TLS example requires Redis to be configured with TLS: {e}")


def example_4_data_at_rest_encryption(r):
    """Example 4: Data at Rest Encryption Concept"""
    print("\n=== Example 4: Data at Rest Encryption Concept ===")
    
    # Redis itself doesn't encrypt data at rest, but you can implement
    # application-level encryption before storing data
    
    def encrypt_data(data, key):
        """Simple encryption function (not for production use)"""
        # In production, use proper encryption libraries like cryptography
        return hashlib.sha256((data + key).encode()).hexdigest()
    
    def decrypt_data(encrypted_data):
        """Placeholder for decryption (not implemented for this example)"""
        # In a real implementation, you would decrypt the data
        return "Decrypted data would be returned here"
    
    # Example usage
    secret_key = "my_secret_key"
    sensitive_data = "This is sensitive information"
    
    # Encrypt before storing
    encrypted = encrypt_data(sensitive_data, secret_key)
    r.set('encrypted_data', encrypted)
    print(f"Original data: {sensitive_data}")
    print(f"Encrypted data stored in Redis: {encrypted[:20]}...")
    
    # Retrieve and "decrypt"
    retrieved = r.get('encrypted_data')
    print(f"Retrieved encrypted data: {retrieved[:20]}...")
    print(f"Decrypted concept: {decrypt_data(retrieved)}")


def example_5_network_security(r):
    """Example 5: Network Security"""
    print("\n=== Example 5: Network Security ===")
    
    # Binding to specific interfaces
    # In redis.conf:
    # bind 127.0.0.1 192.168.1.100  # Only listen on specific interfaces
    
    # Protected mode
    # In redis.conf:
    # protected-mode yes  # Enabled by default in Redis 3.2+
    
    # Test connection from localhost (should work)
    try:
        local_r = redis.Redis(host='127.0.0.1', port=6379, db=0, decode_responses=True)
        local_r.ping()
        print("✓ Connection from localhost successful")
    except Exception as e:
        print(f"Local connection failed: {e}")
    
    # Firewall considerations (conceptual)
    print("Network Security Best Practices:")
    print("1. Bind Redis to specific interfaces")
    print("2. Use firewall rules to restrict access")
    print("3. Enable protected mode")
    print("4. Use VPN or SSH tunneling for remote access")
    print("5. Monitor network traffic")


def example_6_key_expiration_and_cleanup(r):
    """Example 6: Key Expiration and Cleanup for Security"""
    print("\n=== Example 6: Key Expiration and Cleanup ===")
    
    # Set keys with expiration for sensitive data
    sensitive_keys = [
        'session_token_12345',
        'password_reset_token_67890',
        'api_key_temp_abcde'
    ]
    
    for key in sensitive_keys:
        # Set with 5-minute expiration
        r.setex(key, 300, f"sensitive_data_{key}")
        print(f"Set key '{key}' with 5-minute expiration")
    
    # Check TTL (Time To Live)
    for key in sensitive_keys:
        ttl = r.ttl(key)
        print(f"TTL for '{key}': {ttl} seconds")
    
    # Automatic cleanup simulation
    print("Simulating automatic cleanup of expired keys...")
    time.sleep(301)  # Wait for keys to expire
    
    for key in sensitive_keys:
        value = r.get(key)
        if value is None:
            print(f"Key '{key}' has been automatically cleaned up")
        else:
            print(f"Key '{key}' still exists: {value}")


def example_7_audit_logging(r):
    """Example 7: Audit Logging Concept"""
    print("\n=== Example 7: Audit Logging Concept ===")
    
    # Redis doesn't have built-in audit logging, but you can implement
    # application-level logging
    
    def logged_set(redis_client, key, value, user, action="SET"):
        """Wrapper function that logs operations"""
        timestamp = datetime.now().isoformat()
        log_entry = f"{timestamp} | USER: {user} | ACTION: {action} | KEY: {key}"
        
        # Log to a separate audit log key
        redis_client.lpush('audit_log', log_entry)
        
        # Perform the actual operation
        if action == "SET":
            return redis_client.set(key, value)
        elif action == "GET":
            return redis_client.get(key)
    
    # Example usage
    logged_set(r, 'user_profile_123', '{"name":"John","role":"user"}', 'admin_user')
    logged_set(r, 'config_api_limit', '1000', 'system_admin')
    
    # View audit log
    audit_entries = r.lrange('audit_log', 0, -1)
    print("Audit Log Entries:")
    for entry in audit_entries[:5]:  # Show last 5 entries
        print(f"  {entry}")


def example_8_secure_configuration(r):
    """Example 8: Secure Configuration Settings"""
    print("\n=== Example 8: Secure Configuration Settings ===")
    
    # Get Redis configuration (be careful with sensitive info)
    try:
        # Safe configuration checks
        config_items = ['requirepass', 'maxmemory', 'maxmemory-policy', 'tcp-keepalive']
        
        print("Important Security Configuration:")
        for item in config_items:
            try:
                value = r.config_get(item)
                if value:
                    # Mask sensitive values
                    if item == 'requirepass' and value[item]:
                        print(f"  {item}: ***PROTECTED***")
                    else:
                        print(f"  {item}: {value[item]}")
            except Exception:
                print(f"  {item}: Not accessible or not set")
                
    except Exception as e:
        print(f"Could not retrieve configuration: {e}")
    
    print("\nSecurity Configuration Best Practices:")
    print("1. Set a strong requirepass")
    print("2. Disable dangerous commands")
    print("3. Configure appropriate timeouts")
    print("4. Limit memory usage")
    print("5. Regular security updates")


def example_9_session_management(r):
    """Example 9: Secure Session Management"""
    print("\n=== Example 9: Secure Session Management ===")
    
    def create_secure_session(user_id):
        """Create a secure session token"""
        # Generate cryptographically secure random token
        token = secrets.token_urlsafe(32)
        session_key = f"session:{token}"
        
        # Session data
        session_data = {
            'user_id': user_id,
            'created_at': datetime.now().isoformat(),
            'expires_at': (datetime.now() + timedelta(hours=2)).isoformat()
        }
        
        # Store session with expiration (2 hours)
        r.hset(session_key, mapping=session_data)
        r.expire(session_key, 7200)  # 2 hours in seconds
        
        return token
    
    def validate_session(token):
        """Validate a session token"""
        session_key = f"session:{token}"
        if r.exists(session_key):
            session_data = r.hgetall(session_key)
            # Check if expired
            expires_at = datetime.fromisoformat(session_data['expires_at'])
            if datetime.now() < expires_at:
                return session_data
            else:
                # Session expired, remove it
                r.delete(session_key)
                return None
        return None
    
    def destroy_session(token):
        """Destroy a session"""
        session_key = f"session:{token}"
        r.delete(session_key)
        print(f"Session {token[:10]}... destroyed")
    
    # Example usage
    user_id = "user_12345"
    token = create_secure_session(user_id)
    print(f"Created session token: {token[:20]}...")
    
    # Validate session
    session_data = validate_session(token)
    if session_data:
        print(f"Valid session for user: {session_data['user_id']}")
    else:
        print("Invalid or expired session")
    
    # Destroy session
    destroy_session(token)


def example_10_vulnerability_prevention(r):
    """Example 10: Vulnerability Prevention Techniques"""
    print("\n=== Example 10: Vulnerability Prevention Techniques ===")
    
    # Input sanitization example
    def sanitize_key(key):
        """Sanitize user input for Redis keys"""
        # Remove potentially dangerous characters
        sanitized = key.replace(' ', '_').replace('\n', '').replace('\r', '')
        # Limit length
        return sanitized[:100]
    
    # Safe command execution
    def safe_redis_operation(client, operation, *args):
        """Execute Redis commands safely"""
        try:
            # Validate arguments
            for arg in args:
                if isinstance(arg, str) and ('FLUSHALL' in arg.upper() or 'FLUSHDB' in arg.upper()):
                    raise ValueError("Dangerous command detected")
            
            # Execute operation
            result = getattr(client, operation)(*args)
            return result
        except Exception as e:
            print(f"Safe operation blocked or failed: {e}")
            return None
    
    # Example usage
    user_input = "user_data\nFLUSHALL"  # Malicious input
    safe_key = sanitize_key(user_input)
    print(f"Sanitized key: {safe_key}")
    
    # This will be blocked
    result = safe_redis_operation(r, 'set', safe_key, 'safe_value')
    if result is not None:
        print("Operation completed safely")
    else:
        print("Operation was blocked for security")


def main():
    """Main function to run all examples"""
    print("Redis Security Examples")
    print("======================")
    
    # Test Redis connection
    r = test_redis_connection()
    if not r:
        return
    
    # Clear database for clean testing
    r.flushdb()
    
    # Run all examples
    example_1_authentication(r)
    example_2_acl_management(r)
    example_3_encryption_in_transit(r)
    example_4_data_at_rest_encryption(r)
    example_5_network_security(r)
    example_6_key_expiration_and_cleanup(r)
    example_7_audit_logging(r)
    example_8_secure_configuration(r)
    example_9_session_management(r)
    example_10_vulnerability_prevention(r)
    
    print("\n=== Security Best Practices Summary ===")
    print("1. Always use strong authentication")
    print("2. Implement proper access controls with ACLs")
    print("3. Encrypt data in transit with TLS")
    print("4. Encrypt sensitive data at rest in your application")
    print("5. Bind Redis to specific interfaces and use firewalls")
    print("6. Enable protected mode")
    print("7. Use key expiration for sensitive temporary data")
    print("8. Implement audit logging for security-sensitive operations")
    print("9. Keep Redis updated with security patches")
    print("10. Disable or rename dangerous commands")
    print("11. Monitor and alert on suspicious activities")
    print("12. Regularly review and update security configurations")


if __name__ == "__main__":
    main()