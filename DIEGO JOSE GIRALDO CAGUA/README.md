# Análisis crítico comparativo de sistemas distribuidos: Facebook TAO y Amazon DynamoDB

## 1. Descripción del proyecto

Este repositorio contiene el desarrollo del primer trabajo autónomo individual sumativo de la asignatura de Sistemas Distribuidos.

El proyecto consiste en realizar un análisis crítico y comparativo de dos sistemas distribuidos reales:

- **Facebook TAO:** sistema distribuido de almacenamiento de datos en forma de grafo, desarrollado por Facebook.
- **Amazon DynamoDB:** servicio de base de datos NoSQL distribuida, ofrecido por Amazon Web Services (AWS).
- **Link del video:** https://youtu.be/95TQS1WtIm8

El análisis aborda los principales conceptos de la Unidad 1, relacionando la teoría con las características, decisiones arquitectónicas y mecanismos de funcionamiento de ambos sistemas.

## 2. Objetivos

- Analizar la arquitectura y los componentes de Facebook TAO.
- Estudiar las características de distribución de Amazon DynamoDB.
- Examinar las transparencias de distribución de ambos sistemas.
- Analizar sus decisiones de diseño mediante los teoremas CAP y PACELC.
- Identificar sus modelos de comunicación y mecanismos de tolerancia a fallos.
- Realizar una comparación técnica sustentada en documentación y fuentes académicas.
- Desarrollar experimentos que permitan relacionar los conceptos teóricos con resultados observables.

## 3. Estructura del repositorio

```text
TA-IND-01-Informe-Acad-mico-Individual---CGMT/DIEGO JOSE GIRALDO CAGUA
│
├── README.md
├── BITACORA.md
├── informe.tex
├── referencias.bib
├── informe.pdf
│
├── figuras/
│   └── anexos/
│
├── capturas/
│
└── experimento/
    ├── comandos.md
    ├── resultados.md
    └── scripts/
```

### Descripción de los archivos y carpetas

| Elemento | Descripción |
|---|---|
| `README.md` | Documentación general del proyecto. |
| `BITACORA.md` | Registro cronológico de las sesiones de trabajo. |
| `informe.tex` | Documento principal escrito en LaTeX. |
| `referencias.bib` | Base de datos bibliográfica utilizada por BibLaTeX. |
| `informe.pdf` | Informe académico compilado. |
| `figuras/` | Diagramas y recursos gráficos del informe. |
| `figuras/anexos/` | Esquema manual y evidencias de lectura de fuentes. |
| `capturas/` | Evidencias originales de interacción con los sistemas. |
| `experimento/` | Comandos, resultados y scripts de experimentación. |

## 4. Tecnologías y herramientas

Las herramientas previstas para desarrollar el proyecto son:

- **LaTeX:** elaboración del informe académico.
- **BibLaTeX y Biber:** gestión y generación de referencias bibliográficas.
- **Git y GitHub:** control de versiones y almacenamiento del proyecto.
- **Docker:** ejecución de entornos de prueba, cuando corresponda.
- **DynamoDB Local:** entorno de experimentación con Amazon DynamoDB.
- **Draw.io:** elaboración del diagrama arquitectónico.

La experimentación relacionada con Facebook TAO se documentará mediante una estrategia técnicamente justificada, considerando las limitaciones de acceso a su implementación interna.

## 5. Compilación del informe

Para generar el documento PDF se requiere una distribución de LaTeX que incluya `pdflatex` y Biber.

El archivo principal es `informe.tex`.

Ejecutar los siguientes comandos en orden:

```bash
pdflatex informe.tex
biber informe
pdflatex informe.tex
pdflatex informe.tex
```

Este procedimiento permite procesar el documento, generar las referencias bibliográficas y actualizar las citas y referencias cruzadas.

### Dependencias

- Una distribución LaTeX (TeX Live o MiKTeX).
- BibLaTeX.
- Biber.
- Paquetes LaTeX utilizados por el documento.

## 6. Evidencias y experimentación

El repositorio contendrá las evidencias originales del desarrollo:

1. Capturas de interacción con los sistemas o entornos de prueba.
2. Resultados de los experimentos realizados.
3. Comandos y scripts utilizados.
4. Esquema arquitectónico inicial elaborado a mano.
5. Capturas de lectura y anotación de fuentes académicas.
6. Bitácora de trabajo con las sesiones y avances realizados.

Los resultados se presentarán diferenciando los experimentos ejecutados directamente de las aproximaciones o simulaciones utilizadas.

## 7. Video de sustentación

El video de sustentación tendrá una duración de entre 3 y 5 minutos y presentará una explicación de las evidencias experimentales y de las conclusiones principales del análisis.

**Enlace al video:** Pendiente de publicación.

## 8. Autoría e integridad académica

Este proyecto corresponde a un trabajo individual. Las capturas, experimentos, diagramas y resultados deberán corresponder al trabajo realizado por el estudiante.

Las fuentes bibliográficas se verificarán mediante sus publicaciones originales y sus respectivos DOI, cuando corresponda.

El uso de herramientas de inteligencia artificial se declarará de manera transparente en el informe, especificando su utilización y los procedimientos de verificación.

## 9. Estado del proyecto

Proyecto en desarrollo.

La información de esta sección se actualizará conforme se completen las actividades y evidencias del trabajo.
