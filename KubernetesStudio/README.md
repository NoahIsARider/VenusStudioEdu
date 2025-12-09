# Kubernetes Studio

欢迎来到Kubernetes Studio！这是一个全面的学习环境，旨在帮助您掌握Kubernetes的所有重要概念和实践技能。

## 项目目标

本项目通过实际操作和详细示例，让您从零开始学习Kubernetes的核心概念，包括：

- Pods, Services, Deployments等基本资源
- 配置管理(ConfigMaps, Secrets)
- 存储(Volumes, PersistentVolumes)
- 网络策略和服务发现
- 自动扩缩容(HorizontalPodAutoscaler)
- Helm Charts和包管理
- 监控和日志
- 安全性(RBAC, NetworkPolicies)

## 项目结构

```
KubernetesStudio/
├── README.md
├── QUICKSTART.md
├── LEARNING_GUIDE.md
├── 01-basics/
├── 02-pods/
├── 03-services/
├── 04-deployments/
├── 05-config/
├── 06-storage/
├── 07-networking/
├── 08-scaling/
├── 09-helm/
├── 10-monitoring/
├── 11-security/
├── scripts/
│   ├── setup.sh
│   ├── cleanup.sh
│   ├── test-environment.sh
│   └── README.md
└── examples/
    ├── nginx-pod.yaml
    ├── nginx-deployment.yaml
    ├── nginx-service.yaml
    ├── configmap-example.yaml
    ├── secret-example.yaml
    ├── pod-with-config-and-secret.yaml
    ├── persistent-volume.yaml
    ├── persistent-volume-claim.yaml
    ├── pod-with-pvc.yaml
    ├── network-policy.yaml
    └── helm-chart/
        ├── Chart.yaml
        ├── values.yaml
        ├── templates/
        │   ├── deployment.yaml
        │   ├── service.yaml
        │   └── _helpers.tpl
        └── charts/
```

## 先决条件

- Docker Desktop (包含Kubernetes)
- kubectl 命令行工具
- Helm (可选，用于高级示例)

## 快速开始

查看 [QUICKSTART.md](QUICKSTART.md) 获取详细的安装和设置说明。

## 学习路径

按照 [LEARNING_GUIDE.md](LEARNING_GUIDE.md) 中的建议顺序学习各个模块。

## 实践示例

`examples/` 目录包含了丰富的实践示例，涵盖了Kubernetes的各种核心概念：
- 基础Pod和Deployment示例
- ConfigMap和Secret配置示例
- 存储卷使用示例
- 网络策略示例
- Helm Chart完整示例

## 辅助脚本

`scripts/` 目录包含了几个有用的脚本来帮助您设置和管理学习环境：
- `setup.sh`: 初始化学习环境
- `test-environment.sh`: 验证环境配置
- `cleanup.sh`: 清理学习过程中创建的资源

查看 [scripts/README.md](scripts/README.md) 获取更多关于这些脚本的信息。
