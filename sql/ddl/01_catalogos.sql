-- Catálogos y estructura general

-- Almacena la información de cada hospital de la cadena.
CREATE TABLE hospital (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(250) NOT NULL,
    telefono VARCHAR(20)
);

-- Catálogo de las cuatro unidades principales de atención médica.
CREATE TABLE unidad_medica (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    CONSTRAINT ck_unidad_medica_nombre
        CHECK (nombre IN ('Consulta Externa', 'Emergencias', 'Cirugía', 'Hospitalización'))
);

-- Catálogo de especialidades médicas de consulta externa y cirugía.
CREATE TABLE especialidad (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL UNIQUE,
    descripcion VARCHAR(250)
);

-- Catálogo de servicios médicos ofrecidos por cada unidad, con su costo base.
CREATE TABLE servicio_medico (
    id INTEGER PRIMARY KEY,
    unidad_medica_id INTEGER NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion VARCHAR(250),
    costo_base NUMERIC(12,2) NOT NULL,
    CONSTRAINT ck_servicio_medico_costo CHECK (costo_base >= 0),
    CONSTRAINT uq_servicio_medico_unidad_nombre UNIQUE (unidad_medica_id, nombre),
    CONSTRAINT fk_servicio_medico_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Relaciona los hospitales con las unidades médicas que poseen (M:N).
CREATE TABLE hospital_unidad (
    hospital_id INTEGER NOT NULL,
    unidad_medica_id INTEGER NOT NULL,
    PRIMARY KEY (hospital_id, unidad_medica_id),
    CONSTRAINT fk_hospital_unidad_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_hospital_unidad_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Registra las clínicas o consultorios de consulta externa de cada hospital.
CREATE TABLE clinica (
    id INTEGER PRIMARY KEY,
    hospital_id INTEGER NOT NULL,
    unidad_medica_id INTEGER NOT NULL,
    numero VARCHAR(30) NOT NULL,
    descripcion VARCHAR(150),
    CONSTRAINT uq_clinica_hospital_numero UNIQUE (hospital_id, numero),
    CONSTRAINT fk_clinica_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_clinica_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Registra camillas, quirófanos y camas disponibles en los hospitales.
CREATE TABLE recurso_asistencial (
    id INTEGER PRIMARY KEY,
    hospital_id INTEGER NOT NULL,
    unidad_medica_id INTEGER NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250),
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_recurso_asistencial_tipo
        CHECK (tipo IN ('Camilla', 'Quirófano', 'Cama')),
    CONSTRAINT uq_recurso_asistencial_nombre
        UNIQUE (hospital_id, unidad_medica_id, nombre),
    CONSTRAINT fk_recurso_asistencial_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_recurso_asistencial_unidad
        FOREIGN KEY (unidad_medica_id) REFERENCES unidad_medica(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
