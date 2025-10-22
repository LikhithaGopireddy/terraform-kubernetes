## validate, plan , apply
```
terraform validate
terraform plan
terraform apply
```

## update kubeconfig to set current cluster context
```
aws eks update-kubeconfig --region us-east-1 --name prod-eks-cluster
```

## *Mandatorily read important_eks_grant_access.md

## deploy the app & service 
```
kubectl apply -f app-deployment.yaml
kubectl apply -f app-service.yaml
```

## Install NGINX Ingress Controller
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.1/deploy/static/provider/aws/deploy.yaml
```
### Note: It will install the Ingress controller in the ingress-nginx namespace, creates the namespace if it doesn’t already exist.

## Wait for it to come up:
```
kubectl get pods -n ingress-nginx
```
### Expected o/p: Two pods are expected be in completed state (refer below image) as they are only ment for one time task.

<img width="464" alt="image" src="https://github.com/user-attachments/assets/17c6e59a-67a8-42b0-918e-acb1c9d46739" />


## deploy ingress resource Now!!
```
kubectl apply -f ingress.yaml
```

## Now hit localhost to access the application
```
localhost
```

## If you are on cloud, your native cloud provider load balancer will be created accordingly. Hit the following command & get the ip or external url to access the app on port 80.
```
kubectl get svc -n ingress-nginx
```
## you can also use the following command to get ip/external url.
```
kubectl get ingress
```

## Once you are done, cleanup the cluster 
```
eksctl delete cluster --name haneesh-cloud --region us-west-1
```

## *Delete the load balancer manually


### Ingress controller installation using Helm (optional)
```
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace
```

### Install helm in gitbash, Download Helm Binary
```

curl -LO https://get.helm.sh/helm-v3.16.2-windows-amd64.zip
unzip helm-v3.16.2-windows-amd64.zip
mkdir -p /c/Users/$USERNAME/bin
mv windows-amd64/helm.exe /c/Users/$USERNAME/bin/
export PATH=$PATH:/c/Users/$USERNAME/bin
helm version

```

### bitnami repo
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

```
### install prometheus
```
helm install prometheus bitnami/prometheus --namespace monitoring
kubectl get pods -n monitoring 
```

### Access the Prometheus Dashboard
```
kubectl port-forward svc/prometheus-server 9090:80 -n monitoring

```

