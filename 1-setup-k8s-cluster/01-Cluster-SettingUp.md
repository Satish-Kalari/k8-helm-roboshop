Session-54 | DevOps with AWS - 76S 

# Setting Up Environment for Workstation and ClusterConfig

1.Create a workstation instance (with workstation.tf)
   - terraform apply -auto-approve

workstation instance installed with below components via workstation.sh
   -  docker 
   -  kubectl 
   -  eksctl 
   -  helm 
   -  k9s
   -  metric server
   -  kubens

2.Connect to workstation via supper putty
   check the installation of docker, kubectl, eksctl, helm
   - docker --version
   - kubectl version --short --client
   - eksctl version
   - helm version

3.aws configure 
   - aws configure
   - AWS Access Key
   - AWS Secret Key

4.git clone eks.yaml into workstation instance
   - git clone

5.Create the EKS cluster using eksctl
   - cd eksctl
   - eksctl create cluster --config-file=eks.yaml
   - eksctl delete cluster --config-file=eks.yaml 

6.Verify the creation of the EKS cluster and its nodes.
7.Access the EKS cluster from the workstation using kubectl commands.
      commands:
      - kubectl get nodes
      - kubectl get pods --all-namespaces
      - kubectl get svc
      - kubectl get deployments


kubeconfig -- a file contains authentication information to connect kubernetes cluster and should be moved to .kube folder and save as config

mkdir .kube
   - .kube is not made by default
   - kubectl will check a file in home folder ~/.kube/config (automatically)
cp kubeconfig .kube/config
   - copying kubeconfig from home folder to .kube/config and names as config

Now all command will work 
kubectl get nodes (ROLES: control-plane means master node)
---

# Install the k9s tool to manage the kubernetes cluster [via-workstation.sh]
- curl -sS https://webinstall.dev/k9s | bash
- k9s

# kubens configuration installation (https://github.com/ahmetb/kubectx)[via-workstation.sh]
in home directory of workstation
    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

then cd kubernetes-roboshop/catalogue
    kubens roboshop #this will set roboshop namespace as default, so every time we need not to give -n roboshop
    example: kubectl get pods instead of kubectl get pods -n roboshop
 
-----

*** Install and set up kubectl on the workstation *** [via-workstation.sh]
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client

Connecting workstation instance via ssh using GitBash
   ssh -i ~/.ssh/satish-git centos@<ec2-ipaddress> 
   ssh -i ~/.ssh/satish-git centos@52.72.239.88