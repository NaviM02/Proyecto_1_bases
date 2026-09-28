-- Facturación y pagos

-- Registra las facturas emitidas por los servicios hospitalarios.
CREATE TABLE factura (
    id INTEGER PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    hospital_id INTEGER NOT NULL,
    fecha_emision TIMESTAMP NOT NULL,
    descripcion TEXT NOT NULL,
    total NUMERIC(12,2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    CONSTRAINT ck_factura_total CHECK (total >= 0),
    CONSTRAINT ck_factura_estado
        CHECK (estado IN ('Pendiente', 'Parcial', 'Pagada', 'Anulada')),
    CONSTRAINT fk_factura_paciente
        FOREIGN KEY (paciente_id) REFERENCES paciente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_factura_hospital
        FOREIGN KEY (hospital_id) REFERENCES hospital(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Desglosa los servicios y conceptos incluidos en una factura.
CREATE TABLE factura_detalle (
    id INTEGER PRIMARY KEY,
    factura_id INTEGER NOT NULL,
    servicio_medico_id INTEGER,
    descripcion VARCHAR(250) NOT NULL,
    cantidad NUMERIC(12,2) NOT NULL,
    precio_unitario NUMERIC(12,2) NOT NULL,
    subtotal NUMERIC(12,2) NOT NULL,
    CONSTRAINT ck_factura_detalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT ck_factura_detalle_precio CHECK (precio_unitario >= 0),
    CONSTRAINT fk_factura_detalle_factura
        FOREIGN KEY (factura_id) REFERENCES factura(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_factura_detalle_servicio
        FOREIGN KEY (servicio_medico_id) REFERENCES servicio_medico(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Registra los pagos realizados sobre las facturas, incluyendo cuotas (1 a 12).
CREATE TABLE pago (
    id INTEGER PRIMARY KEY,
    factura_id INTEGER NOT NULL,
    numero_pago INTEGER NOT NULL,
    fecha_pago TIMESTAMP NOT NULL,
    monto NUMERIC(12,2) NOT NULL,
    CONSTRAINT uq_pago_factura_numero UNIQUE (factura_id, numero_pago),
    CONSTRAINT ck_pago_numero CHECK (numero_pago BETWEEN 1 AND 12),
    CONSTRAINT ck_pago_monto CHECK (monto > 0),
    CONSTRAINT fk_pago_factura
        FOREIGN KEY (factura_id) REFERENCES factura(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
