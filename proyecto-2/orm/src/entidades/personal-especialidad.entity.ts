import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'personal_especialidad' })
export class PersonalEspecialidad {
  @PrimaryColumn({ name: 'personal_medico_id', type: 'integer' })
  medicoId!: number;

  @PrimaryColumn({ name: 'especialidad_id', type: 'integer' })
  especialidadId!: number;

  @Column({ type: 'boolean' })
  principal!: boolean;
}
