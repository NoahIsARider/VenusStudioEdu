#!/usr/bin/env python3
"""
Redis Keys Practice Exercises
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
    
    print("\nStarting Redis Keys Practice Exercises...\n")
    
    # Exercise 1: Key Creation and Existence Checking
    print("--- Exercise 1: Key Creation and Existence Checking ---")
    # Create keys for a simple blog system
    r.set('blog:title:1', 'Introduction to Redis')
    r.set('blog:author:1', 'Alice')
    r.set('blog:content:1', 'Redis is an in-memory data structure store...')
    
    # Check if specific keys exist
    print(f"Does blog title exist? {r.exists('blog:title:1')}")
    print(f"Does blog author exist? {r.exists('blog:author:1')}")
    print(f"Does nonexistent key exist? {r.exists('blog:title:999')}")
    
    # Exercise 2: Key Expiration
    print("\n--- Exercise 2: Key Expiration ---")
    # Create a session key with expiration
    r.setex('session:user:12345', 10, 'session_data_here')
    print(f"Session key TTL: {r.ttl('session:user:12345')} seconds")
    
    # Create a cache key and set expiration separately
    r.set('cache:weather:beijing', '25°C, Sunny')
    r.expire('cache:weather:beijing', 5)
    print(f"Weather cache TTL: {r.ttl('cache:weather:beijing')} seconds")
    
    # Wait and check expiration
    time.sleep(6)
    print(f"Weather cache exists after expiration: {r.exists('cache:weather:beijing')}")
    
    # Exercise 3: Key Patterns and Scanning
    print("\n--- Exercise 3: Key Patterns and Scanning ---")
    # Create keys with patterns for an e-commerce system
    r.set('product:name:1001', 'Laptop')
    r.set('product:price:1001', '999.99')
    r.set('product:stock:1001', '50')
    
    r.set('product:name:1002', 'Mouse')
    r.set('product:price:1002', '29.99')
    r.set('product:stock:1002', '200')
    
    r.set('user:name:1001', 'Alice')
    r.set('user:name:1002', 'Bob')
    
    # Find all product keys
    product_keys = r.keys('product:*')
    print(f"All product keys: {product_keys}")
    
    # Find all product names
    product_names = r.keys('product:name:*')
    print(f"Product name keys: {product_names}")
    
    # Use scan for better performance with large datasets
    cursor = 0
    user_keys = []
    while True:
        cursor, keys = r.scan(cursor, match='user:*', count=10)
        user_keys.extend(keys)
        if cursor == 0:
            break
    print(f"User keys (using scan): {user_keys}")
    
    # Exercise 4: Key Renaming and Moving
    print("\n--- Exercise 4: Key Renaming and Moving ---")
    # Create a key
    r.set('draft:article:1', 'Draft content here')
    
    # Rename the key
    r.rename('draft:article:1', 'published:article:1')
    print(f"Published article content: {r.get('published:article:1')}")
    
    # Try safe rename (should fail if target exists)
    r.set('temp:draft', 'Temporary draft')
    try:
        r.renamenx('temp:draft', 'published:article:1')  # Should fail
        print("Renamenx succeeded")
    except redis.ResponseError:
        print("Renamenx failed - target key already exists")
    
    # Successful safe rename
    r.renamenx('temp:draft', 'archived:draft')
    print(f"Archived draft content: {r.get('archived:draft')}")
    
    # Exercise 5: Multiple Key Operations
    print("\n--- Exercise 5: Multiple Key Operations ---")
    # Set multiple configuration keys at once
    r.mset({
        'config:theme': 'dark',
        'config:language': 'en',
        'config:notifications': 'enabled',
        'config:auto_save': 'true'
    })
    
    # Get multiple configuration values
    config_values = r.mget(['config:theme', 'config:language', 'config:notifications', 'config:auto_save'])
    print(f"Configuration values: {dict(zip(['theme', 'language', 'notifications', 'auto_save'], config_values))}")
    
    # Delete multiple keys
    deleted_count = r.delete('config:theme', 'config:language', 'config:notifications', 'config:auto_save')
    print(f"Deleted {deleted_count} configuration keys")
    
    # Exercise 6: Key Information and Metadata
    print("\n--- Exercise 6: Key Information and Metadata ---")
    # Create a key with value
    r.set('metadata:example', 'This is example data')
    
    # Get key type
    key_type = r.type('metadata:example')
    print(f"Key type: {key_type}")
    
    # Get time to live
    ttl = r.ttl('metadata:example')
    print(f"Key TTL: {ttl} seconds")
    
    # Get object encoding
    encoding = r.object('encoding', 'metadata:example')
    print(f"Key encoding: {encoding}")
    
    # Exercise 7: Working with Key Patterns
    print("\n--- Exercise 7: Working with Key Patterns ---")
    # Create a set of keys for a gaming system
    r.set('game:player:1001:score', '1500')
    r.set('game:player:1001:level', '15')
    r.set('game:player:1002:score', '2100')
    r.set('game:player:1002:level', '22')
    r.set('game:player:1003:score', '900')
    r.set('game:player:1003:level', '8')
    
    # Find all player score keys
    score_keys = r.keys('game:player:*:score')
    print(f"Player score keys: {score_keys}")
    
    # Get all player scores
    scores = r.mget(score_keys)
    print(f"Player scores: {dict(zip(score_keys, scores))}")
    
    # Exercise 8: Advanced Key Operations
    print("\n--- Exercise 8: Advanced Key Operations ---")
    # Create keys for sorting demonstration
    r.lpush('leaderboard', 'player3', 'player1', 'player4', 'player2')
    r.set('score:player1', 1500)
    r.set('score:player2', 2100)
    r.set('score:player3', 900)
    r.set('score:player4', 1800)
    
    # Sort players by their scores
    sorted_players = r.sort('leaderboard', by='score:*', get='score:*', desc=True)
    print(f"Players sorted by score: {sorted_players}")
    
    print("\nPractice exercises completed!")
    print("Bonus Exercise: Design a key naming strategy for a complex application like a social media platform, considering scalability and organization.")

if __name__ == "__main__":
    main()