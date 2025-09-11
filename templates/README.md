Carpeta de plantillas para prácticas - Uso y convenciones

Propósito

La carpeta `templates/` contiene archivos reutilizables para generar las prácticas en este repositorio. Diseñadas para copiarlas y pegarlas en cada carpeta de práctica, las plantillas mantienen consistencia visual y técnica.

Contenido principal

- `practice-metadata.yaml` — Plantilla YAML con metadatos y opciones de documento (portada, colores, encabezados, índices, etc.). Recomendado: copiar el contenido relevante en el frontmatter de cada práctica o incluirlo con `--metadata-file` si se desea.

- `custom-boxes.tex` — Definición de cajas (tcolorbox) y estilos para listings y código. Esta plantilla se incluye automáticamente desde el `Makefile` cuando se genera el PDF.

- `snippets/` — Fragmentos Markdown reutilizables (configuraciones comunes, comandos, tablas). Útiles para copiar comandos Cisco IOS, tablas de direccionamiento, etc.

Buenas prácticas

1. Mantener en las prácticas sólo los metadatos específicos de la práctica (título, autores, fecha, número de práctica, keywords). Las opciones globales (geometry, fuente, template path, color links, logo, etc.) se gestionan desde el `Makefile` y `practice-metadata.yaml`.

2. Para personalizar la portada y fondo use las variables del `Makefile` si necesita cambiar rutas o colores globales. Evite duplicar valores en ambos sitios.

3. Si se requiere cambiar el template LaTeX base (`eisvogel.latex`), actualice la variable `EISVOGEL_TEMPLATE` en el `Makefile`.

Cómo crear una nueva práctica

1. Copiar la carpeta `practicas/practica-01-mac-flooding/` y renombrarla a `practica-XX-<tema>`.
2. Editar sólo el frontmatter de `practica-XX-<tema>.md` para cambiar `title`, `author`, `date`, `practice-number` y `practice-topic`.
3. Agregar imágenes en `images/`, configuraciones en `configs/` y topologías en `topologies/` según la estructura estándar del repositorio.
4. Ejecutar `make practica-XX` o `make all` para generar el PDF.

Notas

- `custom-boxes.tex` ya está referenciado por el `Makefile` como `--include-in-header`. Si necesita más paquetes en LaTeX, añádalos allí.
- Use rutas absolutas relativas al repo root si va a invocar `pandoc` desde el `Makefile` (las variables en el Makefile están configuradas para ello).

---
Generado: $(date)
