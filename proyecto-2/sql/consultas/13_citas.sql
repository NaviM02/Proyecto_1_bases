-- Objetivo 13. Citas por fecha, sexo y especialidad principal del médico.
SELECT h.id, h.nombre, CAST(a.fecha_hora AS date) AS fecha, p.sexo,
       CASE WHEN e.nombre IS NULL THEN 'Sin especialidad' ELSE e.nombre END AS especialidad,
       COUNT(*) AS citas,
       SUM(CASE WHEN a.estado = 'Cancelada' THEN 1 ELSE 0 END) AS canceladas,
       SUM(CASE WHEN a.estado <> 'Cancelada' THEN 1 ELSE 0 END) AS demanda_vigente
FROM cita a
JOIN hospital h ON h.id = a.hospital_id
JOIN paciente p ON p.id = a.paciente_id
LEFT JOIN especialidad e ON e.id = (
    -- Si el médico tiene varias especialidades, elige la principal; si empatan, el ID menor.
    SELECT pe.especialidad_id
    FROM personal_especialidad pe
    WHERE pe.personal_medico_id = a.medico_id
    ORDER BY pe.principal DESC, pe.especialidad_id
    LIMIT 1
)
GROUP BY h.id, h.nombre, CAST(a.fecha_hora AS date), p.sexo, e.nombre
ORDER BY fecha, h.id, p.sexo, especialidad;
