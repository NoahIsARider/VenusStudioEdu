#!/usr/bin/env python3
"""
Redis Basics Examples
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
    
    # 1. String operations
    print("\n--- String Operations ---")
    r.set('greeting', 'Hello, Redis!')
    print(f"Get greeting: {r.get('greeting')}")
    
    r.set('counter', 10)
    r.incr('counter')
    print(f"Incremented counter: {r.get('counter')}")
    
    r.append('greeting', ' Welcome!')
    print(f"Appended greeting: {r.get('greeting')}")
    
    # 2. List operations
    print("\n--- List Operations ---")
    r.lpush('tasks', 'task1', 'task2', 'task3')
    r.rpush('tasks', 'task4')
    print(f"All tasks: {r.lrange('tasks', 0, -1)}")
    print(f"First task: {r.lpop('tasks')}")
    print(f"Last task: {r.rpop('tasks')}")
    
    # 3. Hash operations
    print("\n--- Hash Operations ---")
    r.hset('user:1000', mapping={
        'name': 'Alice',
        'email': 'alice@example.com',
        'age': 30
    })
    print(f"User name: {r.hget('user:1000', 'name')}")
    print(f"User info: {r.hgetall('user:1000')}")
    
    # 4. Set operations
    print("\n--- Set Operations ---")
    r.sadd('tags:post1', 'redis', 'database', 'nosql')
    r.sadd('tags:post2', 'redis', 'cache', 'performance')
    print(f"Tags for post1: {r.smembers('tags:post1')}")
    print(f"Common tags: {r.sinter('tags:post1', 'tags:post2')}")
    
    # 5. Sorted Set operations
    print("\n--- Sorted Set Operations ---")
    r.zadd('leaderboard', {'player1': 100, 'player2': 200, 'player3': 150})
    print(f"Leaderboard: {r.zrange('leaderboard', 0, -1, withscores=True)}")
    print(f"Top player: {r.zrevrange('leaderboard', 0, 0, withscores=True)}")
    
    # 6. Key operations
    print("\n--- Key Operations ---")
    r.setex('temporary', 5, 'This will expire in 5 seconds')
    print(f"Temporary key exists: {r.exists('temporary')}")
    time.sleep(6)
    print(f"Temporary key after expiration: {r.exists('temporary')}")
    
    # 7. Transactions
    print("\n--- Transactions ---")
    pipe = r.pipeline()
    pipe.set('name', 'John')
    pipe.set('city', 'New York')
    pipe.execute()
    print(f"Name: {r.get('name')}, City: {r.get('city')}")
    
    # Clean up
    r.delete('greeting', 'counter', 'tasks', 'user:1000', 'tags:post1', 
             'tags:post2', 'leaderboard', 'name', 'city')
    
    print("\nAll examples completed!")

if __name__ == "__main__":
    main()