# Introduction:
Kubernetes (k8s) is an open-source system for automating deployment, scaling, and management of containerized applications. Initially developed by Google based on its experience of running containers in production and now is actively developed by a community around the world.

## Get Started:
* This setup will help you to install following components:
 1. Docker on all the nodes.
 2. kubeadm for creating k8s cluster.
 3. Weave network plugin for establishing k8s cluster networking.
 4. Helm - kubernetes package manager installation.
 5. Kubernetes Dashboard
  
### Prerequisite for deploying K8s Cluster:
* At minimum you will require two host machines for deploying a kubernetes cluster.  
    - Required OS Version: CentOS Linux release 7.4 (Core)
    - Both machines should have same root credentials at the time of initial cluster setup.
    - Ansible package to be installed on host machine where you are clonning this project.

### Steps to create Kubernetes Cluster:
#### Step 1 : Pre Configuration
* This step will prompt you for details required to setup Kubernetes master and slave master and will according update your inventory file.
* Select option 1 or 2 based on the desired setup.
    ````
        $ cd ~/Kubernetes/
        $ sh init.sh 
        Date: Thu Aug 30 14:54:59 IST 2019

        Deploy Application with Kubernetes
        ----------------------------------------------------------------------
        1. Pre-Configuration for Single K8s Master.
        2. Pre-Configuration for High-Availability K8s Master.(Recommended for production use.)
        3. Deploy Kubernetes Cluster.
        4. Add a new node to k8s cluster.
        5. Destroy k8s cluster.
        0. Exit
		1
    ````
### Step 2 : Kubernetes Cluster Deployment
* In Kubernetes setup we have master and slave nodes. Slave nodes are also known as worker node or Minion. From the master node we manage the cluster and its nodes using ‘kubeadm‘ and ‘kubectl‘  command.
````
        $ cd ~/Kubernetes/
        $ sh init.sh 
        Date: Thu Aug 30 14:54:59 IST 2019

        Deploy Application with Kubernetes
        ----------------------------------------------------------------------
        1. Pre-Configuration for Single K8s Master.
        2. Pre-Configuration for High-Availability K8s Master.(Recommended for production use.)
        3. Deploy Kubernetes Cluster.
        4. Add a new node to k8s cluster.
        5. Destroy k8s cluster.
        0. Exit        
     3
````
### On the Master Node following components will be installed:
* API Server  – It provides kubernetes API using Jason / Yaml over http, states of API objects are stored in etcd
* Scheduler  – It is a program on master node which performs the scheduling tasks like launching containers in worker nodes based on resource availability
* Controller Manager – Main Job of Controller manager is to monitor replication controllers and create pods to maintain desired state.
* etcd – It is a Key value pair data base. It stores configuration data of cluster and cluster state.
* Kubectl utility – It is a command line utility which connects to API Server on port 6443. It is used by administrators to create pods, services etc.

### On Worker Nodes following components will be installed:
* Kubelet – It is an agent which runs on every worker node, it connects to docker  and takes care of creating, starting, deleting containers.
* Kube-Proxy – It routes the traffic to appropriate containers based on ip address and port number of the incoming request. In other words we can say it is used for port translation.

## Verification:
````
# Login with kubemaster user on k8s master machine. (Password is same as the username you can change this once installation is done.)

# kubectl get nodes
NAME         STATUS    AGE       VERSION
k8s-master   Ready     1h        v1.14.2

# kubectl  get pods  --all-namespaces
NAME                                    READY   STATUS    RESTARTS   AGE
coredns-fb8b8dccf-n4fhw                 1/1     Running   0          1d
coredns-fb8b8dccf-rlxfp                 1/1     Running   0          1d
etcd-master1                            1/1     Running   0          1d
kube-apiserver-master1                  1/1     Running   0          1d
kube-controller-manager-master1         1/1     Running   0          1d
kube-proxy-42d9l                        1/1     Running   0          1d
kube-proxy-ck767                        1/1     Running   0          1d
kube-proxy-wtjc6                        1/1     Running   0          1d
kube-scheduler-master1                  1/1     Running   0          1d
kubernetes-dashboard-5f7b999d65-glzrg   1/1     Running   0          1d
tiller-deploy-8458f6c667-lvrjx          1/1     Running   0          1d
weave-net-5wrdt                         2/2     Running   0          1d
weave-net-gmsjw                         2/2     Running   0          1d
weave-net-n22gs                         2/2     Running   0          1d
````

### Accessing kubernetes dashboard:
````
# kubectl  get svc -n kube-system
NAME                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                  AGE
kube-dns               ClusterIP   10.96.0.10     <none>        53/UDP,53/TCP,9153/TCP   1d
kubernetes-dashboard   NodePort    10.111.12.61   <none>        443:30495/TCP            1d
tiller-deploy          ClusterIP   10.98.4.12     <none>        44134/TCP                1d
````
* Open your browser with below url and we will be able to access kubernetes dashboard.
      https://<master-ip>:30495/

## Adding new nodes to Cluster
````        
        $ cd ~/Kubernetes/
        $ sh init.sh 
        Date: Thu Aug 30 14:54:59 IST 2019

        Deploy Application with Kubernetes
        ----------------------------------------------------------------------
        1. Pre-Configuration for Single K8s Master.
        2. Pre-Configuration for High-Availability K8s Master.(Recommended for production use.)
        3. Deploy Kubernetes Cluster.
        4. Add a new node to k8s cluster.
        5. Destroy k8s cluster.
        0. Exit
        
        4
````
## Destroy Cluster
    - This script will destroy the kubernetes cluster.
````        
        $ cd ~/Kubernetes/
        $ sh init.sh 
        Date: Thu Aug 30 14:54:59 IST 2019

        Deploy Application with Kubernetes
        ----------------------------------------------------------------------
        1. Pre-Configuration for Single K8s Master.
        2. Pre-Configuration for High-Availability K8s Master.(Recommended for production use.)
        3. Deploy Kubernetes Cluster.
        4. Add a new node to k8s cluster.
        5. Destroy k8s cluster.
        0. Exit
        
        5
````
