-- Objetivo 17. Posiciones locales y globales; la posición 1 corresponde al mejor promedio.
-- Las funciones de ventana calculan el ranking sin perder las filas de cada médico.
SELECT l.medico_id, p.nombres, h.nombre AS hospital, ROUND(l.promedio, 2) AS promedio,
       l.consultas_calificadas, l.posicion_hospital,
       ROUND(g.promedio_global, 2) AS promedio_global, g.posicion_global
FROM (
    SELECT n.medico_id, n.hospital_id, n.consultas_calificadas,
           n.suma_notas / n.evaluaciones AS promedio,
           DENSE_RANK() OVER (
               PARTITION BY n.hospital_id ORDER BY n.suma_notas / n.evaluaciones DESC
           ) AS posicion_hospital,
           ROW_NUMBER() OVER (
               PARTITION BY n.hospital_id ORDER BY n.suma_notas / n.evaluaciones, n.medico_id
           ) AS peores
    FROM v_nota_consulta n
) l
JOIN (
    SELECT totales.medico_id, totales.promedio_global,
           DENSE_RANK() OVER (ORDER BY totales.promedio_global DESC) AS posicion_global
    FROM (
        SELECT medico_id, SUM(suma_notas) / SUM(evaluaciones) AS promedio_global
        FROM v_nota_consulta
        GROUP BY medico_id
    ) totales
) g ON g.medico_id = l.medico_id
JOIN personal p ON p.id = l.medico_id
JOIN hospital h ON h.id = l.hospital_id
WHERE l.peores <= 5
ORDER BY h.id, l.promedio, l.medico_id;
