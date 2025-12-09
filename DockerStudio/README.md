# DockerStudio - Docker 容器技术学习项目 🐳

欢迎来到 DockerStudio！这是一个全面的 Docker 容器技术学习项目，通过 12 个精心设计的实践模块，帮助你掌握 Docker 的所有重要知识和技能。

## 📚 项目结构

```
DockerStudio/
├── 01-basics/              # Docker 基础
│   ├── hello-world/        # 第一个容器
│   ├── ubuntu-interactive/ # 交互式容器
│   └── README.md
├── 02-images/              # 镜像管理
│   ├── custom-image/       # 自定义镜像
│   ├── multi-stage/        # 多阶段构建
│   └── README.md
├── 03-containers/          # 容器操作
│   ├── lifecycle/          # 生命周期管理
│   ├── resource-limits/    # 资源限制
│   └── README.md
├── 04-networking/          # 网络配置
│   ├── bridge-network/     # 桥接网络
│   ├── host-network/       # 主机网络
│   └── README.md
├── 05-volumes/             # 数据持久化
│   ├── named-volumes/      # 命名卷
│   ├── bind-mounts/        # 绑定挂载
│   └── README.md
├── 06-compose/             # Docker Compose
│   ├── simple-stack/       # 简单堆栈
│   ├── multi-service/      # 多服务应用
│   └── README.md
├── 07-web-apps/            # Web 应用
│   ├── nginx-static/       # Nginx 静态站点
│   ├── nodejs-app/         # Node.js 应用
│   └── README.md
├── 08-databases/           # 数据库容器
│   ├── mysql/              # MySQL 容器
│   ├── postgres/           # PostgreSQL 容器
│   └── README.md
├── 09-microservices/       # 微服务架构
│   ├── api-gateway/        # API 网关
│   ├── services/           # 微服务
│   └── README.md
├── 10-monitoring/          # 监控和日志
│   ├── logging/            # 日志管理
│   ├── metrics/            # 指标监控
│   └── README.md
├── 11-security/            # 安全最佳实践
│   ├── user-permissions/   # 用户权限
│   ├── secrets/            # 密钥管理
│   └── README.md
├── 12-advanced/            # 高级主题
│   ├── swarm/              # Docker Swarm
│   ├── registry/           # 私有仓库
│   └── README.md
├── scripts/                # 辅助脚本
│   ├── setup.sh            # 环境设置
│   ├── cleanup.sh          # 清理脚本
│   └── test-all.sh         # 测试所有示例
└── README.md               # 本文件
```

## 🚀 快速开始

### 1. 环境验证

Docker 已安装并准备就绪：

```bash
# 检查 Docker 版本
docker --version

# 检查 Docker Compose 版本
docker compose version

# 验证 Docker 运行状态
docker ps
```

### 2. 运行第一个示例

```bash
cd DockerStudio/01-basics/hello-world
docker run hello-world
```

### 3. 学习路径

按照编号顺序学习各个模块，每个模块都有：
- 📖 详细的 README 说明
- 🔨 实践示例代码
- 💡 最佳实践建议
- 🎯 练习任务

## 📖 学习内容

### 第1章：Docker 基础 (Basics)
- ✅ Docker 架构和核心概念
- ✅ 镜像、容器、仓库
- ✅ 运行第一个容器
- ✅ 容器交互和管理
- ✅ 基本命令使用

### 第2章：镜像管理 (Images)
- ✅ 拉取和查看镜像
- ✅ 构建自定义镜像
- ✅ Dockerfile 最佳实践
- ✅ 多阶段构建优化
- ✅ 镜像标签和版本管理

### 第3章：容器操作 (Containers)
- ✅ 容器生命周期管理
- ✅ 启动、停止、重启、删除
- ✅ 容器日志和监控
- ✅ 资源限制（CPU、内存）
- ✅ 容器导入导出

### 第4章：网络配置 (Networking)
- ✅ Docker 网络模式
- ✅ 桥接网络
- ✅ 主机网络
- ✅ 自定义网络
- ✅ 容器间通信

### 第5章：数据持久化 (Volumes)
- ✅ Volume 概念和使用
- ✅ 命名卷管理
- ✅ 绑定挂载
- ✅ 数据备份和恢复
- ✅ 卷驱动程序

### 第6章：Docker Compose (Compose)
- ✅ docker-compose.yml 文件
- ✅ 多容器应用编排
- ✅ 服务定义和配置
- ✅ 环境变量管理
- ✅ 依赖关系和启动顺序

### 第7章：Web 应用部署 (Web Apps)
- ✅ Nginx 静态网站
- ✅ Node.js 应用容器化
- ✅ Python Flask 应用
- ✅ 负载均衡配置
- ✅ SSL/TLS 配置

### 第8章：数据库容器 (Databases)
- ✅ MySQL 容器部署
- ✅ PostgreSQL 配置
- ✅ Redis 缓存
- ✅ MongoDB 部署
- ✅ 数据持久化和备份

### 第9章：微服务架构 (Microservices)
- ✅ 微服务设计模式
- ✅ API 网关
- ✅ 服务发现
- ✅ 容器编排
- ✅ 服务间通信

### 第10章：监控和日志 (Monitoring)
- ✅ 容器日志管理
- ✅ 日志聚合
- ✅ 性能监控
- ✅ 健康检查
- ✅ 告警配置

### 第11章：安全最佳实践 (Security)
- ✅ 镜像安全扫描
- ✅ 用户权限管理
- ✅ 密钥和敏感信息
- ✅ 网络隔离
- ✅ 安全加固

### 第12章：高级主题 (Advanced)
- ✅ Docker Swarm 集群
- ✅ 私有镜像仓库
- ✅ CI/CD 集成
- ✅ 性能优化
- ✅ 故障排查

## 🛠️ 常用命令速查

### 容器操作
```bash
# 运行容器
docker run [options] image [command]

# 列出容器
docker ps              # 运行中的容器
docker ps -a           # 所有容器

# 停止/启动容器
docker stop <container>
docker start <container>

# 删除容器
docker rm <container>

# 查看日志
docker logs <container>

# 进入容器
docker exec -it <container> /bin/bash
```

### 镜像操作
```bash
# 列出镜像
docker images

# 拉取镜像
docker pull <image>

# 构建镜像
docker build -t <name:tag> .

# 删除镜像
docker rmi <image>

# 推送镜像
docker push <image>
```

### Docker Compose
```bash
# 启动服务
docker compose up -d

# 停止服务
docker compose down

# 查看日志
docker compose logs -f

# 重启服务
docker compose restart

# 查看服务状态
docker compose ps
```

### 系统清理
```bash
# 清理未使用的资源
docker system prune

# 清理所有未使用的镜像
docker image prune -a

# 清理卷
docker volume prune

# 清理网络
docker network prune
```

## 💡 学习建议

1. **循序渐进**：按照章节顺序学习，每章都建立在前面的基础上
2. **动手实践**：每个示例都要亲自运行，观察结果
3. **理解原理**：不仅要知道怎么做，更要知道为什么这么做
4. **查看文档**：遇到问题查看 [Docker 官方文档](https://docs.docker.com/)
5. **记录笔记**：记录重要命令和遇到的问题

## 📚 推荐资源

- [Docker 官方文档](https://docs.docker.com/) - 最权威的参考
- [Docker Hub](https://hub.docker.com/) - 官方镜像仓库
- [Docker Compose 文档](https://docs.docker.com/compose/) - 多容器编排
- [Play with Docker](https://labs.play-with-docker.com/) - 在线实验环境

## 🎯 实践项目

完成学习后，你可以尝试：

1. **个人博客部署**：使用 Docker 部署 WordPress 或 Ghost
2. **开发环境搭建**：为团队创建统一的开发环境
3. **微服务项目**：构建一个简单的微服务应用
4. **CI/CD 流水线**：集成 Docker 到 Jenkins/GitLab CI
5. **监控系统**：部署 Prometheus + Grafana 监控栈

## ⚠️ 注意事项

- 容器是临时的，重要数据请使用 Volume 持久化
- 生产环境使用时注意安全配置
- 合理分配资源，避免资源耗尽
- 定期清理不用的镜像和容器
- 遵循镜像构建的最佳实践

## 🤝 贡献

欢迎提出建议和改进！

## 📄 许可证

本项目仅用于学习目的。

---

**祝你学习愉快！掌握 Docker 容器技术！** 🐳✨
