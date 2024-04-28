#!/bin/bash

# Limpeza
chmod +x script/cleanup.sh && script/cleanup.sh

# Definir os módulos a serem processados
modules="api network certificates"

for module in $modules; do
        # Caminho base para o módulo
        module_path="$module" # Substitua pelo caminho correto
        terraform -chdir="$module_path" init
        chmod +x "script/$module.sh"
done
