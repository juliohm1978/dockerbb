#!/bin/bash -xe

groupadd -g $USER_GID user
useradd -u $USER_UID -g $USER_GID -ms /bin/bash user
chown -R user.user /home/user

/usr/local/bin/wait.sh &

exec /sbin/init
