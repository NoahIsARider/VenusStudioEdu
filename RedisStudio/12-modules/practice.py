"""
Redis Modules Practice Exercises
This file contains 10 practical exercises for learning Redis modules in Python
"""

import redis
import json
import time
from datetime import datetime, timedelta

# Connect to Redis
r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)

# Flush DB for clean state (uncomment when needed)
# r.flushdb()

print("="*60)
print("Redis Modules Practice Exercises")
print("="*60)

# Exercise 1: E-commerce Product Catalog
# Create a product catalog system using RedisJSON and RediSearch
# Requirements:
# 1. Store product information as JSON documents
# 2. Index products for full-text search
# 3. Support faceted search by category, price range, brand
# 4. Implement product recommendations based on search history

print("\nExercise 1: E-commerce Product Catalog")
print("-"*40)

# Your solution here:

# Exercise 2: IoT Data Analytics Platform
# Build a system for processing and analyzing IoT sensor data
# Requirements:
# 1. Store time series data from multiple sensors
# 2. Create real-time dashboards with aggregated metrics
# 3. Detect anomalies in sensor readings
# 4. Generate automated alerts for critical conditions
# 5. Retain data with configurable retention policies

print("\nExercise 2: IoT Data Analytics Platform")
print("-"*40)

# Your solution here:

# Exercise 3: Social Media Content Engine
# Create a content engine for a social media platform
# Requirements:
# 1. Store user profiles and posts as JSON documents
# 2. Implement content search with RediSearch
# 3. Use Bloom filters to track user interactions
# 4. Create trending topics with Top-K
# 5. Model user relationships with RedisGraph

print("\nExercise 3: Social Media Content Engine")
print("-"*40)

# Your solution here:

# Exercise 4: Real-time Fraud Detection System
# Build a fraud detection system for financial transactions
# Requirements:
# 1. Store transaction data with timestamps
# 2. Use Cuckoo filters to track suspicious patterns
# 3. Implement real-time risk scoring
# 4. Create alerts for high-risk transactions
# 5. Maintain blacklists and whitelists

print("\nExercise 4: Real-time Fraud Detection System")
print("-"*40)

# Your solution here:

# Exercise 5: Content Management System
# Create a CMS with advanced search and caching capabilities
# Requirements:
# 1. Store articles and pages as JSON documents
# 2. Implement full-text search with highlighting
# 3. Use RedisAI for content categorization
# 4. Cache rendered pages with TTL
# 5. Track content popularity with counters

print("\nExercise 5: Content Management System")
print("-"*40)

# Your solution here:

# Exercise 6: Gaming Leaderboard System
# Build a real-time gaming leaderboard with multiple features
# Requirements:
# 1. Store player scores and rankings
# 2. Implement time-based leaderboards (daily, weekly, monthly)
# 3. Use Bloom filters to track unique players
# 4. Generate player statistics and achievements
# 5. Support real-time score updates

print("\nExercise 6: Gaming Leaderboard System")
print("-"*40)

# Your solution here:

# Exercise 7: Smart Cache Layer
# Create an intelligent caching system with multiple strategies
# Requirements:
# 1. Implement LRU and LFU caching algorithms
# 2. Use Bloom filters to optimize cache lookups
# 3. Track cache hit/miss ratios with TimeSeries
# 4. Automatically warm up cache based on usage patterns
# 5. Support cache invalidation policies

print("\nExercise 7: Smart Cache Layer")
print("-"*40)

# Your solution here:

# Exercise 8: Recommendation Engine
# Build a personalized recommendation system
# Requirements:
# 1. Store user preferences and behavior as JSON
# 2. Use collaborative filtering with RedisGraph
# 3. Implement content-based recommendations
# 4. Track recommendation effectiveness
# 5. Support real-time model updates

print("\nExercise 8: Recommendation Engine")
print("-"*40)

# Your solution here:

# Exercise 9: Monitoring and Observability Stack
# Create a comprehensive monitoring solution
# Requirements:
# 1. Collect and store metrics with TimeSeries
# 2. Implement distributed tracing with Redis
# 3. Use Bloom filters for log deduplication
# 4. Create alerting system with threshold detection
# 5. Build dashboard with aggregated metrics

print("\nExercise 9: Monitoring and Observability Stack")
print("-"*40)

# Your solution here:

# Exercise 10: Machine Learning Model Serving
# Deploy and serve machine learning models with RedisAI
# Requirements:
# 1. Load pre-trained models into RedisAI
# 2. Implement model versioning and A/B testing
# 3. Cache model predictions for performance
# 4. Track model performance metrics
# 5. Support batch and real-time inference

print("\nExercise 10: Machine Learning Model Serving")
print("-"*40)

# Your solution here:

# Extra Challenge: Enterprise Data Platform
# Create a comprehensive enterprise data platform using Redis modules:
# 1. Unified data storage with RedisJSON and Hashes
# 2. Advanced search and analytics with RediSearch
# 3. Real-time processing with Streams and TimeSeries
# 4. Probabilistic data structures with RedisBloom
# 5. Graph databases with RedisGraph
# 6. Machine learning with RedisAI
# 7. Geospatial indexing with RedisGears
# 8. Multi-model transactions and consistency
# 9. Horizontal scaling and clustering
# 10. Security, monitoring, and governance

print("\nExtra Challenge: Enterprise Data Platform")
print("-"*50)

# Implementation guidelines:
# - Design for scalability and high availability
# - Implement proper error handling and recovery
# - Optimize for performance with appropriate data structures
# - Include comprehensive monitoring and logging
# - Handle data consistency and integrity
# - Document all components clearly
# - Test thoroughly under various load conditions
# - Consider security and compliance requirements

# Your solution here:

print("\n" + "="*60)
print("Redis Modules Practice Exercises - Complete!")
print("Implement your solutions and test them thoroughly.")
print("="*60)