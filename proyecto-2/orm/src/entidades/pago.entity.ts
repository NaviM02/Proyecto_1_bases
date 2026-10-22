import { Column, Entity, JoinColumn, ManyToOne, PrimaryColumn } from 'typeorm';
import type { Relation } from 'typeorm';
import { Factura } from './factura.entity.js';

@Entity({ name: 'pago' })
export class Pago {
  @PrimaryColumn({ type: 'integer' })
  id!: number;

  @Column({ name: 'fecha_pago', type: 'timestamp' })
  fechaPago!: Date;

  @Column({ type: 'numeric', precision: 12, scale: 2 })
  monto!: string;

  @ManyToOne(() => Factura, (factura) => factura.pagos)
  @JoinColumn({ name: 'factura_id' })
  factura!: Relation<Factura>;
}
