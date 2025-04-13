#!/bin/bash
cd ~/home/wpaisano/MenteDigital/  # ajuste conforme seu diretório
git add .
git commit -m "Backup automático do Obsidian - $(date '+%d/%m/%Y %H:%M')"
git push origin main
