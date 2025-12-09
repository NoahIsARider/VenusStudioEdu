# Kubernetes 自动扩缩容 (Scaling)

本章将学习Kubernetes中的自动扩缩容机制，包括水平扩缩容、垂直扩缩容和集群自动扩缩容。

## 学习目标

完成本章后，您将能够：
- 理解Kubernetes扩缩容的概念和类型
- 配置HorizontalPodAutoscaler (HPA)
- 配置VerticalPodAutoscaler (VPA)
- 理解Cluster Autoscaler的工作原理
- 监控和优化资源使用

## 核心概念

### 水平Pod自动扩缩容 (HPA)

HorizontalPodAutoscaler根据CPU使用率或其他自定义指标自动调整Deployment、ReplicaSet或ReplicationController的Pod副本数量。

### 垂直Pod自动扩缩容 (VPA)

VerticalPodAutoscaler根据历史资源使用情况自动调整Pod的资源请求和限制。

### 集群自动扩缩容 (CA)

Cluster Autoscaler根据资源需求自动调整集群中的节点数量。

## HorizontalPodAutoscaler (HPA)

### HPA工作机制

HPA通过Metrics Server监控Pod的资源使用情况，并根据设定的目标值调整副本数量：

```
期望副本数 = ceil[当前副本数 * (当前指标值 / 期望指标值)]
```

### HPA配置示例

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15
      - type: Pods
        value: 4
        periodSeconds: 15
      selectPolicy: Max
```

## VerticalPodAutoscaler (VPA)

### VPA工作机制

VPA监控Pod的历史资源使用情况，并为新的Pod设置适当的资源请求，从而提高资源利用率。

### VPA配置示例

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: Deployment
    name: my-app
  updatePolicy:
    updateMode: "Auto"
  resourcePolicy:
    containerPolicies:
    - containerName: "application"
      maxAllowed:
        cpu: 1
        memory: 500Mi
      minAllowed:
        cpu: 100m
        memory: 50Mi
```

## Cluster Autoscaler

### 工作机制

Cluster Autoscaler监控集群中的资源请求，当现有节点无法满足Pod调度需求时，自动增加节点；当节点资源长期未充分利用时，自动减少节点。

### 配置要点

1. 云提供商支持（AWS、GCP、Azure等）
2. 正确的节点组配置
3. 节点标签和污点设置

## 实践示例

1. [hpa-cpu.yaml](hpa-cpu.yaml) - 基于CPU使用率的HPA
2. [hpa-custom-metrics.yaml](hpa-custom-metrics.yaml) - 基于自定义指标的HPA
3. [vpa-auto.yaml](vpa-auto.yaml) - 自动模式的VPA
4. [vpa-recommendation.yaml](vpa-recommendation.yaml) - 推荐模式的VPA
5. [stress-test.yaml](stress-test.yaml) - 压力测试以触发扩缩容

## 常用命令

```bash
# 查看HPA
kubectl get hpa

# 查看HPA详细信息
kubectl describe hpa hpa-name

# 查看VPA
kubectl get vpa

# 查看VPA详细信息
kubectl describe vpa vpa-name

# 手动扩缩容Deployment
kubectl scale deployment deployment-name --replicas=5

# 查看节点
kubectl get nodes
```

## Metrics Server

### 安装Metrics Server

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### 验证安装

```bash
kubectl get apiservices | grep metrics
kubectl top nodes
kubectl top pods
```

## 扩缩容策略

### HPA行为配置

```yaml
behavior:
  scaleDown:
    stabilizationWindowSeconds: 300
    policies:
    - type: Percent
      value: 100
      periodSeconds: 15
  scaleUp:
    stabilizationWindowSeconds: 0
    policies:
    - type: Percent
      value: 100
      periodSeconds: 15
    selectPolicy: Max
```

## 练习任务

1. 部署Metrics Server并验证其功能
2. 创建HPA并观察自动扩缩容行为
3. 配置VPA并观察资源请求的调整
4. 执行压力测试触发扩缩容
5. 分析扩缩容日志和指标

## 监控和告警

### 关键指标

- CPU和内存使用率
- Pod副本数量
- 节点资源利用率
- 扩缩容事件

### 告警规则

- HPA无法获取指标
- 持续达到最大副本数
- 节点资源不足
- 扩缩容操作频繁

## 故障排除

常见扩缩容问题及解决方案：
- **HPA无法获取指标**：检查Metrics Server状态和RBAC配置
- **扩缩容无响应**：检查HPA配置和资源指标
- **VPA不生效**：检查VPA模式和Pod重启策略
- **集群扩缩容失败**：检查云提供商配置和权限

## 下一步

完成本章后，请继续学习 [09-helm](../09-helm/) 章节，了解如何使用Helm管理Kubernetes应用。
