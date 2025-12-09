#!/usr/bin/env python3
"""
Redis Performance Optimization Examples

This script demonstrates various techniques for optimizing Redis performance,
including connection pooling, pipelining, batch operations, and more.
"""

import redis
import time
import threading
from concurrent.futures import ThreadPoolExecutor
import json


def test_redis_connection():
    """Test Redis connection"""
    try:
        r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)
        r.ping()
        print("✓ Connected to Redis successfully")
        return r
    except Exception as e:
        print(f"✗ Failed to connect to Redis: {e}")
        return None


def example_1_basic_operations(r):
    """Example 1: Basic Operations Performance"""
    print("\n=== Example 1: Basic Operations Performance ===")
    
    # Simple set/get operations
    start_time = time.time()
    for i in range(1000):
        r.set(f"key:{i}", f"value:{i}")
    set_time = time.time() - start_time
    
    start_time = time.time()
    for i in range(1000):
        r.get(f"key:{i}")
    get_time = time.time() - start_time
    
    print(f"Set 1000 keys: {set_time:.4f} seconds")
    print(f"Get 1000 keys: {get_time:.4f} seconds")


def example_2_connection_pooling(r):
    """Example 2: Connection Pooling"""
    print("\n=== Example 2: Connection Pooling ===")
    
    # Create a connection pool
    pool = redis.ConnectionPool(host='localhost', port=6379, db=0, max_connections=20)
    pooled_client = redis.Redis(connection_pool=pool)
    
    # Test performance with connection pool
    start_time = time.time()
    for i in range(1000):
        pooled_client.set(f"pooled_key:{i}", f"pooled_value:{i}")
    pooled_set_time = time.time() - start_time
    
    print(f"Connection pool set 1000 keys: {pooled_set_time:.4f} seconds")
    
    # Clean up
    pooled_client.close()


def example_3_pipelining(r):
    """Example 3: Pipelining for Batch Operations"""
    print("\n=== Example 3: Pipelining for Batch Operations ===")
    
    # Without pipeline
    start_time = time.time()
    for i in range(1000):
        r.set(f"nopipe:{i}", f"value:{i}")
    no_pipe_time = time.time() - start_time
    
    # With pipeline
    start_time = time.time()
    pipe = r.pipeline()
    for i in range(1000):
        pipe.set(f"pipe:{i}", f"value:{i}")
    pipe.execute()
    pipe_time = time.time() - start_time
    
    print(f"Without pipeline: {no_pipe_time:.4f} seconds")
    print(f"With pipeline: {pipe_time:.4f} seconds")
    print(f"Performance improvement: {no_pipe_time/pipe_time:.2f}x")


def example_4_batch_operations(r):
    """Example 4: Batch Operations with mset/mget"""
    print("\n=== Example 4: Batch Operations with mset/mget ===")
    
    # Prepare data
    data = {f"batch:{i}": f"value:{i}" for i in range(1000)}
    
    # Using mset
    start_time = time.time()
    r.mset(data)
    mset_time = time.time() - start_time
    
    # Using mget
    keys = list(data.keys())
    start_time = time.time()
    values = r.mget(keys)
    mget_time = time.time() - start_time
    
    print(f"mset 1000 keys: {mset_time:.4f} seconds")
    print(f"mget 1000 keys: {mget_time:.4f} seconds")


def example_5_hash_performance(r):
    """Example 5: Hash Performance Optimization"""
    print("\n=== Example 5: Hash Performance Optimization ===")
    
    # Many small hashes vs one large hash
    
    # Approach 1: Many individual keys
    start_time = time.time()
    for i in range(1000):
        r.hset(f"user:{i}", "name", f"User {i}")
        r.hset(f"user:{i}", "email", f"user{i}@example.com")
        r.hset(f"user:{i}", "age", 25 + (i % 50))
    many_hashes_time = time.time() - start_time
    
    # Approach 2: One large hash with field compression
    start_time = time.time()
    user_data = {}
    for i in range(1000):
        user_data[f"user:{i}:name"] = f"User {i}"
        user_data[f"user:{i}:email"] = f"user{i}@example.com"
        user_data[f"user:{i}:age"] = str(25 + (i % 50))
    r.hmset("users_compressed", user_data)
    one_hash_time = time.time() - start_time
    
    print(f"Many small hashes: {many_hashes_time:.4f} seconds")
    print(f"One large hash: {one_hash_time:.4f} seconds")


def example_6_memory_optimization(r):
    """Example 6: Memory Optimization Techniques"""
    print("\n=== Example 6: Memory Optimization Techniques ===")
    
    # String vs integer storage
    r.flushdb()  # Clear database for accurate measurement
    
    # Store as string
    start_time = time.time()
    for i in range(10000):
        r.set(f"str_counter:{i}", str(i))
    str_time = time.time() - start_time
    str_memory = r.info('memory')['used_memory']
    
    r.flushdb()
    
    # Store as integer (using INCR)
    start_time = time.time()
    for i in range(10000):
        r.set(f"int_counter:{i}", i)
    int_time = time.time() - start_time
    int_memory = r.info('memory')['used_memory']
    
    print(f"String storage time: {str_time:.4f} seconds")
    print(f"Integer storage time: {int_time:.4f} seconds")
    print(f"Memory usage comparison may vary based on Redis version")


def example_7_concurrent_access(r):
    """Example 7: Concurrent Access Patterns"""
    print("\n=== Example 7: Concurrent Access Patterns ===")
    
    def worker(worker_id):
        client = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)
        for i in range(100):
            client.set(f"worker:{worker_id}:{i}", f"data:{worker_id}:{i}")
        client.close()
    
    # Sequential execution
    r.flushdb()
    start_time = time.time()
    for i in range(5):
        worker(i)
    sequential_time = time.time() - start_time
    
    # Concurrent execution
    r.flushdb()
    start_time = time.time()
    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = [executor.submit(worker, i) for i in range(5)]
        for future in futures:
            future.result()
    concurrent_time = time.time() - start_time
    
    print(f"Sequential execution: {sequential_time:.4f} seconds")
    print(f"Concurrent execution: {concurrent_time:.4f} seconds")
    print(f"Concurrency improvement: {sequential_time/concurrent_time:.2f}x")


def example_8_caching_strategies(r):
    """Example 8: Caching Strategies"""
    print("\n=== Example 8: Caching Strategies ===")
    
    # Simulate expensive computation
    def expensive_computation(n):
        time.sleep(0.01)  # Simulate 10ms computation
        return sum(i * i for i in range(n))
    
    # Cache with expiration
    def cached_computation(r, n, ttl=300):
        cache_key = f"computation:{n}"
        cached_result = r.get(cache_key)
        
        if cached_result:
            print(f"Cache hit for n={n}")
            return int(cached_result)
        else:
            print(f"Cache miss for n={n}, computing...")
            result = expensive_computation(n)
            r.setex(cache_key, ttl, result)
            return result
    
    # Test caching
    start_time = time.time()
    result1 = cached_computation(r, 1000)
    result2 = cached_computation(r, 1000)  # Should be cache hit
    cache_time = time.time() - start_time
    
    print(f"Cached computation time: {cache_time:.4f} seconds")
    print(f"Result: {result1}")


def example_9_serialization_performance(r):
    """Example 9: Serialization Performance"""
    print("\n=== Example 9: Serialization Performance ===")
    
    # Test different serialization methods
    data = {
        "id": 12345,
        "name": "Test User",
        "email": "test@example.com",
        "preferences": {
            "theme": "dark",
            "notifications": True,
            "language": "en"
        },
        "scores": [85, 92, 78, 96, 88]
    }
    
    # JSON serialization
    start_time = time.time()
    for i in range(1000):
        json_data = json.dumps(data)
        r.set(f"json:{i}", json_data)
    json_store_time = time.time() - start_time
    
    start_time = time.time()
    for i in range(1000):
        json_data = r.get(f"json:{i}")
        parsed_data = json.loads(json_data)
    json_retrieve_time = time.time() - start_time
    
    # Direct string storage (if applicable)
    start_time = time.time()
    for i in range(1000):
        r.set(f"string:{i}", "simple_string_value")
    string_store_time = time.time() - start_time
    
    print(f"JSON store time: {json_store_time:.4f} seconds")
    print(f"JSON retrieve time: {json_retrieve_time:.4f} seconds")
    print(f"Simple string store time: {string_store_time:.4f} seconds")


def example_10_monitoring_and_profiling(r):
    """Example 10: Monitoring and Profiling"""
    print("\n=== Example 10: Monitoring and Profiling ===")
    
    # Get Redis info
    info = r.info()
    print(f"Redis version: {info['redis_version']}")
    print(f"Connected clients: {info['connected_clients']}")
    print(f"Used memory: {info['used_memory_human']}")
    print(f"Ops per second: {info['instantaneous_ops_per_sec']}")
    
    # Monitor command execution time
    start_time = time.time()
    for i in range(1000):
        r.incr("counter")
    incr_time = time.time() - start_time
    
    print(f"1000 INCR operations: {incr_time:.4f} seconds")
    print(f"Approximate ops/sec: {1000/incr_time:.0f}")


def example_11_advanced_patterns(r):
    """Example 11: Advanced Performance Patterns"""
    print("\n=== Example 11: Advanced Performance Patterns ===")
    
    # Lua scripting for atomic operations
    lua_script = """
    local key = KEYS[1]
    local increment = tonumber(ARGV[1])
    local expire_time = tonumber(ARGV[2])
    
    local current = redis.call('GET', key)
    if current == false then
        current = 0
    end
    
    local new_value = tonumber(current) + increment
    redis.call('SET', key, new_value)
    redis.call('EXPIRE', key, expire_time)
    
    return new_value
    """
    
    increment_with_expire = r.register_script(lua_script)
    
    # Test Lua script performance
    start_time = time.time()
    for i in range(1000):
        increment_with_expire(keys=['lua_counter'], args=[1, 60])
    lua_time = time.time() - start_time
    
    # Compare with regular operations
    r.flushdb()
    start_time = time.time()
    for i in range(1000):
        r.incr('regular_counter')
        r.expire('regular_counter', 60)
    regular_time = time.time() - start_time
    
    print(f"Lua script time: {lua_time:.4f} seconds")
    print(f"Regular ops time: {regular_time:.4f} seconds")
    print(f"Lua performance improvement: {regular_time/lua_time:.2f}x")


def example_12_configuration_tuning(r):
    """Example 12: Configuration Tuning Recommendations"""
    print("\n=== Example 12: Configuration Tuning Recommendations ===")
    
    # Get current configuration
    config = r.config_get('*')
    
    # Key configurations for performance
    important_configs = [
        'maxmemory',
        'maxmemory-policy',
        'tcp-keepalive',
        'timeout',
        'save',
        'appendonly',
        'appendfsync'
    ]
    
    print("Important Redis configurations:")
    for conf in important_configs:
        if conf in config:
            print(f"  {conf}: {config[conf]}")
    
    # Database size information
    db_size = r.dbsize()
    print(f"\nCurrent database size: {db_size} keys")
    
    # Memory usage
    memory_info = r.info('memory')
    print(f"Used memory: {memory_info['used_memory_human']}")
    print(f"Peak memory: {memory_info['used_memory_peak_human']}")
    
    print("\nPerformance Tuning Tips:")
    print("1. Set appropriate maxmemory and eviction policy")
    print("2. Use connection pooling to reduce connection overhead")
    print("3. Enable pipelining for batch operations")
    print("4. Use appropriate data structures for your use case")
    print("5. Monitor slow queries with SLOWLOG")
    print("6. Consider using Redis Cluster for horizontal scaling")


def main():
    """Main function to run all examples"""
    print("Redis Performance Optimization Examples")
    print("=====================================")
    
    # Test Redis connection
    r = test_redis_connection()
    if not r:
        return
    
    # Run all examples
    example_1_basic_operations(r)
    example_2_connection_pooling(r)
    example_3_pipelining(r)
    example_4_batch_operations(r)
    example_5_hash_performance(r)
    example_6_memory_optimization(r)
    example_7_concurrent_access(r)
    example_8_caching_strategies(r)
    example_9_serialization_performance(r)
    example_10_monitoring_and_profiling(r)
    example_11_advanced_patterns(r)
    example_12_configuration_tuning(r)
    
    print("\n=== Performance Optimization Summary ===")
    print("Key takeaways:")
    print("1. Use connection pooling to reduce connection overhead")
    print("2. Leverage pipelining for batch operations")
    print("3. Choose appropriate data structures for your use case")
    print("4. Implement effective caching strategies")
    print("5. Monitor and profile your Redis instance regularly")
    print("6. Tune configuration settings based on your workload")
    print("7. Use Lua scripts for complex atomic operations")
    print("8. Consider memory optimization techniques")


if __name__ == "__main__":
    main()