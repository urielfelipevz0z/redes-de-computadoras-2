# Snippets reutilizables para reportes de redes
# Incluir con {{< include snippets/[archivo].md >}}

## Configuración IP estándar
| Dispositivo | Interface | Dirección IP | Máscara | Gateway |
|-------------|-----------|--------------|---------|---------|
| PC A | eth0 | 192.168.1.10 | /24 | 192.168.1.1 |
| PC B | eth0 | 192.168.1.20 | /24 | 192.168.1.1 |
| PC C | eth0 | 192.168.1.30 | /24 | 192.168.1.1 |
| Switch | VLAN1 | 192.168.1.254 | /24 | - |

## Comandos básicos de verificación Cisco

### Verificación de estado de interfaces
```{.cisco-ios}
Switch# show interfaces status
Switch# show interfaces [interface] switchport
Switch# show ip interface brief
```

### Verificación de tabla MAC
```{.cisco-ios}
Switch# show mac address-table
Switch# show mac address-table count
Switch# show mac address-table aging-time
```

### Comandos de limpieza
```{.cisco-ios}
Switch# clear mac address-table dynamic
Switch# clear ip route *
Switch# clear arp-cache
```
