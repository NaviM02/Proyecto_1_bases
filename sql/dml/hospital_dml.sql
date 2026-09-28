-- Catálogos y estructura general

INSERT INTO hospital (id, nombre, direccion, telefono) VALUES
(1, 'Hospital de Occidente Central', 'Zona 1, Quetzaltenango', '5550-1001'),
(2, 'Hospital de Occidente Norte',   'Zona 3, Quetzaltenango', '5550-1002');

INSERT INTO unidad_medica (id, nombre) VALUES
(1, 'Consulta Externa'),
(2, 'Emergencias'),
(3, 'Cirugía'),
(4, 'Hospitalización');

INSERT INTO especialidad (id, nombre, descripcion) VALUES
(1,  'Cardiología',                    'Atención del aparato cardiovascular.'),
(2,  'Dermatología',                   'Atención de la piel.'),
(3,  'Fisioterapia',                   'Rehabilitación física.'),
(4,  'Ginecología Oncológica',         'Cáncer del aparato reproductor femenino.'),
(5,  'Hematología',                    'Enfermedades de la sangre.'),
(6,  'Medicina Física y Rehabilitación','Rehabilitación integral.'),
(7,  'Medicina General',               'Atención médica general.'),
(8,  'Nutrición y Dietética',          'Atención nutricional.'),
(9,  'Odontología General',            'Atención dental.'),
(10, 'Oftalmología',                   'Atención de los ojos.'),
(11, 'Psicología',                     'Atención psicológica.'),
(12, 'Pediatría',                      'Atención de niñas y niños.'),
(13, 'Urología',                       'Atención del aparato urinario.'),
(14, 'Terapia del Lenguaje',           'Atención del lenguaje.'),
(15, 'Cirugía General',                'Cirugía de adultos.'),
(16, 'Cirugía Neurológica',            'Cirugía del sistema nervioso.'),
(17, 'Cirugía Ortopédica',             'Cirugía de huesos y articulaciones.'),
(18, 'Cirugía Pediátrica',             'Cirugía de niñas y niños.');

INSERT INTO servicio_medico (id, unidad_medica_id, nombre, descripcion, costo_base) VALUES
(1, 1, 'Consulta de medicina general',  'Consulta médica general.',            250.00),
(2, 1, 'Consulta de especialidad',      'Consulta médica especializada.',      400.00),
(3, 2, 'Atención de emergencia',        'Atención médica de emergencia.',      600.00),
(4, 3, 'Procedimiento quirúrgico',      'Procedimiento quirúrgico.',         5000.00),
(5, 4, 'Hospitalización',               'Servicio de hospitalización por día.', 850.00);

-- Cada hospital de la cadena contiene las cuatro unidades.
INSERT INTO hospital_unidad (hospital_id, unidad_medica_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4),
(2, 1), (2, 2), (2, 3), (2, 4);

INSERT INTO clinica (id, hospital_id, unidad_medica_id, numero, descripcion) VALUES
(1, 1, 1, 'CE-01', 'Consultorio de medicina general'),
(2, 1, 1, 'CE-02', 'Consultorio de especialidad'),
(3, 2, 1, 'CE-01', 'Consultorio de medicina general');

INSERT INTO recurso_asistencial (id, hospital_id, unidad_medica_id, tipo, nombre, descripcion, disponible) VALUES
(1, 1, 2, 'Camilla',   'CAM-01',   'Camilla de emergencia',   TRUE),
(2, 1, 2, 'Camilla',   'CAM-02',   'Camilla de emergencia',   TRUE),
(3, 1, 3, 'Quirófano', 'QX-01',    'Quirófano principal',     TRUE),
(4, 1, 3, 'Quirófano', 'QX-02',    'Quirófano secundario',    TRUE),
(5, 1, 4, 'Cama',      'CAMA-01',  'Cama de hospitalización', TRUE),
(6, 1, 4, 'Cama',      'CAMA-02',  'Cama de hospitalización', TRUE);


-- Personas y personal

INSERT INTO paciente
(id, expediente, nombres, apellidos, dpi, fecha_nacimiento, sexo, estado_civil, telefono, seguro_social, municipio, departamento, area)
VALUES
(1, 'EXP-0001', 'Carlos', 'Méndez López',  '0000000000001', '1990-04-15', 'Masculino', 'Soltero', '5551-0001', 'SS-0001', 'Quetzaltenango', 'Quetzaltenango', 'Urbana'),
(2, 'EXP-0002', 'Ana',    'García Pérez',  '0000000000002', '1987-09-22', 'Femenino',  'Casada', '5551-0002', 'SS-0002', 'Salcajá',        'Quetzaltenango', 'Rural'),
(3, 'EXP-0003', 'Luis',   'Hernández Díaz','0000000000003', '2004-02-10', 'Masculino', 'Soltero', '5551-0003', NULL,      'Quetzaltenango', 'Quetzaltenango', 'Urbana'),
(4, 'EXP-0004', 'María',  'Ramírez Soto',  '0000000000004', '1995-12-03', 'Femenino',  'Soltera', '5551-0004', 'SS-0004', 'Totonicapán',    'Totonicapán',     'Rural'),
(5, 'EXP-0005', 'Sofía',  'Castillo Ruiz', '0000000000005', '2014-06-18', 'Femenino',  'Soltera', '5551-0005', NULL,      'La Esperanza',   'Quetzaltenango', 'Urbana');

INSERT INTO encargado
(id, nombres, apellidos, parentesco, dpi, telefono, municipio, departamento, area)
VALUES
(1, 'Roberto', 'Méndez García', 'Padre',   '0000000000011', '5552-0001', 'Quetzaltenango', 'Quetzaltenango', 'Urbana'),
(2, 'Laura',   'Soto Castillo', 'Madre',   '0000000000012', '5552-0002', 'La Esperanza',   'Quetzaltenango', 'Urbana'),
(3, 'Jorge',   'Hernández López','Hermano','0000000000013', '5552-0003', 'Salcajá',        'Quetzaltenango', 'Rural');

INSERT INTO paciente_encargado (paciente_id, encargado_id, principal) VALUES
(1, 1, TRUE),
(5, 2, TRUE),
(3, 3, TRUE);

INSERT INTO personal_medico
(id, hospital_id, nombres, apellidos, dpi, telefono, municipio, departamento, area, tipo_personal)
VALUES
(1, 1, 'Diego',     'Morales Pérez',  '0000000000101', '5553-0001', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(2, 1, 'Elena',     'Vásquez López',  '0000000000102', '5553-0002', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(3, 1, 'Fernando',  'Cifuentes Díaz', '0000000000103', '5553-0003', 'Salcajá',        'Quetzaltenango', 'Rural',  'Médico'),
(4, 1, 'Gabriela',  'Rodas Méndez',   '0000000000104', '5553-0004', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Enfermero'),
(5, 1, 'Hugo',      'Alvarado Cruz',  '0000000000105', '5553-0005', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Anestesista'),
(6, 2, 'Irene',     'Pineda Gómez',   '0000000000106', '5553-0006', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico');

INSERT INTO personal_especialidad (personal_medico_id, especialidad_id, principal) VALUES
(1, 7,  TRUE),   -- Diego → Medicina General
(2, 1,  TRUE),   -- Elena → Cardiología
(3, 15, TRUE),   -- Fernando → Cirugía General
(6, 12, TRUE);   -- Irene → Pediatría

INSERT INTO personal_unidad (personal_medico_id, hospital_id, unidad_medica_id) VALUES
-- Consulta externa
(1, 1, 1),
(2, 1, 1),
-- Emergencias
(1, 1, 2),
(3, 1, 2),
-- Cirugía
(3, 1, 3),
(5, 1, 3),
(4, 1, 3),
-- Hospitalización
(1, 1, 4),
(4, 1, 4);

-- Calificaciones de calidad del servicio (hospital, médico, enfermero y encargado).
INSERT INTO calificacion (id, hospital_id, personal_medico_id, encargado_id, puntuacion, comentario, fecha)
VALUES
(1, 1,    NULL, NULL, 5, 'Excelente atención en el hospital.',        '2026-09-15 10:00'),
(2, NULL, 1,    NULL, 4, 'Médico claro y atento con el paciente.',    '2026-09-15 10:30'),
(3, NULL, 4,    NULL, 5, 'Enfermera muy dedicada durante la estadía.','2026-09-17 12:30'),
(4, NULL, NULL, 1,    4, 'Trato adecuado como encargado del paciente.','2026-09-17 13:00');


-- Consulta externa

-- Cita 1: primera consulta realizada (costo base 250.00).
INSERT INTO cita (id, paciente_id, hospital_id, clinica_id, medico_id, fecha_hora, costo, tipo_cita, estado)
VALUES
(1, 1, 1, 1, 1, '2026-09-14 08:00', 250.00, 'Primera consulta', 'Realizada');

-- Cita 2: primera consulta de especialidad programada (costo base 400.00).
INSERT INTO cita (id, paciente_id, hospital_id, clinica_id, medico_id, fecha_hora, costo, tipo_cita, estado)
VALUES
(2, 2, 1, 2, 2, '2026-09-15 09:00', 400.00, 'Primera consulta', 'Programada');

-- Cita 3: reconsulta cancelada (75% de 400.00 = 300.00).
INSERT INTO cita (id, paciente_id, hospital_id, clinica_id, medico_id, fecha_hora, costo, tipo_cita, estado, fecha_cancelacion, motivo_cancelacion)
VALUES
(3, 3, 1, 1, 1, '2026-09-16 10:00', 300.00, 'Reconsulta', 'Cancelada', '2026-09-15 15:00', 'El paciente notificó que no podía asistir.');

-- Cita 4: referida por institución (80% de 400.00 = 320.00).
INSERT INTO cita (id, paciente_id, hospital_id, clinica_id, medico_id, fecha_hora, costo, tipo_cita, estado)
VALUES
(4, 4, 1, 2, 2, '2026-09-17 11:00', 320.00, 'Referido', 'Programada');

-- Consulta realizada a partir de la cita 1.
INSERT INTO consulta (id, cita_id, paciente_id, medico_id, fecha_hora, diagnostico, otros_datos, observaciones)
VALUES
(1, 1, 1, 1, '2026-09-14 08:35', 'Hipertensión arterial leve.', 'Presión arterial elevada durante la evaluación.', 'Se recomienda seguimiento y control de presión.');

INSERT INTO medicamento (id, nombre, descripcion) VALUES
(1, 'Losartán',    'Control de presión arterial.'),
(2, 'Paracetamol', 'Analgésico y antipirético.'),
(3, 'Omeprazol',   'Disminuye la producción de ácido gástrico.');

-- Receta emitida en la consulta 1.
INSERT INTO receta (id, consulta_id, paciente_id, medico_id, fecha, proxima_cita, clinica_id)
VALUES
(1, 1, 1, 1, '2026-09-14', '2026-10-14', 1);

INSERT INTO receta_medicamento (receta_id, medicamento_id, dosis, duracion) VALUES
(1, 1, '50 mg cada 24 horas', '30 días');


-- Emergencias, ingresos y traslados

-- Ingreso 1: paciente a emergencias con camilla CAM-01.
INSERT INTO ingreso (id, paciente_id, hospital_id, unidad_medica_id, servicio_medico_id, medico_encargado_id, recurso_asistencial_id, motivo, fecha_hora, diagnostico_presuntivo)
VALUES
(1, 2, 1, 2, 3, 1, 1, 'Dolor abdominal intenso.', '2026-09-14 18:30', 'Posible apendicitis.');

-- Ingreso 2: paciente a emergencias con camilla CAM-02 (aún sin egreso).
INSERT INTO ingreso (id, paciente_id, hospital_id, unidad_medica_id, servicio_medico_id, medico_encargado_id, recurso_asistencial_id, motivo, fecha_hora, diagnostico_presuntivo)
VALUES
(2, 3, 1, 2, 3, 3, 2, 'Dificultad respiratoria.', '2026-09-15 20:00', 'Crisis asmática.');

-- Traslado interno: emergencias → hospitalización (paciente del ingreso 1).
INSERT INTO traslado (id, paciente_id, medico_indica_id, hospital_origen_id, unidad_origen_id, servicio_origen_id, hospital_destino_id, unidad_destino_id, servicio_destino_id, fecha_hora, tipo_traslado, observaciones)
VALUES
(1, 2, 1, 1, 2, 3, 1, 4, 5, '2026-09-14 21:00', 'Interno', 'Traslado de emergencias a hospitalización para continuar tratamiento.');


-- Hospitalización

-- Estadía del paciente del ingreso 1 (3 días, egreso el 17).
INSERT INTO hospitalizacion (id, paciente_id, hospital_id, ingreso_id, unidad_medica_id, servicio_medico_id, medico_encargado_id, cama_id, fecha_hora_ingreso, fecha_hora_egreso, costo_por_dia)
VALUES
(1, 2, 1, 1, 4, 5, 1, 5, '2026-09-14 21:00', '2026-09-17 11:00', 850.00);

-- Egreso de la hospitalización (ficha de egreso ligada al ingreso 1).
INSERT INTO egreso (id, ingreso_id, paciente_id, hospital_id, unidad_medica_id,
                    servicio_medico_id, medico_asignado_id, recurso_asistencial_id,
                    fecha_hora, diagnostico_principal, diagnosticos_secundarios, motivo,
                    codigo_egreso, sin_consentimiento_medico, dias_hospitalizado,
                    operaciones_intervenciones)
VALUES
(1, 1, 2, 1, 4, 5, 1, 5,
 '2026-09-17 11:00',
 'Apendicitis aguda.',
 'Dolor abdominal controlado.',
 'Finalización de tratamiento.',
 'Vivo', FALSE, 3, NULL);


-- Cirugía

-- Solicitud de cirugía aprobada y programada en quirófano QX-01.
INSERT INTO cirugia_solicitud (id, paciente_id, hospital_id, cirujano_id, tipo_procedimiento,
                               caracter, tiempo_estimado_minutos,
                               tipo_anestesia, requerimientos, fecha_hora_solicitud, estado,
                               fecha_hora_aprobacion, fecha_hora_programada, quirofano_id)
VALUES
(1, 2, 1, 3,
 'Apendicectomía laparoscópica',
 'Programado',
 90,
 'Anestesia general',
 'Equipo laparoscópico e instrumental quirúrgico.',
 '2026-09-16 08:00', 'Programada',
 '2026-09-16 12:00', '2026-09-18 09:00', 3);

-- Historia clínica e interrogatorio del paciente de la cirugía 1.
INSERT INTO historia_clinica (id, paciente_id, cirugia_solicitud_id, tipo_interrogatorio,
                              religion, ocupacion, lugar_nacimiento, lugar_residencia,
                              antecedentes_heredofamiliares, antecedentes_personales_no_patologicos,
                              antecedentes_patologicos, padecimiento_actual,
                              interrogatorio_aparatos_sistemas, sintomas_generales_terapeutica,
                              estudios_previos, fecha)
VALUES
(1, 2, 1, 'Directo',
 'Católica', 'Comerciante', 'Quetzaltenango', 'Salcajá',
 'Madre con hipertensión arterial.',
 'No fuma ni consume bebidas alcohólicas.',
 'Apendicitis aguda.',
 'Dolor abdominal en fosa ilíaca derecha de 24 horas de evolución.',
 'Dolor abdominal localizado, sin irradiación.',
 'Náuseas y febrícula; se administró analgésico.',
 'Hemograma previo sin datos relevantes.',
 '2026-09-16 08:30');

INSERT INTO exploracion_fisica (id, historia_clinica_id, seccion, hallazgo) VALUES
(1, 1, 'Signos vitales',        'Temperatura 38.1 °C, frecuencia cardíaca 96 lpm.'),
(2, 1, 'Exploración general',   'Paciente consciente, orientada, en regular estado general.'),
(3, 1, 'Abdomen',               'Dolor a la palpación profunda en fosa ilíaca derecha.'),
(4, 1, 'Extremidades',          'Sin edema ni alteraciones vasculares.');

INSERT INTO consentimiento_informado
(id, cirugia_solicitud_id, procedimiento, objetivo, caracteristicas, riesgos,
 medico_id, paciente_o_representante, fecha_obtencion, firmado)
VALUES
(1, 1,
 'Apendicectomía laparoscópica',
 'Eliminar el apéndice inflamado.',
 'Procedimiento realizado mediante técnica laparoscópica.',
 'Sangrado, infección y complicaciones relacionadas con la anestesia.',
 3, 'Ana García Pérez', '2026-09-16', TRUE);

INSERT INTO chequeo_preanestesico
(id, cirugia_solicitud_id, asa, medico_clasifica_id, plan_anestesia, anestesista_id, fecha_hora)
VALUES
(1, 1, 'II', 3, 'Anestesia general con monitorización continua.', 5, '2026-09-17 15:00');

INSERT INTO cirugia_etapa (id, cirugia_solicitud_id, etapa, fecha_hora_inicio, fecha_hora_fin,
                           enfermero_responsable_id, observaciones)
VALUES
(1, 1, 'Preoperatorio',   '2026-09-18 08:00', '2026-09-18 08:45', 4,
 'Paciente preparado para el procedimiento.'),
(2, 1, 'Intraoperatorio', '2026-09-18 09:00', '2026-09-18 10:30', 4,
 'Procedimiento realizado sin complicaciones.'),
(3, 1, 'Postoperatorio',  '2026-09-18 10:45', '2026-09-18 12:00', 4,
 'Paciente estable durante la recuperación.');

INSERT INTO chequeo_quirurgico (id, cirugia_solicitud_id, etapa, aspecto, resultado,
                                observaciones, fecha_hora, registrado_por_id)
VALUES
(1, 1, 'Entrada', 'Confirmación del paciente', 'Éxito',
 'Identificación confirmada.', '2026-09-18 08:50', 4),
(2, 1, 'Pausa quirúrgica', 'Buenas condiciones de esterilidad', 'Aceptable',
 'Condiciones verificadas antes de la incisión.', '2026-09-18 09:05', 4);


-- Insumos, instrumentos y equipos

INSERT INTO insumo (id, nombre, descripcion, material, tipo) VALUES
(1, 'Guantes quirúrgicos', 'Guantes estériles para procedimiento quirúrgico.', 'Látex',     'Quirúrgico'),
(2, 'Gasas estériles',     'Gasas para limpieza y control durante procedimientos.', 'Algodón', 'Médico'),
(3, 'Jeringa 10 ml',       'Jeringa descartable.',                                'Plástico', 'Médico'),
(4, 'Sutura absorbible',   'Material para cierre de tejidos.',                     'Poliglactina', 'Quirúrgico');

INSERT INTO instrumento (id, nombre, descripcion, tipo, funcion) VALUES
(1, 'Bisturí quirúrgico',     'Instrumento para realizar incisiones.',        'Quirúrgico', 'Corte'),
(2, 'Pinza hemostática',      'Instrumento para control de sangrado.',        'Quirúrgico', 'Hemostática'),
(3, 'Separador abdominal',    'Instrumento para separación de tejidos.',      'Quirúrgico', 'Retractor');

INSERT INTO equipo (id, nombre, descripcion, tipo, funcion) VALUES
(1, 'Monitor de signos vitales', 'Monitorización de signos vitales.',          'Médico',     'Diagnóstico'),
(2, 'Máquina de anestesia',      'Equipo para administración de anestesia.',   'Quirúrgico', 'Tratamiento'),
(3, 'Torre laparoscópica',       'Equipo para procedimientos laparoscópicos.', 'Quirúrgico', 'Diagnóstico');

-- Detalle de insumos, instrumentos y equipos de la cirugía 1.
INSERT INTO cirugia_insumo (cirugia_solicitud_id, insumo_id, cantidad) VALUES
(1, 2, 10),
(1, 4, 1);

INSERT INTO cirugia_instrumento (cirugia_solicitud_id, instrumento_id, cantidad) VALUES
(1, 1, 1),
(1, 2, 2);

INSERT INTO cirugia_equipo (cirugia_solicitud_id, equipo_id, cantidad) VALUES
(1, 2, 1),
(1, 3, 1);


-- Laboratorio

INSERT INTO examen_laboratorio (id, nombre, tipo, descripcion) VALUES
(1, 'Hemograma completo',        'Sangre',        'Conteo de células sanguíneas.'),
(2, 'Glucosa en ayunas',         'Sangre',        'Nivel de glucosa en sangre.'),
(3, 'Perfil lipídico',           'Sangre',        'Colesterol y triglicéridos.'),
(4, 'Examen general de orina',   'Orina',         'Análisis físico y químico de la orina.'),
(5, 'Radiografía de tórax',      'Imagenología',  'Estudio de imagen del tórax.');

-- Orden de laboratorio solicitada en la consulta 1.
INSERT INTO orden_laboratorio (id, paciente_id, medico_solicita_id, consulta_id,
                               cirugia_solicitud_id, fecha_hora_solicitud, estado, observaciones)
VALUES
(1, 1, 1, 1, NULL, '2026-09-14 08:40', 'Completada',
 'Órdenes de laboratorio para control de hipertensión.');

INSERT INTO orden_laboratorio_examen (orden_laboratorio_id, examen_laboratorio_id, resultado, fecha_resultado) VALUES
(1, 1, 'Valores dentro de los rangos normales.', '2026-09-14 11:00'),
(1, 2, 'Glucosa 98 mg/dL.',                      '2026-09-14 11:00'),
(1, 3, 'Colesterol total 185 mg/dL.',            '2026-09-14 11:00');

-- Orden de laboratorio solicitada en la ficha clínica de la cirugía 1.
INSERT INTO orden_laboratorio (id, paciente_id, medico_solicita_id, consulta_id,
                               cirugia_solicitud_id, fecha_hora_solicitud, estado, observaciones)
VALUES
(2, 2, 3, NULL, 1, '2026-09-17 15:30', 'Completada',
 'Exámenes prequirúrgicos previos a la apendicectomía.');

INSERT INTO orden_laboratorio_examen (orden_laboratorio_id, examen_laboratorio_id, resultado, fecha_resultado) VALUES
(2, 1, 'Leucocitos elevados (14 000 /µL).', '2026-09-17 18:00'),
(2, 4, 'Sin datos patológicos.',            '2026-09-17 18:00'),
(2, 5, 'Sin hallazgos relevantes.',         '2026-09-17 18:30');


-- Facturación y pagos

-- Factura 1: emergencia + hospitalización (total = 600.00 + 3×850.00 = 3150.00).
INSERT INTO factura (id, paciente_id, hospital_id, fecha_emision, descripcion, total, estado)
VALUES
(1, 2, 1, '2026-09-17 12:00', 'Atención de emergencia y hospitalización.', 3150.00, 'Parcial');

INSERT INTO factura_detalle (id, factura_id, servicio_medico_id, descripcion,
                             cantidad, precio_unitario, subtotal)
VALUES
(1, 1, 3, 'Atención de emergencia', 1, 600.00, 600.00),
(2, 1, 5, 'Hospitalización',        3, 850.00, 2550.00);

-- Dos cuotas de la factura 1 (de un máximo de 12).
INSERT INTO pago (id, factura_id, numero_pago, fecha_pago, monto) VALUES
(1, 1, 1, '2026-09-17 13:00', 1000.00),
(2, 1, 2, '2026-09-18 14:00', 1000.00);

-- Factura 2: procedimiento quirúrgico (pendiente de pago).
INSERT INTO factura (id, paciente_id, hospital_id, fecha_emision, descripcion, total, estado)
VALUES
(2, 2, 1, '2026-09-18 13:00', 'Procedimiento quirúrgico.', 5000.00, 'Pendiente');

INSERT INTO factura_detalle (id, factura_id, servicio_medico_id, descripcion, cantidad, precio_unitario, subtotal)
VALUES
(3, 2, 4, 'Procedimiento quirúrgico', 1, 5000.00, 5000.00);
