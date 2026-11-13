# Experimentos — TA-IND-01: CockroachDB vs. Apache Cassandra

> Plantilla: reemplaza todo lo que dice `COMPLETAR` con tus datos reales.
> Pega comandos y salidas tal como salieron, sin editarlos.
> Antes de cada paso ejecuta `date` para que quede la hora, y verifica que se vea tu usuario en el prompt.
> Nombra las capturas como `capturas/AAAA-MM-DD_descripcion.png` y menciónalas aquí y en `BITACORA.md`.

---

## 0. Entorno (común a ambos experimentos)

| Dato | CockroachDB | Apache Cassandra |
|---|---|---|
| Versión | COMPLETAR | COMPLETAR |
| Imagen Docker | COMPLETAR | COMPLETAR |
| Nº de nodos | COMPLETAR | COMPLETAR |
| Factor de replicación | COMPLETAR | COMPLETAR |
| Nivel de consistencia usado | COMPLETAR | COMPLETAR |
| Máquina / SO / Docker | COMPLETAR | COMPLETAR |

**Cómo levanté los clústeres:** COMPLETAR (comandos o archivo `docker-compose.yml` usado).

```
COMPLETAR: comandos de arranque y salida de `docker ps`
```

Captura: `capturas/COMPLETAR.png`

**Limitaciones del entorno:** COMPLETAR (por ejemplo, todos los nodos corren en una sola máquina, así que la latencia de red no es real).

---

## Experimento 1 — Caída de nodos (tolerancia a fallos)

**Concepto de la Unidad 1:** tolerancia a fallos, replicación y consenso.

**Pregunta:** COMPLETAR

**Hipótesis (antes de probar, en tus palabras):** COMPLETAR

### Procedimiento (repetir en cada sistema)

| Paso | Qué hago | Comando | Captura |
|---|---|---|---|
| 1 | Estado inicial del clúster | COMPLETAR | COMPLETAR |
| 2 | Creo datos de prueba y los leo | COMPLETAR | COMPLETAR |
| 3 | Detengo 1 nodo (`docker stop <nodo>`) y vuelvo a leer y escribir | COMPLETAR | COMPLETAR |
| 4 | Detengo un 2.º nodo y vuelvo a leer y escribir | COMPLETAR | COMPLETAR |
| 5 | Levanto los nodos (`docker start <nodo>`) y observo la recuperación | COMPLETAR | COMPLETAR |

### Resultados

**CockroachDB**

```
COMPLETAR: comandos y salidas reales
```

**Cassandra**

```
COMPLETAR: comandos y salidas reales
```

| Situación | CockroachDB | Cassandra |
|---|---|---|
| Todos los nodos activos | COMPLETAR | COMPLETAR |
| 1 nodo caído | COMPLETAR | COMPLETAR |
| 2 nodos caídos | COMPLETAR | COMPLETAR |
| Tras recuperar los nodos | COMPLETAR | COMPLETAR |

### Interpretación

- ¿Coincidió con mi hipótesis? COMPLETAR
- Relación con CAP/PACELC y con la tolerancia a fallos: COMPLETAR

---

## Experimento 2 — Partición de red (CAP)

**Concepto de la Unidad 1:** teorema CAP (consistencia vs. disponibilidad ante una partición).

**Pregunta:** COMPLETAR

**Hipótesis (en tus palabras):** COMPLETAR

### Procedimiento (repetir en cada sistema)

| Paso | Qué hago | Comando | Captura |
|---|---|---|---|
| 1 | Verifico el estado inicial y la hora (`date`) | COMPLETAR | COMPLETAR |
| 2 | Aíslo un nodo del resto (por ejemplo con `docker network disconnect <red> <nodo>`) | COMPLETAR | COMPLETAR |
| 3 | Intento escribir y leer desde el lado aislado | COMPLETAR | COMPLETAR |
| 4 | Intento escribir y leer desde el lado con mayoría | COMPLETAR | COMPLETAR |
| 5 | Reconecto el nodo (`docker network connect <red> <nodo>`) y verifico qué pasó con los datos | COMPLETAR | COMPLETAR |

### Resultados

**CockroachDB**

```
COMPLETAR: comandos y salidas reales
```

**Cassandra**

```
COMPLETAR: comandos y salidas reales
```

| Situación | CockroachDB | Cassandra |
|---|---|---|
| Lado aislado: ¿acepta escrituras? ¿lecturas? | COMPLETAR | COMPLETAR |
| Lado con mayoría: ¿acepta escrituras? ¿lecturas? | COMPLETAR | COMPLETAR |
| Tras reconectar: ¿datos consistentes? ¿cómo se reconcilian? | COMPLETAR | COMPLETAR |

### Interpretación

- ¿Coincidió con mi hipótesis? COMPLETAR
- Qué priorizó cada sistema (consistencia o disponibilidad) y cómo se refleja en CAP: COMPLETAR

---

## Opcional — Latencia (parte EL/EC de PACELC)

Solo si te sobra tiempo. Repite cada medición al menos 10 veces y reporta promedio y variación.

| Sistema | Tipo de lectura / nivel de consistencia | Repeticiones | Promedio | Variación |
|---|---|---|---|---|
| COMPLETAR | COMPLETAR | COMPLETAR | COMPLETAR | COMPLETAR |

---

## Limitaciones y reproducibilidad

- Limitaciones generales del experimento: COMPLETAR
- Cómo repetirlo desde cero (versiones, archivos, comandos): COMPLETAR
