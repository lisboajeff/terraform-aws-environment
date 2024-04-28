# knin.cloud

O projeto knin.cloud é uma infraestrutura como código que implementa API, rede e gerenciamento de certificados utilizando Terraform.

## Estrutura do Projeto

- **api**: Contém os arquivos Terraform para configuração da API.

  - `main.tf`, `config.tf`, `provider.tf`: Define os recursos e provedores da API.
  - `config`: Armazena arquivos de configuração adicionais.
  - `custom`: Diretório para personalizações da API.

- **network**: Gerencia a configuração da rede.

  - `main.tf`, `config.tf`, `provider.tf`: Configurações principais da rede.
  - `route53`: Configurações para o DNS através do Amazon Route 53.

- **certificates**: Configuração e gerenciamento de certificados.

  - `main.tf`, `provider.tf`, `config.tf`: Arquivos para a gestão de certificados via Terraform.
  - `acm`: Integração com o AWS Certificate Manager para gerenciamento de certificados.
  - `config`: Diretório de configurações gerais.

- **cleanup.sh**: Script para limpeza ou configurações iniciais.

## Exemplo de Configuração de Domínio

Abaixo está um exemplo de configuração para o arquivo `domain.yaml`:

```yaml
domains:
  - name: knin.cloud
    wildcard:
      - "*.knin.cloud"
    sub_domains:
      - name: venda.knin.cloud
      - name: compra.knin.cloud
        mtls:
          truststore_name: Brasil/dev/certificates/truststore/posto.pem
          truststore_version: zEzirXkVfaeCfDrRJftK07h0x9mi2tUs
          bucket: bucket-certificates-test
```

## Pré-requisitos

Antes de iniciar a configuração do projeto, certifique-se de que os seguintes requisitos estejam atendidos:

- Terraform: O projeto utiliza Terraform para gerenciar a infraestrutura como código. Instale a versão mais recente do Terraform seguindo as instruções disponíveis no [site oficial do Terraform](https://www.terraform.io/downloads.html).
- Credenciais AWS: O projeto requer acesso configurado às credenciais da AWS para gerenciar recursos. Certifique-se de configurar suas credenciais AWS seguindo as instruções disponíveis na [documentação da AWS](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).

## Configuração Inicial

1. Clone o repositório para sua máquina local.
2. Navegue até o diretório do projeto.
3. Execute o script `cleanup.sh` para configurações iniciais.
4. Inicialize o Terraform

### Configuração da Rede

1. Navegue até a pasta `network` do projeto.
2. Execute `terraform init` para inicializar o Terraform com os módulos e provedores necessários.
3. Execute `terraform plan` para verificar as mudanças que serão aplicadas na infraestrutura.
4. Execute `terraform apply` para aplicar as configurações na infraestrutura.

### Configuração do Certificate

1. Navegue até a pasta `certificates` do projeto.
2. Siga os mesmos passos listados acima para inicializar e aplicar as configurações de domínio.

### Configuração da API

1. Navegue até a pasta `api` do projeto.
2. Siga os mesmos passos listados acima para inicializar e aplicar as configurações de domínio.

---

---

## Provisonamentos

### Inicializando

```sh
#!/bin/bash
chmod +x init.sh
./init.sh
```

### Network

```sh
#!/bin/bash
./script/network.sh /tmp/domain.yaml
```

### Certificate

```sh
#!/bin/bash
./script/certificates.sh /tmp/domain.yaml
```

### API

```sh
#!/bin/bash
./script/api.sh /tmp/domain.yaml
```
