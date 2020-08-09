## ‼ LEIA ANTES DE CONTINUAR ‼

***O conteúdo deste repositório é um protótipo de uso pessoal, independente e não possui vínculo com o Banco do Brasil ou qualquer instituição relacionada***.

***Sua utilização presume conhecimentos técnicos avançados e se dá por sua própria conta e risco, sem qualquer garantia de suporte ou segurança.***

***Por questões de segurança NUNCA UTILIZE QUALQUER IMAGEM DOCKER PRÉ-CONSTRUÍDA DESTE PROJETO. Obtenha uma cópia do código fonte, confira o conteúdo e contrua sua própria imagem.***

***Caso não saiba como proceder com as instruções abaixo, esta solução certamente não é para você.***

## Histórico de Versões

A partir da versão 3.0, o Firefox é substituído pelo Chromium Browser. Ao momento, por ser o navegador majoritário do mercado, oferece maior compatibilidade. Mesmo sendo executado dentro de um container, alguns usuários já encontraram dificuldades usando o dockerbb no MacOS.

> Agradecimentos ao [@marcocspc](https://github.com/marcocspc) pela ajuda 👍

Começando com a versão `2.x`, componentes necessários para o Xfce4 e VNC são iniciados dentro do container, mantendo tudo ainda mais isolado. Caso precise consultar a documentação das versões antigas, confira o histórico [na tag `1.x`](https://github.com/juliohm1978/dockerbb/tree/v1.0).

### Versão atual 3.2 (09/ago/2020):

* Chromium Browser: 84.0.4147.105
* Warsaw 1.14.1-10

Confira histórico de versões em [CHANGELOG.md](CHANGELOG.md).

## Problemas Conhecidos

Mesmo que o container seja iniciado com `docker run -it` dando ao terminal um console interativo, o comando CTRL+C enviado para dentro do container não consegue matar o processo 1 (`/sbin/init`). Este precisa de outro sinal para terminar com sucesso `SIGRTMIN+3`, agora definido como `STOPSIGNAL` no `Dockerfile`.

Para conseguir parar o container, é preciso usar `docker stop dockerbb`.

## Construção Local da Imagem

Com Git e Docker instalados, execute:

```bash
git clone https://github.com/juliohm1978/dockerbb.git
cd dockerbb
make
```

O build é demorado. Portanto, vá tomar um café. O resultado será uma imagem chamada `dockerbb`.

## Como Usar

Há um target no `Makefile` preparado para executar um container.

```bash
make start
```

Isto deve criar um container chamado `dockerbb` com volume montado em `$HOME/dockerbb-data`. Este diretório em seu computador representa o diretório `$HOME` do usuário dentro do container.

> Algumas distribuições Linux (e mesmo MacOS da Apple) podem manter um UID:GID diferente para o seu usuário na estação de trabalho. O `Makefile` tenta deduzir os valores. Em caso de problemas, confira mais abaixo nesta documentação como alterar estes valores.

Após alguns instantes, os componentes internos serão inicializados e uma instância do navegador estará executando dentro do container. O acesso estará disponível quando aparecer a mensagem abaixo:

```text
Componentes iniciados!
Em seu navegador, acesse (CTRL+Click do mouse aqui no terminal):

    http://localhost:6080/vnc_auto.html

Quando terminar, lembre-se de desligar o dockerbb:

    docker stop dockerbb
```

O acesso pode ser feito através do seu navegador preferido, mas **sempre e somente em sua estação de trabalho** (localhost/127.0.0.1).

Através de seu navegador, o endereço http://localhost:6080/vnc_auto.html lhe dará acesso a uma sessão VNC dentro do container. Lá dentro, outra instância do navegador Chromium estará disponível.

> INCEPTION: Utilize o navegador dentro do seu navegador para acessar o site do banco.

Ao terminar, lembre-se de finalizar o container para desligar todos os serviços iniciados:

```bash
make stop
```

O container será completamente removido, mas o diretório `$HOME/dockerbb-data` será mantido em sua estação de trabalho.

Toda vez que o dockerbb for iniciado, uma nova instalação do pacote Warsaw é realizada. Isto deve renovar as chaves e certificados do componente sempre que o `dockerbb` for executado.

## Usuário dentro do container

O `Makefile` deste projeto está preparado para deduzir o `UID:GID` de sua estação de trabalho e repassá-los ao container. Caso precise usar outros valores de `UID:GID`, pode defeiní-los passando variáveis de ambiente diretamente ao container: `USER_UID` e `USER_GID`.

Com as permissões devidamente ajustadas, o diretório `$HOME/dockerbb-data` e todo seu conteúdo terão as permissões do seu usuário. Fora este diretório, o navegador Chromium não possui acesso direto a outros arquivos da sua estação de trabalho. Para transferir arquivos dentro e fora do container, utilize o diretório `$HOME/dockerbb-data`.

Ao avaliar seus próprios requisitos, pode decidir não usar este volume para aumentar o isolamento. Entretanto, sem ele, o banco deve tratar todo acesso como fosse uma primeira vez.

## Algumas notas finais

Sendo uma imgem Docker com base `FROM ubuntu:18.04`, segue-se que o `dockerbb` foi criado especialmente para ambientes Linux. Nenhum suporte foi idealizado para o Windows. Nada foi testado no ambiente WSL da Microsoft.

Para que funcione, vários processos são gerenciados dentro do container pelo `/sbin/init` padrão, comum em várias distribuições Linux. É como se uma mini-estação de trabalho Linux estivesse executando dentro do container. Isto quebra o paradigma "*um processo por container*", padrão na comunidade, mas faz-se necessário pelos requisitos desta solução.

Dentro do container, um usuário comum é configurado na hora da execução. Alguns componentes, como Warsaw e o navegador são executados com este usuário. Outros, por serem necessários ao gerenciamento de processos do Linux, são executados como `root`.
