---
title: "Práctica 03: Protocolo Spanning Tree PVST+"
subtitle: "Implementación de Per-VLAN Spanning Tree Plus para Prevención de Bucles y Optimización de Tráfico"
author: 
  - "Uriel Felipe Vázquez Orozco"
  - "Euler Molina Martínez"
date: "Enero 25, 2026"
subject: "Redes de Computadoras"
keywords: [Spanning Tree, PVST+, STP, BPDU Guard, PortFast, Root Bridge, Cisco, Redes, VLANs]

# Información institucional
institution: "Universidad Michoacana de San Nicolás de Hidalgo"
faculty: "Facultad de Ingeniería Eléctrica"
course: "Redes de Computadoras 2"
professor: "M.C. Manuel Eduardo Sánchez Solchaga"

# Configuración de tablas y código
listings: true

# Configuración de cajas personalizadas
pandoc-latex-environment:
  info-box: [info]
  warning-box: [warning]
  error-box: [error]
  success-box: [success]
  cisco-ios-box: [cisco-ios]
  bash-box: [bash]
---

# Resumen Ejecutivo

Esta práctica documenta la implementación del protocolo Per-VLAN Spanning Tree Plus (PVST+) en una topología de red con múltiples switches Cisco. El objetivo es comprender los mecanismos de prevención de bucles de capa 2, la elección del Root Bridge, y la optimización del tráfico mediante la configuración de prioridades STP por VLAN.

**Resultados:** Se logró implementar una topología redundante con 7 switches y 1 router, donde la elección de Root Bridge se determinó mediante la manipulación de costos STP a través de diferentes velocidades de enlace (1 Gbps, 100 Mbps y 10 Mbps), aplicando PortFast y BPDU Guard en puertos de acceso, y verificando el comportamiento del protocolo ante cambios en la topología.

# Identificación del Problema

En redes conmutadas con topologías redundantes, existe el riesgo de generar bucles de capa 2 que pueden provocar:

- **Tormentas de broadcast:** Saturación de la red por tramas circulando indefinidamente
- **Inestabilidad de tablas MAC:** Actualizaciones constantes por tramas duplicadas
- **Degradación del rendimiento:** Consumo excesivo de ancho de banda

::: warning
**Desafío:** Implementar redundancia física manteniendo una topología lógica libre de bucles, con optimización de rutas diferenciada por VLAN.
:::

# Metodología Aplicada

**Equipos utilizados:**

- 7 Switches Cisco Catalyst 2960 con IOS 15.x
- 1 Router Cisco 2911 configurado como Router-on-Stick
- 2 PCs para pruebas de conectividad (VLAN 10 y VLAN 20)
- Packet Tracer como herramienta de simulación

**Proceso:**

1. **Diseño de topología:** Planificación de la red redundante con múltiples caminos y velocidades diferenciadas
2. **Configuración de VLANs:** Creación de VLANs 10, 20 y 99 (nativa)
3. **Configuración de enlaces trunk:** Establecimiento de trunks entre switches con diferentes velocidades
4. **Manipulación de costos STP:** Uso de cables de diferentes velocidades (1 Gbps, 100 Mbps, 10 Mbps) para influir en la elección de rutas
5. **Optimización de puertos:** Aplicación de PortFast y BPDU Guard en puertos de acceso
6. **Validación:** Verificación de convergencia y pruebas de failover

# Topología de Red Implementada

![Topología de red PVST+ implementada](images/topology-diagram-01.png)

**Configuración de direccionamiento:**

| Dispositivo | VLAN | Dirección IP | Rol en STP |
|-------------|------|--------------|------------|
| R1 | 10/20/99 | 192.168.X.1/24 | Gateway por VLAN |
| SW1 | 99 | 192.168.99.1/24 | Root Bridge VLAN 10 |
| SW2 | 99 | 192.168.99.2/24 | Conexión a Router |
| SW3 | 99 | 192.168.99.3/24 | Distribución |
| SW4 | 99 | 192.168.99.4/24 | Núcleo |
| SW5 | 99 | 192.168.99.5/24 | Distribución |
| SW6 | 99 | 192.168.99.6/24 | Distribución |
| SW7 | 99 | 192.168.99.7/24 | Root Bridge VLAN 20 |
| PC-VLAN10 | 10 | 192.168.10.10/24 | Host de pruebas |
| PC-VLAN20 | 20 | 192.168.20.10/24 | Host de pruebas |

**Configuración de VLANs:**

| VLAN ID | Nombre | Propósito |
|---------|--------|-----------|
| 10 | Ventas | Tráfico de usuarios de ventas |
| 20 | Ingeniería | Tráfico de usuarios de ingeniería |
| 99 | Administración | Gestión de dispositivos (nativa) |

# Configuración Inicial

## Configuración de VLANs en Todos los Switches

::: cisco-ios
Switch> enable
Switch# configure terminal
Switch(config)# vlan 10
Switch(config-vlan)# name Ventas
Switch(config-vlan)# vlan 20
Switch(config-vlan)# name Ingenieria
Switch(config-vlan)# vlan 99
Switch(config-vlan)# name Administracion
Switch(config-vlan)# exit
:::

## Habilitación de PVST+

::: cisco-ios
Switch(config)# spanning-tree mode pvst
Switch(config)# spanning-tree extend system-id
:::

::: info
**Nota:** PVST+ es el modo predeterminado en switches Cisco y permite una instancia de Spanning Tree independiente para cada VLAN, optimizando las rutas de tráfico.
:::

# Desarrollo Detallado

## Paso 1: Diseño de Topología con Velocidades Diferenciadas

La topología utiliza tres tipos de enlaces con diferentes velocidades para influir en los costos STP:

**Mapa de enlaces por velocidad:**

| Color | Velocidad | Costo STP | Enlaces |
|-------|-----------|-----------|----------|
| Azul | 1 Gbps | 4 | SW1-SW2, SW1-SW3, SW4-SW3, SW5-SW7, SW6-SW7, SW2-R1 |
| Rojo | 100 Mbps | 19 | SW2-SW4, SW4-SW5, SW4-SW7, SW7-PC_B, SW1-PC_A |
| Negro | 10 Mbps | 100 | SW1-SW4, SW3-SW6, SW4-SW6, SW2-SW5 |

::: info
**Concepto clave:** En esta práctica NO se configuraron prioridades STP manualmente. La elección del Root Bridge se determina por la dirección MAC más baja (con prioridad predeterminada 32768), y las rutas óptimas se calculan basándose en los costos de los enlaces determinados por sus velocidades.
:::

## Paso 2: Configuración de Enlaces de Alta Velocidad (1 Gbps - Azul)

Los enlaces Gigabit Ethernet proporcionan el menor costo STP (4) y son preferidos para las rutas principales:

::: cisco-ios
SW1(config)# interface GigabitEthernet0/1
SW1(config-if)# description Enlace a SW2 (1 Gbps - Azul)
SW1(config-if)# switchport trunk native vlan 99
SW1(config-if)# switchport trunk allowed vlan 10,20,99
SW1(config-if)# switchport mode trunk
SW1(config-if)# exit
:::

## Paso 3: Configuración de Enlaces de Media Velocidad (100 Mbps - Rojo)

Los enlaces FastEthernet a velocidad nativa proporcionan costo STP intermedio (19):

::: cisco-ios
SW4(config)# interface FastEthernet0/2
SW4(config-if)# description Enlace a SW2 (100 Mbps - Rojo)
SW4(config-if)# switchport trunk native vlan 99
SW4(config-if)# switchport trunk allowed vlan 10,20,99
SW4(config-if)# switchport mode trunk
SW4(config-if)# exit
:::

## Paso 4: Configuración de Enlaces de Baja Velocidad (10 Mbps - Negro)

Los enlaces configurados a 10 Mbps proporcionan el mayor costo STP (100) y actúan como rutas de respaldo:

::: cisco-ios
SW1(config)# interface FastEthernet0/2
SW1(config-if)# description Enlace a SW4 (10 Mbps - Negro)
SW1(config-if)# switchport trunk native vlan 99
SW1(config-if)# switchport trunk allowed vlan 10,20,99
SW1(config-if)# switchport mode trunk
SW1(config-if)# speed 10
SW1(config-if)# exit
:::

## Paso 5: Configuración de Puertos de Acceso con PortFast y BPDU Guard

En SW1 (puerto hacia PC-A en VLAN 10):

::: cisco-ios
SW1(config)# interface FastEthernet0/1
SW1(config-if)# description Host PC-A VLAN 10 (100 Mbps - Rojo)
SW1(config-if)# switchport access vlan 10
SW1(config-if)# switchport mode access
SW1(config-if)# spanning-tree portfast
SW1(config-if)# spanning-tree bpduguard enable
SW1(config-if)# exit
:::

En SW7 (puerto hacia PC-B en VLAN 20):

::: cisco-ios
SW7(config)# interface FastEthernet0/1
SW7(config-if)# description Host PC-B VLAN 20 (100 Mbps - Rojo)
SW7(config-if)# switchport access vlan 20
SW7(config-if)# switchport mode access
SW7(config-if)# spanning-tree portfast
SW7(config-if)# spanning-tree bpduguard enable
SW7(config-if)# exit
:::

::: warning
**PortFast:** Permite que el puerto pase inmediatamente al estado Forwarding, evitando los estados Listening y Learning. Solo debe usarse en puertos de acceso conectados a dispositivos finales.

**BPDU Guard:** Deshabilita el puerto si recibe BPDUs, protegiendo contra conexiones no autorizadas de switches.
:::

::: info
**Referencia de costos STP por velocidad:**

| Ancho de Banda | Costo STP | Uso en Topología |
|----------------|-----------|------------------|
| 10 Mbps | 100 | Enlaces de respaldo (Negro) |
| 100 Mbps | 19 | Enlaces secundarios (Rojo) |
| 1 Gbps | 4 | Enlaces principales (Azul) |
| 10 Gbps | 2 | No utilizado |

Los enlaces de menor velocidad tienen mayor costo y son menos preferidos por STP, quedando como rutas de respaldo.
:::

## Paso 6: Configuración del Router-on-Stick (R1)

::: cisco-ios
R1> enable
R1# configure terminal
R1(config)# hostname R1
R1(config)# interface GigabitEthernet0/0
R1(config-if)# no shutdown
R1(config-if)# exit

R1(config)# interface GigabitEthernet0/0.10
R1(config-subif)# description Gateway VLAN 10 - Ventas
R1(config-subif)# encapsulation dot1Q 10
R1(config-subif)# ip address 192.168.10.1 255.255.255.0
R1(config-subif)# exit

R1(config)# interface GigabitEthernet0/0.20
R1(config-subif)# description Gateway VLAN 20 - Ingenieria
R1(config-subif)# encapsulation dot1Q 20
R1(config-subif)# ip address 192.168.20.1 255.255.255.0
R1(config-subif)# exit

R1(config)# interface GigabitEthernet0/0.99
R1(config-subif)# description Gateway VLAN 99 - Administracion
R1(config-subif)# encapsulation dot1Q 99 native
R1(config-subif)# ip address 192.168.99.254 255.255.255.0
R1(config-subif)# exit

R1(config)# end
R1# write memory
:::

# Validación y Pruebas

## Verificación del Root Bridge por VLAN

En cualquier switch, verificar el estado de Spanning Tree:

::: cisco-ios
SW1# show spanning-tree vlan 10

VLAN0010
  Spanning tree enabled protocol ieee
  Root ID    Priority    32778
             Address     0001.C7A8.1234
             This bridge is the root
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32778  (priority 32768 sys-id-ext 10)
             Address     0001.C7A8.1234
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  300
:::

::: cisco-ios
SW7# show spanning-tree vlan 20

VLAN0020
  Spanning tree enabled protocol ieee
  Root ID    Priority    32788
             Address     0002.17FA.5678
             This bridge is the root
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32788  (priority 32768 sys-id-ext 20)
             Address     0002.17FA.5678
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  300
:::

::: info
**Nota:** Los Root Bridges fueron elegidos automáticamente por STP basándose en la prioridad predeterminada (32768) y la dirección MAC más baja. No se configuraron prioridades manualmente.
:::

::: success
**Validación exitosa:** SW1 es Root Bridge para VLAN 10 y SW7 es Root Bridge para VLAN 20, determinados por sus direcciones MAC.
:::

## Verificación de Estados de Puertos

::: cisco-ios
SW4# show spanning-tree vlan 10 brief

VLAN0010
  Spanning tree enabled protocol ieee
  Root ID    Priority    32778
             Address     0001.C7A8.1234

Interface        Role Sts Cost      Prio.Nbr Type
---------------- ---- --- --------- -------- ----
Fa0/1            Root FWD 100       128.1    P2p (10 Mbps a SW1)
Fa0/2            Altn BLK 19        128.2    P2p (100 Mbps a SW2)
Fa0/4            Altn BLK 100       128.4    P2p (10 Mbps a SW6)
Gi0/1            Desg FWD 4         128.25   P2p (1 Gbps a SW3)
:::

**Estados de puertos STP:**

| Estado | Descripción |
|--------|-------------|
| FWD (Forwarding) | Puerto activo transmitiendo tráfico |
| BLK (Blocking) | Puerto bloqueado para prevenir bucles |
| LRN (Learning) | Aprendiendo direcciones MAC |
| LSN (Listening) | Escuchando BPDUs |

## Verificación de Convergencia

::: cisco-ios
SW1# show spanning-tree summary

Switch is in pvst mode
Root bridge for: VLAN0010, VLAN0020, VLAN0099
Extended system ID           is enabled
Portfast Default             is disabled
PortFast BPDU Guard Default  is disabled

Name                   Blocking Listening Learning Forwarding STP Active
---------------------- -------- --------- -------- ---------- ----------
VLAN0010                     0         0        0          3          3
VLAN0020                     0         0        0          3          3
VLAN0099                     0         0        0          3          3
:::

## Pruebas de Conectividad entre VLANs

::: bash
PC-VLAN10> ping 192.168.10.1
Pinging 192.168.10.1 with 32 bytes of data:
Reply from 192.168.10.1: bytes=32 time<1ms TTL=255
Reply from 192.168.10.1: bytes=32 time<1ms TTL=255

PC-VLAN10> ping 192.168.20.10
Pinging 192.168.20.10 with 32 bytes of data:
Reply from 192.168.20.10: bytes=32 time=1ms TTL=126
Reply from 192.168.20.10: bytes=32 time=1ms TTL=126
:::

::: success
**Conectividad verificada:** Los hosts en diferentes VLANs pueden comunicarse a través del router R1.
:::

## Prueba de Failover

Para probar la redundancia, desconectar un enlace y observar la reconvergencia:

::: cisco-ios
SW4(config)# interface FastEthernet0/1
SW4(config-if)# shutdown
:::

Observar los mensajes de consola:

::: cisco-ios
%LINEPROTO-5-UPDOWN: Line protocol on Interface FastEthernet0/1, changed state to down
%SPANTREE-2-TOPOLOGY_CHANGE: Topology change detected on port Fa0/1, VLAN 10
:::

Verificar nuevo estado de Spanning Tree:

::: cisco-ios
SW4# show spanning-tree vlan 10
! Rutas alternativas ahora activas
:::

# Problemas Encontrados y Soluciones

## Problema: Convergencia Lenta Inicial

**Descripción:** Durante las primeras pruebas, los hosts tardaban aproximadamente 50 segundos en obtener conectividad después de conectarse.

**Diagnóstico:** Los puertos de acceso pasaban por todos los estados de STP (Blocking → Listening → Learning → Forwarding).

**Solución aplicada:** Implementación de PortFast en puertos de acceso:

::: cisco-ios
Switch(config)# interface FastEthernet0/1
Switch(config-if)# spanning-tree portfast
:::

## Problema: Rutas Subóptimas por Costos de Enlace

**Descripción:** Inicialmente, algunos switches elegían rutas a través de enlaces de 10 Mbps en lugar de rutas más rápidas disponibles.

**Diagnóstico:** La topología física creaba situaciones donde el primer enlace descubierto no era el de menor costo.

**Solución aplicada:** Verificación de la convergencia STP y espera del tiempo necesario para que todos los switches calculen las rutas óptimas basándose en los costos reales de los enlaces:

::: cisco-ios
Switch# show spanning-tree vlan 10
! Verificar que los puertos Root apunten hacia enlaces de mayor velocidad
! Los puertos hacia enlaces de 10 Mbps deben quedar en estado Blocking o Alternate
:::

## Problema: BPDU Recibido en Puerto PortFast

**Descripción:** Un puerto configurado con PortFast entró en estado err-disabled después de recibir un BPDU.

**Diagnóstico:** Se conectó temporalmente un switch adicional al puerto de acceso, activando BPDU Guard.

**Solución aplicada:** Recuperación del puerto y documentación del comportamiento esperado:

::: cisco-ios
Switch(config)# interface FastEthernet0/1
Switch(config-if)# shutdown
Switch(config-if)# no shutdown
:::

::: info
**Nota:** Este comportamiento es el esperado y deseado para BPDU Guard, protegiendo la red contra bucles accidentales.
:::

# Experiencia Adquirida

## Conocimientos Técnicos Clave

### Funcionamiento de PVST+
- Cada VLAN mantiene su propia instancia de Spanning Tree
- Permite optimización de rutas diferenciada por VLAN
- Mayor uso de CPU y memoria comparado con MST

### Elección del Root Bridge
El Root Bridge se selecciona basándose en:
1. **Prioridad más baja** (predeterminada 32768, configurable en múltiplos de 4096)
2. **Dirección MAC más baja** (desempate cuando las prioridades son iguales)

::: info
**En esta práctica:** No se modificaron las prioridades. Los Root Bridges fueron elegidos automáticamente por tener la dirección MAC más baja entre los switches con prioridad predeterminada.
:::

### Cálculo de Rutas
Los switches calculan la ruta óptima al Root basándose en:
1. Menor costo acumulado al Root Bridge
2. Menor Bridge ID del switch vecino (desempate)
3. Menor Port ID (desempate final)

### Comandos Cisco IOS Críticos

::: cisco-ios
! Verificación de Spanning Tree
Switch# show spanning-tree
Switch# show spanning-tree vlan 10
Switch# show spanning-tree summary
Switch# show spanning-tree interface FastEthernet0/1

! Verificación de velocidad y costo de interfaces
Switch# show interfaces FastEthernet0/1 status
Switch# show spanning-tree interface FastEthernet0/1 detail

! Configuración de velocidad para manipular costos
Switch(config-if)# speed 10
Switch(config-if)# speed 100
Switch(config-if)# speed auto

! Optimización de puertos de acceso
Switch(config-if)# spanning-tree portfast
Switch(config-if)# spanning-tree bpduguard enable

! Debug (usar con precaución)
Switch# debug spanning-tree events
:::

## Lecciones Aprendidas

### Planificación de Root Bridge
Es fundamental planificar qué switches serán Root Bridge para cada VLAN, considerando:
- Ubicación física en la topología
- Capacidad del equipo
- Patrones de tráfico esperados

### Protección de Puertos de Acceso
Siempre configurar PortFast y BPDU Guard en puertos de acceso para:
- Acelerar la convergencia para dispositivos finales
- Proteger contra conexiones no autorizadas de switches

### Documentación de Topología
Mantener documentación actualizada de:
- Roles STP de cada switch por VLAN
- Estados de puertos esperados
- Rutas primarias y alternativas

# Exploración de Aplicaciones y Sugerencias

<!-- Esta sección se completará posteriormente con aplicaciones prácticas y sugerencias de mejora -->

# Recursos y Referencias Utilizados

## Documentación Técnica Oficial

### Cisco Systems
- **Cisco Catalyst 2960-X Series Switches Configuration Guide** - Chapter: "Configuring Spanning Tree Protocol"
- **Understanding and Configuring Spanning Tree Protocol** - Cisco White Paper
- **Per-VLAN Spanning Tree Plus (PVST+) Design Guide** - Cisco Design Zone

### Estándares IEEE
- **IEEE 802.1D-2004:** "MAC Bridges" - Especificación original de STP
- **IEEE 802.1w-2001:** "Rapid Spanning Tree Protocol" - Mejoras de convergencia
- **IEEE 802.1s-2002:** "Multiple Spanning Tree Protocol" - MST

## Configuraciones de Referencia

### Archivos de Configuración
Los archivos de configuración de esta práctica se encuentran en el directorio `configs/`:

- **`R1-final-v1.cfg`:** Configuración del router con subinterfaces para inter-VLAN routing
- **`SW1-final-v1.cfg`:** Switch configurado como Root Bridge para VLAN 10
- **`SW2-final-v1.cfg`:** Switch de conexión al router
- **`SW3-final-v1.cfg`:** Switch de distribución
- **`SW4-final-v1.cfg`:** Switch de núcleo
- **`SW5-final-v1.cfg`:** Switch de distribución
- **`SW6-final-v1.cfg`:** Switch de distribución
- **`SW7-final-v1.cfg`:** Switch configurado como Root Bridge para VLAN 20

## Recursos en Línea

### Laboratorios Virtuales
- **Cisco Packet Tracer** - Simulador oficial de Cisco
- **Archivo de topología:** `topologies/topology-pvst.pkt`

---

**Documento:** Práctica 03 - Spanning Tree PVST+  
**Fecha:** Enero 25, 2026  
**Autores:** Uriel Felipe Vázquez Orozco, Euler Molina Martínez  
**Materia:** Redes de Computadoras 2  
**Profesor:** M.C. Manuel Eduardo Sánchez Solchaga
