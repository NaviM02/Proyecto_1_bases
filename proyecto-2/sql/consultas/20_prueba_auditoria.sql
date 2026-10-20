-- Objetivo 20. Cambios persistidos sobre datos ficticios; idempotentes (segunda ejecución no cambia nada).
BEGIN;
UPDATE medico_perfil SET salario=9150.00 WHERE personal_id=1003;
UPDATE medico_perfil SET nivel_acceso='Supervisor' WHERE personal_id=1003;
UPDATE personal_especialidad SET especialidad_id=4 WHERE personal_medico_id=1003 AND especialidad_id=1;
-- Actualización sin diferencias: no debe generar evidencia falsa.
UPDATE medico_perfil SET salario=salario WHERE personal_id=1003;
COMMIT;
SELECT medico_id,tabla,campo,valor_anterior,valor_nuevo,usuario_sesion,rol_efectivo,momento
FROM auditoria_personal WHERE medico_id=1003 ORDER BY id;
