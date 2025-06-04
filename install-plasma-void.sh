#!/bin/bash
set -e

echo "==== Atualizando sistema e xbps ===="
sudo xbps-install -Syu
sudo xbps-install -yu xbps

echo "==== Ativando repositório void-repo-nonfree ===="
sudo xbps-install -y void-repo-nonfree

echo "==== Instalando servidor gráfico (Xorg), Wayland e drivers ===="
sudo xbps-install -y xorg mesa libinput wayland
sudo xbps-install -y xf86-video-intel

echo "==== Instalando serviços essenciais ===="
sudo xbps-install -y dbus elogind NetworkManager

echo "==== Instalando utilitários e ferramentas ===="
sudo xbps-install -y \
    gvfs gvfs-mtp gvfs-afc gvfs-smb \
    tumbler ntfs-3g \
    pipewire wireplumber \
    xdg-utils xdg-user-dirs \
    noto-fonts-ttf noto-fonts-emoji fontconfig \
    alsa-utils pulseaudio-utils pavucontrol \
    plasma-pa plasma-nm \
    konsole ark kwalletmanager

echo "==== Instalando ambiente KDE Plasma ===="
sudo xbps-install -y kde5 kde5-baseapps

# Plasma 6 já inclui Wayland por padrão — não é necessário plasma-wayland-session

echo "==== Atualizando diretórios de usuário ===="
xdg-user-dirs-update

echo "==== Instalando e ativando gerenciador de exibição (SDDM) ===="
sudo xbps-install -y sddm

echo "==== Ativando serviços essenciais ===="
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/elogind /var/service
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/sddm /var/service

echo "==== Desativando serviços que podem causar conflitos ===="
sudo rm -f /var/service/dhcpcd
sudo rm -f /var/service/wpa_supplicant

echo "==== Ativando Pipewire no autostart ===="
mkdir -p ~/.config/autostart
cp /etc/xdg/autostart/pipewire.desktop ~/.config/autostart/

echo "==== Configurando fontes ===="
fc-cache -fv

echo "==== Instalação e configuração concluídas com sucesso! ===="

echo "==== Status dos serviços ===="
sv status dbus
sv status elogind
sv status NetworkManager
sv status sddm

