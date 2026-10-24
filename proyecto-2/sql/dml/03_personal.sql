BEGIN;
-- Jerarquías de prueba para todo el personal médico, incluidos los médicos legados.
UPDATE medico_perfil m SET cargo='Director' WHERE personal_id IN
 (SELECT min(personal_id) FROM medico_perfil GROUP BY hospital_id);
UPDATE medico_perfil SET cargo='Jefe' WHERE personal_id IN (1002,1010,1018);
INSERT INTO medico_supervision
SELECT m.personal_id,m.hospital_id,
 CASE WHEN m.personal_id=d.id THEN NULL
 WHEN m.personal_id BETWEEN 1003 AND 1008 THEN 1002
 WHEN m.personal_id BETWEEN 1011 AND 1016 THEN 1010
 WHEN m.personal_id BETWEEN 1019 AND 1024 THEN 1018 ELSE d.id END
FROM medico_perfil m JOIN (SELECT hospital_id,min(personal_id) AS id FROM medico_perfil GROUP BY 1) d USING(hospital_id);
-- No se inventa salario/contratación de los empleados legados.
UPDATE medico_perfil SET salario=8000+(personal_id-1000)*100,colegiado='FICT-COL-'||personal_id
WHERE personal_id BETWEEN 1001 AND 1024;
UPDATE personal SET direccion=(ARRAY[
 '4a calle 12-35, zona 1, Quetzaltenango',
 '8a avenida 3-18, zona 3, Quetzaltenango',
 '2a calle 6-42, zona 5, Quetzaltenango',
 'Diagonal 2, lote 14, zona 7, Quetzaltenango'
 ]) [1+((id-1001)%4)],fecha_contratacion='2026-01-01'
WHERE id BETWEEN 1001 AND 1024;
INSERT INTO personal (id,hospital_id,nombres,apellidos,dpi,direccion,fecha_contratacion,tipo)
SELECT 2000+n,101+(n-1)%3,
       (ARRAY['María José','Paola','Rocío','Sandra','Mónica','Elena','Verónica','Carmen','Daniela','Andrea','Silvia','Karla','Gabriela','Rosa','Claudia','Teresa','Irene','Lucía','Fátima','Beatriz'])[n],
       (ARRAY['Mazariegos López','Cifuentes Barrios','Chávez Ixcot','Rodas Méndez','López Ochoa','Pérez Villagrán','Méndez Castillo','Vásquez Tzoc','Gómez Ajanel','Fuentes Ovalle','Cáceres Bran','Pineda Gómez','Reyes Soto','García Cajas','Morales de León','Ramírez Xicará','Castillo Cotí','Díaz Maldonado','Barrios Cifuentes','Estrada Chuc'])[n],
       'FICT-P2-E-'||n,
       (ARRAY['4a calle 12-35, zona 1, Quetzaltenango','8a avenida 3-18, zona 3, Quetzaltenango','2a calle 6-42, zona 5, Quetzaltenango','Diagonal 2, lote 14, zona 7, Quetzaltenango'])[1+((n-1)%4)],
       '2026-01-01','Enfermería'
FROM generate_series(1,20) n;
INSERT INTO enfermeria (personal_id,registro_profesional,nivel)
SELECT 2000+n,'FICT-ENF-'||n,CASE WHEN n%2=0 THEN 'Profesional' ELSE 'Auxiliar' END FROM generate_series(1,20) n;
COMMIT;
