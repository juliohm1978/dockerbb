# Histórico de Versões

## 3.2 (09/ago/2020)

* Atualiza Chromium para 84.0.4147.105

## 3.1 (22/jul/2020)

* Atualiza Chromium para 83.0.4103.61
* Substitui `wait.sh` por uma alternativa mais robusta: `banner.service` iniciado depois do chromium.
* Usa flag `--disable-dev-shm-usage` do chromium para evitar que abas morram com falta de memória SHM.
* Usa flag `--start-maximized` do chromium para iniciar navegador já maximizado.
* Define `Restart=always` no `chromium.service` para um restart automático do navegador.
* Define `STOPSIGNAL` com valor `SIGRTMIN+3` para que o comando `docker stop` consiga desligar o `/sbin/init` com sucesso.

## 3.0 (11/mai/2020)

* Merge com PR #2 (@marcocspc) melhora suporte ao MacOS
* Melhorias em cima da PR #2 para ficar mais simples
* Remove Firefox, substitui pelo Chromium Browser (81)
* Inclui nos docs uma lista completa de todos os pacotes instalados.
* Atualiza documentação

## 2.3 (05/abr/2020)

* Modifica entrypoint para /sbin/init e configura todos os serviços com systemctl.
* Atualiza warsaw para 1.14.1-10
* Atualiza Firefox para 74.0.1
* Remove senha do VNC - para segurança, expor a porta 6080 apenas em localhost na hora de executar o container.

## 2.1 (12/jul/2019)

* Melhorias no entrypoint para manter o x11vnc e xfwm sempre executando em plano de fundo.

## 2.0 (10/jul/2019)

* Remove necessidade de compartilhar ambiente X11 com host. Utiliza Xfce4 e Firefox instalados dentro da imagem.
* Acesso via web vnc através de <http://localhost:6080/vnc_auto.html>

Versões de componentes:

* Firefox: 67.0.4
* Warsaw 1.13.1-2
* xfwm4 4.12.5

## v1.0 (30/nov/2018)

Versões de componentes:

* Google Chrome 70.0.3538.110
* Warsaw 1.12.13-8
