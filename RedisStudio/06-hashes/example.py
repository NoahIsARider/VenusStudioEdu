#!/usr/bin/env python3
"""
Redis Hashes Example
This script demonstrates various hash operations in Redis.
"""

import redis
import time

def main():
    # Connect to Redis
    r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)
    
    # Test connection
    try:
        r.ping()
        print("Connected to Redis successfully!")
    except redis.ConnectionError:
        print("Failed to connect to Redis")
        return
    
    print("\n=== Redis Hashes Examples ===\n")
    
    # Clear any existing data
    r.delete('user:1000', 'product:2000', 'session:abc123', 'config:app')
    
    # 1. Basic Hash Operations (HSET, HGET, HMSET, HMGET)
    print("1. Basic Hash Operations")
    
    # HSET - Set field in hash
    r.hset('user:1000', 'name', 'Alice Johnson')
    r.hset('user:1000', 'email', 'alice@example.com')
    r.hset('user:1000', 'age', 30)
    print(f"User hash after HSET: {r.hgetall('user:1000')}")
    
    # HGET - Get field value from hash
    name = r.hget('user:1000', 'name')
    print(f"HGET name: {name}")
    
    # HMSET - Set multiple fields (deprecated, but still works)
    # Using HSET with dict is preferred in newer versions
    r.hset('product:2000', mapping={
        'name': 'Laptop',
        'price': 999.99,
        'category': 'Electronics',
        'in_stock': 50
    })
    print(f"Product hash after HMSET: {r.hgetall('product:2000')}")
    
    # HMGET - Get multiple fields
    product_info = r.hmget('product:2000', 'name', 'price', 'category')
    print(f"HMGET product info: {product_info}")
    
    print("\n" + "-"*50 + "\n")
    
    # 2. Hash Inspection (HGETALL, HKEYS, HVALS, HLEN)
    print("2. Hash Inspection")
    
    # HGETALL - Get all fields and values
    user_data = r.hgetall('user:1000')
    print(f"HGETALL user:1000: {user_data}")
    
    # HKEYS - Get all field names
    user_fields = r.hkeys('user:1000')
    print(f"HKEYS user:1000: {user_fields}")
    
    # HVALS - Get all values
    user_values = r.hvals('user:1000')
    print(f"HVALS user:1000: {user_values}")
    
    # HLEN - Get number of fields
    user_field_count = r.hlen('user:1000')
    print(f"HLEN user:1000: {user_field_count}")
    
    print("\n" + "-"*50 + "\n")
    
    # 3. Hash Modification (HSETNX, HINCRBY, HINCRBYFLOAT)
    print("3. Hash Modification")
    
    # HSETNX - Set field only if it doesn't exist
    r.hsetnx('user:1000', 'status', 'active')
    r.hsetnx('user:1000', 'status', 'inactive')  # Won't change value
    print(f"Status after HSETNX attempts: {r.hget('user:1000', 'status')}")
    
    # HINCRBY - Increment integer field
    r.hincrby('product:2000', 'in_stock', -2)  # Sell 2 items
    r.hincrby('product:2000', 'sales_count', 2)  # Add 2 to sales count
    print(f"Product stock after sales: {r.hgetall('product:2000')}")
    
    # HINCRBYFLOAT - Increment float field
    r.hincrbyfloat('product:2000', 'price', -50.00)  # Discount $50
    print(f"Product price after discount: {r.hget('product:2000', 'price')}")
    
    print("\n" + "-"*50 + "\n")
    
    # 4. Conditional Hash Operations (HEXISTS, HDEL)
    print("4. Conditional Hash Operations")
    
    # HEXISTS - Check if field exists
    has_email = r.hexists('user:1000', 'email')
    has_phone = r.hexists('user:1000', 'phone')
    print(f"User has email: {has_email}")
    print(f"User has phone: {has_phone}")
    
    # HDEL - Delete field(s)
    r.hset('user:1000', 'temp_field', 'temporary_value')
    print(f"Before HDEL: {r.hkeys('user:1000')}")
    r.hdel('user:1000', 'temp_field')
    print(f"After HDEL: {r.hkeys('user:1000')}")
    
    print("\n" + "-"*50 + "\n")
    
    # 5. Advanced Hash Operations (HSTRLEN, HRANDFIELD)
    print("5. Advanced Hash Operations")
    
    # HSTRLEN - Get length of field value
    name_length = r.hstrlen('user:1000', 'name')
    print(f"Length of user name: {name_length}")
    
    # Note: HRANDFIELD is available in Redis 6.2+
    # For older versions, we'll simulate random field selection
    try:
        # HRANDFIELD - Get random field(s) from hash
        random_field = r.hrandfield('user:1000')
        print(f"Random field from user hash: {random_field}")
        
        # Get random field with value
        random_field_value = r.hrandfield('user:1000', 1, withvalues=True)
        print(f"Random field with value: {random_field_value}")
    except AttributeError:
        print("HRANDFIELD not available in this Redis version")
        # Alternative approach for older versions
        import random
        fields = r.hkeys('user:1000')
        if fields:
            random_field = random.choice(fields)
            print(f"Simulated random field: {random_field}")
    
    print("\n" + "-"*50 + "\n")
    
    # 6. Practical Example: User Session Management
    print("6. Practical Example: User Session Management")
    
    # Create a session hash
    session_id = 'session:xyz789'
    r.hset(session_id, mapping={
        'user_id': '1000',
        'username': 'alice',
        'login_time': int(time.time()),
        'last_activity': int(time.time()),
        'ip_address': '192.168.1.100',
        'user_agent': 'Mozilla/5.0...',
        'permissions': 'read,write,delete'
    })
    
    print(f"Session data: {r.hgetall(session_id)}")
    
    # Update last activity
    r.hset(session_id, 'last_activity', int(time.time()))
    print(f"Last activity updated: {r.hget(session_id, 'last_activity')}")
    
    # Check if session has specific permission
    permissions = r.hget(session_id, 'permissions')
    has_write_permission = 'write' in permissions if permissions else False
    print(f"Has write permission: {has_write_permission}")
    
    # Extend session (update expiration)
    r.expire(session_id, 3600)  # 1 hour
    ttl = r.ttl(session_id)
    print(f"Session TTL: {ttl} seconds")
    
    print("\n" + "-"*50 + "\n")
    
    # 7. Practical Example: Application Configuration
    print("7. Practical Example: Application Configuration")
    
    config_key = 'config:webapp'
    # Initialize configuration
    r.hset(config_key, mapping={
        'debug_mode': 'false',
        'max_connections': 100,
        'timeout': 30,
        'log_level': 'info',
        'database_url': 'postgresql://localhost/mydb',
        'cache_enabled': 'true',
        'cache_ttl': 300
    })
    
    print(f"Initial config: {r.hgetall(config_key)}")
    
    # Update specific configuration values
    r.hset(config_key, 'debug_mode', 'true')
    r.hincrby(config_key, 'max_connections', 50)
    print(f"Updated config: {r.hgetall(config_key)}")
    
    # Get specific configuration values
    debug_mode = r.hget(config_key, 'debug_mode')
    max_conn = r.hget(config_key, 'max_connections')
    print(f"Debug mode: {debug_mode}, Max connections: {max_conn}")
    
    # Check if a configuration exists
    has_feature_flag = r.hexists(config_key, 'feature_new_ui')
    print(f"Has feature_new_ui flag: {has_feature_flag}")
    
    # Add a new configuration
    r.hset(config_key, 'feature_new_ui', 'enabled')
    print(f"Config after adding feature flag: {r.hgetall(config_key)}")
    
    print("\n=== End of Redis Hashes Examples ===")

if __name__ == "__main__":
    main()