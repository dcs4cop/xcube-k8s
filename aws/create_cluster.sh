eksctl create cluster \
--name xcube-gen \
--region eu-central-1 \
--nodegroup-name xcube-gen-workers \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--managed


eksctl utils associate-iam-oidc-provider --cluster=xcube-gen --approve

aws iam create-policy \
  --policy-name ALBIngressControllerIAMPolicyXC \
  --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/iam-policy.json

eksctl create iamserviceaccount \
  --cluster=xcube-gen \
  --namespace=kube-system \
  --name=alb-ingress-controller \
  --attach-policy-arn=arn:aws:iam::346516713328:policy/ALBIngressControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

kubectl apply -f alb-ingress-controller.yaml

# kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=xcube-gen:default
