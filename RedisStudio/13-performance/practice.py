#!/usr/bin/env python3
"""
Redis Performance Optimization Practice Exercises

This script contains hands-on exercises for optimizing Redis performance.
Each exercise focuses on a different aspect of performance tuning.
"""

import redis
import time
import threading
import json
from concurrent.futures import ThreadPoolExecutor


def test_redis_connection():
    """Test Redis connection"""
    try:
        r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)
        r.ping()
        print("✓ Connected to Redis successfully")
        return r
    except Exception as e:
        print(f"✗ Failed to connect to Redis: {e}")
        return None


# Exercise 1: Connection Pool Optimization
# Task: Implement an optimized connection pool with appropriate settings
# Requirements:
# 1. Create a connection pool with custom settings
# 2. Implement a function that uses the pool efficiently
# 3. Compare performance with default connections

def exercise_1_connection_pool():
    """Exercise 1: Connection Pool Optimization"""
    print("\n=== Exercise 1: Connection Pool Optimization ===")
    
    # Your implementation here:
    # 1. Create a connection pool with appropriate settings
    # 2. Implement a function that performs multiple Redis operations using the pool
    # 3. Compare performance with default connections
    
    pass  # Replace with your implementation


# Exercise 2: Pipeline Implementation
# Task: Implement efficient batch operations using pipelines
# Requirements:
# 1. Create a function that sets multiple keys using a pipeline
# 2. Create a function that gets multiple keys using a pipeline
# 3. Measure and compare performance with non-pipeline approaches

def exercise_2_pipeline_operations():
    """Exercise 2: Pipeline Implementation"""
    print("\n=== Exercise 2: Pipeline Implementation ===")
    
    # Your implementation here:
    # 1. Create a function that sets 1000 keys using a pipeline
    # 2. Create a function that gets 1000 keys using a pipeline
    # 3. Compare performance with individual operations
    
    pass  # Replace with your implementation


# Exercise 3: Efficient Data Structure Selection
# Task: Optimize storage for user session data
# Requirements:
# 1. Store user session data efficiently (user_id, session_token, last_activity, permissions)
# 2. Implement functions to read/write session data
# 3. Compare memory usage between different approaches (hashes vs strings)

def exercise_3_efficient_storage():
    """Exercise 3: Efficient Data Structure Selection"""
    print("\n=== Exercise 3: Efficient Data Structure Selection ===")
    
    # Your implementation here:
    # 1. Implement two approaches for storing user session data:
    #    a. Using separate string keys
    #    b. Using hash structures
    # 2. Compare memory usage and performance
    
    pass  # Replace with your implementation


# Exercise 4: Caching Strategy Implementation
# Task: Implement a multi-level caching strategy
# Requirements:
# 1. Create L1 cache (in-memory) and L2 cache (Redis)
# 2. Implement cache-aside pattern
# 3. Handle cache misses and updates appropriately

class CacheManager:
    """Exercise 4: Multi-level Cache Manager"""
    def __init__(self, redis_client):
        self.redis = redis_client
        self.l1_cache = {}  # Simple in-memory cache
        
    # Your implementation here:
    # 1. Implement get/set methods with L1 and L2 cache
    # 2. Handle cache invalidation
    # 3. Implement cache warming strategies
    
    def get(self, key):
        # Your implementation
        pass
    
    def set(self, key, value, ttl=300):
        # Your implementation
        pass
    
    def invalidate(self, key):
        # Your implementation
        pass


# Exercise 5: Batch Operations Optimization
# Task: Optimize bulk data processing
# Requirements:
# 1. Process 10,000 user records efficiently
# 2. Use appropriate batching techniques
# 3. Minimize network round trips

def exercise_5_batch_processing(redis_client):
    """Exercise 5: Batch Operations Optimization"""
    print("\n=== Exercise 5: Batch Operations Optimization ===")
    
    # Sample data
    user_data = [
        {"id": i, "name": f"User {i}", "email": f"user{i}@example.com"}
        for i in range(10000)
    ]
    
    # Your implementation here:
    # 1. Implement an efficient function to store all user data
    # 2. Use batching to minimize network round trips
    # 3. Compare performance with naive approach
    
    pass  # Replace with your implementation


# Exercise 6: Concurrency and Thread Safety
# Task: Implement thread-safe Redis operations
# Requirements:
# 1. Create multiple threads performing Redis operations
# 2. Ensure thread safety
# 3. Measure throughput and identify bottlenecks

def exercise_6_concurrent_operations(redis_client):
    """Exercise 6: Concurrency and Thread Safety"""
    print("\n=== Exercise 6: Concurrency and Thread Safety ===")
    
    # Your implementation here:
    # 1. Create a function that performs Redis operations
    # 2. Run multiple instances concurrently using threads
    # 3. Measure throughput and identify potential issues
    
    pass  # Replace with your implementation


# Exercise 7: Memory Optimization
# Task: Optimize memory usage for time-series data
# Requirements:
# 1. Store time-series metrics efficiently
# 2. Implement data expiration/cleanup strategies
# 3. Monitor memory usage

def exercise_7_memory_optimization(redis_client):
    """Exercise 7: Memory Optimization"""
    print("\n=== Exercise 7: Memory Optimization ===")
    
    # Your implementation here:
    # 1. Implement efficient storage for time-series data
    # 2. Use appropriate data structures (sorted sets, streams)
    # 3. Implement automatic cleanup of old data
    
    pass  # Replace with your implementation


# Exercise 8: Serialization Performance
# Task: Optimize data serialization for Redis storage
# Requirements:
# 1. Compare different serialization methods (JSON, pickle, msgpack)
# 2. Measure storage size and performance
# 3. Recommend optimal approach for different data types

def exercise_8_serialization_comparison(redis_client):
    """Exercise 8: Serialization Performance"""
    print("\n=== Exercise 8: Serialization Performance ===")
    
    # Sample complex data structure
    complex_data = {
        "user_id": 12345,
        "profile": {
            "name": "John Doe",
            "preferences": {
                "theme": "dark",
                "notifications": ["email", "sms"],
                "privacy": {"public_profile": True, "searchable": False}
            },
            "friends": [123, 456, 789],
            "achievements": [{"name": "First Login", "date": "2023-01-01"}]
        }
    }
    
    # Your implementation here:
    # 1. Implement different serialization methods
    # 2. Compare storage size and performance
    # 3. Analyze results and recommend optimal approaches
    
    pass  # Replace with your implementation


# Exercise 9: Query Optimization
# Task: Optimize complex Redis queries
# Requirements:
# 1. Implement efficient search/filter operations
# 2. Use appropriate indexing strategies
# 3. Minimize data scanning

def exercise_9_query_optimization(redis_client):
    """Exercise 9: Query Optimization"""
    print("\n=== Exercise 9: Query Optimization ===")
    
    # Your implementation here:
    # 1. Create sample data with searchable attributes
    # 2. Implement efficient filtering/searching mechanisms
    # 3. Use secondary indexing where appropriate
    
    pass  # Replace with your implementation


# Exercise 10: Monitoring and Profiling
# Task: Implement performance monitoring
# Requirements:
# 1. Track operation latency
# 2. Monitor resource usage
# 3. Identify performance bottlenecks

def exercise_10_monitoring(redis_client):
    """Exercise 10: Monitoring and Profiling"""
    print("\n=== Exercise 10: Monitoring and Profiling ===")
    
    # Your implementation here:
    # 1. Implement timing decorators or context managers
    # 2. Track key performance metrics
    # 3. Create performance reports
    
    pass  # Replace with your implementation


# Bonus Exercise: Real-world Performance Scenario
# Task: Optimize a social media feed system
# Requirements:
# 1. Design efficient data models for posts, likes, comments
# 2. Implement pagination for feeds
# 3. Optimize for read-heavy workload
# 4. Handle viral content scenarios

def bonus_exercise_social_media_feed(redis_client):
    """Bonus Exercise: Social Media Feed System"""
    print("\n=== Bonus Exercise: Social Media Feed System ===")
    
    # Your implementation here:
    # 1. Design data models for a social media platform
    # 2. Implement efficient feed generation
    # 3. Optimize for common operations (post creation, fetching feeds)
    # 4. Handle scalability challenges
    
    pass  # Replace with your implementation


def main():
    """Main function to run practice exercises"""
    print("Redis Performance Optimization Practice Exercises")
    print("==============================================")
    
    # Test Redis connection
    r = test_redis_connection()
    if not r:
        return
    
    # Clear database for clean testing
    r.flushdb()
    
    # Run exercises
    exercise_1_connection_pool()
    exercise_2_pipeline_operations()
    exercise_3_efficient_storage()
    
    # Initialize cache manager
    cache_manager = CacheManager(r)
    # Test cache manager functionality
    
    exercise_5_batch_processing(r)
    exercise_6_concurrent_operations(r)
    exercise_7_memory_optimization(r)
    exercise_8_serialization_comparison(r)
    exercise_9_query_optimization(r)
    exercise_10_monitoring(r)
    bonus_exercise_social_media_feed(r)
    
    print("\n=== Practice Complete ===")
    print("Remember to:")
    print("1. Test your implementations with realistic data volumes")
    print("2. Measure performance improvements")
    print("3. Consider trade-offs between different optimization techniques")
    print("4. Profile your code to identify actual bottlenecks")


if __name__ == "__main__":
    main()