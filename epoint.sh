#!/bin/bash -xe

VNC_PASSWORD=$(echo $RANDOM$RANDOM$RANDOM)

groupadd -g $USER_GID user
useradd -u $USER_UID -g $USER_GID -ms /bin/bash user
dpkg -i /w.deb && rm -fr /w.deb
/usr/local/bin/warsaw/core
sleep 5
chown -R user.user /home/user
gosu user:user /usr/local/bin/warsaw/core
gosu user:user Xvfb $DISPLAY -screen 0 $DESKTOP_SIZE &
gosu user:user x11vnc -passwd $VNC_PASSWORD --rfbport 5900 -display $DISPLAY -N -forever &
gosu user:user /usr/share/novnc/utils/launch.sh --vnc localhost:5900 &
xfwm4 &
sleep 5
clear
set +x
echo ""
echo "====================================="
echo "Acesse do seu navegador"
echo "http://localhost:6080/vnc_auto.html"
echo ""
echo "Senha do VNC: ${VNC_PASSWORD}"
echo ""
gosu user:user firefox "$@"
