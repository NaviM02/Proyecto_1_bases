-- Objetivo 5. Cirujanos con agendamientos aprobados y las tres listas de recursos documentadas.
SELECT m.id, m.nombres, COUNT(*) AS aprobados,
       SUM(ci.total) AS insumos, SUM(it.total) AS instrumentos, SUM(eq.total) AS equipos
FROM cirugia_solicitud s
JOIN personal_medico m ON m.id = s.cirujano_id
JOIN (
    SELECT cirugia_solicitud_id, SUM(cantidad) AS total
    FROM cirugia_insumo GROUP BY cirugia_solicitud_id
) ci ON ci.cirugia_solicitud_id = s.id
JOIN (
    SELECT cirugia_solicitud_id, SUM(cantidad) AS total
    FROM cirugia_instrumento GROUP BY cirugia_solicitud_id
) it ON it.cirugia_solicitud_id = s.id
JOIN (
    SELECT cirugia_solicitud_id, SUM(cantidad) AS total
    FROM cirugia_equipo GROUP BY cirugia_solicitud_id
) eq ON eq.cirugia_solicitud_id = s.id
WHERE s.fecha_hora_aprobacion >= TIMESTAMP '2026-09-01'
  AND s.fecha_hora_aprobacion < TIMESTAMP '2026-11-01'
  AND s.estado IN ('Aprobada', 'Programada', 'Realizada')
GROUP BY m.id, m.nombres
ORDER BY aprobados DESC, insumos, instrumentos, equipos, m.id
LIMIT 3;
