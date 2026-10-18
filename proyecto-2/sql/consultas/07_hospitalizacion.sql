-- Objetivo 7. Ingresos de hospitalización, camas asignadas y costo diario promedio.
SELECT h.id, h.nombre, ROUND(c.ingresos, 2) AS ingresos,
       u.camas_asignadas, ROUND(u.costo_promedio, 2) AS costo_promedio
FROM hospital h
JOIN (
    SELECT hospital_id, SUM(monto) AS ingresos
    FROM v_cobro_unidad
    WHERE unidad_medica_id = 4
      AND fecha_pago >= :'desde'::timestamp AND fecha_pago < :'hasta'::timestamp
    GROUP BY hospital_id
) c ON c.hospital_id = h.id
LEFT JOIN (
    SELECT hospital_id, COUNT(DISTINCT cama_id) AS camas_asignadas,
           AVG(costo_por_dia) AS costo_promedio
    FROM hospitalizacion
    WHERE fecha_hora_ingreso >= :'desde'::timestamp AND fecha_hora_ingreso < :'hasta'::timestamp
    GROUP BY hospital_id
) u ON u.hospital_id = h.id
ORDER BY ingresos DESC, camas_asignadas, costo_promedio, h.id
LIMIT 3;
