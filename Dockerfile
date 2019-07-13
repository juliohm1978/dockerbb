FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER_UID=1000
ENV USER_GID=1000
ENV DISPLAY=:20
ENV DESKTOP_SIZE=1366x900x16

RUN apt-get update && apt-get install -y \
    libnss3-tools \
    zenity \
    libgtk2.0-0 \
    dbus-x11 \
    yad \
    libcurl3 \
    libdbus-1.3 \
    openssl \
    sudo gosu \
    libxss1 \
    lsb-release \
    wget \
    xdg-utils \
    xfce4 \
    x11vnc xvfb novnc net-tools \
    firefox

ADD https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_64.deb /w.deb

RUN mkdir -p /var/run/dbus

COPY epoint.sh /usr/local/bin/epoint.sh
COPY start-x11vnc.sh /usr/local/bin/start-x11vnc.sh
COPY start-xfwm.sh /usr/local/bin/start-xfwm.sh

ENTRYPOINT [ "/usr/local/bin/epoint.sh" ]
