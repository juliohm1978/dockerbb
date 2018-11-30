#!/bin/bash -xe

dpkg -i /w.deb && rm -fr /w.deb

/usr/local/bin/warsaw/core
chown -R user.user /home/user
gosu user:user /usr/local/bin/warsaw/core
gosu user:user google-chrome "$@"
