#!/usr/bin/env python3
"""
Redis Keys Examples
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
    
    print("\n=== Redis Keys Examples ===\n")
    
    # 1. Basic Key Operations
    print("--- 1. Basic Key Operations ---")
    # Set some keys
    r.set('user:1001', 'Alice')
    r.set('user:1002', 'Bob')
    r.set('product:2001', 'Laptop')
    r.set('product:2002', 'Mouse')
    
    # Check if keys exist
    print(f"Does 'user:1001' exist? {r.exists('user:1001')}")
    print(f"Does 'user:9999' exist? {r.exists('user:9999')}")
    
    # Get key type
    print(f"Type of 'user:1001': {r.type('user:1001')}")
    print(f"Type of 'nonexistent': {r.type('nonexistent')}")
    
    # 2. Key Expiration
    print("\n--- 2. Key Expiration ---")
    # Set a key with expiration time (5 seconds)
    r.setex('temporary_key', 5, 'This will expire soon')
    print(f"Temporary key exists: {r.exists('temporary_key')}")
    print(f"Time to live (TTL): {r.ttl('temporary_key')} seconds")
    
    # Set a key and then set expiration
    r.set('another_temp_key', 'This will also expire')
    r.expire('another_temp_key', 3)
    print(f"Another temporary key TTL: {r.ttl('another_temp_key')} seconds")
    
    # Wait for keys to expire
    print("Waiting for keys to expire...")
    time.sleep(6)
    print(f"Temporary key exists after expiration: {r.exists('temporary_key')}")
    print(f"Another temporary key exists after expiration: {r.exists('another_temp_key')}")
    
    # 3. Key Pattern Matching
    print("\n--- 3. Key Pattern Matching ---")
    # Set keys with patterns
    r.set('user:profile:1001', 'Alice Profile')
    r.set('user:profile:1002', 'Bob Profile')
    r.set('user:session:1001', 'Session data for Alice')
    r.set('user:session:1002', 'Session data for Bob')
    r.set('product:info:2001', 'Laptop Info')
    r.set('product:info:2002', 'Mouse Info')
    
    # Find keys matching patterns
    user_keys = r.keys('user:*')
    print(f"All user keys: {user_keys}")
    
    profile_keys = r.keys('user:profile:*')
    print(f"User profile keys: {profile_keys}")
    
    specific_pattern = r.keys('*1001*')
    print(f"Keys containing '1001': {specific_pattern}")
    
    # 4. Key Movement and Renaming
    print("\n--- 4. Key Movement and Renaming ---")
    # Set a key
    r.set('original_key', 'Original Value')
    
    # Rename a key
    r.rename('original_key', 'renamed_key')
    print(f"Value of renamed key: {r.get('renamed_key')}")
    
    # Safe rename (only if new key doesn't exist)
    r.set('safe_rename_source', 'Source Value')
    try:
        r.renamenx('safe_rename_source', 'renamed_key')  # Should fail since renamed_key exists
        print("Renamenx succeeded")
    except redis.ResponseError:
        print("Renamenx failed - target key already exists")
    
    # Successful renamenx
    r.renamenx('safe_rename_source', 'safe_rename_target')
    print(f"Value of safe renamed key: {r.get('safe_rename_target')}")
    
    # 5. Key Information
    print("\n--- 5. Key Information ---")
    # Set a key with value
    r.set('info_key', 'Some information')
    
    # Get key dump (serialized value)
    dumped_value = r.dump('info_key')
    print(f"Dumped value length: {len(dumped_value) if dumped_value else 0} bytes")
    
    # Get object encoding
    encoding = r.object('encoding', 'info_key')
    print(f"Key encoding: {encoding}")
    
    # Get object idle time
    idle_time = r.object('idletime', 'info_key')
    print(f"Key idle time: {idle_time} seconds")
    
    # 6. Multiple Key Operations
    print("\n--- 6. Multiple Key Operations ---")
    # Set multiple keys
    r.mset({
        'multi_key1': 'Value 1',
        'multi_key2': 'Value 2',
        'multi_key3': 'Value 3'
    })
    
    # Get multiple keys
    values = r.mget(['multi_key1', 'multi_key2', 'multi_key3', 'nonexistent'])
    print(f"Multiple key values: {values}")
    
    # Delete multiple keys
    deleted_count = r.delete('multi_key1', 'multi_key2', 'multi_key3')
    print(f"Deleted {deleted_count} keys")
    
    # 7. Key Scanning (better alternative to KEYS for large datasets)
    print("\n--- 7. Key Scanning ---")
    # Set many keys for scanning demonstration
    for i in range(20):
        r.set(f'scan_key:{i}', f'Value {i}')
    
    # Scan keys
    cursor = 0
    all_scanned_keys = []
    while True:
        cursor, keys = r.scan(cursor, match='scan_key:*', count=10)
        all_scanned_keys.extend(keys)
        if cursor == 0:
            break
    
    print(f"Scanned keys: {all_scanned_keys}")
    print(f"Total scanned keys: {len(all_scanned_keys)}")
    
    # Clean up scanned keys
    r.delete(*all_scanned_keys)
    
    # 8. Key Sorting
    print("\n--- 8. Key Sorting ---")
    # Add items to a list
    r.lpush('sort_list', '3', '1', '4', '2', '5')
    print(f"Original list: {r.lrange('sort_list', 0, -1)}")
    
    # Sort the list
    sorted_list = r.sort('sort_list')
    print(f"Sorted list: {sorted_list}")
    
    # Sort descending
    sorted_desc = r.sort('sort_list', desc=True)
    print(f"Sorted descending: {sorted_desc}")
    
    # Clean up
    keys_to_delete = [
        'user:1001', 'user:1002', 'product:2001', 'product:2002',
        'user:profile:1001', 'user:profile:1002', 
        'user:session:1001', 'user:session:1002',
        'product:info:2001', 'product:info:2002',
        'renamed_key', 'safe_rename_target', 'info_key',
        'sort_list'
    ]
    r.delete(*keys_to_delete)
    
    print("\nAll examples completed!")

if __name__ == "__main__":
    main()