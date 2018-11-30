# dockerbb

Imagem Docker com google-chrome e warsaw instalados para acessar o Banco do Brasil.

## Nota de Instalação

Por questões de transparência e segurança, não há uma imagem pré-construída em repositório público. Para usar, você deverá obter o código fonte deste repositório e construir sua própria imagem. Sinta-se livre para realizar push para qualquer Registry público ou privado sob sua única e própria responsabilidade.

## Construção Local da Imagem

Com Docker mais recente instalado, faça um build de imagem local com os comandos abaixo.

```bash
git clone https://github.com/juliohm1978/dockerbb.git
cd dockerbb
make
```

Coloque isto num terminal separado e vá tomar um café. O processo de build envolve instalação de inúmeros pacotes Ubuntu para o ambiente X11 e interfaces gráficas e deve demorar vários minutos.

Ao final, uma imagem local `dockerbb` estará criada.

Se você pretende enviar sua imagem (push) a um Docker Registry privado, use o comando `make squash` para criar uma imagem mais compacta. Isto deve incluir parâmetro `--squash` no `docker build` para reduzir o tamanho da imagem final.

> Para `--squash` funcionar, seu Docker Daemon precisa ser configurado com a flag `--experimental`.
> 
> Confira a documentação do Docker para maiores detalhes: https://docs.docker.com/engine/reference/commandline/dockerd/

## Executando

Há um target no `Makefile` preparado para executar um container.

```bash
make start
```

Isto deve criar um container chamado `dockerbb` com volume montado em `$HOME/dockerbb-data`. Este diretório em seu computador representa o diretório `$HOME` do usuário dentro do container, onde um usuário chamado `user` é criado na hora da execução. Para alterar o UID:GID deste usuário, confira o capítulo abaixo "Usuário dentro do container".

Aguarde alguns instantes até o Google Chrome aparecer em sua tela. Em caso de problemas pode conferir os logs do container.

```bash
make logs
```

Ao fechar o navegador, o container será removido automaticamente. Se isto não ocorrer, a remoção pode ser forçada.

```bash
make stop
```

Mesmo que o container seja removido, o diretório `$HOME/dockerbb-data` continua existindo em sua pasta pessoal. Isto deve manter as configurações e histórico do Google Chrome entre execuções diferentes.

> NOTA: Com cada nova execução, uma nova instalação do pacote Warsaw é realizada. Isto renova chaves e certificados do componente sempre que o `dockerbb` for executado.

## Usuário dentro do container

Dentro do container, um usuário comum é criado em momento de execução para iniciar componentes do Warsaw e o navegador. O `Makefile` deste projeto está preparado para deduzir o UID:GID do seu usuário e repassá-los para o container. Assim, o diretório `$HOME/dockerbb-data` e todo seu conteúdo terá permissões para o seu usuário que executou o container.

Caso precise usar outro UID:GID, pode defeinir estes valores passando variáveis de ambiente diretamente para o container `USER_UID` e `USER_GID`. Confira estes valores no início do `Makefile`.

Para algumas instalações de Docker o usuário comum não tem permissões para executar `docker run...` diretamente, sendo necessário `sudo docker run...`. Neste caso, você pode simplesmente definir os valores na hora de executar pelo `Makefile`.

```bash
sudo make start USER_UID=1000 USER_GID=1000
```
