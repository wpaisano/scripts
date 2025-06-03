#!/bin/bash
set -e

echo "==== Atualizando pacotes ===="
sudo xbps-install -Syu

echo "==== Limpando pacotes órfãos e cache ===="
sudo xbps-remove -Oo

echo "==== Atualizando pacotes Flatpak ===="
if command -v flatpak &> /dev/null; then
    sudo flatpak update -y
else
    echo "Flatpak não está instalado."
fi

echo "==== Verificando status dos serviços essenciais ===="
for service in dbus elogind NetworkManager sddm; do
    sv status $service
done

echo "==== Sincronizando diretórios de usuário ===="
xdg-user-dirs-update

echo "==== Atualizando cache de fontes ===="
fc-cache -fv

echo "==== Verificando espaço em disco ===="
df -h

echo "==== Sincronizando perfis de navegador (se psd estiver instalado) ===="
if command -v psd &> /dev/null; then
    psd p
else
    echo "psd não está instalado."
fi

echo "==== Verificando atualizações de firmware ===="
if command -v fwupdmgr &> /dev/null; then
    fwupdmgr get-updates
else
    echo "fwupd não está instalado."
fi

echo "==== Manutenção concluída com sucesso! ===="

