#!/bin/bash

# ==============================================================================
# SCRIPT DE INSTALAÇÃO AUTOMATIZADA DO GNOME NO VOID LINUX
# Autor: Walace
# Propósito: Automatizar a instalação do ambiente GNOME, serviços e utilitários
# ==============================================================================

set -e  # Encerra o script caso algum comando falhe

echo "==== Atualizando o sistema ===="
sudo xbps-install -Syu
echo "==== Atualização concluída. Recomendado reiniciar. Continuando... ===="

echo "==== Instalando pacotes essenciais ===="
sudo xbps-install -y xorg wayland dbus elogind NetworkManager gnome gdm

echo "==== Desabilitando dhcpcd e wpa_supplicant ===="
sudo touch /etc/sv/dhcpcd/down /etc/sv/wpa_supplicant/down
sudo sv down dhcpcd wpa_supplicant

echo "==== Habilitando serviços essenciais ===="
for svc in dbus elogind NetworkManager gdm; do
    sudo ln -sf /etc/sv/$svc /var/service
done

echo "==== Instalando pacotes quality-of-life ===="
sudo xbps-install -y curl wget git xz unzip zip nano vim gptfdisk xtools mtools mlocate ntfs-3g \
    fuse-exfat bash-completion linux-headers gtksourceview4 ffmpeg mesa-vdpau mesa-vaapi \
    htop fastfetch numlockx psmisc 7zip cpupower xmirror mesa-demos noto-fonts-cjk \
    noto-fonts-emoji xdg-user-dirs xdg-user-dirs-gtk

echo "==== Instalando pacotes de desenvolvimento ===="
sudo xbps-install -y autoconf automake bison m4 make libtool flex meson ninja optipng sassc

echo "==== Instalando Pipewire e Wireplumber ===="
sudo xbps-install -y pipewire wireplumber

echo "==== Configurando autostart para Pipewire e Wireplumber ===="
for app in pipewire pipewire-pulse wireplumber; do
    sudo chmod +x /usr/share/applications/${app}.desktop || true
    sudo ln -sf /usr/share/applications/${app}.desktop /etc/xdg/autostart
done

echo "==== Instalando e habilitando cronie ===="
sudo xbps-install -y cronie
sudo ln -sf /etc/sv/cronie /var/service

echo "==== Instalando e habilitando socklog-void ===="
sudo xbps-install -y socklog-void
sudo ln -sf /etc/sv/socklog-unix /var/service
sudo ln -sf /etc/sv/nanoklogd /var/service

echo "==== Instalando Profile Sync Daemon (psd) ===="
git clone https://github.com/madand/runit-services.git
cd runit-services
sudo mv psd /etc/sv/
sudo ln -sf /etc/sv/psd /var/service/
sudo chmod +x /etc/sv/psd/*
cd ..
rm -rf runit-services

echo "==== Instalando Firefox e configurando fontes ===="
sudo xbps-install -y firefox firefox-i18n-en-US
sudo ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo xbps-reconfigure -f fontconfig

echo "==== Atualizando diretórios XDG ===="
xdg-user-dirs-update
xdg-user-dirs-gtk-update

echo "==== Instalando gnome-browser-connector ===="
sudo xbps-install -y gnome-browser-connector

echo "==== Desativando novamente dhcpcd e wpa_supplicant por segurança ===="
sudo sv down dhcpcd wpa_supplicant
sudo touch /etc/sv/dhcpcd/down /etc/sv/wpa_supplicant/down
sudo sv status dhcpcd
sudo sv status wpa_supplicant

echo "==== Todos os serviços principais foram habilitados ===="

echo "==== Instalação concluída com sucesso! ===="
echo "Reinicie sua máquina para iniciar o GNOME com GDM."


