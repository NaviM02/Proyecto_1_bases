-- Objetivo 2. Solo calificaciones atribuibles a consultas; no inventar el servicio de las antiguas.
SELECT m.id,m.nombres,m.apellidos,h.nombre AS hospital,
 round(n.suma_notas/n.evaluaciones,2) AS promedio,
 (SELECT count(*) FROM consulta c JOIN cita a ON a.id=c.cita_id
  WHERE c.medico_id=m.id AND a.hospital_id=n.hospital_id) AS consultas,
 n.consultas_calificadas,n.evaluaciones
FROM v_nota_consulta n JOIN personal_medico m ON m.id=n.medico_id JOIN hospital h ON h.id=n.hospital_id
ORDER BY promedio,m.id,h.id LIMIT 5;
