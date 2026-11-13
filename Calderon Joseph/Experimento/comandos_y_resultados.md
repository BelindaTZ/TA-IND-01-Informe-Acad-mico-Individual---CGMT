# Registro de comandos y resultados de etcd

**Actividad:** TA-IND-01 — Análisis Crítico de Sistemas Distribuidos  
**Estudiante:** Calderón Saltos Joseph Alexander  
**Fecha:** 12 de noviembre de 2026  
**Sistema:** etcd 3.7.3

## 1. Objetivo y entorno

Se configuró un clúster de tres nodos de etcd para observar cómo responde cuando pierde a su líder. La prueba consistió en guardar datos, detener un nodo, comprobar si las escrituras continuaban funcionando y reincorporar el miembro desconectado.

Se utilizó Windows 11, Docker Desktop 4.99.0 y Docker Engine 29.9.3. Los nodos `etcd1`, `etcd2` y `etcd3` se ejecutaron en contenedores independientes, con volúmenes persistentes definidos en `compose.yaml`.

## 2. Preparación del clúster

Los comandos iniciales fueron:

`docker compose config --quiet`  
`docker compose up -d`  
`docker compose ps`

El primer intento de inicio falló porque Windows rechazó el uso del puerto `12379`, asignado a `etcd2`. Para solucionarlo se quitaron las publicaciones de puertos de `etcd2` y `etcd3` en el archivo Compose. Ambos conservaron sus conexiones internas dentro de Docker.

Después de guardar los cambios y ejecutar nuevamente `docker compose up -d`, los tres contenedores iniciaron correctamente.

## 3. Pruebas y resultados

### Prueba 1. Estado inicial

Se consultaron los tres miembros mediante:

`docker exec ta-etcd1 etcdctl --endpoints=http://etcd1:2379,http://etcd2:2379,http://etcd3:2379 endpoint status -w table`

Los tres respondieron. `etcd3` figuraba como líder, mientras que `etcd1` y `etcd2` eran seguidores. Todos mostraron el término Raft 3, el índice 11 y el índice aplicado 11.

Estos datos permitieron identificar al líder y comprobar que los miembros habían aplicado entradas hasta la misma posición del registro.

**Captura:** `01_estado_cluster.png`

### Prueba 2. Escritura y lectura

Se guardó un valor mediante `etcd1`:

`docker exec ta-etcd1 etcdctl --endpoints=http://etcd1:2379 put /ta-ind-01/prueba "Replicacion-etcd"`

El comando respondió `OK`. Después se consultó desde `etcd2`:

`docker exec ta-etcd2 etcdctl --endpoints=http://etcd2:2379 get /ta-ind-01/prueba`

La consulta devolvió la clave `/ta-ind-01/prueba` y el valor `Replicacion-etcd`.

El resultado comprobó que un dato confirmado podía consultarse desde otro miembro del clúster.

**Captura:** `02_escritura_lectura.png`

### Prueba 3. Caída del líder

Para reproducir el fallo se utilizó la instrucción:

`docker compose stop etcd3`

El estado posterior se comprobó con:

`docker compose ps`

`docker exec ta-etcd1 etcdctl --endpoints=http://etcd1:2379,http://etcd2:2379 endpoint status -w table`

Con `etcd3` detenido, los otros dos miembros continuaron activos. `etcd1` apareció como nuevo líder y el término Raft aumentó de 3 a 4.

El cambio de término y de líder es consistente con una nueva elección. Al conservar dos de los tres miembros, el clúster mantuvo la mayoría necesaria para el consenso.

**Captura:** `03_caida_lider.png`

### Prueba 4. Escritura durante el fallo

Sin reiniciar `etcd3`, se ejecutó una escritura a través de `etcd2`:

`docker exec ta-etcd2 etcdctl --endpoints=http://etcd2:2379 put /ta-ind-01/durante-fallo "quorum-2-de-3"`

La respuesta fue `OK`. Luego se consultó desde `etcd1`:

`docker exec ta-etcd1 etcdctl --endpoints=http://etcd1:2379 get /ta-ind-01/durante-fallo`

Se recuperó el valor `quorum-2-de-3`.

Esta fue la comprobación principal del experimento: **el clúster aceptó una nueva escritura aun cuando uno de sus tres nodos permanecía detenido**.

**Captura:** `04_escritura_durante_fallo.png`

### Prueba 5. Recuperación del nodo

Para reincorporar el miembro detenido se ejecutó:

`docker compose start etcd3`

Después se comprobó el estado de los contenedores y del clúster:

`docker compose ps`

`docker exec ta-etcd1 etcdctl --endpoints=http://etcd1:2379,http://etcd2:2379,http://etcd3:2379 endpoint status -w table`

Los tres miembros volvieron a responder. `etcd1` permaneció como líder y todos mostraron el término Raft 4, con índice e índice aplicado en 16.

Finalmente, se consultó desde el nodo recuperado:

`docker exec ta-etcd3 etcdctl --endpoints=http://etcd3:2379 get /ta-ind-01/durante-fallo`

`etcd3` devolvió el valor `quorum-2-de-3`, que había sido escrito mientras estaba desconectado.

La prueba confirmó que, después de reincorporarse, el nodo podía consultar el dato registrado durante su ausencia.

**Captura:** `05_recuperacion_nodo.png`

## 4. Análisis de los resultados

En la primera consulta, `etcd3` era el líder. Después de detenerlo, `etcd1` asumió ese papel y el término Raft aumentó. La elección permitió continuar las operaciones con los dos miembros restantes.

El punto más importante fue la escritura realizada durante el fallo. `etcd2` aceptó el dato y `etcd1` pudo consultarlo. Esto muestra que, en la configuración utilizada, perder un nodo no impidió confirmar nuevas escrituras mientras se conservó el quórum.

También se comprobó la recuperación. Al reiniciar `etcd3`, sus índices coincidieron con los de los demás miembros y pudo consultar la información creada durante su ausencia.

La prueba tiene límites. No se midieron tiempos de recuperación ni latencia, tampoco se realizaron particiones de red o pruebas de carga. Por eso, los resultados describen el comportamiento observado en este clúster local y no permiten afirmar cómo respondería ante cualquier fallo.

## 5. Conclusión

El clúster de etcd mantuvo las escrituras después de perder a su líder, eligió otro y permitió recuperar la información desde el nodo reincorporado. La prueba mostró la importancia de conservar una mayoría de miembros para continuar operando.

Consultar únicamente si los contenedores estaban activos habría sido insuficiente. Las operaciones de escritura, lectura y consulta del estado Raft permitieron comprobar qué sucedió durante el fallo y después de la recuperación.
