#!/bin/bash
#Check ansible installation:
set -e
clear

ANS_HOME=`pwd | sed -r 's~(.*?)/(.*)$~\1~g'`
sed -i "s~ansible_dir=.*~ansible_dir=$ANS_HOME/ansible/~g" build.info

. ./build.info

cluster_type=$1

echo >  $ansible_dir/installation.info


#Configure inventory:
echo ""

if [[ "$cluster_type" == "single" ]];
then
	while [[ -z $master_ip ]]
	do
	  echo -e "\e[32mPlease enter the IP address on which you need to install kubernetes master:\e[0m"
	  read master_ip
	done
		sed -ri '/^master([0-9])*/d'  $inventory_file_path
                set_inv=`echo "master1 " | sed 's~\.~-~g'`
		sed -i "/^\[k8s-master\]/a $set_inv ansible_ssh_host=$master_ip" $inventory_file_path
		echo "k8s_master_ip=$master_ip" >> $ansible_dir/installation.info
	        sed -ir "s~^cluster_type:.*~cluster_type: \"$cluster_type\"~g" $master_group_file_path

elif [[ "$cluster_type" == "multi" ]];
then
      sed -ri '/^master([0-9])*/d'  $inventory_file_path
      echo > $ansible_dir/plays/roles/k8s-master/files/ha.master

        while [[ -z $master_ip ]]
        do
          echo -e "\e[32mPlease enter the IP address for kubernetes master-1 installation:\e[0m"
          read master_ip
        done
		set_inv=`echo "master1-$master_ip " | sed 's~\.~-~g'`
                sed -i "/^\[k8s-master\]/a $set_inv ansible_ssh_host=$master_ip" $inventory_file_path
                echo "k8s_master_ip=$master_ip" >> $ansible_dir/installation.info
		echo ""

      for i in `seq 2 3`; do
        echo -e "\e[32mPlease enter the IP address for kubernetes master-$i installation:\e[0m"
        read master_ip
	echo ""

	set_inv=`echo "master$i-$master_ip " | sed 's~\.~-~g'`
        sed -i "/^\[k8s-master-HA\]/a $set_inv ansible_ssh_host=$master_ip" $inventory_file_path
        echo "k8s_master_ip=$master_ip" >> $ansible_dir/installation.info
        echo "$master_ip $set_inv" >> $ansible_dir/plays/roles/k8s-master/files/ha.master
    done
	sed -ir "s~^cluster_type:.*~cluster_type: \"$cluster_type\"~g" $master_group_file_path
fi

if [[ $cluster_type = multi ]];
then
	while [[ -z $LB_IP_ADDRESS ]]
	do
	        echo -e "\e[32mPlease enter the IP address for LoadBalancer:\e[0m"
        	read LB_IP_ADDRESS
                sed -ir "s~^LB_IP_ADDRESS:.*~LB_IP_ADDRESS: \"$LB_IP_ADDRESS\"~g" $master_group_file_path
	done

        while [[ -z $LB_APISERVER_PORT ]]
        do
	        echo -e "\e[32mPlease enter the port configured with LoadBalancer:\e[0m"
        	read LB_APISERVER_PORT
	        sed -ir "s~^LB_APISERVER_PORT:.*~LB_APISERVER_PORT: \"$LB_APISERVER_PORT\"~g" $master_group_file_path
	done
        
fi

echo ""
while [[ -z $slave_count ]]
do
   echo -e "\e[32mPlease enter the number of slave nodes you want for kubernetes cluster deployment:\e[0m"
   read slave_count
done

echo "k8s_node_count=$slave_count" >> $ansible_dir/installation.info

echo ""

sed -ri '/^slave([0-9])*/d'  $inventory_file_path

for slave in $(seq 1 $slave_count); do
    echo -e "\e[32mPlease enter the IP address for node-$slave:\e[0m"
    read slave_ip
    echo "k8s_node-${slave}=$slave_ip" >> $ansible_dir/installation.info
    sed -i "/^\[k8s-slave\]/a slave$slave ansible_ssh_host=$slave_ip" $inventory_file_path
    echo ""
done




echo "*************************************PreConfiguration Completed Successfully.*************************************************************"
set +e

