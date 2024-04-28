#!/bin/bash

# Define os diretórios dos módulos
domain_dir="certificates"

#Define o caminho do arquivo de domain
domain_yaml_path="$1"

# Aplicando configurações no módulo de Domain
echo "Aplicando configurações no certificates..."
terraform -chdir="$domain_dir" apply -auto-approve -var="domain_yaml_path=$domain_yaml_path"
echo "Configurações de certificates aplicadas."