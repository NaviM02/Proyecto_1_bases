-- Facturación y pagos

-- Facturas de consulta externa.
INSERT INTO factura (id, paciente_id, hospital_id, fecha_emision, descripcion, total, estado)
VALUES
(1, 2,  1, '2026-09-15 13:00', 'Atención de emergencia y hospitalización.',                        3150.00, 'Parcial'),
(2, 2,  1, '2026-09-15 14:00', 'Procedimiento quirúrgico: apendicectomía laparoscópica.',           4800.00, 'Pagada'),
(3, 1,  1, '2026-09-14 09:15', 'Consulta de medicina general.',                                   250.00,  'Pagada'),
(4, 2,  1, '2026-09-23 10:00', 'Consulta de cardiología (reconsulta).',                            300.00,  'Pendiente'),
(5, 11, 1, '2026-09-24 11:00', 'Consulta de cardiología por paciente referido.', 320.00,  'Pagada'),
(6, 4,  1, '2026-09-17 08:00', 'Factura anulada por cancelación de la cita programada.',           400.00,  'Anulada'),
(7, 9,  1, '2026-09-22 11:30', 'Cesárea segmentaria e insumos quirúrgicos.',                        6000.00, 'Parcial'),
(8, 8,  1, '2026-09-22 12:00', 'Atención de emergencia y hospitalización por neumonía.',          4400.00, 'Pagada'),
(9, 12, 1, '2026-09-23 09:00', 'Atención de emergencia y unidad de cuidado crítico de adultos.',   6600.00, 'Parcial'),
(10,3,  1, '2026-09-17 09:00', 'Atención de emergencia y hospitalización pediátrica.',            2520.00, 'Pagada');

INSERT INTO factura_detalle (id, factura_id, servicio_medico_id, descripcion, cantidad, precio_unitario, subtotal)
VALUES
(1,  1, 3,    'Atención de emergencia',              1, 600.00,  600.00),
(2,  1, 5,    'Hospitalización por día',             3, 850.00,  2550.00),
(3,  2, 4,    'Procedimiento quirúrgico',            1, 4800.00, 4800.00),
(4,  3, 1,    'Consulta de medicina general',        1, 250.00,  250.00),
(5,  4, 2,    'Consulta de especialidad',            1, 300.00,  300.00),
(6,  5, 2,    'Consulta de especialidad',            1, 320.00,  320.00),
(7,  6, 2,    'Consulta de especialidad',            1, 400.00,  400.00),
(8,  7, 4,    'Procedimiento quirúrgico',            1, 5200.00, 5200.00),
(9,  7, NULL, 'Insumos quirúrgicos utilizados',      4, 200.00,  800.00),
(10, 8, 3,    'Atención de emergencia',              1, 600.00,  600.00),
(11, 8, 7,    'Hospitalización por día',             4, 950.00,  3800.00),
(12, 9, 3,    'Atención de emergencia',              1, 600.00,  600.00),
(13, 9, 14,   'Atención en unidad de cuidado crítico de adultos', 4, 1500.00, 6000.00),
(14, 10,3,    'Atención de emergencia',              1, 600.00,  600.00),
(15, 10,11,   'Hospitalización pediátrica por día',   3, 640.00,  1920.00);

-- La factura 2 se cancela en 12 cuotas (máximo permitido) y la factura 8 en un único pago.
INSERT INTO pago (id, factura_id, numero_pago, fecha_pago, monto)
VALUES
(1,  1,  1, '2026-09-17 13:00', 1000.00),
(2,  1,  2, '2026-09-18 14:00', 1000.00),
(3,  2,  1, '2026-09-15 10:00', 400.00),
(4,  2,  2, '2026-10-15 10:00', 400.00),
(5,  2,  3, '2026-11-15 10:00', 400.00),
(6,  2,  4, '2026-12-15 10:00', 400.00),
(7,  2,  5, '2027-01-15 10:00', 400.00),
(8,  2,  6, '2027-02-15 10:00', 400.00),
(9,  2,  7, '2027-03-15 10:00', 400.00),
(10, 2,  8, '2027-04-15 10:00', 400.00),
(11, 2,  9, '2027-05-15 10:00', 400.00),
(12, 2,  10, '2027-06-15 10:00', 400.00),
(13, 2,  11, '2027-07-15 10:00', 400.00),
(14, 2,  12, '2027-08-15 10:00', 400.00),
(15, 3,  1, '2026-09-14 09:30', 250.00),
(16, 5,  1, '2026-09-24 11:15', 320.00),
(17, 7,  1, '2026-09-22 12:00', 1500.00),
(18, 8,  1, '2026-09-22 13:00', 4400.00),
(19, 9,  1, '2026-09-23 10:00', 1000.00),
(20, 10, 1, '2026-09-17 09:30', 2520.00);