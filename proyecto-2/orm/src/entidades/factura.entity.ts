import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryColumn } from 'typeorm';
import type { Relation } from 'typeorm';
import { Hospital } from './hospital.entity.js';
import { Pago } from './pago.entity.js';

@Entity({ name: 'factura' })
export class Factura {
  @PrimaryColumn({ type: 'integer' })
  id!: number;

  @Column({ type: 'varchar', length: 20 })
  estado!: string;

  @ManyToOne(() => Hospital, (hospital) => hospital.facturas)
  @JoinColumn({ name: 'hospital_id' })
  hospital!: Relation<Hospital>;

  @OneToMany(() => Pago, (pago) => pago.factura)
  pagos!: Relation<Pago[]>;
}
