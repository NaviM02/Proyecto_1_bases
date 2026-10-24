-- Objetivo 11. Ingreso = efectivo cobrado, no total facturado pendiente; incluir hospitales sin cobros.
SELECT h.id,h.nombre,
 CASE WHEN SUM(p.monto) IS NULL THEN 0.00 ELSE ROUND(SUM(p.monto),2) END AS ingresos
FROM hospital h LEFT JOIN factura f ON f.hospital_id=h.id AND f.estado<>'Anulada'
LEFT JOIN pago p ON p.factura_id=f.id AND p.fecha_pago >= TIMESTAMP '2026-09-01' AND p.fecha_pago < TIMESTAMP '2026-11-01'
GROUP BY h.id ORDER BY ingresos DESC,h.id;
