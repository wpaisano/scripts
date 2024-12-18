#!/bin/sh

# Diretório onde os papéis de parede estão armazenados
backgrounds="/home/glover/Imagens/wallpapers/"
BG_CMD="feh --bg-fill"

get_fitting_images () {
  # Busca duas imagens aleatórias no diretório principal
  find "$backgrounds" -type f | shuf -n2
}

set_screensaver () {
  # Prepara a imagem para o i3lock, convertendo se necessário
  img=$1
  echo "Definindo $img como papel de parede do i3lock."
  png="${img%.*}.png"
  target="${HOME}/.config/i3/$(sha1sum "$img" | awk '{ print $1 }').png"

  if [ ! -f "$target" ]; then
    if [ "$img" != "$png" ]; then
      echo "Convertendo $img para $target."
      convert "$img" "$target"
    else
      cp "$img" "$target"
    fi
  fi

  ln -sf "$target" "${HOME}/.config/i3/i3lock.png"
}

set_background () {
  echo "Definindo papéis de parede para os monitores."
  $BG_CMD "$1" "$2"
}

# Verifica se os comandos necessários estão instalados
for cmd in xdpyinfo feh convert; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd não está instalado. Instale-o para continuar."
    exit 1
  fi
done

# Verifica se é possível conectar ao display atual
if ! xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
  echo "Não foi possível conectar ao display '$DISPLAY'."
  exit 2
fi

# Busca duas imagens apropriadas
images=$(get_fitting_images)
img1=$(echo "$images" | sed -n '1p')
img2=$(echo "$images" | sed -n '2p')

if [ -z "$img1" ] || [ -z "$img2" ]; then
  echo "Imagens insuficientes encontradas no diretório especificado."
  exit 3
fi

# Define a ação com base no argumento
case ${1:-background} in
  screensaver*)
    set_screensaver "$img1"
    ;;
  background*)
    set_background "$img1" "$img2"
    ;;
  both*)
    set_background "$img1" "$img2"
    set_screensaver "$img1"
    ;;
  *)
    echo "Opção inválida. Use 'screensaver', 'background' ou 'both'."
    exit 4
    ;;
esac
