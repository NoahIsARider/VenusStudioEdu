# Kubernetes Helm 包管理

本章将学习Helm，Kubernetes的包管理工具，用于简化复杂应用的部署和管理。

## 学习目标

完成本章后，您将能够：
- 理解Helm的概念和架构
- 安装和配置Helm
- 创建和管理Helm Charts
- 使用Helm部署应用
- 管理Chart仓库和版本

## 核心概念

### 什么是Helm？

Helm是Kubernetes的包管理工具，类似于Linux系统的APT或YUM。它使用Charts来打包、分发和管理Kubernetes应用。

### Helm架构

Helm包含两个主要组件：
1. **Helm Client**：命令行客户端，负责Chart管理和Release管理
2. **Tiller Server**（Helm 2，Helm 3中已移除）：集群中的服务，负责处理Helm命令

### 核心概念

- **Chart**：包含Kubernetes应用所需资源定义的包
- **Repository**：存储和分享Charts的地方
- **Release**：Chart在Kubernetes集群中的运行实例

## Helm Charts结构

```
mychart/
├── Chart.yaml
├── values.yaml
├── charts/
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── _helpers.tpl
└── README.md
```

### Chart.yaml

```yaml
apiVersion: v2
name: mychart
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1.0"
```

### values.yaml

```yaml
replicaCount: 1

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: ""

service:
  type: ClusterIP
  port: 80
```

## 实践示例

1. [simple-chart/](simple-chart/) - 简单的Helm Chart示例
2. [custom-chart/](custom-chart/) - 自定义Helm Chart
3. [dependency-chart/](dependency-chart/) - 包含依赖的Chart
4. [helm-release.yaml](helm-release.yaml) - Helm Release配置
5. [repository-config.yaml](repository-config.yaml) - 仓库配置

## 常用命令

```bash
# 安装Helm（如果未安装）
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# 添加仓库
helm repo add stable https://charts.helm.sh/stable

# 搜索Charts
helm search repo nginx

# 安装Chart
helm install my-release stable/nginx

# 查看Release
helm list

# 查看Release状态
helm status my-release

# 升级Release
helm upgrade my-release stable/nginx --set service.port=8080

# 回滚Release
helm rollback my-release 1

# 删除Release
helm uninstall my-release

# 创建Chart模板
helm create my-chart

# 打包Chart
helm package my-chart

# 验证Chart
helm lint my-chart
```

## Chart模板语法

### 模板函数

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
data:
  myvalue: "Hello World"
  drink: {{ .Values.favorite.drink | default "tea" | quote }}
  food: {{ .Values.favorite.food | upper | quote }}
```

### 控制结构

```yaml
{{- if .Values.service.enabled }}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}
spec:
  type: {{ .Values.service.type }}
{{- end }}
```

### 循环

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
data:
  {{- range $key, $val := .Values.favorite }}
  {{ $key }}: {{ $val | quote }}
  {{- end}}
```

## 自定义Chart开发

### 创建Chart

```bash
helm create my-app
```

### 修改模板

编辑`templates/`目录下的文件，使用Go模板语法和Helm内置对象：

- `.Release`：Release相关信息
- `.Values`：从values.yaml传入的值
- `.Chart`：Chart.yaml中的内容
- `.Files`：访问Chart中的文件

### 调试Chart

```bash
# 渲染模板查看结果
helm template my-release ./my-chart

# 检查语法
helm lint ./my-chart

# Dry-run安装
helm install my-release ./my-chart --dry-run --debug
```

## 依赖管理

### Chart.yaml中定义依赖

```yaml
dependencies:
- name: mysql
  version: "1.2.3"
  repository: "https://charts.helm.sh/stable"
```

### 管理依赖

```bash
# 下载依赖
helm dependency update

# 构建依赖
helm dependency build
```

## 练习任务

1. 安装Helm并配置仓库
2. 部署一个现成的Chart（如nginx）
3. 创建自定义Chart并部署应用
4. 配置Chart依赖并管理
5. 升级和回滚Release

## 最佳实践

1. **版本控制**：使用语义化版本控制Chart
2. **参数化**：将可变配置放入values.yaml
3. **文档化**：编写清晰的README文档
4. **验证**：使用helm lint验证Chart
5. **安全**：定期更新依赖和基础镜像

## 故障排除

常见Helm问题及解决方案：
- **Chart安装失败**：检查模板语法和值配置
- **依赖下载失败**：检查仓库地址和网络连接
- **Release状态异常**：查看Release历史和事件
- **权限错误**：检查RBAC配置和ServiceAccount

## 下一步

完成本章后，请继续学习 [10-monitoring](../10-monitoring/) 章节，了解Kubernetes监控和日志管理。
