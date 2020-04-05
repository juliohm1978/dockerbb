FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

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

RUN apt-get install -y vim less

ENV USER_UID=1000
ENV USER_GID=1000

ADD https://cloud.gastecnologia.com.br/cef/warsaw/install/GBPCEFwr64.deb /w.deb

RUN mkdir -p /var/run/dbus

COPY rootfs /

RUN    systemctl enable warsaw-install \
    && systemctl enable warsaw-root \
    && systemctl enable warsaw-user \
    && systemctl enable xvfb \
    && systemctl enable xfwm \
    && systemctl enable vnc \
    && systemctl enable novnc \
    && systemctl enable firefox \
    && echo OK

ENTRYPOINT [ "/usr/local/bin/epoint.sh" ]
