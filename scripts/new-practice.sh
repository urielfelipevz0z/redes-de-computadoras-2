#!/bin/bash

# Script para crear nueva práctica en Redes de Computadoras 2
# Autor: Uriel Felipe Vázquez Orozco y Euler Molina Martínez
# Descripción: Genera automáticamente la estructura de carpetas y archivos base

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[ÉXITO]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 <número-práctica> <tema-práctica>"
}

# Verificar argumentos
if [[ $# -ne 2 ]]; then
    log_error "Número incorrecto de argumentos"
    show_help
    exit 1
fi

PRACTICA_NUM=$(printf "%02d" "$1")
TEMA="$2"
PRACTICA_DIR="practica-${PRACTICA_NUM}-${TEMA}"
FULL_PATH="./practicas/${PRACTICA_DIR}"

# Verificar que estamos en directorio correcto
if [[ ! -d "practicas" ]] || [[ ! -d "templates" ]]; then
    log_error "Ejecuta este script desde el directorio raíz del proyecto"
    exit 1
fi

# Verificar si ya existe
if [[ -d "$FULL_PATH" ]]; then
    log_error "La práctica $PRACTICA_DIR ya existe"
    exit 1
fi

echo -e "${BLUE}"
echo "=================================================="
echo "    NUEVA PRÁCTICA - REDES DE COMPUTADORAS 2"
echo "=================================================="
echo -e "${NC}"

log_info "Creando práctica: $PRACTICA_DIR"

# Crear estructura de directorios
log_info "Creando estructura de directorios..."
mkdir -p "$FULL_PATH"/{images,configs,scripts,topologies}

# Crear archivos base
log_info "Generando archivos base..."

# Script de build
cat > "$FULL_PATH/build.sh" << 'EOF'
#!/bin/bash

set -e

# Configuración
EISVOGEL_TEMPLATE="../../Eisvogel-3.2.0/eisvogel.latex"
BACKGROUND_PAGE="../../Eisvogel-3.2.0/examples/title-page-background/backgrounds/background5.pdf"
BACKGROUND_TITLE="../../Eisvogel-3.2.0/examples/title-page-custom/background.pdf"
LOGO="../../FIE-Logo-Oro.png"

# Colores institucionales FIE
TITLE_COLOR="FFFFFF"
RULE_COLOR="B8860B"  # Dorado FIE

# Archivo de entrada
MAIN_FILE=$(basename "$(pwd)").md
INPUT_FILE="$MAIN_FILE"
OUTPUT_FILE="${INPUT_FILE%.*}.pdf"

echo "Generando PDF con Eisvogel..."
echo "Archivo de entrada: $INPUT_FILE"
echo "Archivo de salida: $OUTPUT_FILE"

# Verificar que existe el archivo de entrada
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: No se encuentra el archivo $INPUT_FILE"
    exit 1
fi

# Generar PDF con pandoc + Eisvogel
# Toda la configuración está en el YAML front matter del markdown
pandoc "$INPUT_FILE" \
    --from markdown \
    --to pdf \
    --template="$EISVOGEL_TEMPLATE" \
    --listings \
    --pdf-engine=xelatex \
    --metadata lang=es \
    --metadata papersize=letter \
    --metadata documentclass=scrartcl \
    --metadata classoption="oneside,open=any" \
    --metadata geometry="top=2cm, bottom=2.5cm, left=2cm, right=2cm" \
    --metadata fontsize=11pt \
    --metadata linestretch=1.2 \
    --metadata colorlinks=true \
    --metadata linkcolor=NavyBlue \
    --metadata urlcolor=NavyBlue \
    --metadata citecolor=NavyBlue \
    --metadata titlepage=true \
    --metadata titlepage-color="D8D8D8" \
    --metadata titlepage-text-color="$TITLE_COLOR" \
    --metadata titlepage-rule-color="$RULE_COLOR" \
    --metadata titlepage-rule-height=0 \
    --metadata titlepage-background="$BACKGROUND_TITLE" \
    --metadata titlepage-logo="$LOGO" \
    --metadata logo-width="70mm" \
    --metadata page-background="$BACKGROUND_PAGE" \
    --metadata table-use-row-colors=true \
    --metadata tables=true \
    --metadata listings-no-page-break=true \
    --include-in-header=../../templates/custom-boxes.tex \
    --filter /home/beladen/Redes-de-Computadoras-2/venv/bin/pandoc-latex-environment \
    --output "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "PDF generado exitosamente: $OUTPUT_FILE"
    echo "Puedes abrirlo con: xdg-open $OUTPUT_FILE"
else
    echo "Error al generar el PDF"
    exit 1
fi
EOF

chmod +x "$FULL_PATH/build.sh"

# Generar archivo Markdown principal
FECHA_ACTUAL=$(date "+%B %d, %Y" | sed 's/January/Enero/g; s/February/Febrero/g; s/March/Marzo/g; s/April/Abril/g; s/May/Mayo/g; s/June/Junio/g; s/July/Julio/g; s/August/Agosto/g; s/September/Septiembre/g; s/October/Octubre/g; s/November/Noviembre/g; s/December/Diciembre/g')

# Convertir tema a título legible
TITULO_TEMA=$(echo "$TEMA" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')

cat > "$FULL_PATH/${PRACTICA_DIR}.md" << EOF
---
title: "Práctica ${PRACTICA_NUM}: ${TITULO_TEMA}"
subtitle: "${TITULO_TEMA}"
author: 
  - "Uriel Felipe Vázquez Orozco"
  - "Euler Molina Martínez"
date: "${FECHA_ACTUAL}"
subject: "Redes de Computadoras"
keywords: [${TITULO_TEMA// /, }, Cisco, Redes, Configuración]

# Información institucional
institution: "Universidad Michoacana de San Nicolás de Hidalgo"
faculty: "Facultad de Ingeniería Eléctrica"
course: "Redes de Computadoras 2"
professor: "M.C. Manuel Eduardo Sánchez Solchaga"

# Configuración de tablas y código
listings: true

# Configuración de cajas personalizadas
pandoc-latex-environment:
  info-box: [info]
  warning-box: [warning]
  error-box: [error]
  success-box: [success]
---
EOF

log_success "Estructura de práctica creada exitosamente"

echo -e "${GREEN}"
echo "=================================================="
echo "         PRÁCTICA CREADA"
echo "=================================================="
echo -e "${NC}"

echo "Directorio: $FULL_PATH"
echo "Archivo principal: ${PRACTICA_DIR}.md"
echo ""
echo "Para comenzar a trabajar:"
echo -e "${YELLOW}  cd $FULL_PATH${NC}"
echo -e "${YELLOW}  vim ${PRACTICA_DIR}.md${NC}"
echo -e "${YELLOW}  ./build.sh${NC}"
echo ""
echo -e "${GREEN}Práctica lista para comenzar${NC}"