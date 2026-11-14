
# TA-IND-01 — Análisis crítico de etcd

**Estudiante:** Calderón Saltos Joseph Alexander  
**Universidad:** Universidad Técnica Estatal de Quevedo  
**Facultad:** Ciencias de la Computación y Diseño Digital  
**Carrera:** Software  
**Asignatura:** Aplicaciones Distribuidas (ISR-701)  
**Paralelo:** A  
**Actividad:** TA-IND-01 — Informe Académico Individual

## Sistema analizado

Este trabajo analiza etcd, un sistema distribuido de clave-valor utilizado para almacenar información de configuración y coordinar servicios.

Se estudian su arquitectura, las siete transparencias de distribución, CAP, PACELC, los modelos de comunicación y la tolerancia a fallos.

También se compara con Apache ZooKeeper para identificar diferencias en consistencia, comunicación, recuperación y coordinación.

## Experimento realizado

El 12 de noviembre de 2026 se ejecutó un clúster de tres miembros de etcd 3.7.3 mediante Docker Desktop en Windows 11.

Se realizaron cinco pruebas:

1. Consultar el estado inicial e identificar al líder.
2. Escribir una clave desde un miembro y leerla desde otro.
3. Detener al líder y observar la elección de otro miembro.
4. Confirmar una escritura mientras un nodo permanecía detenido.
5. Reiniciar el nodo y comprobar su recuperación.

El líder inicial fue `etcd3`. Después de detenerlo, `etcd1` asumió el liderazgo y el término Raft cambió de 3 a 4.

Con dos miembros activos, el clúster siguió aceptando escrituras. Tras reiniciar `etcd3`, este pudo consultar el dato registrado durante su ausencia.

El experimento se limitó a la detención y recuperación de un proceso. No se realizaron particiones de red ni mediciones de latencia.

## Archivos del proyecto

- `main.tex`: informe académico en LaTeX.
- `Referencias/referencias.bib`: bibliografía utilizada en formato IEEE.
- `Anexos/Anexo_A_bosquejo_etcd.jpg`: esquema inicial dibujado a mano.
- `Anexos/Anexo_B_diagrama_etcd.pdf`: diagrama de arquitectura.
- `Anexos/diagrama_arquitectura_etcd.drawio`: archivo editable del diagrama.
- `Anexos/lectura_bora.png`: captura de lectura del artículo de Bora y colaboradores.
- `Anexos/lectura_gulcan.png`: captura de lectura del artículo de Gulcan y colaboradores.
- `Anexos/lectura_borgarelli.png`: captura de lectura del artículo de Borgarelli y colaboradores.
- `Experimento/compose.yaml`: configuración del clúster de etcd.
- `Experimento/comandos_y_resultados.md`: comandos, salidas e interpretación de las pruebas.
- `Experimento/Capturas/`: cinco capturas del experimento.
- `BITACORA.md`: registro de las sesiones de trabajo.

El archivo `main.pdf` se incorporará al repositorio una vez finalizada la compilación y revisión del informe.

## Cómo reproducir el experimento

**Requisitos:** Windows 11, Docker Desktop y Docker Compose.

Desde la carpeta `Experimento`, ejecutar:

```powershell
docker compose config --quiet
docker compose up -d
docker compose ps
```

Para consultar el estado de los tres miembros:

```powershell
docker exec ta-etcd1 etcdctl --endpoints=http://etcd1:2379,http://etcd2:2379,http://etcd3:2379 endpoint status -w table
```

Los comandos de escritura, lectura, detención del líder y recuperación están documentados en `Experimento/comandos_y_resultados.md`.

Para detener los contenedores sin eliminar sus volúmenes:

```powershell
docker compose stop
```

## Compilación del informe académico

El informe está desarrollado en LaTeX. Su compilación genera `main.pdf` con el contenido académico, las tablas, el diagrama de arquitectura, las referencias IEEE y las capturas incluidas en los anexos.

### 1. Requisitos

Tener instalada una distribución de LaTeX, como TeX Live o MiKTeX, con las siguientes herramientas:

- pdfLaTeX.
- Biber.
- Paquetes: `babel`, `lmodern`, `geometry`, `graphicx`, `booktabs`, `tabularx`, `array`, `caption`, `csquotes`, `biblatex` e `hyperref`.

### 2. Descargar el repositorio

Clonar el repositorio:

```bash
git clone https://github.com/BelindaTZ/TA-IND-01-Informe-Acad-mico-Individual---CGMT.git
```

Entrar al repositorio y después a la carpeta individual:

```bash
cd TA-IND-01-Informe-Acad-mico-Individual---CGMT
cd "Calderon Joseph"
```

También se puede descargar el proyecto como ZIP desde GitHub y extraerlo, conservando su estructura de carpetas.

### 3. Estructura necesaria para compilar

Los archivos deben conservar sus nombres y rutas originales:

```text
Calderon Joseph/
├── main.tex
├── README.md
├── BITACORA.md
├── Referencias/
│   └── referencias.bib
├── Anexos/
│   ├── Anexo_A_bosquejo_etcd.jpg
│   ├── Anexo_B_diagrama_etcd.pdf
│   ├── diagrama_arquitectura_etcd.drawio
│   ├── lectura_bora.png
│   ├── lectura_gulcan.png
│   └── lectura_borgarelli.png
└── Experimento/
    ├── compose.yaml
    ├── comandos_y_resultados.md
    └── Capturas/
        ├── 01_estado_cluster.png
        ├── 02_escritura_lectura.png
        ├── 03_caida_lider.png
        ├── 04_escritura_durante_fallo.png
        └── 05_recuperacion_nodo.png
```

Las imágenes y referencias son cargadas automáticamente mediante las rutas relativas definidas en `main.tex`. No es necesario insertarlas manualmente.

### 4. Generar el PDF

Desde la carpeta `Calderon Joseph`, ejecutar los siguientes comandos en orden:

```bash
pdflatex -halt-on-error main.tex
biber main
pdflatex -halt-on-error main.tex
pdflatex -halt-on-error main.tex
```

El proceso realiza lo siguiente:

1. La primera ejecución de pdfLaTeX procesa el documento y carga las figuras.
2. Biber procesa las entradas de `Referencias/referencias.bib`.
3. La segunda ejecución incorpora la bibliografía y actualiza las citas.
4. La tercera ejecución actualiza las referencias cruzadas y la numeración de figuras.

El orden de compilación es:

**pdfLaTeX → Biber → pdfLaTeX → pdfLaTeX**

No se requiere ejecutar Docker para compilar el informe. Docker solo es necesario para reproducir el experimento.

### 5. Resultado de la compilación

Si el proceso finaliza sin errores, se genera:

```text
Calderon Joseph/main.pdf
```

El PDF debe contener:

- Portada con los datos del estudiante y el enlace al repositorio.
- Resumen e introducción.
- Arquitectura de etcd y diagrama digital.
- Análisis de transparencias, CAP, PACELC y modelos de comunicación.
- Tolerancia a fallos e incidente documentado.
- Resultados e interpretación del experimento.
- Ejemplos del entorno del estudiante.
- Comparación con Apache ZooKeeper.
- Postura crítica y conclusiones.
- Declaración de uso de inteligencia artificial.
- Referencias bibliográficas IEEE.
- Bosquejo inicial de arquitectura.
- Tres capturas de lectura de fuentes.
- Cinco capturas del experimento con Docker.

Si falta algún archivo de imagen o `referencias.bib`, la compilación puede detenerse o generar un documento incompleto. Se recomienda revisar los mensajes de compilación antes de utilizar el PDF.

### Compilación alternativa en Overleaf

El mismo proyecto puede compilarse en Overleaf:

1. Subir `main.tex` y las carpetas `Anexos`, `Referencias` y `Experimento`.
2. Mantener los nombres y rutas originales.
3. Seleccionar `main.tex` como documento principal.
4. Configurar pdfLaTeX como compilador.
5. Ejecutar **Recompile** y comprobar que la bibliografía se procese con Biber.
6. Descargar el PDF generado.

## Referencias académicas

El informe incluye seis publicaciones académicas con DOI sobre consenso, Raft y pruebas de sistemas distribuidos.

También utiliza documentación oficial de etcd, Kubernetes y Apache ZooKeeper, además de bibliografía sobre sistemas distribuidos.

Las referencias se encuentran en `Referencias/referencias.bib` y se procesan con BibLaTeX y el estilo IEEE.

## Video de sustentación

**Estado:** pendiente de publicación.

Se preparará un video individual de 3 a 5 minutos, con el rostro y la voz del estudiante, en el que se explicará una captura real del experimento y las conclusiones principales.

**Enlace al video:** pendiente de incorporar.

## Estado de la entrega

El informe, el experimento, sus resultados y las evidencias se encuentran documentados.

Queda pendiente incorporar el PDF definitivo al repositorio, publicar el video de sustentación y completar la bitácora con las últimas actividades realizadas.
