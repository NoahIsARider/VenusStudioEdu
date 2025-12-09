# Kubernetes 监控和日志 (Monitoring & Logging)

本章将学习Kubernetes中的监控和日志管理，包括指标收集、日志聚合和应用健康检查。

## 学习目标

完成本章后，您将能够：
- 理解Kubernetes监控架构和最佳实践
- 配置和使用Metrics Server
- 部署Prometheus和Grafana监控堆栈
- 实施应用健康检查机制
- 配置集中式日志解决方案

## 核心概念

### 监控层次

Kubernetes监控分为三个层次：
1. **基础设施监控**：节点、网络、存储等
2. **Kubernetes组件监控**：API Server、etcd、kubelet等
3. **应用监控**：业务应用的性能和健康状况

### 日志架构

Kubernetes日志分为：
1. **节点级日志**：系统组件日志
2. **Pod日志**：应用容器日志
3. **事件日志**：Kubernetes事件

### 健康检查

Kubernetes提供三种健康检查机制：
1. **Liveness Probe**：判断容器是否存活
2. **Readiness Probe**：判断容器是否准备好接收流量
3. **Startup Probe**：判断容器是否已启动

## Metrics Server

### 安装Metrics Server

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### 使用Metrics Server

```bash
# 查看节点资源使用
kubectl top nodes

# 查看Pod资源使用
kubectl top pods

# 查看特定命名空间的Pod资源使用
kubectl top pods -n namespace
```

## Prometheus监控堆栈

### Prometheus架构

Prometheus监控堆栈包含：
- **Prometheus Server**：指标收集和存储
- **Alertmanager**：告警处理
- **Grafana**：可视化仪表板
- **Node Exporter**：节点指标收集
- **kube-state-metrics**：Kubernetes对象状态指标

### 部署Prometheus

使用Prometheus Operator部署：

```bash
# 添加Prometheus社区Helm仓库
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# 安装Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack
```

### Prometheus配置示例

```yaml
global:
  scrape_interval: 15s

scrape_configs:
- job_name: 'kubernetes-nodes'
  kubernetes_sd_configs:
  - role: node
  relabel_configs:
  - source_labels: [__address__]
    regex: '(.*):10250'
    target_label: __address__
    replacement: '${1}:10255'
```

## 健康检查配置

### Liveness Probe示例

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-exec
spec:
  containers:
  - name: liveness
    image: registry.k8s.io/busybox
    args:
    - /bin/sh
    - -c
    - touch /tmp/healthy; sleep 30; rm -rf /tmp/healthy; sleep 600
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5
```

### Readiness Probe示例

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: readiness
  name: readiness-http
spec:
  containers:
  - name: readiness
    image: nginx
    ports:
    - containerPort: 80
    readinessProbe:
      httpGet:
        path: /healthz
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 5
```

## 日志管理

### EFK堆栈 (Elasticsearch, Fluentd, Kibana)

#### Fluentd配置示例

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
data:
  fluent.conf: |
    <source>
      @type tail
      path /var/log/containers/*.log
      pos_file /var/log/fluentd-containers.log.pos
      tag kubernetes.*
      read_from_head true
      <parse>
        @type json
        time_format %Y-%m-%dT%H:%M:%S.%NZ
      </parse>
    </source>
    
    <match kubernetes.**>
      @type elasticsearch
      host elasticsearch
      port 9200
      logstash_format true
    </match>
```

### Loki日志堆栈 (Loki, Promtail, Grafana)

#### Promtail配置示例

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
- job_name: system
  static_configs:
  - targets:
      - localhost
    labels:
      job: varlogs
      __path__: /var/log/*log
```

## 实践示例

1. [metrics-server.yaml](metrics-server.yaml) - Metrics Server部署配置
2. [prometheus-operator.yaml](prometheus-operator.yaml) - Prometheus Operator配置
3. [liveness-probe.yaml](liveness-probe.yaml) - Liveness探针示例
4. [readiness-probe.yaml](readiness-probe.yaml) - Readiness探针示例
5. [fluentd-daemonset.yaml](fluentd-daemonset.yaml) - Fluentd DaemonSet配置
6. [grafana-dashboard.json](grafana-dashboard.json) - Grafana仪表板配置

## 常用命令

```bash
# 查看Pod日志
kubectl logs pod-name

# 查看Pod日志（最近1小时）
kubectl logs --since=1h pod-name

# 查看Pod日志（实时）
kubectl logs -f pod-name

# 查看前一个容器实例的日志
kubectl logs --previous pod-name

# 查看Kubernetes事件
kubectl get events

# 查看特定资源的事件
kubectl describe pod pod-name
```

## 监控指标

### 关键指标类别

1. **资源指标**：CPU、内存、存储、网络使用率
2. **可用性指标**：Pod状态、节点状态、服务可用性
3. **性能指标**：请求延迟、吞吐量、错误率
4. **业务指标**：订单量、用户活跃度等

### 告警规则示例

```yaml
groups:
- name: example
  rules:
  - alert: HighPodLatency
    expr: histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m])) > 1
    for: 10m
    labels:
      severity: page
    annotations:
      summary: "High request latency"
```

## 练习任务

1. 部署Metrics Server并验证资源监控
2. 配置Prometheus和Grafana监控堆栈
3. 实现应用的健康检查机制
4. 部署EFK或Loki日志解决方案
5. 创建自定义监控仪表板和告警规则

## 最佳实践

1. **分层监控**：建立基础设施、平台和应用三层监控
2. **合理采样**：平衡监控精度和资源消耗
3. **有效告警**：避免告警风暴，确保告警可操作
4. **日志标准化**：统一日志格式便于分析
5. **长期存储**：为合规和分析需求配置长期存储

## 故障排除

常见监控和日志问题及解决方案：
- **指标缺失**：检查Exporter状态和网络连接
- **日志收集失败**：检查DaemonSet状态和权限配置
- **告警误报**：优化告警规则和阈值设置
- **性能瓶颈**：分析资源使用模式和优化配置
- **数据不一致**：检查时间同步和采集间隔

## 下一步

完成本章后，请继续学习 [11-security](../11-security/) 章节，了解Kubernetes安全机制和最佳实践。
