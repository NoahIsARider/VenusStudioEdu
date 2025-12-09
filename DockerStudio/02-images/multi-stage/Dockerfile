# 构建阶段
FROM golang:1.21-alpine AS builder

WORKDIR /build

# 复制源代码
COPY main.go .
COPY go.mod .

# 编译为静态二进制文件
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# 运行阶段
FROM alpine:latest

# 安装 ca-certificates（HTTPS 需要）
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# 从构建阶段复制二进制文件
COPY --from=builder /build/app .

EXPOSE 8080

CMD ["./app"]
