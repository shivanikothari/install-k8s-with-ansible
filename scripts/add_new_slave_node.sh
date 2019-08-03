#!/bin/bash
set -e
clear
. ./build.info

echo -e "\e[32mList of available nodes:\e[0m"
echo -e "\e[32m------------------------------------------\e[0m"
last_added_slave=`egrep -r "^slave([0-9]*)" $inventory_file_path | tail -1 | awk '{print $1}'`
sed -n "/^\[k8s-slave\]/,/^$last_added_slave/p" $inventory_file_path | sort | sed '1d'
echo ""

while [[ -z $slave_count ]]
do
   echo -e "\e[32mPlease enter the new number of slave nodes you want to add to kubernetes cluster:\e[0m"
   read slave_count
done

echo "new_k8s_node_count=$slave_count" >> $ansible_dir/installation.info

echo ""

echo > node.limit
for slave in $(seq 1 $slave_count); do

    last_node_count=`sed -n "/^\[k8s-slave\]/,/^$last_added_slave/p" $inventory_file_path | sort | awk '{print $1}' | tail -1 | sed -r 's~([a-z]*)([0-9]*)~\2~g'` 
    new_count=$((last_node_count + 1)) 

    echo -e "\e[32mPlease enter the IP address for node-$slave:\e[0m"
    read slave_ip

    echo "new_k8s_node-${slave}=$slave_ip" >> $ansible_dir/installation.info

    sed -i "/^\[k8s-slave\]/a slave$new_count ansible_ssh_host=$slave_ip" $inventory_file_path
    echo ""

    echo "slave$new_count," >> node.limit
done

limits=`cat node.limit |  tr '\n' ',' | sed 's~,,~,~g' | sed 's~^,~~g' | sed 's~,$~~g'`
set +e

. ./build.info
cd $ansible_dir
master_ip=`ansible --list-hosts k8s-master | grep master1| awk '{$1=$1};1'`
echo -e "\e[32mPlease enter root password for kubernetes master $master_ip\e[0m"

ansible-playbook plays/add-k8s-node.yaml  -u root -k --limit "$limits,master1"
