#!/bin/bash -xe

if ! getent group $USER_GID >/dev/null; then
    groupadd -g $USER_GID user
fi
useradd -u $USER_UID -g $USER_GID -ms /bin/bash user
chown -R user.user /home/user

exec /sbin/init
