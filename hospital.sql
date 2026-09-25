-- Catálogos y estructura general
CREATE TABLE hospital (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(250) NOT NULL,
    telefono VARCHAR(20),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE unidad_medica (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(250),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_unidad_medica_nombre CHECK (nombre IN ('Consulta Externa', 'Emergencias', 'Cirugía', 'Hospitalización'))
);

CREATE TABLE especialidad (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL UNIQUE,
    descripcion VARCHAR(250),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE servicio_medico (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    unidad_medica_id BIGINT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion VARCHAR(250),
    costo_base NUMERIC(12,2) NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_servicio_medico_costo CHECK (costo_base >= 0),
    CONSTRAINT uq_servicio_medico_unidad_nombre UNIQUE (unidad_medica_id, nombre),
    CONSTRAINT fk_servicio_medico_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE hospital_unidad (
    hospital_id BIGINT NOT NULL,
    unidad_medica_id BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (hospital_id, unidad_medica_id),
    CONSTRAINT fk_hospital_unidad_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_hospital_unidad_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE clinica (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hospital_id BIGINT NOT NULL,
    unidad_medica_id BIGINT NOT NULL,
    numero VARCHAR(30) NOT NULL,
    descripcion VARCHAR(150),
    CONSTRAINT uq_clinica_hospital_numero UNIQUE (hospital_id, numero),
    CONSTRAINT fk_clinica_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_clinica_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE recurso_asistencial (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hospital_id BIGINT NOT NULL,
    unidad_medica_id BIGINT NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250),
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_recurso_asistencial_tipo CHECK (tipo IN ('Camilla', 'Quirófano', 'Cama')),
    CONSTRAINT uq_recurso_asistencial_nombre UNIQUE (hospital_id, unidad_medica_id, nombre),
    CONSTRAINT fk_recurso_asistencial_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_recurso_asistencial_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Personas y personal

CREATE TABLE paciente (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    expediente VARCHAR(50) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    dpi VARCHAR(20) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    sexo VARCHAR(10) NOT NULL,
    estado_civil VARCHAR(30),
    telefono VARCHAR(20),
    seguro_social VARCHAR(50),
    municipio VARCHAR(100),
    departamento VARCHAR(100),
    area VARCHAR(10) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_paciente_sexo CHECK (sexo IN ('Masculino', 'Femenino')),
    CONSTRAINT ck_paciente_area CHECK (area IN ('Urbana', 'Rural')),
    CONSTRAINT ck_paciente_fecha_nacimiento CHECK (fecha_nacimiento <= CURRENT_DATE)
);

CREATE TABLE encargado (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    parentesco VARCHAR(80) NOT NULL,
    dpi VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    municipio VARCHAR(100),
    departamento VARCHAR(100),
    area VARCHAR(10) NOT NULL,
    CONSTRAINT ck_encargado_area CHECK (area IN ('Urbana', 'Rural'))
);

CREATE TABLE paciente_encargado (
    paciente_id BIGINT NOT NULL,
    encargado_id BIGINT NOT NULL,
    principal BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (paciente_id, encargado_id),
    CONSTRAINT fk_paciente_encargado_paciente
        FOREIGN KEY (paciente_id) REFERENCES paciente(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_paciente_encargado_encargado
        FOREIGN KEY (encargado_id) REFERENCES encargado(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE personal_medico (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hospital_id BIGINT NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    dpi VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    municipio VARCHAR(100),
    departamento VARCHAR(100),
    area VARCHAR(10),
    tipo_personal VARCHAR(30) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_personal_medico_area CHECK (area IS NULL OR area IN ('Urbana', 'Rural')),
    CONSTRAINT ck_personal_medico_tipo CHECK (tipo_personal IN ('Médico', 'Enfermero', 'Anestesista', 'Practicante Médico', 'Practicante Enfermería', 'Otro')),
    CONSTRAINT fk_personal_medico_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE personal_especialidad (
    personal_medico_id BIGINT NOT NULL,
    especialidad_id BIGINT NOT NULL,
    principal BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (personal_medico_id, especialidad_id),
    CONSTRAINT fk_personal_especialidad_personal
        FOREIGN KEY (personal_medico_id) REFERENCES personal_medico(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_personal_especialidad_especialidad
        FOREIGN KEY (especialidad_id) REFERENCES especialidad(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE personal_unidad (
    personal_medico_id BIGINT NOT NULL,
    hospital_id BIGINT NOT NULL,
    unidad_medica_id BIGINT NOT NULL,
    PRIMARY KEY (personal_medico_id, hospital_id, unidad_medica_id),
    CONSTRAINT fk_personal_unidad_personal
        FOREIGN KEY (personal_medico_id) REFERENCES personal_medico(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_personal_unidad_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_personal_unidad_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Consulta externa
CREATE TABLE ingreso (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    paciente_id BIGINT NOT NULL,
    hospital_id BIGINT NOT NULL,
    unidad_medica_id BIGINT NOT NULL,
    servicio_medico_id BIGINT NOT NULL,
    medico_encargado_id BIGINT NOT NULL,
    recurso_asistencial_id BIGINT,
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

CREATE TABLE egreso (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ingreso_id BIGINT NOT NULL UNIQUE,
    paciente_id BIGINT NOT NULL,
    hospital_id BIGINT NOT NULL,
    unidad_medica_id BIGINT NOT NULL,
    servicio_medico_id BIGINT NOT NULL,
    medico_asignado_id BIGINT NOT NULL,
    recurso_asistencial_id BIGINT,
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
    CONSTRAINT ck_egreso_codigo CHECK (codigo_egreso IN ('Vivo', 'Muerto', 'Embarazo', 'Parto')),
    CONSTRAINT ck_egreso_dias CHECK (dias_hospitalizado IS NULL OR dias_hospitalizado >= 0),
    CONSTRAINT ck_egreso_motivo_consentimiento CHECK (
        (sin_consentimiento_medico = TRUE AND motivo_sin_consentimiento IS NOT NULL)
        OR (sin_consentimiento_medico = FALSE)
    ),
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

CREATE TABLE traslado (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    paciente_id BIGINT NOT NULL,
    medico_indica_id BIGINT NOT NULL,
    hospital_origen_id BIGINT NOT NULL,
    unidad_origen_id BIGINT NOT NULL,
    servicio_origen_id BIGINT,
    hospital_destino_id BIGINT NOT NULL,
    unidad_destino_id BIGINT NOT NULL,
    servicio_destino_id BIGINT,
    fecha_hora TIMESTAMP NOT NULL,
    tipo_traslado VARCHAR(10) NOT NULL,
    observaciones TEXT,
    CONSTRAINT ck_traslado_tipo CHECK (tipo_traslado IN ('Interno', 'Externo')),
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
