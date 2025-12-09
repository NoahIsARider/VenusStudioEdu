#!/usr/bin/env python3
"""
Redis Basics Practice Exercises
"""

import redis

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
    
    print("\nStarting Redis Basics Practice Exercises...\n")
    
    # Exercise 1: String Operations
    print("--- Exercise 1: String Operations ---")
    # Set a key-value pair
    r.set('practice_greeting', 'Hello, Redis Learner!')
    # Get the value
    greeting = r.get('practice_greeting')
    print(f"1. Retrieved greeting: {greeting}")
    
    # Increment a counter
    r.set('practice_counter', 5)
    r.incr('practice_counter')
    counter_value = r.get('practice_counter')
    print(f"2. Incremented counter value: {counter_value}")
    
    # Exercise 2: List Operations
    print("\n--- Exercise 2: List Operations ---")
    # Create a list with some items
    r.lpush('practice_tasks', 'task1', 'task2')
    r.rpush('practice_tasks', 'task3')
    # Get all items from the list
    tasks = r.lrange('practice_tasks', 0, -1)
    print(f"1. All tasks: {tasks}")
    # Remove and get the first item
    first_task = r.lpop('practice_tasks')
    print(f"2. First task removed: {first_task}")
    
    # Exercise 3: Hash Operations
    print("\n--- Exercise 3: Hash Operations ---")
    # Create a hash with user information
    r.hset('practice_user:1', mapping={
        'name': 'John Doe',
        'email': 'john@example.com',
        'age': 25
    })
    # Get a specific field
    user_name = r.hget('practice_user:1', 'name')
    print(f"1. User name: {user_name}")
    # Get all fields
    user_info = r.hgetall('practice_user:1')
    print(f"2. User info: {user_info}")
    
    # Exercise 4: Set Operations
    print("\n--- Exercise 4: Set Operations ---")
    # Create two sets
    r.sadd('practice_set1', 'a', 'b', 'c')
    r.sadd('practice_set2', 'b', 'c', 'd')
    # Get all members of a set
    set1_members = r.smembers('practice_set1')
    print(f"1. Set1 members: {set1_members}")
    # Find intersection of two sets
    intersection = r.sinter('practice_set1', 'practice_set2')
    print(f"2. Intersection of sets: {intersection}")
    
    # Exercise 5: Sorted Set Operations
    print("\n--- Exercise 5: Sorted Set Operations ---")
    # Create a sorted set with scores
    r.zadd('practice_leaderboard', {'player1': 100, 'player2': 200, 'player3': 150})
    # Get all members with scores
    leaderboard = r.zrange('practice_leaderboard', 0, -1, withscores=True)
    print(f"1. Leaderboard: {leaderboard}")
    # Get the member with the highest score
    top_player = r.zrevrange('practice_leaderboard', 0, 0, withscores=True)
    print(f"2. Top player: {top_player}")
    
    # Exercise 6: Key Operations
    print("\n--- Exercise 6: Key Operations ---")
    # Check if a key exists
    r.set('practice_check_key', 'exists')
    key_exists = r.exists('practice_check_key')
    print(f"1. Key 'practice_check_key' exists: {bool(key_exists)}")
    # Delete a key
    r.delete('practice_check_key')
    key_exists_after = r.exists('practice_check_key')
    print(f"2. Key 'practice_check_key' exists after deletion: {bool(key_exists_after)}")
    
    # Exercise 7: Advanced Operations
    print("\n--- Exercise 7: Advanced Operations ---")
    # Use a pipeline to execute multiple commands
    pipe = r.pipeline()
    pipe.set('pipeline_key1', 'value1')
    pipe.set('pipeline_key2', 'value2')
    pipe.incr('practice_counter')
    pipe_results = pipe.execute()
    print(f"1. Pipeline execution results: {pipe_results}")
    
    # Exercise 8: Pattern Matching
    print("\n--- Exercise 8: Pattern Matching ---")
    # Set multiple keys with a pattern
    r.set('pattern:user:1', 'user1_data')
    r.set('pattern:user:2', 'user2_data')
    r.set('pattern:admin:1', 'admin1_data')
    # Find keys matching a pattern
    user_keys = r.keys('pattern:user:*')
    print(f"1. Keys matching 'pattern:user:*': {user_keys}")
    
    print("\nPractice exercises completed!")
    print("Bonus Exercise: Try creating your own Redis operations using the patterns above.")

if __name__ == "__main__":
    main()