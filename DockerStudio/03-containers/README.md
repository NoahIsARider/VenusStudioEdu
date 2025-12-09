# 第3章：容器操作

## 学习目标

- 掌握容器生命周期管理
- 理解容器资源限制
- 学会容器日志和监控

## 容器生命周期

```bash
# 创建容器（不启动）
docker create --name mycontainer nginx

# 启动容器
docker start mycontainer

# 停止容器
docker stop mycontainer

# 重启容器
docker restart mycontainer

# 暂停容器
docker pause mycontainer

# 恢复容器
docker unpause mycontainer

# 删除容器
docker rm mycontainer

# 强制删除运行中的容器
docker rm -f mycontainer
```

## 容器交互

### 进入运行中的容器

```bash
# 使用 exec（推荐）
docker exec -it container_name bash

# 或使用 sh（如果没有 bash）
docker exec -it container_name sh

# 执行单个命令
docker exec container_name ls -la /app

# 以 root 用户执行
docker exec -u root -it container_name bash
```

### 查看容器信息

```bash
# 列出运行中的容器
docker ps

# 列出所有容器（包括停止的）
docker ps -a

# 查看容器详细信息
docker inspect container_name

# 查看容器端口映射
docker port container_name

# 查看容器资源使用
docker stats container_name

# 查看容器进程
docker top container_name
```

## 容器日志

```bash
# 查看日志
docker logs container_name

# 实时跟踪日志
docker logs -f container_name

# 查看最后 100 行
docker logs --tail 100 container_name

# 显示时间戳
docker logs -t container_name

# 查看指定时间后的日志
docker logs --since 2024-01-01T00:00:00 container_name
```

## 资源限制

### 内存限制

```bash
# 限制内存为 512MB
docker run -m 512m nginx

# 内存 + Swap 限制
docker run -m 512m --memory-swap 1g nginx

# 内存预留
docker run --memory-reservation 256m nginx
```

### CPU 限制

```bash
# 限制 CPU 核心数（50% 的单核）
docker run --cpus 0.5 nginx

# 指定 CPU 核心
docker run --cpuset-cpus 0,1 nginx

# CPU 权重（相对值）
docker run --cpu-shares 512 nginx
```

### 完整示例

```bash
docker run -d \
  --name resource-limited \
  --memory 512m \
  --cpus 1.0 \
  --restart unless-stopped \
  nginx:alpine
```

## 容器网络模式

```bash
# 桥接模式（默认）
docker run --network bridge nginx

# 主机模式（使用宿主机网络）
docker run --network host nginx

# 无网络模式
docker run --network none nginx

# 容器模式（共享另一个容器的网络）
docker run --network container:other_container nginx
```

## 数据管理

### 临时挂载

```bash
# 挂载主机目录
docker run -v /host/path:/container/path nginx

# 只读挂载
docker run -v /host/path:/container/path:ro nginx

# 命名卷
docker run -v myvolume:/data nginx
```

### 容器间数据共享

```bash
# 创建数据容器
docker create -v /data --name datastore busybox

# 其他容器使用
docker run --volumes-from datastore nginx
```

## 容器重启策略

```bash
# 不自动重启
docker run --restart no nginx

# 总是重启
docker run --restart always nginx

# 失败时重启
docker run --restart on-failure nginx

# 失败时重启（最多3次）
docker run --restart on-failure:3 nginx

# 除非手动停止
docker run --restart unless-stopped nginx
```

## 实践示例

### 示例 1: 运行数据库

```bash
#!/bin/bash

# 运行 MySQL 容器
docker run -d \
  --name mysql-demo \
  --restart unless-stopped \
  -e MYSQL_ROOT_PASSWORD=mypassword \
  -e MYSQL_DATABASE=testdb \
  -v mysql-data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:8.0

# 等待启动
echo "等待 MySQL 启动..."
sleep 20

# 连接测试
docker exec -it mysql-demo mysql -uroot -pmypassword -e "SHOW DATABASES;"

# 查看日志
docker logs mysql-demo

# 查看资源使用
docker stats mysql-demo --no-stream
```

### 示例 2: 健康检查

```bash
docker run -d \
  --name web-with-health \
  --health-cmd="curl -f http://localhost/ || exit 1" \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  nginx:alpine

# 查看健康状态
docker inspect --format='{{.State.Health.Status}}' web-with-health
```

## 容器导入导出

```bash
# 导出容器为 tar 文件
docker export container_name > container.tar

# 从 tar 文件导入为镜像
cat container.tar | docker import - myimage:latest

# 容器提交为镜像
docker commit container_name myimage:v1
```

## 故障排查

### 容器无法启动

```bash
# 查看容器日志
docker logs container_name

# 查看容器详细信息
docker inspect container_name

# 检查退出码
docker inspect --format='{{.State.ExitCode}}' container_name
```

### 容器资源问题

```bash
# 实时监控资源
docker stats

# 查看容器进程
docker top container_name

# 查看容器事件
docker events --filter container=container_name
```

## 练习任务

1. **容器生命周期**：
   - 创建、启动、停止、重启容器
   - 使用不同的重启策略

2. **资源限制**：
   - 创建资源受限的容器
   - 使用 `docker stats` 监控

3. **日志管理**：
   - 查看和过滤容器日志
   - 使用 `-f` 实时跟踪

4. **健康检查**：
   - 创建带健康检查的容器
   - 观察健康状态变化

## 实践脚本

保存为 `container-operations.sh`:
```bash
#!/bin/bash

echo "=== 容器操作练习 ==="

# 1. 创建和管理容器
echo -e "\n1. 容器生命周期"
docker run -d --name test-nginx nginx:alpine
docker ps
sleep 2

docker stop test-nginx
docker ps -a
sleep 2

docker start test-nginx
docker ps

docker rm -f test-nginx

# 2. 资源限制
echo -e "\n2. 资源限制测试"
docker run -d \
  --name limited-nginx \
  --memory 256m \
  --cpus 0.5 \
  nginx:alpine

docker stats limited-nginx --no-stream

docker rm -f limited-nginx

# 3. 日志测试
echo -e "\n3. 日志查看"
docker run -d --name log-test nginx:alpine
sleep 2
docker logs log-test
docker rm -f log-test

echo -e "\n=== 练习完成 ==="
```

## 下一步

完成本章后，继续学习第4章：Docker 网络。
