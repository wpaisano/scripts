#!/bin/bash
# ======================================================
# Instalação e Configuração do Niri no Void Linux
# VERSÃO REVISADA E OTIMIZADA PARA WAYLAND
# ======================================================

# --------- VARIÁVEIS ---------
USER_NAME="wpaisano"

# --------- ATUALIZAÇÃO DO SISTEMA ---------
echo ">>> Atualizando o sistema..."
sudo xbps-install -u xbps
sudo xbps-install -Syu

# --------- PACOTES BÁSICOS E SERVIÇOS ESSENCIAIS ---------
echo ">>> Instalando pacotes básicos..."
sudo xbps-install -S elogind dbus polkit neofetch \
xdg-user-dirs nano neovim htop firefox

echo ">>> Habilitando serviços essenciais..."
sudo ln -sf /etc/sv/dbus /var/service/
sudo ln -sf /etc/sv/elogind /var/service/
sudo ln -sf /etc/sv/polkitd /var/service/ # <<< CORREÇÃO: o serviço é polkitd

# --------- REPOSITÓRIOS EXTRA ---------
echo ">>> Habilitando repositórios nonfree e multilib..."
sudo xbps-install -S void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree

# --------- REDE ---------
echo ">>> Configurando a rede com NetworkManager..."
sudo xbps-install -S NetworkManager network-manager-applet
sudo ln -sf /etc/sv/NetworkManager /var/service/

# --------- BLUETOOTH ---------
echo ">>> Configurando Bluetooth..."
sudo xbps-install -S blueman
sudo usermod -aG bluetooth "$USER_NAME"
sudo ln -sf /etc/sv/bluetoothd /var/service/

# --------- DIRETÓRIOS DE USUÁRIO ---------
echo ">>> Criando diretórios de usuário padrão..."
xdg-user-dirs-update

# --------- GRÁFICOS / VULKAN ---------
# <<< SUGESTÃO: Adicionado comentário para outros hardwares
# Para AMD (como no original):
sudo xbps-install -S mesa mesa-vulkan-radeon mesa-vaapi mesa-vdpau vulkan-loader
# Para Intel, adicione: intel-video-accel
# Para Nvidia, instale o driver proprietário: nvidia

# --------- AMBIENTE NIRI (Wayland) ---------
echo ">>> Instalando o ambiente Niri e ferramentas Wayland..."
# <<< CORREÇÃO: Removido 'seatd' para evitar conflito com 'elogind'
# <<< MELHORIA: Removida a instalação duplicada do 'foot'
sudo xbps-install -S niri kanshi waybar wofi foot swaybg mako grim slurp wl-clipboard

# <<< CORREÇÃO: Não adicionar o usuário ao grupo 'seat' nem habilitar o serviço
# sudo usermod -aG seat "$USER_NAME" # REMOVIDO
# sudo ln -s /etc/sv/seatd /var/service # REMOVIDO

# --------- GERENCIADOR DE ARQUIVOS ---------
echo ">>> Instalando o gerenciador de arquivos Thunar..."
sudo xbps-install -S thunar thunar-archive-plugin thunar-volman tumbler gvfs file-roller zip unzip mousepad parole ristretto atril

# --------- ÁUDIO (PipeWire) ---------
echo ">>> Configurando áudio com PipeWire..."
sudo xbps-install -S pipewire wireplumber pavucontrol
# O WirePlumber gerencia a inicialização dos serviços do PipeWire na sessão do usuário.

# --------- BLOQUEIO DE TELA (Wayland) ---------
echo ">>> Instalando bloqueador de tela para Wayland..."
# <<< CORREÇÃO: Substituído betterlockscreen (X11) por swaylock (Wayland)
sudo xbps-install -S swaylock

# --------- AJUSTES DE PROPRIEDADE ---------
echo ">>> Corrigindo permissões de diretórios..."
# <<< CORREÇÃO: Caminho absoluto para o home do usuário
sudo chown -R "$USER_NAME":"$USER_NAME" "/home/$USER_NAME/.config"
sudo chown -R "$USER_NAME":"$USER_NAME" "/home/$USER_NAME/.cache"
sudo chown -R "$USER_NAME":"$USER_NAME" "/home/$USER_NAME/.local"

# --------- LIMPEZA ---------
echo ">>> Limpando pacotes órfãos..."
sudo xbps-remove -Oo

echo "======================================================"
echo " Instalação concluída. Prossiga com as configurações:"
echo " 1. REINICIE O SISTEMA para que os serviços e grupos sejam aplicados."
echo " 2. Crie o arquivo de configuração: ~/.config/niri/config.kdl"
echo " 3. Configure seus atalhos para waybar, wofi e swaylock no config.kdl"
echo "======================================================"
