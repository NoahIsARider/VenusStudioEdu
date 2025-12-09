#!/usr/bin/env python3
"""
Redis Hashes Practice Exercises
Complete the following exercises to practice hash operations in Redis.
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
    
    print("\nStarting Redis Hashes Practice Exercises...\n")
    
    # Exercise 1: User Profile Management
    print("--- Exercise 1: User Profile Management ---")
    # Implement user profile management using Redis hashes
    # Requirements:
    # 1. Store user profile information (name, email, age, location, preferences)
    # 2. Update specific profile fields
    # 3. Retrieve partial profile information
    # 4. Check if user has specific preferences
    
    # Your implementation here:
    # 1. Create user profile hash
    # 2. Update user's email and location
    # 3. Retrieve only name and email
    # 4. Check if user has "newsletter" preference
    
    print("Exercise 1 completed. Check the implementation.")
    
    # Exercise 2: Product Catalog
    print("\n--- Exercise 2: Product Catalog ---")
    # Implement a product catalog using Redis hashes
    # Requirements:
    # 1. Store product information (name, price, category, stock, ratings)
    # 2. Update stock levels when products are sold
    # 3. Add ratings to products
    # 4. Retrieve products by category
    
    # Your implementation here:
    # 1. Create product hashes
    # 2. Implement stock reduction when items are sold
    # 3. Add customer ratings
    # 4. Find all products in a specific category
    
    print("Exercise 2 completed. Check the implementation.")
    
    # Exercise 3: Real-time Analytics Dashboard
    print("\n--- Exercise 3: Real-time Analytics Dashboard ---")
    # Implement analytics tracking using Redis hashes
    # Requirements:
    # 1. Track page views, unique visitors, and conversion rates
    # 2. Update metrics in real-time
    # 3. Calculate derived metrics (conversion rate)
    # 4. Reset daily metrics at midnight
    
    # Your implementation here:
    # 1. Create analytics hashes for different pages
    # 2. Update page views and visitor counts
    # 3. Calculate and store conversion rates
    # 4. Implement daily reset functionality
    
    print("Exercise 3 completed. Check the implementation.")
    
    # Exercise 4: Configuration Management
    print("\n--- Exercise 4: Configuration Management ---")
    # Implement application configuration using Redis hashes
    # Requirements:
    # 1. Store configuration settings with different data types
    # 2. Update configuration values dynamically
    # 3. Validate configuration changes
    # 4. Handle feature flags
    
    # Your implementation here:
    # 1. Create configuration hashes
    # 2. Implement dynamic configuration updates
    # 3. Validate numeric configuration values
    # 4. Manage feature flags
    
    print("Exercise 4 completed. Check the implementation.")
    
    # Exercise 5: Game State Management
    print("\n--- Exercise 5: Game State Management ---")
    # Implement game state using Redis hashes
    # Requirements:
    # 1. Store player state (level, score, inventory, position)
    # 2. Update player progress
    # 3. Manage player inventory
    # 4. Handle player sessions
    
    # Your implementation here:
    # 1. Create player state hashes
    # 2. Implement level progression
    # 3. Add/remove items from inventory
    # 4. Manage player sessions with expiration
    
    print("Exercise 5 completed. Check the implementation.")
    
    # Exercise 6: Cache with Metadata
    print("\n--- Exercise 6: Cache with Metadata ---")
    # Implement a caching system with metadata using Redis hashes
    # Requirements:
    # 1. Store cached data with creation timestamp and access count
    # 2. Update access count on cache hits
    # 3. Implement cache eviction based on access count
    # 4. Add TTL to cache entries
    
    # Your implementation here:
    # 1. Create cache entry hashes
    # 2. Update access metadata on retrieval
    # 3. Implement LRU-like eviction
    # 4. Set expiration for cache entries
    
    print("Exercise 6 completed. Check the implementation.")
    
    # Exercise 7: Voting System
    print("\n--- Exercise 7: Voting System ---")
    # Implement a voting system using Redis hashes
    # Requirements:
    # 1. Store poll options with vote counts
    # 2. Record user votes
    # 3. Prevent duplicate voting
    # 4. Calculate vote percentages
    
    # Your implementation here:
    # 1. Create poll hashes
    # 2. Implement voting mechanism
    # 3. Prevent duplicate votes
    # 4. Calculate and display results
    
    print("Exercise 7 completed. Check the implementation.")
    
    # Exercise 8: Session Storage with Complex Data
    print("\n--- Exercise 8: Session Storage with Complex Data ---")
    # Implement session storage for complex user data using Redis hashes
    # Requirements:
    # 1. Store user session with nested data (shopping cart, preferences)
    # 2. Update session data efficiently
    # 3. Handle session expiration
    # 4. Serialize/deserialize complex data structures
    
    # Your implementation here:
    # 1. Create session hashes with complex data
    # 2. Update nested session data
    # 3. Implement session timeout
    # 4. Handle JSON serialization for complex values
    
    print("Exercise 8 completed. Check the implementation.")
    
    print("\nPractice exercises completed!")
    print("\nBonus Exercise:")
    print("Design and implement a Redis-based recommendation system with the following features:")
    print("- User preference profiling using hashes")
    print("- Item similarity calculations")
    print("- Real-time recommendation updates")
    print("- Personalized content delivery")
    print("- Performance optimized lookups")

if __name__ == "__main__":
    main()