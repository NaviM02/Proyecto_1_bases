-- Objetivo 14. Cuotas pagadas al corte por factura emitida dentro del intervalo.
-- Cada factura participa una vez por unidad médica, aunque tenga varias líneas de esa unidad.
SELECT h.id, h.nombre,
       CASE WHEN um.nombre IS NULL THEN 'Sin identificar' ELSE um.nombre END AS unidad,
       COUNT(*) AS facturas, ROUND(AVG(c.n), 2) AS promedio_cuotas_pagadas
FROM (
    SELECT f.id, COUNT(p.id) AS n
    FROM factura f
    LEFT JOIN pago p ON p.factura_id = f.id AND p.fecha_pago < TIMESTAMP '2026-11-01'
    WHERE f.estado <> 'Anulada'
      AND f.fecha_emision >= TIMESTAMP '2026-09-01' AND f.fecha_emision < TIMESTAMP '2026-11-01'
    GROUP BY f.id
) c
JOIN (
    SELECT DISTINCT f.id, f.hospital_id, s.unidad_medica_id
    FROM factura f
    LEFT JOIN factura_detalle d ON d.factura_id = f.id
    LEFT JOIN servicio_medico s ON s.id = d.servicio_medico_id
) u ON u.id = c.id
JOIN hospital h ON h.id = u.hospital_id
LEFT JOIN unidad_medica um ON um.id = u.unidad_medica_id
GROUP BY h.id, h.nombre, um.nombre
ORDER BY h.id, unidad;
