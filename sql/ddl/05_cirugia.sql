-- Cirugía y programación quirúrgica

-- Registra las solicitudes, aprobaciones y programación de cirugías.
CREATE TABLE cirugia_solicitud (
    id INTEGER PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    hospital_id INTEGER NOT NULL,
    cirujano_id INTEGER NOT NULL,
    tipo_procedimiento TEXT NOT NULL,
    caracter VARCHAR(12) NOT NULL,
    tiempo_estimado_minutos INTEGER NOT NULL,
    tipo_anestesia VARCHAR(100) NOT NULL,
    requerimientos TEXT,
    fecha_hora_solicitud TIMESTAMP NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    razon_rechazo TEXT,
    fecha_hora_aprobacion TIMESTAMP,
    fecha_hora_programada TIMESTAMP,
    quirofano_id INTEGER,
    CONSTRAINT ck_cirugia_solicitud_caracter
        CHECK (caracter IN ('Urgente', 'Programado')),
    CONSTRAINT ck_cirugia_solicitud_tiempo
        CHECK (tiempo_estimado_minutos > 0),
    CONSTRAINT ck_cirugia_solicitud_estado
        CHECK (estado IN ('Pendiente', 'Aprobada', 'Rechazada', 'Programada', 'Realizada', 'Cancelada')),
    CONSTRAINT ck_cirugia_solicitud_rechazo
        CHECK ((estado = 'Rechazada' AND razon_rechazo IS NOT NULL)
            OR estado <> 'Rechazada'),
    CONSTRAINT fk_cirugia_solicitud_paciente
        FOREIGN KEY (paciente_id) REFERENCES paciente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cirugia_solicitud_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cirugia_solicitud_cirujano
        FOREIGN KEY (cirujano_id) REFERENCES personal_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cirugia_solicitud_quirofano
        FOREIGN KEY (quirofano_id) REFERENCES recurso_asistencial(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Registra el consentimiento informado requerido para una cirugía.
CREATE TABLE consentimiento_informado (
    id INTEGER PRIMARY KEY,
    cirugia_solicitud_id INTEGER NOT NULL UNIQUE,
    procedimiento TEXT NOT NULL,
    objetivo TEXT NOT NULL,
    caracteristicas TEXT NOT NULL,
    riesgos TEXT NOT NULL,
    medico_id INTEGER NOT NULL,
    paciente_o_representante VARCHAR(200) NOT NULL,
    fecha_obtencion DATE NOT NULL,
    firmado BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_consentimiento_cirugia
        FOREIGN KEY (cirugia_solicitud_id) REFERENCES cirugia_solicitud(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_consentimiento_medico
        FOREIGN KEY (medico_id) REFERENCES personal_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Registra la evaluación y planificación preanestésica.
CREATE TABLE chequeo_preanestesico (
    id INTEGER PRIMARY KEY,
    cirugia_solicitud_id INTEGER NOT NULL UNIQUE,
    asa VARCHAR(10) NOT NULL,
    medico_clasifica_id INTEGER NOT NULL,
    plan_anestesia TEXT NOT NULL,
    anestesista_id INTEGER NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    CONSTRAINT ck_chequeo_preanestesico_asa
        CHECK (asa IN ('I', 'II', 'III', 'IV', 'V', 'VI')),
    CONSTRAINT fk_chequeo_preanestesico_cirugia
        FOREIGN KEY (cirugia_solicitud_id) REFERENCES cirugia_solicitud(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_chequeo_preanestesico_medico
        FOREIGN KEY (medico_clasifica_id) REFERENCES personal_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_chequeo_preanestesico_anestesista
        FOREIGN KEY (anestesista_id) REFERENCES personal_medico(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Registra las etapas del proceso quirúrgico con su enfermero responsable.
CREATE TABLE cirugia_etapa (
    id INTEGER PRIMARY KEY,
    cirugia_solicitud_id INTEGER NOT NULL,
    etapa VARCHAR(20) NOT NULL,
    fecha_hora_inicio TIMESTAMP,
    fecha_hora_fin TIMESTAMP,
    enfermero_responsable_id INTEGER,
    observaciones TEXT,
    CONSTRAINT ck_cirugia_etapa_tipo
        CHECK (etapa IN ('Preoperatorio', 'Intraoperatorio', 'Postoperatorio')),
    CONSTRAINT ck_cirugia_etapa_fechas
        CHECK (fecha_hora_fin IS NULL OR fecha_hora_inicio IS NULL
            OR fecha_hora_fin >= fecha_hora_inicio),
    CONSTRAINT fk_cirugia_etapa_cirugia
        FOREIGN KEY (cirugia_solicitud_id) REFERENCES cirugia_solicitud(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cirugia_etapa_enfermero
        FOREIGN KEY (enfermero_responsable_id) REFERENCES personal_medico(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Registra los chequeos y resultados del proceso quirúrgico.
CREATE TABLE chequeo_quirurgico (
    id INTEGER PRIMARY KEY,
    cirugia_solicitud_id INTEGER NOT NULL,
    etapa VARCHAR(30) NOT NULL,
    aspecto VARCHAR(150) NOT NULL,
    resultado VARCHAR(30) NOT NULL,
    observaciones TEXT,
    fecha_hora TIMESTAMP NOT NULL,
    registrado_por_id INTEGER,
    CONSTRAINT ck_chequeo_quirurgico_etapa
        CHECK (etapa IN ('Planificación', 'Entrada', 'Quirófano', 'Pausa quirúrgica', 'Salida quirúrgica', 'Postoperatorio', 'Traslado seguro')),
    CONSTRAINT ck_chequeo_quirurgico_resultado
        CHECK (resultado IN ('Éxito', 'Fallo', 'Aceptable', 'Medianamente aceptable', 'No aceptable')),
    CONSTRAINT fk_chequeo_quirurgico_cirugia
        FOREIGN KEY (cirugia_solicitud_id) REFERENCES cirugia_solicitud(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_chequeo_quirurgico_personal
        FOREIGN KEY (registrado_por_id) REFERENCES personal_medico(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Registra la historia clínica (interrogatorio) del paciente asociada a una cirugía.
CREATE TABLE historia_clinica (
    id INTEGER PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    cirugia_solicitud_id INTEGER UNIQUE,
    tipo_interrogatorio VARCHAR(10) NOT NULL,
    religion VARCHAR(80),
    ocupacion VARCHAR(120),
    lugar_nacimiento VARCHAR(150),
    lugar_residencia VARCHAR(150),
    antecedentes_heredofamiliares TEXT,
    antecedentes_personales_no_patologicos TEXT,
    antecedentes_patologicos TEXT,
    padecimiento_actual TEXT NOT NULL,
    interrogatorio_aparatos_sistemas TEXT,
    sintomas_generales_terapeutica TEXT,
    estudios_previos TEXT,
    fecha TIMESTAMP NOT NULL,
    CONSTRAINT ck_historia_clinica_interrogatorio
        CHECK (tipo_interrogatorio IN ('Directo', 'Indirecto')),
    CONSTRAINT fk_historia_clinica_paciente
        FOREIGN KEY (paciente_id) REFERENCES paciente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_historia_clinica_cirugia
        FOREIGN KEY (cirugia_solicitud_id) REFERENCES cirugia_solicitud(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Registra los hallazgos de la exploración física de una historia clínica.
CREATE TABLE exploracion_fisica (
    id INTEGER PRIMARY KEY,
    historia_clinica_id INTEGER NOT NULL,
    seccion VARCHAR(40) NOT NULL,
    hallazgo TEXT NOT NULL,
    CONSTRAINT ck_exploracion_fisica_seccion
        CHECK (seccion IN ('Signos vitales', 'Exploración general', 'Cabeza',
                           'Cuello', 'Tórax', 'Abdomen', 'Extremidades',
                           'Columna vertebral', 'Cavidad bucal', 'Cavidad vaginal',
                           'Cavidad rectal', 'Conducto auditivo externo')),
    CONSTRAINT fk_exploracion_fisica_historia
        FOREIGN KEY (historia_clinica_id) REFERENCES historia_clinica(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
