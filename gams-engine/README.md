# gams-engine

Official Helm chart for GAMS Engine. A scalable job and user management system for GAMS optimization models in Kubernetes.

## `chart.version`

0.1.3

## `chart.type`

application

## `chart.appVersion`

25.11.13

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
helm repo add gams https://charts.gams.com/
helm repo update

# 2. Install the chart
helm install my-engine gams/gams-engine --namespace gams --create-namespace
```
# Configuration

The following table lists the configurable parameters of the GAMS Engine chart and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| broker.affinity | object | `{}` | Affinity settings for pod assignment. |
| broker.maxReplicas | int | `3` | Max replicas for Broker HPA. |
| broker.monitoring.metricsEnabled | bool | `false` | Expose metrics at /api/metrics. |
| broker.monitoring.podMonitorEnabled | bool | `false` | Create a Prometheus Operator PodMonitor. |
| broker.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| broker.networkPolicy.extraIngress | list | `[]` | Extra ingress rules. |
| broker.networkPolicy.ingress | list | `[{"ports":[{"port":80,"protocol":"TCP"}]}]` | Ingress rules for the Broker. |
| broker.nginx.image.pullSecrets | list | `[]` | Image pull secrets. |
| broker.nginx.image.registry | string | `"docker.io/gams"` | Image registry. |
| broker.nginx.image.repository | string | `"engine-nginx"` | Image repository. |
| broker.nginx.image.tag | string | `""` | Image tag. |
| broker.nginx.resources.limits | object | `{"memory":"200Mi"}` | Resource limits. |
| broker.nginx.resources.requests | object | `{"cpu":"100m","memory":"100Mi"}` | Resource requests. |
| broker.service.annotations | object | `{}` | NodePort (only if type is NodePort). |
| broker.service.port | int | `80` | Service Port. |
| broker.service.type | string | `"ClusterIP"` | Service Type (ClusterIP, NodePort, LoadBalancer). |
| broker.uwsgi.image.pullSecrets | list | `[]` | Image pull secrets. |
| broker.uwsgi.image.registry | string | `"docker.io/gams"` | Image registry. |
| broker.uwsgi.image.repository | string | `"engine-broker"` | Image repository. |
| broker.uwsgi.image.tag | string | `""` | Image tag. |
| broker.uwsgi.resources.limits | object | `{"memory":"1000Mi"}` | Resource limits. |
| broker.uwsgi.resources.requests | object | `{"cpu":"600m","memory":"1000Mi"}` | Resource requests. |
| cleaner.affinity | object | `{}` | Affinity settings for pod assignment. |
| cleaner.image.pullSecrets | list | `[]` | Image pull secrets. |
| cleaner.image.registry | string | `"docker.io/gams"` | Image registry. |
| cleaner.image.repository | string | `"engine-cleaner"` | Image repository. |
| cleaner.image.tag | string | `""` | Image tag. |
| cleaner.resources.limits | object | `{"memory":"1000Mi"}` | Resource limits. |
| cleaner.resources.requests | object | `{"cpu":"100m","memory":"1000Mi"}` | Resource requests. |
| config.cleanerHeartbeatSeconds | int | `300` | Interval (seconds) for the background cleaner process. |
| config.maxPendingJobDurationSeconds | int | `120` | Max duration (seconds) a job can remain pending. |
| config.maxPendingJobs | int | `5` | Max pending jobs in the queue before new ones are held. |
| config.workerStartupDurationSeconds | int | `0` | Volume quota deduction per worker spawned. |
| dependencyChecker.affinity | object | `{}` | Affinity settings for pod assignment. |
| dependencyChecker.image.pullSecrets | list | `[]` | Image pull secrets. |
| dependencyChecker.image.registry | string | `"docker.io/gams"` | Image registry. |
| dependencyChecker.image.repository | string | `"engine-dependency-checker"` | Image repository. |
| dependencyChecker.image.tag | string | `""` | Image tag. |
| dependencyChecker.resources.limits | object | `{"memory":"250Mi"}` | Resource limits. |
| dependencyChecker.resources.requests | object | `{"cpu":"50m","memory":"250Mi"}` | Resource requests. |
| eventManager.affinity | object | `{}` | Affinity settings for pod assignment. |
| eventManager.image.pullSecrets | list | `[]` | Image pull secrets. |
| eventManager.image.registry | string | `"docker.io/gams"` | Image registry. |
| eventManager.image.repository | string | `"engine-event-manager"` | Image repository. |
| eventManager.image.tag | string | `""` | Image tag. |
| eventManager.networkPolicy.extraEgress | list | `[{"ports":[{"port":443,"protocol":"TCP"}],"to":[{"ipBlock":{"cidr":"0.0.0.0/0","except":["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]}}]}]` | Extra egress rules. |
| eventManager.resources.limits | object | `{"memory":"100Mi"}` | Resource limits. |
| eventManager.resources.requests | object | `{"cpu":"100m","memory":"100Mi"}` | Resource requests. |
| forwardProxy.affinity | object | `{}` | Affinity settings for pod assignment. |
| forwardProxy.image.pullSecrets | list | `[]` | Image pull secrets. |
| forwardProxy.image.registry | string | `"docker.io/gams"` | Image registry. |
| forwardProxy.image.repository | string | `"engine-forward-proxy"` | Image repository. |
| forwardProxy.image.tag | string | `""` | Image tag. |
| forwardProxy.networkPolicy.extraEgress | list | `[{"ports":[{"port":443,"protocol":"TCP"}],"to":[{"ipBlock":{"cidr":"0.0.0.0/0","except":["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]}}]}]` | Extra egress rules. |
| forwardProxy.networkPolicy.extraIngress | list | `[]` | Extra ingress rules. |
| forwardProxy.resources.limits | object | `{"memory":"100Mi"}` | Resource limits. |
| forwardProxy.resources.requests | object | `{"cpu":"50m","memory":"100Mi"}` | Resource requests. |
| global | object | `{"imagePullSecrets":[],"imageRegistry":"","nodeSelector":{},"nodeSelectorSts":{},"tolerations":[],"tolerationsSts":[],"useNetworkPolicies":true}` | --------------------------------------------------------------- |
| global.imagePullSecrets | list | `[]` | List of image pull secrets. |
| global.imageRegistry | string | `""` | Global Docker image registry. |
| global.nodeSelector | object | `{}` | Node labels for pod assignment. |
| global.nodeSelectorSts | object | `{}` | Node labels for StatefulSets (Databases). |
| global.tolerations | list | `[]` | Tolerations for pod assignment. |
| global.tolerationsSts | list | `[]` | Tolerations for StatefulSets (Databases). |
| global.useNetworkPolicies | bool | `true` | Enable/Disable NetworkPolicies globally. |
| hypercubeAppender.affinity | object | `{}` | Affinity settings for pod assignment. |
| hypercubeAppender.image.pullSecrets | list | `[]` | Image pull secrets. |
| hypercubeAppender.image.registry | string | `"docker.io/gams"` | Image registry. |
| hypercubeAppender.image.repository | string | `"engine-hypercube-appender"` | Image repository. |
| hypercubeAppender.image.tag | string | `""` | Image tag. |
| hypercubeAppender.resources.limits | object | `{"ephemeral-storage":"4Gi","memory":"100Mi"}` | Resource limits. |
| hypercubeAppender.resources.requests | object | `{"cpu":"50m","ephemeral-storage":"512Mi","memory":"100Mi"}` | Resource requests. |
| hypercubeUnpacker.affinity | object | `{}` | Affinity settings for pod assignment. |
| hypercubeUnpacker.image.pullSecrets | list | `[]` | Image pull secrets. |
| hypercubeUnpacker.image.registry | string | `"docker.io/gams"` | Image registry. |
| hypercubeUnpacker.image.repository | string | `"engine-hypercube-unpacker"` | Image repository. |
| hypercubeUnpacker.image.tag | string | `""` | Image tag. |
| hypercubeUnpacker.resources.limits | object | `{"memory":"100Mi"}` | Resource limits. |
| hypercubeUnpacker.resources.requests | object | `{"cpu":"50m","memory":"100Mi"}` | Resource requests. |
| image.tag | string | `""` | Default image tag for all components. |
| ingress.annotations | object | `{}` | Annotations for the Ingress resource. |
| ingress.enabled | bool | `false` | Enable or disable the Ingress resource. |
| ingress.hosts | list | `[]` | Hostnames to route traffic for. |
| ingress.ingressClassName | string | `""` | The IngressClass to use (e.g. "nginx", "alb"). |
| ingress.labels | object | `{}` | Labels for the Ingress resource. |
| ingress.path | string | `"/"` | The default path for all hosts. |
| ingress.pathType | string | `"Prefix"` | The path matching type (e.g. Prefix). |
| ingress.tls | list | `[]` | TLS configuration. |
| jobCanceler.affinity | object | `{}` | Affinity settings for pod assignment. |
| jobCanceler.image.pullSecrets | list | `[]` | Image pull secrets. |
| jobCanceler.image.registry | string | `"docker.io/gams"` | Image registry. |
| jobCanceler.image.repository | string | `"engine-job-canceler"` | Image repository. |
| jobCanceler.image.tag | string | `""` | Image tag. |
| jobCanceler.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| jobCanceler.resources.limits | object | `{"memory":"400Mi"}` | Resource limits. |
| jobCanceler.resources.requests | object | `{"cpu":"50m","memory":"400Mi"}` | Resource requests. |
| jobSpawner.affinity | object | `{}` | Affinity settings for pod assignment. |
| jobSpawner.image.pullSecrets | list | `[]` | Image pull secrets. |
| jobSpawner.image.registry | string | `"docker.io/gams"` | Image registry. |
| jobSpawner.image.repository | string | `"engine-job-spawner"` | Image repository. |
| jobSpawner.image.tag | string | `""` | Image tag. |
| jobSpawner.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| jobSpawner.resources.limits | object | `{"memory":"500Mi"}` | Resource limits. |
| jobSpawner.resources.requests | object | `{"cpu":"100m","memory":"500Mi"}` | Resource requests. |
| jobSpawner.workerImage.pullSecrets | list | `[]` | Worker Image pull secrets. |
| jobSpawner.workerImage.registry | string | `"docker.io/gams"` | Worker Image registry. |
| jobSpawner.workerImage.repository | string | `"engine-worker"` | Worker Image repository. |
| jobSpawner.workerImage.tag | string | `""` | Worker Image tag. |
| jobSpawner.workerNetworkPolicy.extraEgress | list | `[]` | Extra egress rules for workers. |
| jobWatcher.affinity | object | `{}` | Affinity settings for pod assignment. |
| jobWatcher.image.pullSecrets | list | `[]` | Image pull secrets. |
| jobWatcher.image.registry | string | `"docker.io/gams"` | Image registry. |
| jobWatcher.image.repository | string | `"engine-job-watcher"` | Image repository. |
| jobWatcher.image.tag | string | `""` | Image tag. |
| jobWatcher.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| jobWatcher.resources.limits | object | `{"memory":"250Mi"}` | Resource limits. |
| jobWatcher.resources.requests | object | `{"cpu":"50m","memory":"250Mi"}` | Resource requests. |
| mongoMigrate.image.registry | string | `"docker.io/gams"` | Image registry. |
| mongoMigrate.image.repository | string | `"engine-mongo-migrate"` | Image repository. |
| mongoMigrate.image.tag | string | `""` | Image tag. |
| mongodb.affinity | object | `{}` | Affinity settings for pod assignment. |
| mongodb.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the volume. |
| mongodb.persistence.size | string | `"8Gi"` | Size of the persistent volume. |
| mongodb.persistence.storageClassName | string | `""` | Storage Class to use. |
| mongodb.resources.limits | object | `{"memory":"6Gi"}` | Resource limits. |
| mongodb.resources.requests | object | `{"cpu":"500m","memory":"5Gi"}` | Resource requests. |
| pgBouncer.affinity | object | `{}` | Affinity settings for pod assignment. |
| pgBouncer.networkPolicy.extraEgress | list | `[]` | Extra egress rules. |
| pgBouncer.resources.limits | object | `{"memory":"300Mi"}` | Resource limits. |
| pgBouncer.resources.requests | object | `{"cpu":"100m","memory":"200Mi"}` | Resource requests. |
| postgresql.affinity | object | `{}` | Affinity settings for pod assignment. |
| postgresql.database | string | `"gams_engine"` | The default database name. |
| postgresql.database_user | string | `"gams_engine"` | The default database user. |
| postgresql.externalDatabase.enabled | bool | `false` | Enable to use an external PostgreSQL. |
| postgresql.externalDatabase.host | string | `""` | Hostname of your external postgres database. |
| postgresql.externalDatabase.initialize.connectionString | string | `""` | Admin connection string. |
| postgresql.externalDatabase.initialize.run | bool | `true` | Run the one-time initialization job? |
| postgresql.externalDatabase.networkPolicy.namespaceSelector | object | `{"matchLabels":{}}` | Namespace Selector labels. |
| postgresql.externalDatabase.networkPolicy.podSelector | object | `{"matchLabels":{}}` | Pod Selector labels. |
| postgresql.externalDatabase.port | string | `""` | Port of your external postgres database. |
| postgresql.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the volume. |
| postgresql.persistence.size | string | `"4Gi"` | Size of the persistent volume. |
| postgresql.persistence.storageClassName | string | `""` | Storage Class to use. |
| postgresql.resources.limits | object | `{"memory":"3Gi"}` | Resource limits. |
| postgresql.resources.requests | object | `{"cpu":"500m","memory":"2Gi"}` | Resource requests. |
| postgresqlMigrate.image.registry | string | `"docker.io/gams"` | Image registry. |
| postgresqlMigrate.image.repository | string | `"engine-postgres-migrate"` | Image repository. |
| postgresqlMigrate.image.tag | string | `""` | Image tag. |
| rabbitmq.affinity | object | `{}` | Affinity settings for pod assignment. |
| rabbitmq.monitoring.podMonitorEnabled | bool | `false` | Enable monitoring (Requires Prometheus Operator). |
| rabbitmq.networkPolicy.extraIngress | list | `[]` | Add extra ingress rules. |
| rabbitmq.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the volume. |
| rabbitmq.persistence.size | string | `"4Gi"` | Size of the persistent volume. |
| rabbitmq.persistence.storageClassName | string | `""` | Storage Class to use. |
| rabbitmq.resources.limits | object | `{"memory":"6Gi"}` | Resource limits. |
| rabbitmq.resources.requests | object | `{"cpu":"500m","memory":"5Gi"}` | Resource requests. |
| rabbitmqMigrate.image.registry | string | `"docker.io/gams"` | Image registry. |
| rabbitmqMigrate.image.repository | string | `"engine-queue-migrate"` | Image repository. |
| rabbitmqMigrate.image.tag | string | `""` | Image tag. |
| useDefaultDenyNetworkPolicy | bool | `false` | If true, blocks all traffic in the namespace unless explicitly allowed. |
