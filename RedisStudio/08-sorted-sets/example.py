#!/usr/bin/env python3
"""
Redis Sorted Sets Examples
This script demonstrates various sorted set operations in Redis.
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
    
    print("\n=== Redis Sorted Sets Examples ===\n")
    
    # 1. Basic Sorted Set Operations
    print("--- 1. Basic Sorted Set Operations ---")
    
    # Add members with scores
    r.zadd('game_scores', {'Alice': 1500, 'Bob': 1200, 'Charlie': 1800, 'Diana': 900})
    print("Added players to game_scores sorted set")
    
    # Get all members with scores
    members_with_scores = r.zrange('game_scores', 0, -1, withscores=True)
    print(f"All players with scores: {members_with_scores}")
    
    # Get members in descending order
    members_desc = r.zrevrange('game_scores', 0, -1, withscores=True)
    print(f"Players in descending order: {members_desc}")
    
    # Get score of specific member
    alice_score = r.zscore('game_scores', 'Alice')
    print(f"Alice's score: {alice_score}")
    
    # Get rank of member (0-based)
    alice_rank = r.zrank('game_scores', 'Alice')
    print(f"Alice's rank (0-based): {alice_rank}")
    
    # Get reverse rank of member
    alice_rev_rank = r.zrevrank('game_scores', 'Alice')
    print(f"Alice's reverse rank (0-based): {alice_rev_rank}")
    
    # 2. Sorted Set Cardinality and Membership
    print("\n--- 2. Sorted Set Cardinality and Membership ---")
    
    # Get size of sorted set
    size = r.zcard('game_scores')
    print(f"Total players: {size}")
    
    # Count members within score range
    count = r.zcount('game_scores', 1000, 2000)
    print(f"Players with scores between 1000-2000: {count}")
    
    # Check if member exists
    exists = r.zscore('game_scores', 'Bob') is not None
    print(f"Does Bob exist? {exists}")
    
    # 3. Sorted Set Modifications
    print("\n--- 3. Sorted Set Modifications ---")
    
    # Increment score of existing member
    new_score = r.zincrby('game_scores', 200, 'Bob')
    print(f"Bob's new score after incrementing by 200: {new_score}")
    
    # Add new member
    r.zadd('game_scores', {'Eve': 1600})
    print("Added Eve with score 1600")
    
    # Update score of existing member
    r.zadd('game_scores', {'Diana': 1100})
    print("Updated Diana's score to 1100")
    
    # Remove member
    removed = r.zrem('game_scores', 'Charlie')
    print(f"Removed Charlie: {removed > 0}")
    
    # 4. Range Queries
    print("\n--- 4. Range Queries ---")
    
    # Get members by rank range
    top_3 = r.zrevrange('game_scores', 0, 2, withscores=True)
    print(f"Top 3 players: {top_3}")
    
    # Get members by score range
    high_scorers = r.zrangebyscore('game_scores', 1500, float('inf'), withscores=True)
    print(f"Players with score >= 1500: {high_scorers}")
    
    # Get members by score range with limit
    limited_high_scorers = r.zrangebyscore('game_scores', 1000, float('inf'), start=0, num=2, withscores=True)
    print(f"Top 2 players with score >= 1000: {limited_high_scorers}")
    
    # 5. Lexicographical Sorted Sets
    print("\n--- 5. Lexicographical Sorted Sets ---")
    
    # Create lexicographical sorted set (all scores are 0)
    r.zadd('lex_set', {'apple': 0, 'banana': 0, 'cherry': 0, 'date': 0, 'elderberry': 0})
    print("Created lexicographical sorted set")
    
    # Get members in lex range
    lex_range = r.zrangebylex('lex_set', '[b', '[d')
    print(f"Lexicographical range [b, d]: {lex_range}")
    
    # Count members in lex range
    lex_count = r.zlexcount('lex_set', '[a', '[c')
    print(f"Count of members in lex range [a, c]: {lex_count}")
    
    # Remove members in lex range
    lex_removed = r.zremrangebylex('lex_set', '(c', '[e')
    print(f"Removed {lex_removed} members in lex range (c, e]")
    
    # 6. Set Operations
    print("\n--- 6. Set Operations ---")
    
    # Create another sorted set
    r.zadd('game_scores_2', {'Alice': 1400, 'Frank': 1300, 'Grace': 1700, 'Henry': 1000})
    print("Created second game scores set")
    
    # Intersect sorted sets
    r.zinterstore('common_players', ['game_scores', 'game_scores_2'])
    common_players = r.zrange('common_players', 0, -1, withscores=True)
    print(f"Common players (intersection): {common_players}")
    
    # Union sorted sets
    r.zunionstore('all_players', ['game_scores', 'game_scores_2'])
    all_players = r.zrange('all_players', 0, -1, withscores=True)
    print(f"All players (union): {all_players}")
    
    # 7. Advanced Sorted Set Operations
    print("\n--- 7. Advanced Sorted Set Operations ---")
    
    # Pop member with highest score
    popped_max = r.zpopmax('game_scores')
    print(f"Popped member with highest score: {popped_max}")
    
    # Pop member with lowest score
    popped_min = r.zpopmin('game_scores')
    print(f"Popped member with lowest score: {popped_min}")
    
    # Get random member
    random_member = r.zrandmember('game_scores', 1, withscores=True)
    print(f"Random member: {random_member}")
    
    # 8. Practical Example: Leaderboard Implementation
    print("\n--- 8. Practical Example: Leaderboard Implementation ---")
    
    # Simulate game leaderboard updates
    leaderboard_key = 'game_leaderboard'
    
    # Add initial scores
    players = {
        'Player1': 1200, 'Player2': 1500, 'Player3': 900,
        'Player4': 1800, 'Player5': 1100, 'Player6': 1300
    }
    r.zadd(leaderboard_key, players)
    print("Initialized game leaderboard")
    
    # Display top 5 players
    top_players = r.zrevrange(leaderboard_key, 0, 4, withscores=True)
    print("Top 5 players:")
    for i, (player, score) in enumerate(top_players, 1):
        print(f"  {i}. {player}: {int(score)} points")
    
    # Update player score
    r.zincrby(leaderboard_key, 300, 'Player3')
    print("\nUpdated Player3's score (+300)")
    
    # Check new ranking
    player3_rank = r.zrevrank(leaderboard_key, 'Player3')
    player3_score = r.zscore(leaderboard_key, 'Player3')
    print(f"Player3 is now rank {player3_rank + 1} with {int(player3_score)} points")
    
    # 9. Practical Example: Time-series Data
    print("\n--- 9. Practical Example: Time-series Data ---")
    
    # Simulate timestamped events (using current time as score)
    event_key = 'user_events'
    current_time = int(time.time())
    
    # Add events with timestamps
    events = {
        f"user1:{current_time}": current_time,
        f"user2:{current_time + 10}": current_time + 10,
        f"user1:{current_time + 20}": current_time + 20,
        f"user3:{current_time + 30}": current_time + 30
    }
    r.zadd(event_key, events)
    print("Added timestamped events")
    
    # Get events in time range (last 60 seconds)
    recent_events = r.zrangebyscore(event_key, current_time - 60, current_time + 60)
    print(f"Recent events: {recent_events}")
    
    # Remove old events (older than 30 seconds)
    old_events_removed = r.zremrangebyscore(event_key, 0, current_time - 30)
    print(f"Removed {old_events_removed} old events")
    
    # 10. Memory and Performance Information
    print("\n--- 10. Memory and Performance Information ---")
    
    # Get memory usage
    memory_usage = r.memory_usage('game_scores')
    print(f"Memory usage of game_scores: {memory_usage} bytes")
    
    # Clean up example keys
    r.delete('game_scores', 'game_scores_2', 'common_players', 'all_players', 
             'lex_set', 'game_leaderboard', 'user_events')
    print("Cleaned up example keys")
    
    print("\n=== End of Redis Sorted Sets Examples ===")

if __name__ == "__main__":
    main()