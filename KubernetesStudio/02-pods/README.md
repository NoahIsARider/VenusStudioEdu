# Kubernetes Pods

本章将深入学习Pods，这是Kubernetes中最小的可部署单元。

## 学习目标

完成本章后，您将能够：
- 理解Pod的概念及其在Kubernetes中的作用
- 创建和管理单容器和多容器Pods
- 理解Pod的生命周期和状态
- 使用Init Containers初始化应用
- 排查Pod相关问题

## 核心概念

### 什么是Pod？

Pod是Kubernetes中最小的可部署单元，代表集群中运行的进程。一个Pod可以包含一个或多个容器，这些容器共享存储、网络和如何运行的规范。

### Pod的特点

1. **资源共享**：Pod中的容器共享网络和存储资源
2. **单一IP**：每个Pod都有唯一的IP地址
3. **紧密耦合**：Pod中的容器总是共同调度和共同销毁
4. **短暂性**：Pod是临时的，不会自愈

### Pod生命周期

Pod的生命周期状态包括：
- **Pending**：Pod已被接受但容器镜像尚未准备好
- **Running**：Pod已绑定到节点，所有容器已创建
- **Succeeded**：Pod中所有容器成功终止
- **Failed**：Pod中至少有一个容器终止失败
- **Unknown**：由于某种原因无法获得Pod的状态

### 多容器Pods

在某些场景下，需要在一个Pod中运行多个容器：
- **Sidecar模式**：辅助容器为主应用提供额外功能
- **Adapter模式**：适配器容器修改主应用的输出
- **Ambassador模式**：代理容器代表主容器处理外部连接

### Init Containers

Init Containers是在应用容器启动之前运行的专用容器，用于：
- 设置应用容器所需的环境
- 等待服务准备就绪
- 注册应用到目录服务

## 实践示例

1. [simple-pod.yaml](simple-pod.yaml) - 创建一个简单的单容器Pod
2. [multi-container-pod.yaml](multi-container-pod.yaml) - 创建一个多容器Pod
3. [init-container-pod.yaml](init-container-pod.yaml) - 使用Init Container的Pod
4. [pod-with-volume.yaml](pod-with-volume.yaml) - 带有卷的Pod

## 常用命令

```bash
# 创建Pod
kubectl apply -f pod.yaml

# 查看Pod状态
kubectl get pods

# 查看Pod详细信息
kubectl describe pod pod-name

# 查看Pod日志
kubectl logs pod-name

# 进入Pod中的容器
kubectl exec -it pod-name -- /bin/bash

# 删除Pod
kubectl delete pod pod-name
```

## 练习任务

1. 创建一个运行nginx的简单Pod
2. 创建一个多容器Pod，包含一个应用容器和一个日志sidecar容器
3. 创建一个使用Init Container的Pod
4. 观察Pod的生命周期状态变化

## 故障排除

常见Pod问题及解决方案：
- **ImagePullBackOff**：检查镜像名称和标签
- **CrashLoopBackOff**：检查容器日志和启动命令
- **Pending**：检查资源请求和节点容量
- **OOMKilled**：调整内存限制

## 下一步

完成本章后，请继续学习 [03-services](../03-services/) 章节，了解如何通过服务暴露Pod。
