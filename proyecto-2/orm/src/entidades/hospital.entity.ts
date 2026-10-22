import { Column, Entity, OneToMany, PrimaryColumn } from 'typeorm';
import type { Relation } from 'typeorm';
import { Factura } from './factura.entity.js';

@Entity({ name: 'hospital' })
export class Hospital {
  @PrimaryColumn({ type: 'integer' })
  id!: number;

  @Column({ type: 'varchar', length: 150 })
  nombre!: string;

  @OneToMany(() => Factura, (factura) => factura.hospital)
  facturas!: Relation<Factura[]>;
}
