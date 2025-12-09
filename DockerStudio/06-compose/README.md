# 第6章：Docker Compose

## 学习目标

- 理解 Docker Compose 概念
- 掌握 docker-compose.yml 编写
- 学会多容器应用编排

## 什么是 Docker Compose？

Docker Compose 是用于定义和运行多容器 Docker 应用程序的工具。

### 优势

- ✅ 单个文件定义整个应用
- ✅ 一键启动所有服务
- ✅ 服务间自动网络配置
- ✅ 环境变量管理
- ✅ 依赖关系处理

## 基础语法

### 最小示例

`docker-compose.yml`:
```yaml
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
```

启动：
```bash
docker compose up
```

### 完整示例

```yaml
version: '3.8'

services:
  # Web 服务
  web:
    image: nginx:alpine
    container_name: my-web
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    networks:
      - frontend
    depends_on:
      - api
    restart: unless-stopped
    environment:
      - NGINX_HOST=localhost
      - NGINX_PORT=80

  # API 服务
  api:
    build:
      context: ./api
      dockerfile: Dockerfile
    container_name: my-api
    ports:
      - "3000:3000"
    volumes:
      - ./api:/app
    networks:
      - frontend
      - backend
    depends_on:
      - database
      - cache
    environment:
      DB_HOST: database
      DB_PORT: 5432
      REDIS_HOST: cache

  # 数据库
  database:
    image: postgres:15
    container_name: my-db
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydb
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myuser"]
      interval: 10s
      timeout: 5s
      retries: 5

  # 缓存
  cache:
    image: redis:7-alpine
    container_name: my-cache
    networks:
      - backend
    command: redis-server --appendonly yes
    volumes:
      - cache-data:/data

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge

volumes:
  db-data:
  cache-data:
```

## 常用配置详解

### 服务定义

```yaml
services:
  myservice:
    # 使用现有镜像
    image: nginx:alpine
    
    # 或从 Dockerfile 构建
    build:
      context: ./dir
      dockerfile: Dockerfile.dev
      args:
        - VERSION=1.0
    
    # 容器名称
    container_name: my-container
    
    # 端口映射
    ports:
      - "8080:80"        # host:container
      - "127.0.0.1:8081:80"  # 指定 IP
    
    # 卷挂载
    volumes:
      - ./local:/container
      - named-volume:/data
      - /absolute/path:/path
    
    # 环境变量
    environment:
      KEY: value
      ANOTHER: ${ENV_VAR}
    
    # 或使用 env 文件
    env_file:
      - .env
      - .env.prod
    
    # 依赖关系
    depends_on:
      - db
      - cache
    
    # 重启策略
    restart: unless-stopped
    
    # 资源限制
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
    
    # 健康检查
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
    
    # 网络
    networks:
      - frontend
      - backend
```

### 网络配置

```yaml
networks:
  # 默认网络
  default:
    driver: bridge
  
  # 自定义网络
  frontend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
  
  # 使用现有网络
  existing:
    external: true
```

### 卷配置

```yaml
volumes:
  # 简单卷
  data:
  
  # 带选项的卷
  db-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /path/on/host
  
  # 使用现有卷
  existing:
    external: true
```

## Docker Compose 命令

### 基础命令

```bash
# 启动服务
docker compose up

# 后台运行
docker compose up -d

# 指定文件
docker compose -f docker-compose.yml up

# 构建或重新构建
docker compose build

# 构建并启动
docker compose up --build

# 停止服务
docker compose stop

# 停止并删除
docker compose down

# 删除包括卷
docker compose down -v

# 删除包括镜像
docker compose down --rmi all
```

### 服务管理

```bash
# 查看服务状态
docker compose ps

# 查看日志
docker compose logs

# 跟踪日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f web

# 执行命令
docker compose exec web sh

# 重启服务
docker compose restart web

# 暂停服务
docker compose pause web

# 恢复服务
docker compose unpause web
```

### 扩展和伸缩

```bash
# 扩展服务实例
docker compose up -d --scale web=3

# 查看服务
docker compose ps
```

## 实践示例

### 示例 1: LAMP 栈

创建目录结构：
```
lamp-stack/
├── docker-compose.yml
├── www/
│   └── index.php
└── mysql/
    └── init.sql
```

`docker-compose.yml`:
```yaml
version: '3.8'

services:
  web:
    image: php:8.2-apache
    ports:
      - "8080:80"
    volumes:
      - ./www:/var/www/html
    depends_on:
      - database
    networks:
      - lamp

  database:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: myapp
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    volumes:
      - db-data:/var/lib/mysql
      - ./mysql/init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - lamp

  phpmyadmin:
    image: phpmyadmin:latest
    ports:
      - "8081:80"
    environment:
      PMA_HOST: database
      PMA_USER: root
      PMA_PASSWORD: rootpass
    depends_on:
      - database
    networks:
      - lamp

networks:
  lamp:

volumes:
  db-data:
```

`www/index.php`:
```php
<?php
$conn = new mysqli("database", "user", "password", "myapp");
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "<h1>Connected to MySQL!</h1>";
echo "Server version: " . $conn->server_info;
?>
```

运行：
```bash
cd lamp-stack
docker compose up -d
# 访问 http://localhost:8080
# phpMyAdmin: http://localhost:8081
```

### 示例 2: Node.js + MongoDB + Redis

`docker-compose.yml`:
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: development
      MONGODB_URI: mongodb://mongo:27017/myapp
      REDIS_URL: redis://redis:6379
    volumes:
      - .:/app
      - /app/node_modules
    depends_on:
      - mongo
      - redis
    command: npm run dev

  mongo:
    image: mongo:7
    ports:
      - "27017:27017"
    volumes:
      - mongo-data:/data/db
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: password

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data

  mongo-express:
    image: mongo-express:latest
    ports:
      - "8081:8081"
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: admin
      ME_CONFIG_MONGODB_ADMINPASSWORD: password
      ME_CONFIG_MONGODB_URL: mongodb://admin:password@mongo:27017/
    depends_on:
      - mongo

volumes:
  mongo-data:
  redis-data:
```

### 示例 3: 微服务架构

`docker-compose.yml`:
```yaml
version: '3.8'

services:
  gateway:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - auth-service
      - user-service
      - product-service

  auth-service:
    build: ./services/auth
    environment:
      SERVICE_NAME: auth
      DB_HOST: postgres
    depends_on:
      - postgres
      - redis

  user-service:
    build: ./services/user
    environment:
      SERVICE_NAME: user
      DB_HOST: postgres
    depends_on:
      - postgres

  product-service:
    build: ./services/product
    environment:
      SERVICE_NAME: product
      DB_HOST: postgres
    depends_on:
      - postgres

  postgres:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
    volumes:
      - pg-data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data

volumes:
  pg-data:
  redis-data:
```

## 环境管理

### 使用 .env 文件

`.env`:
```bash
# Database
DB_USER=myuser
DB_PASSWORD=mypassword
DB_NAME=mydb

# Application
APP_PORT=3000
APP_ENV=production
```

`docker-compose.yml`:
```yaml
version: '3.8'

services:
  app:
    image: myapp
    ports:
      - "${APP_PORT}:3000"
    environment:
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}
```

### 多环境配置

```bash
# 开发环境
docker compose -f docker-compose.yml -f docker-compose.dev.yml up

# 生产环境
docker compose -f docker-compose.yml -f docker-compose.prod.yml up
```

`docker-compose.dev.yml`:
```yaml
version: '3.8'

services:
  app:
    build:
      target: development
    volumes:
      - .:/app
    command: npm run dev
```

## 最佳实践

1. **使用版本控制**：将 docker-compose.yml 提交到 Git
2. **环境变量**：敏感信息使用 .env（不提交到 Git）
3. **健康检查**：为关键服务添加健康检查
4. **资源限制**：设置适当的 CPU 和内存限制
5. **命名规范**：使用清晰的服务名称
6. **网络隔离**：合理规划网络拓扑

## 练习任务

1. **基础应用**：
   - 创建 Web + Database 应用
   - 使用 docker compose 启动

2. **多服务编排**：
   - 部署包含 3 个以上服务的应用
   - 配置服务依赖关系

3. **环境管理**：
   - 创建开发和生产环境配置
   - 使用 .env 文件管理变量

## 下一步

完成本章后，继续学习第7章：实战项目 - Web 应用部署。
