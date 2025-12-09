#!/usr/bin/env python3
"""
Redis Sorted Sets Practice Exercises
Complete the following exercises to practice sorted set operations in Redis.
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
    
    print("\nStarting Redis Sorted Sets Practice Exercises...\n")
    
    # Exercise 1: Game Leaderboard System
    print("--- Exercise 1: Game Leaderboard System ---")
    # Implement a game leaderboard using Redis sorted sets
    # Requirements:
    # 1. Track player scores
    # 2. Update scores dynamically
    # 3. Retrieve top players
    # 4. Get player rankings
    
    # Your implementation here:
    # 1. Create leaderboard sorted set
    # 2. Add/update player scores
    # 3. Retrieve top 10 players
    # 4. Get specific player's rank
    
    print("Exercise 1 completed. Check the implementation.")
    
    # Exercise 2: Real-time Analytics Dashboard
    print("\n--- Exercise 2: Real-time Analytics Dashboard ---")
    # Implement analytics tracking using Redis sorted sets
    # Requirements:
    # 1. Track page views with timestamps
    # 2. Calculate trending pages
    # 3. Get recent activity
    # 4. Expire old data
    
    # Your implementation here:
    # 1. Track page views with scores as timestamps
    # 2. Identify trending pages (most views in last hour)
    # 3. Retrieve recent page views
    # 4. Remove data older than 24 hours
    
    print("Exercise 2 completed. Check the implementation.")
    
    # Exercise 3: Priority Task Queue
    print("\n--- Exercise 3: Priority Task Queue ---")
    # Implement a priority queue using Redis sorted sets
    # Requirements:
    # 1. Add tasks with priorities
    # 2. Process highest priority tasks first
    # 3. Update task priorities
    # 4. Handle task completion
    
    # Your implementation here:
    # 1. Add tasks with priority scores
    # 2. Process tasks in priority order
    # 3. Modify task priorities
    # 4. Remove completed tasks
    
    print("Exercise 3 completed. Check the implementation.")
    
    # Exercise 4: Geo-location Based Recommendations
    print("\n--- Exercise 4: Geo-location Based Recommendations ---")
    # Implement location-based recommendations using Redis sorted sets
    # Requirements:
    # 1. Store locations with coordinates
    # 2. Find nearby locations
    # 3. Rank locations by proximity
    # 4. Filter by categories
    
    # Note: This exercise would typically use Redis GEO commands, but we'll simulate with sorted sets
    # Your implementation here:
    # 1. Store locations with distance scores
    # 2. Find locations within radius
    # 3. Rank by proximity
    # 4. Apply category filters
    
    print("Exercise 4 completed. Check the implementation.")
    
    # Exercise 5: Content Recommendation Engine
    print("\n--- Exercise 5: Content Recommendation Engine ---")
    # Implement a recommendation engine using Redis sorted sets
    # Requirements:
    # 1. Track user-content interactions
    # 2. Calculate content popularity
    # 3. Generate personalized recommendations
    # 4. Update recommendations in real-time
    
    # Your implementation here:
    # 1. Track user interactions with scores as timestamps
    # 2. Calculate trending content
    # 3. Generate recommendations for users
    # 4. Update based on new interactions
    
    print("Exercise 5 completed. Check the implementation.")
    
    # Exercise 6: Time-series Data Aggregation
    print("\n--- Exercise 6: Time-series Data Aggregation ---")
    # Implement time-series data processing using Redis sorted sets
    # Requirements:
    # 1. Store timestamped metrics
    # 2. Aggregate data by time windows
    # 3. Calculate moving averages
    # 4. Expire old data
    
    # Your implementation here:
    # 1. Store metrics with timestamps as scores
    # 2. Aggregate data for different time windows
    # 3. Calculate moving averages
    # 4. Remove expired data periodically
    
    print("Exercise 6 completed. Check the implementation.")
    
    # Exercise 7: Social Media Feed Ranking
    print("\n--- Exercise 7: Social Media Feed Ranking ---")
    # Implement social media feed ranking using Redis sorted sets
    # Requirements:
    # 1. Rank posts by engagement score
    # 2. Personalize feeds for users
    # 3. Update rankings in real-time
    # 4. Handle post expiration
    
    # Your implementation here:
    # 1. Store posts with engagement scores
    # 2. Personalize feeds based on user preferences
    # 3. Update rankings when new engagements occur
    # 4. Remove old posts from feeds
    
    print("Exercise 7 completed. Check the implementation.")
    
    # Exercise 8: Cache with TTL and Priority
    print("\n--- Exercise 8: Cache with TTL and Priority ---")
    # Implement a cache system with TTL and priority using Redis sorted sets
    # Requirements:
    # 1. Store cached items with priorities
    # 2. Expire items based on TTL
    # 3. Evict low priority items when cache is full
    # 4. Update item priorities
    
    # Your implementation here:
    # 1. Store cache items with priority scores
    # 2. Implement TTL-based expiration
    # 3. Evict items based on priority when needed
    # 4. Allow priority updates
    
    print("Exercise 8 completed. Check the implementation.")
    
    print("\nPractice exercises completed!")
    print("\nBonus Exercise:")
    print("Design and implement a Redis-based real-time bidding system for an advertising platform with the following features:")
    print("- Track advertiser budgets and bids in real-time")
    print("- Implement auction algorithms with sub-millisecond latency")
    print("- Handle bid adjustments and campaign optimizations")
    print("- Provide analytics on bidding patterns and performance")
    print("- Ensure consistency and prevent overspending")

if __name__ == "__main__":
    main()