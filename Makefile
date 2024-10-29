include ./.env
export

build:
	- docker build -t ${REPO} ./docker-file

build_verbose:
	- docker build --progress=plain -t ${REPO} ./docker-file

build_no_cache:
	- docker build --no-cache --pull -t ${REPO} ./docker-file

commit:
	- docker commit ${STACK} ${REPO};

login:
	- echo ${DOCKERHUB_PASS} | docker login -u ${DOCKERHUB_USER} --password-stdin

push:
	- docker push ${REPO}

pull:
	- docker pull ${REPO}

run:
	- docker run -d --name ${STACK} ${REPO}

mkdir:
	- mkdir -p ./vol/www/wwwroot
	- mkdir -p ./vol/www/server/data
	- mkdir -p ./vol/www/server/panel/vhost
	- mkdir -p ./vol/www/server/panel/data
	- mkdir -p ./vol/www/server/panel/ssl

	# fix apache ssl  restart
	- mkdir -p ./vol/www/server/apache/conf/extra
	- touch ./vol/www/server/apache/conf/extra/httpd-ssl.conf
	- touch ./vol/www/server/apache/conf/httpd.conf


	- mkdir -p ./vol/www/server/nodejs
	- mkdir -p ./vol/www/server/python_manager/versions

	- mkdir -p ./vol/www/server/panel/plugin/pythonmamager
	- mkdir -p ./vol/www/server/python_manager/panel/plugin/pythonmamager/
	- touch ./vol/www/server/python_manager/panel/plugin/pythonmamager/config.json
	- touch ./vol/www/server/python_manager/panel/plugin/pgsql_manager_dbuser_info.json

	- mkdir -p ./vol/www/server/pgsql
	- mkdir -p ./vol/www/server/pass
	- mkdir -p ./vol/www/wwwlogs
	- mkdir -p ./vol/www/backup
	- mkdir -p ./vol/www/vmail
	- mkdir -p ./vol/etc

	- make --no-print-directory run
	- docker cp ${STACK}:/www/wwwroot ./vol/www
	- docker cp ${STACK}:/www/server/data ./vol/www/server
	- sudo docker cp ${STACK}:/www/server/panel/vhost ./vol/www/server/panel
	- sudo docker cp ${STACK}:/www/server/panel/data ./vol/www/server/panel
	- sudo docker cp ${STACK}:/www/server/panel/ssl ./vol/www/server/ssl
	- sudo docker cp ${STACK}:/www/server/nodejs ./vol/www/server/nodejs
	- sudo docker cp ${STACK}:/www/server/python_manager/versions ./vol/www/server/python_manager
	- sudo docker cp ${STACK}:/www/server/python_manager/panel/plugin/pythonmamager/config.json ./vol/www/server/panel/plugin/pythonmamager/config.json
	- sudo docker cp ${STACK}:/www/server/python_manager/panel/plugin/pgsql_manager_dbuser_info.json ./vol/www/server/panel/plugin/pgsql_manager_dbuser_info.json
	- docker cp ${STACK}:/www/server/pgsql ./vol/www/server/pgsql
	- docker cp ${STACK}:/www/wwwlogs ./vol/www
	- sudo docker cp ${STACK}:/www/backup ./vol/www
	- docker cp ${STACK}:/www/vmail ./vol/www
	- docker cp ${STACK}:/etc/hosts ./vol/etc/hosts
	- docker cp ${STACK}:/etc/resolv.conf ./vol/etc/resolv.conf
	- cp -r ./docker-file/provision ./vol

	- docker rm ${STACK} -f

up:
	- docker compose -p ${STACK} -f "./docker-compose.yml" up -d
	

rm:
	- docker rm ${STACK} -f
	- docker rm ${STACK}_wt -f

bt:
	- docker exec -it ${STACK} bt;

bash:
	- docker exec -it ${STACK} bash;
	
perm:
	- docker exec -u 0 ${STACK} chown -R mysql:mysql /www/server/data; 
	- docker exec -u 0 ${STACK} chown root:root -R /www/server/panel/vhost; 
	- docker exec -u 0 ${STACK} chown root:root -R /www/server/panel/data; 
	- docker exec -u 0 ${STACK} chown ${AAP_USER}:www /www/wwwroot; 
	- docker exec -u 0 ${STACK} find /www/wwwroot -type d -exec chmod 775 {} \; ; 
	- docker exec -u 0 ${STACK} find /www/wwwroot -type f -exec chmod 664 {} \; ; 
	- docker exec -u 0 ${STACK} chown root:root /www/wwwroot/*/.user.ini; 
	- docker exec -u 0 ${STACK} chmod 440 /www/wwwroot/*/.user.ini; 
	- docker exec -u 0 ${STACK} chown www:www /www/wwwlogs; 
	- docker exec -u 0 ${STACK} chown root:root /www/backup; 
	- docker exec -u 0 ${STACK} chown vmail:mail /www/vmail; 
	- docker exec -u 0 ${STACK} chown ${LINUX_USER_NAME}:${LINUX_USER_NAME} /home/${LINUX_USER_NAME}; 
	- docker exec -u 0 ${STACK} chown root:root /root; 

rmdir:
	- sudo rm -Rf ./vol/

mass_pull:
	- docker pull ${MASS_REPO};
	- docker pull ${MASS_REPO}-apache;
	- docker pull ${MASS_REPO}-nginx;
	- docker pull ${MASS_REPO}-ols;
	- docker pull ${MASS_REPO}-mail;
mass_up:
	- docker run --name ${STACK}        --env-file=./.env -d -p 7801:7800 ${MASS_REPO}
	- docker run --name ${STACK}-apache --env-file=./.env -d -p 7802:7800 ${MASS_REPO}-apache
	- docker run --name ${STACK}-nginx  --env-file=./.env -d -p 7803:7800 ${MASS_REPO}-nginx
	- docker run --name ${STACK}-ols    --env-file=./.env -d -p 7804:7800 ${MASS_REPO}-ols
	- docker run --name ${STACK}-mail   --env-file=./.env -d -p 7805:7800 ${MASS_REPO}-mail
mass_run: 
	- docker run --name ${STACK}        --env-file=./.env -d ${MASS_REPO}
	- docker run --name ${STACK}-apache --env-file=./.env -d ${MASS_REPO}-apache
	- docker run --name ${STACK}-nginx  --env-file=./.env -d ${MASS_REPO}-nginx
	- docker run --name ${STACK}-ols    --env-file=./.env -d ${MASS_REPO}-ols
	- docker run --name ${STACK}-mail   --env-file=./.env -d ${MASS_REPO}-mail
mass_update:
	- docker exec ${STACK} bash -c "apt-get update -y"
	- docker exec ${STACK}-apache bash -c "apt-get update -y"
	- docker exec ${STACK}-nginx bash -c "apt-get update -y"
	- docker exec ${STACK}-ols bash -c "apt-get update -y"
	- docker exec ${STACK}-mail bash -c "apt-get update -y"

	- docker exec ${STACK} bash -c "apt-get upgrade -y"
	- docker exec ${STACK}-apache bash -c "apt-get upgrade -y"
	- docker exec ${STACK}-nginx bash -c "apt-get upgrade -y"
	- docker exec ${STACK}-ols bash -c "apt-get upgrade -y"
	- docker exec ${STACK}-mail bash -c "apt-get upgrade -y"


	- docker exec ${STACK} bash -c "apt-get dist-upgrade -y"
	- docker exec ${STACK}-apache bash -c "apt-get dist-upgrade -y"
	- docker exec ${STACK}-nginx bash -c "apt-get dist-upgrade -y"
	- docker exec ${STACK}-ols bash -c "apt-get dist-upgrade -y"
	- docker exec ${STACK}-mail bash -c "apt-get dist-upgrade -y"

	- docker exec ${STACK} bash -c "bt 16 && bt 1"
	- docker exec ${STACK}-apache bash -c "bt 16 && bt 1"
	- docker exec ${STACK}-nginx bash -c "bt 16 && bt 1"
	- docker exec ${STACK}-ols bash -c "bt 16 && bt 1"
	- docker exec ${STACK}-mail bash -c "bt 16 && bt 1"
mass_commit:
	- docker commit ${STACK} ${MASS_REPO};
	- docker commit ${STACK}-apache ${MASS_REPO}-apache;
	- docker commit ${STACK}-nginx ${MASS_REPO}-nginx;
	- docker commit ${STACK}-ols ${MASS_REPO}-ols;
	- docker commit ${STACK}-mail ${MASS_REPO}-mail;
mass_rm:
	- docker rm ${STACK} -f
	- docker rm ${STACK}-apache -f
	- docker rm ${STACK}-nginx -f
	- docker rm ${STACK}-ols -f
	- docker rm ${STACK}-mail -f
	- docker rm ${STACK}_wt -f
mass_push:
	- docker push ${MASS_REPO};
	- docker push ${MASS_REPO}-apache;
	- docker push ${MASS_REPO}-nginx;
	- docker push ${MASS_REPO}-ols;
	- docker push ${MASS_REPO}-mail;

mass_no_parallel_update_cycle: # to save resources
	- docker pull   ${MASS_REPO};
	- docker run --name ${STACK}      --env-file=./.env -d -p 7801:7800 -d ${MASS_REPO}
	- docker exec 		${STACK} bash -c "apt-get update -y"
	- docker exec 		${STACK} bash -c "apt-get upgrade -y"
	- docker exec 		${STACK} bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK} bash -c "bt 16 && bt 1"
	- docker commit 	${STACK} ${MASS_REPO};
	- docker rm 		${STACK} -f
	- docker push   ${MASS_REPO};

	- docker pull   ${MASS_REPO}-apache;
	- docker run --name ${STACK}-apache      -d ${MASS_REPO}-apache
	- docker exec 		${STACK}-apache bash -c "apt-get update -y"
	- docker exec 		${STACK}-apache bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-apache bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-apache bash -c "bt 16 && bt 1"
	- docker commit 	${STACK}-apache ${MASS_REPO};
	- docker rm 		${STACK}-apache -f
	- docker push   ${MASS_REPO}-apache;

	- docker pull   ${MASS_REPO}-nginx;
	- docker run --name ${STACK}-nginx      -d ${MASS_REPO}-nginx
	- docker exec 		${STACK}-nginx bash -c "apt-get update -y"
	- docker exec 		${STACK}-nginx bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-nginx bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-nginx bash -c "bt 16 && bt 1"
	- docker commit 	${STACK}-nginx ${MASS_REPO};
	- docker rm 		${STACK}-nginx -f
	- docker push   ${MASS_REPO}-nginx;

	- docker pull   ${MASS_REPO}-ols;
	- docker run --name ${STACK}-ols      -d ${MASS_REPO}-ols 
	- docker exec 		${STACK}-ols bash -c "apt-get update -y"
	- docker exec 		${STACK}-ols bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-ols bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-ols bash -c "bt 16 && bt 1"
	- docker commit 	${STACK}-ols ${MASS_REPO};
	- docker rm 		${STACK}-ols -f
	- docker push   ${MASS_REPO}-ols;

	- docker pull   ${MASS_REPO}-mail;
	- docker run --name ${STACK}-mail      -d ${MASS_REPO}-mail
	- docker exec 		${STACK}-mail bash -c "apt-get update -y"
	- docker exec 		${STACK}-mail bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-mail bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-mail bash -c "bt 16 && bt 1"
	- docker commit 	${STACK}-mail ${MASS_REPO};
	- docker rm 		${STACK}-mail -f
	- docker push   ${MASS_REPO}-mail;


up_empty:
	- docker pull   ${MASS_REPO};
	- docker run --name ${STACK}   	  -p 7800:7800   -d ${MASS_REPO}
	- docker exec 		${STACK} bash -c "apt-get update -y"
	- docker exec 		${STACK} bash -c "apt-get upgrade -y"
	- docker exec 		${STACK} bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK} bash -c "rm -f /tmp/update_to7.pl && curl -k https://node.aapanel.com/install/update_7.x_en.sh | bash"
	- docker exec 		${STACK} bash -c "bt 16"
	- docker exec 		${STACK} bash -c "bt 1"

bash_empty:
	- docker exec -it ${STACK} bash;

push_empty:
	- docker commit 	${STACK} ${MASS_REPO};
	- docker rm 		${STACK} -f
	- docker push   ${MASS_REPO};

up_apache:
	- docker pull   ${MASS_REPO}-apache;
	- docker run --name ${STACK}-apache      -d ${MASS_REPO}-apache
	- docker exec 		${STACK}-apache bash -c "apt-get update -y"
	- docker exec 		${STACK}-apache bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-apache bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-apache bash -c "rm -f /tmp/update_to7.pl && curl -k https://node.aapanel.com/install/update_7.x_en.sh | bash"
	# - docker exec 		${STACK}-apache bash -c "bt 16"
	- docker exec 		${STACK}-apache bash -c "bt 1"

bash_apache:
	- docker exec -it ${STACK}-apache bash;

push_apache:
	- docker commit 	${STACK}-apache ${MASS_REPO};
	- docker rm 		${STACK}-apache -f
	- docker push   ${MASS_REPO}-apache;


up_nginx:
	- docker pull   ${MASS_REPO}-nginx;
	- docker run --name ${STACK}-nginx      -d ${MASS_REPO}-nginx
	- docker exec 		${STACK}-nginx bash -c "apt-get update -y"
	- docker exec 		${STACK}-nginx bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-nginx bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-nginx bash -c "rm -f /tmp/update_to7.pl && curl -k https://node.aapanel.com/install/update_7.x_en.sh | bash"
	- docker exec 		${STACK}-nginx bash -c "bt 16"
	- docker exec 		${STACK}-nginx bash -c "bt 1"

bash_nginx:
	- docker exec -it ${STACK}-nginx bash;
	
push_nginx:
	- docker commit 	${STACK}-nginx ${MASS_REPO};
	- docker rm 		${STACK}-nginx -f
	- docker push   ${MASS_REPO}-nginx;


up_ols:
	- docker pull   ${MASS_REPO}-ols;
	- docker run --name ${STACK}-ols      -d ${MASS_REPO}-ols 
	- docker exec 		${STACK}-ols bash -c "apt-get update -y"
	- docker exec 		${STACK}-ols bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-ols bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-ols bash -c "rm -f /tmp/update_to7.pl && curl -k https://node.aapanel.com/install/update_7.x_en.sh | bash"
	- docker exec 		${STACK}-ols bash -c "bt 16"
	- docker exec 		${STACK}-ols bash -c "bt 1"

bash_ols:
	- docker exec -it ${STACK}-ols bash;

push_ols:
	- docker commit 	${STACK}-ols ${MASS_REPO};
	- docker rm 		${STACK}-ols -f
	- docker push   ${MASS_REPO}-ols;


up_mail:
	- docker pull   ${MASS_REPO}-mail;
	- docker run --name ${STACK}-mail      -d ${MASS_REPO}-mail
	- docker exec 		${STACK}-mail bash -c "apt-get update -y"
	- docker exec 		${STACK}-mail bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-mail bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-mail bash -c "rm -f /tmp/update_to7.pl && curl -k https://node.aapanel.com/install/update_7.x_en.sh | bash"
	- docker exec 		${STACK}-mail bash -c "bt 16"
	- docker exec 		${STACK}-mail bash -c "bt 1"

bash_mail:
	- docker exec -it ${STACK}-mail bash;

push_mail:
	- docker commit 	${STACK}-mail ${MASS_REPO};
	- docker rm 		${STACK}-mail -f
	- docker push   ${MASS_REPO}-mail;