#!/bin/bash

# Definir os módulos a serem processados
modules="api network certificates"

# Caminho para o arquivo .gitignore
gitignore_path=".gitignore"

# Solicitar confirmação antes de prosseguir
echo "AVISO: Você está prestes a apagar arquivos críticos que incluem os estados do Terraform para cada módulo."
echo "Se você prosseguir, não terá mais os estados do Terraform disponíveis para estes módulos."
read -p "Tem certeza que deseja continuar? (y/n) " -n 1 -r
echo # move to a new line

if [[ $REPLY =~ ^[Yy]$ ]]; then

    # Iterar sobre cada módulo e remover os arquivos/diretórios específicos do Terraform
    for module in $modules; do
        echo "Limpando arquivos do Terraform no módulo: $module"

        # Caminho base para o módulo
        module_path="$module" # Substitua pelo caminho correto

        # Ler cada entrada no .gitignore e remover os arquivos/diretórios correspondentes
        while IFS= read -r line; do
            # Ignorar linhas vazias e comentários no .gitignore
            if [[ "$line" == \#* ]] || [[ -z "$line" ]]; then
                continue
            fi

            # Construir o caminho completo e remover o arquivo/diretório
            target="$module_path/$line"
            echo "Removendo: $target"
            rm -rf "$target"
        done <"$gitignore_path"

        echo "Limpeza concluída para o módulo: $module"
        echo "---------------------------------------"
    done

    echo "Todos os módulos foram limpos."

else
    echo "Operação cancelada pelo usuário."
fi
