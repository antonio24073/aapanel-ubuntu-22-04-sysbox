
FROM nestybox/ubuntu-jammy-systemd-docker

ENV TIMEZONE=America/Sao_Paulo
ENV LINUX_ROOT_PASS=ha4bgvmRLPk4C
ENV LINUX_USER_NAME=username
ENV LINUX_USER_PASS=9RHodjidWti7R

ENV AAP_PORT=7800
ENV AAP_USER=username
ENV AAP_PASS=T434zqsWqyX4h 
ENV AAP_PATH=aap_login
ENV DB_ROOT_PASS=hcjR4Vgj3TvRK
ENV REDIS_PASS=MEArt7Xjairzf

USER root

# ini SO updates, installs
RUN apt-get clean -y
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN apt-get install -y wget
RUN apt-get install -y procps
# end SO updates, installs

# ini aapanel install
RUN URL=https://www.aapanel.com/script/install_7.0_en.sh && if [ -f /usr/bin/curl ];then curl -ksSO "$URL" ;else wget --no-check-certificate -O install_7.0_en.sh "$URL";fi;
RUN echo 'echo -e "y\nn\n" | bash install_7.0_en.sh aapanel' > inst.sh
RUN bash inst.sh
# end aapanel install

# ini SO installs
RUN apt-get install -y passwd 
RUN apt-get install -y sudo
RUN apt-get install -y nano
RUN apt-get install -y iproute2
RUN apt-get install -y net-tools
RUN apt-get install -y locales-all
RUN apt-get install -y procps
RUN apt-get install -y telnet
RUN apt-get install -y iputils-ping
RUN apt-get install -y net-tools
RUN apt-get install -y nmon
RUN apt-get install -y ncdu
RUN apt-get install -y htop
# end SO installs

COPY ./provision /provision
RUN ["chmod", "+x", "-R", "/provision/entrypoint"]

COPY ./provision/wp-cli.phar /usr/bin/wp
RUN ["chmod", "+x", "-R", "/provision/wp-cli.phar"]
RUN ["chmod", "+x", "-R", "/usr/bin/wp"]

COPY ./provision/docker-compose /bin/docker-compose
RUN ["chmod", "+x", "/provision/docker-compose"]
RUN ["chmod", "+x", "/bin/docker-compose"]

COPY ./aapanel-start.service /etc/systemd/system/aapanel-start.service

RUN systemctl enable aapanel-start

ENTRYPOINT ["/bin/sh", "/provision/entrypoint/entrypoint.sh"]

EXPOSE 7800 21 22 443 80 888
