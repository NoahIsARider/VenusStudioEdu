"""
Redis Streams Practice Exercises
This file contains 10 practical exercises for learning Redis Streams operations in Python
"""

import redis
import json
import time
import threading
from datetime import datetime, timedelta

# Connect to Redis
r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)

# Flush DB for clean state (uncomment when needed)
# r.flushdb()

print("="*60)
print("Redis Streams Practice Exercises")
print("="*60)

# Exercise 1: IoT Sensor Data Processing
# Create a system that processes temperature and humidity sensor data
# Requirements:
# 1. Create a stream to store sensor readings
# 2. Implement a producer that adds readings every 2 seconds
# 3. Implement a consumer that processes readings and detects anomalies
# 4. Anomaly detection: temperature > 35°C or humidity > 80%
# 5. Log anomalies to a separate stream

print("\nExercise 1: IoT Sensor Data Processing")
print("-"*40)

# Your solution here:

# Exercise 2: Real-time Chat Application
# Create a Redis Streams based chat application
# Requirements:
# 1. Create streams for different chat rooms
# 2. Implement message sending functionality
# 3. Implement message receiving with blocking read
# 4. Support multiple users in the same room
# 5. Handle message history retrieval

print("\nExercise 2: Real-time Chat Application")
print("-"*40)

# Your solution here:

# Exercise 3: Task Queue with Priority
# Create a priority-based task queue using Redis Streams
# Requirements:
# 1. Create streams for high, medium, and low priority tasks
# 2. Implement task producer with priority assignment
# 3. Implement worker that processes tasks by priority
# 4. Track task completion and processing time
# 5. Handle task retries for failed tasks

print("\nExercise 3: Task Queue with Priority")
print("-"*40)

# Your solution here:

# Exercise 4: Event Sourcing Pattern
# Implement an event sourcing system for a simple bank account
# Requirements:
# 1. Create streams to store account events (deposit, withdrawal, transfer)
# 2. Implement functions to apply events and calculate balance
# 3. Support querying account state at any point in time
# 4. Handle concurrent operations safely
# 5. Replay events to rebuild account state

print("\nExercise 4: Event Sourcing Pattern")
print("-"*40)

# Your solution here:

# Exercise 5: Log Aggregation System
# Create a log aggregation system that collects logs from multiple sources
# Requirements:
# 1. Create streams for different log sources (application, database, security)
# 2. Implement log producers for each source type
# 3. Create a central consumer that aggregates logs
# 4. Filter and categorize logs by severity (INFO, WARN, ERROR)
# 5. Generate periodic summary reports

print("\nExercise 5: Log Aggregation System")
print("-"*40)

# Your solution here:

# Exercise 6: Real-time Analytics Dashboard
# Create a system that processes user activity events for analytics
# Requirements:
# 1. Create stream for user activity events (page views, clicks, purchases)
# 2. Implement multiple consumers for different analytics calculations
# 3. Calculate real-time metrics (active users, conversion rates, etc.)
# 4. Store aggregated results in Redis keys for fast retrieval
# 5. Handle backpressure and consumer lag

print("\nExercise 6: Real-time Analytics Dashboard")
print("-"*40)

# Your solution here:

# Exercise 7: Notification System
# Create a notification system that handles different delivery channels
# Requirements:
# 1. Create streams for email, SMS, and push notifications
# 2. Implement notification producer with channel selection
# 3. Create consumers for each delivery channel
# 4. Track delivery status and handle failures
# 5. Implement deduplication to prevent duplicate notifications

print("\nExercise 7: Notification System")
print("-"*40)

# Your solution here:

# Exercise 8: Data Pipeline with Transformation
# Create a data pipeline that processes and transforms incoming data
# Requirements:
# 1. Create input stream for raw data
# 2. Implement transformation workers that process data
# 3. Apply transformations (filtering, enrichment, formatting)
# 4. Output processed data to result streams
# 5. Handle data validation and error routing

print("\nExercise 8: Data Pipeline with Transformation")
print("-"*40)

# Your solution here:

# Exercise 9: Microservices Communication
# Implement a communication system between microservices using Redis Streams
# Requirements:
# 1. Create streams for different service interactions
# 2. Implement request-response pattern between services
# 3. Handle service discovery and load balancing
# 4. Implement circuit breaker pattern for fault tolerance
# 5. Track service metrics and performance

print("\nExercise 9: Microservices Communication")
print("-"*40)

# Your solution here:

# Exercise 10: Time Series Data Processing
# Create a system for processing and analyzing time series data
# Requirements:
# 1. Store time series data in Redis Streams with timestamps
# 2. Implement windowed aggregations (1min, 5min, 1hour)
# 3. Calculate moving averages and trends
# 4. Detect patterns and anomalies in time series
# 5. Support data retention policies and stream trimming

print("\nExercise 10: Time Series Data Processing")
print("-"*40)

# Your solution here:

# Extra Challenge: Distributed Social Media Feed
# Create a comprehensive social media feed system using Redis Streams:
# 1. User activity stream (posts, likes, comments, follows)
# 2. Personalized feed generation using fan-out pattern
# 3. Real-time feed updates with consumer groups
# 4. Content moderation and filtering
# 5. Trending topics detection
# 6. Engagement analytics and metrics
# 7. Scalable architecture supporting millions of users
# 8. Fault-tolerant design with automatic recovery
# 9. Performance optimization for low latency
# 10. Comprehensive monitoring and debugging capabilities

print("\nExtra Challenge: Distributed Social Media Feed")
print("-"*50)

# Implementation guidelines:
# - Use consumer groups for scalable processing
# - Implement proper error handling and recovery mechanisms
# - Design for high availability and fault tolerance
# - Optimize for performance with appropriate data structures
# - Include comprehensive logging for debugging
# - Handle edge cases like network partitions and failures
# - Ensure data consistency and integrity
# - Document all components clearly
# - Test thoroughly under various conditions

# Your solution here:

print("\n" + "="*60)
print("Redis Streams Practice Exercises - Complete!")
print("Implement your solutions and test them thoroughly.")
print("="*60)