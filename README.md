# Shell Script para Submissão e Gerenciamento na Plataforma PATRIC

Este Shell Script foi desenvolvido para facilitar a submissão de dados, o gerenciamento de status e o download de anotações diretamente na plataforma [PATRIC](https://www.bv-brc.org/). Para utilizar este script, é necessário que você tenha a BV-BRC Command-line Interface instalada no seu sistema operacional.

Abaixo, você encontrará o passo a passo para configurar o ambiente e executar o script de forma otimizada. Vamos começar?

1. **Instalação da BV-BRC Command-line Interface**: Instruções para instalar a CLI necessária para comunicação com o PATRIC.
2. **Configuração do Script**: Ele ta comentado, basta você adicionar seu usuário, senha, diretório dos arquivos fasta, e taxomId do(s) organismo(s). Ta na dúvida olha aqui: https://www.ncbi.nlm.nih.gov/taxonomy
3. **Execução do Script**: Guia para submeter, monitorar e recuperar dados de anotações no PATRIC.

### Pré-requisitos
Antes de prosseguir, certifique-se de que seu sistema atende aos pré-requisitos necessários para o funcionamento do BV-BRC Command-line Interface e das dependências do script.

Vamos começar?

1. Download e instalação do Patric : link para baixar o pacote, usei essa versão ai: https://github.com/PATRIC3/PATRIC-distribution/releases/download/1.039/patric-cli-1.039.deb
```
sudo apt install ./patric-cli-1.039.deb 
```
**Nota** Fiz um ajuste no script para permitir que seja informado o username e password na mesma linha, pra facilitar o uso do script. Mas, foi só isso.
Agora faça a cópia pro destinho, no seu sistema operacional, estou usando o Ubuntu para o teste então segue o exemplo:

```
sudo cp p3-login.pl /usr/share/patric-cli/deployment/plbin/
```

2. Execução:

```
bash Send2PatricAnnotation.sh
```
