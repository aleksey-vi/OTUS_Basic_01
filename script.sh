#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт должен запускать пользователем с root правами"
   exit 1
else
   SEsys=$(getenforce)
   source /etc/selinux/config
   echo ""
   echo "Статус SElinux в системе: $SEsys, Статус в Конфиг файле: $SELINUX"
   echo ""
   # Проверяем в системе выключать ли силинукс
   if [[ $SEsys == "Enforcing" ]]; then
       read -p "Выключить в системе selinux? Yy(Да)/Nn(Нет): " ch
       if [[ $ch == Y || $ch == y ]]; then
           	sudo  setenforce 0
           	echo "Вы выключили SELinux в системе"
       fi
       # Проверяем в системе включать ли силинукс
   elif [[ $SEsys == "Permissive" ]]; then
      read -p "Включить в системе selinux? Yy(Да)/Nn(Нет): " ch
      if [[ $ch == Y || $ch == y ]]; then
       		sudo  setenforce 1
      		echo "Вы включили SELinux в системе"
      fi
   fi
   # Проверяем в конфигурационном файле
	if [[ $SELINUX == "disabled" ]]; then
       		read -p "В настоящий момент SELinux в конфигурационном файле в режиме DISABLED.Включить в конфигурационном файле SELinux? Yy(Да)/Nn(Нет): " ch
       		if [[ $ch == Y || $ch == y ]]; then
			read -p "Выберите режим работы SELinux? 1(Enforcing)/2(Permissive): " cf
			if [[ $cf == 1 ]]; then
        			sed -i 's/SELINUX=disabled/SELINUX=enforcing/g' /etc/selinux/config
       				echo "Вы включили SELinux в конфиг файле в режиме ENFORCING, перезагрузите систему"       
			else  
				sed -i 's/SELINUX=disabled/SELINUX=Permissive/g' /etc/selinux/config
                       		echo "Вы включили SELinux в конфиг файле в режиме PERMISSIVE, перезагрузите систему"
                	fi
      		fi
	elif  [[ $SELINUX == "enforcing" ]]; then
		read -p "В настоящий момент SELinux в конфигурационном файле в режиме ENFORCING. Изменить режим работы конфигурационного файла SELinux? Yy(Да)/Nn(Нет): " ch
       		if [[ $ch == Y || $ch == y ]]; then
        		read -p "Выберите режим работы SELinux? 1(DISABLED)/2(Permissive): " cf
                 	if [[ $cf == 1 ]]; then
                		sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
                 		echo "SELinux в конфиг файле в режиме DISABLED, перезагрузите систему"       
                 	else
				sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
                    		echo "Вы включили SELinux в конфиг файле в режиме PERMISSIVE, перезагрузите систему"
                 	fi	
      		fi
	elif [[ $SELINUX == "permissive" ]]; then
		read -p "В настоящий момент SELinux в конфигурационном файле в режиме PERMISSIVE. Изменить режим работы конфигурационного файла SELinux? Yy(Да)/Nn(Нет): " ch
       		if [[ $ch == Y || $ch == y ]]; then
        		read -p "Выберите режим работы SELinux? 1(DISABLED)/2(ENFORCING): " cf
                	if [[ $cf == 1 ]]; then
                   		sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
                        	echo "SELinux в конфиг файле в режиме DISABLED, перезагрузите систему"       
                	else  
                		sed -i 's/SELINUX=permissive/SELINUX=enforcing/g' /etc/selinux/config
                        	echo "Вы включили SELinux в конфиг файле в режиме ENFORCING, перезагрузите систему"
                	fi
       		fi
	fi
fi
