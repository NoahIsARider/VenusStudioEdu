#!/usr/bin/env python3
"""
Redis Lists Practice Exercises
Complete the following exercises to practice list operations in Redis.
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
    
    print("\nStarting Redis Lists Practice Exercises...\n")
    
    # Exercise 1: Message Queue Implementation
    print("--- Exercise 1: Message Queue Implementation ---")
    # Implement a simple message queue using Redis lists
    # Requirements:
    # 1. Add messages to the queue
    # 2. Process messages from the queue (FIFO)
    # 3. Handle empty queue gracefully
    # 4. Simulate processing time
    
    # Your implementation here:
    # 1. Create a message queue
    # 2. Add several messages
    # 3. Process messages one by one
    # 4. Handle case when queue is empty
    
    print("Exercise 1 completed. Check the implementation.")
    
    # Exercise 2: Browser History Management
    print("\n--- Exercise 2: Browser History Management ---")
    # Implement browser history using Redis lists
    # Requirements:
    # 1. Add visited URLs to history (most recent first)
    # 2. Limit history to 10 items
    # 3. Retrieve recent history items
    # 4. Search for specific URLs in history
    
    # Your implementation here:
    # 1. Add URLs to history
    # 2. Maintain only 10 most recent items
    # 3. Retrieve last 5 visited URLs
    # 4. Check if a specific URL exists in history
    
    print("Exercise 2 completed. Check the implementation.")
    
    # Exercise 3: Shopping Cart with Quantity Management
    print("\n--- Exercise 3: Shopping Cart with Quantity Management ---")
    # Implement a shopping cart using Redis lists
    # Requirements:
    # 1. Add items to cart
    # 2. Remove specific items
    # 3. Update item quantities
    # 4. Calculate total items in cart
    
    # Your implementation here:
    # 1. Add items to cart (allow duplicates for quantity)
    # 2. Remove one instance of an item
    # 3. Count quantity of specific item
    # 4. Get total number of items in cart
    
    print("Exercise 3 completed. Check the implementation.")
    
    # Exercise 4: Leaderboard Implementation
    print("\n--- Exercise 4: Leaderboard Implementation ---")
    # Implement a game leaderboard using Redis lists
    # Requirements:
    # 1. Add players with scores
    # 2. Maintain top 10 players
    # 3. Retrieve top 5 players
    # 4. Update player scores
    
    # Your implementation here:
    # 1. Add players with scores
    # 2. Keep only top 10 players
    # 3. Show top 5 players
    # 4. Update a player's score and reposition
    
    print("Exercise 4 completed. Check the implementation.")
    
    # Exercise 5: Recent Logs Tracker
    print("\n--- Exercise 5: Recent Logs Tracker ---")
    # Implement a log tracker that keeps only recent logs
    # Requirements:
    # 1. Add log entries with timestamps
    # 2. Keep only last 20 log entries
    # 3. Retrieve logs from last 5 minutes
    # 4. Clear old logs
    
    # Your implementation here:
    # 1. Add log entries
    # 2. Maintain only 20 most recent entries
    # 3. Retrieve recent logs
    # 4. Implement log cleanup
    
    print("Exercise 5 completed. Check the implementation.")
    
    # Exercise 6: Task Scheduler with Priority
    print("\n--- Exercise 6: Task Scheduler with Priority ---")
    # Implement a task scheduler with high and low priority queues
    # Requirements:
    # 1. Add tasks to high/low priority queues
    # 2. Process high priority tasks first
    # 3. Handle empty queues
    # 4. Show queue sizes
    
    # Your implementation here:
    # 1. Create high and low priority queues
    # 2. Add tasks to appropriate queues
    # 3. Process tasks prioritizing high priority queue
    # 4. Show current queue sizes
    
    print("Exercise 6 completed. Check the implementation.")
    
    # Exercise 7: Social Media Feed
    print("\n--- Exercise 7: Social Media Feed ---")
    # Implement a social media feed using Redis lists
    # Requirements:
    # 1. Add posts to user feeds
    # 2. Limit feed to 50 most recent posts
    # 3. Retrieve paginated feed (10 posts per page)
    # 4. Remove old posts
    
    # Your implementation here:
    # 1. Add posts to feed
    # 2. Maintain only 50 most recent posts
    # 3. Implement pagination (10 posts per page)
    # 4. Show posts for specific page
    
    print("Exercise 7 completed. Check the implementation.")
    
    # Exercise 8: Undo/Redo Functionality
    print("\n--- Exercise 8: Undo/Redo Functionality ---")
    # Implement undo/redo functionality using Redis lists
    # Requirements:
    # 1. Add actions to undo stack
    # 2. Limit undo stack to 10 actions
    # 3. Implement undo operation
    # 4. Implement redo operation
    
    # Your implementation here:
    # 1. Add actions to undo stack
    # 2. Limit to 10 actions
    # 3. Implement undo (move action to redo stack)
    # 4. Implement redo (move action back to undo stack)
    
    print("Exercise 8 completed. Check the implementation.")
    
    print("\nPractice exercises completed!")
    print("\nBonus Exercise:")
    print("Design and implement a Redis-based notification system with the following features:")
    print("- Notification queuing for users")
    print("- Priority levels for notifications")
    print("- Notification history tracking")
    print("- Read/unread status management")
    print("- Batch notification processing")

if __name__ == "__main__":
    main()