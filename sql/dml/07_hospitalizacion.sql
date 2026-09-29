-- Hospitalización

INSERT INTO hospitalizacion (id, paciente_id, hospital_id, ingreso_id, unidad_medica_id, servicio_medico_id, medico_encargado_id, cama_id, fecha_hora_ingreso, fecha_hora_egreso, costo_por_dia)
VALUES
(1, 2,  1, 1, 4, 5,  1,  5,  '2026-09-14 21:00', '2026-09-17 11:00', 850.00),
(2, 3,  1, 2, 4, 11, 16, 12, '2026-09-15 22:00', '2026-09-17 08:00', 640.00),
(3, 8,  1, 3, 4, 7,  51, 11, '2026-09-18 22:00', '2026-09-22 11:00', 950.00),
(4, 12, 1, 4, 4, 14, 53, 6,  '2026-09-19 03:20', '2026-09-23 02:30', 1500.00),
(5, 11, 2, 8, 4, 8,  54, 19, '2026-09-25 10:00', '2026-09-27 09:00', 700.00);