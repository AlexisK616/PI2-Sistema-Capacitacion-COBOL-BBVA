-- Sistema de Capacitación en COBOL para BBVA
-- Caso de estudio simulado - PI2 / Proyecto Integrador 2
-- PostgreSQL 18+

CREATE SCHEMA IF NOT EXISTS capacitacion;
SET search_path TO capacitacion;

CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    email VARCHAR(160) NOT NULL UNIQUE,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('alumno', 'docente', 'administrador')),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_alta TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cursos (
    id_curso BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo VARCHAR(180) NOT NULL,
    descripcion TEXT NOT NULL,
    nivel VARCHAR(20) NOT NULL CHECK (nivel IN ('inicial', 'intermedio', 'avanzado')),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS modulos (
    id_modulo BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_curso BIGINT NOT NULL REFERENCES cursos(id_curso) ON DELETE CASCADE,
    titulo VARCHAR(180) NOT NULL,
    descripcion TEXT NOT NULL,
    orden SMALLINT NOT NULL CHECK (orden > 0),
    obligatorio BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (id_curso, orden)
);

CREATE TABLE IF NOT EXISTS inscripciones (
    id_inscripcion BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON DELETE RESTRICT,
    id_curso BIGINT NOT NULL REFERENCES cursos(id_curso) ON DELETE RESTRICT,
    estado VARCHAR(20) NOT NULL DEFAULT 'activa' CHECK (estado IN ('activa', 'finalizada', 'cancelada')),
    porcentaje_avance NUMERIC(5, 2) NOT NULL DEFAULT 0 CHECK (porcentaje_avance BETWEEN 0 AND 100),
    fecha_inscripcion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_usuario, id_curso)
);

CREATE TABLE IF NOT EXISTS evaluaciones (
    id_evaluacion BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_modulo BIGINT NOT NULL REFERENCES modulos(id_modulo) ON DELETE CASCADE,
    titulo VARCHAR(180) NOT NULL,
    puntaje_minimo NUMERIC(5, 2) NOT NULL DEFAULT 60 CHECK (puntaje_minimo BETWEEN 0 AND 100),
    entrega_obligatoria BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS entregas (
    id_entrega BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_evaluacion BIGINT NOT NULL REFERENCES evaluaciones(id_evaluacion) ON DELETE CASCADE,
    id_usuario BIGINT NOT NULL REFERENCES usuarios(id_usuario) ON DELETE RESTRICT,
    archivo_referencia VARCHAR(255),
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'enviada', 'corregida')),
    puntaje NUMERIC(5, 2) CHECK (puntaje BETWEEN 0 AND 100),
    fecha_entrega TIMESTAMPTZ,
    observaciones TEXT,
    UNIQUE (id_evaluacion, id_usuario)
);

CREATE INDEX IF NOT EXISTS idx_modulos_curso ON modulos(id_curso);
CREATE INDEX IF NOT EXISTS idx_inscripciones_usuario ON inscripciones(id_usuario);
CREATE INDEX IF NOT EXISTS idx_entregas_usuario ON entregas(id_usuario);

-- Datos de demostración exclusivamente simulados para validar la estructura.
INSERT INTO usuarios (nombre, apellido, email, rol)
VALUES ('Usuario', 'Demo', 'usuario.demo@example.test', 'alumno')
ON CONFLICT (email) DO NOTHING;

INSERT INTO cursos (titulo, descripcion, nivel)
VALUES (
    'Sistema de Capacitación en COBOL para BBVA',
    'Curso de demostración para fortalecer conocimientos en tecnologías legacy. Caso de estudio simulado, sin información interna real.',
    'inicial'
)
ON CONFLICT DO NOTHING;

INSERT INTO modulos (id_curso, titulo, descripcion, orden)
SELECT c.id_curso, datos.titulo, datos.descripcion, datos.orden
FROM cursos c
CROSS JOIN (VALUES
    ('Fundamentos de COBOL', 'Conceptos iniciales del lenguaje y su contexto legacy.', 1),
    ('Mantenimiento de sistemas legacy', 'Prácticas de lectura, documentación y evolución controlada.', 2),
    ('Automatización del aprendizaje', 'Seguimiento de avance, evaluaciones y entregas.', 3)
) AS datos(titulo, descripcion, orden)
WHERE c.titulo = 'Sistema de Capacitación en COBOL para BBVA'
  AND NOT EXISTS (SELECT 1 FROM modulos m WHERE m.id_curso = c.id_curso);

INSERT INTO evaluaciones (id_modulo, titulo, puntaje_minimo, entrega_obligatoria)
SELECT m.id_modulo, 'Actividad práctica del módulo ' || m.orden, 60, TRUE
FROM modulos m
WHERE NOT EXISTS (SELECT 1 FROM evaluaciones e WHERE e.id_modulo = m.id_modulo);
