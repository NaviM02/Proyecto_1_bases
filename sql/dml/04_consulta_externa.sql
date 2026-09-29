-- Consulta externa

-- Costos: primera consulta 100%, reconsulta 75%, referido 80% y 10% de
-- sobrecargo sobre la cita siguiente cuando el paciente cancela sin notificar.
INSERT INTO cita (id, paciente_id, hospital_id, clinica_id, medico_id, fecha_hora, costo, tipo_cita, estado, fecha_cancelacion, motivo_cancelacion)
VALUES
(1,  1,  1, 1, 1,  '2026-09-14 08:00', 250.00, 'Primera consulta', 'Realizada',  NULL, NULL),
(2,  2,  1, 2, 2,  '2026-09-15 09:00', 400.00, 'Primera consulta', 'Programada',  NULL, NULL),
(3,  3,  1, 1, 1,  '2026-09-16 10:00', 187.50, 'Reconsulta',      'Cancelada',   '2026-09-15 15:00', 'El paciente notificó que no podía asistir.'),
(4,  4,  1, 2, 2,  '2026-09-17 11:00', 320.00, 'Referido',        'Programada',  NULL, NULL),
(5,  6,  1, 5, 8,  '2026-09-18 09:00', 400.00, 'Primera consulta', 'Realizada',  NULL, NULL),
(6,  9,  1, 6, 15, '2026-09-22 08:00', 400.00, 'Primera consulta', 'Reprogramada', NULL, NULL),
(7,  2,  1, 2, 2,  '2026-09-23 09:00', 300.00, 'Reconsulta',      'Realizada',   NULL, NULL),
(8,  11, 1, 2, 2,  '2026-09-24 10:00', 320.00, 'Referido',        'Realizada',   NULL, NULL),
(9,  12, 1, 2, 2,  '2026-09-25 08:00', 400.00, 'Primera consulta', 'Cancelada',   '2026-09-25 08:10', 'El paciente no compareció y no notificó la cancelación.'),
(10, 12, 1, 2, 2,  '2026-09-28 08:00', 440.00, 'Primera consulta', 'Programada',  NULL, NULL),
(11, 4,  1, 4, 13, '2026-09-29 11:00', 400.00, 'Primera consulta', 'Cancelada',   '2026-09-26 10:00', 'La paciente reprogramó por motivos laborales.');

INSERT INTO consulta (id, cita_id, paciente_id, medico_id, fecha_hora, diagnostico, otros_datos, observaciones)
VALUES
(1, 1, 1,  1,  '2026-09-14 08:35', 'Hipertensión arterial leve.',        'Presión arterial elevada durante la evaluación.', 'Se recomienda seguimiento y control de presión.'),
(2, 5, 6,  8,  '2026-09-18 09:40', 'Lumbago mecánico de origen postural.','Sedestación prolongada durante el trabajo.',           'Se indican ejercicios de fisioterapia y medidas ergonómicas.'),
(3, 7, 2,  2,  '2026-09-23 09:35', 'Hipertensión arterial controlada.',  'Presión arterial 128/82 mmHg.',                         'Se mantiene el tratamiento antihipertensivo.'),
(4, 8, 11, 2,  '2026-09-24 10:35', 'Dolor precordial atípico.',          'Electrocardiograma sin alteraciones.',                  'Se indica seguimiento y control de factores de riesgo.');

INSERT INTO medicamento (id, nombre, descripcion) VALUES
(1,  'Losartán',                   'Control de la presión arterial.'),
(2,  'Paracetamol',                'Analgésico y antipirético.'),
(3,  'Omeprazol',                  'Disminuye la producción de ácido gástrico.'),
(4,  'Simvastatina',               'Control del colesterol.'),
(5,  'Ibuprofeno',                 'Antiinflamatorio y analgésico.'),
(6,  'Amoxicilina',                'Antibiótico de amplio espectro.'),
(7,  'Salbutamol',                'Bronodilatador de rescate.'),
(8,  'Ondansetrón',                'Antiemético.'),
(9,  'Sales de rehidratación oral','Reemplazo de líquidos y electrolitos.'),
(10, 'Furosemida',                 'Diurético de asa.'),
(11, 'Hidroclorotiazida',          'Diurético para el control de la presión arterial.');

INSERT INTO receta (id, consulta_id, paciente_id, medico_id, fecha, proxima_cita, clinica_id)
VALUES
(1, 1, 1,  1, '2026-09-14', '2026-10-14', 1),
(2, 2, 6,  8, '2026-09-18', '2026-10-02', 5),
(3, 3, 2,  2, '2026-09-23', '2026-10-07', 2),
(4, 4, 11, 2, '2026-09-24', '2026-10-08', 2);

INSERT INTO receta_medicamento (receta_id, medicamento_id, dosis, duracion) VALUES
(1, 1,  '50 mg cada 24 horas',         '30 días'),
(1, 4,  '20 mg cada 24 horas',         '30 días'),
(1, 11, '25 mg cada 8 horas',          '15 días'),
(2, 5,  '400 mg cada 8 horas',         '7 días'),
(2, 2,  '500 mg cada 6 horas',         '5 días'),
(3, 1,  '50 mg cada 24 horas',         '30 días'),
(3, 11, '25 mg cada 24 horas',         '30 días'),
(4, 8,  '4 mg cada 8 horas',           '5 días'),
(4, 9,  '1 sobre cada 8 horas',        '3 días');