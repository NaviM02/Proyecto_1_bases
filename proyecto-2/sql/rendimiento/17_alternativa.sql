-- Objetivo 17. Posiciones calculadas contando promedios superiores y consultas previas en el orden.
SELECT n.medico_id, p.nombres, h.nombre AS hospital,
       ROUND(n.suma_notas / n.evaluaciones, 2) AS promedio, n.consultas_calificadas,
       1 + (
           SELECT COUNT(DISTINCT x.suma_notas / x.evaluaciones)
           FROM v_nota_consulta x
           WHERE x.hospital_id = n.hospital_id
             AND x.suma_notas / x.evaluaciones > n.suma_notas / n.evaluaciones
       ) AS posicion_hospital,
       ROUND(g.promedio_global, 2) AS promedio_global,
       1 + (
           SELECT COUNT(DISTINCT otro.promedio_global)
           FROM (
               SELECT medico_id, SUM(suma_notas) / SUM(evaluaciones) AS promedio_global
               FROM v_nota_consulta GROUP BY medico_id
           ) otro
           WHERE otro.promedio_global > g.promedio_global
       ) AS posicion_global
FROM v_nota_consulta n
JOIN (
    SELECT medico_id, SUM(suma_notas) / SUM(evaluaciones) AS promedio_global
    FROM v_nota_consulta GROUP BY medico_id
) g ON g.medico_id = n.medico_id
JOIN personal p ON p.id = n.medico_id
JOIN hospital h ON h.id = n.hospital_id
WHERE (
    SELECT COUNT(*)
    FROM v_nota_consulta x
    WHERE x.hospital_id = n.hospital_id
      AND (x.suma_notas / x.evaluaciones < n.suma_notas / n.evaluaciones
           OR (x.suma_notas / x.evaluaciones = n.suma_notas / n.evaluaciones AND x.medico_id < n.medico_id))
) < 5
ORDER BY h.id, n.suma_notas / n.evaluaciones, n.medico_id;
