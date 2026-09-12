# 04. Historias técnicas Scrum

Las historias técnicas se expresan para el caso de estudio simulado y contienen
criterios de aceptación verificables.

## HT-01 — Aislar archivos locales del repositorio

**Como** equipo de desarrollo, **quiero** excluir configuraciones y secretos
locales, **para** evitar publicar información del entorno.

**Criterios de aceptación**

- `.idea/`, `.env`, logs, temporales y dependencias quedan excluidos.
- `.env.example` puede documentarse sin credenciales.
- El SQL y la documentación del proyecto siguen versionables.

## HT-02 — Registrar auditoría de cambios

**Como** sistema, **quiero** registrar los cambios sobre entidades, **para**
conservar trazabilidad funcional y técnica.

**Criterios de aceptación**

- Existe `auditoria_cambios` dentro del esquema `capacitacion`.
- La tabla obliga entidad, registro, acción, actor y fecha.
- La acción solo admite `ALTA`, `MODIFICACION` o `BAJA_LOGICA`.
- El índice permite buscar por entidad y registro ordenado por fecha.

## HT-03 — Mantener módulos sin borrado físico

**Como** docente, **quiero** desactivar un módulo sin eliminarlo, **para**
conservar la historia del recorrido formativo.

**Criterios de aceptación**

- `modulos.activo` existe y por defecto vale verdadero.
- `modulos.fecha_actualizacion` se actualiza al modificar el registro.
- El orden del módulo sigue siendo positivo y único dentro del curso.

## HT-04 — Ejecutar regresión del esquema

**Como** responsable de calidad, **quiero** una prueba reproducible, **para**
detectar rápidamente una regresión del modelo.

**Criterios de aceptación**

- El script identifica las siete tablas esperadas.
- El script detecta la falta del índice de auditoría.
- Una ejecución exitosa informa `SPRINT3_TEST_OK`.
- Una condición inválida interrumpe la prueba con un mensaje explícito.

## HT-05 — Preparar API REST

**Como** equipo, **quiero** una API REST para encapsular PostgreSQL, **para**
evitar acceso directo desde la interfaz.

**Estado:** Postergada. El repositorio actual aún no contiene implementación de
backend; se planifica para el siguiente incremento y no se presenta como una
mejora realizada.
