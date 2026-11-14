# Comandos utilizados en el experimento

Durante las pruebas utilicé PowerShell, Docker y AWS CLI para trabajar con DynamoDB Local. Los comandos se ejecutaron desde Windows y se utilizó el puerto 8000 para establecer la conexión con la base de datos local.

## 1. Comprobación de herramientas

Primero revisé que Docker y AWS CLI estuvieran disponibles.

```powershell
docker --version
docker ps
aws --version
```

## 2. Ejecución de DynamoDB Local

Descargué la imagen de DynamoDB Local y ejecuté el contenedor mediante Docker.

```powershell
docker pull amazon/dynamodb-local
```

```powershell
docker run -d -p 8000:8000 --name dynamodb-local amazon/dynamodb-local
```

Para comprobar que estaba funcionando utilicé:

```powershell
docker ps
```

## 3. Configuración de AWS CLI

Como las pruebas se realizaron de forma local, utilicé credenciales de prueba y configuré la región de AWS.

```powershell
$env:AWS_ACCESS_KEY_ID="local"
$env:AWS_SECRET_ACCESS_KEY="local"
$env:AWS_DEFAULT_REGION="us-east-1"
```

La conexión con DynamoDB Local se comprobó mediante:

```powershell
aws dynamodb list-tables --endpoint-url http://localhost:8000
```

## 4. Creación de la tabla

Creé una tabla llamada Vehiculos. Utilicé la placa como clave principal para identificar cada registro.

```powershell
aws dynamodb create-table --table-name Vehiculos --attribute-definitions AttributeName=placa,AttributeType=S --key-schema AttributeName=placa,KeyType=HASH --billing-mode PAY_PER_REQUEST --endpoint-url http://localhost:8000
```

Para comprobar su creación utilicé:

```powershell
aws dynamodb list-tables --endpoint-url http://localhost:8000
```

También revisé su estructura:

```powershell
aws dynamodb describe-table --table-name Vehiculos --endpoint-url http://localhost:8000
```

## 5. Preparación de los registros

Para evitar problemas con las comillas del formato JSON en PowerShell, guardé la información de los vehículos en archivos independientes.

El primer archivo fue `vehiculo1.json`:

```json
{
  "placa": {"S": "PBC-2045"},
  "marca": {"S": "Chevrolet"},
  "anio": {"N": "2018"},
  "aprobado": {"BOOL": false}
}
```

El archivo se creó mediante:

```powershell
@'
{
  "placa": {"S": "PBC-2045"},
  "marca": {"S": "Chevrolet"},
  "anio": {"N": "2018"},
  "aprobado": {"BOOL": false}
}
'@ | Set-Content -Encoding ascii .\experimento\scripts\vehiculo1.json
```

## 6. Inserción del vehículo

Para guardar el registro utilicé el siguiente comando:

```powershell
aws dynamodb put-item --table-name Vehiculos --item file://experimento/scripts/vehiculo1.json --endpoint-url http://localhost:8000
```

## 7. Consulta de los registros

Finalmente, utilicé el comando scan para consultar los elementos almacenados en la tabla.

```powershell
aws dynamodb scan --table-name Vehiculos --endpoint-url http://localhost:8000
```

Este comando permitió revisar los atributos guardados y comprobar que la información se encontraba disponible.
