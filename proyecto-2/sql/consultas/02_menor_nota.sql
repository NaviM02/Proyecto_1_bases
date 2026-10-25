-- Objetivo 2. Muestra los cinco médicos con menor promedio de calificación.
SELECT m.id,
       m.nombres,
       m.apellidos,
       h.nombre AS hospital,
       ROUND(n.suma_notas / n.evaluaciones, 2) AS promedio,
       -- Este conteo corresponde al médico en el hospital evaluado.
       (SELECT COUNT(*)
        FROM consulta c
        JOIN cita a ON a.id = c.cita_id
        WHERE c.medico_id = m.id
          AND a.hospital_id = n.hospital_id) AS consultas,
       n.consultas_calificadas,
       n.evaluaciones
FROM v_nota_consulta n
JOIN personal_medico m ON m.id = n.medico_id
JOIN hospital h ON h.id = n.hospital_id
ORDER BY promedio, m.id, h.id
LIMIT 5;
