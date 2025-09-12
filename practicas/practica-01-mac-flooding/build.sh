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
# Toda la configuración está en el YAML front matter del markdown
pandoc "$INPUT_FILE" \
    --from markdown \
    --to pdf \
    --template="$EISVOGEL_TEMPLATE" \
    --listings \
    --pdf-engine=xelatex \
    --metadata titlepage=true \
    --metadata titlepage-color="D8D8D8" \
    --metadata titlepage-text-color="$TITLE_COLOR" \
    --metadata titlepage-rule-color="$RULE_COLOR" \
    --metadata titlepage-rule-height=0 \
    --metadata titlepage-background="$BACKGROUND_TITLE" \
    --metadata titlepage-logo="$LOGO" \
    --metadata logo-width="70mm" \
    --metadata page-background="$BACKGROUND_PAGE" \
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
