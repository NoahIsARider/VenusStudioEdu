#!/usr/bin/env python3
"""
Redis Data Types Examples
"""

import redis
import time
import json

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
    
    print("\n=== Redis Data Types Examples ===\n")
    
    # 1. Strings
    print("--- 1. Strings ---")
    r.set('string_example', 'Hello, Redis!')
    print(f"Basic string: {r.get('string_example')}")
    
    # Numeric operations
    r.set('counter', 10)
    r.incr('counter')
    r.incrby('counter', 5)
    print(f"Counter after operations: {r.get('counter')}")
    
    # Binary data
    r.set('binary_data', b'\x00\x01\x02\x03')
    print(f"Binary data: {r.get('binary_data')}")
    
    # 2. Lists
    print("\n--- 2. Lists ---")
    r.lpush('list_example', 'item1', 'item2', 'item3')
    r.rpush('list_example', 'item4')
    print(f"All list items: {r.lrange('list_example', 0, -1)}")
    print(f"First item: {r.lpop('list_example')}")
    print(f"Last item: {r.rpop('list_example')}")
    print(f"List length: {r.llen('list_example')}")
    
    # 3. Hashes
    print("\n--- 3. Hashes ---")
    r.hset('hash_example', mapping={
        'name': 'John Doe',
        'email': 'john@example.com',
        'age': 30
    })
    print(f"User name: {r.hget('hash_example', 'name')}")
    print(f"All user info: {r.hgetall('hash_example')}")
    print(f"User fields: {r.hkeys('hash_example')}")
    print(f"User values: {r.hvals('hash_example')}")
    
    # 4. Sets
    print("\n--- 4. Sets ---")
    r.sadd('set_example1', 'a', 'b', 'c', 'd')
    r.sadd('set_example2', 'c', 'd', 'e', 'f')
    print(f"Set 1 members: {r.smembers('set_example1')}")
    print(f"Set 2 members: {r.smembers('set_example2')}")
    print(f"Intersection: {r.sinter('set_example1', 'set_example2')}")
    print(f"Union: {r.sunion('set_example1', 'set_example2')}")
    print(f"Difference: {r.sdiff('set_example1', 'set_example2')}")
    
    # 5. Sorted Sets
    print("\n--- 5. Sorted Sets ---")
    r.zadd('sorted_set_example', {
        'player1': 100,
        'player2': 200,
        'player3': 150,
        'player4': 300
    })
    print(f"Leaderboard: {r.zrange('sorted_set_example', 0, -1, withscores=True)}")
    print(f"Top 2 players: {r.zrevrange('sorted_set_example', 0, 1, withscores=True)}")
    print(f"Players with scores 100-200: {r.zrangebyscore('sorted_set_example', 100, 200, withscores=True)}")
    
    # 6. HyperLogLog
    print("\n--- 6. HyperLogLog ---")
    r.pfadd('hll_example', 'user1', 'user2', 'user3', 'user4')
    r.pfadd('hll_example', 'user3', 'user4', 'user5', 'user6')
    print(f"Estimated unique users: {r.pfcount('hll_example')}")
    
    # 7. Bitmaps
    print("\n--- 7. Bitmaps ---")
    r.setbit('bitmap_example', 0, 1)
    r.setbit('bitmap_example', 1, 1)
    r.setbit('bitmap_example', 2, 0)
    r.setbit('bitmap_example', 3, 1)
    print(f"Bit at position 0: {r.getbit('bitmap_example', 0)}")
    print(f"Bit at position 2: {r.getbit('bitmap_example', 2)}")
    print(f"Population count: {r.bitcount('bitmap_example')}")
    
    # 8. Geospatial
    print("\n--- 8. Geospatial ---")
    r.geoadd('cities', (13.361389, 38.115556, 'Palermo'))
    r.geoadd('cities', (15.087269, 37.502669, 'Catania'))
    distance = r.geodist('cities', 'Palermo', 'Catania', unit='km')
    print(f"Distance between Palermo and Catania: {distance} km")
    print(f"Position of Palermo: {r.geopos('cities', 'Palermo')}")
    
    # Clean up
    keys_to_delete = [
        'string_example', 'counter', 'binary_data', 'list_example',
        'hash_example', 'set_example1', 'set_example2', 'sorted_set_example',
        'hll_example', 'bitmap_example', 'cities'
    ]
    r.delete(*keys_to_delete)
    
    print("\nAll examples completed!")

if __name__ == "__main__":
    main()