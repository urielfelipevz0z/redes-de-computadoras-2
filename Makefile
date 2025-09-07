EISVOGEL_TEMPLATE = Eisvogel-3.2.0/eisvogel.latex
CUSTOM_TEMPLATE = templates/custom-boxes.tex
TITLE_PAGE_LOGO = FIE-Logo-Oro.png
VENV_FILTER = .venv/bin/pandoc-latex-environment

PRACTICAS_DIR = practicas

.PHONY: all
all: practica-01
	@echo "Todas las prácticas han sido generadas exitosamente"

.PHONY: practica-01
practica-01:
	@echo "Construyendo práctica 01: MAC Flooding"
	@cd $(PRACTICAS_DIR)/practica-01-mac-flooding && \
	pandoc "practica-01-mac-flooding.md" \
		--from markdown \
		--to pdf \
		--template="../../$(EISVOGEL_TEMPLATE)" \
		--listings \
		--pdf-engine=xelatex \
		--include-in-header="../../$(CUSTOM_TEMPLATE)" \
		--filter "../../.venv/bin/pandoc-latex-environment" \
		--output "practica-01-mac-flooding.pdf"
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
