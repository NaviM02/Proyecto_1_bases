-- Objetivo 10. Fechas con más decesos y unidades predominantes, conservando los empates.
SELECT h.nombre, d.fecha, d.total_dia, u.nombre AS unidad_predominante,
       c.decesos AS decesos_unidad
FROM v_decesos_dia d
JOIN hospital h ON h.id = d.hospital_id
JOIN v_decesos_unidad c ON c.hospital_id = d.hospital_id AND c.fecha = d.fecha
JOIN unidad_medica u ON u.id = c.unidad_medica_id
WHERE d.total_dia = (
    SELECT MAX(otro.total_dia)
    FROM v_decesos_dia otro
    WHERE otro.hospital_id = d.hospital_id
)
AND c.decesos = (
    SELECT MAX(otra.decesos)
    FROM v_decesos_unidad otra
    WHERE otra.hospital_id = d.hospital_id AND otra.fecha = d.fecha
)
ORDER BY h.id, d.fecha, u.id;
