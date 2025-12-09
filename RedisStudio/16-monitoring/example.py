import redis
import time
import json
from datetime import datetime
import threading
import psutil
import matplotlib.pyplot as plt
import pandas as pd

# Redis Monitoring Examples
# This script demonstrates various monitoring techniques for Redis

def connect_redis():
    """Establish connection to Redis"""
    try:
        r = redis.Redis(
            host='localhost',
            port=6379,
            db=0,
            decode_responses=True,
            socket_connect_timeout=5,
            socket_timeout=5
        )
        r.ping()
        print("Connected to Redis successfully")
        return r
    except Exception as e:
        print(f"Error connecting to Redis: {e}")
        return None

# Example 1: Basic Server Information Monitoring
def monitor_basic_info(r):
    """Monitor basic Redis server information"""
    print("\n=== Basic Server Information ===")
    
    # Get server info
    info = r.info()
    
    # Display key server metrics
    print(f"Redis Version: {info.get('redis_version', 'N/A')}")
    print(f"Mode: {info.get('redis_mode', 'N/A')}")
    print(f"OS: {info.get('os', 'N/A')}")
    print(f"Process ID: {info.get('process_id', 'N/A')}")
    print(f"TCP Port: {info.get('tcp_port', 'N/A')}")
    print(f"Uptime (days): {info.get('uptime_in_days', 'N/A')}")
    print(f"Executable: {info.get('executable', 'N/A')}")

# Example 2: Memory Usage Monitoring
def monitor_memory_usage(r):
    """Monitor Redis memory usage"""
    print("\n=== Memory Usage Monitoring ===")
    
    # Get memory info
    memory_info = r.info('memory')
    
    # Display memory metrics
    used_memory = memory_info.get('used_memory_human', 'N/A')
    used_memory_rss = memory_info.get('used_memory_rss_human', 'N/A')
    used_memory_peak = memory_info.get('used_memory_peak_human', 'N/A')
    mem_fragmentation_ratio = memory_info.get('mem_fragmentation_ratio', 'N/A')
    
    print(f"Used Memory: {used_memory}")
    print(f"Used Memory RSS: {used_memory_rss}")
    print(f"Peak Memory: {used_memory_peak}")
    print(f"Memory Fragmentation Ratio: {mem_fragmentation_ratio}")
    
    # Check for memory issues
    if float(mem_fragmentation_ratio) > 1.5:
        print("Warning: High memory fragmentation detected")
    elif float(mem_fragmentation_ratio) < 1.0:
        print("Info: Memory fragmentation is low (possible virtual memory usage)")

# Example 3: Keyspace Monitoring
def monitor_keyspace(r):
    """Monitor Redis keyspace statistics"""
    print("\n=== Keyspace Monitoring ===")
    
    # Get keyspace info
    keyspace_info = r.info('keyspace')
    
    # Display keyspace metrics
    if keyspace_info:
        for db, stats in keyspace_info.items():
            print(f"Database {db}:")
            print(f"  Keys: {stats.get('keys', 'N/A')}")
            print(f"  Expires: {stats.get('expires', 'N/A')}")
            print(f"  Avg TTL: {stats.get('avg_ttl', 'N/A')}")
    else:
        print("No keyspace information available")

# Example 4: Client Connection Monitoring
def monitor_clients(r):
    """Monitor Redis client connections"""
    print("\n=== Client Connection Monitoring ===")
    
    # Get client info
    client_info = r.info('clients')
    
    # Display client metrics
    connected_clients = client_info.get('connected_clients', 'N/A')
    blocked_clients = client_info.get('blocked_clients', 'N/A')
    max_clients = client_info.get('maxclients', 'N/A')
    
    print(f"Connected Clients: {connected_clients}")
    print(f"Blocked Clients: {blocked_clients}")
    print(f"Max Clients: {max_clients}")
    
    # Check for client connection issues
    if int(connected_clients) > int(max_clients) * 0.8:
        print("Warning: High client connection usage")

# Example 5: Performance Metrics Monitoring
def monitor_performance(r):
    """Monitor Redis performance metrics"""
    print("\n=== Performance Metrics Monitoring ===")
    
    # Get stats info
    stats_info = r.info('stats')
    
    # Display performance metrics
    total_commands = stats_info.get('total_commands_processed', 'N/A')
    instantaneous_ops = stats_info.get('instantaneous_ops_per_sec', 'N/A')
    total_net_input = stats_info.get('total_net_input_bytes', 'N/A')
    total_net_output = stats_info.get('total_net_output_bytes', 'N/A')
    rejected_connections = stats_info.get('rejected_connections', 'N/A')
    evicted_keys = stats_info.get('evicted_keys', 'N/A')
    
    print(f"Total Commands Processed: {total_commands}")
    print(f"Instantaneous OPS: {instantaneous_ops}")
    print(f"Total Network Input: {total_net_input} bytes")
    print(f"Total Network Output: {total_net_output} bytes")
    print(f"Rejected Connections: {rejected_connections}")
    print(f"Evicted Keys: {evicted_keys}")
    
    # Check for performance issues
    if int(rejected_connections) > 0:
        print("Warning: Connections are being rejected")
    if int(evicted_keys) > 0:
        print("Warning: Keys are being evicted due to memory pressure")

# Example 6: Persistence Monitoring
def monitor_persistence(r):
    """Monitor Redis persistence status"""
    print("\n=== Persistence Monitoring ===")
    
    # Get persistence info
    persistence_info = r.info('persistence')
    
    # Display persistence metrics
    rdb_last_save_time = persistence_info.get('rdb_last_save_time', 'N/A')
    rdb_last_bgsave_status = persistence_info.get('rdb_last_bgsave_status', 'N/A')
    aof_enabled = persistence_info.get('aof_enabled', 'N/A')
    aof_last_write_status = persistence_info.get('aof_last_write_status', 'N/A')
    
    print(f"RDB Last Save Time: {datetime.fromtimestamp(int(rdb_last_save_time)) if rdb_last_save_time != 'N/A' else 'N/A'}")
    print(f"RDB Last BGSAVE Status: {rdb_last_bgsave_status}")
    print(f"AOF Enabled: {aof_enabled}")
    print(f"AOF Last Write Status: {aof_last_write_status}")

# Example 7: Real-time Monitoring with Pub/Sub
def setup_realtime_monitoring(r):
    """Set up real-time monitoring using Redis pub/sub"""
    print("\n=== Real-time Monitoring Setup ===")
    
    # Subscribe to keyspace notifications
    pubsub = r.pubsub()
    pubsub.psubscribe('__keyspace@0__:*')
    
    print("Listening for keyspace events (press Ctrl+C to stop)...")
    
    def listen_for_events():
        try:
            for message in pubsub.listen():
                if message['type'] == 'pmessage':
                    channel = message['channel']
                    event = message['data']
                    key = channel.split(':')[-1]
                    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    print(f"[{timestamp}] Key '{key}' was {event}")
        except KeyboardInterrupt:
            print("Stopping real-time monitoring...")
            pubsub.close()
    
    # Start listening in a separate thread
    listener_thread = threading.Thread(target=listen_for_events)
    listener_thread.daemon = True
    listener_thread.start()
    
    return pubsub, listener_thread

# Example 8: Custom Metrics Collection
def collect_custom_metrics(r):
    """Collect custom application metrics"""
    print("\n=== Custom Metrics Collection ===")
    
    # Simulate application metrics
    metrics = {
        'user_sessions': r.dbsize(),
        'active_users': r.scard('active_users_set') if r.exists('active_users_set') else 0,
        'pending_tasks': r.llen('task_queue') if r.exists('task_queue') else 0,
        'cache_hit_rate': calculate_cache_hit_rate(r)
    }
    
    # Store metrics in Redis
    timestamp = int(time.time())
    metric_key = f"metrics:{timestamp}"
    r.hset(metric_key, mapping=metrics)
    r.expire(metric_key, 3600)  # Expire after 1 hour
    
    print("Custom metrics collected:")
    for key, value in metrics.items():
        print(f"  {key}: {value}")
    
    return metrics

def calculate_cache_hit_rate(r):
    """Calculate cache hit rate"""
    try:
        info = r.info('stats')
        keyspace_hits = info.get('keyspace_hits', 0)
        keyspace_misses = info.get('keyspace_misses', 0)
        
        total_requests = keyspace_hits + keyspace_misses
        if total_requests > 0:
            hit_rate = (keyspace_hits / total_requests) * 100
            return round(hit_rate, 2)
        else:
            return 0
    except:
        return 0

# Example 9: System Resource Monitoring
def monitor_system_resources():
    """Monitor system resources"""
    print("\n=== System Resource Monitoring ===")
    
    # CPU usage
    cpu_percent = psutil.cpu_percent(interval=1)
    
    # Memory usage
    memory = psutil.virtual_memory()
    
    # Disk usage
    disk = psutil.disk_usage('/')
    
    print(f"CPU Usage: {cpu_percent}%")
    print(f"Memory Usage: {memory.percent}%")
    print(f"Available Memory: {memory.available / (1024**3):.2f} GB")
    print(f"Disk Usage: {disk.percent}%")
    print(f"Free Disk Space: {disk.free / (1024**3):.2f} GB")

# Example 10: Alerting System
def check_alerts(r):
    """Check for alert conditions"""
    print("\n=== Alert Checking ===")
    
    # Get current metrics
    info = r.info()
    memory_info = r.info('memory')
    client_info = r.info('clients')
    
    # Define alert thresholds
    MEMORY_THRESHOLD = 0.8  # 80%
    CLIENT_THRESHOLD = 0.8   # 80%
    EVICTED_KEYS_THRESHOLD = 0
    
    # Check memory usage
    used_memory = int(memory_info.get('used_memory', 0))
    max_memory = int(memory_info.get('maxmemory', 1))
    
    if max_memory > 0 and (used_memory / max_memory) > MEMORY_THRESHOLD:
        print("ALERT: High memory usage detected!")
        return True
    
    # Check client connections
    connected_clients = int(client_info.get('connected_clients', 0))
    max_clients = int(client_info.get('maxclients', 1))
    
    if (connected_clients / max_clients) > CLIENT_THRESHOLD:
        print("ALERT: High client connection usage detected!")
        return True
    
    # Check for evicted keys
    stats_info = r.info('stats')
    evicted_keys = int(stats_info.get('evicted_keys', 0))
    
    if evicted_keys > EVICTED_KEYS_THRESHOLD:
        print("ALERT: Keys are being evicted!")
        return True
    
    print("No alerts at this time")
    return False

# Example 11: Historical Data Analysis
def analyze_historical_data(r):
    """Analyze historical metrics data"""
    print("\n=== Historical Data Analysis ===")
    
    # Retrieve recent metrics
    metric_keys = r.keys('metrics:*')
    metric_keys.sort(reverse=True)  # Sort by timestamp, newest first
    
    if not metric_keys:
        print("No historical metrics data available")
        return
    
    # Get last 10 metrics entries
    recent_metrics = []
    for key in metric_keys[:10]:
        metrics = r.hgetall(key)
        timestamp = int(key.split(':')[1])
        metrics['timestamp'] = timestamp
        recent_metrics.append(metrics)
    
    # Convert to DataFrame for analysis
    df = pd.DataFrame(recent_metrics)
    df['timestamp'] = pd.to_datetime(df['timestamp'], unit='s')
    
    print("Recent metrics trend:")
    print(df[['timestamp', 'user_sessions', 'active_users', 'pending_tasks', 'cache_hit_rate']].to_string(index=False))

# Example 12: Monitoring Dashboard Simulation
def display_dashboard(r):
    """Display a simulated monitoring dashboard"""
    print("\n" + "="*50)
    print("           REDIS MONITORING DASHBOARD")
    print("="*50)
    
    # Get all info
    info = r.info()
    memory_info = r.info('memory')
    client_info = r.info('clients')
    stats_info = r.info('stats')
    keyspace_info = r.info('keyspace')
    
    # Display dashboard
    print(f"Server Status: {'UP' if r.ping() else 'DOWN'}")
    print(f"Version: {info.get('redis_version', 'N/A')}")
    print(f"Mode: {info.get('redis_mode', 'N/A')}")
    print("-"*50)
    
    print("MEMORY USAGE:")
    print(f"  Used: {memory_info.get('used_memory_human', 'N/A')}")
    print(f"  Peak: {memory_info.get('used_memory_peak_human', 'N/A')}")
    print(f"  Fragmentation: {memory_info.get('mem_fragmentation_ratio', 'N/A')}")
    print("-"*50)
    
    print("CLIENT CONNECTIONS:")
    print(f"  Connected: {client_info.get('connected_clients', 'N/A')}")
    print(f"  Blocked: {client_info.get('blocked_clients', 'N/A')}")
    print("-"*50)
    
    print("PERFORMANCE:")
    print(f"  OPS/sec: {stats_info.get('instantaneous_ops_per_sec', 'N/A')}")
    print(f"  Total Commands: {stats_info.get('total_commands_processed', 'N/A')}")
    print(f"  Evicted Keys: {stats_info.get('evicted_keys', 'N/A')}")
    print("-"*50)
    
    print("KEYSPACE:")
    if keyspace_info:
        for db, stats in keyspace_info.items():
            print(f"  {db}: {stats.get('keys', 'N/A')} keys")
    else:
        print("  No keyspace data")
    print("="*50)

# Main execution
if __name__ == "__main__":
    # Connect to Redis
    redis_client = connect_redis()
    
    if redis_client:
        # Run all examples
        monitor_basic_info(redis_client)
        monitor_memory_usage(redis_client)
        monitor_keyspace(redis_client)
        monitor_clients(redis_client)
        monitor_performance(redis_client)
        monitor_persistence(redis_client)
        collect_custom_metrics(redis_client)
        monitor_system_resources()
        check_alerts(redis_client)
        analyze_historical_data(redis_client)
        display_dashboard(redis_client)
        
        # Set up real-time monitoring (optional - comment out if not needed)
        # pubsub, listener_thread = setup_realtime_monitoring(redis_client)
        # time.sleep(10)  # Monitor for 10 seconds
        # pubsub.close()
        
        print("\n=== Redis Monitoring Examples Completed ===")
    else:
        print("Failed to connect to Redis. Please check your Redis server.")