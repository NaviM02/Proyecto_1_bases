-- Objetivo 18. Pacientes atendidos en las cuatro unidades de un mismo hospital durante el intervalo.
SELECT p.id, p.nombres, p.apellidos, h.id AS hospital_id, h.nombre AS hospital
FROM (
    SELECT c.paciente_id, a.hospital_id, 1 AS unidad_medica_id
    FROM consulta c JOIN cita a ON a.id = c.cita_id
    WHERE c.fecha_hora >= :'desde'::timestamp AND c.fecha_hora < :'hasta'::timestamp
    UNION
    SELECT paciente_id, hospital_id, 2
    FROM ingreso
    WHERE unidad_medica_id = 2
      AND fecha_hora >= :'desde'::timestamp AND fecha_hora < :'hasta'::timestamp
    UNION
    SELECT paciente_id, hospital_id, 3
    FROM cirugia_solicitud
    WHERE estado = 'Realizada'
      AND fecha_hora_programada >= :'desde'::timestamp AND fecha_hora_programada < :'hasta'::timestamp
    UNION
    SELECT paciente_id, hospital_id, 4
    FROM hospitalizacion
    WHERE fecha_hora_ingreso >= :'desde'::timestamp AND fecha_hora_ingreso < :'hasta'::timestamp
) a
JOIN paciente p ON p.id = a.paciente_id
JOIN hospital h ON h.id = a.hospital_id
GROUP BY p.id, p.nombres, p.apellidos, h.id, h.nombre
HAVING COUNT(DISTINCT a.unidad_medica_id) = 4
ORDER BY h.id, p.id;
