-- Objetivo 16. Incluye el médico inicial (nivel 0), sin fijar la profundidad de la jerarquía.
WITH RECURSIVE cadena AS (
 SELECT s.medico_id,s.hospital_id,s.superior_id,0 AS nivel,ARRAY[s.medico_id] AS ruta
 FROM medico_supervision s WHERE medico_id=:'medico_id'::integer
 UNION ALL
 SELECT s.medico_id,s.hospital_id,s.superior_id,c.nivel+1,c.ruta||s.medico_id
 FROM cadena c JOIN medico_supervision s ON s.medico_id=c.superior_id
 WHERE NOT s.medico_id=ANY(c.ruta)
)
SELECT c.nivel,p.id,p.nombres,p.apellidos,h.nombre AS hospital,m.cargo,c.superior_id
FROM cadena c JOIN personal p ON p.id=c.medico_id JOIN hospital h ON h.id=c.hospital_id
JOIN medico_perfil m ON m.personal_id=p.id ORDER BY nivel;
