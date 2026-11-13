# Bitácora de trabajo — TA-IND-01

**Estudiante:** Calderón Saltos Joseph Alexander  
**Sistema:** etcd  
**Comparación:** Apache ZooKeeper

## 11 de noviembre de 2026

**Actividad:** Selección del sistema distribuido y preparación inicial del repositorio.

**Avances:**

* Se seleccionó etcd como sistema principal.
* Se eligió Apache ZooKeeper para la comparación.
* Se organizaron seis referencias académicas sobre Raft, consenso y pruebas de sistemas distribuidos.
* Se preparó la estructura inicial de la documentación.

**Aspectos por revisar:**

* Leer las fuentes seleccionadas y extraer los datos necesarios para el informe.
* Preparar el primer esquema de arquitectura.

**Horario de trabajo:** 23:01 a 23:25.
**Tiempo dedicado:** 24 minutos.

**Estado:** Preparación inicial. No se han realizado pruebas experimentales.

## 

## \## 12 de noviembre de 2026



\*\*Actividad:\*\* Diseño de la arquitectura, ejecución del clúster de etcd y preparación del informe.



\*\*Avances:\*\*



\- Elaboré el bosquejo inicial de la arquitectura y su versión digital en draw.io.

\- Configuré tres nodos de etcd 3.7.3 mediante Docker Compose en Windows 11.

\- Comprobé el estado del clúster e identifiqué a `etcd3` como líder inicial.

\- Realicé operaciones de escritura y lectura desde diferentes nodos.

\- Detuve `etcd3` y comprobé que `etcd1` asumió el liderazgo.

\- Verifiqué que el clúster continuaba aceptando escrituras con dos nodos activos.

\- Reinicié `etcd3` y comprobé que recuperaba el dato registrado durante su ausencia.

\- Guardé cinco capturas y documenté los comandos y resultados del experimento.

\- Subí la estructura inicial del informe en LaTeX.



\*\*Dificultad encontrada:\*\*



Windows rechazó la publicación del puerto `12379`, lo que impidió iniciar correctamente `etcd2`.



\*\*Solución:\*\*



Retiré las publicaciones de puertos de `etcd2` y `etcd3` en `compose.yaml`. Ambos mantuvieron la comunicación interna mediante la red de Docker y el clúster pudo iniciarse.



\*\*Pendiente:\*\*



Completar los dos ejemplos personales, revisar las referencias, obtener las capturas de lectura de artículos, comprobar la compilación del informe y preparar el video de sustentación.



\*\*Horario registrado en GitHub:\*\* 17:42 a 21:22.



\*\*Intervalo entre el primer y último commit:\*\* 3 horas y 40 minutos. El tiempo efectivo puede variar si hubo pausas.



\*\*Estado:\*\* Experimento documentado y borrador inicial del informe incorporado al repositorio.

