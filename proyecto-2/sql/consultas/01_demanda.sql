-- Objetivo 1. Reservaciones vigentes, consultas y próximas consultas por hospital.
SELECT h.id, h.nombre,
       SUM(e.reservas) AS reservaciones,
       SUM(e.consultas) AS consultas,
       SUM(e.proximas) AS proximas_consultas,
       SUM(e.reservas + e.consultas + e.proximas) AS demanda
FROM hospital h
JOIN (
    SELECT hospital_id, 1 AS reservas, 0 AS consultas, 0 AS proximas
    FROM cita
    WHERE estado <> 'Cancelada'
      AND fecha_hora >= TIMESTAMP '2026-09-01' AND fecha_hora < TIMESTAMP '2026-11-01'
    UNION ALL
    SELECT a.hospital_id, 0, 1, 0
    FROM consulta c JOIN cita a ON a.id = c.cita_id
    WHERE c.fecha_hora >= TIMESTAMP '2026-09-01' AND c.fecha_hora < TIMESTAMP '2026-11-01'
    UNION ALL
    SELECT a.hospital_id, 0, 0, 1
    FROM receta r
    JOIN consulta c ON c.id = r.consulta_id
    JOIN cita a ON a.id = c.cita_id
    WHERE r.proxima_cita >= TIMESTAMP '2026-09-01' AND r.proxima_cita < TIMESTAMP '2026-11-01'
) e ON e.hospital_id = h.id
GROUP BY h.id, h.nombre
ORDER BY demanda DESC, h.id
LIMIT 3;
