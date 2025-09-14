# Scripts de Automatización - Redes de Computadoras 2

Este repositorio incluye varios scripts de automatización para simplificar el flujo de trabajo de documentación y desarrollo.

## Configuración inicial

### 1. Setup del entorno

```bash
# Ejecutar una sola vez para configurar el entorno
./setup.sh
```

Este script:
- Crea el entorno virtual Python
- Instala dependencias del `requirements.txt`
- Verifica que Pandoc esté disponible
- Configura permisos de scripts
- Valida estructura del proyecto

### 2. Activar entorno virtual

```bash
# Para futuras sesiones de trabajo
source venv/bin/activate
```

## Scripts disponibles

### Crear nueva práctica

```bash
./scripts/new-practice.sh <número> <tema>
```

### Compilar todas las prácticas

```bash
./scripts/build-all.sh [opciones]
```

**Opciones:**
- `--clean` - Limpiar PDFs antes de compilar
- `--verbose` - Mostrar output detallado
- `--force` - Continuar aunque haya errores
- `--help` - Mostrar ayuda

### Error: "Pandoc no encontrado"
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install pandoc texlive-xetex
```

### Error: "Python3 no encontrado"
```bash
# Ubuntu/Debian
sudo apt install python3 python3-venv python3-pip
```

### Error de permisos en scripts
```bash
chmod +x setup.sh
```

### Rehacer configuración completa
```bash
rm -rf venv/
./setup.sh
```