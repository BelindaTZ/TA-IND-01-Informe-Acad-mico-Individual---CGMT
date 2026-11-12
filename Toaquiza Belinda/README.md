# TA-IND-01 — Informe Académico Individual
 
Análisis crítico de un sistema distribuido real (CockroachDB), comparado con Apache Cassandra — Aplicaciones Distribuidas, UTEQ.
 
- **Estudiante:** _completar_
- **Video de sustentación:** _enlace (YouTube no listado o Google Drive con acceso abierto)_
## Compilación
 
- **Compilador:** pdfLaTeX (TeX Live o MiKTeX)
- **Archivo principal:** `main.tex`
- **Bibliografía:** `referencias.bib` (biblatex con backend biber, estilo IEEE)
- **Orden de comandos:**
```bash
pdflatex main.tex
biber main
pdflatex main.tex
pdflatex main.tex
```
 
- **Dependencias (paquetes LaTeX):** babel (spanish), csquotes, mathptmx, geometry, microtype,
  setspace, ragged2e, titlesec, fancyhdr, graphicx, float, booktabs, tabularx, array, caption,
  xcolor, tikz, listings, biblatex, hyperref. Una instalación completa de TeX Live los incluye.
## Estructura del repositorio
 
| Ruta | Contenido |
|---|---|
| `main.tex`, `referencias.bib` | Fuentes del informe |
| `main.pdf` | PDF compilado |
| `figuras/` | Diagramas y esquema a mano |
| `capturas/` | Capturas de ejecución y de lectura de fuentes |
| `experimento/` | Comandos y resultados del experimento |
| `BITACORA.md` | Bitácora de trabajo |
 