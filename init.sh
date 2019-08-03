#!/bin/ksh
main()
{
        while :
        do
                clear
                echo Date: `date`
                echo ""
		echo -e "\e[32mDeploy Application with Kubernetes\e[0m"
                echo -e "\e[32m----------------------------------------------------------------------\e[0m"
                echo "    1. Pre-Configuration for Single K8s Master."
                echo "    2. Pre-Configuration for High-Availability K8s Master.(Recommended for production use.)"
                echo "    3. Deploy Kubernetes Cluster."
                echo "    4. Add a new node to k8s cluster."
                echo "    5. Destroy k8s cluster."
                echo "    0. Exit"
                echo " "
                read line;

                case $line in
                        1)
				cd scripts;
				sh 1_prerequisite_config.sh single
                                echo "master_deployment=single" > master-deployment.info
				exit;
                        ;;
                        2)
                                cd scripts;
                                sh 1_prerequisite_config.sh multi
				echo "master_deployment=multi" > master-deployment.info
                                exit;
                        ;;
                        3)
                                cd scripts;

				do_deploy(){
						status=`grep "master_deployment" master-deployment.info | awk -F "=" '{print $2}'`
						if [[ "$status" = "single" || "$status" = "multi" ]]
						then
		                	                sh 2_deploy_k8s_cluster.sh $status
                		        	        exit;
						else
						     echo "Please provide master deployment type(single/multi)"
						     read status
	
						     sh 2_deploy_k8s_cluster.sh $status
						     exit;
						fi
				}

                       		if [ -f "master-deployment.info" ] ; then
                                        do_deploy
                                else
                                                echo "--"
                                                echo -e "\e[33mPreconfiguration is not executed yet. Please execute it first.\e[0m"
                                                exit;
                                        fi

			;;
                        4)
                                cd scripts;
				sh add_new_slave_node.sh
                                exit;
                        ;;
                        5)
                                cd scripts;
                                sh destroy_k8s.sh
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

