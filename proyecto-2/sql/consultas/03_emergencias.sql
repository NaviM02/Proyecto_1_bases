-- Objetivo 3. Horas y turnos de emergencias junto con egresos vivos consentidos.
SELECT m.id, m.nombres, h.nombre AS hospital,
       ROUND(t.horas, 2) AS horas, t.turnos,
       CASE WHEN e.egresos_vivos_consentidos IS NULL THEN 0
            ELSE e.egresos_vivos_consentidos END AS egresos_vivos_consentidos
FROM personal_medico m
JOIN (
    SELECT medico_id, hospital_id, COUNT(*) AS turnos,
           SUM(EXTRACT(EPOCH FROM (
               CASE WHEN fin > :'hasta'::timestamp THEN :'hasta'::timestamp ELSE fin END
               - CASE WHEN inicio < :'desde'::timestamp THEN :'desde'::timestamp ELSE inicio END
           )) / 3600) AS horas
    FROM turno_medico
    WHERE unidad_medica_id = 2
      AND inicio < :'hasta'::timestamp AND fin > :'desde'::timestamp
    GROUP BY medico_id, hospital_id
) t ON t.medico_id = m.id
JOIN hospital h ON h.id = t.hospital_id
LEFT JOIN (
    SELECT medico_asignado_id, hospital_id, COUNT(*) AS egresos_vivos_consentidos
    FROM egreso
    WHERE unidad_medica_id = 2 AND codigo_egreso = 'Vivo'
      AND sin_consentimiento_medico = FALSE
      AND fecha_hora >= :'desde'::timestamp AND fecha_hora < :'hasta'::timestamp
    GROUP BY medico_asignado_id, hospital_id
) e ON e.medico_asignado_id = m.id AND e.hospital_id = h.id
ORDER BY horas DESC, turnos DESC, egresos_vivos_consentidos DESC, m.id
LIMIT 5;
