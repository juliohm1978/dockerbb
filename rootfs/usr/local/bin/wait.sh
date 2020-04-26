#!/bin/bash

echo "$(date) Esperando serviços, aguarde aprox. 1 min"
while true; do
  if [[ "$MACOS" == "1" ]]
  then
    systemctl status chromium > /dev/null
  else
    systemctl status firefox > /dev/null
  fi
  R=$?
  if [[ "$R" == "0" ]]; then
    if [[ "$MACOS" == "1" ]]
    then
        echo "Detectado sistema MAC-OS, desabilitando Firefox e Habilitando Chromium..."
        systemctl stop firefox > /dev/null
    fi
    echo "###"
    echo "## "
    echo "## Acesse de seu navegador:"
    echo "## "
    echo "## http://localhost:6080/vnc_auto.html"
    echo "## "
    echo "###"
    exit 0
  fi
  sleep 1
done
