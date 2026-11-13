# Experimentos — TA-IND-01: CockroachDB vs. Apache Cassandra

> Plantilla: reemplaza todo lo que dice `COMPLETAR` con tus datos reales.
> Pega comandos y salidas tal como salieron, sin editarlos.
> Antes de cada paso ejecuta `Get-Date` en PowerShell o `date` en Bash para registrar la hora; comprueba también que la terminal permita identificar la sesión.
> Nombra las capturas como `capturas/AAAA-MM-DD_descripcion.png` y menciónalas aquí y en `BITACORA.md`.

---

## 0. Entorno (común a ambos experimentos)

| Dato | CockroachDB | Apache Cassandra |
|---|---|---|
| Versión | COMPLETAR | COMPLETAR |
| Imagen Docker | COMPLETAR | COMPLETAR |
| Nº de nodos | COMPLETAR | COMPLETAR |
| Factor de replicación | COMPLETAR | COMPLETAR |
| Nivel de consistencia usado | COMPLETAR | COMPLETAR |
| Máquina / SO / Docker | COMPLETAR | COMPLETAR |

**Cómo levanté los clústeres:** COMPLETAR (comandos o archivo `docker-compose.yml` usado).

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

**Registro:** Estas hipótesis se formularon antes de los ensayos y se incorporan ahora al documento desde las notas previas. La hipótesis de Cassandra queda pendiente de contrastar cuando se ejecute ese ensayo.

### Procedimiento — CockroachDB

| Paso | Qué hago | Comando | Captura |
|---|---|---|---|
| 1 | Compruebo que los tres nodos estén activos y disponibles | <code>docker compose ps</code>; <code>docker exec -it roach1 cockroach node status --certs-dir=/certs --host=roach1:26257</code> | [Línea base: estado del clúster](../Capturas/2026-11-13_cockroachdb_e1_01_linea_base_estado_cluster.png) |
| 2 | Creo la base y la tabla, inserto tres filas y consulto datos y rango | SQL desde roach1: CREATE DATABASE, USE prueba, CREATE TABLE, INSERT, SELECT y SHOW RANGES | [Línea base: datos y rango 87](../Capturas/2026-11-13_cockroachdb_e1_02_linea_base_datos_rango87.png) |
| 3 | Detengo roach2 y verifico lectura, escritura y persistencia de la fila 4 | docker stop roach2; docker compose ps -a; SQL por roach1 | [roach2 detenido: lectura y escritura](../Capturas/2026-11-13_cockroachdb_e1_03_roach2_detenido_lectura_escritura.png) |
| 4 | Detengo roach3 e intento consultar con dos nodos detenidos | docker stop roach3; docker compose ps -a; SQL por roach1 | [Dos nodos detenidos: pérdida de quórum](../Capturas/2026-11-13_cockroachdb_e1_04_dos_nodos_caidos_perdida_quorum.png) |
| 5 | Inicio roach2 y roach3, compruebo la recuperación SQL, registro el estado anómalo de roach1, lo reinicio y verifico nodos y datos | docker start roach2 roach3; node status; consultas SQL; docker restart roach1; node status final | [Recuperación SQL](../Capturas/2026-11-13_cockroachdb_e1_05_recuperacion_sql_nodos_levantados.png); [roach1 anómalo](../Capturas/2026-11-13_cockroachdb_e1_06_roach1_estado_inconsistente_logs.png); [reinicio y consulta final](../Capturas/2026-11-13_cockroachdb_e1_07_reinicio_roach1_consulta_final_rango88.png); [estado final](../Capturas/2026-11-13_cockroachdb_e1_08_estado_final_tras_reinicio_roach1.png) |

### Procedimiento — Cassandra

Este ensayo aún está **pendiente de ejecución**. Mantén cass1 activo como coordinador y prueba cada nivel por separado. Cassandra puede tardar unos segundos en reflejar `DN` en `nodetool status`; registra la salida después de que el estado se estabilice. Usa una clave distinta en cada intento para distinguir los datos nuevos. Ejecuta `CONSISTENCY <nivel>;` antes de cada lectura o escritura y anota resultado, error o tiempo de espera.

| Paso | Qué hago | Comandos de referencia | Captura |
|---|---|---|---|
| 1 | Registro versión, estado inicial y datos base | `Get-Date`; `docker exec cass1 nodetool version`; `docker exec cass1 nodetool status`; desde `cqlsh`: `CONSISTENCY QUORUM; SELECT * FROM prueba.datos;` | Pendiente |
| 2 | Detengo cass2; espero a que aparezca `DN` y pruebo lectura y escritura con `ONE`, `QUORUM` y `ALL` | `docker stop cass2`; `docker exec cass1 nodetool status`; desde `cqlsh`, para cada nivel: `CONSISTENCY <nivel>; INSERT INTO prueba.datos (id, valor) VALUES (<id_unico>, '<nivel>_un_nodo'); SELECT * FROM prueba.datos WHERE id = <id_unico>;` | Pendiente |
| 3 | Detengo cass3; espero a que se refleje la segunda caída y repito las operaciones por nivel | `docker stop cass3`; `docker exec cass1 nodetool status`; desde `cqlsh`, repetir el bloque anterior con nuevos `<id_unico>` y el sufijo `dos_nodos` | Pendiente |
| 4 | Inicio cass2 y cass3, verifico que vuelvan a `UN` y leo con `ALL` las claves de prueba | `docker start cass2 cass3`; `docker exec cass1 nodetool status`; desde `cqlsh`: `CONSISTENCY ALL; SELECT * FROM prueba.datos WHERE id IN (<ids_de_prueba>);` | Pendiente |

No registres las respuestas esperadas como resultados: completa la sección siguiente solo con salidas observadas y capturas del ensayo.

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

Pendiente de ejecutar el Experimento 1 para Cassandra. Registrar aquí los comandos efectivamente ejecutados, sus salidas, los errores o tiempos de espera y las capturas. No hay resultados todavía.

```
COMPLETAR: comandos y salidas reales
```

| Situación | CockroachDB | Cassandra |
|---|---|---|
| Todos los nodos activos | Tres nodos disponibles; rango 87 con votantes {1,2,3}. | COMPLETAR |
| 1 nodo caído | Lectura y escritura continuaron con roach2 detenido; la fila 4 persistió. | COMPLETAR |
| 2 nodos caídos | Se observó replica unavailable al consultar; la salida con SQLSTATE XXUUU aparece parcialmente en la captura 04. | COMPLETAR |
| Tras recuperar los nodos | Se reportó la recuperación de lecturas y escrituras; tras reiniciar roach1, las consultas finales mostraron las filas 1, 2, 3, 4 y 6, y node status confirmó los tres nodos activos. | COMPLETAR |

### Interpretación

- ¿Coincidieron los resultados con las hipótesis planteadas? Pendiente de analizar los resultados frente a cada predicción.
- Relación con CAP/PACELC y con la tolerancia a fallos: con un nodo detenido, el clúster conservó el quórum y permitió leer y escribir. Al detener dos nodos, la mayoría dejó de estar disponible y se reportó pérdida de quórum al abrir SQL. Estos resultados documentan la tolerancia a fallos del clúster en esta prueba; no permiten por sí solos concluir sobre una partición de red.

---

## Experimento 2 — Partición de red (CAP)

**Concepto de la Unidad 1:** teorema CAP (consistencia vs. disponibilidad ante una partición).

**Pregunta:** COMPLETAR

**Hipótesis formuladas antes de los ensayos**

- **E2, CockroachDB:** Si aíslo una réplica y las otras dos siguen comunicándose, espero que el lado mayoritario pueda confirmar una escritura cuando el rango mantenga quórum; una escritura nueva desde el lado aislado no debería confirmarse. Registraré también si las lecturas terminan o quedan esperando.
- **E2, Cassandra:** En una partición 2+1, si el cliente puede acceder a un coordinador en cada lado, espero que `ONE` pueda operar en ambos lados; `QUORUM` debería completarse solo en el lado con dos réplicas y `ALL` no debería completarse en ninguno. Con `ONE`, una lectura podría devolver una versión anterior. La observación depende de la conectividad real del cliente y de las réplicas, que verificaré durante la prueba. Predicción basada en `apacheCassandraDynamo`, niveles de consistencia.

**Registro:** Hipótesis formuladas antes de ejecutar el experimento; completar con la fecha y las condiciones previstas.

### Procedimiento (repetir en cada sistema)

| Paso | Qué hago | Comando | Captura |
|---|---|---|---|
| 1 | Verifico el estado inicial y la hora (`date`) | COMPLETAR | COMPLETAR |
| 2 | Aíslo un nodo del resto (por ejemplo con `docker network disconnect <red> <nodo>`) | COMPLETAR | COMPLETAR |
| 3 | Intento escribir y leer desde el lado aislado | COMPLETAR | COMPLETAR |
| 4 | Intento escribir y leer desde el lado con mayoría | COMPLETAR | COMPLETAR |
| 5 | Reconecto el nodo (`docker network connect <red> <nodo>`) y verifico qué pasó con los datos | COMPLETAR | COMPLETAR |

### Resultados

**CockroachDB**

```
COMPLETAR: comandos y salidas reales
```

**Cassandra**

```
COMPLETAR: comandos y salidas reales
```

| Situación | CockroachDB | Cassandra |
|---|---|---|
| Lado aislado: ¿acepta escrituras? ¿lecturas? | COMPLETAR | COMPLETAR |
| Lado con mayoría: ¿acepta escrituras? ¿lecturas? | COMPLETAR | COMPLETAR |
| Tras reconectar: ¿datos consistentes? ¿cómo se reconcilian? | COMPLETAR | COMPLETAR |

### Interpretación

- ¿Coincidieron los resultados con las hipótesis planteadas? COMPLETAR
- Qué priorizó cada sistema (consistencia o disponibilidad) y cómo se refleja en CAP: COMPLETAR

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
