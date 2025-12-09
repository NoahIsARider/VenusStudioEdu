import redis
import json
import time
from datetime import datetime, timedelta

# Redis Backup and Restore Practice Exercises
# This script contains hands-on exercises for practicing Redis backup and restore techniques

def connect_redis():
    """Establish connection to Redis"""
    try:
        r = redis.Redis(
            host='localhost',
            port=6379,
            db=0,
            decode_responses=True
        )
        r.ping()
        print("Connected to Redis successfully")
        return r
    except Exception as e:
        print(f"Error connecting to Redis: {e}")
        return None

# Exercise 1: RDB Backup Strategy Implementation
# Task: Design and implement an RDB backup strategy for a web application
# Requirements:
# 1. Configure appropriate save points based on data change frequency
# 2. Implement a backup rotation scheme
# 3. Verify backup integrity

def exercise_rdb_strategy(r):
    """Exercise 1: RDB Backup Strategy Implementation"""
    print("\n=== Exercise 1: RDB Backup Strategy Implementation ===")
    
    # Your implementation here:
    # 1. Configure save points (e.g., every 5 minutes if 100+ keys changed)
    # 2. Create a function to check last save time
    # 3. Implement backup file rotation logic
    
    # Sample implementation outline:
    """
    # Configure save points
    r.config_set('save', '900 1 300 10 60 10000')
    
    # Check last save time
    last_save = r.lastsave()
    print(f"Last save: {datetime.fromtimestamp(last_save)}")
    
    # Simulate data changes
    for i in range(100):
        r.set(f"user:{i}", f"data_{i}")
    
    # Trigger save if needed
    # Implement your logic here
    """

# Exercise 2: AOF Persistence Configuration
# Task: Configure AOF persistence for maximum data durability
# Requirements:
# 1. Enable AOF with appropriate fsync policy
# 2. Implement AOF rewrite scheduling
# 3. Monitor AOF file growth

def exercise_aof_configuration(r):
    """Exercise 2: AOF Persistence Configuration"""
    print("\n=== Exercise 2: AOF Persistence Configuration ===")
    
    # Your implementation here:
    # 1. Enable AOF persistence
    # 2. Set fsync policy to 'always' for maximum durability
    # 3. Schedule periodic AOF rewrites
    
    # Sample implementation outline:
    """
    # Enable AOF
    r.config_set('appendonly', 'yes')
    
    # Set fsync policy
    r.config_set('appendfsync', 'always')
    
    # Add sample data
    for i in range(50):
        r.hset('metrics', f"metric_{i}", f"value_{i}")
    
    # Trigger AOF rewrite
    r.bgrewriteaof()
    
    # Monitor AOF status
    info = r.info('persistence')
    print(f"AOF enabled: {info.get('aof_enabled')}")
    """

# Exercise 3: Selective Data Backup
# Task: Implement selective backup for specific data patterns
# Requirements:
# 1. Identify critical data keys using pattern matching
# 2. Export only critical data using DUMP/RESTORE
# 3. Verify selective backup integrity

def exercise_selective_backup(r):
    """Exercise 3: Selective Data Backup"""
    print("\n=== Exercise 3: Selective Data Backup ===")
    
    # Prepare sample data
    critical_data = {
        'user:1001': {'name': 'Alice', 'role': 'admin', 'last_login': str(datetime.now())},
        'user:1002': {'name': 'Bob', 'role': 'user', 'last_login': str(datetime.now())},
        'config:app_settings': {'theme': 'dark', 'notifications': True, 'language': 'en'},
        'session:xyz789': {'user_id': 1001, 'ip': '192.168.1.100'}
    }
    
    non_critical_data = {
        'cache:temp_data': 'temporary cache value',
        'log:debug_info': 'debugging information',
        'stats:page_views': '12345'
    }
    
    # Add sample data to Redis
    for key, value in critical_data.items():
        if isinstance(value, dict):
            r.hset(key, mapping=value)
        else:
            r.set(key, value)
    
    for key, value in non_critical_data.items():
        r.set(key, value)
    
    # Your implementation here:
    # 1. Identify critical data keys (user:* and config:*)
    # 2. Export only critical data using DUMP command
    # 3. Clear database and restore only critical data
    
    # Sample implementation outline:
    """
    # Find critical keys
    critical_keys = r.keys('user:*') + r.keys('config:*')
    print(f"Critical keys identified: {critical_keys}")
    
    # Export critical data
    exported_data = {}
    for key in critical_keys:
        exported_data[key] = r.dump(key)
    
    # Clear database
    r.flushdb()
    
    # Restore critical data
    for key, data in exported_data.items():
        if data:
            r.restore(key, 0, data)
    
    # Verify restoration
    restored_keys = r.keys('*')
    print(f"Restored keys: {restored_keys}")
    """

# Exercise 4: Backup Verification System
# Task: Create a comprehensive backup verification system
# Requirements:
# 1. Implement checksum validation for backup files
# 2. Create data integrity checks
# 3. Generate backup reports

def exercise_backup_verification(r):
    """Exercise 4: Backup Verification System"""
    print("\n=== Exercise 4: Backup Verification System ===")
    
    # Add test data
    test_data = {
        'verification:test1': 'data_for_verification_1',
        'verification:test2': {'field1': 'value1', 'field2': 'value2'},
        'verification:test3': json.dumps({'json': 'data', 'number': 42})
    }
    
    for key, value in test_data.items():
        if isinstance(value, dict):
            r.hset(key, mapping=value)
        else:
            r.set(key, value)
    
    # Your implementation here:
    # 1. Create a function to generate data checksums
    # 2. Implement pre-backup and post-restore verification
    # 3. Generate a backup verification report
    
    # Sample implementation outline:
    """
    import hashlib
    
    def generate_data_checksum(r):
        # Get all keys and their values
        keys = sorted(r.keys('*'))
        data_string = ""
        
        for key in keys:
            key_type = r.type(key)
            if key_type == 'string':
                data_string += f"{key}:{r.get(key)}|"
            elif key_type == 'hash':
                data_string += f"{key}:{dict(r.hgetall(key))}|"
        
        # Generate checksum
        return hashlib.md5(data_string.encode()).hexdigest()
    
    # Generate pre-backup checksum
    pre_backup_checksum = generate_data_checksum(r)
    print(f"Pre-backup checksum: {pre_backup_checksum}")
    
    # Perform backup (simulate)
    r.bgsave()
    time.sleep(3)  # Wait for backup
    
    # Clear and restore (simulate)
    r.flushdb()
    # In practice, you would restore from backup file here
    
    # Generate post-restore checksum
    # post_restore_checksum = generate_data_checksum(r)
    # print(f"Post-restore checksum: {post_restore_checksum}")
    # 
    # # Compare checksums
    # if pre_backup_checksum == post_restore_checksum:
    #     print("Backup verification successful!")
    # else:
    #     print("Backup verification failed!")
    """

# Exercise 5: Disaster Recovery Plan Testing
# Task: Implement and test a disaster recovery plan
# Requirements:
# 1. Simulate different failure scenarios
# 2. Implement automated recovery procedures
# 3. Test recovery time objectives (RTO)

def exercise_disaster_recovery(r):
    """Exercise 5: Disaster Recovery Plan Testing"""
    print("\n=== Exercise 5: Disaster Recovery Plan Testing ===")
    
    # Prepare test dataset
    for i in range(100):
        r.hset(f"customer:{i}", mapping={
            'name': f'Customer {i}',
            'email': f'customer{i}@example.com',
            'status': 'active' if i % 2 == 0 else 'inactive'
        })
    
    # Your implementation here:
    # 1. Simulate data loss scenario (flushdb)
    # 2. Implement recovery from latest backup
    # 3. Measure recovery time
    
    # Sample implementation outline:
    """
    import time
    
    # Record start time
    start_time = time.time()
    
    # Simulate disaster (data loss)
    print("Simulating data loss...")
    lost_keys_count = len(r.keys('*'))
    r.flushdb()
    print(f"Lost {lost_keys_count} keys")
    
    # Recovery process
    print("Starting recovery process...")
    # In practice, this would involve:
    # 1. Locating latest backup file
    # 2. Stopping Redis server
    # 3. Replacing current RDB file with backup
    # 4. Starting Redis server
    # 5. Verifying data restoration
    
    # Simulate recovery time
    recovery_time = time.time() - start_time
    print(f"Recovery completed in {recovery_time:.2f} seconds")
    
    # In a real implementation, you would verify data integrity here
    """

# Exercise 6: Incremental Backup Implementation
# Task: Design and implement an incremental backup solution
# Requirements:
# 1. Track data changes using keyspace notifications
# 2. Implement delta backup mechanism
# 3. Optimize storage for incremental backups

def exercise_incremental_backup(r):
    """Exercise 6: Incremental Backup Implementation"""
    print("\n=== Exercise 6: Incremental Backup Implementation ===")
    
    # Your implementation here:
    # 1. Enable keyspace notifications
    # 2. Track data changes
    # 3. Implement delta backup storage
    
    # Sample implementation outline:
    """
    # Enable keyspace notifications for all events
    r.config_set('notify-keyspace-events', 'AKE')
    
    # In a real implementation, you would:
    # 1. Use Redis pub/sub to listen for keyspace events
    # 2. Maintain a log of changes since last full backup
    # 3. Periodically save incremental changes
    
    # Example of subscribing to keyspace notifications:
    # pubsub = r.pubsub()
    # pubsub.psubscribe('__keyspace@0__:*')
    # 
    # for message in pubsub.listen():
    #     if message['type'] == 'pmessage':
    #         key = message['channel'].decode().replace('__keyspace@0__:', '')
    #         event = message['data'].decode()
    #         print(f"Key {key} was {event}")
    #         # Log this change for incremental backup
    """

# Exercise 7: Cross-Platform Backup Migration
# Task: Implement backup migration between different Redis installations
# Requirements:
# 1. Handle version compatibility issues
# 2. Manage data type differences
# 3. Validate migrated data integrity

def exercise_cross_platform_migration(r):
    """Exercise 7: Cross-Platform Backup Migration"""
    print("\n=== Exercise 7: Cross-Platform Backup Migration ===")
    
    # Prepare diverse dataset
    r.set('string_key', 'simple_string_value')
    r.lpush('list_key', 'item1', 'item2', 'item3')
    r.sadd('set_key', 'member1', 'member2', 'member3')
    r.hset('hash_key', mapping={'field1': 'value1', 'field2': 'value2'})
    r.zadd('zset_key', {'member1': 1.0, 'member2': 2.0, 'member3': 3.0})
    
    # Add complex data types if available
    try:
        r.execute_command('JSON.SET', 'json_key', '$', '{"name":"John","age":30}')
    except:
        print("RedisJSON module not available")
    
    # Your implementation here:
    # 1. Export data in a portable format
    # 2. Handle version/data type compatibility
    # 3. Import data to target Redis instance
    
    # Sample implementation outline:
    """
    def portable_export(r):
        # Export all data in a version-independent format
        all_keys = r.keys('*')
        export_data = {}
        
        for key in all_keys:
            key_type = r.type(key)
            if key_type == 'string':
                export_data[key] = {'type': 'string', 'value': r.get(key)}
            elif key_type == 'list':
                export_data[key] = {'type': 'list', 'value': r.lrange(key, 0, -1)}
            elif key_type == 'set':
                export_data[key] = {'type': 'set', 'value': list(r.smembers(key))}
            elif key_type == 'hash':
                export_data[key] = {'type': 'hash', 'value': r.hgetall(key)}
            elif key_type == 'zset':
                export_data[key] = {'type': 'zset', 'value': r.zrange(key, 0, -1, withscores=True)}
        
        return json.dumps(export_data)
    
    # Export data
    exported_json = portable_export(r)
    print("Data exported in portable format")
    
    # In a real implementation, you would:
    # 1. Save exported_json to a file
    # 2. Transfer to target system
    # 3. Parse and import on target Redis instance
    # 4. Handle any compatibility issues
    """

# Exercise 8: Backup Encryption and Security
# Task: Implement secure backup procedures with encryption
# Requirements:
# 1. Encrypt backup data before storage
# 2. Secure key management
# 3. Implement access controls for backups

def exercise_backup_security(r):
    """Exercise 8: Backup Encryption and Security"""
    print("\n=== Exercise 8: Backup Encryption and Security ===")
    
    # Your implementation here:
    # 1. Implement backup data encryption
    # 2. Secure key storage
    # 3. Access control for backup files
    
    # Sample implementation outline:
    """
    from cryptography.fernet import Fernet
    
    # Generate encryption key (in practice, use secure key management)
    key = Fernet.generate_key()
    cipher_suite = Fernet(key)
    
    # Export and encrypt data
    def encrypted_export(r):
        # Export data (similar to previous exercise)
        # ... export logic ...
        
        # Convert to JSON string
        data_json = json.dumps(export_data)
        
        # Encrypt data
        encrypted_data = cipher_suite.encrypt(data_json.encode())
        
        return encrypted_data, key
    
    # encrypted_backup, encryption_key = encrypted_export(r)
    # print("Backup data encrypted")
    
    # Store encryption_key securely (e.g., in a secrets manager)
    # Store encrypted_backup in secure location
    
    # For decryption:
    # decrypted_data = cipher_suite.decrypt(encrypted_backup)
    # restored_data = json.loads(decrypted_data.decode())
    """

# Exercise 9: Automated Backup Scheduling
# Task: Create a robust automated backup scheduling system
# Requirements:
# 1. Implement backup scheduling with cron-like functionality
# 2. Handle backup failures and retries
# 3. Send notifications for backup status

def exercise_backup_scheduling(r):
    """Exercise 9: Automated Backup Scheduling"""
    print("\n=== Exercise 9: Automated Backup Scheduling ===")
    
    # Your implementation here:
    # 1. Create backup scheduler
    # 2. Implement error handling and retry logic
    # 3. Add notification system
    
    # Sample implementation outline:
    """
    import schedule
    import time
    import smtplib
    from email.mime.text import MIMEText
    
    def perform_backup(r):
        try:
            print(f"Starting backup at {datetime.now()}")
            result = r.bgsave()
            
            if result:
                print("Backup initiated successfully")
                send_notification("Backup Successful", "Redis backup completed successfully")
            else:
                print("Backup initiation failed")
                send_notification("Backup Failed", "Redis backup failed to start")
                
        except Exception as e:
            print(f"Backup error: {e}")
            send_notification("Backup Error", f"Redis backup encountered an error: {e}")
    
    def send_notification(subject, message):
        # In a real implementation, send email or other notification
        print(f"Notification - {subject}: {message}")
    
    # Schedule backups
    # schedule.every().day.at("02:00").do(perform_backup, r)
    # schedule.every().hour.do(perform_backup, r)
    # 
    # # Keep scheduler running
    # while True:
    #     schedule.run_pending()
    #     time.sleep(60)
    """

# Exercise 10: Cloud Backup Integration
# Task: Integrate Redis backups with cloud storage services
# Requirements:
# 1. Implement cloud storage upload for backups
# 2. Handle network failures and retries
# 3. Implement backup lifecycle management

def exercise_cloud_backup(r):
    """Exercise 10: Cloud Backup Integration"""
    print("\n=== Exercise 10: Cloud Backup Integration ===")
    
    # Your implementation here:
    # 1. Implement cloud storage integration (AWS S3, Google Cloud Storage, etc.)
    # 2. Handle upload failures and retries
    # 3. Implement backup retention policies
    
    # Sample implementation outline:
    """
    import boto3
    from botocore.exceptions import ClientError
    
    def upload_to_s3(file_path, bucket_name, object_name):
        # Create S3 client
        s3_client = boto3.client('s3')
        
        try:
            # Upload file
            s3_client.upload_file(file_path, bucket_name, object_name)
            print(f"Successfully uploaded {object_name} to {bucket_name}")
            return True
        except ClientError as e:
            print(f"Error uploading to S3: {e}")
            return False
    
    def cloud_backup_workflow(r, bucket_name):
        # Perform RDB backup
        r.bgsave()
        time.sleep(5)  # Wait for backup completion
        
        # Get backup file path
        backup_dir = r.config_get('dir')['dir']
        rdb_filename = r.config_get('dbfilename')['dbfilename']
        backup_file_path = f"{backup_dir}/{rdb_filename}"
        
        # Upload to cloud
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        cloud_object_name = f"redis_backups/rdb_backup_{timestamp}.rdb"
        
        success = upload_to_s3(backup_file_path, bucket_name, cloud_object_name)
        
        if success:
            print("Cloud backup completed successfully")
        else:
            print("Cloud backup failed")
    
    # In practice, you would call:
    # cloud_backup_workflow(r, 'my-redis-backups-bucket')
    """

# Bonus Exercise: Enterprise-Grade Backup Solution
# Task: Design a comprehensive enterprise-grade backup solution
# Requirements:
# 1. Multi-tier backup strategy (full/incremental/differential)
# 2. Cross-region backup replication
# 3. Automated compliance reporting

def bonus_enterprise_backup(r):
    """Bonus Exercise: Enterprise-Grade Backup Solution"""
    print("\n=== Bonus Exercise: Enterprise-Grade Backup Solution ===")
    
    # Your implementation here:
    # 1. Implement multi-tier backup strategy
    # 2. Add cross-region replication
    # 3. Create compliance reporting
    
    # Sample implementation outline:
    """
    class EnterpriseBackupManager:
        def __init__(self, redis_client):
            self.r = redis_client
            self.backup_config = {
                'full_backup_schedule': 'daily',
                'incremental_backup_schedule': 'hourly',
                'differential_backup_schedule': 'weekly',
                'retention_policy': {
                    'full': 30,  # days
                    'incremental': 7,  # days
                    'differential': 30  # days
                },
                'regions': ['us-east-1', 'us-west-2', 'eu-central-1']
            }
        
        def perform_full_backup(self):
            # Implementation for full backup
            pass
            
        def perform_incremental_backup(self):
            # Implementation for incremental backup
            pass
            
        def perform_differential_backup(self):
            # Implementation for differential backup
            pass
            
        def replicate_to_regions(self, backup_file):
            # Implementation for cross-region replication
            pass
            
        def generate_compliance_report(self):
            # Implementation for compliance reporting
            pass
    
    # manager = EnterpriseBackupManager(r)
    # manager.perform_full_backup()
    """

# Main execution
if __name__ == "__main__":
    # Connect to Redis
    redis_client = connect_redis()
    
    if redis_client:
        # Run all exercises
        exercise_rdb_strategy(redis_client)
        exercise_aof_configuration(redis_client)
        exercise_selective_backup(redis_client)
        exercise_backup_verification(redis_client)
        exercise_disaster_recovery(redis_client)
        exercise_incremental_backup(redis_client)
        exercise_cross_platform_migration(redis_client)
        exercise_backup_security(redis_client)
        exercise_backup_scheduling(redis_client)
        exercise_cloud_backup(redis_client)
        bonus_enterprise_backup(redis_client)
        
        print("\n=== Redis Backup Practice Exercises Completed ===")
    else:
        print("Failed to connect to Redis. Please check your Redis server.")