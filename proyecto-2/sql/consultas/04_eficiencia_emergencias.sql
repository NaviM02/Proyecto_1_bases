-- Objetivo 4. Disponibilidad observada a la llegada y turnos de espera en emergencias.
SELECT h.id, h.nombre, COUNT(*) AS ingresos,
       COUNT(e.id) AS egresos_de_esos_ingresos_al_corte,
       COUNT(a.ingreso_id) AS llegadas_observadas,
       ROUND(100.0 * COUNT(CASE WHEN a.camas_disponibles_llegada > 0 THEN 1 END)
             / COUNT(a.ingreso_id), 2) AS porcentaje_con_cama,
       CASE WHEN COUNT(a.ingreso_id) = COUNT(*)
                  AND COUNT(CASE WHEN a.camas_disponibles_llegada > 0 THEN 1 END) = COUNT(*)
            THEN TRUE ELSE FALSE END AS siempre_disponibles,
       ROUND(AVG(a.turnos_espera), 2) AS promedio_turnos_espera
FROM ingreso i
JOIN hospital h ON h.id = i.hospital_id
LEFT JOIN atencion_emergencia a ON a.ingreso_id = i.id
LEFT JOIN egreso e ON e.ingreso_id = i.id AND e.fecha_hora < TIMESTAMP '2026-11-01'
WHERE i.unidad_medica_id = 2
  AND i.fecha_hora >= TIMESTAMP '2026-09-01' AND i.fecha_hora < TIMESTAMP '2026-11-01'
GROUP BY h.id, h.nombre
HAVING COUNT(a.ingreso_id) > 0
ORDER BY siempre_disponibles DESC, porcentaje_con_cama DESC, promedio_turnos_espera, h.id
LIMIT 3;
