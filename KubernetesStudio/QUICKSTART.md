# Kubernetes Studio 快速开始指南

本指南将帮助您快速设置Kubernetes环境并开始学习。

## 先决条件

在开始之前，请确保您的系统上已安装以下工具：

1. **Docker Desktop** - 包含Kubernetes支持
2. **kubectl** - Kubernetes命令行工具
3. **Helm** (可选) - 用于Helm Charts示例

## 安装和设置

### 1. 启用Docker Desktop中的Kubernetes

1. 打开Docker Desktop
2. 进入 Settings (设置) > Kubernetes
3. 勾选 "Enable Kubernetes"
4. 点击 Apply & Restart (应用并重启)

等待Docker Desktop完成Kubernetes集群的启动，这可能需要几分钟时间。

### 2. 验证Kubernetes安装

打开终端并运行以下命令验证Kubernetes是否正常工作：

```bash
# 检查kubectl是否正确安装
kubectl version --client

# 检查集群状态
kubectl cluster-info

# 查看节点信息
kubectl get nodes
```

您应该能看到类似以下的输出：

```
Kubernetes control plane is running at https://kubernetes.docker.internal:6443
CoreDNS is running at https://kubernetes.docker.internal:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

### 3. 设置kubectl上下文

确保kubectl指向正确的集群：

```bash
# 查看当前上下文
kubectl config current-context

# 查看所有上下文
kubectl config get-contexts
```

对于Docker Desktop，上下文通常命名为 `docker-desktop`。

## 学习路径

1. 从 [LEARNING_GUIDE.md](LEARNING_GUIDE.md) 开始了解推荐的学习路径
2. 按照目录顺序学习各个模块：
   - [01-basics](01-basics/) - Kubernetes基础概念
   - [02-pods](02-pods/) - Pods详解
   - [03-services](03-services/) - 服务和服务发现
   - [04-deployments](04-deployments/) - 部署和更新应用
   - 等等...

## 运行第一个示例

让我们运行一个简单的Nginx Pod来测试环境：

```bash
# 应用一个简单的Pod配置
kubectl apply -f examples/nginx-pod.yaml

# 检查Pod状态
kubectl get pods

# 查看Pod详细信息
kubectl describe pod nginx-pod

# 删除Pod
kubectl delete pod nginx-pod
```

## 故障排除

### 如果Kubernetes无法启动

1. 确保Docker Desktop已完全关闭并重新启动
2. 检查防火墙设置
3. 尝试重置Kubernetes集群：Docker Desktop > Troubleshoot > Clean / Purge data

### 如果kubectl命令失败

1. 检查kubectl是否在PATH中：
   ```bash
   which kubectl
   ```

2. 如果未找到，手动添加到PATH或重新安装kubectl

### 重置Kubernetes集群

如果遇到问题，可以重置Kubernetes集群：

1. Docker Desktop > Settings > Kubernetes
2. 取消勾选 "Enable Kubernetes"
3. 点击 Apply & Restart
4. 重新勾选 "Enable Kubernetes"
5. 再次点击 Apply & Restart

## 下一步

现在您已经设置了环境，请查看 [LEARNING_GUIDE.md](LEARNING_GUIDE.md) 开始学习Kubernetes的核心概念。
