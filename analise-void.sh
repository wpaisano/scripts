#!/bin/bash
echo "Verificando pacotes instalados..."
xbps-query -l

echo "Verificando inconsistências..."
xbps-pkgdb -a

echo "Verificando pacotes órfãos..."
xbps-remove -o

echo "Verificando atualizações disponíveis..."
xbps-install -Sun

echo "Análise concluída!"
