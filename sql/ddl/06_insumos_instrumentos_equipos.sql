-- Insumos, instrumentos y equipos

-- Catálogo de insumos médicos y quirúrgicos.
CREATE TABLE insumo (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    descripcion VARCHAR(250),
    material VARCHAR(100),
    tipo VARCHAR(20) NOT NULL,
    CONSTRAINT ck_insumo_tipo
        CHECK (tipo IN ('Médico', 'Quirúrgico', 'Otro'))
);

-- Catálogo de instrumentos médicos y quirúrgicos.
CREATE TABLE instrumento (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    descripcion VARCHAR(250),
    tipo VARCHAR(20) NOT NULL,
    funcion VARCHAR(30) NOT NULL,
    CONSTRAINT ck_instrumento_tipo
        CHECK (tipo IN ('Médico', 'Quirúrgico', 'Otro')),
    CONSTRAINT ck_instrumento_funcion
        CHECK (funcion IN ('Corte', 'Contenido', 'Hemostática', 'Retractor',
                           'Accesorio', 'Implante', 'Otro'))
);

-- Catálogo de equipos médicos y quirúrgicos.
CREATE TABLE equipo (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    descripcion VARCHAR(250),
    tipo VARCHAR(20) NOT NULL,
    funcion VARCHAR(30) NOT NULL,
    CONSTRAINT ck_equipo_tipo
        CHECK (tipo IN ('Médico', 'Quirúrgico', 'Otro')),
    CONSTRAINT ck_equipo_funcion
        CHECK (funcion IN ('Exploración', 'Diagnóstico', 'Tratamiento',
                           'Rehabilitación', 'Otro'))
);

-- Registra los insumos utilizados en una cirugía (M:N).
CREATE TABLE cirugia_insumo (
    cirugia_solicitud_id INTEGER NOT NULL,
    insumo_id INTEGER NOT NULL,
    cantidad NUMERIC(12,2) NOT NULL,
    PRIMARY KEY (cirugia_solicitud_id, insumo_id),
    CONSTRAINT ck_cirugia_insumo_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_cirugia_insumo_cirugia
        FOREIGN KEY (cirugia_solicitud_id) REFERENCES cirugia_solicitud(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cirugia_insumo_insumo
        FOREIGN KEY (insumo_id) REFERENCES insumo(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Registra los instrumentos utilizados en una cirugía (M:N).
CREATE TABLE cirugia_instrumento (
    cirugia_solicitud_id INTEGER NOT NULL,
    instrumento_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    PRIMARY KEY (cirugia_solicitud_id, instrumento_id),
    CONSTRAINT ck_cirugia_instrumento_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_cirugia_instrumento_cirugia
        FOREIGN KEY (cirugia_solicitud_id) REFERENCES cirugia_solicitud(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cirugia_instrumento_instrumento
        FOREIGN KEY (instrumento_id) REFERENCES instrumento(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Registra los equipos utilizados en una cirugía (M:N).
CREATE TABLE cirugia_equipo (
    cirugia_solicitud_id INTEGER NOT NULL,
    equipo_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    PRIMARY KEY (cirugia_solicitud_id, equipo_id),
    CONSTRAINT ck_cirugia_equipo_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_cirugia_equipo_cirugia
        FOREIGN KEY (cirugia_solicitud_id) REFERENCES cirugia_solicitud(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cirugia_equipo_equipo
        FOREIGN KEY (equipo_id) REFERENCES equipo(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Catálogo de exámenes de laboratorio solicitables.
CREATE TABLE examen_laboratorio (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    tipo VARCHAR(30) NOT NULL,
    descripcion VARCHAR(250),
    CONSTRAINT ck_examen_laboratorio_tipo
        CHECK (tipo IN ('Sangre', 'Orina', 'Heces', 'Imagenología', 'Otro'))
);

-- Registra las órdenes de laboratorio solicitadas en una consulta o cirugía.
CREATE TABLE orden_laboratorio (
    id INTEGER PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    medico_solicita_id INTEGER NOT NULL,
    consulta_id INTEGER,
    cirugia_solicitud_id INTEGER,
    fecha_hora_solicitud TIMESTAMP NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Solicitada',
    observaciones TEXT,
    CONSTRAINT ck_orden_laboratorio_estado
        CHECK (estado IN ('Solicitada', 'En proceso', 'Completada', 'Cancelada')),
    CONSTRAINT ck_orden_laboratorio_origen
        CHECK (consulta_id IS NOT NULL OR cirugia_solicitud_id IS NOT NULL),
    CONSTRAINT fk_orden_laboratorio_paciente
        FOREIGN KEY (paciente_id) REFERENCES paciente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_orden_laboratorio_medico
        FOREIGN KEY (medico_solicita_id) REFERENCES personal_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_orden_laboratorio_consulta
        FOREIGN KEY (consulta_id) REFERENCES consulta(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_orden_laboratorio_cirugia
        FOREIGN KEY (cirugia_solicitud_id) REFERENCES cirugia_solicitud(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Relaciona una orden de laboratorio con los exámenes solicitados y su resultado (M:N).
CREATE TABLE orden_laboratorio_examen (
    orden_laboratorio_id INTEGER NOT NULL,
    examen_laboratorio_id INTEGER NOT NULL,
    resultado TEXT,
    fecha_resultado TIMESTAMP,
    PRIMARY KEY (orden_laboratorio_id, examen_laboratorio_id),
    CONSTRAINT fk_orden_examen_orden
        FOREIGN KEY (orden_laboratorio_id) REFERENCES orden_laboratorio(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_orden_examen_examen
        FOREIGN KEY (examen_laboratorio_id) REFERENCES examen_laboratorio(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
