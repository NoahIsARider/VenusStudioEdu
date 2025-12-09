#!/usr/bin/env python3
"""
Redis Pub/Sub Practice Exercises
Complete the following exercises to practice publish/subscribe operations in Redis.
"""

import redis
import threading
import time
import json
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
    
    print("\nStarting Redis Pub/Sub Practice Exercises...\n")
    
    # Exercise 1: Real-time Chat Application
    print("--- Exercise 1: Real-time Chat Application ---")
    # Implement a real-time chat application using Redis Pub/Sub
    # Requirements:
    # 1. Support multiple chat rooms
    # 2. Handle user presence (join/leave)
    # 3. Broadcast messages to room participants
    # 4. Handle private messages between users
    
    # Your implementation here:
    # 1. Create chat room management system
    # 2. Implement message broadcasting
    # 3. Handle user join/leave events
    # 4. Support private messaging
    
    print("Exercise 1 completed. Check the implementation.")
    
    # Exercise 2: Live Sports Score Updates
    print("\n--- Exercise 2: Live Sports Score Updates ---")
    # Implement a live sports score update system using Redis Pub/Sub
    # Requirements:
    # 1. Broadcast score updates for multiple games
    # 2. Handle different types of events (goals, fouls, timeouts)
    # 3. Support subscriber filtering by sport/game
    # 4. Provide real-time statistics
    
    # Your implementation here:
    # 1. Create score update publishing system
    # 2. Implement event type filtering
    # 3. Handle multiple simultaneous games
    # 4. Generate real-time statistics
    
    print("Exercise 2 completed. Check the implementation.")
    
    # Exercise 3: Distributed Task Queue
    print("\n--- Exercise 3: Distributed Task Queue ---")
    # Implement a distributed task queue using Redis Pub/Sub
    # Requirements:
    # 1. Publish tasks to worker nodes
    # 2. Handle task prioritization
    # 3. Track task progress and completion
    # 4. Handle worker node failures
    
    # Your implementation here:
    # 1. Create task publishing system
    # 2. Implement worker node subscriptions
    # 3. Handle task acknowledgment
    # 4. Manage worker node lifecycle
    
    print("Exercise 3 completed. Check the implementation.")
    
    # Exercise 4: Real-time Analytics Dashboard
    print("\n--- Exercise 4: Real-time Analytics Dashboard ---")
    # Implement a real-time analytics dashboard using Redis Pub/Sub
    # Requirements:
    # 1. Stream metrics from multiple sources
    # 2. Aggregate and process data in real-time
    # 3. Push updates to dashboard clients
    # 4. Handle different visualization types
    
    # Your implementation here:
    # 1. Create metrics streaming system
    # 2. Implement real-time aggregation
    # 3. Push updates to dashboard subscribers
    # 4. Support multiple visualization types
    
    print("Exercise 4 completed. Check the implementation.")
    
    # Exercise 5: IoT Sensor Data Processing
    print("\n--- Exercise 5: IoT Sensor Data Processing ---")
    # Implement an IoT sensor data processing system using Redis Pub/Sub
    # Requirements:
    # 1. Collect data from multiple sensor types
    # 2. Process and filter sensor readings
    # 3. Trigger alerts based on thresholds
    # 4. Store processed data for analysis
    
    # Your implementation here:
    # 1. Create sensor data ingestion system
    # 2. Implement real-time data filtering
    # 3. Handle alert generation and distribution
    # 4. Manage sensor device registration
    
    print("Exercise 5 completed. Check the implementation.")
    
    # Exercise 6: Collaborative Document Editing
    print("\n--- Exercise 6: Collaborative Document Editing ---")
    # Implement collaborative document editing using Redis Pub/Sub
    # Requirements:
    # 1. Broadcast edits to all collaborators
    # 2. Handle conflict resolution
    # 3. Track user presence and cursor positions
    # 4. Support offline synchronization
    
    # Your implementation here:
    # 1. Create document editing event system
    # 2. Implement edit broadcasting and merging
    # 3. Track user presence and cursors
    # 4. Handle offline-online transitions
    
    print("Exercise 6 completed. Check the implementation.")
    
    # Exercise 7: Microservices Communication
    print("\n--- Exercise 7: Microservices Communication ---")
    # Implement microservices communication using Redis Pub/Sub
    # Requirements:
    # 1. Enable service-to-service messaging
    # 2. Handle event-driven architecture
    # 3. Implement service discovery
    # 4. Manage message routing and filtering
    
    # Your implementation here:
    # 1. Create service messaging framework
    # 2. Implement event publication/subscriptions
    # 3. Handle service registration and discovery
    # 4. Manage inter-service communication patterns
    
    print("Exercise 7 completed. Check the implementation.")
    
    # Exercise 8: Gaming Platform Events
    print("\n--- Exercise 8: Gaming Platform Events ---")
    # Implement gaming platform event system using Redis Pub/Sub
    # Requirements:
    # 1. Broadcast game state updates
    # 2. Handle player actions and events
    # 3. Support multiplayer game synchronization
    # 4. Implement anti-cheat measures
    
    # Your implementation here:
    # 1. Create game event broadcasting system
    # 2. Handle player action processing
    # 3. Synchronize multiplayer game states
    # 4. Implement security measures
    
    print("Exercise 8 completed. Check the implementation.")
    
    print("\nPractice exercises completed!")
    print("\nBonus Exercise:")
    print("Design and implement a Redis-based real-time collaborative platform with the following features:")
    print("- Support for multiple collaboration types (documents, whiteboards, code editing)")
    print("- Real-time presence and activity tracking")
    print("- Conflict-free replicated data types (CRDTs) for synchronization")
    print("- Scalable architecture supporting millions of concurrent users")
    print("- Advanced security with end-to-end encryption")

if __name__ == "__main__":
    main()