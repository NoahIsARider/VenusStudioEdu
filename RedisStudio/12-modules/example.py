"""
Redis Modules Examples
This file demonstrates various Redis modules and their operations in Python
"""

import redis
import json
import time
from datetime import datetime
import numpy as np

# Connect to Redis
r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)

# Flush DB for clean state
r.flushdb()

# Helper function to print section headers
def print_section(title):
    print(f"\n{'='*60}")
    print(f"{title}")
    print(f"{'='*60}")

# Note: Many Redis modules need to be installed separately and loaded into Redis server
# This example assumes the following modules are available:
# - RedisJSON (for JSON operations)
# - RediSearch (for advanced search capabilities)
# - RedisTimeSeries (for time series data)
# - RedisBloom (for probabilistic data structures)
# - RedisGraph (for graph databases)
# - RedisAI (for machine learning)

# 1. RedisJSON Examples
print_section("1. RedisJSON Examples")

try:
    # Store JSON document
    user_data = {
        "name": "John Doe",
        "age": 30,
        "email": "john@example.com",
        "address": {
            "street": "123 Main St",
            "city": "New York",
            "zipcode": "10001"
        },
        "interests": ["programming", "reading", "travel"],
        "active": True
    }
    
    # Set JSON document
    r.execute_command('JSON.SET', 'user:1000', '$', json.dumps(user_data))
    print("Stored JSON document for user:1000")
    
    # Get entire JSON document
    full_doc = r.execute_command('JSON.GET', 'user:1000', '$')
    print(f"Full document: {full_doc}")
    
    # Get specific field
    name = r.execute_command('JSON.GET', 'user:1000', '$.name')
    print(f"User name: {name}")
    
    # Get nested field
    city = r.execute_command('JSON.GET', 'user:1000', '$.address.city')
    print(f"User city: {city}")
    
    # Update field
    r.execute_command('JSON.SET', 'user:1000', '$.age', '31')
    updated_age = r.execute_command('JSON.GET', 'user:1000', '$.age')
    print(f"Updated age: {updated_age}")
    
    # Append to array
    r.execute_command('JSON.ARRAPPEND', 'user:1000', '$.interests', '"cooking"')
    interests = r.execute_command('JSON.GET', 'user:1000', '$.interests')
    print(f"Updated interests: {interests}")
    
    # Get array length
    interests_len = r.execute_command('JSON.ARRLEN', 'user:1000', '$.interests')
    print(f"Number of interests: {interests_len}")
    
except redis.exceptions.ResponseError as e:
    print(f"RedisJSON not available or error: {e}")
except Exception as e:
    print(f"Error with RedisJSON: {e}")

# 2. RediSearch Examples
print_section("2. RediSearch Examples")

try:
    # Create index
    r.execute_command('FT.CREATE', 'idx:users', 'ON', 'HASH', 'PREFIX', '1', 'user:',
                      'SCHEMA', 'name', 'TEXT', 'SORTABLE',
                      'age', 'NUMERIC', 'SORTABLE',
                      'email', 'TEXT', 'NOINDEX',
                      'city', 'TAG', 'SORTABLE')
    print("Created RediSearch index for users")
    
    # Add documents
    r.hset('user:1001', mapping={
        'name': 'Alice Smith',
        'age': '25',
        'email': 'alice@example.com',
        'city': 'Boston'
    })
    
    r.hset('user:1002', mapping={
        'name': 'Bob Johnson',
        'age': '35',
        'email': 'bob@example.com',
        'city': 'New York'
    })
    
    r.hset('user:1003', mapping={
        'name': 'Carol Williams',
        'age': '28',
        'email': 'carol@example.com',
        'city': 'Boston'
    })
    
    print("Added sample users")
    
    # Wait for indexing
    time.sleep(1)
    
    # Search examples
    # Simple text search
    result = r.execute_command('FT.SEARCH', 'idx:users', 'Alice')
    print(f"Search for 'Alice': {result}")
    
    # Numeric range search
    result = r.execute_command('FT.SEARCH', 'idx:users', '@age:[25 30]')
    print(f"Users aged 25-30: {result}")
    
    # Tag search
    result = r.execute_command('FT.SEARCH', 'idx:users', '@city:{Boston}')
    print(f"Users in Boston: {result}")
    
    # Sorted search
    result = r.execute_command('FT.SEARCH', 'idx:users', '*', 'SORTBY', 'age', 'ASC')
    print(f"All users sorted by age: {result}")
    
    # Aggregation
    result = r.execute_command('FT.AGGREGATE', 'idx:users', '*',
                               'GROUPBY', '1', '@city',
                               'REDUCE', 'COUNT', '0', 'AS', 'count')
    print(f"User count by city: {result}")
    
except redis.exceptions.ResponseError as e:
    if "unknown command" in str(e):
        print("RediSearch not available")
    else:
        print(f"RediSearch error: {e}")
except Exception as e:
    print(f"Error with RediSearch: {e}")

# 3. RedisTimeSeries Examples
print_section("3. RedisTimeSeries Examples")

try:
    # Create time series
    r.execute_command('TS.CREATE', 'sensor:temp:1', 'RETENTION', 86400000, 'LABELS', 'sensor_id', '1', 'type', 'temperature')
    r.execute_command('TS.CREATE', 'sensor:temp:2', 'RETENTION', 86400000, 'LABELS', 'sensor_id', '2', 'type', 'temperature')
    print("Created time series for temperature sensors")
    
    # Add data points
    now = int(time.time() * 1000)  # RedisTimeSeries uses milliseconds
    for i in range(10):
        timestamp = now + (i * 60000)  # 1 minute intervals
        r.execute_command('TS.ADD', 'sensor:temp:1', timestamp, 20 + (i % 5))
        r.execute_command('TS.ADD', 'sensor:temp:2', timestamp, 22 + (i % 3))
    
    print("Added temperature readings")
    
    # Get recent data
    data = r.execute_command('TS.RANGE', 'sensor:temp:1', now, now + 300000)
    print(f"Recent temperature data for sensor 1: {data}")
    
    # Get average
    avg = r.execute_command('TS.MRANGE', now, now + 300000, 'AGGREGATION', 'avg', 60000, 'FILTER', 'type=temperature')
    print(f"Average temperatures: {avg}")
    
    # Get last data point
    last = r.execute_command('TS.GET', 'sensor:temp:1')
    print(f"Latest reading for sensor 1: {last}")
    
except redis.exceptions.ResponseError as e:
    if "unknown command" in str(e):
        print("RedisTimeSeries not available")
    else:
        print(f"RedisTimeSeries error: {e}")
except Exception as e:
    print(f"Error with RedisTimeSeries: {e}")

# 4. RedisBloom Examples
print_section("4. RedisBloom Examples")

try:
    # Create Bloom Filter
    r.execute_command('BF.RESERVE', 'bf:emails', 0.01, 1000)
    print("Created Bloom Filter for emails")
    
    # Add items
    emails = ['alice@example.com', 'bob@example.com', 'charlie@example.com']
    for email in emails:
        r.execute_command('BF.ADD', 'bf:emails', email)
    
    print("Added emails to Bloom Filter")
    
    # Check membership
    test_emails = ['alice@example.com', 'unknown@example.com', 'bob@example.com']
    for email in test_emails:
        exists = r.execute_command('BF.EXISTS', 'bf:emails', email)
        print(f"Email {email} exists: {exists}")
    
    # Create Cuckoo Filter
    r.execute_command('CF.RESERVE', 'cf:users', 1000)
    print("Created Cuckoo Filter for users")
    
    # Add items to Cuckoo Filter
    users = ['user1', 'user2', 'user3']
    for user in users:
        r.execute_command('CF.ADD', 'cf:users', user)
    
    print("Added users to Cuckoo Filter")
    
    # Check membership
    test_users = ['user1', 'unknown_user', 'user2']
    for user in test_users:
        exists = r.execute_command('CF.EXISTS', 'cf:users', user)
        print(f"User {user} exists: {exists}")
    
    # Create Top-K
    r.execute_command('TOPK.RESERVE', 'topk:searches', 5, 2000, 7, 0.925)
    print("Created Top-K for searches")
    
    # Add items
    searches = ['python', 'redis', 'database', 'python', 'machine learning', 'redis', 'python', 'ai']
    for search in searches:
        r.execute_command('TOPK.ADD', 'topk:searches', search)
    
    print("Added search terms to Top-K")
    
    # Get top items
    top_items = r.execute_command('TOPK.LIST', 'topk:searches')
    print(f"Top search terms: {top_items}")
    
except redis.exceptions.ResponseError as e:
    if "unknown command" in str(e):
        print("RedisBloom not available")
    else:
        print(f"RedisBloom error: {e}")
except Exception as e:
    print(f"Error with RedisBloom: {e}")

# 5. RedisGraph Examples
print_section("5. RedisGraph Examples")

try:
    # Create a graph
    # Add nodes and relationships
    query = """
    CREATE (alice:Person {name: 'Alice', age: 30}),
           (bob:Person {name: 'Bob', age: 25}),
           (charlie:Person {name: 'Charlie', age: 35}),
           (company:Company {name: 'TechCorp'}),
           (alice)-[:WORKS_AT]->(company),
           (bob)-[:WORKS_AT]->(company),
           (alice)-[:FRIENDS_WITH]->(bob),
           (alice)-[:FRIENDS_WITH]->(charlie)
    """
    result = r.execute_command('GRAPH.QUERY', 'social_graph', query)
    print("Created social graph")
    
    # Query the graph
    query = """
    MATCH (p:Person)-[:WORKS_AT]->(c:Company {name: 'TechCorp'})
    RETURN p.name, p.age
    """
    result = r.execute_command('GRAPH.QUERY', 'social_graph', query)
    print(f"People working at TechCorp: {result}")
    
    # Find friends of Alice
    query = """
    MATCH (alice:Person {name: 'Alice'})-[:FRIENDS_WITH]->(friend)
    RETURN friend.name
    """
    result = r.execute_command('GRAPH.QUERY', 'social_graph', query)
    print(f"Alice's friends: {result}")
    
    # Find friends of friends
    query = """
    MATCH (alice:Person {name: 'Alice'})-[:FRIENDS_WITH]->(friend)-[:FRIENDS_WITH]->(fof)
    RETURN alice.name, friend.name, fof.name
    """
    result = r.execute_command('GRAPH.QUERY', 'social_graph', query)
    print(f"Friends of friends: {result}")
    
except redis.exceptions.ResponseError as e:
    if "unknown command" in str(e):
        print("RedisGraph not available")
    else:
        print(f"RedisGraph error: {e}")
except Exception as e:
    print(f"Error with RedisGraph: {e}")

# 6. RedisAI Examples
print_section("6. RedisAI Examples")

try:
    # Note: RedisAI requires models to be loaded, which is complex to demonstrate
    # This is a conceptual example
    
    # Load a model (this would typically be done with a pre-trained model file)
    # r.execute_command('AI.MODELSET', 'model1', 'TF', 'CPU', 'INPUTS', 'input', 'OUTPUTS', 'output', model_blob)
    
    # Create tensor
    # r.execute_command('AI.TENSORSET', 'tensor1', 'FLOAT', 2, 3, 'VALUES', 1, 2, 3, 4, 5, 6)
    
    # Run model
    # r.execute_command('AI.MODELRUN', 'model1', 'INPUTS', 'tensor1', 'OUTPUTS', 'output_tensor')
    
    print("RedisAI examples (conceptual - requires pre-trained models)")
    
except redis.exceptions.ResponseError as e:
    if "unknown command" in str(e):
        print("RedisAI not available")
    else:
        print(f"RedisAI error: {e}")
except Exception as e:
    print(f"Error with RedisAI: {e}")

# 7. Module Information and Management
print_section("7. Module Information and Management")

try:
    # List loaded modules
    modules = r.execute_command('MODULE LIST')
    print(f"Loaded modules: {modules}")
    
    # Get module information
    for module in modules:
        module_name = module[1].decode() if isinstance(module[1], bytes) else module[1]
        try:
            info = r.execute_command(f'MODULE LOADEXEC {module_name}')
            print(f"Module {module_name} info: {info}")
        except:
            print(f"Could not get detailed info for module {module_name}")
    
except redis.exceptions.ResponseError as e:
    print(f"Module management error: {e}")
except Exception as e:
    print(f"Error with module management: {e}")

# 8. Performance Comparison
print_section("8. Performance Comparison")

# Standard Redis vs RedisJSON
def performance_test():
    # Standard Redis Hash
    start_time = time.time()
    for i in range(1000):
        r.hset(f'user:std:{i}', mapping={
            'name': f'User {i}',
            'age': i % 100,
            'email': f'user{i}@example.com'
        })
    std_time = time.time() - start_time
    
    # RedisJSON
    try:
        start_time = time.time()
        for i in range(1000):
            user_data = {
                'name': f'User {i}',
                'age': i % 100,
                'email': f'user{i}@example.com'
            }
            r.execute_command('JSON.SET', f'user:json:{i}', '$', json.dumps(user_data))
        json_time = time.time() - start_time
        
        print(f"Standard Redis Hash time: {std_time:.4f}s")
        print(f"RedisJSON time: {json_time:.4f}s")
        print(f"RedisJSON is {json_time/std_time:.2f}x slower/faster")
        
    except:
        print("RedisJSON not available for performance test")

performance_test()

# 9. Error Handling and Best Practices
print_section("9. Error Handling and Best Practices")

def safe_module_operation(operation, *args):
    """Safely execute Redis module operations with error handling"""
    try:
        result = r.execute_command(operation, *args)
        return result, None
    except redis.exceptions.ResponseError as e:
        if "unknown command" in str(e):
            return None, f"Module not available: {operation}"
        else:
            return None, f"Redis error: {e}"
    except Exception as e:
        return None, f"Unexpected error: {e}"

# Example usage
result, error = safe_module_operation('JSON.SET', 'safe:test', '$', '{"test": "value"}')
if error:
    print(f"Operation failed: {error}")
else:
    print(f"Operation succeeded: {result}")

# 10. Integration Example
print_section("10. Integration Example")

def create_smart_cache():
    """Create a smart caching system using multiple Redis modules"""
    try:
        # Use RedisJSON for structured cache data
        cache_data = {
            "data": "cached_value",
            "metadata": {
                "created": datetime.now().isoformat(),
                "hits": 0,
                "ttl": 3600
            },
            "tags": ["cache", "demo"]
        }
        
        r.execute_command('JSON.SET', 'cache:item:1', '$', json.dumps(cache_data))
        
        # Use Bloom Filter to track cached keys
        r.execute_command('BF.ADD', 'bf:cache_keys', 'cache:item:1')
        
        # Use TimeSeries to track cache performance
        timestamp = int(time.time() * 1000)
        r.execute_command('TS.ADD', 'ts:cache_hits', timestamp, 1)
        
        print("Created smart cache with integrated modules")
        
        # Retrieve and update cache
        cached_value = r.execute_command('JSON.GET', 'cache:item:1', '$.data')
        print(f"Cached value: {cached_value}")
        
        # Update hit counter
        r.execute_command('JSON.NUMINCRBY', 'cache:item:1', '$.metadata.hits', 1)
        hits = r.execute_command('JSON.GET', 'cache:item:1', '$.metadata.hits')
        print(f"Cache hits: {hits}")
        
    except Exception as e:
        print(f"Smart cache creation failed: {e}")

create_smart_cache()

print("\n" + "="*60)
print("Redis Modules Examples Completed!")
print("="*60)
print("\nNote: Many Redis modules require separate installation and loading.")
print("Make sure to install required modules for full functionality:")
print("- RedisJSON: For native JSON support")
print("- RediSearch: For advanced querying")
print("- RedisTimeSeries: For time series data")
print("- RedisBloom: For probabilistic data structures")
print("- RedisGraph: For graph databases")
print("- RedisAI: For machine learning")