import { Controller, Get, Query } from '@nestjs/common';
import { ReportesService } from './reportes.service.js';

@Controller('reportes')
export class ReportesController {
  constructor(private readonly reportes: ReportesService) {}

  @Get('02')
  menorNota() {
    return this.reportes.menorNota();
  }

  @Get('11')
  ingresos(@Query('desde') desde?: string, @Query('hasta') hasta?: string) {
    return this.reportes.ingresos(desde, hasta);
  }

  @Get('13')
  citasPorEspecialidad() {
    return this.reportes.citasPorEspecialidad();
  }
}
