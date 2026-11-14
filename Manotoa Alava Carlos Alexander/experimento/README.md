# Práctica final documentada con Docker Compose

Esta es la práctica que respalda el informe reescrito. Contiene una copia sin modificar del Compose utilizado por el estudiante y una transcripción declarada de las cuatro capturas nuevas.

- `docker-compose.yml`: archivo real copiado desde el directorio del experimento.
- `COMANDOS-Y-RESULTADOS.md`: comandos, resultados legibles, contexto y límites.
- Las cuatro imágenes originales organizadas están en `capturas/experimento/` desde la raíz del informe.

## Reproducción desde un clon

Ejecutar desde la carpeta del informe cuando corresponda una corrida nueva y se haya comprobado el contexto. No ejecutar el arranque sobre la práctica existente ni eliminar contenedores para aparentar una repetición independiente. Docker y Docker Compose deben estar disponibles y el daemon en funcionamiento.

El nombre del proyecto se fija en `experimento` para reproducir la red `experimento_default` de las imágenes:

```bash
sudo docker compose -p experimento -f experimento/docker-compose.yml up -d
sudo docker compose -p experimento -f experimento/docker-compose.yml ps
```

Esperar a que el servicio SQL acepte conexiones; el estado Up por sí solo no es una prueba completa de salud. Conectar con el mismo método de la captura:

```bash
sudo docker run -it --rm --network experimento_default mysql:8.0 mysql -h tidb-server -P 4000 -u root
```

Las imágenes de PD, TiDB y TiKV están fijadas en v7.5.0 en el Compose. El cliente utiliza la etiqueta MySQL 8.0 que se ve en la captura; esa etiqueta puede actualizarse con el tiempo.

En una corrida realmente nueva, crear la base y tabla. El siguiente INSERT inicial es una instrucción propuesta para reproducir el valor de la tabla final: su orden original no aparece en la captura de preparación, así que no se presenta como transcripción de una ejecución aportada.

```sql
CREATE DATABASE experimento;
USE experimento;
CREATE TABLE prueba (
  id INT AUTO_INCREMENT PRIMARY KEY,
  dato VARCHAR(100),
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO prueba (dato) VALUES ('Dato antes de la caida');
SELECT * FROM prueba;
```

Si la base ya existe, detenerse y separar la corrida en lugar de borrar o mezclar evidencia. Para probar la caída sobre esta instalación local, la orden observada fue:

```bash
sudo docker kill tidb-tikv1
sudo docker ps -a --filter name=tidb-tikv1
```

Después, en el cliente SQL:

```sql
INSERT INTO prueba (dato) VALUES ('Insertado exitosamente tras la caida del nodo');
SELECT * FROM prueba;
```

Para completar la evidencia, mostrar también `docker compose ps -a` después de la operación, identidad y hora en cada captura, y una verificación de peers antes del fallo. Si se repite la práctica, registrar la salida real, incluidos errores. No asumir elección de líder o tiempo de recuperación a partir de una sola operación.

La zona horaria puede comprobarse en una sesión posterior con:

```sql
SELECT @@session.time_zone, @@global.time_zone, @@system_time_zone,
       NOW(), UTC_TIMESTAMP();
```

Esta consulta es una comprobación propuesta, no una salida que forme parte de las imágenes recibidas. El cierre, el respaldo y la conservación de los datos deben decidirse antes de eliminar contenedores: este Compose no declara volúmenes persistentes.
