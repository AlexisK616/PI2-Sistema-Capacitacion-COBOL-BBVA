# 02. Informe de revisión del Product Backlog

## Contexto

La revisión corresponde a PP3, Sprint 3 — Ajustes, Pruebas y Revisión. Se toma
como línea base la entrega de PI2: modelo relacional creado en PostgreSQL 18.6,
estructura inicial del repositorio y requisitos del sistema. El estado se informa
según lo que existe realmente en el repositorio y en la base local.

## Revisión de historias y requisitos

| ID tarea/HU | Descripción de la HU o requisito | Estado anterior | Estado actual | Acción de ajuste / observaciones |
|---|---|---|---|---|
| RF-01 | Como administrador quiero administrar usuarios y roles para controlar el acceso. | Implementado en persistencia; UI/API pendiente | Aprobado parcialmente | El esquema valida roles. La integración con API y pantalla queda pendiente. |
| RF-02 | Como alumno quiero consultar el catálogo y el detalle de cursos para elegir una capacitación. | Implementado en persistencia; UI/API pendiente | Aprobado parcialmente | `cursos` contiene datos simulados. Falta construir la consulta de aplicación. |
| RF-03 | Como docente quiero ordenar módulos dentro de un curso para mantener el recorrido formativo. | Implementado | Corregido y reforzado | Se conserva `UNIQUE (id_curso, orden)` y se agrega ciclo de vida (`activo`, `fecha_actualizacion`). |
| RF-04 | Como alumno quiero inscribirme y consultar mi avance para conocer mi progreso. | Implementado en persistencia | Aprobado | Las FK, el estado y el porcentaje validado quedan cubiertos por el esquema. |
| RF-05 | Como docente quiero definir evaluaciones y obligatoriedad para organizar el cursado. | Implementado en persistencia | Aprobado | `puntaje_minimo` y `entrega_obligatoria` poseen restricciones de dominio. |
| RF-06 | Como alumno quiero registrar una entrega asociada a una evaluación para acreditar mi actividad. | Implementado en persistencia | Aprobado | Se mantiene la relación con evaluación/usuario y la unicidad por entrega. |
| RF-07 | Como sistema quiero conservar estado y puntaje de una entrega para consultar resultados. | Implementado en persistencia | Aprobado | Se mantienen los estados permitidos y el rango de puntaje. |
| RNF-01 | Separar interfaz, backend y persistencia mediante API REST. | Planificado | Postergado | El repositorio aún no contiene código de API. No se presenta como realizado. |
| RNF-02 | Aplicar claves, relaciones y restricciones de dominio. | Implementado | Aprobado y probado | Se agrega una prueba de regresión del esquema y del índice de auditoría. |
| RNF-03 | Ofrecer una interfaz clara y responsive. | Planificado | Postergado | El frontend todavía no está implementado; requiere una siguiente historia. |
| RNF-04 | Informar errores comprensibles sin perder datos. | Planificado | Postergado | Queda vinculado al desarrollo de la API y sus validaciones. |
| RNF-05 | Mantener el código versionado con estructura clara. | Parcial | Corregido | Se agrega `.gitignore` para excluir IDE, dependencias, builds, logs y secretos. |
| RNF-06 | Usar PostgreSQL local sin exponer credenciales. | Implementado | Aprobado | La conexión local está validada y el repositorio no contiene contraseñas. |

## Criterios de aceptación de la revisión

- Cada ítem distingue lo implementado de lo planificado.
- Las mejoras de base de datos cuentan con migración versionable.
- La auditoría conserva entidad, registro, acción, actor, fecha, campo, valores y motivo.
- El registro de regresión puede ejecutarse sobre la base local sin depender de datos reales.
- No se atribuye al BBVA información interna; toda la solución sigue siendo un caso simulado.
