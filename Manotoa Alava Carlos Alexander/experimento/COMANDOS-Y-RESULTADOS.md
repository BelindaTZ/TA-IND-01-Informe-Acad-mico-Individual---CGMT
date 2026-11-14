# Comandos y resultados de la práctica con Docker

Este registro se basa en las cuatro imágenes nuevas aportadas por el estudiante y en su archivo `docker-compose.yml`. La ejecución se realizó en `/home/carlos/Documentos/experimento`. El contenido siguiente es una transcripción y descripción de lo visible; no es el resultado de una ejecución nueva durante la organización del repositorio.

## 1. Inicio del entorno

Imagen original: `El clúster levantado.png`. Imagen organizada: `capturas/experimento/01-topologia.png`.

```bash
echo "Autor: carlos | Host: $(hostname) | Fecha: $(date)"
sudo docker compose up -d
sudo docker compose ps
```

Identificación visible:

```text
Autor: carlos | Host: cachyos-x8664 | Fecha: vie 13 nov 2026 18:52:35 -05
```

La captura muestra los cinco contenedores iniciados:

| Contenedor | Imagen | Estado mostrado |
|---|---|---|
| tidb-pd | pingcap/pd:v7.5.0 | Up |
| tidb-server | pingcap/tidb:v7.5.0 | Up |
| tidb-tikv1 | pingcap/tikv:v7.5.0 | Up |
| tidb-tikv2 | pingcap/tikv:v7.5.0 | Up |
| tidb-tikv3 | pingcap/tikv:v7.5.0 | Up |

Se muestran los puertos 2379 para PD y 4000 para TiDB. El aviso del atributo `version` obsoleto no detuvo el inicio. Un estado Up indica un proceso iniciado en el contenedor, no una verificación completa de salud.

## 2. Conexión y creación de la tabla

Imagen original: `base de datos preparada.png`. Imagen organizada: `capturas/experimento/02-dato-inicial.png`.

```bash
sudo docker run -it --rm --network experimento_default mysql:8.0 mysql -h tidb-server -P 4000 -u root
```

Versión del servidor que muestra el cliente:

```text
Server version: 8.0.11-TiDB-v7.5.0 TiDB Server (Apache License 2.0) Community Edition, MySQL 8.0 compatible
```

Instrucciones y resultados visibles:

```sql
CREATE DATABASE experimento;
USE experimento;
CREATE TABLE prueba (id INT AUTO_INCREMENT PRIMARY KEY, dato VARCHAR(100), fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
```

```text
Query OK, 0 rows affected (0.23 sec)
Database changed
Query OK, 0 rows affected (0.23 sec)
```

La imagen no incluye la instrucción de inserción del primer dato. La existencia de ese dato sí se observa en la consulta final. No se inventa una salida de INSERT inicial ni se utiliza la captura antigua de otro momento como si perteneciera a esta corrida.

## 3. Terminación del TiKV

Imagen original: `Simulamos caida.png`. Imagen organizada: `capturas/experimento/03-caida-tikv.png`.

```bash
echo "Autor: carlos | Host: $(hostname) | Fecha: $(date)"
sudo docker kill tidb-tikv1
sudo docker ps -a --filter name=tidb-tikv1
```

Identificación y datos relevantes visibles:

```text
Autor: carlos | Host: cachyos-x8664 | Fecha: vie 13 nov 2026 19:01:09 -05
tidb-tikv1
CONTAINER ID: ec5a5ae9320f
IMAGE: pingcap/tikv:v7.5.0
STATUS: Exited (137) Less than a second ago
NAMES: tidb-tikv1
```

Los campos finales se presentan como transcripción por campo para conservar su lectura, sin fingir que son un formato de salida nuevo. El comando `docker kill` usa SIGKILL por defecto. El reporte no determina si ese TiKV era líder de una Region de la tabla.

## 4. Operación posterior

Imagen original: `Prueba final.png`. Imagen organizada: `capturas/experimento/04-operacion-tras-caida.png`.

```sql
INSERT INTO prueba (dato) VALUES ('Insertado exitosamente tras la caida del nodo');
SELECT * FROM prueba;
```

Respuesta visible del INSERT:

```text
Query OK, 1 row affected (0.01 sec)
```

Valores visibles del SELECT:

| id | dato | fecha |
|---|---|---|
| 1 | Dato antes de la caida | 2026-11-13 23:59:28 |
| 2 | Insertado exitosamente tras la caida del nodo | 2026-11-14 00:02:53 |

```text
2 rows in set (0.00 sec)
```

La inserción y la consulta se aceptaron en ese momento. Los 0.01 s corresponden al INSERT y no miden el tiempo de recuperación desde el fallo. Las marcas SQL y la hora local de la terminación no se comparan directamente sin conocer la zona horaria configurada.

## Alcance y datos que faltan

La secuencia aportada documenta inicio, preparación, terminación de un TiKV e inserción posterior. No muestra el estado de todos los peers por Region, ni una verificación del TiKV terminado junto a la consulta final. La captura de creación de tabla y la captura SQL final no incluyen todos los datos personales/contextuales que la consigna pide en cada imagen. Eso debe completarse mediante nuevas capturas originales, conservando las actuales y separando corridas si se repite la ejecución.

El Compose real contiene un solo PD y un solo TiDB Server, además de los tres TiKV. No declara volúmenes persistentes ni política de reinicio. No se afirma alta disponibilidad de todas las capas ni conservación después de eliminar contenedores. Los intentos previos con TiUP son otro contexto y no se usan como resultados de este ensayo Docker.
