clear
set -e
echo "********************************************Deploying Kubernetes Cluster********************************************"

echo ""
. ./build.info
status=$1

#Cluster Deployment:
cd $ansible_dir
master_ip=`ansible --list-hosts k8s-master | grep master1| awk '{$1=$1};1'`

create_k8s_cluster() {

echo -e "\e[32mPlease enter root password for kubernetes master $master_ip\e[0m"

if [ "$status" = "single" ];then
	ansible-playbook plays/kubernetes-cluster.yaml -k -u root
elif [ "$status" = "multi" ];then
	ansible-playbook plays/kubernetes-ha-cluster.yaml -k -u root
fi


#Helm installation
echo -e "\e[32mPlease enter root password for kubernetes master $master_ip\e[0m"
ansible-playbook plays/install-helm.yaml -k -u root

#Deploy Dashboard
ansible-playbook plays/deploy-k8s-dashboard.yaml -u kubemaster -e "ansible_ssh_pass=kubemaster"

}


if echo "$master_ip" | egrep -o "master(.*?)[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}|master1"  > /dev/null
then
        create_k8s_cluster
        
        echo ""
        echo ""
        echo -e "\e[35m********************************************************Installation Completed.*************************************************************************\e[0m"
        IP=`grep $master_ip ./inventory/hosts| egrep -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"`
        secret=`ansible master1-10-151-32-177 -m shell -a "kubectl -n kube-system get secret | grep admin-user| cut -d' ' -f1" -u kubemaster -e "ansible_ssh_pass=kubemaster" | tail -1`
        token=`ansible master1-10-151-32-177  -u kubemaster -e "ansible_ssh_pass=kubemaster" -m shell -a   "kubectl -n kube-system describe secret $secret"  | grep token: | awk '{print $2}'`
        echo ""
        echo ""
        echo -e "\e[32mTo access k8s cluster follow below steps:\e[0m"
        echo ""
        echo -e "\e[32m1. Login to $IP:\e[0m"
        echo ""
        echo -e "\e[32m2. Switch User:\e[0m"
        echo -e "\e[33m\t\t$ su - kubemaster\e[0m"
        echo ""
        echo -e "\e[32m3. Get node details:\e[0m"
        echo -e "\e[33m\t\t$ kubectl get nodes\e[0m"
        echo ""
        echo -e "\e[32m4. Get system pod details:\e[0m"
        echo -e "\e[33m\t\t$ kubectl get pods -n kube-system\e[0m"
        echo ""
        echo -e "\e[32m5. To access k8s dashboard, visit\e[0m"
        echo -e "\e[33m\t\t https://$IP:30495/\e[0m"
        echo ""
        echo -e "\e[32m6. Access token:\e[0m"
        echo -e "\e[33m\t\t$token\e[0m"
else
        echo -e "\e[33mHost details not found. Kindly execute the pre-configuration step first.\e[0m"
fi


set +e
