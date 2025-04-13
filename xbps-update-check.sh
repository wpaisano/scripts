#!/bin/bash

# Verifica atualizações
updates=$(xbps-install -un | wc -l)

# Ícone (usando Nerd Font ou emoji como alternativa)
icon=" "  # nf-fa-refresh

# Texto exibido na barra
echo "<txt><span font='Open Sans 10'>$icon $updates</span></txt>"
echo "<tool>Pacotes disponíveis para atualização: $updates</tool>"

# Comando ao clicar
echo "<click>xfce4-terminal -e 'sudo xbps-install -Su'</click>"

