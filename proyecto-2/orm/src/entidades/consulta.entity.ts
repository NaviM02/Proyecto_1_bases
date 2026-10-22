import { Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';
import type { Relation } from 'typeorm';
import { Cita } from './cita.entity.js';
import { Medico } from './medico.entity.js';

@Entity({ name: 'consulta' })
export class Consulta {
  @PrimaryColumn({ type: 'integer' })
  id!: number;

  @ManyToOne(() => Cita)
  @JoinColumn({ name: 'cita_id' })
  cita!: Relation<Cita>;

  @ManyToOne(() => Medico)
  @JoinColumn({ name: 'medico_id' })
  medico!: Relation<Medico>;
}
