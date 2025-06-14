#!/bin/bash

set -e

### Pacotes essenciais e áudio ###
echo "[1/7] Atualizando sistema e instalando dependências de áudio e integração Wayland..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm \
  pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber \
  gstreamer gst-libav gst-plugins-base gst-plugins-good \
  gst-plugins-bad gst-plugins-ugly ffmpeg nano gnome-keyring \
  xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland \
  xdg-user-dirs xdg-user-dirs-gtk xdg-utils unzip unrar bash-completion \
  pavucontrol pamixer swayidle grimblast ffmpegthumbnailer ffmpegthumbs \
  ttf-font-awesome noto-fonts noto-fonts-emoji noto-fonts-extra \
  ttf-firacode-nerd ttf-jetbrains-mono-nerd

### Instalar yay ###
echo "[2/7] Instalando yay..."
sudo pacman -S --noconfirm git base-devel
cd ~
git clone https://aur.archlinux.org/yay.git
temp_dir=$(mktemp -d)
mv yay "$temp_dir"
cd "$temp_dir/yay"
makepkg -si --noconfirm
cd ~
rm -rf "$temp_dir"

### Instalar ambiente Hyprland e utilitários principais ###
echo "[3/7] Instalando Hyprland e utilitários..."
sudo pacman -S --noconfirm \
  hyprland hyprlock hypridle hyprcursor hyprpaper hyprpicker \
  waybar kitty wofi dolphin dolphin-plugins ark \
  qt5ct qt6ct qt5-wayland qt6-wayland \
  dunst cliphist mpv xdg-desktop-portal-gtk \
  polkit-gnome adw-gtk-theme papirus-icon-theme nwg-look

echo "[4/7] Instalando pacotes AUR..."
yay -S --noconfirm hyprshot wlogout qview visual-studio-code-bin firefox brave-bin \
  swayosd-git waypaper hyprswitch swaylock-effects clipman clipse protonup-qt-bin

### Ativar serviços do pipewire ###
echo "[5/7] Habilitando serviços de áudio..."
systemctl --user enable pipewire pipewire-pulse wireplumber

### Bluetooth ###
echo "[6/7] Instalando e ativando Bluetooth..."
sudo pacman -S --noconfirm bluez bluez-utils blueman
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

### Finalização ###
echo "[7/7] Aplicando tema padrão com nwg-look (GTK e ícones)..."
nwg-look --apply || echo "[Aviso] Execute nwg-look manualmente para configurar temas."

read -p "Deseja reiniciar agora? (s/n): " choice
if [[ "$choice" =~ ^[Ss]$ ]]; then
    shutdown -r now
else
    echo "Reinicialização cancelada. Configure o Hyprland em ~/.config/hypr/hyprland.conf"
fi
