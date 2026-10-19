-- Objetivo 8. Pagos por método y unidad, con el total de cada hospital.
SELECT r.id, r.nombre, r.unidad, r.efectivo, r.credito, r.debito, r.sin_metodo, r.total
FROM (
    SELECT h.id, h.nombre,
           CASE WHEN u.nombre IS NULL THEN 'Sin identificar' ELSE u.nombre END AS unidad,
           ROUND(SUM(CASE WHEN v.metodo = 'Efectivo' AND v.monto IS NOT NULL THEN v.monto ELSE 0 END), 2) AS efectivo,
           ROUND(SUM(CASE WHEN v.metodo = 'Tarjeta de crédito' AND v.monto IS NOT NULL THEN v.monto ELSE 0 END), 2) AS credito,
           ROUND(SUM(CASE WHEN v.metodo = 'Tarjeta de débito' AND v.monto IS NOT NULL THEN v.monto ELSE 0 END), 2) AS debito,
           ROUND(SUM(CASE WHEN v.metodo IS NULL AND v.monto IS NOT NULL THEN v.monto ELSE 0 END), 2) AS sin_metodo,
           ROUND(SUM(v.monto), 2) AS total, 0 AS orden
    FROM v_cobro_unidad v
    JOIN hospital h ON h.id = v.hospital_id
    LEFT JOIN unidad_medica u ON u.id = v.unidad_medica_id
    GROUP BY h.id, h.nombre, v.unidad_medica_id, u.nombre
    UNION ALL
    SELECT h.id, h.nombre, 'TOTAL HOSPITAL',
           ROUND(SUM(CASE WHEN v.metodo = 'Efectivo' AND v.monto IS NOT NULL THEN v.monto ELSE 0 END), 2),
           ROUND(SUM(CASE WHEN v.metodo = 'Tarjeta de crédito' AND v.monto IS NOT NULL THEN v.monto ELSE 0 END), 2),
           ROUND(SUM(CASE WHEN v.metodo = 'Tarjeta de débito' AND v.monto IS NOT NULL THEN v.monto ELSE 0 END), 2),
           ROUND(SUM(CASE WHEN v.metodo IS NULL AND v.monto IS NOT NULL THEN v.monto ELSE 0 END), 2),
           ROUND(SUM(v.monto), 2), 1
    FROM v_cobro_unidad v
    JOIN hospital h ON h.id = v.hospital_id
    GROUP BY h.id, h.nombre
) r
ORDER BY r.id, r.orden, r.unidad;
