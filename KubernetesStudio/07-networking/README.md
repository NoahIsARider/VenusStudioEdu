# Kubernetes 网络 (Networking)

本章将学习Kubernetes网络模型、服务发现和网络安全策略。

## 学习目标

完成本章后，您将能够：
- 理解Kubernetes网络模型和设计原则
- 配置和管理Network Policies
- 使用Ingress控制器暴露服务
- 理解DNS服务发现机制
- 配置网络安全和流量控制

## 核心概念

### Kubernetes网络模型

Kubernetes网络遵循四个基本原则：
1. Pod间通信：所有Pod都可以在没有NAT的情况下与任何其他Pod通信
2. Node-Pod通信：节点可以与所有Pod通信而无需NAT
3. Pod-Node通信：Pod可以与所有节点通信而无需NAT
4. 外部通信：外部机器可以与所有节点通信而无需NAT

### CNI插件

容器网络接口(CNI)是Kubernetes网络的核心组件，负责：
- 分配Pod IP地址
- 配置网络接口
- 管理路由规则

常见的CNI插件包括：
- Calico
- Flannel
- Cilium
- Weave Net

### Service Networking

Service通过虚拟IP和iptables/ipvs规则实现服务发现和负载均衡。

### DNS

Kubernetes集群内建CoreDNS服务，为Service和Pod提供DNS解析。

## Network Policies

Network Policy用于控制Pod之间的网络流量，实现网络安全隔离。

### Network Policy示例

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
        - 172.17.1.0/24
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 6379
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 5978
```

## Ingress Controllers

Ingress是管理外部访问集群内服务的API对象，通常用于HTTP/HTTPS路由。

### Ingress示例

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /testpath
        pathType: Prefix
        backend:
          service:
            name: test
            port:
              number: 80
```

## 实践示例

1. [network-policy-allow.yaml](network-policy-allow.yaml) - 允许特定流量的网络策略
2. [network-policy-deny.yaml](network-policy-deny.yaml) - 拒绝所有流量的网络策略
3. [ingress-simple.yaml](ingress-simple.yaml) - 简单的Ingress配置
4. [ingress-tls.yaml](ingress-tls.yaml) - 带TLS的Ingress配置
5. [service-discovery-test.yaml](service-discovery-test.yaml) - 服务发现测试

## 常用命令

```bash
# 查看网络策略
kubectl get networkpolicies

# 查看Ingress
kubectl get ingress

# 查看服务
kubectl get services

# 测试DNS解析
kubectl exec -it pod-name -- nslookup service-name

# 测试网络连通性
kubectl exec -it pod-name -- ping other-pod-ip
```

## 网络策略选择器

### Pod选择器
```yaml
podSelector:
  matchLabels:
    app: database
```

### 命名空间选择器
```yaml
namespaceSelector:
  matchLabels:
    name: production
```

### IP块选择器
```yaml
ipBlock:
  cidr: 172.17.0.0/16
  except:
  - 172.17.1.0/24
```

## Ingress控制器类型

1. **NGINX Ingress Controller**：最常用的Ingress控制器
2. **Traefik**：现代化的反向代理和负载均衡器
3. **HAProxy**：高性能TCP/HTTP负载均衡器
4. **AWS Load Balancer Controller**：专为AWS设计的控制器

## 练习任务

1. 创建Network Policy限制Pod间的通信
2. 配置Ingress控制器并暴露服务
3. 测试服务发现和DNS解析
4. 验证网络策略的效果
5. 配置TLS加密的Ingress

## 故障排除

常见网络问题及解决方案：
- **Pod无法通信**：检查Network Policies和CNI插件状态
- **DNS解析失败**：检查CoreDNS Pod状态和服务配置
- **Ingress无法访问**：检查Ingress控制器和负载均衡器配置
- **网络延迟高**：检查CNI插件配置和网络拓扑

## 下一步

完成本章后，请继续学习 [08-scaling](../08-scaling/) 章节，了解Kubernetes中的自动扩缩容机制。
