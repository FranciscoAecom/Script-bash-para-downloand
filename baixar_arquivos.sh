#!/bin/bash

# URL onde os arquivos ZIP estão localizados
URL="https://arquivos.receitafederal.gov.br/dados/cnpj/dados_abertos_cnpj/2024-10/"

# Diretório onde os arquivos serão salvos
DIR_DESTINO="./cnpj_zips"

# Criar diretório de destino, se não existir
mkdir -p "$DIR_DESTINO"

# Baixar a página com curl e procurar os links para os arquivos .zip
echo "Baixando a página para encontrar links de arquivos ZIP..."
links=$(curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36" "$URL" | \
        grep -oP 'href="\K[^"]+\.zip')

# Verificando os links encontrados
echo "Links encontrados:"
echo "$links"

# Processar cada link
echo "$links" | while read -r link; do
    # Se o link não for absoluto, adiciona a base da URL
    if [[ "$link" != http* ]]; then
      link="${URL}${link}"
    fi
    
    # Nome do arquivo a ser salvo
    ARQUIVO_LOCAL="${DIR_DESTINO}/$(basename "$link")"
    
    # Mostrar o link do arquivo que está sendo baixado
    echo "Baixando $link para $ARQUIVO_LOCAL"
    
    # Baixar o arquivo com curl
    curl -s -o "$ARQUIVO_LOCAL" "$link"
done

echo "Todos os arquivos ZIP foram baixados!"


