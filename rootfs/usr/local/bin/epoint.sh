#!/bin/bash -xe

if ! getent group $USER_GID >/dev/null; then
    groupadd -g $USER_GID user
else
    USER_GID=$((USER_GID + 1000))
    groupadd -g $USER_GID user
fi
if ! getent passwd $USER_UID >/dev/null; then
    useradd -u $USER_UID -g $USER_GID -ms /bin/bash user
else
    useradd -u $((USER_UID + 1000)) -g $USER_GID -ms /bin/bash user
fi
chown -R user.user /home/user

exec /sbin/init
