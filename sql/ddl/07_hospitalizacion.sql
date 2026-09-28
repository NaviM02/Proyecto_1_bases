-- Parte 07 — Hospitalización
-- =========================================================
-- Hospitalización
-- =========================================================

-- Registra la estadía del paciente en la unidad de hospitalización.
CREATE TABLE hospitalizacion (
    id INTEGER PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    hospital_id INTEGER NOT NULL,
    ingreso_id INTEGER NOT NULL UNIQUE,
    unidad_medica_id INTEGER NOT NULL,
    servicio_medico_id INTEGER NOT NULL,
    medico_encargado_id INTEGER NOT NULL,
    cama_id INTEGER,
    fecha_hora_ingreso TIMESTAMP NOT NULL,
    fecha_hora_egreso TIMESTAMP,
    -- Valida que el costo por día no sea negativo
    costo_por_dia NUMERIC(12,2) NOT NULL,
    CONSTRAINT ck_hospitalizacion_costo_dia CHECK (costo_por_dia >= 0),
    -- Valida que el egreso no ocurra antes del ingreso
    CONSTRAINT ck_hospitalizacion_fechas
        CHECK (fecha_hora_egreso IS NULL OR fecha_hora_egreso >= fecha_hora_ingreso),
    CONSTRAINT fk_hospitalizacion_paciente
        FOREIGN KEY (paciente_id) REFERENCES paciente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_hospitalizacion_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_hospitalizacion_ingreso
        FOREIGN KEY (ingreso_id) REFERENCES ingreso(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_hospitalizacion_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_hospitalizacion_servicio
        FOREIGN KEY (servicio_medico_id) REFERENCES servicio_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_hospitalizacion_medico
        FOREIGN KEY (medico_encargado_id) REFERENCES personal_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_hospitalizacion_cama
        FOREIGN KEY (cama_id) REFERENCES recurso_asistencial(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);
