# Kubernetes 安全 (Security)

本章将学习Kubernetes安全机制和最佳实践，包括身份认证、授权、网络安全和数据保护。

## 学习目标

完成本章后，您将能够：
- 理解Kubernetes安全模型和架构
- 配置身份认证和授权机制
- 实施网络安全策略
- 管理Secrets和加密
- 应用安全最佳实践

## 核心概念

### Kubernetes安全支柱

Kubernetes安全建立在四个支柱上：
1. **身份认证 (Authentication)**：确认用户身份
2. **授权 (Authorization)**：确定用户权限
3. **准入控制 (Admission Control)**：控制对象创建和更新
4. **网络安全 (Network Security)**：控制Pod间通信

### 安全上下文

Security Context定义Pod或Container的安全属性：
- 用户和组ID
- 文件系统权限
- SELinux选项
- AppArmor配置

## 身份认证 (Authentication)

### 认证方式

1. **客户端证书**：X509客户端证书
2. **Bearer Token**：不记名令牌
3. **OIDC**：OpenID Connect
4. **Webhook**：外部认证服务
5. **Bootstrap Tokens**：引导令牌

### ServiceAccount

ServiceAccount为Pod提供身份：

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account
---
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: my-service-account
  containers:
  - name: my-container
    image: nginx
```

## 授权 (Authorization)

### RBAC (Role-Based Access Control)

RBAC是Kubernetes默认的授权机制，包含：
- **Role**：命名空间级别的权限规则
- **ClusterRole**：集群级别的权限规则
- **RoleBinding**：将Role绑定到用户或组
- **ClusterRoleBinding**：将ClusterRole绑定到用户或组

### Role示例

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

### RoleBinding示例

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: jane
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

## 网络安全策略

### NetworkPolicy

NetworkPolicy控制Pod间的网络流量：

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

## Secrets管理

### Secret类型

1. **Opaque**：任意用户定义数据
2. **kubernetes.io/service-account-token**：ServiceAccount令牌
3. **kubernetes.io/dockercfg**：Docker配置文件
4. **kubernetes.io/tls**：TLS证书

### Secret示例

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm
```

### 加密Secrets

在etcd中启用Secret加密：

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - aescbc:
        keys:
        - name: key1
          secret: <BASE64_ENCODED_SECRET>
    - identity: {}
```

## 安全上下文

### Pod安全上下文

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  volumes:
  - name: sec-ctx-vol
    emptyDir: {}
  containers:
  - name: sec-ctx-demo
    image: busybox
    command: [ "sh", "-c", "sleep 1h" ]
    volumeMounts:
    - name: sec-ctx-vol
      mountPath: /data/demo
    securityContext:
      allowPrivilegeEscalation: false
```

## 实践示例

1. [rbac-role.yaml](rbac-role.yaml) - RBAC角色配置
2. [rbac-rolebinding.yaml](rbac-rolebinding.yaml) - RBAC角色绑定
3. [network-policy.yaml](network-policy.yaml) - 网络策略配置
4. [pod-security-context.yaml](pod-security-context.yaml) - Pod安全上下文
5. [encrypted-secret.yaml](encrypted-secret.yaml) - 加密Secret配置
6. [service-account.yaml](service-account.yaml) - ServiceAccount配置

## 常用命令

```bash
# 查看RBAC资源
kubectl get roles,rolebindings,clusterroles,clusterrolebindings

# 查看NetworkPolicies
kubectl get networkpolicies

# 查看ServiceAccounts
kubectl get serviceaccounts

# 查看Secrets
kubectl get secrets

# 创建RBAC资源
kubectl apply -f rbac-role.yaml
kubectl apply -f rbac-rolebinding.yaml
```

## 安全最佳实践

### Pod安全标准

1. **禁止特权容器**：避免使用privileged: true
2. **限制capabilities**：只授予必要的capabilities
3. **只读根文件系统**：设置readOnlyRootFilesystem: true
4. **非root用户运行**：设置runAsNonRoot: true

### 镜像安全

1. **使用可信基础镜像**：选择官方或经过验证的镜像
2. **扫描漏洞**：定期扫描镜像中的安全漏洞
3. **固定标签**：避免使用latest标签
4. **最小化镜像**：只包含必需的组件

### 网络安全

1. **默认拒绝**：使用NetworkPolicy默认拒绝所有流量
2. **最小权限**：只允许必需的网络连接
3. **网络分段**：使用命名空间隔离不同环境
4. **加密传输**：使用TLS加密服务间通信

## 练习任务

1. 配置RBAC角色和绑定，限制用户权限
2. 实施NetworkPolicy限制Pod间通信
3. 创建和管理加密的Secrets
4. 配置Pod安全上下文增强安全性
5. 实施Pod安全标准

## 安全工具

### 推荐工具

1. **kube-bench**：检查Kubernetes安全配置
2. **kube-hunter**：主动渗透测试工具
3. **Trivy**：容器镜像漏洞扫描
4. **Falco**：运行时安全检测和告警
5. **Aqua Security**：企业级容器安全平台

### kube-bench使用示例

```bash
# 在节点上运行kube-bench
kube-bench master
kube-bench node
```

## 故障排除

常见安全问题及解决方案：
- **权限不足**：检查RBAC配置和ServiceAccount绑定
- **网络策略阻止**：验证NetworkPolicy规则和标签选择器
- **Secret访问失败**：检查权限和挂载配置
- **Pod安全违规**：审查安全上下文和Pod安全策略
- **认证失败**：验证认证配置和证书有效性

## 下一步

恭喜您完成了Kubernetes Studio的所有章节学习！现在您已经掌握了Kubernetes的核心概念和实践技能。建议您：

1. 复习所有章节内容，强化理解
2. 在实际项目中应用所学知识
3. 关注Kubernetes社区和最新发展
4. 探索更多高级主题，如Operators、Service Mesh等
