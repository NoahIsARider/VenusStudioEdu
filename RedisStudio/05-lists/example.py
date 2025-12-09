#!/usr/bin/env python3
"""
Redis Lists Example
This script demonstrates various list operations in Redis.
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
    
    print("\n=== Redis Lists Examples ===\n")
    
    # Clear any existing data
    r.delete('tasks', 'queue', 'browsers', 'ratings')
    
    # 1. Basic List Operations (LPUSH, RPUSH, LPOP, RPOP)
    print("1. Basic List Operations")
    
    # LPUSH - Add elements to the head of the list
    r.lpush('tasks', 'task1', 'task2', 'task3')
    print(f"List after LPUSH: {r.lrange('tasks', 0, -1)}")
    
    # RPUSH - Add elements to the tail of the list
    r.rpush('tasks', 'task4', 'task5')
    print(f"List after RPUSH: {r.lrange('tasks', 0, -1)}")
    
    # LPOP - Remove and return the first element
    first_task = r.lpop('tasks')
    print(f"LPOP result: {first_task}")
    print(f"List after LPOP: {r.lrange('tasks', 0, -1)}")
    
    # RPOP - Remove and return the last element
    last_task = r.rpop('tasks')
    print(f"RPOP result: {last_task}")
    print(f"List after RPOP: {r.lrange('tasks', 0, -1)}")
    
    print("\n" + "-"*50 + "\n")
    
    # 2. List Inspection (LRANGE, LLEN)
    print("2. List Inspection")
    
    # LRANGE - Get a range of elements
    r.rpush('queue', 'item1', 'item2', 'item3', 'item4', 'item5')
    print(f"First 3 items: {r.lrange('queue', 0, 2)}")
    print(f"Last 2 items: {r.lrange('queue', -2, -1)}")
    print(f"All items: {r.lrange('queue', 0, -1)}")
    
    # LLEN - Get the length of the list
    print(f"Length of queue: {r.llen('queue')}")
    
    print("\n" + "-"*50 + "\n")
    
    # 3. List Modification (LSET, LINSERT)
    print("3. List Modification")
    
    # LSET - Set the value of an element by index
    r.lset('queue', 1, 'modified_item2')
    print(f"Queue after LSET: {r.lrange('queue', 0, -1)}")
    
    # LINSERT - Insert an element before or after another element
    r.linsert('queue', 'BEFORE', 'item4', 'inserted_before_item4')
    r.linsert('queue', 'AFTER', 'item3', 'inserted_after_item3')
    print(f"Queue after LINSERT: {r.lrange('queue', 0, -1)}")
    
    print("\n" + "-"*50 + "\n")
    
    # 4. List Trimming (LTRIM)
    print("4. List Trimming")
    
    # LTRIM - Trim a list to the specified range
    r.ltrim('queue', 1, 4)
    print(f"Queue after LTRIM (1,4): {r.lrange('queue', 0, -1)}")
    
    print("\n" + "-"*50 + "\n")
    
    # 5. Blocking Operations (BLPOP, BRPOP)
    print("5. Blocking Operations")
    print("Adding items to 'browsers' list for blocking operations...")
    
    # Add some items to demonstrate blocking operations
    r.rpush('browsers', 'Chrome', 'Firefox', 'Safari')
    
    # BLPOP - Blocking left pop (demonstrated with timeout)
    print("Performing BLPOP with 1 second timeout...")
    result = r.blpop('browsers', timeout=1)
    if result:
        print(f"BLPOP result: {result}")
    else:
        print("BLPOP timed out")
    
    print(f"Browsers list after BLPOP: {r.lrange('browsers', 0, -1)}")
    
    print("\n" + "-"*50 + "\n")
    
    # 6. Advanced List Operations
    print("6. Advanced List Operations")
    
    # LINDEX - Get an element by index
    r.rpush('ratings', '5', '4', '3', '5', '2')
    print(f"Element at index 2: {r.lindex('ratings', 2)}")
    
    # LREM - Remove elements equal to value
    r.lrem('ratings', 1, '5')  # Remove first occurrence of '5'
    print(f"Ratings after removing first '5': {r.lrange('ratings', 0, -1)}")
    
    # LPOS - Get the position of an element
    pos = r.lpos('ratings', '3')
    print(f"Position of '3' in ratings: {pos}")
    
    # LMOVE - Move an element from one list to another
    r.rpush('source_list', 'item1', 'item2', 'item3')
    r.rpush('destination_list', 'existing_item')
    
    moved_item = r.lmove('source_list', 'destination_list', 'RIGHT', 'LEFT')
    print(f"Moved item: {moved_item}")
    print(f"Source list: {r.lrange('source_list', 0, -1)}")
    print(f"Destination list: {r.lrange('destination_list', 0, -1)}")
    
    print("\n" + "-"*50 + "\n")
    
    # 7. Practical Example: Task Queue
    print("7. Practical Example: Task Queue")
    
    # Clear previous data
    r.delete('task_queue', 'processing_tasks', 'completed_tasks')
    
    # Add tasks to queue
    tasks = ['send_email', 'process_image', 'generate_report', 'backup_data']
    r.lpush('task_queue', *tasks)
    print(f"Initial task queue: {r.lrange('task_queue', 0, -1)}")
    
    # Process tasks (simulated)
    while r.llen('task_queue') > 0:
        # Move task from queue to processing
        task = r.brpoplpush('task_queue', 'processing_tasks', timeout=1)
        if task:
            print(f"Processing task: {task}")
            # Simulate task processing time
            time.sleep(0.5)
            # Move task to completed
            r.lrem('processing_tasks', 1, task)
            r.lpush('completed_tasks', task)
            print(f"Completed task: {task}")
    
    print(f"Final completed tasks: {r.lrange('completed_tasks', 0, -1)}")
    
    print("\n=== End of Redis Lists Examples ===")

if __name__ == "__main__":
    main()