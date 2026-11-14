# TA-IND-01: Análisis crítico de TiDB frente a YugabyteDB

**Estudiante:** Manotoa Alava Carlos Alexander  
**Carrera:** Ingeniería de Software, séptimo semestre A  
**Asignatura:** Sistemas Distribuidos  
**Fecha de entrega:** 15 de noviembre de 2026

## Video de sustentación

**Enlace: pendiente de grabación.** Añadir la URL real y accesible cuando esté disponible.

## Compilar el informe

Ejecutar desde esta carpeta:

```bash
bash compilar.sh
```

Se necesita pdfLaTeX, biber y los paquetes utilizados en el preámbulo de `main.tex`. El script ejecuta pdfLaTeX, biber y dos pasadas adicionales de pdfLaTeX; guarda los auxiliares en `.compilacion/` y deja el resultado en `main.pdf`.

También puede utilizarse la secuencia manual habitual, desde esta misma carpeta:

```bash
pdflatex main.tex
biber main
pdflatex main.tex
pdflatex main.tex
```

## Organización

- `main.tex`, `datos.tex`, `ejemplos.tex` y `referencias.bib`: fuentes del informe.
- `figuras/arquitectura.tex`: diagrama conceptual utilizado por LaTeX.
- `figuras/arquitectura-original.drawio` y `.png`: diagrama original del estudiante.
- `figuras/boceto-original.jpeg`: fotografía original del esquema a mano.
- `capturas/experimento/`: cuatro imágenes de la ejecución final con Docker, en orden.
- `capturas/preparacion/`: seis imágenes anteriores conservadas como antecedentes.
- `capturas/lecturas/`: las tres capturas originales del Anexo B: `01-ferreira.png`, `02-ding.png`, `03-song.png`. El resaltado se dibuja en LaTeX sobre el PDF; no se modificaron los PNG.
- `experimento/docker-compose.yml`: configuración de la práctica, con un PD, un TiDB Server y tres TiKV 7.5.0.
- `experimento/COMANDOS-Y-RESULTADOS.md`: transcripción de lo visible en las capturas, con sus límites.
- `experimento/README.md`: instrucciones para reproducir una corrida nueva; no es un registro de ejecución.
- `BITACORA.md`: sesiones reales registradas por el estudiante. No se añadieron sesiones ni duraciones durante esta organización.
- `revision/`: inventario inicial, mapa de nombres y respaldo local anterior a los cambios.

## Evidencias pendientes

Las tres capturas de lectura ya están incorporadas y resaltadas en el PDF. Sigue pendiente el enlace al video y completar la identificación del boceto y de algunas capturas. Las duraciones que no constan en la bitácora deben completarse con los datos reales. El ejercicio documenta una inserción tras terminar un TiKV; no mide el tiempo de recuperación ni prueba fallos de todas las capas.

## Uso de inteligencia artificial

La declaración de asistencia con IA se conserva en el informe e incluye la incorporación de las lecturas y el resaltado solicitado por el estudiante. El estudiante debe revisar y comprender el contenido, las referencias y los resultados antes de entregar.
