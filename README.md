# How to start using GAMS Engine in Kubernetes?

The following prerequisites are required for using GAMS Engine in Kubernetes.

1. A Kubernetes Cluster
1. `kubectl` is installed and pointing to the cluster
1. `helm`, version >= 3.0, is installed

## Deploy Engine

- Extract `gams_engine.zip` file into a folder
- `cd` into that folder
- Run `up.sh` to deploy Engine.

## Setup GAMS nodes

If you want to limit the machines on which GAMS jobs can be run, you must label each "node" (which can be a physical or virtual computer) as follows:

- To see the node names `kubectl get nodes`
- `kubectl label nodes <nodename> gamslice=exists`

Don't forget to add `gamslice=exists` to the node selectors when creating instances.

## Setup reverse proxy and Engine UI

This solution is for On-Prem Kubernetes, if you wish to use LoadBalancer go to next
section. Follow these steps, in a computer that can access to Kubernetes nodes that host
your application.

- Install nginx from https://nginx.org/en/docs/install.html
- Find IP address of any Kubernetes node
- Open `engine.conf` in your favorite editor and replace `some_ip_addr` with the IP
- Remove the nginx default configuration that comes with the NGINX installation
  (in case it exists). `sudo rm /etc/nginx/conf.d/default.conf`. Note that the location
  of your nginx installation may vary depending on your package system
  (e.g. `/usr/local/nginx/conf` or `/usr/local/etc/nginx`). The default configuration
  might also be directly inside `/etc/nginx/nginx.conf`. In this case, you need to
  comment the corresponding lines out/delete them.
- Copy the Engine UI directory: `sudo cp -r engine /usr/share/nginx`
- Copy the Engine nginx configuration file: `sudo cp engine.conf /etc/nginx/conf.d/`
- Reload NGINX `sudo nginx -s reload`

  - If `No such file or directory` error displays, call `sudo nginx`

## Setup LoadBalancer

When you use a managed Kubernetes, you will want to use LoadBalancer instead of previous
solution. Follow these steps:

- Remove `NodePort` service with `kubectl delete service broker-ext`
- Run `kubectl apply -f broker_with_nginx.yml`

## Migrations

When there is a newer version of the GAMS Engine, you should update your system as
soon as possible. If the images of the stateless containers update before migrating the
stateful containers, you might experience undefined behaviour. To update your system

- Do not accept new requests, `kubectl scale deployment broker-deployment --replicas=0`
- Wait until the REST API is down, `kubectl get deployment broker-deployment` to check
- Check all workers to see if there is running job
  - `kubectl get pods | grep worker-deployment | cut -d' ' -f1` to list all worker pods
  - `kubectl log <pod name>` to get worker log
- Wait until jobs are finished
- Down all workers, `kubectl scale deployment worker-deployment --replicas=0`
- Apply the migrations, `kubectl apply -f migrations.yml`
- Check status of migrations until they are finished with `kubectl get jobs`
- When all the migrations are finished call `kubectl delete -f migrations.yml`
- Up all workers, `kubectl scale deployment worker-deployment --replicas=x` where x any
  number that your license allows and you want.
- Up the REST API, `kubectl scale deployment broker-deployment --replicas=2`
