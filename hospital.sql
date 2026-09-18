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
