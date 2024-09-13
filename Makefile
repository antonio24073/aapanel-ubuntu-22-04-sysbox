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
	- docker run --name ${STACK} -d -p 7800:7800 ${REPO}

mkdir:
	- mkdir -p ./vol/www/wwwroot
	- mkdir -p ./vol/www/server/data
	- mkdir -p ./vol/www/server/panel/vhost
	- mkdir -p ./vol/www/server/panel/data
	- mkdir -p ./vol/www/server/nodejs
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
	- sudo docker cp ${STACK}:/www/server/nodejs ./vol/www/server/nodejs
	- docker cp ${STACK}:/www/wwwlogs ./vol/www
	- docker cp ${STACK}:/www/backup ./vol/www
	- docker cp ${STACK}:/etc/hosts ./vol/etc/hosts
	- docker cp ${STACK}:/etc/resolv.conf ./vol/etc/resolv.conf
	- cp -r ./docker-file/provision ./vol

	- docker rm ${STACK} -f

perm:
	- docker exec -u 0 -it ${STACK} chown -R mysql:mysql /www/server/data
	- docker exec -u 0 -it ${STACK} chown root:root -R /www/server/panel/vhost
	- docker exec -u 0 -it ${STACK} chown root:root -R /www/server/panel/data
	- docker exec -u 0 -it ${STACK} chown ${AAP_USER}:www /www/wwwroot
	- docker exec -u 0 -it ${STACK} find /www/wwwroot -type d -exec chmod 775 {} \; 
	- docker exec -u 0 -it ${STACK} find /www/wwwroot -type f -exec chmod 664 {} \; 

rmdir:
	- sudo rm -Rf ./vol/

mass_pull:
	- docker pull ${REPO};
	- docker pull ${REPO}-apache;
	- docker pull ${REPO}-nginx;
	- docker pull ${REPO}-ols;
	- docker pull ${REPO}-mail;
mass_up:
	- docker run --name ${STACK}        -d -p 7801:7800 ${REPO}
	- docker run --name ${STACK}-apache -d -p 7802:7800 ${REPO}-apache
	- docker run --name ${STACK}-nginx  -d -p 7803:7800 ${REPO}-nginx
	- docker run --name ${STACK}-ols    -d -p 7804:7800 ${REPO}-ols
	- docker run --name ${STACK}-mail    -d -p 7805:7800 ${REPO}-mail
mass_run:
	- docker run --name ${STACK}        -d ${REPO}
	- docker run --name ${STACK}-apache -d ${REPO}-apache
	- docker run --name ${STACK}-nginx  -d ${REPO}-nginx
	- docker run --name ${STACK}-ols    -d ${REPO}-ols
	- docker run --name ${STACK}-mail    -d ${REPO}-mail
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
	- docker commit ${STACK} ${REPO};
	- docker commit ${STACK}-apache ${REPO}-apache;
	- docker commit ${STACK}-nginx ${REPO}-nginx;
	- docker commit ${STACK}-ols ${REPO}-ols;
	- docker commit ${STACK}-mail ${REPO}-mail;
mass_rm:
	- docker rm ${STACK} -f
	- docker rm ${STACK}-apache -f
	- docker rm ${STACK}-nginx -f
	- docker rm ${STACK}-ols -f
	- docker rm ${STACK}-mail -f
	- docker rm ${STACK}_wt -f
mass_push:
	- docker push ${REPO};
	- docker push ${REPO}-apache;
	- docker push ${REPO}-nginx;
	- docker push ${REPO}-ols;
	- docker push ${REPO}-mail;

mass_no_parallel_update_cycle: # to save resources
	- docker run --name ${STACK}        -d ${REPO}
	- docker exec 		${STACK} bash -c "apt-get update -y"
	- docker exec 		${STACK} bash -c "apt-get upgrade -y"
	- docker exec 		${STACK} bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK} bash -c "bt 16 && bt 1"
	- docker commit 	${STACK} ${REPO};
	- docker rm 		${STACK} -f
	- docker push ${REPO};
	- docker run --name ${STACK}-apache        -d ${REPO}
	- docker exec 		${STACK}-apache bash -c "apt-get update -y"
	- docker exec 		${STACK}-apache bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-apache bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-apache bash -c "bt 16 && bt 1"
	- docker commit 	${STACK}-apache ${REPO};
	- docker rm 		${STACK}-apache -f
	- docker push ${REPO};
	- docker run --name ${STACK}-nginx        -d ${REPO}
	- docker exec 		${STACK}-nginx bash -c "apt-get update -y"
	- docker exec 		${STACK}-nginx bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-nginx bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-nginx bash -c "bt 16 && bt 1"
	- docker commit 	${STACK}-nginx ${REPO};
	- docker rm 		${STACK}-nginx -f
	- docker push ${REPO};
	- docker run --name ${STACK}-ols        -d ${REPO}
	- docker exec 		${STACK}-ols bash -c "apt-get update -y"
	- docker exec 		${STACK}-ols bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-ols bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-ols bash -c "bt 16 && bt 1"
	- docker commit 	${STACK}-ols ${REPO};
	- docker rm 		${STACK}-ols -f
	- docker push ${REPO};
	- docker run --name ${STACK}-mail        -d ${REPO}
	- docker exec 		${STACK}-mail bash -c "apt-get update -y"
	- docker exec 		${STACK}-mail bash -c "apt-get upgrade -y"
	- docker exec 		${STACK}-mail bash -c "apt-get dist-upgrade -y"
	- docker exec 		${STACK}-mail bash -c "bt 16 && bt 1"
	- docker commit 	${STACK}-mail ${REPO};
	- docker rm 		${STACK}-mail -f
	- docker push ${REPO};

up:
	- docker compose -p ${STACK} -f "./docker-compose.yml" up -d
	

rm:
	- docker rm ${STACK} -f
	- docker rm ${STACK}_wt -f

bt:
	- docker exec -it ${STACK} bt;

bash:
	- docker exec -it ${STACK} bash;