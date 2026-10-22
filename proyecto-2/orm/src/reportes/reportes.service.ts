import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Hospital } from '../entidades/hospital.entity.js';
import { NotaConsulta } from '../entidades/nota-consulta.entity.js';
import { Medico } from '../entidades/medico.entity.js';
import { Consulta } from '../entidades/consulta.entity.js';
import { Cita } from '../entidades/cita.entity.js';
import { Especialidad } from '../entidades/especialidad.entity.js';
import { PersonalEspecialidad } from '../entidades/personal-especialidad.entity.js';

@Injectable()
export class ReportesService {
  constructor(
    @InjectRepository(Hospital) private readonly hospitales: Repository<Hospital>,
    @InjectRepository(NotaConsulta) private readonly notas: Repository<NotaConsulta>,
    @InjectRepository(Cita) private readonly citas: Repository<Cita>,
  ) {}

  // Objetivo 2. Promedio de las evaluaciones atribuidas a consultas externas.
  menorNota() {
    return this.notas.createQueryBuilder('n')
      .innerJoin(Medico, 'm', 'm.id = n.medico_id')
      .innerJoin(Hospital, 'h', 'h.id = n.hospital_id')
      .select('m.id', 'id')
      .addSelect('m.nombres', 'nombres')
      .addSelect('m.apellidos', 'apellidos')
      .addSelect('h.nombre', 'hospital')
      .addSelect('ROUND(n.suma_notas / n.evaluaciones, 2)', 'promedio')
      .addSelect((qb) => qb.select('COUNT(*)')
        .from(Consulta, 'c')
        .innerJoin('c.cita', 'a')
        .where('c.medico_id = m.id')
        .andWhere('a.hospital_id = n.hospital_id'), 'consultas')
      .addSelect('n.consultas_calificadas', 'consultas_calificadas')
      .addSelect('n.evaluaciones', 'evaluaciones')
      .orderBy('promedio', 'ASC')
      .addOrderBy('m.id', 'ASC')
      .addOrderBy('h.id', 'ASC')
      .limit(5)
      .getRawMany();
  }

  // Objetivo 11. Pagos recibidos en el intervalo, incluyendo hospitales sin cobros.
  ingresos(desde = '2026-09-01', hasta = '2026-11-01') {
    this.validarIntervalo(desde, hasta);
    return this.hospitales.createQueryBuilder('h')
      .leftJoin('h.facturas', 'f', 'f.estado <> :anulada', { anulada: 'Anulada' })
      .leftJoin('f.pagos', 'p',
        'p.fecha_pago >= CAST(:desde AS timestamp) AND p.fecha_pago < CAST(:hasta AS timestamp)',
        { desde, hasta })
      .select('h.id', 'id')
      .addSelect('h.nombre', 'nombre')
      .addSelect('CASE WHEN SUM(p.monto) IS NULL THEN 0.00 ELSE ROUND(SUM(p.monto), 2) END', 'ingresos')
      .groupBy('h.id')
      .addGroupBy('h.nombre')
      .orderBy('ingresos', 'DESC')
      .addOrderBy('h.id', 'ASC')
      .getRawMany();
  }

  // Objetivo 13. Cada cita se cuenta en una única especialidad del médico.
  citasPorEspecialidad() {
    const especialidad = this.citas.createQueryBuilder().subQuery()
      .select('pe.especialidad_id')
      .from(PersonalEspecialidad, 'pe')
      .where('pe.personal_medico_id = a.medico_id')
      .orderBy('pe.principal', 'DESC')
      .addOrderBy('pe.especialidad_id', 'ASC')
      .limit(1)
      .getQuery();

    return this.citas.createQueryBuilder('a')
      .innerJoin('a.hospital', 'h')
      .innerJoin('a.paciente', 'p')
      .leftJoin(Especialidad, 'e', `e.id = ${especialidad}`)
      .select('h.id', 'id')
      .addSelect('h.nombre', 'nombre')
      .addSelect('CAST(a.fecha_hora AS date)', 'fecha')
      .addSelect('p.sexo', 'sexo')
      .addSelect('CASE WHEN e.nombre IS NULL THEN :sinEspecialidad ELSE e.nombre END', 'especialidad')
      .addSelect('COUNT(*)', 'citas')
      .addSelect('SUM(CASE WHEN a.estado = :cancelada THEN 1 ELSE 0 END)', 'canceladas')
      .addSelect('SUM(CASE WHEN a.estado <> :cancelada THEN 1 ELSE 0 END)', 'demanda_vigente')
      .setParameters({ sinEspecialidad: 'Sin especialidad', cancelada: 'Cancelada' })
      .groupBy('h.id')
      .addGroupBy('h.nombre')
      .addGroupBy('CAST(a.fecha_hora AS date)')
      .addGroupBy('p.sexo')
      .addGroupBy('e.nombre')
      .orderBy('fecha', 'ASC')
      .addOrderBy('h.id', 'ASC')
      .addOrderBy('p.sexo', 'ASC')
      .addOrderBy('especialidad', 'ASC')
      .getRawMany();
  }

  private validarIntervalo(desde: string, hasta: string) {
    const formato = /^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}(:\d{2})?)?$/;
    const instantes: number[] = [];
    for (const fecha of [desde, hasta]) {
      const date = new Date(fecha.includes('T') ? `${fecha}Z` : `${fecha}T00:00:00Z`);
      if (!formato.test(fecha) || Number.isNaN(date.getTime())
          || date.toISOString().slice(0, 10) !== fecha.slice(0, 10)) {
        throw new BadRequestException('Use fechas válidas: YYYY-MM-DD o YYYY-MM-DDTHH:mm:ss');
      }
      instantes.push(date.getTime());
    }
    if (instantes[0] >= instantes[1]) {
      throw new BadRequestException('desde debe ser anterior a hasta');
    }
  }
}
