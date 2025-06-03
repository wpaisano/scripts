#!/bin/bash
set -e  # Encerra o script se algum comando falhar

# ======= Tratamento de interrupção =======
trap 'echo "⚠️ Script interrompido em: $(date)" >> "$LOG_FILE"; exit 1' INT TERM

# ======= Diretórios e arquivos =======
LOG_DIR="$HOME/Logs"
LOG_FILE="$LOG_DIR/backup_log.txt"
LOCAL_CONFIG_BACKUP="$HOME/GoogleDrive/Backup_Pessoal/configs"
BACKUP_ROOT="gdrive:/Backup_Pessoal"

dirs_to_backup=(
    "$HOME/Documentos"
    "$HOME/Vídeos"
    "$HOME/Downloads"
    "$HOME/Imagens"
    "$HOME/Scripts"
    "$HOME/Logs"
    "$HOME/Customização"
    "$HOME/Applications"
)

# ======= Criação de diretórios =======
mkdir -p "$LOG_DIR"
mkdir -p "$LOCAL_CONFIG_BACKUP"

# ======= Log inicial =======
echo -e "\n🔁 Execução iniciada em: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"

# ======= Backup incremental com rclone =======
for dir in "${dirs_to_backup[@]}"; do
    if [ -d "$dir" ]; then
        echo "🔄 Sincronizando $(basename "$dir")..." >> "$LOG_FILE"
        rclone sync "$dir" "$BACKUP_ROOT/$(basename "$dir")" \
            --progress --log-file="$LOG_FILE" --log-level INFO
    else
        echo "❌ Diretório $dir não encontrado!" >> "$LOG_FILE"
    fi
done

# ======= Exportar lista de pacotes - compatível com Void Linux =======
DATA=$(date +%Y-%m-%d)
PACOTE_ARQUIVO="$LOCAL_CONFIG_BACKUP/pacotes_$DATA.txt"

echo "📝 Exportando lista de pacotes instalados..." >> "$LOG_FILE"
xbps-query -m | awk '{print $2}' | sort > "$PACOTE_ARQUIVO"

# ======= Manter apenas as 5 versões mais recentes =======
cd "$LOCAL_CONFIG_BACKUP" || exit
ls -t pacotes_*.txt | sed -e '1,5d' | xargs -r rm -f --

# ======= Notificação final (Wayland) =======
notify-send "✅ Backup Concluído" "Backup dos diretórios e configurações realizado com sucesso!" -i dialog-information || \
echo "⚠️ Notificação não enviada. Verifique o suporte ao notify-send no Wayland." >> "$LOG_FILE"

echo "✅ Backup concluído com sucesso em: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"

