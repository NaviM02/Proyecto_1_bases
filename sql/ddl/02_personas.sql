-- Personas y personal

-- Almacena la información personal y de identificación de los pacientes.
CREATE TABLE paciente (
    id INTEGER PRIMARY KEY,
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
    CONSTRAINT ck_paciente_sexo
        CHECK (sexo IN ('Masculino', 'Femenino')),
    CONSTRAINT ck_paciente_area
        CHECK (area IN ('Urbana', 'Rural')),
    CONSTRAINT ck_paciente_fecha_nacimiento
        CHECK (fecha_nacimiento BETWEEN '1900-01-01' AND CURRENT_DATE)
);

-- Registra al encargado o representante legal de un paciente.
CREATE TABLE encargado (
    id INTEGER PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    parentesco VARCHAR(80) NOT NULL,
    dpi VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    municipio VARCHAR(100),
    departamento VARCHAR(100),
    area VARCHAR(10) NOT NULL,
    CONSTRAINT ck_encargado_area
        CHECK (area IN ('Urbana', 'Rural'))
);

-- Relaciona pacientes con sus encargados o representantes (M:N).
CREATE TABLE paciente_encargado (
    paciente_id INTEGER NOT NULL,
    encargado_id INTEGER NOT NULL,
    principal BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (paciente_id, encargado_id),
    CONSTRAINT fk_paciente_encargado_paciente
        FOREIGN KEY (paciente_id) REFERENCES paciente(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_paciente_encargado_encargado
        FOREIGN KEY (encargado_id) REFERENCES encargado(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Registra médicos, enfermeros, anestesistas y personal de apoyo clínico.
CREATE TABLE personal_medico (
    id INTEGER PRIMARY KEY,
    hospital_id INTEGER NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    dpi VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    municipio VARCHAR(100),
    departamento VARCHAR(100),
    area VARCHAR(10),
    tipo_personal VARCHAR(30) NOT NULL,
    CONSTRAINT ck_personal_medico_area
        CHECK (area IS NULL OR area IN ('Urbana', 'Rural')),
    CONSTRAINT ck_personal_medico_tipo
        CHECK (tipo_personal IN ('Médico', 'Enfermero', 'Anestesista',
                                 'Practicante Médico', 'Practicante Enfermería', 'Otro')),
    CONSTRAINT fk_personal_medico_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Relaciona al personal médico con sus especialidades (M:N).
CREATE TABLE personal_especialidad (
    personal_medico_id INTEGER NOT NULL,
    especialidad_id INTEGER NOT NULL,
    principal BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (personal_medico_id, especialidad_id),
    CONSTRAINT fk_personal_especialidad_personal
        FOREIGN KEY (personal_medico_id) REFERENCES personal_medico(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_personal_especialidad_especialidad
        FOREIGN KEY (especialidad_id) REFERENCES especialidad(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Relaciona al personal con las unidades donde presta servicio por hospital (M:N).
CREATE TABLE personal_unidad (
    personal_medico_id INTEGER NOT NULL,
    hospital_id INTEGER NOT NULL,
    unidad_medica_id INTEGER NOT NULL,
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

-- Registra las calificaciones de calidad del servicio de hospitales, médicos, enfermeros y encargados.
CREATE TABLE calificacion (
    id INTEGER PRIMARY KEY,
    hospital_id INTEGER,
    personal_medico_id INTEGER,
    encargado_id INTEGER,
    puntuacion INTEGER NOT NULL,
    comentario TEXT,
    fecha TIMESTAMP NOT NULL,
    CONSTRAINT ck_calificacion_puntuacion
        CHECK (puntuacion BETWEEN 1 AND 5),
    CONSTRAINT ck_calificacion_sujeto
        CHECK ((CASE WHEN hospital_id IS NOT NULL THEN 1 ELSE 0 END
              + CASE WHEN personal_medico_id IS NOT NULL THEN 1 ELSE 0 END
              + CASE WHEN encargado_id IS NOT NULL THEN 1 ELSE 0 END) = 1),
    CONSTRAINT fk_calificacion_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_calificacion_personal
        FOREIGN KEY (personal_medico_id) REFERENCES personal_medico(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_calificacion_encargado
        FOREIGN KEY (encargado_id) REFERENCES encargado(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
