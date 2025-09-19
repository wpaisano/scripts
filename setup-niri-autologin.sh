#!/bin/bash
# ============================================================
# Configuração automática do Void Linux + Niri
# - Adiciona usuário ao grupo wheel (sudo)
# - Configura login automático no tty1
# - Configura inicialização automática do Niri (Wayland)
# ============================================================

USER_NAME="wpaisano"   # <<< ALTERE SE NECESSÁRIO

echo ">>> Adicionando $USER_NAME ao grupo wheel (sudo)..."
usermod -aG wheel "$USER_NAME" || {
    echo "Erro ao adicionar ao grupo wheel"; exit 1;
}

echo ">>> Habilitando sudo para o grupo wheel..."
# Descomenta linha do sudoers se estiver comentada
if ! grep -q "^%wheel ALL=(ALL:ALL) ALL" /etc/sudoers; then
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
fi

echo ">>> Criando ~/.bash_profile para iniciar Niri..."
su - "$USER_NAME" -c "mkdir -p ~ && touch ~/.bash_profile"
su - "$USER_NAME" -c "cat > ~/.bash_profile << 'EOF'
# Início automático do Niri no tty1
if [[ -z \$DISPLAY ]] && [[ \$(tty) == /dev/tty1 ]]; then
    exec dbus-run-session niri
fi
EOF"

echo ">>> Configurando autologin no tty1..."
CONF_DIR=/etc/sv/agetty-tty1
if [ -d \$CONF_DIR ]; then
    echo "AUTOLOGIN=$USER_NAME" > \$CONF_DIR/conf
    ln -sf \$CONF_DIR /var/service/
else
    echo "Aviso: Serviço agetty-tty1 não encontrado."
    echo "Verifique se o runit está instalado corretamente."
fi

echo ">>> Configuração concluída!"
echo "Reinicie o sistema para aplicar as mudanças."

