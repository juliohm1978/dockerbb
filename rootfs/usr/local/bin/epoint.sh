#!/bin/bash -xe

if ! getent group $USER_GID >/dev/null; then
    groupadd -g $USER_GID user
fi
if ! id -u user >/dev/null 2>&1; then
    useradd -u $USER_UID -g $USER_GID -ms /bin/bash user
fi
chown -R user.user /home/user

exec /sbin/init
