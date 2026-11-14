# Bitácora de Trabajo — TA-IND-01
## Sesión 1 — 11 de noviembre de 2026
* **Actividades realizadas:**
  * Selección y definición del caso de estudio: **Apache Kafka** (sistema principal) frente a **RabbitMQ** (sistema de comparación).
  * Creación del repositorio público en GitHub y estructuración de directorios base (`experimento/`, `capturas/`, `figuras/`).
  * Redacción del archivo `README.md` con los datos identificativos, instrucciones de compilación (`pdflatex` -> `biber` -> `pdflatex` x2) y dependencias de LaTeX.
  * Creación de la estructura base del documento académico en `main.tex` con las 13 secciones obligatorias de la rúbrica.
  * Inicialización del archivo de bibliografía `referencias.bib`.
  * Para estás actividades se dedico un tiempo aproximado de tres horas
* **Problemas encontrados y solución:**
  * *Problema:* Se requería asegurar un respaldo bibliográfico riguroso que cumpliera estrictamente con los filtros de la rúbrica (últimos 5 años, acceso libre y DOI verificable).
  * *Solución:* Se realizó una selección previa de referencias candidatas, entendiendo que este conjunto de fuentes podrá cambiar, reducirse o extenderse según avance la redacción y los requerimientos específicos del análisis técnico de la Unidad 1.
## Sesión 2 — 12 de noviembre de 2026
* **Actividades realizadas:**
  * Relección y definición del caso de estudio, dado que el tema se repetia con el de un compañero. Nuevo tema seleccionado: TiDB (principal) vs. YugabyteDB (comparativo).
  * Para estás actividades se dedico un tiempo aproximado de tres horas.
* **Problemas encontrados y solución:**
  * *Problema:* Dificultad para encontrar aplicaciones distribuidas que no repetan con las de los compañeros.
  * *Solución:* Busqueda de aplicaciones distribuidas con ayuda de la IA.
## Sesión 3 — 12 de noviembre de 2026
* **Actividades realizadas:**
  * Inicio de la redacción
  * Se sube un primer avances en formato .docx
* **Problemas encontrados y solución:**
  * Durante esta sección no se encontraron mayores problemas
## Sesión 4 — 12 de noviembre de 2026
* **Actividades realizadas:**
  * Continuación de la redacción
  * En esta etapa se realizo un avance de los conceptos
* **Problemas encontrados y solución:**
  * Durante esta sección no se encontraron mayores problemas
## Sesión 5 — 13 de noviembre de 2026
* **Actividades realizadas:**
  * En esta sesión se realizo la diagramación de la arquitectura del sistema TiDB, primero a mano y luego cuando estuvo finalizado se lo paso a draw.io
* **Problemas encontrados y solución:**
* *Problema:* Desconocimiento de la arquitectura y sus capas
* *Solución:* Buscando información se encontró que en la documentación oficial se encuentra su arquitectura.

## Sesión 6 — 13 de noviembre de 2026

* **Actividades realizadas:**
  * Revisión y redacción del informe sobre TiDB y YugabyteDB, manteniendo un lenguaje parecido al avance original.
  * Incorporación de párrafos de conexión entre los títulos y sus subtítulos.
  * Revisión de las referencias bibliográficas, sus DOI, fechas de publicación y acceso gratuito. Se ajustaron las entradas del archivo bibliográfico a las citas utilizadas en el informe.
  * Organización de las capturas del ejercicio práctico según su orden: inicio del clúster, preparación de la base, caída de un TiKV y operación posterior.
  * Organización de las carpetas de figuras, capturas y experimento, conservando las imágenes originales.
  * Corrección de las dependencias y rutas necesarias para compilar el documento.
  * Actualización del README y del archivo Docker Compose de la práctica.
  * Incorporación de tres capturas de lectura de Ferreira, Ding y Song, con los fragmentos relevantes resaltados en el PDF.
  * Preparación del script de compilación y revisión visual del documento final, que quedó con 18 páginas.
  * Para estas actividades se dedicó un tiempo aproximado de 5 horas.

* **Problemas encontrados y solución:**
  * *Problema:* La compilación se detenía porque faltaban archivos de apoyo y el diagrama de arquitectura en LaTeX.
  * *Solución:* Se incorporaron las dependencias necesarias y se corrigieron las rutas de las figuras y capturas.

  * *Problema:* El archivo bibliográfico correspondía a una versión anterior y no contenía varias claves citadas en el documento.
  * *Solución:* Se ajustó la bibliografía y se comprobó que las 18 referencias tuvieran sus citas correspondientes.

  * *Problema:* Una de las lecturas seleccionadas estaba en chino, lo que dificultaba comprender y explicar su contenido.
  * *Solución:* Para la evidencia de lectura se seleccionó un artículo en inglés de Springer. La referencia anterior se conservó en las secciones donde seguía utilizándose.

  * *Problema:* Algunas imágenes no estaban ubicadas en las carpetas que esperaba el documento y todavía faltaban las capturas de lectura.
  * *Solución:* Se organizaron las imágenes, se incorporaron las tres lecturas y se añadieron resaltados sobre el PDF sin modificar los archivos originales.

  * *Problema:* El compilador integrado no pudo trabajar correctamente con un salto de línea presente en el nombre de una carpeta superior.
  * *Solución:* Se compiló desde la terminal mediante pdfLaTeX y biber, utilizando un script que guarda los archivos auxiliares en una carpeta separada.

  * *Problema:* El README todavía mencionaba el tema anterior y el archivo Docker Compose del repositorio estaba vacío.
  * *Solución:* Se actualizó la descripción del trabajo y se incorporó la configuración utilizada en la práctica.