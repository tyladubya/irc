--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE messages (
    user_id integer NOT NULL,
    message text,
    room_id integer
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE permissions (
    user_id integer,
    room_id integer
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rooms (
    room_id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- Name: rooms_room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rooms_room_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rooms_room_id_seq OWNER TO postgres;

--
-- Name: rooms_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE rooms_room_id_seq OWNED BY rooms.room_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(40),
    password character varying(200)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: room_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rooms ALTER COLUMN room_id SET DEFAULT nextval('rooms_room_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY messages (user_id, message, room_id) FROM stdin;
2	This is general	1
2	This is beatboxing	2
2	This is programming	3
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY permissions (user_id, room_id) FROM stdin;
1	1
2	1
2	2
2	3
3	1
3	2
4	1
5	1
6	1
7	1
8	1
9	1
10	1
10	2
10	3
9	3
8	2
7	2
7	3
6	2
5	3
4	2
4	3
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rooms (room_id, name) FROM stdin;
1	General
2	Beatboxing
3	Programming
\.


--
-- Name: rooms_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('rooms_room_id_seq', 3, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (id, username, password) FROM stdin;
1	Cassie	$2a$06$IgEfG9kCyqEMMIGX4HoHGexUSjTrioUuWJMfXJShaaIVP7UU.VdKe
2	Tyler	$2a$06$DAJPECq5POmoQxVJT25Us.nbwMrytJJm.UfiBe01FrS1ioHbrjgEO
3	Bob	$2a$06$wmh1FxAajBCn06s/tMkmlO8Nv.D.vN8RY70vC79vIWTCdmsUJ1IBu
4	Henry	$2a$06$pisqMB0LKSGFqYjWEoOGEuASi4mozG1f7QLBZrpKgMxtwScYGP28m
5	Thomas	$2a$06$WBEqDtv1GzjX6w.IE3C8A.OwNPdVGI.h.vb.GXP81NudaDW8CN4cS
6	Shehan	$2a$06$sQbj0RGfh3KC8Nx.RQRwP.cnTQbZjY.CKRhRWrDKmCRHEU7JoMubK
7	Gusty	$2a$06$i6WY/it.TCwozhhm/ciExuk7wFbnkdTz3S4KISlDpj1tuQh.87Sj2
8	Sepehr	$2a$06$mvMs8zP75CwvNzh.PpdDhO3OmCSe2HywJGZlXSwQB2Yv5KUSCBo9G
9	Jake	$2a$06$o9T5ekVNtaPYguDo6mg5BuQv5E8PhcDMo5RlOV8iMPupGEI0ErQoS
10	Alex	$2a$06$EWuHQcbui6FhFXQ2gwEafO3OVlkJwUb1NrmwmaT8/W.TjM6CV5GbO
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 10, true);


--
-- Name: rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: messages_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_room_id_fkey FOREIGN KEY (room_id) REFERENCES rooms(room_id);


--
-- Name: permissions_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_room_id_fkey FOREIGN KEY (room_id) REFERENCES rooms(room_id);


--
-- Name: permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

