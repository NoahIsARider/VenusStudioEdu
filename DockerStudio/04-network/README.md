# 第4章：Docker 网络

## 学习目标

- 理解 Docker 网络类型
- 掌握容器间通信
- 学会自定义网络配置

## 网络类型

### 1. Bridge 网络（默认）

容器连接到虚拟网桥，可以互相通信。

```bash
# 查看网络
docker network ls

# 查看默认网桥详情
docker network inspect bridge

# 使用默认网桥
docker run -d --name web1 nginx
docker run -d --name web2 nginx
```

### 2. Host 网络

容器直接使用主机网络栈，无网络隔离。

```bash
# 使用 host 网络
docker run -d --network host nginx

# 注意：端口直接暴露在主机上，无需 -p 映射
```

### 3. None 网络

容器没有网络接口。

```bash
# 创建无网络容器
docker run -d --network none nginx
```

### 4. 自定义网络（推荐）

```bash
# 创建自定义桥接网络
docker network create mynetwork

# 创建容器并连接
docker run -d --name web --network mynetwork nginx
docker run -d --name db --network mynetwork mysql:8.0
```

## 容器间通信

### 使用容器名称通信

自定义网络中，容器可以通过名称互相访问：

```bash
# 创建网络
docker network create app-network

# 启动数据库
docker run -d \
  --name mysql \
  --network app-network \
  -e MYSQL_ROOT_PASSWORD=password \
  mysql:8.0

# 启动应用（可以通过 'mysql' 主机名访问数据库）
docker run -d \
  --name webapp \
  --network app-network \
  -e DB_HOST=mysql \
  -e DB_PASSWORD=password \
  my-web-app
```

### 连接测试

```bash
# 进入容器测试网络连通性
docker exec -it webapp sh

# 在容器内
ping mysql
curl http://mysql:3306
```

## 端口映射

```bash
# 映射单个端口
docker run -p 8080:80 nginx

# 映射到随机端口
docker run -P nginx

# 映射多个端口
docker run -p 8080:80 -p 8443:443 nginx

# 指定 IP 和端口
docker run -p 127.0.0.1:8080:80 nginx

# 查看端口映射
docker port container_name
```

## 网络管理命令

```bash
# 创建网络
docker network create \
  --driver bridge \
  --subnet 172.20.0.0/16 \
  --gateway 172.20.0.1 \
  mynetwork

# 查看所有网络
docker network ls

# 查看网络详情
docker network inspect mynetwork

# 连接容器到网络
docker network connect mynetwork container_name

# 断开容器连接
docker network disconnect mynetwork container_name

# 删除网络
docker network rm mynetwork

# 清理未使用的网络
docker network prune
```

## 实践示例

### 示例 1: Web + 数据库架构

创建 `web-db-demo.sh`:
```bash
#!/bin/bash

echo "=== 创建 Web + Database 架构 ==="

# 创建专用网络
docker network create webapp-net

# 启动 MySQL
docker run -d \
  --name db \
  --network webapp-net \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=appdb \
  -e MYSQL_USER=appuser \
  -e MYSQL_PASSWORD=apppass \
  mysql:8.0

echo "等待 MySQL 启动..."
sleep 20

# 启动 Web 应用（使用 PHP + Apache）
docker run -d \
  --name web \
  --network webapp-net \
  -p 8080:80 \
  -e DB_HOST=db \
  -e DB_NAME=appdb \
  -e DB_USER=appuser \
  -e DB_PASS=apppass \
  php:8.2-apache

echo "架构部署完成！"
echo "Web 应用: http://localhost:8080"
echo "数据库主机名: db (在容器内部)"

# 测试连接
docker exec -it web sh -c "apt-get update && apt-get install -y default-mysql-client"
docker exec -it web mysql -h db -u appuser -papppass -e "SHOW DATABASES;"
```

### 示例 2: 微服务网络

```bash
#!/bin/bash

echo "=== 创建微服务网络 ==="

# 创建前端和后端网络
docker network create frontend
docker network create backend

# API Gateway (连接两个网络)
docker run -d \
  --name api-gateway \
  --network frontend \
  -p 80:80 \
  nginx:alpine

docker network connect backend api-gateway

# 后端服务 (只在 backend 网络)
docker run -d \
  --name service1 \
  --network backend \
  nginx:alpine

docker run -d \
  --name service2 \
  --network backend \
  nginx:alpine

# 数据库 (只在 backend 网络)
docker run -d \
  --name database \
  --network backend \
  postgres:15

echo "网络拓扑创建完成"
echo "api-gateway 可以访问: service1, service2, database"
echo "外部只能访问: api-gateway (端口 80)"
```

## 网络隔离

### 创建隔离的环境

```bash
# 开发环境
docker network create dev-network

# 生产环境
docker network create prod-network

# 开发容器
docker run -d --name dev-app --network dev-network myapp:dev

# 生产容器（完全隔离）
docker run -d --name prod-app --network prod-network myapp:prod
```

## 高级网络配置

### 自定义 DNS

```bash
docker run -d \
  --name custom-dns \
  --dns 8.8.8.8 \
  --dns 8.8.4.4 \
  --dns-search example.com \
  nginx
```

### 添加主机名映射

```bash
docker run -d \
  --name web \
  --add-host db:192.168.1.100 \
  --add-host cache:192.168.1.101 \
  nginx
```

### 网络别名

```bash
# 在网络中使用别名
docker run -d \
  --name web \
  --network mynetwork \
  --network-alias webserver \
  --network-alias www \
  nginx

# 其他容器可以通过 webserver 或 www 访问
```

## 故障排查

### 网络连通性测试

```bash
# 安装网络工具
docker exec -it container apt-get update
docker exec -it container apt-get install -y iputils-ping curl dnsutils

# 测试 DNS
docker exec container nslookup google.com

# 测试连通性
docker exec container ping other-container

# 检查端口
docker exec container nc -zv hostname 80
```

### 查看容器 IP

```bash
# 查看容器 IP
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name

# 查看网络中的所有容器
docker network inspect mynetwork
```

## 练习任务

1. **基础网络**：
   - 创建自定义网络
   - 启动多个容器并测试通信

2. **Web 应用架构**：
   - 部署 Web + Database
   - 通过容器名称连接数据库

3. **网络隔离**：
   - 创建多个网络
   - 实现服务隔离

4. **端口映射**：
   - 映射不同端口
   - 测试访问

## 实践脚本

保存为 `network-demo.sh`:
```bash
#!/bin/bash

echo "=== Docker 网络练习 ==="

# 1. 创建网络
echo -e "\n1. 创建自定义网络"
docker network create test-net
docker network ls | grep test-net

# 2. 启动容器
echo -e "\n2. 启动容器"
docker run -d --name c1 --network test-net alpine sleep 1000
docker run -d --name c2 --network test-net alpine sleep 1000

# 3. 测试通信
echo -e "\n3. 测试容器间通信"
docker exec c1 ping -c 3 c2

# 4. 查看网络
echo -e "\n4. 网络详情"
docker network inspect test-net

# 清理
echo -e "\n清理环境..."
docker rm -f c1 c2
docker network rm test-net

echo -e "\n=== 练习完成 ==="
```

## 下一步

完成本章后，继续学习第5章：数据持久化和卷管理。
