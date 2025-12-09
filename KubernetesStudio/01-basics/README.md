# Kubernetes 基础概念

本章将介绍Kubernetes的核心概念和基础知识，为您后续的学习打下坚实的基础。

## 学习目标

完成本章后，您将能够：
- 理解Kubernetes是什么以及它解决的问题
- 了解Kubernetes集群的架构组成
- 掌握kubectl命令行工具的基本使用
- 理解Namespaces、Labels和Annotations的概念

## 核心概念

### 什么是Kubernetes？

Kubernetes是一个开源的容器编排平台，用于自动化部署、扩展和管理容器化应用程序。它提供了服务发现、负载均衡、存储编排、自我修复、密钥和配置管理等功能。

### 集群架构

Kubernetes集群由两部分组成：
1. **Control Plane（控制平面）**：负责管理集群
2. **Nodes（节点）**：运行应用程序的工作节点

#### 控制平面组件
- **API Server**：集群的前端接口
- **etcd**：分布式数据库，存储集群状态
- **Scheduler**：调度Pod到合适的节点
- **Controller Manager**：管理控制器
- **Cloud Controller Manager**：与云提供商交互

#### Node组件
- **kubelet**：在节点上运行，确保容器在Pod中运行
- **kube-proxy**：网络代理，维护网络规则
- **Container Runtime**：运行容器的软件（如Docker、containerd）

### kubectl 基础命令

```bash
# 查看集群信息
kubectl cluster-info

# 查看节点
kubectl get nodes

# 查看Pods
kubectl get pods

# 查看服务
kubectl get services

# 查看所有资源
kubectl get all
```

## 实践示例

1. [cluster-info.yaml](cluster-info.yaml) - 获取集群信息的脚本
2. [node-details.yaml](node-details.yaml) - 查看节点详细信息

## 练习任务

1. 使用 `kubectl cluster-info` 查看集群信息
2. 使用 `kubectl get nodes` 查看节点状态
3. 创建一个简单的Pod并观察其状态

## 下一步

完成本章后，请继续学习 [02-pods](../02-pods/) 章节，深入了解Pod的概念和使用方法。
