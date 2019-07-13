#!/bin/bash -xe

export VNC_PASSWORD=$(echo $RANDOM$RANDOM$RANDOM)

start-xfwm.sh &
groupadd -g $USER_GID user
useradd -u $USER_UID -g $USER_GID -ms /bin/bash user
dpkg -i /w.deb && rm -fr /w.deb
/usr/local/bin/warsaw/core
sleep 5
chown -R user.user /home/user
gosu user:user /usr/local/bin/warsaw/core
gosu user:user Xvfb $DISPLAY -screen 0 $DESKTOP_SIZE &
/usr/local/bin/start-x11vnc.sh &
sleep 10
gosu user:user /usr/share/novnc/utils/launch.sh --vnc localhost:5900 &
echo ""
echo ""
echo "Aguarde alguns instantes....."
echo ""
sleep 10
set +x
echo ""
echo "====================================="
echo "Acesse do seu navegador"
echo "http://localhost:6080/vnc_auto.html"
echo ""
echo "Senha do VNC: ${VNC_PASSWORD}"
echo ""
gosu user:user firefox "$@"
