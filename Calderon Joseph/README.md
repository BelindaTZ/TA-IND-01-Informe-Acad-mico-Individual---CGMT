
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

- `main.tex`: código fuente del informe académico.
- `main.pdf`: informe completo compilado.
- `Referencias/referencias.bib`: referencias bibliográficas en formato IEEE.
- `Anexos/Anexo_A_bosquejo_etcd.jpg`: esquema inicial dibujado a mano.
- `Anexos/Anexo_B_diagrama_etcd.pdf`: diagrama de arquitectura.
- `Anexos/diagrama_arquitectura_etcd.drawio`: archivo editable del diagrama.
- `Anexos/lectura_bora.png`: captura de lectura del artículo de Bora y colaboradores.
- `Anexos/lectura_gulcan.png`: captura de lectura del artículo de Gulcan y colaboradores.
- `Anexos/lectura_borgarelli.png`: captura de lectura del artículo de Borgarelli y colaboradores.
- `Experimento/compose.yaml`: configuración del clúster.
- `Experimento/comandos_y_resultados.md`: comandos, resultados e interpretación de las pruebas.
- `Experimento/Capturas/`: cinco capturas originales del experimento.
- `BITACORA.md`: registro de las sesiones de trabajo.

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

El informe está desarrollado en LaTeX. Su compilación genera `main.pdf` con el contenido académico, las tablas, el diagrama de arquitectura, las referencias IEEE y las capturas de los anexos.

### 1. Requisitos

Tener instalada una distribución de LaTeX, como TeX Live o MiKTeX, con las siguientes herramientas:

- pdfLaTeX.
- Biber.
- Paquetes: `babel`, `lmodern`, `geometry`, `graphicx`, `booktabs`, `tabularx`, `array`, `caption`, `biblatex` e `hyperref`.
- `csquotes`, recomendado para trabajar con BibLaTeX.

### 2. Descargar el repositorio

Clonar el repositorio:

```bash
git clone https://github.com/BelindaTZ/TA-IND-01-Informe-Acad-mico-Individual---CGMT.git
```

Entrar a la carpeta individual:

```bash
cd TA-IND-01-Informe-Acad-mico-Individual---CGMT
cd "Calderon Joseph"
```

También se puede descargar el repositorio como ZIP y extraerlo conservando su estructura de carpetas.

### 3. Estructura necesaria

```text
Calderon Joseph/
├── main.tex
├── main.pdf
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

Los nombres y rutas deben mantenerse exactamente iguales. Las imágenes y referencias se incorporan automáticamente mediante las instrucciones de `main.tex`.

### 4. Generar el PDF

Desde la carpeta `Calderon Joseph`, ejecutar en este orden:

```bash
pdflatex -halt-on-error main.tex
biber main
pdflatex -halt-on-error main.tex
pdflatex -halt-on-error main.tex
```

El proceso realiza lo siguiente:

1. La primera ejecución procesa el documento y sus figuras.
2. Biber procesa las entradas de `Referencias/referencias.bib`.
3. La segunda ejecución incorpora la bibliografía y actualiza las citas.
4. La tercera ejecución actualiza las referencias cruzadas y la numeración de figuras.

**Orden de compilación:** pdfLaTeX → Biber → pdfLaTeX → pdfLaTeX.

No se necesita Docker para compilar el informe. Docker solo se utiliza para reproducir el experimento.

### 5. Resultado

Al completar la compilación sin errores se genera:

```text
Calderon Joseph/main.pdf
```

El documento contiene la portada, el resumen, el análisis técnico, el diagrama de arquitectura, las tablas, las conclusiones, la declaración de uso de IA, las referencias IEEE y las evidencias del experimento.

También incluye el bosquejo inicial, tres capturas de lectura académica y cinco capturas de Docker.

La compilación se comprobó utilizando los archivos originales del proyecto.

### Compilación alternativa en Overleaf

1. Subir `main.tex` y las carpetas `Referencias`, `Anexos` y `Experimento`.
2. Mantener las rutas originales.
3. Seleccionar `main.tex` como documento principal.
4. Configurar pdfLaTeX.
5. Ejecutar **Recompile** y comprobar las referencias bibliográficas.
6. Descargar el PDF generado.

## Referencias académicas

El informe utiliza seis publicaciones académicas con DOI relacionadas con Raft, consenso y pruebas de sistemas distribuidos.

También incluye documentación oficial de etcd, Kubernetes y Apache ZooKeeper, además de bibliografía sobre sistemas distribuidos.

Las referencias están almacenadas en `Referencias/referencias.bib` y se procesan mediante BibLaTeX con estilo IEEE.

## Video de sustentación

**Estado:** publicado en YouTube.

**Enlace:** https://youtu.be/VZhGzHoyRug

El video presenta el funcionamiento de etcd mediante el diagrama de arquitectura elaborado para el informe.

También explica tres evidencias del experimento:

1. La caída del líder inicial y la elección de otro miembro.
2. La escritura de información mientras un nodo permanecía detenido.
3. La recuperación del nodo y la consulta de los datos registrados durante su ausencia.

Finalmente, se presentan los resultados y las conclusiones del análisis.

## Estado de la entrega

El informe académico está disponible en los archivos `main.tex` y `main.pdf`.

El repositorio contiene las referencias bibliográficas, el diagrama de arquitectura, el bosquejo inicial, las capturas de lectura, las evidencias del experimento y los comandos utilizados.

El video de sustentación está publicado y enlazado en este README.

La bitácora documenta las actividades desarrolladas durante la elaboración del trabajo.
