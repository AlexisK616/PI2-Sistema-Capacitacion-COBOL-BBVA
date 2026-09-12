# 03. Registro de mejoras implementadas

## 1. Resumen ejecutivo de ajustes

Durante el Sprint 3 se revisó el esquema PostgreSQL y la organización del
repositorio que habían quedado definidos en PI2. La mejora se concentra en
trazabilidad, ciclo de vida de los módulos, higiene del repositorio y pruebas de
regresión. No se declara implementada una API o una interfaz porque todavía no
existe código ejecutable de esas capas.

## 2. Registro detallado de mejoras

### Mejora 1 — Auditoría de cambios del dominio

**Tipo de ajuste:** Base de datos y trazabilidad.

**Descripción del problema:** El modelo inicial no tenía una estructura específica
para registrar quién cambió un registro, cuándo lo hizo, qué campo fue afectado y
cuál fue el motivo.

**Solución implementada:** Se creó `capacitacion.auditoria_cambios` con acción,
actor, campo, valores anterior/nuevo, motivo y fecha. También se agregó un índice
por entidad, registro y fecha para facilitar la consulta del historial.

**Validación realizada:** La prueba `database/tests/sprint3_regression.sql`
verifica la existencia de la tabla y del índice.

### Mejora 2 — Ciclo de vida de módulos

**Tipo de ajuste:** Base de datos y regla de negocio.

**Descripción del problema:** El modelo podía ordenar módulos, pero no distinguía
un módulo activo de uno que debía dejar de ofrecerse sin borrarlo.

**Solución implementada:** Se agregaron `activo` y `fecha_actualizacion` a
`modulos`. Un trigger actualiza automáticamente la fecha ante modificaciones.

**Validación realizada:** La prueba de regresión verifica que exista un módulo
activo con orden válido y que la migración pueda auditarse en el esquema.

### Mejora 3 — Higiene y seguridad del repositorio

**Tipo de ajuste:** Configuración/versionado.

**Descripción del problema:** La configuración local de IntelliJ y otros archivos
generados no deben formar parte del repositorio público.

**Solución implementada:** Se agregó `.gitignore` para excluir `.idea/`,
dependencias, builds, logs, archivos temporales y variables `.env`, manteniendo
`.env.example` como única excepción documentable.

**Validación realizada:** La revisión del estado de Git permite identificar la
configuración local como no versionable y conserva el SQL/documentación como
artefactos del proyecto.

### Mejora 4 — Prueba de regresión reproducible

**Tipo de ajuste:** Calidad/QA.

**Descripción del problema:** La estructura estaba creada, pero no existía un
chequeo automatizado que confirmara tablas, índice y condición mínima del dominio.

**Solución implementada:** Se creó un script SQL con bloques `DO` y mensajes de
fallo explícitos. La prueba valida las siete tablas esperadas, un módulo activo
válido y el índice de auditoría.

**Validación realizada:** Ejecución real con `psql` sobre PostgreSQL local; el
resultado esperado es `SPRINT3_TEST_OK`.
