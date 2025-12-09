# Kubernetes 配置管理 (ConfigMaps & Secrets)

本章将学习如何在Kubernetes中管理应用配置和敏感信息。

## 学习目标

完成本章后，您将能够：
- 理解ConfigMap和Secret的作用和区别
- 创建和管理ConfigMap
- 创建和管理Secret
- 将配置数据注入到Pod中
- 管理敏感信息的安全存储

## 核心概念

### ConfigMap

ConfigMap是一种API对象，用于存储非机密性的键值对配置数据。它可以被Pod使用，或者被系统组件（如控制器）使用。

### Secret

Secret类似于ConfigMap，但专门用于存储敏感信息，如密码、OAuth令牌和SSH密钥。Secret经过Base64编码存储。

### 使用场景

- 应用配置参数（数据库连接字符串、API端点等）
- 环境变量
- 配置文件内容
- 敏感信息（密码、令牌等）

## 实践示例

1. [configmap-literal.yaml](configmap-literal.yaml) - 从字面值创建ConfigMap
2. [configmap-file.yaml](configmap-file.yaml) - 从文件创建ConfigMap
3. [secret-generic.yaml](secret-generic.yaml) - 创建通用Secret
4. [secret-from-file.yaml](secret-from-file.yaml) - 从文件创建Secret
5. [pod-with-config.yaml](pod-with-config.yaml) - 在Pod中使用ConfigMap
6. [pod-with-secret.yaml](pod-with-secret.yaml) - 在Pod中使用Secret

## ConfigMap详解

### 创建ConfigMap

```bash
# 从字面值创建
kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2

# 从文件创建
kubectl create configmap my-config --from-file=config.properties

# 从目录创建
kubectl create configmap my-config --from-file=./config-dir
```

### ConfigMap YAML示例

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  database.url: mongodb://localhost:27017
  log.level: INFO
  app.properties: |
    ui.color=blue
    ui.theme=dark
```

## Secret详解

### 创建Secret

```bash
# 从字面值创建
kubectl create secret generic db-secret --from-literal=username=admin --from-literal=password=secretpassword

# 从文件创建
kubectl create secret generic ssl-certificate --from-file=ssh-privatekey=~/.ssh/id_rsa --from-file=ssh-publickey=~/.ssh/id_rsa.pub
```

### Secret YAML示例

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  username: YWRtaW4=  # admin (base64编码)
  password: c2VjcmV0cGFzc3dvcmQ=  # secretpassword (base64编码)
```

## 在Pod中使用配置

### 作为环境变量

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: my-app
    env:
    - name: DATABASE_URL
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: database.url
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
```

### 作为卷挂载

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: my-app
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
    - name: secret-volume
      mountPath: /etc/secret
      readOnly: true
  volumes:
  - name: config-volume
    configMap:
      name: app-config
  - name: secret-volume
    secret:
      secretName: db-secret
```

## 常用命令

```bash
# 创建ConfigMap
kubectl apply -f configmap.yaml

# 创建Secret
kubectl apply -f secret.yaml

# 查看ConfigMap
kubectl get configmaps

# 查看Secret
kubectl get secrets

# 查看ConfigMap详细信息
kubectl describe configmap configmap-name

# 查看Secret详细信息（注意：不会显示实际值）
kubectl describe secret secret-name

# 以YAML格式查看Secret（显示base64编码的值）
kubectl get secret secret-name -o yaml
```

## 最佳实践

1. **敏感信息使用Secret**：永远不要在ConfigMap中存储密码或令牌
2. **启用加密**：在etcd中启用Secret加密
3. **最小权限原则**：只授予Pod访问所需配置的权限
4. **定期轮换**：定期更新Secret中的敏感信息
5. **避免大文件**：ConfigMap和Secret不适合存储大文件

## 练习任务

1. 创建一个包含应用配置的ConfigMap
2. 创建一个包含数据库凭证的Secret
3. 创建一个Pod，将ConfigMap作为环境变量使用
4. 创建一个Pod，将Secret作为卷挂载使用
5. 更新ConfigMap并观察Pod的行为

## 故障排除

常见配置管理问题及解决方案：
- **配置未生效**：检查Pod是否重启或重新加载配置
- **权限错误**：检查ServiceAccount是否有访问Secret的权限
- **Base64解码错误**：确保Secret值正确进行Base64编码
- **挂载路径冲突**：检查卷挂载路径是否与其他路径冲突

## 下一步

完成本章后，请继续学习 [06-storage](../06-storage/) 章节，了解Kubernetes中的存储管理。
