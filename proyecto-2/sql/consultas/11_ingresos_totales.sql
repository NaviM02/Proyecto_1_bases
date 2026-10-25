-- Objetivo 11. Suma los pagos recibidos; también muestra hospitales sin cobros.
SELECT h.id,
       h.nombre,
       COALESCE(ROUND(SUM(p.monto), 2), 0.00) AS ingresos
FROM hospital h
LEFT JOIN factura f
       ON f.hospital_id = h.id
      AND f.estado <> 'Anulada'
LEFT JOIN pago p
       ON p.factura_id = f.id
      AND p.fecha_pago >= TIMESTAMP '2026-09-01'
      AND p.fecha_pago < TIMESTAMP '2026-11-01'
GROUP BY h.id, h.nombre
ORDER BY ingresos DESC, h.id;
