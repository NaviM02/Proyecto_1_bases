-- Objetivo 15. Extensión aditiva: se preservan tablas, IDs, FKs y columnas de la fase 1.
BEGIN;
-- Supertipo: datos generales compartidos por médicos, enfermería y otros empleados.
CREATE TABLE personal (
    id integer PRIMARY KEY,
    hospital_id integer NOT NULL REFERENCES hospital(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    nombres varchar(100) NOT NULL,
    apellidos varchar(100) NOT NULL,
    dpi varchar(20) NOT NULL UNIQUE,
    telefono varchar(20),
    direccion text,
    fecha_contratacion date,
    tipo varchar(15) NOT NULL,
    -- Discriminador cerrado; subtipos disjuntos.
    CONSTRAINT ck_personal_tipo CHECK (tipo IN ('Médico','Enfermería','Otro')),
    UNIQUE (id,tipo), UNIQUE (id,hospital_id)
);
INSERT INTO personal (id,hospital_id,nombres,apellidos,dpi,telefono,tipo)
SELECT id,hospital_id,nombres,apellidos,dpi,telefono,
 CASE WHEN tipo_personal IN ('Médico','Anestesista') THEN 'Médico'
 WHEN tipo_personal IN ('Enfermero','Practicante Enfermería') THEN 'Enfermería' ELSE 'Otro' END
FROM personal_medico;
-- El registro clínico legado conserva sus datos por compatibilidad y depende del supertipo.
ALTER TABLE personal_medico ADD CONSTRAINT fk_legado_personal FOREIGN KEY(id)
 REFERENCES personal(id) ON DELETE RESTRICT ON UPDATE CASCADE;
-- Subtipo médico: atributos particulares, sin duplicar datos generales.
CREATE TABLE medico_perfil (
    personal_id integer PRIMARY KEY REFERENCES personal_medico(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    tipo varchar(15) NOT NULL DEFAULT 'Médico',
    hospital_id integer NOT NULL,
    colegiado varchar(40) UNIQUE,
    salario numeric(12,2),
    nivel_acceso varchar(20) NOT NULL DEFAULT 'Clínico',
    cargo varchar(15) NOT NULL DEFAULT 'Médico',
    -- Subtipo exclusivamente médico.
    CONSTRAINT ck_medico_tipo CHECK (tipo='Médico'),
    -- Salario desconocido permitido para el legado, jamás negativo.
    CONSTRAINT ck_medico_salario CHECK (salario IS NULL OR salario>=0),
    -- Niveles funcionales de aplicación; no sustituyen los roles de PostgreSQL.
    CONSTRAINT ck_medico_acceso CHECK (nivel_acceso IN ('Clínico','Supervisor','Administrador')),
    -- Cargos de la cadena de mando.
    CONSTRAINT ck_medico_cargo CHECK (cargo IN ('Médico','Jefe','Director')),
    FOREIGN KEY (personal_id,tipo) REFERENCES personal(id,tipo) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (personal_id,hospital_id) REFERENCES personal(id,hospital_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE (personal_id,hospital_id)
);
INSERT INTO medico_perfil (personal_id,hospital_id)
SELECT id,hospital_id FROM personal WHERE tipo='Médico';
-- Subtipo enfermería: se incluyen enfermeros legados y se admiten nuevas contrataciones independientes.
CREATE TABLE enfermeria (
    personal_id integer PRIMARY KEY,
    tipo varchar(15) NOT NULL DEFAULT 'Enfermería',
    registro_profesional varchar(40) UNIQUE,
    nivel varchar(15) NOT NULL,
    -- Subtipo exclusivamente de enfermería.
    CONSTRAINT ck_enfermeria_tipo CHECK (tipo='Enfermería'),
    -- Niveles formativos válidos.
    CONSTRAINT ck_enfermeria_nivel CHECK (nivel IN ('Auxiliar','Profesional','Practicante')),
    FOREIGN KEY (personal_id,tipo) REFERENCES personal(id,tipo) ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO enfermeria (personal_id,nivel)
SELECT id,CASE WHEN tipo_personal='Practicante Enfermería' THEN 'Practicante' ELSE 'Profesional' END
FROM personal_medico WHERE tipo_personal IN ('Enfermero','Practicante Enfermería');
-- Relación recursiva dentro del mismo hospital; NULL identifica al director raíz.
CREATE TABLE medico_supervision (
    medico_id integer PRIMARY KEY,
    hospital_id integer NOT NULL,
    superior_id integer,
    -- No se permite supervisarse a sí mismo.
    CONSTRAINT ck_supervision_distinto CHECK (medico_id IS DISTINCT FROM superior_id),
    FOREIGN KEY (medico_id,hospital_id) REFERENCES medico_perfil(personal_id,hospital_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (superior_id,hospital_id) REFERENCES medico_perfil(personal_id,hospital_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE UNIQUE INDEX uq_director_hospital ON medico_supervision(hospital_id) WHERE superior_id IS NULL;
-- Evita ciclos de cualquier longitud; serializa modificaciones concurrentes de la jerarquía.
CREATE FUNCTION validar_supervision() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 PERFORM pg_advisory_xact_lock(20262015);
 IF NEW.superior_id IS NULL AND NOT EXISTS (
  SELECT 1 FROM medico_perfil WHERE personal_id=NEW.medico_id AND cargo='Director') THEN
  RAISE EXCEPTION 'Una raíz debe tener cargo Director';
 END IF;
 IF EXISTS (
  WITH RECURSIVE cadena(id,ruta) AS (
   SELECT NEW.superior_id,ARRAY[NEW.superior_id]
   UNION ALL SELECT s.superior_id,c.ruta||s.superior_id
   FROM cadena c JOIN medico_supervision s ON s.medico_id=c.id
   WHERE s.superior_id IS NOT NULL AND NOT s.superior_id=ANY(c.ruta)
  ) SELECT 1 FROM cadena WHERE id=NEW.medico_id
 ) THEN RAISE EXCEPTION 'La supervisión formaría un ciclo'; END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER tr_validar_supervision BEFORE INSERT OR UPDATE ON medico_supervision
FOR EACH ROW EXECUTE FUNCTION validar_supervision();
-- Sincronización bidireccional de las columnas comunes conservadas por compatibilidad.
CREATE FUNCTION sincronizar_personal() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF pg_trigger_depth()>1 THEN RETURN NEW; END IF;
 IF TG_TABLE_NAME='personal_medico' THEN
  INSERT INTO personal (id,hospital_id,nombres,apellidos,dpi,telefono,tipo)
  VALUES (NEW.id,NEW.hospital_id,NEW.nombres,NEW.apellidos,NEW.dpi,NEW.telefono,
   CASE WHEN NEW.tipo_personal IN ('Médico','Anestesista') THEN 'Médico'
   WHEN NEW.tipo_personal IN ('Enfermero','Practicante Enfermería') THEN 'Enfermería' ELSE 'Otro' END)
  ON CONFLICT(id) DO UPDATE SET hospital_id=excluded.hospital_id,nombres=excluded.nombres,
   apellidos=excluded.apellidos,dpi=excluded.dpi,telefono=excluded.telefono,tipo=excluded.tipo;
 ELSE
  UPDATE personal_medico SET hospital_id=NEW.hospital_id,nombres=NEW.nombres,
   apellidos=NEW.apellidos,dpi=NEW.dpi,telefono=NEW.telefono WHERE id=NEW.id
   AND (hospital_id,nombres,apellidos,dpi,telefono) IS DISTINCT FROM
       (NEW.hospital_id,NEW.nombres,NEW.apellidos,NEW.dpi,NEW.telefono);
 END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER tr_legado_personal BEFORE INSERT OR UPDATE ON personal_medico
FOR EACH ROW EXECUTE FUNCTION sincronizar_personal();
CREATE TRIGGER tr_personal_legado AFTER UPDATE ON personal
FOR EACH ROW EXECUTE FUNCTION sincronizar_personal();
GRANT SELECT ON personal,medico_perfil,enfermeria,medico_supervision TO hospital_lector;
COMMIT;
