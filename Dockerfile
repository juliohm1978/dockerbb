FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
    CHROME_VERSION=86 \
    XFCE_VERSION=4.12.4 \
    XFWM4_VERSION=4.12.5 \
    X11VNC_VERSION=0.9.13-3 \
    XVFB_VERSION=2:1.19.6 \
    NOVNC_VERSION=1:0.4 \
    OPENSSL_VERSION=1.1.1-1

RUN apt-get update && apt-get install -y \
    libnss3-tools \
    zenity \
    libgtk2.0-0 \
    dbus-x11 \
    yad \
    libcurl3 \
    libdbus-1.3 \
    sudo gosu \
    libxss1 \
    lsb-release \
    wget \
    xdg-utils \
    net-tools \
    openssl=${OPENSSL_VERSION}* \
    xfce4=${XFCE_VERSION}* \
    xfwm4=${XFWM4_VERSION}* \
    x11vnc=${X11VNC_VERSION}* \
    xvfb=${XVFB_VERSION}* \
    novnc=${NOVNC_VERSION}* \
    chromium-browser=${CHROME_VERSION}* \
    && dpkg -l | awk '{print "|" $2 "|" $3 "|"}' > /installed-packages.txt

RUN apt-get install -y vim less

ENV USER_UID=1000
ENV USER_GID=1000

ADD https://cloud.gastecnologia.com.br/cef/warsaw/install/GBPCEFwr64.deb /w.deb

RUN mkdir -p /var/run/dbus

COPY rootfs /

STOPSIGNAL SIGRTMIN+3

RUN    systemctl enable xvfb \
    && systemctl enable xfwm \
    && systemctl enable vnc \
    && systemctl enable novnc \
    && systemctl enable chromium \
    && systemctl enable banner \
    && echo OK

ENTRYPOINT [ "/usr/local/bin/epoint.sh" ]
