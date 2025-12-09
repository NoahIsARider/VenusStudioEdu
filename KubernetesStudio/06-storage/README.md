# Kubernetes 存储管理 (Storage)

本章将学习Kubernetes中的存储管理，包括Volumes、PersistentVolumes和StorageClasses。

## 学习目标

完成本章后，您将能够：
- 理解Kubernetes存储模型和概念
- 使用不同类型的Volumes
- 创建和管理PersistentVolumes和PersistentVolumeClaims
- 配置动态存储供应
- 管理存储类和存储策略

## 核心概念

### Volumes（卷）

Volume是Pod中能够被多个容器访问的目录，具有明确的生命周期（与Pod相同）。Volume解决了容器重启后数据丢失的问题。

### PersistentVolumes（PV）

PersistentVolume是集群中的一块存储资源，由管理员配置或使用StorageClass动态供应。它是集群级别的资源。

### PersistentVolumeClaims（PVC）

PersistentVolumeClaim是用户对存储的请求，类似于Pod消费Node资源的方式。PVC消耗PV资源。

### StorageClass

StorageClass为管理员提供了一种描述存储"类"的方法。不同的类可能会映射到不同的服务质量等级或备份策略。

## Volume类型

### 临时存储
- **emptyDir**：Pod分配时创建空目录，Pod删除时清除
- **hostPath**：挂载宿主机文件系统中的文件或目录

### 网络存储
- **nfs**：挂载NFS共享存储
- **iscsi**：挂载iSCSI存储卷
- **cephfs**：挂载CephFS存储卷
- **awsElasticBlockStore**：挂载AWS EBS卷

### 云提供商存储
- **gcePersistentDisk**：Google Compute Engine持久化磁盘
- **azureDisk**：Microsoft Azure磁盘
- **csi**：容器存储接口卷

## 实践示例

1. [emptydir-volume.yaml](emptydir-volume.yaml) - 使用emptyDir卷的Pod
2. [hostpath-volume.yaml](hostpath-volume.yaml) - 使用hostPath卷的Pod
3. [persistent-volume.yaml](persistent-volume.yaml) - 创建PersistentVolume
4. [persistent-volume-claim.yaml](persistent-volume-claim.yaml) - 创建PersistentVolumeClaim
5. [pod-with-pvc.yaml](pod-with-pvc.yaml) - 在Pod中使用PVC
6. [storage-class.yaml](storage-class.yaml) - 创建StorageClass

## PersistentVolume配置示例

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: slow
  nfs:
    path: /tmp
    server: 172.17.0.2
```

## PersistentVolumeClaim配置示例

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
  storageClassName: slow
```

## 在Pod中使用PersistentVolume

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: nginx
    volumeMounts:
    - mountPath: "/usr/share/nginx/html"
      name: my-storage
  volumes:
  - name: my-storage
    persistentVolumeClaim:
      claimName: my-pvc
```

## 常用命令

```bash
# 查看PersistentVolumes
kubectl get pv

# 查看PersistentVolumeClaims
kubectl get pvc

# 查看StorageClasses
kubectl get storageclass

# 查看详细信息
kubectl describe pv pv-name
kubectl describe pvc pvc-name

# 删除资源
kubectl delete pv pv-name
kubectl delete pvc pvc-name
```

## 访问模式

- **ReadWriteOnce (RWO)**：卷可以被单个节点以读写方式挂载
- **ReadOnlyMany (ROX)**：卷可以被多个节点以只读方式挂载
- **ReadWriteMany (RWX)**：卷可以被多个节点以读写方式挂载

## 回收策略

- **Retain**：手动回收，保留数据
- **Recycle**：基础擦除（已弃用）
- **Delete**：删除底层存储资产

## 动态供应

通过StorageClass实现动态供应：

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
```

## 练习任务

1. 创建一个使用emptyDir卷的Pod并测试数据持久性
2. 创建PersistentVolume和PersistentVolumeClaim
3. 创建一个使用PVC的Pod
4. 配置StorageClass并测试动态供应
5. 观察PV和PVC的绑定过程

## 故障排除

常见存储问题及解决方案：
- **PVC pending**：检查是否有匹配的PV或StorageClass
- **挂载失败**：检查访问模式和节点兼容性
- **权限错误**：检查存储后端权限设置
- **容量不足**：检查PV容量和PVC请求

## 下一步

完成本章后，请继续学习 [07-networking](../07-networking/) 章节，了解Kubernetes网络模型和策略。
