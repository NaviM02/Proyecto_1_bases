-- Objetivo 20. Ejecutar como hospital_admin: auditoría automática, una fila por campo cambiado.
BEGIN;
-- Bitácora histórica: sin FK al médico para conservar evidencia aunque el origen se elimine.
CREATE TABLE auditoria_personal (
 id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 medico_id integer NOT NULL,
 tabla text NOT NULL,
 campo text NOT NULL,
 operacion varchar(6) NOT NULL,
 valor_anterior text,
 valor_nuevo text,
 usuario_sesion text NOT NULL,
 rol_efectivo text NOT NULL,
 momento timestamptz NOT NULL DEFAULT clock_timestamp(),
 transaccion bigint NOT NULL DEFAULT txid_current(),
 -- Operaciones que pueden alterar los datos sensibles.
 CONSTRAINT ck_auditoria_operacion CHECK(operacion IN ('INSERT','UPDATE','DELETE'))
);
-- SECURITY DEFINER permite auditar sin conceder INSERT directo a quien edita el dato.
-- Search_path fijo evita sustitución de objetos; session_user conserva el login real.
CREATE FUNCTION auditar_personal() RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER
SET search_path=pg_catalog,public AS $$
DECLARE anterior jsonb; nuevo jsonb; campos text[]; campo_actual text; identificador integer;
BEGIN
 anterior:=CASE WHEN TG_OP='INSERT' THEN '{}'::jsonb ELSE to_jsonb(OLD) END;
 nuevo:=CASE WHEN TG_OP='DELETE' THEN '{}'::jsonb ELSE to_jsonb(NEW) END;
 identificador:=coalesce((nuevo->>'personal_id')::integer,(nuevo->>'personal_medico_id')::integer,
                        (anterior->>'personal_id')::integer,(anterior->>'personal_medico_id')::integer);
 campos:=CASE WHEN TG_TABLE_NAME='medico_perfil' THEN ARRAY['salario','nivel_acceso']
              ELSE ARRAY['especialidad_id','principal'] END;
 FOREACH campo_actual IN ARRAY campos LOOP
  IF (anterior->>campo_actual) IS DISTINCT FROM (nuevo->>campo_actual) THEN
   INSERT INTO public.auditoria_personal(medico_id,tabla,campo,operacion,valor_anterior,valor_nuevo,usuario_sesion,rol_efectivo)
   VALUES(identificador,TG_TABLE_NAME,campo_actual,TG_OP,anterior->>campo_actual,nuevo->>campo_actual,
          session_user,coalesce(nullif(current_setting('role',true),'none'),session_user));
  END IF;
 END LOOP;
 RETURN NULL;
END $$;
CREATE TRIGGER tr_auditar_perfil AFTER INSERT OR UPDATE OR DELETE ON medico_perfil
FOR EACH ROW EXECUTE FUNCTION auditar_personal();
-- Fase 1 pertenece a postgres: crear este trigger requiere preparación DCL adicional.
CREATE TRIGGER tr_auditar_especialidad AFTER INSERT OR UPDATE OR DELETE ON personal_especialidad
FOR EACH ROW EXECUTE FUNCTION auditar_personal();
REVOKE ALL ON auditoria_personal FROM PUBLIC;
GRANT SELECT ON auditoria_personal TO hospital_lector;
COMMIT;
