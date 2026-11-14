# Organización de la carpeta del informe

Se preservaron los archivos recibidos en `respaldo-antes-de-ordenar.zip`, con inventario SHA-256 en `INVENTARIO-INICIAL.json`. El respaldo es local y está excluido de Git mediante la regla de esta carpeta.

Las imágenes y el draw.io se renombraron y movieron sin alterar sus bytes. Se añadió el diagrama TikZ que faltaba. Se restauró el Compose utilizado en la práctica desde la copia ya verificada en esta conversación; el archivo del repositorio estaba vacío. El informe apunta ahora a `experimento/docker-compose.yml` y `experimento/COMANDOS-Y-RESULTADOS.md`.

El README ahora describe TiDB/YugabyteDB. La bitácora conserva sus actividades y tiempos originales; únicamente se quitó una envoltura de bloque Markdown y se alinearon sus encabezados. Las menciones históricas de Kafka/RabbitMQ permanecen como parte del cambio de tema registrado por el estudiante.

No se ejecutó el experimento, no se añadieron resultados ni evidencias de lectura y no se hicieron commits o push. No se modificó la carpeta superior del repositorio ni se inspeccionaron carpetas de otros estudiantes.

## Rutas reorganizadas

- `figuras/Arquitectura TiDB.drawio` → `figuras/arquitectura-original.drawio`
- `figuras/Arquitectura TiDB.png` → `figuras/arquitectura-original.png`
- `figuras/Boceto hecho a mano.jpeg` → `figuras/boceto-original.jpeg`
- `capturas/El clúster levantado.png` → `capturas/experimento/01-topologia.png`
- `capturas/base de datos preparada.png` → `capturas/experimento/02-dato-inicial.png`
- `capturas/Simulamos caida.png` → `capturas/experimento/03-caida-tikv.png`
- `capturas/Prueba final.png` → `capturas/experimento/04-operacion-tras-caida.png`
- `capturas/preparación del entorno.png` → `capturas/preparacion/01-entorno.png`
- `capturas/clone del repositorio oficial.png` → `capturas/preparacion/02-clon-repositorio.png`
- `capturas/revisión de la configuración del clúster.png` → `capturas/preparacion/03-configuracion.png`
- `capturas/descarga las imagenes y levanta de los contenedores.png` → `capturas/preparacion/04-descarga-e-inicio.png`
- `capturas/preparacion de datos de prueba.png` → `capturas/preparacion/05-datos-prueba.png`
- `capturas/Inserción.png` → `capturas/preparacion/06-insercion.png`
