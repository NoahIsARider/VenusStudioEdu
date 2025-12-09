#!/usr/bin/env python3
"""
Redis Strings Example
This script demonstrates various string operations in Redis.
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
    
    print("\n=== Redis Strings Examples ===\n")
    
    # 1. Basic String Operations
    print("1. Basic String Operations")
    # SET and GET
    r.set('greeting', 'Hello, Redis!')
    print(f"GET greeting: {r.get('greeting')}")
    
    # SET with expiration
    r.setex('temporary', 10, 'This will expire in 10 seconds')
    print(f"GET temporary: {r.get('temporary')}")
    print(f"TTL temporary: {r.ttl('temporary')} seconds")
    
    # SETNX (Set if Not eXists)
    r.setnx('unique_key', 'Initial Value')
    print(f"SETNX unique_key: {r.get('unique_key')}")
    r.setnx('unique_key', 'This will not overwrite')  # Won't change the value
    print(f"SETNX unique_key after second attempt: {r.get('unique_key')}")
    
    # GETSET (Get old value and set new value)
    old_value = r.getset('greeting', 'Hello, Redis World!')
    print(f"Old value from GETSET: {old_value}")
    print(f"New value from GET: {r.get('greeting')}")
    
    # MSET and MGET (Multiple SET and GET)
    r.mset({'color': 'blue', 'size': 'large', 'shape': 'circle'})
    values = r.mget(['color', 'size', 'shape'])
    print(f"MGET color, size, shape: {values}")
    
    print("\n" + "-"*50 + "\n")
    
    # 2. String Manipulation
    print("2. String Manipulation")
    # Append to string
    r.set('message', 'Hello')
    r.append('message', ' World')
    print(f"APPEND result: {r.get('message')}")
    
    # Get string length
    print(f"STRLEN message: {r.strlen('message')}")
    
    # Get substring
    r.set('alphabet', 'abcdefghijklmnopqrstuvwxyz')
    print(f"GETRANGE alphabet [0, 4]: {r.getrange('alphabet', 0, 4)}")
    print(f"GETRANGE alphabet [-5, -1]: {r.getrange('alphabet', -5, -1)}")
    
    # Set range
    r.setrange('alphabet', 0, 'HELLO')
    print(f"SETRANGE result: {r.get('alphabet')}")
    
    print("\n" + "-"*50 + "\n")
    
    # 3. Numeric Operations
    print("3. Numeric Operations")
    # Increment integer
    r.set('counter', 10)
    r.incr('counter')
    print(f"INCR counter: {r.get('counter')}")
    
    # Increment by value
    r.incrby('counter', 5)
    print(f"INCRBY counter 5: {r.get('counter')}")
    
    # Decrement
    r.decr('counter')
    print(f"DECR counter: {r.get('counter')}")
    
    # Decrement by value
    r.decrby('counter', 3)
    print(f"DECRBY counter 3: {r.get('counter')}")
    
    # Float operations
    r.set('balance', 100.50)
    r.incrbyfloat('balance', 25.75)
    print(f"INCRBYFLOAT balance 25.75: {r.get('balance')}")
    
    print("\n" + "-"*50 + "\n")
    
    # 4. Bit Operations
    print("4. Bit Operations")
    # Set bits
    r.setbit('bitstring', 2, 1)
    r.setbit('bitstring', 7, 1)
    print(f"GETBIT bitstring 2: {r.getbit('bitstring', 2)}")
    print(f"GETBIT bitstring 7: {r.getbit('bitstring', 7)}")
    
    # Bit count
    print(f"BITCOUNT bitstring: {r.bitcount('bitstring')}")
    
    # Bit operations between strings
    r.set('string1', 'foobar')
    r.set('string2', 'abcdef')
    r.bitop('AND', 'result_and', 'string1', 'string2')
    print(f"BITOP AND result: {r.get('result_and')}")
    
    print("\n" + "-"*50 + "\n")
    
    # 5. Advanced String Operations
    print("5. Advanced String Operations")
    # Set with conditional expiration (KEEPTTL)
    r.set('expiring_key', 'original_value', ex=60)
    r.set('expiring_key', 'updated_value', keepttl=True)
    print(f"Updated value with KEEPTTL: {r.get('expiring_key')}")
    print(f"TTL after KEEPTTL: {r.ttl('expiring_key')} seconds")
    
    # Conditional SET operations
    # SET with XX (only set if key exists)
    r.set('existing_key', 'original')
    r.set('existing_key', 'updated_with_xx', xx=True)
    print(f"SET with XX on existing key: {r.get('existing_key')}")
    
    r.set('non_existing_key_with_xx', 'should_not_work', xx=True)
    print(f"SET with XX on non-existing key: {r.get('non_existing_key_with_xx')}")
    
    # SET with NX (only set if key doesn't exist)
    r.set('new_key_nx', 'created_with_nx', nx=True)
    print(f"SET with NX on new key: {r.get('new_key_nx')}")
    
    r.set('existing_key_nx', 'should_not_change', nx=True)
    print(f"SET with NX on existing key: {r.get('existing_key_nx')}")
    
    # GETDEL (Get value and delete key)
    r.set('temporary_getdel', 'to_be_deleted')
    value = r.getdel('temporary_getdel')
    print(f"GETDEL value: {value}")
    print(f"Key exists after GETDEL: {r.exists('temporary_getdel')}")
    
    print("\n=== End of Redis Strings Examples ===")

if __name__ == "__main__":
    main()