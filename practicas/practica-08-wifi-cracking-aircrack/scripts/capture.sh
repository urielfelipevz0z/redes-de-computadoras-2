#!/bin/bash
# Script para automatizar la captura de tráfico WiFi
# Práctica 08: WiFi Cracking con Aircrack-ng

# Parámetros de captura
INTERFACE="${1:-wlp2s0mon}"
CHANNEL="${2:-6}"
BSSID="${3:-00:21:29:B3:96:6F}"
OUTPUT="${4:-captura_wpa}"

# Ejecutar captura dirigida
sudo airodump-ng -c "$CHANNEL" --bssid "$BSSID" -w "$OUTPUT" "$INTERFACE"