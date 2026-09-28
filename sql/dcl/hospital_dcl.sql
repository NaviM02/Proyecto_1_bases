-- Ejecutar conectado como superusuario a la base hospital_db.

-- Rol con privilegios de solo lectura (auditoría / reportes)
CREATE ROLE hospital_lector LOGIN PASSWORD 'lector2026';

GRANT CONNECT ON DATABASE hospital_db TO hospital_lector;
GRANT USAGE ON SCHEMA public TO hospital_lector;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO hospital_lector;

-- Rol con privilegios administrativos completos sobre el esquema
CREATE ROLE hospital_admin LOGIN PASSWORD 'admin2026';

GRANT ALL PRIVILEGES ON DATABASE hospital_db TO hospital_admin;
GRANT ALL PRIVILEGES ON SCHEMA public TO hospital_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO hospital_admin;
