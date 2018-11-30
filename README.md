# dockerbb

Imagem Docker com google-chrome e warsaw instalados para acessar o Banco do Brasil.

## NOTA DE INSTALAÇÃO

Por questões de transparência e segurança, não há uma imagem pré-construída em repositório público. Para usar, você deverá obter o código fonte deste repositório e construir sua própria imagem. Sinta-se livre para realizar push para qualquer Registry público ou privado sob sua única e própria responsabilidade.

## Build local

Com Docker mais recente instalado, faça um build de imagem local com os comandos abaixo.

```bash
git clone https://github.com/juliohm1978/dockerbb.git
cd dockerbb
make
```

Coloque isto num terminal separado e vá tomar um café. O processo de build envolve instalação de inúmeros pacotes Ubuntu para o ambiente X11 e interfaces gráficas e deve demorar vários minutos.

Ao final, uma imagem local `dockerbb` estará criada.

Se você pretende enviar esta imagem a um Docker Registry (push), use o comando `make squash` para criar uma imagem mais compacta. Isto deve incluir parâmetro `--squash` no `docker build` para reduzir o tamanho da imagem final.

> Para `--squash` funcionar, seu dockerd precisa ter a flag `--experimental`.
> 
> Confira a documentação do Docker para maiores detalhes: https://docs.docker.com/engine/reference/commandline/dockerd/

## Executando

Há um target no `Makefile` preparado para executar um container.

```bash
make start
```

Isto deve criar um container chamado `dockerbb` com volume montado em `$HOME/dockerbb-data`. Este diretório em seu computador representa o diretório `$HOME` do usuário dentro do container, onde um usuário chamado `user` é utilizado com uid:gid `1000:1000`. Estes valores geralmente batem com usuário Ubuntu principal desktop instalado. Isto significa que, em uma instalação padrão Ubuntu Desktop, os arquivos criados em `$HOME/dockerbb-data` terão as mesas permissões do seu usuário principal.

Aguarde alguns instantes até o Google Chrome aparecer em sua tela. Em caso de problemas pode conferir os logs do container.

```bash
make logs
```

Ao fechar o navegador, o container deve parar e ser removido automaticamente. Se isto não ocorrer, pode forçar a remoção do container.

```bash
make stop
```

Mesmo que o containe seja removido, o diretório `$HOME/dockerbb-data` continua existindo em sua pasta pessoal. Isto deve manter as configurações do Google Chrome entre execuções diferentes.

> NOTA: Com cada nova execução do container, uma nova instalação do pacote Warsaw é realizada. Isto deve renovar chaves e certificados do componente sempre que o `dockerbb` for executado.

