#!/bin/bash
# Note: Vultr's minimum volume size on magnetic storage is 40Gi.
# Adjust below if you are not using Vultr, a very small volume is fine for storing the SSL certs.

helm upgrade --install traefik traefik/traefik --namespace=traefik --create-namespace -f <(echo '
certResolvers:
  letsencrypt:
    email: CHANGE_TO_YOUR_EMAIL@email.domain
    tlsChallenge: true
    httpChallenge:
      entryPoint: "web"
    storage: /data/acme.json
persistence:
  enabled: true
  storageClassName: "standard"
  accessMode: "ReadWriteOnce"
  size: "40Gi"
  path: "/data"
deployment:
  initContainers:
    - name: volume-permissions
      image: busybox:1.36
      command:
        ["sh", "-c", "touch /data/acme.json; chown -v 65532 /data/acme.json; chmod -v 600 /data/acme.json"]
      securityContext:
        runAsNonRoot: false
        runAsGroup: 0
        runAsUser: 0
      volumeMounts:
        - name: data
          mountPath: /data
')
