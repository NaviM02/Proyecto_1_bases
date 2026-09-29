-- Insumos, instrumentos y equipos

INSERT INTO insumo (id, nombre, descripcion, material, tipo) VALUES
(1, 'Guantes quirúrgicos',      'Guantes estériles para procedimiento quirúrgico.', 'Látex',       'Quirúrgico'),
(2, 'Gasas estériles',          'Gasas para limpieza y control durante procedimientos.','Algodón',  'Médico'),
(3, 'Jeringa 10 ml',            'Jeringa descartable.',                           'Plástico',    'Médico'),
(4, 'Sutura absorbible',        'Material para cierre de tejidos.',                'Poliglactina','Quirúrgico'),
(5, 'Sutura no absorbible',     'Material para cierre de piel.',                  'Polipropileno','Quirúrgico'),
(6, 'Anestesia local',          'Anestésico local para procedimientos menores.',  'Lidocaína',   'Otro'),
(7, 'Cánula endotraqueal',      'Cánula para vía aérea en anestesia general.',    'PVC',         'Quirúrgico'),
(8, 'Solución salina 0.9%',     'Solución isotónica de 500 ml.',                  'Cloruro de sodio', 'Médico');

INSERT INTO instrumento (id, nombre, descripcion, tipo, funcion) VALUES
(1, 'Bisturí quirúrgico',       'Instrumento para realizar incisiones.',       'Quirúrgico', 'Corte'),
(2, 'Pinza hemostática',        'Instrumento para control de sangrado.',       'Quirúrgico', 'Hemostática'),
(3, 'Separador abdominal',      'Instrumento para separación de tejidos.',     'Quirúrgico', 'Retractor'),
(4, 'Pinza de Babcock',         'Pinza atraumática para sujeción de tejidos.','Quirúrgico', 'Accesorio'),
(5, 'Pinza de Cohen',           'Pinza de contención vascular.',               'Médico',     'Contenido'),
(6, 'Fijador óseo',             'Elemento de osteosíntesis interna.',          'Quirúrgico', 'Implante'),
(7, 'Pinza atraumatológica',    'Pinza de prueba para evaluar el pulso distal.', 'Médico', 'Corte'),
(8, 'Cureta de Blaker',          'Instrumento para limpieza de cavidades en cirugía otorrinolaringológica.', 'Quirúrgico', 'Otro');

INSERT INTO equipo (id, nombre, descripcion, tipo, funcion) VALUES
(1, 'Monitor de signos vitales','Monitorización continua de signos vitales.',  'Médico',     'Diagnóstico'),
(2, 'Máquina de anestesia',     'Equipo para administración de anestesia.',    'Quirúrgico', 'Tratamiento'),
(3, 'Torre laparoscópica',      'Equipo para procedimientos laparoscópicos.',  'Quirúrgico', 'Diagnóstico'),
(4, 'Laringoscopio',            'Laringoscopio para intubación orotraqueal.',  'Médico',     'Exploración'),
(5, 'Bomba de infusión',        'Bomba para administración de fármacos.','Médico',     'Tratamiento'),
(6, 'Aspirador quirúrgico',     'Aspiración de sangre y fluidos en quirófano.','Quirúrgico', 'Tratamiento'),
(7, 'Tensiómetro digital',      'Medición no invasiva de la presión arterial.','Médico',     'Exploración'),
(8, 'Bicicleta estática',       'Bicicleta para rehabilitación física.',      'Médico',     'Rehabilitación'),
(9, 'Contenedor de residuos',   'Contenedor para disposición de residuos.','Otro',       'Otro');

INSERT INTO cirugia_insumo (cirugia_solicitud_id, insumo_id, cantidad) VALUES
(1, 1, 6), (1, 2, 10), (1, 4, 1), (1, 6, 2), (1, 8, 3),
(2, 1, 6), (2, 4, 3), (2, 7, 1), (2, 8, 4),
(3, 1, 4), (3, 2, 6), (3, 4, 1), (3, 6, 1);

INSERT INTO cirugia_instrumento (cirugia_solicitud_id, instrumento_id, cantidad) VALUES
(1, 1, 1), (1, 2, 3), (1, 3, 2), (1, 4, 1),
(2, 1, 1), (2, 2, 2), (2, 4, 2),
(3, 1, 1), (3, 2, 2), (3, 6, 2);

INSERT INTO cirugia_equipo (cirugia_solicitud_id, equipo_id, cantidad) VALUES
(1, 1, 1), (1, 2, 1), (1, 3, 1), (1, 6, 1),
(2, 1, 1), (2, 2, 1), (2, 6, 1),
(3, 1, 1), (3, 7, 1);

-- Laboratorio

INSERT INTO examen_laboratorio (id, nombre, tipo, descripcion) VALUES
(1, 'Hemograma completo',        'Sangre',       'Conteo de células sanguíneas.'),
(2, 'Glucosa en ayunas',         'Sangre',       'Nivel de glucosa en sangre.'),
(3, 'Perfil lipídico',           'Sangre',       'Colesterol y triglicéridos.'),
(4, 'Examen general de orina',   'Orina',        'Análisis físico y químico de la orina.'),
(5, 'Radiografía de tórax',      'Imagenología', 'Estudio de imagen del tórax.'),
(6, 'Hemocultivo',               'Sangre',       'Cultivo de sangre para gérmenes.'),
(7, 'Coprocultivo',              'Heces',        'Cultivo de heces para gérmenes.'),
(8, 'Parasitológico fecal',      'Heces',        'Búsqueda de parásitos intestinales.'),
(9, 'Prueba de embarazo',        'Orina',        'Detección de embarazo en orina.'),
(10,'Prueba rápida de VIH',      'Otro',         'Prueba rápida de detección de VIH.');

INSERT INTO orden_laboratorio (id, paciente_id, medico_solicita_id, consulta_id, cirugia_solicitud_id, fecha_hora_solicitud, estado, observaciones)
VALUES
(1, 1,  1,  1,    NULL, '2026-09-14 08:40', 'Completada', 'Órdenes de laboratorio para control de hipertensión.'),
(2, 2,  3,  NULL, 1,    '2026-09-14 11:30', 'Completada', 'Exámenes prequirúrgicos previos a la apendicectomía.'),
(3, 6,  8,  2,    NULL, '2026-09-18 09:45', 'Solicitada', 'Estudios iniciales por dolor lumbar de nueva aparición.'),
(4, 2,  2,  3,    NULL, '2026-09-23 09:40', 'En proceso',  'Control de perfil lipídico y función renal.'),
(5, 10, 31, NULL, 4,    '2026-09-18 10:15', 'Cancelada',   'El paciente no cumple las condiciones para el procedimiento.'),
(6, 7,  20, NULL, 3,    '2026-09-23 08:05', 'Completada',  'Exámenes prequirúrgicos de la mano.');

INSERT INTO orden_laboratorio_examen (orden_laboratorio_id, examen_laboratorio_id, resultado, fecha_resultado)
VALUES
(1, 1, 'Valores dentro de los rangos normales.', '2026-09-14 11:00'),
(1, 2, 'Glucosa 98 mg/dL.',                      '2026-09-14 11:00'),
(1, 3, 'Colesterol total 185 mg/dL.',            '2026-09-14 11:00'),
(2, 1, 'Leucocitos elevados (14 000 /µL).',      '2026-09-14 18:00'),
(2, 4, 'Sin datos patológicos.',                 '2026-09-14 18:00'),
(2, 5, 'Sin hallazgos relevantes.',              '2026-09-14 18:30'),
(3, 1, NULL, NULL),
(3, 6, NULL, NULL),
(4, 3, NULL, NULL),
(4, 9, NULL, NULL),
(5, 1, NULL, NULL),
(5, 10,'No se realizó: el paciente no alcanzó a otorgar consentimiento.', '2026-09-18 11:00'),
(6, 1, 'Leucocitos 9 800 /µL.',                 '2026-09-23 08:40'),
(6, 5, 'Fractura oblicua de metacarpiano.',      '2026-09-23 08:50'),
(6, 7, 'Sin crecimiento bacteriano.',            '2026-09-23 08:55');