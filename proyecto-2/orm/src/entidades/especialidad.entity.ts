import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'especialidad' })
export class Especialidad {
  @PrimaryColumn({ type: 'integer' })
  id!: number;

  @Column({ type: 'varchar', length: 120 })
  nombre!: string;
}
