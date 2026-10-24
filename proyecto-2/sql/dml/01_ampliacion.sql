-- Datos exclusivamente ficticios, reservados en rangos >= 1000 (hospitales >= 101).
-- Ejecutar una vez; una colisión aborta toda la transacción en vez de sobrescribir datos.
BEGIN;
INSERT INTO hospital (id,nombre,direccion,telefono) VALUES
 (101,'Hospital Regional de Los Altos','Diagonal 11, zona 1, Quetzaltenango','5554-0101'),
 (102,'Centro Médico La Esperanza','6a avenida 4-25, zona 3, Quetzaltenango','5554-0102'),
 (103,'Hospital San Carlos de Occidente','7a calle 9-18, zona 5, Quetzaltenango','5554-0103');
INSERT INTO hospital_unidad SELECT h,u FROM generate_series(101,103) h CROSS JOIN generate_series(1,4) u;
INSERT INTO paciente (id,expediente,nombres,apellidos,dpi,fecha_nacimiento,sexo,estado_civil,telefono,municipio,departamento,area)
SELECT 1000+n,'P2-'||n,
       (ARRAY['Mateo','Valeria','Sebastián','Camila','Daniel','Fernanda','Andrés','Gabriela','José','Mariana','Diego','Lucía','Pablo','Andrea','Tomás','Paola','Emilio','Natalia','Javier','Sofía','Cristian','Mónica','Ricardo','Elena'])[n],
       (ARRAY['López Alvarado','Méndez Castillo','García Ochoa','Pérez Cifuentes','Hernández Soto','Ramírez Fuentes','Morales de León','Gómez Barrios','Cruz Vásquez','Castillo Tzoc','Vásquez Barrios','Mazariegos López','Santos Ovalle','Chávez Ixcot','Rodas Méndez','González Batz','Fuentes Cajas','Calderón Ajanel','Díaz Maldonado','Reyes Xicará','Barrios Cifuentes','Lima Sosa','Ovalle Chuc','Estrada Cotí'])[n],
       'FICT-P2-P-'||n,date '1960-01-01'+n*400,
       CASE WHEN n%2=0 THEN 'Femenino' ELSE 'Masculino' END,
       CASE n%4 WHEN 0 THEN 'Casado' WHEN 1 THEN 'Soltero' WHEN 2 THEN 'Soltera' ELSE 'Casada' END,
       '5554-'||lpad((1000+n)::text,4,'0'),
       (ARRAY['Quetzaltenango','La Esperanza','Salcajá','Olintepeque'])[1+(n%4)],
       'Quetzaltenango','Urbana'
FROM generate_series(1,24) n;
INSERT INTO personal_medico (id,hospital_id,nombres,apellidos,dpi,telefono,municipio,departamento,area,tipo_personal)
SELECT 1000+n,101+(n-1)/8,
       (ARRAY['Alejandro','Claudia','Marco','Patricia','Fernando','Irene','Luis','Andrea','Héctor','Silvia','Manuel','Teresa','Óscar','Rosa','Julio','Karla','Esteban','Marta','Rodrigo','Elisa','Carlos','Brenda','Víctor','Diana'])[n],
       (ARRAY['Alvarado Pérez','García Cifuentes','Méndez López','Rodas Castillo','Fuentes de León','Pineda Gómez','Cuc Hernández','Ical Barrios','Batz Ochoa','Cáceres Ovalle','Chun Ramírez','Guzmán Tzoc','Xicará Méndez','López Ajanel','Morales Cajas','Vásquez Cotí','Ramos Mazariegos','Pérez Villagrán','Cardona Cifuentes','Reyes Soto','Castillo Bran','Estrada Xicará','Ovalle Chuc','Maldonado Sosa'])[n],
       'FICT-P2-M-'||n,'5555-'||lpad((1000+n)::text,4,'0'),
       (ARRAY['Quetzaltenango','La Esperanza','Salcajá','Olintepeque'])[1+(n%4)],
       'Quetzaltenango','Urbana','Médico'
FROM generate_series(1,24) n;
INSERT INTO personal_especialidad SELECT 1000+n,1+(n%3),true FROM generate_series(1,24) n;
INSERT INTO personal_unidad SELECT 1000+n,101+(n-1)/8,u FROM generate_series(1,24) n CROSS JOIN generate_series(1,4) u;
INSERT INTO calificacion (id,personal_medico_id,puntuacion,comentario,fecha)
SELECT 1000+2*n+j,1000+n,1+(n+j)%5,
       CASE 1+(n+j)%5
         WHEN 5 THEN 'La atención fue muy clara y recibí respuesta a mis preguntas.'
         WHEN 4 THEN 'Buen trato y explicaciones útiles durante la consulta.'
         WHEN 3 THEN 'La atención fue adecuada, aunque la espera fue larga.'
         WHEN 2 THEN 'La consulta pudo ser más puntual y las indicaciones más detalladas.'
         ELSE 'No quedé conforme con la atención recibida.'
       END,
       timestamp '2026-10-01'+n*interval '1 day'+j*interval '6 hours'
FROM generate_series(1,24) n CROSS JOIN generate_series(0,1) j;
INSERT INTO clinica (id,hospital_id,unidad_medica_id,numero,descripcion) VALUES
 (1001,101,1,'CE-01','Consulta externa y medicina general'),
 (1002,102,1,'CE-01','Consulta externa y especialidades'),
 (1003,103,1,'CE-01','Consulta externa y seguimiento médico');
INSERT INTO recurso_asistencial (id,hospital_id,unidad_medica_id,tipo,nombre)
SELECT 1000+(h-1)*3+t,100+h,CASE t WHEN 1 THEN 2 WHEN 2 THEN 4 ELSE 3 END,
        CASE t WHEN 1 THEN 'Camilla' WHEN 2 THEN 'Cama' ELSE 'Quirófano' END,
        CASE t WHEN 1 THEN 'Camilla de observación ' WHEN 2 THEN 'Cama de hospitalización ' ELSE 'Quirófano general ' END||h
FROM generate_series(1,3) h CROSS JOIN generate_series(1,3) t;
INSERT INTO cita (id,paciente_id,hospital_id,clinica_id,medico_id,fecha_hora,costo,tipo_cita,estado,fecha_cancelacion)
SELECT 1000+n,1000+n,101+(n-1)/8,1001+(n-1)/8,1000+n,timestamp '2026-10-01 08:00'+n*interval '1 hour',
        250,CASE WHEN n%3=0 THEN 'Seguimiento' ELSE 'Primera consulta' END,
        CASE WHEN n%8=0 THEN 'Cancelada' WHEN n%4=0 THEN 'Programada' ELSE 'Realizada' END,
       CASE WHEN n%8=0 THEN timestamp '2026-09-30' END
FROM generate_series(1,24) n;
INSERT INTO consulta (id,cita_id,paciente_id,medico_id,fecha_hora,diagnostico)
SELECT id,id,paciente_id,medico_id,fecha_hora,
       CASE id%5 WHEN 0 THEN 'Hipertensión arterial en seguimiento' WHEN 1 THEN 'Infección respiratoria aguda' WHEN 2 THEN 'Gastritis y dispepsia' WHEN 3 THEN 'Dolor lumbar mecánico' ELSE 'Control médico y evaluación general' END
FROM cita WHERE id BETWEEN 1001 AND 1024 AND estado='Realizada';
INSERT INTO receta (id,consulta_id,paciente_id,medico_id,fecha,proxima_cita,clinica_id)
SELECT c.id,c.id,c.paciente_id,c.medico_id,c.fecha_hora::date,c.fecha_hora::date+14,a.clinica_id
FROM consulta c JOIN cita a ON a.id=c.cita_id WHERE c.id BETWEEN 1001 AND 1024;
INSERT INTO ingreso (id,paciente_id,hospital_id,unidad_medica_id,servicio_medico_id,medico_encargado_id,recurso_asistencial_id,motivo,fecha_hora,diagnostico_presuntivo)
SELECT u*1000+n,1000+n,101+(n-1)/8,u,CASE u WHEN 2 THEN 3 WHEN 3 THEN 4 ELSE 5 END,
       1000+n,1001+((n-1)/8)*3+CASE u WHEN 2 THEN 0 WHEN 3 THEN 2 ELSE 1 END,
        CASE u WHEN 2 THEN 'Atención por urgencia' WHEN 3 THEN 'Procedimiento quirúrgico programado' ELSE 'Ingreso para hospitalización' END,
        timestamp '2026-10-03 08:00'+n*interval '1 day'+(u-2)*interval '4 hours',
        CASE n%4 WHEN 0 THEN 'Dolor abdominal agudo' WHEN 1 THEN 'Infección respiratoria' WHEN 2 THEN 'Fractura de antebrazo' ELSE 'Deshidratación moderada' END
FROM generate_series(1,24) n CROSS JOIN generate_series(2,4) u;
INSERT INTO egreso (id,ingreso_id,paciente_id,hospital_id,unidad_medica_id,servicio_medico_id,medico_asignado_id,recurso_asistencial_id,fecha_hora,diagnostico_principal,motivo,codigo_egreso,sin_consentimiento_medico,motivo_sin_consentimiento)
SELECT id,id,paciente_id,hospital_id,unidad_medica_id,servicio_medico_id,medico_encargado_id,recurso_asistencial_id,
        fecha_hora+interval '2 hours',diagnostico_presuntivo,'Atención médica completada',CASE WHEN id>=4000 AND id%7=0 THEN 'Muerto' ELSE 'Vivo' END,
        id%11=0,CASE WHEN id%11=0 THEN 'Retiro voluntario por decisión del paciente' END
FROM ingreso WHERE id BETWEEN 2001 AND 4024;
INSERT INTO turno_medico (medico_id,hospital_id,unidad_medica_id,inicio,fin)
SELECT 1000+n,101+(n-1)/8,2,timestamp '2026-10-03 06:00'+n*interval '1 day',
       timestamp '2026-10-03 06:00'+n*interval '1 day'+(6+n%3)*interval '1 hour'
FROM generate_series(1,24) n;
INSERT INTO atencion_emergencia
SELECT id,fecha_hora+(id%3)*interval '20 minutes',id%3,CASE WHEN hospital_id=101 THEN 2 WHEN hospital_id=102 THEN 1 ELSE 0 END
FROM ingreso WHERE id BETWEEN 2001 AND 2024;
INSERT INTO cirugia_solicitud (id,paciente_id,hospital_id,cirujano_id,tipo_procedimiento,caracter,tiempo_estimado_minutos,tipo_anestesia,fecha_hora_solicitud,estado,fecha_hora_aprobacion,fecha_hora_programada,quirofano_id)
SELECT 1000+n,1000+n,101+(n-1)/8,1000+n,
        CASE n%3 WHEN 0 THEN 'Apendicectomía' WHEN 1 THEN 'Hernioplastia inguinal' ELSE 'Colecistectomía laparoscópica' END,
       'Programado',60,'General',timestamp '2026-10-02 12:00'+n*interval '1 day',
       CASE WHEN n%6=0 THEN 'Cancelada' ELSE 'Realizada' END,
       CASE WHEN n%6<>0 THEN timestamp '2026-10-02 14:00'+n*interval '1 day' END,
       timestamp '2026-10-03 12:00'+n*interval '1 day',1003+((n-1)/8)*3
FROM generate_series(1,24) n;
INSERT INTO cirugia_etapa (id,cirugia_solicitud_id,etapa,fecha_hora_inicio,fecha_hora_fin,observaciones)
SELECT id,id,'Intraoperatorio',fecha_hora_programada,fecha_hora_programada+interval '1 hour','Evolución documentada en chequeo'
FROM cirugia_solicitud WHERE id BETWEEN 1001 AND 1024 AND estado='Realizada';
INSERT INTO chequeo_quirurgico (id,cirugia_solicitud_id,etapa,aspecto,resultado,fecha_hora)
SELECT 1000+(s.id-1000)*3+k,s.id,
       CASE k WHEN 0 THEN 'Postoperatorio' WHEN 1 THEN 'Quirófano' ELSE 'Pausa quirúrgica' END,
        CASE k WHEN 0 THEN 'Condiciones de evolución durante la cirugía' WHEN 1 THEN 'Verificación del equipo e instrumental' ELSE 'Pausa de seguridad quirúrgica' END,
       CASE WHEN s.id%5=0 AND k=1 THEN 'Fallo' ELSE 'Éxito' END,s.fecha_hora_programada+interval '30 minutes'
FROM cirugia_solicitud s CROSS JOIN generate_series(0,2) k WHERE s.id BETWEEN 1001 AND 1024 AND s.estado='Realizada';
INSERT INTO cirugia_insumo SELECT 1000+n,id,1+n%5 FROM generate_series(1,24) n CROSS JOIN (SELECT id FROM insumo ORDER BY id LIMIT 2) x;
INSERT INTO cirugia_instrumento SELECT 1000+n,id,1+n%3 FROM generate_series(1,24) n CROSS JOIN (SELECT id FROM instrumento ORDER BY id LIMIT 2) x;
INSERT INTO cirugia_equipo SELECT 1000+n,id,1+n%2 FROM generate_series(1,24) n CROSS JOIN (SELECT id FROM equipo ORDER BY id LIMIT 2) x;
INSERT INTO hospitalizacion (id,paciente_id,hospital_id,ingreso_id,unidad_medica_id,servicio_medico_id,medico_encargado_id,cama_id,fecha_hora_ingreso,fecha_hora_egreso,costo_por_dia)
SELECT id-3000,paciente_id,hospital_id,id,4,5,medico_encargado_id,recurso_asistencial_id,fecha_hora,fecha_hora+interval '2 hours',500+(hospital_id-101)*50
FROM ingreso WHERE id BETWEEN 4001 AND 4024;
INSERT INTO factura (id,paciente_id,hospital_id,fecha_emision,descripcion,total,estado)
SELECT 1000+(n-1)*4+u,1000+n,101+(n-1)/8,timestamp '2026-10-03 18:00'+n*interval '1 day',
        CASE u WHEN 1 THEN 'Consulta externa' WHEN 2 THEN 'Atención de emergencia' WHEN 3 THEN 'Procedimiento quirúrgico' ELSE 'Hospitalización' END,
        CASE u WHEN 1 THEN 250 WHEN 2 THEN 600 WHEN 3 THEN 4800 ELSE 1000+(n%3)*100 END,'Pagada'
FROM generate_series(1,24) n CROSS JOIN generate_series(1,4) u;
INSERT INTO factura_detalle (id,factura_id,servicio_medico_id,descripcion,cantidad,precio_unitario,subtotal)
SELECT id,id,CASE (id-1001)%4 WHEN 0 THEN 1 WHEN 1 THEN 3 WHEN 2 THEN 4 ELSE 5 END,descripcion,1,total,total
FROM factura WHERE id BETWEEN 1001 AND 1096;
INSERT INTO cirugia_factura_detalle SELECT 1000+(n-1)*4+3,1000+n FROM generate_series(1,24) n;
INSERT INTO pago (id,factura_id,numero_pago,fecha_pago,monto)
SELECT 10000+(f.id-1000)*3+j,f.id,j,f.fecha_emision+j*interval '1 hour',
       CASE WHEN j=1 THEN f.total-round(f.total/(1+f.id%3),2)*(f.id%3) ELSE round(f.total/(1+f.id%3),2) END
FROM factura f CROSS JOIN generate_series(1,3) j WHERE f.id BETWEEN 1001 AND 1096 AND j<=1+f.id%3;
INSERT INTO pago_metodo SELECT id,CASE id%3 WHEN 0 THEN 'Efectivo' WHEN 1 THEN 'Tarjeta de crédito' ELSE 'Tarjeta de débito' END
FROM pago WHERE id>10000;
COMMIT;
