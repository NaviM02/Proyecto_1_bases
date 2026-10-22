import { ViewColumn, ViewEntity } from 'typeorm';

@ViewEntity({ name: 'v_nota_consulta', synchronize: false })
export class NotaConsulta {
  @ViewColumn({ name: 'medico_id' })
  medicoId!: number;

  @ViewColumn({ name: 'hospital_id' })
  hospitalId!: number;

  @ViewColumn({ name: 'consultas_calificadas' })
  consultasCalificadas!: string;

  @ViewColumn({ name: 'suma_notas' })
  sumaNotas!: string;

  @ViewColumn()
  evaluaciones!: string;
}
