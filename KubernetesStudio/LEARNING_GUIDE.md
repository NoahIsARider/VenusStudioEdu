# Kubernetes 学习指南

本指南为您提供了一个结构化的学习路径，帮助您循序渐进地掌握Kubernetes的所有重要概念。

## 学习路径

### 第1阶段：基础知识 (Basics)
**目录**: [01-basics](01-basics/)

学习目标：
- 理解Kubernetes是什么以及它的核心概念
- 了解集群架构和主要组件
- 掌握kubectl基本命令

关键概念：
- 集群架构
- Master节点和Worker节点
- Control Plane组件
- kubectl命令行工具

### 第2阶段：Pods
**目录**: [02-pods](02-pods/)

学习目标：
- 理解Pod的概念和用途
- 学会创建和管理Pods
- 掌握多容器Pods的使用

关键概念：
- Pod生命周期
- Pod网络
- 多容器Pods
- Init Containers

### 第3阶段：服务发现 (Services)
**目录**: [03-services](03-services/)

学习目标：
- 理解服务的概念和类型
- 学会创建不同类型的Service
- 掌握服务发现机制

关键概念：
- ClusterIP
- NodePort
- LoadBalancer
- ExternalName
- Endpoints

### 第4阶段：部署管理 (Deployments)
**目录**: [04-deployments](04-deployments/)

学习目标：
- 理解Deployment的作用
- 学会创建和管理Deployment
- 掌握滚动更新和回滚操作

关键概念：
- ReplicaSet
- 滚动更新策略
- 回滚机制
- 标签和选择器

### 第5阶段：配置管理 (ConfigMaps & Secrets)
**目录**: [05-config](05-config/)

学习目标：
- 学会管理应用配置
- 理解Secrets的安全存储
- 掌握配置注入方式

关键概念：
- ConfigMaps
- Secrets
- 环境变量
- 卷挂载

### 第6阶段：存储 (Storage)
**目录**: [06-storage](06-storage/)

学习目标：
- 理解持久化存储概念
- 学会使用PersistentVolumes
- 掌握存储类和动态供应

关键概念：
- Volumes
- PersistentVolumes (PV)
- PersistentVolumeClaims (PVC)
- StorageClasses

### 第7阶段：网络 (Networking)
**目录**: [07-networking](07-networking/)

学习目标：
- 理解Kubernetes网络模型
- 学会配置网络策略
- 掌握Ingress控制器

关键概念：
- CNI插件
- Network Policies
- Service Mesh基础
- Ingress Controllers

### 第8阶段：自动扩缩容 (Scaling)
**目录**: [08-scaling](08-scaling/)

学习目标：
- 理解水平和垂直扩缩容
- 学会配置HPA和VPA
- 掌握集群自动扩缩容

关键概念：
- HorizontalPodAutoscaler
- VerticalPodAutoscaler
- Cluster Autoscaler
- 资源请求和限制

### 第9阶段：包管理 (Helm)
**目录**: [09-helm](09-helm/)

学习目标：
- 理解Helm的作用
- 学会创建和管理Charts
- 掌握模板和值文件

关键概念：
- Helm Charts
- 模板函数
- Release管理
- 依赖管理

### 第10阶段：监控和日志 (Monitoring & Logging)
**目录**: [10-monitoring](10-monitoring/)

学习目标：
- 学会监控集群和应用
- 理解日志收集和分析
- 掌握健康检查机制

关键概念：
- 健康检查 (Liveness/Readiness)
- Metrics Server
- Prometheus集成
- 日志架构

### 第11阶段：安全 (Security)
**目录**: [11-security](11-security/)

学习目标：
- 理解Kubernetes安全模型
- 学会配置RBAC
- 掌握网络安全策略

关键概念：
- RBAC (Role-Based Access Control)
- Network Policies
- Pod Security Standards
- TLS和证书管理

## 学习建议

1. **动手实践**：每个章节都配有实际示例，请务必亲手操作
2. **循序渐进**：按照推荐顺序学习，后续章节会依赖前面的知识
3. **反复练习**：重复练习关键概念直到熟练掌握
4. **查阅文档**：遇到问题时参考官方文档和社区资源

## 评估标准

完成每个阶段后，您应该能够：
- 解释相关概念
- 编写相应的YAML配置文件
- 使用kubectl执行相关操作
- 解决常见的问题和错误

## 进阶学习

掌握基础概念后，您可以进一步学习：
- Operators模式
- 自定义资源定义(CRD)
- Service Mesh (Istio, Linkerd)
- GitOps (ArgoCD, Flux)
- 多集群管理
- 云原生生态系统

祝您学习愉快！
