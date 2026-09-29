-- Ingresos, egresos y traslados

INSERT INTO ingreso (id, paciente_id, hospital_id, unidad_medica_id, servicio_medico_id, medico_encargado_id, recurso_asistencial_id, motivo, fecha_hora, diagnostico_presuntivo)
VALUES
(1, 2,  1, 2, 3, 1,  1, 'Dolor abdominal intenso.',                     '2026-09-14 18:30', 'Posible apendicitis.'),
(2, 3,  1, 2, 3, 47, 2, 'Dificultad respiratoria.',                   '2026-09-15 20:00', 'Crisis asmática.'),
(3, 8,  1, 2, 3, 46, 7, 'Fiebre alta y dificultad para respirar.',   '2026-09-18 21:15', 'Neumonía adquirida en la comunidad.'),
(4, 12, 1, 2, 3, 48, 8, 'Dolor torácico intenso y sudoración fría.',  '2026-09-19 02:40', 'Síndrome coronario agudo.'),
(5, 9,  1, 3, 4, 22, 4, 'Cesárea programada por riesgo fetal.',       '2026-09-21 07:00', 'Embarazo a término con dilatación cervical completa.'),
(6, 4,  1, 2, 3, 46, 1, 'Dolor pélvico y sangrado transvaginal.',      '2026-09-19 15:30', 'Embarazo de 20 semanas con amenaza de aborto.'),
(7, 7,  1, 3, 4, 20, 3, 'Lesión en la mano derecha por accidente.',   '2026-09-23 08:45', 'Fractura de segundo metacarpiano.'),
(8, 11, 2, 2, 3, 50, 13,'Dolor abdominal y diarrea de tres días.',    '2026-09-25 09:00', 'Gastroenteritis aguda con deshidratación.');

-- Todos los traslados registrados son internos: el paciente permanece en la institución.
INSERT INTO traslado (id, paciente_id, medico_indica_id, hospital_origen_id, unidad_origen_id, servicio_origen_id, hospital_destino_id, unidad_destino_id, servicio_destino_id, fecha_hora, tipo_traslado, observaciones)
VALUES
(1, 2,  1,  1, 2, 3, 1, 4, 5,  '2026-09-14 21:00', 'Interno', 'Traslado de emergencias a hospitalización para continuar el tratamiento.'),
(2, 3,  47, 1, 2, 3, 1, 4, 11, '2026-09-15 22:00', 'Interno', 'Traslado a hospitalización pediátrica por deshidratación.'),
(3, 8,  46, 1, 2, 3, 1, 4, 7,  '2026-09-18 22:00', 'Interno', 'Traslado de emergencias a hospitalización por neumología.'),
(4, 12, 48, 1, 2, 3, 1, 4, 14, '2026-09-19 03:20', 'Interno', 'Traslado a unidad de cuidado crítico de adultos.'),
(5, 11, 50, 2, 2, 3, 2, 4, 8,  '2026-09-25 10:00', 'Interno', 'Traslado a hospitalización por medicina interna.');

INSERT INTO egreso (id, ingreso_id, paciente_id, hospital_id, unidad_medica_id,
                    servicio_medico_id, medico_asignado_id, recurso_asistencial_id,
                    fecha_hora, diagnostico_principal, diagnosticos_secundarios, motivo,
                    codigo_egreso, sin_consentimiento_medico, motivo_sin_consentimiento,
                    dias_hospitalizado, operaciones_intervenciones, codigo_traslado, referido_a)
VALUES
(1, 1, 2,  1, 4, 5,  1,  5, '2026-09-17 11:00', 'Apendicitis aguda.', 'Dolor abdominal controlado con analgesia.',
 'Finalización del tratamiento quirúrgico y médico.', 'Vivo', FALSE, NULL, 3,
 'Apendicectomía laparoscópica; ficha clínica con consentimiento informado y evaluación preanestésica.',
 'Alta a consulta externa', NULL),
(2, 2, 3,  1, 4, 11, 16, 12, '2026-09-17 08:00', 'Gastroenteritis aguda con deshidratación moderada.', 'Electrolitos séricos alterados al ingreso.',
 'Tolerancia adecuada de la vía oral.', 'Vivo', FALSE, NULL, 2, NULL,
 'Alta a pediatría', NULL),
(3, 3, 8,  1, 4, 7,  51, 11, '2026-09-22 11:00', 'Neumonía adquirida en la comunidad.', 'Hipoxemia leve durante el primer día.',
 'Respuesta favorable al tratamiento antibiótico.', 'Vivo', FALSE, NULL, 4, NULL,
 'Alta a consulta externa', 'Hospital de Occidente Norte'),
(4, 4, 12, 1, 4, 14, 53, 6,  '2026-09-23 02:30', 'Infarto agudo de miocardio.', 'Arritmia ventricular durante la hospitalización.',
 'Fallecimiento durante la hospitalización.', 'Muerto', TRUE,
 'No se obtuvo autorización de la familia: el paciente estaba inconsciente y los familiares no fueron localizados durante la emergencia.',
 4, NULL, NULL, NULL),
(5, 5, 9,  1, 3, 4,  22, 4, '2026-09-22 10:20', 'Cesárea segmentaria con recién nacido vivo.', 'Sangrado transquirúrgico dentro de parámetros normales.',
 'Parto por indicación obstétrica.', 'Parto', FALSE, NULL, 2,
 'Cesárea segmentaria; consentimiento informado firmado y evaluación preanestésica ASA II.', NULL, NULL),
(6, 6, 4,  1, 2, 3,  46, 1,  '2026-09-20 09:00', 'Amenaza de aborto en embarazo de 20 semanas.', 'Sangrado vaginal leve.',
 'Estabilización del cuadro; alta con control prenatal programado.', 'Embarazo', FALSE, NULL, NULL, NULL,
 'Alta con control prenatal', NULL),
(7, 7, 7,  1, 3, 4,  20, 3,  '2026-09-24 08:00', 'Fractura de segundo metacarpiano de la mano derecha.', NULL,
 'Reducción y osteosíntesis sin complicaciones.', 'Vivo', FALSE, NULL, 1,
 'Reducción y osteosíntesis de metacarpiano; ficha clínica completa con consentimiento informado.',
 NULL, NULL);