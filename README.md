# Hospitales de Occidente — Base de datos hospitalaria

Base de datos PostgreSQL 16 que modela la operación diaria de la cadena de
Hospitales de Occidente: las cuatro unidades médicas (Consulta Externa,
Emergencias, Cirugía y Hospitalización), sus fichas (ingreso, egreso,
traslado, cita, consulta, receta, agendamiento quirúrgico, ficha clínica) y
la facturación de los servicios prestados.

## Contenido

| Carpeta | Contenido |
| --- | --- |
| `modelo/` | Modelo de datos en notación de Barker. `hospital_db.drawio` y `hospital_db.xml` son los archivos nativos del diagrama; `hospital_dbeaver.png` y `hospital_db.png` son las imágenes exportadas. |
| `sql/ddl/` | Definición del esquema (DDL), dividida por secciones en el orden en que deben ejecutarse: `01_catalogos` → `02_personas` → `03_ingresos_egresos_traslados` → `04_consulta_externa` → `05_cirugia` → `06_insumos_instrumentos_equipos` → `07_hospitalizacion` → `08_facturacion`. Incluye las llaves primarias, foráneas con su acción referencial explícita ante `DELETE` y `UPDATE`, y las restricciones `CHECK` de dominio. |
| `sql/dml/` | Inserción de datos de prueba (`hospital_dml.sql`). Todos los datos de pacientes, médicos y encargados son ficticios. |
| `sql/dcl/` | Creación de roles y asignación de privilegios (`hospital_dcl.sql`): un rol de solo lectura para auditoría y reportes, y un rol con privilegios administrativos completos sobre el esquema. |
| `backup/` | Respaldo de la base de datos `hospital_db` generado con `pg_dump` (`hospital_db_backup.sql`): contiene la estructura y los datos de prueba. |
| `documentacion/` | Documento PDF final: imagen del modelo, sentencias DDL, DML y DCL, y el diccionario de datos (una tabla por entidad con atributos, tipos, llaves, nulos, acciones referenciales y su justificación). |
