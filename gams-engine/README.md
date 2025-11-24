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

# Introduction

Welcome to the official Helm chart for **gams-engine**. 
This chart bootstraps a GAMS Engine deployment on a Kubernetes cluster using the Helm package manager.

It deploys the complete GAMS Engine stack, including:
- **Broker**: The core API and job manager.
- **Job Spawner**: Manages Kubernetes Jobs for optimization models.
- **Database**: PostgreSQL and MongoDB.
- **Queue**: RabbitMQ for message passing.

# Prerequisites

- Kubernetes >= 1.29.0-0
- Helm 3.0+
- PV provisioner in the cluster

# Installing the Chart

To install the chart with the release name `my-engine`:

```console
# 1. Add the GAMS Helm repository
helm repo add gams https://charts.gams.com/repo
helm repo update

# 2. Install the chart
helm install my-engine gams/gams-engine --namespace gams --create-namespace
```
# Configuration

The following table lists the configurable parameters of the GAMS Engine chart and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.imageRegistry | string | `""` | Global Docker image registry. |
| global.imagePullSecrets | list | `[]` | List of image pull secrets. |
| global.useNetworkPolicies | bool | `true` | Enable/Disable NetworkPolicies globally. |
| image.tag | string | `""` | Default tag for all images (overrides AppVersion if set). |
| useDefaultDenyNetworkPolicy | bool | `false` | If true, blocks all traffic in the namespace unless explicitly allowed. WARNING: Only set to 'true' if this chart is the only app in the namespace. |
| config.cleanerHeartbeatSeconds | int | `300` | Interval (seconds) for the background cleaner to run. |
| config.workerStartupDurationSeconds | int | `0` | Volume quota deduction per worker spawned. |
| config.maxPendingJobs | int | `5` | Max pending jobs in the queue before new ones are held. |
| config.maxPendingJobDurationSeconds | int | `120` | Max duration (seconds) a job can remain pending. |
| ingress.enabled | bool | `false` | Enable or disable the Ingress resource. |
| ingress.ingressClassName | string | `""` | The IngressClass to use (e.g. "nginx", "alb"). |
| ingress.annotations | object | `{}` | Annotations for the Ingress resource. |
| ingress.labels | object | `{}` | Labels for the Ingress resource. |
| ingress.path | string | `"/"` | The default path for all hosts. |
| ingress.pathType | string | `"Prefix"` | The path matching type (e.g. Prefix). |
| ingress.hosts | list | `[]` | Hostnames to route traffic for. |
| ingress.tls | list | `[]` | TLS configuration. |
| kubernetesClientVersion | string | `"v34.1.0"` | Client version used in Job pods (Must match cluster version). |
| broker.affinity | object | `{}` | Affinity settings for pod assignment. |
| broker.monitoring.metricsEnabled | bool | `false` | Expose metrics at /api/metrics. |
| broker.monitoring.podMonitorEnabled | bool | `false` | Create a Prometheus Operator PodMonitor. |
| broker.uwsgi.image.registry | string | `"docker.io/gams"` | Image registry. |
| broker.uwsgi.image.repository | string | `"engine-broker"` | Image repository. |
| broker.uwsgi.image.tag | string | `""` | Image tag. |
| broker.uwsgi.image.pullSecrets | list | `[]` | Image pull secrets. |
| broker.uwsgi.resources.limits | object | `{"memory":"1000Mi"}` | Resource limits. |
| broker.uwsgi.resources.requests | object | `{"cpu":"600m","memory":"1000Mi"}` | Resource requests. |
| broker.nginx.image.registry | string | `"docker.io/gams"` | Image registry. |
| broker.nginx.image.repository | string | `"engine-nginx"` | Image repository. |
| broker.nginx.image.tag | string | `""` | Image tag. |
| broker.nginx.image.pullSecrets | list | `[]` | Image pull secrets. |
| broker.nginx.resources.limits | object | `{"memory":"200Mi"}` | Resource limits. |
| broker.nginx.resources.requests | object | `{"cpu":"100m","memory":"100Mi"}` | Resource requests. |
| broker.networkPolicy.extraIngress | list | `[]` | Extra ingress rules. |
| broker.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| broker.service.type | string | `"ClusterIP"` | Service Type (ClusterIP, NodePort, LoadBalancer). |
| broker.service.port | int | `80` | Service Port. |
| broker.service.annotations | object | `{}` | NodePort (only if type is NodePort). |
| forwardProxy.affinity | object | `{}` | Affinity settings. |
| forwardProxy.image.registry | string | `"docker.io/gams"` | Image registry. |
| forwardProxy.image.repository | string | `"engine-forward-proxy"` | Image repository. |
| forwardProxy.image.tag | string | `""` | Image tag. |
| forwardProxy.image.pullSecrets | list | `[]` |  |
| forwardProxy.resources.requests | object | `{"cpu":"5m","memory":"100Mi"}` | Resource requests. |
| forwardProxy.resources.limits | object | `{"memory":"100Mi"}` | Resource limits. |
| forwardProxy.networkPolicy.extraIngress | list | `[]` | Extra ingress rules. |
| forwardProxy.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| eventManager.affinity | object | `{}` | Affinity settings. |
| eventManager.image.registry | string | `"docker.io/gams"` | Image registry. |
| eventManager.image.repository | string | `"engine-event-manager"` | Image repository. |
| eventManager.image.tag | string | `""` | Image tag. |
| eventManager.image.pullSecrets | list | `[]` |  |
| eventManager.resources.requests | object | `{"cpu":"100m","memory":"100Mi"}` | Resource requests. |
| eventManager.resources.limits | object | `{"memory":"100Mi"}` | Resource limits. |
| eventManager.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| cleaner.affinity | object | `{}` | Affinity settings. |
| cleaner.image.registry | string | `"docker.io/gams"` | Image registry. |
| cleaner.image.repository | string | `"engine-cleaner"` | Image repository. |
| cleaner.image.tag | string | `""` | Image tag. |
| cleaner.image.pullSecrets | list | `[]` |  |
| cleaner.resources.requests | object | `{"cpu":"100m","memory":"1000Mi"}` | Resource requests. |
| cleaner.resources.limits | object | `{"memory":"1000Mi"}` | Resource limits. |
| dependencyChecker.affinity | object | `{}` | Affinity settings. |
| dependencyChecker.image.registry | string | `"docker.io/gams"` | Image registry. |
| dependencyChecker.image.repository | string | `"engine-dependency-checker"` | Image repository. |
| dependencyChecker.image.tag | string | `""` | Image tag. |
| dependencyChecker.image.pullSecrets | list | `[]` |  |
| dependencyChecker.resources.requests | object | `{"cpu":"5m","memory":"250Mi"}` | Resource requests. |
| dependencyChecker.resources.limits | object | `{"memory":"250Mi"}` | Resource limits. |
| hypercubeAppender.affinity | object | `{}` | Affinity settings. |
| hypercubeAppender.image.registry | string | `"docker.io/gams"` | Image registry. |
| hypercubeAppender.image.repository | string | `"engine-hypercube-appender"` | Image repository. |
| hypercubeAppender.image.tag | string | `""` | Image tag. |
| hypercubeAppender.image.pullSecrets | list | `[]` |  |
| hypercubeAppender.resources.requests | object | `{"cpu":"50m","ephemeral-storage":"512Mi","memory":"100Mi"}` | Resource requests. |
| hypercubeAppender.resources.limits | object | `{"ephemeral-storage":"4Gi","memory":"100Mi"}` | Resource limits. |
| hypercubeUnpacker.affinity | object | `{}` | Affinity settings. |
| hypercubeUnpacker.image.registry | string | `"docker.io/gams"` | Image registry. |
| hypercubeUnpacker.image.repository | string | `"engine-hypercube-unpacker"` | Image repository. |
| hypercubeUnpacker.image.tag | string | `""` | Image tag. |
| hypercubeUnpacker.image.pullSecrets | list | `[]` |  |
| hypercubeUnpacker.resources.requests | object | `{"cpu":"50m","memory":"100Mi"}` | Resource requests. |
| hypercubeUnpacker.resources.limits | object | `{"memory":"100Mi"}` | Resource limits. |
| jobCanceler.affinity | object | `{}` | Affinity settings. |
| jobCanceler.image.registry | string | `""` | Image registry. |
| jobCanceler.image.repository | string | `"engine-job-canceler"` | Image repository. |
| jobCanceler.image.tag | string | `""` | Image tag. |
| jobCanceler.image.pullSecrets | list | `[]` |  |
| jobCanceler.resources.requests | object | `{"cpu":"50m","memory":"400Mi"}` | Resource requests. |
| jobCanceler.resources.limits | object | `{"memory":"400Mi"}` | Resource limits. |
| jobCanceler.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| jobSpawner.affinity | object | `{}` | Affinity settings. |
| jobSpawner.workerImage.registry | string | `"docker.io/gams"` | Image registry. |
| jobSpawner.workerImage.repository | string | `"engine-worker"` | Image repository. |
| jobSpawner.workerImage.tag | string | `""` | Image tag. |
| jobSpawner.workerImage.pullSecrets | list | `[]` |  |
| jobSpawner.image.registry | string | `""` | Image registry. |
| jobSpawner.image.repository | string | `"engine-job-spawner"` | Image repository. |
| jobSpawner.image.tag | string | `""` | Image tag. |
| jobSpawner.image.pullSecrets | list | `[]` |  |
| jobSpawner.resources.requests | object | `{"cpu":"100m","memory":"500Mi"}` | Resource requests. |
| jobSpawner.resources.limits | object | `{"memory":"500Mi"}` | Resource limits. |
| jobSpawner.workerNetworkPolicy.extraEgress | list | `[]` | Extra egress rules for workers. |
| jobSpawner.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| jobWatcher.affinity | object | `{}` | Affinity settings. |
| jobWatcher.image.registry | string | `""` | Image registry. |
| jobWatcher.image.repository | string | `"engine-job-watcher"` | Image repository. |
| jobWatcher.image.tag | string | `""` | Image tag. |
| jobWatcher.image.pullSecrets | list | `[]` |  |
| jobWatcher.resources.requests | object | `{"cpu":"50m","memory":"250Mi"}` | Resource requests. |
| jobWatcher.resources.limits | object | `{"memory":"250Mi"}` | Resource limits. |
| jobWatcher.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| pgBouncer.affinity | object | `{}` | Affinity settings. |
| pgBouncer.image.registry | string | `""` | Image registry. |
| pgBouncer.image.repository | string | `"pgbouncer"` | Image repository. |
| pgBouncer.image.tag | string | `"1.19.1"` | Image tag. |
| pgBouncer.image.pullSecrets | list | `[]` |  |
| pgBouncer.resources.requests | object | `{"cpu":"100m","memory":"200Mi"}` | Resource requests. |
| pgBouncer.resources.limits | object | `{"memory":"300Mi"}` | Resource limits. |
| pgBouncer.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| mongodb.persistence.storageClassName | string | `""` | Storage Class to use. |
| mongodb.persistence.size | string | `"8Gi"` | Size of the persistent volume. |
| mongodb.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the volume. |
| mongodb.affinity | object | `{}` | Affinity settings. |
| mongodb.resources.requests | object | `{"cpu":"500m","memory":"5Gi"}` | Resource requests. |
| mongodb.resources.limits | object | `{"memory":"6Gi"}` | Resource limits. |
| mongoMigrate.image.registry | string | `"docker.io/gams"` | Image registry. |
| mongoMigrate.image.repository | string | `"engine-mongo-migrate"` | Image repository. |
| mongoMigrate.image.tag | string | `""` | Image tag. |
| postgresql.persistence.storageClassName | string | `""` | Storage Class to use. |
| postgresql.persistence.size | string | `"4Gi"` | Size of the persistent volume. |
| postgresql.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the volume. |
| postgresql.database_user | string | `"gams_engine"` | The database user to create. |
| postgresql.database | string | `"gams_engine"` | The database name to create. |
| postgresql.externalDatabase.enabled | bool | `false` | Enable to use an external PostgreSQL. |
| postgresql.externalDatabase.host | string | `""` | Hostname of your external postgres database. |
| postgresql.externalDatabase.port | string | `""` | Port number of your external postgres database. |
| postgresql.externalDatabase.initialize.run | bool | `true` | Run the database initialization job |
| postgresql.externalDatabase.initialize.connectionString | string | `"postgresql://<USERNAME>:<PASSWORD>@<HOST>:<PORT>/<DATABASE_NAME>"` | Admin connection string |
| postgresql.affinity | object | `{}` | Affinity settings. |
| postgresql.resources.requests | object | `{"cpu":"500m","memory":"2Gi"}` | Resource requests. |
| postgresql.resources.limits | object | `{"memory":"3Gi"}` | Resource limits. |
| postgresqlMigrate.image.registry | string | `"docker.io/gams"` | Image registry. |
| postgresqlMigrate.image.repository | string | `"engine-postgres-migrate"` | Image repository. |
| postgresqlMigrate.image.tag | string | `""` | Image tag. |
| rabbitmq.monitoring.podMonitorEnabled | bool | `false` | Enable monitoring (Requires Prometheus Operator and CRDs). |
| rabbitmq.persistence.storageClassName | string | `""` | Storage Class to use. |
| rabbitmq.persistence.size | string | `"4Gi"` | Size of the persistent volume. |
| rabbitmq.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the volume. |
| rabbitmq.affinity | object | `{}` | Affinity settings. |
| rabbitmq.resources.limits | object | `{"memory":"6Gi"}` | Resource limits. |
| rabbitmq.resources.requests | object | `{"cpu":"500m","memory":"5Gi"}` | Resource requests. |
| rabbitmq.networkPolicy.extraIngress | list | `[]` | Add extra ingress rules. |
| rabbitmqMigrate.image.registry | string | `"docker.io/gams"` | Image registry. |
| rabbitmqMigrate.image.repository | string | `"engine-queue-migrate"` | Image repository. |
| rabbitmqMigrate.image.tag | string | `""` | Image tag. |
