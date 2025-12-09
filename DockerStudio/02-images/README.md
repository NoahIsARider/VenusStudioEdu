# 第2章：镜像管理

## 学习目标

- 理解 Docker 镜像的层次结构
- 掌握 Dockerfile 编写
- 学会构建和优化镜像

## Dockerfile 基础

### Dockerfile 指令

```dockerfile
# FROM: 指定基础镜像
FROM ubuntu:22.04

# LABEL: 添加元数据
LABEL maintainer="your@email.com"
LABEL description="示例镜像"

# RUN: 执行命令（构建时）
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# WORKDIR: 设置工作目录
WORKDIR /app

# COPY: 复制文件到镜像
COPY app.py /app/

# ADD: 类似 COPY，但支持 URL 和自动解压
ADD https://example.com/file.tar.gz /tmp/

# ENV: 设置环境变量
ENV APP_ENV=production
ENV PORT=8080

# EXPOSE: 声明端口
EXPOSE 8080

# CMD: 容器启动时执行的命令（可被覆盖）
CMD ["python3", "app.py"]

# ENTRYPOINT: 容器入口点（不易被覆盖）
ENTRYPOINT ["python3"]
CMD ["app.py"]
```

## 构建自定义镜像

### 示例 1: 简单的 Python 应用

创建 `simple-python/app.py`:
```python
#!/usr/bin/env python3
print("Hello from Docker!")
print("Python application running in container")
```

创建 `simple-python/Dockerfile`:
```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY app.py .

CMD ["python3", "app.py"]
```

构建和运行：
```bash
cd simple-python
docker build -t my-python-app:v1.0 .
docker run my-python-app:v1.0
```

### 示例 2: Web 服务器

创建 `simple-web/index.html`:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Docker Web App</title>
</head>
<body>
    <h1>Hello from Docker Container!</h1>
    <p>This is a simple web page served by Nginx.</p>
</body>
</html>
```

创建 `simple-web/Dockerfile`:
```dockerfile
FROM nginx:alpine

# 复制自定义页面
COPY index.html /usr/share/nginx/html/

# 暴露端口
EXPOSE 80

# Nginx 镜像已有 CMD，无需再定义
```

构建和运行：
```bash
cd simple-web
docker build -t my-web-server:v1.0 .
docker run -d -p 8080:80 my-web-server:v1.0
curl http://localhost:8080
```

## 多阶段构建

多阶段构建可以大幅减小最终镜像大小。

### 示例：Go 应用多阶段构建

创建 `multi-stage/main.go`:
```go
package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello from Go in Docker!")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Server starting on :8080")
    http.ListenAndServe(":8080", nil)
}
```

创建 `multi-stage/Dockerfile`:
```dockerfile
# 构建阶段
FROM golang:1.21-alpine AS builder

WORKDIR /build
COPY main.go .

# 构建二进制文件
RUN go build -o app main.go

# 运行阶段
FROM alpine:latest

WORKDIR /app

# 只复制二进制文件
COPY --from=builder /build/app .

EXPOSE 8080
CMD ["./app"]
```

对比镜像大小：
```bash
# 单阶段构建（约 300MB+）
FROM golang:1.21
WORKDIR /app
COPY main.go .
RUN go build -o app main.go
CMD ["./app"]

# 多阶段构建（约 10MB）
# 使用上面的 Dockerfile
```

## 镜像优化最佳实践

### 1. 使用 .dockerignore

创建 `.dockerignore` 文件：
```
.git
.gitignore
README.md
*.md
node_modules
__pycache__
*.pyc
.env
.DS_Store
```

### 2. 合并 RUN 指令

❌ 不好的做法：
```dockerfile
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN apt-get install -y git
```

✅ 好的做法：
```dockerfile
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    git \
    && rm -rf /var/lib/apt/lists/*
```

### 3. 使用小型基础镜像

```dockerfile
# 大镜像 (约 700MB)
FROM ubuntu:22.04

# 小镜像 (约 100MB)
FROM python:3.11-slim

# 最小镜像 (约 5MB)
FROM alpine:latest
```

### 4. 利用构建缓存

```dockerfile
# 先复制依赖文件
COPY requirements.txt .
RUN pip install -r requirements.txt

# 再复制应用代码（代码改动不影响依赖层）
COPY . .
```

## 镜像管理命令

### 构建镜像
```bash
# 基本构建
docker build -t image-name:tag .

# 指定 Dockerfile
docker build -f Dockerfile.dev -t my-app:dev .

# 不使用缓存
docker build --no-cache -t my-app:latest .

# 设置构建参数
docker build --build-arg VERSION=1.0 -t my-app .
```

### 查看和管理
```bash
# 列出镜像
docker images

# 查看镜像历史
docker history image-name

# 查看镜像详细信息
docker inspect image-name

# 删除镜像
docker rmi image-name

# 删除所有未使用的镜像
docker image prune -a

# 标记镜像
docker tag source-image:tag target-image:tag

# 保存镜像到文件
docker save -o image.tar image-name:tag

# 从文件加载镜像
docker load -i image.tar
```

## 实践脚本

保存为 `build-examples.sh`:
```bash
#!/bin/bash

echo "=== Docker 镜像构建练习 ==="

# 1. 构建 Python 应用
echo -e "\n1. 构建 Python 应用镜像"
mkdir -p simple-python
cat > simple-python/app.py << 'EOF'
#!/usr/bin/env python3
import platform
print(f"Hello from Python {platform.python_version()}")
print(f"Running on {platform.system()}")
EOF

cat > simple-python/Dockerfile << 'EOF'
FROM python:3.11-slim
WORKDIR /app
COPY app.py .
CMD ["python3", "app.py"]
EOF

docker build -t python-demo:v1 ./simple-python
docker run --rm python-demo:v1

# 2. 构建 Web 服务器
echo -e "\n2. 构建 Web 服务器镜像"
mkdir -p simple-web
cat > simple-web/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Docker Demo</title></head>
<body>
    <h1>Hello from Docker! 🐳</h1>
    <p>Current time: <span id="time"></span></p>
    <script>
        setInterval(() => {
            document.getElementById('time').textContent = new Date().toLocaleString();
        }, 1000);
    </script>
</body>
</html>
EOF

cat > simple-web/Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
EOF

docker build -t web-demo:v1 ./simple-web
docker run -d -p 8080:80 --name web-demo web-demo:v1

echo "访问 http://localhost:8080 查看网页"
sleep 3

# 清理
docker stop web-demo
docker rm web-demo

echo -e "\n=== 练习完成 ==="
```

## 练习任务

1. **基础构建**：
   - 创建一个 Node.js 应用的 Dockerfile
   - 构建镜像并运行
   - 使用不同的标签构建多个版本

2. **多阶段构建**：
   - 为一个编译型语言（Go/Rust）创建多阶段 Dockerfile
   - 对比单阶段和多阶段构建的镜像大小

3. **优化镜像**：
   - 选择一个现有 Dockerfile
   - 应用最佳实践进行优化
   - 对比优化前后的镜像大小

## 下一步

完成本章后，继续学习第3章：容器操作和生命周期管理。
