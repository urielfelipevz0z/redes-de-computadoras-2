# Makefile para generar PDFs de prácticas con Eisvogel

# Variables
EISVOGEL_TEMPLATE = ../../Eisvogel-3.2.0/eisvogel.latex
BACKGROUND_PAGE = ../../Eisvogel-3.2.0/examples/title-page-background/backgrounds/background5.pdf
BACKGROUND_TITLE = ../../Eisvogel-3.2.0/examples/title-page-custom/background.pdf
LOGO = ../../FIE-Logo-Oro.png
FILTER_PATH = ../../.venv/bin/pandoc-latex-environment

# Colores institucionales FIE
TITLE_COLOR = FFFFFF
RULE_COLOR = B8860B

# Archivos fuente
MD_FILES = $(wildcard *.md)
PDF_FILES = $(MD_FILES:.md=.pdf)

# Regla por defecto
all: $(PDF_FILES)

# Regla para generar PDF desde MD
%.pdf: %.md
	@echo "Generando PDF: $@"
	pandoc "$<" \
		--from markdown \
		--to pdf \
		--template="$(EISVOGEL_TEMPLATE)" \
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
		--metadata titlepage-text-color="$(TITLE_COLOR)" \
		--metadata titlepage-rule-color="$(RULE_COLOR)" \
		--metadata titlepage-rule-height=0 \
		--metadata titlepage-background="$(BACKGROUND_TITLE)" \
		--metadata titlepage-logo="$(LOGO)" \
		--metadata logo-width=35mm \
		--metadata page-background="$(BACKGROUND_PAGE)" \
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
		--filter "$(FILTER_PATH)" \
		--output "$@"
	@echo "PDF generado exitosamente: $@"

# Limpiar archivos generados
clean:
	rm -f *.pdf

# Regla para generar solo una práctica específica
practica-01: practica-01-mac-flooding.pdf

# Ayuda
help:
	@echo "Uso del Makefile:"
	@echo "  make                    - Genera todos los PDFs"
	@echo "  make <archivo>.pdf      - Genera un PDF específico"
	@echo "  make practica-01        - Genera PDF de práctica 01"
	@echo "  make clean              - Elimina archivos PDF generados"
	@echo "  make help               - Muestra esta ayuda"

.PHONY: all clean help practica-01
