-- Ejecutar con psql -X -v ON_ERROR_STOP=1 -f ... como hospital_admin.
-- Las rutas de \ir son relativas a este archivo. Siempre revierte el escenario.
\set ON_ERROR_STOP on
CREATE TEMP VIEW estado_facturacion AS
SELECT 'factura' AS tabla,md5(jsonb_agg(t ORDER BY id)::text) AS huella FROM factura t
UNION ALL SELECT 'factura_detalle',md5(jsonb_agg(t ORDER BY id)::text) FROM factura_detalle t
UNION ALL SELECT 'pago',md5(jsonb_agg(t ORDER BY id)::text) FROM pago t
UNION ALL SELECT 'pago_metodo',md5(jsonb_agg(t ORDER BY pago_id)::text) FROM pago_metodo t;
CREATE TEMP TABLE estado_inicial AS SELECT * FROM estado_facturacion;

BEGIN;
\ir ../dml/05_escenarios_pago.sql
DO $$
BEGIN
    IF (SELECT count(*) FROM factura WHERE id BETWEEN 20001 AND 20063) <> 63
       OR (SELECT count(*) FROM factura_detalle WHERE id BETWEEN 20001 AND 20066) <> 66
       OR (SELECT count(*) FROM pago WHERE id BETWEEN 20001 AND 20063) <> 63
       OR (SELECT count(*) FROM pago_metodo WHERE pago_id BETWEEN 20001 AND 20063) <> 63 THEN
        RAISE EXCEPTION 'Cantidad de registros inesperada';
    END IF;
    IF (SELECT count(*) FROM (
        SELECT hospital_id,unidad_medica_id,metodo FROM v_cobro_unidad
        WHERE factura_id BETWEEN 20001 AND 20060
        GROUP BY hospital_id,unidad_medica_id,metodo
    ) grupos) <> 60 THEN
        RAISE EXCEPTION 'Falta un método en alguna unidad/hospital';
    END IF;
    IF (SELECT sum(monto) FROM v_cobro_unidad WHERE factura_id BETWEEN 20001 AND 20063) <> 30500
       OR EXISTS (SELECT 1 FROM v_cobro_unidad WHERE factura_id IN (20062,20063)) THEN
        RAISE EXCEPTION 'Total incorrecto o se incluyó una factura anulada/sin pagos';
    END IF;
    IF EXISTS (
        SELECT 1 FROM v_cobro_unidad WHERE factura_id BETWEEN 20001 AND 20063
        GROUP BY pago_id HAVING sum(monto) <> (SELECT p.monto FROM pago p WHERE p.id=pago_id)
    ) THEN
        RAISE EXCEPTION 'El prorrateo duplica o pierde dinero';
    END IF;
    IF EXISTS (
        SELECT 1 FROM v_cobro_unidad WHERE factura_id=20061
        GROUP BY unidad_medica_id HAVING sum(monto) <> 50*unidad_medica_id
    ) THEN
        RAISE EXCEPTION 'La factura parcial no reparte 50, 100, 150 y 200 por unidad';
    END IF;
    RAISE NOTICE 'OK: 60 combinaciones; 30500 cobrados; cuotas y prorrateo correctos; anulada y pendiente excluidas';
END $$;

-- Salida real del objetivo 8 con el escenario temporal cargado.
\ir ../consultas/08_metodos_pago.sql
ROLLBACK;

DO $$
BEGIN
    IF EXISTS (SELECT * FROM estado_facturacion EXCEPT SELECT * FROM estado_inicial)
       OR EXISTS (SELECT * FROM estado_inicial EXCEPT SELECT * FROM estado_facturacion) THEN
        RAISE EXCEPTION 'La facturación no coincide con el estado inicial';
    END IF;
    RAISE NOTICE 'OK: ROLLBACK verificado; las cuatro tablas coinciden con su estado inicial';
END $$;
DROP VIEW estado_facturacion;
DROP TABLE estado_inicial;
