-- Consulta externa

-- Registra las citas programadas de consulta externa y su estado.
CREATE TABLE cita (
    id INTEGER PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    hospital_id INTEGER NOT NULL,
    clinica_id INTEGER NOT NULL,
    medico_id INTEGER NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    costo NUMERIC(12,2) NOT NULL,
    tipo_cita VARCHAR(20) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Programada',
    fecha_cancelacion TIMESTAMP,
    motivo_cancelacion TEXT,
    CONSTRAINT ck_cita_costo CHECK (costo >= 0),
    CONSTRAINT ck_cita_tipo CHECK (tipo_cita IN ('Primera consulta', 'Reconsulta', 'Referido')),
    CONSTRAINT ck_cita_estado CHECK (estado IN ('Programada', 'Realizada', 'Reprogramada', 'Cancelada')),
    CONSTRAINT ck_cita_cancelacion CHECK ((estado = 'Cancelada' AND fecha_cancelacion IS NOT NULL)OR estado <> 'Cancelada'),
    CONSTRAINT fk_cita_paciente FOREIGN KEY (paciente_id) REFERENCES paciente(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cita_hospital FOREIGN KEY (hospital_id) REFERENCES hospital(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cita_clinica FOREIGN KEY (clinica_id) REFERENCES clinica(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cita_medico FOREIGN KEY (medico_id) REFERENCES personal_medico(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Registra la atención médica realizada durante una cita.
CREATE TABLE consulta (
    id INTEGER PRIMARY KEY,
    cita_id INTEGER NOT NULL UNIQUE,
    paciente_id INTEGER NOT NULL,
    medico_id INTEGER NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    diagnostico TEXT NOT NULL,
    otros_datos TEXT,
    observaciones TEXT,
    CONSTRAINT fk_consulta_cita FOREIGN KEY (cita_id) REFERENCES cita(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_consulta_paciente FOREIGN KEY (paciente_id) REFERENCES paciente(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_consulta_medico FOREIGN KEY (medico_id) REFERENCES personal_medico(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Registra las recetas médicas emitidas durante las consultas.
CREATE TABLE receta (
    id INTEGER PRIMARY KEY,
    consulta_id INTEGER NOT NULL,
    paciente_id INTEGER NOT NULL,
    medico_id INTEGER NOT NULL,
    fecha DATE NOT NULL,
    proxima_cita DATE,
    clinica_id INTEGER,
    CONSTRAINT fk_receta_consulta FOREIGN KEY (consulta_id) REFERENCES consulta(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_receta_paciente FOREIGN KEY (paciente_id) REFERENCES paciente(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_receta_medico FOREIGN KEY (medico_id) REFERENCES personal_medico(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_receta_clinica FOREIGN KEY (clinica_id) REFERENCES clinica(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Catálogo de medicamentos utilizados en las prescripciones.
CREATE TABLE medicamento (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    descripcion VARCHAR(250)
);

-- Relaciona una receta con los medicamentos prescritos y sus indicaciones (M:N).
CREATE TABLE receta_medicamento (
    receta_id INTEGER NOT NULL,
    medicamento_id INTEGER NOT NULL,
    dosis VARCHAR(100) NOT NULL,
    duracion VARCHAR(100) NOT NULL,
    PRIMARY KEY (receta_id, medicamento_id),
    CONSTRAINT fk_receta_medicamento_receta FOREIGN KEY (receta_id) REFERENCES receta(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_receta_medicamento_medicamento FOREIGN KEY (medicamento_id) REFERENCES medicamento(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
