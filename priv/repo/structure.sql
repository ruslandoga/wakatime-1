--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7
-- Dumped by pg_dump version 14.3

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
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: heartbeats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heartbeats (
    "time" timestamp with time zone NOT NULL,
    entity character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    category character varying(255),
    project character varying(255),
    branch character varying(255),
    language character varying(255),
    dependencies character varying(255)[],
    lines integer,
    lineno integer,
    cursorpos integer,
    is_write boolean DEFAULT false NOT NULL,
    editor character varying(255),
    operating_system character varying(255)
);


--
-- Name: _hyper_1_1_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1_chunk (
    CONSTRAINT constraint_1 CHECK ((("time" >= '2022-05-26 00:00:00+00'::timestamp with time zone) AND ("time" < '2022-06-02 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.heartbeats);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: _hyper_1_1_chunk is_write; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1_chunk ALTER COLUMN is_write SET DEFAULT false;


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: _hyper_1_1_chunk_heartbeats_time_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1_chunk_heartbeats_time_idx ON _timescaledb_internal._hyper_1_1_chunk USING btree ("time" DESC);


--
-- Name: heartbeats_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX heartbeats_time_idx ON public.heartbeats USING btree ("time" DESC);


--
-- Name: heartbeats ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.heartbeats FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20220526142121);
INSERT INTO public."schema_migrations" (version) VALUES (20220526142547);
INSERT INTO public."schema_migrations" (version) VALUES (20220526142639);
