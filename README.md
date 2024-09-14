# Aapanel

Aapanel docker compose file to customize

Update: Ubuntu 22.04

5 tags:

- clean: antonio24073/aapanel-ubuntu-22-04-sysbox
- apache: antonio24073/aapanel-ubuntu-22-04-sysbox-apache
- nginx: antonio24073/aapanel-ubuntu-22-04-sysbox-nginx
- open litespeed: antonio24073/aapanel-ubuntu-22-04-sysbox-ols
- mail: antonio24073/aapanel-ubuntu-22-04-sysbox-mail

The mail tag needs nginx and mysql 5.7. So it's a nginx modified.

# Requirements

## Install sysbox

Install docker sysbox or remove it from `Dockerfile` and `docker-compose.yml` =>> [help](https://github.com/antonio24073/aapanel-ubuntu-22-04-sysbox/tree/main/docs)

## Config

Rename `.env.example` to `.env` and change the variables

## Run

```
make build
make mkdir
make perm
make up
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
