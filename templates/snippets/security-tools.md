# Comandos específicos para análisis de seguridad en redes

## Herramientas de auditoría de seguridad

### dsniff suite
```bash
# Instalación en sistemas Debian/Ubuntu
sudo apt update
sudo apt install dsniff -y

# Verificación de instalación
which macof
dpkg -l | grep dsniff
```

### macof - MAC flooding
```bash
# Ataque básico MAC flooding
sudo macof -i [interface] -s random -d random

# Ataque con parámetros específicos
sudo macof -i eth0 -s random -d random -n 1000
```

### Wireshark/tshark
```bash
# Captura con tshark
sudo tshark -i [interface] -f "[filter]" -c [count]

# Filtros comunes
tshark -i eth0 -f "icmp" -c 20
tshark -i eth0 -f "udp and port 1234"
```

## Filtros de Wireshark para análisis

### Filtros de protocolo
- `icmp` - Tráfico ICMP
- `udp` - Tráfico UDP  
- `tcp` - Tráfico TCP
- `arp` - Tráfico ARP

### Filtros de dirección IP
- `ip.src == 192.168.1.10` - Origen específico
- `ip.dst == 192.168.1.20` - Destino específico
- `not host 192.168.1.30` - Excluir host específico

### Filtros combinados
- `icmp and (ip.src == 192.168.1.10 or ip.dst == 192.168.1.20)`
- `not host 192.168.1.30 and (icmp or udp)`
