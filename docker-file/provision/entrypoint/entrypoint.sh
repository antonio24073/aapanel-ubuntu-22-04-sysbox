#!/bin/sh

# ini changing root password and adding user to sudo
[[ ! -z "$LINUX_ROOT_PASS" ]] && printf "$LINUX_ROOT_PASS\n$LINUX_ROOT_PASS" | passwd

if [ ! -z "$LINUX_USER_NAME" ]; then
    [[ ! -z "$LINUX_USER_PASS" ]] && printf "$LINUX_USER_PASS\n$LINUX_USER_PASS\n\n\n\n\n\ny\n" | adduser $LINUX_USER_NAME

    if [ "$(grep -Ei 'debian|ubuntu|mint' /etc/*release)" ]; then
        usermod -aG sudo $LINUX_USER_NAME
    fi
    if [ "$(grep -Ei 'centos|fedora|redhat|almalinux|oraclelinux|rockylinux' /etc/*release)" ]; then
        usermod -aG wheel $LINUX_USER_NAME
    fi
    # end changing root password and adding user to sudo

    # ini docker post-install
    groupadd docker
    usermod -aG docker $LINUX_USER_NAME
    newgrp docker 
    # end docker post-install
fi 

[[ ! -z "$AAP_PASS" ]] && printf "$AAP_PASS" | bt 5
[[ ! -z "$AAP_USER" ]] && printf "$AAP_USER" | bt 6
[[ ! -z "$AAP_PATH" ]] &&  echo "/$AAP_PATH" > /www/server/panel/data/admin_path.pl
[[ ! -z "$AAP_PORT" ]] &&   echo "$AAP_PORT" > /www/server/panel/data/port.pl
[[ ! -z "$REDIS_PASS" ]] && sudo sed -z -i "s/# requirepass foobared/requirepass $REDIS_PASS\n/g" /www/server/redis/redis.conf

sh /provision/entrypoint/restart.sh

chmod +x /sbin/init

exec /sbin/init --log-level=err