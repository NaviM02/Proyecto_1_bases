-- Catálogos y estructura general
CREATE TABLE hospital (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(250) NOT NULL,
    telefono VARCHAR(20),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE hospital IS 'Almacena la información de cada hospital de la cadena.';

CREATE TABLE unidad_medica (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(250),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_unidad_medica_nombre CHECK (nombre IN ('Consulta Externa', 'Emergencias', 'Cirugía', 'Hospitalización'))
);

COMMENT ON TABLE unidad_medica IS 'Catálogo de las unidades principales de atención médica.';
COMMENT ON CONSTRAINT ck_unidad_medica_nombre ON unidad_medica IS 'Valida que la unidad pertenezca a las cuatro unidades definidas.';

CREATE TABLE especialidad (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL UNIQUE,
    descripcion VARCHAR(250),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE especialidad IS 'Catálogo de especialidades médicas disponibles.';

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

COMMENT ON TABLE servicio_medico IS 'Catálogo de servicios médicos ofrecidos por cada unidad.';
COMMENT ON CONSTRAINT ck_servicio_medico_costo ON servicio_medico IS 'Valida que el costo del servicio no sea negativo.';

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

COMMENT ON TABLE hospital_unidad IS 'Relaciona los hospitales con las unidades médicas que poseen.';

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

COMMENT ON TABLE clinica IS 'Registra las clínicas o consultorios de cada hospital.';

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

COMMENT ON TABLE recurso_asistencial IS 'Registra camillas, quirófanos y camas disponibles en los hospitales.';
COMMENT ON CONSTRAINT ck_recurso_asistencial_tipo ON recurso_asistencial IS 'Valida los tipos de recurso asistencial permitidos.';

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

COMMENT ON TABLE paciente IS 'Almacena la información personal y de identificación de los pacientes.';
COMMENT ON CONSTRAINT ck_paciente_sexo ON paciente IS 'Valida el sexo permitido para el paciente.';
COMMENT ON CONSTRAINT ck_paciente_area ON paciente IS 'Valida el área de residencia del paciente.';
COMMENT ON CONSTRAINT ck_paciente_fecha_nacimiento ON paciente IS 'Valida que la fecha de nacimiento no sea futura.';

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

COMMENT ON TABLE encargado IS 'Registra al encargado o representante relacionado con un paciente.';
COMMENT ON CONSTRAINT ck_encargado_area ON encargado IS 'Valida el área de residencia del encargado.';

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

COMMENT ON TABLE paciente_encargado IS 'Relaciona pacientes con sus encargados o representantes.';

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

COMMENT ON TABLE personal_medico IS 'Registra médicos, enfermeros, anestesistas y personal de apoyo clínico.';
COMMENT ON CONSTRAINT ck_personal_medico_area ON personal_medico IS 'Valida el área de residencia cuando se registra.';
COMMENT ON CONSTRAINT ck_personal_medico_tipo ON personal_medico IS 'Valida los tipos de personal médico permitidos.';

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

COMMENT ON TABLE personal_especialidad IS 'Relaciona al personal médico con sus especialidades.';

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

COMMENT ON TABLE personal_unidad IS 'Relaciona al personal médico con las unidades donde presta servicio.';
