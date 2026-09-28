-- Ingresos, egresos y traslados

-- Registra la ficha de ingreso de pacientes a emergencias, cirugía u hospitalización.
CREATE TABLE ingreso (
    id INTEGER PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    hospital_id INTEGER NOT NULL,
    unidad_medica_id INTEGER NOT NULL,
    servicio_medico_id INTEGER NOT NULL,
    medico_encargado_id INTEGER NOT NULL,
    recurso_asistencial_id INTEGER,
    motivo TEXT NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    diagnostico_presuntivo TEXT NOT NULL,
    CONSTRAINT fk_ingreso_paciente
        FOREIGN KEY (paciente_id) REFERENCES paciente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ingreso_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ingreso_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ingreso_servicio
        FOREIGN KEY (servicio_medico_id) REFERENCES servicio_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ingreso_medico
        FOREIGN KEY (medico_encargado_id) REFERENCES personal_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ingreso_recurso
        FOREIGN KEY (recurso_asistencial_id) REFERENCES recurso_asistencial(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Registra la ficha de egreso del paciente y el resultado de la atención.
CREATE TABLE egreso (
    id INTEGER PRIMARY KEY,
    ingreso_id INTEGER NOT NULL UNIQUE,
    paciente_id INTEGER NOT NULL,
    hospital_id INTEGER NOT NULL,
    unidad_medica_id INTEGER NOT NULL,
    servicio_medico_id INTEGER NOT NULL,
    medico_asignado_id INTEGER NOT NULL,
    recurso_asistencial_id INTEGER,
    fecha_hora TIMESTAMP NOT NULL,
    diagnostico_principal TEXT NOT NULL,
    diagnosticos_secundarios TEXT,
    motivo TEXT NOT NULL,
    codigo_egreso VARCHAR(20) NOT NULL,
    sin_consentimiento_medico BOOLEAN NOT NULL DEFAULT FALSE,
    motivo_sin_consentimiento TEXT,
    dias_hospitalizado INTEGER,
    operaciones_intervenciones TEXT,
    codigo_traslado VARCHAR(30),
    referido_a TEXT,
    CONSTRAINT ck_egreso_codigo
        CHECK (codigo_egreso IN ('Vivo', 'Muerto', 'Embarazo', 'Parto')),
    CONSTRAINT ck_egreso_dias
        CHECK (dias_hospitalizado IS NULL OR dias_hospitalizado >= 0),
    CONSTRAINT ck_egreso_motivo_consentimiento
        CHECK ((sin_consentimiento_medico = TRUE AND motivo_sin_consentimiento IS NOT NULL)
            OR (sin_consentimiento_medico = FALSE)),
    CONSTRAINT fk_egreso_ingreso
        FOREIGN KEY (ingreso_id) REFERENCES ingreso(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_egreso_paciente
        FOREIGN KEY (paciente_id) REFERENCES paciente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_egreso_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_egreso_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_egreso_servicio
        FOREIGN KEY (servicio_medico_id) REFERENCES servicio_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_egreso_medico
        FOREIGN KEY (medico_asignado_id) REFERENCES personal_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_egreso_recurso
        FOREIGN KEY (recurso_asistencial_id) REFERENCES recurso_asistencial(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Registra la ficha de traslado entre unidades u hospitales.
CREATE TABLE traslado (
    id INTEGER PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    medico_indica_id INTEGER NOT NULL,
    hospital_origen_id INTEGER NOT NULL,
    unidad_origen_id INTEGER NOT NULL,
    servicio_origen_id INTEGER,
    hospital_destino_id INTEGER NOT NULL,
    unidad_destino_id INTEGER NOT NULL,
    servicio_destino_id INTEGER,
    fecha_hora TIMESTAMP NOT NULL,
    tipo_traslado VARCHAR(10) NOT NULL,
    observaciones TEXT,
    CONSTRAINT ck_traslado_tipo
        CHECK (tipo_traslado IN ('Interno', 'Externo')),
    CONSTRAINT fk_traslado_paciente
        FOREIGN KEY (paciente_id) REFERENCES paciente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_traslado_medico
        FOREIGN KEY (medico_indica_id) REFERENCES personal_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_traslado_hospital_origen
        FOREIGN KEY (hospital_origen_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_traslado_unidad_origen
        FOREIGN KEY (unidad_origen_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_traslado_servicio_origen
        FOREIGN KEY (servicio_origen_id) REFERENCES servicio_medico(id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_traslado_hospital_destino
        FOREIGN KEY (hospital_destino_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_traslado_unidad_destino
        FOREIGN KEY (unidad_destino_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_traslado_servicio_destino
        FOREIGN KEY (servicio_destino_id) REFERENCES servicio_medico(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);
