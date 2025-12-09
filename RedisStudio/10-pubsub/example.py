#!/usr/bin/env python3
"""
Redis Pub/Sub Examples
This script demonstrates various publish/subscribe operations in Redis.
"""

import redis
import threading
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
    
    print("\n=== Redis Pub/Sub Examples ===\n")
    
    # 1. Basic Publish/Subscribe
    print("--- 1. Basic Publish/Subscribe ---")
    
    # Create a subscriber
    pubsub = r.pubsub()
    
    # Subscribe to a channel
    pubsub.subscribe('news')
    print("Subscribed to 'news' channel")
    
    # Publish a message
    r.publish('news', 'Hello, World!')
    print("Published message to 'news' channel")
    
    # Get message (non-blocking)
    message = pubsub.get_message(timeout=1)
    if message:
        print(f"Received message: {message}")
    
    # Unsubscribe
    pubsub.unsubscribe('news')
    print("Unsubscribed from 'news' channel")
    
    # 2. Pattern Subscription
    print("\n--- 2. Pattern Subscription ---")
    
    # Subscribe to pattern
    pubsub.psubscribe('news.*')
    print("Subscribed to pattern 'news.*'")
    
    # Publish to matching channels
    r.publish('news.sports', 'Sports news update')
    r.publish('news.politics', 'Politics news update')
    print("Published messages to pattern-matching channels")
    
    # Get messages
    for _ in range(2):
        message = pubsub.get_message(timeout=1)
        if message:
            print(f"Received pattern message: {message}")
    
    # Unsubscribe from pattern
    pubsub.punsubscribe('news.*')
    print("Unsubscribed from pattern 'news.*'")
    
    # 3. Message Handler with Threading
    print("\n--- 3. Message Handler with Threading ---")
    
    def message_handler(message):
        """Handle incoming messages"""
        if message['type'] == 'message':
            print(f"Handler received: {message['channel']} -> {message['data']}")
        elif message['type'] == 'pmessage':
            print(f"Pattern handler received: {message['channel']} ({message['pattern']}) -> {message['data']}")
    
    # Create pubsub with handler
    pubsub_handler = r.pubsub()
    pubsub_handler.subscribe(**{'chat': message_handler})
    pubsub_handler.psubscribe(**{'chat.*': message_handler})
    
    # Start listening thread
    def listen_for_messages():
        for message in pubsub_handler.listen():
            if message['type'] in ['message', 'pmessage']:
                message_handler(message)
    
    listener_thread = threading.Thread(target=listen_for_messages, daemon=True)
    listener_thread.start()
    print("Started message listener thread")
    
    # Publish messages
    time.sleep(0.1)  # Give thread time to start
    r.publish('chat', 'Hello everyone!')
    r.publish('chat.room1', 'Room 1 message')
    r.publish('chat.room2', 'Room 2 message')
    
    time.sleep(0.1)  # Give time for messages to be processed
    
    # Close pubsub
    pubsub_handler.close()
    
    # 4. Channel Information
    print("\n--- 4. Channel Information ---")
    
    # Subscribe to multiple channels
    pubsub_info = r.pubsub()
    pubsub_info.subscribe('channel1', 'channel2', 'channel3')
    print("Subscribed to multiple channels")
    
    # Publish to all channels
    r.publish('channel1', 'Message 1')
    r.publish('channel2', 'Message 2')
    r.publish('channel3', 'Message 3')
    
    # Get channel information
    channels = r.pubsub_channels()
    print(f"Active channels: {channels}")
    
    # Get number of subscribers per channel
    numsub = r.pubsub_numsub('channel1', 'channel2', 'channel3')
    print(f"Subscribers per channel: {dict(numsub)}")
    
    # Get number of pattern subscribers
    numpat = r.pubsub_numpat()
    print(f"Pattern subscribers: {numpat}")
    
    # Close pubsub
    pubsub_info.close()
    
    # 5. Practical Example: Chat Application
    print("\n--- 5. Practical Example: Chat Application ---")
    
    class ChatApplication:
        def __init__(self, redis_client):
            self.r = redis_client
            self.pubsub = self.r.pubsub()
        
        def join_room(self, room_name):
            """Join a chat room"""
            self.pubsub.subscribe(f"room:{room_name}")
            print(f"Joined room: {room_name}")
        
        def leave_room(self, room_name):
            """Leave a chat room"""
            self.pubsub.unsubscribe(f"room:{room_name}")
            print(f"Left room: {room_name}")
        
        def send_message(self, room_name, username, message):
            """Send a message to a room"""
            msg_data = {
                'username': username,
                'message': message,
                'timestamp': time.time()
            }
            self.r.publish(f"room:{room_name}", json.dumps(msg_data))
            print(f"[{username}] sent message to {room_name}")
        
        def listen_for_messages(self, timeout=5):
            """Listen for messages in subscribed rooms"""
            messages_received = 0
            start_time = time.time()
            
            while time.time() - start_time < timeout:
                message = self.pubsub.get_message(timeout=0.1)
                if message and message['type'] == 'message':
                    try:
                        msg_data = json.loads(message['data'])
                        print(f"[{msg_data['username']}] in {message['channel'][5:]}: {msg_data['message']}")
                        messages_received += 1
                    except json.JSONDecodeError:
                        print(f"Raw message in {message['channel'][5:]}: {message['data']}")
                
                if messages_received >= 3:  # Stop after receiving 3 messages
                    break
            
            return messages_received
    
    # Create chat application
    chat_app = ChatApplication(r)
    
    # Join rooms
    chat_app.join_room('general')
    chat_app.join_room('tech')
    
    # Send messages
    chat_app.send_message('general', 'Alice', 'Hello everyone!')
    chat_app.send_message('tech', 'Bob', 'Check out this new tech!')
    chat_app.send_message('general', 'Charlie', 'Welcome to the general chat!')
    
    # Listen for messages
    received = chat_app.listen_for_messages()
    print(f"Received {received} messages")
    
    # Leave rooms
    chat_app.leave_room('general')
    chat_app.leave_room('tech')
    
    # 6. Practical Example: Real-time Notifications
    print("\n--- 6. Practical Example: Real-time Notifications ---")
    
    class NotificationSystem:
        def __init__(self, redis_client):
            self.r = redis_client
        
        def subscribe_user(self, user_id):
            """Create a pubsub connection for a user"""
            pubsub = self.r.pubsub()
            pubsub.subscribe(f"user:{user_id}", f"notifications")
            return pubsub
        
        def send_notification(self, user_id, message, notification_type='info'):
            """Send notification to specific user"""
            notification = {
                'type': notification_type,
                'message': message,
                'timestamp': time.time()
            }
            self.r.publish(f"user:{user_id}", json.dumps(notification))
            print(f"Sent {notification_type} notification to user {user_id}")
        
        def broadcast_notification(self, message, notification_type='broadcast'):
            """Broadcast notification to all users"""
            notification = {
                'type': notification_type,
                'message': message,
                'timestamp': time.time()
            }
            self.r.publish(f"notifications", json.dumps(notification))
            print(f"Broadcast {notification_type} notification")
        
        def listen_for_notifications(self, pubsub, timeout=3):
            """Listen for notifications"""
            notifications_received = 0
            start_time = time.time()
            
            while time.time() - start_time < timeout:
                message = pubsub.get_message(timeout=0.1)
                if message and message['type'] == 'message':
                    try:
                        notification = json.loads(message['data'])
                        channel = message['channel']
                        print(f"Notification on {channel}: [{notification['type']}] {notification['message']}")
                        notifications_received += 1
                    except json.JSONDecodeError:
                        print(f"Raw notification on {message['channel']}: {message['data']}")
                
                if notifications_received >= 3:
                    break
            
            return notifications_received
    
    # Create notification system
    notify_system = NotificationSystem(r)
    
    # Create subscribers
    user1_pubsub = notify_system.subscribe_user(1)
    user2_pubsub = notify_system.subscribe_user(2)
    general_pubsub = r.pubsub()
    general_pubsub.subscribe('notifications')
    
    # Send notifications
    notify_system.send_notification(1, 'Your order has been shipped!', 'order')
    notify_system.send_notification(2, 'New message from Alice', 'message')
    notify_system.broadcast_notification('System maintenance scheduled for tonight', 'alert')
    
    # Listen for notifications
    print("User 1 notifications:")
    notify_system.listen_for_notifications(user1_pubsub)
    
    print("\nUser 2 notifications:")
    notify_system.listen_for_notifications(user2_pubsub)
    
    print("\nGeneral notifications:")
    notifications_received = 0
    start_time = time.time()
    while time.time() - start_time < 3 and notifications_received < 1:
        message = general_pubsub.get_message(timeout=0.1)
        if message and message['type'] == 'message':
            try:
                notification = json.loads(message['data'])
                print(f"Broadcast: [{notification['type']}] {notification['message']}")
                notifications_received += 1
            except json.JSONDecodeError:
                print(f"Raw broadcast: {message['data']}")
    
    # Close pubsubs
    user1_pubsub.close()
    user2_pubsub.close()
    general_pubsub.close()
    
    # 7. Performance Testing
    print("\n--- 7. Performance Testing ---")
    
    # Measure publish performance
    test_channel = 'perf_test'
    message_count = 1000
    start_time = time.time()
    
    for i in range(message_count):
        r.publish(test_channel, f"Test message {i}")
    
    end_time = time.time()
    duration = end_time - start_time
    rate = message_count / duration if duration > 0 else 0
    
    print(f"Published {message_count} messages in {duration:.4f} seconds")
    print(f"Publish rate: {rate:.2f} messages/second")
    
    # 8. Best Practices and Cleanup
    print("\n--- 8. Best Practices and Cleanup ---")
    
    # List all active channels
    active_channels = r.pubsub_channels()
    print(f"Active channels before cleanup: {active_channels}")
    
    # Clean up by unsubscribing all
    cleanup_pubsub = r.pubsub()
    if active_channels:
        cleanup_pubsub.unsubscribe(*active_channels)
        print(f"Cleaned up {len(active_channels)} channels")
    
    # Close all pubsub connections
    pubsub.close()
    cleanup_pubsub.close()
    
    print("\n=== End of Redis Pub/Sub Examples ===")

if __name__ == "__main__":
    main()