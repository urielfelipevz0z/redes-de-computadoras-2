#!/bin/bash

# Script para generar PDF de prácticas usando Eisvogel
# Uso: ./build.sh [archivo.md]

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
INPUT_FILE="${1:-practica-01-mac-flooding.md}"
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
    --metadata logo-width=35mm \
    --metadata page-background="$BACKGROUND_PAGE" \
    --metadata header-left="\\hspace{1cm}" \
    --metadata header-center="Redes de Computadoras 2" \
    --metadata header-right="Página \\thepage" \
    --metadata footer-left="\\thetitle" \
    --metadata footer-center="UMSNH - Facultad de Ingeniería Eléctrica" \
    --metadata footer-right="\\thedate" \
    --metadata table-use-row-colors=true \
    --metadata tables=true \
    --metadata listings-no-page-break=true \
    --metadata code-block-font-size="\\footnotesize" \
    --metadata toc=true \
    --metadata toc-depth=3 \
    --metadata lof=true \
    --metadata lot=true \
    --include-in-header=../../templates/custom-boxes.tex \
    --filter /home/beladen/Redes-de-Computadoras-2/.venv/bin/pandoc-latex-environment \
    --output "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "PDF generado exitosamente: $OUTPUT_FILE"
    echo "Puedes abrirlo con: xdg-open $OUTPUT_FILE"
else
    echo "Error al generar el PDF"
    exit 1
fi
