
# Resultados del experimento

## 1. Preparación del entorno

La primera parte del trabajo consistió en preparar el entorno para realizar las pruebas. Utilicé Docker para ejecutar DynamoDB Local y AWS CLI para enviar los comandos desde PowerShell.

Al principio tuve que resolver algunos inconvenientes relacionados con la instalación de AWS CLI y la configuración de las variables de entorno. Una vez solucionados, pude establecer la conexión con la base de datos local.

La primera consulta mediante `list-tables` devolvió una lista vacía. Esto era normal porque todavía no había creado ninguna tabla.

## 2. Creación de la tabla Vehiculos

Después creé la tabla Vehiculos y utilicé el atributo placa como clave principal.

La respuesta de AWS CLI indicó que la tabla se encontraba en estado ACTIVE. También ejecuté `describe-table` para revisar su estructura y comprobar que la clave principal estaba configurada correctamente.

En ese momento la tabla tenía cero registros.

## 3. Inserción de información

Para comprobar el almacenamiento de información preparé un registro correspondiente a un vehículo Chevrolet.

Los datos utilizados fueron:

| Atributo | Valor |
|---|---|
| Placa | PBC-2045 |
| Marca | Chevrolet |
| Año | 2018 |
| Aprobado | false |

Durante esta parte encontré un problema al enviar el JSON directamente desde PowerShell. AWS CLI recibía el contenido sin las comillas necesarias y rechazaba la operación.

Para solucionarlo guardé los datos en un archivo JSON y utilicé la opción `file://` al ejecutar el comando `put-item`.

Con este procedimiento pude insertar el registro correctamente.

## 4. Consulta de información

Después de insertar el vehículo ejecuté el comando `scan` para revisar los datos almacenados.

La consulta devolvió el registro con su placa, marca, año y estado de aprobación.

El resultado mostró:

- Registros encontrados: 1.
- Registros examinados: 1.
- Placa consultada: PBC-2045.

Con esta prueba comprobé que la información insertada podía recuperarse desde DynamoDB Local.

## 5. Problemas encontrados durante las pruebas

Durante la configuración y ejecución del experimento aparecieron algunos inconvenientes.

El primero fue que AWS CLI no estaba instalado. Lo solucioné instalando la versión 2 para Windows.

También tuve que configurar nuevamente las variables de entorno al abrir otra sesión de PowerShell, porque la región y las credenciales de prueba no estaban disponibles en esa ventana.

Otro inconveniente apareció al enviar objetos JSON directamente como parámetros de AWS CLI. PowerShell modificaba las comillas y el comando no podía interpretar correctamente los datos. La solución fue guardar la información en archivos JSON y utilizar `file://` para enviarlos.

Finalmente, organicé los archivos del experimento dentro de una carpeta de trabajo en Documentos, para mantenerlos separados de los directorios del sistema operativo.

## 6. Observaciones

Las pruebas realizadas permitieron comprobar que DynamoDB Local puede recibir información mediante AWS CLI y devolver los registros almacenados.

También pude observar que la identificación de los elementos depende de la clave principal definida al crear la tabla. En este caso utilicé la placa del vehículo.

El uso de DynamoDB Local permitió realizar las operaciones de prueba sin conectarme al servicio de DynamoDB en la nube.

**Estado de las pruebas:** creación de tabla e inserción y consulta de un registro comprobadas. Las operaciones de actualización y eliminación quedan pendientes de registrar cuando se ejecuten correctamente.
