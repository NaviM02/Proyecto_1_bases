-- Datos operativos no registrados por la fase 1. Ejecutar como hospital_admin.
BEGIN;
-- Turnos efectivamente trabajados; no se deducen de las horas de ingreso.
CREATE TABLE turno_medico (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    medico_id integer NOT NULL REFERENCES personal_medico(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    hospital_id integer NOT NULL REFERENCES hospital(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    unidad_medica_id integer NOT NULL REFERENCES unidad_medica(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inicio timestamp NOT NULL,
    fin timestamp NOT NULL,
    -- Duración positiva, como máximo un día por turno.
    CONSTRAINT ck_turno_duracion CHECK (fin > inicio AND fin <= inicio + interval '24 hours'),
    UNIQUE (medico_id, inicio)
);
-- Observación histórica al llegar: el booleano actual de un recurso no da su disponibilidad pasada.
CREATE TABLE atencion_emergencia (
    ingreso_id integer PRIMARY KEY REFERENCES ingreso(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    inicio_atencion timestamp NOT NULL,
    turnos_espera integer NOT NULL,
    camas_disponibles_llegada integer NOT NULL,
    -- Conteos observados nunca negativos.
    CONSTRAINT ck_atencion_conteos CHECK (turnos_espera >= 0 AND camas_disponibles_llegada >= 0)
);
-- Método verificado por pago; los pagos antiguos sin dato permanecen sin clasificación.
CREATE TABLE pago_metodo (
    pago_id integer PRIMARY KEY REFERENCES pago(id) ON DELETE CASCADE ON UPDATE CASCADE,
    metodo varchar(25) NOT NULL,
    -- Solo los tres métodos solicitados.
    CONSTRAINT ck_pago_metodo CHECK (metodo IN ('Efectivo', 'Tarjeta de crédito', 'Tarjeta de débito'))
);
-- Identifica el procedimiento que originó una línea de factura, sin emparejar por paciente/fecha.
CREATE TABLE cirugia_factura_detalle (
    factura_detalle_id integer PRIMARY KEY REFERENCES factura_detalle(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    cirugia_id integer NOT NULL REFERENCES cirugia_solicitud(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
GRANT SELECT ON ALL TABLES IN SCHEMA public TO hospital_lector;
COMMIT;
