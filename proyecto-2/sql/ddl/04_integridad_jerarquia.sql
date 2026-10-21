BEGIN;
-- La arista superior debe existir en la misma jerarquía, no solo como perfil médico.
ALTER TABLE medico_supervision ADD CONSTRAINT uq_supervision_hospital UNIQUE(medico_id,hospital_id);
ALTER TABLE medico_supervision ADD CONSTRAINT fk_superior_en_jerarquia
 FOREIGN KEY (superior_id,hospital_id) REFERENCES medico_supervision(medico_id,hospital_id)
 ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
-- Un director raíz no se puede degradar sin reorganizar primero su jerarquía.
CREATE FUNCTION validar_cargo_director() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF NEW.cargo<>'Director' AND EXISTS (
  SELECT 1 FROM medico_supervision WHERE medico_id=NEW.personal_id AND superior_id IS NULL
 ) THEN RAISE EXCEPTION 'Reorganice la raíz antes de cambiar el cargo Director'; END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER tr_cargo_director BEFORE UPDATE OF cargo ON medico_perfil
FOR EACH ROW EXECUTE FUNCTION validar_cargo_director();
COMMIT;
