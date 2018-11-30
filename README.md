# dockerbb

Imagem Docker com google-chrome e warsaw instalados para acessar o Banco do Brasil.

## Nota de Instalação

Por questões de transparência e segurança, não há uma imagem pré-construída em repositório público. Para usar, você deverá obter o código fonte deste repositório e construir sua própria imagem. Sinta-se livre para realizar push para qualquer Registry privado sob sua única e própria responsabilidade.

## Construção Local da Imagem

Com Docker mais recente instalado, faça um build de imagem local com os comandos abaixo.

```bash
git clone https://github.com/juliohm1978/dockerbb.git
cd dockerbb
make
```

Coloque isto num terminal separado e vá tomar um café. O processo de build envolve instalação de inúmeros pacotes Ubuntu para o ambiente X11 e interfaces gráficas e deve demorar vários minutos.

Ao final, uma imagem local `dockerbb` estará criada.

Se você pretende enviar sua imagem (push) a um Docker Registry privado, use o comando `make squash` para criar uma imagem mais compacta. Assim, o parâmetro `--squash` será usado no `docker build` para reduzir o tamanho da imagem final.

> Para `--squash` funcionar, seu Docker Daemon precisa ser configurado com a flag `--experimental`.
> 
> Confira a documentação do Docker para maiores detalhes: https://docs.docker.com/engine/reference/commandline/dockerd/

## Executando

Há um target no `Makefile` preparado para executar um container.

```bash
make start
```

Isto deve criar um container chamado `dockerbb` com volume montado em `$HOME/dockerbb-data`. Este diretório em seu computador representa o diretório `$HOME` do usuário dentro do container, onde um usuário chamado `user` é criado na hora da execução. Para alterar o UID:GID deste usuário, confira o capítulo abaixo "Usuário dentro do container".

Aguarde alguns instantes até o Google Chrome aparecer em sua tela. Em caso de problemas pode conferir os logs do container. Ao fechar o navegador, o container será removido automaticamente. Se isto não ocorrer, a remoção pode ser forçada.

```bash
make stop
```

Mesmo que o container seja removido, o diretório `$HOME/dockerbb-data` continua existindo em sua pasta pessoal. Isto deve manter as configurações e histórico do Google Chrome entre execuções diferentes.

> NOTA: Com cada nova execução, uma nova instalação do pacote Warsaw é realizada. Isto renova chaves e certificados do componente sempre que o `dockerbb` for executado.

## Usuário dentro do container

Dentro do container, um usuário comum é criado em momento de execução para iniciar componentes do Warsaw e o navegador. O `Makefile` deste projeto está preparado para deduzir o UID:GID do seu usuário e repassá-los ao container. Assim, o diretório `$HOME/dockerbb-data` e todo seu conteúdo terá permissões para o seu usuário.

Caso precise usar outro UID:GID, pode defeinir estes valores passando variáveis de ambiente diretamente para o container `USER_UID` e `USER_GID`. Para algumas instalações de Docker o usuário comum não tem permissões para executar `docker run...` diretamente, sendo necessário `sudo docker run...`.

Para estes casos, você pode definir os valores na hora de executar.


```bash
sudo make start USER_UID=1000 USER_GID=1000
```

## Algumas notas de segurança

Sendo uma imgem Docker com base `FROM ubuntu:18.04`, segue-se que o `dockerbb` foi criado especialmente para ambientes Linux. Nenhum suporte foi idealizado para executar esta imagem no ambiente Windows. Com isto em mente, lembre-se de que o `dockerbb` só funciona em instalações Linux com desktop gráfico. O ambiente suportado e testado é o Ubuntu 18.04 LTS / Linux Mint 19. Talvez sejam necessários alguns ajustes nos parâmetros do `docker run ...` para que funcione em outras versões/distribuições.

O navegador e Warsaw dentro do container são executados com uma conta de usuário comum. Este usuário só é criado no container no momento de execução. O container inicia com usuário `root` para poder realizar esta e outras tarefas antes de iniciar o navegador. Isto inclui:

* Criar o usuário comum `user` com UID:GID especificados.
* Instalar o Warsaw.
* Iniciar instâncias do Warsaw em plano de fundo.
* Iniciar o navegador com usuário `user`.

Para poder executar aplicações gráficas, o container acessa o X11 do host onde executa. Para isso, o container precisa de acesso às interfaces de rede do host. Em prática, o container é executado com `docker run --net=host --cap-add=SYS_ADMIN`. Isto pode ser um risco de segurança para o seu ambiente. Portanto, lembre-se de considerar este aspecto antes de usar a imagem.

O diretório do seu computador `$HOME/dockerbb-data` é montado como volume para o `/home/user` dentro do container. Isso permite o navegador guardar seu histórico e configurações entre diferentes execuções e ajuda você a fazer download/upload de arquivos. Se não deseja ter este ponto aberto fora do container, faça os ajustes no `docker run...` do Makefile, ou simplesmente crie sua própria chamada para refletir suas necessidades.

## Problemas Conhecidos

Alguns problemas podem ocorrer na comunicação entre o navegador e o processo Warsaw (core). Por se tratar de um módulo completamente obscuro, nenhuma mensagem de log referente a este processo aparece no sistema. Por isso, é difícil identificar a causa.

### Cannot open display :0

Uma falha de integração entre o ambiente dentro do container e o X11 de sua máquina. O caminho do arquivo `.XAuthority` pode ser diferente no seu caso. Tente descobrir com `xauth info` e passar o arquivo correto.

```bash
make start XAUTHIRITY_FILE=$(xauth info | grep 'Authority file' | awk '{print $3}')
```

### cert_verify_proc_nss.cc(975)] CERT_PKIXVerifyCert for 127.0.0.1 failed err=-8179

Sem causa definida. Mensagem aparece no console do container. O navegador não conseguiu validar a comunicação com o módulo Warsaw. Em alguns casos, reiniciar o container pode resolver o problema.

### Erro ao enviar evento associado 'diges': Not connected to daemon

Sem causa definida. Mensagem aparece no navegador. O navegador não conseguiu se conectar ao o módulo Warsaw. Em alguns casos, reiniciar o container pode resolver o problema.
