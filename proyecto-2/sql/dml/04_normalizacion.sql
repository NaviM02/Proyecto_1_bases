BEGIN;
INSERT INTO propuesta_3fn.diagnostico VALUES ('FICT-P2','Diagnóstico ficticio para demostrar normalización');
INSERT INTO propuesta_3fn.cirugia
SELECT s.id,s.cirujano_id,s.paciente_id,pe.especialidad_id,s.fecha_hora_programada
FROM cirugia_solicitud s
JOIN personal_especialidad pe ON pe.personal_medico_id=s.cirujano_id AND pe.principal
WHERE s.id BETWEEN 1001 AND 1024;
INSERT INTO propuesta_3fn.cirugia_diagnostico SELECT id,'FICT-P2' FROM propuesta_3fn.cirugia;
INSERT INTO propuesta_3fn.cirugia_insumo
SELECT ci.* FROM cirugia_insumo ci JOIN propuesta_3fn.cirugia s ON s.id=ci.cirugia_solicitud_id;
COMMIT;
