-- PP3 / Sprint 3 - mejoras técnicas del caso de estudio simulado
-- No contiene información interna de BBVA.

SET search_path TO capacitacion;

-- La auditoría permite conservar actor, fecha, campo modificado y motivo.
CREATE TABLE IF NOT EXISTS auditoria_cambios (
    id_auditoria BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    entidad VARCHAR(80) NOT NULL,
    id_registro BIGINT NOT NULL,
    accion VARCHAR(20) NOT NULL CHECK (accion IN ('ALTA', 'MODIFICACION', 'BAJA_LOGICA')),
    actor VARCHAR(160) NOT NULL,
    campo VARCHAR(80),
    valor_anterior TEXT,
    valor_nuevo TEXT,
    motivo TEXT,
    fecha_cambio TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_auditoria_entidad_registro
    ON auditoria_cambios (entidad, id_registro, fecha_cambio DESC);

-- Los módulos pueden desactivarse sin perder su trazabilidad.
ALTER TABLE modulos
    ADD COLUMN IF NOT EXISTS activo BOOLEAN NOT NULL DEFAULT TRUE;

ALTER TABLE modulos
    ADD COLUMN IF NOT EXISTS fecha_actualizacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP;

CREATE OR REPLACE FUNCTION actualizar_fecha_modulo()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.fecha_actualizacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_modulos_fecha_actualizacion ON modulos;

CREATE TRIGGER trg_modulos_fecha_actualizacion
BEFORE UPDATE ON modulos
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_modulo();
