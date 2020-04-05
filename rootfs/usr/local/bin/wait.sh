#!/bin/bash

echo "$(date) Esperando serviços, aguarde aprox. 1 min"
while true; do
  systemctl status firefox.service > /dev/null
  R=$?
  if [[ "$R" == "0" ]]; then
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
