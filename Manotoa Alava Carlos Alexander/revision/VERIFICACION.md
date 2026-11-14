# Verificación de la organización

- Compilación con pdfLaTeX → biber → pdfLaTeX → pdfLaTeX: correcta; `main.pdf` tiene 18 páginas físicas.
- Sin errores, citas pendientes o advertencias Warning, Overfull o Underfull en el log final. Se añadió la traducción española de la cadena bibliográfica `artno`.
- Las 18 claves de citas coinciden con las 18 entradas únicas de la bibliografía.
- Todas las dependencias obligatorias de LaTeX están presentes. No se modificaron `datos.tex`, `ejemplos.tex` ni `referencias.bib` durante la organización.
- La versión ordenada se revisó visualmente completa. Tras incorporar las lecturas, las primeras 12 páginas conservan el mismo texto y distribución; se renderizaron y revisaron las páginas 13–18, incluida la nueva declaración de IA y las tres capturas resaltadas del Anexo B.
- Las 13 imágenes/archivos draw.io originales conservan sus hashes SHA-256 tras reorganizarlos.
- El respaldo anterior contiene los 20 archivos originales; su integridad y cada hash coinciden con el inventario inicial.
- El Compose restaurado coincide con la configuración de la práctica conservada en la revisión anterior: SHA-256 `23652e299a9b4fd41a825ce0d1bc0d44895efa00373ea517a6321c5fb016f701`.
- Sintaxis de `compilar.sh` comprobada con `bash -n` y ejecución completa correcta. Los auxiliares se guardan en `.compilacion/`, excluida de Git mediante las reglas locales de esta carpeta.

El compilador integrado no pudo manejar la ruta con un salto de línea literal en un directorio superior y su alternativa Tectonic no tenía el bundle disponible. La compilación verificada se hizo con las herramientas locales de terminal. No se renombró el directorio superior porque queda fuera del alcance autorizado.

Las tres capturas de lectura están incorporadas en `capturas/lecturas/`, con resaltado amarillo vectorial en el PDF y sin cambios en los PNG originales. No quedan avisos de captura de lectura pendiente. Siguen pendientes el video y los datos personales de evidencia y bitácora que no se habían aportado. No se ejecutaron contenedores ni se fabricaron resultados. No se hicieron commits ni push ni se entró en carpetas de otros estudiantes.

La versión con lecturas mantiene 18 referencias y dispone las tres fuentes del Anexo B en páginas independientes. La copia previa se conserva en `respaldo-antes-de-lecturas.zip`; procedencia y hashes en `LECTURAS.md`.
