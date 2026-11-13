# Bitácora de trabajo — TA-IND-01: CockroachDB vs. Apache Cassandra
 
Una entrada por cada día trabajado. Las fechas deben coincidir con los commits del repositorio.
 
## Plantilla de entrada
 
### AAAA-MM-DD
- **Qué hice:**
- **Problema encontrado:**
- **Cómo lo resolví:**
- **Tiempo dedicado:** X h Y min
---
 
<!-- Agrega tus entradas debajo, de la más antigua a la más reciente. -->
 ### 2026-11-11
- **Qué hice:** Subí las plantillas para organizar la documentación del informe.
- **Problema encontrado:** No se habían consolidado todavía las plantillas de trabajo.
- **Cómo lo resolví:** Organicé y subí la estructura inicial de la documentación.
- **Tiempo dedicado:** No registrado

### 2026-11-11
- **Qué hice:** Busqué fuentes iniciales para orientar el informe y la práctica experimental.
- **Problema encontrado:** Era necesario reunir referencias pertinentes para comenzar el análisis.
- **Cómo lo resolví:** Identifiqué fuentes preliminares para apoyar el desarrollo del trabajo.
- **Tiempo dedicado:** 1 hora.

### 2026-11-11
- **Qué hice:** Subí el archivo `.bib` y los PDF de las seis referencias iniciales para la práctica experimental.
- **Problema encontrado:** Las referencias y sus documentos de respaldo debían quedar disponibles en el repositorio.
- **Cómo lo resolví:** Incorporé el archivo bibliográfico y los seis PDF.
- **Tiempo dedicado:** No registrado

### 2026-11-12
- **Qué hice:** Instalé y puse en marcha Apache Cassandra y CockroachDB con Docker. Guardé las capturas de ambas instalaciones en la carpeta `Capturas`.
- **Problema encontrado:** Cassandra se inició correctamente desde el primer intento. En CockroachDB, el contenedor se detenía con estado `Exited (1)`. Al revisar `docker logs cockroach`, encontré el mensaje `hostname of listen_addr must be "127.0.0.1" or "localhost"`. La causa era la combinación de `--insecure` con la dirección de escucha `0.0.0.0:26257` en la versión utilizada.
- **Cómo lo resolví:** Eliminé únicamente el contenedor fallido con `docker rm cockroach` y lo volví a crear usando `--listen-addr=127.0.0.1:26257`. Luego comprobé que el servidor estuviera operativo al abrir la consola SQL con `docker exec -it cockroach cockroach sql --insecure`. Así confirmé que el inconveniente provenía de la dirección de escucha incompatible con el modo inseguro y no de Docker ni de la instalación.
- **Tiempo dedicado:** 1 hora y media