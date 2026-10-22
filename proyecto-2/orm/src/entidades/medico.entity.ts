import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'personal_medico' })
export class Medico {
  @PrimaryColumn({ type: 'integer' })
  id!: number;

  @Column({ type: 'varchar', length: 100 })
  nombres!: string;

  @Column({ type: 'varchar', length: 100 })
  apellidos!: string;
}
