Metric server is a cluster-wide aggregator of resource usage data. 
- It is not installed by default in the k8s cluster. 
- It is used by HPA and VPA to scale the pods based on the CPU and Memory usage. 
- It is a replacement for Heapster.
- It is a cluster level resource.

# HPA and VPA
- HPA: Horizontal Pod Autoscaler
- VPA: Vertical Pod Autoscaler

in workstation super putty
# Installation of metric server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

To check the metric server is installed or not
    kubectl top nodes
    kubectl top pods

# implementing resource for metric server in deployment
need to mention the resource in the deployment file of metric server
resources:
  limits:
    cpu: 100m
    memory: 64Mi
  requests:
    cpu: 50m
    memory: 128Mi

# HPA
- It is used to scale the pods based on the CPU and Memory usage.
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .Values.name }}-hpa
  namespace: {{ .Values.namespace }}
spec:
    scaleTargetRef:
        apiVersion: apps/v1
        kind: Deployment
        name: {{ .Values.name }}
    minReplicas: 1
    maxReplicas: 10
    metrics:
    - type: Resource
        resource:
        name: cpu
        targetAverageUtilization: 50
    - type: Resource
        resource:
        name: memory
        targetAverageUtilization: 50

# load testing
- To check the HPA is working or not
script to generate the load on the application
    kubectl run --tty load-generator --rm --image=busybox:1.28 -restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://<place-web-hpa-url>; done"

kubectl get hpa # to check the status of HPA
kubectl describe hpa # to check the details of HPA
