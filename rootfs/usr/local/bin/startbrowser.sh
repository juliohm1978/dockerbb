#!/bin/bash -xe

/usr/bin/dpkg -D10 -i /w.deb
service warsaw restart


if [ -f /home/user/.config/chromium/SingletonLock ]; then
    rm /home/user/.config/chromium/SingletonLock
fi

runuser -l user -c "DISPLAY=:20 /usr/bin/chromium-browser --disable-dev-shm-usage --start-maximized https://www.bb.com.br"
