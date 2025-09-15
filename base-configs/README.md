# Base Configurations para CCNA 1 - Redes de Computadoras 2

Este directorio contiene las configuraciones base y templates para los equipos del laboratorio de Redes de Computadoras

## Configuraciones Base

### Switches
- **SW2960-base-config-v1.cfg**: Configuración base para Cisco Catalyst 2960
  - Configuración de seguridad básica
  - Configuración de puertos por defecto
  - Configuración de administración
  - Templates para VLANs y puertos trunk/access

- **SW2950-base-config-v1.cfg**: Configuración base para Cisco Catalyst 2950
  - Configuración de seguridad básica
  - Configuración de puertos FastEthernet únicamente
  - Configuración de administración
  - Templates para VLANs básicas

### Routers
- **R1841-base-config-v1.cfg**: Configuración base para Cisco ISR 1841
  - Configuración de interfaces FastEthernet y Serial
  - Configuración de seguridad básica
  - Templates para configuración de interfaces

- **R2911-base-config-v1.cfg**: Configuración base para Cisco ISR 2911
  - Configuración de interfaces GigabitEthernet y Serial
  - Configuración de seguridad básica
  - Templates para sub-interfaces y VLANs

## Estándares de Nomenclatura

### Dispositivos:
- **Switches**: SW[Modelo]-[Site/Número] (ej: SW2960-01, SW2960-Core)
- **Routers**: R[Modelo]-[Site/Número] (ej: R1841-01, R2911-Branch)

### Interfaces:
- **LAN**: Descripción del segmento conectado
- **WAN**: Descripción del enlace remoto
- **Trunk**: Descripción del dispositivo conectado

### VLANs Sugeridas:
- VLAN 1: Default (no usar para tráfico de usuarios)
- VLAN 10-50: VLANs de usuarios (por departamento/función)
- VLAN 99: Administración de switches
- VLAN 999: VLAN "parking" para puertos no utilizados

## Estructura de archivos estandarizada para prácticas

```
/practicas/practica-XX-[tema]/
├── configs/
│   ├── [device]-initial-v1.cfg
│   ├── [device]-final-v1.cfg
│   └── [device]-backup-v1.cfg
├── images/
├── scripts/
└── topologies/
```

Esta estructura facilita el seguimiento de cambios y la documentación de cada práctica.