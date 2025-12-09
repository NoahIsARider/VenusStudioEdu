# 第1章：Docker 基础

## 学习目标

- 理解 Docker 核心概念
- 掌握基本 Docker 命令
- 运行和管理简单容器

## 核心概念

### 1. Docker 架构

```
┌─────────────────────────────────────────┐
│          Docker Client (CLI)            │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│          Docker Daemon                   │
│  ┌──────────┐  ┌──────────┐            │
│  │ Images   │  │Containers│            │
│  └──────────┘  └──────────┘            │
└─────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│          Docker Registry (Hub)          │
└─────────────────────────────────────────┘
```

### 2. 核心概念解释

- **镜像 (Image)**: 只读的模板，包含运行应用所需的一切
- **容器 (Container)**: 镜像的运行实例，可以启动、停止、删除
- **仓库 (Registry)**: 存储和分发镜像的服务，如 Docker Hub

## 实践练习

### 练习 1: Hello World

最简单的 Docker 示例：

```bash
# 运行 hello-world 容器
docker run hello-world
```

**解释**：
1. Docker 检查本地是否有 hello-world 镜像
2. 如果没有，从 Docker Hub 下载
3. 创建容器并运行
4. 显示欢迎信息后自动退出

### 练习 2: 交互式 Ubuntu 容器

```bash
# 运行交互式 Ubuntu 容器
docker run -it ubuntu:22.04 /bin/bash

# 在容器内执行命令
cat /etc/os-release
ls /
whoami

# 退出容器
exit
```

**参数说明**：
- `-i`: 交互模式，保持 STDIN 打开
- `-t`: 分配伪终端
- `ubuntu:22.04`: 镜像名称和标签
- `/bin/bash`: 容器启动后执行的命令

### 练习 3: 后台运行容器

```bash
# 后台运行 nginx 容器
docker run -d -p 8080:80 --name my-nginx nginx:latest

# 查看运行中的容器
docker ps

# 查看容器日志
docker logs my-nginx

# 停止容器
docker stop my-nginx

# 启动容器
docker start my-nginx

# 删除容器（需先停止）
docker rm my-nginx
```

**参数说明**：
- `-d`: 后台运行（detached mode）
- `-p 8080:80`: 端口映射，主机端口:容器端口
- `--name`: 给容器命名

## 常用命令总结

### 容器管理
```bash
docker run [options] image       # 创建并运行容器
docker ps                        # 列出运行中的容器
docker ps -a                     # 列出所有容器
docker stop <container>          # 停止容器
docker start <container>         # 启动容器
docker restart <container>       # 重启容器
docker rm <container>            # 删除容器
docker exec -it <container> cmd  # 在运行的容器中执行命令
```

### 镜像管理
```bash
docker images                    # 列出本地镜像
docker pull <image>              # 拉取镜像
docker rmi <image>               # 删除镜像
docker search <term>             # 搜索镜像
```

### 信息查看
```bash
docker info                      # 显示系统信息
docker version                   # 显示版本信息
docker logs <container>          # 查看容器日志
docker inspect <container>       # 查看容器详细信息
docker stats                     # 查看容器资源使用情况
```

## 动手实践脚本

保存以下脚本为 `practice.sh` 并运行：

```bash
#!/bin/bash

echo "=== Docker 基础练习 ==="

echo -e "\n1. 运行 hello-world 容器"
docker run hello-world

echo -e "\n2. 拉取 Ubuntu 镜像"
docker pull ubuntu:22.04

echo -e "\n3. 查看本地镜像"
docker images

echo -e "\n4. 运行临时 Ubuntu 容器（退出后自动删除）"
docker run --rm ubuntu:22.04 echo "Hello from Ubuntu container!"

echo -e "\n5. 运行后台 nginx 容器"
docker run -d -p 8080:80 --name test-nginx nginx:alpine

echo -e "\n6. 等待容器启动"
sleep 3

echo -e "\n7. 测试 nginx"
curl -I http://localhost:8080

echo -e "\n8. 查看运行中的容器"
docker ps

echo -e "\n9. 查看容器日志"
docker logs test-nginx

echo -e "\n10. 停止并删除容器"
docker stop test-nginx
docker rm test-nginx

echo -e "\n=== 练习完成 ==="
```

## 练习任务

1. **基础操作**：
   - 运行 hello-world 容器
   - 拉取并运行 alpine 镜像
   - 在 alpine 容器中执行 `uname -a` 命令

2. **容器管理**：
   - 启动一个命名的 nginx 容器
   - 查看容器日志
   - 停止容器但不删除
   - 重新启动容器
   - 最后删除容器

3. **探索命令**：
   - 使用 `docker inspect` 查看容器详细信息
   - 使用 `docker stats` 监控容器资源使用
   - 使用 `docker top` 查看容器进程

## 故障排查

### 常见问题

**问题 1**: 端口已被占用
```bash
# 错误信息
Error: port is already allocated

# 解决方法
# 更换端口或停止占用端口的进程
docker run -d -p 8081:80 nginx
```

**问题 2**: 容器名称冲突
```bash
# 错误信息
Error: Conflict. The container name is already in use

# 解决方法
# 删除同名容器或使用不同名称
docker rm <container-name>
```

**问题 3**: 镜像拉取失败
```bash
# 可能原因：网络问题或镜像不存在
# 解决方法
# 1. 检查镜像名称是否正确
# 2. 尝试使用镜像加速器
# 3. 使用备用镜像
```

## 下一步

完成本章学习后，继续学习：
- 第2章：镜像管理 - 学习如何构建自定义镜像

## 参考资源

- [Docker Run 参考文档](https://docs.docker.com/engine/reference/run/)
- [Docker CLI 命令参考](https://docs.docker.com/engine/reference/commandline/cli/)
