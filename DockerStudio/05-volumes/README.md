# 第5章：数据持久化

## 学习目标

- 理解 Docker 存储类型
- 掌握卷的创建和管理
- 学会数据备份和恢复

## 存储类型

Docker 有三种主要的数据存储方式：

### 1. 卷 (Volumes) - 推荐

由 Docker 管理，存储在主机文件系统的特定位置。

```bash
# 创建卷
docker volume create myvolume

# 使用卷
docker run -d --name db -v myvolume:/var/lib/mysql mysql:8.0

# 查看卷
docker volume ls

# 查看卷详情
docker volume inspect myvolume

# 删除卷
docker volume rm myvolume
```

### 2. 绑定挂载 (Bind Mounts)

直接挂载主机目录或文件到容器。

```bash
# 挂载主机目录
docker run -d \
  -v /host/path:/container/path \
  nginx

# 或使用 --mount (更明确)
docker run -d \
  --mount type=bind,source=/host/path,target=/container/path \
  nginx

# 只读挂载
docker run -d \
  -v /host/path:/container/path:ro \
  nginx
```

### 3. tmpfs 挂载

存储在主机内存中，容器停止时数据丢失。

```bash
# 创建 tmpfs 挂载
docker run -d \
  --tmpfs /tmp \
  nginx

# 或使用 --mount
docker run -d \
  --mount type=tmpfs,target=/tmp,tmpfs-size=100m \
  nginx
```

## 卷管理

### 创建和使用卷

```bash
# 创建命名卷
docker volume create \
  --driver local \
  --label project=myapp \
  mydata

# 使用卷启动容器
docker run -d \
  --name app \
  -v mydata:/app/data \
  myapp:latest

# 多个容器共享卷
docker run -d --name app1 -v shared-data:/data nginx
docker run -d --name app2 -v shared-data:/data nginx
```

### 查看和检查

```bash
# 列出所有卷
docker volume ls

# 查看卷详细信息
docker volume inspect mydata

# 查看卷使用情况
docker system df -v
```

### 清理卷

```bash
# 删除未使用的卷
docker volume prune

# 删除所有卷（危险！）
docker volume prune -a

# 删除特定卷
docker volume rm mydata
```

## 实践示例

### 示例 1: MySQL 数据持久化

```bash
#!/bin/bash

echo "=== MySQL 数据持久化示例 ==="

# 创建卷
docker volume create mysql-data

# 启动 MySQL
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=testdb \
  -v mysql-data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:8.0

echo "等待 MySQL 启动..."
sleep 20

# 创建测试数据
docker exec mysql mysql -uroot -ppassword testdb -e "
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO users (name, email) VALUES 
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com');
"

echo "查看数据："
docker exec mysql mysql -uroot -ppassword testdb -e "SELECT * FROM users;"

# 停止并删除容器
echo -e "\n停止容器..."
docker stop mysql
docker rm mysql

# 使用相同卷重新启动
echo -e "\n使用相同卷重新启动..."
docker run -d \
  --name mysql-new \
  -e MYSQL_ROOT_PASSWORD=password \
  -v mysql-data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:8.0

sleep 20

# 验证数据仍然存在
echo -e "\n验证数据持久化："
docker exec mysql-new mysql -uroot -ppassword testdb -e "SELECT * FROM users;"

echo -e "\n✅ 数据持久化成功！"
```

### 示例 2: Web 应用开发环境

```bash
#!/bin/bash

# 创建项目目录
mkdir -p ~/my-web-app

# 创建示例文件
cat > ~/my-web-app/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>My Web App</title>
</head>
<body>
    <h1>Hello from Docker!</h1>
    <p>This file is mounted from the host.</p>
</body>
</html>
EOF

# 运行 Nginx，挂载项目目录
docker run -d \
  --name dev-server \
  -v ~/my-web-app:/usr/share/nginx/html:ro \
  -p 8080:80 \
  nginx:alpine

echo "开发服务器运行在 http://localhost:8080"
echo "修改 ~/my-web-app/index.html 会立即生效"

# 测试
sleep 2
curl http://localhost:8080
```

### 示例 3: 数据备份和恢复

```bash
#!/bin/bash

echo "=== 数据备份和恢复 ==="

# 创建卷和数据
docker volume create backup-demo
docker run -v backup-demo:/data alpine sh -c "echo 'Important Data' > /data/file.txt"

# 备份卷
echo "备份数据..."
docker run --rm \
  -v backup-demo:/source:ro \
  -v $(pwd):/backup \
  alpine tar czf /backup/backup.tar.gz -C /source .

echo "备份文件: $(pwd)/backup.tar.gz"

# 删除原卷
docker volume rm backup-demo

# 创建新卷并恢复
echo "恢复数据..."
docker volume create backup-demo-restored
docker run --rm \
  -v backup-demo-restored:/target \
  -v $(pwd):/backup \
  alpine sh -c "cd /target && tar xzf /backup/backup.tar.gz"

# 验证恢复
echo "验证恢复的数据："
docker run --rm -v backup-demo-restored:/data alpine cat /data/file.txt

echo "✅ 备份和恢复完成"
```

## 最佳实践

### 1. 使用命名卷

❌ 不好：
```bash
docker run -v /var/lib/mysql mysql
```

✅ 好：
```bash
docker volume create mysql-data
docker run -v mysql-data:/var/lib/mysql mysql
```

### 2. 数据目录规划

```bash
# 应用数据
docker volume create app-data

# 配置文件
docker volume create app-config

# 日志文件
docker volume create app-logs

docker run -d \
  -v app-data:/app/data \
  -v app-config:/app/config:ro \
  -v app-logs:/app/logs \
  myapp
```

### 3. 定期备份

创建 `backup.sh`:
```bash
#!/bin/bash

BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d-%H%M%S)

# 备份所有卷
for volume in $(docker volume ls -q); do
    echo "备份卷: $volume"
    docker run --rm \
        -v $volume:/source:ro \
        -v $BACKUP_DIR:/backup \
        alpine tar czf /backup/${volume}-${DATE}.tar.gz -C /source .
done

# 清理30天前的备份
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete
```

## 卷驱动

### 本地驱动（默认）

```bash
docker volume create --driver local myvolume
```

### NFS 卷

```bash
docker volume create \
  --driver local \
  --opt type=nfs \
  --opt o=addr=192.168.1.100,rw \
  --opt device=:/path/to/dir \
  nfs-volume
```

## 故障排查

### 查看卷位置

```bash
# 查看卷的实际位置
docker volume inspect myvolume | grep Mountpoint

# 在主机上查看（需要 root 权限）
sudo ls -la /var/lib/docker/volumes/myvolume/_data
```

### 检查卷权限

```bash
# 查看卷内容和权限
docker run --rm -v myvolume:/data alpine ls -la /data

# 修改权限
docker run --rm -v myvolume:/data alpine chown -R 1000:1000 /data
```

### 卷被占用无法删除

```bash
# 查看使用该卷的容器
docker ps -a --filter volume=myvolume

# 停止并删除容器
docker rm -f container_name

# 然后删除卷
docker volume rm myvolume
```

## 数据迁移

### 容器间数据迁移

```bash
# 从旧容器复制到新容器
docker run --rm \
  --volumes-from old-container \
  -v new-volume:/backup \
  alpine sh -c "cp -a /data/. /backup/"
```

### 主机到容器

```bash
# 复制文件到卷
docker run --rm \
  -v myvolume:/target \
  -v $(pwd):/source \
  alpine cp -r /source/data /target/
```

## 练习任务

1. **基础操作**：
   - 创建卷并启动容器
   - 在容器中创建文件
   - 删除容器，用新容器挂载相同卷，验证数据

2. **绑定挂载**：
   - 创建本地目录
   - 挂载到 Nginx 容器
   - 修改本地文件，观察容器变化

3. **数据备份**：
   - 创建包含数据的卷
   - 备份到 tar 文件
   - 恢复到新卷

4. **共享卷**：
   - 创建共享卷
   - 启动多个容器使用同一卷
   - 测试数据共享

## 实践脚本

保存为 `volume-demo.sh`:
```bash
#!/bin/bash

echo "=== 数据持久化练习 ==="

# 1. 创建卷
echo -e "\n1. 创建和使用卷"
docker volume create test-vol
docker run --rm -v test-vol:/data alpine sh -c "echo 'Hello' > /data/test.txt"
docker run --rm -v test-vol:/data alpine cat /data/test.txt

# 2. 绑定挂载
echo -e "\n2. 绑定挂载测试"
mkdir -p /tmp/docker-test
echo "Local file" > /tmp/docker-test/local.txt
docker run --rm -v /tmp/docker-test:/mount alpine cat /mount/local.txt

# 3. 备份和恢复
echo -e "\n3. 数据备份"
docker run --rm -v test-vol:/source -v /tmp:/backup alpine \
  tar czf /backup/test-vol-backup.tar.gz -C /source .
ls -lh /tmp/test-vol-backup.tar.gz

# 清理
docker volume rm test-vol
rm -rf /tmp/docker-test /tmp/test-vol-backup.tar.gz

echo -e "\n=== 练习完成 ==="
```

## 下一步

完成本章后，继续学习第6章：Docker Compose。
