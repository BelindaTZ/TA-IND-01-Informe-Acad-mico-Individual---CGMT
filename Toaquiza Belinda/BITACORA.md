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

### 2026-11-12
- **Qué hice:** Después de instalar Apache Cassandra y CockroachDB, preparé CockroachDB para continuar con la práctica experimental en un clúster seguro de tres nodos. Liberé los puertos deteniendo el contenedor de un solo nodo, generé los certificados de la CA, de los nodos y del cliente root, y levanté el clúster con Docker Compose. Las claves y certificados quedaron en volúmenes de Docker, fuera del repositorio.
- **Problema encontrado:** El contenedor de CockroachDB de un solo nodo ocupaba los puertos que necesitaba el clúster. Cassandra seguía funcionando correctamente.
- **Cómo lo resolví:** Detuve el contenedor `cockroach`, creé el material de certificados y ejecuté `docker compose up -d`. Luego inicialicé el clúster con `cockroach init` y comprobé el estado de los nodos y la versión. La consola confirmó la inicialización correcta, los tres nodos activos y la versión `v26.4.0`. Guardé las evidencias como `Capturas/cockroachdb-certificados-generados.png` y `Capturas/cockroachdb-cluster-inicializado-y-verificado.png`.
- **Tiempo dedicado:** 40 min

### 2026-11-12
- **Qué hice:** Al revisar la preparación del experimento de partición de red, ajusté la configuración del clúster CockroachDB y las instrucciones de consulta al nodo aislado.
- **Problema encontrado:** Cada nodo tenía configurada una dirección de escucha limitada a su nombre dentro de la red de Docker. Al desconectar un nodo, esa dirección deja de estar disponible, lo que podía impedir la conexión y confundir un problema de acceso con el comportamiento que se busca observar en el experimento.
- **Cómo lo resolví:** Quité del `docker-compose.yml` las direcciones `--listen-addr` específicas para que los nodos escuchen en todas sus interfaces, incluida `localhost`. Para consultar un nodo aislado, indiqué que se use `--host=localhost:26257` desde su propio contenedor. También añadí que se registre si una consulta queda esperando o termina en timeout, cuánto tarda y que se puede cancelar con `Ctrl+C`. Así, la prueba permite observar la respuesta del clúster sin perder el acceso local al nodo aislado.
- **Tiempo dedicado:** 25 min

### 2026-11-12
- **Qué hice:** Preparé el entorno de Apache Cassandra para la práctica experimental. Detuve el clúster CockroachDB y el contenedor Cassandra de un solo nodo para liberar recursos; después levanté con Docker Compose un clúster Cassandra de tres nodos.
- **Problema encontrado:** El arranque de los nodos tomó varios minutos porque se iniciaron de forma secuencial y cada uno debía superar su verificación de salud antes de iniciar el siguiente.
- **Cómo lo resolví:** Esperé a que terminara el arranque y comprobé el estado con `nodetool status`. Los tres nodos aparecieron como `UN` (activos y normales). La configuración mantiene direcciones IP fijas en la red del clúster y limita la memoria para que los tres nodos puedan ejecutarse en el mismo equipo. Guardé las capturas como `Capturas/cassandra-preparacion-detener-servicios-previos.png` y `Capturas/cassandra-cluster-3-nodos-verificacion-UN.png`.
- **Tiempo dedicado:** 30 min
### 2026-11-13
- **Qué hice:** Amplié la bibliografía con nuevas fuentes para sustentar la comparación entre CockroachDB y Apache Cassandra. Añadí documentación técnica sobre arquitectura, replicación, almacenamiento, comunicación y consistencia, además de publicaciones académicas y un caso de uso industrial. Incorporé también tres artículos en formato PDF a `Referencias/PDFs`.
- **Problema encontrado:** Las fuentes iniciales no cubrían con suficiente detalle los aspectos técnicos y experimentales que se están analizando en ambos sistemas.
- **Cómo lo resolví:** Agregué 15 referencias al archivo bibliográfico y organicé los tres nuevos artículos en PDF junto a las fuentes del proyecto para consultarlos durante el análisis.
- **Tiempo dedicado:** No registrado