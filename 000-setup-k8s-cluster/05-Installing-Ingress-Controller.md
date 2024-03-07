# Installing Ingress Controller
we need this so that eks can create a load balancer and route the traffic to the services

alb ingress controller
- ALB Ingress Controller is an Ingress controller that configures AWS Application Load Balancers (ALB) to route traffic to Kubernetes services.

https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.7/deploy/installation/

in workstation super putty
# 1. Create an IAM OIDC provider. You can skip this step if you already have one for your cluster.
    eksctl utils associate-iam-oidc-provider \
        --region <region-code> \
        --cluster <your-cluster-name> \
        --approve

# 2. Download an IAM policy for the LBC using one of the following commands
    curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.0/docs/install/iam_policy.json

# 3. Create an IAM policy named AWSLoadBalancerControllerIAMPolicy. If you downloaded a different policy, replace iam-policy with the name of the policy that you downloaded.
    aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json

# 4. Create an IAM role and Kubernetes ServiceAccount for the LBC. Use the ARN from the previous step.
eksctl create iamserviceaccount \
--cluster=<cluster-name> \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::<AWS_ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region <region-code> \
--approve

# 5. Add controller to cluster
5.1.Add the EKS chart repo to Helm
    helm repo add eks https://aws.github.io/eks-charts
5.2. If upgrading the chart via helm upgrade, install the TargetGroupBinding CRDs.
    wget https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml
    kubectl apply -f crds.yaml
5.3. Helm install command for clusters with IRSA:
    helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=<cluster-name> --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

# 6. Give ec2 instance role permission to create load balancer [in-aws-console]
    - Go to ec2 dashboard
    - Select the any node instance
    - Actions -> Security -> clcik on iam role
    - click on add permissions -> attach policies
    - search for "AmazonEC2FullAccess" and attach it
    
# 7. create route53 record set [in-aws-console]
    - Go to route53 dashboard
    - click on hosted zones
    - click on the hosted zone
    - click on create record 
    - record name: *
    - route traffic to: alias to application and classic load balancer
    - region: us-east-1
    - select the target as the load balancer that is created by the ingress controller

# ingress controller
- Ingress is a Kubernetes API object that manages external access to services in a cluster, typically HTTP.
- Ingress may provide load balancing, SSL termination and name-based virtual hosting.
- Ingress Controller is a daemon, deployed as a pod in a cluster, that watches the apiserver's /ingresses endpoint for updates to the Ingress resource.
- Its job is to satisfy requests for Ingresses.
- It does this by updating the configuration of a load balancer provided by the cloud provider.
- Different ingress controllers have different capabilities.
- Ingress controllers are not started automatically, they need to be deployed.
- Ingress controllers are not part of the Kubernetes core, but they are part of the Kubernetes ecosystem.

# context path vs host path
- context path: /catalogue
    example.com/catalogue
- host path: catalogue.example.com
    
so host path can be used to route to different services based on the host name, and context path can be used to route to different services based on the path.