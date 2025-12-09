#!/usr/bin/env python3
"""
Redis Data Types Practice Exercises
"""

import redis
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
    
    print("\nStarting Redis Data Types Practice Exercises...\n")
    
    # Exercise 1: String Operations
    print("--- Exercise 1: String Operations ---")
    # Store a user's name and increment their login count
    r.set('user:name', 'Alice')
    r.set('user:login_count', 0)
    r.incr('user:login_count')
    r.incrby('user:login_count', 3)
    print(f"User: {r.get('user:name')}")
    print(f"Login count: {r.get('user:login_count')}")
    
    # Exercise 2: List Operations
    print("\n--- Exercise 2: List Operations ---")
    # Implement a simple task queue
    r.lpush('task_queue', 'task1', 'task2', 'task3')
    r.rpush('task_queue', 'task4', 'task5')
    print(f"Task queue: {r.lrange('task_queue', 0, -1)}")
    processing_task = r.lpop('task_queue')
    print(f"Processing task: {processing_task}")
    print(f"Remaining tasks: {r.llen('task_queue')}")
    
    # Exercise 3: Hash Operations
    print("\n--- Exercise 3: Hash Operations ---")
    # Store product information
    r.hset('product:1001', mapping={
        'name': 'Laptop',
        'price': 999.99,
        'category': 'Electronics',
        'stock': 50
    })
    print(f"Product name: {r.hget('product:1001', 'name')}")
    r.hincrby('product:1001', 'stock', -1)  # Sold one item
    print(f"Updated stock: {r.hget('product:1001', 'stock')}")
    print(f"All product info: {r.hgetall('product:1001')}")
    
    # Exercise 4: Set Operations
    print("\n--- Exercise 4: Set Operations ---")
    # Manage user tags
    r.sadd('user:tags:alice', 'python', 'redis', 'database')
    r.sadd('user:tags:bob', 'python', 'javascript', 'web')
    print(f"Alice's tags: {r.smembers('user:tags:alice')}")
    print(f"Bob's tags: {r.smembers('user:tags:bob')}")
    common_tags = r.sinter('user:tags:alice', 'user:tags:bob')
    print(f"Common tags: {common_tags}")
    
    # Exercise 5: Sorted Set Operations
    print("\n--- Exercise 5: Sorted Set Operations ---")
    # Implement a game leaderboard
    r.zadd('game:leaderboard', {
        'player1': 1500,
        'player2': 2000,
        'player3': 1800,
        'player4': 1200
    })
    print("Top 3 players:")
    top_players = r.zrevrange('game:leaderboard', 0, 2, withscores=True)
    for i, (player, score) in enumerate(top_players, 1):
        print(f"  {i}. {player}: {int(score)} points")
    
    # Update a player's score
    r.zincrby('game:leaderboard', 300, 'player4')
    print(f"Player4's new score: {int(r.zscore('game:leaderboard', 'player4'))}")
    
    # Exercise 6: HyperLogLog
    print("\n--- Exercise 6: HyperLogLog ---")
    # Estimate unique visitors to a website
    r.pfadd('website:visitors:2023-06-01', 'user1', 'user2', 'user3')
    r.pfadd('website:visitors:2023-06-01', 'user3', 'user4', 'user5')
    unique_visitors = r.pfcount('website:visitors:2023-06-01')
    print(f"Estimated unique visitors: {unique_visitors}")
    
    # Exercise 7: Bitmaps
    print("\n--- Exercise 7: Bitmaps ---")
    # Track daily active users (assuming user IDs 1-10)
    # Day 1 activity
    r.setbit('daily_active:2023-06-01', 1, 1)
    r.setbit('daily_active:2023-06-01', 3, 1)
    r.setbit('daily_active:2023-06-01', 5, 1)
    r.setbit('daily_active:2023-06-01', 7, 1)
    
    # Day 2 activity
    r.setbit('daily_active:2023-06-02', 2, 1)
    r.setbit('daily_active:2023-06-02', 3, 1)
    r.setbit('daily_active:2023-06-02', 5, 1)
    r.setbit('daily_active:2023-06-02', 8, 1)
    
    # Count daily active users
    day1_count = r.bitcount('daily_active:2023-06-01')
    day2_count = r.bitcount('daily_active:2023-06-02')
    print(f"Day 1 active users: {day1_count}")
    print(f"Day 2 active users: {day2_count}")
    
    # Exercise 8: Geospatial
    print("\n--- Exercise 8: Geospatial ---")
    # Store locations of stores
    r.geoadd('stores', (13.361389, 38.115556, 'Store A'))
    r.geoadd('stores', (15.087269, 37.502669, 'Store B'))
    r.geoadd('stores', (13.583333, 37.316667, 'Store C'))
    
    # Find stores within 100km of a location
    nearby_stores = r.georadius('stores', 13.361389, 38.115556, 100, unit='km')
    print(f"Stores within 100km: {nearby_stores}")
    
    # Calculate distance between two stores
    distance = r.geodist('stores', 'Store A', 'Store B', unit='km')
    print(f"Distance between Store A and Store B: {float(distance):.2f} km")
    
    print("\nPractice exercises completed!")
    print("Bonus Exercise: Try combining multiple data types to implement a more complex feature like a shopping cart or social media feed.")

if __name__ == "__main__":
    main()