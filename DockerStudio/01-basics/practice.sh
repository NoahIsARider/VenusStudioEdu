#!/bin/bash

echo "🐳 === Docker 基础练习 ==="

echo -e "\n📝 1. 运行 hello-world 容器"
docker run hello-world

echo -e "\n📝 2. 拉取 Ubuntu 镜像"
docker pull ubuntu:22.04

echo -e "\n📝 3. 查看本地镜像"
docker images | head -10

echo -e "\n📝 4. 运行临时 Ubuntu 容器（退出后自动删除）"
docker run --rm ubuntu:22.04 echo "Hello from Ubuntu container!"

echo -e "\n📝 5. 运行后台 nginx 容器"
docker run -d -p 8080:80 --name test-nginx nginx:alpine

echo -e "\n📝 6. 等待容器启动..."
sleep 3

echo -e "\n📝 7. 测试 nginx"
curl -I http://localhost:8080 2>/dev/null | head -5

echo -e "\n📝 8. 查看运行中的容器"
docker ps

echo -e "\n📝 9. 查看容器日志（最后10行）"
docker logs test-nginx | tail -10

echo -e "\n📝 10. 进入容器执行命令"
docker exec test-nginx ls -l /usr/share/nginx/html

echo -e "\n📝 11. 查看容器资源使用"
docker stats --no-stream test-nginx

echo -e "\n📝 12. 清理：停止并删除容器"
docker stop test-nginx
docker rm test-nginx

echo -e "\n✅ === 练习完成！==="
echo -e "\n💡 提示：你可以查看各个示例目录了解更多"
