  
# create eks cluster
 cd 000-setup-k8s-cluster 
    refer 000-setup-k8s-cluster/01-Cluster-SettingUp.md

Before creating statefulset, 
    need to install EBS driver for the storage class to work
    refer 000-setup-k8s-cluster/02-before-statefulset.md
    
# creating namespace
    kubectl apply -f namespace.yaml

# Setting up kubens
    kubens roboshop

# k9s setup [via-workstation.sh]
    curl -sS https://webinstall.dev/k9s | bash
    k9s

# Docker images should be present in the docker hub
    docker login
    docker images

# cd k8-helm-roboshop/01-mongodb
    helm install mongodb . 
        helm upgrade mongodb .
        helm uninstall mongodb
            helm list -n roboshop
            helm  history mongodb
            kubectl get pods
            kubectl get pvc
            kubectl get pv
            kubectl describe pod mongodb-0
            kubectl describe pvc mongodb-0

# cd k8-helm-roboshop/02-redis
    helm install redis .

# cd k8-helm-roboshop/03-mysql
    helm install mysql .

# cd k8-helm-roboshop/04-rabbitmq
    helm install rabbitmq .

# cd k8-helm-roboshop/05-catalogue
    helm install catalogue .

# cd k8-helm-roboshop/06-user
    helm install user .

# cd k8-helm-roboshop/07-cart
    helm install cart .

# cd k8-helm-roboshop/08-payment
    helm install payment .

# cd k8-helm-roboshop/09-shipping
    helm install shipping .

# set up metric server
    refer 04-metric-server.md
    
# install ingress controller [for-web-alb]
    refer 05-Installing-Ingress-Controller.md
        
# add inbound rules in security group for alb [in-aws-console]
    select any node instance -> actions -> security ->click on the security group -> edit inbound rules -> add rule -> all traffic -> source: 0.0.0.0/0

# cd k8-helm-roboshop/10-web
    helm install web .

# run apache bench tool [in-workstation]
    refer 000-setup-k8s-cluster/06-apahe-bench.md
    sudo yum install httpd-tools -y
    ab -c 1000 -n 100000 -k http://web.roboshop.projoy.store/

# after running the apache bench tool, check the pods and pvc


***even after running helm uninstall, the pvc and pv are still present.*** 
    kubectl get pvc
    kubectl get pv
    kubectl describe pvc mysql
    kubectl describe pv mysql
    kubectl delete pvc mysql
    kubectl delete pv mysql
    kubectl get pvc
    kubectl get pv

## Once practice done delete all volumes in aws ec2 console manually.