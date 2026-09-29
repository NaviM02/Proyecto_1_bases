--
-- PostgreSQL database dump
--

\restrict CcBY0qWcp91UkRYhEf6KSACa5GSjWLbDjojUxc7JXMhdMqZAAms3wWOLtBtt9SH

-- Dumped from database version 16.15 (Debian 16.15-1.pgdg13+2)
-- Dumped by pg_dump version 16.15 (Debian 16.15-1.pgdg13+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: calificacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calificacion (
    id integer NOT NULL,
    hospital_id integer,
    personal_medico_id integer,
    encargado_id integer,
    puntuacion integer NOT NULL,
    comentario text,
    fecha timestamp without time zone NOT NULL,
    CONSTRAINT ck_calificacion_puntuacion CHECK (((puntuacion >= 1) AND (puntuacion <= 5))),
    CONSTRAINT ck_calificacion_sujeto CHECK ((((
CASE
    WHEN (hospital_id IS NOT NULL) THEN 1
    ELSE 0
END +
CASE
    WHEN (personal_medico_id IS NOT NULL) THEN 1
    ELSE 0
END) +
CASE
    WHEN (encargado_id IS NOT NULL) THEN 1
    ELSE 0
END) = 1))
);


ALTER TABLE public.calificacion OWNER TO postgres;

--
-- Name: chequeo_preanestesico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chequeo_preanestesico (
    id integer NOT NULL,
    cirugia_solicitud_id integer NOT NULL,
    asa character varying(10) NOT NULL,
    medico_clasifica_id integer NOT NULL,
    plan_anestesia text NOT NULL,
    anestesista_id integer NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    CONSTRAINT ck_chequeo_preanestesico_asa CHECK (((asa)::text = ANY ((ARRAY['I'::character varying, 'II'::character varying, 'III'::character varying, 'IV'::character varying, 'V'::character varying, 'VI'::character varying])::text[])))
);


ALTER TABLE public.chequeo_preanestesico OWNER TO postgres;

--
-- Name: chequeo_quirurgico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chequeo_quirurgico (
    id integer NOT NULL,
    cirugia_solicitud_id integer NOT NULL,
    etapa character varying(30) NOT NULL,
    aspecto character varying(150) NOT NULL,
    resultado character varying(30) NOT NULL,
    observaciones text,
    fecha_hora timestamp without time zone NOT NULL,
    registrado_por_id integer,
    CONSTRAINT ck_chequeo_quirurgico_etapa CHECK (((etapa)::text = ANY ((ARRAY['Planificación'::character varying, 'Entrada'::character varying, 'Quirófano'::character varying, 'Pausa quirúrgica'::character varying, 'Salida quirúrgica'::character varying, 'Postoperatorio'::character varying, 'Traslado seguro'::character varying])::text[]))),
    CONSTRAINT ck_chequeo_quirurgico_resultado CHECK (((resultado)::text = ANY ((ARRAY['Éxito'::character varying, 'Fallo'::character varying, 'Aceptable'::character varying, 'Medianamente aceptable'::character varying, 'No aceptable'::character varying])::text[])))
);


ALTER TABLE public.chequeo_quirurgico OWNER TO postgres;

--
-- Name: cirugia_equipo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cirugia_equipo (
    cirugia_solicitud_id integer NOT NULL,
    equipo_id integer NOT NULL,
    cantidad integer NOT NULL,
    CONSTRAINT ck_cirugia_equipo_cantidad CHECK ((cantidad > 0))
);


ALTER TABLE public.cirugia_equipo OWNER TO postgres;

--
-- Name: cirugia_etapa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cirugia_etapa (
    id integer NOT NULL,
    cirugia_solicitud_id integer NOT NULL,
    etapa character varying(20) NOT NULL,
    fecha_hora_inicio timestamp without time zone,
    fecha_hora_fin timestamp without time zone,
    enfermero_responsable_id integer,
    observaciones text,
    CONSTRAINT ck_cirugia_etapa_fechas CHECK (((fecha_hora_fin IS NULL) OR (fecha_hora_inicio IS NULL) OR (fecha_hora_fin >= fecha_hora_inicio))),
    CONSTRAINT ck_cirugia_etapa_tipo CHECK (((etapa)::text = ANY ((ARRAY['Preoperatorio'::character varying, 'Intraoperatorio'::character varying, 'Postoperatorio'::character varying])::text[])))
);


ALTER TABLE public.cirugia_etapa OWNER TO postgres;

--
-- Name: cirugia_instrumento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cirugia_instrumento (
    cirugia_solicitud_id integer NOT NULL,
    instrumento_id integer NOT NULL,
    cantidad integer NOT NULL,
    CONSTRAINT ck_cirugia_instrumento_cantidad CHECK ((cantidad > 0))
);


ALTER TABLE public.cirugia_instrumento OWNER TO postgres;

--
-- Name: cirugia_insumo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cirugia_insumo (
    cirugia_solicitud_id integer NOT NULL,
    insumo_id integer NOT NULL,
    cantidad numeric(12,2) NOT NULL,
    CONSTRAINT ck_cirugia_insumo_cantidad CHECK ((cantidad > (0)::numeric))
);


ALTER TABLE public.cirugia_insumo OWNER TO postgres;

--
-- Name: cirugia_solicitud; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cirugia_solicitud (
    id integer NOT NULL,
    paciente_id integer NOT NULL,
    hospital_id integer NOT NULL,
    cirujano_id integer NOT NULL,
    tipo_procedimiento text NOT NULL,
    caracter character varying(12) NOT NULL,
    tiempo_estimado_minutos integer NOT NULL,
    tipo_anestesia character varying(100) NOT NULL,
    requerimientos text,
    fecha_hora_solicitud timestamp without time zone NOT NULL,
    estado character varying(20) DEFAULT 'Pendiente'::character varying NOT NULL,
    razon_rechazo text,
    fecha_hora_aprobacion timestamp without time zone,
    fecha_hora_programada timestamp without time zone,
    quirofano_id integer,
    CONSTRAINT ck_cirugia_solicitud_caracter CHECK (((caracter)::text = ANY ((ARRAY['Urgente'::character varying, 'Programado'::character varying])::text[]))),
    CONSTRAINT ck_cirugia_solicitud_estado CHECK (((estado)::text = ANY ((ARRAY['Pendiente'::character varying, 'Aprobada'::character varying, 'Rechazada'::character varying, 'Programada'::character varying, 'Realizada'::character varying, 'Cancelada'::character varying])::text[]))),
    CONSTRAINT ck_cirugia_solicitud_rechazo CHECK (((((estado)::text = 'Rechazada'::text) AND (razon_rechazo IS NOT NULL)) OR ((estado)::text <> 'Rechazada'::text))),
    CONSTRAINT ck_cirugia_solicitud_tiempo CHECK ((tiempo_estimado_minutos > 0))
);


ALTER TABLE public.cirugia_solicitud OWNER TO postgres;

--
-- Name: cita; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cita (
    id integer NOT NULL,
    paciente_id integer NOT NULL,
    hospital_id integer NOT NULL,
    clinica_id integer NOT NULL,
    medico_id integer NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    costo numeric(12,2) NOT NULL,
    tipo_cita character varying(20) NOT NULL,
    estado character varying(20) DEFAULT 'Programada'::character varying NOT NULL,
    fecha_cancelacion timestamp without time zone,
    motivo_cancelacion text,
    CONSTRAINT ck_cita_cancelacion CHECK (((((estado)::text = 'Cancelada'::text) AND (fecha_cancelacion IS NOT NULL)) OR ((estado)::text <> 'Cancelada'::text))),
    CONSTRAINT ck_cita_costo CHECK ((costo >= (0)::numeric)),
    CONSTRAINT ck_cita_estado CHECK (((estado)::text = ANY ((ARRAY['Programada'::character varying, 'Realizada'::character varying, 'Reprogramada'::character varying, 'Cancelada'::character varying])::text[]))),
    CONSTRAINT ck_cita_tipo CHECK (((tipo_cita)::text = ANY ((ARRAY['Primera consulta'::character varying, 'Reconsulta'::character varying, 'Referido'::character varying])::text[])))
);


ALTER TABLE public.cita OWNER TO postgres;

--
-- Name: clinica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clinica (
    id integer NOT NULL,
    hospital_id integer NOT NULL,
    unidad_medica_id integer NOT NULL,
    numero character varying(30) NOT NULL,
    descripcion character varying(150)
);


ALTER TABLE public.clinica OWNER TO postgres;

--
-- Name: consentimiento_informado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consentimiento_informado (
    id integer NOT NULL,
    cirugia_solicitud_id integer NOT NULL,
    procedimiento text NOT NULL,
    objetivo text NOT NULL,
    caracteristicas text NOT NULL,
    riesgos text NOT NULL,
    medico_id integer NOT NULL,
    paciente_o_representante character varying(200) NOT NULL,
    fecha_obtencion date NOT NULL,
    firmado boolean DEFAULT false NOT NULL
);


ALTER TABLE public.consentimiento_informado OWNER TO postgres;

--
-- Name: consulta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consulta (
    id integer NOT NULL,
    cita_id integer NOT NULL,
    paciente_id integer NOT NULL,
    medico_id integer NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    diagnostico text NOT NULL,
    otros_datos text,
    observaciones text
);


ALTER TABLE public.consulta OWNER TO postgres;

--
-- Name: egreso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.egreso (
    id integer NOT NULL,
    ingreso_id integer NOT NULL,
    paciente_id integer NOT NULL,
    hospital_id integer NOT NULL,
    unidad_medica_id integer NOT NULL,
    servicio_medico_id integer NOT NULL,
    medico_asignado_id integer NOT NULL,
    recurso_asistencial_id integer,
    fecha_hora timestamp without time zone NOT NULL,
    diagnostico_principal text NOT NULL,
    diagnosticos_secundarios text,
    motivo text NOT NULL,
    codigo_egreso character varying(20) NOT NULL,
    sin_consentimiento_medico boolean DEFAULT false NOT NULL,
    motivo_sin_consentimiento text,
    dias_hospitalizado integer,
    operaciones_intervenciones text,
    codigo_traslado character varying(30),
    referido_a text,
    CONSTRAINT ck_egreso_codigo CHECK (((codigo_egreso)::text = ANY ((ARRAY['Vivo'::character varying, 'Muerto'::character varying, 'Embarazo'::character varying, 'Parto'::character varying])::text[]))),
    CONSTRAINT ck_egreso_dias CHECK (((dias_hospitalizado IS NULL) OR (dias_hospitalizado >= 0))),
    CONSTRAINT ck_egreso_motivo_consentimiento CHECK ((((sin_consentimiento_medico = true) AND (motivo_sin_consentimiento IS NOT NULL)) OR (sin_consentimiento_medico = false)))
);


ALTER TABLE public.egreso OWNER TO postgres;

--
-- Name: encargado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encargado (
    id integer NOT NULL,
    nombres character varying(100) NOT NULL,
    apellidos character varying(100) NOT NULL,
    parentesco character varying(80) NOT NULL,
    dpi character varying(20) NOT NULL,
    telefono character varying(20),
    municipio character varying(100),
    departamento character varying(100),
    area character varying(10) NOT NULL,
    CONSTRAINT ck_encargado_area CHECK (((area)::text = ANY ((ARRAY['Urbana'::character varying, 'Rural'::character varying])::text[])))
);


ALTER TABLE public.encargado OWNER TO postgres;

--
-- Name: equipo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipo (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion character varying(250),
    tipo character varying(20) NOT NULL,
    funcion character varying(30) NOT NULL,
    CONSTRAINT ck_equipo_funcion CHECK (((funcion)::text = ANY ((ARRAY['Exploración'::character varying, 'Diagnóstico'::character varying, 'Tratamiento'::character varying, 'Rehabilitación'::character varying, 'Otro'::character varying])::text[]))),
    CONSTRAINT ck_equipo_tipo CHECK (((tipo)::text = ANY ((ARRAY['Médico'::character varying, 'Quirúrgico'::character varying, 'Otro'::character varying])::text[])))
);


ALTER TABLE public.equipo OWNER TO postgres;

--
-- Name: especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especialidad (
    id integer NOT NULL,
    nombre character varying(120) NOT NULL,
    descripcion character varying(250)
);


ALTER TABLE public.especialidad OWNER TO postgres;

--
-- Name: examen_laboratorio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.examen_laboratorio (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    tipo character varying(30) NOT NULL,
    descripcion character varying(250),
    CONSTRAINT ck_examen_laboratorio_tipo CHECK (((tipo)::text = ANY ((ARRAY['Sangre'::character varying, 'Orina'::character varying, 'Heces'::character varying, 'Imagenología'::character varying, 'Otro'::character varying])::text[])))
);


ALTER TABLE public.examen_laboratorio OWNER TO postgres;

--
-- Name: exploracion_fisica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exploracion_fisica (
    id integer NOT NULL,
    historia_clinica_id integer NOT NULL,
    seccion character varying(40) NOT NULL,
    hallazgo text NOT NULL,
    CONSTRAINT ck_exploracion_fisica_seccion CHECK (((seccion)::text = ANY ((ARRAY['Signos vitales'::character varying, 'Exploración general'::character varying, 'Cabeza'::character varying, 'Cuello'::character varying, 'Tórax'::character varying, 'Abdomen'::character varying, 'Extremidades'::character varying, 'Columna vertebral'::character varying, 'Cavidad bucal'::character varying, 'Cavidad vaginal'::character varying, 'Cavidad rectal'::character varying, 'Conducto auditivo externo'::character varying])::text[])))
);


ALTER TABLE public.exploracion_fisica OWNER TO postgres;

--
-- Name: factura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.factura (
    id integer NOT NULL,
    paciente_id integer NOT NULL,
    hospital_id integer NOT NULL,
    fecha_emision timestamp without time zone NOT NULL,
    descripcion text NOT NULL,
    total numeric(12,2) NOT NULL,
    estado character varying(20) DEFAULT 'Pendiente'::character varying NOT NULL,
    CONSTRAINT ck_factura_estado CHECK (((estado)::text = ANY ((ARRAY['Pendiente'::character varying, 'Parcial'::character varying, 'Pagada'::character varying, 'Anulada'::character varying])::text[]))),
    CONSTRAINT ck_factura_total CHECK ((total >= (0)::numeric))
);


ALTER TABLE public.factura OWNER TO postgres;

--
-- Name: factura_detalle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.factura_detalle (
    id integer NOT NULL,
    factura_id integer NOT NULL,
    servicio_medico_id integer,
    descripcion character varying(250) NOT NULL,
    cantidad numeric(12,2) NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    CONSTRAINT ck_factura_detalle_cantidad CHECK ((cantidad > (0)::numeric)),
    CONSTRAINT ck_factura_detalle_precio CHECK ((precio_unitario >= (0)::numeric))
);


ALTER TABLE public.factura_detalle OWNER TO postgres;

--
-- Name: historia_clinica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historia_clinica (
    id integer NOT NULL,
    paciente_id integer NOT NULL,
    cirugia_solicitud_id integer,
    tipo_interrogatorio character varying(10) NOT NULL,
    religion character varying(80),
    ocupacion character varying(120),
    lugar_nacimiento character varying(150),
    lugar_residencia character varying(150),
    antecedentes_heredofamiliares text,
    antecedentes_personales_no_patologicos text,
    antecedentes_patologicos text,
    padecimiento_actual text NOT NULL,
    interrogatorio_aparatos_sistemas text,
    sintomas_generales_terapeutica text,
    estudios_previos text,
    fecha timestamp without time zone NOT NULL,
    CONSTRAINT ck_historia_clinica_interrogatorio CHECK (((tipo_interrogatorio)::text = ANY ((ARRAY['Directo'::character varying, 'Indirecto'::character varying])::text[])))
);


ALTER TABLE public.historia_clinica OWNER TO postgres;

--
-- Name: hospital; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hospital (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    direccion character varying(250) NOT NULL,
    telefono character varying(20)
);


ALTER TABLE public.hospital OWNER TO postgres;

--
-- Name: hospital_unidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hospital_unidad (
    hospital_id integer NOT NULL,
    unidad_medica_id integer NOT NULL
);


ALTER TABLE public.hospital_unidad OWNER TO postgres;

--
-- Name: hospitalizacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hospitalizacion (
    id integer NOT NULL,
    paciente_id integer NOT NULL,
    hospital_id integer NOT NULL,
    ingreso_id integer NOT NULL,
    unidad_medica_id integer NOT NULL,
    servicio_medico_id integer NOT NULL,
    medico_encargado_id integer NOT NULL,
    cama_id integer,
    fecha_hora_ingreso timestamp without time zone NOT NULL,
    fecha_hora_egreso timestamp without time zone,
    costo_por_dia numeric(12,2) NOT NULL,
    CONSTRAINT ck_hospitalizacion_costo_dia CHECK ((costo_por_dia >= (0)::numeric)),
    CONSTRAINT ck_hospitalizacion_fechas CHECK (((fecha_hora_egreso IS NULL) OR (fecha_hora_egreso >= fecha_hora_ingreso)))
);


ALTER TABLE public.hospitalizacion OWNER TO postgres;

--
-- Name: ingreso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingreso (
    id integer NOT NULL,
    paciente_id integer NOT NULL,
    hospital_id integer NOT NULL,
    unidad_medica_id integer NOT NULL,
    servicio_medico_id integer NOT NULL,
    medico_encargado_id integer NOT NULL,
    recurso_asistencial_id integer,
    motivo text NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    diagnostico_presuntivo text NOT NULL
);


ALTER TABLE public.ingreso OWNER TO postgres;

--
-- Name: instrumento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrumento (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion character varying(250),
    tipo character varying(20) NOT NULL,
    funcion character varying(30) NOT NULL,
    CONSTRAINT ck_instrumento_funcion CHECK (((funcion)::text = ANY ((ARRAY['Corte'::character varying, 'Contenido'::character varying, 'Hemostática'::character varying, 'Retractor'::character varying, 'Accesorio'::character varying, 'Implante'::character varying, 'Otro'::character varying])::text[]))),
    CONSTRAINT ck_instrumento_tipo CHECK (((tipo)::text = ANY ((ARRAY['Médico'::character varying, 'Quirúrgico'::character varying, 'Otro'::character varying])::text[])))
);


ALTER TABLE public.instrumento OWNER TO postgres;

--
-- Name: insumo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insumo (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion character varying(250),
    material character varying(100),
    tipo character varying(20) NOT NULL,
    CONSTRAINT ck_insumo_tipo CHECK (((tipo)::text = ANY ((ARRAY['Médico'::character varying, 'Quirúrgico'::character varying, 'Otro'::character varying])::text[])))
);


ALTER TABLE public.insumo OWNER TO postgres;

--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicamento (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion character varying(250)
);


ALTER TABLE public.medicamento OWNER TO postgres;

--
-- Name: orden_laboratorio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_laboratorio (
    id integer NOT NULL,
    paciente_id integer NOT NULL,
    medico_solicita_id integer NOT NULL,
    consulta_id integer,
    cirugia_solicitud_id integer,
    fecha_hora_solicitud timestamp without time zone NOT NULL,
    estado character varying(20) DEFAULT 'Solicitada'::character varying NOT NULL,
    observaciones text,
    CONSTRAINT ck_orden_laboratorio_estado CHECK (((estado)::text = ANY ((ARRAY['Solicitada'::character varying, 'En proceso'::character varying, 'Completada'::character varying, 'Cancelada'::character varying])::text[]))),
    CONSTRAINT ck_orden_laboratorio_origen CHECK (((consulta_id IS NOT NULL) OR (cirugia_solicitud_id IS NOT NULL)))
);


ALTER TABLE public.orden_laboratorio OWNER TO postgres;

--
-- Name: orden_laboratorio_examen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_laboratorio_examen (
    orden_laboratorio_id integer NOT NULL,
    examen_laboratorio_id integer NOT NULL,
    resultado text,
    fecha_resultado timestamp without time zone
);


ALTER TABLE public.orden_laboratorio_examen OWNER TO postgres;

--
-- Name: paciente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paciente (
    id integer NOT NULL,
    expediente character varying(50) NOT NULL,
    nombres character varying(100) NOT NULL,
    apellidos character varying(100) NOT NULL,
    dpi character varying(20) NOT NULL,
    fecha_nacimiento date NOT NULL,
    sexo character varying(10) NOT NULL,
    estado_civil character varying(30),
    telefono character varying(20),
    seguro_social character varying(50),
    municipio character varying(100),
    departamento character varying(100),
    area character varying(10) NOT NULL,
    CONSTRAINT ck_paciente_area CHECK (((area)::text = ANY ((ARRAY['Urbana'::character varying, 'Rural'::character varying])::text[]))),
    CONSTRAINT ck_paciente_fecha_nacimiento CHECK (((fecha_nacimiento >= '1900-01-01'::date) AND (fecha_nacimiento <= CURRENT_DATE))),
    CONSTRAINT ck_paciente_sexo CHECK (((sexo)::text = ANY ((ARRAY['Masculino'::character varying, 'Femenino'::character varying])::text[])))
);


ALTER TABLE public.paciente OWNER TO postgres;

--
-- Name: paciente_encargado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paciente_encargado (
    paciente_id integer NOT NULL,
    encargado_id integer NOT NULL,
    principal boolean DEFAULT true NOT NULL
);


ALTER TABLE public.paciente_encargado OWNER TO postgres;

--
-- Name: pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pago (
    id integer NOT NULL,
    factura_id integer NOT NULL,
    numero_pago integer NOT NULL,
    fecha_pago timestamp without time zone NOT NULL,
    monto numeric(12,2) NOT NULL,
    CONSTRAINT ck_pago_monto CHECK ((monto > (0)::numeric)),
    CONSTRAINT ck_pago_numero CHECK (((numero_pago >= 1) AND (numero_pago <= 12)))
);


ALTER TABLE public.pago OWNER TO postgres;

--
-- Name: personal_especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_especialidad (
    personal_medico_id integer NOT NULL,
    especialidad_id integer NOT NULL,
    principal boolean DEFAULT false NOT NULL
);


ALTER TABLE public.personal_especialidad OWNER TO postgres;

--
-- Name: personal_medico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_medico (
    id integer NOT NULL,
    hospital_id integer NOT NULL,
    nombres character varying(100) NOT NULL,
    apellidos character varying(100) NOT NULL,
    dpi character varying(20) NOT NULL,
    telefono character varying(20),
    municipio character varying(100),
    departamento character varying(100),
    area character varying(10),
    tipo_personal character varying(30) NOT NULL,
    CONSTRAINT ck_personal_medico_area CHECK (((area IS NULL) OR ((area)::text = ANY ((ARRAY['Urbana'::character varying, 'Rural'::character varying])::text[])))),
    CONSTRAINT ck_personal_medico_tipo CHECK (((tipo_personal)::text = ANY ((ARRAY['Médico'::character varying, 'Enfermero'::character varying, 'Anestesista'::character varying, 'Practicante Médico'::character varying, 'Practicante Enfermería'::character varying, 'Otro'::character varying])::text[])))
);


ALTER TABLE public.personal_medico OWNER TO postgres;

--
-- Name: personal_unidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_unidad (
    personal_medico_id integer NOT NULL,
    hospital_id integer NOT NULL,
    unidad_medica_id integer NOT NULL
);


ALTER TABLE public.personal_unidad OWNER TO postgres;

--
-- Name: receta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receta (
    id integer NOT NULL,
    consulta_id integer NOT NULL,
    paciente_id integer NOT NULL,
    medico_id integer NOT NULL,
    fecha date NOT NULL,
    proxima_cita date,
    clinica_id integer
);


ALTER TABLE public.receta OWNER TO postgres;

--
-- Name: receta_medicamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receta_medicamento (
    receta_id integer NOT NULL,
    medicamento_id integer NOT NULL,
    dosis character varying(100) NOT NULL,
    duracion character varying(100) NOT NULL
);


ALTER TABLE public.receta_medicamento OWNER TO postgres;

--
-- Name: recurso_asistencial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recurso_asistencial (
    id integer NOT NULL,
    hospital_id integer NOT NULL,
    unidad_medica_id integer NOT NULL,
    tipo character varying(30) NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(250),
    disponible boolean DEFAULT true NOT NULL,
    CONSTRAINT ck_recurso_asistencial_tipo CHECK (((tipo)::text = ANY ((ARRAY['Camilla'::character varying, 'Quirófano'::character varying, 'Cama'::character varying])::text[])))
);


ALTER TABLE public.recurso_asistencial OWNER TO postgres;

--
-- Name: servicio_medico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicio_medico (
    id integer NOT NULL,
    unidad_medica_id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion character varying(250),
    costo_base numeric(12,2) NOT NULL,
    CONSTRAINT ck_servicio_medico_costo CHECK ((costo_base >= (0)::numeric))
);


ALTER TABLE public.servicio_medico OWNER TO postgres;

--
-- Name: traslado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traslado (
    id integer NOT NULL,
    paciente_id integer NOT NULL,
    medico_indica_id integer NOT NULL,
    hospital_origen_id integer NOT NULL,
    unidad_origen_id integer NOT NULL,
    servicio_origen_id integer,
    hospital_destino_id integer NOT NULL,
    unidad_destino_id integer NOT NULL,
    servicio_destino_id integer,
    fecha_hora timestamp without time zone NOT NULL,
    tipo_traslado character varying(10) NOT NULL,
    observaciones text,
    CONSTRAINT ck_traslado_tipo CHECK (((tipo_traslado)::text = ANY ((ARRAY['Interno'::character varying, 'Externo'::character varying])::text[])))
);


ALTER TABLE public.traslado OWNER TO postgres;

--
-- Name: unidad_medica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_medica (
    id integer NOT NULL,
    nombre character varying(80) NOT NULL,
    CONSTRAINT ck_unidad_medica_nombre CHECK (((nombre)::text = ANY ((ARRAY['Consulta Externa'::character varying, 'Emergencias'::character varying, 'Cirugía'::character varying, 'Hospitalización'::character varying])::text[])))
);


ALTER TABLE public.unidad_medica OWNER TO postgres;

--
-- Data for Name: calificacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calificacion (id, hospital_id, personal_medico_id, encargado_id, puntuacion, comentario, fecha) FROM stdin;
1	1	\N	\N	5	Excelente atención en el hospital.	2026-09-15 10:00:00
2	\N	1	\N	4	Médico claro y atento con el paciente.	2026-09-15 10:30:00
3	\N	4	\N	5	Enfermera muy dedicada durante la estadía.	2026-09-17 12:30:00
4	\N	\N	1	4	Trato adecuado como encargado del paciente.	2026-09-17 13:00:00
\.


--
-- Data for Name: chequeo_preanestesico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chequeo_preanestesico (id, cirugia_solicitud_id, asa, medico_clasifica_id, plan_anestesia, anestesista_id, fecha_hora) FROM stdin;
1	1	II	3	Anestesia general con monitorización continua.	5	2026-09-17 15:00:00
\.


--
-- Data for Name: chequeo_quirurgico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chequeo_quirurgico (id, cirugia_solicitud_id, etapa, aspecto, resultado, observaciones, fecha_hora, registrado_por_id) FROM stdin;
1	1	Entrada	Confirmación del paciente	Éxito	Identificación confirmada.	2026-09-18 08:50:00	4
2	1	Pausa quirúrgica	Buenas condiciones de esterilidad	Aceptable	Condiciones verificadas antes de la incisión.	2026-09-18 09:05:00	4
\.


--
-- Data for Name: cirugia_equipo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cirugia_equipo (cirugia_solicitud_id, equipo_id, cantidad) FROM stdin;
1	2	1
1	3	1
\.


--
-- Data for Name: cirugia_etapa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cirugia_etapa (id, cirugia_solicitud_id, etapa, fecha_hora_inicio, fecha_hora_fin, enfermero_responsable_id, observaciones) FROM stdin;
1	1	Preoperatorio	2026-09-18 08:00:00	2026-09-18 08:45:00	4	Paciente preparado para el procedimiento.
2	1	Intraoperatorio	2026-09-18 09:00:00	2026-09-18 10:30:00	4	Procedimiento realizado sin complicaciones.
3	1	Postoperatorio	2026-09-18 10:45:00	2026-09-18 12:00:00	4	Paciente estable durante la recuperación.
\.


--
-- Data for Name: cirugia_instrumento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cirugia_instrumento (cirugia_solicitud_id, instrumento_id, cantidad) FROM stdin;
1	1	1
1	2	2
\.


--
-- Data for Name: cirugia_insumo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cirugia_insumo (cirugia_solicitud_id, insumo_id, cantidad) FROM stdin;
1	2	10.00
1	4	1.00
\.


--
-- Data for Name: cirugia_solicitud; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cirugia_solicitud (id, paciente_id, hospital_id, cirujano_id, tipo_procedimiento, caracter, tiempo_estimado_minutos, tipo_anestesia, requerimientos, fecha_hora_solicitud, estado, razon_rechazo, fecha_hora_aprobacion, fecha_hora_programada, quirofano_id) FROM stdin;
1	2	1	3	Apendicectomía laparoscópica	Programado	90	Anestesia general	Equipo laparoscópico e instrumental quirúrgico.	2026-09-16 08:00:00	Programada	\N	2026-09-16 12:00:00	2026-09-18 09:00:00	3
\.


--
-- Data for Name: cita; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cita (id, paciente_id, hospital_id, clinica_id, medico_id, fecha_hora, costo, tipo_cita, estado, fecha_cancelacion, motivo_cancelacion) FROM stdin;
1	1	1	1	1	2026-09-14 08:00:00	250.00	Primera consulta	Realizada	\N	\N
2	2	1	2	2	2026-09-15 09:00:00	400.00	Primera consulta	Programada	\N	\N
3	3	1	1	1	2026-09-16 10:00:00	300.00	Reconsulta	Cancelada	2026-09-15 15:00:00	El paciente notificó que no podía asistir.
4	4	1	2	2	2026-09-17 11:00:00	320.00	Referido	Programada	\N	\N
\.


--
-- Data for Name: clinica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clinica (id, hospital_id, unidad_medica_id, numero, descripcion) FROM stdin;
1	1	1	CE-01	Consultorio de medicina general
2	1	1	CE-02	Consultorio de especialidad
3	2	1	CE-01	Consultorio de medicina general
\.


--
-- Data for Name: consentimiento_informado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consentimiento_informado (id, cirugia_solicitud_id, procedimiento, objetivo, caracteristicas, riesgos, medico_id, paciente_o_representante, fecha_obtencion, firmado) FROM stdin;
1	1	Apendicectomía laparoscópica	Eliminar el apéndice inflamado.	Procedimiento realizado mediante técnica laparoscópica.	Sangrado, infección y complicaciones relacionadas con la anestesia.	3	Ana García Pérez	2026-09-16	t
\.


--
-- Data for Name: consulta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consulta (id, cita_id, paciente_id, medico_id, fecha_hora, diagnostico, otros_datos, observaciones) FROM stdin;
1	1	1	1	2026-09-14 08:35:00	Hipertensión arterial leve.	Presión arterial elevada durante la evaluación.	Se recomienda seguimiento y control de presión.
\.


--
-- Data for Name: egreso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.egreso (id, ingreso_id, paciente_id, hospital_id, unidad_medica_id, servicio_medico_id, medico_asignado_id, recurso_asistencial_id, fecha_hora, diagnostico_principal, diagnosticos_secundarios, motivo, codigo_egreso, sin_consentimiento_medico, motivo_sin_consentimiento, dias_hospitalizado, operaciones_intervenciones, codigo_traslado, referido_a) FROM stdin;
1	1	2	1	4	5	1	5	2026-09-17 11:00:00	Apendicitis aguda.	Dolor abdominal controlado.	Finalización de tratamiento.	Vivo	f	\N	3	\N	\N	\N
\.


--
-- Data for Name: encargado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encargado (id, nombres, apellidos, parentesco, dpi, telefono, municipio, departamento, area) FROM stdin;
1	Roberto	Méndez García	Padre	0000000000011	5552-0001	Quetzaltenango	Quetzaltenango	Urbana
2	Laura	Soto Castillo	Madre	0000000000012	5552-0002	La Esperanza	Quetzaltenango	Urbana
3	Jorge	Hernández López	Hermano	0000000000013	5552-0003	Salcajá	Quetzaltenango	Rural
\.


--
-- Data for Name: equipo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipo (id, nombre, descripcion, tipo, funcion) FROM stdin;
1	Monitor de signos vitales	Monitorización de signos vitales.	Médico	Diagnóstico
2	Máquina de anestesia	Equipo para administración de anestesia.	Quirúrgico	Tratamiento
3	Torre laparoscópica	Equipo para procedimientos laparoscópicos.	Quirúrgico	Diagnóstico
\.


--
-- Data for Name: especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especialidad (id, nombre, descripcion) FROM stdin;
1	Cardiología	Atención del aparato cardiovascular.
2	Dermatología	Atención de la piel.
3	Fisioterapia	Rehabilitación física.
4	Ginecología Oncológica	Cáncer del aparato reproductor femenino.
5	Hematología	Enfermedades de la sangre.
6	Medicina Física y Rehabilitación	Rehabilitación integral.
7	Medicina General	Atención médica general.
8	Nutrición y Dietética	Atención nutricional.
9	Odontología General	Atención dental.
10	Oftalmología	Atención de los ojos.
11	Psicología	Atención psicológica.
12	Pediatría	Atención de niñas y niños.
13	Urología	Atención del aparato urinario.
14	Terapia del Lenguaje	Atención del lenguaje.
15	Cirugía General	Cirugía de adultos.
16	Cirugía Neurológica	Cirugía del sistema nervioso.
17	Cirugía Ortopédica	Cirugía de huesos y articulaciones.
18	Cirugía Pediátrica	Cirugía de niñas y niños.
\.


--
-- Data for Name: examen_laboratorio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.examen_laboratorio (id, nombre, tipo, descripcion) FROM stdin;
1	Hemograma completo	Sangre	Conteo de células sanguíneas.
2	Glucosa en ayunas	Sangre	Nivel de glucosa en sangre.
3	Perfil lipídico	Sangre	Colesterol y triglicéridos.
4	Examen general de orina	Orina	Análisis físico y químico de la orina.
5	Radiografía de tórax	Imagenología	Estudio de imagen del tórax.
\.


--
-- Data for Name: exploracion_fisica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exploracion_fisica (id, historia_clinica_id, seccion, hallazgo) FROM stdin;
1	1	Signos vitales	Temperatura 38.1 °C, frecuencia cardíaca 96 lpm.
2	1	Exploración general	Paciente consciente, orientada, en regular estado general.
3	1	Abdomen	Dolor a la palpación profunda en fosa ilíaca derecha.
4	1	Extremidades	Sin edema ni alteraciones vasculares.
\.


--
-- Data for Name: factura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.factura (id, paciente_id, hospital_id, fecha_emision, descripcion, total, estado) FROM stdin;
1	2	1	2026-09-17 12:00:00	Atención de emergencia y hospitalización.	3150.00	Parcial
2	2	1	2026-09-18 13:00:00	Procedimiento quirúrgico.	5000.00	Pendiente
\.


--
-- Data for Name: factura_detalle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.factura_detalle (id, factura_id, servicio_medico_id, descripcion, cantidad, precio_unitario, subtotal) FROM stdin;
1	1	3	Atención de emergencia	1.00	600.00	600.00
2	1	5	Hospitalización	3.00	850.00	2550.00
3	2	4	Procedimiento quirúrgico	1.00	5000.00	5000.00
\.


--
-- Data for Name: historia_clinica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historia_clinica (id, paciente_id, cirugia_solicitud_id, tipo_interrogatorio, religion, ocupacion, lugar_nacimiento, lugar_residencia, antecedentes_heredofamiliares, antecedentes_personales_no_patologicos, antecedentes_patologicos, padecimiento_actual, interrogatorio_aparatos_sistemas, sintomas_generales_terapeutica, estudios_previos, fecha) FROM stdin;
1	2	1	Directo	Católica	Comerciante	Quetzaltenango	Salcajá	Madre con hipertensión arterial.	No fuma ni consume bebidas alcohólicas.	Apendicitis aguda.	Dolor abdominal en fosa ilíaca derecha de 24 horas de evolución.	Dolor abdominal localizado, sin irradiación.	Náuseas y febrícula; se administró analgésico.	Hemograma previo sin datos relevantes.	2026-09-16 08:30:00
\.


--
-- Data for Name: hospital; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hospital (id, nombre, direccion, telefono) FROM stdin;
1	Hospital de Occidente Central	Zona 1, Quetzaltenango	5550-1001
2	Hospital de Occidente Norte	Zona 3, Quetzaltenango	5550-1002
\.


--
-- Data for Name: hospital_unidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hospital_unidad (hospital_id, unidad_medica_id) FROM stdin;
1	1
1	2
1	3
1	4
2	1
2	2
2	3
2	4
\.


--
-- Data for Name: hospitalizacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hospitalizacion (id, paciente_id, hospital_id, ingreso_id, unidad_medica_id, servicio_medico_id, medico_encargado_id, cama_id, fecha_hora_ingreso, fecha_hora_egreso, costo_por_dia) FROM stdin;
1	2	1	1	4	5	1	5	2026-09-14 21:00:00	2026-09-17 11:00:00	850.00
\.


--
-- Data for Name: ingreso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ingreso (id, paciente_id, hospital_id, unidad_medica_id, servicio_medico_id, medico_encargado_id, recurso_asistencial_id, motivo, fecha_hora, diagnostico_presuntivo) FROM stdin;
1	2	1	2	3	1	1	Dolor abdominal intenso.	2026-09-14 18:30:00	Posible apendicitis.
2	3	1	2	3	3	2	Dificultad respiratoria.	2026-09-15 20:00:00	Crisis asmática.
\.


--
-- Data for Name: instrumento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrumento (id, nombre, descripcion, tipo, funcion) FROM stdin;
1	Bisturí quirúrgico	Instrumento para realizar incisiones.	Quirúrgico	Corte
2	Pinza hemostática	Instrumento para control de sangrado.	Quirúrgico	Hemostática
3	Separador abdominal	Instrumento para separación de tejidos.	Quirúrgico	Retractor
\.


--
-- Data for Name: insumo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insumo (id, nombre, descripcion, material, tipo) FROM stdin;
1	Guantes quirúrgicos	Guantes estériles para procedimiento quirúrgico.	Látex	Quirúrgico
2	Gasas estériles	Gasas para limpieza y control durante procedimientos.	Algodón	Médico
3	Jeringa 10 ml	Jeringa descartable.	Plástico	Médico
4	Sutura absorbible	Material para cierre de tejidos.	Poliglactina	Quirúrgico
\.


--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicamento (id, nombre, descripcion) FROM stdin;
1	Losartán	Control de presión arterial.
2	Paracetamol	Analgésico y antipirético.
3	Omeprazol	Disminuye la producción de ácido gástrico.
\.


--
-- Data for Name: orden_laboratorio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden_laboratorio (id, paciente_id, medico_solicita_id, consulta_id, cirugia_solicitud_id, fecha_hora_solicitud, estado, observaciones) FROM stdin;
1	1	1	1	\N	2026-09-14 08:40:00	Completada	Órdenes de laboratorio para control de hipertensión.
2	2	3	\N	1	2026-09-17 15:30:00	Completada	Exámenes prequirúrgicos previos a la apendicectomía.
\.


--
-- Data for Name: orden_laboratorio_examen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden_laboratorio_examen (orden_laboratorio_id, examen_laboratorio_id, resultado, fecha_resultado) FROM stdin;
1	1	Valores dentro de los rangos normales.	2026-09-14 11:00:00
1	2	Glucosa 98 mg/dL.	2026-09-14 11:00:00
1	3	Colesterol total 185 mg/dL.	2026-09-14 11:00:00
2	1	Leucocitos elevados (14 000 /µL).	2026-09-17 18:00:00
2	4	Sin datos patológicos.	2026-09-17 18:00:00
2	5	Sin hallazgos relevantes.	2026-09-17 18:30:00
\.


--
-- Data for Name: paciente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paciente (id, expediente, nombres, apellidos, dpi, fecha_nacimiento, sexo, estado_civil, telefono, seguro_social, municipio, departamento, area) FROM stdin;
1	EXP-0001	Carlos	Méndez López	0000000000001	1990-04-15	Masculino	Soltero	5551-0001	SS-0001	Quetzaltenango	Quetzaltenango	Urbana
2	EXP-0002	Ana	García Pérez	0000000000002	1987-09-22	Femenino	Casada	5551-0002	SS-0002	Salcajá	Quetzaltenango	Rural
3	EXP-0003	Luis	Hernández Díaz	0000000000003	2004-02-10	Masculino	Soltero	5551-0003	\N	Quetzaltenango	Quetzaltenango	Urbana
4	EXP-0004	María	Ramírez Soto	0000000000004	1995-12-03	Femenino	Soltera	5551-0004	SS-0004	Totonicapán	Totonicapán	Rural
5	EXP-0005	Sofía	Castillo Ruiz	0000000000005	2014-06-18	Femenino	Soltera	5551-0005	\N	La Esperanza	Quetzaltenango	Urbana
\.


--
-- Data for Name: paciente_encargado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paciente_encargado (paciente_id, encargado_id, principal) FROM stdin;
1	1	t
5	2	t
3	3	t
\.


--
-- Data for Name: pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pago (id, factura_id, numero_pago, fecha_pago, monto) FROM stdin;
1	1	1	2026-09-17 13:00:00	1000.00
2	1	2	2026-09-18 14:00:00	1000.00
\.


--
-- Data for Name: personal_especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_especialidad (personal_medico_id, especialidad_id, principal) FROM stdin;
1	7	t
2	1	t
3	15	t
6	12	t
\.


--
-- Data for Name: personal_medico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_medico (id, hospital_id, nombres, apellidos, dpi, telefono, municipio, departamento, area, tipo_personal) FROM stdin;
1	1	Diego	Morales Pérez	0000000000101	5553-0001	Quetzaltenango	Quetzaltenango	Urbana	Médico
2	1	Elena	Vásquez López	0000000000102	5553-0002	Quetzaltenango	Quetzaltenango	Urbana	Médico
3	1	Fernando	Cifuentes Díaz	0000000000103	5553-0003	Salcajá	Quetzaltenango	Rural	Médico
4	1	Gabriela	Rodas Méndez	0000000000104	5553-0004	Quetzaltenango	Quetzaltenango	Urbana	Enfermero
5	1	Hugo	Alvarado Cruz	0000000000105	5553-0005	Quetzaltenango	Quetzaltenango	Urbana	Anestesista
6	2	Irene	Pineda Gómez	0000000000106	5553-0006	Quetzaltenango	Quetzaltenango	Urbana	Médico
\.


--
-- Data for Name: personal_unidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_unidad (personal_medico_id, hospital_id, unidad_medica_id) FROM stdin;
1	1	1
2	1	1
1	1	2
3	1	2
3	1	3
5	1	3
4	1	3
1	1	4
4	1	4
\.


--
-- Data for Name: receta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receta (id, consulta_id, paciente_id, medico_id, fecha, proxima_cita, clinica_id) FROM stdin;
1	1	1	1	2026-09-14	2026-10-14	1
\.


--
-- Data for Name: receta_medicamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receta_medicamento (receta_id, medicamento_id, dosis, duracion) FROM stdin;
1	1	50 mg cada 24 horas	30 días
\.


--
-- Data for Name: recurso_asistencial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recurso_asistencial (id, hospital_id, unidad_medica_id, tipo, nombre, descripcion, disponible) FROM stdin;
1	1	2	Camilla	CAM-01	Camilla de emergencia	t
2	1	2	Camilla	CAM-02	Camilla de emergencia	t
3	1	3	Quirófano	QX-01	Quirófano principal	t
4	1	3	Quirófano	QX-02	Quirófano secundario	t
5	1	4	Cama	CAMA-01	Cama de hospitalización	t
6	1	4	Cama	CAMA-02	Cama de hospitalización	t
\.


--
-- Data for Name: servicio_medico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servicio_medico (id, unidad_medica_id, nombre, descripcion, costo_base) FROM stdin;
1	1	Consulta de medicina general	Consulta médica general.	250.00
2	1	Consulta de especialidad	Consulta médica especializada.	400.00
3	2	Atención de emergencia	Atención médica de emergencia.	600.00
4	3	Procedimiento quirúrgico	Procedimiento quirúrgico.	5000.00
5	4	Hospitalización	Servicio de hospitalización por día.	850.00
\.


--
-- Data for Name: traslado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.traslado (id, paciente_id, medico_indica_id, hospital_origen_id, unidad_origen_id, servicio_origen_id, hospital_destino_id, unidad_destino_id, servicio_destino_id, fecha_hora, tipo_traslado, observaciones) FROM stdin;
1	2	1	1	2	3	1	4	5	2026-09-14 21:00:00	Interno	Traslado de emergencias a hospitalización para continuar tratamiento.
\.


--
-- Data for Name: unidad_medica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_medica (id, nombre) FROM stdin;
1	Consulta Externa
2	Emergencias
3	Cirugía
4	Hospitalización
\.


--
-- Name: calificacion calificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calificacion
    ADD CONSTRAINT calificacion_pkey PRIMARY KEY (id);


--
-- Name: chequeo_preanestesico chequeo_preanestesico_cirugia_solicitud_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chequeo_preanestesico
    ADD CONSTRAINT chequeo_preanestesico_cirugia_solicitud_id_key UNIQUE (cirugia_solicitud_id);


--
-- Name: chequeo_preanestesico chequeo_preanestesico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chequeo_preanestesico
    ADD CONSTRAINT chequeo_preanestesico_pkey PRIMARY KEY (id);


--
-- Name: chequeo_quirurgico chequeo_quirurgico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chequeo_quirurgico
    ADD CONSTRAINT chequeo_quirurgico_pkey PRIMARY KEY (id);


--
-- Name: cirugia_equipo cirugia_equipo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_equipo
    ADD CONSTRAINT cirugia_equipo_pkey PRIMARY KEY (cirugia_solicitud_id, equipo_id);


--
-- Name: cirugia_etapa cirugia_etapa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_etapa
    ADD CONSTRAINT cirugia_etapa_pkey PRIMARY KEY (id);


--
-- Name: cirugia_instrumento cirugia_instrumento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_instrumento
    ADD CONSTRAINT cirugia_instrumento_pkey PRIMARY KEY (cirugia_solicitud_id, instrumento_id);


--
-- Name: cirugia_insumo cirugia_insumo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_insumo
    ADD CONSTRAINT cirugia_insumo_pkey PRIMARY KEY (cirugia_solicitud_id, insumo_id);


--
-- Name: cirugia_solicitud cirugia_solicitud_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_solicitud
    ADD CONSTRAINT cirugia_solicitud_pkey PRIMARY KEY (id);


--
-- Name: cita cita_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT cita_pkey PRIMARY KEY (id);


--
-- Name: clinica clinica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinica
    ADD CONSTRAINT clinica_pkey PRIMARY KEY (id);


--
-- Name: consentimiento_informado consentimiento_informado_cirugia_solicitud_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consentimiento_informado
    ADD CONSTRAINT consentimiento_informado_cirugia_solicitud_id_key UNIQUE (cirugia_solicitud_id);


--
-- Name: consentimiento_informado consentimiento_informado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consentimiento_informado
    ADD CONSTRAINT consentimiento_informado_pkey PRIMARY KEY (id);


--
-- Name: consulta consulta_cita_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT consulta_cita_id_key UNIQUE (cita_id);


--
-- Name: consulta consulta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT consulta_pkey PRIMARY KEY (id);


--
-- Name: egreso egreso_ingreso_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egreso
    ADD CONSTRAINT egreso_ingreso_id_key UNIQUE (ingreso_id);


--
-- Name: egreso egreso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egreso
    ADD CONSTRAINT egreso_pkey PRIMARY KEY (id);


--
-- Name: encargado encargado_dpi_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encargado
    ADD CONSTRAINT encargado_dpi_key UNIQUE (dpi);


--
-- Name: encargado encargado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encargado
    ADD CONSTRAINT encargado_pkey PRIMARY KEY (id);


--
-- Name: equipo equipo_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_nombre_key UNIQUE (nombre);


--
-- Name: equipo equipo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_pkey PRIMARY KEY (id);


--
-- Name: especialidad especialidad_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidad
    ADD CONSTRAINT especialidad_nombre_key UNIQUE (nombre);


--
-- Name: especialidad especialidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidad
    ADD CONSTRAINT especialidad_pkey PRIMARY KEY (id);


--
-- Name: examen_laboratorio examen_laboratorio_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examen_laboratorio
    ADD CONSTRAINT examen_laboratorio_nombre_key UNIQUE (nombre);


--
-- Name: examen_laboratorio examen_laboratorio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examen_laboratorio
    ADD CONSTRAINT examen_laboratorio_pkey PRIMARY KEY (id);


--
-- Name: exploracion_fisica exploracion_fisica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exploracion_fisica
    ADD CONSTRAINT exploracion_fisica_pkey PRIMARY KEY (id);


--
-- Name: factura_detalle factura_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura_detalle
    ADD CONSTRAINT factura_detalle_pkey PRIMARY KEY (id);


--
-- Name: factura factura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura
    ADD CONSTRAINT factura_pkey PRIMARY KEY (id);


--
-- Name: historia_clinica historia_clinica_cirugia_solicitud_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historia_clinica
    ADD CONSTRAINT historia_clinica_cirugia_solicitud_id_key UNIQUE (cirugia_solicitud_id);


--
-- Name: historia_clinica historia_clinica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historia_clinica
    ADD CONSTRAINT historia_clinica_pkey PRIMARY KEY (id);


--
-- Name: hospital hospital_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital
    ADD CONSTRAINT hospital_pkey PRIMARY KEY (id);


--
-- Name: hospital_unidad hospital_unidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital_unidad
    ADD CONSTRAINT hospital_unidad_pkey PRIMARY KEY (hospital_id, unidad_medica_id);


--
-- Name: hospitalizacion hospitalizacion_ingreso_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospitalizacion
    ADD CONSTRAINT hospitalizacion_ingreso_id_key UNIQUE (ingreso_id);


--
-- Name: hospitalizacion hospitalizacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospitalizacion
    ADD CONSTRAINT hospitalizacion_pkey PRIMARY KEY (id);


--
-- Name: ingreso ingreso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingreso
    ADD CONSTRAINT ingreso_pkey PRIMARY KEY (id);


--
-- Name: instrumento instrumento_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumento
    ADD CONSTRAINT instrumento_nombre_key UNIQUE (nombre);


--
-- Name: instrumento instrumento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumento
    ADD CONSTRAINT instrumento_pkey PRIMARY KEY (id);


--
-- Name: insumo insumo_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insumo
    ADD CONSTRAINT insumo_nombre_key UNIQUE (nombre);


--
-- Name: insumo insumo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insumo
    ADD CONSTRAINT insumo_pkey PRIMARY KEY (id);


--
-- Name: medicamento medicamento_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_nombre_key UNIQUE (nombre);


--
-- Name: medicamento medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (id);


--
-- Name: orden_laboratorio_examen orden_laboratorio_examen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_laboratorio_examen
    ADD CONSTRAINT orden_laboratorio_examen_pkey PRIMARY KEY (orden_laboratorio_id, examen_laboratorio_id);


--
-- Name: orden_laboratorio orden_laboratorio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_laboratorio
    ADD CONSTRAINT orden_laboratorio_pkey PRIMARY KEY (id);


--
-- Name: paciente paciente_dpi_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_dpi_key UNIQUE (dpi);


--
-- Name: paciente_encargado paciente_encargado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente_encargado
    ADD CONSTRAINT paciente_encargado_pkey PRIMARY KEY (paciente_id, encargado_id);


--
-- Name: paciente paciente_expediente_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_expediente_key UNIQUE (expediente);


--
-- Name: paciente paciente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_pkey PRIMARY KEY (id);


--
-- Name: pago pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_pkey PRIMARY KEY (id);


--
-- Name: personal_especialidad personal_especialidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_especialidad
    ADD CONSTRAINT personal_especialidad_pkey PRIMARY KEY (personal_medico_id, especialidad_id);


--
-- Name: personal_medico personal_medico_dpi_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_medico
    ADD CONSTRAINT personal_medico_dpi_key UNIQUE (dpi);


--
-- Name: personal_medico personal_medico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_medico
    ADD CONSTRAINT personal_medico_pkey PRIMARY KEY (id);


--
-- Name: personal_unidad personal_unidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_unidad
    ADD CONSTRAINT personal_unidad_pkey PRIMARY KEY (personal_medico_id, hospital_id, unidad_medica_id);


--
-- Name: receta_medicamento receta_medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_medicamento
    ADD CONSTRAINT receta_medicamento_pkey PRIMARY KEY (receta_id, medicamento_id);


--
-- Name: receta receta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_pkey PRIMARY KEY (id);


--
-- Name: recurso_asistencial recurso_asistencial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recurso_asistencial
    ADD CONSTRAINT recurso_asistencial_pkey PRIMARY KEY (id);


--
-- Name: servicio_medico servicio_medico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicio_medico
    ADD CONSTRAINT servicio_medico_pkey PRIMARY KEY (id);


--
-- Name: traslado traslado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traslado
    ADD CONSTRAINT traslado_pkey PRIMARY KEY (id);


--
-- Name: unidad_medica unidad_medica_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medica
    ADD CONSTRAINT unidad_medica_nombre_key UNIQUE (nombre);


--
-- Name: unidad_medica unidad_medica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medica
    ADD CONSTRAINT unidad_medica_pkey PRIMARY KEY (id);


--
-- Name: clinica uq_clinica_hospital_numero; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinica
    ADD CONSTRAINT uq_clinica_hospital_numero UNIQUE (hospital_id, numero);


--
-- Name: pago uq_pago_factura_numero; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT uq_pago_factura_numero UNIQUE (factura_id, numero_pago);


--
-- Name: recurso_asistencial uq_recurso_asistencial_nombre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recurso_asistencial
    ADD CONSTRAINT uq_recurso_asistencial_nombre UNIQUE (hospital_id, unidad_medica_id, nombre);


--
-- Name: servicio_medico uq_servicio_medico_unidad_nombre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicio_medico
    ADD CONSTRAINT uq_servicio_medico_unidad_nombre UNIQUE (unidad_medica_id, nombre);


--
-- Name: calificacion fk_calificacion_encargado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calificacion
    ADD CONSTRAINT fk_calificacion_encargado FOREIGN KEY (encargado_id) REFERENCES public.encargado(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: calificacion fk_calificacion_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calificacion
    ADD CONSTRAINT fk_calificacion_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: calificacion fk_calificacion_personal; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calificacion
    ADD CONSTRAINT fk_calificacion_personal FOREIGN KEY (personal_medico_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: chequeo_preanestesico fk_chequeo_preanestesico_anestesista; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chequeo_preanestesico
    ADD CONSTRAINT fk_chequeo_preanestesico_anestesista FOREIGN KEY (anestesista_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: chequeo_preanestesico fk_chequeo_preanestesico_cirugia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chequeo_preanestesico
    ADD CONSTRAINT fk_chequeo_preanestesico_cirugia FOREIGN KEY (cirugia_solicitud_id) REFERENCES public.cirugia_solicitud(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: chequeo_preanestesico fk_chequeo_preanestesico_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chequeo_preanestesico
    ADD CONSTRAINT fk_chequeo_preanestesico_medico FOREIGN KEY (medico_clasifica_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: chequeo_quirurgico fk_chequeo_quirurgico_cirugia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chequeo_quirurgico
    ADD CONSTRAINT fk_chequeo_quirurgico_cirugia FOREIGN KEY (cirugia_solicitud_id) REFERENCES public.cirugia_solicitud(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: chequeo_quirurgico fk_chequeo_quirurgico_personal; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chequeo_quirurgico
    ADD CONSTRAINT fk_chequeo_quirurgico_personal FOREIGN KEY (registrado_por_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cirugia_equipo fk_cirugia_equipo_cirugia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_equipo
    ADD CONSTRAINT fk_cirugia_equipo_cirugia FOREIGN KEY (cirugia_solicitud_id) REFERENCES public.cirugia_solicitud(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cirugia_equipo fk_cirugia_equipo_equipo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_equipo
    ADD CONSTRAINT fk_cirugia_equipo_equipo FOREIGN KEY (equipo_id) REFERENCES public.equipo(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cirugia_etapa fk_cirugia_etapa_cirugia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_etapa
    ADD CONSTRAINT fk_cirugia_etapa_cirugia FOREIGN KEY (cirugia_solicitud_id) REFERENCES public.cirugia_solicitud(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cirugia_etapa fk_cirugia_etapa_enfermero; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_etapa
    ADD CONSTRAINT fk_cirugia_etapa_enfermero FOREIGN KEY (enfermero_responsable_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cirugia_instrumento fk_cirugia_instrumento_cirugia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_instrumento
    ADD CONSTRAINT fk_cirugia_instrumento_cirugia FOREIGN KEY (cirugia_solicitud_id) REFERENCES public.cirugia_solicitud(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cirugia_instrumento fk_cirugia_instrumento_instrumento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_instrumento
    ADD CONSTRAINT fk_cirugia_instrumento_instrumento FOREIGN KEY (instrumento_id) REFERENCES public.instrumento(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cirugia_insumo fk_cirugia_insumo_cirugia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_insumo
    ADD CONSTRAINT fk_cirugia_insumo_cirugia FOREIGN KEY (cirugia_solicitud_id) REFERENCES public.cirugia_solicitud(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cirugia_insumo fk_cirugia_insumo_insumo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_insumo
    ADD CONSTRAINT fk_cirugia_insumo_insumo FOREIGN KEY (insumo_id) REFERENCES public.insumo(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cirugia_solicitud fk_cirugia_solicitud_cirujano; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_solicitud
    ADD CONSTRAINT fk_cirugia_solicitud_cirujano FOREIGN KEY (cirujano_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cirugia_solicitud fk_cirugia_solicitud_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_solicitud
    ADD CONSTRAINT fk_cirugia_solicitud_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cirugia_solicitud fk_cirugia_solicitud_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_solicitud
    ADD CONSTRAINT fk_cirugia_solicitud_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cirugia_solicitud fk_cirugia_solicitud_quirofano; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia_solicitud
    ADD CONSTRAINT fk_cirugia_solicitud_quirofano FOREIGN KEY (quirofano_id) REFERENCES public.recurso_asistencial(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cita fk_cita_clinica; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT fk_cita_clinica FOREIGN KEY (clinica_id) REFERENCES public.clinica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cita fk_cita_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT fk_cita_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cita fk_cita_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT fk_cita_medico FOREIGN KEY (medico_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cita fk_cita_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT fk_cita_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: clinica fk_clinica_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinica
    ADD CONSTRAINT fk_clinica_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: clinica fk_clinica_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clinica
    ADD CONSTRAINT fk_clinica_unidad FOREIGN KEY (unidad_medica_id) REFERENCES public.unidad_medica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: consentimiento_informado fk_consentimiento_cirugia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consentimiento_informado
    ADD CONSTRAINT fk_consentimiento_cirugia FOREIGN KEY (cirugia_solicitud_id) REFERENCES public.cirugia_solicitud(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: consentimiento_informado fk_consentimiento_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consentimiento_informado
    ADD CONSTRAINT fk_consentimiento_medico FOREIGN KEY (medico_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: consulta fk_consulta_cita; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT fk_consulta_cita FOREIGN KEY (cita_id) REFERENCES public.cita(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: consulta fk_consulta_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT fk_consulta_medico FOREIGN KEY (medico_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: consulta fk_consulta_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT fk_consulta_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: egreso fk_egreso_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egreso
    ADD CONSTRAINT fk_egreso_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: egreso fk_egreso_ingreso; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egreso
    ADD CONSTRAINT fk_egreso_ingreso FOREIGN KEY (ingreso_id) REFERENCES public.ingreso(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: egreso fk_egreso_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egreso
    ADD CONSTRAINT fk_egreso_medico FOREIGN KEY (medico_asignado_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: egreso fk_egreso_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egreso
    ADD CONSTRAINT fk_egreso_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: egreso fk_egreso_recurso; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egreso
    ADD CONSTRAINT fk_egreso_recurso FOREIGN KEY (recurso_asistencial_id) REFERENCES public.recurso_asistencial(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: egreso fk_egreso_servicio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egreso
    ADD CONSTRAINT fk_egreso_servicio FOREIGN KEY (servicio_medico_id) REFERENCES public.servicio_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: egreso fk_egreso_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egreso
    ADD CONSTRAINT fk_egreso_unidad FOREIGN KEY (unidad_medica_id) REFERENCES public.unidad_medica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: exploracion_fisica fk_exploracion_fisica_historia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exploracion_fisica
    ADD CONSTRAINT fk_exploracion_fisica_historia FOREIGN KEY (historia_clinica_id) REFERENCES public.historia_clinica(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: factura_detalle fk_factura_detalle_factura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura_detalle
    ADD CONSTRAINT fk_factura_detalle_factura FOREIGN KEY (factura_id) REFERENCES public.factura(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: factura_detalle fk_factura_detalle_servicio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura_detalle
    ADD CONSTRAINT fk_factura_detalle_servicio FOREIGN KEY (servicio_medico_id) REFERENCES public.servicio_medico(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: factura fk_factura_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura
    ADD CONSTRAINT fk_factura_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: factura fk_factura_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factura
    ADD CONSTRAINT fk_factura_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: historia_clinica fk_historia_clinica_cirugia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historia_clinica
    ADD CONSTRAINT fk_historia_clinica_cirugia FOREIGN KEY (cirugia_solicitud_id) REFERENCES public.cirugia_solicitud(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: historia_clinica fk_historia_clinica_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historia_clinica
    ADD CONSTRAINT fk_historia_clinica_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: hospital_unidad fk_hospital_unidad_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital_unidad
    ADD CONSTRAINT fk_hospital_unidad_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hospital_unidad fk_hospital_unidad_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospital_unidad
    ADD CONSTRAINT fk_hospital_unidad_unidad FOREIGN KEY (unidad_medica_id) REFERENCES public.unidad_medica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: hospitalizacion fk_hospitalizacion_cama; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospitalizacion
    ADD CONSTRAINT fk_hospitalizacion_cama FOREIGN KEY (cama_id) REFERENCES public.recurso_asistencial(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hospitalizacion fk_hospitalizacion_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospitalizacion
    ADD CONSTRAINT fk_hospitalizacion_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: hospitalizacion fk_hospitalizacion_ingreso; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospitalizacion
    ADD CONSTRAINT fk_hospitalizacion_ingreso FOREIGN KEY (ingreso_id) REFERENCES public.ingreso(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: hospitalizacion fk_hospitalizacion_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospitalizacion
    ADD CONSTRAINT fk_hospitalizacion_medico FOREIGN KEY (medico_encargado_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: hospitalizacion fk_hospitalizacion_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospitalizacion
    ADD CONSTRAINT fk_hospitalizacion_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: hospitalizacion fk_hospitalizacion_servicio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospitalizacion
    ADD CONSTRAINT fk_hospitalizacion_servicio FOREIGN KEY (servicio_medico_id) REFERENCES public.servicio_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: hospitalizacion fk_hospitalizacion_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hospitalizacion
    ADD CONSTRAINT fk_hospitalizacion_unidad FOREIGN KEY (unidad_medica_id) REFERENCES public.unidad_medica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ingreso fk_ingreso_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingreso
    ADD CONSTRAINT fk_ingreso_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ingreso fk_ingreso_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingreso
    ADD CONSTRAINT fk_ingreso_medico FOREIGN KEY (medico_encargado_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ingreso fk_ingreso_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingreso
    ADD CONSTRAINT fk_ingreso_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ingreso fk_ingreso_recurso; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingreso
    ADD CONSTRAINT fk_ingreso_recurso FOREIGN KEY (recurso_asistencial_id) REFERENCES public.recurso_asistencial(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ingreso fk_ingreso_servicio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingreso
    ADD CONSTRAINT fk_ingreso_servicio FOREIGN KEY (servicio_medico_id) REFERENCES public.servicio_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ingreso fk_ingreso_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingreso
    ADD CONSTRAINT fk_ingreso_unidad FOREIGN KEY (unidad_medica_id) REFERENCES public.unidad_medica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orden_laboratorio_examen fk_orden_examen_examen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_laboratorio_examen
    ADD CONSTRAINT fk_orden_examen_examen FOREIGN KEY (examen_laboratorio_id) REFERENCES public.examen_laboratorio(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orden_laboratorio_examen fk_orden_examen_orden; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_laboratorio_examen
    ADD CONSTRAINT fk_orden_examen_orden FOREIGN KEY (orden_laboratorio_id) REFERENCES public.orden_laboratorio(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orden_laboratorio fk_orden_laboratorio_cirugia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_laboratorio
    ADD CONSTRAINT fk_orden_laboratorio_cirugia FOREIGN KEY (cirugia_solicitud_id) REFERENCES public.cirugia_solicitud(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orden_laboratorio fk_orden_laboratorio_consulta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_laboratorio
    ADD CONSTRAINT fk_orden_laboratorio_consulta FOREIGN KEY (consulta_id) REFERENCES public.consulta(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orden_laboratorio fk_orden_laboratorio_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_laboratorio
    ADD CONSTRAINT fk_orden_laboratorio_medico FOREIGN KEY (medico_solicita_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orden_laboratorio fk_orden_laboratorio_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_laboratorio
    ADD CONSTRAINT fk_orden_laboratorio_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: paciente_encargado fk_paciente_encargado_encargado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente_encargado
    ADD CONSTRAINT fk_paciente_encargado_encargado FOREIGN KEY (encargado_id) REFERENCES public.encargado(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: paciente_encargado fk_paciente_encargado_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente_encargado
    ADD CONSTRAINT fk_paciente_encargado_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pago fk_pago_factura; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT fk_pago_factura FOREIGN KEY (factura_id) REFERENCES public.factura(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: personal_especialidad fk_personal_especialidad_especialidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_especialidad
    ADD CONSTRAINT fk_personal_especialidad_especialidad FOREIGN KEY (especialidad_id) REFERENCES public.especialidad(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: personal_especialidad fk_personal_especialidad_personal; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_especialidad
    ADD CONSTRAINT fk_personal_especialidad_personal FOREIGN KEY (personal_medico_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: personal_medico fk_personal_medico_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_medico
    ADD CONSTRAINT fk_personal_medico_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: personal_unidad fk_personal_unidad_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_unidad
    ADD CONSTRAINT fk_personal_unidad_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: personal_unidad fk_personal_unidad_personal; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_unidad
    ADD CONSTRAINT fk_personal_unidad_personal FOREIGN KEY (personal_medico_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: personal_unidad fk_personal_unidad_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_unidad
    ADD CONSTRAINT fk_personal_unidad_unidad FOREIGN KEY (unidad_medica_id) REFERENCES public.unidad_medica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: receta fk_receta_clinica; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT fk_receta_clinica FOREIGN KEY (clinica_id) REFERENCES public.clinica(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: receta fk_receta_consulta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT fk_receta_consulta FOREIGN KEY (consulta_id) REFERENCES public.consulta(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: receta_medicamento fk_receta_medicamento_medicamento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_medicamento
    ADD CONSTRAINT fk_receta_medicamento_medicamento FOREIGN KEY (medicamento_id) REFERENCES public.medicamento(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: receta_medicamento fk_receta_medicamento_receta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta_medicamento
    ADD CONSTRAINT fk_receta_medicamento_receta FOREIGN KEY (receta_id) REFERENCES public.receta(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: receta fk_receta_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT fk_receta_medico FOREIGN KEY (medico_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: receta fk_receta_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT fk_receta_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: recurso_asistencial fk_recurso_asistencial_hospital; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recurso_asistencial
    ADD CONSTRAINT fk_recurso_asistencial_hospital FOREIGN KEY (hospital_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: recurso_asistencial fk_recurso_asistencial_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recurso_asistencial
    ADD CONSTRAINT fk_recurso_asistencial_unidad FOREIGN KEY (unidad_medica_id) REFERENCES public.unidad_medica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: servicio_medico fk_servicio_medico_unidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicio_medico
    ADD CONSTRAINT fk_servicio_medico_unidad FOREIGN KEY (unidad_medica_id) REFERENCES public.unidad_medica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: traslado fk_traslado_hospital_destino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traslado
    ADD CONSTRAINT fk_traslado_hospital_destino FOREIGN KEY (hospital_destino_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: traslado fk_traslado_hospital_origen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traslado
    ADD CONSTRAINT fk_traslado_hospital_origen FOREIGN KEY (hospital_origen_id) REFERENCES public.hospital(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: traslado fk_traslado_medico; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traslado
    ADD CONSTRAINT fk_traslado_medico FOREIGN KEY (medico_indica_id) REFERENCES public.personal_medico(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: traslado fk_traslado_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traslado
    ADD CONSTRAINT fk_traslado_paciente FOREIGN KEY (paciente_id) REFERENCES public.paciente(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: traslado fk_traslado_servicio_destino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traslado
    ADD CONSTRAINT fk_traslado_servicio_destino FOREIGN KEY (servicio_destino_id) REFERENCES public.servicio_medico(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: traslado fk_traslado_servicio_origen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traslado
    ADD CONSTRAINT fk_traslado_servicio_origen FOREIGN KEY (servicio_origen_id) REFERENCES public.servicio_medico(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: traslado fk_traslado_unidad_destino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traslado
    ADD CONSTRAINT fk_traslado_unidad_destino FOREIGN KEY (unidad_destino_id) REFERENCES public.unidad_medica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: traslado fk_traslado_unidad_origen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traslado
    ADD CONSTRAINT fk_traslado_unidad_origen FOREIGN KEY (unidad_origen_id) REFERENCES public.unidad_medica(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO hospital_lector;
GRANT ALL ON SCHEMA public TO hospital_admin;


--
-- Name: TABLE calificacion; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.calificacion TO hospital_lector;
GRANT ALL ON TABLE public.calificacion TO hospital_admin;


--
-- Name: TABLE chequeo_preanestesico; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.chequeo_preanestesico TO hospital_lector;
GRANT ALL ON TABLE public.chequeo_preanestesico TO hospital_admin;


--
-- Name: TABLE chequeo_quirurgico; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.chequeo_quirurgico TO hospital_lector;
GRANT ALL ON TABLE public.chequeo_quirurgico TO hospital_admin;


--
-- Name: TABLE cirugia_equipo; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.cirugia_equipo TO hospital_lector;
GRANT ALL ON TABLE public.cirugia_equipo TO hospital_admin;


--
-- Name: TABLE cirugia_etapa; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.cirugia_etapa TO hospital_lector;
GRANT ALL ON TABLE public.cirugia_etapa TO hospital_admin;


--
-- Name: TABLE cirugia_instrumento; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.cirugia_instrumento TO hospital_lector;
GRANT ALL ON TABLE public.cirugia_instrumento TO hospital_admin;


--
-- Name: TABLE cirugia_insumo; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.cirugia_insumo TO hospital_lector;
GRANT ALL ON TABLE public.cirugia_insumo TO hospital_admin;


--
-- Name: TABLE cirugia_solicitud; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.cirugia_solicitud TO hospital_lector;
GRANT ALL ON TABLE public.cirugia_solicitud TO hospital_admin;


--
-- Name: TABLE cita; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.cita TO hospital_lector;
GRANT ALL ON TABLE public.cita TO hospital_admin;


--
-- Name: TABLE clinica; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.clinica TO hospital_lector;
GRANT ALL ON TABLE public.clinica TO hospital_admin;


--
-- Name: TABLE consentimiento_informado; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.consentimiento_informado TO hospital_lector;
GRANT ALL ON TABLE public.consentimiento_informado TO hospital_admin;


--
-- Name: TABLE consulta; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.consulta TO hospital_lector;
GRANT ALL ON TABLE public.consulta TO hospital_admin;


--
-- Name: TABLE egreso; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.egreso TO hospital_lector;
GRANT ALL ON TABLE public.egreso TO hospital_admin;


--
-- Name: TABLE encargado; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.encargado TO hospital_lector;
GRANT ALL ON TABLE public.encargado TO hospital_admin;


--
-- Name: TABLE equipo; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.equipo TO hospital_lector;
GRANT ALL ON TABLE public.equipo TO hospital_admin;


--
-- Name: TABLE especialidad; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.especialidad TO hospital_lector;
GRANT ALL ON TABLE public.especialidad TO hospital_admin;


--
-- Name: TABLE examen_laboratorio; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.examen_laboratorio TO hospital_lector;
GRANT ALL ON TABLE public.examen_laboratorio TO hospital_admin;


--
-- Name: TABLE exploracion_fisica; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.exploracion_fisica TO hospital_lector;
GRANT ALL ON TABLE public.exploracion_fisica TO hospital_admin;


--
-- Name: TABLE factura; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.factura TO hospital_lector;
GRANT ALL ON TABLE public.factura TO hospital_admin;


--
-- Name: TABLE factura_detalle; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.factura_detalle TO hospital_lector;
GRANT ALL ON TABLE public.factura_detalle TO hospital_admin;


--
-- Name: TABLE historia_clinica; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.historia_clinica TO hospital_lector;
GRANT ALL ON TABLE public.historia_clinica TO hospital_admin;


--
-- Name: TABLE hospital; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.hospital TO hospital_lector;
GRANT ALL ON TABLE public.hospital TO hospital_admin;


--
-- Name: TABLE hospital_unidad; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.hospital_unidad TO hospital_lector;
GRANT ALL ON TABLE public.hospital_unidad TO hospital_admin;


--
-- Name: TABLE hospitalizacion; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.hospitalizacion TO hospital_lector;
GRANT ALL ON TABLE public.hospitalizacion TO hospital_admin;


--
-- Name: TABLE ingreso; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.ingreso TO hospital_lector;
GRANT ALL ON TABLE public.ingreso TO hospital_admin;


--
-- Name: TABLE instrumento; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.instrumento TO hospital_lector;
GRANT ALL ON TABLE public.instrumento TO hospital_admin;


--
-- Name: TABLE insumo; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.insumo TO hospital_lector;
GRANT ALL ON TABLE public.insumo TO hospital_admin;


--
-- Name: TABLE medicamento; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.medicamento TO hospital_lector;
GRANT ALL ON TABLE public.medicamento TO hospital_admin;


--
-- Name: TABLE orden_laboratorio; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.orden_laboratorio TO hospital_lector;
GRANT ALL ON TABLE public.orden_laboratorio TO hospital_admin;


--
-- Name: TABLE orden_laboratorio_examen; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.orden_laboratorio_examen TO hospital_lector;
GRANT ALL ON TABLE public.orden_laboratorio_examen TO hospital_admin;


--
-- Name: TABLE paciente; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.paciente TO hospital_lector;
GRANT ALL ON TABLE public.paciente TO hospital_admin;


--
-- Name: TABLE paciente_encargado; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.paciente_encargado TO hospital_lector;
GRANT ALL ON TABLE public.paciente_encargado TO hospital_admin;


--
-- Name: TABLE pago; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.pago TO hospital_lector;
GRANT ALL ON TABLE public.pago TO hospital_admin;


--
-- Name: TABLE personal_especialidad; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.personal_especialidad TO hospital_lector;
GRANT ALL ON TABLE public.personal_especialidad TO hospital_admin;


--
-- Name: TABLE personal_medico; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.personal_medico TO hospital_lector;
GRANT ALL ON TABLE public.personal_medico TO hospital_admin;


--
-- Name: TABLE personal_unidad; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.personal_unidad TO hospital_lector;
GRANT ALL ON TABLE public.personal_unidad TO hospital_admin;


--
-- Name: TABLE receta; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.receta TO hospital_lector;
GRANT ALL ON TABLE public.receta TO hospital_admin;


--
-- Name: TABLE receta_medicamento; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.receta_medicamento TO hospital_lector;
GRANT ALL ON TABLE public.receta_medicamento TO hospital_admin;


--
-- Name: TABLE recurso_asistencial; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.recurso_asistencial TO hospital_lector;
GRANT ALL ON TABLE public.recurso_asistencial TO hospital_admin;


--
-- Name: TABLE servicio_medico; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.servicio_medico TO hospital_lector;
GRANT ALL ON TABLE public.servicio_medico TO hospital_admin;


--
-- Name: TABLE traslado; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.traslado TO hospital_lector;
GRANT ALL ON TABLE public.traslado TO hospital_admin;


--
-- Name: TABLE unidad_medica; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.unidad_medica TO hospital_lector;
GRANT ALL ON TABLE public.unidad_medica TO hospital_admin;


--
-- PostgreSQL database dump complete
--

\unrestrict CcBY0qWcp91UkRYhEf6KSACa5GSjWLbDjojUxc7JXMhdMqZAAms3wWOLtBtt9SH

