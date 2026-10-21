-- Única preparación como postgres: GRANT ALL de fase 1 no concede propiedad para ALTER TABLE.
-- Cambia propietario, no datos ni estructura; la migración posterior se ejecuta como hospital_admin.
ALTER TABLE public.personal_medico OWNER TO hospital_admin;
