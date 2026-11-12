
# TA-IND-01 — Análisis de etcd

**Estudiante:** Calderón Saltos Joseph Alexander  
**Asignatura:** Aplicaciones Distribuidas (ISR-701)  
**Actividad:** TA-IND-01 — Informe Académico Individual  
**Universidad:** Universidad Técnica Estatal de Quevedo  

## Sistema seleccionado

- Principal: etcd
- Sistema de comparación: Apache ZooKeeper

etcd es un almacén distribuido de clave-valor utilizado para tareas de coordinación y configuración. Utiliza el algoritmo de consenso Raft para mantener un estado replicado entre los miembros de un clúster.

Apache ZooKeeper se utilizará como referencia comparativa, ya que también ofrece mecanismos de coordinación distribuida, aunque con una arquitectura y un protocolo de consenso diferentes.

## Enfoque del informe

El análisis se centrará en:

1. Arquitectura y comunicación entre componentes.
2. Transparencias de distribución.
3. CAP y PACELC.
4. Modelos de comunicación.
5. Consistencia, replicación y tolerancia a fallos.
6. Comparación crítica entre etcd y ZooKeeper.

## Experimentación prevista

Se planea ejecutar un clúster de tres nodos de etcd utilizando Docker en Windows 11.

El experimento consistirá en almacenar y consultar datos, identificar el líder, detener un nodo y observar el comportamiento del clúster durante el fallo y la recuperación.

Las capturas, los comandos, las salidas y el análisis se incorporarán después de realizar las pruebas. No se presentan resultados experimentales en esta etapa.

## Bibliografía

Las fuentes académicas iniciales están en `Referencias/referencias.bib`.

El informe utilizará LaTeX con BibLaTeX y estilo IEEE.

## Estado actual

Etapa inicial: selección del sistema, definición de la comparación y organización de referencias académicas.

Pendiente: diagrama propio, experimentación, análisis comparativo, informe completo, anexos y video de sustentación.

Las instrucciones de compilación se agregarán cuando se cree y compruebe el archivo principal de LaTeX.
