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
- **Tiempo dedicado:** 15 min

### 2026-11-13
- **Qué hice:** Realicé la parte de CockroachDB del Experimento 1. Verifiqué la línea base y preparé los datos; después detuve roach2 y confirmé que las lecturas y escrituras continuaban, incluida la persistencia de la fila 4. Al detener también roach3, la sesión SQL reportó pérdida de quórum y no confirmó la consulta ni una escritura nueva. Abrí otra terminal, levanté roach2 y roach3 y comprobé que SQL volviera a responder: la fila 6 se insertó y pudo consultarse. Aunque roach1 seguía activo en Docker, node status lo mostraba con address NULL e is_live=false. Reinicié solo roach1; después, node status mostró los tres nodos activos y la consulta final incluyó las filas 1, 2, 3, 4 y 6. También observé que el identificador de rango pasó de 87 a 88; no se verificó la causa.
- **Problema encontrado:** Con dos nodos detenidos, CockroachDB no pudo atender la consulta por pérdida de quórum. Luego, tras recuperar SQL, node status siguió marcando roach1 como no activo hasta reiniciarlo.
- **Cómo lo resolví:** Inicié roach2 y roach3 desde una segunda terminal para recuperar SQL; luego reinicié únicamente roach1 y verifiqué el estado y los datos finales. Las capturas correspondientes están en Capturas/2026-11-13_cockroachdb_e1_01_linea_base_estado_cluster.png, Capturas/2026-11-13_cockroachdb_e1_02_linea_base_datos_rango87.png, Capturas/2026-11-13_cockroachdb_e1_03_roach2_detenido_lectura_escritura.png, Capturas/2026-11-13_cockroachdb_e1_04_dos_nodos_caidos_perdida_quorum.png, Capturas/2026-11-13_cockroachdb_e1_05_recuperacion_sql_nodos_levantados.png, Capturas/2026-11-13_cockroachdb_e1_06_roach1_estado_inconsistente_logs.png, Capturas/2026-11-13_cockroachdb_e1_07_reinicio_roach1_consulta_final_rango88.png y Capturas/2026-11-13_cockroachdb_e1_08_estado_final_tras_reinicio_roach1.png.
- **Tiempo dedicado:** 40 min
### 2026-11-13
- **Qué hice:** Documenté la ejecución de Apache Cassandra para el Experimento 1. A las 14:31:08 levanté el clúster en Docker Compose y comprobé Cassandra 5.0.9, los tres nodos `UN` y la distribución de la clave 1. A las 14:43:19 preparé el keyspace y la tabla con RF=3 y consistencia `QUORUM`. A las 15:00:36 detuve `cass2`: con `ONE` y `QUORUM` las lecturas y escrituras probadas pudieron verificarse después; con `ALL` Cassandra devolvió `Unavailable` al requerir tres réplicas y tener dos disponibles. A las 15:30:59 detuve `cass3`: `ONE` permitió leer y guardar la fila 7, mientras `QUORUM` y `ALL` no alcanzaron sus respuestas requeridas. A las 15:34:50 inicié ambos nodos. El primer `nodetool status` todavía mostraba dos `DN`; después, los tres contenedores aparecieron saludables y `nodetool status` confirmó los tres `UN`. La lectura final con `ALL` devolvió seis filas, con IDs 1, 2, 3, 4, 5 y 7.
- **Problema encontrado:** Tras iniciar los contenedores, el primer estado del clúster todavía mostraba `cass2` y `cass3` como `DN`. Además, los niveles `ALL` con un nodo detenido y `QUORUM`/`ALL` con dos nodos detenidos devolvieron `Unavailable` al no reunir suficientes réplicas.
- **Cómo lo resolví:** Esperé a que Cassandra reflejara la recuperación y repetí `nodetool status`; los tres nodos aparecieron `UN` sin que se observe otro reinicio. Verifiqué los datos recuperados con una lectura de consistencia `ALL`. Las capturas están en `Capturas/2026-11-13_cassandra_e1_01_linea_base_estado_version.png`, `Capturas/2026-11-13_cassandra_e1_02_datos_base_consistency_quorum.png`, `Capturas/2026-11-13_cassandra_e1_03_endpoints_replicas_datos.png`, `Capturas/2026-11-13_cassandra_e1_04_cass2_detenido_estado_y_pruebas.png`, `Capturas/2026-11-13_cassandra_e1_05_un_nodo_verificacion_lecturas.png`, `Capturas/2026-11-13_cassandra_e1_06_dos_nodos_estado_y_consistency.png` y `Capturas/2026-11-13_cassandra_e1_07_recuperacion_tres_un_y_lectura_all.png`.
- **Tiempo dedicado:** 40 min
### 2026-11-13
- **Qué hice:** Realicé la parte de Apache Cassandra del Experimento 2. A las 16:25:51 confirmé que `cass3` seguía `Up (healthy)`, aunque `nodetool status` ya mostraba su IP `172.28.0.13` como `DN`; a las 16:26:00, Docker confirmó al repetir la desconexión que el contenedor ya no estaba conectado a `cassandra-lab_cassnet`. Desde `cass3`, `ONE` permitió leer y escribir la fila 21 por localhost, mientras `QUORUM` falló al requerir dos respuestas y haber una disponible. Desde `cass1`, las operaciones con `ONE` y `QUORUM` no mostraron error; `ALL` falló con dos réplicas disponibles. A las 16:28:51 reconecté `cass3` con su IP original y `nodetool status` mostró tres nodos `UN`. La lectura final con `ALL` devolvió las filas 21, 23 y 24.
- **Problema encontrado:** El nodo aislado quedó marcado `DN` aunque su contenedor seguía saludable y Cassandra aceptaba conexiones locales. La lectura/escritura con niveles que exigían más réplicas que las disponibles devolvió `Unavailable`.
- **Cómo lo resolví:** Confirmé que el aislamiento estaba aplicado, probé cada lado con los niveles de consistencia correspondientes y reconecté `cass3` a `cassandra-lab_cassnet` con su IP original `172.28.0.13`. Después verifiqué los tres nodos `UN` y la visibilidad de las filas con `ALL`. Las capturas están en `Capturas/2026-11-13_cassandra_e2_01_cass3_aislado_estado_confirmacion.png`, `Capturas/2026-11-13_cassandra_e2_02_lado_aislado_one_quorum.png`, `Capturas/2026-11-13_cassandra_e2_03_lado_mayoritario_one_quorum_all.png` y `Capturas/2026-11-13_cassandra_e2_04_reconexion_tres_nodos_un_y_lectura_all.png`.
- **Tiempo dedicado:** 30 min
### 2026-11-13
- **Qué hice:** Completé la parte de CockroachDB del Experimento 2. A las 16:53:49 confirmé los tres nodos activos, las filas existentes, el rango 88 con votantes `{1,2,3}` y la IP/alias original de roach3. Según la cronología, la primera consulta de estado con los contenedores recién iniciados devolvió `connection refused`, aunque esa respuesta no aparece en las capturas. A las 16:56:47 desconecté roach3 de `crdb-lab_crdbnet`; `docker inspect` mostró `{}` y el contenedor siguió `Up`. A las 16:57:52 desde el lado mayoritario confirmé la lectura de id 1 y la escritura y lectura de id 31. A las 17:00:05 falló el primer intento de reconexión porque Docker interpretó `--alias` como IP; a las 17:01:03 reconecté con `172.22.0.2` y el alias `roach3`, y a las 17:03:26 los tres nodos estaban activos y la fila 31 seguía visible. Como se perdió la captura original, reproduje el escenario. En esa repetición, marcada 17:26:15, la lectura de id 1 desde roach3 devolvió `replica unavailable`/`lost quorum` (`SQLSTATE XXUUU`); el INSERT de id 32 quedó sin respuesta visible. A las 17:30:32 reconecté roach3; el estado inmediato aún lo mostraba `false/false`, pero a las 17:31:20 los tres nodos aparecieron activos. Dos consultas posteriores de id 32 no devolvieron filas. Esta secuencia corresponde a la repetición, no a una desconexión inesperada después de la primera verificación de las 17:03.
- **Problema encontrado:** El primer intento de reconexión usó un orden de argumentos incorrecto. Además, se perdió la captura original de la sesión SQL aislada, así que repetí esa parte del escenario para conservar su evidencia.
- **Cómo lo resolví:** Reconecté roach3 con su IP original y alias, verifiqué `docker inspect` y repetí `node status` hasta ver los tres nodos activos. Después reproduje el escenario para recuperar la captura perdida de la sesión SQL aislada. La lectura de id 31 confirmó la escritura mayoritaria; el resultado del INSERT de id 32 durante el aislamiento permanece no verificado. Capturas: `Capturas/2026-11-13_cockroachdb_e2_01_linea_base_tres_nodos.png`, `Capturas/2026-11-13_cockroachdb_e2_01_linea_base_tres_nodos_detalle.png`, `Capturas/2026-11-13_cockroachdb_e2_02_roach3_aislado_estado.png`, `Capturas/2026-11-13_cockroachdb_e2_02_03_aislamiento_y_mayoria_compuesta.png`, `Capturas/2026-11-13_cockroachdb_e2_03_lado_mayoritario_lectura_escritura.png`, `Capturas/2026-11-13_cockroachdb_e2_04_lado_aislado_sesion_sql.png`, `Capturas/2026-11-13_cockroachdb_e2_05_reconexion_fallida_roach3.png`, `Capturas/2026-11-13_cockroachdb_e2_06_reconexion_ip_original.png`, `Capturas/2026-11-13_cockroachdb_e2_07_tres_nodos_activos.png` y `Capturas/2026-11-13_cockroachdb_e2_08_verificacion_final_filas.png`.
- **Tiempo dedicado:** 35 min

### 2026-11-13
- **Qué hice:** Redacté la sección 3, «Análisis crítico a la Unidad 1». Reuní en 3.1 la transparencia de distribución, en 3.2 el modelo de comunicación, en 3.3 el CAP/PACELC y en 3.4 la tolerancia a fallos, y cerré con el contraste documental entre CockroachDB y Apache Cassandra, apoyado en las fuentes recopiladas.
- **Problema encontrado:** El esquema inicial era una lista de definiciones sin hilo argumental, y varias citas habían quedado después del punto final, fuera del formato numérico IEEE solicitado.
- **Cómo lo resolví:** Reordené los conceptos para que cada apartado desembocara en una comparación concreta entre ambos motores, trasladé las citas antes del punto en todo el documento y eliminé el párrafo que remitía a las capturas, porque esa información correspondía al anexo.
- **Tiempo dedicado:** 30 min

### 2026-11-13
- **Qué hice:** Preparé el Anexo B, «Capturas de lectura de las fuentes». Seleccioné cinco pasajes de los artículos citados en la sección 3, recorté la página correspondiente, subrayé el fragmento empleado y redacté el pie de cada figura con su número de referencia y la página.
- **Problema encontrado:** Las capturas completas de las páginas no permitían ubicar con rapidez el pasaje citado, y los pies indicaban la clave bibliográfica del archivo `.bib` en lugar del número que aparece en el texto.
- **Cómo lo resolví:** Generé los recortes con Pillow, dibujé el subrayado sobre el fragmento y guardé las versiones editadas junto a las originales en `Capturas/fuentes/`. Después reemplacé las claves de los pies por `\cite{}` para que se renderizaran como números, igual que en el resto de los párrafos.
- **Tiempo dedicado:** 30 min

### 2026-11-13
- **Qué hice:** Redacté la sección 4, «Experimentación propia», a partir de `experimento/comandos.md`. Describí el entorno y su justificación, los procedimientos de los dos experimentos con sus comandos, los resultados de cada motor con quince capturas de evidencia, dos tablas resumen, la interpretación, las conclusiones y las limitaciones.
- **Problema encontrado:** Los comandos y las capturas estaban repartidos en el registro de la práctica y no había mediciones de latencia que permitieran comparar rendimiento. Además, algunos listados largos se partían entre páginas y las rutas de los archivos de composición desbordaban el margen.
- **Cómo lo resolví:** Ordené el contenido en 4.1 a 4.5, referencié cada afirmación con las fuentes sobre quórum, replicación y niveles de consistencia, y remití a `experimento/comandos.md` para los pasos que no se reproducen en el informe. Compacté los listados, ajusté el ancho de las tablas, registré la versión de Docker empleada y verifiqué que no quedaran errores ni referencias sin resolver en la compilación.
- **Tiempo dedicado:** 30 min

### 2026-11-13
- **Qué hice:** Redacté la sección 7, «Postura crítica». En 7.1 expuse las fortalezas de cada motor, en 7.2 las limitaciones y los compromisos (trade-offs) y en 7.3 los contextos en los que ninguno de los dos sería la mejor opción, con las afirmaciones respaldadas por las fuentes y por lo observado en los experimentos.
- **Problema encontrado:** La sección 6 ya describía las diferencias, así que la postura crítica corría el riesgo de repetir la comparación. Además, algunas afirmaciones sobre latencia y rendimiento no tenían respaldo en el ensayo, porque no se registraron tiempos.
- **Cómo lo resolví:** Organicé la sección en fortalezas, limitaciones y contextos, y distinguí de forma explícita lo observado en E1 y E2 de lo que solo sostiene la documentación. Retiré las conclusiones de rendimiento y las reemplacé por el contraste entre coherencia sin configuración y disponibilidad graduable.
- **Tiempo dedicado:** 30 min

### 2026-11-13
- **Qué hice:** Redacté la sección 8, «Conclusiones». Formulé cinco conclusiones derivadas del análisis de la sección 3 y de los resultados de la sección 4: dónde se decide el compromiso, coincidencia entre el modelo y el ensayo, límite práctico de la transparencia, ajuste al requisito y alcance de la evidencia.
- **Problema encontrado:** Las conclusiones debían ser afirmaciones concretas y no una repetición de la teoría, y el ensayo no midió latencia ni escrituras concurrentes, por lo que varias comparaciones habituales entre ambos motores quedaban fuera de lo demostrable.
- **Cómo lo resolví:** Redacté cada conclusión con la evidencia que la sostiene y con su referencia, y cerré con el alcance del estudio. Verifiqué que las citas quedaran antes del punto, que no hubiera referencias sin resolver y que el documento compilara sin errores.
- **Tiempo dedicado:** 30 min

### 2026-11-13
- **Qué hice:** Redacté la sección 5, «Ejemplos del entorno del estudiante», con dos casos observados de primera mano: una transferencia recibida en la aplicación móvil de Banco Pichincha que no aparecía en el historial pero sí en la búsqueda por número, y una prueba de la plataforma de capacitaciones del CNE que no se marcó como completada hasta el día siguiente. Relacioné ambos con la consistencia de lectura, la transparencia de distribución y el compromiso de CAP.
- **Problema encontrado:** Los dos casos son observaciones de interfaz, sin acceso a la arquitectura de los servicios, así que no permitían afirmar una causa concreta. Además, la sección no debía convertirse en una denuncia de los servicios ni en una repetición de la teoría de la Unidad 1.
- **Cómo lo resolví:** Presenté cada caso como una hipótesis compatible con lo observado, distinguí la durabilidad del dato de su visibilidad y relacioné el comportamiento con lo medido en E1 y E2. Añadí las fuentes sobre consistencia eventual y niveles de consistencia donde correspondía, y cerré con la idea de que la coherencia entre vistas es lo que se percibe como confiabilidad.
- **Tiempo dedicado:** 25 min

### 2026-11-13
- **Qué hice:** Redacté el resumen con sus palabras clave, la introducción y la declaración de uso de inteligencia artificial. El resumen sintetiza el problema, la metodología y las conclusiones en 192 palabras, con su versión en inglés, y la introducción presenta el contexto, los objetivos, la metodología y la organización del documento. La declaración detalla los cuatro usos de la IA y la verificación aplicada.
- **Problema encontrado:** El resumen debía respetar el límite de 150 a 200 palabras y, a la vez, ocupar una página completa, lo que obligaba a cuidar el interlineado. La introducción debía llenar una carilla sin repetir la teoría de las secciones 3 y 4, y la declaración tenía que describir el uso real de la IA sin atribuirle los resultados.
- **Cómo lo resolví:** Ajusté el resumen a 192 palabras con interlineado amplio, añadí su traducción al inglés con las palabras clave y reservé una página para cada apartado. Amplié la introducción con la metodología y el alcance hasta completar la carilla, y redacté la declaración por tareas, aclarando que las fuentes se revisaron manualmente, que los comandos se ejecutaron y verificaron, y que la IA no generó datos experimentales.
- **Tiempo dedicado:** 25 min

### 2026-11-13
- **Qué hice:** Actualicé el `README.md` de la carpeta con los datos del informe, el enlace al video de presentación y las instrucciones de compilación: compilador, archivo principal, orden de comandos y dependencias. También corregí la estructura de carpetas y las rutas, que estaban desactualizadas.
- **Problema encontrado:** El README conservaba marcadores sin completar, nombraba las rutas en minúsculas (`referencias.bib`, `capturas/`) y no explicaba por qué se repite `pdflatex` ni qué se necesita para compilar. Un lector podía ejecutar los comandos en el orden incorrecto y obtener citas sin resolver.
- **Cómo lo resolví:** Probé la secuencia completa en una copia limpia de la carpeta, con `pdflatex`, `biber` y dos `pdflatex`, y verifiqué que generara el PDF de 33 páginas sin errores. Documenté los requisitos, las dependencias por paquete, los archivos indispensables, la limpieza de auxiliares y las dos advertencias inocuas de la compilación.
- **Tiempo dedicado:** 30 min
