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

### Provisionamento : Network

```sh
#!/bin/bash

# Define os diretórios dos módulos
network_dir="network"

# Aplicando configurações no módulo de Network
echo "Aplicando configurações na rede..."
terraform -chdir="$network_dir" apply -auto-approve -var="domain_yaml_path=domain.yaml"
echo "Configurações da rede aplicadas."
"
```

### Recuperando Servidores DNS

```sh
#!/bin/bash

# Caminho para o arquivo domain.yaml
domain_file="$1"

# Ler cada domínio do arquivo domain.yaml
for domain_name in $(yq e '.domains[].name' $domain_file)
do
    echo "Processando o domínio: $domain_name"

    # Adicionar um ponto no final do domínio se necessário
    domain_name="$domain_name."

    # Recuperar o ID da zona usando AWS CLI
    zone_id=$(aws route53 list-hosted-zones | jq -r --arg domain_name "$domain_name" '.HostedZones[] | select(.Name==$domain_name) | .Id')

    # Verificar se o ID da zona foi encontrado
    if [ -z "$zone_id" ]; then
        echo "Nenhuma zona encontrada para o domínio $domain_name"
    else
        echo "ID da zona para o domínio $domain_name: $zone_id"

        # Recuperar os servidores DNS para o ID da zona encontrado
        name_servers=$(aws route53 get-hosted-zone --id $zone_id | jq -r '.DelegationSet.NameServers[]')
        echo "Servidores DNS para o domínio $domain_name:"
        for ns in $name_servers; do
            echo $ns
        done
    fi
    echo "-----------------------------------"
done

```

### Provisionamento : Certificates

```sh
#!/bin/bash

# Define os diretórios dos módulos
domain_dir="domain"

# Aplicando configurações no módulo de Domain
echo "Aplicando configurações no domínio..."
terraform -chdir="$domain_dir" apply -auto-approve -var="domain_yaml_path=domain.yaml"
echo "Configurações de domínio aplicadas."

```

### Provisionamento : API

```sh
#!/bin/bash

# Caminho para o arquivo domain.yaml
domain_file="$1"

# Ler cada domínio do arquivo domain.yaml usando yq
for domain_name in $(yq e '.domains[].name' $domain_file)
do
    echo "Processando o domínio: $domain_name"

    # Usar AWS CLI para listar todos os certificados e filtrar pelo nome do domínio
    certificate_arn=$(aws acm list-certificates | jq -r --arg domain_name "$domain_name" '.CertificateSummaryList[] | select(.DomainName==$domain_name) | .CertificateArn')

    # Verificar se o ARN foi encontrado
    if [ -z "$certificate_arn" ]; then
        echo "Nenhum certificado encontrado para o domínio $domain_name."
    else
        echo "O ARN do certificado para o domínio $domain_name é: $certificate_arn"

        # Usar AWS CLI para obter informações sobre o certificado
        cert_status=$(aws acm describe-certificate --certificate-arn $certificate_arn | jq -r '.Certificate.Status')

        # Verificar o status do certificado
        if [ "$cert_status" == "ISSUED" ]; then
            echo "O certificado com ARN $certificate_arn está aprovado."

            # Define os diretórios dos módulos
            domain_dir="api"

            # Aplicando configurações no módulo de Domain
            echo "Aplicando configurações no domínio..."
            terraform -chdir="$domain_dir" apply -auto-approve -var="domain_yaml_path=domain.yaml"
            echo "Configurações de domínio aplicadas."

        else
            echo "O certificado com ARN $certificate_arn não está aprovado. Status atual: $cert_status"
        fi

    fi

    echo "-----------------------------------"

done

```
