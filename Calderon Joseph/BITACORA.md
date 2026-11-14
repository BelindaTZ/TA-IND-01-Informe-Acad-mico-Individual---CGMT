Bitácora de trabajo — TA-IND-01

Estudiante: Calderón Saltos Joseph Alexander  
Sistema analizado: etcd  
Sistema de comparación: Apache ZooKeeper

11 de noviembre de 2026

Actividad: Selección del sistema y preparación del repositorio.

Avances:

Seleccioné etcd para el análisis.

Elegí Apache ZooKeeper como sistema de comparación.

Organicé seis referencias académicas relacionadas con Raft, consenso y pruebas de sistemas distribuidos.

Preparé la estructura inicial del trabajo.

Aspectos pendientes: Revisar las fuentes y preparar el esquema de arquitectura.

Horario de trabajo: 23:01 a 23:25.  
Tiempo dedicado: 24 minutos.

12 de noviembre de 2026

Actividad: Diseño de arquitectura y ejecución del experimento.

Avances:

Elaboré el bosquejo de arquitectura y su versión digital en draw.io.

Configuré un clúster de tres nodos con etcd 3.7.3 en Docker Desktop.

Identifiqué a etcd3 como líder inicial.

Comprobé la escritura y lectura de información desde diferentes miembros.

Detuve etcd3 y observé que etcd1 asumió el liderazgo.

Realicé una nueva escritura con dos miembros activos.

Reinicié etcd3 y comprobé que recuperaba la información.

Guardé cinco capturas y documenté los comandos y resultados.

Dificultad: Windows rechazó la publicación del puerto 12379.

Solución: Retiré las publicaciones de puertos de etcd2 y etcd3, manteniendo su comunicación por la red interna de Docker.

Intervalo: 17:42:56 a 21:32:49 

Tiempo efectivo dedicado: 3 h 49 min 53 s (con pausas de intermedio)

13 de noviembre de 2026

Actividad: Revisión del informe, compilación y preparación de la sustentación.

Avances:

Revisé el análisis técnico de etcd y la comparación con Apache ZooKeeper.

Comprobé las referencias académicas y sus DOI.

Incorporé los ejemplos del SGA de la UTEQ y WhatsApp.

Revisé las capturas de lectura y su relación con las citas del informe.

Corregí errores de LaTeX relacionados con la portada y la bibliografía.

Compilé el informe mediante pdfLaTeX y Biber.

Revisé el PDF generado, incluyendo sus referencias y anexos.

Preparé y grabé el video de sustentación con OBS.

Publiqué el video en YouTube.

Dificultades: Durante la preparación aparecieron problemas de compilación en LaTeX, un bosquejo con orientación incorrecta y una fuente de micrófono silenciada en OBS.

Soluciones: Se corrigió el código de la portada, se verificaron las rutas de los archivos, se ajustó la orientación del bosquejo y se revisó la configuración de audio.

Resultado: El informe quedó compilado en PDF y se obtuvo el enlace del video de sustentación.

Intervalo: 16:23:05 a 20:54:10 

Tiempo efectivo dedicado:4 h 31 min 5 s (con pausas de intermedio)

