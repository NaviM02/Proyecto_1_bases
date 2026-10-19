-- Objetivo 12. Promedio de edad y distribución por sexo en cada turno de emergencias.
SELECT h.id, h.nombre, b.turno, b.sexo, COUNT(*) AS ingresos,
       ROUND(AVG(b.edad), 2) AS edad_promedio_sexo,
       ROUND(100.0 * COUNT(*) / t.total_ingresos, 2) AS porcentaje_sexo,
       ROUND(t.edad_promedio, 2) AS edad_promedio_turno
FROM v_demografia_emergencias b
JOIN hospital h ON h.id = b.hospital_id
JOIN (
    SELECT hospital_id, turno, COUNT(*) AS total_ingresos, AVG(edad) AS edad_promedio
    FROM v_demografia_emergencias
    GROUP BY hospital_id, turno
) t ON t.hospital_id = b.hospital_id AND t.turno = b.turno
GROUP BY h.id, h.nombre, b.turno, b.sexo, t.total_ingresos, t.edad_promedio
ORDER BY h.id, b.turno, b.sexo;
