# 多阶段构建示例

展示如何使用多阶段构建优化镜像大小。

## 为什么使用多阶段构建？

**单阶段构建问题**：
- 镜像包含编译工具链（Go 编译器等）
- 最终镜像体积大（300MB+）
- 包含不必要的开发工具

**多阶段构建优势**：
- 只包含运行时需要的文件
- 镜像体积小（10MB 左右）
- 更安全（减少攻击面）

## 构建和运行

```bash
# 构建镜像
docker build -t go-web-app:multi-stage .

# 查看镜像大小
docker images go-web-app

# 运行容器
docker run -d -p 8080:8080 --name go-app go-web-app:multi-stage

# 测试
curl http://localhost:8080

# 在浏览器访问
# http://localhost:8080

# 查看日志
docker logs -f go-app

# 停止和清理
docker stop go-app
docker rm go-app
```

## 对比测试

### 创建单阶段 Dockerfile

```dockerfile
FROM golang:1.21-alpine
WORKDIR /app
COPY main.go .
RUN go build -o app .
EXPOSE 8080
CMD ["./app"]
```

```bash
# 构建单阶段版本
docker build -f Dockerfile.single -t go-web-app:single-stage .

# 对比大小
docker images | grep go-web-app
```

你会看到：
- single-stage: ~350MB
- multi-stage: ~15MB

## Dockerfile 解析

```dockerfile
# === 第一阶段：构建 ===
FROM golang:1.21-alpine AS builder  # 命名为 builder
WORKDIR /build
COPY main.go .
RUN go build -o app .               # 编译

# === 第二阶段：运行 ===
FROM alpine:latest                  # 使用最小镜像
COPY --from=builder /build/app .    # 只复制编译好的二进制文件
CMD ["./app"]
```

## 练习

1. 修改 main.go 添加新的路由
2. 重新构建并测试
3. 尝试为其他语言创建多阶段构建（Rust、C++等）
