import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';
import type { Relation } from 'typeorm';
import { Hospital } from './hospital.entity.js';
import { Paciente } from './paciente.entity.js';
import { Medico } from './medico.entity.js';

@Entity({ name: 'cita' })
export class Cita {
  @PrimaryColumn({ type: 'integer' })
  id!: number;

  @Column({ name: 'fecha_hora', type: 'timestamp' })
  fechaHora!: Date;

  @Column({ type: 'varchar', length: 20 })
  estado!: string;

  @ManyToOne(() => Hospital)
  @JoinColumn({ name: 'hospital_id' })
  hospital!: Relation<Hospital>;

  @ManyToOne(() => Paciente)
  @JoinColumn({ name: 'paciente_id' })
  paciente!: Relation<Paciente>;

  @ManyToOne(() => Medico)
  @JoinColumn({ name: 'medico_id' })
  medico!: Relation<Medico>;
}
