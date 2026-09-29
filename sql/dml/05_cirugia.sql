-- Cirugía y programación quirúrgica

INSERT INTO cirugia_solicitud (id, paciente_id, hospital_id, cirujano_id, tipo_procedimiento,
                               caracter, tiempo_estimado_minutos, tipo_anestesia, requerimientos,
                               fecha_hora_solicitud, estado, razon_rechazo,
                               fecha_hora_aprobacion, fecha_hora_programada, quirofano_id)
VALUES
(1, 2,  1, 3,  'Apendicectomía laparoscópica', 'Programado', 90, 'Anestesia general',
 'Torre laparoscópica e instrumental quirúrgico básico.', '2026-09-14 09:00', 'Realizada', NULL,
 '2026-09-14 10:30', '2026-09-15 08:00', 3),
(2, 9,  1, 22, 'Cesárea segmentaria', 'Programado', 60, 'Anestesia regional peridural',
 'Instrumental de cesárea y material para hemostasia uterina.', '2026-09-19 09:00', 'Realizada', NULL,
 '2026-09-19 11:15', '2026-09-21 08:00', 4),
(3, 7,  1, 20, 'Reducción y osteosíntesis de segundo metacarpiano', 'Urgente', 75, 'Anestesia local con sedación',
 'Fijadores óseos y material de osteosíntesis.', '2026-09-23 07:30', 'Realizada', NULL,
 '2026-09-23 08:00', '2026-09-23 09:30', 3),
(4, 10, 1, 31, 'Amigdalectomía', 'Urgente', 45, 'Anestesia general',
 'Sonda orofaríngea y material de amigdalectomía.', '2026-09-18 10:00', 'Rechazada',
 'El paciente no cumple las condiciones clínicas institucionales: presenta fiebre y antecedentes de obstrucción de la vía aérea; debe estabilizarse antes de volver a solicitar el procedimiento.',
 NULL, NULL, NULL),
(5, 6,  1, 30, 'Hernioplastia inguinal derecha', 'Programado', 70, 'Anestesia regional',
 'Malla de polipropileno e instrumental de hernioplastia.', '2026-09-22 11:00', 'Pendiente', NULL,
 NULL, NULL, NULL),
(6, 3,  2, 32, 'Apendicectomía abierta', 'Programado', 60, 'Anestesia general',
 'Instrumental de laparotomía y material de cierre.', '2026-09-26 09:30', 'Aprobada', NULL,
 '2026-09-26 15:00', NULL, NULL),
(7, 11, 2, 32, 'Colecistectomía laparoscópica', 'Programado', 90, 'Anestesia general',
 'Torre laparoscópica e instrumental de colecistectomía.', '2026-09-26 08:00', 'Cancelada', NULL,
 NULL, NULL, NULL);

INSERT INTO historia_clinica (id, paciente_id, cirugia_solicitud_id, tipo_interrogatorio,
                             religion, ocupacion, lugar_nacimiento, lugar_residencia,
                             antecedentes_heredofamiliares, antecedentes_personales_no_patologicos,
                             antecedentes_patologicos, padecimiento_actual,
                             interrogatorio_aparatos_sistemas, sintomas_generales_terapeutica,
                             estudios_previos, fecha)
VALUES
(1, 2, 1, 'Directo',
 'Católica', 'Comerciante', 'Quetzaltenango, Quetzaltenango', 'Salcajá, Quetzaltenango',
 'Madre con hipertensión arterial.',
 'No fuma ni consume bebidas alcohólicas.',
 'Apendicitis aguda sin complicaciones.',
 'Dolor abdominal en fosa ilíaca derecha de 24 horas de evolución.',
 'Dolor abdominal localizado, sin irradiación.',
 'Náuseas y febrícula; se administró analgésico.',
 'Hemograma previo sin datos relevantes.', '2026-09-14 10:45'),
(2, 9, 2, 'Directo',
 'Católica', 'Docente', 'Cobán, Alta Verapaz', 'Salcajá, Quetzaltenango',
 'Madre con diabetes mellitus tipo 2.',
 'Gesta 2, para 1; no fuma ni consume alcohol.',
 'Diabetes gestacional controlada con dieta.',
 'Embarazo de 39 semanas con indicación de cesárea por dilatación cervical completa.',
 'Sin alteraciones por aparatos y sistemas.',
 'Sin síntomas de preeclampsia.',
 'Perfil lipídico y hemograma dentro de límites normales.', '2026-09-19 10:00'),
(3, 7, 3, 'Indirecto',
 'Evangélica', 'Estudiante', 'San Mateo, San Marcos', 'San Mateo, San Marcos',
 'Madre con hipertensión arterial.',
 'Información proporcionada por la madre: no fuma ni consume alcohol.',
 'Sin antecedentes patológicos previos.',
 'Traumatismo cerrado en la mano derecha tras caída de altura.',
 'Dolor y edema en la segunda articulación metacarpofalángica.',
 'Dolor intenso que no cede con analgésicos comunes.',
 'Radiografía de mano con fractura oblicua del segundo metacarpiano.', '2026-09-23 08:00');

INSERT INTO exploracion_fisica (id, historia_clinica_id, seccion, hallazgo) VALUES
(1,  1, 'Signos vitales',         'Temperatura 38.1 °C, frecuencia cardíaca 96 lpm, presión arterial 118/74 mmHg.'),
(2,  1, 'Exploración general',    'Paciente consciente, orientado y en regular estado general.'),
(3,  1, 'Abdomen',                'Dolor a la palpación profunda en fosa ilíaca derecha con defensa.'),
(4,  1, 'Extremidades',           'Sin edema ni alteraciones vasculares.'),
(5,  2, 'Signos vitales',         'Temperatura 36.8 °C, frecuencia cardíaca 88 lpm, presión arterial 112/70 mmHg.'),
(6,  2, 'Exploración general',    'Paciente en buen estado general, sin edemas ni palidez.'),
(7,  2, 'Tórax',                  'Ruidos pulmonares claros, sin ingurgitación yugular.'),
(8,  2, 'Abdomen',                'Útero hipertónico, altura uterina de 34 cm, sin dolor a la palpación.'),
(9,  2, 'Cavidad vaginal',         'Dilatación cervical completa con membranas intactas.'),
(10, 3, 'Signos vitales',         'Temperatura 36.9 °C, frecuencia cardíaca 84 lpm, saturación 98%.'),
(11, 3, 'Exploración general',    'Niña consciente, colaboradora, sin hallazgos relevantes.'),
(12, 3, 'Cabeza',                 'Normocéfala, sin traumatismos ni hematomas.'),
(13, 3, 'Cuello',                 'Sin dolor ni limitación de la movilidad.'),
(14, 3, 'Tórax',                  'Expansión torácica simétrica, ruidos pulmonares normales.'),
(15, 3, 'Abdomen',                'Abdomen blando e indoloro.'),
(16, 3, 'Extremidades',           'Mano derecha con edema y ferida contusa en el dorso; sin déficit vascular.'),
(17, 3, 'Columna vertebral',      'Escoliosis leve, sin dolor a la palpación.'),
(18, 3, 'Cavidad bucal',          'Mucosas hidratadas, sin lesiones.'),
(19, 3, 'Cavidad rectal',          'Tono del esfínter conservado, sin tumoraciones palpables.'),
(20, 3, 'Conducto auditivo externo', 'Ambos conductos permeables, sin secreción.');

INSERT INTO consentimiento_informado
(id, cirugia_solicitud_id, procedimiento, objetivo, caracteristicas, riesgos,
 medico_id, paciente_o_representante, fecha_obtencion, firmado)
VALUES
(1, 1, 'Apendicectomía laparoscópica',
 'Eliminar el apéndice inflamado y prevenir peritonitis.',
 'Procedimiento realizado por laparoscopia mediante tres puertos de entrada.',
 'Sangrado, infección del sitio quirúrgico, lesión de órganos vecinos y complicaciones de la anestesia.',
 3, 'Ana García Pérez', '2026-09-14', TRUE),
(2, 2, 'Cesárea segmentaria',
 'Extraer al feto vivo mediante incisión abdominal y uterina.',
 'Incisión de Pfannenstiel y extracción del feto por vía abdominal.',
 'Hemorragia, infección, lesión de vejiga o intestinos y complicaciones anestésicas.',
 22, 'Natalia De León Quiñónez', '2026-09-20', TRUE),
(3, 3, 'Reducción y osteosíntesis de segundo metacarpiano',
 'Restituir la anatomía y la función de la mano.',
 'Reducción bajo anestesia local y fijación del hueso con material de osteosíntesis.',
 'Infección, lesión del nervio radial, rigidez articular y necesidad de reintervención.',
 20, 'Luis Báez Villagrán (representante legal)', '2026-09-23', TRUE);

INSERT INTO chequeo_preanestesico
(id, cirugia_solicitud_id, asa, medico_clasifica_id, plan_anestesia, anestesista_id, fecha_hora)
VALUES
(1, 1, 'II', 3,  'Anestesia general con intubación orotracheal y monitorización continua.', 5, '2026-09-15 07:20'),
(2, 2, 'II', 22, 'Anestesia regional peridural con analgesia posoperatoria.',             5, '2026-09-21 07:20'),
(3, 3, 'I',  20, 'Anestesia local con sedación Consciente.',                            5, '2026-09-23 09:00');

INSERT INTO cirugia_etapa (id, cirugia_solicitud_id, etapa, fecha_hora_inicio, fecha_hora_fin, enfermero_responsable_id, observaciones)
VALUES
(1, 1, 'Preoperatorio',   '2026-09-15 07:30', '2026-09-15 08:00', 4,  'Paciente preparado; checklist de entrada completo.'),
(2, 1, 'Intraoperatorio', '2026-09-15 08:00', '2026-09-15 09:30', 4,  'Procedimiento realizado sin complicaciones.'),
(3, 1, 'Postoperatorio',  '2026-09-15 09:45', '2026-09-15 11:00', 4,  'Paciente estable durante la recuperación.'),
(4, 2, 'Preoperatorio',   '2026-09-21 07:30', '2026-09-21 08:00', 4,  'Paciente con ayuno completo y tipificación sanguínea verificada.'),
(5, 2, 'Intraoperatorio', '2026-09-21 08:00', '2026-09-21 09:05', 4,  'Extracción del feto vivo de 3 200 g con llanto espontáneo.'),
(6, 2, 'Postoperatorio',  '2026-09-21 09:20', '2026-09-21 10:30', 4,  'Recuperación sin incidencias.'),
(7, 3, 'Preoperatorio',   '2026-09-23 09:00', '2026-09-23 09:30', 58, 'Consentimiento informado firmado por la representante.'),
(8, 3, 'Intraoperatorio', '2026-09-23 09:30', '2026-09-23 10:45', 58, 'Reducción y osteosíntesis sin incidencias.'),
(9, 3, 'Postoperatorio',  '2026-09-23 11:00', '2026-09-23 12:00', 58, 'Movimientos de mano conservados.');

INSERT INTO chequeo_quirurgico (id, cirugia_solicitud_id, etapa, aspecto, resultado, observaciones, fecha_hora, registrado_por_id)
VALUES
(1,  1, 'Planificación',    'Disponibilidad de tabla quirúrgica',                     'Éxito',    'Pabellón y hora confirmados.',                '2026-09-14 10:35', 4),
(2,  1, 'Planificación',    'Preparación de equipos y quirófano',                     'Éxito',    'Torre laparoscópica estéril y operativa.',     '2026-09-14 10:40', 4),
(3,  1, 'Entrada',          'Brazalete de identificación del paciente',                'Éxito',    'Nombre, procedimiento y lado confirmados.',     '2026-09-15 07:55', 4),
(4,  1, 'Entrada',          'Ficha clínica: consentimiento informado y preanestésico', 'Éxito',   'Documentos firmados y en expediente.',          '2026-09-15 07:56', 4),
(5,  1, 'Entrada',          'Confirmación de arsenal instrumental, implantes y equipos', 'Éxito', 'Todo disponible y operativo.',                  '2026-09-15 07:58', 4),
(6,  1, 'Quirófano',        'Traslado correcto de camilla a mesa quirúrgica',        'Éxito',    'Traslado supervisado sin incidentes.',         '2026-09-15 08:05', 4),
(7,  1, 'Quirófano',        'Posicionamiento correcto en mesa operatoria',           'Éxito',    'Decúbito dorsal con control de los miembros.', '2026-09-15 08:08', 4),
(8,  1, 'Pausa quirúrgica', 'Confirmación de todo el equipo de quirófano',           'Éxito',    'Presencia completa del equipo quirúrgico.',     '2026-09-15 08:10', 4),
(9,  1, 'Pausa quirúrgica', 'Confirmación de buenas condiciones de esterilidad',     'Éxito',    'Verificado antes de la incisión.',             '2026-09-15 08:12', 4),
(10, 1, 'Pausa quirúrgica', 'Revisión de máquina de anestesia',                     'Aceptable','Revisión realizada; alarma de oxígeno desactivada.', '2026-09-15 08:14', 4),
(11, 1, 'Pausa quirúrgica', 'Confirmación de suministro de anestesia',               'Éxito',    'Anestesia administrada según plan.',           '2026-09-15 08:16', 4),
(12, 1, 'Salida quirúrgica', 'Conteo del instrumental',                             'Éxito',    'Conteo satisfactoryo, sin faltantes.',        '2026-09-15 09:35', 4),
(13, 1, 'Salida quirúrgica', 'Cierre de la incisión',                               'Éxito',    'Cierre con sutura absorbible.',                '2026-09-15 09:40', 4),
(14, 1, 'Postoperatorio',   'Condiciones de evolución durante la cirugía',           'Éxito',    'Sin complicaciones intraoperatorias.',         '2026-09-15 09:50', 4),
(15, 1, 'Postoperatorio',   'Confirmación de disposición de infraestructura',        'Aceptable','Monitor de sala de recuperación en mantenimiento.', '2026-09-15 10:00', 4),
(16, 1, 'Traslado seguro',  'Signos vitales dentro de los límites normales',         'Éxito',    'Signos estables antes del traslado a la cama.', '2026-09-15 10:15', 4),
(17, 1, 'Traslado seguro',  'Zona operatoria limpia y documentada',                  'Éxito',    'Zona limpia, sueros de mantención pasando.',    '2026-09-15 10:20', 4),
(18, 2, 'Quirófano',        'Placa operatoria colocada en el lugar correcto',        'Fallo',    'Se reubica la placa antes de la incisión.',   '2026-09-21 08:10', 4),
(19, 2, 'Postoperatorio',   'Confirmación de insumos: bombas de infusión',           'Medianamente aceptable', 'Una bomba sin batería disponible.', '2026-09-21 09:30', 4),
(20, 2, 'Salida quirúrgica', 'Conteo del instrumental',                          'No aceptable', 'Faltó una gasa al conteo; se recupera antes del cierre.', '2026-09-21 09:00', 4),
(21, 3, 'Entrada',          'Brazalete de identificación del paciente',                'Éxito',    'Nombre y lado confirmados con la madre.',       '2026-09-23 09:05', 58),
(22, 3, 'Traslado seguro',  'Signos vitales dentro de los límites normales',         'Éxito',    'Signos estables antes del alta de la sala.',    '2026-09-23 11:30', 58);