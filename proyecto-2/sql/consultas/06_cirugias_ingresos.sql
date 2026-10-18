-- Objetivo 6. Cobros de cirugías realizadas con evolución y chequeos satisfactorios.
-- Quirófano, Pausa quirúrgica y Salida quirúrgica corresponden al proceso intraoperatorio.
SELECT s.tipo_procedimiento, ROUND(SUM(v.monto), 2) AS ingresos
FROM cirugia_solicitud s
JOIN v_cobro_unidad v ON v.cirugia_id = s.id
JOIN (
    SELECT cirugia_solicitud_id
    FROM chequeo_quirurgico
    GROUP BY cirugia_solicitud_id
    HAVING COUNT(CASE WHEN aspecto = 'Condiciones de evolución durante la cirugía'
                            AND resultado = 'Éxito' THEN 1 END) > 0
       AND COUNT(CASE WHEN etapa IN ('Quirófano', 'Pausa quirúrgica', 'Salida quirúrgica') THEN 1 END) > 0
       AND COUNT(CASE WHEN (etapa IN ('Quirófano', 'Pausa quirúrgica', 'Salida quirúrgica')
                               OR aspecto = 'Condiciones de evolución durante la cirugía')
                            AND resultado NOT IN ('Éxito', 'Aceptable') THEN 1 END) = 0
) q ON q.cirugia_solicitud_id = s.id
JOIN (
    SELECT DISTINCT cirugia_solicitud_id
    FROM cirugia_etapa
    WHERE etapa = 'Intraoperatorio' AND fecha_hora_fin IS NOT NULL
) e ON e.cirugia_solicitud_id = s.id
WHERE s.estado = 'Realizada'
  AND v.fecha_pago >= :'desde'::timestamp AND v.fecha_pago < :'hasta'::timestamp
GROUP BY s.tipo_procedimiento
ORDER BY ingresos DESC, s.tipo_procedimiento
LIMIT 3;
