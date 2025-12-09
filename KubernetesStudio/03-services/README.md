# Kubernetes Services

本章将学习Services，它是Kubernetes中实现服务发现和负载均衡的关键概念。

## 学习目标

完成本章后，您将能够：
- 理解Service的概念及其在网络中的作用
- 创建不同类型的Service（ClusterIP、NodePort、LoadBalancer）
- 理解服务发现机制和DNS解析
- 使用Endpoints和Headless Services
- 配置外部服务访问

## 核心概念

### 什么是Service？

Service是Kubernetes中定义了一组Pod的逻辑集合和访问它们的策略。Service为Pod提供稳定的网络端点，即使后端Pod发生变化也能保持连接稳定。

### Service的类型

1. **ClusterIP**（默认）：在集群内部暴露服务，提供集群内的访问
2. **NodePort**：在每个节点上开放一个静态端口，允许外部访问
3. **LoadBalancer**：在云提供商环境中创建外部负载均衡器
4. **ExternalName**：将服务映射到外部DNS名称

### 服务发现

Kubernetes通过以下方式实现服务发现：
- **环境变量**：为每个活跃Service创建环境变量
- **DNS**：集群内DNS服务器为Service创建DNS记录

### 标签选择器

Service通过标签选择器（Label Selector）来确定后端Pod：
```yaml
selector:
  app: myapp
  tier: frontend
```

### Headless Services

当不需要负载均衡或单一服务IP时，可以创建Headless Service（将clusterIP设置为None），直接返回Pod的IP地址。

## 实践示例

1. [clusterip-service.yaml](clusterip-service.yaml) - 创建ClusterIP类型的Service
2. [nodeport-service.yaml](nodeport-service.yaml) - 创建NodePort类型的Service
3. [loadbalancer-service.yaml](loadbalancer-service.yaml) - 创建LoadBalancer类型的Service
4. [headless-service.yaml](headless-service.yaml) - 创建Headless Service
5. [externalname-service.yaml](externalname-service.yaml) - 创建ExternalName Service

## 常用命令

```bash
# 创建Service
kubectl apply -f service.yaml

# 查看Service
kubectl get services

# 查看Service详细信息
kubectl describe service service-name

# 测试Service连通性
kubectl exec -it pod-name -- curl service-name:port

# 删除Service
kubectl delete service service-name
```

## 服务访问模式

### 内部访问
```bash
# 通过Service名称访问
curl http://my-service:8080

# 通过环境变量访问
curl http://$MY_SERVICE_SERVICE_HOST:$MY_SERVICE_SERVICE_PORT
```

### 外部访问
```bash
# 通过NodePort访问
curl http://<node-ip>:<node-port>

# 通过LoadBalancer访问
curl http://<load-balancer-ip>:<port>
```

## 练习任务

1. 创建一个ClusterIP Service并测试内部访问
2. 创建一个NodePort Service并从外部访问
3. 创建一个Headless Service并观察DNS记录
4. 配置Service与Deployment的关联

## 故障排除

常见Service问题及解决方案：
- **Service无法访问**：检查标签选择器是否匹配
- **DNS解析失败**：检查CoreDNS是否正常运行
- **端口冲突**：检查NodePort范围和已分配端口
- **负载均衡器未创建**：检查云提供商配置

## 下一步

完成本章后，请继续学习 [04-deployments](../04-deployments/) 章节，了解如何管理应用的部署和更新。
