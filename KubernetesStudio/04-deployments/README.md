# Kubernetes Deployments

本章将学习Deployments，这是Kubernetes中管理应用部署和更新的核心资源。

## 学习目标

完成本章后，您将能够：
- 理解Deployment的概念及其在应用管理中的作用
- 创建和管理Deployment
- 执行滚动更新和回滚操作
- 配置更新策略和健康检查
- 管理应用的版本和发布

## 核心概念

### 什么是Deployment？

Deployment为Pod和ReplicaSet提供声明式更新。它描述了期望的状态，Deployment控制器会以受控速率将实际状态更改为期望状态。

### Deployment的优势

1. **声明式更新**：只需描述期望状态，系统自动处理更新过程
2. **滚动更新**：零停机时间更新应用
3. **回滚能力**：轻松回滚到之前的版本
4. **扩缩容**：轻松调整副本数量
5. **状态监控**：实时监控更新进度

### ReplicaSet

Deployment通过ReplicaSet管理Pod副本。ReplicaSet确保指定数量的Pod副本始终运行。

### 更新策略

Deployment支持两种更新策略：
1. **RollingUpdate**（默认）：逐个替换Pod，确保服务不中断
2. **Recreate**：删除所有现有Pod后再创建新Pod

## 实践示例

1. [simple-deployment.yaml](simple-deployment.yaml) - 创建一个简单的Deployment
2. [deployment-with-healthcheck.yaml](deployment-with-healthcheck.yaml) - 带有健康检查的Deployment
3. [rolling-update-example.yaml](rolling-update-example.yaml) - 滚动更新示例
4. [blue-green-deployment.yaml](blue-green-deployment.yaml) - 蓝绿部署示例

## 常用命令

```bash
# 创建Deployment
kubectl apply -f deployment.yaml

# 查看Deployment
kubectl get deployments

# 查看Deployment详细信息
kubectl describe deployment deployment-name

# 更新Deployment镜像
kubectl set image deployment/deployment-name container-name=image:v2

# 扩展Deployment副本数
kubectl scale deployment/deployment-name --replicas=5

# 查看更新历史
kubectl rollout history deployment/deployment-name

# 回滚到上一版本
kubectl rollout undo deployment/deployment-name

# 回滚到指定版本
kubectl rollout undo deployment/deployment-name --to-revision=2

# 暂停Deployment更新
kubectl rollout pause deployment/deployment-name

# 恢复Deployment更新
kubectl rollout resume deployment/deployment-name
```

## Deployment配置详解

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: my-app:v1
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

## 更新策略参数

- **maxSurge**：更新期间可额外创建的Pod数
- **maxUnavailable**：更新期间可不可用的Pod数

## 练习任务

1. 创建一个简单的Deployment并观察其行为
2. 执行滚动更新并将应用升级到新版本
3. 回滚到之前的版本
4. 配置健康检查并测试故障恢复

## 故障排除

常见Deployment问题及解决方案：
- **更新卡住**：检查Pod状态和事件
- **镜像拉取失败**：检查镜像名称和标签
- **健康检查失败**：检查探针配置和应用状态
- **资源不足**：检查节点资源和资源请求

## 下一步

完成本章后，请继续学习 [05-config](../05-config/) 章节，了解如何管理应用配置和敏感信息。
