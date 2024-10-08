# Aapanel

Aapanel docker compose file to customize

Update: Ubuntu 22.04

5 tags:

- clean: antonio24073/aapanel-ubuntu-22-04-sysbox
- apache: antonio24073/aapanel-ubuntu-22-04-sysbox-apache
- nginx: antonio24073/aapanel-ubuntu-22-04-sysbox-nginx
- open litespeed: antonio24073/aapanel-ubuntu-22-04-sysbox-ols
- mail: antonio24073/aapanel-ubuntu-22-04-sysbox-mail

The mail tag has roundcube and the one-click install needs nginx and mysql 5.7. So it's a nginx modified. But it works in apache too. Only the auto install button that do not works. But it has another one-click install too into app store.

# Requirements

## Install sysbox

Install docker sysbox or remove it from `Dockerfile` and `docker-compose.yml` =>> [help](https://github.com/antonio24073/aapanel-ubuntu-22-04-sysbox/tree/main/docs)

## Config

Rename `.env.example` to `.env` and change the variables

## Run

```
make build
make mkdir
make up
make perm
make bt
14
```

## Record changes to aapanel in the docker image

```
make commit
```

## Stop

```
make rm
```
To "make up" twice, you need "make rm" first.

## Read this:

https://hub.docker.com/r/antonio24073/aapanel

https://github.com/antonio24073/aapanel-updater
