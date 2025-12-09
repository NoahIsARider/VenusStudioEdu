# Hello World 示例

这是最简单的 Docker 示例，用于验证 Docker 安装是否正确。

## 运行命令

```bash
docker run hello-world
```

## 输出解释

当你运行这个命令时，会发生以下步骤：

1. Docker 客户端联系 Docker 守护进程
2. Docker 守护进程从 Docker Hub 拉取 "hello-world" 镜像
3. Docker 守护进程从该镜像创建一个新容器
4. 容器运行一个可执行文件，生成你看到的输出
5. Docker 守护进程将输出流式传输到 Docker 客户端
6. 容器自动退出

## 预期输出

```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.
```

## 验证安装

如果看到以上输出，说明 Docker 安装成功！

## 清理

查看创建的容器：
```bash
docker ps -a
```

删除容器：
```bash
docker rm <container-id>
```

删除镜像：
```bash
docker rmi hello-world
```
