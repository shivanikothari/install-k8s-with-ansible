#!/bin/ksh
main()
{

        while :
        do
                clear
                echo Date: `date`
                echo " "
		echo -e "\e[31mAre you sure you want to destroy your kubernetes cluster?\e[0m"
                echo -e "\e[31m-------------------------------------------------------\e[0m"
                echo "    1. Yes"
                echo "    2. No"
                echo "    0. Exit"
                echo " "
                read line;

                case $line in
                        1)
				. ./build.info
				cd $ansible_dir
                       	        echo ""

				master_ip=`ansible --list-hosts k8s-master | grep master1| awk '{$1=$1};1'`
			        echo -e "\e[32mPlease enter root password for kubernetes master $master_ip\e[0m"
			        ansible-playbook plays/reset-cluster.yaml  -u root -k
				exit;
                        ;;
                        2)
				exit;
			;;
                        0)
                                clear
                                exit
                       ;;
                esac
        done
}
#Start program execution here
trap "main" 2 3
main

# exit
