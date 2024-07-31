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
	- docker pull ${REPO};

mkdir:
	- mkdir -p ./vol/www/wwwroot
	- mkdir -p ./vol/www/server/data
	- mkdir -p ./vol/www/server/panel/vhost
	- mkdir -p ./vol/www/server/panel/data
	- mkdir -p ./vol/www/wwwlogs
	- mkdir -p ./vol/www/backup
	- mkdir -p ./vol/etc
	- make --no-print-directory run
	- docker cp ${STACK}:/www/wwwroot ./vol/www
	- docker cp ${STACK}:/www/server/data ./vol/www/server
	- sudo docker cp ${STACK}:/www/server/panel/vhost ./vol/www/server/panel
	- sudo docker cp ${STACK}:/www/server/panel/data ./vol/www/server/panel
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

run:
	- docker run --name ${STACK} -d -p ${AAP_PORT}:7800 -p ${FTP_PORT}:21 -p ${SSH_PORT}:22 \
	-p ${HTTPS_PORT}:443 -p ${HTTP_PORT}:80 -p ${PMA_PORT}:888 ${REPO}

up:
	- docker compose -p ${STACK} -f "./docker-compose.yml" up -d
	

rm:
	- docker rm ${STACK} -f

bt:
	- docker exec -it ${STACK} bt;

bash:
	- docker exec -it ${STACK} bash;