# DockerStudio 学习指南

欢迎使用 DockerStudio！这是一个全面的 Docker 容器技术学习项目。

## 📚 学习路径

### 初学者路线

1. **第1章：Docker 基础** (01-basics/)
   - Docker 架构和概念
   - 第一个容器
   - 基础命令

2. **第2章：镜像管理** (02-images/)
   - Dockerfile 编写
   - 构建自定义镜像
   - 多阶段构建

3. **第3章：容器操作** (03-containers/)
   - 容器生命周期
   - 资源限制
   - 日志和监控

4. **第4章：Docker 网络** (04-network/)
   - 网络类型
   - 容器通信
   - 端口映射

5. **第5章：数据持久化** (05-volumes/)
   - 卷管理
   - 数据备份
   - 绑定挂载

6. **第6章：Docker Compose** (06-compose/)
   - 多容器编排
   - docker-compose.yml
   - 服务依赖

### 进阶路线

7. **第7章：Web 应用部署**
   - Nginx 应用
   - Node.js 应用
   - 负载均衡

8. **第8章：数据库容器化**
   - MySQL/PostgreSQL
   - Redis 缓存
   - MongoDB

9. **第9章：微服务架构**
   - 服务拆分
   - API 网关
   - 服务发现

10. **第10章：监控和日志**
    - 日志收集
    - 性能监控
    - 健康检查

11. **第11章：安全最佳实践**
    - 镜像扫描
    - 权限管理
    - 密钥管理

12. **第12章：高级主题**
    - Docker Swarm
    - 私有仓库
    - CI/CD 集成

## 🚀 快速开始

### 1. 环境设置

```bash
# 运行设置脚本
bash scripts/setup.sh
```

### 2. 开始学习

```bash
# 进入第一章
cd 01-basics

# 阅读教程
cat README.md

# 运行练习脚本
bash practice.sh
```

### 3. 逐章学习

每个章节包含：
- 📖 README.md - 详细教程
- 💻 示例代码和配置
- 🔧 practice.sh - 练习脚本
- 📝 练习任务

## 📖 学习建议

### 循序渐进
- ✅ 按章节顺序学习
- ✅ 完成每章的练习
- ✅ 理解概念后再继续

### 动手实践
- ✅ 运行所有示例代码
- ✅ 修改参数观察变化
- ✅ 尝试自己的项目

### 记录笔记
- ✅ 记录重要命令
- ✅ 总结最佳实践
- ✅ 整理遇到的问题

### 项目实战
- ✅ 完成实战项目
- ✅ 部署实际应用
- ✅ 解决真实问题

## 🛠️ 常用工具

### 辅助脚本

```bash
# 环境设置
bash scripts/setup.sh

# 清理环境
bash scripts/cleanup.sh

# 运行所有测试
bash scripts/test-all.sh
```

### Docker 速查

```bash
# 镜像操作
docker images                 # 列出镜像
docker pull image:tag         # 拉取镜像
docker build -t name .        # 构建镜像
docker rmi image              # 删除镜像

# 容器操作
docker ps                     # 列出容器
docker run image              # 运行容器
docker stop container         # 停止容器
docker rm container           # 删除容器

# 网络操作
docker network ls             # 列出网络
docker network create net     # 创建网络
docker network rm net         # 删除网络

# 卷操作
docker volume ls              # 列出卷
docker volume create vol      # 创建卷
docker volume rm vol          # 删除卷

# Compose 操作
docker compose up             # 启动服务
docker compose down           # 停止服务
docker compose logs           # 查看日志
```

## 📝 练习项目建议

### 初级项目
1. 静态网站部署 (Nginx)
2. 简单 API 服务 (Node.js/Python)
3. 数据库实例 (MySQL/PostgreSQL)

### 中级项目
1. LAMP/MEAN 全栈应用
2. 博客系统 (WordPress)
3. 个人网盘 (Nextcloud)

### 高级项目
1. 微服务架构应用
2. 实时聊天系统
3. CI/CD 流水线

## 🔧 故障排查

### 常见问题

**Docker 服务未启动**
```bash
# Linux
sudo systemctl start docker

# macOS/Windows
# 启动 Docker Desktop
```

**权限问题**
```bash
# 添加用户到 docker 组
sudo usermod -aG docker $USER
# 重新登录生效
```

**镜像拉取失败**
```bash
# 配置镜像加速器
# 编辑 /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://mirror.example.com"
  ]
}
```

**容器无法启动**
```bash
# 查看日志
docker logs container_name

# 查看详细信息
docker inspect container_name
```

## 🎯 学习目标检查

### 基础知识 ✓
- [ ] 理解 Docker 架构
- [ ] 掌握基础命令
- [ ] 能够运行容器

### 镜像和容器 ✓
- [ ] 编写 Dockerfile
- [ ] 构建自定义镜像
- [ ] 管理容器生命周期

### 网络和存储 ✓
- [ ] 配置容器网络
- [ ] 实现数据持久化
- [ ] 容器间通信

### 编排和部署 ✓
- [ ] 使用 Docker Compose
- [ ] 部署多容器应用
- [ ] 理解微服务架构

## 📚 参考资源

### 官方文档
- [Docker 官方文档](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Compose 文档](https://docs.docker.com/compose/)

### 社区资源
- [Docker 论坛](https://forums.docker.com/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/docker)
- [GitHub Docker](https://github.com/docker)

## 💬 获取帮助

- 每章 README 包含详细说明
- 查看示例代码和注释
- 运行测试脚本验证环境
- 参考官方文档

## 🎓 认证建议

完成学习后，可以考虑：
- Docker Certified Associate (DCA)
- Kubernetes 相关认证
- 云平台容器服务认证

## 📈 持续学习

Docker 生态不断发展，建议关注：
- Kubernetes (K8s)
- 服务网格 (Istio, Linkerd)
- 云原生技术 (CNCF)

---

开始你的 Docker 学习之旅吧！🚀

记住：**动手实践是最好的学习方法！**
