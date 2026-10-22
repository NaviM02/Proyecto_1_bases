import { strict as assert } from 'node:assert';
import { readFile, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { NestFactory } from '@nestjs/core';
import { DataSource } from 'typeorm';
import { AppModule } from './app.module.js';
import { ReportesService } from './reportes/reportes.service.js';

type Fila = Record<string, unknown>;

function normalizar(rows: Fila[]) {
  return rows.map((row) => Object.fromEntries(Object.keys(row).sort().map((key) => {
    const value = row[key];
    return [key, value instanceof Date ? value.toISOString() : value === null ? null : String(value)];
  })));
}

async function main() {
  const app = await NestFactory.create(AppModule, { logger: false });
  try {
    await app.listen(0, '127.0.0.1');
    const url = await app.getUrl();
    const dataSource = app.get(DataSource);
    const reportes = app.get(ReportesService);
    const [usuario] = await dataSource.query('SELECT current_user AS nombre');
    assert.equal(usuario.nombre, 'hospital_lector');
    assert.equal(dataSource.options.synchronize, false);
    const casos = [
      ['2026-09-01', '2026-11-01'],
      ['2026-10-10', '2026-10-20'],
      ['2030-01-01', '2030-02-01'],
      ['2026-10-04T07:00:00', '2026-10-04T10:00:00'],
      ['2026-10-04T23:00:00', '2026-10-05T01:00:00'],
    ];
    const resultados = [];
    for (const numero of ['02', '11', '13']) {
      const archivos: Record<string, string> = {
        '02': '02_menor_nota.sql', '11': '11_ingresos_totales.sql', '13': '13_citas.sql',
      };
      const source = await readFile(new URL(`../../sql/consultas/${archivos[numero]}`, import.meta.url), 'utf8');
      const sql = source.replaceAll(":'desde'", '$1').replaceAll(":'hasta'", '$2');
      for (const [desde, hasta] of casos) {
        const esperado = await dataSource.query(sql, numero === '11' ? [desde, hasta] : []);
        const obtenido = numero === '02' ? await reportes.menorNota()
          : numero === '11' ? await reportes.ingresos(desde, hasta) : await reportes.citasPorEspecialidad();
        assert.deepEqual(normalizar(obtenido), normalizar(esperado), `SQL/ORM objetivo ${numero}`);
        const response = await fetch(`${url}/reportes/${numero}?${new URLSearchParams({ desde, hasta })}`);
        assert.equal(response.status, 200);
        assert.deepEqual(normalizar(await response.json() as Fila[]), normalizar(esperado), `HTTP objetivo ${numero}`);
        resultados.push({ objetivo: Number(numero), desde, hasta, filas: obtenido.length,
          sql_igual_orm: true, http_igual_sql: true, resultado: obtenido });
        console.log(`Objetivo ${numero}: SQL = TypeORM = HTTP (${obtenido.length} filas, ${desde} / ${hasta})`);
      }
    }
    for (const [desde, hasta] of [['2026-10-01\'; DROP TABLE hospital; --', '2026-11-01'],
      ['2026-11-01', '2026-10-01'], ['2026-02-30', '2026-11-01'],
      ['2026-10-01', '2026-10-01T00:00:00']]) {
      const response = await fetch(`${url}/reportes/11?${new URLSearchParams({ desde, hasta })}`);
      assert.equal(response.status, 400);
    }
    const evidence = new URL('../../documentacion/evidencias/orm_typeorm.json', import.meta.url);
    await writeFile(evidence, JSON.stringify({ framework: 'NestJS + TypeORM', usuario: usuario.nombre,
      comparaciones: resultados.length, entradas_invalidas_rechazadas: 4, resultados }, null, 2));
    console.log(`Evidencia: ${fileURLToPath(evidence)}`);
  } finally {
    await app.close();
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
