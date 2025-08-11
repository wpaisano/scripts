#!/bin/sh
# Script de instalação do Sway no Void Linux
# Autor original: Secret Firefox
# Revisão e otimização: Walace
# Objetivo: pós-instalação com Sway e pacotes complementares + greetd com gtkgreet para login gráfico

echo "[1/15] Atualizando sistema..."
sudo xbps-install -Syu

echo "[2/15] Adicionando repositório nonfree..."
sudo xbps-install -Rs void-repo-nonfree -y

echo "[3/15] Instalando serviços essenciais..."
sudo xbps-install dbus elogind NetworkManager -y

echo "[4/15] Instalando pacotes recomendados..."
sudo xbps-install curl wget git xz unzip zip nano vim gptfdisk xtools mtools mlocate ntfs-3g fuse-exfat \
    bash-completion linux-headers ffmpeg mesa-vdpau mesa-vaapi htop fastfetch psmisc 7zip cpupower \
    xmirror mesa-demos noto-fonts-cjk noto-fonts-emoji xdg-user-dirs xdg-user-dirs-gtk -y

echo "[5/15] Instalando pacotes de desenvolvimento..."
sudo xbps-install autoconf automake bison m4 make libtool flex meson ninja optipng sassc -y

echo "[6/15] Instalando sistema de som (PipeWire e WirePlumber)..."
sudo xbps-install pipewire pipewire-pulse wireplumber -y

echo "[6.1/15] Ativando serviços PipeWire e WirePlumber via runit..."
sudo ln -s /etc/sv/pipewire /var/service
sudo ln -s /etc/sv/pipewire-pulse /var/service
sudo ln -s /etc/sv/wireplumber /var/service

echo "[7/15] Instalando e ativando Cronie..."
sudo xbps-install cronie -y
sudo ln -s /etc/sv/cronie /var/service

echo "[8/15] Instalando e ativando sistema de logs..."
sudo xbps-install socklog-void -y
sudo ln -s /etc/sv/socklog-unix /var/service
sudo ln -s /etc/sv/nanoklogd /var/service

echo "[9/15] Instalando Profile Sync Daemon (psd)..."
git clone https://github.com/madand/runit-services
cd runit-services
sudo mv psd /etc/sv/
sudo ln -s /etc/sv/psd /var/service/
sudo chmod +x /etc/sv/psd/*
cd ..
rm -rf runit-services

echo "[10/15] Instalando Firefox e configurando fontes..."
sudo xbps-install firefox firefox-i18n-en-US -y
sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo xbps-reconfigure -f fontconfig

echo "[11/15] Instalando servidores gráficos..."
sudo xbps-install xorg wayland xorg-server-xwayland -y

echo "[12/15] Instalando Sway e componentes..."
sudo xbps-install sway swayidle swaylock sway-audio-idle-inhibit Waybar foot wmenu \
    xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr rtkit \
    breeze-snow-cursor-theme font-fira-ttf polkit -y

echo "[13/15] Instalando aplicativos extras..."
sudo xbps-install caja engrampa eom mate-calc pluma nwg-look atril vlc mousepad -y

echo "[14/15] Instalando utilitários de captura de tela..."
sudo xbps-install grim wl-clipboard -y

echo "[14.1/15] Desativando dhcpcd e wpa_supplicant em favor do NetworkManager..."
sudo sv down dhcpcd wpa_supplicant
sudo touch /etc/sv/dhcpcd/down /etc/sv/wpa_supplicant/down
sudo sv status dhcpcd
sudo sv status wpa_supplicant

echo "[14.2/15] Ativando serviços essenciais..."
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/elogind /var/service
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/polkit /var/service
sudo ln -s /etc/sv/rtkit /var/service

echo "[15/15] Atualizando diretórios de usuário..."
xdg-user-dirs-update
xdg-user-dirs-gtk-update

echo "[Extra] Instalando greetd e gtkgreet..."
sudo xbps-install greetd gtkgreet -y

echo "[Extra] Configurando greetd para iniciar com gtkgreet e Sway..."
sudo mkdir -p /etc/greetd

cat << 'EOF' | sudo tee /etc/greetd/config.toml
[terminal]
vt = 1

[default_session]
command = "gtkgreet --cmd sway"
user = "greeter"
EOF

sudo ln -s /etc/sv/greetd /var/service

echo "======================================================="
echo "Instalação concluída com sucesso!"
echo "O sistema iniciará com greetd (login gráfico) usando gtkgreet e Sway."
echo "======================================================="