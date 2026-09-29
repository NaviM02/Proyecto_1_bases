-- Personas y personal

INSERT INTO paciente
(id, expediente, nombres, apellidos, dpi, fecha_nacimiento, sexo, estado_civil, telefono, seguro_social, municipio, departamento, area)
VALUES
(1, 'EXP-0001', 'Carlos',  'Méndez López',    '0000000000001', '1990-04-15', 'Masculino', 'Soltero',  '5551-0001', 'SS-0001', 'Quetzaltenango',    'Quetzaltenango', 'Urbana'),
(2, 'EXP-0002', 'Ana',     'García Pérez',    '0000000000002', '1987-09-22', 'Femenino',  'Casada',   '5551-0002', 'SS-0002', 'Salcajá',           'Quetzaltenango', 'Rural'),
(3, 'EXP-0003', 'Luis',    'Hernández Díaz',  '0000000000003', '2004-02-10', 'Masculino', 'Soltero',  '5551-0003', NULL,      'Quetzaltenango',    'Quetzaltenango', 'Urbana'),
(4, 'EXP-0004', 'María',   'Ramírez Soto',    '0000000000004', '1995-12-03', 'Femenino',  'Soltera',  '5551-0004', 'SS-0004', 'Totonicapán',       'Totonicapán',    'Rural'),
(5, 'EXP-0005', 'Sofía',   'Castillo Ruiz',   '0000000000005', '2014-06-18', 'Femenino',  'Soltera',  '5551-0005', NULL,      'La Esperanza',      'Quetzaltenango', 'Urbana'),
(6, 'EXP-0006', 'Jorge',   'Alvarado Recinos', '0000000000006', '1998-07-30', 'Masculino', 'Casado',   '5551-0006', 'SS-0006', 'San Francisco El Grande', 'Huehuetenango', 'Urbana'),
(7, 'EXP-0007', 'Claudia', 'Báez Villagrán',   '0000000000007', '2001-03-11', 'Femenino',  'Soltera',  '5551-0007', 'SS-0007', 'San Mateo',         'San Marcos',     'Rural'),
(8, 'EXP-0008', 'Ricardo', 'Cuc Ovalle',       '0000000000008', '1978-11-05', 'Masculino', 'Casado',   '5551-0008', 'SS-0008', 'Quetzaltenango',    'Quetzaltenango', 'Urbana'),
(9, 'EXP-0009', 'Natalia', 'De León Quiñónez', '0000000000009', '1985-05-19', 'Femenino',  'Casada',   '5551-0009', 'SS-0009', 'Salcajá',           'Quetzaltenango', 'Urbana'),
(10,'EXP-0010', 'Emilio',  'Chun Estrada',     '0000000000010', '2016-01-27', 'Masculino', 'Soltero',  '5551-0010', NULL,      'Quetzaltenango',    'Quetzaltenango', 'Urbana'),
(11,'EXP-0011', 'Verónica','Cruz Marroquín',   '0000000000011', '2001-09-14', 'Femenino',  'Soltera',  '5551-0011', 'SS-0011', 'Mazatenango',       'Suchitepéquez',  'Urbana'),
(12,'EXP-0012', 'Óscar',   'Guzmán Sandoval',   '0000000000012', '1969-02-08', 'Masculino', 'Viudo',    '5551-0012', 'SS-0012', 'Quetzaltenango',    'Quetzaltenango', 'Urbana');

INSERT INTO encargado
(id, nombres, apellidos, parentesco, dpi, telefono, municipio, departamento, area)
VALUES
(1, 'Roberto',   'Méndez García',  'Padre',   '0000000000011', '5552-0001', 'Quetzaltenango', 'Quetzaltenango', 'Urbana'),
(2, 'Laura',     'Soto Castillo',  'Madre',    '0000000000012', '5552-0002', 'La Esperanza',   'Quetzaltenango', 'Urbana'),
(3, 'Jorge',     'Hernández López', 'Hermano', '0000000000013', '5552-0003', 'Salcajá',        'Quetzaltenango', 'Rural'),
(4, 'Carmen',    'Villagrán Chun',  'Madre',    '0000000000014', '5552-0004', 'Quetzaltenango', 'Quetzaltenango', 'Urbana'),
(5, 'Luis',      'Báez Villagrán',  'Hermano',  '0000000000015', '5552-0005', 'San Mateo',      'San Marcos',     'Rural');

INSERT INTO paciente_encargado (paciente_id, encargado_id, principal) VALUES
(1,  1, TRUE),
(5,  2, TRUE),
(3,  3, TRUE),
(10, 4, TRUE),
(7,  5, TRUE);

-- Personal médico, enfermería, anestesia y practicantes de los dos hospitales.
INSERT INTO personal_medico
(id, hospital_id, nombres, apellidos, dpi, telefono, municipio, departamento, area, tipo_personal)
VALUES
(1,  1, 'Diego',     'Morales Pérez',  '0000000000101', '5553-0001', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(2,  1, 'Elena',     'Vásquez López',  '0000000000102', '5553-0002', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(3,  1, 'Fernando',  'Cifuentes Díaz', '0000000000103', '5553-0003', 'Salcajá',        'Quetzaltenango', 'Rural',  'Médico'),
(4,  1, 'Gabriela',  'Rodas Méndez',   '0000000000104', '5553-0004', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Enfermero'),
(5,  1, 'Hugo',      'Alvarado Cruz',  '0000000000105', '5553-0005', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Anestesista'),
(6,  2, 'Irene',     'Pineda Gómez',   '0000000000106', '5553-0006', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(7,  1, 'Mario',     'Beltrán Recinos','0000000000107', '5553-0007', 'Totonicapán',    'Totonicapán',    'Urbana', 'Médico'),
(8,  1, 'Silvia',    'Cáceres Bran',   '0000000000108', '5553-0008', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(9,  1, 'Rita',      'De León Estrada','0000000000109', '5553-0009', 'Salcajá',        'Quetzaltenango', 'Rural',  'Médico'),
(10, 1, 'Óscar',     'Fuentes Tzoc',   '0000000000110', '5553-0010', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(11, 1, 'Teresa',    'Guzmán Xicará',  '0000000000111', '5553-0011', 'San Mateo',      'San Marcos',     'Rural',  'Médico'),
(12, 1, 'Julio',     'Hernández Cuc',  '0000000000112', '5553-0012', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(13, 1, 'Andrea',    'Ical Zapeta',    '0000000000113', '5553-0013', 'Mazatenango',    'Suchitepéquez',  'Urbana', 'Médico'),
(14, 1, 'Byron',     'Job Cuc',        '0000000000114', '5553-0014', 'Cobán',          'Alta Verapaz',   'Urbana', 'Médico'),
(15, 1, 'Melissa',   'López Estrada',  '0000000000115', '5553-0015', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(16, 1, 'Karla',     'Martínez Bran',  '0000000000116', '5553-0016', 'Retalhuleu',     'Retalhuleu',     'Rural',  'Médico'),
(17, 1, 'Nelson',    'Otín Sandoval',  '0000000000117', '5553-0017', 'Suchitoto',      'El Progreso',    'Urbana', 'Médico'),
(18, 1, 'Marta',     'Pérez Villagrán','0000000000118', '5553-0018', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(19, 1, 'Alonso',    'Quetz Güemes',   '0000000000119', '5553-0019', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(20, 1, 'Brenda',    'Reyes Marroquín','0000000000120', '5553-0020', 'San Marcos',     'San Marcos',     'Urbana', 'Médico'),
(21, 1, 'Guillermo', 'Sala Ovalle',    '0000000000121', '5553-0021', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(22, 1, 'Carmen',    'Tuñón Villagrán','0000000000122', '5553-0022', 'Salcajá',        'Quetzaltenango', 'Rural',  'Médico'),
(23, 1, 'Esteban',   'Urizar Chun',    '0000000000123', '5553-0023', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(24, 1, 'Fátima',    'Vides Carranza', '0000000000124', '5553-0024', 'Totonicapán',    'Totonicapán',    'Urbana', 'Médico'),
(25, 1, 'Iván',      'Arriaga Negrón', '0000000000125', '5553-0025', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(26, 1, 'Paola',     'Barela Sandoval', '0000000000126', '5553-0026', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(27, 1, 'Marco',     'Cáceres Quiñónez','0000000000127', '5553-0027', 'Santa Cruz del Quiché', 'Quiché', 'Rural', 'Médico'),
(28, 1, 'Lucía',     'De León Cuc',    '0000000000128', '5553-0028', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(29, 1, 'Ramiro',    'Espinosa Bran',  '0000000000129', '5553-0029', 'Huehuetenango',  'Huehuetenango',  'Urbana', 'Médico'),
(30, 1, 'Silvio',    'Fuentes Ovalle', '0000000000130', '5553-0030', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(31, 1, 'Adriana',   'Gómez Marroquín','0000000000131', '5553-0031', 'La Esperanza',   'Quetzaltenango', 'Urbana', 'Médico'),
(32, 2, 'Héctor',    'Arana Sandoval', '0000000000132', '5553-0032', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(33, 2, 'Yesenia',   'Batz Chun',      '0000000000133', '5553-0033', 'Salcajá',        'Quetzaltenango', 'Rural',  'Médico'),
(34, 2, 'Rodrigo',   'Cardona Zapeta', '0000000000134', '5553-0034', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(35, 2, 'Ana Lucía', 'Cotzalá Estrada', '0000000000135', '5553-0035', 'Cobán',          'Alta Verapaz',   'Urbana', 'Médico'),
(36, 2, 'Mario',     'Dubón Villagrán','0000000000136', '5553-0036', 'Suchitoto',      'El Progreso',    'Urbana', 'Médico'),
(37, 2, 'Verónica',  'Echeverría Bran','0000000000137', '5553-0037', 'Retalhuleu',     'Retalhuleu',     'Rural',  'Médico'),
(38, 2, 'Luis',      'Figueroa Cuc',   '0000000000138', '5553-0038', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(39, 2, 'Sonia',     'Garcés Sandoval','0000000000139', '5553-0039', 'Totonicapán',    'Totonicapán',    'Urbana', 'Médico'),
(40, 2, 'Julio',     'Herrera Negrón', '0000000000140', '5553-0040', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(41, 2, 'Andrea',    'Ixcalá Quiñónez','0000000000141', '5553-0041', 'Mazatenango',    'Suchitepéquez',  'Urbana', 'Médico'),
(42, 2, 'Edwin',     'Job Marroquín',  '0000000000142', '5553-0042', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(43, 2, 'Fabiola',   'Lajá Ovalle',    '0000000000143', '5553-0043', 'Huehuetenango',  'Huehuetenango',  'Urbana', 'Médico'),
(44, 2, 'Germán',    'Menchú Zapeta',  '0000000000144', '5553-0044', 'Salcajá',        'Quetzaltenango', 'Rural',  'Médico'),
(45, 2, 'Priscila',  'Nájera Carranza','0000000000145', '5553-0045', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(46, 1, 'Alberto',  'Ochoa Bran',     '0000000000146', '5553-0046', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(47, 1, 'Walter',    'Pineda Cardona', '0000000000147', '5553-0047', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(48, 1,  'Rómulo',    'Santisteban Tzoc','0000000000148', '5553-0048', 'La Esperanza',   'Quetzaltenango', 'Urbana', 'Médico'),
(49, 2, 'Amado',     'Turcumá Gómez',  '0000000000149', '5553-0049', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(50, 2, 'Nelda',     'Villagrán Espinal','0000000000150','5553-0050', 'San Mateo',      'San Marcos',     'Rural',  'Médico'),
(51, 1, 'Gustavo',   'Arévalo Menchú', '0000000000151', '5553-0051', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(52, 1, 'Mónica',    'Barrientos Nájera','0000000000152','5553-0052', 'Totonicapán',    'Totonicapán',    'Urbana', 'Médico'),
(53, 1, 'Óscar',     'Cifuentes Lajá', '0000000000153', '5553-0053', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(54, 2, 'Rina',      'Job de León',    '0000000000154', '5553-0054', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(55, 2, 'Alfonso',   'Xicará Marroquín','0000000000155', '5553-0055', 'Salcajá',        'Quetzaltenango', 'Rural',  'Anestesista'),
(56, 2, 'Silvia',    'Batz Cú',        '0000000000156', '5553-0056', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Enfermero'),
(57, 1, 'Alma',      'Morán Sandoval', '0000000000157', '5553-0057', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Practicante Médico'),
(58, 1, 'Jonathan',  'Pérez Villagrán','0000000000158', '5553-0058', 'Salcajá',        'Quetzaltenango', 'Rural',  'Practicante Enfermería'),
(59, 2, 'Edilson',   'Quirós Marroquín','0000000000159', '5553-0059', 'Retalhuleu',    'Retalhuleu',    'Urbana', 'Médico'),
(60, 2, 'Sandra',    'Tzoc Villagrán', '0000000000160', '5553-0060', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Médico'),
(61, 1, 'Rigoberto', 'Axel Cuc',       '0000000000161', '5553-0061', 'Quetzaltenango', 'Quetzaltenango', 'Urbana', 'Otro');

INSERT INTO personal_especialidad (personal_medico_id, especialidad_id, principal) VALUES
(1,  7,  TRUE), (2,  1,  TRUE), (3,  15, TRUE), (6,  12, TRUE),
(7,  2,  TRUE), (8,  3,  TRUE), (9,  4,  TRUE), (10, 5,  TRUE),
(11, 6,  TRUE), (12, 8,  TRUE), (13, 9,  TRUE), (14, 10, TRUE),
(15, 11, TRUE), (16, 12, TRUE), (17, 13, TRUE), (18, 14, TRUE),
(19, 19, TRUE), (20, 20, TRUE), (21, 21, TRUE), (22, 22, TRUE),
(23, 23, TRUE), (24, 24, TRUE), (25, 25, TRUE), (26, 26, TRUE),
(27, 27, TRUE), (28, 28, TRUE), (29, 16, TRUE), (30, 17, TRUE),
(31, 18, TRUE), (32, 15, TRUE), (33, 19, TRUE), (34, 20, TRUE),
(35, 21, TRUE), (36, 22, TRUE), (37, 23, TRUE), (38, 24, TRUE),
(39, 25, TRUE), (40, 26, TRUE), (41, 27, TRUE), (42, 28, TRUE),
(43, 16, TRUE), (44, 17, TRUE), (45, 18, TRUE),
(46, 7,  TRUE), (47, 7,  TRUE), (48, 7,  TRUE), (49, 7,  TRUE),
(50, 7,  TRUE), (51, 30, TRUE), (52, 29, TRUE), (53, 35, TRUE),
(54, 29, TRUE), (58, 12, FALSE), (59, 7, TRUE), (60, 7, TRUE);

INSERT INTO personal_unidad (personal_medico_id, hospital_id, unidad_medica_id) VALUES
(1,  1, 1), (2,  1, 1), (7,  1, 1), (8,  1, 1), (9,  1, 1), (10, 1, 1),
(11, 1, 1), (12, 1, 1), (13, 1, 1), (14, 1, 1), (15, 1, 1), (16, 1, 1),
(17, 1, 1), (18, 1, 1), (6,  2, 1),
(3,  1, 3), (5,  1, 3), (19, 1, 3), (20, 1, 3), (21, 1, 3), (22, 1, 3),
(23, 1, 3), (24, 1, 3), (25, 1, 3), (26, 1, 3), (27, 1, 3), (28, 1, 3),
(29, 1, 3), (30, 1, 3), (31, 1, 3), (4,  1, 3), (57, 1, 3), (58, 1, 3),
(32, 2, 3), (33, 2, 3), (34, 2, 3), (35, 2, 3), (36, 2, 3), (37, 2, 3),
(38, 2, 3), (39, 2, 3), (40, 2, 3), (41, 2, 3), (42, 2, 3), (43, 2, 3),
(44, 2, 3), (45, 2, 3), (55, 2, 3), (56, 2, 3),
(1,  1, 2), (46, 1, 2), (47, 1, 2), (48, 1, 2),
(49, 2, 2), (50, 2, 2), (59, 2, 2), (60, 2, 2),
(1,  1, 4), (4,  1, 4), (51, 1, 4), (52, 1, 4), (53, 1, 4), (16, 1, 4),
(54, 2, 4), (56, 2, 4), (61, 1, 4);

-- Calificaciones de calidad del servicio (hospital, médico, enfermero y encargado).
INSERT INTO calificacion (id, hospital_id, personal_medico_id, encargado_id, puntuacion, comentario, fecha)
VALUES
(1, 1,    NULL, NULL, 5, 'Excelente atención en el hospital.',         '2026-09-15 10:00'),
(2, NULL, 1,    NULL, 4, 'Médico claro y atento con el paciente.',     '2026-09-15 10:30'),
(3, NULL, 4,    NULL, 5, 'Enfermera muy dedicada durante la estadía.', '2026-09-17 12:30'),
(4, NULL, NULL, 1,    4, 'Trato adecuado como encargado del paciente.', '2026-09-17 13:00'),
(5, 2,    NULL, NULL, 4, 'Recepción ágil y trato cordial.',            '2026-09-24 16:00'),
(6, NULL, 47,   NULL, 5, 'Estabilizó al paciente en pocos minutos.',   '2026-09-19 08:20');