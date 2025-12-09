#!/usr/bin/env python3
"""
Redis Sets Practice Exercises
Complete the following exercises to practice set operations in Redis.
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
    
    print("\nStarting Redis Sets Practice Exercises...\n")
    
    # Exercise 1: User Permission Management
    print("--- Exercise 1: User Permission Management ---")
    # Implement user permission management using Redis sets
    # Requirements:
    # 1. Store user permissions as sets
    # 2. Add/remove permissions dynamically
    # 3. Check if user has specific permissions
    # 4. Find common permissions between users
    
    # Your implementation here:
    # 1. Create permission sets for different users
    # 2. Add permissions to users
    # 3. Check if user has specific permissions
    # 4. Find common permissions between users
    
    print("Exercise 1 completed. Check the implementation.")
    
    # Exercise 2: Social Network Friends System
    print("\n--- Exercise 2: Social Network Friends System ---")
    # Implement a friends system using Redis sets
    # Requirements:
    # 1. Store friends for each user
    # 2. Find mutual friends between users
    # 3. Suggest new friends based on mutual connections
    # 4. Handle friend requests and removals
    
    # Your implementation here:
    # 1. Create friend sets for users
    # 2. Find mutual friends
    # 3. Suggest friends based on mutual connections
    # 4. Implement friend addition/removal
    
    print("Exercise 2 completed. Check the implementation.")
    
    # Exercise 3: Content Filtering System
    print("\n--- Exercise 3: Content Filtering System ---")
    # Implement a content filtering system using Redis sets
    # Requirements:
    # 1. Tag content with categories
    # 2. Filter content by user preferences
    # 3. Exclude content with blocked tags
    # 4. Recommend content based on interests
    
    # Your implementation here:
    # 1. Tag content with categories
    # 2. Create user preference sets
    # 3. Filter content based on preferences
    # 4. Exclude blocked content
    
    print("Exercise 3 completed. Check the implementation.")
    
    # Exercise 4: Real-time Collaboration
    print("\n--- Exercise 4: Real-time Collaboration ---")
    # Implement a real-time collaboration system using Redis sets
    # Requirements:
    # 1. Track users editing the same document
    # 2. Find overlapping collaborators
    # 3. Notify users of new collaborators
    # 4. Handle user disconnections
    
    # Your implementation here:
    # 1. Track document collaborators
    # 2. Find users working on same documents
    # 3. Implement collaboration notifications
    # 4. Handle user disconnections
    
    print("Exercise 4 completed. Check the implementation.")
    
    # Exercise 5: E-commerce Product Recommendations
    print("\n--- Exercise 5: E-commerce Product Recommendations ---")
    # Implement product recommendations using Redis sets
    # Requirements:
    # 1. Track products viewed/bought by users
    # 2. Find users with similar purchase histories
    # 3. Recommend products based on similar users
    # 4. Handle product categories and preferences
    
    # Your implementation here:
    # 1. Track user product interactions
    # 2. Find users with similar histories
    # 3. Generate product recommendations
    # 4. Filter by categories/preferences
    
    print("Exercise 5 completed. Check the implementation.")
    
    # Exercise 6: Access Control Lists (ACL)
    print("\n--- Exercise 6: Access Control Lists (ACL) ---")
    # Implement ACL system using Redis sets
    # Requirements:
    # 1. Define roles with permissions
    # 2. Assign roles to users
    # 3. Check user permissions
    # 4. Handle role inheritance
    
    # Your implementation here:
    # 1. Create role permission sets
    # 2. Assign roles to users
    # 3. Check effective user permissions
    # 4. Handle role inheritance
    
    print("Exercise 6 completed. Check the implementation.")
    
    # Exercise 7: Event Registration System
    print("\n--- Exercise 7: Event Registration System ---")
    # Implement event registration using Redis sets
    # Requirements:
    # 1. Track attendees for events
    # 2. Find users attending multiple events
    # 3. Handle waitlist management
    # 4. Send notifications to attendees
    
    # Your implementation here:
    # 1. Track event registrations
    # 2. Find overlapping attendees
    # 3. Implement waitlist functionality
    # 4. Send attendee notifications
    
    print("Exercise 7 completed. Check the implementation.")
    
    # Exercise 8: Quiz/Game Scoring System
    print("\n--- Exercise 8: Quiz/Game Scoring System ---")
    # Implement scoring system using Redis sets
    # Requirements:
    # 1. Track users who answered questions correctly
    # 2. Find users with perfect scores
    # 3. Calculate leaderboard positions
    # 4. Handle bonus achievements
    
    # Your implementation here:
    # 1. Track correct answers by user
    # 2. Find users with perfect scores
    # 3. Calculate relative rankings
    # 4. Award achievements
    
    print("Exercise 8 completed. Check the implementation.")
    
    print("\nPractice exercises completed!")
    print("\nBonus Exercise:")
    print("Design and implement a Redis-based social media analytics system with the following features:")
    print("- Track hashtag usage and trends")
    print("- Identify influential users based on followers/mentions")
    print("- Detect bot accounts through behavioral analysis")
    print("- Real-time sentiment analysis of posts")
    print("- Viral content detection algorithms")

if __name__ == "__main__":
    main()