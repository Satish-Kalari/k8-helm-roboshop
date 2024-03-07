Before staring StateFulSet:

# 1. EC2 role access for EBS CSI driver in aws console
2a. select any node ec2 instance
2b. under security, click on IAM role    
2c. in permissions policy, click on add permissions
2d. search for AmazonEBSCSIDriverPolicy and select it
2e. select the policy and click on attach policy


# 2. installing EBS CSI driver
Access workstation ec2 instance via supper putty
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
helm upgrade --install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver

# 3. install storage class
kubeclt apply -f ebs-sc.yaml
this same storage class name should be used in all statefulsets

***if this statefulset is part of a namespace, then the storage class should be created in the same namespace***
