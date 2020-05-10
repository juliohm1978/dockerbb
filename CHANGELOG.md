# Histórico de Versões

## 3.0 (26/abr/2020)

* Merge com PR #2 (@marcocspc) melhora suporte ao MacOS
* Melhorias em cima da PR #2 para ficar mais simples
* Remove Firefox, substitui pelo Chromium Browser
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
