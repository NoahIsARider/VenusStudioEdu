# 自定义镜像示例

这个示例展示如何创建自定义 Docker 镜像。

## 文件说明

- `Dockerfile`: 镜像构建配置
- `app.py`: Python 应用程序

## 构建镜像

```bash
docker build -t my-python-app:v1.0 .
```

## 运行容器

```bash
docker run --rm my-python-app:v1.0
```

## 查看镜像信息

```bash
# 查看镜像
docker images my-python-app

# 查看镜像历史
docker history my-python-app:v1.0

# 查看镜像详细信息
docker inspect my-python-app:v1.0
```

## 练习

1. 修改 `app.py` 添加更多功能
2. 重新构建镜像，使用新的标签 `v1.1`
3. 对比 v1.0 和 v1.1 的差异
