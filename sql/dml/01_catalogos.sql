-- Catálogos y estructura general

INSERT INTO hospital (id, nombre, direccion, telefono) VALUES
(1, 'Hospital de Occidente Central', 'Zona 1, Quetzaltenango', '5550-1001'),
(2, 'Hospital de Occidente Norte',   'Zona 3, Quetzaltenango', '5550-1002');

INSERT INTO unidad_medica (id, nombre) VALUES
(1, 'Consulta Externa'),
(2, 'Emergencias'),
(3, 'Cirugía'),
(4, 'Hospitalización');

-- Consulta externa (1-14), cirugía (15-28) y hospitalización (29-35).
INSERT INTO especialidad (id, nombre, descripcion) VALUES
(1,  'Cardiología',                     'Atención del aparato cardiovascular.'),
(2,  'Dermatología',                    'Atención de la piel.'),
(3,  'Fisioterapia',                    'Rehabilitación física.'),
(4,  'Ginecología Oncológica',          'Cáncer del aparato reproductor femenino.'),
(5,  'Hematología',                     'Enfermedades de la sangre.'),
(6,  'Medicina Física y Rehabilitación', 'Rehabilitación integral.'),
(7,  'Medicina General',                'Atención médica general.'),
(8,  'Nutrición y Dietética',           'Atención nutricional.'),
(9,  'Odontología General',             'Atención dental.'),
(10, 'Oftalmología',                    'Atención de los ojos.'),
(11, 'Psicología',                      'Atención psicológica.'),
(12, 'Pediatría',                       'Atención de niñas y niños.'),
(13, 'Urología',                        'Atención del aparato urinario.'),
(14, 'Terapia del Lenguaje',            'Atención del lenguaje.'),
(15, 'Cirugía General',                 'Cirugía de adultos.'),
(16, 'Cirugía Neurológica',             'Cirugía del sistema nervioso.'),
(17, 'Cirugía Ortopédica',             'Cirugía de huesos y articulaciones.'),
(18, 'Cirugía Pediátrica',              'Cirugía de niñas y niños.'),
(19, 'Cirugía Cardiovascular (Adulto y Pediátrica)', 'Cirugía del corazón y de los grandes vasos.'),
(20, 'Cirugía de la Mano',              'Cirugía de la extremidad superior.'),
(21, 'Videolaparoscopia Quirúrgica',    'Cirugía mediante videolaparoscopia.'),
(22, 'Cirugía Ginecológica',            'Cirugía del aparato reproductor femenino.'),
(23, 'Cirugía Oftalmológica',           'Cirugía de los ojos.'),
(24, 'Cirugía Oncológica',              'Cirugía para el tratamiento del cáncer.'),
(25, 'Cirugía Otorrinolaringológica',   'Cirugía de oído, nariz y garganta.'),
(26, 'Cirugía Plástica',                'Cirugía reconstructiva.'),
(27, 'Cirugía de Tórax',                'Cirugía de tórax y pulmón.'),
(28, 'Cirugía Urológica',               'Cirugía del aparato urinario.'),
(29, 'Medicina Interna',                'Atención de enfermedades internas en hospitalización.'),
(30, 'Neumología',                      'Atención de enfermedades respiratorias.'),
(31, 'Neurología',                      'Atención de enfermedades del sistema nervioso.'),
(32, 'Oncología',                       'Atención del paciente con cáncer.'),
(33, 'Ortopedia',                       'Atención de traumatología y huesos.'),
(34, 'Unidad de Cuidados Intermedios',  'Atención de pacientes en observación y estabilización.'),
(35, 'Unidad de Cuidado Crítico de Adultos', 'Atención intensiva de adultos.');

INSERT INTO servicio_medico (id, unidad_medica_id, nombre, descripcion, costo_base) VALUES
(1,  1, 'Consulta de medicina general',                       'Consulta médica general.',                      250.00),
(2,  1, 'Consulta de especialidad',                           'Consulta médica especializada.',                400.00),
(3,  2, 'Atención de emergencia',                             'Atención médica de emergencia.',                600.00),
(4,  3, 'Procedimiento quirúrgico',                           'Procedimiento quirúrgico.',                    4800.00),
(5,  4, 'Hospitalización',                                    'Servicio de hospitalización por día.',          850.00),
(6,  4, 'Atención de hematología',                            'Hospitalización por hematología.',              780.00),
(7,  4, 'Atención de neumología',                             'Hospitalización por neumología.',               950.00),
(8,  4, 'Atención de medicina interna',                       'Hospitalización por medicina interna.',         700.00),
(9,  4, 'Atención de neurología',                             'Hospitalización por neurología.',               720.00),
(10, 4, 'Atención de oncología',                              'Hospitalización por oncología.',                760.00),
(11, 4, 'Atención de pediatría',                              'Hospitalización pediátrica.',                    640.00),
(12, 4, 'Atención de ortopedia',                              'Hospitalización por ortopedia.',                700.00),
(13, 4, 'Atención en unidad de cuidados intermedios',         'Atención en sala de cuidados intermedios.',    1100.00),
(14, 4, 'Atención en unidad de cuidado crítico de adultos',   'Atención en unidad de cuidado crítico.',       1500.00);

-- Cada hospital de la cadena contiene las cuatro unidades.
INSERT INTO hospital_unidad (hospital_id, unidad_medica_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4),
(2, 1), (2, 2), (2, 3), (2, 4);

INSERT INTO clinica (id, hospital_id, unidad_medica_id, numero, descripcion) VALUES
(1, 1, 1, 'CE-01', 'Consultorio de medicina general'),
(2, 1, 1, 'CE-02', 'Consultorio de especialidad'),
(3, 2, 1, 'CE-01', 'Consultorio de medicina general'),
(4, 1, 1, 'CE-03', 'Consultorio de odontología'),
(5, 1, 1, 'CE-04', 'Consultorio de fisioterapia y terapia del lenguaje'),
(6, 1, 1, 'CE-05', 'Consultorio de psicología'),
(7, 1, 1, 'CE-06', 'Consultorio de pediatría'),
(8, 2, 1, 'CE-02', 'Consultorio de especialidad'),
(9, 2, 1, 'CE-03', 'Consultorio de medicina general');

-- Cuatro quirófanos por hospital, camillas de emergencia y camas de hospitalización.
INSERT INTO recurso_asistencial (id, hospital_id, unidad_medica_id, tipo, nombre, descripcion, disponible) VALUES
(1,  1, 2, 'Camilla',   'CAM-01',  'Camilla de emergencia',                              TRUE),
(2,  1, 2, 'Camilla',   'CAM-02',  'Camilla de emergencia',                              TRUE),
(3,  1, 3, 'Quirófano', 'QX-01',   'Quirófano principal',                                TRUE),
(4,  1, 3, 'Quirófano', 'QX-02',   'Quirófano secundario',                               TRUE),
(5,  1, 4, 'Cama',      'CAMA-01', 'Cama de hospitalización',                            TRUE),
(6,  1, 4, 'Cama',      'CAMA-02', 'Cama de hospitalización',                            TRUE),
(7,  1, 2, 'Camilla',   'CAM-03',  'Camilla de emergencia',                              TRUE),
(8,  1, 2, 'Camilla',   'CAM-04',  'Camilla de emergencia ocupada por un paciente',     FALSE),
(9,  1, 3, 'Quirófano', 'QX-03',   'Quirófano terciario',                                TRUE),
(10, 1, 3, 'Quirófano', 'QX-04',   'Quirófano de urgencias',                             TRUE),
(11, 1, 4, 'Cama',      'CAMA-03', 'Cama de hospitalización',                            TRUE),
(12, 1, 4, 'Cama',      'CAMA-04', 'Cama de hospitalización',                            TRUE),
(13, 2, 2, 'Camilla',   'CAM-01',  'Camilla de emergencia',                              TRUE),
(14, 2, 2, 'Camilla',   'CAM-02',  'Camilla de emergencia',                              TRUE),
(15, 2, 3, 'Quirófano', 'QX-01',   'Quirófano principal',                                TRUE),
(16, 2, 3, 'Quirófano', 'QX-02',   'Quirófano secundario',                               TRUE),
(17, 2, 3, 'Quirófano', 'QX-03',   'Quirófano terciario',                                TRUE),
(18, 2, 3, 'Quirófano', 'QX-04',   'Quirófano de urgencias',                             TRUE),
(19, 2, 4, 'Cama',      'CAMA-01', 'Cama de hospitalización',                            TRUE),
(20, 2, 4, 'Cama',      'CAMA-02', 'Cama de hospitalización',                            TRUE);