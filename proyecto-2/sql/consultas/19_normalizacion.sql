-- Objetivo 19. Propuesta ejecutable en un esquema separado; no sustituye las tablas de fase 1.
BEGIN;
CREATE SCHEMA propuesta_3fn AUTHORIZATION hospital_admin;
-- Catálogo de diagnósticos; código determina descripción (dependencia transitiva eliminada).
CREATE TABLE propuesta_3fn.diagnostico (
 codigo varchar(20) PRIMARY KEY,
 descripcion text NOT NULL
);
-- Hecho quirúrgico; reutiliza los catálogos normalizados de personas/especialidades/insumos.
CREATE TABLE propuesta_3fn.cirugia (
 id integer PRIMARY KEY,
 cirujano_id integer NOT NULL REFERENCES public.medico_perfil(personal_id) ON DELETE RESTRICT ON UPDATE CASCADE,
 paciente_id integer NOT NULL REFERENCES public.paciente(id) ON DELETE RESTRICT ON UPDATE CASCADE,
 especialidad_id integer NOT NULL REFERENCES public.especialidad(id) ON DELETE RESTRICT ON UPDATE CASCADE,
 fecha timestamp NOT NULL
);
-- Diagnósticos múltiples por cirugía, sin repetir datos de cirujano/paciente.
CREATE TABLE propuesta_3fn.cirugia_diagnostico (
 cirugia_id integer REFERENCES propuesta_3fn.cirugia(id) ON DELETE CASCADE ON UPDATE CASCADE,
 codigo varchar(20) REFERENCES propuesta_3fn.diagnostico(codigo) ON DELETE RESTRICT ON UPDATE CASCADE,
 PRIMARY KEY(cirugia_id,codigo)
);
-- Reemplaza Insumo_1/Insumo_2 por tantas filas como sean necesarias (1FN).
CREATE TABLE propuesta_3fn.cirugia_insumo (
 cirugia_id integer REFERENCES propuesta_3fn.cirugia(id) ON DELETE CASCADE ON UPDATE CASCADE,
 insumo_id integer REFERENCES public.insumo(id) ON DELETE RESTRICT ON UPDATE CASCADE,
 cantidad numeric(12,2) NOT NULL,
 -- Cantidad consumida estrictamente positiva.
 CONSTRAINT ck_propuesta_cantidad CHECK(cantidad>0),
 PRIMARY KEY(cirugia_id,insumo_id)
);
GRANT USAGE ON SCHEMA propuesta_3fn TO hospital_lector;
GRANT SELECT ON ALL TABLES IN SCHEMA propuesta_3fn TO hospital_lector;
COMMIT;
