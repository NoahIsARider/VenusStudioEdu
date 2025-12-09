#!/usr/bin/env python3
"""
Redis HyperLogLog Examples
This script demonstrates various HyperLogLog operations in Redis for cardinality estimation.
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
    
    print("\n=== Redis HyperLogLog Examples ===\n")
    
    # 1. Basic HyperLogLog Operations
    print("--- 1. Basic HyperLogLog Operations ---")
    
    # Add elements to HyperLogLog
    users_hll = 'unique_users'
    
    # Add individual elements
    r.pfadd(users_hll, 'user1', 'user2', 'user3', 'user4', 'user5')
    print("Added 5 users to HyperLogLog")
    
    # Estimate cardinality
    count = r.pfcount(users_hll)
    print(f"Estimated unique users: {count}")
    
    # Add more elements (some duplicates)
    r.pfadd(users_hll, 'user3', 'user4', 'user6', 'user7', 'user8')
    print("Added more users (with some duplicates)")
    
    # Estimate cardinality again
    count = r.pfcount(users_hll)
    print(f"Estimated unique users after adding more: {count}")
    
    # 2. Merging HyperLogLogs
    print("\n--- 2. Merging HyperLogLogs ---")
    
    # Create another HyperLogLog for mobile users
    mobile_hll = 'mobile_users'
    r.pfadd(mobile_hll, 'user1', 'user3', 'user5', 'user7', 'user9', 'user11')
    print("Created mobile users HyperLogLog")
    
    # Create another HyperLogLog for web users
    web_hll = 'web_users'
    r.pfadd(web_hll, 'user2', 'user4', 'user6', 'user8', 'user10', 'user12')
    print("Created web users HyperLogLog")
    
    # Merge HyperLogLogs
    merged_hll = 'all_users'
    r.pfmerge(merged_hll, mobile_hll, web_hll)
    print("Merged mobile and web user HyperLogLogs")
    
    # Count merged cardinality
    merged_count = r.pfcount(merged_hll)
    mobile_count = r.pfcount(mobile_hll)
    web_count = r.pfcount(web_hll)
    print(f"Mobile users estimate: {mobile_count}")
    print(f"Web users estimate: {web_count}")
    print(f"Merged users estimate: {merged_count}")
    
    # 3. Large Scale Cardinality Estimation
    print("\n--- 3. Large Scale Cardinality Estimation ---")
    
    # Generate large dataset
    large_hll = 'large_dataset'
    
    # Add 10,000 unique elements
    elements = []
    for i in range(10000):
        element = ''.join(random.choices(string.ascii_letters + string.digits, k=10))
        elements.append(element)
    
    # Add in batches to avoid command length limits
    batch_size = 1000
    for i in range(0, len(elements), batch_size):
        batch = elements[i:i+batch_size]
        r.pfadd(large_hll, *batch)
    
    estimated_count = r.pfcount(large_hll)
    print(f"Added ~10,000 elements")
    print(f"Estimated cardinality: {estimated_count}")
    print(f"Accuracy: {abs(estimated_count - 10000) / 10000 * 100:.2f}% error")
    
    # 4. Practical Example: Web Analytics
    print("\n--- 4. Practical Example: Web Analytics ---")
    
    # Simulate daily unique visitors
    days = ['day1', 'day2', 'day3', 'day4', 'day5']
    
    # Generate visitor data for each day
    for day in days:
        visitors = []
        # Each day has ~1000 unique visitors with ~30% overlap
        base_visitors = [f"visitor_{i}" for i in range(700)]
        daily_visitors = [f"{day}_visitor_{i}" for i in range(300)]
        all_visitors = base_visitors + daily_visitors
        
        # Shuffle and select random subset
        selected_visitors = random.sample(all_visitors, min(1000, len(all_visitors)))
        
        # Add to daily HyperLogLog
        r.pfadd(day, *selected_visitors)
        daily_count = r.pfcount(day)
        print(f"{day} unique visitors: {daily_count}")
    
    # Calculate total unique visitors across all days
    r.pfmerge('total_visitors', *days)
    total_unique = r.pfcount('total_visitors')
    print(f"Total unique visitors across all days: {total_unique}")
    
    # 5. Practical Example: IP Address Tracking
    print("\n--- 5. Practical Example: IP Address Tracking ---")
    
    ip_hll = 'unique_ips'
    
    # Generate sample IP addresses
    def generate_ip():
        return f"{random.randint(1, 255)}.{random.randint(0, 255)}.{random.randint(0, 255)}.{random.randint(0, 255)}"
    
    # Simulate tracking 5000 unique IP addresses
    ips = set()
    while len(ips) < 5000:
        ips.add(generate_ip())
    
    # Add to HyperLogLog in batches
    ip_list = list(ips)
    for i in range(0, len(ip_list), 500):
        batch = ip_list[i:i+500]
        r.pfadd(ip_hll, *batch)
    
    estimated_ips = r.pfcount(ip_hll)
    print(f"Tracked IP addresses: {len(ips)}")
    print(f"HyperLogLog estimate: {estimated_ips}")
    print(f"Accuracy: {abs(estimated_ips - len(ips)) / len(ips) * 100:.2f}% error")
    
    # 6. Memory Efficiency Comparison
    print("\n--- 6. Memory Efficiency Comparison ---")
    
    # Standard set approach (for comparison)
    standard_set_key = 'standard_unique_users'
    
    # Add same elements to a standard set
    for i in range(10000):
        user_id = f"user_{i}_{random.randint(1, 1000)}"
        r.sadd(standard_set_key, user_id)
    
    # Get memory usage
    hll_memory = r.memory_usage('large_dataset')
    set_memory = r.memory_usage(standard_set_key)
    
    print(f"HyperLogLog memory usage: {hll_memory} bytes")
    print(f"Standard set memory usage: {set_memory} bytes")
    print(f"Memory savings: {(set_memory - hll_memory) / set_memory * 100:.2f}%")
    
    # 7. Error Rate Analysis
    print("\n--- 7. Error Rate Analysis ---")
    
    # Test accuracy with known cardinalities
    test_sizes = [100, 1000, 10000, 100000]
    
    for size in test_sizes:
        test_hll = f'test_{size}'
        r.delete(test_hll)
        
        # Generate unique elements
        elements = [f"element_{i}" for i in range(size)]
        
        # Add in batches
        for i in range(0, len(elements), 1000):
            batch = elements[i:i+1000]
            r.pfadd(test_hll, *batch)
        
        estimated = r.pfcount(test_hll)
        error_rate = abs(estimated - size) / size * 100
        print(f"True count: {size}, Estimated: {estimated}, Error rate: {error_rate:.2f}%")
    
    # 8. Time Series Unique Counters
    print("\n--- 8. Time Series Unique Counters ---")
    
    # Simulate hourly unique user tracking
    current_hour = int(time.time() // 3600)
    
    # Track unique users per hour for 24 hours
    for hour_offset in range(24):
        hour_key = f"hourly_users_{current_hour - hour_offset}"
        
        # Generate unique users for this hour (with some overlap)
        users = []
        base_users = [f"user_{i}" for i in range(500)]
        hourly_users = [f"hour_{hour_offset}_user_{i}" for i in range(200)]
        all_users = base_users + hourly_users
        
        # Select random subset
        selected_users = random.sample(all_users, min(600, len(all_users)))
        
        # Add to hourly HyperLogLog
        r.pfadd(hour_key, *selected_users)
    
    # Calculate unique users in the last 24 hours
    hourly_keys = [f"hourly_users_{current_hour - i}" for i in range(24)]
    r.pfmerge('last_24_hours', *hourly_keys)
    last_24_count = r.pfcount('last_24_hours')
    print(f"Unique users in last 24 hours: {last_24_count}")
    
    # 9. Advanced Use Case: Real-time Analytics
    print("\n--- 9. Advanced Use Case: Real-time Analytics ---")
    
    # Track multiple metrics simultaneously
    metrics = {
        'daily_active_users': 'DAU',
        'daily_new_users': 'DNU',
        'daily_sessions': 'Sessions',
        'daily_page_views': 'PageViews'
    }
    
    # Simulate a day of activity
    for metric_key, metric_name in metrics.items():
        # Generate unique identifiers for each metric
        identifiers = [f"{metric_name}_{i}" for i in range(random.randint(1000, 5000))]
        
        # Add to HyperLogLog
        r.pfadd(metric_key, *identifiers)
        
        # Get estimate
        count = r.pfcount(metric_key)
        print(f"{metric_name}: {count}")
    
    # 10. Cleanup and Best Practices
    print("\n--- 10. Cleanup and Best Practices ---")
    
    # List all HyperLogLog keys
    hll_keys = [key for key in r.keys('*') if r.type(key) == 'hyperloglog']
    print(f"HyperLogLog keys: {hll_keys}")
    
    # Clean up example keys
    cleanup_keys = [
        'unique_users', 'mobile_users', 'web_users', 'all_users',
        'large_dataset', 'standard_unique_users', 'unique_ips',
        'total_visitors', 'last_24_hours'
    ] + days + [f"test_{size}" for size in test_sizes] + \
      [f"hourly_users_{current_hour - i}" for i in range(24)] + \
      list(metrics.keys())
    
    # Delete keys
    deleted = r.delete(*cleanup_keys)
    print(f"Cleaned up {deleted} keys")
    
    print("\n=== End of Redis HyperLogLog Examples ===")

if __name__ == "__main__":
    main()