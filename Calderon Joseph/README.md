\# TA-IND-01 — Análisis crítico de etcd



\*\*Estudiante:\*\* Calderón Saltos Joseph Alexander  

\*\*Universidad:\*\* Universidad Técnica Estatal de Quevedo  

\*\*Carrera:\*\* Ingeniería de Software  

\*\*Asignatura:\*\* Aplicaciones Distribuidas (ISR-701)  

\*\*Actividad:\*\* TA-IND-01 — Informe Académico Individual



\## Sistema analizado



El trabajo analiza etcd, un almacén distribuido de clave-valor utilizado para configuración y coordinación de servicios. Se estudian su arquitectura, las transparencias de distribución, CAP, PACELC, los modelos de comunicación y la tolerancia a fallos.



Se compara con Apache ZooKeeper, considerando sus mecanismos de consenso, consistencia, comunicación y recuperación.



\## Experimento realizado



El 12 de noviembre de 2026 se ejecutó un clúster de tres nodos de etcd 3.7.3 mediante Docker Compose en Windows 11.



Las pruebas incluyeron:



1\. Consulta del estado inicial e identificación del líder.

2\. Escritura y lectura de datos desde miembros diferentes.

3\. Detención del líder y elección de otro miembro.

4\. Escritura y lectura con dos nodos activos.

5\. Reincorporación del nodo detenido y consulta del dato registrado durante el fallo.



El líder inicial fue `etcd3`. Después de detenerlo, `etcd1` asumió el liderazgo y el término Raft pasó de 3 a 4. Las escrituras continuaron con dos miembros disponibles. Al reiniciar `etcd3`, este pudo consultar el dato creado durante su ausencia.



Los resultados corresponden a una prueba local de detención y recuperación de un nodo. No se realizaron particiones de red ni mediciones de latencia.



\## Archivos del trabajo



\- `main.tex`: borrador del informe académico en LaTeX.

\- `Referencias/referencias.bib`: referencias bibliográficas en formato BibLaTeX.

\- `Anexos/`: bosquejo a mano y diagrama de arquitectura elaborado en draw.io.

\- `Experimento/compose.yaml`: configuración del clúster.

\- `Experimento/comandos\_y\_resultados.md`: comandos, resultados e interpretación de las pruebas.

\- `Experimento/Capturas/`: cinco capturas originales del experimento.

\- `BITACORA.md`: registro de las sesiones de trabajo.



\## Reproducción del experimento



Se requiere Docker Desktop con Docker Compose.



Desde la carpeta `Experimento`, ejecutar:



```powershell

docker compose up -d

docker compose ps

```



Para consultar el estado del clúster:



```powershell

docker exec ta-etcd1 etcdctl --endpoints=http://etcd1:2379,http://etcd2:2379,http://etcd3:2379 endpoint status -w table

```



Las demás operaciones están registradas en `Experimento/comandos\_y\_resultados.md`.



Para detener los contenedores sin borrar sus volúmenes:



```powershell

docker compose stop

```



\## Compilación del informe



El documento utiliza LaTeX, BibLaTeX y el estilo bibliográfico IEEE.



\*\*Herramientas necesarias:\*\* pdfLaTeX, Biber y una distribución de LaTeX con los paquetes `babel`, `graphicx`, `booktabs`, `tabularx`, `array`, `caption`, `biblatex`, `hyperref`, `geometry` y `lmodern`.



Desde la carpeta `Calderon Joseph`, ejecutar en este orden:



```powershell

pdflatex main.tex

biber main

pdflatex main.tex

pdflatex main.tex

```



La compilación definitiva está pendiente de verificar. Antes deben incorporarse las entradas bibliográficas faltantes y las tres capturas de lectura citadas en `main.tex`.



\## Video de sustentación



\*\*Estado:\*\* pendiente de grabación y publicación.



El enlace al video de 3 a 5 minutos se incorporará aquí una vez que esté disponible.



\## Estado del trabajo



El experimento está terminado y documentado. Se incorporó el borrador inicial del informe.



Quedan pendientes los ejemplos personales, las capturas anotadas de tres artículos, la revisión final de las referencias, la compilación del PDF y el video de sustentación.

