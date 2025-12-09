#!/usr/bin/env python3
"""
Redis Sets Example
This script demonstrates various set operations in Redis.
"""

import redis
import time
import random

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
    
    print("\n=== Redis Sets Examples ===\n")
    
    # Clear any existing data
    r.delete('fruits', 'vegetables', 'colors', 'animals', 'tags:post:1', 'tags:post:2', 'online_users')
    
    # 1. Basic Set Operations (SADD, SMEMBERS, SISMEMBER)
    print("1. Basic Set Operations")
    
    # SADD - Add members to set
    r.sadd('fruits', 'apple', 'banana', 'orange', 'grape')
    print(f"Fruits set: {r.smembers('fruits')}")
    
    # SMEMBERS - Get all members
    fruits = r.smembers('fruits')
    print(f"All fruits: {fruits}")
    
    # SISMEMBER - Check if member exists
    is_apple = r.sismember('fruits', 'apple')
    is_mango = r.sismember('fruits', 'mango')
    print(f"Is 'apple' in fruits? {is_apple}")
    print(f"Is 'mango' in fruits? {is_mango}")
    
    print("\n" + "-"*50 + "\n")
    
    # 2. Set Cardinality and Removal (SCARD, SREM)
    print("2. Set Cardinality and Removal")
    
    # SCARD - Get set size
    fruit_count = r.scard('fruits')
    print(f"Number of fruits: {fruit_count}")
    
    # SREM - Remove members
    r.srem('fruits', 'grape')
    print(f"Fruits after removing grape: {r.smembers('fruits')}")
    
    # SPOP - Remove and return random member
    popped_fruit = r.spop('fruits')
    print(f"Popped fruit: {popped_fruit}")
    print(f"Fruits after pop: {r.smembers('fruits')}")
    
    print("\n" + "-"*50 + "\n")
    
    # 3. Set Membership Operations (SMOVE)
    print("3. Set Membership Operations")
    
    # Recreate sets for demonstration
    r.sadd('fruits', 'apple', 'banana', 'orange')
    r.sadd('vegetables', 'carrot', 'broccoli', 'spinach')
    
    # SMOVE - Move member from one set to another
    moved = r.smove('fruits', 'vegetables', 'apple')
    print(f"Moved apple from fruits to vegetables: {moved}")
    print(f"Fruits: {r.smembers('fruits')}")
    print(f"Vegetables: {r.smembers('vegetables')}")
    
    print("\n" + "-"*50 + "\n")
    
    # 4. Set Comparison Operations (SDIFF, SINTER, SUNION)
    print("4. Set Comparison Operations")
    
    # Create sets for comparison
    r.sadd('colors', 'red', 'blue', 'green', 'yellow')
    r.sadd('animals', 'red', 'blue', 'cat', 'dog')
    
    # SDIFF - Difference between sets
    color_only = r.sdiff('colors', 'animals')
    print(f"Colors not in animals: {color_only}")
    
    # SINTER - Intersection of sets
    common_items = r.sinter('colors', 'animals')
    print(f"Common items in colors and animals: {common_items}")
    
    # SUNION - Union of sets
    all_items = r.sunion('colors', 'animals')
    print(f"All items in both sets: {all_items}")
    
    print("\n" + "-"*50 + "\n")
    
    # 5. Store Set Operations (SDIFFSTORE, SINTERSTORE, SUNIONSTORE)
    print("5. Store Set Operations")
    
    # SDIFFSTORE - Store difference in new set
    r.sdiffstore('color_only_stored', 'colors', 'animals')
    print(f"Stored color-only items: {r.smembers('color_only_stored')}")
    
    # SINTERSTORE - Store intersection in new set
    r.sinterstore('common_stored', 'colors', 'animals')
    print(f"Stored common items: {r.smembers('common_stored')}")
    
    # SUNIONSTORE - Store union in new set
    r.sunionstore('all_stored', 'colors', 'animals')
    print(f"Stored all items: {r.smembers('all_stored')}")
    
    print("\n" + "-"*50 + "\n")
    
    # 6. Random Member Operations (SRANDMEMBER)
    print("6. Random Member Operations")
    
    # SRANDMEMBER - Get random member(s) without removing
    random_fruit = r.srandmember('fruits')
    print(f"Random fruit: {random_fruit}")
    
    # Get multiple random members
    random_fruits = r.srandmember('fruits', 2)
    print(f"Two random fruits: {random_fruits}")
    
    # Get random members with possible duplicates
    random_fruits_dup = r.srandmember('fruits', -3)
    print(f"Three random fruits (with duplicates): {random_fruits_dup}")
    
    print("\n" + "-"*50 + "\n")
    
    # 7. Advanced Set Operations (SSCAN)
    print("7. Advanced Set Operations")
    
    # SSCAN - Incrementally iterate through set
    print("Iterating through fruits with SSCAN:")
    cursor = 0
    while True:
        cursor, members = r.sscan('fruits', cursor)
        for member in members:
            print(f"  Found: {member}")
        if cursor == 0:
            break
    
    print("\n" + "-"*50 + "\n")
    
    # 8. Practical Example: Tagging System
    print("8. Practical Example: Tagging System")
    
    # Simulate tagging blog posts
    post1_tags = ['python', 'redis', 'database', 'tutorial']
    post2_tags = ['redis', 'nosql', 'performance', 'tutorial']
    
    # Add tags to posts
    r.sadd('tags:post:1', *post1_tags)
    r.sadd('tags:post:2', *post2_tags)
    
    print(f"Tags for post 1: {r.smembers('tags:post:1')}")
    print(f"Tags for post 2: {r.smembers('tags:post:2')}")
    
    # Find posts with specific tag
    posts_with_redis = r.sinter('tags:post:1', 'tags:post:2')
    print(f"Posts tagged with both post1 and post2 tags: {posts_with_redis}")
    
    # Find all unique tags
    all_tags = r.sunion('tags:post:1', 'tags:post:2')
    print(f"All unique tags: {all_tags}")
    
    # Find tags unique to post 1
    unique_to_post1 = r.sdiff('tags:post:1', 'tags:post:2')
    print(f"Tags unique to post 1: {unique_to_post1}")
    
    print("\n" + "-"*50 + "\n")
    
    # 9. Practical Example: Online User Tracking
    print("9. Practical Example: Online User Tracking")
    
    # Simulate users coming online
    users = ['alice', 'bob', 'charlie', 'diana', 'eve']
    for user in users:
        r.sadd('online_users', user)
        print(f"{user} is now online")
    
    print(f"Currently online users: {r.smembers('online_users')}")
    print(f"Number of online users: {r.scard('online_users')}")
    
    # Simulate user going offline
    r.srem('online_users', 'bob')
    print(f"After Bob goes offline: {r.smembers('online_users')}")
    
    # Check if specific user is online
    is_alice_online = r.sismember('online_users', 'alice')
    print(f"Is Alice online? {is_alice_online}")
    
    # Simulate user session timeout (clear set periodically in real apps)
    # For demo, we'll just show how to clear
    # r.delete('online_users')
    
    print("\n=== End of Redis Sets Examples ===")

if __name__ == "__main__":
    main()