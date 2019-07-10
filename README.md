# dockerbb

Imagem Docker com firefox e warsaw instalados para acessar o Banco do Brasil.

## Nota de Instalação

Por questões de transparência, privacidade e segurança, não recomendo usar minha imagem pré-construída hospedada no Docker Hub. Obtenha o código fonte deste repositório e contrua sua própria imagem.

A versão atual `2.x` utiliza Xfce4 e VNC dentro do container para manter os componentes ainda mais isolados e independentes do ambiente onde executa. Se precisa consultar a documentação da versão antiga, confira o histórico [na tag `1.x`](https://github.com/juliohm1978/dockerbb/tree/v1.0).

## Construção Local da Imagem

Com Docker mais recente instalado, faça um build de imagem local com os comandos abaixo.

```bash
git clone https://github.com/juliohm1978/dockerbb.git
cd dockerbb
make
```

Deixe isto num terminal separado e vá tomar um café. O build é demorado e envolve instalação de inúmeros pacotes para o ambiente X11, interface gráfica. Ao final, uma imagem local `dockerbb` estará criada.

Se pretende enviar sua imagem para seu Docker Registry privado (push), use o comando `make squash` para criar uma imagem mais compacta.

> **NOTA**: Para `--squash` funcionar, seu Docker Daemon precisa ser configurado com a flag `--experimental`. Confira a documentação do Docker para maiores detalhes: <https://docs.docker.com/engine/reference/commandline/dockerd>

## Executando

Há um target no `Makefile` preparado para executar um container.

```bash
make start
```

Isto deve criar um container chamado `dockerbb` com volume montado em `$HOME/dockerbb-data`. Este diretório em seu computador representa o diretório `$HOME` do usuário dentro do container.

> Algumas distribuições Linux (e mesmo MacOS da Apple) podem manter um UID:GID diferente do usuário principal da estação de trabalho. O `Makefile` tenta deduzir os valores. Em caso de problemas, confira mais abaixo nesta documentação como customizar este UID:GID.

Após alguns instantes, os componentes internos serão inicializados e uma instância do Firefox estará executando dentro do container. Uma mensagem parecida com esta será mostrada.

```text
=====================================
Acesse do seu navegador
http://localhost:6080/vnc_auto.html

Senha do VNC: ***
```

Com a senha criada para esta sessão, utilize um navegador de fora do container e acesse: <http://localhost:6080/vnc_auto.html>.

Ao terminar, não se confunda: **feche o navegador de dentro do container**. Caso precise parar o container manualmente, pode fazer isso na linha de comando:

```bash
make stop
```

Com o comando `make stop` o container será completamente removido, mas o diretório `$HOME/dockerbb-data` será mantido.

> **NOTA**: Com cada nova execução, uma nova instalação do pacote Warsaw é realizada. Isto renova chaves e certificados do componente sempre que o `dockerbb` for executado.

## Usuário dentro do container

Dentro do container, um usuário comum é criado em momento de execução para iniciar componentes do Warsaw e o navegador. O `Makefile` deste projeto está preparado para deduzir o UID:GID do seu usuário e repassá-los ao container. Assim, o diretório `$HOME/dockerbb-data` e todo seu conteúdo terão as permissões do seu usuário.

Caso precise usar outro UID:GID, pode defeinir estes valores passando variáveis de ambiente diretamente ao container `USER_UID` e `USER_GID`.

## Algumas notas de segurança

Sendo uma imgem Docker com base `FROM ubuntu:18.04`, segue-se que o `dockerbb` foi criado especialmente para ambientes Linux. Nenhum suporte foi idealizado para executar esta imagem no ambiente Windows. Nada foi testado no ambiente WSL da Microsoft.

O navegador e Warsaw dentro do container são executados com uma conta de usuário comum. Este usuário só é criado no container no momento de execução. O container inicia com usuário `root` para poder realizar esta e outras tarefas antes de iniciar o navegador. Isto inclui:

* Criar o usuário comum `user` com UID:GID especificados.
* Instalar o Warsaw.
* Iniciar instâncias do Warsaw em plano de fundo.
* Iniciar o navegador com usuário `user`.

Para executar aplicações gráficas, o container também possui instalado o Xfce4 e um servidor VNC. Com ajuda do `novnc`, o acesso ao navegador dentro do container pode ser feito através do seu navegador externo ou a partir de qualquer cliente VNC pela porta `5920` do container.
