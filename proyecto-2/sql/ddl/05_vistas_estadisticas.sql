BEGIN;
-- Cantidad de decesos por fecha y hospital.
CREATE VIEW v_decesos_dia AS
SELECT hospital_id, CAST(fecha_hora AS date) AS fecha, COUNT(*) AS total_dia
FROM egreso
WHERE codigo_egreso = 'Muerto'
GROUP BY hospital_id, CAST(fecha_hora AS date);

-- Cantidad de decesos por fecha, hospital y unidad médica.
CREATE VIEW v_decesos_unidad AS
SELECT hospital_id, CAST(fecha_hora AS date) AS fecha, unidad_medica_id, COUNT(*) AS decesos
FROM egreso
WHERE codigo_egreso = 'Muerto'
GROUP BY hospital_id, CAST(fecha_hora AS date), unidad_medica_id;

-- Edad al ingreso y turno civil de cada atención de emergencias.
CREATE VIEW v_demografia_emergencias AS
SELECT i.hospital_id, p.sexo,
       EXTRACT(YEAR FROM AGE(i.fecha_hora, p.fecha_nacimiento)) AS edad,
       CASE WHEN CAST(i.fecha_hora AS time) >= TIME '06:00'
                  AND CAST(i.fecha_hora AS time) < TIME '14:00' THEN 'Matutino'
            WHEN CAST(i.fecha_hora AS time) >= TIME '14:00'
                  AND CAST(i.fecha_hora AS time) < TIME '22:00' THEN 'Vespertino'
            ELSE 'Nocturno' END AS turno
FROM ingreso i
JOIN paciente p ON p.id = i.paciente_id
WHERE i.unidad_medica_id = 2;

GRANT SELECT ON v_decesos_dia, v_decesos_unidad, v_demografia_emergencias TO hospital_lector;
COMMIT;
