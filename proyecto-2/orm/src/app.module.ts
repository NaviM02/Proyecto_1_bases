import 'reflect-metadata';
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Hospital } from './entidades/hospital.entity.js';
import { Factura } from './entidades/factura.entity.js';
import { Pago } from './entidades/pago.entity.js';
import { Paciente } from './entidades/paciente.entity.js';
import { Medico } from './entidades/medico.entity.js';
import { Cita } from './entidades/cita.entity.js';
import { Consulta } from './entidades/consulta.entity.js';
import { Especialidad } from './entidades/especialidad.entity.js';
import { PersonalEspecialidad } from './entidades/personal-especialidad.entity.js';
import { NotaConsulta } from './entidades/nota-consulta.entity.js';
import { ReportesModule } from './reportes/reportes.module.js';

try {
  process.loadEnvFile();
} catch (error) {
  if ((error as NodeJS.ErrnoException).code !== 'ENOENT') throw error;
}

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST ?? 'localhost',
      port: Number(process.env.DB_PORT ?? 5432),
      username: process.env.DB_USER ?? 'hospital_lector',
      password: process.env.DB_PASSWORD ?? '',
      database: process.env.DB_NAME ?? 'hospital_db',
      entities: [Hospital, Factura, Pago, Paciente, Medico, Cita, Consulta,
        Especialidad, PersonalEspecialidad, NotaConsulta],
      synchronize: false,
      dropSchema: false,
      migrationsRun: false,
    }),
    ReportesModule,
  ],
})
export class AppModule {}
