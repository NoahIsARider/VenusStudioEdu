#!/usr/bin/env python3
"""
Redis Strings Practice Exercises
Complete the following exercises to practice string operations in Redis.
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
    
    print("\nStarting Redis Strings Practice Exercises...\n")
    
    # Exercise 1: User Session Management
    print("--- Exercise 1: User Session Management ---")
    # Simulate storing user session data as strings
    # Store session data for user ID 12345 with expiration of 1 hour
    # Session data should include username, last_activity timestamp, and IP address
    # Verify the data was stored correctly and check TTL
    
    # Your code here:
    # 1. Store session data for user ID 12345
    # 2. Set expiration to 1 hour (3600 seconds)
    # 3. Retrieve and print the session data
    # 4. Print the TTL of the session key
    
    print("Exercise 1 completed. Check the implementation.")
    
    # Exercise 2: Product Inventory Counter
    print("\n--- Exercise 2: Product Inventory Counter ---")
    # Implement an inventory system for a product using Redis strings
    # Product ID: PRODUCT_001
    # Initial stock: 100 units
    # Perform the following operations:
    # 1. Initialize the stock
    # 2. Sell 5 units (decrease stock)
    # 3. Receive 20 units (increase stock)
    # 4. Check current stock
    # 5. Try to sell 150 units (should handle negative stock appropriately)
    
    # Your code here:
    # 1. Set initial stock
    # 2. Decrease stock by 5
    # 3. Increase stock by 20
    # 4. Get current stock
    # 5. Try to decrease by 150 and handle appropriately
    
    print("Exercise 2 completed. Check the implementation.")
    
    # Exercise 3: Configuration Management
    print("\n--- Exercise 3: Configuration Management ---")
    # Manage application configurations using Redis strings
    # Store the following configurations:
    # - app_version: "1.2.3"
    # - max_connections: "1000"
    # - debug_mode: "true"
    # - maintenance_window: "02:00-04:00"
    # Then retrieve all configurations and display them
    # Update the app_version to "1.2.4" only if it exists
    # Add a new config "log_level": "INFO" only if it doesn't exist
    
    # Your code here:
    # 1. Store all configurations
    # 2. Retrieve and display all configurations
    # 3. Update app_version conditionally
    # 4. Add new config conditionally
    
    print("Exercise 3 completed. Check the implementation.")
    
    # Exercise 4: Text Processing with Substrings
    print("\n--- Exercise 4: Text Processing with Substrings ---")
    # Process a long text document using Redis string operations
    # Store a long text (at least 200 characters) in Redis
    # Perform the following operations:
    # 1. Store the text
    # 2. Get the first 50 characters
    # 3. Get the last 30 characters
    # 4. Replace the first 10 characters with "PROCESSED:"
    # 5. Get the length of the modified text
    
    # Your code here:
    # 1. Store a long text
    # 2. Extract first 50 characters
    # 3. Extract last 30 characters
    # 4. Modify the beginning of the text
    # 5. Get the new length
    
    print("Exercise 4 completed. Check the implementation.")
    
    # Exercise 5: Atomic Counter Operations
    print("\n--- Exercise 5: Atomic Counter Operations ---")
    # Implement atomic counters for a web application
    # Create counters for:
    # - page_views: Track total page views
    # - active_users: Track currently active users
    # - login_attempts: Track login attempts (with reset functionality)
    # Perform these operations:
    # 1. Initialize all counters to 0
    # 2. Increment page_views by 1
    # 3. Increment active_users by 3
    # 4. Decrement active_users by 1
    # 5. Increment login_attempts by 1
    # 6. Reset login_attempts to 0
    # 7. Display final values of all counters
    
    # Your code here:
    # 1. Initialize counters
    # 2. Perform increment/decrement operations
    # 3. Reset login_attempts
    # 4. Display final values
    
    print("Exercise 5 completed. Check the implementation.")
    
    # Exercise 6: Rate Limiting Implementation
    print("\n--- Exercise 6: Rate Limiting Implementation ---")
    # Implement a simple rate limiter for API requests
    # Limit: 10 requests per minute per user
    # For user ID "user_001":
    # 1. Create a key with 1-minute expiration
    # 2. Increment the counter for each request
    # 3. Check if the user has exceeded the limit
    # 4. Simulate 12 requests and show when the limit is exceeded
    
    # Your code here:
    # 1. Implement rate limiting logic
    # 2. Simulate 12 requests
    # 3. Show when limit is exceeded
    
    print("Exercise 6 completed. Check the implementation.")
    
    # Exercise 7: Bit Manipulation for Feature Flags
    print("\n--- Exercise 7: Bit Manipulation for Feature Flags ---")
    # Use Redis bit operations to manage feature flags for users
    # Each bit represents a feature:
    # Bit 0: Dark Mode
    # Bit 1: Beta Features
    # Bit 2: Analytics
    # Bit 3: Notifications
    # For user ID "user_123":
    # 1. Enable Dark Mode and Analytics
    # 2. Check if Beta Features are enabled
    # 3. Disable Analytics
    # 4. Count total enabled features
    # 5. Check status of all features
    
    # Your code here:
    # 1. Set bits for enabled features
    # 2. Check specific feature
    # 3. Disable a feature
    # 4. Count enabled features
    # 5. Check all feature statuses
    
    print("Exercise 7 completed. Check the implementation.")
    
    # Exercise 8: Complex String Operations
    print("\n--- Exercise 8: Complex String Operations ---")
    # Combine multiple string operations for a practical use case
    # Scenario: Managing a simple cache with metadata
    # Requirements:
    # 1. Store cached data with automatic expiration (5 minutes)
    # 2. Keep track of cache hit count
    # 3. Store last accessed timestamp
    # 4. Implement cache get operation that updates hit count and timestamp
    # 5. Show how to atomically get and delete a cache entry
    
    # Your code here:
    # 1. Implement cache set with expiration
    # 2. Implement cache get that updates metadata
    # 3. Show atomic get and delete operation
    
    print("Exercise 8 completed. Check the implementation.")
    
    print("\nPractice exercises completed!")
    print("\nBonus Exercise:")
    print("Design and implement a Redis-based system for managing API tokens with the following features:")
    print("- Token generation with expiration")
    print("- Token validation")
    print("- Token revocation")
    print("- Rate limiting per token")
    print("- Metadata storage for each token (user ID, permissions, etc.)")

if __name__ == "__main__":
    main()