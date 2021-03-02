# DevOps Notes

## Install

```sh
brew install minikube

brew install helm
helm repo add stable https://charts.helm.sh/stable
helm search repo stable
helm repo update


helm install prometheus stable/prometheus-operator

minikube version
minikube status
minikube start
minikube ip

kubectl get pod
kubectl get pod -o wide
kubectl get all

kubectl get service
kubectl get deployment
kubectl get servicemonitor
kubectl get crd
kubectl describe pod prometheus-grafana-76cbbd744f-rk5j2

kubectl create -f replicaset-def.yml
kubectl get replicatset
kubectl delete replicaset myapp-replicaset
kubectl replace -f replicaset-def.yml
kubectl scale -replicas=6 -f replicaset-def.yml

# deployment strategy
# 1. Recreate
# 2. Rolling update
kubectl create -f deployment-def.yml
kubectl get deployments
kubecte apply -f deployment-def.yml
kubectl set image deployment/myapp-deployment nginx=nginx:1.9.1
kubectl rollout status deployment/myapp-deployment
kubectl rollout history deployment/myapp-deployment
kubectl rollout undo deployment/myapp-deployment

kubectl logs prometheus-grafana-76cbbd744f-rk5j2 grafana
kubectl port-forward deployment/prometheus-grafana 3000
```

Terraform vs Ansible

https://intellipaat.com/blog/terraform-vs-ansible-difference/#:~:text=Terraform%20and%20Ansible%20are%20two,configurations%20and%20scale%20them%20easily.&text=Both%20the%20tools%20help%20in,is%20a%20service%20orchestration%20tool.


