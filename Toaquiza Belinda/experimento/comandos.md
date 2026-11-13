# Experimentos — TA-IND-01: CockroachDB vs. Apache Cassandra

> Plantilla: reemplaza todo lo que dice `COMPLETAR` con tus datos reales.
> Pega comandos y salidas tal como salieron, sin editarlos.
> Antes de cada paso ejecuta `Get-Date` en PowerShell o `date` en Bash para registrar la hora; comprueba también que la terminal permita identificar la sesión.
> Nombra las capturas como `capturas/AAAA-MM-DD_descripcion.png` y menciónalas aquí y en `BITACORA.md`.

---

## 0. Entorno (común a ambos experimentos)

| Dato | CockroachDB | Apache Cassandra |
|---|---|---|
| Versión | COMPLETAR | 5.0.9 (cqlsh) |
| Imagen Docker | COMPLETAR | `cassandra:5.0` |
| Nº de nodos | COMPLETAR | 3 (`cass1`, `cass2`, `cass3`), en `dc1` |
| Factor de replicación | COMPLETAR | 3 en el keyspace `prueba` |
| Nivel de consistencia usado | COMPLETAR | Preparación: `QUORUM`; pruebas: `ONE`, `QUORUM` y `ALL` |
| Máquina / SO / Docker | COMPLETAR | PowerShell en `DESKTOP-OCH81AB`; versión de Docker no registrada |

**Cómo levanté los clústeres:** CockroachDB: COMPLETAR. Cassandra: desde `experimento/cassandra`, ejecuté `docker compose up -d`; `docker compose ps` mostró los tres contenedores activos y saludables.

```
COMPLETAR: comandos de arranque y salida de `docker ps`
```

Captura: `capturas/COMPLETAR.png`

**Limitaciones del entorno:** COMPLETAR (por ejemplo, todos los nodos corren en una sola máquina, así que la latencia de red no es real).

---

## Experimento 1 — Caída de nodos (tolerancia a fallos)

**Concepto de la Unidad 1:** tolerancia a fallos, replicación y consenso.

**Pregunta:** ¿Qué ocurre con las lecturas y escrituras en CockroachDB y Cassandra cuando se detiene uno de los tres nodos y cuando solo queda una réplica disponible?

**Hipótesis formuladas antes de los ensayos**

- **CockroachDB:** Si se detiene un nodo y quedan dos de las tres réplicas votantes disponibles, espero que el clúster pueda confirmar lecturas actuales y escrituras cuando el rango conserve el quórum Raft, aunque una elección de líder o la renovación de la concesión pueda causar una espera. Si se detiene un segundo nodo, espero que las operaciones que requieren ese quórum no se confirmen.
- **Cassandra:** Con RF=3 y cass1 como coordinador accesible, si se detiene un nodo espero que las operaciones con consistencia `ONE` y `QUORUM` puedan completarse, mientras que `ALL` no. Si se detienen dos nodos, espero que solo `ONE` pueda completarse desde la única réplica disponible; `QUORUM` y `ALL` deberían fallar o expirar por falta de respuestas. Comprobaré por separado lecturas y escrituras, porque cada operación puede producir un resultado o tiempo de espera distinto. Esta predicción se basa en los niveles de consistencia descritos por `apacheCassandraDynamo`.

**Registro:** Las hipótesis se formularon antes de los ensayos. Los resultados de Cassandra documentados a continuación permiten contrastar la predicción para ese sistema.

### Procedimiento — CockroachDB

| Paso | Qué hago | Comando | Captura |
|---|---|---|---|
| 1 | Compruebo que los tres nodos estén activos y disponibles | <code>docker compose ps</code>; <code>docker exec -it roach1 cockroach node status --certs-dir=/certs --host=roach1:26257</code> | [Línea base: estado del clúster](../Capturas/2026-11-13_cockroachdb_e1_01_linea_base_estado_cluster.png) |
| 2 | Creo la base y la tabla, inserto tres filas y consulto datos y rango | SQL desde roach1: CREATE DATABASE, USE prueba, CREATE TABLE, INSERT, SELECT y SHOW RANGES | [Línea base: datos y rango 87](../Capturas/2026-11-13_cockroachdb_e1_02_linea_base_datos_rango87.png) |
| 3 | Detengo roach2 y verifico lectura, escritura y persistencia de la fila 4 | docker stop roach2; docker compose ps -a; SQL por roach1 | [roach2 detenido: lectura y escritura](../Capturas/2026-11-13_cockroachdb_e1_03_roach2_detenido_lectura_escritura.png) |
| 4 | Detengo roach3 e intento consultar con dos nodos detenidos | docker stop roach3; docker compose ps -a; SQL por roach1 | [Dos nodos detenidos: pérdida de quórum](../Capturas/2026-11-13_cockroachdb_e1_04_dos_nodos_caidos_perdida_quorum.png) |
| 5 | Inicio roach2 y roach3, compruebo la recuperación SQL, registro el estado anómalo de roach1, lo reinicio y verifico nodos y datos | docker start roach2 roach3; node status; consultas SQL; docker restart roach1; node status final | [Recuperación SQL](../Capturas/2026-11-13_cockroachdb_e1_05_recuperacion_sql_nodos_levantados.png); [roach1 anómalo](../Capturas/2026-11-13_cockroachdb_e1_06_roach1_estado_inconsistente_logs.png); [reinicio y consulta final](../Capturas/2026-11-13_cockroachdb_e1_07_reinicio_roach1_consulta_final_rango88.png); [estado final](../Capturas/2026-11-13_cockroachdb_e1_08_estado_final_tras_reinicio_roach1.png) |

### Procedimiento — Cassandra

La ejecución se realizó desde PowerShell con Cassandra 5.0.9 en tres nodos (`cass1`, `cass2`, `cass3`) del datacenter `dc1`; el keyspace `prueba` usó factor de replicación 3. En cada etapa se cambió el nivel con `CONSISTENCY` y se registraron las respuestas inmediatas y las lecturas posteriores por separado.

| Paso | Qué hice | Comando / evidencia | Captura |
|---|---|---|---|
| 1 | Levanté el clúster, comprobé versión y estado de los nodos | `docker compose up -d`; `docker compose ps`; `docker exec -it cass1 nodetool status`; `docker exec cass1 nodetool version` | [Línea base: estado y versión](../Capturas/2026-11-13_cassandra_e1_01_linea_base_estado_version.png) |
| 2 | Preparé el keyspace, tabla y filas iniciales con `QUORUM` | `CREATE KEYSPACE prueba WITH replication = {'class': 'NetworkTopologyStrategy', 'dc1': 3};`; creación de `prueba.datos`; `CONSISTENCY QUORUM`; inserción y lectura de IDs 1–3 | [Datos base](../Capturas/2026-11-13_cassandra_e1_02_datos_base_consistency_quorum.png) |
| 3 | Consulté las réplicas de la clave 1 | `docker exec cass1 nodetool getendpoints prueba datos 1` | [Endpoints de las réplicas](../Capturas/2026-11-13_cassandra_e1_03_endpoints_replicas_datos.png) |
| 4 | Detuve `cass2`, confirmé su estado `DN` y probé operaciones con un nodo caído | `docker stop cass2`; `docker compose ps -a`; `docker exec -it cass1 nodetool status`; en `cqlsh`, lecturas/escrituras con `ONE`, `QUORUM` y `ALL` | [cass2 detenido y operaciones](../Capturas/2026-11-13_cassandra_e1_04_cass2_detenido_estado_y_pruebas.png); [lecturas posteriores](../Capturas/2026-11-13_cassandra_e1_05_un_nodo_verificacion_lecturas.png) |
| 5 | Detuve `cass3` y repetí consultas y escrituras por nivel con un nodo vivo | `docker stop cass3`; `docker exec -it cass1 nodetool status`; en `cqlsh`, operaciones con `ONE`, `QUORUM` y `ALL` | [Dos nodos detenidos y respuestas](../Capturas/2026-11-13_cassandra_e1_06_dos_nodos_estado_y_consistency.png) |
| 6 | Inicié `cass2` y `cass3`, observé la convergencia del estado y consulté los datos con `ALL` | `docker start cass2 cass3`; `docker compose ps -a`; `docker exec -it cass1 nodetool status`; `CONSISTENCY ALL; SELECT * FROM prueba.datos;` | [Recuperación y lectura final](../Capturas/2026-11-13_cassandra_e1_07_recuperacion_tres_un_y_lectura_all.png) |

Las capturas 04 y 06 contienen tanto el estado de los nodos como parte de las operaciones de CQL; la captura 07 reúne el primer estado tras el arranque, el estado posterior con los tres nodos `UN` y la lectura final con `ALL`.
### Resultados

**CockroachDB**

### Línea base — 13 de noviembre, 10:54:16 y 10:56:02

La primera captura muestra los tres nodos activos y disponibles. La segunda muestra la consola CockroachDB CCL v26.4.0.

Comandos ejecutados:
    docker compose up -d
    docker compose ps
    docker exec -it roach1 cockroach node status --certs-dir=/certs --host=roach1:26257
    docker exec -it roach1 cockroach sql --certs-dir=/certs --host=roach1:26257

La salida de node status mostró is_available=true e is_live=true para los nodos 1, 2 y 3.

Comandos SQL:
    CREATE DATABASE prueba;
    USE prueba;
    CREATE TABLE datos (id INT PRIMARY KEY, valor STRING);
    INSERT INTO datos VALUES (1, 'a'), (2, 'b'), (3, 'c');
    SELECT * FROM datos ORDER BY id;
    SHOW RANGES FROM TABLE datos;
    \q

Salidas visibles:
    CREATE DATABASE
    SET
    CREATE TABLE
    INSERT 0 3

    id | valor
    1  | a
    2  | b
    3  | c
    (3 rows)

Extracto visible de SHOW RANGES:
    range_id | replicas | voting_replicas
    87       | {1,2,3}  | {1,2,3}
    (1 row)

Capturas: ../Capturas/2026-11-13_cockroachdb_e1_01_linea_base_estado_cluster.png y ../Capturas/2026-11-13_cockroachdb_e1_02_linea_base_datos_rango87.png.

### Un nodo detenido — 11:13:42

Se ejecutó docker stop roach2, cuya salida visible fue:
    roach2

En docker compose ps -a, roach1 y roach3 aparecieron Up 20 minutes y roach2 como Exited (137) About a minute ago. La consulta SELECT * FROM datos ORDER BY id; devolvió las filas 1, 2 y 3.

Se ejecutó:
    INSERT INTO datos VALUES (4, 'un_nodo_caido');

Salida visible:
    INSERT 0 1

Comprobación:
    SELECT * FROM datos WHERE id = 4;

La captura muestra:
    id | valor
    4  | un_nodo_caido
    (1 row)

La lectura y la escritura siguieron funcionando con dos de las tres réplicas votantes; la fila 4 persistió. Captura: ../Capturas/2026-11-13_cockroachdb_e1_03_roach2_detenido_lectura_escritura.png.

### Dos nodos detenidos — captura de las 13:23 (04)

La captura muestra la salida de docker compose ps -a:
    roach1: Up 22 minutes
    roach2: Exited (137) 3 minutes ago
    roach3: Exited (137) 3 seconds ago

Se intentó abrir SQL por roach1 y ejecutar SELECT * FROM datos ORDER BY id;. La captura deja ver este extracto del error; el mensaje se extiende más allá del borde derecho:
    warning: unable to retrieve the server's version: ERROR: replica unavailable ...
    ... (SQLSTATE XXUUU)

La cronología de la sesión identifica el error como pérdida de quórum al acceder al rango r8. El SELECT no produjo resultado confirmado y el INSERT de la fila 5 no se probó. Se salió de la consola con \q y se continuó desde otra terminal. La hora terminal no aparece en esta imagen; 13:23 corresponde a la hora del nombre del archivo. Captura: ../Capturas/2026-11-13_cockroachdb_e1_04_dos_nodos_caidos_perdida_quorum.png.

### Recuperación SQL — 13:25:13 (captura 05)

Desde otra terminal se ejecutó:
    docker start roach2 roach3

Salidas visibles:
    roach2
    roach3

node status confirmó roach2 y roach3 activos. Para el nodo 1 aún mostraba address=NULL, is_available=true e is_live=false. Después, SQL volvió a responder:

    SELECT * FROM datos ORDER BY id;

    id | valor
    1  | a
    2  | b
    3  | c
    4  | un_nodo_caido
    (4 rows)

    INSERT INTO datos VALUES (6, 'cluster_recuperado');

    INSERT 0 1

    SELECT * FROM datos WHERE id = 6;

    6 | cluster_recuperado
    (1 row)

Esto confirma la recuperación SQL antes del reinicio de roach1, aunque node status aún lo marcaba como no activo. Captura: ../Capturas/2026-11-13_cockroachdb_e1_05_recuperacion_sql_nodos_levantados.png.

### Estado anómalo y reinicio posterior de roach1 — 13:31:45 a 13:38:17 (capturas 06, 07 y 08)

La captura de las 13:31:45 muestra los contenedores activos, pero node status todavía reportaba para el nodo 1:
    id | address | sql_address | build | is_available | is_live
    1  | NULL    | NULL        | NULL  | true         | false

En esa captura se ejecutó docker logs --since 15m --tail 100 roach1; no aparece salida antes del siguiente prompt.

A las 13:33:52 se reinició únicamente roach1:
    docker restart roach1
    roach1

Después, node status consultado desde roach2 volvió a mostrar address=roach1:26257, is_available=true e is_live=true para el nodo 1. La consulta final por roach1 mostró las filas 1, 2, 3, 4 y 6. SHOW RANGES mostró el rango 88 con voting_replicas={1,2,3}. La causa del cambio del rango 87 al 88 y del estado anómalo previo de roach1 no quedó verificada.

A las 13:38:17, node status mostró los tres nodos con is_available=true e is_live=true. Así se distingue la recuperación SQL tras iniciar los nodos del reinicio posterior de roach1, que corrigió su estado en node status. Capturas: ../Capturas/2026-11-13_cockroachdb_e1_06_roach1_estado_inconsistente_logs.png, ../Capturas/2026-11-13_cockroachdb_e1_07_reinicio_roach1_consulta_final_rango88.png y ../Capturas/2026-11-13_cockroachdb_e1_08_estado_final_tras_reinicio_roach1.png.
**Cassandra**

#### Línea base — 14:31:08 a 14:44:51

Desde PowerShell inicié el clúster con `docker compose up -d`. `docker compose ps` mostró `cass1`, `cass2` y `cass3` saludables; `nodetool status` reportó los tres como `UN` en `dc1`. La imagen usada fue `cassandra:5.0`; `nodetool version` y el banner de `cqlsh` indicaron la versión exacta Cassandra 5.0.9. Preparé el keyspace `prueba` con `NetworkTopologyStrategy` y `dc1: 3`, la tabla `prueba.datos` y las filas iniciales `(1, 'a')`, `(2, 'b')` y `(3, 'c')`. Con `CONSISTENCY QUORUM`, la consulta devolvió las tres filas. `nodetool getendpoints prueba datos 1` mostró como endpoints `172.28.0.12`, `172.28.0.11` y `172.28.0.13`.

Capturas: [estado y versión](../Capturas/2026-11-13_cassandra_e1_01_linea_base_estado_version.png), [datos base](../Capturas/2026-11-13_cassandra_e1_02_datos_base_consistency_quorum.png) y [endpoints](../Capturas/2026-11-13_cassandra_e1_03_endpoints_replicas_datos.png).

#### Un nodo detenido — 15:00:36

`docker stop cass2` devolvió `cass2`. `docker compose ps -a` mostró `cass2` detenido y `nodetool status` lo identificó como `DN` en `172.28.0.12`; `cass1` (`172.28.0.11`) y `cass3` (`172.28.0.13`) seguían `UN`. `cqlsh` continuó accesible a través de `cass1`.

- Con `ONE`, `SELECT * FROM prueba.datos WHERE id = 1;` devolvió `1 | a`. La escritura de `(4, 'un_caido_one')` no mostró error inmediato; una lectura posterior con `QUORUM` confirmó la fila 4.
- Con `QUORUM`, otra lectura de la clave 1 devolvió `1 | a`. La escritura de `(5, 'un_caido_quorum')` no mostró error inmediato; la lectura posterior con `QUORUM` confirmó la fila 5.
- Con `ALL`, la lectura de la clave 1 y la escritura de `(6, 'un_caido_all')` devolvieron `NoHostAvailable` con `Unavailable`, `required_replicas: 3` y `alive_replicas: 2`. La captura muestra el detalle `Cannot achieve consistency level ALL`; el intento de escritura de la fila 6, por tanto, sí quedó registrado como fallido.

Capturas: [estado y pruebas con cass2 detenido](../Capturas/2026-11-13_cassandra_e1_04_cass2_detenido_estado_y_pruebas.png) y [lecturas posteriores de las filas 4 y 5](../Capturas/2026-11-13_cassandra_e1_05_un_nodo_verificacion_lecturas.png).

#### Dos nodos detenidos — 15:30:59

Después de detener `cass3`, `nodetool status` mostró `cass1` (`172.28.0.11`) como único `UN`; `cass2` (`172.28.0.12`) y `cass3` (`172.28.0.13`) aparecieron `DN`. Se pudo abrir `cqlsh` por `cass1`.

- Con `ALL`, tanto `SELECT * FROM prueba.datos;` como la lectura de la clave 1 devolvieron `Unavailable`: se requerían 3 réplicas y había 1 disponible. La escritura de `(9, 'dos_caidos_all')` también devolvió error con `required_replicas: 3`, `alive_replicas: 1`.
- Con `QUORUM`, la lectura de la clave 1 falló con `required_replicas: 2`, `alive_replicas: 1`. La escritura de `(8, 'dos_caidos_quorum')` también falló con ese requisito de dos respuestas.
- Con `ONE`, la lectura de la clave 1 devolvió `1 | a`. La escritura de `(7, 'dos_caidos_one')` no mostró error inmediato y la lectura siguiente devolvió `7 | dos_caidos_one`.

La evidencia permite distinguir las operaciones que Cassandra rechazó por falta de respuestas de las que completó en el nivel `ONE`. Captura: [dos nodos detenidos, estado y respuestas de consistencia](../Capturas/2026-11-13_cassandra_e1_06_dos_nodos_estado_y_consistency.png).

#### Recuperación y lectura final — desde 15:34:50

`docker start cass2 cass3` devolvió ambos nombres. En la primera consulta inmediata a `nodetool status`, `cass1` aparecía `UN` y los otros dos aún `DN`. Después, `docker compose ps -a` mostró los tres contenedores `Up (healthy)` y una nueva consulta de `nodetool status` mostró los tres nodos `UN`, sin que se vea otro reinicio. La indicación `Up About a minute` es el tiempo aproximado desde el arranque de los contenedores, no una medición exacta de recuperación del clúster.

Con `CONSISTENCY ALL`, `SELECT * FROM prueba.datos;` terminó y devolvió seis filas: IDs 1, 2, 3, 4, 5 y 7. No aparecieron los IDs 6, 8 ni 9; los intentos de escritura correspondientes ya muestran errores en las capturas de las etapas previas. La lectura final confirma que la fila 7 era visible después de la recuperación, pero no identifica por sí misma el mecanismo de sincronización de las réplicas.

Captura: [primer estado tras el arranque, tres nodos UN y lectura final con ALL](../Capturas/2026-11-13_cassandra_e1_07_recuperacion_tres_un_y_lectura_all.png).

| Situación | CockroachDB | Cassandra |
|---|---|---|
| Todos los nodos activos | Tres nodos disponibles; rango 87 con votantes {1,2,3}. | Tres nodos `UN` en `dc1`, RF=3; filas iniciales 1–3. Los endpoints de la clave 1 fueron 172.28.0.12, .11 y .13. |
| 1 nodo caído | Lectura y escritura continuaron con roach2 detenido; la fila 4 persistió. | `ONE` y `QUORUM`: lectura de id 1 y escrituras de ids 4 y 5 verificadas después; `ALL` lectura y escritura fallaron (`required_replicas=3`, `alive_replicas=2`), incluida la fila 6. |
| 2 nodos caídos | Se observó replica unavailable al consultar; la salida con SQLSTATE XXUUU aparece parcialmente en la captura 04. | `ONE`: lectura de id 1 y escritura/lectura de id 7 completadas. `QUORUM` falló (2 requeridas, 1 viva); `ALL` falló (3 requeridas, 1 viva), también en escrituras de ids 8 y 9. |
| Tras recuperar los nodos | Se reportó la recuperación de lecturas y escrituras; tras reiniciar roach1, las consultas finales mostraron las filas 1, 2, 3, 4 y 6, y node status confirmó los tres nodos activos. | Primer status: 1 `UN`, 2 `DN`; después, contenedores saludables y 3 `UN` sin reinicio adicional. `ALL` leyó seis filas (1, 2, 3, 4, 5 y 7). |

### Interpretación

- **¿Coincidieron los resultados con las hipótesis?** Sí, en los comportamientos observados. CockroachDB mantuvo las operaciones cuando el rango conservó mayoría y dejó de confirmar la consulta al perderla. Cassandra, con un nodo detenido, completó lecturas y escrituras en `ONE` y `QUORUM`, mientras `ALL` falló por exigir tres respuestas. Con dos nodos detenidos, `ONE` permitió leer y escribir en la única réplica disponible; `QUORUM` y `ALL` fallaron por no alcanzar dos y tres respuestas, respectivamente.
- **Comparación de mecanismos:** CockroachDB coordina cada rango mediante réplicas votantes Raft y requiere mayoría para confirmar operaciones que dependen de ese rango. Cassandra permite escoger el número mínimo de respuestas mediante el nivel CQL: en esta prueba `ONE` mantuvo acceso a una réplica aunque la mayoría de nodos estuviera caída; `QUORUM` y `ALL` aplicaron requisitos mayores. Por eso la disponibilidad observada con dos nodos detenidos fue distinta, aunque ambos sistemas operaban con tres réplicas.
- **Recuperación y alcance:** En Cassandra, el primer `nodetool status` tras iniciar `cass2` y `cass3` todavía mostraba dos `DN`; después, sin otro reinicio visible, el estado convergió a tres `UN` y la consulta con `ALL` devolvió las seis filas presentes. Esto no demuestra por sí solo qué mecanismo sincronizó las réplicas ni cuánto tardó exactamente la recuperación. El ensayo mide disponibilidad ante caídas de nodos; no prueba particiones de red ni permite concluir sobre el intercambio latencia-consistencia de PACELC.
---

## Experimento 2 — Partición de red (CAP)

**Concepto de la Unidad 1:** teorema CAP (consistencia vs. disponibilidad ante una partición).

**Pregunta:** ¿Cómo afecta una partición de red 2+1 las lecturas y escrituras de Cassandra según el nivel de consistencia, y qué datos pueden leerse después de reconectar el nodo aislado?

**Hipótesis formuladas antes de los ensayos**

- **E2, CockroachDB:** Si aíslo una réplica y las otras dos siguen comunicándose, espero que el lado mayoritario pueda confirmar una escritura cuando el rango mantenga quórum; una escritura nueva desde el lado aislado no debería confirmarse. Registraré también si las lecturas terminan o quedan esperando.
- **E2, Cassandra:** En una partición 2+1, si el cliente puede acceder a un coordinador en cada lado, espero que `ONE` pueda operar en ambos lados; `QUORUM` debería completarse solo en el lado con dos réplicas y `ALL` no debería completarse en ninguno. Con `ONE`, una lectura podría devolver una versión anterior. La observación depende de la conectividad real del cliente y de las réplicas, que verificaré durante la prueba. Predicción basada en `apacheCassandraDynamo`, niveles de consistencia.

**Registro:** La hipótesis de Cassandra se formuló antes de ejecutar este experimento. La parte de CockroachDB queda pendiente.

### Procedimiento — Cassandra

Cassandra 5.0.9 se ejecutó en Docker Compose con tres nodos en `dc1`, RF=3 para `prueba.datos`. Aislé `cass3` de `cassandra-lab_cassnet` conservando el proceso activo y lo consulté por `127.0.0.1`.

| Paso | Qué hice | Comandos y observaciones | Captura |
|---|---|---|---|
| 1 | Confirmé el aislamiento de cass3 | A las 16:25:51 `docker compose ps` aún mostraba cass3 `Up (healthy)`, mientras `nodetool status` mostraba `172.28.0.13` como `DN` y los otros nodos `UN`; `docker inspect cass3 --format '{{range $nombre, $red := .NetworkSettings.Networks}}{{$nombre}} {{$red.IPAddress}}{{println}}{{end}}'` no listó redes para cass3. A las 16:26:00 repetí `docker network disconnect $red cass3`; Docker indicó que el contenedor ya no estaba conectado a `cassandra-lab_cassnet`. | [cass3 aislado y desconexión confirmada](../Capturas/2026-11-13_cassandra_e2_01_cass3_aislado_estado_confirmacion.png) |
| 2 | Probé lecturas y escrituras desde cass3 aislado | `docker exec -it cass3 cqlsh 127.0.0.1 9042`; con `ONE`, leí id 1 e inserté y leí id 21; con `QUORUM`, intenté leer id 1 e insertar id 22. | [Lado aislado: ONE y QUORUM](../Capturas/2026-11-13_cassandra_e2_02_lado_aislado_one_quorum.png) |
| 3 | Probé lecturas y escrituras desde el lado de cass1 y cass2 | `docker exec -it cass1 cqlsh`; con `ONE` y `QUORUM`, leí id 1 e inserté ids 23 y 24; con `ALL`, intenté leer id 1 e insertar id 25. | [Lado mayoritario: ONE, QUORUM y ALL](../Capturas/2026-11-13_cassandra_e2_03_lado_mayoritario_one_quorum_all.png) |
| 4 | Reconecté cass3 con su IP original y comprobé el estado del clúster | A las 16:28:51 ejecuté `docker network connect --ip $ipCass3 $red cass3`, con `$ipCass3='172.28.0.13'` y `$red='cassandra-lab_cassnet'`; después `docker exec cass1 nodetool status` mostró tres nodos `UN`. | [Reconexión y estado de tres nodos UN](../Capturas/2026-11-13_cassandra_e2_04_reconexion_tres_nodos_un_y_lectura_all.png) |
| 5 | Verifiqué la visibilidad posterior con ALL | Desde `cqlsh` en cass1 ejecuté `CONSISTENCY ALL; SELECT * FROM prueba.datos WHERE id IN (21, 22, 23, 24, 25, 26);`. La salida mostró los IDs 21, 23 y 24. | [Lectura ALL incluida en la captura de reconexión](../Capturas/2026-11-13_cassandra_e2_04_reconexion_tres_nodos_un_y_lectura_all.png) |

La última imagen reúne la reconexión, el estado final de tres nodos `UN` y la lectura `ALL`; no existe una captura separada de esa consulta. El tiempo exacto que tardó Cassandra en marcar `cass3` como `DN` no se midió.

### Procedimiento — CockroachDB

Pendiente de ejecutar la parte del Experimento 2 para CockroachDB. No se incluye aquí una comparación experimental entre los dos motores.

### Resultados

**CockroachDB**

```
COMPLETAR: comandos y salidas reales
```

**Cassandra**

#### cass3 aislado — 16:25:51 y 16:26:00

A las 16:25:51 `docker compose ps` todavía mostraba el contenedor `cass3` como `Up (healthy)`, pero `docker exec cass1 nodetool status` ya reportaba la IP original `172.28.0.13` como `DN`; `cass1` y `cass2` figuraban `UN`. La inspección de las redes de `cass3` no listó ninguna red. A las 16:26:00, al repetir `docker network disconnect $red cass3`, Docker respondió: `Error response from daemon: container ... is not connected to network cassandra-lab_cassnet`. Ese mensaje confirmó que ya estaba aislado. No se midió cuánto tardó la detección.

El proceso Cassandra de `cass3` siguió encendido y aceptó la conexión local `docker exec -it cass3 cqlsh 127.0.0.1 9042`:

- Con `ONE`, `SELECT * FROM prueba.datos WHERE id = 1;` devolvió `1 | a`. El `INSERT` de `(21, 'particion_aislado_one')` volvió al prompt sin error; la lectura posterior de id 21 devolvió esa fila.
- Con `QUORUM`, la lectura de id 1 y el `INSERT` de `(22, 'particion_aislado_quorum')` devolvieron `NoHostAvailable` con `Unavailable`, `required_replicas: 2` y `alive_replicas: 1`.
- `ALL` no se probó desde el lado aislado.

Capturas: [estado del aislamiento](../Capturas/2026-11-13_cassandra_e2_01_cass3_aislado_estado_confirmacion.png) y [operaciones locales ONE/QUORUM](../Capturas/2026-11-13_cassandra_e2_02_lado_aislado_one_quorum.png).

#### Lado mayoritario — dos nodos conectados

Desde `cqlsh` en `cass1`, las lecturas de id 1 con `ONE` y `QUORUM` devolvieron `1 | a`. Los `INSERT` de `(23, 'particion_mayoria_one')` y `(24, 'particion_mayoria_quorum')` regresaron al prompt sin error visible. Con `ALL`, tanto la lectura de id 1 como el `INSERT` de `(25, 'particion_mayoria_all')` devolvieron `Unavailable`, con `required_replicas: 3` y `alive_replicas: 2`.

Captura: [pruebas desde el lado mayoritario](../Capturas/2026-11-13_cassandra_e2_03_lado_mayoritario_one_quorum_all.png).

#### Reconexión y lectura posterior — 16:28:51

Reconecté `cass3` usando su IP original `172.28.0.13`. `nodetool status` mostró los tres nodos `UN`. Después, `CONSISTENCY ALL; SELECT * FROM prueba.datos WHERE id IN (21, 22, 23, 24, 25, 26);` devolvió exactamente:

    21 | particion_aislado_one
    23 | particion_mayoria_one
    24 | particion_mayoria_quorum
    (3 rows)

Las escrituras de IDs 21, 23 y 24 quedaron visibles tras la reconexión. Las operaciones de IDs 22 y 25 habían devuelto error durante la partición; la escritura del ID 26 no se intentó, aunque se incluyó en la búsqueda final. Como se usaron claves distintas, la evidencia muestra disponibilidad por nivel y visibilidad posterior, pero no prueba la reconciliación de escrituras concurrentes sobre una misma clave ni identifica el mecanismo exacto de sincronización.

Captura: [reconexión, tres nodos UN y lectura final con ALL](../Capturas/2026-11-13_cassandra_e2_04_reconexion_tres_nodos_un_y_lectura_all.png).

| Situación | CockroachDB | Cassandra |
|---|---|---|
| Lado aislado: ¿acepta escrituras? ¿lecturas? | Pendiente de medir | Con `ONE`, lectura de id 1 y escritura/lectura de id 21 funcionaron por `127.0.0.1`; `QUORUM` lectura y escritura fallaron (2 requeridas, 1 viva); `ALL` no se probó. |
| Lado con mayoría: ¿acepta escrituras? ¿lecturas? | Pendiente de medir | `ONE` y `QUORUM`: lectura de id 1 y escrituras de ids 23 y 24 sin error visible; `ALL` lectura y escritura fallaron (3 requeridas, 2 vivas). |
| Tras reconectar: ¿datos consistentes? ¿cómo se reconcilian? | Pendiente de medir | Los tres nodos quedaron `UN`; `ALL` devolvió ids 21, 23 y 24. La reconciliación de escrituras concurrentes y el mecanismo de sincronización no se verificaron. |

### Interpretación

- **¿Coincidió Cassandra con la hipótesis?** Parcialmente confirmado con los niveles probados: `ONE` permitió leer y escribir en ambos lados; `QUORUM` solo completó las operaciones en el lado de dos nodos; `ALL` falló en ese lado. `ALL` no se probó en `cass3` aislado, así que esa parte de la hipótesis queda sin verificar.
- **Lectura de la partición:** `cass3` permaneció encendido y atendió por `127.0.0.1`; el aislamiento cortó su conexión con los pares, a diferencia de la caída de procesos del Experimento 1. Con `ONE`, cada lado pudo operar usando una respuesta de réplica. `QUORUM` necesitó dos respuestas y por eso solo funcionó en el lado mayoritario. `ALL` necesitó las tres y falló allí cuando solo había dos disponibles.
- **Reconciliación y comparación:** Tras reconectar `cass3`, una lectura `ALL` mostró las filas nuevas 21, 23 y 24. Como se escribieron IDs distintos, no se probó un conflicto sobre la misma clave ni quedó determinado el mecanismo exacto de sincronización. La parte de CockroachDB del Experimento 2 está pendiente; la comparación experimental entre ambos motores también queda pendiente.
---

## Opcional — Latencia (parte EL/EC de PACELC)

Solo si te sobra tiempo. Repite cada medición al menos 10 veces y reporta promedio y variación.

| Sistema | Tipo de lectura / nivel de consistencia | Repeticiones | Promedio | Variación |
|---|---|---|---|---|
| COMPLETAR | COMPLETAR | COMPLETAR | COMPLETAR | COMPLETAR |

---

## Limitaciones y reproducibilidad

- Limitaciones generales del experimento: COMPLETAR
- Cómo repetirlo desde cero (versiones, archivos, comandos): COMPLETAR
