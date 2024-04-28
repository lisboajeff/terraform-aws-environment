#!/bin/bash

# Define os diretórios dos módulos
network_dir="network"

# Caminho para o arquivo domain.yaml
domain_file="$1"

# Aplicando configurações no módulo de Network
echo "Aplicando configurações na rede..."
terraform -chdir="$network_dir" apply -auto-approve -var="domain_yaml_path=$domain_file"
echo "Configurações da rede aplicadas."

# Ler cada domínio do arquivo domain.yaml
for domain_name in $(yq -e '.domains[].name' $domain_file); do

    domain_name="$(echo $domain_name | cut -d '"' -f 2)"

    echo "Processando o domínio: $domain_name"

    # Recuperar o ID da zona usando AWS CLI
    zone_id=$(aws route53 list-hosted-zones | jq -r --arg domain_name "$domain_name." '.HostedZones[] | select(.Name==$domain_name) | .Id' | cut -d '/' -f 3)

    echo "zone id : $zone_id"

    # Verificar se o ID da zona foi encontrado
    if [ -z "$zone_id" ]; then
        echo "Nenhuma zona encontrada para o domínio $domain_name"
    else
        echo "ID da zona para o domínio $domain_name: $zone_id"

        # Recuperar os servidores DNS para o ID da zona encontrado
        name_servers_route53=$(aws route53 get-hosted-zone --id $zone_id | jq -r '.DelegationSet.NameServers[]')
        echo "Servidores DNS para o domínio $domain_name:"

        rm zone

        for ns in $name_servers_route53; do
            # echo $ns
            echo $ns >>zone
        done

        echo "Verificando resolução de Name Servers para $domain_name:"

        name_servers_dig=$(dig $domain_name NS +short)

        # Verifica se a saída está vazia
        if [ -z "$name_servers_dig" ]; then
            echo "Os Name Servers para $domain_name ainda não foram resolvidos.Aguarde"
            exit 1
        else
            ns_route53="$(echo "$name_servers_route53" | tr '\n' ',' | sed 's/,$//')"
            ns_dig="$(echo "$name_servers_dig" | tr '\n' ',' | sed 's/,$//')"
            python3 script/ns.py "$ns_route53" "$ns_dig"
            exit_code=$?
            # Verificar o código de saída do script Python
            if [ $exit_code -eq 0 ]; then
                echo "Sucesso: As listas de Name Servers são iguais."
                echo "Execute o próximo módulo"
            else
                echo "Erro: As listas de Name Servers não são iguais."
                exit 1
            fi
        fi

    fi

    echo "-----------------------------------"

done
