# Zcash Stack Helm Chart

This chart is a work in progress and has only been tested on Vultr Kubernetes Engine as of writing.

All of the "zec.rocks" Lightwalletd servers are provisioned using this.

## Prerequisites

1. A running Kubernetes cluster (this is currently tested on Vultr Kubernetes Engine)
2. The KUBECONFIG env variable set to your cluster's Kubernetes credentials file
3. Helm installed in your local environment

## Usage

1. Traefik is required to auto-provision LetsEncrypt SSL certificates.

    a. Edit ```install-traefik.sh``` to specify your real email address.

    b. Install Traefik on your cluster:

```
chmod +x install-traefik.sh
./install-traefik.sh
```

2. Edit an example values file from the ```./examples``` folder. Specify the domain name that you intend to host a lightwalletd instance on. View the ```values.yaml``` file to see all of the configuration options possible.

3. Install the chart on your cluster: (execute from this project's directory, specify your own yaml file if you did not modify an example in-place)

```
helm install zcash . -f examples/zebra-mainnet.yaml
```

### Upgrading

We highly recommend installing the "helm-diff" plugin.

Verify changes before you upgrade:
```
KUBECONFIG=~/.kube/config-eu1 helm diff upgrade zec-eu1 ~/dev/zcash-stack -f ./values-eu1.yaml
```

Then apply the upgrade:
```
KUBECONFIG=~/.kube/config-eu1 helm upgrade zec-eu1 ~/dev/zcash-stack -f ./values-eu1.yaml
```

### Kubernetes Cheat Sheet

If you're new to Kubernetes, here is a list of commands that you might find useful for operating this chart:

```
# See what is running in your cluster's default namespace
kubectl get all

# Watch logs
kubectl logs -f statefulset/lightwalletd
kubectl logs -f statefulset/zebra
kubectl logs -f statefulset/zcashd

# Open a shell in a running container
kubectl exec statefulset/zebra -ti -- bash

# Restart a part of the stack
kubectl rollout restart statefulset/lightwalletd
kubectl rollout restart statefulset/zebra
kubectl rollout restart statefulset/zcashd
```

## Works in progress

- Updated documentation to launch on AWS, GCP, and self-hosted (k3s)
- Support for hosting a block explorer
- Contribute to the P2P network by allowing inbound connections via a Kubernetes Service, only possible on Zcashd at the moment.
