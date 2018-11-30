FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    python2.7 \
    libpython2.7-minimal \
    libpython2.7-stdlib \
    python-openssl \
    libnss3-tools \
    zenity \
    libgtk2.0-0 \
    dbus-x11 \
    yad \
    libcurl3 \
    libdbus-1.3 \
    openssl \
    sudo gosu \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libxss1 \
    lsb-release \
    wget \
    xdg-utils \
    && \
    \
    rm -fr /var/lib/apt/lists/* \
    rm -fr /var/cache/apt/* \
    rm -fr /tmp/*
 
ADD https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_64.deb /w.deb
ADD https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb /c.deb

RUN dpkg -i c.deb && rm -fr /c.deb
RUN mkdir -p /var/run/dbus
RUN useradd -ms /bin/bash user

COPY epoint.sh /usr/local/bin/epoint.sh

ENTRYPOINT [ "/usr/local/bin/epoint.sh" ]
