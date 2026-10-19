-- Objetivo 9. Una cita y su consulta representan una sola visita; se excluyen cancelaciones.
SELECT h.id, h.nombre, c.visitas, ROUND(d.ingresos, 2) AS ingresos,
       ROUND(d.ingresos / c.visitas, 2) AS ingreso_por_visita
FROM hospital h
JOIN (
    SELECT visitas.hospital_id, COUNT(*) AS visitas
    FROM (
        SELECT hospital_id
        FROM ingreso
        WHERE fecha_hora >= :'desde'::timestamp AND fecha_hora < :'hasta'::timestamp
        UNION ALL
        SELECT a.hospital_id
        FROM cita a LEFT JOIN consulta c ON c.cita_id = a.id
        WHERE a.estado <> 'Cancelada'
          AND CASE WHEN c.fecha_hora IS NULL THEN a.fecha_hora ELSE c.fecha_hora END >= :'desde'::timestamp
          AND CASE WHEN c.fecha_hora IS NULL THEN a.fecha_hora ELSE c.fecha_hora END < :'hasta'::timestamp
    ) visitas
    GROUP BY visitas.hospital_id
) c ON c.hospital_id = h.id
JOIN (
    SELECT hospital_id, SUM(monto) AS ingresos
    FROM v_cobro_unidad
    WHERE fecha_pago >= :'desde'::timestamp AND fecha_pago < :'hasta'::timestamp
    GROUP BY hospital_id
) d ON d.hospital_id = h.id
ORDER BY ingreso_por_visita DESC, c.visitas, h.id
LIMIT 3;
