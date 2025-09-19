#!/bin/bash
# ======================================================
# Instalação e Configuração do Niri no Void Linux
# Baseado no checklist original adaptado para Wayland
# ======================================================

# --------- VARIÁVEIS ---------
USER_NAME="wpaisano"

# --------- ATUALIZAÇÃO DO SISTEMA ---------
sudo xbps-install -u xbps
sudo xbps-install -Syu

# --------- PACOTES BÁSICOS ---------
sudo xbps-install -S elogind dbus polkit neofetch \
xdg-user-dirs nano neovim htop firefox

# Serviços essenciais
ln -s /etc/sv/dbus /var/service
ln -s /etc/sv/elogind /var/service
ln -s /etc/sv/polkit /var/service

# --------- REPOSITÓRIOS EXTRA ---------
sudo xbps-install -S void-repo-nonfree void-multilib void-repo-multilib-nonfree

# --------- REDE ---------
sudo xbps-install -S NetworkManager network-manager-applet
ln -s /etc/sv/NetworkManager /var/service

# --------- BLUETOOTH ---------
sudo xbps-install -S blueman
sudo usermod -aG bluetooth "$USER_NAME"
sudo ln -s /etc/sv/bluetoothd /var/service

# --------- DIRETÓRIOS DE USUÁRIO ---------
xdg-user-dirs-update

# --------- GRÁFICOS / VULKAN ---------
sudo xbps-install -S mesa mesa-vulkan-radeon mesa-vaapi mesa-vdpau vulkan-loader

# --------- AMBIENTE NIRI (Wayland) ---------
sudo xbps-install -S niri seatd kanshi waybar wofi \
foot swaybg mako grim slurp wl-clipboard

# Ativar seatd
ln -s /etc/sv/seatd /var/service
sudo usermod -aG seat "$USER_NAME"

# Terminal Wayland
sudo xbps-install -S foot

# --------- GERENCIADOR DE ARQUIVOS ---------
sudo xbps-install -S thunar thunar-archive-plugin thunar-volman tumbler gvfs file-roller zip unzip mousepad parole ristretto atril

# --------- ÁUDIO (PipeWire) ---------
sudo xbps-install -S pipewire pipewire-pulse wireplumber pavucontrol

# --------- TEMAS E PAPEL DE PAREDE ---------
sudo xbps-install -S nitrogen

# --------- BLOQUEIO DE TELA ---------
sudo xbps-install -S betterlockscreen

# --------- AJUSTES DE PROPRIEDADE ---------
sudo chown -R "$USER_NAME" ~/.cache

# --------- LIMPEZA ---------
sudo xbps-remove -Oo

echo "======================================================"
echo " Instalação concluída. Prossiga com as configurações:"
echo " 1. Criar ~/.config/niri/config.kdl"
echo " 2. Adicionar atalhos e binds conforme abaixo"
echo "======================================================"

