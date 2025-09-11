EISVOGEL_TEMPLATE = ../../Eisvogel-3.2.0/eisvogel.latex
CUSTOM_TEMPLATE = templates/custom-boxes.tex
TITLE_PAGE_LOGO = FIE-Logo-Oro.png
VENV_FILTER = .venv/bin/pandoc-latex-environment
CURDIR := $(shell pwd)

EISVOGEL_TEMPLATE = $(CURDIR)/Eisvogel-3.2.0/eisvogel.latex
CUSTOM_TEMPLATE = $(CURDIR)/templates/custom-boxes.tex
TITLE_PAGE_LOGO = $(CURDIR)/FIE-Logo-Oro.png
VENV_FILTER = .venv/bin/pandoc-latex-environment

# Derived/consistency variables
FILTER_PATH ?= $(CURDIR)/$(VENV_FILTER)
TITLE_COLOR ?= FFFFFF
RULE_COLOR ?= B8860B
BACKGROUND_TITLE ?= $(CURDIR)/Eisvogel-3.2.0/examples/title-page-custom/background.pdf
BACKGROUND_PAGE ?= $(CURDIR)/Eisvogel-3.2.0/examples/title-page-background/backgrounds/background5.pdf
PRACTICAS_DIR = practicas

.PHONY: all
all: practica-01
	@echo "Todas las prácticas han sido generadas exitosamente"

.PHONY: practica-01


practica-01:
	@echo "Construyendo práctica 01: MAC Flooding"
	# create a per-practice header file from template and substitute practice-specific values
	mkdir -p "$(CURDIR)/$(PRACTICAS_DIR)/practica-01-mac-flooding"; \
	sed \
		-e "s|{{HEADER_CENTER}}|Redes de Computadoras 2|g" \
		-e "s|{{FOOTER_CENTER}}|UMSNH - Facultad de Ingeniería Eléctrica|g" \
		-e "s|{{BACKGROUND_PAGE}}|$(BACKGROUND_PAGE)|g" \
		$(CURDIR)/templates/header-template.tex > $(CURDIR)/$(PRACTICAS_DIR)/practica-01-mac-flooding/header-extra.tex; \
	cd $(PRACTICAS_DIR)/practica-01-mac-flooding && \
	pandoc "$(CURDIR)/$(PRACTICAS_DIR)/practica-01-mac-flooding/practica-01-mac-flooding.md" \
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
		--metadata titlepage-logo="$(TITLE_PAGE_LOGO)" \
		--metadata logo-width=35mm \
		--metadata page-background="$(BACKGROUND_PAGE)" \
		--metadata table-use-row-colors=true \
		--metadata tables=true \
		--metadata listings-no-page-break=true \
		--metadata code-block-font-size="\\footnotesize" \
		--metadata toc=true \
		--metadata toc-depth=3 \
		--metadata lof=true \
		--metadata lot=true \
		--include-in-header="$(CUSTOM_TEMPLATE)" \
		--include-in-header="$(CURDIR)/$(PRACTICAS_DIR)/practica-01-mac-flooding/header-extra.tex" \
		--filter "$(FILTER_PATH)" \
		--output "$(CURDIR)/$(PRACTICAS_DIR)/practica-01-mac-flooding/practica-01-mac-flooding.pdf"
	@echo "PDF generado: $(PRACTICAS_DIR)/practica-01-mac-flooding/practica-01-mac-flooding.pdf"

.PHONY: clean
clean:
	@echo "Limpiando archivos PDF generados..."
	@find $(PRACTICAS_DIR) -name "*.pdf" -type f -delete
	@echo "Archivos PDF eliminados"

.PHONY: clean-temp
clean-temp:
	@echo "Limpiando archivos temporales de LaTeX..."
	@find $(PRACTICAS_DIR) -name "*.aux" -o -name "*.log" -o -name "*.toc" -o -name "*.out" -o -name "*.fdb_latexmk" -o -name "*.fls" -o -name "*.synctex.gz" | xargs rm -f
	@echo "Archivos temporales eliminados"

.PHONY: install-deps
install-deps:
	@echo "Instalando dependencias..."
	@sudo apt update
	@sudo apt install -y pandoc texlive-xetex texlive-fonts-recommended texlive-fonts-extra
	@pip3 install pandoc-latex-environment
	@echo "Dependencias instaladas"

.PHONY: check-deps
check-deps:
	@echo "Verificando dependencias..."
	@which pandoc > /dev/null || (echo "pandoc no está instalado" && exit 1)
	@which xelatex > /dev/null || (echo "xelatex no está instalado" && exit 1)
	@test -f "$(VENV_FILTER)" || (echo "pandoc-latex-environment no está instalado" && exit 1)
	@test -f "$(EISVOGEL_TEMPLATE)" || (echo "Template Eisvogel no encontrado" && exit 1)
	@echo "Todas las dependencias están disponibles"

.PHONY: help
help:
	@echo "Makefile para Redes de Computadoras 2"
	@echo ""
	@echo "Targets disponibles:"
	@echo "  all               - Construir todas las prácticas"
	@echo "  practica-01       - Construir solo la práctica 01"
	@echo "  clean             - Eliminar todos los PDFs generados"
	@echo "  clean-temp        - Eliminar archivos temporales de LaTeX"
	@echo "  install-deps      - Instalar dependencias del sistema"
	@echo "  check-deps        - Verificar que las dependencias estén instaladas"
	@echo "  help              - Mostrar esta ayuda"
	@echo ""
