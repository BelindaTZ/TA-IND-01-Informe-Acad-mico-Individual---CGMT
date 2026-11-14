# BITÁCORA DE TRABAJO

**Estudiante:** Diego José Giraldo Cagua  
**Proyecto:** Análisis crítico comparativo de Facebook TAO y Amazon DynamoDB  
**Asignatura:** Sistemas Distribuidos  
**Repositorio:** https://github.com/BelindaTZ/TA-IND-01-Informe-Acad-mico-Individual---CGMT.git

---

## Jueves 12 de noviembre de 2026

Para desarrollar el trabajo seleccioné Facebook TAO como sistema principal y Amazon DynamoDB para realizar el análisis comparativo. Empecé a revisar las características generales de ambos sistemas, principalmente su arquitectura, almacenamiento de información y funcionamiento dentro de un entorno distribuido.

Durante la planificación encontré que Facebook TAO presenta una dificultad para realizar pruebas directamente, debido a que es una tecnología desarrollada para uso interno de Facebook. Por este motivo, será necesario investigar su funcionamiento mediante documentación técnica y buscar una alternativa que permita desarrollar una experimentación relacionada con su arquitectura, sin presentar resultados de otras herramientas como si fueran propios de TAO.

También revisé la posibilidad de utilizar DynamoDB Local para realizar las pruebas correspondientes a Amazon DynamoDB.

Finalmente, comencé a preparar los archivos de documentación del repositorio, incluyendo el README.md y la BITACORA.md, además de organizar las carpetas que utilizaré para guardar el informe, las referencias, las capturas y los resultados de los experimentos.

**Estado al finalizar la jornada:**

- Actividades formativas entregadas.
- Sistemas seleccionados para el análisis.
- Requisitos de la actividad revisados.
- Estructura inicial del proyecto planificada.
- Documentación inicial preparada.
- Pendiente continuar con la investigación de las arquitecturas y la configuración del entorno experimental.

---

## Viernes 13 de noviembre de 2026

Durante esta jornada continué trabajando en la parte práctica del proyecto. Configuré el entorno de Docker para ejecutar DynamoDB Local y utilicé AWS CLI para realizar las operaciones sobre una tabla denominada `Vehiculos`.

Primero comprobé el funcionamiento del servicio y creé la tabla utilizando el atributo `placa` como clave de partición. Después realicé operaciones de almacenamiento y consulta de información, utilizando como ejemplo los datos de un vehículo Chevrolet. También avancé con las operaciones de actualización y eliminación de registros.

Para respaldar el trabajo organicé las capturas de pantalla de las pruebas realizadas, procurando que se mostraran los datos de identificación del equipo y la fecha de ejecución. Asimismo, completé el esquema inicial de la arquitectura y su representación digital, y continué incorporando los avances al repositorio mediante commits.

Posteriormente realicé una prueba para observar el comportamiento del servicio cuando se interrumpe su ejecución. Detuve el contenedor de DynamoDB Local e intenté consultar las tablas mientras permanecía detenido. Como resultado, AWS CLI devolvió un error de conexión. Luego inicié nuevamente el contenedor y comprobé que el servicio volvía a estar activo, pero la tabla `Vehiculos` ya no aparecía y la consulta de sus registros devolvía un error indicando que la tabla no existía.

Este resultado permitió identificar una diferencia entre recuperar la ejecución de un servicio y recuperar la información que se encontraba almacenada. La prueba también mostró una limitación de la configuración local utilizada, ya que no se conservó la tabla después del reinicio. Por ello, este resultado se utilizará únicamente para analizar la instancia local y no como evidencia de pérdida de información en el servicio administrado de Amazon DynamoDB.

Después de completar estas pruebas, preparé la siguiente etapa de investigación sobre Facebook TAO. Debido a que no se dispone de una versión pública oficial para ejecutar su infraestructura, se decidió estudiar su arquitectura mediante documentación técnica y artículos académicos. Se planteó analizar su modelo de objetos y asociaciones, los servidores followers y leaders, la distribución mediante shards, las cachés y el almacenamiento persistente.

También se identificó la necesidad de profundizar en los mecanismos de consistencia, comunicación y tolerancia a fallos de TAO, para posteriormente compararlos con las características observadas en DynamoDB.

**Estado al finalizar la jornada:**

- Entorno de DynamoDB Local configurado y utilizado para las pruebas.
- Tabla `Vehiculos` creada y operaciones de almacenamiento y consulta realizadas.
- Operaciones de actualización y eliminación incorporadas al experimento.
- Pruebas de interrupción y reinicio del servicio realizadas.
- Pérdida de disponibilidad durante la interrupción observada.
- Tabla no disponible después del reinicio de la instancia local.
- Esquema manual y diagrama digital de arquitectura elaborados.
- Capturas originales de las pruebas organizadas.
- Commits de los avances incorporados al repositorio.
- Investigación documental de Facebook TAO planificada.

---
