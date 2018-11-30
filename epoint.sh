#!/bin/bash -xe

groupadd --gid $USER_GID
useradd -uid $USER_UID --gid $USER_GID-ms /bin/bash user

dpkg -i /w.deb && rm -fr /w.deb

/usr/local/bin/warsaw/core
chown -R user.user /home/user
gosu user:user /usr/local/bin/warsaw/core
gosu user:user google-chrome "$@"
