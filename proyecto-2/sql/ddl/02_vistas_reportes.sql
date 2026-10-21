BEGIN;
-- Atribución comprobable de una evaluación a un servicio de consulta externa.
CREATE TABLE calificacion_consulta (
    calificacion_id integer PRIMARY KEY REFERENCES calificacion(id) ON DELETE CASCADE ON UPDATE CASCADE,
    consulta_id integer NOT NULL REFERENCES consulta(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- Cobros reales repartidos por el peso de cada línea; no se repite el pago entero por unidad.
-- Las líneas sin servicio o facturas sin desglose quedan como unidad NULL (sin identificar).
CREATE VIEW v_cobro_unidad AS
SELECT p.id AS pago_id,p.fecha_pago,p.numero_pago,f.id AS factura_id,f.hospital_id,
       f.paciente_id,d.id AS detalle_id,s.unidad_medica_id,
       p.monto * CASE WHEN d.id IS NULL THEN 1 ELSE d.subtotal / NULLIF(f.total,0) END AS monto,
       pm.metodo,cf.cirugia_id
FROM pago p JOIN factura f ON f.id=p.factura_id
LEFT JOIN factura_detalle d ON d.factura_id=f.id
LEFT JOIN servicio_medico s ON s.id=d.servicio_medico_id
LEFT JOIN pago_metodo pm ON pm.pago_id=p.id
LEFT JOIN cirugia_factura_detalle cf ON cf.factura_detalle_id=d.id
WHERE f.estado<>'Anulada';
-- Agrega evaluaciones antes de unirlas con consultas, evitando el producto M:N.
CREATE VIEW v_nota_consulta AS
SELECT co.medico_id,a.hospital_id,count(DISTINCT co.id) AS consultas_calificadas,
       sum(c.puntuacion)::numeric AS suma_notas,count(*) AS evaluaciones
FROM calificacion_consulta cc JOIN calificacion c ON c.id=cc.calificacion_id
JOIN consulta co ON co.id=cc.consulta_id JOIN cita a ON a.id=co.cita_id
WHERE c.personal_medico_id=co.medico_id
GROUP BY co.medico_id,a.hospital_id;
GRANT SELECT ON calificacion_consulta,v_cobro_unidad,v_nota_consulta TO hospital_lector;
COMMIT;
