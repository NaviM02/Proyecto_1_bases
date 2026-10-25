# Hospitales de Occidente — Base de datos hospitalaria

Proyecto de base de datos relacional en PostgreSQL 16 para la cadena Hospitales
de Occidente. Modela las unidades de Consulta Externa, Emergencias, Cirugía y
Hospitalización, sus pacientes, personal, atenciones, pagos y facturación.

El repositorio contiene la base inicial (Proyecto 1) y su extensión (Proyecto 2),
ambas sobre el mismo esquema `public` y la misma base `hospital_db`.

## Contenido del repositorio

| Ruta | Descripción |
| --- | --- |
| `modelo/` | Modelo original en notación Barker: archivos fuente de diagrams.net y sus imágenes exportadas. |
| `sql/ddl/` | Definición de las tablas, llaves, restricciones y relaciones del Proyecto 1. |
| `sql/dml/` | Datos ficticios de prueba del Proyecto 1, divididos en ocho scripts. |
| `sql/dcl/` | Roles y permisos del Proyecto 1 (`hospital_dcl.sql`). |
| `backup/` | Respaldo SQL del Proyecto 1 y respaldo limpio en formato custom para restauración. |
| `documentacion/` | Documentación PDF del Proyecto 1. |
| `proyecto-2/modelo/` | Diagrama extendido del Proyecto 2 y sus imágenes. |
| `proyecto-2/sql/ddl/` | Extensiones operativas, vistas, jerarquía y soporte de reportes del Proyecto 2. |
| `proyecto-2/sql/dml/` | Datos adicionales y datos de prueba del Proyecto 2. |
| `proyecto-2/sql/dcl/` | Preparación de permisos y propiedad para la instalación/auditoría. |
| `proyecto-2/sql/consultas/` | Consultas y scripts de verificación de los objetivos 1–20. |
| `proyecto-2/sql/rendimiento/` | Alternativa para comparar el rendimiento del ranking del objetivo 17. |
| `proyecto-2/sql/auditoria/` | Función y disparadores para registrar cambios sensibles del personal. |
| `proyecto-2/sql/pruebas/` | Prueba transaccional del escenario adicional de pagos. |
| `proyecto-2/orm/` | API NestJS + TypeORM para los reportes de los objetivos 2, 11 y 13. |
| `proyecto-2/documentacion/` | Documentación PDF y diccionario de datos. |
| `proyecto-2/backup/` | Respaldo de la base extendida y metadatos de verificación. |

## Proyecto 1 — instalación desde cero

Se requiere PostgreSQL 16 o superior. Para crear la base manualmente, conecta

```sql
CREATE DATABASE hospital_db;
```

Conecta después a `hospital_db` y ejecuta los scripts **DDL en orden numérico**:

1. `sql/ddl/01_catalogos.sql`
2. `sql/ddl/02_personas.sql`
3. `sql/ddl/03_ingresos_egresos_traslados.sql`
4. `sql/ddl/04_consulta_externa.sql`
5. `sql/ddl/05_cirugia.sql`
6. `sql/ddl/06_insumos_instrumentos_equipos.sql`
7. `sql/ddl/07_hospitalizacion.sql`
8. `sql/ddl/08_facturacion.sql`

Luego ejecuta los **DML en el mismo orden**:

1. `sql/dml/01_catalogos.sql`
2. `sql/dml/02_personas.sql`
3. `sql/dml/03_ingresos_egresos_traslados.sql`
4. `sql/dml/04_consulta_externa.sql`
5. `sql/dml/05_cirugia.sql`
6. `sql/dml/06_insumos_instrumentos_equipos.sql`
7. `sql/dml/07_hospitalizacion.sql`
8. `sql/dml/08_facturacion.sql`

Por último, aplica `sql/dcl/hospital_dcl.sql` como superusuario conectado a
`hospital_db`. Este script crea roles y asigna permisos. Usa las credenciales
definidas allí para conectarte con los roles de lectura o administración.

También se puede restaurar el archivo `backup/hospital_db_backup.sql` en lugar
de cargar todos los DDL y DML. **El respaldo es una alternativa**, no se debe
restaurar después de ejecutar los scripts anteriores.

## Proyecto 2 — instalación sobre una copia limpia

Proyecto 2 extiende la misma base del Proyecto 1. No ejecutes las migraciones de
nuevo en una base que ya tenga la extensión aplicada. El contenedor
`postgres-lab` ya tiene instalado Proyecto 2; para pruebas desde cero, utiliza
una copia aislada restaurada desde `backup/hospital_db_proyecto_1_limpio.dump`.

El orden de instalación sobre la copia limpia es:

1. `proyecto-2/sql/dcl/01_preparacion.sql` — ejecutar como `postgres`.
2. `proyecto-2/sql/ddl/01_datos_operativos.sql` — como `hospital_admin`.
3. `proyecto-2/sql/dml/01_ampliacion.sql` — como `hospital_admin`.
4. `proyecto-2/sql/ddl/02_vistas_reportes.sql` — como `hospital_admin`.
5. `proyecto-2/sql/dml/02_vinculos_verificados.sql` — como `hospital_admin`.
6. `proyecto-2/sql/ddl/03_extension_personal.sql` — como `hospital_admin`.
7. `proyecto-2/sql/dml/03_personal.sql` — como `hospital_admin`.
8. `proyecto-2/sql/ddl/04_integridad_jerarquia.sql` — como `hospital_admin`.
9. `proyecto-2/sql/ddl/05_vistas_estadisticas.sql` — como `hospital_admin`.
10. `proyecto-2/sql/consultas/19_normalizacion.sql` — como `hospital_admin`.
11. `proyecto-2/sql/dml/04_normalizacion.sql` — como `hospital_admin`.
12. `proyecto-2/sql/dcl/02_preparar_auditoria.sql` — ejecutar como `postgres`.
13. `proyecto-2/sql/auditoria/01_mecanismo.sql` — como `hospital_admin`.
14. `proyecto-2/sql/consultas/20_prueba_auditoria.sql` — como `hospital_admin`.

Los pasos 1 y 12 requieren `postgres` para preparar la propiedad de objetos
originales y permisos de auditoría. Para ejecutar cualquier archivo de la lista
desde la raíz del repositorio, usa `psql` con el rol indicado en cada paso. Por
ejemplo:

```bash
psql -X -v ON_ERROR_STOP=1 -U hospital_admin -d hospital_db \
  -f proyecto-2/sql/ddl/01_datos_operativos.sql
```

Para los pasos señalados como `postgres`, sustituye el usuario por `postgres`.
Ejecuta cada archivo individualmente y en el orden listado; los scripts de
migración no deben repetirse sobre una base que ya tenga aplicada la extensión.

### Ejecutar los reportes SQL

Los reportes de lectura se encuentran en `proyecto-2/sql/consultas/` y se
ejecutan individualmente con el rol `hospital_lector`, por ejemplo:

```bash
psql -U hospital_lector -d hospital_db \
  -f proyecto-2/sql/consultas/01_demanda.sql
```

Los intervalos de fecha y el médico usado por el objetivo 16 están indicados en
los archivos SQL. Se pueden abrir y ejecutar desde DBeaver o desde la terminal
con `psql`.

### Ejecutar el ORM

La API TypeORM requiere Node.js según las versiones indicadas en
`proyecto-2/orm/package.json` y acceso a PostgreSQL. Desde la raíz:

```bash
npm --prefix proyecto-2/orm ci
```

Configura las variables de conexión según `proyecto-2/orm/.env.example` y luego
inicia el servicio:

```bash
npm --prefix proyecto-2/orm run start:dev
```

Endpoints disponibles:

```text
GET http://localhost:3000/reportes/02
GET http://localhost:3000/reportes/11?desde=2026-09-01&hasta=2026-11-01
GET http://localhost:3000/reportes/13
```

El ORM es de consulta; las solicitudes no llevan body JSON. Para ejecutar la
verificación automatizada:

```bash
npm --prefix proyecto-2/orm test
```

## Respaldos del Proyecto 2

`proyecto-2/backup/hospital_db_proyecto_2.dump` es el respaldo extendido vigente.
Se puede restaurar como alternativa a ejecutar el orden de instalación SQL,
siempre que existan previamente los roles PostgreSQL correspondientes. El
respaldo anterior a la actualización de datos de muestra se conserva como
`proyecto-2/backup/hospital_db_proyecto_2_antes_datos_naturales.dump`.

No restaures el respaldo extendido sobre una instalación ya extendida; utiliza
una base vacía de prueba.
