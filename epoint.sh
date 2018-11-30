#!/bin/bash -xe

groupadd -g $USER_GID user
useradd -u $USER_UID -g $USER_GID -ms /bin/bash user

dpkg -i /w.deb && rm -fr /w.deb

/usr/local/bin/warsaw/core
chown -R user.user /home/user
gosu user:user /usr/local/bin/warsaw/core
gosu user:user google-chrome "$@"
