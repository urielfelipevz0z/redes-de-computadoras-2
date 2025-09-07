# Filtros de Wireshark para Análisis de MAC Flooding

## Filtros de Captura (Capture Filters)
Estos filtros se aplican durante la captura para reducir el volumen de datos capturados.

### Capturar solo tráfico específico
```
# Solo tráfico ICMP
icmp

# Solo tráfico UDP en puerto específico
udp port 1234

# Excluir tráfico del atacante
not host 192.168.1.30

# Solo tráfico entre dos hosts específicos
host 192.168.1.10 and host 192.168.1.20

# Capturar tráfico en subnet específica
net 192.168.1.0/24
```

## Filtros de Visualización (Display Filters)
Estos filtros se aplican después de la captura para análizar datos específicos.

### Filtros ICMP
```
# Todo el tráfico ICMP
icmp

# ICMP desde host específico
icmp and ip.src == 192.168.1.10

# ICMP hacia host específico
icmp and ip.dst == 192.168.1.20

# ICMP entre dos hosts específicos
icmp and ((ip.src == 192.168.1.10 and ip.dst == 192.168.1.20) or (ip.src == 192.168.1.20 and ip.dst == 192.168.1.10))

# Solo Echo Request (ping)
icmp.type == 8

# Solo Echo Reply (pong)
icmp.type == 0
```

### Filtros UDP
```
# Todo el tráfico UDP
udp

# UDP en puerto específico
udp.port == 1234

# UDP desde puerto específico
udp.srcport == 1234

# UDP hacia puerto específico
udp.dstport == 1234

# UDP con datos específicos
udp contains "mensaje"

# UDP entre hosts específicos en puerto específico
udp and ip.addr == 192.168.1.10 and ip.addr == 192.168.1.20 and udp.port == 1234
```

### Filtros por Dirección IP
```
# Tráfico desde IP específica
ip.src == 192.168.1.10

# Tráfico hacia IP específica
ip.dst == 192.168.1.20

# Tráfico desde o hacia IP específica
ip.addr == 192.168.1.10

# Excluir IP específica (útil para excluir atacante)
not ip.addr == 192.168.1.30

# Rango de IPs
ip.addr >= 192.168.1.10 and ip.addr <= 192.168.1.20

# Subnet específica
ip.src_host == 192.168.1.0/24
```

### Filtros por Dirección MAC
```
# Tráfico desde MAC específica
eth.src == 00:11:22:33:44:55

# Tráfico hacia MAC específica
eth.dst == 00:11:22:33:44:55

# Tráfico desde o hacia MAC específica
eth.addr == 00:11:22:33:44:55

# Excluir MAC específica
not eth.addr == 00:11:22:33:44:55

# Tráfico broadcast
eth.dst == ff:ff:ff:ff:ff:ff

# Tráfico multicast
eth.dst[0] & 1
```

### Filtros Combinados para Análisis de MAC Flooding
```
# Tráfico interceptado durante ataque (excluir atacante y switch)
(icmp or udp) and not ip.addr == 192.168.1.30 and not ip.addr == 192.168.1.254

# Análisis de efectividad del ataque
icmp and ip.src == 192.168.1.10 and ip.dst == 192.168.1.20

# Monitoreo de tráfico UDP específico durante ataque
udp and udp.port == 1234 and not ip.addr == 192.168.1.30

# Verificar si el tráfico está siendo interceptado
(ip.src == 192.168.1.10 or ip.src == 192.168.1.20) and not ip.addr == 192.168.1.30
```

### Filtros de Tiempo
```
# Paquetes en los últimos 60 segundos
frame.time_relative <= 60

# Paquetes en ventana de tiempo específica
frame.time >= "2025-09-03 14:30:00" and frame.time <= "2025-09-03 14:35:00"

# Paquetes con timestamp específico
frame.time_epoch >= 1693747800
```

## Filtros Avanzados para Análisis de Ataques

### Detección de Anomalías
```
# Tráfico con TTL anómalo
ip.ttl < 10 or ip.ttl > 250

# Fragmentos IP sospechosos
ip.flags.mf == 1

# Paquetes con opciones IP inusuales
ip.hdr_len > 20

# ARP gratuito (posible ARP spoofing)
arp.opcode == 2 and arp.src.hw_mac == arp.dst.hw_mac
```

### Análisis de Protocolos
```
# Todos los protocolos de capa 2
frame

# Solo Ethernet
eth

# Solo ARP
arp

# DHCP
dhcp

# DNS
dns

# HTTP
http

# HTTPS/TLS
tls

# SSH
ssh
```

### Análisis de Errores
```
# Paquetes con errores de checksum
udp.checksum_bad or tcp.checksum_bad or ip.checksum_bad

# Paquetes duplicados
tcp.analysis.duplicate_ack

# Paquetes con problemas de secuencia
tcp.analysis.out_of_order

# Retransmisiones
tcp.analysis.retransmission
```

## Expresiones Regulares en Filtros

### Búsqueda de Contenido
```
# Buscar texto específico en datos
frame contains "password"

# Buscar múltiples strings
frame contains "user" or frame contains "pass"

# Buscar patrón regex
frame matches "admin|root|administrator"

# Buscar en campo específico
http.request.uri contains "login"
```

### Análisis de Payload UDP
```
# UDP con payload específico
udp.payload contains "secreto"

# UDP con patrón específico
udp.payload matches "mensaje.*[0-9]+"

# UDP con tamaño específico
udp.length == 12

# UDP con datos hexadecimales específicos
udp.payload == 48:65:6c:6c:6f  # "Hello" en hex
```

## Configuración de Columnas Personalizadas

Para agregar columnas útiles en el análisis:

1. **Timestamp relativo:** `frame.time_relative`
2. **Dirección MAC origen:** `eth.src`
3. **Dirección MAC destino:** `eth.dst`
4. **TTL:** `ip.ttl`
5. **Tamaño de frame:** `frame.len`
6. **Flags TCP:** `tcp.flags`
7. **Puerto UDP origen:** `udp.srcport`
8. **Puerto UDP destino:** `udp.dstport`

## Scripts Avanzados de Filtrado

### tshark (línea de comandos)
```bash
# Extraer solo paquetes ICMP y guardar en archivo
tshark -r capture.pcap -Y "icmp" -w icmp_only.pcap

# Mostrar estadísticas de protocolos
tshark -r capture.pcap -qz io,phs

# Extraer datos UDP específicos
tshark -r capture.pcap -Y "udp.port == 1234" -T fields -e frame.time -e ip.src -e ip.dst -e udp.payload

# Contar paquetes por host
tshark -r capture.pcap -T fields -e ip.src | sort | uniq -c

# Análisis temporal de ataques
tshark -r capture.pcap -Y "icmp" -T fields -e frame.time_relative -e ip.src -e ip.dst
```

Estos filtros y comandos proporcionan una base sólida para el análisis detallado del tráfico capturado.
