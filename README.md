# dockerbb

**Protótipo** de imagem Docker com Chromium Browser e Warsaw instalados para acessar o Banco do Brasil.

> **NOTA 1**: A partir da versão 3.0, o Firefox é substituído pelo Chromium Browser. Ao momento, por ser o navegador majoritário do mercado, oferece maior compatibilidade. Mesmo sendo executado dentro de um container, alguns usuários já encontraram dificuldades usando o dockerbb no MacOS, por exemplo.
>
> *-- Agradecimentos ao @marcocspc por relatar e ajudar a corrigir os problemas. :+1:*

> **NOTA 2**: Começando com a versão `2.x`, componentes necessários para o Xfce4 e VNC são iniciados dentro do container, mantendo tudo ainda mais isolado. Caso precise consultar a documentação da versão com modelo de instalação antigo, confira o histórico [na tag `1.x`](https://github.com/juliohm1978/dockerbb/tree/v1.0).

Componentes instalados na versão 3.0 (26/abr/2020):

* Chromium Browser: 80.0.3987.163
* Warsaw 1.14.1-10
* xfwm4 4.12.5
* openssl 1.1.1-1
* xfce 4.12.4
* x11vnc 0.9.13-3
* novnc 1:0.4
* xvfb 2:1.19.6

Para uma lista completa dos pacotes instalados, confira: [Pacotes Instalados](installed-packages.md)

## LEIA ANTES DE CONTINUAR

***É IMPORTANTE RESSALTAR que o conteúdo deste repositório é um protótipo de uso pessoal, independente e não possui vínculo com o Banco do Brasil ou qualquer instituição relacionada***.

***Sua utilização presume conhecimentos técnicos avançados e se dá por sua própria conta e risco, sem qualquer garantia de suporte ou segurança.***

***Por questões de transparência, privacidade e segurança NUNCA UTILIZE QUALQUER IMAGEM DOCKER PRÉ-CONSTRUÍDA DESTE PROJETO. Obtenha uma cópia do código fonte deste repositório, confira o conteúdo e contrua sua própria imagem.***

***Caso não saiba como proceder com as instruções abaixo, esta solução certamente não é para você.***

## Construção Local da Imagem

Com Docker mais recente instalado:

```bash
git clone https://github.com/juliohm1978/dockerbb.git
cd dockerbb
make
```

Deixe isto num terminal separado e vá tomar um café; o build é demorado. Ao final, uma imagem local `dockerbb` estará criada.

## Executando

Há um target no `Makefile` preparado para executar um container.

```bash
make start
```

Isto deve criar um container chamado `dockerbb` com volume montado em `$HOME/dockerbb-data`. Este diretório em seu computador representa o diretório `$HOME` do usuário dentro do container.

> Algumas distribuições Linux (e mesmo MacOS da Apple) podem manter um UID:GID diferente do usuário principal da estação de trabalho. O `Makefile` tenta deduzir os valores. Em caso de problemas, confira mais abaixo nesta documentação como customizar este UID:GID.

Após alguns instantes, os componentes internos serão inicializados e uma instância do navegador estará executando dentro do container. Depois de aproximadamente 1 min a mensagem abaixo deve aparecer:

```bash
###
##
## Acesse de seu navegador:
##
## http://localhost:6080/vnc_auto.html
##
###
```

O acesso pode ser feito através do seu navegador de preferência **somente em sua estação de trabalho**. Usando este `Makefile`, a porta `6080` não é exposta para interface externas, apenas em `localhost/127.0.0.1`. Ao entrar, uma sessão VNC será iniciada para dentro do container. 

> INCEPTION: Utilize o navegador dentro do seu navegador para acessar o site do banco.

Ao terminar, lembre-se de finalizar o container para desligar todos os serviços iniciados:

```bash
make stop
```

O container será completamente removido, mas o diretório `$HOME/dockerbb-data` será mantido em sua estação de trabalho.

Com cada nova execução, uma nova instalação do pacote Warsaw é realizada. Isto renova chaves e certificados do componente sempre que o `dockerbb` for executado.

## Usuário dentro do container

O `Makefile` deste projeto está preparado para deduzir o `UID:GID` de sua estação de trabalho e repassá-los ao container. Assim, o diretório `$HOME/dockerbb-data` e todo seu conteúdo terão as permissões do seu usuário. O usuário de dentro do container não tem acesso à sua estação de trabalho. Por outro lado, é possível transferir arquivos para dentro e fora do container através do diretório `$HOME/dockerbb-data`. Ao avaliar seus próprios requisitos, pode decidir remover este volume para aumentar o isolamento e, por consequẽncia, sua segurança.

Caso precise usar outros valores de `UID:GID`, pode defeiní-los passando variáveis de ambiente diretamente ao container: `USER_UID` e `USER_GID`.

## Algumas notas finais

Sendo uma imgem Docker com base `FROM ubuntu:18.04`, segue-se que o `dockerbb` foi criado especialmente para ambientes Linux. Nenhum suporte foi idealizado para o Windows. Nada foi testado no ambiente WSL da Microsoft.

Para que funcione, vários processos são gerenciados dentro do container pelo `/sbin/init` padrão, comum em várias distribuições Linux. É como se uma mini-estação de trabalho Linux estivesse executando dentro do container. Isto quebra o paradigma "*um processo por container*", padrão na comunidade, mas faz-se necessário pelos requisitos desta solução.

Dentro do container, um usuário comum é configurado na hora da execução. Alguns componentes, como Warsaw e o navegador são executados com este usuário. Outros, por serem necessários ao gerenciamento de processos do Linux, são executados como `root`.
