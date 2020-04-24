# xcube-gen cluster on AWS

## Installation

Adapt xcube-gen-cluster.yaml and deploy-tls-termination.yaml to your needs.
For the tls nginx ingress controller, pelase refer to its 
[Installation Guide](https://kubernetes.github.io/ingress-nginx/deploy/)  


```bash
eksctl create cluster -f xcube-gen-cluster.yaml
kubectl apply -f deploy-tls-termination.yaml
```

