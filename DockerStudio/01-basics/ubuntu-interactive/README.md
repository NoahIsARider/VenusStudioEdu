# 交互式 Ubuntu 容器

学习如何在容器中进行交互式操作。

## 基本使用

### 启动交互式容器

```bash
docker run -it ubuntu:22.04 /bin/bash
```

参数说明：
- `-i`: 交互模式
- `-t`: 分配终端
- `ubuntu:22.04`: 使用 Ubuntu 22.04 镜像
- `/bin/bash`: 启动 bash shell

### 在容器内操作

进入容器后，你可以执行任何 Linux 命令：

```bash
# 查看系统信息
cat /etc/os-release
uname -a

# 更新包列表
apt-get update

# 安装软件
apt-get install -y curl vim

# 测试安装的软件
curl --version

# 创建文件
echo "Hello from container" > /tmp/hello.txt
cat /tmp/hello.txt

# 查看进程
ps aux

# 退出容器
exit
```

## 高级示例

### 示例 1: 运行临时容器（退出后自动删除）

```bash
docker run -it --rm ubuntu:22.04 /bin/bash
```

`--rm` 参数会在容器退出后自动删除。

### 示例 2: 在后台容器中执行命令

```bash
# 启动后台容器
docker run -d --name my-ubuntu ubuntu:22.04 sleep infinity

# 在运行的容器中执行命令
docker exec -it my-ubuntu /bin/bash

# 或执行单个命令
docker exec my-ubuntu cat /etc/os-release

# 清理
docker stop my-ubuntu
docker rm my-ubuntu
```

### 示例 3: 容器和主机之间复制文件

```bash
# 启动容器
docker run -d --name ubuntu-test ubuntu:22.04 sleep infinity

# 从容器复制文件到主机
docker cp ubuntu-test:/etc/hostname ./container-hostname

# 从主机复制文件到容器
echo "Hello" > local-file.txt
docker cp local-file.txt ubuntu-test:/tmp/

# 验证
docker exec ubuntu-test cat /tmp/local-file.txt

# 清理
docker stop ubuntu-test
docker rm ubuntu-test
rm container-hostname local-file.txt
```

## 实践脚本

保存为 `interactive-demo.sh`：

```bash
#!/bin/bash

echo "=== 交互式容器演示 ==="

echo -e "\n1. 运行临时 Ubuntu 容器并执行命令"
docker run --rm ubuntu:22.04 bash -c "
    echo '容器内部执行:'
    echo '- 主机名:' \$(hostname)
    echo '- 当前用户:' \$(whoami)
    echo '- 工作目录:' \$(pwd)
    echo '- 系统版本:' \$(cat /etc/os-release | grep PRETTY_NAME)
"

echo -e "\n2. 创建持久容器并安装工具"
docker run -d --name demo-ubuntu ubuntu:22.04 sleep 3600

echo "   在容器中安装 curl..."
docker exec demo-ubuntu bash -c "apt-get update -qq && apt-get install -y curl > /dev/null 2>&1"

echo "   测试 curl..."
docker exec demo-ubuntu curl -s http://ifconfig.me

echo -e "\n3. 清理"
docker stop demo-ubuntu
docker rm demo-ubuntu

echo -e "\n=== 演示完成 ==="
```

## 练习任务

1. 启动交互式 Ubuntu 容器，安装 `htop` 工具
2. 在容器内创建一个文本文件，然后复制到主机
3. 使用 `docker exec` 在运行的容器中执行多个命令
4. 尝试不同的 Linux 发行版（如 alpine、debian）

## 注意事项

- 容器中的修改不会影响镜像
- 容器删除后，内部数据会丢失（除非使用 Volume）
- 每次 `docker run` 会创建新容器
- 使用 `--rm` 避免产生大量停止的容器

## 下一步

学习如何构建自定义镜像，保存你的修改。
