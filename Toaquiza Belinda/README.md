# TA-IND-01 — Informe Académico Individual

Análisis crítico de **CockroachDB** frente a **Apache Cassandra** a partir de los
conceptos de la Unidad 1 (transparencias de distribución, comunicación, CAP/PACELC y
tolerancia a fallos), con dos experimentos propios sobre clústeres de tres nodos.

- **Estudiante:** Toaquiza Zambrano Belinda Betzabeth
- **Paralelo:** A
- **Asignatura:** Aplicaciones Distribuidas
- **Universidad Técnica Estatal de Quevedo — Facultad de Ciencias de la Ingeniería**
- **Código de la actividad:** TA-IND-01
- **Video de presentación:** https://youtu.be/jjIqFWVfyhc
- **Informe compilado:** [`main.pdf`](main.pdf) (33 páginas)

## Compilación

### Requisitos

- **Compilador:** pdfLaTeX (probado con **MiKTeX 26.2** en Windows; también funciona en
  TeX Live).
- **Bibliografía:** Biber (backend de `biblatex`).
- No se necesita Docker para compilar el PDF: Docker solo se usa para reproducir los
  experimentos de la sección 4.

### Archivo principal

`main.tex` es el único archivo que se compila. Debe ejecutarse desde esta carpeta
(la que contiene `main.tex`), porque todas las rutas de figuras y de la bibliografía
son relativas.

### Orden de comandos

Orden: **pdflatex → biber → pdflatex → pdflatex**.

```bash
pdflatex -interaction=nonstopmode main.tex
biber main
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
```

Por qué ese orden:

1. El primer `pdflatex` genera `main.aux` y `main.bcf` y deja las citas sin resolver.
2. `biber main` lee `main.bcf` y `Referencias/referencias.bib`, y escribe `main.bbl`.
3. El segundo `pdflatex` incorpora la bibliografía y las citas.
4. El tercer `pdflatex` termina de resolver referencias cruzadas, numeración de
   figuras/tablas y el índice interno de hipervínculos.

Si se omite `biber`, el PDF sale con `[?]` en las citas y sin la lista de referencias.

### Limpiar y recompilar desde cero

Antes de compilar desde cero, o si aparece un error de referencias, se pueden borrar
los auxiliares y repetir la secuencia:

```bash
# Windows (PowerShell)
Remove-Item main.aux, main.bbl, main.bcf, main.blg, main.log, main.out, main.run.xml -ErrorAction SilentlyContinue

# Linux / macOS
rm -f main.aux main.bbl main.bcf main.blg main.log main.out main.run.xml
```

Si está instalado `latexmk`, también sirve `latexmk -pdf main.tex`, que ejecuta la
misma secuencia de forma automática.

### Dependencias (paquetes LaTeX)

| Paquete | Uso en el informe |
|---|---|
| `babel` (spanish) | Idioma, separadores y «Tabla» en español |
| `csquotes` | Comillas y citas textuales |
| `mathptmx` | Tipografía Times para texto y matemáticas |
| `geometry`, `microtype`, `setspace`, `ragged2e` | Márgenes, justificación e interlineado |
| `titlesec`, `fancyhdr` | Formato de títulos y encabezados |
| `graphicx`, `float`, `caption` | Figuras y pies |
| `booktabs`, `tabularx`, `array` | Tablas comparativas y de resultados |
| `xcolor`, `tikz` | Colores y diagrama de arquitectura |
| `listings` | Listados de comandos |
| `biblatex` + `biber` (estilo `ieee`) | Referencias en formato IEEE |
| `hyperref` | Enlaces internos y externos |

En **MiKTeX** basta con permitir la instalación automática de paquetes. En **TeX Live**
una instalación completa (`scheme-full`) los incluye todos; en Debian/Ubuntu equivalen
a:

```bash
sudo apt install texlive-latex-recommended texlive-latex-extra \
  texlive-lang-spanish texlive-pictures texlive-bibtex-extra biber
```

### Archivos necesarios para compilar

- `main.tex`
- `Referencias/referencias.bib`
- `figuras/arquitectura-cockroachdb.tex` (diagrama TikZ)
- `Capturas/` completa (capturas de evidencia y de lectura de fuentes)

Las rutas distinguen mayúsculas y minúsculas, así que `Capturas/` y `Referencias/`
deben conservar exactamente ese nombre (importante al compilar en Linux o al subir a
GitHub).

### Verificación

La secuencia anterior se probó en una copia limpia de la carpeta: termina sin errores,
genera un PDF de 33 páginas y deja solo dos advertencias inocuas que no afectan el
resultado:

- `pdfTeX warning (ext4): destination with the same identifier (name{page.1})`
  (la portada y la página 1 comparten el ancla de `hyperref`).
- `Package biblatex Warning: Bibliography string 'artno' untranslated` (cadena del
  estilo IEEE para números de artículo).

## Estructura de la carpeta

| Ruta | Contenido |
|---|---|
| `main.tex` | Fuente LaTeX del informe |
| `main.pdf` | Informe compilado (33 páginas) |
| `Referencias/referencias.bib` | Bibliografía en formato BibLaTeX |
| `Referencias/PDFs/` | Artículos y documentos de las fuentes |
| `figuras/` | Diagrama de arquitectura (TikZ) y esquema inicial |
| `Capturas/` | Capturas de los experimentos y de lectura de fuentes |
| `Capturas/fuentes/` | Recortes originales y subrayados del Anexo B |
| `experimento/` | `comandos.md`, archivos `docker-compose.yml` y evidencias |
| `BITACORA.md` | Registro de trabajo por día |

## Contenido del informe

1. Introducción
2. Arquitectura del sistema
3. Análisis con los conceptos de la Unidad 1
4. Experimentación propia (dos experimentos, resultados y conclusiones)
5. Ejemplos del entorno del estudiante
6. Análisis comparativo
7. Postura crítica
8. Conclusiones

El informe cierra con la declaración de uso de inteligencia artificial, las
referencias en formato IEEE y dos anexos: el esquema inicial a mano y las capturas de
lectura de las fuentes.

## Reproducción de los experimentos (opcional)

Los experimentos no son necesarios para compilar el PDF, pero se pueden repetir con:

- Docker 29.9.3
- CockroachDB 26.4.0 (imagen `cockroachdb/cockroach:v26.4.0`), nodos `roach1`,
  `roach2` y `roach3`
- Apache Cassandra 5.0.9 (imagen `cassandra:5.0`), nodos `cass1`, `cass2` y `cass3`

Los archivos de composición están en `experimento/cockroachdb/` y
`experimento/cassandra/`, y la secuencia completa de comandos, horas y resultados está
en [`experimento/comandos.md`](experimento/comandos.md).

## Uso de inteligencia artificial

El detalle de las herramientas empleadas, las tareas apoyadas y la verificación
aplicada está en la sección «Declaración de uso de inteligencia artificial» de
`main.pdf` y en el código fuente de `main.tex`.
