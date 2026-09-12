-- PP3 / Sprint 3 - pruebas de regresión del esquema
-- Ejecutar con psql sobre la base capacitacion_cobol_bbva.

SET search_path TO capacitacion;

DO $$
DECLARE
    cantidad INTEGER;
BEGIN
    SELECT COUNT(*) INTO cantidad
    FROM information_schema.tables
    WHERE table_schema = 'capacitacion'
      AND table_name IN ('usuarios', 'cursos', 'modulos', 'inscripciones',
                         'evaluaciones', 'entregas', 'auditoria_cambios');

    IF cantidad <> 7 THEN
        RAISE EXCEPTION 'Fallo: se esperaban 7 tablas del modelo Sprint 3 y se encontraron %', cantidad;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM capacitacion.modulos
        WHERE orden > 0 AND activo IS TRUE
    ) THEN
        RAISE EXCEPTION 'Fallo: no hay módulo activo válido para la prueba';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE schemaname = 'capacitacion'
          AND indexname = 'idx_auditoria_entidad_registro'
    ) THEN
        RAISE EXCEPTION 'Fallo: falta índice de auditoría';
    END IF;

    RAISE NOTICE 'SPRINT3_TEST_OK: esquema, integridad e índice de auditoría verificados';
END;
$$;
