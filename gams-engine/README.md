# gams-engine

Official Helm chart for GAMS Engine. A scalable job and user management system for GAMS optimization models in Kubernetes.

## `chart.version`

0.2.2

## `chart.type`

application

## `chart.appVersion`

25.10.28

## `chart.kubeVersion`

>= 1.29.0-0

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| GAMS Development Corp. | <support@gams.com> | <https://gams.com> |

## Introduction

Welcome to the official Helm chart for **gams-engine**. 
This chart bootstraps a GAMS Engine deployment on a Kubernetes cluster using the Helm package manager.

It deploys the complete GAMS Engine stack, including:
- **Broker**: The core API and job manager.
- **Job Spawner**: Manages Kubernetes Jobs for optimization models.
- **Database**: PostgreSQL and MongoDB.
- **Queue**: RabbitMQ for message passing.

## Prerequisites

- Kubernetes >= 1.29.0-0
- Helm 3.0+
- PV provisioner in the cluster

## Installing the Chart

To install the chart with the release name `my-engine`:

```console
# 1. Add the GAMS Helm repository
helm repo add gams https://charts.gams.com/repo
helm repo update

# 2. Install the chart
helm install my-engine gams/gams-engine --namespace gams --create-namespace

## Configuration

The following table lists the configurable parameters of the GAMS Engine chart and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| broker.affinity | object | `{}` |  |
| broker.monitoring.metricsEnabled | bool | `false` | When set to True, exposes metrics at /api/metrics. |
| broker.monitoring.podMonitorEnabled | bool | `false` | If true, creates a Prometheus Operator PodMonitor. Requires metricsEnabled to be true. |
| broker.networkPolicy.extraEgress | list | `[]` | Add extra egress rules. |
| broker.networkPolicy.extraIngress | list | `[]` | Add extra ingress rules. |
| broker.nginx.image.pullSecrets | list | `[]` |  |
| broker.nginx.image.registry | string | `"docker.io/gams"` | Image registry. |
| broker.nginx.image.repository | string | `"engine-nginx"` | Image repository. |
| broker.nginx.image.tag | string | `""` | Image tag. |
| broker.nginx.resources.limits.memory | string | `"200Mi"` |  |
| broker.nginx.resources.requests.cpu | string | `"100m"` |  |
| broker.nginx.resources.requests.memory | string | `"100Mi"` |  |
| broker.service.annotations | object | `{}` | The NodePort to assign (only if type is NodePort). nodePort: "" |
| broker.service.port | int | `80` | The port that the service will expose. |
| broker.service.type | string | `"ClusterIP"` | Service Type: "ClusterIP", "NodePort", "LoadBalancer". |
| broker.uwsgi.image.pullSecrets | list | `[]` |  |
| broker.uwsgi.image.registry | string | `"docker.io/gams"` | Image registry (overrides global). |
| broker.uwsgi.image.repository | string | `"engine-broker"` | Image repository. |
| broker.uwsgi.image.tag | string | `""` | Image tag (defaults to AppVersion). |
| broker.uwsgi.resources.limits.memory | string | `"1000Mi"` |  |
| broker.uwsgi.resources.requests.cpu | string | `"600m"` |  |
| broker.uwsgi.resources.requests.memory | string | `"1000Mi"` |  |
| cleaner.affinity | object | `{}` |  |
| cleaner.image.pullSecrets | list | `[]` |  |
| cleaner.image.registry | string | `"docker.io/gams"` | Image registry. |
| cleaner.image.repository | string | `"engine-cleaner"` | Image repository. |
| cleaner.image.tag | string | `""` |  |
| cleaner.resources.limits.memory | string | `"1000Mi"` |  |
| cleaner.resources.requests.cpu | string | `"100m"` |  |
| cleaner.resources.requests.memory | string | `"1000Mi"` |  |
| config.cleanerHeartbeatSeconds | int | `300` | Interval (in seconds) for the background cleaner to run. |
| config.maxPendingJobDurationSeconds | int | `120` | Max pending job duration (seconds). Job spawner will keep new jobs in the queue if any job is pending longer than this. |
| config.maxPendingJobs | int | `5` | Max pending jobs in the queue. Job spawner will keep the new jobs in the queue if there are more than this number of pending jobs. |
| config.workerStartupDurationSeconds | int | `0` | Job spawner volume quota deduction. Subtracts 'workerStartupDurationSeconds' from user's volume quota for each worker spawned. |
| dependencyChecker.affinity | object | `{}` |  |
| dependencyChecker.image.pullSecrets | list | `[]` |  |
| dependencyChecker.image.registry | string | `"docker.io/gams"` | Image registry. |
| dependencyChecker.image.repository | string | `"engine-dependency-checker"` | Image repository. |
| dependencyChecker.image.tag | string | `""` |  |
| dependencyChecker.resources.limits.memory | string | `"250Mi"` |  |
| dependencyChecker.resources.requests.cpu | string | `"50m"` |  |
| dependencyChecker.resources.requests.memory | string | `"250Mi"` |  |
| eventManager.affinity | object | `{}` |  |
| eventManager.image.pullSecrets | list | `[]` |  |
| eventManager.image.registry | string | `"docker.io/gams"` | Image registry. |
| eventManager.image.repository | string | `"engine-event-manager"` | Image repository. |
| eventManager.image.tag | string | `""` |  |
| eventManager.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| eventManager.resources.limits.memory | string | `"100Mi"` |  |
| eventManager.resources.requests.cpu | string | `"100m"` |  |
| eventManager.resources.requests.memory | string | `"100Mi"` |  |
| forwardProxy.affinity | object | `{}` |  |
| forwardProxy.image.pullSecrets | list | `[]` |  |
| forwardProxy.image.registry | string | `"docker.io/gams"` | Image registry. |
| forwardProxy.image.repository | string | `"engine-forward-proxy"` | Image repository. |
| forwardProxy.image.tag | string | `""` |  |
| forwardProxy.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| forwardProxy.networkPolicy.extraIngress | list | `[]` | Extra ingress rules. |
| forwardProxy.resources.limits.memory | string | `"100Mi"` |  |
| forwardProxy.resources.requests.cpu | string | `"5m"` |  |
| forwardProxy.resources.requests.memory | string | `"100Mi"` |  |
| global.imagePullSecrets | list | `[]` | List of image pull secrets. imagePullSecrets:   - registryKeySecretName |
| global.imageRegistry | string | `""` | Global Docker image registry. Change this to use a private registry. |
| global.useNetworkPolicies | bool | `true` | Enable/Disable NetworkPolicies globally. |
| hypercubeAppender.affinity | object | `{}` |  |
| hypercubeAppender.image.pullSecrets | list | `[]` |  |
| hypercubeAppender.image.registry | string | `"docker.io/gams"` | Image registry. |
| hypercubeAppender.image.repository | string | `"engine-hypercube-appender"` | Image repository. |
| hypercubeAppender.image.tag | string | `""` |  |
| hypercubeAppender.resources.limits.ephemeral-storage | string | `"4Gi"` |  |
| hypercubeAppender.resources.limits.memory | string | `"100Mi"` |  |
| hypercubeAppender.resources.requests.cpu | string | `"50m"` |  |
| hypercubeAppender.resources.requests.ephemeral-storage | string | `"512Mi"` |  |
| hypercubeAppender.resources.requests.memory | string | `"100Mi"` |  |
| hypercubeUnpacker.affinity | object | `{}` |  |
| hypercubeUnpacker.image.pullSecrets | list | `[]` |  |
| hypercubeUnpacker.image.registry | string | `"docker.io/gams"` | Image registry. |
| hypercubeUnpacker.image.repository | string | `"engine-hypercube-unpacker"` | Image repository. |
| hypercubeUnpacker.image.tag | string | `""` |  |
| hypercubeUnpacker.resources.limits.memory | string | `"100Mi"` |  |
| hypercubeUnpacker.resources.requests.cpu | string | `"50m"` |  |
| hypercubeUnpacker.resources.requests.memory | string | `"100Mi"` |  |
| image.tag | string | `""` | Default tag for all images (overrides AppVersion if set). |
| ingress.annotations | object | `{}` | Annotations for the Ingress resource. |
| ingress.enabled | bool | `false` | Enable or disable the Ingress resource. |
| ingress.hosts | list | `[]` | A list of hostnames to route traffic for. |
| ingress.ingressClassName | string | `""` | The IngressClass resource to use (e.g., "nginx", "alb"). If empty, uses the cluster's default IngressClass. |
| ingress.labels | object | `{}` |  |
| ingress.path | string | `"/"` | The default path for all hosts. |
| ingress.pathType | string | `"Prefix"` | The path matching type (e.g., Prefix). |
| ingress.tls | list | `[]` | TLS configuration. |
| jobCanceler.affinity | object | `{}` |  |
| jobCanceler.image.pullSecrets | list | `[]` |  |
| jobCanceler.image.registry | string | `""` |  |
| jobCanceler.image.repository | string | `"engine-job-canceler"` |  |
| jobCanceler.image.tag | string | `""` |  |
| jobCanceler.networkPolicy.extraEgress | list | `[]` |  |
| jobCanceler.resources.limits.memory | string | `"400Mi"` |  |
| jobCanceler.resources.requests.cpu | string | `"50m"` |  |
| jobCanceler.resources.requests.memory | string | `"400Mi"` |  |
| jobSpawner.affinity | object | `{}` |  |
| jobSpawner.image.pullSecrets | list | `[]` |  |
| jobSpawner.image.registry | string | `""` |  |
| jobSpawner.image.repository | string | `"engine-job-spawner"` |  |
| jobSpawner.image.tag | string | `""` |  |
| jobSpawner.networkPolicy.extraEgress | list | `[]` |  |
| jobSpawner.resources.limits.memory | string | `"500Mi"` |  |
| jobSpawner.resources.requests.cpu | string | `"100m"` |  |
| jobSpawner.resources.requests.memory | string | `"500Mi"` |  |
| jobSpawner.workerImage.pullSecrets | list | `[]` |  |
| jobSpawner.workerImage.registry | string | `"docker.io/gams"` | Image registry. |
| jobSpawner.workerImage.repository | string | `"engine-worker"` | Image repository. |
| jobSpawner.workerImage.tag | string | `""` |  |
| jobSpawner.workerNetworkPolicy.extraEgress | list | `[]` |  |
| jobWatcher.affinity | object | `{}` |  |
| jobWatcher.image.pullSecrets | list | `[]` |  |
| jobWatcher.image.registry | string | `""` |  |
| jobWatcher.image.repository | string | `"engine-job-watcher"` |  |
| jobWatcher.image.tag | string | `""` |  |
| jobWatcher.networkPolicy.extraEgress | list | `[]` |  |
| jobWatcher.resources.limits.memory | string | `"250Mi"` |  |
| jobWatcher.resources.requests.cpu | string | `"50m"` |  |
| jobWatcher.resources.requests.memory | string | `"250Mi"` |  |
| kubernetesClientVersion | string | `"v34.1.0"` | Client version used in Job pods. Must be compatible with your Kubernetes Cluster API version. See: https://kubernetes.io/releases/version-skew-policy/ |
| mongoMigrate.image.registry | string | `"docker.io/gams"` |  |
| mongoMigrate.image.repository | string | `"engine-mongo-migrate"` |  |
| mongoMigrate.image.tag | string | `""` |  |
| mongodb | object | `{"affinity":{},"persistence":{"accessMode":"ReadWriteOnce","size":"8Gi","storageClassName":""},"resources":{"limits":{"memory":"6Gi"},"requests":{"cpu":"500m","memory":"5Gi"}}}` | MongoDB configurations |
| mongodb.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the volume. |
| mongodb.persistence.size | string | `"8Gi"` | Size of the persistent volume. |
| mongodb.persistence.storageClassName | string | `""` | Storage Class to use. |
| pgBouncer.affinity | object | `{}` |  |
| pgBouncer.image.pullSecrets | list | `[]` |  |
| pgBouncer.image.registry | string | `""` |  |
| pgBouncer.image.repository | string | `"pgbouncer"` |  |
| pgBouncer.image.tag | string | `"1.19.1"` |  |
| pgBouncer.networkPolicy.extraEgress | list | `[]` |  |
| pgBouncer.resources.limits.memory | string | `"300Mi"` |  |
| pgBouncer.resources.requests.cpu | string | `"100m"` |  |
| pgBouncer.resources.requests.memory | string | `"200Mi"` |  |
| postgresql | object | `{"affinity":{},"database":"gams_engine","database_user":"gams_engine","externalDatabase":{"enabled":false,"host":"","initialize":{"connectionString":"","run":true},"port":""},"persistence":{"accessMode":"ReadWriteOnce","size":"4Gi","storageClassName":""},"resources":{"limits":{"memory":"3Gi"},"requests":{"cpu":"500m","memory":"2Gi"}}}` | PostgreSQL configurations |
| postgresql.database_user | string | `"gams_engine"` | The default database name to create. |
| postgresql.externalDatabase.enabled | bool | `false` | Enable to use an external PostgreSQL. |
| postgresql.externalDatabase.host | string | `""` | Hostname of your external postgres database. |
| postgresql.externalDatabase.initialize.connectionString | string | `""` | Admin connection string (Required if initialize.run is true). Format: postgresql://<USERNAME>:<PASSWORD>@<HOST>:<PORT>/<DATABASE_NAME> |
| postgresql.externalDatabase.initialize.run | bool | `true` | Run the one-time initialization job? |
| postgresql.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the volume. |
| postgresql.persistence.size | string | `"4Gi"` | Size of the persistent volume. |
| postgresql.persistence.storageClassName | string | `""` | Storage Class to use. |
| postgresqlMigrate.image.registry | string | `"docker.io/gams"` |  |
| postgresqlMigrate.image.repository | string | `"engine-postgres-migrate"` |  |
| postgresqlMigrate.image.tag | string | `""` |  |
| rabbitmq.affinity | object | `{}` |  |
| rabbitmq.monitoring.podMonitorEnabled | bool | `false` | Specifies whether the monitoring should be enabled. |
| rabbitmq.networkPolicy.extraIngress | list | `[]` | Add extra ingress rules to the NetworkPolicy. |
| rabbitmq.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the volume. |
| rabbitmq.persistence.size | string | `"4Gi"` | Size of the persistent volume. |
| rabbitmq.persistence.storageClassName | string | `""` | Storage Class to use. |
| rabbitmq.resources.limits.memory | string | `"6Gi"` |  |
| rabbitmq.resources.requests.cpu | string | `"500m"` |  |
| rabbitmq.resources.requests.memory | string | `"5Gi"` |  |
| rabbitmqMigrate.image.registry | string | `"docker.io/gams"` |  |
| rabbitmqMigrate.image.repository | string | `"engine-queue-migrate"` |  |
| rabbitmqMigrate.image.tag | string | `""` |  |
| useDefaultDenyNetworkPolicy | bool | `false` | If set to true, a "default-deny-all" NetworkPolicy is created. This policy blocks ALL traffic to ALL pods in the namespace unless another policy explicitly allows it. WARNING: We recommend 'true' ONLY IF this chart is the *only* application running in its namespace. |
