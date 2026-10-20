-- Objetivo 15. DDL: ../ddl/03_extension_personal.sql; evidencia del mapeo y jerarquía.
SELECT p.tipo,count(*) AS personas,count(m.personal_id) AS medicos,count(e.personal_id) AS enfermeria
FROM personal p LEFT JOIN medico_perfil m ON m.personal_id=p.id
LEFT JOIN enfermeria e ON e.personal_id=p.id GROUP BY p.tipo ORDER BY p.tipo;
SELECT s.hospital_id,count(*) AS integrantes,
 count(CASE WHEN superior_id IS NULL THEN 1 END) AS directores
FROM medico_supervision s GROUP BY hospital_id ORDER BY hospital_id;
