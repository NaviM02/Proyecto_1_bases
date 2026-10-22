import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'paciente' })
export class Paciente {
  @PrimaryColumn({ type: 'integer' })
  id!: number;

  @Column({ type: 'varchar', length: 10 })
  sexo!: string;
}
