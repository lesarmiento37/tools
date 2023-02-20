#!/bin/bash
#Determine whether you have an existing IAM OIDC provider for your cluster
aws eks --region us-east-1 update-kubeconfig --name aws-eks-kubernetes-produccion
aws eks describe-cluster --name aws-eks-kubernetes-produccion --query "cluster.identity.oidc.issuer" --output text

#Example output:
#https://oidc.eks.us-east-1.amazonaws.com/id/00C0272DC5B4980D9D85D31D4F846413

#List the IAM OIDC providers in your account. Replace <EXAMPLED539D4633E53DE1B716D3041E> (including <>) with the value returned from the previous command. 
#aws iam list-open-id-connect-providers | grep 00C0272DC5B4980D9D85D31D4F846413

#Example output
#"Arn": "arn:aws:iam::12345678910:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/00C0272DC5B4980D9D85D31D4F846413"

#Download an IAM policy for the AWS Load Balancer Controller that allows it to make calls to AWS APIs on your behalf. You can view the policy document on GitHub. 

#curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.3/docs/install/iam_policy.json

#aws iam create-policy \
#    --policy-name AWSLoadBalancerControllerIAMPolicy \
#    --policy-document file://iam_policy.json

#apply service-account aws-load-balancer-controller-service-account.yaml
#apply load-balacer-deployment

#Cluster Autoscaler

eksctl create iamserviceaccount \
  --cluster=aws-eks-kubernetes-produccion \
  --namespace=kube-system \
  --name=cluster-autoscaler \
  --attach-policy-arn=arn:aws:iam::564645646456:role/eks-kubernetes-produccion \
  --override-existing-serviceaccounts \
  --approve

eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster aws-eks-kubernetes-produccion \
    --approve

helm install cluster-autoscaler stable/cluster-autoscaler --set autoDiscovery.clusterName=aws-eks-kubernetes-produccion

# Install Cluster Cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.2/cert-manager.yaml

#Edit the saved yaml file, go to the Deployment spec, and set the controller --cluster-name arg value to your EKS cluster name
#Aws-load-balancer-controller

#aws iam create-policy \
#    --policy-name AWSLoadBalancerControllerIAMPolicy \
#    --policy-document file://iam-policy.json

eksctl create iamserviceaccount \
--cluster=aws-eks-kubernetes-produccion \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::12345678910:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--approve

#wget https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.2/docs/install/v2_1_2_full.yaml
#change the  eks-cluster-name and apply
kubectl apply -f aws-alb-controller.yaml

#Install metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml


#install kube-ops-view45
#helm install kube-ops-view kube-ops-view/
helm fetch stable/kube-ops-view --untar

#Install the coredns
aws eks create-addon \
    --cluster-name my-cluster \
    --addon-name coredns