BEGIN;
-- Las dos evaluaciones sintéticas corresponden a la consulta del mismo médico/paciente.
INSERT INTO calificacion_consulta
SELECT ca.id,co.id FROM calificacion ca JOIN consulta co ON co.medico_id=ca.personal_medico_id
WHERE ca.id BETWEEN 1002 AND 1049 AND co.id BETWEEN 1001 AND 1024;
-- Vínculos de fase 1 verificables en DML/05_cirugia.sql y DML/08_facturacion.sql.
-- No se vincula la cirugía 3, que carece de una línea de cobro identificable.
INSERT INTO cirugia_factura_detalle VALUES (3,1),(8,2);
COMMIT;
