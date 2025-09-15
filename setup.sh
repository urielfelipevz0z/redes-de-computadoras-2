#!/bin/bash

# Script de configuración automática para el repositorio Redes de Computadoras 2
# Autor: Uriel Felipe Vázquez Orozco y Euler Molina Martínez
# Descripción: Configura el entorno de desarrollo con venv y dependencias

set -e  # Salir si cualquier comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para logging con colores
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[ÉXITO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Banner
echo -e "${BLUE}"
echo "=================================================="
echo "    SETUP - REDES DE COMPUTADORAS 2"
echo "=================================================="
echo -e "${NC}"

# Verificar que estamos en el directorio correcto
if [[ ! -f "README.md" ]] || [[ ! -d "Eisvogel-3.2.0" ]]; then
    log_error "No estás en el directorio raíz del proyecto Redes-de-Computadoras-2"
    exit 1
fi

log_info "Verificando directorio del proyecto... ✓"

# Verificar Python 3
if ! command -v python3 &> /dev/null; then
    log_error "Python 3 no está instalado"
    exit 1
fi

log_info "Python 3 detectado: $(python3 --version)"

# Verificar Pandoc
if ! command -v pandoc &> /dev/null; then
    log_warning "Pandoc no está instalado. Se recomienda instalarlo para compilar reportes."
    echo "   Ubuntu/Debian: sudo apt install pandoc"
else
    log_info "Pandoc detectado: $(pandoc --version | head -n1)"
fi

# Crear entorno virtual si no existe
if [[ ! -d "venv" ]]; then
    log_info "Creando entorno virtual Python..."
    python3 -m venv venv
    log_success "Entorno virtual creado"
else
    log_info "Entorno virtual ya existe"
fi

# Activar entorno virtual
log_info "Activando entorno virtual..."
source venv/bin/activate

# Actualizar pip
log_info "Actualizando pip..."
pip install --upgrade pip

# Instalar dependencias
if [[ -f "requirements.txt" ]]; then
    log_info "Instalando dependencias de Python..."
    pip install -r requirements.txt
    log_success "Dependencias instaladas"
else
    log_warning "No se encontró requirements.txt"
fi

# Crear directorio scripts si no existe
if [[ ! -d "scripts" ]]; then
    log_info "Creando directorio scripts..."
    mkdir -p scripts
fi

# Hacer ejecutables los scripts
log_info "Configurando permisos de scripts..."
chmod +x scripts/build-all.sh 2>/dev/null || true
chmod +x scripts/new-practice.sh 2>/dev/null || true

# Verificar estructura de directorios críticos
log_info "Verificando estructura de directorios..."
for dir in "practicas" "templates" "Eisvogel-3.2.0"; do
    if [[ -d "$dir" ]]; then
        log_info "✓ $dir"
    else
        log_warning "✗ $dir (no encontrado)"
    fi
done

# Instrucciones finales
echo -e "${GREEN}"
echo "=================================================="
echo "         CONFIGURACIÓN COMPLETADA"
echo "=================================================="
echo -e "${NC}"

echo "Para activar el entorno virtual en futuras sesiones:"
echo -e "${YELLOW}  source venv/bin/activate${NC}"
echo ""
echo "Scripts disponibles (próximamente):"
echo "  ./scripts/new-practice.sh    - Crear nueva práctica"
echo "  ./scripts/build-all.sh       - Compilar todos los reportes"
echo ""
echo -e "${GREEN}Entorno listo para trabajar${NC}"