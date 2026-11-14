# TA-IND-01 — Análisis crítico de TiDB frente a YugabyteDB

**Estudiante:** Manotoa Alava Carlos Alexander  
**Carrera:** Ingeniería de Software, séptimo semestre A  
**Asignatura:** Sistemas Distribuidos  
**Fecha de entrega:** 15 de noviembre de 2026

## Video de sustentación

[Ver sustentación en YouTube](https://youtu.be/F2ZR4tRdR3A)

## Compilación

**Archivo principal:** `main.tex`  
**Compilador:** pdfLaTeX  
**Bibliografía:** BibLaTeX con estilo IEEE y biber

Ejecutar desde esta carpeta:

```bash
bash compilar.sh
```

El script guarda los archivos auxiliares en `.compilacion/` y genera `main.pdf`.

También se puede compilar manualmente:

```bash
pdflatex main.tex
biber main
pdflatex main.tex
pdflatex main.tex
```

**Dependencias:** TeX Live con soporte español, pdfLaTeX, biber, biblatex, biblatex-ieee, babel-spanish, fontenc, inputenc, geometry, lmodern, microtype, graphicx, booktabs, tabularx, array, amsmath, PGF/TikZ, float, placeins, listings, xcolor, csquotes, hyperref y xurl. TikZ utiliza las bibliotecas `arrows.meta` y `babel`.

## Organización de los archivos

- `main.tex`: documento principal.
- `main.pdf`: informe compilado.
- `datos.tex`: datos del estudiante.
- `ejemplos.tex`: experiencias relacionadas con los conceptos analizados.
- `referencias.bib`: fuentes bibliográficas.
- `figuras/`: boceto a mano, archivo draw.io y diagrama TikZ.
- `capturas/experimento/`: cuatro capturas del ejercicio práctico.
- `capturas/lecturas/`: capturas de Ferreira, Ding y Song utilizadas en el Anexo B.
- `experimento/docker-compose.yml`: configuración de la práctica.
- `experimento/COMANDOS-Y-RESULTADOS.md`: comandos, salidas observadas e interpretación.
- `experimento/README.md`: instrucciones para reproducir el ejercicio.
- `BITACORA.md`: actividades, problemas, soluciones y tiempos registrados.

## Experimento práctico

Se utilizó TiDB 7.5.0 con Docker Compose, mediante un PD, un TiDB Server y tres TiKV. Se terminó uno de los contenedores TiKV y se comprobó una inserción posterior.

El informe explica los resultados y los límites de esta prueba. El tiempo mostrado por el INSERT no representa el tiempo de recuperación del sistema.

## Uso de inteligencia artificial y versiones

El trabajo partió de avances redactados por el estudiante en DOCX. OpenAI Codex apoyó la búsqueda y lectura de fuentes, el contraste de referencias, la revisión y adaptación del texto, el formato LaTeX y el resaltado de las lecturas.

Las capturas originales se conservaron sin modificar sus datos. Los resaltados de lectura se aplican sobre el PDF mediante LaTeX. La declaración completa de uso de IA está incluida en el informe.

Esta carpeta contiene la versión final y las evidencias utilizadas. El historial Git conserva la evolución del trabajo.