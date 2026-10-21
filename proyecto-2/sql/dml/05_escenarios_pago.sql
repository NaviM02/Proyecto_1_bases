-- Objetivo 8: escenario financiero ficticio adicional sobre Proyecto 2 instalado.
-- Ejecutar en una transacción (psql --single-transaction o BEGIN/COMMIT en DBeaver).
-- No idempotente: una colisión de IDs aborta, sin sobrescribir datos existentes.
-- IDs 20001..20063; no se alteran los métodos desconocidos de pagos históricos.
DO $$
BEGIN
    IF (SELECT count(*) FROM hospital WHERE id IN (1,2,101,102,103)) <> 5
       OR NOT EXISTS (SELECT 1 FROM paciente WHERE id=1001) THEN
        RAISE EXCEPTION 'Se requiere Proyecto 2 instalado con los cinco hospitales y el paciente ficticio 1001';
    END IF;
END $$;

-- 5 hospitales x 4 unidades x 3 métodos: 60 facturas pagadas.
INSERT INTO factura (id,paciente_id,hospital_id,fecha_emision,descripcion,total,estado)
SELECT 20000+(h.n-1)*12+(u-1)*3+m,1001,h.id,timestamp '2026-10-28 10:00',
       'Escenario ficticio P2 pagos: unidad '||u||', método '||m,100*u*m,'Pagada'
FROM (VALUES (1,1),(2,2),(3,101),(4,102),(5,103)) h(n,id)
CROSS JOIN generate_series(1,4) u CROSS JOIN generate_series(1,3) m;

INSERT INTO factura_detalle (id,factura_id,servicio_medico_id,descripcion,cantidad,precio_unitario,subtotal)
SELECT id,id,CASE ((id-20001)%12)/3 WHEN 0 THEN 1 WHEN 1 THEN 3 WHEN 2 THEN 4 ELSE 5 END,
       descripcion,1,total,total FROM factura WHERE id BETWEEN 20001 AND 20060;

INSERT INTO pago (id,factura_id,numero_pago,fecha_pago,monto)
SELECT id,id,1,timestamp '2026-10-28 11:00',total FROM factura WHERE id BETWEEN 20001 AND 20060;
INSERT INTO pago_metodo (pago_id,metodo)
SELECT id,CASE (id-20001)%3 WHEN 0 THEN 'Efectivo' WHEN 1 THEN 'Tarjeta de crédito'
       ELSE 'Tarjeta de débito' END FROM pago WHERE id BETWEEN 20001 AND 20060;

-- Factura parcial multiunidad: 1000 facturados, solo 500 cobrados en dos cuotas.
INSERT INTO factura VALUES
    (20061,1001,2,'2026-10-28 10:00','Escenario ficticio P2 pagos: factura multiunidad',1000,'Parcial'),
    (20062,1001,2,'2026-10-28 10:00','Escenario ficticio P2 pagos: factura anulada',999,'Anulada'),
    (20063,1001,2,'2026-10-28 10:00','Escenario ficticio P2 pagos: factura sin pagos',777,'Pendiente');
INSERT INTO factura_detalle (id,factura_id,servicio_medico_id,descripcion,cantidad,precio_unitario,subtotal)
SELECT 20060+u,20061,CASE u WHEN 1 THEN 1 WHEN 2 THEN 3 WHEN 3 THEN 4 ELSE 5 END,
       'Escenario ficticio P2 pagos: línea multiunidad '||u,1,100*u,100*u
FROM generate_series(1,4) u;
INSERT INTO factura_detalle VALUES
    (20065,20062,1,'Escenario ficticio P2 pagos: línea anulada',1,999,999),
    (20066,20063,1,'Escenario ficticio P2 pagos: línea pendiente',1,777,777);
INSERT INTO pago VALUES
    (20061,20061,1,'2026-10-28 11:00',200),
    (20062,20061,2,'2026-10-28 12:00',300),
    (20063,20062,1,'2026-10-28 11:00',999);
INSERT INTO pago_metodo VALUES
    (20061,'Tarjeta de crédito'),(20062,'Tarjeta de débito'),(20063,'Efectivo');
