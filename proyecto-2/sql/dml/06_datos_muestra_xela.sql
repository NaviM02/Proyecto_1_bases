-- Actualiza únicamente datos de demostración de Proyecto 2 (rangos reservados >= 1000).
-- Los datos son simulados; se conservan intactos los registros de Proyecto 1.
BEGIN;

UPDATE hospital SET
    nombre = CASE id
        WHEN 101 THEN 'Hospital Regional de Los Altos'
        WHEN 102 THEN 'Centro Médico La Esperanza'
        WHEN 103 THEN 'Hospital San Carlos de Occidente'
    END,
    direccion = CASE id
        WHEN 101 THEN 'Diagonal 11, zona 1, Quetzaltenango'
        WHEN 102 THEN '6a avenida 4-25, zona 3, Quetzaltenango'
        WHEN 103 THEN '7a calle 9-18, zona 5, Quetzaltenango'
    END,
    telefono = '5554-01'||lpad((id-100)::text,2,'0')
WHERE id BETWEEN 101 AND 103;

UPDATE paciente p SET
    nombres = (ARRAY['Mateo','Valeria','Sebastián','Camila','Daniel','Fernanda','Andrés','Gabriela','José','Mariana','Diego','Lucía','Pablo','Andrea','Tomás','Paola','Emilio','Natalia','Javier','Sofía','Cristian','Mónica','Ricardo','Elena'])[p.id-1000],
    apellidos = (ARRAY['López Alvarado','Méndez Castillo','García Ochoa','Pérez Cifuentes','Hernández Soto','Ramírez Fuentes','Morales de León','Gómez Barrios','Cruz Vásquez','Castillo Tzoc','Vásquez Barrios','Mazariegos López','Santos Ovalle','Chávez Ixcot','Rodas Méndez','González Batz','Fuentes Cajas','Calderón Ajanel','Díaz Maldonado','Reyes Xicará','Barrios Cifuentes','Lima Sosa','Ovalle Chuc','Estrada Cotí'])[p.id-1000],
    estado_civil = CASE p.id%4 WHEN 0 THEN 'Casado' WHEN 1 THEN 'Soltero' WHEN 2 THEN 'Soltera' ELSE 'Casada' END,
    telefono = '5554-'||lpad((1000+p.id-1000)::text,4,'0'),
    municipio = (ARRAY['Quetzaltenango','La Esperanza','Salcajá','Olintepeque'])[1+((p.id-1001)%4)],
    departamento = 'Quetzaltenango'
WHERE p.id BETWEEN 1001 AND 1024;

UPDATE personal_medico p SET
    nombres = (ARRAY['Alejandro','Claudia','Marco','Patricia','Fernando','Irene','Luis','Andrea','Héctor','Silvia','Manuel','Teresa','Óscar','Rosa','Julio','Karla','Esteban','Marta','Rodrigo','Elisa','Carlos','Brenda','Víctor','Diana'])[p.id-1000],
    apellidos = (ARRAY['Alvarado Pérez','García Cifuentes','Méndez López','Rodas Castillo','Fuentes de León','Pineda Gómez','Cuc Hernández','Ical Barrios','Batz Ochoa','Cáceres Ovalle','Chun Ramírez','Guzmán Tzoc','Xicará Méndez','López Ajanel','Morales Cajas','Vásquez Cotí','Ramos Mazariegos','Pérez Villagrán','Cardona Cifuentes','Reyes Soto','Castillo Bran','Estrada Xicará','Ovalle Chuc','Maldonado Sosa'])[p.id-1000],
    telefono = '5555-'||lpad((1000+p.id-1000)::text,4,'0'),
    municipio = (ARRAY['Quetzaltenango','La Esperanza','Salcajá','Olintepeque'])[1+((p.id-1001)%4)],
    departamento = 'Quetzaltenango'
WHERE p.id BETWEEN 1001 AND 1024;

UPDATE personal SET
    direccion = (ARRAY['4a calle 12-35, zona 1, Quetzaltenango','8a avenida 3-18, zona 3, Quetzaltenango','2a calle 6-42, zona 5, Quetzaltenango','Diagonal 2, lote 14, zona 7, Quetzaltenango'])[1+((id-1001)%4)]
WHERE id BETWEEN 1001 AND 1024;

UPDATE personal SET
    nombres = (ARRAY['María José','Paola','Rocío','Sandra','Mónica','Elena','Verónica','Carmen','Daniela','Andrea','Silvia','Karla','Gabriela','Rosa','Claudia','Teresa','Irene','Lucía','Fátima','Beatriz'])[id-2000],
    apellidos = (ARRAY['Mazariegos López','Cifuentes Barrios','Chávez Ixcot','Rodas Méndez','López Ochoa','Pérez Villagrán','Méndez Castillo','Vásquez Tzoc','Gómez Ajanel','Fuentes Ovalle','Cáceres Bran','Pineda Gómez','Reyes Soto','García Cajas','Morales de León','Ramírez Xicará','Castillo Cotí','Díaz Maldonado','Barrios Cifuentes','Estrada Chuc'])[id-2000],
    direccion = (ARRAY['4a calle 12-35, zona 1, Quetzaltenango','8a avenida 3-18, zona 3, Quetzaltenango','2a calle 6-42, zona 5, Quetzaltenango','Diagonal 2, lote 14, zona 7, Quetzaltenango'])[1+((id-2001)%4)]
WHERE id BETWEEN 2001 AND 2020;

UPDATE calificacion SET comentario = CASE puntuacion
    WHEN 5 THEN 'La atención fue muy clara y recibí respuesta a mis preguntas.'
    WHEN 4 THEN 'Buen trato y explicaciones útiles durante la consulta.'
    WHEN 3 THEN 'La atención fue adecuada, aunque la espera fue larga.'
    WHEN 2 THEN 'La consulta pudo ser más puntual y las indicaciones más detalladas.'
    ELSE 'No quedé conforme con la atención recibida.'
END
WHERE id BETWEEN 1002 AND 1049;

-- Se retiran las 18 filas adicionales agregadas por el script de evaluaciones de muestra.
DELETE FROM calificacion_consulta WHERE calificacion_id BETWEEN 1051 AND 1068;
DELETE FROM calificacion WHERE id BETWEEN 1051 AND 1068
  AND personal_medico_id BETWEEN 1001 AND 1024;

UPDATE clinica SET
    numero = 'CE-01',
    descripcion = CASE hospital_id
        WHEN 101 THEN 'Consulta externa y medicina general'
        WHEN 102 THEN 'Consulta externa y especialidades'
        ELSE 'Consulta externa y seguimiento médico'
    END
WHERE id BETWEEN 1001 AND 1003;

UPDATE recurso_asistencial SET nombre =
    CASE (id-1001)%3
        WHEN 0 THEN 'Camilla de observación '||((id-1001)/3+1)
        WHEN 1 THEN 'Cama de hospitalización '||((id-1002)/3+1)
        ELSE 'Quirófano general '||((id-1003)/3+1)
    END
WHERE id BETWEEN 1001 AND 1009;

UPDATE consulta SET diagnostico = CASE id%5
    WHEN 0 THEN 'Hipertensión arterial en seguimiento'
    WHEN 1 THEN 'Infección respiratoria aguda'
    WHEN 2 THEN 'Gastritis y dispepsia'
    WHEN 3 THEN 'Dolor lumbar mecánico'
    ELSE 'Control médico y evaluación general'
END
WHERE id BETWEEN 1001 AND 1024;

UPDATE ingreso SET
    motivo = CASE unidad_medica_id
        WHEN 2 THEN 'Atención por urgencia'
        WHEN 3 THEN 'Procedimiento quirúrgico programado'
        ELSE 'Ingreso para hospitalización'
    END,
    diagnostico_presuntivo = CASE id%4
        WHEN 0 THEN 'Dolor abdominal agudo'
        WHEN 1 THEN 'Infección respiratoria'
        WHEN 2 THEN 'Fractura de antebrazo'
        ELSE 'Deshidratación moderada'
    END
WHERE id BETWEEN 2001 AND 4024;

UPDATE egreso e SET
    diagnostico_principal = i.diagnostico_presuntivo,
    motivo = 'Atención médica completada',
    motivo_sin_consentimiento = CASE WHEN e.sin_consentimiento_medico THEN 'Retiro voluntario por decisión del paciente' ELSE NULL END
FROM ingreso i
WHERE e.ingreso_id = i.id AND e.id BETWEEN 2001 AND 4024;

UPDATE cirugia_solicitud SET tipo_procedimiento = CASE id%3
    WHEN 0 THEN 'Apendicectomía'
    WHEN 1 THEN 'Hernioplastia inguinal'
    ELSE 'Colecistectomía laparoscópica'
END
WHERE id BETWEEN 1001 AND 1024;

UPDATE chequeo_quirurgico SET aspecto = CASE etapa
    WHEN 'Postoperatorio' THEN 'Condiciones de evolución durante la cirugía'
    WHEN 'Quirófano' THEN 'Verificación del equipo e instrumental'
    ELSE 'Pausa de seguridad quirúrgica'
END
WHERE cirugia_solicitud_id BETWEEN 1001 AND 1024;

UPDATE factura SET descripcion = CASE (id-1001)%4
    WHEN 0 THEN 'Consulta externa'
    WHEN 1 THEN 'Atención de emergencia'
    WHEN 2 THEN 'Procedimiento quirúrgico'
    ELSE 'Hospitalización'
END
WHERE id BETWEEN 1001 AND 1096;

COMMIT;
