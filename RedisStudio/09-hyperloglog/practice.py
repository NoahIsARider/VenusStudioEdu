#!/usr/bin/env python3
"""
Redis HyperLogLog Practice Exercises
Complete the following exercises to practice HyperLogLog operations in Redis.
"""

import redis
import random
import string
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
    
    print("\nStarting Redis HyperLogLog Practice Exercises...\n")
    
    # Exercise 1: Website Traffic Analytics
    print("--- Exercise 1: Website Traffic Analytics ---")
    # Implement website traffic analytics using Redis HyperLogLog
    # Requirements:
    # 1. Track unique visitors per day
    # 2. Calculate weekly/monthly unique visitors
    # 3. Track unique page views
    # 4. Merge statistics across time periods
    
    # Your implementation here:
    # 1. Create HyperLogLogs for daily visitors
    # 2. Merge daily logs for weekly/monthly stats
    # 3. Track unique page views separately
    # 4. Calculate and display various metrics
    
    print("Exercise 1 completed. Check the implementation.")
    
    # Exercise 2: Social Media Platform Metrics
    print("\n--- Exercise 2: Social Media Platform Metrics ---")
    # Implement social media metrics tracking using Redis HyperLogLog
    # Requirements:
    # 1. Track unique users who posted content
    # 2. Track unique users who commented
    # 3. Track unique users who liked content
    # 4. Calculate engagement metrics
    
    # Your implementation here:
    # 1. Create separate HyperLogLogs for different activities
    # 2. Track unique users for each action type
    # 3. Merge related metrics for combined insights
    # 4. Calculate engagement ratios
    
    print("Exercise 2 completed. Check the implementation.")
    
    # Exercise 3: E-commerce Customer Analytics
    print("\n--- Exercise 3: E-commerce Customer Analytics ---")
    # Implement e-commerce analytics using Redis HyperLogLog
    # Requirements:
    # 1. Track unique customers who visited the site
    # 2. Track unique customers who added items to cart
    # 3. Track unique customers who made purchases
    # 4. Calculate conversion funnel metrics
    
    # Your implementation here:
    # 1. Create HyperLogLogs for each stage of the funnel
    # 2. Track unique customers at each step
    # 3. Calculate conversion rates between stages
    # 4. Identify drop-off points in the funnel
    
    print("Exercise 3 completed. Check the implementation.")
    
    # Exercise 4: Application Performance Monitoring
    print("\n--- Exercise 4: Application Performance Monitoring ---")
    # Implement APM using Redis HyperLogLog
    # Requirements:
    # 1. Track unique API endpoints called
    # 2. Track unique users experiencing errors
    # 3. Track unique sessions with performance issues
    # 4. Monitor system health metrics
    
    # Your implementation here:
    # 1. Create HyperLogLogs for different monitoring aspects
    # 2. Track unique endpoints, error-affected users, slow sessions
    # 3. Calculate error rates and performance degradation
    # 4. Set up alerts based on threshold breaches
    
    print("Exercise 4 completed. Check the implementation.")
    
    # Exercise 5: IoT Device Network Monitoring
    print("\n--- Exercise 5: IoT Device Network Monitoring ---")
    # Implement IoT network monitoring using Redis HyperLogLog
    # Requirements:
    # 1. Track unique devices connected to network
    # 2. Track unique devices sending data
    # 3. Track unique devices with errors
    # 4. Monitor device population changes
    
    # Your implementation here:
    # 1. Create HyperLogLogs for device connectivity metrics
    # 2. Track active devices and data transmission
    # 3. Monitor error rates across device population
    # 4. Analyze device network growth trends
    
    print("Exercise 5 completed. Check the implementation.")
    
    # Exercise 6: Content Delivery Network Analytics
    print("\n--- Exercise 6: Content Delivery Network Analytics ---")
    # Implement CDN analytics using Redis HyperLogLog
    # Requirements:
    # 1. Track unique edge nodes serving content
    # 2. Track unique clients requesting content
    # 3. Track unique content items served
    # 4. Analyze CDN efficiency metrics
    
    # Your implementation here:
    # 1. Create HyperLogLogs for CDN components
    # 2. Track unique nodes, clients, and content
    # 3. Calculate cache hit ratios and distribution efficiency
    # 4. Optimize content placement strategies
    
    print("Exercise 6 completed. Check the implementation.")
    
    # Exercise 7: Gaming Platform Statistics
    print("\n--- Exercise 7: Gaming Platform Statistics ---")
    # Implement gaming analytics using Redis HyperLogLog
    # Requirements:
    # 1. Track unique players online
    # 2. Track unique players completing levels
    # 3. Track unique players making in-game purchases
    # 4. Analyze player engagement metrics
    
    # Your implementation here:
    # 1. Create HyperLogLogs for different player activities
    # 2. Track unique players in various game contexts
    # 3. Calculate retention and monetization metrics
    # 4. Identify popular game features
    
    print("Exercise 7 completed. Check the implementation.")
    
    # Exercise 8: Email Marketing Analytics
    print("\n--- Exercise 8: Email Marketing Analytics ---")
    # Implement email marketing analytics using Redis HyperLogLog
    # Requirements:
    # 1. Track unique recipients of emails
    # 2. Track unique opens and clicks
    # 3. Track unique conversions from emails
    # 4. Calculate email campaign effectiveness
    
    # Your implementation here:
    # 1. Create HyperLogLogs for email campaign metrics
    # 2. Track unique recipients, opens, clicks, conversions
    # 3. Calculate open rates, click-through rates, conversion rates
    # 4. Optimize future campaigns based on insights
    
    print("Exercise 8 completed. Check the implementation.")
    
    print("\nPractice exercises completed!")
    print("\nBonus Exercise:")
    print("Design and implement a Redis-based real-time fraud detection system with the following features:")
    print("- Track unique suspicious activities and patterns")
    print("- Implement anomaly detection with sub-second latency")
    print("- Handle false positive reduction through machine learning")
    print("- Provide real-time alerts and automated response mechanisms")
    print("- Ensure compliance with privacy regulations and data protection")

if __name__ == "__main__":
    main()