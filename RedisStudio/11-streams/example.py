"""
Redis Streams Examples
This file demonstrates various Redis Streams operations and patterns in Python
"""

import redis
import time
import json
import threading
from datetime import datetime, timedelta

# Connect to Redis
r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)

# Helper function to print section headers
def print_section(title):
    print(f"\n{'='*50}")
    print(f"{title}")
    print(f"{'='*50}")

# Flush DB for clean state
r.flushdb()

# 1. Basic Stream Operations
print_section("1. Basic Stream Operations")

# Add entries to stream
stream_key = "sensor_data"
entry1_id = r.xadd(stream_key, {"temperature": "25.5", "humidity": "60"})
entry2_id = r.xadd(stream_key, {"temperature": "26.0", "humidity": "58"})
entry3_id = r.xadd(stream_key, {"temperature": "24.8", "humidity": "62"})

print(f"Added entries with IDs: {entry1_id}, {entry2_id}, {entry3_id}")

# Read all entries from stream
entries = r.xrange(stream_key)
print(f"All entries: {entries}")

# Read specific range
range_entries = r.xrange(stream_key, min=f"{entry1_id}", max=f"{entry2_id}")
print(f"Range entries: {range_entries}")

# Read last N entries
last_entries = r.xrevrange(stream_key, count=2)
print(f"Last 2 entries: {last_entries}")

# 2. Consumer Groups
print_section("2. Consumer Groups")

# Create consumer group
group_name = "analytics_group"
try:
    r.xgroup_create(stream_key, group_name, id='0', mkstream=False)
    print(f"Created consumer group: {group_name}")
except redis.exceptions.ResponseError as e:
    if "BUSYGROUP" in str(e):
        print(f"Consumer group {group_name} already exists")
    else:
        raise

# Add more entries
r.xadd(stream_key, {"temperature": "27.2", "humidity": "55"})
r.xadd(stream_key, {"temperature": "26.8", "humidity": "57"})

# Read pending entries for a consumer
consumer_name = "worker1"
pending_entries = r.xreadgroup(group_name, consumer_name, {stream_key: '>'}, count=2)
print(f"Pending entries for {consumer_name}: {pending_entries}")

# Acknowledge processed entries
if pending_entries:
    stream_data = pending_entries[0][1]
    entry_ids = [entry[0] for entry in stream_data]
    ack_result = r.xack(stream_key, group_name, *entry_ids)
    print(f"Acknowledged {ack_result} entries")

# 3. Continuous Reading with Blocking
print_section("3. Continuous Reading with Blocking")

def producer():
    """Simulate a data producer"""
    for i in range(5):
        data = {
            "sensor_id": f"sensor_{i%3}",
            "value": f"{20 + (i % 10)}",
            "timestamp": datetime.now().isoformat()
        }
        entry_id = r.xadd("data_stream", data)
        print(f"[Producer] Added entry: {entry_id}")
        time.sleep(1)

def consumer(consumer_name):
    """Simulate a consumer that reads data"""
    try:
        while True:
            # Block for 5 seconds waiting for new messages
            streams = r.xreadgroup("processing_group", consumer_name, {"data_stream": '>'}, count=1, block=5000)
            
            if streams:
                stream_name, messages = streams[0]
                for message_id, message_data in messages:
                    print(f"[{consumer_name}] Processing: {message_data}")
                    # Simulate processing time
                    time.sleep(0.5)
                    # Acknowledge message
                    r.xack("data_stream", "processing_group", message_id)
                    print(f"[{consumer_name}] Acknowledged: {message_id}")
            else:
                print(f"[{consumer_name}] No new messages, continuing...")
                
    except KeyboardInterrupt:
        print(f"[{consumer_name}] Stopping...")

# Create stream and consumer group for continuous reading
r.xadd("data_stream", {"init": "true"})  # Add dummy entry to create stream
try:
    r.xgroup_create("data_stream", "processing_group", id='0')
except redis.exceptions.ResponseError as e:
    if "BUSYGROUP" not in str(e):
        raise

# Run producer and consumer in separate threads for demo
producer_thread = threading.Thread(target=producer)
producer_thread.daemon = True
producer_thread.start()

# Let producer run for a moment
time.sleep(2)

# 4. Stream Information and Management
print_section("4. Stream Information and Management")

# Add more entries for information demo
for i in range(10):
    r.xadd("metrics_stream", {"metric": f"value_{i}", "count": i})

# Get stream information
stream_info = r.xinfo_stream("metrics_stream")
print(f"Stream length: {stream_info['length']}")
print(f"First entry ID: {stream_info['first-entry'][0]}")
print(f"Last entry ID: {stream_info['last-entry'][0]}")

# Get consumer group information
group_info = r.xinfo_groups("metrics_stream")
print(f"Consumer groups: {group_info}")

# Get consumer information
r.xgroup_create("metrics_stream", "monitoring_group", id='0', mkstream=True)
r.xreadgroup("monitoring_group", "monitor1", {"metrics_stream": '>'}, count=3)
consumer_info = r.xinfo_consumers("metrics_stream", "monitoring_group")
print(f"Consumers: {consumer_info}")

# 5. Stream Trimming
print_section("5. Stream Trimming")

# Add many entries to demonstrate trimming
for i in range(100):
    r.xadd("large_stream", {"data": f"item_{i}"}, maxlen=50, approximate=True)

# Check stream size after trimming
stream_length = r.xlen("large_stream")
print(f"Stream length after trimming: {stream_length}")

# Manual trimming
trim_result = r.xtrim("large_stream", maxlen=30, approximate=False)
print(f"Manual trim removed {trim_result} entries")

# 6. Advanced Patterns: Fan-out
print_section("6. Advanced Patterns: Fan-out")

# Create multiple streams for fan-out pattern
topics = ["news", "sports", "technology"]
for topic in topics:
    r.xadd(f"topic:{topic}", {"message": f"First message in {topic}"})

# Add entry to multiple streams (fan-out)
def publish_to_topics(message_data):
    for topic in topics:
        stream_key = f"topic:{topic}"
        entry_id = r.xadd(stream_key, message_data)
        print(f"Published to {stream_key}: {entry_id}")

publish_to_topics({"message": "Breaking news!", "priority": "high"})

# Read from all topic streams
for topic in topics:
    stream_key = f"topic:{topic}"
    entries = r.xrange(stream_key)
    print(f"{stream_key} entries: {len(entries)}")

# 7. Time-based Operations
print_section("7. Time-based Operations")

# Add entries with explicit timestamps
now = int(time.time() * 1000)  # Redis timestamp format (milliseconds)
past_time = now - 3600000  # 1 hour ago

r.xadd("timed_stream", {"event": "past_event"}, id=f"{past_time}-0")
r.xadd("timed_stream", {"event": "recent_event"}, id=f"{now}-0")

# Read entries from last hour
one_hour_ago = now - 3600000
recent_entries = r.xrange("timed_stream", min=f"{one_hour_ago}-0")
print(f"Recent entries: {recent_entries}")

# 8. Complex Data Structures in Streams
print_section("8. Complex Data Structures in Streams")

# Store JSON data in streams
complex_data = {
    "user_id": 12345,
    "action": "purchase",
    "details": {
        "product_id": 67890,
        "amount": 99.99,
        "currency": "USD",
        "metadata": {
            "source": "mobile_app",
            "version": "2.1.3"
        }
    },
    "tags": ["electronics", "sale", "featured"]
}

# Serialize complex data to JSON string
json_data = json.dumps(complex_data)
entry_id = r.xadd("complex_stream", {"data": json_data})
print(f"Added complex data entry: {entry_id}")

# Read and deserialize complex data
entries = r.xrange("complex_stream")
if entries:
    stored_json = entries[0][1]['data']
    stored_data = json.loads(stored_json)
    print(f"Retrieved complex data: {stored_data}")

# 9. Pipeline Operations
print_section("9. Pipeline Operations")

# Use pipeline for efficient bulk operations
pipe = r.pipeline()
for i in range(10):
    pipe.xadd("pipeline_stream", {"batch_item": f"item_{i}", "batch_id": "B001"})
results = pipe.execute()
print(f"Pipeline added {len(results)} entries")

# 10. Error Handling and Recovery
print_section("10. Error Handling and Recovery")

def safe_stream_operation(stream_key, data):
    """Safely add data to stream with error handling"""
    try:
        entry_id = r.xadd(stream_key, data)
        print(f"Successfully added entry: {entry_id}")
        return entry_id
    except redis.ConnectionError:
        print("Connection error - could not add to stream")
        return None
    except redis.TimeoutError:
        print("Timeout error - operation took too long")
        return None
    except Exception as e:
        print(f"Unexpected error: {e}")
        return None

# Test safe operation
safe_stream_operation("error_handling_stream", {"status": "test", "value": 42})

# 11. Monitoring and Debugging
print_section("11. Monitoring and Debugging")

# Add entries for monitoring demo
for i in range(5):
    r.xadd("monitor_stream", {"job": f"task_{i}", "priority": i})

# Monitor stream activity
def monitor_stream(stream_key, duration_seconds=10):
    """Monitor stream for new entries"""
    print(f"Monitoring {stream_key} for {duration_seconds} seconds...")
    start_time = time.time()
    
    last_id = '0'
    while time.time() - start_time < duration_seconds:
        # Read new entries
        entries = r.xrange(stream_key, min=f"({last_id}")
        if entries:
            for entry_id, entry_data in entries:
                print(f"New entry: {entry_id} - {entry_data}")
                last_id = entry_id
        time.sleep(1)
    
    print("Monitoring completed")

# Uncomment to test monitoring (will run for 5 seconds)
# monitor_stream("monitor_stream", 5)

# 12. Performance Optimization
print_section("12. Performance Optimization")

# Batch operations for better performance
def batch_add_entries(stream_key, count):
    """Efficiently add multiple entries"""
    pipe = r.pipeline()
    for i in range(count):
        data = {"batch_id": f"batch_{i}", "value": i, "timestamp": time.time()}
        pipe.xadd(stream_key, data)
    results = pipe.execute()
    return len(results)

# Add 1000 entries efficiently
added_count = batch_add_entries("performance_stream", 1000)
print(f"Added {added_count} entries efficiently")

# Get stream information for performance metrics
perf_info = r.xinfo_stream("performance_stream")
print(f"Performance stream length: {perf_info['length']}")

print("\n" + "="*50)
print("Redis Streams Examples Completed!")
print("="*50)