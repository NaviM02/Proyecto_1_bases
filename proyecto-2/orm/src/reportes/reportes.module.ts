import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Hospital } from '../entidades/hospital.entity.js';
import { NotaConsulta } from '../entidades/nota-consulta.entity.js';
import { Cita } from '../entidades/cita.entity.js';
import { ReportesController } from './reportes.controller.js';
import { ReportesService } from './reportes.service.js';

@Module({
  imports: [TypeOrmModule.forFeature([Hospital, NotaConsulta, Cita])],
  controllers: [ReportesController],
  providers: [ReportesService],
})
export class ReportesModule {}
