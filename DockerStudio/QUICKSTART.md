# 🐳 DockerStudio - 快速开始

10分钟快速体验 Docker 核心功能！

## ⚡ 极速上手（3步）

### 1️⃣ 环境检查 (30秒)

```bash
cd /workspaces/codespaces-blank/DockerStudio
bash scripts/setup.sh
```

### 2️⃣ 第一个容器 (1分钟)

```bash
# 运行 Hello World
docker run hello-world

# 运行 Web 服务器
docker run -d -p 8080:80 --name nginx nginx:alpine

# 访问测试
curl http://localhost:8080

# 清理
docker rm -f nginx
```

### 3️⃣ 构建自己的镜像 (2分钟)

```bash
cd 02-images/custom-image

# 构建镜像
docker build -t my-app:v1 .

# 运行容器
docker run --rm my-app:v1
```

## 🎯 学习路径

### 初学者（1-2天）

```bash
# Day 1: 基础
cd 01-basics && bash practice.sh    # Docker 基础
cd ../02-images                       # 镜像管理
cd ../03-containers                   # 容器操作

# Day 2: 网络和数据
cd ../04-network                      # 网络配置
cd ../05-volumes                      # 数据持久化
cd ../06-compose                      # Docker Compose
```

### 中级（3-5天）

- 实战项目：LAMP/MEAN 栈
- 数据库容器化
- 微服务架构基础

### 高级（1周+）

- 容器编排 (Swarm/Kubernetes)
- CI/CD 集成
- 生产环境最佳实践

## 📚 每章学习时间

| 章节 | 内容 | 时间 | 难度 |
|-----|------|------|------|
| 01-basics | Docker 基础 | 30分钟 | ⭐ |
| 02-images | 镜像管理 | 45分钟 | ⭐⭐ |
| 03-containers | 容器操作 | 30分钟 | ⭐⭐ |
| 04-network | Docker 网络 | 45分钟 | ⭐⭐⭐ |
| 05-volumes | 数据持久化 | 30分钟 | ⭐⭐ |
| 06-compose | Docker Compose | 1小时 | ⭐⭐⭐ |

## 🎓 学习方式

### 理论 + 实践

1. **阅读** - README.md（10分钟）
2. **实践** - 运行示例（15分钟）
3. **练习** - 完成任务（15分钟）
4. **总结** - 记录笔记（5分钟）

### 推荐顺序

```
README.md → 示例代码 → practice.sh → 练习任务 → 下一章
```

## 💡 常用命令速查

### 容器操作

```bash
docker run image              # 运行容器
docker ps                     # 查看容器
docker stop container         # 停止容器
docker rm container           # 删除容器
docker logs container         # 查看日志
docker exec -it container sh  # 进入容器
```

### 镜像操作

```bash
docker images                 # 列出镜像
docker build -t name .        # 构建镜像
docker pull image             # 拉取镜像
docker rmi image              # 删除镜像
docker tag src dst            # 标记镜像
```

### 网络和卷

```bash
docker network ls             # 列出网络
docker network create net     # 创建网络
docker volume ls              # 列出卷
docker volume create vol      # 创建卷
```

### Compose

```bash
docker compose up             # 启动服务
docker compose up -d          # 后台启动
docker compose down           # 停止服务
docker compose logs -f        # 查看日志
docker compose ps             # 查看状态
```

## 🚀 实战项目

### 5分钟项目：静态网站

```bash
# 1. 创建网页
mkdir my-website
echo '<h1>Hello Docker!</h1>' > my-website/index.html

# 2. 运行 Web 服务器
docker run -d -p 8080:80 -v $(pwd)/my-website:/usr/share/nginx/html nginx:alpine

# 3. 访问
curl http://localhost:8080
```

### 10分钟项目：Web + Database

```bash
cd 06-compose/examples/simple
docker compose up -d
curl http://localhost:8080
docker compose down
```

## ❓ 常见问题

### Q: Docker 服务未启动？
```bash
# Linux
sudo systemctl start docker

# 查看状态
docker info
```

### Q: 权限问题？
```bash
sudo usermod -aG docker $USER
# 重新登录生效
```

### Q: 镜像拉取慢？
```bash
# 使用镜像加速器
# 编辑 /etc/docker/daemon.json
{
  "registry-mirrors": ["https://mirror.example.com"]
}
```

### Q: 容器无法启动？
```bash
# 查看日志
docker logs container_name

# 查看详细信息
docker inspect container_name
```

## 🧹 清理环境

```bash
# 停止所有容器
docker stop $(docker ps -aq)

# 删除所有容器
docker rm $(docker ps -aq)

# 清理未使用的资源
docker system prune -a

# 或使用清理脚本
bash scripts/cleanup.sh
```

## 🎯 学习目标检查

完成快速开始后，你应该能够：

- [ ] 理解 Docker 基本概念
- [ ] 运行和管理容器
- [ ] 构建自定义镜像
- [ ] 使用 Docker Compose
- [ ] 配置网络和数据持久化
- [ ] 查看日志和调试容器

## 📖 下一步

1. **深入学习** - 按章节系统学习
2. **实战项目** - 部署实际应用
3. **最佳实践** - 学习生产环境技巧
4. **进阶主题** - Kubernetes, CI/CD

## 📚 资源链接

- [Docker 官方文档](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [LEARNING_GUIDE.md](LEARNING_GUIDE.md) - 完整学习指南

---

**开始你的 Docker 之旅！🚀**

记住：**边学边做，动手实践！**
