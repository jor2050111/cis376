--
-- PostgreSQL database dump
--

\restrict iG6zvAsI2pl9cAD34RbQ74T38RPj26YjIPBbeGLFh6jxeM17NVwXEnBLhDdhsmb

-- Dumped from database version 17.11 (Homebrew)
-- Dumped by pg_dump version 17.11 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointments (
    appointment_id integer NOT NULL,
    patient_id integer NOT NULL,
    provider_id integer NOT NULL,
    scheduled_at timestamp without time zone NOT NULL,
    status text NOT NULL,
    visit_type text NOT NULL
);


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patients (
    patient_id integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    date_of_birth date NOT NULL,
    phone text,
    email text,
    address text,
    insurance_member_id text
);


--
-- Name: providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.providers (
    provider_id integer NOT NULL,
    full_name text NOT NULL,
    specialty text NOT NULL,
    npi character(10) NOT NULL
);


--
-- Name: staff_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.staff_accounts (
    account_id integer NOT NULL,
    username text NOT NULL,
    role_name text NOT NULL,
    provider_id integer
);


--
-- Name: visit_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.visit_notes (
    note_id integer NOT NULL,
    appointment_id integer NOT NULL,
    diagnosis_code text NOT NULL,
    note_text text NOT NULL
);


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.appointments (appointment_id, patient_id, provider_id, scheduled_at, status, visit_type) FROM stdin;
1	504	1	2024-10-19 09:15:00	Completed	Annual physical
2	122	4	2021-01-20 17:00:00	Completed	Follow-up
3	555	3	2021-03-04 13:30:00	Completed	Follow-up
4	9	8	2021-06-25 12:15:00	No-show	Telehealth
5	15	8	2025-07-13 17:00:00	Completed	Chronic care
6	170	9	2022-04-03 10:15:00	Completed	Annual physical
7	5	4	2021-03-31 13:00:00	Completed	Annual physical
8	536	3	2021-12-20 14:00:00	No-show	Follow-up
9	241	11	2024-05-19 16:15:00	Scheduled	Telehealth
10	178	10	2022-03-22 08:45:00	Completed	Well child
11	292	11	2024-07-03 15:30:00	Cancelled	Well child
12	450	1	2022-01-10 17:00:00	Completed	Sick visit
13	40	8	2026-02-04 14:00:00	Completed	Well child
14	531	7	2023-10-19 13:30:00	Completed	Well child
15	470	12	2023-12-22 09:00:00	Completed	Well child
16	14	5	2024-05-12 09:30:00	Completed	Chronic care
17	236	6	2021-09-10 16:15:00	No-show	Chronic care
18	263	12	2020-01-13 09:15:00	Completed	Sick visit
19	323	5	2019-09-12 11:00:00	Completed	Annual physical
20	44	12	2026-05-08 08:30:00	Completed	Annual physical
21	357	11	2023-12-22 16:45:00	Completed	Sick visit
22	266	7	2019-06-26 16:30:00	Completed	Telehealth
23	26	2	2023-11-16 16:45:00	Completed	Annual physical
24	42	6	2023-05-02 16:15:00	Completed	Telehealth
25	504	10	2022-12-14 16:00:00	Completed	Well child
26	65	4	2024-10-04 10:30:00	Completed	Telehealth
27	194	2	2023-02-07 14:45:00	Completed	Telehealth
28	544	4	2023-09-22 10:45:00	No-show	Sick visit
29	598	8	2025-03-04 15:00:00	Completed	Follow-up
30	36	4	2022-11-15 12:00:00	Completed	Sick visit
31	520	6	2021-01-21 12:15:00	Completed	Follow-up
32	45	2	2019-07-31 11:30:00	Completed	Chronic care
33	60	5	2025-08-10 11:30:00	Completed	Annual physical
34	315	5	2026-01-25 13:15:00	Completed	Well child
35	265	1	2020-10-05 15:30:00	Completed	Well child
36	502	8	2019-05-17 12:45:00	Completed	Well child
37	425	2	2025-12-23 09:15:00	Completed	Annual physical
38	590	3	2022-11-14 17:00:00	Completed	Annual physical
39	282	6	2024-01-02 10:30:00	Completed	Chronic care
40	367	12	2020-06-15 09:00:00	Completed	Annual physical
41	527	8	2024-11-29 17:00:00	Scheduled	Annual physical
42	491	3	2021-03-14 12:15:00	Completed	Chronic care
43	272	1	2023-05-15 08:00:00	Completed	Sick visit
44	66	4	2020-12-18 08:30:00	Completed	Annual physical
45	288	9	2023-12-07 11:30:00	Completed	Sick visit
46	128	6	2024-10-29 13:15:00	No-show	Well child
47	462	4	2019-03-04 15:30:00	Completed	Follow-up
48	284	5	2021-12-29 11:00:00	Completed	Sick visit
49	487	9	2023-06-30 11:30:00	Completed	Well child
50	524	7	2025-07-24 12:00:00	Completed	Annual physical
51	457	10	2023-04-04 12:00:00	Completed	Well child
52	262	7	2020-03-20 17:00:00	Completed	Chronic care
53	332	6	2020-02-24 09:30:00	Completed	Annual physical
54	78	3	2023-03-23 09:30:00	Completed	Sick visit
55	276	8	2019-02-09 10:45:00	Cancelled	Annual physical
56	286	1	2020-12-27 16:45:00	Completed	Sick visit
57	267	4	2019-02-14 13:45:00	Completed	Well child
58	245	8	2022-08-30 13:00:00	Completed	Well child
59	492	7	2019-11-24 13:30:00	Completed	Annual physical
60	263	5	2019-01-03 09:30:00	Completed	Chronic care
61	182	4	2021-12-22 14:30:00	No-show	Follow-up
62	106	8	2022-11-22 08:45:00	Completed	Sick visit
63	133	3	2025-07-13 08:00:00	Completed	Sick visit
64	597	8	2019-08-04 14:30:00	Completed	Annual physical
65	193	9	2023-09-15 14:15:00	Completed	Follow-up
66	47	12	2021-04-14 17:00:00	Completed	Annual physical
67	567	6	2025-03-14 10:45:00	Completed	Follow-up
68	219	11	2019-11-10 16:30:00	Completed	Sick visit
69	485	2	2021-05-30 14:30:00	Completed	Sick visit
70	124	6	2020-09-22 08:45:00	Completed	Annual physical
71	45	4	2023-07-26 10:30:00	Completed	Annual physical
72	264	1	2020-10-06 15:15:00	Completed	Annual physical
73	200	5	2026-05-10 15:45:00	Completed	Annual physical
74	76	4	2024-02-28 13:30:00	Completed	Follow-up
75	454	3	2021-03-15 10:45:00	Cancelled	Telehealth
76	117	6	2019-01-18 14:45:00	Completed	Annual physical
77	341	10	2025-09-07 12:15:00	Cancelled	Follow-up
78	444	1	2019-11-08 15:45:00	No-show	Annual physical
79	562	5	2019-05-19 16:00:00	Completed	Chronic care
80	437	4	2020-06-02 08:30:00	No-show	Follow-up
81	85	7	2022-02-21 10:30:00	Completed	Annual physical
82	141	3	2022-10-21 09:30:00	Completed	Annual physical
83	519	9	2024-07-13 16:15:00	Completed	Well child
84	506	8	2025-10-13 16:30:00	Completed	Well child
85	386	2	2022-03-18 16:30:00	Scheduled	Chronic care
86	460	6	2022-07-31 13:00:00	Completed	Sick visit
87	176	1	2024-01-28 16:15:00	Completed	Follow-up
88	475	7	2023-01-21 08:15:00	Cancelled	Chronic care
89	446	12	2019-08-29 15:00:00	Completed	Annual physical
90	343	5	2025-01-31 11:15:00	Completed	Chronic care
91	83	1	2025-12-21 11:30:00	No-show	Follow-up
92	303	7	2025-07-22 13:30:00	Completed	Sick visit
93	73	6	2020-03-28 16:30:00	Completed	Chronic care
94	319	11	2024-09-26 08:30:00	Completed	Chronic care
95	38	12	2026-01-18 11:45:00	Completed	Follow-up
96	8	1	2019-09-24 16:00:00	Completed	Well child
97	592	12	2025-06-28 09:15:00	Completed	Telehealth
98	212	7	2025-12-03 10:00:00	Completed	Annual physical
99	35	11	2022-01-17 13:00:00	Cancelled	Annual physical
100	376	5	2023-09-06 08:45:00	Completed	Well child
101	129	11	2020-02-20 12:00:00	No-show	Annual physical
102	326	2	2019-06-15 08:15:00	Scheduled	Well child
103	585	2	2024-09-11 13:00:00	Cancelled	Chronic care
104	561	8	2025-02-17 11:30:00	Completed	Sick visit
105	483	5	2021-09-25 14:00:00	No-show	Chronic care
106	439	6	2019-03-29 13:45:00	Completed	Annual physical
107	379	7	2022-08-04 15:45:00	Scheduled	Sick visit
108	5	4	2025-11-08 08:15:00	Completed	Telehealth
109	574	11	2023-01-19 11:00:00	Completed	Chronic care
110	275	8	2019-05-18 09:00:00	Completed	Annual physical
111	217	4	2023-04-15 15:30:00	Completed	Well child
112	493	1	2022-06-17 12:00:00	Completed	Follow-up
113	173	5	2020-09-19 13:30:00	Completed	Annual physical
114	364	4	2022-04-26 13:00:00	Completed	Follow-up
115	289	9	2022-06-28 13:15:00	Completed	Chronic care
116	55	9	2024-02-13 12:45:00	Completed	Well child
117	291	1	2020-01-20 12:45:00	No-show	Annual physical
118	215	10	2025-03-01 14:30:00	Completed	Follow-up
119	507	9	2025-12-27 14:00:00	Completed	Telehealth
120	471	8	2025-04-11 09:30:00	Completed	Sick visit
121	107	4	2022-01-25 11:45:00	Completed	Sick visit
122	528	7	2023-05-09 15:15:00	Completed	Sick visit
123	535	5	2022-11-29 12:30:00	Completed	Chronic care
124	534	7	2021-06-03 12:30:00	Completed	Annual physical
125	249	7	2025-07-16 08:45:00	Completed	Annual physical
126	317	6	2022-08-11 14:00:00	Completed	Chronic care
127	247	4	2024-07-16 08:30:00	Completed	Chronic care
128	417	11	2025-06-03 11:00:00	Completed	Well child
129	73	6	2023-08-29 15:30:00	Completed	Follow-up
130	36	8	2025-05-06 08:30:00	Completed	Follow-up
131	163	1	2023-08-07 15:45:00	Completed	Well child
132	223	8	2023-07-20 15:30:00	Completed	Sick visit
133	144	3	2020-11-22 16:00:00	No-show	Follow-up
134	388	12	2025-12-11 12:30:00	Completed	Sick visit
135	368	12	2022-09-19 16:00:00	Completed	Well child
136	529	7	2024-05-29 16:00:00	Completed	Chronic care
137	108	3	2019-02-15 15:30:00	Completed	Annual physical
138	42	2	2023-06-27 11:00:00	Completed	Chronic care
139	136	9	2023-09-10 08:45:00	Completed	Telehealth
140	461	2	2019-04-08 15:15:00	Completed	Annual physical
141	437	4	2019-05-10 16:00:00	Completed	Chronic care
142	554	6	2019-03-31 15:00:00	Completed	Annual physical
143	379	7	2025-11-21 09:00:00	Completed	Telehealth
144	19	5	2019-09-11 15:15:00	Completed	Telehealth
145	495	4	2019-03-25 14:00:00	Scheduled	Follow-up
146	38	12	2021-07-26 08:45:00	Completed	Chronic care
147	395	8	2020-01-04 10:00:00	Completed	Sick visit
148	341	10	2020-04-15 08:00:00	Completed	Sick visit
149	342	1	2022-03-25 12:15:00	Completed	Telehealth
150	343	5	2022-07-04 11:30:00	Completed	Annual physical
151	233	8	2026-04-01 10:45:00	Completed	Sick visit
152	124	10	2020-07-16 16:15:00	Completed	Sick visit
153	27	7	2019-12-04 09:15:00	Completed	Telehealth
154	98	5	2019-10-21 09:00:00	Completed	Telehealth
155	67	3	2020-09-07 14:00:00	Completed	Chronic care
156	144	3	2025-06-20 08:30:00	Completed	Chronic care
157	281	3	2024-02-14 16:00:00	Completed	Chronic care
158	207	11	2022-07-22 16:30:00	Completed	Chronic care
159	379	7	2025-01-22 13:00:00	Completed	Well child
160	16	2	2020-06-04 15:30:00	Cancelled	Telehealth
161	582	8	2022-08-04 16:15:00	Completed	Annual physical
162	59	10	2019-05-26 11:15:00	Completed	Follow-up
163	593	6	2021-05-26 09:00:00	Cancelled	Telehealth
164	148	5	2021-06-29 16:00:00	Completed	Annual physical
165	401	11	2025-07-16 09:30:00	Completed	Well child
166	369	4	2023-11-25 14:15:00	Completed	Telehealth
167	49	4	2021-02-22 14:15:00	Completed	Annual physical
168	49	4	2023-11-04 11:30:00	No-show	Telehealth
169	453	1	2022-08-20 16:45:00	Completed	Annual physical
170	410	1	2024-07-04 16:30:00	Completed	Sick visit
171	25	10	2019-03-30 16:15:00	Completed	Well child
172	92	9	2019-02-04 10:00:00	Completed	Annual physical
173	305	3	2021-08-29 12:45:00	Completed	Telehealth
174	187	11	2025-09-23 16:30:00	Scheduled	Annual physical
175	304	11	2020-11-23 12:00:00	Completed	Annual physical
176	552	8	2020-09-09 15:15:00	Completed	Follow-up
177	326	2	2025-10-26 16:15:00	Cancelled	Chronic care
178	72	12	2021-09-07 09:15:00	Completed	Annual physical
179	72	12	2022-09-09 15:30:00	No-show	Follow-up
180	199	10	2019-10-06 10:45:00	Completed	Chronic care
181	215	10	2024-10-23 16:45:00	Completed	Telehealth
182	482	6	2021-07-25 09:45:00	Completed	Follow-up
183	115	2	2021-03-26 13:45:00	No-show	Follow-up
184	438	3	2025-09-14 12:15:00	Completed	Telehealth
185	328	7	2023-10-22 14:00:00	Completed	Chronic care
186	587	7	2023-03-08 12:45:00	Completed	Well child
187	13	2	2021-07-25 10:00:00	Completed	Telehealth
188	148	5	2021-02-10 15:15:00	Completed	Well child
189	278	3	2022-01-24 11:00:00	Completed	Annual physical
190	198	1	2020-12-13 12:15:00	Completed	Sick visit
191	354	8	2020-05-25 10:00:00	Completed	Telehealth
192	547	6	2024-10-31 13:45:00	No-show	Sick visit
193	373	4	2019-02-13 16:45:00	Completed	Sick visit
194	368	12	2023-04-01 16:15:00	Completed	Annual physical
195	92	5	2021-10-07 13:00:00	No-show	Well child
196	413	8	2021-01-07 09:00:00	Completed	Follow-up
197	460	4	2025-06-27 11:45:00	No-show	Follow-up
198	135	8	2022-11-21 09:15:00	Completed	Chronic care
199	349	6	2025-10-10 14:45:00	Completed	Sick visit
200	393	9	2021-12-05 10:30:00	Completed	Telehealth
201	241	11	2024-03-29 09:45:00	Completed	Chronic care
202	442	3	2025-05-11 15:00:00	No-show	Well child
203	55	9	2019-06-23 15:00:00	Completed	Sick visit
204	222	12	2023-05-24 15:30:00	Completed	Well child
205	64	11	2021-05-09 10:15:00	Completed	Follow-up
206	468	7	2020-03-13 08:00:00	Completed	Telehealth
207	285	9	2022-05-27 13:00:00	Completed	Sick visit
208	457	10	2022-01-13 15:30:00	No-show	Well child
209	335	11	2021-04-25 09:30:00	Completed	Annual physical
210	273	6	2025-03-23 09:00:00	Completed	Telehealth
211	258	10	2024-04-22 16:45:00	Completed	Sick visit
212	598	10	2019-05-12 15:15:00	Cancelled	Well child
213	228	5	2023-06-08 17:00:00	Completed	Chronic care
214	73	6	2023-12-15 15:45:00	Completed	Sick visit
215	477	12	2021-09-19 10:30:00	Completed	Follow-up
216	95	9	2025-06-09 13:45:00	No-show	Sick visit
217	320	11	2023-05-13 15:45:00	Completed	Sick visit
218	402	6	2021-08-08 13:00:00	Completed	Annual physical
219	196	6	2023-05-05 12:00:00	Completed	Annual physical
220	432	3	2025-06-12 16:30:00	Completed	Sick visit
221	291	1	2026-02-10 13:00:00	Completed	Sick visit
222	573	9	2019-08-04 11:30:00	Completed	Chronic care
223	234	2	2024-09-16 10:15:00	Completed	Sick visit
224	96	1	2021-01-07 14:45:00	Scheduled	Annual physical
225	152	7	2022-07-29 12:00:00	Completed	Annual physical
226	153	8	2023-09-13 11:45:00	Cancelled	Annual physical
227	296	2	2019-02-11 15:45:00	Cancelled	Well child
228	411	8	2021-06-17 14:00:00	Scheduled	Annual physical
229	474	9	2019-10-20 08:00:00	Completed	Well child
230	147	9	2022-01-08 10:45:00	Completed	Well child
231	468	7	2022-01-22 13:00:00	Completed	Chronic care
232	416	9	2021-10-26 08:00:00	Cancelled	Telehealth
233	318	12	2022-10-02 11:00:00	Cancelled	Follow-up
234	162	10	2022-04-01 10:00:00	Scheduled	Annual physical
235	355	6	2022-03-09 16:00:00	Completed	Well child
236	139	12	2024-11-08 11:30:00	Completed	Well child
237	599	7	2019-01-06 10:30:00	Completed	Annual physical
238	186	4	2024-05-28 08:15:00	Completed	Annual physical
239	101	11	2021-04-21 16:45:00	Completed	Annual physical
240	119	6	2020-03-10 10:45:00	Completed	Annual physical
241	148	5	2023-02-25 17:00:00	Completed	Chronic care
242	166	10	2022-10-23 16:00:00	Completed	Annual physical
243	26	11	2019-04-02 16:45:00	Completed	Well child
244	293	9	2020-09-28 15:00:00	Scheduled	Sick visit
245	168	2	2023-08-06 14:15:00	Completed	Chronic care
246	228	7	2020-08-03 09:45:00	Completed	Sick visit
247	258	8	2023-01-14 11:45:00	Completed	Follow-up
248	260	2	2024-09-15 10:45:00	No-show	Well child
249	560	6	2019-10-10 09:30:00	Completed	Follow-up
250	103	8	2021-12-28 09:30:00	Completed	Sick visit
251	200	5	2024-11-03 09:45:00	Completed	Telehealth
252	529	6	2021-06-14 10:15:00	Completed	Annual physical
253	463	9	2025-05-06 15:45:00	Cancelled	Telehealth
254	540	4	2026-01-15 13:00:00	Completed	Sick visit
255	353	7	2022-01-06 13:00:00	Completed	Telehealth
256	513	8	2020-05-21 14:45:00	Scheduled	Telehealth
257	18	4	2019-09-02 15:00:00	Completed	Well child
258	2	4	2025-12-10 11:15:00	Completed	Follow-up
259	271	2	2025-06-04 08:45:00	Completed	Telehealth
260	182	8	2025-01-30 09:30:00	Completed	Follow-up
261	200	5	2019-06-17 09:15:00	Completed	Telehealth
262	460	6	2021-05-16 12:30:00	Completed	Telehealth
263	196	6	2022-06-03 12:30:00	Completed	Telehealth
264	473	5	2023-09-24 10:15:00	Completed	Sick visit
265	318	12	2019-09-19 13:45:00	Cancelled	Well child
266	78	3	2025-12-20 13:15:00	Completed	Telehealth
267	120	5	2023-08-31 10:45:00	Completed	Follow-up
268	277	4	2024-03-26 10:00:00	Completed	Telehealth
269	582	8	2019-11-11 08:15:00	Completed	Sick visit
270	587	2	2023-12-12 14:00:00	Completed	Well child
271	125	11	2025-04-15 13:00:00	Completed	Well child
272	427	9	2024-01-17 09:30:00	Completed	Sick visit
273	290	6	2019-09-28 13:45:00	Completed	Chronic care
274	377	10	2019-05-23 11:45:00	Completed	Telehealth
275	366	12	2025-11-10 15:00:00	Completed	Annual physical
276	362	6	2021-06-11 11:45:00	No-show	Follow-up
277	200	5	2023-09-23 12:45:00	No-show	Follow-up
278	531	2	2023-09-23 09:15:00	Scheduled	Chronic care
279	213	2	2021-08-21 15:15:00	No-show	Sick visit
280	250	11	2020-01-13 10:00:00	Completed	Well child
281	170	9	2025-12-10 10:30:00	Scheduled	Sick visit
282	156	10	2021-01-02 10:15:00	Scheduled	Sick visit
283	440	5	2021-03-16 13:45:00	Completed	Chronic care
284	340	1	2020-05-10 14:15:00	Scheduled	Chronic care
285	380	7	2021-06-29 14:45:00	Cancelled	Chronic care
286	440	5	2019-10-19 10:15:00	Completed	Sick visit
287	537	5	2023-06-07 15:30:00	Completed	Sick visit
288	527	8	2025-05-21 08:30:00	Completed	Follow-up
289	457	10	2019-08-25 11:15:00	Completed	Annual physical
290	310	9	2021-11-10 16:15:00	Completed	Follow-up
291	576	3	2023-08-01 15:00:00	Completed	Annual physical
292	417	4	2020-01-05 09:00:00	Completed	Follow-up
293	213	2	2022-06-09 15:45:00	Cancelled	Well child
294	127	11	2021-08-06 11:15:00	Scheduled	Well child
295	171	12	2022-10-16 13:45:00	Completed	Chronic care
296	154	8	2026-03-04 11:15:00	Scheduled	Well child
297	570	3	2021-06-10 11:15:00	Completed	Well child
298	364	4	2019-10-09 16:15:00	Completed	Annual physical
299	338	11	2023-11-22 09:30:00	No-show	Telehealth
300	168	10	2025-01-13 10:30:00	Cancelled	Telehealth
301	529	4	2023-11-19 16:15:00	Completed	Annual physical
302	404	6	2025-12-13 11:45:00	Completed	Sick visit
303	83	1	2023-03-26 16:15:00	Completed	Sick visit
304	109	7	2020-08-22 14:00:00	No-show	Follow-up
305	264	7	2021-04-02 08:30:00	Completed	Follow-up
306	153	8	2025-08-24 16:30:00	Cancelled	Follow-up
307	389	5	2020-08-23 10:30:00	Completed	Sick visit
308	546	7	2019-09-21 09:45:00	Completed	Annual physical
309	462	4	2021-05-31 12:00:00	Completed	Telehealth
310	596	8	2024-08-11 13:30:00	Cancelled	Follow-up
311	438	3	2025-04-25 13:15:00	Completed	Sick visit
312	22	2	2024-01-05 08:45:00	Completed	Follow-up
313	265	1	2022-01-14 14:00:00	Scheduled	Annual physical
314	81	8	2021-08-06 11:15:00	Completed	Chronic care
315	492	7	2025-07-11 16:15:00	Completed	Well child
316	171	12	2024-10-25 12:00:00	Completed	Chronic care
317	442	3	2019-04-25 16:45:00	Completed	Well child
318	597	9	2025-12-23 10:15:00	Completed	Well child
319	464	5	2026-03-04 08:15:00	Completed	Chronic care
320	275	5	2019-02-25 16:15:00	Completed	Well child
321	428	8	2020-12-10 08:45:00	Completed	Telehealth
322	160	7	2022-02-15 16:45:00	Completed	Follow-up
323	246	5	2023-08-23 16:30:00	No-show	Telehealth
324	272	1	2020-05-09 08:45:00	Completed	Annual physical
325	443	3	2023-12-19 15:00:00	Completed	Annual physical
326	116	4	2022-12-09 13:15:00	Completed	Well child
327	484	2	2023-11-04 13:45:00	Completed	Annual physical
328	186	4	2020-10-03 11:45:00	Completed	Follow-up
329	43	6	2025-02-12 10:00:00	Completed	Sick visit
330	103	8	2022-09-29 12:00:00	Completed	Well child
331	456	1	2022-01-05 15:15:00	No-show	Sick visit
332	50	2	2021-03-03 09:00:00	Completed	Telehealth
333	385	9	2023-06-27 15:00:00	Cancelled	Telehealth
334	136	9	2026-05-21 08:00:00	Completed	Telehealth
335	248	8	2023-08-03 11:45:00	Completed	Follow-up
336	177	7	2025-09-15 11:45:00	Completed	Sick visit
337	314	9	2020-06-23 12:30:00	Completed	Telehealth
338	323	5	2025-08-31 17:00:00	Completed	Annual physical
339	73	6	2023-12-01 08:30:00	No-show	Telehealth
340	406	8	2025-06-13 11:00:00	Completed	Annual physical
341	163	5	2020-04-18 08:45:00	Completed	Well child
342	312	1	2022-07-25 14:15:00	Completed	Telehealth
343	239	11	2021-04-23 13:15:00	Completed	Follow-up
344	93	1	2022-11-12 12:15:00	Completed	Well child
345	147	9	2024-09-11 14:00:00	Scheduled	Chronic care
346	2	4	2024-04-27 16:45:00	Completed	Telehealth
347	436	3	2022-05-10 08:30:00	Scheduled	Annual physical
348	394	6	2019-09-26 09:30:00	Completed	Sick visit
349	496	10	2023-05-23 08:00:00	Completed	Annual physical
350	25	10	2023-04-26 14:30:00	Completed	Sick visit
351	71	4	2019-01-20 14:45:00	Scheduled	Telehealth
352	168	2	2023-01-02 15:15:00	No-show	Well child
353	211	6	2023-10-12 14:45:00	Cancelled	Well child
354	285	9	2019-04-08 08:30:00	Scheduled	Annual physical
355	174	1	2021-01-04 10:45:00	Completed	Sick visit
356	113	11	2024-10-14 13:45:00	No-show	Telehealth
357	325	7	2025-04-25 13:30:00	Completed	Chronic care
358	267	4	2024-05-26 13:00:00	Completed	Annual physical
359	107	4	2025-10-25 12:30:00	Completed	Annual physical
360	273	6	2019-02-18 11:30:00	Completed	Follow-up
361	88	7	2025-05-09 11:15:00	Completed	Annual physical
362	248	9	2019-01-11 10:15:00	Completed	Chronic care
363	93	1	2023-04-04 10:30:00	Completed	Telehealth
364	360	12	2023-05-27 10:45:00	Completed	Follow-up
365	422	1	2022-11-13 14:30:00	Cancelled	Sick visit
366	456	1	2019-08-22 08:30:00	Completed	Annual physical
367	322	9	2021-04-09 14:45:00	Completed	Telehealth
368	155	12	2023-05-22 16:00:00	Completed	Sick visit
369	381	1	2022-06-12 10:00:00	Completed	Annual physical
370	181	11	2023-02-27 12:00:00	No-show	Chronic care
371	416	1	2022-08-12 16:00:00	Completed	Follow-up
372	72	12	2020-11-04 10:45:00	Scheduled	Sick visit
373	242	9	2020-05-17 15:45:00	Completed	Well child
374	165	6	2025-06-19 15:15:00	Completed	Chronic care
375	328	7	2019-05-20 13:30:00	Completed	Well child
376	575	3	2025-10-22 08:15:00	Completed	Annual physical
377	76	10	2021-06-07 15:15:00	Completed	Annual physical
378	71	4	2019-08-18 12:45:00	No-show	Well child
379	475	7	2026-02-04 09:30:00	Completed	Sick visit
380	288	9	2019-11-30 11:30:00	Completed	Annual physical
381	531	9	2023-01-01 15:15:00	Completed	Telehealth
382	44	12	2020-02-13 13:45:00	Completed	Well child
383	173	5	2021-09-12 15:00:00	Completed	Follow-up
384	113	1	2025-12-09 08:15:00	Completed	Chronic care
385	80	10	2023-01-07 10:15:00	Completed	Annual physical
386	157	10	2020-02-14 08:15:00	Completed	Sick visit
387	362	6	2022-02-23 17:00:00	Completed	Telehealth
388	75	7	2025-05-21 12:30:00	Completed	Chronic care
389	282	5	2026-03-10 15:15:00	Completed	Well child
390	548	10	2023-06-11 09:45:00	Completed	Annual physical
391	410	2	2020-03-17 11:30:00	Completed	Annual physical
392	96	5	2019-02-08 11:30:00	Cancelled	Chronic care
393	423	4	2020-11-28 15:15:00	Completed	Sick visit
394	43	6	2019-06-15 11:00:00	Completed	Chronic care
395	96	1	2021-08-26 16:30:00	Completed	Sick visit
396	464	5	2025-03-30 10:00:00	Completed	Annual physical
397	92	8	2019-07-18 13:00:00	Completed	Well child
398	432	3	2020-08-14 16:15:00	Completed	Chronic care
399	404	6	2021-09-09 17:00:00	Completed	Sick visit
400	535	5	2022-09-27 13:15:00	Completed	Follow-up
401	505	3	2023-09-01 14:15:00	Scheduled	Annual physical
402	118	1	2025-10-30 14:45:00	Completed	Follow-up
403	59	10	2020-08-19 11:00:00	Completed	Telehealth
404	115	7	2019-01-15 10:00:00	Completed	Well child
405	358	11	2022-11-01 09:30:00	Completed	Sick visit
406	594	10	2024-11-23 16:45:00	Completed	Chronic care
407	11	5	2025-02-19 09:45:00	Completed	Annual physical
408	182	4	2023-04-17 13:00:00	Completed	Well child
409	281	3	2022-12-21 10:30:00	Cancelled	Follow-up
410	220	8	2024-05-20 13:00:00	Cancelled	Follow-up
411	26	2	2023-05-28 16:30:00	Completed	Telehealth
412	523	7	2023-03-26 16:45:00	Completed	Sick visit
413	333	2	2020-02-14 15:30:00	Completed	Telehealth
414	378	4	2022-06-24 13:45:00	Completed	Annual physical
415	366	12	2022-07-09 10:30:00	Completed	Chronic care
416	47	12	2025-05-25 16:00:00	Completed	Sick visit
417	438	9	2021-10-09 16:15:00	Completed	Sick visit
418	557	10	2023-09-14 16:45:00	Scheduled	Annual physical
419	151	3	2024-12-02 12:45:00	Completed	Telehealth
420	41	6	2025-03-01 15:00:00	Completed	Annual physical
421	588	5	2022-08-03 14:15:00	Completed	Sick visit
422	67	3	2025-12-09 13:45:00	Completed	Telehealth
423	174	1	2025-12-29 13:30:00	Completed	Annual physical
424	43	6	2025-08-27 10:00:00	Completed	Annual physical
425	265	1	2024-07-23 15:15:00	Completed	Follow-up
426	559	7	2022-02-01 08:00:00	Completed	Telehealth
427	420	12	2020-06-14 16:30:00	Cancelled	Telehealth
428	3	12	2023-07-18 16:45:00	Completed	Sick visit
429	183	1	2023-11-22 15:15:00	Completed	Chronic care
430	239	5	2019-01-04 12:15:00	Scheduled	Annual physical
431	586	9	2026-04-13 15:15:00	Completed	Well child
432	417	11	2026-05-23 08:45:00	Completed	Telehealth
433	427	9	2025-09-28 11:45:00	Completed	Follow-up
434	187	11	2021-07-02 10:00:00	Scheduled	Follow-up
435	423	4	2020-07-28 09:30:00	Completed	Annual physical
436	413	8	2025-09-24 13:45:00	Cancelled	Sick visit
437	141	12	2022-04-15 12:00:00	Completed	Chronic care
438	544	8	2025-11-24 12:30:00	Completed	Annual physical
439	543	9	2019-07-10 16:30:00	Completed	Sick visit
440	337	4	2023-10-06 16:15:00	Completed	Follow-up
441	363	8	2019-07-29 09:30:00	Completed	Well child
442	440	5	2020-02-25 12:00:00	Completed	Sick visit
443	382	1	2020-12-04 15:00:00	Completed	Telehealth
444	87	6	2025-07-06 14:45:00	Scheduled	Chronic care
445	17	6	2023-05-10 14:00:00	Completed	Follow-up
446	228	7	2023-08-10 16:15:00	Completed	Chronic care
447	81	8	2020-09-10 13:30:00	No-show	Follow-up
448	563	8	2024-10-21 16:45:00	No-show	Telehealth
449	255	2	2025-05-06 14:00:00	Completed	Telehealth
450	590	3	2023-12-12 14:00:00	Completed	Telehealth
451	274	10	2022-06-25 14:15:00	Completed	Telehealth
452	574	5	2024-10-11 14:00:00	Completed	Follow-up
453	141	12	2020-03-09 09:00:00	Completed	Follow-up
454	600	6	2023-09-23 10:30:00	Scheduled	Follow-up
455	324	1	2022-01-28 13:00:00	Completed	Chronic care
456	511	2	2019-01-28 08:30:00	Completed	Well child
457	83	1	2026-01-15 11:00:00	Completed	Telehealth
458	177	12	2020-10-28 13:30:00	Completed	Well child
459	289	9	2019-06-15 13:00:00	Completed	Follow-up
460	323	5	2023-04-19 12:00:00	Completed	Sick visit
461	4	2	2026-04-22 15:15:00	Completed	Telehealth
462	560	6	2020-09-19 12:15:00	Completed	Follow-up
463	343	5	2024-05-17 17:00:00	Completed	Chronic care
464	80	10	2022-04-29 09:15:00	No-show	Telehealth
465	267	4	2020-11-03 13:30:00	No-show	Annual physical
466	473	5	2021-11-05 12:15:00	Scheduled	Sick visit
467	166	5	2025-01-04 09:45:00	Scheduled	Telehealth
468	541	11	2025-10-11 11:30:00	Completed	Follow-up
469	156	10	2019-12-31 11:30:00	Completed	Annual physical
470	421	6	2020-02-26 09:45:00	Scheduled	Telehealth
471	512	2	2022-08-25 09:00:00	Completed	Chronic care
472	340	6	2022-08-10 16:15:00	Completed	Annual physical
473	442	2	2025-12-19 13:00:00	Completed	Chronic care
474	561	8	2024-08-02 12:30:00	No-show	Telehealth
475	311	11	2025-03-19 09:15:00	Completed	Annual physical
476	451	4	2024-02-16 08:30:00	Completed	Sick visit
477	472	4	2019-03-14 09:45:00	Scheduled	Annual physical
478	295	8	2020-02-10 08:30:00	Completed	Sick visit
479	275	5	2020-09-17 10:45:00	Cancelled	Follow-up
480	226	4	2025-10-28 11:30:00	Completed	Chronic care
481	38	12	2024-05-28 09:30:00	Completed	Telehealth
482	10	9	2020-09-06 12:00:00	Completed	Telehealth
483	598	8	2023-11-11 11:45:00	No-show	Well child
484	445	9	2019-06-07 17:00:00	Completed	Well child
485	119	6	2022-03-13 15:30:00	Completed	Follow-up
486	409	6	2023-07-17 08:45:00	Completed	Well child
487	58	11	2024-06-30 09:00:00	Cancelled	Well child
488	173	5	2024-10-06 13:15:00	Cancelled	Follow-up
489	406	8	2021-06-20 12:00:00	No-show	Chronic care
490	428	8	2024-07-22 09:30:00	Cancelled	Sick visit
491	470	12	2019-11-29 14:45:00	No-show	Sick visit
492	203	2	2024-10-15 08:45:00	Completed	Chronic care
493	15	8	2020-05-06 11:00:00	Completed	Sick visit
494	566	12	2026-05-23 08:45:00	Completed	Chronic care
495	490	10	2024-03-07 10:45:00	Completed	Well child
496	180	2	2019-09-29 11:15:00	Completed	Follow-up
497	161	11	2025-08-09 11:15:00	Completed	Well child
498	324	8	2021-11-10 08:15:00	Completed	Sick visit
499	363	5	2025-06-28 09:15:00	Completed	Follow-up
500	411	1	2024-03-15 12:45:00	Cancelled	Follow-up
501	258	8	2019-08-31 08:30:00	Completed	Follow-up
502	20	8	2025-10-15 16:15:00	Completed	Chronic care
503	130	9	2022-09-11 15:15:00	No-show	Annual physical
504	114	7	2021-07-11 12:45:00	Completed	Annual physical
505	90	2	2024-09-14 14:45:00	Cancelled	Follow-up
506	325	4	2024-01-27 13:30:00	Cancelled	Well child
507	140	8	2025-02-11 13:15:00	Cancelled	Chronic care
508	355	11	2024-10-13 13:45:00	Scheduled	Chronic care
509	597	8	2020-08-27 12:00:00	Completed	Sick visit
510	278	3	2022-08-01 09:30:00	Completed	Follow-up
511	449	7	2022-03-18 08:45:00	Completed	Follow-up
512	481	11	2025-12-01 08:00:00	Completed	Annual physical
513	374	6	2020-11-27 10:15:00	Completed	Well child
514	166	10	2019-10-26 13:30:00	Scheduled	Sick visit
515	181	1	2022-12-10 13:00:00	Scheduled	Follow-up
516	502	9	2025-01-26 09:15:00	Completed	Sick visit
517	426	7	2020-07-19 08:30:00	Completed	Follow-up
518	291	1	2024-03-05 12:45:00	Completed	Follow-up
519	551	4	2024-02-02 10:15:00	No-show	Annual physical
520	490	3	2025-07-31 15:15:00	Completed	Sick visit
521	248	9	2025-10-11 15:30:00	No-show	Follow-up
522	213	2	2019-02-26 14:00:00	Completed	Follow-up
523	487	10	2020-06-16 13:45:00	Completed	Chronic care
524	451	4	2022-01-30 15:45:00	Completed	Follow-up
525	297	6	2020-09-29 16:15:00	Completed	Annual physical
526	322	4	2025-02-15 13:45:00	Completed	Well child
527	501	12	2019-10-11 08:30:00	Completed	Annual physical
528	240	12	2024-06-25 16:45:00	Completed	Sick visit
529	273	6	2025-04-23 08:45:00	No-show	Sick visit
530	462	4	2019-01-06 15:15:00	Completed	Annual physical
531	57	7	2025-02-25 16:45:00	Completed	Follow-up
532	237	10	2019-11-11 10:30:00	Completed	Sick visit
533	439	6	2019-04-12 12:45:00	Scheduled	Annual physical
534	427	9	2026-01-11 08:00:00	Completed	Sick visit
535	495	2	2025-06-03 15:15:00	Completed	Sick visit
536	77	6	2022-01-10 13:15:00	Completed	Follow-up
537	384	8	2020-01-04 08:45:00	Completed	Telehealth
538	513	5	2025-05-30 08:15:00	Cancelled	Annual physical
539	66	3	2019-08-09 14:45:00	Cancelled	Annual physical
540	529	6	2024-02-09 16:30:00	Scheduled	Well child
541	255	2	2026-03-27 16:00:00	Completed	Telehealth
542	218	5	2020-07-11 12:15:00	Completed	Annual physical
543	529	6	2020-01-06 12:30:00	Completed	Telehealth
544	132	10	2019-06-14 10:00:00	Completed	Well child
545	384	5	2025-01-11 14:30:00	Completed	Sick visit
546	304	11	2023-05-02 15:00:00	Completed	Follow-up
547	161	1	2024-04-05 09:00:00	No-show	Telehealth
548	563	4	2020-09-30 11:00:00	Completed	Follow-up
549	488	5	2023-03-16 14:15:00	Cancelled	Follow-up
550	591	10	2021-12-14 09:45:00	Completed	Well child
551	361	3	2021-04-13 08:15:00	Completed	Annual physical
552	365	7	2021-10-10 12:45:00	Completed	Annual physical
553	340	1	2022-09-11 09:15:00	Completed	Sick visit
554	288	9	2019-11-06 14:00:00	Completed	Sick visit
555	273	6	2022-01-25 08:45:00	Cancelled	Well child
556	526	2	2022-12-01 10:45:00	Completed	Chronic care
557	470	2	2023-04-24 13:30:00	Completed	Telehealth
558	28	9	2022-07-31 16:15:00	Completed	Sick visit
559	91	8	2020-12-06 08:30:00	Completed	Follow-up
560	301	6	2019-07-05 12:00:00	Completed	Follow-up
561	104	10	2023-01-22 09:15:00	Completed	Telehealth
562	59	10	2019-01-17 15:30:00	Scheduled	Sick visit
563	300	2	2025-09-17 08:15:00	Completed	Follow-up
564	81	8	2020-10-19 09:45:00	Completed	Telehealth
565	74	8	2023-02-24 14:15:00	Completed	Telehealth
566	369	5	2024-01-08 11:00:00	Completed	Sick visit
567	1	4	2025-12-11 13:15:00	Completed	Well child
568	154	8	2022-12-28 16:30:00	Completed	Annual physical
569	307	8	2021-02-10 16:00:00	Cancelled	Well child
570	556	9	2023-10-16 14:00:00	Completed	Sick visit
571	409	6	2020-06-02 10:15:00	Cancelled	Sick visit
572	164	2	2023-06-16 16:45:00	Completed	Sick visit
573	183	1	2019-04-07 14:00:00	Completed	Annual physical
574	349	10	2021-06-05 13:45:00	Completed	Sick visit
575	481	9	2022-06-03 10:15:00	Scheduled	Follow-up
576	256	4	2026-01-10 14:30:00	Completed	Follow-up
577	402	6	2019-11-10 13:00:00	Completed	Sick visit
578	473	5	2019-09-17 14:30:00	No-show	Annual physical
579	334	10	2022-06-06 14:30:00	Completed	Telehealth
580	333	2	2019-01-02 15:00:00	Completed	Telehealth
581	139	12	2025-09-17 09:30:00	Completed	Sick visit
582	577	8	2023-01-04 08:45:00	No-show	Telehealth
583	480	11	2019-06-23 10:30:00	Cancelled	Well child
584	572	2	2025-12-22 10:30:00	Completed	Sick visit
585	141	12	2019-04-08 09:00:00	Completed	Chronic care
586	545	7	2024-08-07 11:00:00	Cancelled	Sick visit
587	464	5	2024-04-18 14:00:00	Completed	Well child
588	333	2	2024-03-25 10:45:00	Completed	Well child
589	423	4	2023-04-26 10:00:00	Scheduled	Sick visit
590	13	2	2022-02-22 09:30:00	Cancelled	Follow-up
591	424	8	2020-08-25 15:00:00	Completed	Follow-up
592	359	12	2021-08-05 13:30:00	Completed	Telehealth
593	531	6	2023-04-15 15:45:00	Completed	Chronic care
594	92	6	2019-01-06 08:45:00	Completed	Chronic care
595	287	11	2020-07-18 09:00:00	Completed	Sick visit
596	493	1	2026-05-06 09:30:00	Completed	Follow-up
597	330	8	2020-03-14 14:15:00	Cancelled	Well child
598	300	2	2026-02-02 16:45:00	Completed	Follow-up
599	307	8	2021-11-04 08:45:00	Completed	Sick visit
600	188	9	2021-11-13 14:00:00	Completed	Well child
601	150	2	2024-01-14 09:30:00	Cancelled	Chronic care
602	400	6	2024-03-15 13:00:00	Completed	Chronic care
603	394	12	2021-04-27 12:15:00	Completed	Annual physical
604	270	7	2026-03-17 13:45:00	Cancelled	Chronic care
605	529	6	2020-08-28 08:45:00	Completed	Follow-up
606	378	1	2025-06-26 10:00:00	Completed	Sick visit
607	407	11	2023-09-07 12:45:00	Completed	Chronic care
608	272	2	2020-11-27 14:30:00	Completed	Sick visit
609	102	3	2019-08-20 16:45:00	Completed	Telehealth
610	188	9	2025-06-06 10:15:00	No-show	Chronic care
611	45	4	2019-09-01 14:45:00	Completed	Follow-up
612	353	4	2025-04-21 12:15:00	Completed	Follow-up
613	566	11	2022-01-08 08:45:00	Completed	Chronic care
614	279	11	2024-11-28 08:15:00	Cancelled	Annual physical
615	338	11	2022-08-23 09:00:00	Completed	Annual physical
616	86	6	2025-01-20 09:30:00	Completed	Sick visit
617	185	8	2023-08-17 12:15:00	Completed	Sick visit
618	255	2	2024-11-17 13:15:00	Completed	Telehealth
619	547	4	2019-08-25 09:30:00	Completed	Well child
620	143	10	2020-03-20 14:45:00	Scheduled	Annual physical
621	402	6	2023-04-26 13:30:00	Scheduled	Follow-up
622	242	9	2021-05-02 12:45:00	Completed	Annual physical
623	515	5	2019-03-31 14:15:00	Completed	Chronic care
624	38	12	2024-02-29 11:45:00	Completed	Follow-up
625	493	1	2025-06-19 08:00:00	Completed	Well child
626	278	3	2025-06-10 08:15:00	No-show	Sick visit
627	171	12	2021-01-14 13:00:00	Completed	Sick visit
628	396	7	2025-10-05 14:00:00	Completed	Chronic care
629	538	3	2022-08-02 13:15:00	Cancelled	Chronic care
630	156	10	2020-03-24 08:00:00	Completed	Annual physical
631	357	6	2025-11-09 16:15:00	No-show	Annual physical
632	453	1	2025-04-16 15:30:00	No-show	Annual physical
633	427	9	2026-02-12 13:15:00	Completed	Follow-up
634	498	3	2021-04-18 15:30:00	Completed	Telehealth
635	346	10	2021-09-14 15:00:00	Completed	Telehealth
636	159	10	2024-01-10 12:45:00	Completed	Chronic care
637	247	9	2025-11-02 11:00:00	Cancelled	Well child
638	237	10	2024-07-11 16:15:00	Completed	Annual physical
639	310	9	2024-08-09 11:15:00	Scheduled	Annual physical
640	236	7	2022-08-21 12:45:00	Completed	Chronic care
641	289	9	2019-06-12 08:00:00	Completed	Annual physical
642	337	4	2021-01-07 14:15:00	Completed	Sick visit
643	238	1	2023-12-09 13:00:00	Completed	Chronic care
644	361	3	2022-03-07 15:00:00	Completed	Telehealth
645	137	7	2020-08-29 12:00:00	Scheduled	Well child
646	454	3	2026-03-04 12:30:00	Completed	Chronic care
647	431	5	2022-06-25 12:15:00	Completed	Sick visit
648	341	3	2024-08-27 13:45:00	Completed	Follow-up
649	389	5	2020-10-08 09:00:00	Completed	Sick visit
650	372	9	2020-09-25 14:30:00	Completed	Telehealth
651	377	8	2026-01-16 14:30:00	Completed	Sick visit
652	358	11	2023-03-17 11:00:00	Completed	Annual physical
653	585	2	2022-09-28 12:45:00	Scheduled	Chronic care
654	496	3	2023-11-11 10:30:00	Completed	Sick visit
655	486	2	2020-06-04 12:00:00	Completed	Annual physical
656	161	11	2021-11-28 14:45:00	No-show	Follow-up
657	65	12	2023-08-30 15:15:00	Completed	Annual physical
658	508	3	2020-06-02 16:15:00	Completed	Sick visit
659	214	12	2020-02-01 12:00:00	No-show	Annual physical
660	90	2	2023-07-26 08:45:00	Completed	Follow-up
661	143	10	2022-01-16 11:45:00	Completed	Sick visit
662	391	1	2024-03-17 12:45:00	Completed	Follow-up
663	133	3	2020-12-04 08:45:00	Completed	Annual physical
664	48	10	2021-04-30 09:45:00	Completed	Well child
665	502	9	2020-05-31 12:00:00	No-show	Chronic care
666	162	10	2025-07-27 15:30:00	Cancelled	Well child
667	308	9	2020-06-22 14:45:00	Completed	Telehealth
668	139	12	2021-05-15 11:00:00	Cancelled	Chronic care
669	115	7	2019-10-05 09:00:00	Completed	Chronic care
670	573	9	2024-02-18 09:00:00	Completed	Sick visit
671	488	5	2019-03-10 08:15:00	Completed	Chronic care
672	82	7	2020-06-11 11:45:00	Cancelled	Annual physical
673	367	3	2020-05-15 10:45:00	Completed	Annual physical
674	442	3	2023-02-25 08:00:00	Scheduled	Follow-up
675	454	3	2025-03-04 11:45:00	No-show	Telehealth
676	330	8	2023-02-24 11:30:00	Completed	Follow-up
677	207	11	2020-05-08 11:30:00	Completed	Telehealth
678	445	9	2022-07-21 12:30:00	Completed	Sick visit
679	517	1	2022-03-19 15:15:00	Cancelled	Telehealth
680	115	12	2026-02-06 08:00:00	Completed	Sick visit
681	567	6	2023-12-11 10:45:00	Completed	Sick visit
682	73	6	2019-09-26 10:45:00	Completed	Well child
683	509	2	2024-11-07 10:30:00	Completed	Chronic care
684	367	3	2024-01-31 13:00:00	Completed	Well child
685	529	6	2025-10-30 14:00:00	Completed	Follow-up
686	453	1	2023-09-16 08:30:00	Completed	Follow-up
687	516	12	2025-07-23 15:45:00	Completed	Sick visit
688	30	1	2025-10-11 11:30:00	Completed	Sick visit
689	269	9	2022-03-03 08:15:00	Completed	Well child
690	95	9	2023-02-21 13:45:00	Completed	Well child
691	98	5	2024-05-30 12:15:00	Completed	Annual physical
692	517	4	2019-09-26 12:15:00	Completed	Telehealth
693	481	11	2019-01-24 08:15:00	Scheduled	Annual physical
694	98	5	2021-06-19 09:00:00	Completed	Telehealth
695	28	3	2020-01-18 13:00:00	No-show	Annual physical
696	565	11	2022-11-11 11:30:00	Completed	Well child
697	189	11	2024-10-30 12:30:00	Completed	Chronic care
698	96	1	2021-05-06 16:30:00	Completed	Sick visit
699	307	8	2020-04-06 12:30:00	Completed	Chronic care
700	364	4	2023-03-03 15:30:00	Completed	Telehealth
701	216	1	2025-06-18 11:00:00	Completed	Well child
702	522	2	2025-01-10 12:15:00	Completed	Annual physical
703	68	11	2025-05-04 17:00:00	Completed	Annual physical
704	494	8	2022-07-04 15:30:00	Completed	Chronic care
705	368	8	2023-09-17 17:00:00	Completed	Chronic care
706	380	7	2022-12-20 14:30:00	Completed	Sick visit
707	589	10	2020-11-25 16:30:00	Completed	Sick visit
708	397	2	2023-08-15 09:30:00	No-show	Follow-up
709	459	3	2026-04-19 13:30:00	Completed	Chronic care
710	113	11	2024-02-02 09:30:00	Completed	Well child
711	58	11	2020-09-24 13:30:00	Completed	Well child
712	393	9	2019-05-27 08:30:00	Completed	Well child
713	391	1	2022-07-20 12:00:00	Completed	Well child
714	369	5	2024-05-28 08:00:00	Cancelled	Chronic care
715	80	10	2020-04-16 14:30:00	Completed	Well child
716	241	11	2020-11-27 12:30:00	Completed	Telehealth
717	350	1	2022-07-08 12:45:00	Completed	Annual physical
718	466	3	2023-05-24 10:45:00	Completed	Telehealth
719	266	7	2023-08-28 09:15:00	Completed	Annual physical
720	352	9	2024-07-31 13:15:00	No-show	Telehealth
721	553	6	2022-01-23 12:45:00	Completed	Follow-up
722	279	11	2021-12-29 16:00:00	Completed	Telehealth
723	124	12	2021-09-07 08:45:00	Completed	Telehealth
724	188	9	2023-02-23 16:00:00	Completed	Well child
725	247	4	2022-02-15 10:30:00	Completed	Telehealth
726	242	9	2024-04-11 12:00:00	Completed	Sick visit
727	263	2	2023-11-07 10:00:00	Completed	Telehealth
728	160	7	2020-04-25 08:00:00	Completed	Chronic care
729	449	7	2025-01-03 13:30:00	Completed	Annual physical
730	549	3	2025-02-28 08:30:00	Completed	Annual physical
731	45	4	2022-01-15 09:15:00	Completed	Follow-up
732	243	3	2025-03-27 14:00:00	Completed	Annual physical
733	513	5	2023-08-16 11:45:00	Completed	Sick visit
734	587	1	2019-09-24 08:00:00	No-show	Follow-up
735	331	1	2025-05-09 14:30:00	Completed	Chronic care
736	350	9	2022-09-12 16:45:00	Scheduled	Well child
737	251	1	2019-11-27 12:30:00	Completed	Sick visit
738	57	7	2023-07-10 11:30:00	Completed	Annual physical
739	141	12	2022-04-14 13:45:00	Completed	Well child
740	172	9	2022-05-23 09:30:00	Completed	Chronic care
741	375	10	2022-05-09 14:30:00	Completed	Chronic care
742	134	5	2023-09-21 15:00:00	Scheduled	Annual physical
743	245	11	2022-12-04 15:30:00	Completed	Well child
744	464	5	2025-03-23 11:45:00	Completed	Telehealth
745	184	2	2021-11-24 12:45:00	No-show	Annual physical
746	342	12	2024-08-11 14:15:00	Completed	Sick visit
747	533	2	2024-07-05 13:15:00	Cancelled	Sick visit
748	494	8	2021-03-11 09:45:00	Scheduled	Telehealth
749	528	7	2021-10-16 16:45:00	Scheduled	Telehealth
750	206	11	2021-06-24 12:00:00	Completed	Well child
751	407	11	2026-02-08 13:00:00	Completed	Well child
752	485	2	2020-12-13 13:15:00	Completed	Well child
753	407	7	2026-03-25 09:15:00	Completed	Well child
754	560	6	2020-01-09 09:15:00	Completed	Sick visit
755	251	1	2023-02-27 10:00:00	Completed	Sick visit
756	374	6	2025-03-31 09:45:00	Completed	Follow-up
757	400	6	2019-10-24 14:15:00	Completed	Chronic care
758	172	9	2023-03-14 09:00:00	Completed	Telehealth
759	216	1	2023-01-17 14:45:00	Completed	Telehealth
760	257	6	2022-01-26 08:30:00	Completed	Follow-up
761	373	4	2021-08-15 09:45:00	Completed	Follow-up
762	173	5	2019-11-22 16:15:00	Completed	Annual physical
763	187	11	2021-07-27 11:15:00	Completed	Sick visit
764	194	9	2023-01-19 14:30:00	Completed	Chronic care
765	348	7	2021-06-12 15:00:00	No-show	Sick visit
766	139	12	2019-07-18 09:15:00	Completed	Sick visit
767	364	4	2022-06-03 15:45:00	No-show	Telehealth
768	246	5	2024-04-21 16:15:00	Completed	Well child
769	485	2	2019-07-12 14:30:00	Completed	Sick visit
770	276	8	2020-11-09 14:30:00	Completed	Telehealth
771	322	4	2021-10-01 15:00:00	Completed	Chronic care
772	312	1	2022-10-05 16:45:00	Completed	Telehealth
773	550	3	2020-08-03 08:45:00	Completed	Sick visit
774	391	1	2019-03-08 12:45:00	Completed	Well child
775	369	7	2023-11-09 15:30:00	Completed	Telehealth
776	179	1	2019-12-24 13:00:00	Completed	Annual physical
777	48	10	2022-12-19 08:45:00	Completed	Telehealth
778	472	4	2025-09-25 08:30:00	Completed	Follow-up
779	27	7	2023-04-21 12:45:00	Completed	Annual physical
780	424	8	2021-11-17 12:15:00	Completed	Annual physical
781	295	8	2026-02-14 11:15:00	Completed	Chronic care
782	465	2	2022-10-21 09:15:00	Completed	Follow-up
783	401	9	2020-08-27 14:30:00	Scheduled	Well child
784	472	7	2024-05-30 10:30:00	Scheduled	Annual physical
785	181	11	2021-08-02 16:15:00	Completed	Annual physical
786	202	4	2020-03-03 14:45:00	No-show	Chronic care
787	478	6	2021-02-02 11:15:00	Completed	Sick visit
788	208	7	2021-07-09 11:15:00	Completed	Annual physical
789	274	1	2025-02-13 09:30:00	Cancelled	Follow-up
790	161	11	2022-01-15 15:30:00	Completed	Well child
791	45	4	2020-03-12 08:30:00	Completed	Well child
792	432	5	2024-09-25 16:45:00	Completed	Sick visit
793	308	9	2025-06-25 16:15:00	Cancelled	Chronic care
794	255	2	2020-06-25 08:00:00	Completed	Telehealth
795	314	9	2024-07-08 16:00:00	Cancelled	Sick visit
796	179	12	2021-01-25 10:30:00	Completed	Well child
797	532	1	2021-03-12 10:15:00	Completed	Chronic care
798	452	2	2021-09-12 15:15:00	Completed	Chronic care
799	597	8	2025-09-06 08:30:00	Completed	Annual physical
800	418	5	2023-10-16 16:00:00	Completed	Chronic care
801	341	10	2025-02-15 16:00:00	Completed	Annual physical
802	100	10	2019-08-28 10:30:00	Completed	Follow-up
803	81	10	2021-07-09 16:30:00	Scheduled	Telehealth
804	454	3	2023-02-09 14:45:00	Completed	Follow-up
805	475	7	2019-04-30 13:30:00	Completed	Annual physical
806	147	5	2024-03-04 15:30:00	Cancelled	Follow-up
807	511	2	2021-10-03 12:15:00	Completed	Telehealth
808	487	9	2025-11-10 09:00:00	Completed	Annual physical
809	428	8	2020-12-17 13:45:00	Completed	Well child
810	150	8	2024-10-02 09:00:00	No-show	Sick visit
811	25	10	2021-05-04 17:00:00	Completed	Follow-up
812	479	7	2024-06-30 11:30:00	Completed	Well child
813	480	2	2023-10-30 12:45:00	No-show	Annual physical
814	547	4	2020-08-23 11:45:00	Scheduled	Annual physical
815	62	2	2019-03-28 11:45:00	Completed	Follow-up
816	328	7	2023-10-01 09:30:00	Completed	Chronic care
817	428	8	2022-12-24 16:30:00	Completed	Well child
818	140	8	2022-01-15 09:15:00	Completed	Sick visit
819	445	9	2024-11-04 14:15:00	Cancelled	Chronic care
820	325	4	2026-04-19 16:00:00	Completed	Annual physical
821	412	7	2020-02-08 09:15:00	Completed	Sick visit
822	277	4	2025-11-09 13:30:00	Completed	Follow-up
823	240	12	2020-03-11 09:00:00	Completed	Follow-up
824	399	1	2021-03-27 13:15:00	Completed	Follow-up
825	561	11	2024-09-24 14:15:00	No-show	Follow-up
826	512	2	2024-01-29 08:15:00	Completed	Follow-up
827	182	7	2019-04-03 08:00:00	Completed	Annual physical
828	360	12	2023-02-06 12:45:00	Scheduled	Follow-up
829	436	3	2021-11-19 08:00:00	Cancelled	Telehealth
830	580	4	2021-07-21 14:15:00	Completed	Follow-up
831	426	9	2025-03-12 13:00:00	Cancelled	Well child
832	565	11	2020-06-13 10:30:00	Completed	Annual physical
833	502	9	2025-04-22 11:15:00	Completed	Telehealth
834	159	1	2024-10-23 14:15:00	Completed	Telehealth
835	387	5	2023-10-13 09:00:00	No-show	Annual physical
836	361	3	2019-07-10 11:00:00	No-show	Annual physical
837	245	8	2025-04-05 08:00:00	Completed	Sick visit
838	493	1	2024-08-19 15:00:00	Completed	Chronic care
839	545	9	2024-03-03 09:30:00	Completed	Telehealth
840	443	7	2020-09-27 12:30:00	No-show	Telehealth
841	508	3	2022-01-27 08:30:00	Completed	Well child
842	297	6	2025-08-30 13:45:00	Completed	Annual physical
843	250	4	2021-01-14 14:30:00	Cancelled	Telehealth
844	246	5	2024-01-08 17:00:00	Completed	Well child
845	266	7	2026-01-11 16:45:00	Scheduled	Chronic care
846	36	1	2023-02-28 11:15:00	Cancelled	Telehealth
847	438	3	2022-03-10 08:00:00	Completed	Sick visit
848	563	4	2025-09-17 16:45:00	Completed	Telehealth
849	472	4	2023-01-17 16:15:00	Completed	Sick visit
850	303	7	2024-02-02 12:15:00	Completed	Follow-up
851	514	3	2021-10-20 15:45:00	No-show	Follow-up
852	194	10	2021-08-09 11:15:00	Completed	Telehealth
853	286	1	2025-08-14 12:15:00	Completed	Annual physical
854	542	12	2020-09-18 09:15:00	Completed	Annual physical
855	80	1	2026-03-18 15:15:00	Completed	Well child
856	457	10	2026-05-08 12:45:00	Completed	Well child
857	321	5	2025-01-04 17:00:00	Completed	Chronic care
858	373	4	2023-02-15 16:30:00	Completed	Follow-up
859	437	4	2024-11-17 09:00:00	Scheduled	Sick visit
860	222	12	2025-07-18 16:00:00	Completed	Chronic care
861	427	9	2024-02-12 08:15:00	Completed	Chronic care
862	464	5	2023-06-11 08:45:00	Completed	Annual physical
863	340	5	2022-06-16 09:00:00	Completed	Telehealth
864	62	2	2020-09-11 14:45:00	Cancelled	Telehealth
865	379	7	2019-05-15 09:30:00	No-show	Telehealth
866	461	3	2024-04-09 16:15:00	Completed	Sick visit
867	258	8	2021-12-18 12:15:00	Completed	Annual physical
868	192	6	2019-08-02 15:45:00	Completed	Telehealth
869	251	7	2019-09-15 10:00:00	Completed	Annual physical
870	169	2	2024-04-23 10:00:00	Completed	Follow-up
871	591	10	2021-02-09 14:45:00	Completed	Telehealth
872	312	1	2021-01-24 08:30:00	Completed	Chronic care
873	232	6	2024-07-15 15:15:00	Completed	Chronic care
874	162	10	2019-09-08 09:30:00	Completed	Annual physical
875	321	5	2019-05-28 12:15:00	Completed	Telehealth
876	131	10	2019-03-26 08:30:00	Completed	Chronic care
877	50	2	2022-07-31 13:15:00	Completed	Follow-up
878	449	7	2023-07-04 12:45:00	Completed	Well child
879	563	10	2020-09-26 14:15:00	Completed	Well child
880	490	3	2019-10-28 09:45:00	Completed	Telehealth
881	126	12	2019-01-12 16:30:00	Scheduled	Well child
882	319	6	2023-01-21 12:00:00	Completed	Sick visit
883	168	2	2022-08-15 13:30:00	Completed	Sick visit
884	221	11	2023-06-18 09:45:00	Completed	Well child
885	213	2	2020-11-17 12:30:00	Completed	Chronic care
886	420	12	2024-01-23 11:45:00	Completed	Follow-up
887	371	6	2019-01-11 10:30:00	Scheduled	Sick visit
888	456	1	2023-02-13 08:15:00	Completed	Annual physical
889	288	9	2023-08-10 12:30:00	Completed	Follow-up
890	530	5	2025-04-11 13:30:00	Completed	Annual physical
891	137	5	2025-09-15 17:00:00	Scheduled	Chronic care
892	452	2	2020-04-30 14:30:00	Completed	Sick visit
893	501	12	2019-09-13 09:15:00	No-show	Well child
894	6	3	2020-02-08 08:45:00	Scheduled	Sick visit
895	252	9	2022-07-24 12:45:00	Completed	Chronic care
896	341	10	2025-06-23 13:15:00	Cancelled	Follow-up
897	176	5	2019-09-17 15:00:00	Completed	Telehealth
898	118	1	2022-04-28 14:30:00	Cancelled	Telehealth
899	150	8	2022-03-24 12:15:00	Completed	Follow-up
900	441	11	2025-11-10 13:00:00	Cancelled	Telehealth
901	572	3	2022-02-02 13:15:00	Completed	Follow-up
902	590	3	2025-03-17 08:30:00	Cancelled	Well child
903	318	12	2025-11-03 09:45:00	Completed	Well child
904	87	6	2019-10-28 08:15:00	Cancelled	Well child
905	315	5	2023-09-29 14:30:00	Completed	Chronic care
906	543	9	2021-07-05 12:30:00	Completed	Annual physical
907	275	5	2023-03-03 09:00:00	Completed	Chronic care
908	409	6	2020-07-11 16:30:00	Cancelled	Chronic care
909	381	1	2022-07-20 10:15:00	Completed	Telehealth
910	411	8	2020-08-03 16:00:00	Scheduled	Sick visit
911	196	6	2023-01-14 11:45:00	Completed	Chronic care
912	346	10	2024-12-27 09:30:00	Completed	Well child
913	286	1	2021-05-11 16:30:00	No-show	Telehealth
914	413	8	2022-12-28 14:30:00	Completed	Annual physical
915	183	1	2025-04-12 12:45:00	No-show	Chronic care
916	402	6	2019-10-27 15:30:00	No-show	Annual physical
917	368	12	2020-06-01 17:00:00	Completed	Follow-up
918	290	6	2026-02-11 12:45:00	Completed	Sick visit
919	57	7	2025-08-12 08:00:00	Cancelled	Sick visit
920	296	4	2019-11-04 16:00:00	Completed	Well child
921	240	12	2019-11-19 11:45:00	Completed	Telehealth
922	138	9	2024-01-23 15:30:00	Completed	Chronic care
923	36	2	2019-08-28 12:15:00	Scheduled	Annual physical
924	533	3	2021-07-03 14:45:00	Completed	Annual physical
925	51	12	2024-11-01 10:30:00	Completed	Sick visit
926	252	9	2019-11-09 14:45:00	Completed	Follow-up
927	46	6	2020-08-03 14:30:00	Completed	Telehealth
928	287	12	2025-09-20 08:45:00	Completed	Chronic care
929	450	1	2022-07-24 13:45:00	Completed	Telehealth
930	403	4	2024-11-02 13:30:00	Completed	Chronic care
931	433	5	2020-05-25 11:45:00	No-show	Chronic care
932	149	4	2025-01-04 16:45:00	Completed	Well child
933	203	11	2024-10-24 15:00:00	Completed	Telehealth
934	323	5	2019-03-05 17:00:00	Completed	Sick visit
935	34	5	2024-03-06 15:00:00	Completed	Annual physical
936	370	9	2022-07-16 11:45:00	Completed	Well child
937	417	4	2024-04-17 08:45:00	Completed	Annual physical
938	108	5	2024-10-21 09:15:00	Completed	Annual physical
939	173	5	2023-06-25 13:00:00	Completed	Sick visit
940	226	8	2023-10-06 09:15:00	Completed	Chronic care
941	343	5	2024-03-09 14:00:00	No-show	Chronic care
942	415	12	2022-07-08 09:00:00	Cancelled	Well child
943	345	1	2020-08-28 11:15:00	Scheduled	Chronic care
944	482	4	2026-03-08 11:00:00	Cancelled	Telehealth
945	81	8	2022-03-10 09:00:00	Completed	Well child
946	392	6	2024-10-17 15:30:00	Completed	Follow-up
947	290	6	2023-03-11 10:00:00	Cancelled	Well child
948	387	5	2020-11-25 17:00:00	Completed	Telehealth
949	93	1	2022-06-10 14:45:00	Completed	Well child
950	216	10	2024-03-09 17:00:00	Completed	Well child
951	344	10	2019-03-12 11:30:00	Completed	Telehealth
952	158	8	2022-08-04 15:30:00	Completed	Telehealth
953	585	2	2023-05-29 16:15:00	Completed	Follow-up
954	539	10	2023-02-18 12:15:00	Completed	Sick visit
955	401	11	2021-10-07 15:30:00	No-show	Annual physical
956	257	2	2019-08-16 17:00:00	Cancelled	Follow-up
957	348	7	2024-07-26 09:00:00	Cancelled	Follow-up
958	552	8	2023-11-01 15:15:00	Completed	Follow-up
959	314	9	2022-09-08 13:45:00	Completed	Sick visit
960	507	9	2024-07-26 14:45:00	Completed	Annual physical
961	394	6	2025-03-02 13:15:00	Completed	Annual physical
962	139	12	2019-08-19 14:30:00	Completed	Chronic care
963	141	12	2024-05-05 14:00:00	Completed	Well child
964	107	1	2026-02-23 13:30:00	Scheduled	Annual physical
965	232	9	2019-02-02 14:00:00	Completed	Telehealth
966	497	7	2025-05-16 11:30:00	Completed	Follow-up
967	204	2	2023-03-20 15:30:00	Cancelled	Follow-up
968	103	8	2019-09-24 12:30:00	No-show	Well child
969	110	5	2020-09-08 12:15:00	Completed	Well child
970	134	11	2019-11-30 09:15:00	Completed	Telehealth
971	120	4	2023-07-19 15:00:00	Completed	Sick visit
972	189	11	2019-09-23 09:30:00	Cancelled	Follow-up
973	22	10	2024-09-14 08:30:00	Completed	Well child
974	49	4	2023-08-17 16:15:00	Completed	Chronic care
975	197	12	2022-03-12 13:30:00	Completed	Chronic care
976	147	9	2024-09-16 16:00:00	Completed	Telehealth
977	588	4	2025-06-26 09:30:00	Completed	Chronic care
978	143	10	2023-09-25 16:45:00	Completed	Telehealth
979	289	9	2023-12-12 12:15:00	Completed	Well child
980	236	6	2019-02-02 16:30:00	Completed	Telehealth
981	339	12	2021-02-27 14:15:00	Cancelled	Annual physical
982	309	9	2021-04-02 13:30:00	Cancelled	Annual physical
983	563	4	2020-10-07 16:45:00	Completed	Sick visit
984	173	10	2024-09-21 16:00:00	Completed	Follow-up
985	159	4	2022-08-13 14:00:00	Completed	Sick visit
986	490	3	2026-03-09 16:45:00	Completed	Annual physical
987	463	11	2025-09-20 13:30:00	Completed	Well child
988	502	9	2019-03-20 15:30:00	Scheduled	Well child
989	247	4	2020-04-17 14:15:00	Completed	Follow-up
990	154	8	2025-03-13 13:30:00	Completed	Sick visit
991	515	5	2024-07-01 10:00:00	Completed	Sick visit
992	342	1	2020-04-22 14:15:00	Cancelled	Annual physical
993	380	7	2020-02-04 11:00:00	Scheduled	Sick visit
994	488	5	2024-05-25 11:30:00	Completed	Well child
995	365	1	2025-09-24 12:45:00	Scheduled	Chronic care
996	25	5	2022-01-29 08:15:00	Completed	Telehealth
997	255	11	2022-12-19 13:30:00	Completed	Sick visit
998	77	6	2021-08-05 15:15:00	No-show	Follow-up
999	78	6	2019-06-14 09:15:00	Completed	Chronic care
1000	125	11	2021-04-05 16:30:00	Scheduled	Telehealth
1001	457	10	2024-07-24 08:30:00	Cancelled	Follow-up
1002	578	8	2021-10-23 12:15:00	Completed	Telehealth
1003	111	1	2025-11-01 09:45:00	No-show	Telehealth
1004	66	4	2021-05-10 11:30:00	Cancelled	Sick visit
1005	372	9	2025-01-05 14:00:00	Completed	Telehealth
1006	264	1	2024-08-08 08:15:00	Cancelled	Follow-up
1007	557	4	2022-06-30 10:45:00	Cancelled	Telehealth
1008	445	9	2021-12-06 16:30:00	Completed	Telehealth
1009	230	10	2022-09-21 13:30:00	Scheduled	Well child
1010	573	9	2024-04-23 15:15:00	Completed	Well child
1011	201	9	2019-07-06 16:15:00	Completed	Annual physical
1012	190	5	2019-07-03 14:45:00	Completed	Follow-up
1013	216	1	2024-01-09 08:45:00	Completed	Sick visit
1014	548	10	2024-03-19 08:45:00	Completed	Follow-up
1015	508	3	2021-12-28 10:15:00	Completed	Chronic care
1016	151	3	2020-03-16 12:00:00	Cancelled	Follow-up
1017	571	7	2019-08-16 09:30:00	Completed	Follow-up
1018	264	1	2024-11-20 13:45:00	Completed	Sick visit
1019	535	5	2024-08-23 10:00:00	Cancelled	Sick visit
1020	243	3	2021-11-05 12:15:00	Completed	Chronic care
1021	42	6	2021-05-05 14:00:00	Completed	Telehealth
1022	283	4	2019-07-01 12:45:00	Completed	Sick visit
1023	463	11	2022-10-04 12:15:00	Scheduled	Annual physical
1024	444	6	2024-08-26 14:00:00	Completed	Annual physical
1025	19	5	2025-08-30 14:30:00	Completed	Annual physical
1026	437	4	2023-07-20 12:45:00	Cancelled	Well child
1027	487	9	2019-08-18 16:00:00	Completed	Telehealth
1028	132	10	2019-01-13 13:45:00	Completed	Annual physical
1029	445	9	2023-12-11 08:15:00	Completed	Sick visit
1030	478	6	2022-12-23 17:00:00	Scheduled	Follow-up
1031	527	8	2020-07-25 11:30:00	Completed	Follow-up
1032	228	7	2025-03-21 08:30:00	Completed	Annual physical
1033	153	8	2023-06-27 13:00:00	No-show	Chronic care
1034	402	8	2022-02-17 15:45:00	Completed	Follow-up
1035	42	6	2024-02-06 09:45:00	Completed	Chronic care
1036	343	5	2025-09-08 16:00:00	Cancelled	Annual physical
1037	566	12	2023-09-08 15:00:00	Completed	Annual physical
1038	287	12	2023-06-12 09:15:00	Completed	Chronic care
1039	551	4	2022-07-22 09:00:00	Completed	Telehealth
1040	14	1	2022-05-03 08:45:00	Completed	Telehealth
1041	429	5	2026-05-12 15:45:00	Completed	Chronic care
1042	453	1	2020-03-18 09:15:00	Completed	Sick visit
1043	392	6	2025-11-23 15:45:00	Completed	Well child
1044	382	11	2022-09-05 13:00:00	Completed	Well child
1045	1	4	2022-03-12 12:30:00	Completed	Well child
1046	386	2	2023-06-20 12:30:00	Completed	Follow-up
1047	163	5	2023-06-23 14:00:00	Completed	Follow-up
1048	371	6	2021-02-22 13:15:00	Completed	Annual physical
1049	326	2	2025-09-30 10:45:00	Completed	Well child
1050	358	8	2025-06-23 08:45:00	Completed	Annual physical
1051	389	5	2022-08-30 11:30:00	Cancelled	Well child
1052	356	4	2024-11-03 13:30:00	Completed	Chronic care
1053	124	1	2021-12-22 13:15:00	Completed	Well child
1054	386	2	2025-02-11 14:30:00	Completed	Sick visit
1055	18	3	2021-03-18 11:00:00	Cancelled	Well child
1056	595	1	2022-06-17 13:30:00	Completed	Annual physical
1057	200	5	2020-04-14 14:15:00	No-show	Telehealth
1058	102	6	2025-05-08 14:15:00	Completed	Annual physical
1059	572	2	2025-01-11 11:00:00	Completed	Follow-up
1060	432	11	2022-12-07 15:15:00	Completed	Follow-up
1061	313	8	2024-04-07 13:45:00	Completed	Well child
1062	396	3	2020-03-12 17:00:00	Completed	Chronic care
1063	20	8	2025-08-22 13:15:00	Completed	Chronic care
1064	283	4	2024-04-01 15:30:00	Completed	Annual physical
1065	104	10	2022-01-12 13:30:00	Scheduled	Well child
1066	591	7	2024-03-24 09:45:00	Completed	Annual physical
1067	549	3	2025-02-03 09:45:00	Completed	Annual physical
1068	589	6	2020-01-15 13:30:00	Completed	Telehealth
1069	179	12	2019-02-15 13:15:00	Completed	Telehealth
1070	560	6	2024-12-02 16:30:00	No-show	Sick visit
1071	139	12	2021-05-04 13:15:00	Completed	Telehealth
1072	519	6	2021-12-31 16:30:00	Completed	Follow-up
1073	570	3	2024-10-18 11:00:00	Completed	Well child
1074	340	6	2019-04-24 13:45:00	Completed	Annual physical
1075	58	11	2021-07-16 15:00:00	Completed	Well child
1076	548	10	2021-03-29 13:30:00	Completed	Sick visit
1077	202	4	2019-10-08 14:00:00	Completed	Sick visit
1078	397	2	2022-01-19 13:30:00	Scheduled	Telehealth
1079	551	4	2022-04-22 11:00:00	Completed	Sick visit
1080	68	4	2023-08-20 09:15:00	Completed	Well child
1081	413	8	2025-10-14 12:45:00	Completed	Telehealth
1082	86	6	2021-08-31 15:15:00	Completed	Telehealth
1083	518	11	2023-12-24 14:45:00	Completed	Well child
1084	519	6	2023-06-21 08:30:00	Scheduled	Telehealth
1085	133	3	2019-08-26 13:30:00	Completed	Chronic care
1086	487	10	2022-10-11 09:45:00	Completed	Telehealth
1087	178	10	2024-10-14 13:30:00	No-show	Follow-up
1088	213	2	2024-01-02 09:15:00	Completed	Sick visit
1089	586	4	2025-11-29 15:15:00	Completed	Chronic care
1090	312	1	2022-02-17 13:30:00	Completed	Well child
1091	2	4	2025-06-19 08:30:00	Completed	Well child
1092	339	12	2021-03-30 10:45:00	Scheduled	Sick visit
1093	534	7	2025-11-24 13:00:00	Completed	Telehealth
1094	103	8	2021-05-27 10:00:00	Completed	Follow-up
1095	585	2	2024-07-17 10:00:00	Completed	Sick visit
1096	386	2	2024-09-04 14:15:00	No-show	Sick visit
1097	595	2	2022-08-05 14:45:00	Completed	Well child
1098	590	3	2020-08-06 08:45:00	Completed	Follow-up
1099	356	4	2023-08-24 11:15:00	Scheduled	Telehealth
1100	246	9	2020-12-17 12:15:00	No-show	Follow-up
1101	228	7	2025-06-08 12:30:00	Scheduled	Telehealth
1102	423	3	2023-02-28 14:00:00	Completed	Telehealth
1103	400	7	2020-06-25 14:00:00	Completed	Follow-up
1104	68	11	2025-04-12 15:00:00	Completed	Telehealth
1105	246	5	2022-09-14 12:15:00	Cancelled	Annual physical
1106	10	1	2021-02-04 13:45:00	Completed	Telehealth
1107	229	3	2025-06-05 12:00:00	Completed	Follow-up
1108	219	8	2024-07-23 13:30:00	Completed	Sick visit
1109	564	6	2022-11-19 12:45:00	Completed	Telehealth
1110	548	9	2024-05-05 08:00:00	Completed	Chronic care
1111	269	9	2019-12-22 13:00:00	Completed	Telehealth
1112	113	11	2026-02-27 14:45:00	No-show	Telehealth
1113	180	2	2021-07-27 14:30:00	Scheduled	Well child
1114	137	7	2023-03-05 12:15:00	Completed	Well child
1115	29	4	2024-05-02 12:15:00	Completed	Well child
1116	414	6	2020-02-27 09:00:00	Completed	Follow-up
1117	565	11	2020-03-28 16:15:00	Completed	Telehealth
1118	451	4	2025-06-02 10:15:00	Completed	Sick visit
1119	324	1	2024-03-15 15:45:00	Cancelled	Telehealth
1120	33	9	2024-03-04 12:00:00	No-show	Telehealth
1121	303	7	2020-09-06 15:15:00	Cancelled	Annual physical
1122	517	4	2023-04-03 09:15:00	Completed	Telehealth
1123	550	3	2024-09-09 11:45:00	Scheduled	Well child
1124	60	5	2022-11-03 14:00:00	Scheduled	Well child
1125	561	8	2024-01-08 13:30:00	Completed	Well child
1126	234	2	2020-05-16 14:00:00	Completed	Telehealth
1127	219	11	2024-07-27 13:15:00	Completed	Follow-up
1128	292	1	2025-07-20 09:30:00	Completed	Well child
1129	140	8	2025-07-31 16:30:00	Completed	Telehealth
1130	199	8	2020-11-12 08:30:00	Completed	Telehealth
1131	536	3	2024-08-30 14:15:00	Completed	Annual physical
1132	279	11	2020-06-01 09:45:00	Completed	Chronic care
1133	193	9	2026-01-06 12:15:00	Completed	Telehealth
1134	541	11	2023-12-12 08:15:00	Completed	Annual physical
1135	189	11	2025-02-07 11:15:00	Completed	Annual physical
1136	489	8	2021-08-31 14:30:00	Completed	Follow-up
1137	187	11	2019-10-22 17:00:00	Completed	Telehealth
1138	521	11	2019-11-10 11:45:00	Completed	Chronic care
1139	479	7	2024-05-17 11:15:00	Completed	Chronic care
1140	71	4	2023-12-23 15:45:00	Cancelled	Well child
1141	114	7	2021-09-11 10:30:00	Scheduled	Annual physical
1142	220	10	2023-10-11 16:45:00	Completed	Sick visit
1143	503	5	2021-07-31 11:45:00	Completed	Telehealth
1144	149	4	2026-02-15 11:15:00	Completed	Annual physical
1145	507	10	2022-07-26 13:15:00	Completed	Follow-up
1146	386	2	2019-02-10 16:30:00	Completed	Chronic care
1147	34	5	2025-07-12 14:15:00	Completed	Sick visit
1148	380	7	2025-12-18 15:00:00	Cancelled	Chronic care
1149	66	4	2024-01-24 09:30:00	Completed	Chronic care
1150	341	10	2024-06-07 13:45:00	Cancelled	Follow-up
1151	341	10	2025-02-22 10:45:00	Completed	Follow-up
1152	341	10	2022-02-13 16:45:00	Completed	Sick visit
1153	281	3	2021-11-06 09:15:00	Completed	Follow-up
1154	413	8	2026-04-19 09:30:00	Completed	Telehealth
1155	577	8	2021-05-24 10:15:00	Completed	Well child
1156	565	11	2021-08-03 09:30:00	Completed	Chronic care
1157	114	7	2026-02-04 11:00:00	Completed	Chronic care
1158	244	10	2019-01-03 13:30:00	No-show	Follow-up
1159	1	4	2020-09-17 14:15:00	Cancelled	Well child
1160	496	3	2020-02-10 09:45:00	Completed	Well child
1161	187	11	2019-10-08 10:30:00	Completed	Annual physical
1162	506	8	2022-09-03 13:30:00	Scheduled	Sick visit
1163	49	4	2019-02-03 13:45:00	Completed	Telehealth
1164	518	11	2025-11-26 15:30:00	Completed	Annual physical
1165	368	12	2022-08-07 09:15:00	Completed	Follow-up
1166	78	7	2022-11-20 08:30:00	Completed	Chronic care
1167	388	8	2021-01-11 16:00:00	Completed	Sick visit
1168	86	6	2022-08-08 08:45:00	Cancelled	Follow-up
1169	170	3	2019-09-26 13:00:00	Completed	Follow-up
1170	263	2	2024-03-19 14:30:00	Completed	Follow-up
1171	583	11	2022-07-21 14:00:00	Completed	Sick visit
1172	553	6	2021-06-14 15:30:00	Completed	Telehealth
1173	546	7	2021-03-03 14:15:00	Completed	Follow-up
1174	155	12	2021-05-07 13:30:00	Completed	Annual physical
1175	357	11	2019-10-06 10:30:00	Completed	Follow-up
1176	359	12	2022-09-25 16:00:00	No-show	Well child
1177	8	6	2025-10-12 12:45:00	Scheduled	Well child
1178	174	1	2021-02-05 09:15:00	Completed	Annual physical
1179	124	12	2025-07-19 08:15:00	Completed	Chronic care
1180	559	7	2024-04-17 14:00:00	Completed	Well child
1181	443	7	2023-10-24 08:15:00	Completed	Telehealth
1182	574	5	2023-05-07 14:00:00	Completed	Well child
1183	484	7	2019-11-10 16:00:00	Scheduled	Telehealth
1184	450	11	2023-04-05 08:15:00	Cancelled	Annual physical
1185	113	11	2022-08-13 14:30:00	Completed	Telehealth
1186	542	12	2023-07-20 15:00:00	Completed	Sick visit
1187	77	6	2024-07-17 10:15:00	Completed	Follow-up
1188	372	9	2023-04-17 10:30:00	Cancelled	Well child
1189	549	3	2020-04-28 11:00:00	Completed	Telehealth
1190	571	7	2023-05-10 10:00:00	Cancelled	Chronic care
1191	403	4	2021-09-12 13:00:00	Completed	Annual physical
1192	24	9	2020-11-01 15:00:00	Completed	Follow-up
1193	61	3	2024-04-29 15:15:00	Completed	Follow-up
1194	241	11	2020-08-15 11:00:00	Completed	Telehealth
1195	241	11	2025-12-08 10:00:00	Completed	Telehealth
1196	480	2	2024-10-04 13:45:00	Completed	Sick visit
1197	35	8	2020-03-17 13:30:00	Completed	Annual physical
1198	301	6	2023-11-12 11:00:00	Completed	Follow-up
1199	592	12	2019-11-18 08:00:00	Completed	Sick visit
1200	44	5	2020-12-08 15:00:00	No-show	Well child
1201	530	2	2026-05-22 09:15:00	Completed	Chronic care
1202	148	5	2019-08-19 16:30:00	No-show	Sick visit
1203	167	9	2020-01-12 14:30:00	Completed	Annual physical
1204	301	6	2022-04-02 13:15:00	No-show	Well child
1205	12	4	2025-07-01 08:45:00	Completed	Well child
1206	471	8	2022-05-09 13:45:00	Completed	Annual physical
1207	297	6	2024-06-24 13:15:00	Completed	Well child
1208	427	3	2021-06-11 15:00:00	Completed	Follow-up
1209	488	5	2020-09-21 08:00:00	Completed	Follow-up
1210	533	2	2025-01-02 13:00:00	Completed	Telehealth
1211	264	1	2024-02-19 10:00:00	Cancelled	Sick visit
1212	17	6	2023-09-26 11:15:00	Completed	Well child
1213	426	7	2025-02-03 12:15:00	Cancelled	Sick visit
1214	228	7	2022-06-22 16:00:00	Completed	Sick visit
1215	9	8	2021-06-21 08:30:00	Completed	Telehealth
1216	526	2	2023-05-28 14:30:00	Completed	Annual physical
1217	217	4	2026-01-29 11:30:00	Completed	Telehealth
1218	219	9	2024-03-15 16:00:00	Completed	Sick visit
1219	221	11	2023-01-21 13:45:00	Completed	Follow-up
1220	227	3	2023-12-27 09:00:00	Cancelled	Follow-up
1221	531	6	2026-01-03 15:00:00	Completed	Telehealth
1222	64	11	2019-06-23 10:30:00	Completed	Telehealth
1223	392	8	2020-05-01 11:45:00	Completed	Sick visit
1224	479	7	2025-10-22 17:00:00	Completed	Well child
1225	411	8	2020-12-06 09:15:00	Completed	Sick visit
1226	181	11	2025-08-03 09:30:00	Completed	Chronic care
1227	413	8	2019-09-03 09:45:00	Completed	Well child
1228	276	8	2023-12-19 11:45:00	Scheduled	Telehealth
1229	195	8	2019-09-08 08:15:00	Completed	Chronic care
1230	286	1	2025-10-04 14:45:00	Completed	Chronic care
1231	33	9	2021-01-27 09:45:00	Completed	Well child
1232	425	9	2025-08-29 12:00:00	Scheduled	Well child
1233	223	8	2019-12-11 14:15:00	Scheduled	Well child
1234	76	1	2022-01-01 14:15:00	Completed	Annual physical
1235	83	8	2025-08-13 14:00:00	Completed	Annual physical
1236	317	6	2024-04-09 12:30:00	Cancelled	Telehealth
1237	265	4	2025-10-16 09:30:00	Completed	Sick visit
1238	175	4	2023-02-21 08:15:00	Completed	Annual physical
1239	372	9	2025-05-20 12:45:00	Completed	Chronic care
1240	523	7	2025-12-11 11:00:00	Cancelled	Well child
1241	311	11	2026-05-01 16:45:00	Completed	Follow-up
1242	396	2	2025-05-10 14:30:00	Completed	Sick visit
1243	9	8	2023-07-08 14:15:00	Completed	Follow-up
1244	227	3	2023-10-30 09:15:00	Completed	Well child
1245	548	10	2024-09-26 14:00:00	Completed	Chronic care
1246	552	8	2023-12-02 13:00:00	Completed	Telehealth
1247	191	5	2022-02-04 13:15:00	Completed	Sick visit
1248	533	2	2020-08-08 14:00:00	Completed	Well child
1249	177	12	2025-08-08 09:00:00	Completed	Chronic care
1250	480	2	2021-08-29 14:30:00	No-show	Annual physical
1251	384	5	2026-03-05 13:30:00	Completed	Annual physical
1252	343	5	2021-03-08 09:30:00	Completed	Chronic care
1253	171	12	2023-02-12 13:00:00	Scheduled	Sick visit
1254	68	9	2022-02-21 12:30:00	Completed	Telehealth
1255	169	2	2024-09-16 08:00:00	Completed	Follow-up
1256	60	5	2021-04-20 16:15:00	Completed	Follow-up
1257	150	8	2021-10-22 16:30:00	Completed	Annual physical
1258	10	1	2022-11-23 10:00:00	Completed	Well child
1259	427	9	2023-08-21 10:15:00	Completed	Annual physical
1260	419	12	2025-06-18 13:00:00	Completed	Well child
1261	494	8	2026-04-19 15:30:00	Completed	Sick visit
1262	273	6	2021-02-01 16:45:00	Scheduled	Telehealth
1263	449	7	2022-10-02 15:30:00	Completed	Follow-up
1264	48	10	2025-05-11 10:15:00	Completed	Sick visit
1265	523	7	2022-03-24 14:00:00	Scheduled	Telehealth
1266	505	3	2026-03-26 15:45:00	Completed	Follow-up
1267	401	11	2022-03-16 14:00:00	Completed	Sick visit
1268	352	10	2019-03-25 08:00:00	Completed	Well child
1269	152	7	2025-11-20 15:00:00	No-show	Follow-up
1270	355	2	2023-03-03 14:15:00	Completed	Follow-up
1271	204	2	2020-04-17 10:00:00	Cancelled	Sick visit
1272	109	7	2024-07-15 10:30:00	Completed	Well child
1273	161	11	2026-01-05 12:15:00	Cancelled	Well child
1274	61	5	2023-08-14 14:15:00	Completed	Telehealth
1275	318	12	2026-02-21 10:00:00	Completed	Well child
1276	86	6	2020-07-24 14:45:00	Completed	Well child
1277	186	4	2024-10-26 11:30:00	Completed	Telehealth
1278	430	12	2023-08-21 14:00:00	Completed	Chronic care
1279	430	12	2019-12-27 16:45:00	Completed	Well child
1280	360	12	2022-11-11 16:45:00	Completed	Follow-up
1281	454	3	2021-09-19 10:00:00	Completed	Follow-up
1282	83	8	2019-04-30 09:30:00	Cancelled	Follow-up
1283	284	5	2024-05-26 13:00:00	Completed	Follow-up
1284	20	8	2022-09-06 08:45:00	Scheduled	Chronic care
1285	222	12	2023-10-07 12:45:00	Completed	Sick visit
1286	463	12	2023-03-07 13:15:00	Scheduled	Telehealth
1287	559	7	2025-12-29 16:15:00	Completed	Follow-up
1288	512	2	2026-01-05 08:00:00	Completed	Telehealth
1289	595	1	2025-06-29 13:00:00	No-show	Follow-up
1290	278	3	2022-09-12 14:45:00	Completed	Telehealth
1291	346	10	2024-11-09 13:15:00	Cancelled	Well child
1292	168	2	2019-06-22 14:30:00	Completed	Sick visit
1293	121	7	2019-08-08 12:00:00	Completed	Well child
1294	277	4	2021-08-19 09:30:00	Completed	Sick visit
1295	473	5	2019-10-10 11:15:00	Completed	Well child
1296	572	2	2019-08-02 15:45:00	Scheduled	Sick visit
1297	84	7	2023-10-02 17:00:00	Completed	Chronic care
1298	483	5	2024-07-26 10:30:00	Cancelled	Sick visit
1299	167	9	2025-03-28 10:15:00	No-show	Annual physical
1300	594	10	2020-05-28 16:30:00	Completed	Well child
1301	136	9	2021-03-08 14:00:00	Cancelled	Well child
1302	489	8	2020-01-01 09:00:00	Cancelled	Sick visit
1303	277	4	2021-10-29 13:30:00	Scheduled	Annual physical
1304	44	12	2024-10-18 15:00:00	Completed	Telehealth
1305	467	10	2025-03-11 13:00:00	Completed	Annual physical
1306	31	11	2026-04-15 11:30:00	Completed	Follow-up
1307	263	2	2025-09-19 11:00:00	Completed	Follow-up
1308	500	4	2020-04-14 10:45:00	No-show	Telehealth
1309	406	8	2023-12-03 08:15:00	Completed	Telehealth
1310	333	2	2023-04-13 15:30:00	No-show	Sick visit
1311	473	2	2019-09-18 13:45:00	Completed	Telehealth
1312	176	1	2026-05-18 10:45:00	Completed	Sick visit
1313	45	4	2019-10-31 11:30:00	Completed	Telehealth
1314	520	6	2020-03-22 14:00:00	Cancelled	Sick visit
1315	73	6	2020-12-12 10:00:00	Cancelled	Well child
1316	510	5	2024-07-30 11:45:00	Completed	Chronic care
1317	166	10	2022-04-25 15:45:00	Scheduled	Follow-up
1318	454	3	2024-02-29 08:45:00	Completed	Chronic care
1319	508	12	2024-09-08 16:30:00	Completed	Annual physical
1320	362	6	2020-03-23 11:45:00	Completed	Well child
1321	594	10	2024-05-07 09:15:00	Completed	Follow-up
1322	59	10	2024-06-09 14:30:00	Completed	Sick visit
1323	135	3	2019-04-01 12:15:00	Completed	Well child
1324	438	3	2026-01-05 15:15:00	Completed	Telehealth
1325	186	4	2021-02-15 09:00:00	Completed	Well child
1326	223	8	2024-03-21 17:00:00	Completed	Telehealth
1327	484	2	2022-01-16 11:30:00	Completed	Follow-up
1328	589	12	2022-03-09 14:15:00	Completed	Follow-up
1329	367	12	2021-12-11 14:30:00	Completed	Chronic care
1330	86	6	2022-01-16 15:15:00	Scheduled	Sick visit
1331	542	12	2021-05-27 13:45:00	Completed	Follow-up
1332	588	4	2020-08-30 12:45:00	Completed	Annual physical
1333	482	4	2025-11-06 17:00:00	Completed	Telehealth
1334	25	8	2019-02-17 16:30:00	Completed	Well child
1335	485	2	2026-05-06 14:15:00	Scheduled	Follow-up
1336	360	12	2020-09-28 12:30:00	Scheduled	Well child
1337	74	8	2024-09-29 14:00:00	Completed	Chronic care
1338	391	1	2024-04-01 16:45:00	Scheduled	Well child
1339	397	2	2025-06-04 13:00:00	Cancelled	Chronic care
1340	468	7	2022-02-21 15:45:00	Completed	Sick visit
1341	365	4	2019-07-20 12:30:00	Completed	Sick visit
1342	338	11	2025-03-26 15:45:00	Completed	Well child
1343	49	4	2019-06-16 12:00:00	Completed	Follow-up
1344	224	1	2022-07-08 11:00:00	No-show	Telehealth
1345	491	5	2023-01-24 16:30:00	Completed	Sick visit
1346	244	10	2020-08-14 10:15:00	Completed	Chronic care
1347	423	10	2025-05-25 13:45:00	Completed	Follow-up
1348	18	12	2024-03-18 16:45:00	Completed	Well child
1349	537	5	2021-07-13 16:15:00	Completed	Well child
1350	48	10	2022-06-01 08:15:00	Completed	Sick visit
1351	257	2	2025-09-28 08:00:00	No-show	Follow-up
1352	506	8	2020-10-18 16:15:00	Completed	Sick visit
1353	321	1	2024-02-06 08:00:00	Completed	Annual physical
1354	21	12	2023-07-07 15:00:00	Scheduled	Well child
1355	472	4	2024-11-25 10:30:00	Completed	Well child
1356	557	10	2023-03-24 09:45:00	Completed	Well child
1357	18	4	2020-02-09 13:00:00	Scheduled	Follow-up
1358	117	4	2021-12-07 13:30:00	Completed	Follow-up
1359	412	7	2025-05-06 12:00:00	Completed	Chronic care
1360	485	2	2019-09-27 12:45:00	Completed	Follow-up
1361	90	10	2021-08-12 14:45:00	Completed	Telehealth
1362	493	1	2025-03-10 16:30:00	Scheduled	Chronic care
1363	431	2	2025-12-17 12:15:00	Completed	Annual physical
1364	319	11	2019-04-30 08:45:00	Scheduled	Telehealth
1365	25	10	2020-12-15 10:15:00	Cancelled	Follow-up
1366	596	9	2021-05-31 15:30:00	Completed	Follow-up
1367	128	6	2021-10-29 16:15:00	Completed	Sick visit
1368	106	8	2022-02-27 11:30:00	Completed	Telehealth
1369	188	9	2023-02-15 09:45:00	Completed	Follow-up
1370	441	6	2021-07-27 12:15:00	Completed	Well child
1371	322	4	2020-01-15 09:30:00	Completed	Chronic care
1372	49	4	2024-12-30 13:00:00	Completed	Chronic care
1373	177	12	2023-06-12 09:30:00	Cancelled	Telehealth
1374	125	11	2025-11-01 08:15:00	Completed	Telehealth
1375	195	8	2019-01-17 15:15:00	Cancelled	Follow-up
1376	40	5	2019-05-30 15:15:00	No-show	Telehealth
1377	534	7	2024-09-09 17:00:00	Completed	Well child
1378	395	8	2019-09-30 11:45:00	Completed	Well child
1379	237	10	2019-05-23 10:00:00	Completed	Sick visit
1380	60	5	2022-10-17 14:15:00	Completed	Sick visit
1381	581	4	2021-07-18 14:15:00	Completed	Telehealth
1382	508	3	2025-08-10 08:15:00	No-show	Well child
1383	18	4	2024-07-23 15:30:00	Completed	Annual physical
1384	206	11	2022-02-09 16:30:00	Completed	Well child
1385	117	4	2021-06-07 08:30:00	Scheduled	Telehealth
1386	72	12	2022-10-15 15:15:00	Completed	Well child
1387	258	8	2019-11-18 08:00:00	Scheduled	Annual physical
1388	121	7	2021-07-17 17:00:00	Completed	Chronic care
1389	540	3	2022-12-23 16:45:00	Completed	Sick visit
1390	412	7	2023-07-26 10:30:00	Completed	Annual physical
1391	516	12	2019-08-22 11:00:00	Completed	Chronic care
1392	563	4	2021-01-18 14:45:00	Completed	Follow-up
1393	46	6	2019-09-28 13:00:00	Completed	Chronic care
1394	360	5	2025-01-26 13:30:00	Completed	Chronic care
1395	331	1	2025-11-06 08:45:00	Completed	Annual physical
1396	156	10	2022-01-19 13:45:00	Completed	Annual physical
1397	61	3	2025-01-31 15:45:00	Completed	Annual physical
1398	288	9	2023-05-10 08:00:00	Completed	Sick visit
1399	492	7	2019-08-26 10:30:00	Completed	Annual physical
1400	81	4	2024-04-28 12:45:00	Completed	Sick visit
1401	88	7	2023-11-25 13:15:00	Completed	Sick visit
1402	386	2	2019-11-04 08:00:00	Completed	Telehealth
1403	69	10	2021-05-25 13:30:00	Completed	Chronic care
1404	309	10	2024-03-04 09:45:00	Scheduled	Follow-up
1405	534	12	2020-09-22 15:45:00	Cancelled	Annual physical
1406	63	11	2024-04-07 16:15:00	Completed	Chronic care
1407	16	2	2020-10-17 13:00:00	Completed	Well child
1408	225	6	2025-04-25 10:15:00	Completed	Well child
1409	102	3	2025-08-21 11:30:00	Scheduled	Chronic care
1410	187	11	2022-02-02 13:00:00	Completed	Annual physical
1411	418	1	2021-02-02 11:15:00	Completed	Telehealth
1412	318	12	2019-06-30 16:00:00	Completed	Sick visit
1413	21	12	2024-09-14 15:00:00	Completed	Sick visit
1414	285	10	2019-05-15 12:30:00	Completed	Telehealth
1415	63	12	2020-08-23 10:45:00	Cancelled	Chronic care
1416	198	6	2019-07-27 11:30:00	Completed	Telehealth
1417	554	6	2022-08-13 12:30:00	Scheduled	Telehealth
1418	233	8	2026-05-04 10:00:00	Cancelled	Annual physical
1419	501	12	2019-07-19 17:00:00	Completed	Sick visit
1420	593	6	2019-06-19 08:45:00	Completed	Chronic care
1421	162	10	2021-06-15 08:15:00	Completed	Follow-up
1422	67	3	2023-04-10 10:45:00	Completed	Well child
1423	379	1	2024-03-14 10:30:00	Completed	Sick visit
1424	132	10	2023-02-24 13:15:00	Completed	Chronic care
1425	303	7	2022-09-19 10:00:00	Completed	Sick visit
1426	359	12	2023-12-28 13:00:00	Completed	Telehealth
1427	506	8	2022-03-08 15:30:00	Completed	Sick visit
1428	297	6	2025-04-04 14:15:00	Completed	Annual physical
1429	43	6	2024-12-20 09:15:00	No-show	Annual physical
1430	514	3	2022-07-29 13:15:00	Completed	Annual physical
1431	366	12	2023-03-20 12:45:00	Scheduled	Sick visit
1432	306	7	2021-10-28 10:15:00	Completed	Chronic care
1433	572	2	2019-02-26 14:30:00	Cancelled	Telehealth
1434	331	1	2023-08-02 10:00:00	Completed	Annual physical
1435	193	9	2025-03-11 14:45:00	Completed	Follow-up
1436	546	7	2024-05-11 12:30:00	Completed	Annual physical
1437	304	11	2019-03-21 10:15:00	Completed	Chronic care
1438	87	6	2020-10-27 13:45:00	Completed	Telehealth
1439	525	6	2025-09-18 09:45:00	Completed	Chronic care
1440	396	3	2025-09-14 08:30:00	Completed	Annual physical
1441	100	4	2021-01-16 15:45:00	Scheduled	Annual physical
1442	330	8	2020-03-01 09:15:00	Completed	Telehealth
1443	543	9	2024-05-01 08:30:00	Completed	Chronic care
1444	333	2	2019-06-25 09:45:00	Completed	Telehealth
1445	235	3	2023-10-09 11:45:00	Scheduled	Chronic care
1446	220	6	2021-04-18 13:45:00	Completed	Sick visit
1447	321	5	2021-04-04 14:30:00	Completed	Telehealth
1448	520	6	2020-05-04 16:45:00	Scheduled	Follow-up
1449	314	9	2019-09-17 15:30:00	Cancelled	Telehealth
1450	118	1	2021-03-28 08:45:00	Completed	Well child
1451	264	1	2026-05-12 12:45:00	Completed	Chronic care
1452	403	4	2020-12-20 09:00:00	No-show	Sick visit
1453	518	8	2019-11-02 17:00:00	Completed	Telehealth
1454	434	3	2024-09-06 15:30:00	Completed	Well child
1455	323	3	2019-02-20 11:30:00	Cancelled	Follow-up
1456	585	9	2024-11-23 14:00:00	Completed	Well child
1457	77	6	2026-01-24 10:15:00	Completed	Follow-up
1458	297	10	2024-05-23 16:30:00	Completed	Chronic care
1459	245	8	2024-05-24 16:00:00	Completed	Sick visit
1460	405	7	2026-04-30 16:15:00	Completed	Chronic care
1461	518	11	2019-04-08 14:30:00	Completed	Well child
1462	491	5	2019-08-24 09:15:00	Completed	Well child
1463	419	5	2024-02-02 17:00:00	Completed	Sick visit
1464	111	1	2020-06-28 16:45:00	Completed	Well child
1465	548	10	2020-11-05 11:45:00	Completed	Chronic care
1466	281	3	2023-12-02 14:45:00	Completed	Telehealth
1467	111	5	2022-12-16 10:15:00	Completed	Annual physical
1468	384	5	2019-06-26 11:30:00	Cancelled	Annual physical
1469	408	10	2021-07-08 08:15:00	Cancelled	Annual physical
1470	207	11	2021-01-17 15:00:00	Cancelled	Annual physical
1471	319	11	2024-07-24 16:15:00	Completed	Annual physical
1472	312	1	2025-06-20 10:15:00	Completed	Annual physical
1473	464	9	2019-08-10 08:15:00	Completed	Sick visit
1474	186	4	2019-06-28 08:00:00	Cancelled	Well child
1475	565	6	2025-04-14 15:00:00	Completed	Follow-up
1476	415	12	2025-02-27 15:30:00	Completed	Telehealth
1477	384	5	2022-08-04 11:15:00	Completed	Follow-up
1478	132	11	2025-05-19 16:15:00	Cancelled	Well child
1479	394	6	2021-10-09 12:00:00	Completed	Sick visit
1480	229	3	2024-11-07 16:15:00	Completed	Annual physical
1481	4	12	2020-08-10 08:30:00	Completed	Well child
1482	370	9	2023-03-13 08:15:00	Completed	Well child
1483	446	8	2020-07-21 15:30:00	Completed	Sick visit
1484	393	9	2022-01-29 16:30:00	No-show	Sick visit
1485	43	6	2026-03-09 09:45:00	Cancelled	Chronic care
1486	207	11	2024-06-29 14:45:00	Completed	Sick visit
1487	285	9	2026-03-04 15:00:00	Scheduled	Telehealth
1488	349	10	2019-08-06 09:30:00	Completed	Chronic care
1489	434	1	2023-06-26 08:15:00	No-show	Annual physical
1490	469	12	2021-04-29 08:30:00	Completed	Follow-up
1491	27	4	2020-03-03 12:30:00	No-show	Telehealth
1492	439	6	2025-07-29 15:00:00	Completed	Chronic care
1493	499	7	2021-04-21 12:30:00	Completed	Chronic care
1494	53	8	2024-11-29 14:15:00	Completed	Follow-up
1495	181	11	2020-03-31 12:45:00	Completed	Sick visit
1496	145	4	2020-12-30 11:00:00	Completed	Well child
1497	27	4	2024-09-16 11:30:00	Completed	Telehealth
1498	536	3	2024-11-10 14:00:00	Completed	Well child
1499	123	8	2025-12-09 16:00:00	Completed	Chronic care
1500	574	5	2025-04-08 15:45:00	Completed	Annual physical
1501	17	5	2026-01-04 09:45:00	Completed	Annual physical
1502	177	1	2023-11-06 14:15:00	Completed	Sick visit
1503	297	6	2024-04-04 13:15:00	Cancelled	Well child
1504	592	4	2022-03-24 15:00:00	Scheduled	Telehealth
1505	28	3	2025-09-20 16:45:00	Completed	Telehealth
1506	396	3	2022-12-03 08:30:00	Completed	Well child
1507	313	8	2022-04-27 16:00:00	Completed	Sick visit
1508	410	1	2025-02-15 13:45:00	Scheduled	Sick visit
1509	595	1	2020-09-23 08:15:00	Completed	Annual physical
1510	235	3	2023-01-13 16:30:00	Completed	Follow-up
1511	454	3	2022-02-22 14:30:00	No-show	Telehealth
1512	123	1	2022-01-11 08:15:00	Completed	Well child
1513	208	7	2020-06-27 14:45:00	Completed	Chronic care
1514	453	9	2021-04-17 16:45:00	Completed	Sick visit
1515	69	10	2022-08-27 09:15:00	Cancelled	Follow-up
1516	229	3	2025-01-17 10:15:00	Completed	Chronic care
1517	441	6	2019-07-26 15:45:00	Completed	Telehealth
1518	493	1	2019-11-18 16:00:00	No-show	Follow-up
1519	537	5	2023-09-21 15:00:00	Completed	Telehealth
1520	341	10	2023-07-18 09:45:00	Scheduled	Well child
1521	473	5	2019-02-04 14:45:00	Completed	Chronic care
1522	378	4	2019-12-09 15:45:00	No-show	Telehealth
1523	463	11	2024-05-10 15:00:00	Scheduled	Telehealth
1524	338	11	2023-08-08 15:45:00	Completed	Follow-up
1525	12	4	2024-04-05 09:30:00	Completed	Annual physical
1526	72	12	2025-08-04 15:30:00	Completed	Follow-up
1527	489	8	2020-07-10 11:45:00	Completed	Well child
1528	495	4	2020-01-26 09:00:00	Completed	Telehealth
1529	98	9	2020-05-27 10:00:00	Completed	Annual physical
1530	530	5	2024-08-10 14:30:00	Completed	Sick visit
1531	184	2	2019-05-20 15:30:00	Cancelled	Annual physical
1532	591	10	2026-03-06 15:15:00	Completed	Sick visit
1533	244	10	2024-08-28 16:45:00	Completed	Sick visit
1534	516	12	2021-05-04 08:30:00	Completed	Chronic care
1535	378	4	2020-01-29 09:00:00	Completed	Sick visit
1536	170	9	2024-11-13 13:45:00	Completed	Follow-up
1537	236	11	2021-02-24 13:15:00	Completed	Sick visit
1538	218	12	2020-03-11 12:45:00	Completed	Chronic care
1539	98	5	2026-03-30 14:45:00	Scheduled	Chronic care
1540	329	11	2021-02-16 12:00:00	Completed	Telehealth
1541	55	9	2024-04-14 11:00:00	Completed	Chronic care
1542	20	8	2019-11-20 13:30:00	Completed	Follow-up
1543	346	10	2026-03-07 16:00:00	Cancelled	Follow-up
1544	548	10	2025-08-23 14:00:00	Completed	Chronic care
1545	586	4	2022-10-12 16:30:00	Completed	Chronic care
1546	167	9	2025-10-05 08:45:00	Scheduled	Annual physical
1547	338	11	2024-12-26 13:15:00	Completed	Follow-up
1548	311	11	2024-07-23 10:15:00	Completed	Telehealth
1549	95	9	2025-05-08 13:00:00	No-show	Well child
1550	45	4	2025-05-30 16:30:00	Completed	Follow-up
1551	439	6	2025-11-15 13:45:00	Completed	Telehealth
1552	586	4	2026-01-24 13:45:00	Completed	Telehealth
1553	224	1	2020-05-26 14:00:00	Completed	Telehealth
1554	97	3	2020-08-13 14:00:00	Completed	Sick visit
1555	502	9	2024-03-26 10:15:00	Completed	Sick visit
1556	475	7	2025-09-19 17:00:00	Completed	Telehealth
1557	182	4	2022-01-02 10:00:00	Completed	Follow-up
1558	321	5	2023-09-22 09:45:00	Completed	Chronic care
1559	347	1	2026-01-18 15:00:00	Completed	Well child
1560	163	5	2019-08-30 16:15:00	Completed	Annual physical
1561	181	11	2023-08-22 10:45:00	Completed	Annual physical
1562	540	4	2024-02-19 12:30:00	Scheduled	Sick visit
1563	136	9	2025-04-15 10:45:00	Completed	Telehealth
1564	553	10	2024-04-08 14:15:00	Completed	Chronic care
1565	318	12	2020-11-05 08:30:00	Cancelled	Annual physical
1566	352	9	2024-03-12 08:00:00	Scheduled	Follow-up
1567	290	6	2023-10-13 16:45:00	Completed	Telehealth
1568	301	6	2022-10-15 14:45:00	Completed	Sick visit
1569	353	12	2023-10-23 17:00:00	Completed	Well child
1570	142	12	2022-05-28 12:00:00	Completed	Follow-up
1571	457	4	2021-08-01 11:00:00	Scheduled	Chronic care
1572	287	2	2022-03-18 11:45:00	Completed	Well child
1573	557	10	2025-04-02 15:00:00	Completed	Follow-up
1574	168	2	2021-10-21 14:15:00	Completed	Telehealth
1575	265	1	2020-08-09 13:45:00	Completed	Annual physical
1576	287	12	2019-03-22 15:30:00	Cancelled	Follow-up
1577	256	6	2025-08-12 10:00:00	Completed	Annual physical
1578	209	1	2025-07-04 14:45:00	Completed	Telehealth
1579	20	8	2022-03-05 14:45:00	Completed	Chronic care
1580	69	10	2025-03-07 08:45:00	Completed	Annual physical
1581	124	10	2026-03-04 15:15:00	Completed	Well child
1582	560	6	2024-05-11 15:45:00	Completed	Follow-up
1583	551	4	2020-02-21 15:00:00	Completed	Chronic care
1584	205	10	2021-03-11 13:15:00	Cancelled	Sick visit
1585	102	3	2025-08-01 16:30:00	Cancelled	Telehealth
1586	160	10	2019-07-16 16:30:00	Completed	Annual physical
1587	468	7	2021-08-01 12:15:00	Completed	Well child
1588	345	1	2022-04-06 17:00:00	Completed	Sick visit
1589	371	6	2024-04-08 14:00:00	Completed	Telehealth
1590	80	10	2023-10-20 09:00:00	Scheduled	Well child
1591	6	3	2019-10-25 10:15:00	Completed	Telehealth
1592	342	1	2022-08-27 14:00:00	Completed	Follow-up
1593	78	7	2023-09-11 13:45:00	Scheduled	Telehealth
1594	526	2	2021-11-29 12:00:00	Cancelled	Chronic care
1595	150	8	2022-03-07 08:30:00	Completed	Chronic care
1596	109	7	2021-06-10 13:00:00	Completed	Follow-up
1597	10	1	2023-10-16 14:30:00	Completed	Well child
1598	178	8	2021-12-11 08:00:00	No-show	Telehealth
1599	517	9	2023-05-21 15:00:00	Scheduled	Well child
1600	135	8	2020-08-12 10:00:00	Completed	Well child
1601	92	9	2023-07-27 16:45:00	Completed	Annual physical
1602	372	9	2021-05-22 10:45:00	Completed	Sick visit
1603	551	4	2023-03-04 09:45:00	Completed	Telehealth
1604	154	8	2019-07-04 08:00:00	Completed	Well child
1605	568	4	2025-02-08 11:15:00	Completed	Chronic care
1606	15	8	2022-12-06 10:15:00	Completed	Well child
1607	521	11	2023-02-18 08:00:00	Completed	Sick visit
1608	236	6	2022-07-25 16:00:00	Cancelled	Sick visit
1609	552	8	2023-07-18 09:15:00	Completed	Sick visit
1610	427	9	2026-04-10 10:00:00	Completed	Telehealth
1611	402	6	2019-07-18 09:45:00	Completed	Follow-up
1612	370	9	2020-11-11 10:45:00	Scheduled	Annual physical
1613	520	6	2020-01-07 09:00:00	Scheduled	Sick visit
1614	346	10	2021-10-09 12:00:00	Completed	Chronic care
1615	361	1	2019-03-04 08:00:00	Completed	Chronic care
1616	6	3	2022-07-09 10:15:00	Completed	Annual physical
1617	373	4	2023-10-31 13:45:00	Completed	Annual physical
1618	123	1	2020-01-07 13:00:00	Completed	Telehealth
1619	394	6	2021-09-25 08:45:00	Completed	Telehealth
1620	588	4	2022-05-24 11:45:00	Completed	Follow-up
1621	250	4	2022-05-20 11:45:00	No-show	Well child
1622	260	2	2019-09-24 10:15:00	Completed	Chronic care
1623	149	4	2019-06-26 08:30:00	Completed	Follow-up
1624	493	11	2023-12-25 14:15:00	Completed	Chronic care
1625	328	7	2025-09-19 13:00:00	No-show	Telehealth
1626	149	4	2019-09-25 16:00:00	Completed	Sick visit
1627	373	4	2021-01-18 15:00:00	Completed	Telehealth
1628	184	2	2023-09-23 10:45:00	Completed	Well child
1629	24	6	2020-07-27 11:45:00	Completed	Annual physical
1630	417	4	2024-12-28 10:30:00	Cancelled	Telehealth
1631	284	7	2022-03-03 08:45:00	Completed	Chronic care
1632	213	2	2020-02-13 08:00:00	Completed	Chronic care
1633	237	10	2020-08-07 11:00:00	Scheduled	Telehealth
1634	373	4	2019-07-30 08:15:00	Completed	Well child
1635	216	1	2019-03-14 08:30:00	Cancelled	Telehealth
1636	446	12	2026-01-21 08:15:00	No-show	Annual physical
1637	12	4	2026-03-19 09:45:00	Completed	Sick visit
1638	574	11	2019-10-26 13:15:00	No-show	Follow-up
1639	183	1	2020-08-20 08:30:00	Completed	Telehealth
1640	372	8	2023-02-04 11:15:00	Completed	Annual physical
1641	401	11	2023-02-19 13:45:00	Completed	Well child
1642	406	8	2022-05-12 08:45:00	Completed	Well child
1643	375	10	2020-09-24 13:30:00	Scheduled	Sick visit
1644	157	1	2024-07-29 08:30:00	Scheduled	Well child
1645	506	8	2020-04-19 10:15:00	Completed	Chronic care
1646	385	9	2021-03-04 15:45:00	Completed	Telehealth
1647	281	3	2026-03-28 09:45:00	Completed	Chronic care
1648	445	10	2019-04-10 11:00:00	No-show	Sick visit
1649	9	8	2019-10-07 12:30:00	Completed	Follow-up
1650	357	11	2024-12-10 15:00:00	Scheduled	Telehealth
1651	470	8	2023-10-19 12:15:00	Completed	Telehealth
1652	308	3	2022-06-07 14:30:00	No-show	Follow-up
1653	272	1	2022-04-12 09:15:00	Completed	Chronic care
1654	577	8	2024-12-12 14:15:00	Completed	Chronic care
1655	204	2	2025-01-16 12:15:00	Completed	Sick visit
1656	119	8	2021-06-10 11:30:00	Completed	Sick visit
1657	486	3	2025-07-26 10:15:00	Completed	Telehealth
1658	134	7	2024-12-11 09:15:00	No-show	Chronic care
1659	337	11	2020-01-25 13:30:00	Completed	Sick visit
1660	56	2	2023-10-04 08:00:00	Completed	Sick visit
1661	324	10	2021-07-26 11:00:00	Completed	Telehealth
1662	313	8	2025-01-28 12:45:00	Completed	Well child
1663	163	5	2021-05-23 14:15:00	Completed	Telehealth
1664	145	4	2024-10-21 16:15:00	Completed	Annual physical
1665	167	9	2024-03-24 12:00:00	No-show	Sick visit
1666	112	3	2022-03-11 10:15:00	Completed	Well child
1667	497	10	2019-04-08 11:45:00	Completed	Follow-up
1668	230	10	2019-04-03 16:15:00	Cancelled	Telehealth
1669	88	9	2019-12-22 08:15:00	Scheduled	Sick visit
1670	482	4	2022-11-25 09:00:00	Completed	Telehealth
1671	355	7	2022-07-03 11:30:00	Completed	Well child
1672	290	6	2020-09-24 13:30:00	Completed	Chronic care
1673	459	7	2023-07-09 10:45:00	Completed	Chronic care
1674	573	9	2021-05-27 14:15:00	Completed	Telehealth
1675	547	4	2023-05-27 09:30:00	Completed	Telehealth
1676	41	6	2020-08-04 08:45:00	Completed	Annual physical
1677	445	9	2023-12-04 12:00:00	Cancelled	Follow-up
1678	254	11	2019-07-24 16:45:00	No-show	Follow-up
1679	110	5	2020-01-28 08:30:00	Scheduled	Annual physical
1680	519	6	2020-08-04 10:00:00	Cancelled	Chronic care
1681	117	4	2021-05-22 09:30:00	Completed	Telehealth
1682	377	8	2026-05-02 15:30:00	Completed	Chronic care
1683	296	4	2022-10-01 14:15:00	Completed	Follow-up
1684	266	7	2021-01-10 14:15:00	Completed	Well child
1685	294	11	2021-12-02 14:30:00	Completed	Follow-up
1686	232	6	2023-06-11 08:00:00	Cancelled	Sick visit
1687	47	8	2020-12-10 17:00:00	Completed	Annual physical
1688	364	1	2021-03-19 11:15:00	No-show	Follow-up
1689	493	1	2023-01-01 08:45:00	Completed	Well child
1690	165	6	2022-12-18 10:30:00	Completed	Annual physical
1691	92	9	2019-11-22 13:00:00	Completed	Chronic care
1692	144	3	2024-07-28 14:45:00	Completed	Follow-up
1693	88	7	2025-04-02 09:30:00	Completed	Follow-up
1694	212	7	2020-01-07 14:15:00	Completed	Telehealth
1695	117	4	2023-05-21 16:30:00	Completed	Telehealth
1696	150	5	2020-02-05 15:30:00	Completed	Annual physical
1697	466	3	2021-07-18 15:00:00	Completed	Annual physical
1698	367	10	2023-01-13 13:15:00	No-show	Follow-up
1699	19	5	2026-04-07 08:00:00	Completed	Well child
1700	457	10	2024-04-18 08:15:00	Completed	Sick visit
1701	7	10	2022-04-27 15:45:00	Completed	Chronic care
1702	282	5	2022-10-10 08:00:00	Completed	Sick visit
1703	221	6	2023-12-29 10:00:00	Completed	Follow-up
1704	354	12	2025-01-13 10:00:00	Completed	Well child
1705	58	11	2022-08-02 16:15:00	Cancelled	Chronic care
1706	277	4	2019-12-03 12:45:00	Completed	Sick visit
1707	248	10	2023-01-24 15:45:00	Completed	Annual physical
1708	119	6	2022-06-13 10:00:00	Cancelled	Annual physical
1709	389	2	2019-04-23 10:15:00	Completed	Follow-up
1710	171	12	2020-06-12 11:00:00	Cancelled	Sick visit
1711	141	12	2020-05-20 09:15:00	Completed	Annual physical
1712	282	5	2019-07-08 13:15:00	Completed	Sick visit
1713	281	3	2024-08-13 08:15:00	Completed	Annual physical
1714	569	8	2026-05-19 13:45:00	Completed	Annual physical
1715	442	3	2021-09-26 16:15:00	Cancelled	Well child
1716	267	4	2023-07-10 10:30:00	Completed	Well child
1717	531	6	2025-05-07 12:45:00	Cancelled	Annual physical
1718	521	11	2025-06-15 12:30:00	No-show	Annual physical
1719	202	4	2024-03-27 15:00:00	Completed	Annual physical
1720	162	10	2021-03-16 14:15:00	Completed	Well child
1721	417	4	2020-03-15 12:00:00	Completed	Annual physical
1722	463	5	2021-04-20 14:45:00	Completed	Follow-up
1723	515	5	2023-03-23 16:30:00	Completed	Sick visit
1724	560	5	2021-01-22 13:00:00	Completed	Well child
1725	544	4	2020-01-27 08:15:00	Completed	Sick visit
1726	295	8	2019-02-21 08:15:00	Cancelled	Chronic care
1727	331	1	2022-05-08 14:45:00	Scheduled	Sick visit
1728	584	11	2019-08-08 11:45:00	Completed	Sick visit
1729	572	2	2020-05-05 08:00:00	Completed	Annual physical
1730	58	1	2023-01-03 08:00:00	Completed	Sick visit
1731	393	9	2023-06-08 09:00:00	Completed	Chronic care
1732	78	2	2024-10-17 08:45:00	Completed	Well child
1733	527	8	2023-10-24 12:00:00	Completed	Follow-up
1734	262	7	2024-11-01 11:30:00	Completed	Well child
1735	24	6	2025-09-21 15:45:00	Completed	Chronic care
1736	151	3	2023-09-22 12:30:00	Cancelled	Follow-up
1737	96	1	2022-05-18 13:15:00	Cancelled	Follow-up
1738	119	6	2021-03-01 14:45:00	Completed	Well child
1739	390	10	2021-07-14 09:00:00	Completed	Well child
1740	537	5	2019-06-16 13:00:00	Completed	Follow-up
1741	273	6	2020-12-27 08:00:00	Completed	Follow-up
1742	217	4	2024-04-10 08:15:00	Completed	Follow-up
1743	505	3	2020-10-05 11:15:00	Completed	Well child
1744	425	2	2020-11-08 10:15:00	Completed	Chronic care
1745	140	8	2024-11-21 10:15:00	Completed	Follow-up
1746	266	7	2024-02-06 08:15:00	Completed	Follow-up
1747	90	2	2023-04-08 08:30:00	Completed	Annual physical
1748	527	8	2023-09-06 10:00:00	Completed	Telehealth
1749	244	10	2023-07-06 16:30:00	No-show	Annual physical
1750	252	9	2019-10-04 11:45:00	Completed	Annual physical
1751	558	11	2025-10-24 09:15:00	Completed	Telehealth
1752	79	9	2023-10-16 09:30:00	Completed	Annual physical
1753	353	7	2020-11-26 14:45:00	Completed	Sick visit
1754	38	12	2019-02-20 10:45:00	Completed	Follow-up
1755	426	7	2023-10-11 09:30:00	Completed	Well child
1756	436	3	2020-12-20 14:30:00	Completed	Telehealth
1757	563	4	2022-05-18 12:45:00	Completed	Sick visit
1758	121	8	2022-01-18 16:45:00	Completed	Follow-up
1759	455	8	2024-05-19 09:45:00	Completed	Chronic care
1760	126	12	2020-11-24 13:30:00	Completed	Telehealth
1761	373	4	2022-12-10 17:00:00	Completed	Annual physical
1762	64	11	2019-10-04 10:30:00	Completed	Telehealth
1763	351	2	2022-12-25 09:30:00	Completed	Well child
1764	332	4	2021-07-11 11:15:00	Completed	Telehealth
1765	437	4	2023-01-03 12:00:00	Completed	Annual physical
1766	48	10	2025-11-23 15:15:00	Completed	Sick visit
1767	164	2	2020-05-24 15:30:00	No-show	Telehealth
1768	361	11	2019-04-21 13:30:00	Completed	Annual physical
1769	45	4	2026-01-03 12:30:00	Completed	Annual physical
1770	491	10	2022-08-08 10:15:00	Completed	Follow-up
1771	307	8	2019-11-15 16:30:00	Completed	Sick visit
1772	303	7	2020-02-25 11:15:00	Completed	Well child
1773	87	12	2019-12-03 11:45:00	Completed	Annual physical
1774	316	9	2021-05-24 10:30:00	Cancelled	Sick visit
1775	435	6	2024-09-13 10:45:00	Completed	Sick visit
1776	597	8	2022-06-26 14:30:00	Completed	Telehealth
1777	16	7	2020-12-01 14:45:00	Completed	Telehealth
1778	234	2	2025-09-12 14:45:00	Completed	Well child
1779	507	9	2022-03-10 14:45:00	Completed	Annual physical
1780	267	4	2020-12-22 09:15:00	Completed	Follow-up
1781	288	9	2022-08-04 13:15:00	No-show	Annual physical
1782	155	12	2021-09-21 09:00:00	Completed	Follow-up
1783	90	2	2022-06-23 10:30:00	Completed	Follow-up
1784	73	6	2024-09-20 09:45:00	Completed	Telehealth
1785	239	11	2022-03-12 09:45:00	Scheduled	Sick visit
1786	361	6	2024-01-12 16:15:00	Completed	Annual physical
1787	60	5	2019-04-25 12:30:00	Completed	Well child
1788	145	4	2022-05-28 16:00:00	Completed	Annual physical
1789	583	11	2019-05-27 10:15:00	Completed	Well child
1790	452	2	2026-03-13 17:00:00	Completed	Chronic care
1791	103	8	2025-10-11 15:45:00	Completed	Well child
1792	569	8	2019-11-05 08:45:00	Completed	Annual physical
1793	111	1	2022-12-16 10:30:00	Cancelled	Telehealth
1794	341	10	2023-06-10 08:15:00	Completed	Well child
1795	312	1	2026-01-13 15:45:00	No-show	Annual physical
1796	330	8	2026-01-13 13:45:00	Completed	Annual physical
1797	376	5	2021-01-02 10:15:00	Completed	Telehealth
1798	285	10	2025-10-21 13:45:00	Completed	Follow-up
1799	356	4	2019-05-14 10:00:00	Completed	Follow-up
1800	319	8	2023-10-29 14:00:00	Completed	Sick visit
1801	94	3	2019-06-04 11:30:00	Completed	Well child
1802	206	4	2019-01-23 11:00:00	No-show	Annual physical
1803	161	11	2022-07-17 13:45:00	Completed	Follow-up
1804	436	3	2024-11-23 10:45:00	Completed	Annual physical
1805	28	3	2021-08-30 15:00:00	Completed	Chronic care
1806	35	12	2025-02-25 13:00:00	Completed	Annual physical
1807	332	10	2025-02-09 14:30:00	Completed	Telehealth
1808	96	3	2023-04-15 14:00:00	Completed	Sick visit
1809	482	4	2026-02-28 08:00:00	Completed	Chronic care
1810	46	6	2023-09-28 09:15:00	Completed	Well child
1811	487	9	2022-10-10 13:45:00	No-show	Follow-up
1812	444	6	2023-10-12 12:00:00	Completed	Chronic care
1813	327	3	2021-05-07 11:30:00	Completed	Well child
1814	579	12	2019-10-18 10:30:00	Completed	Annual physical
1815	70	1	2024-11-30 12:30:00	Completed	Follow-up
1816	493	1	2023-07-19 08:15:00	Completed	Sick visit
1817	571	4	2022-03-27 10:30:00	Scheduled	Telehealth
1818	21	12	2022-11-02 14:30:00	Completed	Telehealth
1819	83	1	2024-07-29 10:15:00	Completed	Telehealth
1820	44	12	2021-10-21 12:30:00	Scheduled	Annual physical
1821	375	10	2024-05-06 10:15:00	Completed	Well child
1822	439	6	2023-03-07 12:30:00	Completed	Follow-up
1823	131	10	2024-04-21 16:45:00	Completed	Chronic care
1824	311	11	2025-02-27 08:15:00	Completed	Well child
1825	382	9	2019-02-13 14:30:00	Completed	Well child
1826	296	3	2019-02-10 14:15:00	No-show	Well child
1827	202	4	2024-11-10 17:00:00	Completed	Well child
1828	158	8	2026-05-05 10:30:00	Completed	Well child
1829	11	5	2022-12-09 13:30:00	Completed	Telehealth
1830	526	2	2024-10-16 13:45:00	Completed	Well child
1831	293	10	2024-10-18 15:00:00	Completed	Well child
1832	169	2	2023-08-24 08:45:00	Completed	Follow-up
1833	346	10	2021-05-01 09:15:00	Completed	Sick visit
1834	398	9	2021-05-31 12:30:00	Cancelled	Annual physical
1835	300	2	2020-04-12 12:15:00	Completed	Annual physical
1836	15	8	2023-10-30 10:45:00	Completed	Sick visit
1837	256	2	2022-03-07 16:30:00	Completed	Telehealth
1838	336	8	2026-05-05 11:00:00	Completed	Sick visit
1839	573	9	2025-08-08 10:45:00	Completed	Annual physical
1840	169	2	2023-04-10 16:00:00	Scheduled	Telehealth
1841	188	4	2024-05-04 13:45:00	Completed	Chronic care
1842	432	3	2022-12-03 11:45:00	No-show	Annual physical
1843	361	3	2025-01-26 14:45:00	Completed	Follow-up
1844	501	12	2020-11-22 15:00:00	Completed	Sick visit
1845	293	5	2022-09-07 13:30:00	Cancelled	Well child
1846	99	3	2025-09-03 15:45:00	Completed	Well child
1847	230	10	2024-10-11 11:00:00	Completed	Telehealth
1848	555	6	2026-03-09 15:00:00	Completed	Sick visit
1849	539	10	2020-09-02 08:15:00	Completed	Telehealth
1850	127	11	2019-04-30 16:00:00	Completed	Chronic care
1851	143	10	2020-06-04 12:45:00	Scheduled	Well child
1852	135	8	2023-07-19 15:45:00	Completed	Well child
1853	428	8	2021-02-10 17:00:00	Scheduled	Telehealth
1854	379	12	2023-01-29 15:00:00	Completed	Chronic care
1855	56	2	2022-09-24 15:00:00	Completed	Follow-up
1856	273	6	2019-04-09 15:00:00	Completed	Annual physical
1857	96	1	2022-04-11 11:00:00	Completed	Chronic care
1858	27	7	2022-08-30 09:15:00	Completed	Follow-up
1859	115	7	2025-04-21 13:30:00	Completed	Annual physical
1860	345	1	2023-04-14 17:00:00	Completed	Annual physical
1861	193	9	2025-03-06 10:45:00	Scheduled	Follow-up
1862	189	11	2021-06-08 12:15:00	No-show	Well child
1863	294	11	2023-07-29 08:30:00	Completed	Sick visit
1864	471	8	2025-09-24 12:30:00	Completed	Chronic care
1865	463	9	2023-02-03 14:30:00	Completed	Chronic care
1866	586	10	2019-03-10 13:15:00	Completed	Annual physical
1867	27	4	2022-09-05 15:30:00	Completed	Chronic care
1868	9	8	2020-07-07 11:45:00	Completed	Follow-up
1869	22	10	2025-11-09 12:00:00	Completed	Follow-up
1870	283	4	2025-03-29 14:15:00	Completed	Sick visit
1871	579	12	2022-07-23 09:15:00	Completed	Telehealth
1872	456	1	2025-10-04 10:00:00	Completed	Annual physical
1873	371	6	2025-03-30 16:30:00	Completed	Sick visit
1874	367	3	2025-09-15 08:30:00	No-show	Well child
1875	273	6	2025-08-27 13:15:00	No-show	Follow-up
1876	442	3	2019-06-19 15:00:00	Scheduled	Follow-up
1877	183	1	2020-03-22 16:00:00	Completed	Sick visit
1878	12	11	2023-10-24 08:00:00	No-show	Telehealth
1879	201	7	2020-08-27 11:15:00	Completed	Annual physical
1880	508	3	2022-02-25 10:15:00	Completed	Well child
1881	424	6	2021-02-05 10:45:00	Completed	Well child
1882	311	11	2021-06-23 15:45:00	Completed	Sick visit
1883	199	10	2025-11-12 12:45:00	Completed	Chronic care
1884	580	4	2019-11-19 09:30:00	Completed	Follow-up
1885	123	1	2025-01-09 16:00:00	Completed	Telehealth
1886	219	11	2019-03-14 15:15:00	Completed	Sick visit
1887	395	8	2024-07-16 13:00:00	Completed	Annual physical
1888	72	9	2021-04-14 12:15:00	Completed	Well child
1889	320	11	2024-01-17 14:30:00	Completed	Annual physical
1890	48	10	2023-03-22 11:30:00	Completed	Annual physical
1891	40	8	2023-06-18 09:00:00	Completed	Well child
1892	63	12	2019-11-08 10:45:00	No-show	Chronic care
1893	453	1	2020-05-11 08:00:00	Completed	Follow-up
1894	400	6	2023-11-18 15:00:00	Completed	Chronic care
1895	330	8	2021-08-04 09:15:00	Completed	Telehealth
1896	85	7	2019-08-07 08:30:00	Completed	Telehealth
1897	294	11	2019-07-02 15:00:00	Cancelled	Follow-up
1898	150	8	2023-09-11 08:45:00	Completed	Chronic care
1899	462	4	2024-04-04 11:45:00	Completed	Sick visit
1900	421	6	2023-09-09 09:15:00	Completed	Follow-up
1901	321	5	2022-12-03 10:45:00	Scheduled	Sick visit
1902	436	2	2021-07-14 13:15:00	Completed	Sick visit
1903	220	9	2021-12-19 08:15:00	Completed	Chronic care
1904	37	1	2025-07-11 16:45:00	Completed	Sick visit
1905	326	2	2023-10-29 12:15:00	Completed	Telehealth
1906	453	1	2021-08-04 09:15:00	No-show	Telehealth
1907	445	9	2021-04-06 08:15:00	Completed	Annual physical
1908	77	6	2023-10-03 12:15:00	Completed	Follow-up
1909	186	8	2022-05-17 10:00:00	Cancelled	Sick visit
1910	293	5	2019-06-22 12:00:00	Completed	Telehealth
1911	32	8	2023-04-28 13:30:00	Completed	Sick visit
1912	7	4	2019-02-01 09:15:00	Completed	Sick visit
1913	99	3	2023-06-10 12:45:00	Completed	Annual physical
1914	171	2	2022-07-21 11:45:00	Completed	Sick visit
1915	218	1	2019-08-04 12:15:00	Completed	Chronic care
1916	69	3	2022-12-26 09:15:00	Completed	Well child
1917	98	5	2021-01-08 13:15:00	Scheduled	Telehealth
1918	208	7	2023-12-27 11:15:00	Scheduled	Telehealth
1919	547	4	2025-07-27 11:00:00	No-show	Chronic care
1920	413	8	2021-05-06 14:15:00	Completed	Follow-up
1921	197	10	2025-11-04 12:00:00	Completed	Follow-up
1922	393	9	2022-07-12 13:30:00	Completed	Follow-up
1923	233	8	2026-02-12 16:00:00	Completed	Chronic care
1924	450	1	2020-03-03 15:30:00	Completed	Sick visit
1925	543	9	2025-01-18 16:30:00	Completed	Well child
1926	52	11	2025-05-19 12:15:00	Completed	Chronic care
1927	415	12	2023-10-30 14:45:00	Completed	Annual physical
1928	327	3	2021-02-08 15:15:00	Completed	Follow-up
1929	2	4	2025-11-04 11:45:00	Scheduled	Sick visit
1930	50	4	2024-08-24 14:45:00	Completed	Annual physical
1931	120	5	2019-08-12 12:15:00	Completed	Well child
1932	194	4	2024-08-13 13:15:00	Completed	Annual physical
1933	57	7	2021-01-20 16:15:00	Cancelled	Well child
1934	289	9	2021-03-17 12:00:00	Completed	Annual physical
1935	421	6	2021-11-06 16:30:00	Completed	Annual physical
1936	274	1	2020-06-05 15:45:00	Scheduled	Annual physical
1937	210	2	2025-11-14 10:45:00	Completed	Follow-up
1938	36	2	2022-07-06 13:15:00	Completed	Telehealth
1939	119	6	2026-01-02 11:45:00	Completed	Chronic care
1940	325	4	2025-09-18 14:00:00	Completed	Telehealth
1941	48	10	2026-04-12 17:00:00	Completed	Annual physical
1942	187	11	2021-01-17 14:15:00	Completed	Annual physical
1943	230	10	2023-10-28 15:45:00	Completed	Well child
1944	74	8	2019-06-20 10:15:00	Completed	Chronic care
1945	326	2	2023-03-17 13:15:00	Completed	Follow-up
1946	202	4	2025-11-11 10:15:00	Completed	Follow-up
1947	554	6	2023-06-06 17:00:00	Completed	Chronic care
1948	449	4	2019-01-26 13:45:00	Cancelled	Sick visit
1949	101	11	2023-08-21 15:30:00	Completed	Sick visit
1950	25	10	2019-02-11 09:15:00	Completed	Telehealth
1951	238	1	2024-09-03 16:00:00	No-show	Follow-up
1952	241	11	2024-07-04 14:00:00	Completed	Follow-up
1953	176	1	2023-02-22 16:30:00	Completed	Chronic care
1954	107	4	2023-09-03 10:15:00	Completed	Well child
1955	261	6	2024-05-09 09:00:00	Completed	Follow-up
1956	416	1	2024-12-31 08:30:00	Completed	Annual physical
1957	368	12	2022-03-29 08:45:00	Completed	Telehealth
1958	12	4	2025-01-08 11:45:00	Completed	Telehealth
1959	156	10	2023-11-14 11:00:00	Completed	Follow-up
1960	31	11	2023-12-23 16:30:00	Completed	Follow-up
1961	77	6	2025-07-19 09:30:00	Completed	Telehealth
1962	302	9	2021-10-21 12:45:00	Completed	Well child
1963	365	7	2021-01-21 10:30:00	Scheduled	Annual physical
1964	147	9	2023-12-07 13:30:00	Scheduled	Sick visit
1965	436	3	2026-01-17 09:30:00	Cancelled	Telehealth
1966	342	1	2023-10-09 14:00:00	Completed	Follow-up
1967	160	7	2023-11-14 08:00:00	Scheduled	Follow-up
1968	488	5	2021-10-10 14:00:00	Completed	Well child
1969	269	9	2025-10-19 13:30:00	Completed	Follow-up
1970	141	9	2024-06-05 09:45:00	Completed	Chronic care
1971	452	2	2019-02-10 10:00:00	Completed	Well child
1972	308	9	2025-03-28 10:45:00	Completed	Sick visit
1973	237	10	2021-08-30 16:15:00	Completed	Chronic care
1974	19	11	2019-11-07 08:45:00	Completed	Annual physical
1975	589	12	2021-10-27 08:45:00	Completed	Chronic care
1976	208	4	2021-10-17 16:00:00	Completed	Well child
1977	232	6	2020-12-05 14:45:00	Completed	Sick visit
1978	399	5	2019-11-21 16:15:00	Completed	Sick visit
1979	432	3	2020-05-05 14:45:00	Cancelled	Follow-up
1980	451	4	2024-01-29 09:30:00	Completed	Annual physical
1981	133	3	2023-01-07 08:15:00	Completed	Annual physical
1982	246	5	2025-12-12 11:45:00	Completed	Annual physical
1983	566	11	2026-01-31 15:00:00	Completed	Telehealth
1984	225	9	2022-05-14 16:45:00	Completed	Sick visit
1985	268	1	2019-06-01 12:00:00	Cancelled	Sick visit
1986	401	11	2019-07-24 11:15:00	Completed	Sick visit
1987	292	11	2023-08-25 08:45:00	Completed	Well child
1988	342	1	2025-07-30 12:30:00	Completed	Sick visit
1989	231	11	2023-09-28 08:45:00	Completed	Chronic care
1990	422	1	2019-03-27 12:00:00	Completed	Sick visit
1991	294	11	2024-09-26 16:00:00	Completed	Sick visit
1992	542	12	2020-09-06 11:30:00	Completed	Chronic care
1993	312	1	2021-10-04 11:00:00	Completed	Annual physical
1994	410	1	2019-09-15 09:30:00	Completed	Chronic care
1995	73	6	2019-05-31 15:15:00	Completed	Chronic care
1996	525	6	2024-08-29 11:30:00	Scheduled	Well child
1997	289	9	2021-11-12 16:15:00	Cancelled	Telehealth
1998	266	7	2025-12-07 10:15:00	Completed	Sick visit
1999	299	12	2023-09-29 15:30:00	Completed	Chronic care
2000	461	2	2025-06-11 12:00:00	Completed	Well child
2001	266	7	2023-10-12 12:30:00	Completed	Telehealth
2002	249	7	2026-01-15 09:00:00	Scheduled	Annual physical
2003	566	11	2019-07-26 09:30:00	Completed	Annual physical
2004	399	11	2019-02-24 16:30:00	Completed	Follow-up
2005	566	11	2024-11-20 13:00:00	Completed	Follow-up
2006	98	5	2026-02-28 12:00:00	Completed	Telehealth
2007	493	1	2022-11-18 14:15:00	Completed	Annual physical
2008	410	2	2022-12-19 11:30:00	Completed	Chronic care
2009	564	6	2021-11-20 10:15:00	Completed	Well child
2010	161	11	2024-02-11 14:30:00	Cancelled	Annual physical
2011	359	12	2022-12-26 08:15:00	Cancelled	Well child
2012	581	4	2020-11-15 08:45:00	No-show	Chronic care
2013	395	8	2019-11-24 17:00:00	Completed	Annual physical
2014	102	3	2025-05-31 12:45:00	Completed	Follow-up
2015	483	5	2026-04-08 11:15:00	Completed	Well child
2016	549	3	2025-03-29 09:00:00	Scheduled	Follow-up
2017	525	6	2023-10-13 12:00:00	No-show	Well child
2018	291	1	2020-06-25 11:15:00	Completed	Annual physical
2019	273	6	2021-12-09 16:15:00	Completed	Sick visit
2020	443	7	2022-01-05 16:45:00	Completed	Chronic care
2021	241	11	2024-01-20 12:45:00	Completed	Follow-up
2022	471	8	2025-05-19 09:45:00	Completed	Sick visit
2023	553	6	2021-04-09 09:45:00	Completed	Telehealth
2024	21	12	2019-10-19 11:30:00	Cancelled	Well child
2025	404	6	2021-10-16 15:45:00	Completed	Telehealth
2026	381	5	2025-09-15 13:45:00	Completed	Sick visit
2027	281	3	2024-06-14 10:15:00	Completed	Telehealth
2028	533	2	2022-09-14 15:45:00	Completed	Sick visit
2029	546	7	2025-08-25 16:30:00	Completed	Chronic care
2030	140	8	2024-02-12 15:00:00	Completed	Follow-up
2031	102	3	2021-01-18 16:15:00	Completed	Sick visit
2032	176	1	2020-03-26 09:15:00	Completed	Well child
2033	137	7	2022-01-27 12:15:00	Completed	Annual physical
2034	575	3	2023-08-29 14:00:00	Completed	Telehealth
2035	319	11	2022-10-22 12:00:00	Completed	Chronic care
2036	566	11	2024-05-11 10:45:00	Completed	Chronic care
2037	456	1	2022-04-27 15:00:00	Cancelled	Well child
2038	390	10	2020-10-22 09:30:00	Completed	Sick visit
2039	470	12	2022-02-08 15:00:00	No-show	Sick visit
2040	480	2	2022-08-15 09:00:00	Completed	Telehealth
2041	201	7	2022-02-13 15:30:00	Completed	Sick visit
2042	327	3	2023-06-12 16:30:00	Completed	Telehealth
2043	316	10	2019-04-08 10:00:00	Completed	Follow-up
2044	268	12	2020-03-10 15:45:00	Scheduled	Sick visit
2045	308	9	2024-04-02 12:45:00	Completed	Well child
2046	256	4	2019-07-28 09:30:00	Completed	Annual physical
2047	341	10	2022-09-25 15:45:00	Scheduled	Well child
2048	600	6	2024-05-17 08:00:00	Completed	Well child
2049	281	3	2020-03-02 15:45:00	Completed	Well child
2050	225	9	2022-04-08 16:00:00	Completed	Follow-up
2051	596	7	2023-07-17 17:00:00	Completed	Follow-up
2052	94	6	2022-09-09 09:45:00	Cancelled	Follow-up
2053	228	7	2025-01-12 16:45:00	Completed	Annual physical
2054	247	4	2020-06-15 14:00:00	Completed	Sick visit
2055	228	7	2024-10-08 16:00:00	Completed	Chronic care
2056	378	10	2020-09-13 08:30:00	Completed	Follow-up
2057	286	1	2025-11-01 09:00:00	Completed	Sick visit
2058	345	1	2023-05-20 12:15:00	Completed	Sick visit
2059	552	8	2019-12-01 09:00:00	Scheduled	Annual physical
2060	580	4	2022-08-24 11:00:00	Completed	Sick visit
2061	338	11	2024-09-28 11:30:00	Completed	Annual physical
2062	49	4	2022-10-21 10:45:00	Completed	Annual physical
2063	195	8	2022-11-14 09:30:00	Completed	Follow-up
2064	463	11	2022-01-20 14:15:00	Completed	Annual physical
2065	541	11	2021-04-20 12:15:00	Completed	Telehealth
2066	212	7	2021-10-09 09:30:00	Completed	Annual physical
2067	68	11	2025-12-08 10:15:00	Completed	Telehealth
2068	101	11	2022-08-05 16:45:00	Cancelled	Follow-up
2069	459	7	2020-12-26 08:15:00	Completed	Follow-up
2070	504	10	2023-04-03 15:30:00	Completed	Chronic care
2071	134	5	2025-08-17 15:00:00	No-show	Sick visit
2072	459	7	2019-01-03 09:15:00	Completed	Sick visit
2073	270	5	2022-09-21 12:00:00	Completed	Well child
2074	180	2	2022-10-07 10:00:00	Completed	Sick visit
2075	551	2	2019-06-12 12:30:00	Completed	Well child
2076	127	8	2025-11-17 16:15:00	Completed	Well child
2077	555	5	2022-04-08 13:30:00	Completed	Well child
2078	232	6	2022-03-04 10:30:00	Completed	Follow-up
2079	421	6	2026-03-17 12:30:00	Completed	Follow-up
2080	448	7	2021-10-18 11:00:00	Completed	Well child
2081	593	6	2026-01-25 10:00:00	Completed	Well child
2082	473	5	2020-01-07 11:45:00	Completed	Well child
2083	161	11	2021-01-02 12:00:00	Completed	Annual physical
2084	205	5	2026-01-29 15:30:00	Completed	Well child
2085	403	4	2025-10-24 15:15:00	Cancelled	Sick visit
2086	478	7	2023-07-25 09:30:00	Scheduled	Telehealth
2087	310	9	2021-06-13 13:30:00	Completed	Annual physical
2088	389	5	2020-11-12 08:15:00	Completed	Annual physical
2089	454	3	2025-03-09 16:30:00	Completed	Telehealth
2090	359	12	2021-03-22 14:45:00	Completed	Well child
2091	65	11	2023-03-27 12:45:00	Completed	Telehealth
2092	61	12	2026-05-20 15:45:00	Cancelled	Annual physical
2093	331	1	2020-04-03 16:45:00	No-show	Sick visit
2094	318	9	2022-08-21 13:00:00	Completed	Well child
2095	483	5	2023-03-14 15:15:00	Completed	Follow-up
2096	574	5	2021-03-09 12:00:00	Completed	Well child
2097	139	11	2022-12-04 14:15:00	Completed	Chronic care
2098	456	7	2022-10-15 16:30:00	Cancelled	Sick visit
2099	526	2	2026-03-11 13:30:00	Completed	Sick visit
2100	127	11	2023-12-16 15:30:00	Cancelled	Sick visit
2101	150	8	2026-02-22 12:00:00	Completed	Follow-up
2102	79	3	2025-06-13 12:45:00	Completed	Sick visit
2103	229	3	2026-05-05 09:30:00	Cancelled	Follow-up
2104	427	9	2020-09-06 10:00:00	No-show	Follow-up
2105	217	4	2023-02-13 14:30:00	Completed	Follow-up
2106	464	5	2024-06-06 15:30:00	Cancelled	Annual physical
2107	347	3	2020-05-16 14:45:00	Completed	Chronic care
2108	344	10	2024-02-29 13:45:00	Completed	Well child
2109	167	9	2021-09-08 11:45:00	Completed	Sick visit
2110	501	12	2019-02-21 13:45:00	Completed	Follow-up
2111	538	8	2021-04-08 13:45:00	Completed	Telehealth
2112	450	1	2023-05-27 17:00:00	Completed	Follow-up
2113	362	8	2025-08-08 16:45:00	Completed	Well child
2114	352	9	2025-04-05 14:30:00	Completed	Well child
2115	35	12	2026-03-27 16:45:00	Completed	Annual physical
2116	351	2	2021-02-20 09:30:00	Completed	Sick visit
2117	459	6	2019-07-23 11:45:00	Completed	Sick visit
2118	195	8	2022-08-02 13:15:00	Completed	Well child
2119	91	5	2025-07-07 16:30:00	Cancelled	Follow-up
2120	171	12	2024-03-20 10:30:00	Completed	Annual physical
2121	427	9	2019-10-06 11:30:00	Cancelled	Follow-up
2122	289	9	2025-06-19 13:30:00	Completed	Telehealth
2123	259	6	2019-10-27 14:00:00	Completed	Annual physical
2124	536	3	2025-06-30 10:00:00	Completed	Well child
2125	423	4	2026-05-13 12:30:00	Completed	Well child
2126	447	8	2023-08-30 09:30:00	Scheduled	Follow-up
2127	516	12	2022-08-08 10:45:00	Completed	Chronic care
2128	434	3	2021-02-03 14:30:00	Completed	Telehealth
2129	23	4	2023-04-16 11:15:00	Completed	Follow-up
2130	537	6	2021-06-18 11:45:00	Completed	Annual physical
2131	483	6	2023-11-01 09:45:00	Completed	Chronic care
2132	382	11	2024-01-22 10:45:00	Completed	Follow-up
2133	560	6	2022-01-09 11:45:00	Completed	Follow-up
2134	84	7	2021-04-12 15:45:00	Completed	Sick visit
2135	295	7	2019-07-30 13:30:00	Scheduled	Chronic care
2136	534	9	2020-08-12 15:00:00	Completed	Sick visit
2137	475	7	2025-01-18 16:15:00	Scheduled	Chronic care
2138	119	6	2022-10-21 15:15:00	Completed	Sick visit
2139	429	5	2025-01-23 11:45:00	No-show	Sick visit
2140	531	11	2019-06-23 16:30:00	Completed	Well child
2141	365	7	2025-12-01 09:45:00	Cancelled	Telehealth
2142	71	4	2021-10-13 14:00:00	Completed	Well child
2143	8	1	2024-02-05 09:30:00	Cancelled	Well child
2144	361	3	2024-07-25 16:15:00	Completed	Well child
2145	394	6	2024-03-26 14:00:00	Scheduled	Sick visit
2146	370	9	2025-07-21 11:00:00	Completed	Well child
2147	411	8	2022-06-26 09:15:00	No-show	Sick visit
2148	257	4	2019-05-28 15:45:00	Completed	Sick visit
2149	332	9	2019-08-13 08:45:00	No-show	Sick visit
2150	297	6	2024-11-05 08:00:00	Scheduled	Sick visit
2151	232	6	2025-08-13 13:15:00	Completed	Annual physical
2152	109	7	2022-04-30 09:00:00	Completed	Well child
2153	129	11	2023-06-12 14:00:00	Completed	Chronic care
2154	515	5	2025-09-14 09:30:00	Completed	Telehealth
2155	152	7	2019-03-06 15:15:00	Cancelled	Sick visit
2156	64	11	2019-04-13 08:45:00	Scheduled	Well child
2157	319	11	2025-07-23 14:30:00	No-show	Follow-up
2158	27	4	2019-05-02 13:30:00	Completed	Annual physical
2159	550	3	2022-06-19 11:30:00	Completed	Chronic care
2160	216	1	2025-12-05 12:00:00	Completed	Annual physical
2161	26	2	2021-10-04 09:00:00	Completed	Well child
2162	433	7	2022-03-26 13:00:00	Completed	Follow-up
2163	584	11	2019-04-30 12:00:00	Completed	Sick visit
2164	84	7	2024-01-02 15:15:00	Completed	Sick visit
2165	227	7	2020-01-19 08:30:00	No-show	Chronic care
2166	19	5	2023-02-02 16:30:00	Completed	Follow-up
2167	399	1	2022-06-29 11:45:00	Completed	Follow-up
2168	450	1	2024-01-30 14:45:00	Completed	Telehealth
2169	545	7	2024-03-21 15:00:00	Completed	Annual physical
2170	283	4	2024-03-27 09:15:00	Completed	Follow-up
2171	32	6	2022-02-27 12:15:00	Completed	Sick visit
2172	450	1	2024-04-10 09:15:00	Cancelled	Well child
2173	295	8	2020-12-02 14:30:00	Completed	Follow-up
2174	133	3	2025-02-14 11:00:00	Cancelled	Follow-up
2175	35	12	2020-04-10 16:15:00	Completed	Telehealth
2176	379	7	2025-09-19 11:30:00	Completed	Telehealth
2177	287	12	2022-10-10 16:00:00	Completed	Sick visit
2178	463	11	2021-12-04 10:00:00	Completed	Well child
2179	385	9	2025-09-24 11:00:00	Completed	Telehealth
2180	34	5	2020-06-17 08:00:00	Completed	Telehealth
2181	508	3	2020-02-17 09:45:00	Completed	Follow-up
2182	88	7	2022-10-07 13:00:00	Completed	Follow-up
2183	193	9	2023-03-19 16:15:00	Completed	Annual physical
2184	555	11	2022-12-30 09:45:00	Completed	Annual physical
2185	173	5	2019-06-18 13:00:00	Completed	Annual physical
2186	248	9	2020-05-18 16:00:00	Completed	Follow-up
2187	33	9	2019-03-19 08:15:00	Completed	Sick visit
2188	177	12	2026-05-03 09:30:00	Completed	Telehealth
2189	379	1	2020-12-22 15:15:00	Completed	Annual physical
2190	310	9	2020-09-22 14:45:00	Completed	Annual physical
2191	175	7	2026-01-05 14:15:00	Completed	Telehealth
2192	485	2	2021-01-26 14:45:00	Completed	Sick visit
2193	312	1	2020-12-26 08:00:00	Completed	Annual physical
2194	182	2	2019-07-14 09:45:00	Completed	Chronic care
2195	73	6	2020-06-04 09:45:00	Cancelled	Well child
2196	32	6	2020-05-19 15:00:00	Completed	Well child
2197	245	8	2024-06-22 14:45:00	No-show	Follow-up
2198	334	10	2021-12-15 16:30:00	Completed	Annual physical
2199	179	12	2025-12-21 12:15:00	Completed	Follow-up
2200	284	5	2025-10-29 09:45:00	Scheduled	Annual physical
2201	454	7	2022-12-28 08:30:00	Completed	Chronic care
2202	61	3	2019-04-13 11:45:00	Completed	Well child
2203	498	3	2022-10-06 13:15:00	Completed	Telehealth
2204	57	7	2020-06-03 17:00:00	Completed	Well child
2205	28	3	2021-07-03 16:15:00	Completed	Sick visit
2206	478	6	2024-07-09 11:30:00	Completed	Follow-up
2207	521	11	2024-02-05 08:00:00	Completed	Chronic care
2208	12	11	2019-05-08 08:15:00	Completed	Well child
2209	295	8	2019-04-21 16:45:00	Completed	Well child
2210	19	5	2024-11-12 12:45:00	Completed	Annual physical
2211	187	11	2022-03-08 12:00:00	No-show	Chronic care
2212	509	2	2019-02-17 17:00:00	Completed	Telehealth
2213	351	2	2023-04-24 13:30:00	Completed	Follow-up
2214	4	2	2025-10-04 11:45:00	Completed	Follow-up
2215	359	12	2021-08-05 11:45:00	Completed	Sick visit
2216	180	2	2021-08-31 13:15:00	Cancelled	Telehealth
2217	338	11	2025-10-05 12:00:00	Scheduled	Telehealth
2218	202	4	2025-07-14 09:30:00	Completed	Telehealth
2219	561	8	2022-07-16 16:45:00	Completed	Telehealth
2220	600	6	2024-03-02 11:45:00	Completed	Sick visit
2221	443	7	2019-03-06 16:45:00	Scheduled	Chronic care
2222	585	2	2025-02-13 14:30:00	Completed	Annual physical
2223	58	11	2024-01-06 11:45:00	Completed	Chronic care
2224	418	5	2021-08-21 13:00:00	Completed	Follow-up
2225	13	2	2024-09-29 09:30:00	Completed	Sick visit
2226	179	12	2019-03-08 14:00:00	Completed	Telehealth
2227	322	4	2024-11-18 11:45:00	Completed	Annual physical
2228	285	11	2025-03-17 08:45:00	Completed	Well child
2229	575	3	2020-04-23 09:30:00	Completed	Well child
2230	594	10	2025-02-21 16:15:00	Completed	Sick visit
2231	587	7	2024-06-21 09:45:00	Completed	Chronic care
2232	9	8	2021-11-29 10:15:00	Cancelled	Follow-up
2233	452	2	2025-01-08 09:00:00	Completed	Sick visit
2234	37	12	2024-03-19 13:15:00	Completed	Follow-up
2235	543	1	2025-08-29 16:15:00	Scheduled	Telehealth
2236	50	2	2025-06-27 13:15:00	Completed	Follow-up
2237	349	10	2023-12-02 13:30:00	Scheduled	Well child
2238	551	4	2025-05-22 16:15:00	Completed	Well child
2239	476	10	2021-07-16 08:00:00	Completed	Sick visit
2240	329	11	2025-11-03 08:45:00	No-show	Chronic care
2241	92	9	2020-03-11 12:45:00	Completed	Telehealth
2242	373	12	2020-12-23 12:30:00	Completed	Well child
2243	531	6	2026-03-30 15:45:00	Completed	Annual physical
2244	362	6	2021-06-03 12:00:00	Completed	Telehealth
2245	195	8	2019-08-25 10:45:00	Completed	Chronic care
2246	142	12	2020-06-03 12:30:00	Completed	Chronic care
2247	290	2	2021-10-13 15:30:00	Completed	Sick visit
2248	191	2	2020-07-04 09:00:00	Completed	Well child
2249	288	9	2021-07-28 15:15:00	Completed	Follow-up
2250	258	8	2023-07-29 15:30:00	Completed	Chronic care
2251	544	4	2024-06-06 15:00:00	Completed	Chronic care
2252	183	12	2024-11-07 11:15:00	Completed	Chronic care
2253	242	9	2019-01-30 14:00:00	Completed	Chronic care
2254	491	5	2022-08-28 10:00:00	Completed	Chronic care
2255	596	7	2021-02-09 15:15:00	Completed	Telehealth
2256	246	5	2023-03-02 09:45:00	Completed	Annual physical
2257	301	7	2022-06-21 16:00:00	Completed	Follow-up
2258	81	8	2022-01-11 10:30:00	Completed	Annual physical
2259	223	8	2025-11-13 14:00:00	Completed	Telehealth
2260	329	11	2019-06-13 12:45:00	Completed	Chronic care
2261	145	4	2021-05-28 13:00:00	Scheduled	Well child
2262	503	5	2023-02-01 14:30:00	Scheduled	Annual physical
2263	347	1	2023-04-11 10:00:00	Completed	Chronic care
2264	542	12	2020-12-25 14:45:00	Completed	Well child
2265	163	7	2025-08-04 08:45:00	Completed	Follow-up
2266	556	9	2024-01-22 13:15:00	Completed	Telehealth
2267	7	4	2020-10-31 13:15:00	Completed	Annual physical
2268	314	9	2021-06-03 10:00:00	Completed	Telehealth
2269	80	3	2019-11-22 13:00:00	Scheduled	Follow-up
2270	10	1	2020-02-06 16:30:00	Completed	Follow-up
2271	403	4	2023-05-24 13:45:00	Completed	Chronic care
2272	128	6	2020-01-20 13:45:00	Completed	Chronic care
2273	169	5	2021-08-11 08:45:00	Completed	Chronic care
2274	105	4	2021-08-06 10:00:00	Completed	Chronic care
2275	311	11	2022-05-06 08:30:00	Completed	Annual physical
2276	14	1	2025-04-29 08:15:00	Completed	Annual physical
2277	385	12	2022-11-05 13:15:00	Completed	Chronic care
2278	121	7	2024-03-07 09:45:00	Scheduled	Follow-up
2279	43	6	2024-02-23 13:00:00	Cancelled	Follow-up
2280	156	10	2020-02-19 10:45:00	Cancelled	Chronic care
2281	574	5	2025-11-23 09:15:00	Cancelled	Well child
2282	321	5	2022-08-04 13:30:00	Scheduled	Chronic care
2283	423	4	2020-01-10 12:45:00	Completed	Well child
2284	189	11	2024-04-15 11:00:00	Completed	Well child
2285	315	5	2021-10-08 14:45:00	Completed	Telehealth
2286	538	3	2021-09-14 11:30:00	Completed	Well child
2287	415	12	2020-12-15 11:45:00	Completed	Annual physical
2288	245	8	2025-03-29 15:15:00	Completed	Sick visit
2289	173	5	2022-09-18 13:45:00	Completed	Annual physical
2290	84	7	2019-10-23 10:30:00	Completed	Well child
2291	573	9	2021-03-14 11:45:00	Completed	Annual physical
2292	529	6	2022-09-13 16:45:00	Completed	Follow-up
2293	472	2	2022-08-08 11:45:00	Scheduled	Telehealth
2294	302	9	2025-03-13 09:15:00	Completed	Follow-up
2295	141	12	2020-07-20 13:00:00	Completed	Well child
2296	481	11	2025-07-16 08:30:00	Completed	Sick visit
2297	333	2	2024-12-01 16:00:00	Completed	Chronic care
2298	354	8	2020-08-04 13:30:00	Completed	Telehealth
2299	64	11	2025-08-17 14:00:00	Completed	Follow-up
2300	572	12	2019-08-05 12:30:00	Completed	Annual physical
2301	506	8	2020-05-21 10:45:00	Completed	Annual physical
2302	350	9	2025-07-12 15:45:00	Cancelled	Telehealth
2303	387	7	2021-12-16 08:45:00	Completed	Chronic care
2304	214	1	2023-06-27 14:15:00	Completed	Well child
2305	546	7	2019-03-16 17:00:00	Cancelled	Follow-up
2306	163	5	2022-02-20 15:45:00	Completed	Telehealth
2307	106	2	2025-04-05 11:30:00	Completed	Sick visit
2308	479	7	2024-10-11 12:30:00	Completed	Annual physical
2309	38	9	2025-12-31 08:45:00	Cancelled	Chronic care
2310	472	4	2024-09-01 14:15:00	Completed	Telehealth
2311	253	4	2022-05-10 08:45:00	Completed	Chronic care
2312	35	12	2019-02-17 11:15:00	Completed	Annual physical
2313	37	10	2021-07-10 16:30:00	Completed	Annual physical
2314	126	12	2025-01-18 10:45:00	Completed	Sick visit
2315	437	4	2025-08-31 17:00:00	Cancelled	Sick visit
2316	155	12	2021-11-06 11:00:00	Completed	Annual physical
2317	335	11	2020-01-31 15:30:00	Completed	Follow-up
2318	451	4	2020-09-19 13:45:00	Completed	Sick visit
2319	463	11	2020-05-03 11:30:00	Completed	Well child
2320	406	8	2023-02-02 13:00:00	Completed	Follow-up
2321	212	4	2020-09-24 16:15:00	Completed	Annual physical
2322	280	1	2023-10-10 17:00:00	Completed	Sick visit
2323	543	10	2024-11-07 16:15:00	Completed	Telehealth
2324	375	12	2019-08-26 13:45:00	Completed	Annual physical
2325	553	6	2023-05-17 08:00:00	Completed	Well child
2326	337	4	2021-08-27 12:00:00	No-show	Chronic care
2327	21	12	2024-09-12 09:30:00	Completed	Sick visit
2328	20	8	2026-05-07 15:45:00	Completed	Sick visit
2329	184	2	2022-01-25 16:15:00	Completed	Well child
2330	180	2	2022-10-18 10:45:00	Completed	Chronic care
2331	303	7	2023-01-21 15:15:00	Completed	Sick visit
2332	159	2	2026-05-14 12:00:00	Completed	Well child
2333	477	12	2019-11-03 13:30:00	Completed	Sick visit
2334	202	6	2021-11-14 14:00:00	Completed	Follow-up
2335	238	1	2023-09-10 14:45:00	Completed	Follow-up
2336	79	10	2020-09-15 13:15:00	No-show	Sick visit
2337	104	1	2025-08-12 16:45:00	Completed	Sick visit
2338	46	11	2020-09-26 08:45:00	Completed	Chronic care
2339	588	4	2024-02-15 12:15:00	No-show	Telehealth
2340	478	6	2021-08-26 09:00:00	Completed	Well child
2341	544	4	2026-02-11 11:30:00	Completed	Telehealth
2342	428	8	2019-07-07 10:00:00	Completed	Annual physical
2343	201	7	2021-02-24 15:30:00	Completed	Follow-up
2344	76	4	2020-04-26 08:30:00	Completed	Chronic care
2345	378	4	2022-10-11 09:45:00	Scheduled	Chronic care
2346	274	1	2019-01-15 09:45:00	Completed	Sick visit
2347	210	2	2025-08-07 14:45:00	Completed	Follow-up
2348	522	2	2020-03-15 12:15:00	Completed	Follow-up
2349	535	5	2021-02-24 09:15:00	Completed	Telehealth
2350	27	4	2020-04-19 16:00:00	Completed	Chronic care
2351	300	2	2021-10-05 14:45:00	Completed	Chronic care
2352	461	2	2021-03-16 09:15:00	Completed	Sick visit
2353	41	6	2025-01-11 11:30:00	Completed	Chronic care
2354	528	11	2020-03-08 14:45:00	Completed	Annual physical
2355	111	1	2021-11-19 13:15:00	Completed	Sick visit
2356	325	4	2023-04-06 13:30:00	Completed	Well child
2357	226	2	2020-12-22 13:00:00	Scheduled	Chronic care
2358	330	8	2025-11-13 12:45:00	Completed	Follow-up
2359	105	4	2024-09-17 14:30:00	Completed	Annual physical
2360	121	7	2019-11-22 15:30:00	Completed	Well child
2361	367	10	2022-01-25 14:45:00	Scheduled	Chronic care
2362	304	1	2020-02-22 09:00:00	Scheduled	Telehealth
2363	306	7	2020-02-13 12:45:00	No-show	Telehealth
2364	336	8	2021-01-18 12:15:00	Completed	Sick visit
2365	224	7	2020-01-14 09:15:00	Completed	Chronic care
2366	292	5	2024-12-17 13:15:00	Completed	Telehealth
2367	596	7	2024-02-07 09:00:00	Completed	Telehealth
2368	252	9	2022-12-24 12:00:00	Completed	Chronic care
2369	188	12	2025-05-05 09:45:00	Completed	Chronic care
2370	595	1	2019-08-02 11:15:00	Completed	Sick visit
2371	485	2	2024-10-18 08:30:00	Completed	Follow-up
2372	137	7	2019-09-17 12:30:00	Cancelled	Follow-up
2373	546	7	2025-08-19 12:45:00	Completed	Chronic care
2374	497	10	2020-08-07 10:00:00	Completed	Annual physical
2375	134	5	2026-04-08 12:15:00	Completed	Telehealth
2376	264	1	2025-03-07 16:45:00	Scheduled	Telehealth
2377	375	7	2023-09-20 15:00:00	Completed	Follow-up
2378	12	4	2023-12-04 14:00:00	Completed	Telehealth
2379	335	11	2020-11-14 14:45:00	Completed	Annual physical
2380	288	6	2020-11-15 12:00:00	Completed	Sick visit
2381	327	6	2022-01-30 08:30:00	Cancelled	Chronic care
2382	87	6	2026-03-28 12:30:00	Completed	Well child
2383	194	4	2022-09-06 17:00:00	Scheduled	Follow-up
2384	44	7	2022-04-06 08:15:00	Completed	Well child
2385	365	7	2021-11-27 12:30:00	Completed	Annual physical
2386	49	4	2021-02-27 08:45:00	Completed	Sick visit
2387	467	4	2019-02-20 10:15:00	Scheduled	Annual physical
2388	308	9	2022-11-07 11:30:00	Completed	Follow-up
2389	178	10	2023-08-20 16:30:00	Completed	Chronic care
2390	402	6	2021-07-25 12:15:00	Completed	Sick visit
2391	95	11	2025-05-18 09:00:00	No-show	Sick visit
2392	145	4	2021-08-18 11:30:00	Cancelled	Annual physical
2393	313	8	2019-12-07 16:15:00	Completed	Annual physical
2394	106	8	2022-06-24 16:45:00	Completed	Telehealth
2395	307	8	2021-01-03 16:15:00	Completed	Well child
2396	580	4	2024-10-17 11:00:00	Completed	Annual physical
2397	278	3	2021-11-03 10:00:00	Completed	Well child
2398	209	1	2022-06-18 09:30:00	Cancelled	Chronic care
2399	549	10	2021-11-30 14:15:00	Completed	Well child
2400	498	3	2024-08-21 10:15:00	Completed	Telehealth
2401	589	12	2024-04-25 09:45:00	Scheduled	Chronic care
2402	122	12	2022-04-07 14:15:00	Completed	Well child
2403	76	4	2024-01-03 08:00:00	Completed	Sick visit
2404	39	4	2023-03-20 09:30:00	Completed	Telehealth
2405	253	4	2022-07-19 15:15:00	Completed	Follow-up
2406	240	12	2022-03-13 10:00:00	Completed	Sick visit
2407	269	3	2020-01-12 16:00:00	Completed	Well child
2408	83	4	2019-02-02 14:45:00	Cancelled	Chronic care
2409	275	5	2025-06-20 11:45:00	Completed	Well child
2410	187	11	2026-02-05 15:30:00	Completed	Telehealth
2411	189	11	2019-06-07 15:45:00	Cancelled	Telehealth
2412	331	1	2026-02-05 09:15:00	Completed	Chronic care
2413	156	10	2022-04-26 08:45:00	Completed	Chronic care
2414	187	11	2023-04-02 13:00:00	Completed	Telehealth
2415	360	1	2020-07-14 13:00:00	No-show	Well child
2416	530	5	2020-08-16 16:15:00	Scheduled	Follow-up
2417	106	8	2020-11-02 08:00:00	Completed	Annual physical
2418	199	10	2020-11-09 14:15:00	Cancelled	Telehealth
2419	156	10	2023-11-01 09:15:00	Scheduled	Chronic care
2420	180	2	2025-06-03 11:45:00	Completed	Follow-up
2421	55	9	2024-04-10 14:30:00	Completed	Well child
2422	111	1	2022-05-21 09:30:00	Completed	Telehealth
2423	461	2	2020-11-18 13:45:00	Completed	Telehealth
2424	11	5	2020-06-14 09:15:00	Completed	Well child
2425	561	8	2019-12-27 17:00:00	Completed	Annual physical
2426	455	2	2025-09-06 09:15:00	Completed	Chronic care
2427	591	10	2020-05-21 11:15:00	Completed	Chronic care
2428	293	1	2020-10-05 16:15:00	Completed	Follow-up
2429	241	5	2022-07-16 12:00:00	Completed	Sick visit
2430	560	6	2020-02-10 08:30:00	Completed	Chronic care
2431	86	6	2025-11-18 09:30:00	Completed	Sick visit
2432	67	11	2019-04-07 14:30:00	Completed	Follow-up
2433	528	10	2024-12-31 09:30:00	Completed	Telehealth
2434	286	1	2024-08-13 12:45:00	No-show	Telehealth
2435	562	5	2021-10-15 09:45:00	Completed	Follow-up
2436	122	12	2020-09-27 08:15:00	Scheduled	Sick visit
2437	386	2	2025-11-14 10:00:00	Scheduled	Annual physical
2438	355	7	2023-09-10 16:00:00	No-show	Chronic care
2439	291	1	2020-01-12 09:00:00	Completed	Chronic care
2440	555	10	2024-07-12 10:00:00	Completed	Chronic care
2441	511	11	2019-04-11 13:00:00	Completed	Follow-up
2442	198	7	2021-08-21 16:00:00	Scheduled	Telehealth
2443	318	12	2024-08-26 15:00:00	Completed	Sick visit
2444	283	4	2020-10-17 09:30:00	Cancelled	Sick visit
2445	469	3	2023-06-22 08:45:00	Scheduled	Sick visit
2446	507	2	2023-01-12 11:45:00	Completed	Follow-up
2447	444	8	2023-01-23 13:15:00	Completed	Follow-up
2448	209	1	2024-01-14 16:45:00	Completed	Chronic care
2449	377	8	2024-10-01 16:30:00	No-show	Annual physical
2450	398	1	2025-02-19 11:00:00	Completed	Chronic care
2451	7	4	2021-11-19 15:00:00	Completed	Telehealth
2452	28	1	2025-01-16 10:00:00	Completed	Sick visit
2453	212	7	2020-05-31 15:15:00	Cancelled	Well child
2454	234	11	2021-01-25 11:00:00	Scheduled	Well child
2455	88	7	2022-02-27 11:00:00	Completed	Annual physical
2456	404	6	2023-08-13 12:00:00	Completed	Annual physical
2457	289	9	2020-12-20 10:30:00	Completed	Annual physical
2458	152	7	2022-10-21 08:30:00	Completed	Follow-up
2459	388	8	2022-02-25 08:15:00	Completed	Sick visit
2460	553	6	2024-03-07 11:15:00	Completed	Follow-up
2461	120	5	2024-01-24 08:00:00	Completed	Sick visit
2462	251	1	2024-03-07 12:45:00	Completed	Telehealth
2463	77	6	2024-08-19 10:45:00	Completed	Annual physical
2464	411	8	2023-12-18 10:00:00	Completed	Follow-up
2465	459	7	2025-01-22 10:30:00	Completed	Well child
2466	190	8	2021-03-23 15:30:00	Completed	Telehealth
2467	139	12	2021-11-19 16:15:00	Cancelled	Chronic care
2468	82	3	2021-02-11 15:45:00	Completed	Follow-up
2469	328	5	2025-10-26 08:15:00	Completed	Telehealth
2470	390	10	2021-08-20 09:30:00	Completed	Chronic care
2471	320	1	2020-08-23 15:30:00	Completed	Follow-up
2472	357	11	2025-10-11 09:00:00	Completed	Sick visit
2473	483	5	2025-04-04 10:00:00	Completed	Well child
2474	97	8	2019-10-17 11:30:00	Cancelled	Follow-up
2475	391	1	2023-01-09 08:00:00	Completed	Chronic care
2476	287	10	2026-04-01 10:00:00	Completed	Telehealth
2477	530	10	2024-08-11 10:15:00	Cancelled	Telehealth
2478	22	10	2026-01-08 12:45:00	Completed	Chronic care
2479	586	4	2021-07-14 10:00:00	Completed	Telehealth
2480	56	9	2023-11-12 17:00:00	Completed	Telehealth
2481	110	5	2022-03-04 16:15:00	Completed	Chronic care
2482	488	5	2022-05-01 16:15:00	Completed	Follow-up
2483	90	7	2023-12-15 13:45:00	Completed	Sick visit
2484	286	1	2021-03-22 14:15:00	Cancelled	Chronic care
2485	307	8	2026-03-07 11:30:00	Completed	Follow-up
2486	25	10	2023-06-19 12:30:00	Completed	Annual physical
2487	72	12	2025-08-31 12:00:00	Cancelled	Well child
2488	79	7	2024-10-15 10:30:00	No-show	Follow-up
2489	534	7	2020-07-12 08:15:00	Completed	Annual physical
2490	484	2	2019-06-13 14:15:00	Scheduled	Sick visit
2491	133	3	2023-12-21 08:15:00	Completed	Sick visit
2492	545	7	2022-12-02 13:15:00	Completed	Follow-up
2493	222	12	2024-02-21 10:15:00	Completed	Annual physical
2494	341	10	2025-04-30 11:30:00	Completed	Follow-up
2495	394	6	2022-01-13 10:30:00	Completed	Telehealth
2496	319	8	2021-01-05 08:00:00	Cancelled	Telehealth
2497	598	8	2024-05-27 14:30:00	Completed	Chronic care
2498	18	1	2020-09-21 12:30:00	Completed	Sick visit
2499	184	2	2022-09-24 14:45:00	Completed	Annual physical
2500	584	11	2019-01-20 15:15:00	Completed	Well child
2501	431	4	2019-01-12 08:30:00	Completed	Well child
2502	443	7	2022-12-02 14:45:00	Completed	Well child
2503	479	7	2022-07-24 16:00:00	Completed	Annual physical
2504	502	9	2024-04-08 13:00:00	Completed	Follow-up
2505	547	4	2021-05-02 17:00:00	Cancelled	Well child
2506	257	3	2022-02-08 15:00:00	No-show	Well child
2507	157	1	2020-02-03 13:45:00	Completed	Well child
2508	585	2	2020-09-30 15:00:00	Completed	Annual physical
2509	549	3	2020-05-15 08:30:00	Completed	Annual physical
2510	376	5	2019-06-07 15:45:00	Cancelled	Well child
2511	111	1	2023-12-07 10:45:00	Completed	Follow-up
2512	144	3	2021-02-23 11:45:00	Completed	Annual physical
2513	481	11	2022-12-12 17:00:00	Scheduled	Chronic care
2514	133	3	2024-02-19 14:30:00	Cancelled	Chronic care
2515	483	7	2019-11-14 17:00:00	Completed	Well child
2516	578	8	2019-06-22 08:00:00	Completed	Follow-up
2517	546	7	2023-05-17 16:30:00	Completed	Annual physical
2518	103	8	2022-04-03 14:30:00	Completed	Sick visit
2519	431	11	2025-09-27 11:30:00	Completed	Sick visit
2520	401	10	2020-04-26 15:00:00	Completed	Chronic care
2521	389	5	2019-09-02 16:45:00	No-show	Annual physical
2522	404	6	2024-09-21 16:15:00	Completed	Follow-up
2523	97	11	2023-08-14 15:30:00	Completed	Annual physical
2524	468	7	2020-04-08 15:00:00	Completed	Annual physical
2525	175	2	2025-10-06 13:30:00	Completed	Well child
2526	449	7	2023-02-25 10:00:00	Cancelled	Well child
2527	491	7	2020-10-14 17:00:00	Completed	Sick visit
2528	181	3	2021-08-27 08:15:00	Cancelled	Follow-up
2529	419	12	2024-07-29 10:30:00	Completed	Follow-up
2530	123	5	2022-03-23 15:00:00	Completed	Telehealth
2531	108	3	2025-03-31 15:45:00	Completed	Telehealth
2532	554	11	2024-11-12 09:45:00	Completed	Well child
2533	235	3	2025-05-27 14:15:00	No-show	Sick visit
2534	56	2	2020-09-05 14:30:00	Completed	Sick visit
2535	246	1	2023-03-15 13:15:00	Completed	Chronic care
2536	216	1	2024-03-02 12:15:00	Cancelled	Sick visit
2537	300	2	2026-01-05 14:00:00	Completed	Sick visit
2538	305	2	2025-06-22 11:45:00	No-show	Follow-up
2539	356	4	2022-11-09 14:00:00	Completed	Sick visit
2540	261	6	2024-08-02 15:00:00	Completed	Sick visit
2541	366	12	2021-08-10 15:00:00	Scheduled	Chronic care
2542	456	1	2021-04-17 08:15:00	Completed	Follow-up
2543	259	6	2024-03-27 09:30:00	Completed	Well child
2544	575	3	2019-05-13 11:00:00	Completed	Sick visit
2545	17	6	2025-11-25 11:30:00	Completed	Follow-up
2546	448	7	2022-04-11 13:45:00	Completed	Annual physical
2547	405	7	2024-01-10 13:15:00	Cancelled	Sick visit
2548	496	3	2020-11-16 14:15:00	Cancelled	Follow-up
2549	249	9	2020-05-14 15:45:00	Completed	Annual physical
2550	8	8	2024-08-06 14:15:00	Completed	Well child
2551	463	2	2023-11-10 14:30:00	Completed	Telehealth
2552	558	11	2021-10-28 12:30:00	Completed	Well child
2553	402	6	2026-02-02 16:00:00	Cancelled	Annual physical
2554	535	5	2020-12-02 09:15:00	Completed	Follow-up
2555	574	5	2023-12-14 13:30:00	No-show	Telehealth
2556	278	3	2024-09-05 16:15:00	Completed	Well child
2557	497	10	2025-03-26 09:00:00	Completed	Chronic care
2558	34	5	2025-07-13 14:30:00	Completed	Follow-up
2559	318	12	2023-01-07 12:45:00	Cancelled	Telehealth
2560	316	9	2025-07-21 08:45:00	Cancelled	Well child
2561	100	2	2022-05-28 10:15:00	Completed	Telehealth
2562	31	11	2019-02-17 11:30:00	No-show	Sick visit
2563	164	2	2024-10-16 13:00:00	No-show	Chronic care
2564	140	8	2025-07-26 10:45:00	Completed	Annual physical
2565	161	11	2019-07-01 16:45:00	Completed	Chronic care
2566	324	1	2024-06-30 09:30:00	Completed	Telehealth
2567	354	8	2023-07-18 16:30:00	Completed	Well child
2568	487	9	2025-06-22 16:15:00	Completed	Telehealth
2569	365	7	2021-04-30 08:30:00	Completed	Follow-up
2570	561	8	2019-10-25 15:15:00	Completed	Well child
2571	51	12	2020-09-01 12:45:00	Completed	Sick visit
2572	359	8	2022-04-05 14:45:00	Completed	Sick visit
2573	336	8	2024-07-28 13:15:00	Completed	Sick visit
2574	248	9	2021-11-19 09:30:00	Completed	Annual physical
2575	327	10	2023-08-05 13:00:00	Completed	Follow-up
2576	590	3	2023-07-22 14:30:00	Completed	Sick visit
2577	118	1	2022-05-18 14:45:00	Completed	Sick visit
2578	317	6	2024-02-20 16:45:00	Completed	Telehealth
2579	304	11	2026-03-24 12:00:00	Completed	Follow-up
2580	429	5	2019-10-16 16:30:00	Completed	Follow-up
2581	521	11	2026-02-10 08:00:00	Completed	Chronic care
2582	354	8	2020-12-19 11:15:00	Scheduled	Chronic care
2583	235	8	2022-03-23 10:15:00	Completed	Well child
2584	54	11	2019-09-08 17:00:00	Completed	Telehealth
2585	55	9	2022-09-09 09:15:00	Completed	Well child
2586	565	11	2020-08-25 10:45:00	Cancelled	Well child
2587	525	6	2019-02-26 13:00:00	Completed	Well child
2588	142	12	2024-08-11 10:45:00	Cancelled	Sick visit
2589	138	9	2021-11-29 13:15:00	Completed	Well child
2590	521	11	2025-08-01 10:00:00	Completed	Annual physical
2591	441	6	2021-07-25 12:00:00	Scheduled	Follow-up
2592	284	5	2021-07-05 14:00:00	Completed	Well child
2593	93	1	2024-06-30 15:15:00	Completed	Chronic care
2594	395	10	2023-12-10 16:30:00	Completed	Annual physical
2595	547	4	2020-10-08 08:00:00	Cancelled	Well child
2596	125	11	2019-10-30 13:45:00	Completed	Annual physical
2597	388	7	2022-05-14 16:00:00	Cancelled	Well child
2598	516	12	2023-08-01 16:45:00	Completed	Sick visit
2599	28	10	2020-03-06 12:30:00	No-show	Annual physical
2600	89	12	2025-08-21 12:15:00	Completed	Follow-up
2601	123	1	2023-11-08 15:30:00	Completed	Chronic care
2602	361	3	2024-12-18 10:15:00	Completed	Follow-up
2603	151	3	2026-03-15 15:00:00	Completed	Telehealth
2604	226	11	2025-02-26 16:00:00	Completed	Telehealth
2605	453	1	2019-03-31 08:45:00	Completed	Well child
2606	43	6	2024-05-24 08:45:00	No-show	Well child
2607	134	5	2023-03-15 14:15:00	Cancelled	Follow-up
2608	338	11	2021-04-18 12:30:00	No-show	Follow-up
2609	13	2	2024-08-28 08:00:00	Completed	Sick visit
2610	104	10	2024-05-22 09:30:00	Completed	Chronic care
2611	30	1	2024-03-17 10:00:00	Completed	Telehealth
2612	581	4	2025-01-03 12:00:00	Completed	Telehealth
2613	547	4	2020-12-13 16:45:00	Completed	Sick visit
2614	535	5	2025-10-17 09:30:00	Cancelled	Sick visit
2615	230	10	2024-10-20 11:00:00	Completed	Well child
2616	116	7	2026-02-13 15:30:00	Completed	Well child
2617	66	4	2019-04-19 13:15:00	Completed	Well child
2618	212	7	2022-01-02 15:30:00	Completed	Telehealth
2619	562	5	2025-05-16 12:15:00	Completed	Telehealth
2620	501	12	2022-04-22 10:15:00	Completed	Well child
2621	418	9	2021-05-25 12:00:00	Completed	Sick visit
2622	541	11	2023-08-19 12:45:00	Completed	Follow-up
2623	280	1	2021-06-23 09:00:00	Scheduled	Annual physical
2624	368	12	2023-08-24 11:00:00	Completed	Annual physical
2625	413	8	2019-03-08 15:15:00	Completed	Telehealth
2626	298	9	2024-01-18 09:30:00	Completed	Well child
2627	4	2	2019-10-10 11:15:00	Completed	Follow-up
2628	204	2	2024-06-20 09:15:00	Completed	Telehealth
2629	515	5	2025-11-02 10:45:00	Completed	Chronic care
2630	109	7	2020-02-04 15:45:00	Completed	Follow-up
2631	269	9	2021-03-08 16:45:00	No-show	Well child
2632	203	11	2022-10-02 14:00:00	Completed	Well child
2633	352	9	2020-01-21 14:30:00	Completed	Chronic care
2634	529	6	2023-01-01 16:00:00	Completed	Chronic care
2635	9	8	2025-10-22 15:00:00	Cancelled	Annual physical
2636	53	8	2025-10-10 16:45:00	Cancelled	Well child
2637	497	10	2024-02-13 12:45:00	No-show	Follow-up
2638	411	8	2024-02-17 13:30:00	Completed	Sick visit
2639	325	4	2021-06-19 08:30:00	Completed	Follow-up
2640	536	11	2020-07-11 11:15:00	Completed	Chronic care
2641	268	1	2025-02-22 12:15:00	Completed	Sick visit
2642	15	8	2021-05-14 11:15:00	Completed	Annual physical
2643	596	7	2019-09-29 13:45:00	Cancelled	Sick visit
2644	418	5	2022-08-27 16:00:00	Completed	Follow-up
2645	445	9	2026-04-23 13:15:00	Completed	Follow-up
2646	253	12	2024-04-04 13:15:00	No-show	Annual physical
2647	59	10	2021-12-13 16:30:00	Completed	Annual physical
2648	386	2	2020-10-16 15:00:00	Completed	Telehealth
2649	92	9	2025-10-09 14:30:00	Completed	Telehealth
2650	553	6	2020-01-02 15:15:00	Completed	Sick visit
2651	34	5	2023-06-02 14:15:00	Completed	Annual physical
2652	298	9	2024-03-21 13:00:00	Scheduled	Telehealth
2653	509	2	2025-05-29 12:30:00	Scheduled	Telehealth
2654	421	6	2021-09-14 10:30:00	Completed	Sick visit
2655	146	10	2023-01-16 16:00:00	Completed	Telehealth
2656	250	4	2022-11-22 10:30:00	No-show	Well child
2657	493	1	2023-01-23 08:15:00	Completed	Chronic care
2658	258	8	2023-06-08 16:45:00	Completed	Follow-up
2659	521	11	2020-06-29 12:45:00	Completed	Chronic care
2660	58	11	2024-03-08 16:00:00	Scheduled	Annual physical
2661	569	8	2024-01-19 14:15:00	Completed	Well child
2662	183	1	2026-05-15 15:45:00	Completed	Well child
2663	475	5	2025-04-23 16:30:00	Completed	Well child
2664	312	3	2024-06-26 16:15:00	Completed	Sick visit
2665	553	6	2022-02-12 14:15:00	No-show	Telehealth
2666	56	2	2020-02-13 15:00:00	No-show	Telehealth
2667	255	10	2024-10-13 17:00:00	No-show	Follow-up
2668	316	2	2025-08-23 15:15:00	Completed	Telehealth
2669	433	7	2025-04-02 16:30:00	Completed	Telehealth
2670	82	3	2025-06-13 08:45:00	Completed	Annual physical
2671	48	10	2024-11-09 13:45:00	Completed	Telehealth
2672	194	4	2022-08-16 13:45:00	Completed	Well child
2673	146	10	2021-05-22 11:45:00	No-show	Well child
2674	185	8	2019-04-21 11:00:00	Completed	Telehealth
2675	508	3	2023-08-17 09:15:00	Completed	Telehealth
2676	482	4	2020-10-20 08:30:00	Completed	Annual physical
2677	417	4	2024-04-23 14:00:00	Cancelled	Chronic care
2678	258	8	2021-09-29 14:45:00	Completed	Sick visit
2679	40	3	2020-11-10 13:45:00	Completed	Well child
2680	455	8	2023-05-15 15:30:00	Completed	Annual physical
2681	388	8	2023-11-11 09:15:00	Completed	Annual physical
2682	518	9	2024-09-12 14:45:00	Completed	Annual physical
2683	522	2	2024-05-31 15:15:00	Completed	Chronic care
2684	453	1	2022-05-18 12:15:00	Completed	Follow-up
2685	187	11	2019-11-19 11:30:00	No-show	Well child
2686	579	12	2021-12-30 09:30:00	Completed	Annual physical
2687	192	6	2021-10-13 08:30:00	Completed	Telehealth
2688	495	4	2025-03-06 14:30:00	Completed	Telehealth
2689	190	8	2023-03-16 08:30:00	Completed	Follow-up
2690	549	3	2025-11-30 16:45:00	Completed	Well child
2691	368	12	2020-08-13 14:00:00	Completed	Follow-up
2692	400	6	2020-06-22 08:30:00	Completed	Follow-up
2693	34	5	2020-03-02 08:15:00	Completed	Chronic care
2694	113	2	2025-03-20 09:45:00	Completed	Annual physical
2695	58	11	2019-03-27 09:15:00	Completed	Telehealth
2696	254	11	2024-04-05 16:15:00	Completed	Well child
2697	209	12	2020-05-31 17:00:00	Completed	Chronic care
2698	475	7	2022-10-24 10:30:00	Cancelled	Chronic care
2699	91	8	2024-02-15 12:00:00	Completed	Sick visit
2700	346	10	2021-02-05 09:15:00	Completed	Sick visit
2701	427	9	2022-10-28 10:15:00	Completed	Chronic care
2702	195	8	2021-09-05 10:15:00	Completed	Well child
2703	532	12	2024-07-04 11:00:00	Completed	Telehealth
2704	90	5	2025-03-29 13:00:00	Cancelled	Chronic care
2705	501	12	2025-10-07 10:15:00	Completed	Well child
2706	482	4	2021-08-25 08:30:00	Scheduled	Follow-up
2707	135	8	2019-02-25 12:30:00	Completed	Well child
2708	94	9	2021-02-07 14:45:00	Completed	Follow-up
2709	391	11	2025-08-27 11:45:00	Completed	Sick visit
2710	506	8	2024-05-27 16:30:00	Scheduled	Follow-up
2711	571	11	2021-09-23 09:30:00	Completed	Sick visit
2712	505	3	2025-12-30 15:15:00	Completed	Sick visit
2713	403	4	2024-06-28 12:15:00	Completed	Well child
2714	244	10	2019-02-16 16:30:00	Completed	Chronic care
2715	421	11	2022-05-12 10:15:00	Completed	Annual physical
2716	376	4	2022-02-04 14:30:00	Completed	Sick visit
2717	458	8	2025-07-26 16:45:00	Completed	Follow-up
2718	193	9	2020-09-23 11:15:00	Completed	Telehealth
2719	138	9	2025-06-08 08:00:00	No-show	Follow-up
2720	437	4	2019-11-29 15:15:00	Completed	Follow-up
2721	281	3	2026-02-16 16:00:00	Completed	Sick visit
2722	425	12	2025-01-13 08:00:00	Completed	Sick visit
2723	36	2	2023-08-14 08:15:00	Completed	Annual physical
2724	378	4	2020-08-19 13:45:00	Completed	Well child
2725	596	8	2025-08-17 10:45:00	Completed	Follow-up
2726	323	5	2024-03-18 13:30:00	Completed	Well child
2727	472	4	2019-09-28 16:00:00	Cancelled	Follow-up
2728	352	9	2024-03-01 15:45:00	Cancelled	Sick visit
2729	267	4	2025-12-04 13:45:00	Completed	Well child
2730	266	7	2020-03-22 08:15:00	Completed	Annual physical
2731	460	6	2020-08-24 14:45:00	Completed	Follow-up
2732	128	6	2020-06-05 09:45:00	Completed	Annual physical
2733	598	8	2022-12-19 14:15:00	Completed	Sick visit
2734	289	9	2019-01-18 14:15:00	Scheduled	Follow-up
2735	411	8	2019-07-01 16:30:00	Completed	Sick visit
2736	202	4	2022-09-08 16:15:00	No-show	Annual physical
2737	422	5	2021-02-03 09:15:00	Completed	Sick visit
2738	402	1	2019-10-01 09:00:00	Completed	Annual physical
2739	353	7	2025-01-05 12:00:00	Completed	Sick visit
2740	360	12	2019-05-07 12:45:00	Completed	Chronic care
2741	406	8	2024-05-18 12:15:00	Scheduled	Follow-up
2742	409	6	2026-03-31 13:00:00	Completed	Well child
2743	572	2	2024-11-06 09:00:00	Completed	Follow-up
2744	172	9	2023-03-04 14:15:00	No-show	Sick visit
2745	488	5	2020-02-08 14:15:00	No-show	Chronic care
2746	351	2	2023-04-09 12:30:00	Completed	Follow-up
2747	404	6	2021-04-21 15:15:00	Completed	Well child
2748	241	9	2024-03-21 15:30:00	Completed	Annual physical
2749	558	2	2021-07-25 14:45:00	Cancelled	Annual physical
2750	119	6	2022-09-09 10:00:00	Completed	Follow-up
2751	253	4	2025-10-04 14:30:00	Completed	Sick visit
2752	586	4	2024-08-22 15:15:00	Completed	Chronic care
2753	529	6	2024-11-29 17:00:00	Completed	Sick visit
2754	513	5	2021-08-16 09:15:00	Completed	Sick visit
2755	408	6	2023-04-14 11:15:00	No-show	Annual physical
2756	559	7	2020-05-02 11:15:00	Completed	Sick visit
2757	400	6	2025-05-01 08:00:00	Completed	Annual physical
2758	475	7	2021-01-09 14:15:00	Completed	Follow-up
2759	118	12	2021-08-15 14:30:00	Completed	Well child
2760	166	10	2022-03-24 08:45:00	Completed	Chronic care
2761	219	11	2021-03-04 14:15:00	Scheduled	Sick visit
2762	464	5	2024-08-07 12:30:00	Completed	Follow-up
2763	142	11	2025-09-17 14:00:00	Scheduled	Well child
2764	443	7	2022-08-18 16:00:00	Completed	Annual physical
2765	517	4	2023-09-10 12:00:00	Completed	Follow-up
2766	284	5	2020-07-17 09:30:00	Completed	Telehealth
2767	113	11	2021-11-16 11:00:00	Completed	Follow-up
2768	428	10	2024-08-15 13:15:00	No-show	Telehealth
2769	346	12	2019-04-01 14:30:00	Completed	Well child
2770	305	2	2020-02-20 14:30:00	No-show	Follow-up
2771	551	4	2020-06-25 08:45:00	Completed	Follow-up
2772	128	6	2020-10-16 13:00:00	Completed	Well child
2773	298	3	2021-05-21 10:30:00	Completed	Telehealth
2774	515	5	2025-01-21 13:45:00	Completed	Well child
2775	326	2	2023-05-16 15:15:00	Completed	Chronic care
2776	168	2	2019-03-03 12:15:00	Completed	Chronic care
2777	586	1	2021-12-28 12:15:00	Completed	Follow-up
2778	213	2	2025-07-06 08:30:00	No-show	Follow-up
2779	387	5	2021-05-02 15:30:00	Completed	Well child
2780	523	7	2025-12-18 09:00:00	Completed	Well child
2781	254	11	2025-09-15 08:15:00	Completed	Telehealth
2782	142	12	2020-06-03 15:30:00	Completed	Telehealth
2783	65	11	2020-09-24 09:30:00	Completed	Sick visit
2784	195	8	2026-04-01 16:30:00	Completed	Follow-up
2785	219	11	2022-12-21 09:15:00	Completed	Chronic care
2786	547	4	2024-10-22 12:00:00	Completed	Annual physical
2787	116	7	2021-01-17 13:30:00	No-show	Sick visit
2788	422	1	2020-09-04 16:15:00	No-show	Well child
2789	345	1	2025-06-04 14:15:00	Completed	Well child
2790	497	2	2019-06-04 14:15:00	Completed	Chronic care
2791	486	2	2024-01-22 13:00:00	Completed	Chronic care
2792	372	9	2024-11-13 11:15:00	Completed	Annual physical
2793	554	6	2026-01-05 09:45:00	Completed	Chronic care
2794	350	9	2025-03-06 12:45:00	Completed	Well child
2795	380	7	2020-05-17 14:00:00	Completed	Annual physical
2796	420	12	2023-07-29 09:15:00	Completed	Sick visit
2797	308	9	2020-11-10 15:30:00	Completed	Well child
2798	378	4	2020-02-28 14:00:00	Completed	Follow-up
2799	350	12	2021-06-14 11:15:00	Completed	Chronic care
2800	218	5	2024-08-08 11:00:00	Completed	Follow-up
2801	406	8	2023-01-01 15:45:00	Completed	Annual physical
2802	134	5	2022-04-17 10:00:00	Completed	Follow-up
2803	531	11	2024-07-10 15:45:00	Completed	Sick visit
2804	163	5	2023-06-03 15:45:00	Completed	Annual physical
2805	205	10	2020-03-22 14:45:00	Completed	Chronic care
2806	394	6	2026-05-06 10:45:00	Completed	Annual physical
2807	114	7	2025-10-29 08:30:00	Completed	Well child
2808	298	9	2022-08-06 16:00:00	Completed	Follow-up
2809	149	4	2021-03-13 13:45:00	Completed	Sick visit
2810	11	5	2025-06-22 10:30:00	Completed	Sick visit
2811	163	5	2022-12-07 09:00:00	Completed	Well child
2812	184	2	2019-03-04 12:00:00	Completed	Well child
2813	487	9	2025-02-02 09:00:00	Completed	Well child
2814	57	5	2024-04-07 10:30:00	Completed	Sick visit
2815	372	10	2019-01-19 12:30:00	Cancelled	Telehealth
2816	13	1	2025-06-08 12:00:00	Cancelled	Follow-up
2817	18	4	2025-11-24 11:15:00	Completed	Chronic care
2818	481	11	2026-01-26 12:15:00	Completed	Telehealth
2819	457	10	2019-08-29 15:45:00	Completed	Annual physical
2820	575	3	2024-11-25 11:45:00	Completed	Annual physical
2821	268	1	2020-12-17 14:15:00	Completed	Chronic care
2822	421	6	2023-09-30 13:00:00	Completed	Follow-up
2823	176	1	2023-02-21 10:00:00	Completed	Chronic care
2824	80	10	2025-04-10 16:30:00	Completed	Annual physical
2825	337	4	2024-11-01 15:30:00	Completed	Annual physical
2826	422	3	2019-05-26 16:45:00	Completed	Sick visit
2827	431	5	2026-03-21 15:30:00	Completed	Sick visit
2828	292	9	2021-07-16 15:15:00	Completed	Well child
2829	203	11	2019-11-06 11:45:00	Completed	Sick visit
2830	257	2	2019-09-27 08:45:00	Cancelled	Follow-up
2831	309	9	2022-08-13 14:15:00	Completed	Well child
2832	417	4	2024-11-19 14:00:00	Completed	Chronic care
2833	103	8	2025-04-15 10:45:00	Completed	Follow-up
2834	446	12	2021-03-20 09:15:00	Scheduled	Follow-up
2835	488	5	2025-02-27 13:15:00	Completed	Telehealth
2836	249	9	2023-12-25 15:45:00	No-show	Sick visit
2837	15	8	2019-02-21 10:00:00	No-show	Telehealth
2838	483	2	2022-02-09 09:45:00	Completed	Annual physical
2839	79	4	2023-07-03 12:30:00	Completed	Telehealth
2840	310	9	2023-08-29 10:45:00	Completed	Telehealth
2841	111	1	2022-08-23 16:30:00	Completed	Well child
2842	326	12	2024-01-16 11:15:00	Completed	Sick visit
2843	364	4	2025-11-07 16:00:00	Scheduled	Follow-up
2844	282	5	2022-09-29 09:30:00	Completed	Telehealth
2845	206	11	2020-07-19 09:15:00	Completed	Sick visit
2846	73	4	2024-05-21 09:00:00	Completed	Annual physical
2847	369	5	2022-05-02 14:30:00	Completed	Annual physical
2848	35	12	2022-01-10 15:45:00	Completed	Annual physical
2849	264	6	2023-02-17 15:15:00	Completed	Chronic care
2850	121	7	2023-07-11 13:45:00	Completed	Telehealth
2851	398	1	2025-04-14 13:15:00	Completed	Telehealth
2852	455	7	2024-10-04 08:00:00	Completed	Chronic care
2853	19	5	2020-07-13 08:30:00	Completed	Telehealth
2854	188	9	2020-03-19 08:15:00	Completed	Annual physical
2855	371	6	2025-03-17 16:45:00	Completed	Chronic care
2856	100	2	2020-12-19 11:30:00	Completed	Sick visit
2857	530	5	2022-04-01 16:45:00	Cancelled	Telehealth
2858	512	9	2026-05-05 10:00:00	Completed	Well child
2859	321	5	2020-09-05 10:15:00	Completed	Well child
2860	311	11	2019-11-24 09:45:00	Cancelled	Well child
2861	168	8	2024-03-25 10:30:00	Completed	Follow-up
2862	254	11	2023-12-22 08:15:00	Scheduled	Sick visit
2863	142	12	2020-04-01 16:00:00	Completed	Well child
2864	426	7	2026-04-30 14:15:00	Completed	Telehealth
2865	410	1	2026-04-02 12:00:00	Cancelled	Well child
2866	313	8	2026-03-18 09:00:00	Completed	Sick visit
2867	158	8	2022-09-05 16:45:00	Completed	Well child
2868	210	2	2020-02-21 08:45:00	No-show	Annual physical
2869	545	7	2020-03-30 09:15:00	Completed	Sick visit
2870	359	12	2020-12-21 14:15:00	Completed	Well child
2871	96	1	2024-04-16 10:30:00	Completed	Annual physical
2872	170	9	2020-08-06 12:15:00	Completed	Annual physical
2873	111	1	2021-03-20 12:00:00	Completed	Annual physical
2874	141	12	2022-07-25 15:15:00	Completed	Annual physical
2875	58	11	2025-05-14 08:30:00	No-show	Chronic care
2876	557	10	2022-07-10 11:00:00	Cancelled	Well child
2877	453	1	2021-04-05 14:15:00	Cancelled	Telehealth
2878	294	11	2020-12-09 09:30:00	Completed	Annual physical
2879	410	12	2020-03-25 13:00:00	Completed	Sick visit
2880	223	8	2022-12-18 13:45:00	Completed	Chronic care
2881	461	2	2024-09-24 12:00:00	Completed	Telehealth
2882	74	8	2021-04-03 14:15:00	Completed	Chronic care
2883	396	3	2024-06-25 16:00:00	Completed	Telehealth
2884	71	4	2021-03-30 08:30:00	Completed	Chronic care
2885	440	7	2020-04-25 13:15:00	Completed	Telehealth
2886	73	6	2024-01-28 09:30:00	Completed	Follow-up
2887	155	12	2022-08-09 16:30:00	Completed	Chronic care
2888	405	7	2022-12-10 13:45:00	Completed	Well child
2889	423	4	2024-08-09 15:30:00	Completed	Sick visit
2890	344	11	2019-03-07 16:15:00	Completed	Telehealth
2891	474	11	2021-09-27 14:00:00	Completed	Telehealth
2892	529	6	2021-08-28 10:45:00	Completed	Annual physical
2893	254	11	2019-10-21 09:45:00	Cancelled	Chronic care
2894	415	12	2021-12-17 10:00:00	Completed	Telehealth
2895	11	5	2022-03-16 16:30:00	Completed	Annual physical
2896	371	6	2023-08-12 15:30:00	Completed	Telehealth
2897	171	12	2024-10-05 16:15:00	Cancelled	Telehealth
2898	157	1	2021-08-16 09:30:00	Completed	Annual physical
2899	97	8	2023-04-11 10:15:00	Completed	Well child
2900	154	8	2020-02-02 15:15:00	Completed	Well child
2901	563	4	2022-06-07 08:15:00	Completed	Annual physical
2902	200	5	2023-01-13 12:15:00	Completed	Follow-up
2903	427	9	2019-01-26 11:45:00	Completed	Follow-up
2904	176	1	2022-01-27 17:00:00	Cancelled	Well child
2905	523	7	2023-12-06 16:00:00	Completed	Follow-up
2906	100	2	2020-09-24 14:00:00	Completed	Follow-up
2907	534	10	2025-05-19 09:15:00	Completed	Chronic care
2908	129	11	2024-10-09 10:00:00	Completed	Chronic care
2909	446	12	2022-12-15 08:45:00	Completed	Follow-up
2910	66	4	2020-05-05 16:15:00	No-show	Chronic care
2911	184	2	2021-09-29 10:30:00	Cancelled	Follow-up
2912	421	6	2023-08-23 12:00:00	Completed	Chronic care
2913	212	2	2019-07-28 08:45:00	Cancelled	Chronic care
2914	571	7	2019-06-11 11:45:00	No-show	Follow-up
2915	510	12	2019-04-17 16:15:00	Cancelled	Chronic care
2916	61	3	2021-12-25 15:45:00	Completed	Chronic care
2917	334	10	2023-09-27 14:45:00	Scheduled	Chronic care
2918	19	10	2019-03-23 14:30:00	Completed	Sick visit
2919	191	11	2021-07-19 09:45:00	Completed	Telehealth
2920	545	7	2020-02-22 15:00:00	Completed	Well child
2921	50	7	2021-06-25 11:30:00	Completed	Sick visit
2922	265	1	2020-02-02 09:30:00	Completed	Follow-up
2923	374	6	2026-03-04 08:00:00	Completed	Annual physical
2924	25	4	2024-04-18 16:30:00	Completed	Follow-up
2925	413	8	2019-06-09 15:15:00	Completed	Annual physical
2926	301	6	2025-08-25 12:30:00	Completed	Well child
2927	159	1	2022-11-12 08:15:00	Completed	Sick visit
2928	81	8	2024-12-31 08:00:00	Completed	Well child
2929	347	1	2023-08-20 16:30:00	Completed	Sick visit
2930	328	7	2019-11-30 09:30:00	Completed	Telehealth
2931	16	2	2024-12-19 10:45:00	Completed	Well child
2932	459	7	2022-05-23 15:30:00	Completed	Well child
2933	451	4	2019-10-09 12:00:00	Completed	Follow-up
2934	142	12	2019-12-29 09:00:00	Completed	Sick visit
2935	387	5	2025-08-21 09:15:00	Cancelled	Well child
2936	248	9	2023-03-03 09:30:00	Completed	Annual physical
2937	160	7	2020-07-27 11:15:00	Completed	Sick visit
2938	554	6	2021-06-15 13:00:00	Completed	Follow-up
2939	528	7	2022-02-01 16:15:00	Completed	Well child
2940	588	4	2022-08-24 13:15:00	Scheduled	Chronic care
2941	344	10	2022-03-18 10:30:00	Completed	Telehealth
2942	346	9	2020-09-07 09:00:00	Completed	Sick visit
2943	319	11	2022-04-16 10:00:00	Completed	Chronic care
2944	359	12	2025-01-11 14:15:00	Scheduled	Telehealth
2945	229	5	2022-07-01 08:30:00	Completed	Telehealth
2946	350	9	2020-12-12 10:30:00	Cancelled	Annual physical
2947	118	1	2021-03-11 11:00:00	Completed	Telehealth
2948	222	12	2022-04-27 10:30:00	Completed	Telehealth
2949	126	12	2022-07-28 09:00:00	Completed	Annual physical
2950	208	7	2023-12-27 12:15:00	Completed	Annual physical
2951	151	3	2020-06-22 09:00:00	Scheduled	Well child
2952	469	12	2023-02-04 10:00:00	Cancelled	Chronic care
2953	351	2	2020-09-03 15:00:00	Completed	Annual physical
2954	392	6	2021-01-14 11:00:00	Completed	Telehealth
2955	593	6	2022-07-15 10:30:00	Completed	Follow-up
2956	432	3	2022-08-31 15:00:00	Completed	Telehealth
2957	350	9	2021-06-19 11:45:00	Completed	Follow-up
2958	199	10	2019-05-13 14:15:00	Completed	Well child
2959	388	8	2023-03-22 17:00:00	Completed	Annual physical
2960	518	11	2026-01-14 17:00:00	Cancelled	Telehealth
2961	470	12	2021-08-28 09:00:00	Completed	Annual physical
2962	527	8	2021-10-28 11:15:00	Completed	Sick visit
2963	545	9	2024-01-13 09:00:00	No-show	Follow-up
2964	134	1	2025-06-18 14:30:00	Completed	Telehealth
2965	334	10	2025-10-25 08:00:00	Completed	Annual physical
2966	492	7	2019-08-19 10:45:00	Completed	Annual physical
2967	51	12	2022-02-28 14:45:00	Completed	Chronic care
2968	99	3	2023-04-22 14:45:00	Completed	Well child
2969	435	6	2022-05-18 15:15:00	Completed	Telehealth
2970	499	7	2021-09-21 08:00:00	Completed	Sick visit
2971	377	8	2025-03-04 15:00:00	Cancelled	Follow-up
2972	192	6	2023-04-30 17:00:00	Completed	Well child
2973	19	5	2020-02-02 11:45:00	Scheduled	Sick visit
2974	91	8	2025-05-04 14:00:00	Completed	Well child
2975	392	6	2019-10-20 15:15:00	Scheduled	Follow-up
2976	239	11	2026-03-14 15:15:00	Completed	Telehealth
2977	453	1	2023-06-05 17:00:00	No-show	Telehealth
2978	513	5	2025-03-19 10:00:00	Completed	Follow-up
2979	296	4	2020-01-07 15:15:00	Completed	Chronic care
2980	90	9	2024-08-11 12:30:00	Completed	Well child
2981	275	5	2024-10-07 13:45:00	Completed	Chronic care
2982	224	1	2023-06-17 11:00:00	Completed	Annual physical
2983	504	3	2024-08-02 12:15:00	Completed	Sick visit
2984	452	4	2024-08-24 14:00:00	Completed	Sick visit
2985	35	12	2024-01-10 16:00:00	Completed	Chronic care
2986	270	5	2021-06-09 09:30:00	Completed	Annual physical
2987	328	7	2025-08-19 14:00:00	Scheduled	Well child
2988	10	10	2020-05-16 12:45:00	Cancelled	Chronic care
2989	134	5	2026-03-22 09:15:00	No-show	Well child
2990	512	2	2024-01-09 08:00:00	Completed	Sick visit
2991	79	9	2026-01-03 08:15:00	Scheduled	Sick visit
2992	351	2	2025-06-18 08:15:00	Scheduled	Well child
2993	427	9	2019-05-15 13:00:00	Completed	Well child
2994	145	4	2026-01-24 11:00:00	Completed	Annual physical
2995	333	2	2019-12-20 15:45:00	Scheduled	Follow-up
2996	133	3	2023-12-18 09:30:00	No-show	Well child
2997	301	5	2026-02-03 08:30:00	Scheduled	Follow-up
2998	229	2	2024-12-12 14:00:00	Completed	Chronic care
2999	433	7	2026-03-23 13:45:00	Completed	Telehealth
3000	406	8	2019-11-14 13:15:00	Completed	Sick visit
3001	3	12	2025-07-25 13:30:00	Completed	Sick visit
3002	212	7	2021-02-03 12:30:00	Completed	Sick visit
3003	51	12	2024-09-17 11:30:00	Completed	Well child
3004	74	8	2020-05-24 13:15:00	Completed	Annual physical
3005	349	10	2023-02-05 16:45:00	Completed	Follow-up
3006	175	4	2022-01-10 16:45:00	Completed	Sick visit
3007	445	9	2020-06-13 13:30:00	Completed	Chronic care
3008	59	10	2022-11-12 09:15:00	Completed	Well child
3009	358	9	2024-01-25 14:15:00	Completed	Sick visit
3010	93	4	2025-11-13 14:00:00	Cancelled	Well child
3011	67	3	2024-11-15 08:45:00	Completed	Telehealth
3012	552	8	2025-10-17 13:15:00	Completed	Follow-up
3013	98	5	2022-04-08 10:15:00	Completed	Follow-up
3014	530	5	2021-09-11 10:30:00	Completed	Chronic care
3015	317	6	2020-04-28 09:45:00	Completed	Telehealth
3016	305	9	2024-08-09 14:15:00	Completed	Follow-up
3017	302	9	2024-07-12 15:15:00	Completed	Telehealth
3018	291	7	2021-03-06 11:00:00	Cancelled	Sick visit
3019	545	7	2025-04-23 15:30:00	Completed	Sick visit
3020	141	12	2025-03-19 14:15:00	Completed	Sick visit
3021	122	12	2021-04-18 16:30:00	Completed	Annual physical
3022	387	5	2020-12-04 14:00:00	Completed	Follow-up
3023	84	7	2019-12-11 13:30:00	Completed	Follow-up
3024	267	8	2022-10-04 08:00:00	No-show	Telehealth
3025	355	6	2023-06-30 11:45:00	Completed	Sick visit
3026	560	10	2023-01-07 14:00:00	Completed	Sick visit
3027	396	3	2024-09-16 10:45:00	Scheduled	Chronic care
3028	472	4	2023-01-06 16:45:00	Completed	Chronic care
3029	7	4	2019-01-26 08:15:00	Cancelled	Sick visit
3030	352	4	2021-01-01 11:00:00	Completed	Well child
3031	584	11	2022-04-05 11:30:00	Completed	Follow-up
3032	237	8	2024-12-08 13:15:00	Completed	Annual physical
3033	412	7	2025-10-05 08:30:00	Completed	Well child
3034	343	3	2025-12-27 14:00:00	Completed	Well child
3035	280	1	2022-07-19 10:45:00	Completed	Annual physical
3036	56	2	2021-09-03 12:45:00	Completed	Follow-up
3037	104	10	2026-03-10 10:30:00	Completed	Annual physical
3038	184	2	2021-02-28 08:45:00	Completed	Telehealth
3039	154	11	2025-09-22 08:30:00	Completed	Telehealth
3040	223	8	2019-11-30 16:45:00	Scheduled	Well child
3041	426	5	2023-07-02 13:45:00	Cancelled	Chronic care
3042	211	6	2025-03-16 14:30:00	Scheduled	Chronic care
3043	435	6	2021-05-04 16:30:00	Completed	Annual physical
3044	93	1	2021-09-02 12:15:00	Completed	Chronic care
3045	258	8	2024-06-08 17:00:00	Completed	Annual physical
3046	491	5	2024-02-09 15:30:00	Completed	Telehealth
3047	109	7	2022-07-03 15:15:00	Completed	Follow-up
3048	142	9	2019-08-09 08:45:00	No-show	Well child
3049	293	5	2021-12-31 13:00:00	Cancelled	Telehealth
3050	149	4	2020-04-20 13:00:00	Completed	Telehealth
3051	480	2	2022-10-29 11:45:00	Completed	Chronic care
3052	274	1	2024-01-26 10:15:00	Completed	Chronic care
3053	595	1	2026-04-15 11:30:00	Completed	Sick visit
3054	357	10	2021-12-02 08:30:00	Scheduled	Annual physical
3055	463	11	2023-01-04 10:30:00	Completed	Follow-up
3056	350	9	2019-06-19 09:30:00	Completed	Well child
3057	310	9	2024-10-02 13:15:00	Scheduled	Sick visit
3058	219	2	2024-08-06 13:15:00	Scheduled	Follow-up
3059	141	12	2023-06-12 15:00:00	Completed	Annual physical
3060	362	6	2024-12-17 14:45:00	Completed	Annual physical
3061	554	6	2024-08-16 10:15:00	Completed	Sick visit
3062	147	9	2019-05-23 15:45:00	Completed	Annual physical
3063	373	4	2025-05-09 10:30:00	No-show	Telehealth
3064	423	4	2020-03-26 08:00:00	Completed	Well child
3065	79	12	2025-05-10 12:15:00	Completed	Well child
3066	266	7	2021-06-04 14:15:00	Completed	Chronic care
3067	402	6	2026-02-25 16:45:00	Cancelled	Sick visit
3068	563	4	2019-03-01 08:00:00	Completed	Sick visit
3069	452	2	2022-02-10 15:45:00	Completed	Annual physical
3070	236	6	2023-04-04 16:45:00	Completed	Annual physical
3071	336	8	2023-04-26 14:30:00	Completed	Sick visit
3072	531	6	2024-01-16 16:15:00	Cancelled	Telehealth
3073	519	6	2023-10-17 08:15:00	Completed	Telehealth
3074	474	5	2025-11-10 09:30:00	Scheduled	Well child
3075	298	2	2022-06-23 12:15:00	Completed	Chronic care
3076	301	6	2026-01-11 15:30:00	Completed	Chronic care
3077	4	2	2023-11-09 13:30:00	Completed	Well child
3078	376	5	2019-02-02 16:45:00	Completed	Annual physical
3079	138	9	2026-04-17 13:15:00	Completed	Annual physical
3080	583	11	2025-12-02 08:30:00	Completed	Annual physical
3081	451	2	2020-11-18 08:15:00	Completed	Chronic care
3082	439	6	2023-09-17 16:30:00	Scheduled	Sick visit
3083	423	5	2020-06-02 15:15:00	Completed	Follow-up
3084	339	12	2022-10-23 16:30:00	Completed	Sick visit
3085	323	3	2023-05-09 09:00:00	Cancelled	Sick visit
3086	506	8	2022-07-15 10:45:00	Completed	Chronic care
3087	252	9	2025-09-29 08:45:00	Completed	Annual physical
3088	580	4	2024-06-12 11:00:00	Completed	Follow-up
3089	489	12	2019-08-11 13:00:00	Completed	Sick visit
3090	340	1	2024-12-05 14:00:00	Completed	Sick visit
3091	467	6	2021-09-07 16:45:00	Completed	Follow-up
3092	359	12	2026-03-15 11:30:00	Completed	Annual physical
3093	386	2	2025-06-13 13:00:00	Scheduled	Sick visit
3094	549	3	2024-05-08 11:00:00	Completed	Follow-up
3095	381	9	2023-07-22 13:30:00	Completed	Chronic care
3096	446	10	2023-08-30 08:45:00	Completed	Well child
3097	466	3	2021-03-15 15:45:00	Scheduled	Sick visit
3098	213	2	2025-02-10 13:30:00	Completed	Annual physical
3099	206	2	2022-03-22 14:30:00	Completed	Follow-up
3100	105	4	2019-07-02 10:15:00	Scheduled	Sick visit
3101	358	11	2020-09-18 11:30:00	Completed	Sick visit
3102	91	8	2025-07-14 15:00:00	Completed	Follow-up
3103	462	4	2024-05-20 11:45:00	Completed	Chronic care
3104	294	11	2019-09-17 10:30:00	Completed	Annual physical
3105	277	2	2024-06-27 10:00:00	No-show	Telehealth
3106	265	5	2021-09-24 16:00:00	Completed	Telehealth
3107	271	2	2023-09-03 11:30:00	Completed	Annual physical
3108	493	1	2022-08-27 15:30:00	Cancelled	Annual physical
3109	525	6	2021-10-01 09:30:00	Completed	Annual physical
3110	549	3	2021-06-28 12:00:00	Completed	Annual physical
3111	306	7	2023-10-21 10:45:00	Completed	Telehealth
3112	444	6	2019-09-25 14:00:00	Completed	Follow-up
3113	346	1	2025-03-14 16:30:00	Completed	Well child
3114	305	2	2021-03-23 14:15:00	Completed	Chronic care
3115	559	7	2020-01-23 11:15:00	Cancelled	Telehealth
3116	11	5	2025-03-18 15:15:00	Completed	Chronic care
3117	36	8	2020-04-01 09:00:00	Completed	Annual physical
3118	84	7	2019-04-11 14:45:00	Completed	Sick visit
3119	145	4	2023-09-08 08:00:00	Completed	Telehealth
3120	491	5	2022-12-24 10:15:00	Completed	Telehealth
3121	50	2	2026-01-06 16:00:00	Completed	Well child
3122	68	11	2021-07-07 17:00:00	No-show	Sick visit
3123	187	4	2020-09-29 13:00:00	Completed	Annual physical
3124	403	4	2024-03-05 09:15:00	Completed	Chronic care
3125	308	9	2019-07-10 14:00:00	Completed	Sick visit
3126	433	7	2024-04-18 12:15:00	Cancelled	Annual physical
3127	317	3	2020-02-13 16:00:00	Completed	Sick visit
3128	6	3	2024-10-21 15:00:00	Completed	Telehealth
3129	103	8	2020-03-05 15:15:00	Completed	Annual physical
3130	214	10	2019-07-01 10:45:00	Completed	Chronic care
3131	415	5	2023-12-26 14:30:00	Completed	Well child
3132	346	10	2024-02-11 10:30:00	Completed	Follow-up
3133	369	5	2021-11-01 12:00:00	Cancelled	Well child
3134	292	11	2022-03-23 14:45:00	Scheduled	Sick visit
3135	31	10	2024-04-15 12:00:00	Completed	Sick visit
3136	389	5	2020-01-04 12:45:00	Cancelled	Chronic care
3137	565	9	2024-07-30 13:00:00	Completed	Sick visit
3138	560	11	2019-12-20 13:45:00	Completed	Chronic care
3139	242	9	2024-01-20 14:15:00	Completed	Sick visit
3140	235	3	2022-06-09 09:00:00	Completed	Follow-up
3141	483	3	2020-04-16 09:00:00	Completed	Follow-up
3142	162	10	2021-09-02 11:15:00	Completed	Well child
3143	267	3	2020-02-17 08:00:00	Completed	Telehealth
3144	423	4	2024-01-12 17:00:00	Completed	Telehealth
3145	499	2	2023-06-26 13:30:00	Completed	Well child
3146	9	8	2021-06-11 08:30:00	Completed	Chronic care
3147	385	9	2023-01-25 14:00:00	Completed	Telehealth
3148	575	3	2022-07-12 12:15:00	Completed	Well child
3149	171	12	2020-02-19 16:00:00	Scheduled	Follow-up
3150	252	9	2022-07-07 10:15:00	Completed	Follow-up
3151	92	2	2022-07-29 13:15:00	Completed	Well child
3152	572	2	2025-03-25 13:45:00	Completed	Well child
3153	236	8	2026-01-07 13:30:00	Completed	Follow-up
3154	76	4	2020-08-27 16:15:00	Completed	Well child
3155	78	9	2020-07-27 08:45:00	No-show	Annual physical
3156	199	10	2019-10-20 10:30:00	Completed	Sick visit
3157	475	2	2023-12-01 11:45:00	Completed	Annual physical
3158	334	10	2024-11-08 13:45:00	Completed	Telehealth
3159	519	6	2022-08-09 15:30:00	Completed	Well child
3160	15	8	2022-03-29 09:30:00	Cancelled	Chronic care
3161	444	6	2022-12-15 13:00:00	No-show	Well child
3162	108	3	2023-08-12 13:45:00	Completed	Follow-up
3163	405	7	2023-08-06 11:45:00	Completed	Follow-up
3164	276	8	2024-10-10 12:00:00	Cancelled	Chronic care
3165	559	7	2020-11-13 12:30:00	Completed	Well child
3166	362	6	2025-05-08 15:45:00	Completed	Sick visit
3167	39	5	2023-03-02 09:30:00	Scheduled	Telehealth
3168	98	9	2024-04-29 09:15:00	Completed	Sick visit
3169	107	4	2021-09-25 16:30:00	Completed	Annual physical
3170	6	3	2025-07-17 09:30:00	Completed	Sick visit
3171	577	8	2025-10-04 08:45:00	Completed	Telehealth
3172	489	8	2023-08-13 16:00:00	Completed	Sick visit
3173	311	11	2023-08-05 13:15:00	Completed	Well child
3174	358	11	2019-12-18 11:00:00	Completed	Annual physical
3175	482	4	2024-03-01 11:00:00	Completed	Well child
3176	57	4	2021-06-09 15:00:00	Completed	Well child
3177	127	11	2020-09-18 17:00:00	Cancelled	Annual physical
3178	148	5	2020-09-07 12:30:00	Completed	Annual physical
3179	503	5	2024-02-12 12:00:00	Completed	Follow-up
3180	158	8	2020-03-31 09:15:00	Completed	Sick visit
3181	462	4	2021-03-30 10:00:00	Scheduled	Chronic care
3182	292	6	2026-02-04 10:30:00	Completed	Chronic care
3183	296	4	2024-08-07 11:30:00	Completed	Telehealth
3184	481	11	2024-07-17 12:00:00	No-show	Well child
3185	381	1	2019-04-03 14:00:00	Scheduled	Chronic care
3186	28	3	2025-04-28 13:15:00	Completed	Chronic care
3187	272	1	2024-09-06 13:45:00	Completed	Follow-up
3188	359	12	2026-02-19 15:30:00	Scheduled	Telehealth
3189	372	9	2022-01-08 14:00:00	Completed	Annual physical
3190	73	6	2021-05-13 09:45:00	Completed	Well child
3191	393	9	2025-03-13 14:30:00	Completed	Sick visit
3192	576	3	2020-09-26 08:00:00	Completed	Follow-up
3193	39	4	2021-06-03 12:15:00	Completed	Follow-up
3194	439	6	2023-06-15 16:45:00	Completed	Annual physical
3195	325	4	2022-05-16 10:30:00	Completed	Follow-up
3196	339	12	2024-10-09 14:30:00	Completed	Well child
3197	187	11	2023-11-30 16:00:00	Completed	Chronic care
3198	493	1	2020-09-29 15:30:00	Cancelled	Chronic care
3199	247	4	2025-05-19 16:30:00	No-show	Annual physical
3200	134	11	2025-03-12 12:30:00	Completed	Follow-up
3201	378	4	2021-12-02 13:15:00	Completed	Chronic care
3202	24	6	2019-07-12 12:30:00	Completed	Chronic care
3203	3	12	2020-05-03 08:15:00	Cancelled	Well child
3204	456	9	2020-07-02 16:00:00	Completed	Sick visit
3205	185	8	2023-05-27 10:30:00	Completed	Annual physical
3206	71	7	2022-09-24 11:45:00	Completed	Annual physical
3207	68	11	2023-02-23 12:00:00	Completed	Annual physical
3208	588	4	2020-09-05 13:30:00	Completed	Well child
3209	428	8	2020-07-17 08:30:00	No-show	Well child
3210	249	6	2024-12-16 11:00:00	Completed	Sick visit
3211	380	7	2021-01-24 15:30:00	Completed	Sick visit
3212	188	9	2023-05-24 10:15:00	Completed	Annual physical
3213	563	4	2025-07-16 14:45:00	Completed	Annual physical
3214	9	8	2021-08-14 12:30:00	Completed	Chronic care
3215	555	6	2024-12-21 16:45:00	Completed	Telehealth
3216	273	6	2025-02-24 13:15:00	Completed	Chronic care
3217	335	1	2020-05-31 13:15:00	Completed	Follow-up
3218	576	9	2026-02-04 16:15:00	Scheduled	Follow-up
3219	240	1	2025-11-30 10:15:00	Completed	Sick visit
3220	186	4	2024-06-19 11:45:00	Completed	Telehealth
3221	45	4	2023-11-06 14:00:00	Completed	Sick visit
3222	92	9	2023-05-13 15:00:00	Cancelled	Chronic care
3223	349	10	2024-02-29 08:15:00	Completed	Follow-up
3224	466	3	2019-05-26 15:30:00	Completed	Telehealth
3225	490	3	2021-04-08 12:00:00	Completed	Annual physical
3226	513	5	2023-04-10 08:30:00	Completed	Follow-up
3227	418	5	2021-09-12 15:30:00	Completed	Sick visit
3228	435	6	2019-02-05 12:45:00	Completed	Chronic care
3229	567	6	2019-08-11 08:15:00	Completed	Sick visit
3230	450	1	2022-12-20 14:45:00	Completed	Chronic care
3231	102	3	2025-11-07 14:00:00	Completed	Telehealth
3232	280	2	2021-12-12 10:30:00	No-show	Sick visit
3233	410	1	2020-09-07 08:15:00	Scheduled	Telehealth
3234	337	4	2021-03-15 10:00:00	Completed	Chronic care
3235	251	1	2021-07-25 16:00:00	Completed	Chronic care
3236	496	3	2022-01-01 09:15:00	Completed	Follow-up
3237	384	5	2023-02-28 13:15:00	Completed	Well child
3238	269	9	2023-03-13 13:00:00	Scheduled	Telehealth
3239	519	6	2023-03-05 17:00:00	Cancelled	Well child
3240	236	6	2019-04-10 12:45:00	Completed	Annual physical
3241	578	8	2022-05-24 15:30:00	Completed	Follow-up
3242	203	11	2019-09-21 11:00:00	Cancelled	Follow-up
3243	483	6	2021-12-27 11:00:00	Completed	Annual physical
3244	214	1	2022-05-13 11:45:00	Completed	Sick visit
3245	32	6	2020-02-28 17:00:00	Completed	Well child
3246	298	11	2026-05-23 15:30:00	Completed	Annual physical
3247	562	5	2019-12-20 13:45:00	No-show	Telehealth
3248	504	3	2020-06-01 16:30:00	Completed	Well child
3249	161	11	2025-05-02 16:00:00	Completed	Well child
3250	8	2	2021-07-16 16:30:00	Completed	Well child
3251	15	10	2025-03-13 15:00:00	Completed	Annual physical
3252	466	3	2022-01-24 17:00:00	Completed	Follow-up
3253	419	10	2022-05-09 14:30:00	Completed	Annual physical
3254	573	3	2020-10-05 09:00:00	Completed	Sick visit
3255	207	11	2024-11-12 10:15:00	Cancelled	Follow-up
3256	34	7	2026-02-23 12:30:00	Completed	Follow-up
3257	267	4	2020-12-31 15:15:00	Completed	Telehealth
3258	107	4	2021-05-06 14:00:00	Completed	Telehealth
3259	419	12	2023-04-19 11:00:00	Completed	Sick visit
3260	294	11	2020-05-11 12:15:00	No-show	Follow-up
3261	283	4	2023-08-12 16:45:00	Completed	Annual physical
3262	578	5	2020-01-18 15:45:00	Cancelled	Sick visit
3263	252	9	2024-05-25 10:30:00	Completed	Annual physical
3264	409	6	2021-01-21 17:00:00	Completed	Chronic care
3265	418	5	2019-03-26 15:30:00	Completed	Annual physical
3266	291	1	2019-02-16 09:30:00	Completed	Well child
3267	254	11	2019-03-08 15:30:00	Completed	Sick visit
3268	13	2	2023-06-17 12:15:00	Completed	Follow-up
3269	541	11	2024-01-11 16:45:00	Completed	Well child
3270	252	9	2021-06-08 09:00:00	Completed	Annual physical
3271	90	2	2022-09-27 15:00:00	Cancelled	Sick visit
3272	269	9	2026-01-13 15:00:00	Completed	Sick visit
3273	561	8	2021-01-15 12:30:00	Cancelled	Telehealth
3274	188	9	2025-08-16 13:30:00	Completed	Telehealth
3275	598	8	2026-03-30 09:00:00	Completed	Sick visit
3276	469	12	2022-11-28 13:30:00	Completed	Follow-up
3277	350	9	2020-06-10 16:00:00	Completed	Chronic care
3278	169	5	2019-07-21 13:00:00	Completed	Follow-up
3279	438	3	2019-01-07 08:00:00	Completed	Sick visit
3280	427	9	2023-03-22 10:15:00	Completed	Well child
3281	165	7	2020-06-13 09:00:00	Cancelled	Annual physical
3282	57	7	2019-08-20 11:15:00	Scheduled	Annual physical
3283	144	10	2022-02-03 17:00:00	Completed	Well child
3284	462	11	2024-10-06 08:30:00	Completed	Telehealth
3285	448	9	2026-03-23 09:00:00	Completed	Sick visit
3286	353	7	2024-06-03 14:45:00	Completed	Telehealth
3287	203	12	2023-08-01 15:15:00	No-show	Annual physical
3288	368	12	2019-10-11 16:30:00	Completed	Well child
3289	229	3	2024-02-06 08:15:00	No-show	Annual physical
3290	239	11	2020-02-28 10:00:00	Completed	Chronic care
3291	548	10	2022-01-04 14:00:00	No-show	Well child
3292	45	4	2023-03-16 12:00:00	Completed	Telehealth
3293	88	9	2026-03-11 10:15:00	Completed	Follow-up
3294	27	4	2022-07-17 08:45:00	No-show	Telehealth
3295	444	6	2024-08-13 08:45:00	Completed	Sick visit
3296	38	12	2020-07-11 13:00:00	Completed	Telehealth
3297	514	3	2023-10-31 15:15:00	Completed	Chronic care
3298	407	11	2026-05-02 09:45:00	Completed	Telehealth
3299	438	3	2022-08-11 12:30:00	Completed	Telehealth
3300	455	8	2025-10-12 10:30:00	Completed	Telehealth
3301	465	2	2023-06-21 11:30:00	Completed	Chronic care
3302	7	5	2020-08-05 13:30:00	Completed	Chronic care
3303	149	4	2019-05-14 14:15:00	Completed	Annual physical
3304	344	10	2020-07-10 16:15:00	Completed	Follow-up
3305	587	7	2026-02-06 17:00:00	Completed	Follow-up
3306	286	1	2019-03-29 11:30:00	Completed	Chronic care
3307	311	11	2020-10-15 09:00:00	Completed	Telehealth
3308	466	3	2019-08-07 14:30:00	Cancelled	Well child
3309	191	1	2023-06-07 10:45:00	No-show	Chronic care
3310	513	5	2024-01-03 09:15:00	Completed	Well child
3311	449	7	2021-10-02 11:15:00	Completed	Chronic care
3312	469	12	2021-05-28 10:45:00	Completed	Chronic care
3313	595	1	2023-11-06 13:15:00	Completed	Telehealth
3314	21	12	2020-08-16 11:30:00	Scheduled	Follow-up
3315	9	8	2023-12-21 16:45:00	Completed	Sick visit
3316	560	6	2021-11-01 11:30:00	Scheduled	Annual physical
3317	471	8	2022-10-07 09:45:00	Completed	Well child
3318	163	5	2024-07-07 16:00:00	Cancelled	Well child
3319	528	8	2026-02-21 10:30:00	Completed	Sick visit
3320	553	6	2019-07-18 15:45:00	Completed	Sick visit
3321	320	11	2020-08-30 17:00:00	Completed	Annual physical
3322	126	12	2025-07-22 08:45:00	Scheduled	Follow-up
3323	77	6	2024-07-24 16:30:00	Completed	Chronic care
3324	102	6	2024-12-10 16:00:00	Completed	Follow-up
3325	23	4	2023-07-16 11:30:00	Completed	Annual physical
3326	46	6	2023-02-06 09:00:00	Completed	Annual physical
3327	312	1	2023-05-12 08:45:00	Completed	Well child
3328	571	7	2019-09-29 13:15:00	Completed	Well child
3329	590	3	2022-10-01 08:15:00	Completed	Chronic care
3330	301	6	2022-01-24 11:45:00	Completed	Telehealth
3331	448	7	2019-11-12 11:45:00	Completed	Chronic care
3332	76	4	2023-07-26 10:15:00	Cancelled	Chronic care
3333	379	8	2020-03-06 15:00:00	Completed	Telehealth
3334	540	8	2022-07-17 10:00:00	Completed	Chronic care
3335	545	7	2024-02-07 13:00:00	Completed	Telehealth
3336	183	1	2020-03-25 16:00:00	Completed	Annual physical
3337	440	5	2020-02-13 15:30:00	Completed	Chronic care
3338	273	6	2020-02-24 14:15:00	Completed	Chronic care
3339	73	6	2022-02-20 12:45:00	Completed	Chronic care
3340	352	9	2023-03-13 12:15:00	Completed	Telehealth
3341	463	11	2023-09-04 12:00:00	Cancelled	Follow-up
3342	566	11	2024-05-28 11:15:00	Completed	Sick visit
3343	505	3	2022-03-13 15:00:00	Completed	Follow-up
3344	558	11	2021-04-23 17:00:00	Completed	Telehealth
3345	389	5	2026-02-09 08:30:00	Completed	Chronic care
3346	484	2	2025-04-29 10:30:00	Completed	Follow-up
3347	301	6	2024-11-20 17:00:00	No-show	Annual physical
3348	297	11	2025-10-28 08:15:00	Completed	Chronic care
3349	366	3	2022-10-15 09:15:00	Scheduled	Sick visit
3350	146	10	2026-04-04 10:15:00	Completed	Well child
3351	259	6	2024-03-24 10:00:00	Completed	Telehealth
3352	94	9	2021-09-05 08:45:00	Completed	Sick visit
3353	402	6	2023-04-23 11:30:00	Completed	Chronic care
3354	242	9	2025-06-10 14:30:00	Completed	Chronic care
3355	591	2	2022-07-04 16:15:00	Completed	Sick visit
3356	552	8	2023-06-13 15:00:00	Completed	Annual physical
3357	207	11	2022-02-15 13:15:00	Completed	Telehealth
3358	336	8	2026-03-07 14:15:00	Completed	Follow-up
3359	400	6	2019-12-14 16:30:00	Completed	Annual physical
3360	118	1	2020-02-28 14:15:00	Completed	Chronic care
3361	326	2	2021-12-27 17:00:00	Completed	Follow-up
3362	105	4	2022-12-19 14:15:00	Completed	Telehealth
3363	221	11	2022-10-26 13:00:00	No-show	Annual physical
3364	546	7	2019-12-13 08:00:00	Completed	Annual physical
3365	271	2	2022-12-08 09:30:00	Cancelled	Annual physical
3366	322	4	2020-08-09 09:30:00	Completed	Follow-up
3367	106	8	2022-04-28 09:45:00	Completed	Well child
3368	363	5	2022-08-18 10:15:00	Completed	Chronic care
3369	271	2	2023-12-15 08:45:00	Completed	Telehealth
3370	112	3	2026-05-17 13:00:00	Completed	Chronic care
3371	376	5	2024-07-10 08:00:00	Completed	Chronic care
3372	379	7	2019-10-03 16:00:00	Completed	Sick visit
3373	262	7	2023-01-11 10:00:00	Completed	Annual physical
3374	34	5	2019-01-16 11:15:00	Cancelled	Telehealth
3375	226	4	2019-12-09 13:15:00	Completed	Well child
3376	384	5	2023-10-21 15:30:00	Completed	Annual physical
3377	165	6	2021-10-26 08:30:00	Completed	Follow-up
3378	383	4	2025-08-13 11:45:00	Completed	Follow-up
3379	13	2	2019-02-12 09:00:00	Completed	Annual physical
3380	389	5	2024-11-06 16:00:00	Completed	Chronic care
3381	325	12	2019-10-10 15:30:00	Cancelled	Well child
3382	8	1	2023-10-28 12:00:00	No-show	Sick visit
3383	414	8	2021-02-19 12:00:00	Completed	Sick visit
3384	27	4	2024-04-15 15:30:00	Scheduled	Telehealth
3385	136	9	2023-11-22 14:15:00	Completed	Well child
3386	192	6	2021-05-03 12:00:00	Completed	Sick visit
3387	5	4	2020-12-15 11:30:00	Completed	Telehealth
3388	8	10	2019-03-12 14:15:00	Completed	Annual physical
3389	331	1	2021-02-06 12:00:00	No-show	Well child
3390	529	6	2019-09-10 15:45:00	Completed	Chronic care
3391	112	9	2019-05-18 16:00:00	Completed	Chronic care
3392	22	10	2024-11-04 10:30:00	Completed	Follow-up
3393	60	5	2020-06-23 11:45:00	Completed	Sick visit
3394	364	4	2025-05-19 13:30:00	Completed	Sick visit
3395	329	11	2019-07-10 12:45:00	Completed	Well child
3396	301	7	2025-06-27 12:45:00	No-show	Telehealth
3397	467	4	2025-01-08 08:30:00	Completed	Annual physical
3398	529	6	2019-05-06 13:15:00	Completed	Chronic care
3399	88	7	2020-09-20 10:30:00	Completed	Annual physical
3400	27	4	2020-11-11 15:00:00	Completed	Telehealth
3401	138	9	2022-07-23 14:00:00	Completed	Well child
3402	101	7	2023-01-20 10:15:00	Completed	Telehealth
3403	245	8	2025-03-31 08:45:00	Scheduled	Well child
3404	263	2	2021-07-11 16:00:00	Scheduled	Well child
3405	543	4	2020-05-31 09:15:00	Scheduled	Well child
3406	308	9	2022-06-27 08:45:00	Scheduled	Telehealth
3407	512	2	2026-05-06 08:45:00	Completed	Telehealth
3408	95	8	2025-02-18 14:15:00	Completed	Well child
3409	341	10	2025-06-07 16:15:00	Completed	Chronic care
3410	177	2	2022-12-11 13:15:00	Completed	Sick visit
3411	600	6	2023-05-29 10:30:00	No-show	Telehealth
3412	27	4	2019-12-02 13:45:00	Completed	Well child
3413	472	4	2021-05-24 11:00:00	Scheduled	Chronic care
3414	487	9	2023-09-10 11:00:00	Scheduled	Follow-up
3415	183	1	2021-04-28 14:45:00	Scheduled	Sick visit
3416	488	5	2019-01-18 14:00:00	Completed	Chronic care
3417	531	6	2024-01-17 15:15:00	Completed	Well child
3418	331	1	2024-03-13 16:15:00	Completed	Well child
3419	396	12	2026-04-04 11:15:00	Completed	Well child
3420	189	11	2022-11-02 12:15:00	Completed	Chronic care
3421	552	8	2019-12-16 08:45:00	Completed	Telehealth
3422	82	3	2024-11-21 13:30:00	Completed	Follow-up
3423	307	8	2022-07-29 13:45:00	No-show	Telehealth
3424	386	9	2020-10-30 14:00:00	Completed	Chronic care
3425	164	2	2021-03-16 13:45:00	Completed	Chronic care
3426	560	4	2024-03-19 14:00:00	Completed	Chronic care
3427	400	6	2023-08-11 16:15:00	Completed	Follow-up
3428	467	4	2023-09-23 14:45:00	Completed	Chronic care
3429	330	8	2019-12-18 15:15:00	Scheduled	Chronic care
3430	583	11	2023-11-03 10:15:00	Completed	Chronic care
3431	187	11	2019-02-20 08:30:00	Completed	Chronic care
3432	424	5	2020-03-12 14:15:00	Completed	Sick visit
3433	241	11	2020-08-20 11:45:00	Completed	Follow-up
3434	441	6	2021-01-08 10:30:00	Completed	Chronic care
3435	588	4	2025-07-08 14:15:00	Completed	Annual physical
3436	81	8	2022-08-15 10:30:00	Completed	Annual physical
3437	106	8	2019-10-03 16:30:00	Completed	Telehealth
3438	533	8	2020-01-26 13:45:00	Completed	Sick visit
3439	497	7	2020-07-21 11:45:00	Completed	Follow-up
3440	273	1	2025-11-02 16:30:00	Completed	Annual physical
3441	270	5	2025-08-27 16:00:00	Completed	Well child
3442	180	2	2019-11-13 14:15:00	Completed	Follow-up
3443	303	7	2022-09-03 17:00:00	No-show	Chronic care
3444	576	3	2023-03-05 10:30:00	Completed	Follow-up
3445	429	5	2022-10-28 08:00:00	Completed	Annual physical
3446	320	11	2025-08-10 15:30:00	Completed	Chronic care
3447	126	12	2023-04-03 11:45:00	Cancelled	Follow-up
3448	496	3	2021-03-07 13:30:00	No-show	Well child
3449	341	10	2023-04-26 08:00:00	Scheduled	Well child
3450	339	8	2020-12-28 14:00:00	Completed	Follow-up
3451	238	1	2022-10-26 11:45:00	Completed	Chronic care
3452	55	9	2021-07-08 10:45:00	Completed	Sick visit
3453	289	9	2020-06-05 10:45:00	Completed	Follow-up
3454	58	11	2021-09-24 13:45:00	No-show	Follow-up
3455	154	2	2021-01-24 08:45:00	Completed	Telehealth
3456	486	2	2025-11-21 14:15:00	Completed	Well child
3457	289	9	2024-01-16 10:45:00	Completed	Well child
3458	308	8	2021-09-11 12:15:00	Scheduled	Follow-up
3459	580	4	2022-12-26 14:00:00	Completed	Well child
3460	422	1	2022-08-31 16:45:00	Completed	Follow-up
3461	555	6	2020-07-28 16:45:00	Completed	Sick visit
3462	597	8	2020-01-30 15:30:00	Completed	Well child
3463	404	6	2021-03-01 10:30:00	Completed	Well child
3464	396	3	2023-08-26 16:15:00	Scheduled	Telehealth
3465	415	6	2024-12-17 15:00:00	Completed	Well child
3466	422	1	2026-04-28 16:15:00	Completed	Chronic care
3467	421	6	2022-03-21 15:45:00	Completed	Well child
3468	431	3	2024-03-03 09:15:00	Completed	Annual physical
3469	495	4	2022-09-15 10:00:00	Cancelled	Follow-up
3470	331	11	2020-06-24 09:30:00	Completed	Chronic care
3471	100	2	2022-09-23 11:45:00	Completed	Chronic care
3472	237	10	2022-10-01 16:45:00	No-show	Chronic care
3473	272	1	2022-02-18 13:00:00	Completed	Well child
3474	467	4	2019-12-21 09:30:00	Completed	Well child
3475	435	6	2019-05-05 09:00:00	Completed	Follow-up
3476	50	1	2025-12-22 09:00:00	Completed	Annual physical
3477	429	5	2025-05-25 15:45:00	Completed	Chronic care
3478	594	10	2024-11-08 15:45:00	Completed	Follow-up
3479	532	1	2022-09-01 12:45:00	Completed	Annual physical
3480	78	7	2021-12-13 12:45:00	Cancelled	Telehealth
3481	275	5	2026-01-24 14:30:00	Completed	Annual physical
3482	501	12	2022-06-11 09:45:00	Completed	Chronic care
3483	199	10	2023-09-17 13:15:00	Completed	Telehealth
3484	520	6	2021-08-22 13:45:00	Completed	Sick visit
3485	502	9	2025-12-15 13:15:00	Completed	Telehealth
3486	108	3	2023-12-17 11:30:00	Completed	Sick visit
3487	245	8	2022-08-04 12:00:00	Completed	Sick visit
3488	85	7	2021-08-26 09:30:00	Completed	Well child
3489	275	5	2022-08-03 14:30:00	Completed	Follow-up
3490	331	1	2021-06-18 13:15:00	Cancelled	Chronic care
3491	383	4	2019-01-30 14:00:00	Completed	Annual physical
3492	170	9	2022-01-20 16:45:00	Completed	Follow-up
3493	234	2	2022-09-12 12:45:00	Completed	Annual physical
3494	36	2	2022-01-28 09:00:00	Completed	Follow-up
3495	589	12	2019-10-10 08:15:00	Completed	Telehealth
3496	109	7	2020-12-09 11:15:00	Completed	Follow-up
3497	284	5	2025-05-29 13:00:00	Completed	Sick visit
3498	38	12	2021-02-03 10:15:00	Completed	Follow-up
3499	123	1	2021-09-25 13:15:00	Completed	Sick visit
3500	309	9	2026-03-01 08:00:00	Completed	Follow-up
3501	126	12	2020-05-22 16:30:00	Cancelled	Sick visit
3502	64	11	2020-05-05 08:30:00	Completed	Chronic care
3503	541	11	2023-09-01 16:45:00	Completed	Follow-up
3504	595	1	2026-03-07 08:15:00	Scheduled	Well child
3505	461	5	2024-07-23 15:00:00	No-show	Telehealth
3506	371	6	2020-10-15 17:00:00	Completed	Sick visit
3507	354	8	2019-01-16 08:30:00	Scheduled	Telehealth
3508	451	4	2020-05-04 12:45:00	Cancelled	Annual physical
3509	93	1	2024-01-01 11:00:00	Completed	Follow-up
3510	126	12	2025-01-23 14:15:00	Completed	Telehealth
3511	30	1	2023-07-25 10:30:00	Cancelled	Sick visit
3512	251	11	2025-04-06 15:30:00	Completed	Follow-up
3513	463	11	2025-05-21 15:30:00	Completed	Follow-up
3514	317	6	2022-07-05 14:30:00	Completed	Sick visit
3515	277	7	2021-12-16 10:30:00	Completed	Chronic care
3516	524	11	2019-07-12 14:30:00	Completed	Well child
3517	98	5	2020-05-12 13:45:00	No-show	Annual physical
3518	43	6	2021-08-08 10:30:00	Completed	Annual physical
3519	353	7	2023-07-28 12:00:00	Completed	Chronic care
3520	315	5	2025-11-07 12:30:00	Completed	Chronic care
3521	172	9	2024-10-06 16:45:00	Completed	Well child
3522	471	8	2024-04-13 12:45:00	Cancelled	Sick visit
3523	286	1	2023-04-28 13:15:00	Completed	Chronic care
3524	96	1	2019-03-15 12:30:00	No-show	Well child
3525	160	7	2020-09-06 09:30:00	Completed	Well child
3526	158	8	2023-02-13 16:45:00	Completed	Follow-up
3527	80	10	2024-04-16 10:45:00	Completed	Sick visit
3528	435	2	2021-03-14 13:30:00	Completed	Well child
3529	546	5	2019-02-17 14:15:00	Completed	Chronic care
3530	529	6	2021-04-06 10:45:00	Completed	Follow-up
3531	437	4	2022-06-10 12:45:00	Completed	Well child
3532	540	4	2022-05-24 09:45:00	Scheduled	Chronic care
3533	71	10	2023-03-04 08:00:00	Completed	Well child
3534	575	3	2022-08-28 15:00:00	Completed	Telehealth
3535	587	10	2019-08-10 08:15:00	No-show	Telehealth
3536	589	12	2023-10-26 16:00:00	No-show	Sick visit
3537	221	11	2025-08-09 12:00:00	Completed	Well child
3538	288	9	2021-12-01 13:45:00	Cancelled	Telehealth
3539	4	2	2025-06-16 12:30:00	Completed	Follow-up
3540	596	7	2021-02-18 10:30:00	Completed	Telehealth
3541	397	2	2026-04-07 11:15:00	Completed	Annual physical
3542	76	4	2020-03-24 12:45:00	Completed	Well child
3543	459	7	2025-03-08 12:30:00	Completed	Well child
3544	50	2	2021-05-05 10:30:00	Completed	Well child
3545	159	1	2023-04-28 15:45:00	Completed	Follow-up
3546	360	4	2021-12-10 08:30:00	Completed	Chronic care
3547	424	8	2019-04-17 11:30:00	Cancelled	Chronic care
3548	439	2	2019-06-26 13:45:00	Completed	Chronic care
3549	20	8	2022-10-02 08:15:00	No-show	Sick visit
3550	111	1	2022-04-16 08:30:00	Scheduled	Sick visit
3551	262	7	2023-10-02 12:45:00	Completed	Telehealth
3552	270	5	2023-02-16 15:00:00	Completed	Follow-up
3553	123	1	2021-08-31 14:00:00	Scheduled	Chronic care
3554	600	6	2019-07-31 11:15:00	Completed	Chronic care
3555	498	3	2020-05-02 12:45:00	Completed	Well child
3556	415	12	2025-12-25 10:30:00	Completed	Sick visit
3557	154	8	2019-04-25 16:00:00	Completed	Sick visit
3558	172	9	2025-04-11 14:45:00	Completed	Telehealth
3559	117	4	2019-04-03 14:00:00	Completed	Follow-up
3560	254	8	2022-10-23 13:45:00	Scheduled	Telehealth
3561	578	8	2022-06-16 15:15:00	Completed	Well child
3562	82	3	2023-05-13 12:45:00	Cancelled	Sick visit
3563	77	10	2023-01-10 10:00:00	Completed	Chronic care
3564	121	7	2025-04-21 13:00:00	Completed	Telehealth
3565	137	7	2023-02-20 10:30:00	Completed	Sick visit
3566	88	6	2019-12-23 08:15:00	Completed	Annual physical
3567	479	7	2020-02-02 12:15:00	Completed	Telehealth
3568	175	4	2022-08-17 13:45:00	No-show	Annual physical
3569	128	6	2022-09-19 12:15:00	Completed	Annual physical
3570	9	8	2024-06-13 11:30:00	Completed	Follow-up
3571	535	5	2023-09-15 08:15:00	Completed	Annual physical
3572	147	12	2025-06-17 15:30:00	Completed	Chronic care
3573	442	3	2026-01-04 16:45:00	Completed	Chronic care
3574	162	10	2021-04-13 12:45:00	Completed	Follow-up
3575	13	10	2021-10-28 13:15:00	Completed	Annual physical
3576	578	5	2021-12-04 13:00:00	Completed	Telehealth
3577	14	1	2022-08-10 12:00:00	Completed	Telehealth
3578	264	1	2021-05-06 10:30:00	Cancelled	Follow-up
3579	24	6	2020-06-30 12:00:00	Completed	Chronic care
3580	490	9	2020-08-13 17:00:00	Completed	Annual physical
3581	168	2	2020-07-29 13:15:00	Completed	Well child
3582	563	4	2022-03-19 17:00:00	Completed	Chronic care
3583	237	10	2023-05-01 13:45:00	Completed	Telehealth
3584	245	8	2022-05-20 08:00:00	Completed	Chronic care
3585	72	12	2025-12-07 09:15:00	Completed	Telehealth
3586	103	8	2022-12-01 12:15:00	Completed	Sick visit
3587	207	5	2023-06-30 14:30:00	Completed	Well child
3588	60	5	2024-11-25 15:15:00	Completed	Follow-up
3589	414	8	2021-07-14 15:15:00	Completed	Telehealth
3590	427	9	2022-06-24 15:00:00	Completed	Sick visit
3591	92	9	2023-01-09 12:45:00	Completed	Sick visit
3592	198	1	2022-10-24 12:30:00	Completed	Follow-up
3593	325	4	2022-11-04 14:00:00	Completed	Well child
3594	46	6	2025-10-25 10:30:00	Completed	Annual physical
3595	361	3	2023-01-14 11:30:00	Cancelled	Telehealth
3596	282	5	2019-11-29 09:15:00	Completed	Follow-up
3597	571	7	2023-08-02 12:00:00	Completed	Sick visit
3598	439	6	2020-09-27 14:30:00	Completed	Follow-up
3599	390	10	2021-10-31 13:15:00	Completed	Chronic care
3600	551	4	2021-06-15 16:15:00	Scheduled	Follow-up
3601	562	5	2024-09-18 14:30:00	Completed	Sick visit
3602	153	8	2020-01-05 11:45:00	Completed	Follow-up
3603	204	2	2025-02-13 11:45:00	Completed	Annual physical
3604	564	6	2025-01-23 13:30:00	Completed	Annual physical
3605	389	5	2021-10-18 08:30:00	No-show	Annual physical
3606	13	2	2026-02-24 10:15:00	Completed	Annual physical
3607	199	10	2021-06-27 09:00:00	No-show	Follow-up
3608	212	7	2024-04-23 15:45:00	Scheduled	Well child
3609	131	8	2022-03-09 09:30:00	Scheduled	Annual physical
3610	101	11	2022-12-09 16:30:00	Completed	Sick visit
3611	140	5	2024-11-17 10:15:00	Completed	Sick visit
3612	560	6	2020-08-09 09:30:00	Completed	Telehealth
3613	79	9	2019-03-22 15:30:00	Completed	Sick visit
3614	273	6	2020-12-09 13:30:00	Completed	Well child
3615	557	10	2025-05-27 12:30:00	Completed	Chronic care
3616	303	7	2022-04-14 13:45:00	Cancelled	Telehealth
3617	552	8	2019-10-02 11:00:00	Completed	Well child
3618	381	1	2021-08-20 09:30:00	Completed	Follow-up
3619	106	8	2021-05-24 12:00:00	Completed	Chronic care
3620	368	12	2022-09-12 08:00:00	Completed	Well child
3621	484	2	2024-07-25 13:00:00	Completed	Sick visit
3622	309	9	2021-08-29 09:15:00	Completed	Chronic care
3623	198	1	2021-04-25 08:00:00	Completed	Chronic care
3624	54	8	2021-07-14 09:15:00	Completed	Chronic care
3625	175	4	2020-11-10 12:00:00	Completed	Sick visit
3626	366	12	2022-12-05 14:00:00	Completed	Telehealth
3627	97	8	2023-01-20 09:30:00	Cancelled	Chronic care
3628	258	8	2025-10-26 13:00:00	Completed	Telehealth
3629	461	2	2019-04-20 11:15:00	Scheduled	Chronic care
3630	172	9	2020-07-16 13:00:00	No-show	Chronic care
3631	2	4	2022-05-07 09:15:00	Completed	Annual physical
3632	328	11	2026-04-17 14:45:00	Completed	Annual physical
3633	539	10	2024-11-27 17:00:00	Completed	Sick visit
3634	594	2	2021-02-18 10:30:00	Completed	Follow-up
3635	84	7	2019-10-08 13:15:00	Scheduled	Follow-up
3636	284	5	2021-08-26 16:30:00	Completed	Well child
3637	480	2	2024-08-08 16:00:00	Completed	Annual physical
3638	378	4	2019-04-09 13:30:00	Completed	Chronic care
3639	199	10	2023-04-12 12:15:00	Completed	Well child
3640	115	7	2023-03-31 15:30:00	Completed	Follow-up
3641	21	12	2021-08-09 12:15:00	Completed	Telehealth
3642	118	6	2025-04-19 08:45:00	Completed	Sick visit
3643	110	3	2019-04-18 14:45:00	Completed	Telehealth
3644	237	10	2022-01-12 14:00:00	Completed	Chronic care
3645	437	11	2026-04-14 08:45:00	Completed	Follow-up
3646	241	11	2023-01-02 12:15:00	Completed	Follow-up
3647	254	11	2021-10-03 14:45:00	Completed	Well child
3648	399	1	2022-01-28 10:00:00	Completed	Telehealth
3649	46	6	2025-07-24 12:15:00	Completed	Chronic care
3650	186	4	2020-08-01 15:00:00	Completed	Sick visit
3651	394	6	2021-06-14 17:00:00	Completed	Chronic care
3652	88	7	2023-01-07 15:15:00	Cancelled	Well child
3653	425	2	2024-09-29 10:30:00	Completed	Well child
3654	125	11	2025-10-08 08:30:00	Completed	Chronic care
3655	482	4	2020-07-17 12:15:00	Completed	Well child
3656	504	10	2022-05-05 13:15:00	Completed	Follow-up
3657	469	12	2025-08-04 11:15:00	Completed	Chronic care
3658	113	11	2024-01-28 08:30:00	Completed	Telehealth
3659	130	9	2023-02-08 16:00:00	Completed	Chronic care
3660	377	8	2021-09-13 14:45:00	No-show	Telehealth
3661	31	11	2022-02-28 14:45:00	Completed	Annual physical
3662	408	10	2021-01-30 15:30:00	Completed	Chronic care
3663	421	6	2023-08-24 14:45:00	Completed	Well child
3664	343	5	2019-07-08 11:30:00	Scheduled	Follow-up
3665	54	10	2019-02-13 13:15:00	Completed	Chronic care
3666	292	11	2022-09-21 16:30:00	Completed	Chronic care
3667	1	4	2020-05-31 16:00:00	Completed	Telehealth
3668	116	7	2021-03-06 09:15:00	Completed	Follow-up
3669	250	4	2020-08-23 12:15:00	Completed	Annual physical
3670	325	4	2021-08-15 14:30:00	Completed	Sick visit
3671	166	10	2020-01-13 08:45:00	Completed	Sick visit
3672	244	10	2022-05-25 09:30:00	Cancelled	Telehealth
3673	525	6	2025-10-08 08:30:00	Completed	Annual physical
3674	123	1	2026-05-18 14:45:00	Cancelled	Sick visit
3675	53	8	2020-12-05 09:45:00	Completed	Annual physical
3676	213	1	2025-02-08 09:15:00	Completed	Annual physical
3677	424	9	2020-02-23 12:15:00	Completed	Annual physical
3678	523	7	2019-08-15 11:00:00	Completed	Follow-up
3679	530	5	2021-07-17 12:30:00	Completed	Annual physical
3680	353	7	2025-01-11 12:15:00	No-show	Chronic care
3681	550	3	2022-10-24 12:45:00	Cancelled	Sick visit
3682	232	6	2023-08-22 13:00:00	Completed	Chronic care
3683	95	9	2023-06-26 14:30:00	Completed	Follow-up
3684	325	4	2022-10-25 15:45:00	Completed	Follow-up
3685	570	3	2021-07-31 15:30:00	No-show	Telehealth
3686	98	5	2022-09-28 08:30:00	Completed	Sick visit
3687	167	9	2020-06-08 10:30:00	Completed	Annual physical
3688	33	5	2019-12-04 09:45:00	Completed	Well child
3689	596	12	2023-09-10 16:45:00	Cancelled	Telehealth
3690	467	10	2021-08-22 15:30:00	Completed	Chronic care
3691	407	11	2021-07-25 09:30:00	Completed	Chronic care
3692	595	1	2019-02-02 10:45:00	Cancelled	Follow-up
3693	58	11	2025-07-06 09:15:00	Completed	Sick visit
3694	526	2	2023-04-13 14:45:00	Completed	Chronic care
3695	130	10	2021-07-22 11:45:00	Completed	Telehealth
3696	534	8	2025-01-10 12:45:00	Completed	Sick visit
3697	406	8	2025-06-07 14:45:00	No-show	Follow-up
3698	302	4	2019-05-30 11:30:00	Completed	Telehealth
3699	254	11	2021-11-07 12:30:00	Completed	Follow-up
3700	90	12	2025-12-26 14:15:00	Completed	Telehealth
3701	5	4	2020-12-24 13:30:00	Completed	Sick visit
3702	66	4	2020-07-26 17:00:00	Completed	Annual physical
3703	129	11	2019-12-09 15:30:00	Completed	Telehealth
3704	364	4	2019-10-13 15:00:00	Completed	Annual physical
3705	550	1	2019-02-11 13:15:00	No-show	Annual physical
3706	338	12	2025-04-15 15:30:00	Completed	Sick visit
3707	504	10	2026-01-23 13:15:00	Completed	Well child
3708	129	11	2023-11-16 11:15:00	Completed	Annual physical
3709	173	5	2023-12-03 16:30:00	Completed	Sick visit
3710	272	1	2021-05-29 15:15:00	Completed	Telehealth
3711	127	11	2020-06-08 16:00:00	Completed	Follow-up
3712	345	1	2026-01-09 10:30:00	Completed	Chronic care
3713	267	4	2023-12-24 12:45:00	Cancelled	Sick visit
3714	180	2	2024-12-16 08:00:00	Completed	Annual physical
3715	305	2	2025-08-29 08:45:00	Completed	Annual physical
3716	245	8	2024-08-06 13:00:00	Completed	Well child
3717	444	6	2024-09-18 12:00:00	Completed	Chronic care
3718	535	5	2024-08-03 08:30:00	Completed	Well child
3719	536	3	2021-03-20 11:45:00	Cancelled	Follow-up
3720	150	8	2021-06-10 08:15:00	Cancelled	Telehealth
3721	197	10	2019-04-12 11:30:00	Completed	Chronic care
3722	301	4	2020-03-03 10:45:00	Completed	Follow-up
3723	17	6	2025-12-16 08:45:00	Completed	Telehealth
3724	208	7	2019-06-09 16:45:00	Completed	Telehealth
3725	95	9	2021-06-18 16:30:00	No-show	Well child
3726	457	10	2020-02-14 13:00:00	Completed	Telehealth
3727	428	8	2024-08-23 08:00:00	Completed	Well child
3728	556	9	2019-09-08 11:30:00	Completed	Well child
3729	540	4	2025-03-18 09:45:00	Completed	Chronic care
3730	66	4	2025-02-24 13:30:00	Completed	Annual physical
3731	372	9	2019-08-25 15:30:00	Completed	Follow-up
3732	8	1	2021-07-03 10:15:00	No-show	Chronic care
3733	415	12	2024-09-17 09:15:00	Scheduled	Telehealth
3734	259	6	2023-11-21 08:30:00	Completed	Annual physical
3735	78	7	2025-06-13 15:00:00	Completed	Sick visit
3736	208	7	2021-12-11 10:45:00	Completed	Telehealth
3737	20	8	2019-08-25 15:00:00	Completed	Chronic care
3738	219	11	2019-02-07 16:00:00	Completed	Sick visit
3739	431	7	2021-03-27 11:30:00	Completed	Telehealth
3740	324	1	2025-02-25 15:45:00	Cancelled	Annual physical
3741	569	8	2020-04-14 13:30:00	Completed	Telehealth
3742	599	7	2023-04-26 16:00:00	Cancelled	Well child
3743	42	6	2019-02-18 10:00:00	No-show	Well child
3744	94	9	2025-09-19 14:00:00	Completed	Chronic care
3745	143	10	2024-08-11 08:15:00	Completed	Annual physical
3746	405	7	2025-02-06 12:30:00	Completed	Annual physical
3747	249	9	2020-02-17 13:45:00	Completed	Telehealth
3748	562	5	2020-01-17 14:45:00	Completed	Sick visit
3749	592	12	2020-08-13 14:30:00	Completed	Follow-up
3750	46	6	2025-08-07 08:00:00	Completed	Telehealth
3751	373	4	2023-04-30 13:45:00	Completed	Telehealth
3752	204	2	2020-10-19 15:15:00	Completed	Chronic care
3753	85	7	2025-11-04 08:15:00	Completed	Telehealth
3754	528	7	2020-07-02 16:00:00	No-show	Annual physical
3755	296	4	2025-08-08 17:00:00	Completed	Follow-up
3756	75	5	2025-07-23 10:30:00	Cancelled	Well child
3757	466	3	2025-09-23 08:30:00	Scheduled	Well child
3758	336	8	2019-05-15 14:45:00	Completed	Well child
3759	340	1	2024-04-05 10:30:00	Completed	Sick visit
3760	114	7	2021-02-19 11:45:00	Completed	Sick visit
3761	148	5	2024-08-08 15:45:00	Completed	Follow-up
3762	307	8	2024-02-09 14:45:00	Completed	Chronic care
3763	132	10	2022-02-05 14:00:00	Completed	Sick visit
3764	264	1	2021-12-16 08:45:00	Completed	Annual physical
3765	331	1	2021-01-12 15:45:00	Completed	Well child
3766	22	4	2019-01-23 16:45:00	Completed	Annual physical
3767	255	6	2021-06-21 15:30:00	Completed	Telehealth
3768	273	6	2019-04-30 10:45:00	Completed	Follow-up
3769	442	3	2023-04-03 16:00:00	Completed	Sick visit
3770	109	7	2026-02-12 09:30:00	No-show	Follow-up
3771	71	4	2023-08-06 14:15:00	Scheduled	Well child
3772	140	8	2019-09-10 16:45:00	Scheduled	Sick visit
3773	434	3	2021-03-23 14:45:00	Completed	Annual physical
3774	506	8	2020-08-08 16:30:00	Scheduled	Sick visit
3775	476	10	2023-04-27 14:45:00	Completed	Annual physical
3776	221	11	2022-08-31 12:30:00	Completed	Follow-up
3777	428	8	2021-08-06 10:30:00	Cancelled	Sick visit
3778	302	9	2020-11-25 12:15:00	Completed	Sick visit
3779	139	12	2025-06-24 09:45:00	Completed	Chronic care
3780	329	11	2020-01-14 13:00:00	Completed	Chronic care
3781	283	4	2019-08-09 14:45:00	Completed	Chronic care
3782	559	7	2022-01-03 14:45:00	Completed	Sick visit
3783	142	7	2023-02-03 15:15:00	Completed	Sick visit
3784	25	2	2020-04-25 11:00:00	Completed	Chronic care
3785	496	3	2022-05-28 17:00:00	Completed	Sick visit
3786	400	1	2022-05-28 14:30:00	Completed	Well child
3787	223	8	2024-05-19 09:00:00	Completed	Telehealth
3788	184	2	2020-01-11 12:00:00	Completed	Telehealth
3789	232	6	2025-03-28 08:00:00	Completed	Follow-up
3790	59	10	2021-03-04 13:30:00	Completed	Well child
3791	581	4	2019-09-07 15:30:00	Completed	Telehealth
3792	127	11	2025-06-25 10:15:00	Completed	Annual physical
3793	585	8	2020-08-28 09:00:00	Completed	Follow-up
3794	254	11	2025-03-13 08:45:00	Completed	Sick visit
3795	587	7	2021-10-18 12:15:00	Cancelled	Annual physical
3796	466	3	2022-07-28 11:30:00	Completed	Telehealth
3797	431	2	2024-12-18 08:00:00	Completed	Chronic care
3798	134	5	2024-09-09 16:45:00	Completed	Follow-up
3799	565	4	2019-11-04 11:00:00	Completed	Sick visit
3800	377	8	2019-02-09 10:45:00	Completed	Telehealth
3801	492	7	2025-12-17 16:45:00	Completed	Sick visit
3802	81	8	2020-04-02 09:00:00	Completed	Follow-up
3803	201	7	2021-12-20 17:00:00	Completed	Well child
3804	58	4	2024-05-17 16:30:00	Completed	Sick visit
3805	177	12	2021-08-11 08:00:00	Completed	Follow-up
3806	423	4	2021-08-10 14:15:00	Completed	Annual physical
3807	204	2	2020-02-01 16:00:00	Completed	Chronic care
3808	484	2	2019-12-03 14:15:00	No-show	Annual physical
3809	482	4	2025-01-18 12:00:00	No-show	Follow-up
3810	214	11	2021-02-08 10:00:00	Completed	Well child
3811	491	5	2023-11-13 17:00:00	Completed	Follow-up
3812	105	4	2021-12-30 13:30:00	Completed	Chronic care
3813	2	4	2019-05-18 16:15:00	Completed	Well child
3814	105	4	2024-11-21 13:15:00	Completed	Sick visit
3815	334	10	2020-04-26 13:30:00	Completed	Annual physical
3816	418	5	2020-01-18 12:45:00	Completed	Sick visit
3817	467	4	2019-02-13 08:00:00	No-show	Well child
3818	555	5	2021-04-07 14:00:00	Completed	Well child
3819	295	8	2023-04-07 14:30:00	Completed	Sick visit
3820	266	4	2024-12-22 16:00:00	Completed	Annual physical
3821	344	10	2021-06-06 08:00:00	Completed	Chronic care
3822	298	9	2022-05-15 14:15:00	Completed	Chronic care
3823	243	3	2022-02-02 12:45:00	Completed	Follow-up
3824	445	9	2021-04-26 10:30:00	Completed	Well child
3825	436	3	2024-11-03 12:30:00	Completed	Well child
3826	348	7	2025-03-08 15:00:00	Scheduled	Telehealth
3827	483	5	2024-04-29 12:00:00	Completed	Well child
3828	209	1	2022-05-09 09:00:00	No-show	Annual physical
3829	481	11	2024-05-19 12:45:00	Completed	Follow-up
3830	546	7	2024-11-05 16:15:00	Completed	Annual physical
3831	559	3	2024-12-07 08:00:00	Completed	Sick visit
3832	103	3	2023-03-18 13:45:00	No-show	Sick visit
3833	289	6	2023-05-11 08:30:00	Completed	Well child
3834	173	5	2023-10-14 11:00:00	Completed	Telehealth
3835	358	11	2020-11-29 10:15:00	Completed	Telehealth
3836	69	10	2020-04-09 13:30:00	Completed	Sick visit
3837	134	5	2023-08-21 10:30:00	Completed	Telehealth
3838	351	10	2022-10-25 08:15:00	Completed	Annual physical
3839	227	3	2019-01-25 12:30:00	Completed	Annual physical
3840	2	4	2021-10-05 09:45:00	Completed	Annual physical
3841	333	11	2024-01-01 13:15:00	Scheduled	Well child
3842	260	2	2020-05-26 09:15:00	Completed	Telehealth
3843	250	4	2024-01-29 16:45:00	Completed	Telehealth
3844	304	11	2020-04-28 14:30:00	Scheduled	Telehealth
3845	576	7	2025-12-08 15:30:00	Completed	Follow-up
3846	462	4	2022-08-26 14:00:00	Cancelled	Follow-up
3847	510	12	2026-01-17 16:15:00	Completed	Telehealth
3848	568	4	2024-09-23 16:15:00	No-show	Chronic care
3849	376	5	2023-07-10 17:00:00	Completed	Annual physical
3850	424	8	2021-10-30 12:30:00	Completed	Well child
3851	177	10	2019-06-04 15:00:00	Completed	Telehealth
3852	59	10	2020-10-03 13:15:00	Completed	Follow-up
3853	69	8	2024-07-17 10:00:00	Completed	Chronic care
3854	366	12	2024-04-10 10:30:00	Completed	Chronic care
3855	198	1	2019-04-05 12:00:00	Scheduled	Sick visit
3856	88	7	2023-10-07 17:00:00	Completed	Telehealth
3857	147	9	2020-04-01 09:30:00	Scheduled	Chronic care
3858	311	4	2020-05-15 09:00:00	Completed	Sick visit
3859	266	7	2024-01-06 12:15:00	Completed	Annual physical
3860	450	10	2023-07-09 12:30:00	Scheduled	Chronic care
3861	527	8	2023-08-07 09:30:00	Completed	Follow-up
3862	534	7	2023-01-14 17:00:00	Completed	Follow-up
3863	5	4	2023-11-27 08:45:00	Completed	Telehealth
3864	200	5	2024-11-03 08:00:00	Completed	Follow-up
3865	501	12	2020-08-14 15:15:00	Completed	Sick visit
3866	149	4	2020-11-17 16:30:00	Completed	Sick visit
3867	87	6	2025-11-28 08:30:00	Completed	Well child
3868	40	8	2026-01-12 09:15:00	Completed	Annual physical
3869	548	10	2022-10-22 11:15:00	Completed	Follow-up
3870	331	11	2022-10-14 09:15:00	Completed	Telehealth
3871	360	12	2025-02-03 11:15:00	Cancelled	Follow-up
3872	404	6	2024-01-22 08:45:00	Completed	Sick visit
3873	465	1	2021-05-22 15:30:00	Completed	Annual physical
3874	138	9	2024-11-16 13:45:00	Completed	Chronic care
3875	163	3	2020-05-11 13:30:00	Completed	Well child
3876	389	5	2020-02-29 13:00:00	Cancelled	Chronic care
3877	334	10	2019-09-12 14:15:00	Completed	Chronic care
3878	476	10	2019-12-18 16:15:00	No-show	Annual physical
3879	598	9	2023-03-31 11:45:00	Completed	Well child
3880	145	4	2021-05-26 10:15:00	Completed	Follow-up
3881	496	5	2023-05-06 15:45:00	Completed	Well child
3882	30	1	2020-06-28 14:45:00	Cancelled	Follow-up
3883	361	2	2023-09-03 08:45:00	Scheduled	Sick visit
3884	448	7	2025-10-11 16:45:00	Completed	Well child
3885	70	1	2020-01-06 12:00:00	Completed	Chronic care
3886	22	10	2022-03-22 10:15:00	Completed	Sick visit
3887	564	6	2020-07-22 09:00:00	Scheduled	Annual physical
3888	475	7	2019-02-09 11:45:00	Completed	Well child
3889	79	9	2021-02-27 14:45:00	Completed	Well child
3890	409	6	2025-08-20 08:45:00	Completed	Follow-up
3891	223	10	2019-10-02 11:45:00	Completed	Telehealth
3892	538	3	2021-01-26 11:00:00	Completed	Telehealth
3893	539	10	2023-10-01 14:00:00	Completed	Well child
3894	562	5	2026-01-18 14:15:00	No-show	Follow-up
3895	506	8	2022-06-21 12:45:00	Completed	Follow-up
3896	87	6	2026-04-03 09:15:00	Completed	Chronic care
3897	331	1	2019-03-06 16:15:00	Completed	Telehealth
3898	472	4	2021-01-30 16:00:00	Completed	Follow-up
3899	476	10	2022-09-26 13:00:00	Completed	Telehealth
3900	576	3	2023-12-23 12:15:00	Completed	Follow-up
3901	441	6	2020-12-30 14:00:00	Scheduled	Well child
3902	544	5	2025-04-26 16:00:00	Cancelled	Chronic care
3903	10	1	2024-04-17 13:45:00	Completed	Annual physical
3904	406	9	2026-04-19 14:15:00	Completed	Annual physical
3905	382	11	2025-06-17 16:00:00	Completed	Well child
3906	139	12	2022-10-19 12:15:00	Completed	Sick visit
3907	228	7	2023-04-06 10:30:00	Completed	Annual physical
3908	411	8	2021-12-01 10:00:00	Completed	Well child
3909	60	5	2019-06-08 10:45:00	Completed	Telehealth
3910	350	9	2022-01-17 08:30:00	Completed	Sick visit
3911	114	7	2022-11-12 13:45:00	Completed	Annual physical
3912	388	8	2024-05-04 15:15:00	Completed	Chronic care
3913	203	11	2025-04-19 11:45:00	Completed	Sick visit
3914	563	7	2026-03-18 12:00:00	No-show	Well child
3915	271	2	2022-07-13 13:15:00	Completed	Annual physical
3916	537	5	2023-03-17 12:30:00	Completed	Well child
3917	422	1	2024-11-16 08:15:00	Completed	Well child
3918	228	7	2024-12-07 16:00:00	Completed	Well child
3919	190	8	2026-05-03 15:45:00	Completed	Sick visit
3920	563	4	2024-03-22 14:15:00	Completed	Follow-up
3921	399	1	2021-04-06 10:30:00	Cancelled	Chronic care
3922	451	4	2024-07-26 14:15:00	Scheduled	Chronic care
3923	19	5	2025-03-08 14:00:00	Completed	Annual physical
3924	89	12	2019-05-23 16:30:00	Completed	Telehealth
3925	187	11	2025-12-23 10:45:00	Completed	Sick visit
3926	170	12	2025-08-29 17:00:00	Completed	Well child
3927	230	10	2023-04-09 15:30:00	Completed	Chronic care
3928	73	6	2021-08-20 11:15:00	Completed	Follow-up
3929	250	4	2022-11-03 12:15:00	Completed	Telehealth
3930	346	10	2020-11-08 11:15:00	Completed	Follow-up
3931	401	11	2022-12-23 15:00:00	Completed	Annual physical
3932	150	5	2021-04-18 09:15:00	No-show	Follow-up
3933	62	2	2019-11-21 08:00:00	Cancelled	Follow-up
3934	518	3	2023-07-25 12:45:00	Completed	Telehealth
3935	584	11	2023-11-18 10:30:00	Completed	Chronic care
3936	591	10	2024-05-03 08:45:00	Completed	Annual physical
3937	14	1	2022-06-14 12:30:00	Completed	Annual physical
3938	562	5	2021-08-18 14:15:00	Completed	Follow-up
3939	504	10	2021-03-06 11:00:00	Cancelled	Sick visit
3940	460	1	2019-12-10 14:30:00	Scheduled	Chronic care
3941	413	2	2024-09-24 15:00:00	Completed	Sick visit
3942	369	5	2021-06-02 15:45:00	Completed	Chronic care
3943	574	5	2021-12-12 15:00:00	Completed	Well child
3944	448	7	2023-09-19 10:00:00	Completed	Sick visit
3945	243	3	2019-11-30 14:30:00	Completed	Well child
3946	585	2	2024-10-02 09:00:00	Completed	Annual physical
3947	590	7	2019-07-20 09:45:00	Completed	Chronic care
3948	137	7	2024-02-27 10:30:00	Completed	Sick visit
3949	12	4	2022-07-17 15:45:00	No-show	Chronic care
3950	469	12	2025-09-21 14:30:00	Cancelled	Well child
3951	236	6	2025-06-26 13:30:00	Completed	Well child
3952	262	7	2020-10-18 11:45:00	Completed	Follow-up
3953	60	5	2020-02-12 15:15:00	Completed	Telehealth
3954	118	1	2022-07-06 14:00:00	Completed	Follow-up
3955	517	4	2019-06-24 09:30:00	Completed	Well child
3956	456	1	2019-12-19 15:00:00	Completed	Sick visit
3957	210	2	2021-12-25 12:30:00	Completed	Annual physical
3958	542	12	2022-10-28 12:30:00	Completed	Follow-up
3959	66	4	2023-01-19 14:45:00	Completed	Well child
3960	407	11	2022-09-19 13:15:00	Completed	Well child
3961	503	12	2019-12-22 12:45:00	Completed	Chronic care
3962	153	8	2025-11-17 13:30:00	No-show	Well child
3963	28	3	2021-12-29 14:30:00	Completed	Telehealth
3964	343	5	2025-12-17 10:00:00	Completed	Follow-up
3965	593	6	2021-10-24 08:45:00	Completed	Annual physical
3966	373	4	2024-05-14 14:00:00	Scheduled	Sick visit
3967	245	8	2020-04-14 11:00:00	Completed	Sick visit
3968	102	3	2025-12-18 12:30:00	Completed	Telehealth
3969	452	2	2021-12-28 15:30:00	No-show	Follow-up
3970	459	11	2026-04-04 16:45:00	Completed	Annual physical
3971	155	12	2021-02-18 12:00:00	Completed	Chronic care
3972	375	10	2021-07-16 14:45:00	Completed	Sick visit
3973	26	2	2019-08-22 13:15:00	Completed	Sick visit
3974	310	9	2023-03-31 16:30:00	Completed	Well child
3975	508	3	2024-07-25 15:15:00	Completed	Follow-up
3976	381	1	2021-08-24 16:15:00	Completed	Chronic care
3977	170	9	2020-03-26 12:15:00	Completed	Well child
3978	128	6	2023-04-17 15:45:00	No-show	Annual physical
3979	177	2	2022-09-28 15:15:00	Cancelled	Sick visit
3980	420	12	2024-03-06 10:00:00	Completed	Well child
3981	97	8	2019-12-29 11:30:00	Completed	Sick visit
3982	345	1	2020-07-13 13:45:00	Completed	Follow-up
3983	414	8	2024-03-12 10:00:00	Completed	Follow-up
3984	114	7	2019-03-25 09:45:00	Completed	Chronic care
3985	411	8	2025-06-08 09:15:00	Completed	Telehealth
3986	403	4	2020-02-18 10:00:00	Completed	Follow-up
3987	567	6	2022-04-08 11:00:00	Completed	Sick visit
3988	45	4	2021-04-04 10:45:00	Cancelled	Annual physical
3989	32	6	2025-09-11 13:30:00	Cancelled	Chronic care
3990	389	5	2024-12-23 14:00:00	Completed	Sick visit
3991	430	5	2026-02-28 15:45:00	Completed	Annual physical
3992	193	9	2019-12-22 12:30:00	Completed	Telehealth
3993	124	10	2024-02-19 14:30:00	Scheduled	Sick visit
3994	575	3	2019-07-13 15:30:00	Scheduled	Well child
3995	34	5	2026-05-20 13:30:00	Completed	Annual physical
3996	330	4	2023-12-17 08:15:00	Completed	Annual physical
3997	225	9	2025-02-28 09:15:00	No-show	Well child
3998	264	10	2024-10-18 09:45:00	Completed	Well child
3999	345	1	2022-10-21 09:15:00	Completed	Well child
4000	566	2	2021-02-26 09:45:00	Completed	Chronic care
4001	488	5	2025-04-23 13:00:00	Scheduled	Follow-up
4002	194	4	2022-04-21 10:45:00	Completed	Well child
4003	5	10	2025-09-15 09:15:00	Completed	Telehealth
4004	218	5	2020-06-26 10:30:00	No-show	Telehealth
4005	588	4	2020-07-09 09:00:00	Completed	Telehealth
4006	275	5	2021-03-16 15:00:00	Completed	Sick visit
4007	294	11	2025-08-20 10:45:00	Cancelled	Sick visit
4008	293	5	2023-01-16 09:00:00	Completed	Annual physical
4009	533	2	2025-10-22 10:45:00	Completed	Well child
4010	311	11	2026-03-04 11:45:00	No-show	Annual physical
4011	506	8	2024-03-22 14:15:00	No-show	Chronic care
4012	29	4	2021-06-17 15:45:00	No-show	Follow-up
4013	568	8	2022-05-22 13:45:00	Completed	Telehealth
4014	575	3	2025-09-17 08:15:00	Scheduled	Sick visit
4015	542	12	2026-03-21 08:15:00	Completed	Follow-up
4016	56	5	2025-02-01 09:30:00	Completed	Annual physical
4017	586	4	2022-07-25 11:15:00	Scheduled	Telehealth
4018	322	4	2026-04-08 13:45:00	Completed	Chronic care
4019	528	7	2022-03-31 09:15:00	Completed	Annual physical
4020	255	2	2024-10-27 15:30:00	Completed	Well child
4021	442	3	2025-01-01 13:30:00	Completed	Chronic care
4022	23	6	2020-11-25 12:45:00	Completed	Sick visit
4023	463	11	2020-06-19 08:00:00	Completed	Sick visit
4024	43	6	2025-09-07 15:00:00	Cancelled	Sick visit
4025	18	10	2021-08-04 08:45:00	Completed	Chronic care
4026	210	2	2026-02-08 16:15:00	Completed	Telehealth
4027	545	7	2024-04-13 12:30:00	Completed	Well child
4028	430	12	2025-11-18 10:15:00	Completed	Telehealth
4029	197	10	2020-06-06 10:00:00	Completed	Well child
4030	134	5	2024-04-23 13:30:00	Completed	Well child
4031	358	11	2024-02-23 15:45:00	Completed	Annual physical
4032	129	11	2023-01-26 12:45:00	Completed	Sick visit
4033	407	11	2020-11-10 10:00:00	No-show	Chronic care
4034	530	5	2023-11-17 14:00:00	Completed	Sick visit
4035	167	7	2022-10-21 13:30:00	Completed	Annual physical
4036	12	4	2023-11-19 09:30:00	Completed	Sick visit
4037	580	3	2022-10-08 13:15:00	Completed	Well child
4038	209	1	2026-04-19 09:30:00	Completed	Annual physical
4039	573	9	2025-06-11 09:30:00	Completed	Telehealth
4040	110	5	2023-06-01 12:15:00	Completed	Telehealth
4041	31	11	2022-07-30 08:00:00	Completed	Well child
4042	483	5	2026-01-09 16:45:00	Completed	Chronic care
4043	253	4	2021-12-28 16:15:00	Completed	Sick visit
4044	198	1	2022-12-14 13:00:00	Completed	Sick visit
4045	133	3	2022-12-06 09:30:00	Cancelled	Sick visit
4046	168	2	2023-02-09 15:15:00	Completed	Follow-up
4047	133	8	2024-07-13 09:30:00	Completed	Follow-up
4048	598	8	2025-04-03 10:30:00	Cancelled	Follow-up
4049	506	7	2021-12-17 08:45:00	Scheduled	Telehealth
4050	397	2	2022-04-27 08:00:00	Completed	Annual physical
4051	283	4	2024-07-15 08:00:00	Completed	Telehealth
4052	204	6	2022-06-21 16:15:00	Scheduled	Sick visit
4053	527	8	2024-09-27 16:00:00	Scheduled	Follow-up
4054	410	1	2026-01-14 10:15:00	Completed	Follow-up
4055	15	8	2021-11-02 12:30:00	Completed	Chronic care
4056	474	5	2020-06-30 15:00:00	Completed	Well child
4057	540	4	2020-05-07 12:15:00	Cancelled	Annual physical
4058	411	8	2023-03-16 16:30:00	Completed	Well child
4059	165	6	2021-11-25 12:15:00	Completed	Follow-up
4060	289	9	2021-06-10 10:30:00	No-show	Sick visit
4061	155	12	2023-09-01 15:30:00	No-show	Well child
4062	576	3	2022-02-24 12:15:00	Completed	Annual physical
4063	427	9	2021-07-24 15:30:00	Completed	Well child
4064	559	7	2022-10-03 13:45:00	Completed	Follow-up
4065	424	8	2019-05-18 09:45:00	Cancelled	Chronic care
4066	445	9	2024-01-24 15:00:00	No-show	Chronic care
4067	102	8	2026-05-08 08:15:00	Completed	Chronic care
4068	241	11	2019-11-16 14:00:00	Completed	Well child
4069	326	2	2022-11-19 16:30:00	Completed	Telehealth
4070	121	7	2021-03-12 09:45:00	Completed	Sick visit
4071	341	7	2023-12-06 12:15:00	Completed	Well child
4072	471	3	2023-03-20 14:00:00	Completed	Annual physical
4073	390	10	2022-08-07 09:00:00	Completed	Telehealth
4074	230	10	2024-04-18 12:30:00	Cancelled	Follow-up
4075	271	2	2020-01-15 11:15:00	No-show	Telehealth
4076	581	4	2024-09-29 15:00:00	Completed	Telehealth
4077	428	8	2022-05-04 08:00:00	Completed	Chronic care
4078	586	4	2025-10-10 08:45:00	Completed	Telehealth
4079	157	3	2019-02-13 13:00:00	Completed	Sick visit
4080	242	9	2026-04-04 13:30:00	Scheduled	Telehealth
4081	217	4	2025-10-01 13:45:00	Completed	Follow-up
4082	406	8	2020-03-17 15:15:00	Completed	Well child
4083	252	8	2024-03-21 16:15:00	Completed	Annual physical
4084	411	8	2025-03-28 15:45:00	Completed	Sick visit
4085	199	10	2019-11-02 10:00:00	Completed	Chronic care
4086	585	7	2020-01-15 14:15:00	Completed	Sick visit
4087	159	1	2026-03-26 09:00:00	Completed	Sick visit
4088	66	4	2025-04-02 16:30:00	Completed	Follow-up
4089	270	5	2025-07-06 14:30:00	Completed	Sick visit
4090	502	9	2021-07-18 12:15:00	Cancelled	Follow-up
4091	258	8	2022-12-30 10:30:00	Completed	Follow-up
4092	377	8	2025-11-24 09:15:00	Completed	Telehealth
4093	365	7	2021-10-20 09:15:00	Completed	Sick visit
4094	65	11	2025-09-15 09:45:00	Completed	Well child
4095	99	3	2022-02-16 11:45:00	Completed	Chronic care
4096	204	2	2019-08-12 10:30:00	Completed	Sick visit
4097	279	2	2020-11-30 16:15:00	No-show	Sick visit
4098	476	5	2021-12-25 15:45:00	Completed	Chronic care
4099	25	5	2022-02-22 11:00:00	Scheduled	Sick visit
4100	458	8	2024-02-28 13:45:00	Completed	Annual physical
4101	310	9	2025-05-05 09:45:00	Completed	Chronic care
4102	162	10	2019-03-12 16:15:00	Completed	Follow-up
4103	480	2	2020-06-30 13:45:00	Completed	Follow-up
4104	144	8	2026-01-13 16:00:00	Completed	Well child
4105	96	1	2025-09-05 13:00:00	Completed	Sick visit
4106	157	1	2023-08-29 16:30:00	Scheduled	Annual physical
4107	385	9	2024-02-13 15:30:00	Cancelled	Chronic care
4108	31	11	2022-03-27 15:45:00	Completed	Chronic care
4109	13	2	2023-01-06 14:45:00	Cancelled	Follow-up
4110	561	8	2019-06-15 12:45:00	Completed	Follow-up
4111	558	11	2024-02-05 13:00:00	Completed	Chronic care
4112	122	12	2020-11-11 17:00:00	Completed	Telehealth
4113	347	1	2024-05-21 10:15:00	Cancelled	Well child
4114	227	3	2020-01-24 12:30:00	Completed	Annual physical
4115	445	12	2023-09-05 16:30:00	Completed	Chronic care
4116	20	8	2023-04-05 15:30:00	Completed	Sick visit
4117	448	7	2025-04-15 14:30:00	Completed	Telehealth
4118	9	8	2019-12-27 09:45:00	Completed	Sick visit
4119	177	12	2021-04-03 10:45:00	Completed	Telehealth
4120	20	8	2023-10-18 14:15:00	Completed	Follow-up
4121	125	11	2022-06-12 14:00:00	Completed	Telehealth
4122	149	4	2025-10-29 14:15:00	Completed	Follow-up
4123	426	7	2021-03-30 12:45:00	Completed	Follow-up
4124	46	6	2020-02-13 13:15:00	Completed	Chronic care
4125	62	3	2022-03-04 14:15:00	Completed	Follow-up
4126	393	9	2026-05-06 10:30:00	No-show	Chronic care
4127	389	5	2019-12-17 08:45:00	Cancelled	Well child
4128	9	8	2022-08-20 09:45:00	Completed	Telehealth
4129	317	8	2026-03-03 16:00:00	Completed	Sick visit
4130	288	9	2024-08-12 15:45:00	Completed	Telehealth
4131	372	9	2020-03-14 11:00:00	Completed	Follow-up
4132	306	7	2025-05-05 17:00:00	Scheduled	Well child
4133	486	2	2022-11-25 15:00:00	Completed	Well child
4134	544	4	2025-07-22 16:15:00	Cancelled	Well child
4135	344	10	2019-10-13 13:30:00	Completed	Well child
4136	510	12	2024-02-11 14:30:00	Cancelled	Well child
4137	521	11	2024-01-27 09:45:00	Completed	Well child
4138	193	9	2020-01-05 16:30:00	Completed	Follow-up
4139	72	12	2024-06-19 15:15:00	No-show	Annual physical
4140	518	11	2023-01-13 11:00:00	Completed	Annual physical
4141	408	10	2021-07-08 11:15:00	Completed	Sick visit
4142	298	9	2019-01-13 10:45:00	Completed	Sick visit
4143	106	8	2019-12-11 14:00:00	Completed	Follow-up
4144	40	8	2022-03-18 09:45:00	Scheduled	Telehealth
4145	438	3	2022-08-09 16:15:00	Completed	Telehealth
4146	167	9	2020-06-25 17:00:00	Completed	Follow-up
4147	28	3	2020-08-12 12:30:00	Scheduled	Follow-up
4148	166	10	2019-08-03 09:00:00	Completed	Well child
4149	302	11	2019-07-05 13:00:00	Completed	Follow-up
4150	172	9	2021-02-04 12:15:00	Completed	Sick visit
4151	455	8	2021-03-18 16:15:00	Completed	Well child
4152	246	7	2023-03-13 13:45:00	Completed	Well child
4153	445	9	2022-06-06 09:30:00	Completed	Follow-up
4154	48	7	2023-04-20 08:30:00	Completed	Annual physical
4155	122	12	2024-06-30 08:30:00	Cancelled	Annual physical
4156	240	12	2023-03-27 15:45:00	Completed	Annual physical
4157	475	7	2022-07-30 15:30:00	No-show	Well child
4158	148	5	2021-07-20 13:45:00	Completed	Follow-up
4159	373	4	2022-12-04 10:30:00	Completed	Sick visit
4160	103	8	2022-12-12 16:00:00	Completed	Well child
4161	132	10	2025-01-15 13:30:00	Completed	Chronic care
4162	50	2	2020-12-19 12:45:00	Completed	Well child
4163	267	5	2019-03-20 15:30:00	Completed	Well child
4164	208	2	2019-02-09 13:15:00	Completed	Telehealth
4165	210	2	2021-08-24 12:30:00	Completed	Follow-up
4166	495	4	2026-01-28 14:00:00	Completed	Annual physical
4167	136	9	2026-04-06 12:00:00	Completed	Telehealth
4168	384	4	2025-04-01 09:30:00	Completed	Annual physical
4169	137	7	2020-04-18 13:30:00	Completed	Annual physical
4170	314	8	2025-01-02 09:00:00	Completed	Telehealth
4171	175	4	2025-06-26 14:15:00	Completed	Follow-up
4172	59	10	2021-02-04 11:00:00	Completed	Chronic care
4173	577	8	2025-10-02 14:00:00	Completed	Chronic care
4174	523	7	2019-09-21 12:45:00	Completed	Sick visit
4175	559	7	2021-02-28 10:15:00	Completed	Well child
4176	571	7	2021-10-26 08:45:00	Completed	Telehealth
4177	584	11	2024-04-22 09:45:00	Cancelled	Chronic care
4178	254	11	2025-09-14 11:00:00	Completed	Sick visit
4179	271	2	2023-08-13 09:15:00	Completed	Annual physical
4180	476	10	2024-04-19 13:00:00	Completed	Well child
4181	521	6	2024-09-29 09:00:00	Completed	Follow-up
4182	81	8	2024-06-24 13:45:00	Completed	Follow-up
4183	547	4	2021-07-23 14:30:00	Completed	Annual physical
4184	88	7	2024-08-01 15:30:00	Completed	Chronic care
4185	557	10	2022-10-27 13:15:00	Completed	Annual physical
4186	97	8	2020-10-12 13:30:00	Completed	Follow-up
4187	50	2	2021-07-04 14:45:00	Completed	Well child
4188	294	11	2023-08-06 14:30:00	Completed	Sick visit
4189	585	2	2024-05-06 16:00:00	Completed	Sick visit
4190	511	2	2023-05-04 14:45:00	Completed	Chronic care
4191	89	12	2020-08-02 10:15:00	Completed	Sick visit
4192	107	4	2022-11-18 15:15:00	Completed	Annual physical
4193	361	3	2024-02-16 08:00:00	Completed	Well child
4194	182	4	2025-06-10 11:00:00	Completed	Chronic care
4195	551	4	2025-02-01 16:30:00	Completed	Telehealth
4196	38	11	2022-04-22 12:30:00	Completed	Annual physical
4197	168	2	2019-09-30 16:45:00	Completed	Well child
4198	282	5	2026-03-30 11:15:00	Scheduled	Annual physical
4199	283	4	2024-06-29 13:30:00	Completed	Follow-up
4200	247	4	2020-10-31 11:00:00	Completed	Well child
4201	229	3	2024-10-16 11:15:00	Completed	Chronic care
4202	172	9	2024-08-28 12:15:00	Completed	Annual physical
4203	412	7	2022-02-23 10:00:00	Completed	Well child
4204	40	5	2024-07-09 17:00:00	Completed	Chronic care
4205	172	3	2023-06-29 11:00:00	Completed	Chronic care
4206	585	2	2023-05-02 14:00:00	Completed	Follow-up
4207	245	8	2022-05-19 09:15:00	Completed	Well child
4208	397	11	2023-10-26 11:30:00	Completed	Annual physical
4209	184	2	2025-06-21 08:00:00	Completed	Annual physical
4210	410	7	2024-10-22 14:30:00	Cancelled	Annual physical
4211	578	12	2020-01-30 09:45:00	Completed	Follow-up
4212	230	10	2021-02-09 10:00:00	Cancelled	Chronic care
4213	65	10	2020-09-10 13:45:00	Cancelled	Telehealth
4214	293	5	2020-11-03 14:00:00	Completed	Telehealth
4215	156	10	2023-11-11 09:00:00	Completed	Telehealth
4216	3	12	2025-08-12 14:00:00	Completed	Well child
4217	552	3	2023-04-21 12:45:00	Completed	Chronic care
4218	563	4	2021-02-11 11:30:00	Completed	Follow-up
4219	345	4	2019-06-23 15:00:00	Completed	Well child
4220	332	4	2025-04-23 10:30:00	Completed	Telehealth
4221	108	3	2023-08-30 12:00:00	Completed	Chronic care
4222	224	1	2024-02-28 15:15:00	Cancelled	Telehealth
4223	327	3	2021-10-16 16:45:00	No-show	Telehealth
4224	313	6	2020-10-22 13:30:00	Completed	Annual physical
4225	291	1	2021-07-05 12:45:00	Completed	Telehealth
4226	360	12	2019-09-23 12:00:00	Completed	Follow-up
4227	536	8	2023-11-14 11:00:00	Completed	Annual physical
4228	494	8	2026-05-15 16:00:00	Completed	Chronic care
4229	358	11	2019-09-25 11:00:00	Completed	Telehealth
4230	248	9	2026-05-23 08:30:00	Completed	Telehealth
4231	265	1	2024-03-05 15:45:00	Completed	Well child
4232	371	6	2026-02-14 14:30:00	Completed	Telehealth
4233	249	9	2025-06-26 12:00:00	Completed	Sick visit
4234	333	5	2019-08-16 13:15:00	No-show	Well child
4235	564	6	2022-09-12 11:00:00	Cancelled	Annual physical
4236	396	3	2022-10-27 09:00:00	Completed	Annual physical
4237	396	3	2023-10-18 08:30:00	Cancelled	Annual physical
4238	362	6	2023-08-26 13:30:00	Completed	Follow-up
4239	543	9	2024-11-27 13:15:00	Cancelled	Well child
4240	160	7	2026-03-23 17:00:00	Cancelled	Follow-up
4241	20	8	2023-07-04 12:30:00	Cancelled	Chronic care
4242	20	8	2025-10-02 13:45:00	Scheduled	Well child
4243	440	5	2021-08-21 16:15:00	Completed	Follow-up
4244	334	10	2022-06-23 15:00:00	No-show	Chronic care
4245	405	7	2025-05-18 12:00:00	Completed	Well child
4246	436	3	2020-04-20 16:15:00	Completed	Well child
4247	107	11	2020-03-07 12:15:00	Completed	Well child
4248	329	11	2022-11-30 14:30:00	Completed	Sick visit
4249	578	2	2025-06-22 11:15:00	Completed	Sick visit
4250	12	4	2019-10-14 13:15:00	Completed	Annual physical
4251	407	11	2023-05-12 08:30:00	Completed	Well child
4252	413	11	2024-05-15 12:45:00	Completed	Follow-up
4253	500	1	2020-05-08 16:00:00	Completed	Sick visit
4254	417	4	2022-01-16 15:45:00	Completed	Chronic care
4255	183	1	2024-05-06 12:15:00	Completed	Follow-up
4256	367	3	2022-01-29 08:45:00	No-show	Annual physical
4257	142	12	2020-02-21 12:45:00	Completed	Chronic care
4258	464	5	2025-10-31 12:30:00	No-show	Annual physical
4259	45	4	2025-07-10 15:00:00	Completed	Annual physical
4260	412	7	2024-09-23 10:45:00	Completed	Well child
4261	30	10	2021-03-24 08:30:00	Completed	Chronic care
4262	208	7	2019-12-02 09:15:00	Completed	Telehealth
4263	371	6	2024-03-26 17:00:00	Completed	Well child
4264	428	8	2023-05-03 14:00:00	Completed	Telehealth
4265	365	7	2023-11-29 16:45:00	Completed	Follow-up
4266	588	4	2020-05-02 14:30:00	Completed	Follow-up
4267	295	8	2023-12-21 09:30:00	Completed	Annual physical
4268	331	1	2023-11-09 10:45:00	Completed	Telehealth
4269	414	8	2023-03-21 11:30:00	Completed	Chronic care
4270	418	5	2026-01-06 09:15:00	No-show	Sick visit
4271	313	8	2019-08-30 14:45:00	No-show	Telehealth
4272	352	9	2024-06-01 11:00:00	Completed	Telehealth
4273	145	4	2022-10-13 13:00:00	Completed	Telehealth
4274	265	1	2024-07-22 16:30:00	Completed	Chronic care
4275	22	10	2019-12-23 09:00:00	Completed	Well child
4276	578	8	2025-05-29 15:15:00	Completed	Follow-up
4277	386	9	2022-02-08 10:30:00	Completed	Annual physical
4278	505	3	2024-02-15 11:45:00	Completed	Sick visit
4279	595	1	2024-12-18 15:00:00	Completed	Sick visit
4280	600	6	2026-04-19 08:30:00	Scheduled	Telehealth
4281	487	1	2020-05-14 15:30:00	Completed	Follow-up
4282	5	6	2023-10-14 15:15:00	Completed	Annual physical
4283	541	11	2025-08-18 11:45:00	Completed	Follow-up
4284	184	2	2022-11-29 13:00:00	Completed	Telehealth
4285	171	12	2020-07-19 14:15:00	Completed	Chronic care
4286	367	6	2023-07-01 16:30:00	Completed	Chronic care
4287	307	1	2022-03-03 13:30:00	Completed	Annual physical
4288	162	10	2019-04-07 08:30:00	Completed	Annual physical
4289	237	10	2021-09-21 17:00:00	Completed	Chronic care
4290	283	4	2025-08-13 14:00:00	No-show	Annual physical
4291	515	5	2025-01-07 09:00:00	Completed	Annual physical
4292	564	6	2024-05-18 17:00:00	Completed	Telehealth
4293	145	4	2023-03-17 08:30:00	Completed	Annual physical
4294	181	11	2025-02-17 13:45:00	Completed	Sick visit
4295	353	7	2025-04-29 12:30:00	Completed	Telehealth
4296	390	10	2026-03-09 13:00:00	No-show	Chronic care
4297	539	9	2019-02-16 14:45:00	Completed	Well child
4298	268	1	2025-08-03 12:45:00	Completed	Follow-up
4299	588	4	2025-11-15 16:45:00	No-show	Annual physical
4300	71	4	2021-01-24 17:00:00	Cancelled	Well child
4301	407	9	2020-04-22 16:30:00	Cancelled	Telehealth
4302	488	5	2025-11-26 08:45:00	Completed	Sick visit
4303	450	1	2023-06-27 09:45:00	No-show	Follow-up
4304	490	3	2025-08-12 08:15:00	Completed	Chronic care
4305	21	8	2025-09-10 17:00:00	Completed	Telehealth
4306	203	11	2024-12-18 12:15:00	Scheduled	Sick visit
4307	245	8	2026-03-25 09:00:00	No-show	Annual physical
4308	9	12	2024-01-16 15:30:00	Completed	Chronic care
4309	76	2	2026-05-02 12:15:00	Completed	Follow-up
4310	256	4	2021-07-15 10:45:00	Completed	Sick visit
4311	520	6	2019-05-24 14:45:00	Scheduled	Telehealth
4312	284	5	2021-07-01 17:00:00	Completed	Chronic care
4313	580	4	2022-10-18 08:15:00	Completed	Annual physical
4314	529	6	2023-05-03 11:45:00	Scheduled	Telehealth
4315	313	8	2021-11-02 08:15:00	Completed	Telehealth
4316	205	10	2022-10-06 09:45:00	Completed	Sick visit
4317	90	2	2019-06-06 14:15:00	Completed	Well child
4318	246	5	2022-09-08 16:00:00	Completed	Annual physical
4319	43	6	2024-08-05 12:30:00	Completed	Annual physical
4320	174	1	2020-12-03 17:00:00	Completed	Chronic care
4321	600	6	2020-09-05 16:15:00	Completed	Telehealth
4322	479	7	2026-03-01 16:45:00	Completed	Annual physical
4323	567	6	2020-06-13 15:45:00	Completed	Follow-up
4324	463	11	2025-06-20 15:45:00	Completed	Chronic care
4325	582	8	2025-04-27 12:45:00	Scheduled	Well child
4326	125	11	2021-06-15 09:00:00	Completed	Sick visit
4327	144	3	2020-06-09 13:00:00	Completed	Telehealth
4328	418	9	2023-10-13 10:00:00	Scheduled	Annual physical
4329	181	11	2020-08-14 13:15:00	Completed	Annual physical
4330	586	4	2024-02-06 12:15:00	No-show	Annual physical
4331	487	9	2021-03-11 09:00:00	Completed	Annual physical
4332	586	4	2022-09-27 08:30:00	Completed	Sick visit
4333	324	1	2023-08-07 13:30:00	Cancelled	Annual physical
4334	79	9	2022-12-06 08:00:00	Completed	Annual physical
4335	55	9	2025-04-24 10:45:00	Cancelled	Annual physical
4336	203	11	2023-01-04 14:00:00	Completed	Telehealth
4337	140	8	2022-05-04 13:00:00	Completed	Telehealth
4338	507	9	2024-06-15 14:15:00	Completed	Annual physical
4339	477	12	2022-08-29 12:15:00	Cancelled	Telehealth
4340	551	4	2023-02-13 12:15:00	Completed	Follow-up
4341	273	9	2024-12-27 10:30:00	Completed	Well child
4342	250	4	2024-07-21 08:30:00	Completed	Sick visit
4343	369	5	2023-06-08 11:30:00	Completed	Annual physical
4344	12	4	2026-04-28 11:30:00	Completed	Chronic care
4345	457	10	2019-10-31 11:30:00	Completed	Annual physical
4346	430	12	2021-04-26 15:45:00	Completed	Sick visit
4347	336	8	2019-05-24 13:30:00	Completed	Well child
4348	536	3	2020-09-19 13:15:00	Completed	Telehealth
4349	563	6	2019-01-14 09:00:00	Completed	Sick visit
4350	434	3	2019-01-24 14:00:00	Completed	Annual physical
4351	63	12	2019-03-21 16:15:00	No-show	Telehealth
4352	379	7	2020-10-10 17:00:00	Completed	Well child
4353	279	11	2020-12-03 08:15:00	Completed	Follow-up
4354	83	1	2023-01-07 12:00:00	Completed	Sick visit
4355	505	3	2020-01-26 12:45:00	Completed	Chronic care
4356	15	8	2020-11-20 10:30:00	Completed	Annual physical
4357	201	7	2024-05-12 09:15:00	Completed	Follow-up
4358	119	6	2021-03-21 14:15:00	Completed	Chronic care
4359	124	10	2019-03-28 11:00:00	Completed	Well child
4360	90	2	2025-12-12 14:30:00	Completed	Well child
4361	65	11	2019-01-13 17:00:00	No-show	Sick visit
4362	359	12	2022-05-29 15:15:00	Completed	Annual physical
4363	592	2	2022-07-15 08:15:00	Scheduled	Telehealth
4364	123	5	2019-07-07 16:00:00	Completed	Annual physical
4365	575	3	2024-05-23 10:45:00	No-show	Annual physical
4366	332	4	2022-12-29 08:15:00	Completed	Telehealth
4367	97	8	2024-07-10 15:15:00	Cancelled	Telehealth
4368	568	4	2020-09-12 13:00:00	Completed	Chronic care
4369	421	6	2021-12-12 15:45:00	Completed	Follow-up
4370	469	12	2021-04-29 17:00:00	Completed	Follow-up
4371	72	12	2023-09-11 14:00:00	No-show	Follow-up
4372	542	12	2024-12-18 13:30:00	Completed	Annual physical
4373	319	3	2022-04-28 09:00:00	Completed	Telehealth
4374	46	6	2025-02-18 14:00:00	Scheduled	Telehealth
4375	49	8	2023-06-22 15:45:00	Completed	Telehealth
4376	194	4	2019-12-19 16:30:00	Completed	Telehealth
4377	566	11	2020-11-29 17:00:00	Scheduled	Chronic care
4378	466	3	2025-09-04 09:15:00	Completed	Annual physical
4379	99	3	2022-12-20 11:30:00	Completed	Chronic care
4380	445	9	2020-11-16 16:30:00	Completed	Annual physical
4381	349	10	2024-07-09 08:45:00	Completed	Well child
4382	440	5	2020-03-14 11:30:00	Completed	Chronic care
4383	486	2	2021-04-27 13:00:00	Cancelled	Annual physical
4384	495	4	2024-09-22 17:00:00	Completed	Follow-up
4385	35	12	2023-05-11 11:45:00	Completed	Follow-up
4386	429	5	2020-09-23 14:15:00	Completed	Well child
4387	263	4	2019-02-24 08:00:00	Completed	Chronic care
4388	392	6	2022-05-05 14:30:00	Completed	Well child
4389	359	12	2025-09-08 11:30:00	No-show	Chronic care
4390	20	9	2024-04-22 10:00:00	Completed	Well child
4391	198	1	2025-09-26 16:15:00	Completed	Chronic care
4392	133	3	2024-04-16 10:30:00	Cancelled	Annual physical
4393	347	1	2025-03-31 16:00:00	No-show	Well child
4394	76	4	2024-05-15 16:30:00	Scheduled	Telehealth
4395	197	3	2020-02-11 14:15:00	Completed	Chronic care
4396	356	4	2024-05-23 09:15:00	Completed	Sick visit
4397	140	8	2020-05-01 10:00:00	Cancelled	Well child
4398	338	11	2022-02-02 10:00:00	Cancelled	Well child
4399	199	10	2025-11-28 11:45:00	Completed	Follow-up
4400	286	1	2022-04-18 16:00:00	Completed	Well child
4401	64	11	2021-01-20 11:30:00	No-show	Telehealth
4402	183	1	2025-08-16 16:30:00	Completed	Telehealth
4403	289	2	2023-05-02 16:30:00	Completed	Annual physical
4404	120	5	2022-12-15 10:45:00	Completed	Follow-up
4405	241	4	2022-09-27 14:30:00	Completed	Annual physical
4406	117	4	2023-04-28 12:00:00	Completed	Annual physical
4407	343	5	2021-01-23 16:30:00	Completed	Telehealth
4408	81	8	2022-01-18 09:00:00	No-show	Follow-up
4409	346	10	2022-08-07 16:30:00	Completed	Sick visit
4410	494	8	2023-01-16 12:15:00	Scheduled	Chronic care
4411	205	12	2025-08-14 11:15:00	Completed	Follow-up
4412	263	2	2021-09-11 16:30:00	Completed	Follow-up
4413	416	1	2022-10-17 12:00:00	Completed	Chronic care
4414	416	1	2023-12-04 08:30:00	Completed	Follow-up
4415	312	1	2022-11-30 16:15:00	Completed	Annual physical
4416	524	11	2024-11-11 14:45:00	Completed	Annual physical
4417	137	7	2023-10-24 12:45:00	Completed	Chronic care
4418	112	3	2019-10-19 09:15:00	Completed	Well child
4419	530	1	2025-03-06 09:15:00	Completed	Sick visit
4420	418	5	2025-10-22 13:00:00	Completed	Telehealth
4421	122	12	2025-05-23 15:00:00	Cancelled	Follow-up
4422	142	12	2026-02-28 14:00:00	Completed	Chronic care
4423	95	9	2021-12-04 12:30:00	Scheduled	Follow-up
4424	348	7	2020-09-26 13:15:00	Completed	Follow-up
4425	31	11	2022-06-08 11:45:00	Completed	Follow-up
4426	354	8	2023-10-23 16:15:00	Completed	Telehealth
4427	24	6	2022-05-18 17:00:00	Cancelled	Annual physical
4428	10	1	2025-12-29 12:00:00	No-show	Follow-up
4429	312	1	2020-12-14 09:45:00	Cancelled	Telehealth
4430	431	5	2019-03-12 10:30:00	Scheduled	Sick visit
4431	57	7	2024-03-07 14:30:00	Scheduled	Chronic care
4432	98	5	2019-09-05 12:00:00	Completed	Follow-up
4433	565	11	2020-10-18 16:00:00	Completed	Follow-up
4434	106	11	2019-01-27 15:00:00	Completed	Chronic care
4435	363	3	2023-10-23 16:00:00	Completed	Well child
4436	489	8	2024-04-05 11:00:00	Completed	Chronic care
4437	312	1	2025-09-27 09:15:00	Completed	Telehealth
4438	249	9	2019-04-25 15:30:00	Completed	Annual physical
4439	155	12	2019-10-04 11:00:00	Completed	Chronic care
4440	420	9	2019-08-20 15:30:00	Cancelled	Telehealth
4441	458	8	2021-02-15 17:00:00	Completed	Telehealth
4442	538	3	2024-01-06 08:45:00	Completed	Sick visit
4443	172	9	2022-06-16 08:15:00	Completed	Sick visit
4444	458	8	2019-06-23 14:30:00	No-show	Annual physical
4445	172	9	2024-03-22 09:45:00	Cancelled	Sick visit
4446	551	4	2019-04-06 11:45:00	Cancelled	Annual physical
4447	583	11	2020-12-07 11:30:00	Scheduled	Chronic care
4448	514	3	2023-04-19 14:00:00	No-show	Telehealth
4449	348	7	2020-01-29 08:45:00	Completed	Follow-up
4450	408	10	2022-07-19 14:45:00	Completed	Telehealth
4451	321	5	2026-05-05 13:15:00	Completed	Telehealth
4452	174	1	2024-05-30 15:45:00	Completed	Follow-up
4453	155	12	2019-09-15 10:45:00	Completed	Annual physical
4454	149	4	2024-11-16 11:00:00	Completed	Follow-up
4455	67	3	2023-09-22 11:30:00	Completed	Telehealth
4456	37	4	2023-05-19 12:00:00	Completed	Sick visit
4457	88	7	2024-06-06 12:15:00	Completed	Sick visit
4458	233	8	2021-06-17 10:00:00	Cancelled	Sick visit
4459	391	1	2022-01-14 08:00:00	Completed	Chronic care
4460	100	2	2022-04-26 14:45:00	Completed	Sick visit
4461	221	11	2024-02-15 13:15:00	Completed	Sick visit
4462	432	3	2020-12-24 11:15:00	Completed	Follow-up
4463	249	9	2021-03-16 16:15:00	Completed	Well child
4464	58	10	2024-04-25 14:15:00	Completed	Annual physical
4465	80	10	2019-06-27 08:30:00	Completed	Telehealth
4466	263	2	2022-09-22 08:15:00	Completed	Chronic care
4467	251	9	2019-02-10 12:15:00	Completed	Annual physical
4468	205	5	2025-07-04 15:15:00	Completed	Follow-up
4469	371	6	2024-02-11 09:30:00	Completed	Follow-up
4470	27	4	2019-07-09 09:45:00	Completed	Annual physical
4471	265	1	2022-01-02 09:00:00	Completed	Well child
4472	235	12	2026-03-30 08:30:00	Cancelled	Chronic care
4473	341	12	2024-05-29 13:45:00	Completed	Well child
4474	436	3	2020-05-30 14:00:00	Completed	Well child
4475	360	1	2025-04-10 13:45:00	Completed	Well child
4476	15	8	2025-02-02 14:00:00	Completed	Sick visit
4477	308	9	2019-10-10 11:30:00	Completed	Well child
4478	177	8	2022-10-19 09:30:00	No-show	Telehealth
4479	237	7	2025-10-22 14:15:00	Completed	Sick visit
4480	506	8	2019-08-19 16:00:00	Completed	Well child
4481	116	12	2024-12-01 16:00:00	Cancelled	Annual physical
4482	159	11	2026-03-23 13:00:00	Completed	Telehealth
4483	484	2	2024-04-08 11:00:00	Scheduled	Well child
4484	458	8	2019-11-11 09:15:00	Completed	Telehealth
4485	42	8	2026-01-17 14:00:00	Completed	Annual physical
4486	566	11	2023-02-10 08:30:00	Completed	Follow-up
4487	500	4	2023-08-25 16:15:00	Scheduled	Chronic care
4488	427	9	2019-09-18 14:45:00	Completed	Chronic care
4489	175	4	2026-05-17 09:45:00	Completed	Telehealth
4490	349	10	2024-12-27 13:15:00	Completed	Follow-up
4491	549	3	2023-03-18 15:15:00	Scheduled	Sick visit
4492	397	2	2022-12-28 10:45:00	Completed	Annual physical
4493	1	4	2022-07-06 13:00:00	Completed	Chronic care
4494	544	4	2026-02-14 10:30:00	Completed	Annual physical
4495	372	9	2023-11-28 12:15:00	No-show	Well child
4496	265	1	2022-03-20 08:45:00	Cancelled	Chronic care
4497	126	12	2022-10-31 09:30:00	Completed	Annual physical
4498	187	11	2021-09-25 10:15:00	Completed	Chronic care
4499	70	1	2023-02-10 11:30:00	No-show	Chronic care
4500	353	7	2024-02-14 12:00:00	Completed	Telehealth
4501	110	5	2025-09-25 10:30:00	No-show	Telehealth
4502	181	11	2025-06-06 16:15:00	Completed	Follow-up
4503	121	8	2025-02-17 13:00:00	Completed	Annual physical
4504	18	7	2020-10-12 16:15:00	Completed	Well child
4505	75	7	2020-09-27 10:45:00	Completed	Telehealth
4506	290	6	2020-06-15 15:45:00	Completed	Follow-up
4507	107	4	2021-09-22 12:30:00	Completed	Annual physical
4508	280	1	2019-12-10 16:00:00	Completed	Telehealth
4509	419	12	2020-04-19 16:00:00	Scheduled	Well child
4510	375	10	2023-08-10 10:45:00	Completed	Chronic care
4511	57	7	2019-01-04 12:30:00	Completed	Follow-up
4512	418	5	2019-07-16 14:30:00	Completed	Well child
4513	461	2	2019-07-14 17:00:00	Cancelled	Follow-up
4514	477	12	2020-03-14 15:15:00	Completed	Chronic care
4515	377	8	2022-06-30 10:30:00	Completed	Well child
4516	578	8	2019-04-26 14:30:00	No-show	Sick visit
4517	441	6	2022-11-01 09:30:00	Completed	Well child
4518	441	6	2019-02-11 14:45:00	Completed	Follow-up
4519	197	3	2022-12-24 13:45:00	Completed	Telehealth
4520	442	3	2024-04-15 09:00:00	Completed	Annual physical
4521	129	11	2021-03-10 15:00:00	Completed	Annual physical
4522	196	6	2025-03-15 17:00:00	Completed	Telehealth
4523	121	9	2021-03-08 12:45:00	Completed	Telehealth
4524	126	12	2025-08-30 12:15:00	Completed	Follow-up
4525	430	11	2025-10-27 09:30:00	Completed	Annual physical
4526	503	5	2019-02-04 10:45:00	Completed	Annual physical
4527	205	10	2025-10-10 14:45:00	Completed	Sick visit
4528	433	6	2026-04-23 12:45:00	Completed	Telehealth
4529	294	11	2025-11-10 12:30:00	Completed	Telehealth
4530	29	1	2020-09-10 10:30:00	Completed	Well child
4531	41	6	2020-12-12 10:00:00	Completed	Telehealth
4532	516	12	2023-05-06 15:15:00	Completed	Well child
4533	308	9	2025-04-17 09:30:00	Scheduled	Telehealth
4534	20	9	2021-10-04 15:45:00	No-show	Well child
4535	581	4	2019-07-27 14:15:00	Completed	Telehealth
4536	588	4	2024-05-26 13:00:00	Completed	Well child
4537	77	6	2021-02-14 13:00:00	Cancelled	Well child
4538	267	4	2022-06-13 14:30:00	Cancelled	Well child
4539	442	3	2021-11-03 09:30:00	Cancelled	Annual physical
4540	558	1	2023-04-10 09:00:00	Completed	Well child
4541	169	9	2025-09-15 16:30:00	Completed	Well child
4542	474	5	2022-04-14 11:30:00	Scheduled	Telehealth
4543	572	2	2022-03-22 12:45:00	Completed	Sick visit
4544	78	7	2019-11-15 14:00:00	Completed	Annual physical
4545	340	1	2026-03-19 16:00:00	Completed	Chronic care
4546	525	6	2019-04-17 10:45:00	Scheduled	Follow-up
4547	367	3	2026-01-26 12:45:00	Completed	Sick visit
4548	68	8	2026-01-26 16:15:00	Completed	Annual physical
4549	537	5	2026-02-26 08:00:00	Scheduled	Well child
4550	457	10	2019-12-12 12:45:00	Completed	Chronic care
4551	590	9	2020-10-03 11:00:00	No-show	Annual physical
4552	520	6	2024-12-19 14:45:00	Completed	Follow-up
4553	254	11	2022-09-11 13:00:00	Completed	Annual physical
4554	240	12	2022-06-08 16:30:00	Completed	Annual physical
4555	549	3	2022-07-18 10:45:00	Completed	Telehealth
4556	294	11	2020-10-18 14:00:00	Scheduled	Follow-up
4557	113	11	2019-10-26 11:30:00	Completed	Sick visit
4558	396	6	2024-06-25 10:15:00	No-show	Follow-up
4559	90	2	2019-12-14 15:30:00	No-show	Sick visit
4560	597	7	2021-07-22 08:00:00	Cancelled	Well child
4561	34	5	2020-02-27 11:00:00	Completed	Telehealth
4562	310	9	2025-09-17 14:15:00	Completed	Sick visit
4563	38	12	2022-06-10 12:45:00	No-show	Well child
4564	392	2	2021-12-14 15:15:00	Completed	Annual physical
4565	187	2	2019-06-19 11:30:00	Completed	Annual physical
4566	537	5	2025-11-14 15:30:00	Completed	Telehealth
4567	49	4	2025-11-25 15:15:00	Completed	Telehealth
4568	260	2	2019-01-07 13:00:00	No-show	Follow-up
4569	128	6	2024-12-26 08:45:00	Completed	Telehealth
4570	595	1	2024-09-08 11:30:00	Completed	Telehealth
4571	272	1	2023-11-09 08:15:00	Completed	Well child
4572	4	4	2019-04-27 14:45:00	Cancelled	Sick visit
4573	325	4	2021-05-26 10:00:00	Cancelled	Chronic care
4574	194	4	2022-03-28 12:00:00	Completed	Telehealth
4575	271	1	2019-08-11 13:45:00	Completed	Follow-up
4576	206	11	2022-01-23 17:00:00	Completed	Follow-up
4577	257	2	2022-09-04 09:45:00	Completed	Telehealth
4578	259	6	2021-07-01 09:30:00	Completed	Sick visit
4579	288	9	2023-02-04 13:15:00	Completed	Chronic care
4580	319	11	2024-09-01 14:45:00	Completed	Chronic care
4581	562	4	2023-06-10 15:45:00	Completed	Follow-up
4582	509	2	2022-05-06 16:30:00	Completed	Telehealth
4583	501	12	2021-07-04 08:15:00	Scheduled	Annual physical
4584	567	6	2019-07-16 08:15:00	Completed	Telehealth
4585	447	8	2021-09-17 13:15:00	Completed	Follow-up
4586	33	9	2024-06-26 11:45:00	Completed	Chronic care
4587	572	2	2025-02-21 16:30:00	No-show	Well child
4588	309	9	2025-05-26 13:15:00	No-show	Sick visit
4589	585	2	2025-10-04 09:15:00	Completed	Well child
4590	457	10	2022-11-02 15:15:00	Completed	Well child
4591	434	3	2024-01-12 09:15:00	Scheduled	Well child
4592	580	4	2024-05-18 10:15:00	Completed	Telehealth
4593	28	3	2021-10-09 14:15:00	Completed	Chronic care
4594	432	3	2025-12-09 15:15:00	Completed	Chronic care
4595	592	12	2021-10-01 10:45:00	Completed	Telehealth
4596	253	4	2022-02-07 12:30:00	Completed	Follow-up
4597	454	3	2024-02-08 09:00:00	Completed	Follow-up
4598	589	12	2021-04-16 16:30:00	Completed	Annual physical
4599	597	8	2025-08-27 10:30:00	Completed	Well child
4600	507	6	2020-05-25 15:00:00	Completed	Sick visit
4601	253	4	2021-08-08 16:00:00	Completed	Chronic care
4602	393	9	2023-05-26 10:00:00	Completed	Telehealth
4603	283	4	2024-11-11 13:45:00	Completed	Well child
4604	585	2	2024-09-23 08:00:00	Completed	Telehealth
4605	176	1	2025-11-19 11:15:00	Completed	Annual physical
4606	100	2	2019-09-07 10:45:00	Completed	Chronic care
4607	280	1	2026-04-22 16:45:00	Cancelled	Well child
4608	274	1	2019-04-21 11:15:00	Completed	Well child
4609	385	9	2023-09-24 14:00:00	Completed	Follow-up
4610	374	6	2023-05-21 14:30:00	No-show	Annual physical
4611	232	6	2022-08-13 16:15:00	Cancelled	Chronic care
4612	355	6	2019-06-22 11:30:00	Completed	Sick visit
4613	562	5	2023-09-19 10:15:00	Completed	Chronic care
4614	341	10	2022-05-12 15:00:00	Scheduled	Chronic care
4615	447	8	2019-09-23 14:15:00	Completed	Annual physical
4616	203	10	2024-10-26 10:30:00	Completed	Chronic care
4617	214	1	2023-05-03 14:30:00	Completed	Sick visit
4618	342	1	2022-04-17 11:15:00	Completed	Follow-up
4619	370	9	2024-02-08 10:00:00	Completed	Follow-up
4620	501	10	2020-09-04 14:00:00	Completed	Chronic care
4621	142	12	2024-07-24 13:30:00	Completed	Well child
4622	522	4	2025-06-19 08:30:00	Completed	Sick visit
4623	4	2	2024-02-10 08:15:00	No-show	Chronic care
4624	211	2	2023-04-11 14:00:00	Completed	Well child
4625	83	1	2023-02-03 09:15:00	Completed	Annual physical
4626	270	5	2022-11-29 16:15:00	Completed	Chronic care
4627	342	1	2021-09-12 12:15:00	Completed	Follow-up
4628	117	4	2020-03-03 11:45:00	No-show	Annual physical
4629	401	11	2019-01-10 11:30:00	Completed	Follow-up
4630	424	8	2025-01-18 11:00:00	Completed	Telehealth
4631	428	8	2021-04-10 10:45:00	No-show	Telehealth
4632	493	1	2025-08-19 14:15:00	Scheduled	Chronic care
4633	467	4	2020-08-24 09:45:00	Cancelled	Follow-up
4634	556	9	2024-01-01 11:00:00	Scheduled	Sick visit
4635	280	1	2024-10-30 11:15:00	No-show	Well child
4636	475	7	2019-10-24 12:00:00	Completed	Annual physical
4637	336	10	2022-03-13 13:15:00	Completed	Chronic care
4638	438	3	2022-10-15 09:00:00	Completed	Follow-up
4639	293	5	2021-03-24 14:15:00	Completed	Telehealth
4640	425	2	2023-05-04 09:00:00	No-show	Sick visit
4641	447	1	2025-08-04 09:45:00	Completed	Annual physical
4642	70	1	2020-11-28 12:00:00	Completed	Follow-up
4643	529	6	2025-12-11 15:15:00	Completed	Telehealth
4644	547	4	2021-09-17 14:00:00	Completed	Telehealth
4645	141	12	2026-04-17 14:45:00	Completed	Chronic care
4646	487	9	2020-05-29 15:15:00	Completed	Chronic care
4647	4	2	2024-02-28 08:15:00	Completed	Well child
4648	526	2	2022-06-02 14:45:00	Completed	Follow-up
4649	444	2	2020-08-06 12:30:00	Completed	Well child
4650	256	4	2020-01-08 13:00:00	Completed	Telehealth
4651	486	2	2020-01-10 11:15:00	Completed	Chronic care
4652	69	10	2020-11-19 10:30:00	Completed	Telehealth
4653	109	7	2025-06-12 10:30:00	Completed	Chronic care
4654	224	1	2024-02-26 16:45:00	Scheduled	Annual physical
4655	318	11	2020-05-25 15:30:00	Completed	Sick visit
4656	13	2	2024-12-10 16:15:00	Cancelled	Annual physical
4657	540	4	2024-10-22 17:00:00	No-show	Well child
4658	189	11	2025-01-05 15:15:00	Scheduled	Follow-up
4659	109	7	2025-10-24 08:15:00	Completed	Telehealth
4660	527	8	2023-12-02 09:15:00	Completed	Well child
4661	259	4	2020-07-30 09:30:00	Completed	Follow-up
4662	160	7	2026-05-25 14:45:00	Completed	Well child
4663	156	10	2022-06-02 15:30:00	Completed	Follow-up
4664	199	10	2024-08-25 16:00:00	Completed	Chronic care
4665	511	2	2021-05-25 13:15:00	Completed	Sick visit
4666	311	11	2022-05-31 10:30:00	Completed	Well child
4667	136	12	2023-01-20 12:45:00	Completed	Sick visit
4668	313	9	2022-02-25 13:30:00	Completed	Follow-up
4669	339	12	2021-12-30 09:00:00	No-show	Well child
4670	49	3	2023-12-27 12:45:00	Completed	Annual physical
4671	382	11	2025-11-25 13:30:00	Completed	Telehealth
4672	445	2	2022-07-20 09:30:00	Completed	Telehealth
4673	93	1	2024-03-22 16:00:00	Cancelled	Telehealth
4674	82	3	2023-01-30 08:30:00	Completed	Follow-up
4675	290	6	2023-07-27 14:15:00	Cancelled	Follow-up
4676	208	7	2019-02-11 17:00:00	Completed	Well child
4677	393	9	2025-03-11 13:45:00	Completed	Chronic care
4678	516	12	2023-05-01 15:00:00	No-show	Well child
4679	237	10	2020-05-16 09:00:00	Completed	Follow-up
4680	52	11	2025-09-16 14:45:00	Scheduled	Follow-up
4681	13	2	2023-11-21 11:00:00	Completed	Well child
4682	76	4	2021-02-14 11:30:00	No-show	Sick visit
4683	4	7	2025-11-24 15:45:00	No-show	Well child
4684	305	2	2022-11-10 16:45:00	Completed	Well child
4685	78	7	2024-07-29 08:00:00	Completed	Follow-up
4686	283	4	2021-08-11 17:00:00	Scheduled	Annual physical
4687	497	10	2019-05-04 10:00:00	Completed	Sick visit
4688	128	6	2019-03-14 11:00:00	Cancelled	Telehealth
4689	556	9	2024-01-07 09:45:00	Completed	Annual physical
4690	426	7	2022-04-21 16:45:00	Completed	Annual physical
4691	232	6	2019-11-02 09:00:00	No-show	Sick visit
4692	487	1	2023-08-21 17:00:00	No-show	Chronic care
4693	104	6	2021-02-02 15:15:00	No-show	Chronic care
4694	27	4	2023-02-13 09:00:00	Scheduled	Chronic care
4695	46	6	2025-06-17 16:30:00	Completed	Chronic care
4696	362	6	2022-03-28 13:00:00	Completed	Sick visit
4697	336	8	2023-10-18 15:00:00	Cancelled	Well child
4698	424	8	2024-03-03 09:30:00	Completed	Follow-up
4699	117	4	2022-08-19 12:00:00	Completed	Well child
4700	5	4	2025-04-04 13:15:00	Completed	Follow-up
4701	119	7	2023-10-03 15:15:00	Completed	Sick visit
4702	342	1	2024-11-01 11:30:00	Completed	Follow-up
4703	574	5	2019-10-01 10:15:00	Completed	Telehealth
4704	524	11	2020-08-31 09:45:00	Completed	Follow-up
4705	279	11	2020-02-12 16:45:00	Completed	Annual physical
4706	234	2	2019-04-14 15:45:00	Completed	Sick visit
4707	366	12	2019-11-05 09:00:00	Completed	Telehealth
4708	479	12	2019-11-13 16:30:00	Completed	Telehealth
4709	498	3	2022-05-13 15:30:00	Completed	Annual physical
4710	188	9	2025-06-18 17:00:00	Scheduled	Follow-up
4711	302	9	2025-04-28 10:30:00	Completed	Chronic care
4712	135	11	2024-07-21 11:30:00	Scheduled	Telehealth
4713	426	3	2020-03-13 09:00:00	Completed	Follow-up
4714	241	11	2023-12-21 13:15:00	Completed	Well child
4715	333	11	2019-10-23 08:45:00	Completed	Chronic care
4716	97	8	2019-11-26 13:00:00	Completed	Well child
4717	180	5	2025-07-20 09:45:00	Completed	Follow-up
4718	133	3	2022-05-24 11:30:00	Completed	Chronic care
4719	509	2	2021-09-16 09:30:00	Completed	Chronic care
4720	288	5	2021-11-01 09:15:00	Scheduled	Chronic care
4721	116	7	2022-03-24 11:30:00	Completed	Sick visit
4722	553	7	2025-03-22 17:00:00	Completed	Sick visit
4723	373	4	2020-06-12 16:15:00	Completed	Chronic care
4724	547	4	2022-04-21 12:15:00	Completed	Annual physical
4725	587	7	2019-10-24 15:30:00	Completed	Follow-up
4726	418	6	2019-04-20 12:00:00	Completed	Well child
4727	269	9	2022-09-04 17:00:00	Completed	Annual physical
4728	296	4	2024-09-02 10:30:00	Completed	Well child
4729	204	2	2023-01-17 10:45:00	Completed	Annual physical
4730	580	2	2019-05-01 14:30:00	Completed	Chronic care
4731	501	12	2021-07-12 16:15:00	Completed	Follow-up
4732	150	8	2025-10-25 12:30:00	Completed	Well child
4733	472	4	2022-02-03 08:45:00	Cancelled	Chronic care
4734	46	6	2019-05-31 10:45:00	Completed	Follow-up
4735	530	5	2023-12-27 14:15:00	Completed	Annual physical
4736	371	6	2023-04-12 10:30:00	Cancelled	Well child
4737	80	10	2019-09-25 10:45:00	Completed	Annual physical
4738	158	8	2025-12-15 11:00:00	Completed	Telehealth
4739	12	4	2020-06-19 15:00:00	Completed	Chronic care
4740	58	11	2019-10-29 16:45:00	Completed	Annual physical
4741	144	3	2023-09-30 16:45:00	Completed	Chronic care
4742	590	2	2023-08-10 12:15:00	Completed	Telehealth
4743	198	1	2022-09-12 08:30:00	Completed	Well child
4744	71	4	2020-04-24 12:45:00	Completed	Telehealth
4745	471	8	2020-10-02 12:45:00	Completed	Chronic care
4746	391	11	2023-03-22 13:45:00	Completed	Telehealth
4747	558	12	2020-09-24 10:00:00	Completed	Annual physical
4748	378	4	2021-09-08 08:00:00	Completed	Annual physical
4749	234	10	2019-10-02 14:45:00	Completed	Chronic care
4750	550	3	2026-03-17 17:00:00	Completed	Sick visit
4751	189	4	2019-09-09 16:00:00	Scheduled	Follow-up
4752	314	9	2022-08-27 16:00:00	Completed	Follow-up
4753	347	10	2019-04-29 15:45:00	Completed	Annual physical
4754	280	12	2024-11-23 09:45:00	Cancelled	Annual physical
4755	13	2	2023-10-24 14:45:00	Completed	Annual physical
4756	318	2	2021-07-27 08:45:00	Completed	Sick visit
4757	351	2	2019-05-08 17:00:00	Cancelled	Sick visit
4758	565	11	2023-09-21 12:45:00	Completed	Chronic care
4759	67	3	2019-06-10 12:30:00	Completed	Follow-up
4760	372	9	2024-12-12 12:15:00	Completed	Follow-up
4761	369	5	2023-03-24 15:45:00	Completed	Chronic care
4762	429	5	2024-11-16 15:15:00	Completed	Annual physical
4763	503	5	2019-05-06 12:45:00	Completed	Well child
4764	462	4	2026-04-30 14:30:00	No-show	Sick visit
4765	154	8	2025-10-02 09:00:00	Completed	Sick visit
4766	595	1	2020-04-11 16:00:00	No-show	Sick visit
4767	418	5	2023-04-25 16:00:00	Cancelled	Annual physical
4768	496	3	2024-01-17 10:00:00	Completed	Telehealth
4769	394	6	2021-10-07 13:30:00	Completed	Follow-up
4770	501	8	2022-10-27 16:45:00	Completed	Sick visit
4771	68	11	2021-04-28 10:15:00	Completed	Follow-up
4772	518	3	2020-06-25 16:00:00	Completed	Telehealth
4773	585	2	2025-09-29 13:45:00	Completed	Telehealth
4774	551	4	2021-05-29 08:00:00	Completed	Telehealth
4775	147	1	2020-03-11 11:45:00	Completed	Sick visit
4776	385	9	2020-02-11 13:30:00	Completed	Annual physical
4777	40	8	2022-08-22 14:15:00	Completed	Sick visit
4778	548	7	2024-11-01 08:30:00	Completed	Chronic care
4779	321	5	2024-01-31 14:15:00	Scheduled	Telehealth
4780	292	11	2023-09-11 12:15:00	Completed	Well child
4781	70	1	2021-03-30 13:15:00	Completed	Telehealth
4782	152	7	2021-12-05 12:30:00	Completed	Chronic care
4783	71	4	2022-08-31 08:30:00	Completed	Sick visit
4784	38	12	2021-10-06 16:00:00	Completed	Sick visit
4785	143	10	2020-02-09 16:00:00	No-show	Annual physical
4786	313	8	2026-05-06 08:00:00	Completed	Annual physical
4787	339	12	2025-04-10 15:30:00	Completed	Chronic care
4788	56	2	2019-04-28 10:00:00	Completed	Sick visit
4789	469	12	2021-01-04 11:15:00	Completed	Telehealth
4790	192	6	2026-01-01 08:30:00	Completed	Sick visit
4791	472	11	2025-02-07 10:30:00	Completed	Annual physical
4792	598	8	2022-07-31 14:45:00	Cancelled	Telehealth
4793	588	4	2025-11-20 14:00:00	Completed	Sick visit
4794	323	10	2021-06-20 12:45:00	Completed	Telehealth
4795	54	10	2024-12-23 10:15:00	Completed	Sick visit
4796	29	7	2021-05-07 15:30:00	Completed	Chronic care
4797	299	12	2024-04-26 10:15:00	Cancelled	Sick visit
4798	586	4	2023-05-29 10:30:00	Completed	Chronic care
4799	124	12	2024-06-09 15:15:00	Completed	Telehealth
4800	380	7	2019-11-26 12:15:00	Completed	Sick visit
4801	513	2	2022-06-18 11:00:00	Completed	Chronic care
4802	74	5	2025-03-17 15:45:00	No-show	Sick visit
4803	330	8	2021-03-20 12:45:00	Cancelled	Well child
4804	299	12	2022-01-26 15:30:00	Completed	Telehealth
4805	99	3	2021-10-26 14:45:00	No-show	Chronic care
4806	34	5	2024-12-07 15:00:00	Cancelled	Follow-up
4807	38	12	2023-09-30 13:15:00	Completed	Telehealth
4808	25	10	2023-07-26 11:30:00	Completed	Telehealth
4809	389	5	2019-12-04 11:00:00	Completed	Well child
4810	552	8	2019-04-04 16:30:00	Completed	Telehealth
4811	379	7	2020-04-14 15:15:00	Completed	Chronic care
4812	494	8	2026-01-01 13:00:00	Completed	Well child
4813	539	4	2023-03-29 10:15:00	Completed	Telehealth
4814	162	10	2024-11-21 13:45:00	Scheduled	Well child
4815	115	7	2023-09-30 11:00:00	No-show	Well child
4816	336	8	2019-03-04 12:30:00	Completed	Well child
4817	107	4	2023-05-16 13:15:00	Completed	Chronic care
4818	238	1	2023-07-01 11:45:00	Completed	Telehealth
4819	63	12	2019-08-04 09:45:00	Completed	Well child
4820	56	2	2020-06-22 10:15:00	Completed	Telehealth
4821	343	2	2021-04-02 10:45:00	Completed	Well child
4822	445	9	2020-03-20 16:15:00	No-show	Annual physical
4823	451	3	2020-04-04 14:30:00	Cancelled	Well child
4824	594	10	2025-09-03 09:30:00	Completed	Chronic care
4825	507	9	2023-09-05 09:00:00	Completed	Follow-up
4826	285	9	2024-07-15 13:00:00	Cancelled	Follow-up
4827	14	1	2021-04-05 09:00:00	Completed	Follow-up
4828	24	6	2019-08-28 14:45:00	Scheduled	Chronic care
4829	274	1	2021-05-27 13:30:00	Completed	Telehealth
4830	586	4	2025-10-25 08:15:00	Completed	Annual physical
4831	78	7	2025-10-02 09:45:00	Cancelled	Annual physical
4832	360	12	2019-11-29 17:00:00	Completed	Annual physical
4833	316	9	2023-07-27 12:15:00	Completed	Follow-up
4834	20	8	2024-01-07 09:45:00	Completed	Sick visit
4835	47	12	2024-04-09 10:00:00	Completed	Well child
4836	254	11	2023-09-06 12:15:00	Completed	Telehealth
4837	282	5	2025-01-07 11:45:00	Completed	Chronic care
4838	477	12	2022-01-03 14:45:00	Completed	Well child
4839	554	6	2023-05-18 14:15:00	Completed	Follow-up
4840	321	5	2023-09-18 10:15:00	Completed	Telehealth
4841	12	2	2026-02-11 11:45:00	Completed	Telehealth
4842	432	3	2019-03-25 16:45:00	Cancelled	Annual physical
4843	525	1	2024-04-02 08:00:00	Completed	Annual physical
4844	429	5	2025-08-22 09:30:00	No-show	Telehealth
4845	330	8	2022-09-11 17:00:00	Completed	Sick visit
4846	351	2	2025-04-18 14:00:00	Completed	Follow-up
4847	161	11	2019-01-28 10:45:00	Completed	Well child
4848	582	8	2026-03-02 13:45:00	Completed	Chronic care
4849	316	9	2025-02-19 16:30:00	Completed	Follow-up
4850	470	2	2023-10-01 16:15:00	Completed	Well child
4851	244	10	2022-05-08 15:15:00	Completed	Annual physical
4852	277	7	2024-07-12 11:00:00	Completed	Telehealth
4853	329	11	2024-10-02 17:00:00	Completed	Sick visit
4854	349	10	2020-11-24 08:15:00	Completed	Well child
4855	365	7	2021-06-30 10:15:00	Completed	Sick visit
4856	563	9	2022-11-07 17:00:00	Completed	Follow-up
4857	319	11	2023-04-03 09:45:00	Completed	Annual physical
4858	562	5	2022-07-17 14:30:00	Completed	Follow-up
4859	125	11	2024-12-30 11:00:00	No-show	Chronic care
4860	489	8	2022-10-02 17:00:00	Completed	Sick visit
4861	302	5	2022-01-08 15:45:00	Completed	Chronic care
4862	340	1	2022-10-05 09:15:00	Completed	Sick visit
4863	338	11	2022-12-22 15:45:00	Completed	Annual physical
4864	176	4	2020-10-29 16:45:00	Completed	Telehealth
4865	51	12	2023-02-19 10:00:00	Cancelled	Follow-up
4866	400	6	2024-12-24 10:15:00	Completed	Telehealth
4867	132	10	2025-03-07 08:00:00	Completed	Well child
4868	10	1	2023-06-07 08:30:00	Completed	Chronic care
4869	407	11	2021-09-02 12:45:00	Completed	Chronic care
4870	160	7	2022-02-06 08:30:00	Cancelled	Follow-up
4871	396	3	2023-09-30 13:00:00	Completed	Follow-up
4872	200	1	2026-03-06 09:00:00	Completed	Annual physical
4873	63	11	2025-07-08 16:15:00	Cancelled	Annual physical
4874	269	9	2023-06-10 15:15:00	Completed	Annual physical
4875	121	7	2024-02-18 13:45:00	Scheduled	Chronic care
4876	207	11	2025-09-30 10:45:00	Completed	Annual physical
4877	262	7	2023-07-28 11:00:00	Completed	Annual physical
4878	233	8	2024-07-06 08:15:00	Scheduled	Chronic care
4879	515	5	2022-06-09 10:45:00	Completed	Sick visit
4880	371	6	2024-05-11 15:45:00	Completed	Annual physical
4881	358	11	2026-02-11 08:00:00	Completed	Well child
4882	123	1	2021-10-28 16:15:00	Completed	Annual physical
4883	536	5	2023-10-05 13:45:00	Completed	Well child
4884	189	11	2020-04-01 13:45:00	Completed	Follow-up
4885	128	6	2019-02-10 12:45:00	Cancelled	Chronic care
4886	589	12	2023-09-12 16:15:00	Completed	Chronic care
4887	472	4	2023-03-19 09:45:00	Scheduled	Sick visit
4888	510	12	2020-07-25 15:15:00	Completed	Annual physical
4889	93	1	2021-04-28 14:15:00	Scheduled	Well child
4890	403	4	2022-11-06 08:00:00	Completed	Sick visit
4891	65	11	2021-08-22 13:30:00	Completed	Sick visit
4892	47	12	2024-10-26 13:00:00	Completed	Chronic care
4893	56	2	2023-01-03 08:30:00	No-show	Follow-up
4894	386	2	2021-04-05 10:00:00	Completed	Sick visit
4895	139	12	2023-01-21 08:00:00	Completed	Telehealth
4896	470	12	2020-07-11 12:45:00	Scheduled	Telehealth
4897	351	2	2019-07-23 11:45:00	Completed	Telehealth
4898	156	10	2021-12-21 10:00:00	Cancelled	Well child
4899	15	8	2024-11-11 12:30:00	Completed	Chronic care
4900	31	11	2019-10-23 10:00:00	Scheduled	Follow-up
4901	21	12	2020-10-18 14:00:00	Completed	Follow-up
4902	202	4	2026-02-23 12:30:00	Completed	Well child
4903	260	2	2019-04-21 12:00:00	Completed	Follow-up
4904	343	5	2025-10-27 12:45:00	Completed	Telehealth
4905	184	2	2025-10-29 17:00:00	Completed	Follow-up
4906	551	4	2022-02-12 10:45:00	No-show	Telehealth
4907	485	2	2021-04-14 11:45:00	Completed	Annual physical
4908	178	10	2020-01-23 08:15:00	Completed	Annual physical
4909	375	10	2023-02-02 09:30:00	No-show	Follow-up
4910	526	2	2021-10-22 11:15:00	Completed	Annual physical
4911	353	12	2024-01-04 14:15:00	Completed	Follow-up
4912	397	9	2025-11-16 12:15:00	Completed	Telehealth
4913	526	2	2024-06-19 09:00:00	Completed	Chronic care
4914	399	7	2019-10-09 15:30:00	Completed	Well child
4915	127	11	2024-07-31 11:45:00	Completed	Annual physical
4916	494	8	2025-06-23 15:00:00	Completed	Well child
4917	246	5	2023-02-06 11:00:00	Cancelled	Sick visit
4918	556	9	2020-06-05 08:00:00	Completed	Chronic care
4919	147	9	2020-06-10 09:30:00	Completed	Chronic care
4920	507	2	2022-01-06 16:00:00	Cancelled	Sick visit
4921	431	5	2019-10-18 12:30:00	Completed	Sick visit
4922	516	12	2020-03-30 14:15:00	Completed	Well child
4923	527	8	2020-06-27 12:30:00	Completed	Follow-up
4924	110	3	2023-12-20 08:45:00	Completed	Follow-up
4925	238	1	2020-07-11 13:30:00	Completed	Well child
4926	555	6	2022-07-08 16:30:00	Completed	Telehealth
4927	23	4	2023-01-28 13:00:00	Completed	Telehealth
4928	555	6	2024-05-07 14:00:00	Completed	Chronic care
4929	296	9	2020-08-01 11:30:00	Completed	Annual physical
4930	135	8	2021-03-26 10:00:00	Completed	Telehealth
4931	374	6	2021-09-25 12:45:00	Completed	Chronic care
4932	575	3	2022-04-05 14:15:00	Completed	Chronic care
4933	213	4	2021-12-05 14:45:00	Completed	Sick visit
4934	466	3	2019-01-15 10:45:00	No-show	Annual physical
4935	494	8	2025-10-05 12:15:00	Completed	Sick visit
4936	564	6	2020-07-21 15:15:00	Completed	Follow-up
4937	346	11	2020-11-23 14:15:00	Completed	Follow-up
4938	70	1	2020-07-16 14:45:00	Completed	Follow-up
4939	436	12	2020-11-26 16:45:00	Completed	Chronic care
4940	285	3	2025-05-28 08:15:00	Completed	Chronic care
4941	48	10	2020-12-24 16:30:00	Completed	Annual physical
4942	296	4	2020-08-09 16:45:00	Completed	Telehealth
4943	466	3	2024-11-30 11:15:00	Completed	Follow-up
4944	234	2	2024-03-05 08:15:00	Completed	Well child
4945	379	7	2020-07-11 16:45:00	Completed	Well child
4946	128	6	2020-12-09 08:45:00	Cancelled	Chronic care
4947	274	1	2020-10-28 16:15:00	Cancelled	Telehealth
4948	237	10	2022-11-25 09:45:00	Completed	Follow-up
4949	43	6	2025-08-02 14:30:00	Completed	Well child
4950	573	9	2019-10-28 11:00:00	No-show	Telehealth
4951	561	8	2021-01-05 15:15:00	Completed	Telehealth
4952	441	10	2021-01-15 13:15:00	Cancelled	Annual physical
4953	473	5	2022-05-03 11:45:00	Completed	Follow-up
4954	340	2	2025-01-10 12:15:00	Completed	Sick visit
4955	76	6	2024-03-21 10:45:00	Completed	Well child
4956	70	1	2022-02-12 09:15:00	Completed	Well child
4957	64	2	2024-01-28 08:30:00	Completed	Annual physical
4958	32	6	2019-01-25 17:00:00	Completed	Telehealth
4959	72	12	2024-06-18 16:00:00	Completed	Sick visit
4960	59	10	2019-05-02 08:00:00	Cancelled	Follow-up
4961	15	8	2020-06-18 08:15:00	Completed	Sick visit
4962	454	3	2020-09-02 16:30:00	Completed	Well child
4963	108	3	2020-04-22 14:00:00	Completed	Telehealth
4964	253	4	2021-08-15 15:45:00	Cancelled	Well child
4965	47	12	2022-10-14 13:00:00	Completed	Telehealth
4966	235	3	2024-09-02 11:30:00	Completed	Chronic care
4967	3	12	2020-03-22 16:30:00	Completed	Sick visit
4968	592	12	2024-04-22 10:00:00	Completed	Telehealth
4969	577	8	2021-07-20 14:30:00	Completed	Annual physical
4970	473	5	2022-04-04 12:30:00	Completed	Telehealth
4971	51	12	2023-10-13 16:15:00	Completed	Follow-up
4972	439	1	2019-05-17 16:15:00	Completed	Telehealth
4973	219	11	2020-04-05 11:00:00	Cancelled	Annual physical
4974	328	7	2019-03-25 15:00:00	Cancelled	Telehealth
4975	284	5	2019-05-26 09:45:00	Completed	Follow-up
4976	55	9	2023-06-26 15:30:00	Scheduled	Follow-up
4977	395	8	2021-02-13 17:00:00	Completed	Chronic care
4978	215	10	2026-01-23 11:00:00	Completed	Chronic care
4979	485	3	2022-10-24 12:30:00	Completed	Annual physical
4980	588	4	2025-12-12 11:15:00	Completed	Annual physical
4981	124	3	2023-11-30 14:45:00	No-show	Sick visit
4982	146	10	2021-11-29 12:15:00	Completed	Follow-up
4983	349	10	2021-10-22 10:45:00	No-show	Follow-up
4984	276	8	2019-05-05 08:00:00	Completed	Follow-up
4985	143	10	2023-01-28 08:15:00	Completed	Annual physical
4986	426	7	2023-07-07 09:15:00	Scheduled	Well child
4987	563	4	2025-01-15 17:00:00	Completed	Telehealth
4988	535	5	2019-05-02 10:45:00	Completed	Chronic care
4989	94	9	2019-08-10 10:15:00	Completed	Follow-up
4990	208	4	2023-06-23 16:00:00	Completed	Telehealth
4991	8	1	2020-11-20 10:45:00	Completed	Annual physical
4992	328	7	2025-07-30 14:45:00	Completed	Telehealth
4993	145	4	2020-03-01 13:30:00	Cancelled	Follow-up
4994	418	3	2023-01-16 13:45:00	Completed	Sick visit
4995	428	9	2023-11-25 15:45:00	Completed	Annual physical
4996	549	3	2023-12-26 13:00:00	Completed	Chronic care
4997	26	2	2023-03-13 08:30:00	Completed	Telehealth
4998	351	2	2024-06-16 13:45:00	Completed	Chronic care
4999	68	11	2021-10-18 08:30:00	Completed	Annual physical
5000	226	4	2022-01-29 15:45:00	Completed	Well child
5001	69	10	2022-07-28 10:00:00	Completed	Annual physical
5002	325	12	2026-01-04 08:45:00	Completed	Sick visit
5003	339	12	2023-10-21 14:00:00	Completed	Telehealth
5004	240	12	2026-03-16 14:30:00	Completed	Follow-up
5005	360	12	2019-12-09 11:15:00	Completed	Follow-up
5006	569	8	2023-03-14 15:00:00	Completed	Well child
5007	273	4	2022-11-05 10:00:00	Completed	Follow-up
5008	243	4	2020-12-19 12:15:00	Completed	Chronic care
5009	252	9	2019-08-19 12:30:00	Cancelled	Follow-up
5010	354	11	2025-05-06 10:45:00	Scheduled	Annual physical
5011	339	12	2024-02-29 15:15:00	Completed	Well child
5012	156	10	2023-06-07 13:30:00	Cancelled	Annual physical
5013	257	2	2021-12-28 10:30:00	No-show	Telehealth
5014	377	8	2022-10-15 13:30:00	Completed	Annual physical
5015	548	10	2020-09-05 15:45:00	Completed	Well child
5016	432	4	2024-08-11 08:30:00	Completed	Chronic care
5017	428	8	2021-09-15 15:00:00	Completed	Telehealth
5018	108	3	2024-08-01 08:45:00	Completed	Annual physical
5019	20	8	2023-07-19 16:00:00	Completed	Annual physical
5020	106	8	2019-11-04 09:00:00	Completed	Well child
5021	456	1	2019-08-16 13:30:00	Completed	Annual physical
5022	144	3	2025-04-19 08:45:00	Completed	Well child
5023	38	12	2020-10-10 09:15:00	Completed	Chronic care
5024	329	11	2021-03-14 16:15:00	Completed	Telehealth
5025	42	6	2022-03-03 13:30:00	Completed	Sick visit
5026	310	9	2026-02-23 11:30:00	Cancelled	Sick visit
5027	537	5	2025-07-16 15:45:00	Completed	Annual physical
5028	27	4	2025-01-21 15:15:00	Completed	Follow-up
5029	177	12	2022-04-23 16:30:00	Completed	Follow-up
5030	565	11	2024-02-22 13:00:00	Cancelled	Follow-up
5031	328	7	2025-07-05 15:15:00	Completed	Well child
5032	358	11	2020-01-05 08:00:00	Completed	Follow-up
5033	293	5	2019-07-22 08:15:00	Completed	Follow-up
5034	333	2	2021-07-08 11:00:00	Completed	Telehealth
5035	309	9	2022-12-21 13:30:00	Completed	Annual physical
5036	201	7	2024-07-02 15:15:00	Completed	Chronic care
5037	54	10	2024-11-05 16:15:00	Completed	Telehealth
5038	208	7	2025-04-12 09:00:00	Completed	Chronic care
5039	171	12	2024-02-04 15:45:00	Completed	Follow-up
5040	185	8	2026-03-08 11:15:00	Completed	Telehealth
5041	439	6	2023-03-22 12:15:00	Completed	Telehealth
5042	315	5	2025-03-06 11:00:00	Completed	Well child
5043	458	8	2020-11-15 13:00:00	Completed	Chronic care
5044	302	9	2022-01-27 15:00:00	Completed	Sick visit
5045	15	9	2021-02-04 13:00:00	Scheduled	Follow-up
5046	434	3	2025-03-16 17:00:00	Completed	Follow-up
5047	496	3	2019-06-11 09:15:00	Scheduled	Telehealth
5048	161	11	2025-05-26 15:45:00	Completed	Chronic care
5049	363	5	2021-01-23 11:00:00	Completed	Sick visit
5050	587	7	2026-02-04 08:15:00	Completed	Annual physical
5051	229	3	2020-02-27 11:15:00	Completed	Telehealth
5052	500	4	2019-07-10 08:45:00	Completed	Sick visit
5053	56	2	2019-03-22 14:00:00	Completed	Follow-up
5054	156	10	2025-06-08 08:45:00	Completed	Telehealth
5055	367	3	2020-08-25 13:00:00	Completed	Telehealth
5056	98	5	2023-10-02 15:45:00	Cancelled	Well child
5057	130	9	2019-11-13 08:15:00	Completed	Telehealth
5058	59	5	2025-01-15 14:45:00	Completed	Telehealth
5059	309	9	2020-03-01 16:15:00	Completed	Annual physical
5060	135	8	2025-12-15 15:15:00	Completed	Chronic care
5061	297	6	2021-02-14 12:45:00	Completed	Telehealth
5062	145	4	2023-06-12 10:45:00	Completed	Follow-up
5063	132	10	2021-12-28 12:15:00	Completed	Annual physical
5064	110	5	2023-06-24 08:45:00	Completed	Chronic care
5065	150	8	2019-06-25 10:45:00	Scheduled	Telehealth
5066	60	9	2021-10-02 08:00:00	Completed	Telehealth
5067	538	3	2024-10-13 13:00:00	Completed	Telehealth
5068	118	1	2025-06-19 13:30:00	Completed	Telehealth
5069	266	7	2020-07-21 13:15:00	Completed	Telehealth
5070	532	1	2019-09-11 15:45:00	Completed	Sick visit
5071	517	4	2024-09-20 09:15:00	Completed	Annual physical
5072	18	4	2020-11-21 15:00:00	Completed	Annual physical
5073	371	6	2022-12-09 08:45:00	Completed	Well child
5074	63	12	2026-01-06 12:00:00	Completed	Follow-up
5075	331	1	2020-10-20 13:30:00	Scheduled	Well child
5076	508	3	2024-09-17 15:15:00	Scheduled	Annual physical
5077	577	8	2021-04-11 09:15:00	Completed	Telehealth
5078	558	9	2025-05-08 13:30:00	Cancelled	Chronic care
5079	258	8	2019-12-09 11:45:00	Completed	Well child
5080	174	1	2021-11-26 12:15:00	Completed	Well child
5081	597	8	2024-06-23 14:45:00	Completed	Well child
5082	227	8	2023-11-13 16:30:00	Completed	Follow-up
5083	131	10	2024-07-01 12:30:00	Completed	Annual physical
5084	143	10	2022-02-21 08:45:00	Completed	Sick visit
5085	531	6	2026-02-08 13:30:00	Scheduled	Well child
5086	131	10	2020-03-19 09:45:00	Completed	Sick visit
5087	8	1	2024-09-14 08:45:00	Completed	Annual physical
5088	168	2	2025-02-08 13:45:00	Completed	Sick visit
5089	159	1	2025-04-27 16:30:00	Completed	Annual physical
5090	134	5	2021-09-17 12:30:00	Cancelled	Follow-up
5091	546	7	2020-08-21 10:15:00	Completed	Well child
5092	249	9	2019-10-05 10:15:00	Completed	Sick visit
5093	408	10	2019-08-17 11:15:00	Completed	Telehealth
5094	97	8	2025-02-02 16:45:00	Cancelled	Annual physical
5095	460	6	2021-07-31 10:45:00	Completed	Telehealth
5096	468	7	2020-09-13 12:00:00	Cancelled	Sick visit
5097	469	12	2019-11-28 10:45:00	Completed	Well child
5098	187	12	2022-01-02 14:45:00	Completed	Well child
5099	180	2	2020-03-24 12:15:00	Completed	Annual physical
5100	170	9	2025-10-11 08:15:00	Completed	Telehealth
5101	481	11	2022-03-30 14:30:00	Completed	Well child
5102	265	1	2022-07-18 13:15:00	Completed	Telehealth
5103	386	2	2025-05-21 09:15:00	Cancelled	Follow-up
5104	124	8	2026-01-12 16:15:00	Completed	Well child
5105	214	9	2022-06-14 08:00:00	Completed	Sick visit
5106	119	4	2023-06-08 11:00:00	Completed	Chronic care
5107	43	6	2020-02-29 12:15:00	Completed	Sick visit
5108	141	12	2022-02-16 11:15:00	Completed	Annual physical
5109	408	10	2021-04-11 08:00:00	No-show	Chronic care
5110	558	11	2025-05-20 08:00:00	Completed	Chronic care
5111	144	9	2021-02-14 16:15:00	Completed	Annual physical
5112	72	12	2019-01-20 15:45:00	Completed	Chronic care
5113	151	10	2020-10-24 08:00:00	Completed	Sick visit
5114	336	8	2019-11-12 14:00:00	Completed	Telehealth
5115	541	11	2023-11-06 08:15:00	Completed	Chronic care
5116	436	3	2020-08-24 17:00:00	Completed	Well child
5117	162	9	2025-04-16 11:45:00	Completed	Well child
5118	412	7	2025-04-30 17:00:00	Completed	Telehealth
5119	226	4	2023-03-26 12:30:00	Scheduled	Chronic care
5120	473	5	2023-10-28 16:00:00	No-show	Annual physical
5121	438	3	2020-01-27 10:00:00	Completed	Chronic care
5122	478	6	2020-07-12 14:30:00	Completed	Annual physical
5123	421	6	2023-04-01 16:00:00	Completed	Sick visit
5124	336	8	2025-08-21 12:15:00	Scheduled	Well child
5125	252	9	2022-06-14 11:30:00	Completed	Annual physical
5126	129	11	2019-08-08 11:00:00	Completed	Follow-up
5127	6	3	2021-10-26 13:00:00	Completed	Follow-up
5128	63	2	2024-02-04 15:15:00	Completed	Annual physical
5129	544	4	2023-03-07 16:15:00	Completed	Sick visit
5130	352	9	2019-07-30 11:00:00	Completed	Sick visit
5131	192	6	2024-04-29 12:15:00	Completed	Follow-up
5132	436	3	2021-01-04 10:45:00	Completed	Follow-up
5133	176	1	2020-01-04 10:45:00	Scheduled	Well child
5134	283	4	2020-01-14 10:15:00	No-show	Telehealth
5135	60	5	2020-02-22 12:00:00	Completed	Telehealth
5136	351	2	2024-06-14 13:00:00	Completed	Chronic care
5137	224	1	2022-11-15 12:45:00	Completed	Well child
5138	349	10	2020-06-16 16:45:00	Completed	Telehealth
5139	448	5	2024-06-10 16:30:00	Scheduled	Chronic care
5140	207	11	2025-12-24 14:00:00	Completed	Sick visit
5141	383	4	2025-06-02 09:30:00	Cancelled	Follow-up
5142	526	9	2020-08-25 14:15:00	Completed	Well child
5143	15	5	2022-02-16 09:15:00	Completed	Sick visit
5144	127	11	2020-05-07 10:00:00	Completed	Sick visit
5145	439	6	2023-11-30 15:30:00	Cancelled	Sick visit
5146	159	1	2020-11-05 10:30:00	Scheduled	Follow-up
5147	5	4	2021-08-05 14:30:00	Completed	Follow-up
5148	507	9	2019-08-30 16:30:00	Completed	Well child
5149	412	8	2023-08-03 14:00:00	Cancelled	Sick visit
5150	573	9	2019-11-07 11:45:00	Completed	Chronic care
5151	92	9	2026-02-05 16:00:00	Completed	Chronic care
5152	139	12	2022-05-16 14:30:00	Completed	Sick visit
5153	461	11	2019-02-07 08:30:00	Completed	Chronic care
5154	62	9	2024-08-11 13:45:00	Completed	Telehealth
5155	361	3	2024-04-30 17:00:00	Completed	Well child
5156	598	8	2019-06-26 12:45:00	Completed	Follow-up
5157	496	3	2022-04-25 16:00:00	Completed	Follow-up
5158	337	3	2020-09-20 12:15:00	Completed	Chronic care
5159	45	4	2020-10-02 10:00:00	Cancelled	Annual physical
5160	192	5	2025-01-17 11:45:00	Completed	Annual physical
5161	140	8	2020-03-03 15:30:00	Completed	Well child
5162	80	10	2024-11-06 14:00:00	Completed	Annual physical
5163	326	2	2020-06-21 14:00:00	Cancelled	Telehealth
5164	119	6	2021-02-26 12:30:00	Completed	Well child
5165	136	9	2022-02-05 09:00:00	Completed	Annual physical
5166	146	10	2025-10-08 15:45:00	Completed	Follow-up
5167	231	11	2019-11-16 09:15:00	Completed	Sick visit
5168	447	8	2023-07-09 11:00:00	Cancelled	Chronic care
5169	22	10	2023-10-16 15:00:00	Completed	Sick visit
5170	438	8	2026-04-08 12:45:00	Completed	Sick visit
5171	218	5	2021-02-22 11:15:00	Cancelled	Sick visit
5172	258	10	2024-07-15 08:30:00	No-show	Sick visit
5173	518	4	2019-09-17 09:30:00	Completed	Chronic care
5174	481	7	2024-06-04 12:15:00	Scheduled	Sick visit
5175	517	4	2023-03-08 12:00:00	Cancelled	Annual physical
5176	600	6	2019-04-05 16:45:00	Completed	Sick visit
5177	123	1	2024-06-12 14:30:00	Cancelled	Annual physical
5178	115	7	2020-04-16 11:45:00	Completed	Chronic care
5179	70	1	2021-09-12 11:30:00	Completed	Sick visit
5180	496	3	2022-01-14 13:00:00	Completed	Annual physical
5181	103	8	2024-01-15 08:45:00	Completed	Annual physical
5182	316	9	2020-11-08 13:45:00	Scheduled	Annual physical
5183	277	4	2024-03-07 11:30:00	Completed	Chronic care
5184	518	11	2020-06-17 12:30:00	Completed	Telehealth
5185	331	1	2024-11-30 09:45:00	Cancelled	Chronic care
5186	158	8	2025-08-31 11:00:00	Completed	Annual physical
5187	479	7	2022-05-14 12:45:00	Completed	Follow-up
5188	269	6	2019-08-08 16:45:00	Cancelled	Well child
5189	569	8	2023-03-13 14:45:00	Completed	Follow-up
5190	551	4	2019-07-21 12:30:00	Completed	Follow-up
5191	65	11	2023-10-04 16:15:00	Completed	Well child
5192	417	4	2024-11-12 09:00:00	Completed	Chronic care
5193	13	2	2019-05-23 17:00:00	Completed	Chronic care
5194	336	8	2022-07-25 15:15:00	Completed	Telehealth
5195	294	11	2024-03-01 12:45:00	Completed	Annual physical
5196	88	7	2022-10-28 15:00:00	Completed	Well child
5197	137	7	2020-05-01 14:15:00	Completed	Well child
5198	447	8	2023-06-10 13:30:00	Completed	Telehealth
5199	399	2	2025-04-13 15:45:00	Completed	Telehealth
5200	45	4	2024-12-28 13:45:00	No-show	Telehealth
5201	116	7	2022-05-20 10:15:00	Completed	Telehealth
5202	271	2	2021-12-08 10:15:00	No-show	Annual physical
5203	60	5	2020-02-10 13:45:00	Completed	Chronic care
5204	478	6	2025-03-20 14:45:00	No-show	Well child
5205	428	8	2024-07-24 12:45:00	Completed	Well child
5206	512	2	2023-10-14 08:00:00	Completed	Sick visit
5207	492	7	2023-11-02 09:15:00	Completed	Chronic care
5208	386	2	2023-01-31 16:30:00	Completed	Well child
5209	353	6	2024-04-05 16:30:00	Completed	Chronic care
5210	189	11	2025-05-23 09:30:00	Completed	Chronic care
5211	565	7	2023-10-08 16:15:00	Completed	Annual physical
5212	365	7	2022-01-30 09:00:00	Cancelled	Telehealth
5213	168	2	2022-08-24 08:15:00	Completed	Well child
5214	534	7	2025-12-13 17:00:00	No-show	Annual physical
5215	48	10	2023-03-05 08:30:00	Completed	Follow-up
5216	477	12	2024-07-16 12:45:00	Cancelled	Annual physical
5217	324	1	2021-02-23 16:15:00	Scheduled	Telehealth
5218	218	8	2023-08-01 14:00:00	Completed	Well child
5219	482	4	2026-03-25 09:00:00	Completed	Annual physical
5220	470	12	2024-02-25 14:15:00	Completed	Follow-up
5221	189	11	2019-02-12 13:00:00	Completed	Follow-up
5222	306	6	2020-05-03 08:00:00	Completed	Annual physical
5223	420	12	2023-08-12 11:00:00	Scheduled	Chronic care
5224	447	8	2020-06-01 14:45:00	Completed	Telehealth
5225	295	8	2025-10-28 12:45:00	Completed	Sick visit
5226	62	2	2026-04-03 11:30:00	Completed	Well child
5227	423	4	2020-07-24 10:45:00	Completed	Telehealth
5228	475	7	2024-10-12 09:30:00	Completed	Sick visit
5229	278	3	2022-07-22 13:00:00	Completed	Sick visit
5230	168	2	2026-04-22 11:00:00	No-show	Telehealth
5231	78	7	2022-09-07 14:45:00	Completed	Follow-up
5232	308	9	2026-02-20 14:30:00	Completed	Telehealth
5233	337	4	2022-02-14 11:15:00	Completed	Telehealth
5234	511	2	2025-01-04 14:30:00	Completed	Follow-up
5235	130	9	2019-03-10 08:00:00	Completed	Sick visit
5236	260	2	2024-10-23 11:30:00	Completed	Telehealth
5237	77	6	2021-09-04 13:45:00	Completed	Well child
5238	185	8	2025-10-19 09:00:00	Completed	Follow-up
5239	75	7	2025-03-13 16:45:00	Cancelled	Telehealth
5240	370	9	2024-01-04 10:00:00	Completed	Chronic care
5241	160	7	2024-01-25 17:00:00	Completed	Follow-up
5242	498	3	2022-02-20 09:30:00	Completed	Sick visit
5243	503	5	2023-03-15 11:30:00	No-show	Telehealth
5244	421	5	2025-08-08 11:00:00	No-show	Well child
5245	133	3	2022-12-10 08:45:00	Completed	Chronic care
5246	519	6	2026-03-09 15:15:00	Completed	Follow-up
5247	248	5	2025-10-16 08:00:00	Completed	Sick visit
5248	227	3	2025-07-09 08:15:00	Completed	Sick visit
5249	323	5	2021-03-06 13:45:00	Completed	Annual physical
5250	376	5	2026-03-11 12:45:00	Completed	Chronic care
5251	47	12	2025-06-05 09:00:00	Scheduled	Follow-up
5252	208	1	2021-01-02 11:00:00	Completed	Sick visit
5253	209	6	2020-01-02 13:00:00	Completed	Annual physical
5254	248	1	2025-09-15 13:00:00	Completed	Well child
5255	554	6	2023-07-20 17:00:00	Completed	Sick visit
5256	425	2	2022-05-05 13:45:00	Completed	Annual physical
5257	152	7	2024-09-12 15:15:00	Completed	Chronic care
5258	274	1	2024-06-09 14:15:00	No-show	Follow-up
5259	221	11	2021-03-08 15:30:00	No-show	Well child
5260	401	6	2023-02-09 10:00:00	No-show	Sick visit
5261	158	8	2020-07-25 09:30:00	Completed	Sick visit
5262	444	6	2021-12-22 16:45:00	Cancelled	Annual physical
5263	571	7	2025-10-31 17:00:00	Completed	Well child
5264	203	11	2023-06-14 14:00:00	Completed	Annual physical
5265	296	4	2023-06-26 12:45:00	Cancelled	Sick visit
5266	582	12	2022-11-23 12:30:00	No-show	Telehealth
5267	579	7	2025-04-01 16:30:00	Cancelled	Follow-up
5268	104	10	2023-10-01 08:15:00	Cancelled	Annual physical
5269	588	4	2019-01-27 10:30:00	Completed	Well child
5270	442	3	2020-11-12 14:30:00	Completed	Well child
5271	283	4	2020-08-25 12:45:00	Completed	Chronic care
5272	284	5	2021-10-15 15:00:00	Completed	Annual physical
5273	75	7	2021-11-04 15:30:00	Cancelled	Telehealth
5274	528	7	2020-04-03 16:30:00	Completed	Annual physical
5275	451	4	2026-05-19 15:15:00	Scheduled	Annual physical
5276	583	11	2020-09-12 14:15:00	Completed	Annual physical
5277	468	7	2023-05-02 13:15:00	Completed	Sick visit
5278	579	12	2024-02-25 13:45:00	Completed	Annual physical
5279	199	6	2019-02-12 09:15:00	Completed	Well child
5280	35	12	2020-06-15 11:45:00	Completed	Sick visit
5281	24	5	2020-11-24 15:15:00	Completed	Telehealth
5282	35	12	2020-04-09 12:15:00	Completed	Telehealth
5283	242	9	2020-01-21 12:45:00	Scheduled	Telehealth
5284	488	5	2022-08-25 14:15:00	No-show	Annual physical
5285	454	3	2019-07-10 09:45:00	Completed	Chronic care
5286	321	5	2020-06-11 10:45:00	Cancelled	Annual physical
5287	230	5	2023-04-20 09:00:00	Completed	Annual physical
5288	415	12	2025-10-14 17:00:00	Completed	Chronic care
5289	543	4	2025-06-13 12:30:00	Completed	Telehealth
5290	71	9	2022-12-10 10:30:00	Completed	Chronic care
5291	563	4	2022-04-20 11:00:00	Completed	Well child
5292	112	3	2024-02-08 09:30:00	Completed	Sick visit
5293	202	4	2021-11-10 13:00:00	Completed	Telehealth
5294	423	4	2020-09-12 10:00:00	Completed	Well child
5295	111	1	2023-06-24 10:45:00	Completed	Telehealth
5296	311	11	2019-10-22 16:00:00	No-show	Annual physical
5297	301	6	2021-08-18 08:15:00	Completed	Annual physical
5298	265	5	2022-12-20 12:45:00	Completed	Telehealth
5299	357	11	2025-09-26 11:45:00	Completed	Follow-up
5300	272	8	2019-12-29 12:45:00	Scheduled	Well child
5301	530	7	2026-01-31 13:15:00	Cancelled	Sick visit
5302	30	1	2024-01-26 17:00:00	Completed	Annual physical
5303	311	11	2023-12-24 09:30:00	No-show	Annual physical
5304	43	6	2024-12-31 08:45:00	Completed	Well child
5305	522	5	2024-11-29 15:00:00	Completed	Well child
5306	355	11	2024-02-27 12:00:00	Completed	Telehealth
5307	571	7	2023-08-08 15:15:00	Completed	Chronic care
5308	367	3	2020-08-27 16:30:00	Cancelled	Well child
5309	456	1	2019-04-21 12:15:00	Scheduled	Telehealth
5310	29	4	2025-03-05 13:15:00	Completed	Follow-up
5311	62	2	2021-05-07 11:45:00	Completed	Well child
5312	206	7	2021-05-29 12:30:00	Scheduled	Telehealth
5313	200	5	2022-06-04 11:45:00	Completed	Follow-up
5314	329	11	2024-12-29 08:45:00	Completed	Well child
5315	373	1	2025-05-04 08:00:00	Completed	Chronic care
5316	503	5	2024-10-20 08:00:00	Completed	Well child
5317	302	9	2023-01-22 11:30:00	Completed	Follow-up
5318	197	9	2019-01-21 14:15:00	No-show	Sick visit
5319	177	12	2023-07-04 09:30:00	Completed	Annual physical
5320	63	12	2025-04-10 11:30:00	Scheduled	Sick visit
5321	189	4	2019-12-04 14:30:00	Completed	Telehealth
5322	312	1	2025-11-05 14:15:00	Completed	Follow-up
5323	24	6	2023-05-07 13:15:00	Completed	Telehealth
5324	420	12	2023-07-05 09:45:00	Completed	Telehealth
5325	474	5	2020-05-02 08:15:00	Scheduled	Sick visit
5326	208	5	2020-01-29 11:15:00	Completed	Chronic care
5327	271	2	2025-04-30 12:00:00	Completed	Sick visit
5328	22	10	2025-11-20 16:45:00	Completed	Sick visit
5329	536	3	2022-09-25 13:30:00	Completed	Chronic care
5330	555	6	2024-06-01 14:30:00	Completed	Chronic care
5331	101	11	2023-07-12 15:00:00	Completed	Telehealth
5332	536	3	2024-01-17 09:15:00	Completed	Sick visit
5333	214	1	2021-06-09 14:30:00	Completed	Well child
5334	565	11	2024-07-26 12:00:00	Scheduled	Well child
5335	329	11	2026-02-20 09:30:00	Completed	Sick visit
5336	417	4	2026-02-12 09:00:00	Scheduled	Chronic care
5337	519	6	2026-03-05 11:30:00	Cancelled	Annual physical
5338	520	8	2023-04-12 16:30:00	Completed	Sick visit
5339	150	8	2025-10-23 15:30:00	Completed	Annual physical
5340	192	6	2020-02-25 12:30:00	Completed	Sick visit
5341	128	12	2026-03-31 16:15:00	Completed	Well child
5342	61	3	2023-09-01 16:00:00	Completed	Annual physical
5343	307	8	2021-12-13 10:15:00	Completed	Well child
5344	418	5	2020-12-25 12:15:00	Completed	Annual physical
5345	108	12	2023-11-25 15:15:00	Completed	Sick visit
5346	127	11	2021-12-23 14:00:00	Scheduled	Chronic care
5347	444	6	2019-05-19 10:45:00	Completed	Well child
5348	521	11	2026-05-14 10:15:00	Cancelled	Well child
5349	129	11	2023-08-31 15:15:00	Scheduled	Annual physical
5350	445	9	2024-01-02 11:00:00	Completed	Well child
5351	527	8	2020-05-20 11:45:00	Completed	Follow-up
5352	561	1	2025-10-10 12:30:00	Completed	Well child
5353	288	9	2020-03-05 09:45:00	Completed	Sick visit
5354	512	2	2021-07-22 14:30:00	Completed	Sick visit
5355	64	11	2024-07-19 08:00:00	Completed	Telehealth
5356	317	6	2022-12-25 12:00:00	Completed	Follow-up
5357	492	7	2019-09-26 14:45:00	Cancelled	Follow-up
5358	583	11	2021-11-24 15:45:00	Completed	Chronic care
5359	323	9	2023-12-25 15:15:00	Completed	Telehealth
5360	144	9	2019-08-09 16:15:00	Completed	Annual physical
5361	5	4	2020-03-17 16:15:00	Completed	Follow-up
5362	583	11	2023-11-22 17:00:00	Completed	Chronic care
5363	63	9	2021-09-23 16:45:00	Completed	Well child
5364	505	3	2021-10-14 08:30:00	Completed	Chronic care
5365	359	12	2024-02-18 08:00:00	Completed	Chronic care
5366	152	7	2026-01-06 08:30:00	Completed	Telehealth
5367	157	11	2021-08-03 13:15:00	Completed	Follow-up
5368	47	12	2019-07-05 09:45:00	Completed	Sick visit
5369	211	7	2022-11-29 09:30:00	Completed	Follow-up
5370	427	9	2021-03-06 16:00:00	Completed	Well child
5371	71	4	2024-02-22 16:30:00	Completed	Well child
5372	565	11	2024-02-14 14:45:00	Completed	Sick visit
5373	589	12	2025-01-16 13:15:00	Completed	Well child
5374	467	4	2021-02-04 11:30:00	No-show	Annual physical
5375	576	3	2024-10-18 13:00:00	Completed	Annual physical
5376	58	11	2024-08-26 15:45:00	Completed	Follow-up
5377	303	7	2021-05-29 17:00:00	Completed	Follow-up
5378	4	2	2019-10-12 13:15:00	Completed	Chronic care
5379	283	4	2019-06-29 16:30:00	Completed	Chronic care
5380	470	6	2024-04-12 08:15:00	Completed	Well child
5381	521	11	2024-08-21 15:45:00	Completed	Sick visit
5382	539	10	2022-07-28 14:15:00	Cancelled	Annual physical
5383	205	10	2021-10-29 11:45:00	Completed	Telehealth
5384	280	1	2021-01-20 12:30:00	Completed	Follow-up
5385	129	7	2024-01-27 16:45:00	Cancelled	Follow-up
5386	201	10	2021-06-19 15:45:00	Completed	Sick visit
5387	331	1	2023-06-19 16:15:00	Completed	Telehealth
5388	453	1	2020-08-05 15:15:00	Completed	Sick visit
5389	594	8	2020-09-05 13:30:00	No-show	Annual physical
5390	101	11	2020-10-17 10:30:00	Completed	Sick visit
5391	421	6	2020-03-24 14:00:00	Completed	Chronic care
5392	32	6	2024-07-17 11:30:00	Completed	Telehealth
5393	535	5	2024-12-25 10:45:00	Completed	Annual physical
5394	442	3	2019-09-24 14:30:00	Completed	Sick visit
5395	188	5	2019-08-28 14:45:00	Completed	Chronic care
5396	162	10	2025-02-27 15:00:00	Completed	Annual physical
5397	527	8	2025-10-31 11:15:00	Completed	Well child
5398	201	7	2021-11-23 15:45:00	Completed	Chronic care
5399	278	3	2021-08-17 17:00:00	Completed	Telehealth
5400	225	9	2019-05-30 15:45:00	Completed	Follow-up
5401	398	1	2020-10-14 08:30:00	Cancelled	Telehealth
5402	113	11	2025-10-02 08:45:00	Completed	Chronic care
5403	218	5	2024-10-07 10:00:00	Completed	Telehealth
5404	21	12	2020-05-04 17:00:00	Completed	Annual physical
5405	47	12	2022-08-04 14:45:00	Cancelled	Annual physical
5406	114	7	2022-04-11 12:00:00	Completed	Annual physical
5407	508	3	2020-05-17 12:00:00	Completed	Follow-up
5408	241	11	2026-02-05 16:15:00	Completed	Telehealth
5409	431	5	2021-01-20 10:15:00	Completed	Chronic care
5410	509	2	2023-02-16 12:15:00	Completed	Well child
5411	493	1	2023-05-12 12:00:00	Completed	Follow-up
5412	225	9	2023-11-25 09:00:00	Completed	Well child
5413	145	4	2023-07-05 17:00:00	Completed	Telehealth
5414	312	1	2019-05-11 10:45:00	Completed	Telehealth
5415	415	12	2019-08-25 15:00:00	Scheduled	Follow-up
5416	443	7	2019-11-12 08:30:00	Completed	Telehealth
5417	538	4	2022-04-22 08:15:00	Cancelled	Annual physical
5418	365	8	2020-08-24 13:45:00	Scheduled	Annual physical
5419	234	2	2023-05-25 16:15:00	Completed	Chronic care
5420	380	3	2023-01-02 14:15:00	Completed	Annual physical
5421	566	11	2024-09-24 16:30:00	Completed	Telehealth
5422	444	6	2022-07-02 13:00:00	Completed	Annual physical
5423	491	5	2024-11-24 13:15:00	Completed	Follow-up
5424	31	11	2022-09-27 09:30:00	Completed	Well child
5425	326	2	2020-08-19 09:45:00	Completed	Telehealth
5426	364	4	2023-07-01 14:30:00	Completed	Well child
5427	77	12	2020-03-09 17:00:00	Completed	Sick visit
5428	111	1	2020-03-14 15:45:00	Completed	Well child
5429	3	12	2024-08-16 08:00:00	Completed	Sick visit
5430	41	3	2020-08-31 17:00:00	Completed	Annual physical
5431	193	9	2023-05-30 09:00:00	Completed	Annual physical
5432	202	4	2022-10-05 15:00:00	Completed	Sick visit
5433	377	8	2021-03-15 16:45:00	No-show	Follow-up
5434	365	7	2019-09-07 13:45:00	Completed	Chronic care
5435	336	8	2020-01-17 12:30:00	Completed	Annual physical
5436	506	8	2020-07-02 12:15:00	Completed	Annual physical
5437	377	8	2019-05-27 15:45:00	Completed	Sick visit
5438	42	6	2021-08-29 13:00:00	Completed	Sick visit
5439	509	2	2024-12-14 11:45:00	Completed	Chronic care
5440	272	11	2019-01-20 13:15:00	Completed	Telehealth
5441	573	9	2019-03-28 17:00:00	Completed	Well child
5442	6	3	2023-12-17 10:30:00	Completed	Sick visit
5443	73	6	2026-02-09 16:00:00	Completed	Chronic care
5444	320	11	2023-03-26 13:30:00	Completed	Follow-up
5445	320	11	2021-08-22 12:15:00	Completed	Sick visit
5446	266	2	2020-02-27 11:30:00	Completed	Sick visit
5447	523	7	2023-01-11 09:45:00	Completed	Sick visit
5448	316	9	2024-07-08 11:15:00	Completed	Sick visit
5449	64	11	2026-02-17 14:30:00	Completed	Annual physical
5450	144	11	2019-09-09 09:15:00	Completed	Sick visit
5451	227	3	2022-09-12 11:15:00	No-show	Sick visit
5452	22	10	2021-01-08 11:30:00	Cancelled	Follow-up
5453	488	5	2022-07-28 14:30:00	Completed	Well child
5454	195	8	2019-08-16 11:30:00	Completed	Follow-up
5455	205	10	2021-03-02 08:00:00	Completed	Chronic care
5456	538	3	2026-05-09 09:15:00	No-show	Annual physical
5457	152	9	2025-07-31 10:30:00	Completed	Sick visit
5458	282	5	2026-04-20 09:00:00	No-show	Chronic care
5459	302	5	2021-06-15 10:15:00	Completed	Well child
5460	100	2	2022-01-30 16:45:00	Completed	Follow-up
5461	5	4	2026-03-04 14:45:00	Completed	Sick visit
5462	530	5	2022-01-16 13:30:00	Completed	Telehealth
5463	371	6	2021-03-12 15:15:00	Completed	Sick visit
5464	241	11	2021-04-04 12:15:00	Completed	Telehealth
5465	135	8	2024-08-03 13:15:00	Cancelled	Sick visit
5466	349	10	2025-01-19 14:45:00	Completed	Annual physical
5467	132	10	2024-05-03 09:30:00	Completed	Sick visit
5468	249	9	2023-08-20 16:15:00	Cancelled	Sick visit
5469	433	7	2019-11-10 12:45:00	No-show	Sick visit
5470	302	9	2026-05-16 14:15:00	Completed	Annual physical
5471	464	4	2023-11-14 11:45:00	Completed	Telehealth
5472	187	11	2023-07-31 14:30:00	Completed	Sick visit
5473	481	11	2024-07-21 08:45:00	Completed	Telehealth
5474	555	6	2019-11-05 09:30:00	Completed	Telehealth
5475	30	1	2021-07-18 13:30:00	Scheduled	Telehealth
5476	542	12	2025-08-17 08:45:00	Completed	Follow-up
5477	71	4	2022-02-16 13:00:00	Completed	Sick visit
5478	269	9	2021-09-23 08:00:00	Completed	Annual physical
5479	84	7	2024-08-15 09:45:00	Completed	Telehealth
5480	59	10	2022-06-26 15:45:00	Completed	Sick visit
5481	55	9	2025-03-09 15:15:00	Completed	Well child
5482	514	3	2019-09-22 11:00:00	Completed	Sick visit
5483	8	1	2022-05-24 09:45:00	Completed	Chronic care
5484	402	6	2022-10-24 12:15:00	Completed	Well child
5485	523	7	2020-07-28 09:15:00	Completed	Well child
5486	98	5	2023-11-16 12:00:00	Completed	Follow-up
5487	21	12	2023-01-07 14:45:00	Completed	Well child
5488	119	11	2022-02-10 13:30:00	Completed	Annual physical
5489	555	12	2020-11-03 10:45:00	Completed	Sick visit
5490	281	3	2024-01-10 08:30:00	Completed	Annual physical
5491	563	4	2025-02-14 15:45:00	Completed	Sick visit
5492	456	7	2023-10-15 15:45:00	No-show	Chronic care
5493	451	4	2024-11-26 14:00:00	Completed	Telehealth
5494	224	1	2026-01-13 12:00:00	Completed	Telehealth
5495	38	12	2023-10-25 13:15:00	Cancelled	Chronic care
5496	457	10	2019-08-28 11:15:00	Scheduled	Sick visit
5497	208	7	2021-05-07 11:00:00	Completed	Annual physical
5498	372	9	2025-11-22 11:45:00	Completed	Annual physical
5499	84	7	2026-04-06 08:30:00	Completed	Follow-up
5500	176	1	2020-08-08 09:45:00	Completed	Well child
5501	401	11	2023-09-18 13:45:00	Completed	Sick visit
5502	486	2	2025-01-08 16:15:00	Completed	Follow-up
5503	329	11	2024-10-10 09:00:00	Completed	Telehealth
5504	84	7	2019-08-31 12:00:00	Completed	Sick visit
5505	352	9	2021-12-13 14:15:00	Scheduled	Annual physical
5506	421	12	2022-12-20 10:30:00	Scheduled	Telehealth
5507	106	8	2020-08-14 13:00:00	Completed	Annual physical
5508	43	10	2023-08-16 10:00:00	Completed	Annual physical
5509	117	4	2024-02-27 08:45:00	Completed	Well child
5510	312	1	2023-12-06 08:00:00	Cancelled	Annual physical
5511	519	6	2025-10-24 10:00:00	Completed	Chronic care
5512	418	5	2024-05-27 08:00:00	Completed	Annual physical
5513	158	8	2023-09-29 13:30:00	Completed	Annual physical
5514	4	5	2019-08-19 09:00:00	Scheduled	Chronic care
5515	206	11	2020-10-18 14:45:00	Cancelled	Well child
5516	341	6	2020-03-14 14:00:00	Completed	Chronic care
5517	308	9	2023-06-19 15:30:00	Cancelled	Follow-up
5518	153	8	2022-11-26 12:15:00	Completed	Telehealth
5519	309	9	2026-01-01 14:15:00	Completed	Annual physical
5520	280	1	2020-09-21 12:00:00	Scheduled	Well child
5521	466	3	2026-01-21 11:45:00	Completed	Annual physical
5522	372	9	2024-05-01 08:45:00	Cancelled	Follow-up
5523	318	11	2026-02-28 14:00:00	Completed	Follow-up
5524	154	8	2019-08-11 09:00:00	Completed	Telehealth
5525	309	9	2022-02-11 12:15:00	Completed	Telehealth
5526	6	3	2023-02-16 15:15:00	Completed	Sick visit
5527	342	1	2025-11-06 09:30:00	Completed	Well child
5528	206	11	2024-06-11 12:30:00	Completed	Chronic care
5529	482	4	2022-04-06 16:15:00	Completed	Telehealth
5530	236	6	2023-05-23 09:30:00	Completed	Follow-up
5531	344	10	2023-01-20 14:30:00	Completed	Sick visit
5532	487	9	2021-11-07 16:30:00	Completed	Chronic care
5533	503	12	2024-08-06 08:30:00	Completed	Chronic care
5534	201	7	2019-09-20 10:45:00	Completed	Follow-up
5535	419	12	2025-02-15 10:15:00	Completed	Well child
5536	130	9	2023-12-25 15:00:00	Completed	Telehealth
5537	357	11	2020-12-14 15:15:00	Completed	Sick visit
5538	413	8	2024-12-18 09:15:00	Cancelled	Annual physical
5539	438	12	2024-04-27 17:00:00	No-show	Annual physical
5540	453	1	2025-12-18 16:45:00	Completed	Chronic care
5541	568	4	2021-11-21 16:30:00	Completed	Annual physical
5542	440	5	2023-02-10 13:30:00	Completed	Chronic care
5543	106	8	2020-12-23 12:15:00	Completed	Sick visit
5544	171	6	2022-04-19 16:15:00	Completed	Sick visit
5545	520	6	2020-09-21 16:00:00	Completed	Sick visit
5546	558	11	2019-06-05 16:45:00	Completed	Annual physical
5547	156	10	2024-12-05 10:45:00	Completed	Well child
5548	39	4	2019-05-09 09:15:00	Completed	Follow-up
5549	549	3	2023-06-01 14:15:00	Scheduled	Sick visit
5550	143	10	2019-03-09 16:00:00	No-show	Telehealth
5551	366	12	2026-01-02 14:00:00	Completed	Follow-up
5552	532	1	2025-01-15 15:45:00	Completed	Chronic care
5553	184	2	2021-10-28 16:30:00	Completed	Well child
5554	488	5	2020-11-04 09:45:00	Cancelled	Telehealth
5555	536	3	2021-07-07 15:15:00	Cancelled	Well child
5556	329	11	2026-03-16 16:15:00	Completed	Chronic care
5557	520	6	2025-06-10 09:00:00	Completed	Follow-up
5558	52	11	2022-08-03 11:45:00	Completed	Follow-up
5559	200	8	2026-05-15 09:15:00	Scheduled	Annual physical
5560	588	4	2021-09-02 16:15:00	Scheduled	Chronic care
5561	408	10	2025-11-27 09:30:00	Scheduled	Sick visit
5562	317	3	2023-03-27 08:45:00	Completed	Follow-up
5563	589	12	2021-10-19 15:30:00	Completed	Chronic care
5564	418	11	2019-06-03 16:00:00	No-show	Annual physical
5565	348	7	2019-09-28 16:15:00	Cancelled	Follow-up
5566	29	4	2019-04-17 11:30:00	Cancelled	Well child
5567	193	3	2024-11-10 09:15:00	Completed	Annual physical
5568	549	3	2019-04-26 12:30:00	Completed	Well child
5569	250	4	2023-10-14 12:45:00	Completed	Chronic care
5570	122	12	2023-03-23 11:00:00	Completed	Well child
5571	312	1	2021-07-12 15:45:00	Completed	Sick visit
5572	71	4	2019-09-18 16:15:00	Completed	Sick visit
5573	484	2	2025-07-06 17:00:00	Cancelled	Annual physical
5574	307	8	2023-01-21 12:30:00	Completed	Sick visit
5575	121	7	2022-02-22 11:45:00	Completed	Annual physical
5576	322	4	2023-11-13 12:15:00	Completed	Sick visit
5577	156	10	2025-09-21 11:15:00	Completed	Well child
5578	559	7	2020-08-07 14:45:00	Scheduled	Telehealth
5579	591	10	2022-09-14 16:00:00	Completed	Annual physical
5580	586	4	2022-08-24 15:45:00	Completed	Telehealth
5581	595	1	2024-01-20 11:30:00	Completed	Follow-up
5582	549	3	2022-04-14 10:45:00	Completed	Annual physical
5583	277	4	2026-01-18 14:15:00	Completed	Annual physical
5584	434	3	2025-12-25 13:45:00	Completed	Annual physical
5585	251	3	2025-05-31 08:15:00	Completed	Chronic care
5586	169	10	2021-11-28 15:30:00	Completed	Chronic care
5587	5	4	2022-01-12 12:30:00	Completed	Annual physical
5588	97	11	2022-07-30 08:45:00	Completed	Follow-up
5589	584	11	2025-11-07 15:15:00	Completed	Annual physical
5590	113	11	2021-09-11 09:00:00	Completed	Annual physical
5591	320	10	2019-08-14 10:00:00	Completed	Chronic care
5592	580	3	2023-03-26 14:45:00	Completed	Well child
5593	57	7	2025-06-06 12:30:00	Cancelled	Annual physical
5594	176	1	2022-06-07 08:30:00	Completed	Telehealth
5595	482	4	2024-01-17 14:15:00	No-show	Sick visit
5596	37	10	2023-10-07 14:15:00	Completed	Well child
5597	303	7	2020-10-07 13:45:00	Completed	Follow-up
5598	139	4	2021-10-08 08:30:00	Completed	Telehealth
5599	168	2	2023-11-24 09:00:00	Scheduled	Sick visit
5600	454	3	2019-10-22 09:15:00	Completed	Follow-up
5601	553	6	2021-08-28 15:15:00	Completed	Annual physical
5602	126	12	2022-11-11 13:30:00	Completed	Well child
5603	393	9	2020-09-15 12:45:00	Completed	Telehealth
5604	582	8	2025-05-19 16:45:00	Completed	Well child
5605	355	6	2019-05-29 15:00:00	Scheduled	Well child
5606	54	10	2025-05-31 15:00:00	No-show	Annual physical
5607	579	12	2023-10-16 12:45:00	Completed	Chronic care
5608	197	10	2025-06-03 14:00:00	Completed	Sick visit
5609	128	4	2021-09-01 12:00:00	Cancelled	Follow-up
5610	156	10	2021-10-22 15:30:00	Completed	Sick visit
5611	57	7	2021-06-01 09:00:00	Cancelled	Sick visit
5612	524	11	2020-04-02 16:15:00	Completed	Annual physical
5613	485	2	2024-02-07 13:00:00	Cancelled	Telehealth
5614	349	10	2024-06-07 09:15:00	Completed	Chronic care
5615	359	12	2020-07-20 13:15:00	Completed	Annual physical
5616	151	3	2025-09-26 12:00:00	Completed	Telehealth
5617	94	9	2023-01-10 16:45:00	Completed	Well child
5618	440	1	2021-02-12 11:00:00	Scheduled	Follow-up
5619	337	4	2024-10-12 16:30:00	Completed	Follow-up
5620	103	8	2025-08-11 16:00:00	Completed	Telehealth
5621	357	11	2021-06-19 09:15:00	Completed	Sick visit
5622	240	12	2019-02-17 13:15:00	Completed	Follow-up
5623	240	12	2021-06-03 13:30:00	Scheduled	Annual physical
5624	425	2	2019-10-22 12:15:00	Cancelled	Chronic care
5625	42	6	2022-01-22 12:30:00	Completed	Sick visit
5626	85	7	2022-11-30 12:00:00	Completed	Chronic care
5627	282	5	2020-03-19 12:00:00	Completed	Annual physical
5628	35	12	2020-05-28 16:30:00	Completed	Annual physical
5629	155	12	2020-03-15 16:15:00	Completed	Follow-up
5630	73	6	2023-12-07 10:00:00	Cancelled	Annual physical
5631	52	11	2025-10-08 09:00:00	Completed	Annual physical
5632	316	9	2022-02-03 11:45:00	Completed	Chronic care
5633	32	6	2019-06-13 08:00:00	Scheduled	Chronic care
5634	359	12	2025-04-23 13:00:00	Completed	Chronic care
5635	43	10	2023-03-26 14:15:00	Scheduled	Sick visit
5636	594	10	2023-05-25 16:30:00	Cancelled	Well child
5637	578	8	2021-07-06 14:15:00	Completed	Annual physical
5638	204	2	2024-11-22 13:15:00	Completed	Telehealth
5639	537	5	2024-03-27 13:45:00	Completed	Telehealth
5640	339	12	2020-10-29 13:00:00	Completed	Follow-up
5641	307	8	2024-07-22 08:15:00	Completed	Telehealth
5642	349	10	2022-11-06 16:00:00	Completed	Telehealth
5643	110	5	2019-10-04 08:00:00	Completed	Well child
5644	591	10	2024-03-23 10:15:00	Completed	Well child
5645	428	8	2022-02-17 13:30:00	Completed	Annual physical
5646	447	8	2020-06-20 10:15:00	Completed	Well child
5647	407	11	2022-08-09 15:45:00	Completed	Telehealth
5648	485	2	2020-10-29 15:00:00	Cancelled	Sick visit
5649	87	6	2022-08-31 10:45:00	No-show	Chronic care
5650	579	12	2025-06-13 12:00:00	No-show	Telehealth
5651	73	6	2024-05-29 08:45:00	No-show	Sick visit
5652	542	12	2025-06-08 16:15:00	Completed	Annual physical
5653	37	12	2021-07-24 11:30:00	Completed	Sick visit
5654	202	4	2021-06-26 13:45:00	Completed	Telehealth
5655	9	8	2020-12-11 15:00:00	Completed	Annual physical
5656	559	11	2019-02-10 14:30:00	Cancelled	Follow-up
5657	395	8	2024-04-28 11:45:00	Completed	Follow-up
5658	415	12	2025-11-13 12:30:00	Completed	Sick visit
5659	132	10	2019-05-19 14:15:00	Completed	Sick visit
5660	348	7	2020-05-01 12:45:00	Completed	Annual physical
5661	253	4	2020-08-14 10:45:00	Completed	Telehealth
5662	419	1	2023-04-05 15:30:00	Completed	Follow-up
5663	309	9	2022-11-12 14:30:00	Completed	Annual physical
5664	98	5	2021-01-05 16:45:00	Cancelled	Chronic care
5665	226	4	2024-08-31 14:15:00	Completed	Follow-up
5666	81	9	2026-03-22 09:30:00	Completed	Chronic care
5667	584	11	2020-04-03 15:15:00	Completed	Chronic care
5668	207	11	2021-09-27 11:45:00	Completed	Sick visit
5669	170	9	2023-06-25 12:45:00	Completed	Well child
5670	356	4	2025-11-12 13:00:00	Completed	Follow-up
5671	534	7	2023-01-19 10:15:00	Completed	Annual physical
5672	480	2	2023-10-05 09:15:00	Completed	Annual physical
5673	543	9	2024-09-29 13:30:00	Completed	Annual physical
5674	118	1	2019-08-11 16:30:00	Completed	Annual physical
5675	395	2	2019-08-05 08:15:00	Completed	Well child
5676	567	6	2024-11-11 16:45:00	Completed	Telehealth
5677	533	2	2019-07-17 09:45:00	Completed	Telehealth
5678	289	3	2023-06-20 10:00:00	Completed	Chronic care
5679	235	3	2021-06-04 11:30:00	Completed	Sick visit
5680	162	7	2020-02-02 13:15:00	Completed	Telehealth
5681	98	5	2025-09-26 16:45:00	Completed	Chronic care
5682	323	7	2024-01-18 11:45:00	Completed	Chronic care
5683	404	6	2019-03-29 08:15:00	Completed	Sick visit
5684	572	2	2026-03-04 16:45:00	Scheduled	Well child
5685	125	11	2022-03-14 14:15:00	Completed	Annual physical
5686	236	6	2026-05-23 12:00:00	Completed	Chronic care
5687	153	8	2022-06-11 15:30:00	Completed	Well child
5688	208	7	2024-05-23 11:45:00	Completed	Chronic care
5689	215	10	2025-01-21 17:00:00	Completed	Sick visit
5690	299	12	2021-09-06 09:00:00	No-show	Annual physical
5691	372	9	2024-09-25 16:45:00	Completed	Sick visit
5692	356	1	2023-03-28 08:30:00	Cancelled	Chronic care
5693	353	7	2020-01-10 13:45:00	Completed	Follow-up
5694	99	3	2021-01-07 09:45:00	Completed	Well child
5695	534	7	2025-07-08 09:30:00	Completed	Follow-up
5696	91	8	2019-06-07 09:45:00	Completed	Sick visit
5697	145	4	2020-10-03 09:30:00	Completed	Well child
5698	558	11	2022-04-05 08:00:00	Completed	Annual physical
5699	578	1	2021-11-24 08:15:00	Completed	Chronic care
5700	34	5	2026-04-03 11:15:00	Completed	Annual physical
5701	329	11	2020-11-23 12:30:00	Completed	Annual physical
5702	579	6	2021-09-26 15:15:00	No-show	Chronic care
5703	137	7	2026-04-03 09:30:00	Completed	Follow-up
5704	415	12	2023-12-08 09:45:00	Completed	Well child
5705	199	10	2019-08-08 16:45:00	No-show	Chronic care
5706	126	12	2019-08-04 13:45:00	Completed	Annual physical
5707	218	5	2019-07-08 11:15:00	Completed	Well child
5708	168	2	2023-07-16 11:15:00	Completed	Annual physical
5709	300	2	2025-03-08 09:15:00	Completed	Well child
5710	110	5	2026-02-06 09:00:00	Completed	Well child
5711	191	11	2023-12-21 15:30:00	Completed	Annual physical
5712	255	9	2020-10-02 13:15:00	Completed	Sick visit
5713	90	2	2025-06-05 16:00:00	Completed	Telehealth
5714	248	1	2019-11-24 13:45:00	Completed	Telehealth
5715	216	1	2021-09-14 15:15:00	Completed	Well child
5716	328	7	2022-04-06 15:30:00	Completed	Follow-up
5717	230	10	2022-09-11 11:45:00	Completed	Well child
5718	589	12	2019-11-26 09:30:00	Completed	Follow-up
5719	405	7	2021-08-28 13:15:00	Completed	Telehealth
5720	3	12	2019-01-23 08:30:00	Completed	Follow-up
5721	476	5	2021-06-14 09:15:00	Completed	Well child
5722	377	8	2024-02-29 14:00:00	Completed	Chronic care
5723	285	12	2019-12-02 12:15:00	Completed	Follow-up
5724	255	2	2022-04-30 10:30:00	Completed	Follow-up
5725	422	1	2020-10-07 08:00:00	Cancelled	Follow-up
5726	133	2	2024-06-29 09:45:00	Completed	Chronic care
5727	123	1	2025-04-24 09:15:00	Completed	Well child
5728	304	11	2022-01-24 09:00:00	Completed	Annual physical
5729	397	11	2020-10-21 16:00:00	Completed	Annual physical
5730	20	10	2022-05-26 11:30:00	Completed	Well child
5731	166	10	2020-03-21 16:15:00	No-show	Telehealth
5732	210	2	2025-09-30 08:30:00	Completed	Sick visit
5733	244	10	2023-06-08 11:45:00	Completed	Follow-up
5734	255	2	2026-01-19 13:00:00	Completed	Follow-up
5735	259	6	2020-04-08 10:15:00	Completed	Annual physical
5736	358	11	2023-09-11 11:45:00	Completed	Well child
5737	557	10	2020-01-07 15:30:00	Completed	Annual physical
5738	258	3	2020-09-02 16:30:00	Completed	Well child
5739	84	7	2024-08-25 09:45:00	Completed	Well child
5740	275	5	2020-08-29 11:30:00	Scheduled	Annual physical
5741	83	5	2021-07-29 15:45:00	Completed	Sick visit
5742	387	5	2026-05-05 15:15:00	Completed	Telehealth
5743	365	7	2022-10-16 17:00:00	Completed	Annual physical
5744	286	4	2023-06-26 13:00:00	Completed	Telehealth
5745	579	12	2022-12-10 16:15:00	Completed	Telehealth
5746	109	7	2021-07-04 14:00:00	Cancelled	Chronic care
5747	192	7	2023-12-14 16:45:00	Cancelled	Well child
5748	20	8	2019-08-20 13:15:00	Completed	Annual physical
5749	93	9	2020-08-13 13:00:00	No-show	Telehealth
5750	439	6	2023-09-22 11:00:00	Completed	Sick visit
5751	492	7	2019-12-15 12:30:00	Cancelled	Chronic care
5752	415	12	2025-02-24 08:45:00	Completed	Well child
5753	552	8	2024-11-10 15:30:00	Completed	Follow-up
5754	294	11	2023-01-16 08:00:00	Completed	Well child
5755	122	12	2025-11-07 11:45:00	Completed	Well child
5756	31	11	2019-07-04 11:30:00	Completed	Well child
5757	206	11	2019-03-15 16:30:00	Completed	Follow-up
5758	518	6	2021-07-18 13:15:00	Completed	Follow-up
5759	480	2	2019-08-08 11:00:00	Completed	Follow-up
5760	267	7	2026-03-30 08:00:00	Completed	Follow-up
5761	404	6	2024-08-07 11:15:00	Completed	Telehealth
5762	70	3	2022-01-16 14:30:00	Completed	Well child
5763	244	10	2022-11-05 12:45:00	Completed	Follow-up
5764	55	8	2023-11-10 14:30:00	Completed	Chronic care
5765	579	12	2022-02-17 11:30:00	Cancelled	Follow-up
5766	86	6	2022-11-08 10:00:00	Completed	Follow-up
5767	483	5	2025-01-13 14:00:00	Completed	Telehealth
5768	228	7	2021-01-02 08:45:00	No-show	Follow-up
5769	279	11	2020-06-20 14:15:00	Completed	Annual physical
5770	293	8	2021-08-05 16:15:00	Completed	Annual physical
5771	461	2	2022-02-13 08:30:00	No-show	Annual physical
5772	374	6	2024-02-21 12:15:00	No-show	Sick visit
5773	53	8	2023-03-15 14:00:00	Completed	Telehealth
5774	74	8	2023-08-12 12:00:00	Completed	Follow-up
5775	410	1	2020-04-06 15:45:00	Completed	Chronic care
5776	490	3	2019-09-10 14:00:00	No-show	Telehealth
5777	237	10	2023-10-02 10:45:00	Completed	Sick visit
5778	330	8	2019-11-02 16:45:00	Completed	Chronic care
5779	218	5	2025-03-24 13:00:00	Completed	Follow-up
5780	469	12	2020-01-07 13:00:00	Completed	Sick visit
5781	168	2	2020-10-26 08:00:00	Completed	Follow-up
5782	44	12	2025-03-20 11:30:00	Completed	Well child
5783	234	2	2022-07-30 13:15:00	Scheduled	Sick visit
5784	344	10	2023-04-20 12:00:00	Completed	Sick visit
5785	11	3	2025-01-07 08:15:00	Completed	Well child
5786	313	8	2019-04-15 17:00:00	Completed	Chronic care
5787	65	11	2019-02-26 15:30:00	Completed	Annual physical
5788	217	4	2019-02-12 10:30:00	Completed	Annual physical
5789	476	10	2020-05-01 08:00:00	Completed	Sick visit
5790	144	9	2022-01-01 10:30:00	Completed	Chronic care
5791	196	6	2023-03-06 16:00:00	Completed	Telehealth
5792	467	4	2021-12-17 08:00:00	No-show	Annual physical
5793	410	1	2020-12-23 10:00:00	Completed	Well child
5794	304	5	2022-11-11 15:00:00	Completed	Annual physical
5795	265	1	2024-12-25 15:45:00	Completed	Follow-up
5796	160	7	2023-04-30 09:30:00	Completed	Follow-up
5797	342	1	2023-06-05 10:30:00	Completed	Follow-up
5798	359	12	2025-09-19 13:15:00	Completed	Telehealth
5799	595	1	2024-09-12 15:45:00	Completed	Annual physical
5800	298	9	2025-11-26 12:15:00	Completed	Chronic care
5801	68	11	2025-03-12 12:45:00	Completed	Annual physical
5802	308	6	2023-01-12 10:15:00	Completed	Well child
5803	250	4	2020-01-09 10:15:00	Completed	Annual physical
5804	267	4	2023-09-22 12:30:00	No-show	Well child
5805	161	11	2021-07-18 16:15:00	Completed	Annual physical
5806	409	6	2025-07-12 14:30:00	No-show	Sick visit
5807	470	12	2019-05-01 10:15:00	Cancelled	Annual physical
5808	373	4	2022-09-02 13:00:00	Completed	Annual physical
5809	553	6	2022-11-18 09:15:00	No-show	Telehealth
5810	219	11	2023-07-17 09:45:00	Completed	Well child
5811	214	7	2022-11-03 13:45:00	No-show	Telehealth
5812	363	5	2021-01-01 10:45:00	Completed	Follow-up
5813	562	5	2021-07-07 12:00:00	Completed	Chronic care
5814	36	2	2020-06-20 10:00:00	Completed	Chronic care
5815	435	6	2020-07-20 12:45:00	Completed	Telehealth
5816	377	8	2021-07-11 11:30:00	No-show	Sick visit
5817	393	9	2025-11-09 09:15:00	Cancelled	Annual physical
5818	429	5	2019-09-05 12:45:00	No-show	Well child
5819	342	1	2021-05-24 16:30:00	Completed	Sick visit
5820	384	4	2025-09-24 16:00:00	Completed	Telehealth
5821	221	11	2023-05-11 16:45:00	Cancelled	Telehealth
5822	109	7	2021-10-19 15:15:00	Completed	Sick visit
5823	22	10	2025-08-06 09:00:00	Completed	Follow-up
5824	205	10	2026-04-27 17:00:00	Completed	Sick visit
5825	477	12	2019-09-02 09:00:00	Completed	Chronic care
5826	30	1	2025-12-18 12:15:00	Completed	Sick visit
5827	564	6	2023-06-01 13:30:00	Cancelled	Chronic care
5828	40	8	2021-12-29 10:00:00	Completed	Well child
5829	523	7	2022-05-12 15:30:00	Completed	Well child
5830	591	7	2022-10-04 10:15:00	Completed	Annual physical
5831	593	6	2022-01-20 13:45:00	Cancelled	Telehealth
5832	336	8	2021-02-26 10:30:00	No-show	Follow-up
5833	250	4	2024-08-04 16:15:00	Completed	Telehealth
5834	104	10	2019-12-01 15:45:00	Completed	Annual physical
5835	437	4	2023-07-10 14:00:00	No-show	Chronic care
5836	54	10	2022-08-09 12:30:00	Completed	Follow-up
5837	128	6	2025-10-07 16:00:00	Completed	Well child
5838	436	3	2024-12-10 16:00:00	Completed	Follow-up
5839	413	8	2024-12-11 11:00:00	Completed	Sick visit
5840	239	6	2021-06-16 14:45:00	No-show	Chronic care
5841	586	4	2021-02-18 10:30:00	Completed	Chronic care
5842	92	9	2023-09-14 13:30:00	Completed	Well child
5843	172	9	2019-02-11 10:45:00	Completed	Chronic care
5844	332	4	2022-09-04 16:15:00	Scheduled	Follow-up
5845	212	7	2022-05-10 08:00:00	Completed	Follow-up
5846	82	3	2022-02-22 10:15:00	Completed	Telehealth
5847	29	4	2019-04-06 13:30:00	No-show	Sick visit
5848	128	6	2022-11-14 12:00:00	Completed	Annual physical
5849	324	1	2019-11-12 12:45:00	Completed	Telehealth
5850	386	12	2020-07-29 12:15:00	Completed	Follow-up
5851	556	9	2023-10-27 12:15:00	Scheduled	Well child
5852	296	4	2024-01-26 15:00:00	Completed	Telehealth
5853	241	11	2019-06-29 15:30:00	Completed	Chronic care
5854	11	5	2020-11-19 15:00:00	Completed	Follow-up
5855	84	7	2026-05-01 14:00:00	Cancelled	Follow-up
5856	357	11	2020-07-17 12:45:00	No-show	Chronic care
5857	16	2	2024-07-27 16:30:00	Completed	Follow-up
5858	444	6	2019-03-15 16:45:00	Completed	Sick visit
5859	176	1	2022-12-26 14:15:00	Scheduled	Follow-up
5860	581	4	2024-01-06 10:00:00	Completed	Chronic care
5861	507	11	2020-04-26 14:15:00	Completed	Well child
5862	324	2	2026-05-09 09:45:00	Completed	Follow-up
5863	418	5	2021-05-14 16:00:00	Completed	Well child
5864	514	3	2022-09-02 12:30:00	Completed	Sick visit
5865	5	4	2019-11-02 11:45:00	Completed	Annual physical
5866	389	5	2024-01-01 14:15:00	Completed	Follow-up
5867	556	9	2025-12-07 10:00:00	Completed	Sick visit
5868	166	10	2021-12-29 11:45:00	Completed	Follow-up
5869	361	3	2025-11-19 08:00:00	Scheduled	Sick visit
5870	211	6	2024-09-25 09:00:00	Completed	Chronic care
5871	21	12	2020-05-21 12:15:00	Completed	Follow-up
5872	564	6	2023-11-19 17:00:00	Scheduled	Annual physical
5873	51	12	2021-01-13 10:30:00	Completed	Follow-up
5874	147	9	2025-06-05 14:30:00	Completed	Chronic care
5875	295	8	2026-01-27 09:00:00	Completed	Sick visit
5876	57	7	2025-06-01 12:30:00	Completed	Annual physical
5877	489	8	2019-07-22 10:15:00	Completed	Telehealth
5878	572	2	2020-07-16 08:00:00	No-show	Annual physical
5879	24	9	2019-10-13 10:15:00	Completed	Telehealth
5880	544	3	2021-08-22 08:15:00	Completed	Follow-up
5881	309	9	2023-04-22 16:15:00	Completed	Telehealth
5882	466	3	2020-07-16 11:00:00	Completed	Sick visit
5883	91	3	2021-08-23 09:00:00	Completed	Telehealth
5884	462	8	2023-08-09 16:45:00	Completed	Annual physical
5885	371	4	2021-10-01 10:45:00	Scheduled	Well child
5886	386	2	2021-11-02 16:45:00	Completed	Annual physical
5887	580	12	2023-05-31 09:30:00	Completed	Chronic care
5888	448	7	2021-03-08 13:00:00	Completed	Chronic care
5889	445	9	2024-01-07 14:30:00	Completed	Chronic care
5890	80	10	2025-05-01 16:30:00	Completed	Annual physical
5891	96	1	2020-12-16 10:45:00	Completed	Telehealth
5892	531	6	2020-06-01 14:45:00	Completed	Chronic care
5893	370	9	2023-07-05 09:45:00	Completed	Chronic care
5894	413	8	2019-06-29 12:45:00	Completed	Follow-up
5895	374	5	2019-01-22 11:15:00	Completed	Chronic care
5896	201	7	2020-02-24 08:00:00	Scheduled	Annual physical
5897	510	12	2022-06-28 11:00:00	Completed	Telehealth
5898	82	3	2023-09-28 15:30:00	Cancelled	Telehealth
5899	44	12	2024-03-29 08:30:00	No-show	Telehealth
5900	317	6	2022-07-20 09:00:00	Completed	Sick visit
5901	416	1	2019-12-24 15:00:00	Completed	Telehealth
5902	330	8	2024-02-12 17:00:00	Completed	Well child
5903	206	11	2019-08-20 15:30:00	Completed	Annual physical
5904	76	8	2025-12-30 15:45:00	No-show	Telehealth
5905	210	2	2024-02-16 17:00:00	Completed	Annual physical
5906	409	5	2019-07-15 11:15:00	Cancelled	Well child
5907	390	10	2025-05-10 17:00:00	Completed	Chronic care
5908	31	11	2022-11-19 10:15:00	Completed	Telehealth
5909	580	4	2022-11-19 09:15:00	Completed	Well child
5910	576	3	2019-11-09 14:45:00	Completed	Telehealth
5911	98	5	2022-04-30 09:15:00	Completed	Annual physical
5912	192	11	2023-11-18 14:45:00	Completed	Well child
5913	510	12	2023-12-10 14:00:00	Cancelled	Well child
5914	571	7	2025-06-23 13:15:00	Completed	Well child
5915	82	3	2020-04-05 13:00:00	Completed	Telehealth
5916	56	11	2026-03-18 09:00:00	Completed	Annual physical
5917	466	3	2020-03-12 08:45:00	Cancelled	Sick visit
5918	317	6	2021-12-23 08:15:00	Completed	Annual physical
5919	523	7	2024-06-08 13:30:00	Completed	Chronic care
5920	264	1	2024-08-10 09:30:00	Completed	Chronic care
5921	309	9	2022-11-26 16:15:00	Completed	Annual physical
5922	324	1	2020-03-02 15:15:00	No-show	Telehealth
5923	366	12	2023-12-08 16:00:00	Completed	Annual physical
5924	270	5	2020-08-17 11:45:00	Completed	Follow-up
5925	81	8	2023-09-08 10:30:00	No-show	Telehealth
5926	57	7	2019-09-19 10:15:00	Completed	Sick visit
5927	68	11	2020-04-12 09:00:00	Completed	Telehealth
5928	270	5	2026-04-19 08:00:00	Completed	Follow-up
5929	488	5	2025-06-25 17:00:00	Completed	Telehealth
5930	102	3	2020-05-16 16:30:00	Cancelled	Sick visit
5931	458	8	2019-02-06 13:45:00	Completed	Sick visit
5932	507	9	2020-05-30 11:15:00	Completed	Follow-up
5933	255	12	2019-01-02 10:45:00	Completed	Telehealth
5934	320	11	2023-05-20 11:15:00	Scheduled	Well child
5935	438	3	2023-06-24 14:00:00	Scheduled	Well child
5936	480	2	2025-05-27 14:15:00	Completed	Follow-up
5937	154	8	2024-04-28 08:45:00	Cancelled	Well child
5938	337	4	2023-08-04 11:45:00	Completed	Annual physical
5939	508	3	2025-04-26 09:15:00	Completed	Annual physical
5940	423	4	2023-08-07 15:15:00	Completed	Follow-up
5941	481	11	2022-10-01 11:15:00	Completed	Well child
5942	596	10	2022-12-06 14:15:00	Cancelled	Telehealth
5943	149	4	2022-08-14 16:45:00	Completed	Annual physical
5944	225	9	2025-12-16 15:15:00	Completed	Follow-up
5945	182	6	2023-07-28 12:45:00	Completed	Follow-up
5946	424	8	2019-08-14 10:00:00	Completed	Well child
5947	568	4	2024-06-04 08:00:00	Completed	Telehealth
5948	114	7	2025-01-18 15:15:00	Completed	Follow-up
5949	513	11	2025-12-24 16:15:00	Completed	Telehealth
5950	549	3	2022-03-26 15:30:00	Completed	Follow-up
5951	513	5	2020-01-13 12:45:00	Completed	Well child
5952	259	6	2020-07-28 12:45:00	Completed	Chronic care
5953	495	4	2023-08-31 11:00:00	Completed	Chronic care
5954	489	8	2021-04-21 15:00:00	Completed	Follow-up
5955	582	8	2024-01-10 16:00:00	No-show	Follow-up
5956	568	4	2026-03-21 15:00:00	Completed	Annual physical
5957	431	5	2023-02-09 15:15:00	Completed	Follow-up
5958	407	11	2019-08-20 09:00:00	Completed	Telehealth
5959	262	7	2026-01-13 08:15:00	Completed	Well child
5960	70	1	2020-04-18 11:00:00	Completed	Well child
5961	51	12	2024-05-23 09:00:00	Completed	Annual physical
5962	94	9	2023-11-20 10:15:00	No-show	Telehealth
5963	326	2	2025-12-19 16:15:00	Cancelled	Well child
5964	185	9	2021-01-22 14:00:00	Completed	Well child
5965	135	8	2019-04-27 09:15:00	Completed	Sick visit
5966	261	11	2024-04-13 13:15:00	Completed	Telehealth
5967	236	6	2020-03-10 15:30:00	Cancelled	Telehealth
5968	258	8	2024-10-22 14:00:00	Completed	Telehealth
5969	445	9	2024-12-16 09:00:00	Cancelled	Sick visit
5970	261	6	2021-11-23 10:30:00	Completed	Sick visit
5971	292	11	2024-02-13 12:00:00	No-show	Well child
5972	12	4	2023-05-17 10:45:00	Completed	Chronic care
5973	299	12	2021-04-15 11:00:00	Completed	Annual physical
5974	100	1	2023-05-22 13:00:00	Completed	Sick visit
5975	512	2	2025-11-27 10:45:00	Completed	Chronic care
5976	299	12	2021-08-31 13:45:00	Completed	Follow-up
5977	150	8	2023-08-16 13:15:00	Completed	Chronic care
5978	448	7	2026-01-08 15:00:00	Completed	Chronic care
5979	370	7	2025-07-17 13:45:00	Completed	Follow-up
5980	556	9	2025-11-07 11:15:00	Completed	Follow-up
5981	48	10	2021-07-23 13:30:00	Completed	Sick visit
5982	128	6	2026-04-21 12:45:00	No-show	Well child
5983	212	7	2024-11-15 09:00:00	Cancelled	Well child
5984	599	3	2025-07-07 16:00:00	Completed	Telehealth
5985	262	7	2019-10-14 12:45:00	Completed	Telehealth
5986	531	6	2020-02-28 12:15:00	Completed	Annual physical
5987	261	6	2020-08-28 08:15:00	Completed	Sick visit
5988	62	2	2021-06-28 13:45:00	Completed	Chronic care
5989	7	9	2024-04-28 10:00:00	Completed	Telehealth
5990	579	12	2023-06-24 12:00:00	Completed	Chronic care
5991	228	7	2025-01-18 14:15:00	Completed	Chronic care
5992	151	3	2021-12-31 15:45:00	Completed	Chronic care
5993	189	10	2025-07-12 11:00:00	No-show	Telehealth
5994	412	5	2025-08-25 09:00:00	Completed	Follow-up
5995	534	7	2022-07-19 09:30:00	Completed	Well child
5996	477	12	2023-05-01 14:30:00	Completed	Well child
5997	96	1	2021-03-26 15:45:00	No-show	Annual physical
5998	40	8	2019-07-09 16:30:00	Scheduled	Well child
5999	407	2	2024-05-29 09:45:00	Completed	Annual physical
6000	124	10	2019-03-29 16:45:00	No-show	Sick visit
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.patients (patient_id, first_name, last_name, date_of_birth, phone, email, address, insurance_member_id) FROM stdin;
1	Esperanza	Dominguez	1999-11-21	602-555-2526	esperanza.dominguez4@example.org	7461 W Bell Rd, Phoenix, AZ 85025	CPR-407977684
2	Owen	Singh	1991-05-06	602-555-4370	owen.singh43@example.org	5670 W Thunderbird Rd, Phoenix, AZ 85045	CPR-803997325
3	Uriel	Gutierrez	1999-02-01	602-555-0883	uriel.gutierrez36@example.org	8779 W Southern Ave, Phoenix, AZ 85040	DES-550886503
4	Lena	Acosta	1975-04-12	602-555-0715	lena.acosta65@example.org	478 W Baseline Rd, Phoenix, AZ 85011	DES-205775777
5	Marcus	Begay	1990-03-09	602-555-7435	marcus.begay64@example.org	7897 W Baseline Rd, Phoenix, AZ 85034	MRC-270086151
6	Mateo	Dominguez	2004-01-15	602-555-4964	mateo.dominguez80@example.org	734 W Indian School Rd, Phoenix, AZ 85038	CPR-904045917
7	Mateo	Espinoza	1948-01-21	602-555-6252	mateo.espinoza53@example.org	6369 W Glendale Ave, Phoenix, AZ 85029	CPR-690192259
8	Tomas	Cruz	1950-03-07	602-555-9712	tomas.cruz61@example.org	6938 W Indian School Rd, Phoenix, AZ 85022	MRC-184956292
9	Diego	Gomez	1975-09-19	602-555-3302	diego.gomez62@example.org	874 W Thunderbird Rd, Phoenix, AZ 85039	CPR-600458587
10	Yara	Ortiz	1942-07-28	602-555-9741	yara.ortiz35@example.org	1784 W Peoria Ave, Phoenix, AZ 85032	CPR-241985171
11	Renata	Williams	1989-06-06	602-555-3437	renata.williams71@example.org	6744 W Dunlap Ave, Phoenix, AZ 85027	SUN-444776063
12	Carlos	Cruz	1960-09-13	602-555-3405	carlos.cruz31@example.org	3094 W Indian School Rd, Phoenix, AZ 85044	CPR-665353601
13	Uriel	Velasquez	1967-12-09	602-555-6277	uriel.velasquez44@example.org	1613 W Baseline Rd, Phoenix, AZ 85044	AZB-442059229
14	Hana	Singh	1946-11-28	602-555-9536	hana.singh53@example.org	1542 W Thunderbird Rd, Phoenix, AZ 85032	SUN-790571384
15	Paloma	Kim	1981-07-22	602-555-2647	paloma.kim94@example.org	9395 W Thomas Rd, Phoenix, AZ 85016	MRC-854828844
16	Paloma	Silva	2013-06-15	602-555-8535	paloma.silva86@example.org	7940 W Baseline Rd, Phoenix, AZ 85028	AZB-915987012
17	Carlos	Vasquez	1960-12-16	602-555-6434	carlos.vasquez37@example.org	3919 W Thunderbird Rd, Phoenix, AZ 85048	SUN-998439330
18	Jasmine	Gomez	1946-08-05	602-555-3738	jasmine.gomez22@example.org	8520 W McDowell Rd, Phoenix, AZ 85045	SUN-828691341
19	Miguel	Washington	1964-09-22	602-555-3145	miguel.washington60@example.org	3823 W Camelback Rd, Phoenix, AZ 85044	MRC-188917449
20	Nadia	Rivera	1994-07-07	602-555-1437	nadia.rivera80@example.org	7855 W Dunlap Ave, Phoenix, AZ 85030	DES-108554667
21	Zoe	Nguyen	2016-08-07	602-555-2995	zoe.nguyen70@example.org	5773 W Southern Ave, Phoenix, AZ 85043	AZB-253471670
22	Wren	Mendoza	1980-12-01	602-555-5227	wren.mendoza7@example.org	5716 W Thomas Rd, Phoenix, AZ 85021	SUN-411538306
23	Wren	Chavez	1959-10-20	602-555-8470	wren.chavez90@example.org	4398 W Union Hills Dr, Phoenix, AZ 85050	CPR-899010390
24	Carlos	Medina	1997-10-29	602-555-3376	carlos.medina53@example.org	6486 W McDowell Rd, Phoenix, AZ 85035	AZB-309142993
25	Beatriz	Romero	2022-01-31	602-555-3666	beatriz.romero27@example.org	2409 W Bethany Home Rd, Phoenix, AZ 85049	MRC-433437964
26	Ana	Ramirez	1953-04-18	602-555-0888	ana.ramirez8@example.org	9475 W Peoria Ave, Phoenix, AZ 85039	MRC-989873692
27	Noor	Ramirez	1976-10-28	602-555-6470	noor.ramirez81@example.org	5715 W Bell Rd, Phoenix, AZ 85049	MRC-674228676
28	Lena	Begay	1949-03-30	602-555-6312	lena.begay74@example.org	7003 W Thunderbird Rd, Phoenix, AZ 85033	MRC-529532752
29	Paloma	Singh	1960-08-16	602-555-8345	paloma.singh5@example.org	9135 W Camelback Rd, Phoenix, AZ 85016	CPR-706000224
30	Imani	Gutierrez	1984-08-05	602-555-7278	imani.gutierrez41@example.org	3493 W Dunlap Ave, Phoenix, AZ 85051	SUN-630333104
31	Olivia	Romero	2015-08-11	602-555-6191	olivia.romero51@example.org	5839 W Greenway Rd, Phoenix, AZ 85039	DES-347957008
32	Lucia	Dominguez	1956-11-24	602-555-6458	lucia.dominguez15@example.org	1016 W Camelback Rd, Phoenix, AZ 85041	CPR-508001247
33	Nadia	Foster	1961-11-06	602-555-5141	nadia.foster72@example.org	4356 W Cactus Rd, Phoenix, AZ 85026	MRC-969075023
34	Leon	Reyes	1948-12-24	602-555-4981	leon.reyes67@example.org	7758 W Thunderbird Rd, Phoenix, AZ 85046	CPR-639140784
35	Adrian	Chavez	1954-03-16	602-555-9469	adrian.chavez20@example.org	1418 W Union Hills Dr, Phoenix, AZ 85025	AZB-958643530
36	Omar	Castillo	2003-03-20	602-555-2682	omar.castillo4@example.org	4152 W Glendale Ave, Phoenix, AZ 85016	CPR-508598112
37	Rosa	Perez	2003-12-31	602-555-5974	rosa.perez47@example.org	3694 W Glendale Ave, Phoenix, AZ 85011	AZB-843526356
38	Esperanza	Yazzie	1945-06-09	602-555-3927	esperanza.yazzie33@example.org	4304 W Dunlap Ave, Phoenix, AZ 85042	AZB-237635459
39	Serena	Foster	1948-11-16	602-555-3717	serena.foster7@example.org	8522 W Greenway Rd, Phoenix, AZ 85044	DES-106050057
40	Xavier	Salazar	1957-03-25	602-555-1538	xavier.salazar22@example.org	9518 W Baseline Rd, Phoenix, AZ 85031	SUN-353764086
41	Gavin	Robinson	1996-12-01	602-555-9806	gavin.robinson66@example.org	2883 W Glendale Ave, Phoenix, AZ 85036	MRC-770995634
42	Lucia	Salazar	1965-12-15	602-555-7550	lucia.salazar52@example.org	7970 W Union Hills Dr, Phoenix, AZ 85039	SUN-936846192
43	Noor	Silva	1992-03-24	602-555-2154	noor.silva40@example.org	9331 W Dunlap Ave, Phoenix, AZ 85013	AZB-199206971
44	Zoe	Kim	1942-04-02	602-555-3845	zoe.kim57@example.org	2703 W Thunderbird Rd, Phoenix, AZ 85016	SUN-702167079
45	Dolores	Flores	1945-04-20	602-555-2665	dolores.flores37@example.org	1700 W Camelback Rd, Phoenix, AZ 85046	DES-807937785
46	Victor	Patel	1991-02-24	602-555-5492	victor.patel18@example.org	2050 W Cactus Rd, Phoenix, AZ 85013	AZB-898797275
47	Miguel	Rivera	1957-05-07	602-555-4170	miguel.rivera58@example.org	3117 W Thunderbird Rd, Phoenix, AZ 85040	DES-148753180
48	Javier	Robinson	2006-06-27	602-555-2529	javier.robinson85@example.org	9618 W Greenway Rd, Phoenix, AZ 85030	DES-749687003
49	Omar	Vasquez	1999-01-16	602-555-1286	omar.vasquez65@example.org	3824 W Bethany Home Rd, Phoenix, AZ 85051	AZB-285539149
50	Benjamin	Padilla	1972-10-25	602-555-7836	benjamin.padilla20@example.org	5393 W Southern Ave, Phoenix, AZ 85027	CPR-137738885
51	Yusuf	Medina	2019-03-20	602-555-7321	yusuf.medina94@example.org	4580 W Northern Ave, Phoenix, AZ 85024	CPR-289209792
52	Javier	Castillo	1982-12-25	602-555-2039	javier.castillo67@example.org	4825 W Greenway Rd, Phoenix, AZ 85024	AZB-954282620
53	Adrian	Torres	1959-12-22	602-555-6676	adrian.torres50@example.org	219 W Bethany Home Rd, Phoenix, AZ 85016	SUN-425433462
54	Owen	Padilla	2015-07-02	602-555-3836	owen.padilla42@example.org	7589 W Bethany Home Rd, Phoenix, AZ 85025	DES-873098595
55	Rafael	Vargas	2021-09-06	602-555-5987	rafael.vargas36@example.org	2440 W Camelback Rd, Phoenix, AZ 85051	SUN-221603453
56	Aaliyah	Hernandez	1970-04-01	602-555-1311	aaliyah.hernandez87@example.org	3016 W Baseline Rd, Phoenix, AZ 85046	DES-670388069
57	Victor	Yazzie	2002-02-16	602-555-3336	victor.yazzie63@example.org	7195 W Southern Ave, Phoenix, AZ 85018	SUN-143728638
58	Talia	Ramirez	2013-02-24	602-555-2980	talia.ramirez96@example.org	9253 W Union Hills Dr, Phoenix, AZ 85034	DES-366424427
59	Samuel	Ramirez	2016-05-21	602-555-0994	samuel.ramirez91@example.org	9560 W Glendale Ave, Phoenix, AZ 85025	MRC-147296340
60	Nadia	Flores	1942-01-12	602-555-0426	nadia.flores30@example.org	1388 W Thunderbird Rd, Phoenix, AZ 85021	SUN-138503109
61	Esperanza	Kim	1956-11-08	602-555-1702	esperanza.kim94@example.org	5255 W Thomas Rd, Phoenix, AZ 85050	DES-695053349
62	Uriel	Gutierrez	1999-05-19	602-555-9190	uriel.gutierrez62@example.org	1448 W Baseline Rd, Phoenix, AZ 85015	DES-188848109
63	Renata	Salazar	1947-09-30	602-555-8318	renata.salazar48@example.org	9893 W Bethany Home Rd, Phoenix, AZ 85010	SUN-520488431
64	Ana	Ramirez	1988-04-28	602-555-6884	ana.ramirez95@example.org	2699 W Bell Rd, Phoenix, AZ 85041	SUN-329269832
65	Esperanza	Chavez	2014-05-27	602-555-2576	esperanza.chavez47@example.org	6610 W Northern Ave, Phoenix, AZ 85040	MRC-796503174
66	Isaac	Vasquez	1954-02-17	602-555-2883	isaac.vasquez13@example.org	7292 W Thunderbird Rd, Phoenix, AZ 85034	CPR-530260843
67	Mateo	Sanchez	1998-11-18	602-555-1693	mateo.sanchez8@example.org	1841 W Peoria Ave, Phoenix, AZ 85014	CPR-102449011
68	Ana	Cruz	1970-04-21	602-555-5200	ana.cruz5@example.org	5325 W Greenway Rd, Phoenix, AZ 85025	SUN-230574992
69	Carla	Velasquez	1948-03-31	602-555-1282	carla.velasquez78@example.org	8010 W Southern Ave, Phoenix, AZ 85037	DES-405489757
70	Carla	Delgado	1984-08-21	602-555-6940	carla.delgado80@example.org	8234 W Bethany Home Rd, Phoenix, AZ 85030	MRC-202711827
71	Mateo	Yazzie	1986-12-31	602-555-6290	mateo.yazzie43@example.org	6689 W Thunderbird Rd, Phoenix, AZ 85041	AZB-203018042
72	Gavin	Lopez	1982-03-24	602-555-2332	gavin.lopez24@example.org	5401 W Bell Rd, Phoenix, AZ 85039	CPR-201383192
73	Victor	Kim	1979-02-10	602-555-3647	victor.kim41@example.org	377 W McDowell Rd, Phoenix, AZ 85033	AZB-438281377
74	Valeria	Espinoza	1980-10-29	602-555-8998	valeria.espinoza12@example.org	1775 W Southern Ave, Phoenix, AZ 85015	CPR-279893632
75	Elijah	Yazzie	1957-07-15	602-555-8331	elijah.yazzie25@example.org	5804 W Peoria Ave, Phoenix, AZ 85044	AZB-650749277
76	Daniel	Padilla	1983-07-14	602-555-4237	daniel.padilla11@example.org	6843 W Greenway Rd, Phoenix, AZ 85035	SUN-185047622
77	Uriel	Salazar	1995-10-13	602-555-1097	uriel.salazar4@example.org	4421 W Dunlap Ave, Phoenix, AZ 85012	MRC-835971658
78	Hector	Reyes	1979-02-01	602-555-4583	hector.reyes9@example.org	387 W Thomas Rd, Phoenix, AZ 85016	CPR-608175311
79	Ana	Vasquez	1993-09-22	602-555-2604	ana.vasquez58@example.org	2568 W Union Hills Dr, Phoenix, AZ 85033	AZB-955718488
80	Marisol	Vargas	1978-01-18	602-555-3764	marisol.vargas70@example.org	9706 W Southern Ave, Phoenix, AZ 85014	MRC-982901589
81	Yara	Patel	2001-09-14	602-555-6356	yara.patel93@example.org	6502 W Peoria Ave, Phoenix, AZ 85035	AZB-253909922
82	Gavin	Romero	2007-11-23	602-555-5366	gavin.romero98@example.org	3806 W Indian School Rd, Phoenix, AZ 85031	DES-581252636
83	Yara	Robinson	1944-10-06	602-555-9340	yara.robinson56@example.org	3330 W Peoria Ave, Phoenix, AZ 85024	CPR-400093699
84	Valeria	Jimenez	1958-07-24	602-555-4519	valeria.jimenez19@example.org	1263 W Indian School Rd, Phoenix, AZ 85039	SUN-691669421
85	Miguel	Nguyen	1940-10-17	602-555-4132	miguel.nguyen98@example.org	500 W Northern Ave, Phoenix, AZ 85012	AZB-329611520
86	Uriel	Medina	1998-12-15	602-555-2760	uriel.medina69@example.org	7016 W Glendale Ave, Phoenix, AZ 85013	DES-960198923
87	Omar	Silva	1959-10-26	602-555-3958	omar.silva62@example.org	9958 W Peoria Ave, Phoenix, AZ 85012	AZB-747633616
88	Yusuf	Espinoza	1980-10-22	602-555-2046	yusuf.espinoza20@example.org	2855 W Glendale Ave, Phoenix, AZ 85015	MRC-436890312
89	Dolores	Garcia	1982-05-20	602-555-3509	dolores.garcia29@example.org	7944 W Thomas Rd, Phoenix, AZ 85019	CPR-833129353
90	Serena	Espinoza	1960-10-14	602-555-6743	serena.espinoza21@example.org	3506 W Union Hills Dr, Phoenix, AZ 85015	SUN-710642299
91	Miguel	Perez	1971-12-10	602-555-8024	miguel.perez49@example.org	3545 W Southern Ave, Phoenix, AZ 85041	CPR-130757556
92	Sebastian	Padilla	1994-11-01	602-555-9739	sebastian.padilla2@example.org	5832 W Southern Ave, Phoenix, AZ 85012	CPR-499407633
93	Leon	Delgado	1941-07-25	602-555-5504	leon.delgado13@example.org	7116 W Dunlap Ave, Phoenix, AZ 85041	CPR-507712659
94	Carlos	Garcia	2016-03-15	602-555-6423	carlos.garcia18@example.org	1108 W Peoria Ave, Phoenix, AZ 85014	MRC-476896879
95	Benjamin	Vasquez	1981-02-19	602-555-8275	benjamin.vasquez31@example.org	4103 W Bell Rd, Phoenix, AZ 85018	DES-297021868
96	Felix	Vasquez	1957-11-27	602-555-5467	felix.vasquez95@example.org	3803 W Southern Ave, Phoenix, AZ 85031	MRC-306123912
97	Lucia	Delgado	1991-09-17	602-555-4941	lucia.delgado69@example.org	8691 W Thunderbird Rd, Phoenix, AZ 85033	DES-331221299
98	Hana	Williams	1993-07-06	602-555-6242	hana.williams33@example.org	451 W McDowell Rd, Phoenix, AZ 85029	DES-202457470
99	Carla	Reyes	2012-02-19	602-555-7061	carla.reyes98@example.org	2723 W Bethany Home Rd, Phoenix, AZ 85040	DES-643082417
100	Wren	Kim	1964-05-19	602-555-0120	wren.kim58@example.org	9285 W Peoria Ave, Phoenix, AZ 85026	DES-505458485
101	Gavin	Velasquez	1974-12-19	602-555-5834	gavin.velasquez29@example.org	2033 W McDowell Rd, Phoenix, AZ 85029	DES-751120057
102	Esperanza	Washington	2010-03-30	602-555-0968	esperanza.washington87@example.org	1430 W Dunlap Ave, Phoenix, AZ 85026	DES-634672677
103	Alma	Lopez	2000-02-09	602-555-6816	alma.lopez18@example.org	8438 W Bethany Home Rd, Phoenix, AZ 85032	DES-360438208
104	Benjamin	Rivera	2017-02-26	602-555-3659	benjamin.rivera28@example.org	4893 W Peoria Ave, Phoenix, AZ 85011	CPR-116168724
105	Imani	Jimenez	1941-06-03	602-555-4641	imani.jimenez91@example.org	396 W Indian School Rd, Phoenix, AZ 85020	AZB-706043720
106	Marisol	Garcia	1948-07-27	602-555-8005	marisol.garcia31@example.org	628 W Southern Ave, Phoenix, AZ 85048	AZB-490747904
107	Yara	Ibarra	1986-11-05	602-555-9098	yara.ibarra9@example.org	7979 W Union Hills Dr, Phoenix, AZ 85024	AZB-329892044
108	Owen	Robinson	1962-12-04	602-555-6912	owen.robinson37@example.org	9248 W Bethany Home Rd, Phoenix, AZ 85045	CPR-715863673
109	Marisol	Espinoza	1961-08-16	602-555-7301	marisol.espinoza13@example.org	4291 W Dunlap Ave, Phoenix, AZ 85022	DES-836427633
110	Zoe	Torres	1970-02-10	602-555-0726	zoe.torres90@example.org	908 W Camelback Rd, Phoenix, AZ 85024	MRC-493920632
111	Kenji	Kim	2013-12-10	602-555-8624	kenji.kim18@example.org	9792 W Greenway Rd, Phoenix, AZ 85050	AZB-925433670
112	Nia	Robinson	1955-01-03	602-555-2441	nia.robinson84@example.org	9433 W Union Hills Dr, Phoenix, AZ 85037	CPR-280525644
113	Nathan	Williams	1984-07-08	602-555-2271	nathan.williams70@example.org	1424 W Thomas Rd, Phoenix, AZ 85027	SUN-895228095
114	Omar	Patel	1990-12-15	602-555-4313	omar.patel17@example.org	511 W Bethany Home Rd, Phoenix, AZ 85039	DES-758418227
115	Imani	Robinson	1959-08-18	602-555-4775	imani.robinson43@example.org	6728 W Southern Ave, Phoenix, AZ 85047	AZB-480762926
116	Nadia	Robinson	1955-12-09	602-555-8124	nadia.robinson69@example.org	6173 W Bell Rd, Phoenix, AZ 85032	DES-222009662
117	Adrian	Garcia	1976-10-01	602-555-0762	adrian.garcia49@example.org	2235 W Thunderbird Rd, Phoenix, AZ 85046	SUN-428818778
118	Wren	Sanchez	1956-06-23	602-555-7963	wren.sanchez15@example.org	7992 W Union Hills Dr, Phoenix, AZ 85036	AZB-622299658
119	Marisol	Romero	1961-02-01	602-555-4387	marisol.romero91@example.org	7034 W Thomas Rd, Phoenix, AZ 85027	MRC-707950996
120	Victor	Perez	2017-10-28	602-555-6106	victor.perez48@example.org	8078 W Peoria Ave, Phoenix, AZ 85034	MRC-439764073
121	Talia	Gomez	1969-08-20	602-555-6785	talia.gomez37@example.org	9754 W Camelback Rd, Phoenix, AZ 85040	DES-939591229
122	Diego	Hernandez	2013-03-11	602-555-9739	diego.hernandez79@example.org	2349 W Dunlap Ave, Phoenix, AZ 85038	CPR-683973074
123	Benjamin	Reyes	1996-09-03	602-555-7782	benjamin.reyes10@example.org	8159 W Bell Rd, Phoenix, AZ 85026	AZB-772164256
124	Lucia	Hernandez	2007-10-20	602-555-0419	lucia.hernandez8@example.org	2220 W Thunderbird Rd, Phoenix, AZ 85049	SUN-560188266
125	Carlos	Torres	1996-09-10	602-555-9446	carlos.torres70@example.org	972 W Northern Ave, Phoenix, AZ 85017	AZB-427669816
126	Nathan	Gutierrez	1950-12-05	602-555-7859	nathan.gutierrez64@example.org	7238 W Thunderbird Rd, Phoenix, AZ 85030	CPR-320436475
127	Beatriz	Patel	1962-12-13	602-555-0277	beatriz.patel97@example.org	5091 W Thomas Rd, Phoenix, AZ 85049	CPR-797439130
128	Samuel	Medina	1958-05-04	602-555-1399	samuel.medina74@example.org	257 W Greenway Rd, Phoenix, AZ 85035	AZB-576991878
129	Kaya	Acosta	1946-08-01	602-555-6225	kaya.acosta23@example.org	8898 W Thomas Rd, Phoenix, AZ 85048	SUN-216699512
130	Adrian	Reyes	1959-04-30	602-555-8523	adrian.reyes31@example.org	1269 W Greenway Rd, Phoenix, AZ 85016	DES-368813636
131	Rafael	Martinez	1952-08-19	602-555-9057	rafael.martinez86@example.org	5011 W Glendale Ave, Phoenix, AZ 85034	DES-596005642
132	Xavier	Flores	2011-06-28	602-555-9494	xavier.flores44@example.org	8971 W McDowell Rd, Phoenix, AZ 85048	MRC-660001700
133	Marisol	Acosta	1953-12-11	602-555-1772	marisol.acosta32@example.org	7051 W Cactus Rd, Phoenix, AZ 85047	DES-240838560
134	Aaliyah	Morales	1981-03-19	602-555-2060	aaliyah.morales40@example.org	9876 W Greenway Rd, Phoenix, AZ 85019	SUN-262302297
135	Felix	Chen	1952-03-23	602-555-8500	felix.chen21@example.org	3134 W Union Hills Dr, Phoenix, AZ 85051	CPR-539904543
136	Isaac	Dominguez	1991-04-16	602-555-5736	isaac.dominguez37@example.org	9534 W Dunlap Ave, Phoenix, AZ 85039	AZB-804515406
137	Olivia	Kim	1944-09-14	602-555-9124	olivia.kim63@example.org	2618 W Northern Ave, Phoenix, AZ 85029	SUN-790774843
138	Victor	Padilla	1967-07-23	602-555-8424	victor.padilla42@example.org	2384 W Bethany Home Rd, Phoenix, AZ 85042	AZB-773975057
139	Kaya	Morales	2017-07-30	602-555-9809	kaya.morales26@example.org	7378 W Bethany Home Rd, Phoenix, AZ 85017	CPR-243584944
140	Elijah	Jackson	2002-03-04	602-555-7690	elijah.jackson84@example.org	453 W Cactus Rd, Phoenix, AZ 85049	SUN-556535315
141	Isaac	Santos	1973-08-18	602-555-8619	isaac.santos48@example.org	4598 W Cactus Rd, Phoenix, AZ 85046	DES-891278463
142	Aaliyah	Vasquez	1994-03-07	602-555-6199	aaliyah.vasquez50@example.org	389 W Southern Ave, Phoenix, AZ 85011	CPR-162595784
143	Wren	Ortiz	1955-06-09	602-555-6123	wren.ortiz44@example.org	5500 W Dunlap Ave, Phoenix, AZ 85030	CPR-295269356
144	Nadia	Espinoza	2005-05-29	602-555-9081	nadia.espinoza88@example.org	6057 W Thomas Rd, Phoenix, AZ 85011	AZB-723014797
145	Valeria	Castillo	1985-03-19	602-555-7539	valeria.castillo29@example.org	1432 W Bethany Home Rd, Phoenix, AZ 85031	CPR-599380042
146	Samuel	Begay	1946-12-26	602-555-6368	samuel.begay91@example.org	3886 W Peoria Ave, Phoenix, AZ 85013	AZB-886244176
147	Renata	Foster	1940-05-15	602-555-6561	renata.foster5@example.org	6269 W Bethany Home Rd, Phoenix, AZ 85012	DES-420334174
148	Beatriz	Gutierrez	1961-07-09	602-555-4729	beatriz.gutierrez3@example.org	5621 W Bethany Home Rd, Phoenix, AZ 85046	DES-618584975
149	Imani	Romero	2019-05-16	602-555-7444	imani.romero77@example.org	384 W Bell Rd, Phoenix, AZ 85013	MRC-761472380
150	Mateo	Vargas	1960-05-28	602-555-7685	mateo.vargas99@example.org	4131 W Peoria Ave, Phoenix, AZ 85042	MRC-587397180
151	Miguel	Patel	1950-08-02	602-555-2052	miguel.patel51@example.org	7112 W Thomas Rd, Phoenix, AZ 85018	AZB-842214828
152	Esperanza	Silva	1974-08-05	602-555-0596	esperanza.silva65@example.org	2813 W Glendale Ave, Phoenix, AZ 85035	CPR-315826518
153	Nathan	Espinoza	2006-04-07	602-555-8272	nathan.espinoza12@example.org	7220 W Greenway Rd, Phoenix, AZ 85013	SUN-595969375
154	Renata	Espinoza	1985-07-20	602-555-6230	renata.espinoza40@example.org	8178 W Thomas Rd, Phoenix, AZ 85045	AZB-731303109
155	Victor	Ibarra	1944-01-31	602-555-8434	victor.ibarra98@example.org	7391 W Dunlap Ave, Phoenix, AZ 85010	DES-461820707
156	Esperanza	Robinson	1964-11-07	602-555-8017	esperanza.robinson88@example.org	6117 W Baseline Rd, Phoenix, AZ 85020	MRC-689748053
157	Wren	Ortiz	1976-12-22	602-555-5723	wren.ortiz49@example.org	3190 W Thomas Rd, Phoenix, AZ 85047	MRC-400469051
158	Dolores	Yazzie	1953-02-06	602-555-9572	dolores.yazzie2@example.org	4658 W Baseline Rd, Phoenix, AZ 85046	CPR-673043625
159	Felix	Begay	2012-01-24	602-555-6422	felix.begay44@example.org	5117 W Glendale Ave, Phoenix, AZ 85011	CPR-901746841
160	Adrian	Dominguez	2005-03-08	602-555-7888	adrian.dominguez23@example.org	643 W Bell Rd, Phoenix, AZ 85011	SUN-599019502
161	Marcus	Chen	2015-01-21	602-555-4269	marcus.chen21@example.org	9178 W Camelback Rd, Phoenix, AZ 85038	AZB-930449783
162	Tanya	Lopez	1946-03-22	602-555-8363	tanya.lopez9@example.org	3904 W Greenway Rd, Phoenix, AZ 85047	DES-202532525
163	Felix	Flores	2017-07-30	602-555-7878	felix.flores28@example.org	7214 W Bethany Home Rd, Phoenix, AZ 85019	DES-949887491
164	Zoe	Hernandez	1969-01-06	602-555-5563	zoe.hernandez43@example.org	7688 W Greenway Rd, Phoenix, AZ 85021	MRC-965815909
165	Samuel	Salazar	1971-02-27	602-555-4959	samuel.salazar49@example.org	6087 W Union Hills Dr, Phoenix, AZ 85012	DES-135259523
166	Rafael	Washington	1964-10-09	602-555-6194	rafael.washington52@example.org	5124 W Peoria Ave, Phoenix, AZ 85035	AZB-509943893
167	Xavier	Valdez	1941-12-20	602-555-9243	xavier.valdez69@example.org	6984 W Union Hills Dr, Phoenix, AZ 85043	AZB-878405418
168	Yara	Washington	2009-10-23	602-555-7943	yara.washington6@example.org	1746 W McDowell Rd, Phoenix, AZ 85036	MRC-831115183
169	Kaya	Ibarra	1971-05-02	602-555-4082	kaya.ibarra31@example.org	3971 W Indian School Rd, Phoenix, AZ 85023	MRC-173524172
170	Andre	Garcia	1979-09-15	602-555-5587	andre.garcia64@example.org	3471 W Southern Ave, Phoenix, AZ 85036	AZB-613240613
171	Serena	Hernandez	1999-10-10	602-555-6934	serena.hernandez14@example.org	3150 W Union Hills Dr, Phoenix, AZ 85047	CPR-827409657
172	Paloma	Bennett	1941-01-18	602-555-6231	paloma.bennett28@example.org	3271 W Indian School Rd, Phoenix, AZ 85040	DES-998997124
173	Yusuf	Vasquez	1993-03-03	602-555-5718	yusuf.vasquez60@example.org	9797 W Dunlap Ave, Phoenix, AZ 85023	SUN-983468765
174	Zoe	Acosta	1956-07-05	602-555-8217	zoe.acosta21@example.org	121 W Baseline Rd, Phoenix, AZ 85016	MRC-943866365
175	Valeria	Lopez	2001-12-02	602-555-3845	valeria.lopez39@example.org	2820 W Indian School Rd, Phoenix, AZ 85044	CPR-541068839
176	Aaliyah	Valdez	2004-02-21	602-555-0559	aaliyah.valdez60@example.org	4568 W Dunlap Ave, Phoenix, AZ 85031	SUN-922238623
177	Noor	Nguyen	1966-11-30	602-555-5632	noor.nguyen44@example.org	139 W Indian School Rd, Phoenix, AZ 85042	DES-469675729
178	Jonah	Flores	2020-07-03	602-555-4300	jonah.flores98@example.org	824 W Union Hills Dr, Phoenix, AZ 85030	SUN-390154441
179	Carlos	Ibarra	2002-09-15	602-555-6195	carlos.ibarra3@example.org	6943 W Glendale Ave, Phoenix, AZ 85015	DES-121128519
180	Nathan	Gomez	1988-03-11	602-555-7229	nathan.gomez79@example.org	6818 W McDowell Rd, Phoenix, AZ 85047	AZB-786263914
181	Andre	Ramirez	2003-01-27	602-555-0946	andre.ramirez78@example.org	1712 W Camelback Rd, Phoenix, AZ 85037	MRC-420263501
182	Diego	Yazzie	1943-01-03	602-555-7754	diego.yazzie7@example.org	9822 W Peoria Ave, Phoenix, AZ 85025	DES-290747955
183	Rosa	Garcia	1986-04-18	602-555-4181	rosa.garcia2@example.org	138 W Greenway Rd, Phoenix, AZ 85049	CPR-252744096
184	Marcus	Espinoza	1972-03-24	602-555-8664	marcus.espinoza96@example.org	6848 W Camelback Rd, Phoenix, AZ 85031	CPR-839568195
185	Valeria	Ramirez	1988-05-12	602-555-0931	valeria.ramirez34@example.org	3066 W Cactus Rd, Phoenix, AZ 85027	MRC-989349431
186	Kenji	Vargas	2015-02-14	602-555-6098	kenji.vargas51@example.org	2194 W Dunlap Ave, Phoenix, AZ 85048	AZB-515186436
187	Gabriela	Flores	2005-04-02	602-555-2630	gabriela.flores47@example.org	2597 W Greenway Rd, Phoenix, AZ 85046	AZB-917072618
188	Mateo	Ramirez	1975-01-29	602-555-1735	mateo.ramirez64@example.org	9877 W Camelback Rd, Phoenix, AZ 85014	SUN-351325795
189	Celeste	Velasquez	2021-05-08	602-555-6781	celeste.velasquez46@example.org	3753 W Glendale Ave, Phoenix, AZ 85015	AZB-398364874
190	Javier	Kim	1973-02-23	602-555-6627	javier.kim60@example.org	4859 W Union Hills Dr, Phoenix, AZ 85043	SUN-125998725
191	Tomas	Mendoza	2020-07-25	602-555-9855	tomas.mendoza49@example.org	4408 W Camelback Rd, Phoenix, AZ 85025	AZB-133005814
192	Felix	Vargas	1976-07-21	602-555-0203	felix.vargas63@example.org	5627 W Peoria Ave, Phoenix, AZ 85036	SUN-998393240
193	Gabriela	Gomez	1973-06-30	602-555-7148	gabriela.gomez90@example.org	5181 W Baseline Rd, Phoenix, AZ 85036	MRC-797523842
194	Gabriela	Hernandez	1954-09-26	602-555-2731	gabriela.hernandez70@example.org	3284 W Bethany Home Rd, Phoenix, AZ 85044	AZB-454066383
195	Gavin	Martinez	2009-09-11	602-555-6253	gavin.martinez67@example.org	8815 W Northern Ave, Phoenix, AZ 85041	CPR-450109378
196	Ana	Hernandez	2014-10-25	602-555-6210	ana.hernandez16@example.org	2479 W Bell Rd, Phoenix, AZ 85012	CPR-282125842
197	Jonah	Cruz	1978-11-16	602-555-4240	jonah.cruz64@example.org	9446 W Glendale Ave, Phoenix, AZ 85032	AZB-839862403
198	Marcus	Padilla	1995-04-24	602-555-8829	marcus.padilla72@example.org	1741 W Thunderbird Rd, Phoenix, AZ 85030	MRC-374654882
199	Leon	Begay	1950-02-20	602-555-9476	leon.begay96@example.org	3696 W Greenway Rd, Phoenix, AZ 85051	DES-804411169
200	Beatriz	Rivera	2006-05-20	602-555-9091	beatriz.rivera65@example.org	8028 W McDowell Rd, Phoenix, AZ 85024	DES-739534180
201	Yara	Dominguez	1967-05-20	602-555-3387	yara.dominguez73@example.org	3772 W Thomas Rd, Phoenix, AZ 85020	AZB-109622370
202	Ana	Ibarra	2012-10-15	602-555-2621	ana.ibarra33@example.org	7881 W Bethany Home Rd, Phoenix, AZ 85012	AZB-204817160
203	Javier	Rivera	1969-06-24	602-555-5191	javier.rivera41@example.org	1254 W Glendale Ave, Phoenix, AZ 85037	MRC-140066187
204	Renata	Williams	2001-12-15	602-555-1104	renata.williams37@example.org	2047 W Southern Ave, Phoenix, AZ 85015	CPR-234190877
205	Rosa	Ramirez	1986-12-28	602-555-6995	rosa.ramirez58@example.org	3653 W Cactus Rd, Phoenix, AZ 85031	MRC-768810914
206	Esperanza	Reyes	1968-09-02	602-555-4657	esperanza.reyes66@example.org	2922 W Thomas Rd, Phoenix, AZ 85014	CPR-149035885
207	Hana	Hernandez	1941-03-22	602-555-1051	hana.hernandez8@example.org	213 W Indian School Rd, Phoenix, AZ 85024	AZB-846599294
208	Uriel	Ortiz	1983-12-10	602-555-2585	uriel.ortiz10@example.org	3991 W Northern Ave, Phoenix, AZ 85022	MRC-699943814
209	Nadia	Castillo	1970-06-06	602-555-1578	nadia.castillo18@example.org	9312 W Union Hills Dr, Phoenix, AZ 85041	DES-491170771
210	Zoe	Mendoza	1987-08-05	602-555-1229	zoe.mendoza98@example.org	9153 W Bethany Home Rd, Phoenix, AZ 85041	MRC-451754728
211	Daniel	Young	1995-03-14	602-555-1232	daniel.young66@example.org	9629 W McDowell Rd, Phoenix, AZ 85045	AZB-673445659
212	Daniel	Velasquez	2016-10-27	602-555-3580	daniel.velasquez38@example.org	4827 W Camelback Rd, Phoenix, AZ 85034	MRC-137247870
213	Victor	Dominguez	1958-09-26	602-555-3306	victor.dominguez42@example.org	6261 W Glendale Ave, Phoenix, AZ 85046	CPR-529231648
214	Javier	Flores	1992-09-26	602-555-6599	javier.flores96@example.org	5730 W Indian School Rd, Phoenix, AZ 85046	SUN-363842959
215	Aaliyah	Reyes	1945-05-20	602-555-4348	aaliyah.reyes12@example.org	1709 W Southern Ave, Phoenix, AZ 85032	CPR-257111404
216	Carlos	Washington	1980-07-15	602-555-9159	carlos.washington18@example.org	9136 W Thunderbird Rd, Phoenix, AZ 85014	CPR-220985742
217	Olivia	Delgado	1972-12-14	602-555-3008	olivia.delgado76@example.org	5377 W Thunderbird Rd, Phoenix, AZ 85013	AZB-983190676
218	Leon	Singh	1991-11-03	602-555-8058	leon.singh60@example.org	5119 W Glendale Ave, Phoenix, AZ 85047	AZB-927160630
219	Tomas	Ibarra	1949-09-30	602-555-3059	tomas.ibarra87@example.org	1381 W Thunderbird Rd, Phoenix, AZ 85035	MRC-150546292
220	Diego	Tsosie	2010-01-29	602-555-8136	diego.tsosie63@example.org	3834 W Union Hills Dr, Phoenix, AZ 85027	CPR-753757234
221	Nathan	Chavez	1975-11-17	602-555-3519	nathan.chavez99@example.org	9822 W Dunlap Ave, Phoenix, AZ 85029	CPR-468419638
222	Sebastian	Vasquez	1940-07-04	602-555-1670	sebastian.vasquez56@example.org	6588 W Dunlap Ave, Phoenix, AZ 85043	SUN-150927831
223	Celeste	Vargas	2008-04-21	602-555-8801	celeste.vargas80@example.org	5998 W Dunlap Ave, Phoenix, AZ 85044	DES-386786540
224	Samuel	Jimenez	1988-05-03	602-555-5378	samuel.jimenez73@example.org	8139 W Thomas Rd, Phoenix, AZ 85035	CPR-373658106
225	Rafael	Kim	1966-05-07	602-555-6226	rafael.kim93@example.org	6377 W Thomas Rd, Phoenix, AZ 85010	SUN-821372317
226	Lena	Lopez	1951-11-25	602-555-1265	lena.lopez68@example.org	9954 W Thomas Rd, Phoenix, AZ 85039	MRC-765536652
227	Noor	Rivera	1956-10-08	602-555-9645	noor.rivera51@example.org	9674 W Greenway Rd, Phoenix, AZ 85020	DES-313886190
228	Gabriela	Silva	1999-04-10	602-555-8302	gabriela.silva51@example.org	8189 W Union Hills Dr, Phoenix, AZ 85012	MRC-617304200
229	Sebastian	Foster	1997-03-10	602-555-0031	sebastian.foster72@example.org	5137 W Baseline Rd, Phoenix, AZ 85050	AZB-784010481
230	Diego	Begay	1994-08-27	602-555-9247	diego.begay51@example.org	4769 W Camelback Rd, Phoenix, AZ 85045	MRC-976693394
231	Aaliyah	Sanchez	1981-01-06	602-555-0695	aaliyah.sanchez73@example.org	2335 W Northern Ave, Phoenix, AZ 85014	SUN-942422180
232	Kaya	Hernandez	1953-09-04	602-555-3862	kaya.hernandez14@example.org	9680 W Bethany Home Rd, Phoenix, AZ 85020	AZB-171352548
233	Celeste	Chen	1945-12-02	602-555-0567	celeste.chen97@example.org	297 W Cactus Rd, Phoenix, AZ 85017	AZB-802459405
234	Javier	Tsosie	1986-10-25	602-555-3651	javier.tsosie2@example.org	4434 W Thunderbird Rd, Phoenix, AZ 85032	DES-762862780
235	Hector	Acosta	1969-01-31	602-555-9111	hector.acosta29@example.org	1360 W Thomas Rd, Phoenix, AZ 85012	CPR-841793441
236	Nathan	Bennett	2020-01-13	602-555-1149	nathan.bennett92@example.org	9659 W McDowell Rd, Phoenix, AZ 85046	CPR-520044009
237	Isaac	Flores	1961-07-31	602-555-2606	isaac.flores12@example.org	6241 W Cactus Rd, Phoenix, AZ 85032	MRC-654599933
238	Jonah	Valdez	1981-09-05	602-555-9908	jonah.valdez68@example.org	1966 W McDowell Rd, Phoenix, AZ 85011	AZB-416127481
239	Serena	Jimenez	1966-10-27	602-555-0437	serena.jimenez49@example.org	8318 W Camelback Rd, Phoenix, AZ 85019	MRC-413181670
240	Kaya	Begay	1975-09-16	602-555-7182	kaya.begay18@example.org	9142 W Indian School Rd, Phoenix, AZ 85034	AZB-194698428
241	Valeria	Torres	1979-09-29	602-555-4757	valeria.torres23@example.org	8168 W Baseline Rd, Phoenix, AZ 85036	DES-763835968
242	Xavier	Garcia	1994-08-08	602-555-9423	xavier.garcia95@example.org	5245 W Peoria Ave, Phoenix, AZ 85048	CPR-660240156
243	Samuel	Chavez	1977-02-05	602-555-2355	samuel.chavez85@example.org	8087 W Greenway Rd, Phoenix, AZ 85020	CPR-166452145
244	Miguel	Begay	1957-10-26	602-555-9842	miguel.begay3@example.org	3242 W Cactus Rd, Phoenix, AZ 85016	MRC-690240918
245	Owen	Jimenez	1998-03-12	602-555-2104	owen.jimenez43@example.org	6564 W Thunderbird Rd, Phoenix, AZ 85033	SUN-620087763
246	Yusuf	Salazar	1941-12-22	602-555-7093	yusuf.salazar47@example.org	6675 W Greenway Rd, Phoenix, AZ 85039	CPR-945690800
247	Miguel	Romero	1991-02-19	602-555-4715	miguel.romero79@example.org	4716 W Thomas Rd, Phoenix, AZ 85038	MRC-404952417
248	Benjamin	Chavez	1965-08-23	602-555-8023	benjamin.chavez24@example.org	6864 W Northern Ave, Phoenix, AZ 85035	AZB-967085389
249	Tomas	Romero	1989-03-26	602-555-2162	tomas.romero20@example.org	7149 W Camelback Rd, Phoenix, AZ 85013	SUN-395106901
250	Gavin	Perez	1960-09-15	602-555-4041	gavin.perez14@example.org	948 W Thomas Rd, Phoenix, AZ 85032	AZB-604012575
251	Benjamin	Romero	2009-12-18	602-555-1802	benjamin.romero82@example.org	5602 W Peoria Ave, Phoenix, AZ 85032	MRC-212830028
252	Uriel	Romero	1944-04-11	602-555-0675	uriel.romero21@example.org	2949 W Union Hills Dr, Phoenix, AZ 85035	AZB-802513660
253	Talia	Chen	2004-08-20	602-555-7149	talia.chen94@example.org	9272 W Union Hills Dr, Phoenix, AZ 85018	AZB-149840968
254	Nia	Flores	1980-02-24	602-555-4248	nia.flores42@example.org	2323 W Indian School Rd, Phoenix, AZ 85032	DES-514379615
255	Samuel	Torres	2013-04-22	602-555-4637	samuel.torres60@example.org	9272 W Glendale Ave, Phoenix, AZ 85046	SUN-955700679
256	Yara	Jackson	1987-02-22	602-555-8343	yara.jackson61@example.org	7339 W Indian School Rd, Phoenix, AZ 85034	MRC-404486085
257	Uriel	Ortiz	1994-05-05	602-555-1715	uriel.ortiz11@example.org	4974 W Thunderbird Rd, Phoenix, AZ 85020	MRC-338833775
258	Alma	Tsosie	1957-04-23	602-555-5086	alma.tsosie41@example.org	5528 W Greenway Rd, Phoenix, AZ 85027	DES-198795653
259	Olivia	Martinez	1948-12-06	602-555-0831	olivia.martinez47@example.org	7094 W Peoria Ave, Phoenix, AZ 85022	CPR-220420437
260	Alma	Martinez	2011-05-02	602-555-4841	alma.martinez32@example.org	2557 W Glendale Ave, Phoenix, AZ 85039	CPR-850212792
261	Diego	Garcia	1948-09-17	602-555-9391	diego.garcia92@example.org	8949 W Baseline Rd, Phoenix, AZ 85020	AZB-181703240
262	Esperanza	Acosta	1975-11-30	602-555-9362	esperanza.acosta31@example.org	8843 W Northern Ave, Phoenix, AZ 85019	SUN-332211328
263	Paloma	Cruz	1979-10-08	602-555-9037	paloma.cruz27@example.org	5451 W Glendale Ave, Phoenix, AZ 85015	MRC-138486938
264	Paloma	Chen	1972-03-19	602-555-1703	paloma.chen53@example.org	886 W Glendale Ave, Phoenix, AZ 85011	SUN-548195503
265	Leon	Washington	1952-11-02	602-555-4466	leon.washington40@example.org	9572 W Baseline Rd, Phoenix, AZ 85036	CPR-360561183
266	Daniel	Kim	1971-05-27	602-555-9778	daniel.kim47@example.org	6096 W Glendale Ave, Phoenix, AZ 85044	MRC-801998482
267	Esperanza	Jackson	1941-04-19	602-555-5588	esperanza.jackson89@example.org	7271 W Bell Rd, Phoenix, AZ 85048	AZB-781780539
268	Rafael	Kim	1960-08-06	602-555-9527	rafael.kim62@example.org	9879 W Bell Rd, Phoenix, AZ 85023	AZB-614458509
269	Daniel	Morales	1997-03-30	602-555-2202	daniel.morales28@example.org	8413 W Peoria Ave, Phoenix, AZ 85034	MRC-279611330
270	Jonah	Chavez	1957-06-19	602-555-9826	jonah.chavez36@example.org	4592 W Peoria Ave, Phoenix, AZ 85032	AZB-194351224
271	Benjamin	Acosta	1962-04-14	602-555-9238	benjamin.acosta82@example.org	7213 W Thunderbird Rd, Phoenix, AZ 85014	AZB-511416394
272	Gabriela	Ortiz	1949-06-02	602-555-1924	gabriela.ortiz56@example.org	2294 W Bethany Home Rd, Phoenix, AZ 85050	SUN-507500012
273	Renata	Salazar	2007-09-25	602-555-5495	renata.salazar57@example.org	3157 W Southern Ave, Phoenix, AZ 85046	MRC-383316287
274	Esperanza	Valdez	2013-01-28	602-555-5656	esperanza.valdez93@example.org	7215 W Bethany Home Rd, Phoenix, AZ 85039	SUN-674516916
275	Zoe	Morales	1987-08-18	602-555-3054	zoe.morales34@example.org	5452 W Baseline Rd, Phoenix, AZ 85036	DES-423374356
276	Sebastian	Young	2017-09-13	602-555-7160	sebastian.young15@example.org	1145 W Cactus Rd, Phoenix, AZ 85029	MRC-123567283
277	Jonah	Espinoza	1952-07-07	602-555-8771	jonah.espinoza99@example.org	7794 W Peoria Ave, Phoenix, AZ 85042	MRC-655790371
278	Zoe	Velasquez	1950-12-18	602-555-4049	zoe.velasquez27@example.org	7492 W Bell Rd, Phoenix, AZ 85043	MRC-938880638
279	Renata	Dominguez	2011-12-26	602-555-6626	renata.dominguez20@example.org	3082 W Dunlap Ave, Phoenix, AZ 85044	AZB-137503998
280	Esperanza	Lopez	1975-10-29	602-555-0668	esperanza.lopez71@example.org	5224 W Greenway Rd, Phoenix, AZ 85019	CPR-188812751
281	Isaac	Foster	2005-07-22	602-555-7868	isaac.foster26@example.org	2756 W Northern Ave, Phoenix, AZ 85041	CPR-329008247
282	Beatriz	Torres	1968-08-03	602-555-5073	beatriz.torres81@example.org	8241 W Baseline Rd, Phoenix, AZ 85049	DES-312903695
283	Olivia	Medina	1998-07-16	602-555-7415	olivia.medina99@example.org	4977 W Camelback Rd, Phoenix, AZ 85021	SUN-628744852
284	Javier	Ramirez	1940-01-10	602-555-1180	javier.ramirez90@example.org	5164 W McDowell Rd, Phoenix, AZ 85036	DES-169374741
285	Lucia	Patel	1962-04-06	602-555-7271	lucia.patel44@example.org	3459 W Southern Ave, Phoenix, AZ 85046	MRC-116086844
286	Jonah	Castillo	1983-01-21	602-555-5578	jonah.castillo40@example.org	5953 W McDowell Rd, Phoenix, AZ 85051	SUN-430717436
287	Alma	Sanchez	1956-11-04	602-555-1968	alma.sanchez79@example.org	2592 W Bell Rd, Phoenix, AZ 85046	CPR-532847302
288	Zoe	Robinson	1996-01-11	602-555-0157	zoe.robinson90@example.org	3273 W Peoria Ave, Phoenix, AZ 85026	CPR-647162249
289	Adrian	Bennett	2000-02-07	602-555-0882	adrian.bennett7@example.org	610 W Camelback Rd, Phoenix, AZ 85027	DES-956104378
290	Alma	Cruz	2003-01-17	602-555-0964	alma.cruz99@example.org	4823 W Bell Rd, Phoenix, AZ 85025	SUN-360380732
291	Rosa	Salazar	1961-05-19	602-555-6328	rosa.salazar53@example.org	3232 W Southern Ave, Phoenix, AZ 85030	CPR-883766297
292	Carla	Singh	1987-03-19	602-555-1961	carla.singh52@example.org	9237 W Bethany Home Rd, Phoenix, AZ 85046	CPR-594043602
293	Talia	Jimenez	1972-04-11	602-555-1998	talia.jimenez96@example.org	1497 W Camelback Rd, Phoenix, AZ 85032	DES-653487209
294	Yara	Ramirez	1993-03-20	602-555-4169	yara.ramirez98@example.org	3380 W Dunlap Ave, Phoenix, AZ 85031	CPR-968988545
295	Imani	Delgado	1992-06-11	602-555-7340	imani.delgado58@example.org	5502 W Cactus Rd, Phoenix, AZ 85022	AZB-104714809
296	Wren	Acosta	1967-12-02	602-555-5463	wren.acosta17@example.org	6510 W Cactus Rd, Phoenix, AZ 85017	DES-670395235
297	Gavin	Santos	1958-05-02	602-555-6196	gavin.santos56@example.org	9544 W McDowell Rd, Phoenix, AZ 85037	AZB-564113595
298	Javier	Flores	2004-08-31	602-555-6963	javier.flores54@example.org	3774 W Bethany Home Rd, Phoenix, AZ 85021	MRC-326346840
299	Nathan	Acosta	1959-09-15	602-555-6637	nathan.acosta15@example.org	4579 W Indian School Rd, Phoenix, AZ 85032	CPR-654828458
300	Ana	Velasquez	1953-01-03	602-555-6848	ana.velasquez3@example.org	4491 W Peoria Ave, Phoenix, AZ 85037	AZB-272896490
301	Nia	Chen	1974-01-17	602-555-8194	nia.chen9@example.org	5598 W Dunlap Ave, Phoenix, AZ 85031	DES-358230317
302	Felix	Valdez	1986-04-21	602-555-0556	felix.valdez35@example.org	7633 W Thomas Rd, Phoenix, AZ 85032	CPR-952587788
303	Miguel	Perez	1941-07-08	602-555-7451	miguel.perez36@example.org	6567 W Thomas Rd, Phoenix, AZ 85010	CPR-760454561
304	Alma	Singh	2005-08-17	602-555-5306	alma.singh45@example.org	2191 W Southern Ave, Phoenix, AZ 85030	MRC-596552723
305	Owen	Flores	1997-03-17	602-555-8704	owen.flores84@example.org	9354 W Bell Rd, Phoenix, AZ 85021	DES-844991491
306	Marisol	Velasquez	1997-10-13	602-555-0170	marisol.velasquez39@example.org	9212 W Thomas Rd, Phoenix, AZ 85023	AZB-609084259
307	Felix	Castillo	1977-04-18	602-555-3679	felix.castillo50@example.org	6331 W Baseline Rd, Phoenix, AZ 85035	MRC-846517539
308	Tomas	Santos	1974-08-21	602-555-5588	tomas.santos19@example.org	9989 W Thunderbird Rd, Phoenix, AZ 85043	CPR-614461402
309	Sebastian	Velasquez	1987-05-20	602-555-5022	sebastian.velasquez52@example.org	8810 W Camelback Rd, Phoenix, AZ 85049	DES-311460533
310	Victor	Yazzie	1979-08-26	602-555-3502	victor.yazzie35@example.org	8971 W Indian School Rd, Phoenix, AZ 85034	DES-465367509
311	Nia	Begay	1957-05-16	602-555-0818	nia.begay33@example.org	5797 W Camelback Rd, Phoenix, AZ 85026	MRC-467685882
312	Lucia	Ramirez	1978-04-08	602-555-8768	lucia.ramirez40@example.org	337 W Glendale Ave, Phoenix, AZ 85036	AZB-664211375
313	Carla	Santos	1960-03-13	602-555-1118	carla.santos50@example.org	630 W Baseline Rd, Phoenix, AZ 85021	SUN-895599840
314	Daniel	Yazzie	1993-11-07	602-555-3578	daniel.yazzie48@example.org	9452 W Indian School Rd, Phoenix, AZ 85043	AZB-827249488
315	Beatriz	Martinez	1990-08-04	602-555-7957	beatriz.martinez8@example.org	2533 W Peoria Ave, Phoenix, AZ 85031	SUN-267756391
316	Nia	Garcia	1996-01-25	602-555-3117	nia.garcia53@example.org	9505 W Camelback Rd, Phoenix, AZ 85036	AZB-858120803
317	Kaya	Jackson	1997-04-01	602-555-8913	kaya.jackson27@example.org	2497 W Greenway Rd, Phoenix, AZ 85037	DES-705315307
318	Omar	Garcia	1942-04-03	602-555-6813	omar.garcia59@example.org	5849 W Greenway Rd, Phoenix, AZ 85042	SUN-362658987
319	Esperanza	Silva	2000-10-11	602-555-4372	esperanza.silva89@example.org	6542 W Camelback Rd, Phoenix, AZ 85035	AZB-920155322
320	Renata	Ortiz	2006-09-11	602-555-3621	renata.ortiz21@example.org	9372 W Camelback Rd, Phoenix, AZ 85046	AZB-819061630
321	Quentin	Castillo	1993-08-21	602-555-9487	quentin.castillo82@example.org	9847 W Northern Ave, Phoenix, AZ 85043	DES-840833342
322	Alma	Ortiz	1999-07-03	602-555-3080	alma.ortiz31@example.org	8971 W Union Hills Dr, Phoenix, AZ 85013	MRC-402197456
323	Benjamin	Young	2002-12-29	602-555-8883	benjamin.young59@example.org	2949 W Dunlap Ave, Phoenix, AZ 85019	MRC-727062097
324	Benjamin	Torres	1965-09-02	602-555-5221	benjamin.torres91@example.org	4467 W Northern Ave, Phoenix, AZ 85044	CPR-922777793
325	Lena	Foster	1941-01-20	602-555-9471	lena.foster58@example.org	3584 W Thunderbird Rd, Phoenix, AZ 85035	SUN-757443209
326	Javier	Williams	1990-08-06	602-555-3991	javier.williams36@example.org	4728 W Camelback Rd, Phoenix, AZ 85049	CPR-856598009
327	Benjamin	Lopez	1988-01-26	602-555-1755	benjamin.lopez95@example.org	4458 W Glendale Ave, Phoenix, AZ 85050	CPR-569335769
328	Omar	Martinez	2021-07-14	602-555-1443	omar.martinez14@example.org	3225 W Peoria Ave, Phoenix, AZ 85045	DES-584387819
329	Kaya	Foster	2014-11-02	602-555-9551	kaya.foster85@example.org	2742 W Thomas Rd, Phoenix, AZ 85039	CPR-785799749
330	Jasmine	Young	1982-01-24	602-555-3127	jasmine.young52@example.org	9842 W Greenway Rd, Phoenix, AZ 85038	CPR-836869898
331	Gabriela	Williams	2018-04-28	602-555-9539	gabriela.williams34@example.org	4408 W Southern Ave, Phoenix, AZ 85031	CPR-409906332
332	Gavin	Hernandez	1968-09-22	602-555-0448	gavin.hernandez72@example.org	9676 W Greenway Rd, Phoenix, AZ 85013	MRC-166624329
333	Owen	Chen	1989-03-22	602-555-4193	owen.chen12@example.org	9831 W Bell Rd, Phoenix, AZ 85026	AZB-619251703
334	Yusuf	Gomez	1979-11-16	602-555-4467	yusuf.gomez87@example.org	7436 W Glendale Ave, Phoenix, AZ 85019	MRC-331475251
335	Kaya	Ortiz	2019-09-11	602-555-5819	kaya.ortiz38@example.org	4373 W Union Hills Dr, Phoenix, AZ 85048	CPR-753171761
336	Ana	Espinoza	2000-02-04	602-555-3821	ana.espinoza2@example.org	9803 W Cactus Rd, Phoenix, AZ 85028	CPR-759168984
337	Marcus	Ramirez	1996-02-11	602-555-1070	marcus.ramirez38@example.org	5938 W Union Hills Dr, Phoenix, AZ 85049	SUN-418460939
338	Javier	Ortiz	2013-11-13	602-555-8287	javier.ortiz62@example.org	7924 W Peoria Ave, Phoenix, AZ 85024	CPR-673079118
339	Dolores	Delgado	1998-02-23	602-555-2631	dolores.delgado39@example.org	9402 W Dunlap Ave, Phoenix, AZ 85012	SUN-227607375
340	Valeria	Washington	2000-07-20	602-555-5521	valeria.washington42@example.org	1917 W Southern Ave, Phoenix, AZ 85019	CPR-383098297
341	Wren	Garcia	1968-02-08	602-555-4809	wren.garcia21@example.org	6696 W Dunlap Ave, Phoenix, AZ 85025	DES-428928287
342	Leon	Patel	1966-05-25	602-555-4809	leon.patel2@example.org	2712 W Baseline Rd, Phoenix, AZ 85012	SUN-124687056
343	Yusuf	Martinez	2019-07-23	602-555-5754	yusuf.martinez52@example.org	5550 W Cactus Rd, Phoenix, AZ 85042	CPR-352359236
344	Paloma	Chen	1957-01-19	602-555-0437	paloma.chen57@example.org	8666 W Dunlap Ave, Phoenix, AZ 85027	AZB-201659891
345	Gabriela	Ortiz	2000-01-19	602-555-6619	gabriela.ortiz68@example.org	2364 W Cactus Rd, Phoenix, AZ 85050	CPR-310486585
346	Valeria	Yazzie	1971-09-26	602-555-0337	valeria.yazzie89@example.org	6752 W Baseline Rd, Phoenix, AZ 85048	CPR-220262156
347	Valeria	Garcia	2016-08-01	602-555-3419	valeria.garcia63@example.org	9987 W McDowell Rd, Phoenix, AZ 85020	SUN-633227666
348	Marcus	Espinoza	1995-11-20	602-555-8746	marcus.espinoza2@example.org	5296 W Cactus Rd, Phoenix, AZ 85024	SUN-285710404
349	Hector	Kim	1999-05-30	602-555-3288	hector.kim20@example.org	2419 W Cactus Rd, Phoenix, AZ 85025	SUN-241288637
350	Daniel	Torres	1949-07-11	602-555-8209	daniel.torres55@example.org	6420 W Southern Ave, Phoenix, AZ 85049	CPR-846364113
351	Jonah	Young	1965-10-25	602-555-6316	jonah.young8@example.org	1399 W Baseline Rd, Phoenix, AZ 85046	MRC-821897785
352	Xavier	Singh	2001-05-25	602-555-0112	xavier.singh10@example.org	7558 W Thunderbird Rd, Phoenix, AZ 85015	CPR-569364398
353	Tanya	Velasquez	1993-02-05	602-555-6431	tanya.velasquez93@example.org	3004 W Dunlap Ave, Phoenix, AZ 85051	MRC-895991331
354	Samuel	Espinoza	1941-02-16	602-555-9229	samuel.espinoza55@example.org	2417 W Dunlap Ave, Phoenix, AZ 85041	AZB-182763850
355	Alma	Reyes	1948-12-29	602-555-3704	alma.reyes76@example.org	2652 W Camelback Rd, Phoenix, AZ 85041	SUN-555561306
356	Imani	Tsosie	1951-10-14	602-555-2376	imani.tsosie42@example.org	5697 W McDowell Rd, Phoenix, AZ 85021	SUN-817053416
357	Alma	Lopez	2018-09-19	602-555-3896	alma.lopez44@example.org	1494 W Baseline Rd, Phoenix, AZ 85037	MRC-308280656
358	Wren	Jimenez	2001-08-05	602-555-9748	wren.jimenez96@example.org	1796 W Glendale Ave, Phoenix, AZ 85011	CPR-435057879
359	Benjamin	Patel	1982-03-01	602-555-0984	benjamin.patel33@example.org	717 W Glendale Ave, Phoenix, AZ 85021	MRC-515840205
360	Omar	Hernandez	1977-05-03	602-555-3230	omar.hernandez95@example.org	356 W Dunlap Ave, Phoenix, AZ 85050	SUN-854741433
361	Olivia	Yazzie	1970-05-13	602-555-6545	olivia.yazzie42@example.org	6965 W Indian School Rd, Phoenix, AZ 85037	CPR-541919682
362	Nathan	Rivera	1987-11-15	602-555-8118	nathan.rivera11@example.org	5832 W Thomas Rd, Phoenix, AZ 85030	SUN-354222794
363	Lena	Washington	1986-04-06	602-555-7503	lena.washington27@example.org	1839 W Southern Ave, Phoenix, AZ 85018	DES-240740392
364	Renata	Padilla	1981-09-14	602-555-7735	renata.padilla82@example.org	7434 W Glendale Ave, Phoenix, AZ 85013	CPR-104544797
365	Daniel	Foster	2007-07-22	602-555-2595	daniel.foster6@example.org	4033 W Thunderbird Rd, Phoenix, AZ 85016	CPR-616770266
366	Celeste	Gutierrez	1991-08-08	602-555-3572	celeste.gutierrez82@example.org	712 W Dunlap Ave, Phoenix, AZ 85046	CPR-540046330
367	Javier	Delgado	2011-12-30	602-555-1901	javier.delgado28@example.org	2821 W Cactus Rd, Phoenix, AZ 85019	DES-505633115
368	Beatriz	Kim	1992-02-10	602-555-1544	beatriz.kim23@example.org	6402 W McDowell Rd, Phoenix, AZ 85045	CPR-624880217
369	Zoe	Ibarra	2000-01-08	602-555-7581	zoe.ibarra23@example.org	8972 W Indian School Rd, Phoenix, AZ 85040	DES-942218058
370	Aaliyah	Mendoza	1989-09-04	602-555-2184	aaliyah.mendoza66@example.org	6966 W Cactus Rd, Phoenix, AZ 85041	MRC-251018970
371	Samuel	Mendoza	1950-01-02	602-555-7856	samuel.mendoza26@example.org	8095 W Bethany Home Rd, Phoenix, AZ 85041	AZB-710038451
372	Lena	Ibarra	1950-05-17	602-555-2828	lena.ibarra15@example.org	6623 W Indian School Rd, Phoenix, AZ 85024	DES-167538678
373	Mateo	Medina	1951-04-09	602-555-6686	mateo.medina38@example.org	9860 W Thomas Rd, Phoenix, AZ 85026	DES-685896577
374	Renata	Delgado	1964-10-12	602-555-9675	renata.delgado13@example.org	5030 W Glendale Ave, Phoenix, AZ 85026	MRC-994815511
375	Victor	Torres	1995-02-07	602-555-3325	victor.torres95@example.org	7963 W Indian School Rd, Phoenix, AZ 85040	SUN-345665812
376	Leon	Dominguez	1945-08-23	602-555-9318	leon.dominguez17@example.org	3063 W Cactus Rd, Phoenix, AZ 85050	SUN-436359594
377	Talia	Salazar	2002-05-28	602-555-7045	talia.salazar88@example.org	9872 W McDowell Rd, Phoenix, AZ 85011	AZB-419056403
378	Nia	Velasquez	1981-04-23	602-555-4304	nia.velasquez72@example.org	5966 W Northern Ave, Phoenix, AZ 85012	CPR-265862959
379	Talia	Gomez	1987-10-19	602-555-4961	talia.gomez23@example.org	2113 W Thunderbird Rd, Phoenix, AZ 85010	CPR-829638594
380	Victor	Romero	1999-03-12	602-555-0054	victor.romero89@example.org	5241 W Peoria Ave, Phoenix, AZ 85037	DES-618707277
381	Lucia	Torres	1969-05-15	602-555-9697	lucia.torres13@example.org	6851 W Camelback Rd, Phoenix, AZ 85041	SUN-650038391
382	Nathan	Flores	2012-11-24	602-555-5870	nathan.flores24@example.org	1755 W Thomas Rd, Phoenix, AZ 85039	CPR-246666611
383	Marcus	Romero	1973-12-25	602-555-0039	marcus.romero44@example.org	7310 W Indian School Rd, Phoenix, AZ 85022	MRC-180031540
384	Noor	Singh	1971-02-24	602-555-2777	noor.singh7@example.org	9524 W Camelback Rd, Phoenix, AZ 85018	SUN-318505478
385	Marisol	Robinson	1970-02-11	602-555-2033	marisol.robinson95@example.org	5409 W McDowell Rd, Phoenix, AZ 85023	MRC-901080432
386	Andre	Perez	1959-03-21	602-555-1169	andre.perez6@example.org	979 W Camelback Rd, Phoenix, AZ 85012	AZB-863626147
387	Gavin	Morales	1986-08-23	602-555-0031	gavin.morales92@example.org	7160 W Thunderbird Rd, Phoenix, AZ 85043	DES-715245648
388	Yara	Salazar	1999-03-18	602-555-5074	yara.salazar89@example.org	7001 W Baseline Rd, Phoenix, AZ 85041	DES-585205542
389	Nadia	Hernandez	1992-12-21	602-555-1452	nadia.hernandez86@example.org	621 W Thunderbird Rd, Phoenix, AZ 85051	MRC-950167847
390	Nathan	Medina	2018-12-26	602-555-3015	nathan.medina93@example.org	5723 W Thunderbird Rd, Phoenix, AZ 85020	AZB-637412008
391	Ana	Morales	1992-12-03	602-555-0834	ana.morales94@example.org	4189 W Union Hills Dr, Phoenix, AZ 85019	MRC-336899505
392	Quentin	Kim	2017-10-02	602-555-9759	quentin.kim55@example.org	4668 W McDowell Rd, Phoenix, AZ 85039	AZB-746284157
393	Leon	Romero	2004-10-15	602-555-3711	leon.romero4@example.org	9327 W Thomas Rd, Phoenix, AZ 85016	MRC-511071846
394	Elijah	Romero	1956-06-26	602-555-7871	elijah.romero69@example.org	828 W Camelback Rd, Phoenix, AZ 85033	SUN-883470482
395	Beatriz	Hernandez	1945-08-30	602-555-2464	beatriz.hernandez36@example.org	7150 W Baseline Rd, Phoenix, AZ 85018	DES-766389722
396	Hector	Lopez	1990-01-06	602-555-6508	hector.lopez99@example.org	8334 W Bethany Home Rd, Phoenix, AZ 85038	SUN-598639499
397	Hana	Lopez	1943-03-30	602-555-3298	hana.lopez97@example.org	1692 W Camelback Rd, Phoenix, AZ 85045	AZB-214069351
398	Lena	Sanchez	2002-02-18	602-555-8778	lena.sanchez6@example.org	3946 W Southern Ave, Phoenix, AZ 85022	MRC-640439587
399	Xavier	Espinoza	1980-10-04	602-555-6419	xavier.espinoza89@example.org	3281 W Southern Ave, Phoenix, AZ 85013	MRC-520461657
400	Sebastian	Valdez	1983-10-13	602-555-7575	sebastian.valdez37@example.org	1759 W Camelback Rd, Phoenix, AZ 85034	MRC-940283074
401	Diego	Perez	1961-07-24	602-555-8674	diego.perez99@example.org	3943 W Dunlap Ave, Phoenix, AZ 85021	SUN-159509103
402	Nia	Begay	1976-09-23	602-555-5497	nia.begay76@example.org	9724 W Glendale Ave, Phoenix, AZ 85032	MRC-638985054
403	Lucia	Morales	2008-05-18	602-555-6752	lucia.morales27@example.org	4105 W Glendale Ave, Phoenix, AZ 85039	MRC-520978633
404	Carlos	Martinez	2014-12-20	602-555-1050	carlos.martinez4@example.org	1831 W Indian School Rd, Phoenix, AZ 85032	CPR-848426958
405	Hector	Young	2019-04-22	602-555-9722	hector.young30@example.org	5056 W Thunderbird Rd, Phoenix, AZ 85021	MRC-967629248
406	Kenji	Jimenez	2021-02-18	602-555-5565	kenji.jimenez2@example.org	3252 W Cactus Rd, Phoenix, AZ 85013	MRC-662818849
407	Renata	Washington	1981-02-07	602-555-5115	renata.washington71@example.org	1342 W Indian School Rd, Phoenix, AZ 85046	DES-527524047
408	Omar	Sanchez	1985-11-02	602-555-6053	omar.sanchez38@example.org	1863 W Baseline Rd, Phoenix, AZ 85045	AZB-733724694
409	Jonah	Washington	2000-09-03	602-555-3698	jonah.washington44@example.org	4033 W Indian School Rd, Phoenix, AZ 85043	AZB-643389367
410	Samuel	Ortiz	1983-05-17	602-555-4016	samuel.ortiz55@example.org	3939 W Indian School Rd, Phoenix, AZ 85049	MRC-552796069
411	Ana	Ramirez	1943-08-23	602-555-8506	ana.ramirez90@example.org	8461 W Thunderbird Rd, Phoenix, AZ 85015	CPR-907422229
412	Rosa	Padilla	1975-03-23	602-555-3245	rosa.padilla47@example.org	2274 W Bethany Home Rd, Phoenix, AZ 85018	CPR-507430238
413	Tomas	Jackson	1981-07-11	602-555-6694	tomas.jackson79@example.org	4607 W Dunlap Ave, Phoenix, AZ 85041	SUN-636592811
414	Nathan	Kim	2006-06-13	602-555-7867	nathan.kim10@example.org	1701 W Thomas Rd, Phoenix, AZ 85019	SUN-816880549
415	Felix	Jimenez	2004-01-20	602-555-2403	felix.jimenez58@example.org	8292 W Northern Ave, Phoenix, AZ 85035	CPR-781330512
416	Valeria	Santos	1989-09-18	602-555-2223	valeria.santos67@example.org	3524 W Thunderbird Rd, Phoenix, AZ 85050	SUN-396602716
417	Serena	Sanchez	2008-04-19	602-555-2183	serena.sanchez71@example.org	2132 W Union Hills Dr, Phoenix, AZ 85051	MRC-268633632
418	Yusuf	Silva	1995-07-25	602-555-9745	yusuf.silva29@example.org	4577 W Northern Ave, Phoenix, AZ 85050	MRC-855499405
419	Tanya	Chavez	2008-03-27	602-555-7904	tanya.chavez4@example.org	3741 W Thunderbird Rd, Phoenix, AZ 85014	SUN-904895334
420	Lena	Bennett	1953-08-19	602-555-2860	lena.bennett93@example.org	7362 W Peoria Ave, Phoenix, AZ 85020	DES-924155850
421	Adrian	Lopez	1999-11-22	602-555-3356	adrian.lopez3@example.org	1094 W Baseline Rd, Phoenix, AZ 85045	MRC-596044301
422	Renata	Velasquez	1961-06-06	602-555-8098	renata.velasquez80@example.org	8416 W Peoria Ave, Phoenix, AZ 85019	CPR-925086139
423	Isaac	Washington	1994-10-12	602-555-1539	isaac.washington9@example.org	3233 W Dunlap Ave, Phoenix, AZ 85036	CPR-280058363
424	Xavier	Lopez	1984-05-21	602-555-8906	xavier.lopez28@example.org	6334 W Northern Ave, Phoenix, AZ 85043	MRC-860807178
425	Samuel	Morales	2014-11-23	602-555-1300	samuel.morales18@example.org	4259 W Baseline Rd, Phoenix, AZ 85032	CPR-972327174
426	Rafael	Bennett	2016-04-15	602-555-0517	rafael.bennett99@example.org	9489 W Greenway Rd, Phoenix, AZ 85026	SUN-893497288
427	Wren	Ramirez	1941-01-01	602-555-7975	wren.ramirez18@example.org	7889 W Peoria Ave, Phoenix, AZ 85040	AZB-570531669
428	Esperanza	Perez	1946-10-09	602-555-8136	esperanza.perez49@example.org	7194 W Dunlap Ave, Phoenix, AZ 85025	SUN-446236277
429	Isaac	Romero	1982-12-11	602-555-7548	isaac.romero57@example.org	2897 W Union Hills Dr, Phoenix, AZ 85044	SUN-227984292
430	Javier	Salazar	1967-07-13	602-555-4734	javier.salazar26@example.org	5816 W Glendale Ave, Phoenix, AZ 85026	CPR-292618403
431	Paloma	Romero	2014-11-24	602-555-6783	paloma.romero85@example.org	6057 W Indian School Rd, Phoenix, AZ 85025	MRC-217259331
432	Ana	Salazar	1945-07-11	602-555-0024	ana.salazar18@example.org	4306 W Union Hills Dr, Phoenix, AZ 85036	SUN-192223182
433	Xavier	Nguyen	1976-10-16	602-555-0734	xavier.nguyen3@example.org	9769 W Camelback Rd, Phoenix, AZ 85034	MRC-707827946
434	Dolores	Gomez	1992-03-08	602-555-7885	dolores.gomez88@example.org	7803 W Peoria Ave, Phoenix, AZ 85026	MRC-328522310
435	Nathan	Acosta	1979-05-31	602-555-9286	nathan.acosta80@example.org	5078 W Cactus Rd, Phoenix, AZ 85049	SUN-319813226
436	Samuel	Espinoza	2001-02-15	602-555-9876	samuel.espinoza24@example.org	9346 W Southern Ave, Phoenix, AZ 85039	SUN-262125258
437	Felix	Padilla	1951-05-07	602-555-5342	felix.padilla51@example.org	1195 W Cactus Rd, Phoenix, AZ 85023	MRC-841104243
438	Omar	Robinson	1985-08-06	602-555-4267	omar.robinson9@example.org	1356 W Thomas Rd, Phoenix, AZ 85018	SUN-173743429
439	Elijah	Young	1962-11-12	602-555-7657	elijah.young15@example.org	405 W Camelback Rd, Phoenix, AZ 85044	AZB-794593926
440	Xavier	Vargas	1994-04-12	602-555-7291	xavier.vargas26@example.org	9266 W Northern Ave, Phoenix, AZ 85039	SUN-798705344
441	Carlos	Robinson	1978-06-22	602-555-8998	carlos.robinson74@example.org	8077 W Southern Ave, Phoenix, AZ 85028	SUN-573607209
442	Rafael	Ibarra	2016-08-13	602-555-8852	rafael.ibarra49@example.org	9633 W Northern Ave, Phoenix, AZ 85011	DES-215484285
443	Hector	Castillo	1999-04-07	602-555-2656	hector.castillo83@example.org	6265 W Union Hills Dr, Phoenix, AZ 85045	AZB-854762226
444	Quentin	Chavez	2015-04-06	602-555-2401	quentin.chavez23@example.org	7420 W Bethany Home Rd, Phoenix, AZ 85011	SUN-743752893
445	Renata	Acosta	1944-03-14	602-555-3780	renata.acosta91@example.org	2858 W Indian School Rd, Phoenix, AZ 85038	AZB-623172230
446	Marcus	Valdez	1995-10-06	602-555-5189	marcus.valdez77@example.org	2738 W Camelback Rd, Phoenix, AZ 85042	SUN-326868737
447	Rafael	Nguyen	2014-03-11	602-555-8767	rafael.nguyen42@example.org	7579 W Northern Ave, Phoenix, AZ 85024	DES-495660944
448	Paloma	Perez	1961-10-16	602-555-6693	paloma.perez81@example.org	8005 W Greenway Rd, Phoenix, AZ 85023	MRC-219634776
449	Zoe	Patel	1986-06-02	602-555-9477	zoe.patel87@example.org	3328 W Peoria Ave, Phoenix, AZ 85050	SUN-886817752
450	Marisol	Ibarra	1991-12-09	602-555-5656	marisol.ibarra96@example.org	8342 W Glendale Ave, Phoenix, AZ 85015	CPR-518056544
451	Lucia	Chen	1992-07-11	602-555-6743	lucia.chen78@example.org	8116 W Greenway Rd, Phoenix, AZ 85047	DES-326672344
452	Diego	Valdez	2010-01-23	602-555-6524	diego.valdez94@example.org	5893 W Glendale Ave, Phoenix, AZ 85036	SUN-348477860
453	Tanya	Patel	1973-07-25	602-555-3717	tanya.patel70@example.org	8976 W Peoria Ave, Phoenix, AZ 85041	MRC-783138648
454	Daniel	Martinez	1969-06-11	602-555-4229	daniel.martinez89@example.org	7005 W Thomas Rd, Phoenix, AZ 85010	MRC-631575819
455	Carla	Ramirez	2013-05-01	602-555-8509	carla.ramirez55@example.org	6830 W Cactus Rd, Phoenix, AZ 85010	DES-149565288
456	Omar	Romero	1951-01-19	602-555-7558	omar.romero73@example.org	5314 W McDowell Rd, Phoenix, AZ 85019	SUN-511019515
457	Yara	Williams	2002-01-20	602-555-4434	yara.williams93@example.org	3715 W Camelback Rd, Phoenix, AZ 85023	CPR-998034750
458	Nia	Reyes	1940-03-31	602-555-8541	nia.reyes23@example.org	810 W Southern Ave, Phoenix, AZ 85011	SUN-214268215
459	Noor	Ramirez	1945-07-19	602-555-0657	noor.ramirez92@example.org	8693 W McDowell Rd, Phoenix, AZ 85029	AZB-487820710
460	Daniel	Perez	1945-01-29	602-555-1073	daniel.perez85@example.org	3083 W Camelback Rd, Phoenix, AZ 85017	MRC-389347835
461	Benjamin	Young	2003-05-09	602-555-6533	benjamin.young30@example.org	2926 W Peoria Ave, Phoenix, AZ 85015	SUN-821550609
462	Benjamin	Salazar	2021-10-28	602-555-1923	benjamin.salazar91@example.org	6594 W Glendale Ave, Phoenix, AZ 85015	SUN-638397350
463	Zoe	Tsosie	2014-10-25	602-555-5333	zoe.tsosie65@example.org	8592 W Union Hills Dr, Phoenix, AZ 85018	SUN-134958403
464	Diego	Medina	2014-06-23	602-555-2482	diego.medina49@example.org	3093 W Glendale Ave, Phoenix, AZ 85035	MRC-637367910
465	Talia	Reyes	1954-09-05	602-555-8911	talia.reyes22@example.org	4765 W Baseline Rd, Phoenix, AZ 85040	MRC-209514588
466	Talia	Rivera	1996-07-24	602-555-3989	talia.rivera81@example.org	4555 W Glendale Ave, Phoenix, AZ 85028	CPR-821450389
467	Victor	Tsosie	1994-12-19	602-555-8716	victor.tsosie66@example.org	6795 W Bell Rd, Phoenix, AZ 85036	CPR-777063104
468	Andre	Chen	1994-02-16	602-555-6846	andre.chen15@example.org	2639 W Union Hills Dr, Phoenix, AZ 85037	AZB-528920287
469	Carla	Kim	1943-08-01	602-555-8507	carla.kim28@example.org	5292 W McDowell Rd, Phoenix, AZ 85048	SUN-893007570
470	Yusuf	Acosta	1963-10-01	602-555-5253	yusuf.acosta19@example.org	4510 W Glendale Ave, Phoenix, AZ 85016	CPR-987478471
471	Adrian	Patel	2005-12-08	602-555-4890	adrian.patel17@example.org	9232 W Greenway Rd, Phoenix, AZ 85028	DES-460254051
472	Marisol	Santos	1957-04-02	602-555-1413	marisol.santos9@example.org	9741 W Union Hills Dr, Phoenix, AZ 85019	MRC-942121549
473	Daniel	Jimenez	1969-11-12	602-555-6305	daniel.jimenez20@example.org	2264 W Thomas Rd, Phoenix, AZ 85045	MRC-197850391
474	Esperanza	Rivera	2013-09-16	602-555-5411	esperanza.rivera39@example.org	5081 W Cactus Rd, Phoenix, AZ 85032	DES-129880732
475	Samuel	Valdez	1997-06-27	602-555-9481	samuel.valdez69@example.org	6250 W Glendale Ave, Phoenix, AZ 85046	AZB-391557815
476	Xavier	Morales	2014-10-15	602-555-2212	xavier.morales74@example.org	7194 W Dunlap Ave, Phoenix, AZ 85045	CPR-371853620
477	Ana	Espinoza	2011-12-11	602-555-3455	ana.espinoza90@example.org	4587 W Dunlap Ave, Phoenix, AZ 85030	MRC-166862414
478	Lena	Flores	1967-11-08	602-555-2568	lena.flores67@example.org	5950 W Cactus Rd, Phoenix, AZ 85048	CPR-558031556
479	Isaac	Valdez	1961-12-31	602-555-0698	isaac.valdez26@example.org	9052 W Greenway Rd, Phoenix, AZ 85036	AZB-203082681
480	Yara	Foster	1974-02-27	602-555-0665	yara.foster92@example.org	1157 W Thomas Rd, Phoenix, AZ 85037	AZB-903190870
481	Nadia	Garcia	1982-04-04	602-555-9362	nadia.garcia47@example.org	999 W Greenway Rd, Phoenix, AZ 85029	SUN-786867921
482	Miguel	Bennett	2007-01-10	602-555-0087	miguel.bennett13@example.org	1696 W Dunlap Ave, Phoenix, AZ 85043	AZB-474297376
483	Hana	Velasquez	1995-01-10	602-555-4982	hana.velasquez91@example.org	8835 W Union Hills Dr, Phoenix, AZ 85013	DES-973624005
484	Zoe	Torres	2011-09-05	602-555-1037	zoe.torres60@example.org	3719 W Thomas Rd, Phoenix, AZ 85011	CPR-773695432
485	Dolores	Rivera	2006-05-13	602-555-6983	dolores.rivera71@example.org	2509 W Northern Ave, Phoenix, AZ 85036	SUN-789142161
486	Rosa	Silva	2005-06-24	602-555-1237	rosa.silva98@example.org	8388 W Greenway Rd, Phoenix, AZ 85044	SUN-540371309
487	Paloma	Santos	1992-06-14	602-555-6074	paloma.santos48@example.org	7303 W Baseline Rd, Phoenix, AZ 85026	DES-674252814
488	Uriel	Silva	2007-11-13	602-555-1185	uriel.silva70@example.org	5042 W Dunlap Ave, Phoenix, AZ 85038	DES-336611596
489	Hana	Salazar	1989-06-07	602-555-6408	hana.salazar89@example.org	2920 W Glendale Ave, Phoenix, AZ 85017	DES-799019418
490	Carlos	Yazzie	2018-12-21	602-555-6889	carlos.yazzie34@example.org	4234 W Bell Rd, Phoenix, AZ 85034	AZB-866476423
491	Paloma	Washington	2019-01-09	602-555-5341	paloma.washington73@example.org	8199 W Camelback Rd, Phoenix, AZ 85012	SUN-356596995
492	Hector	Chen	1945-05-23	602-555-3312	hector.chen25@example.org	5223 W Bethany Home Rd, Phoenix, AZ 85050	AZB-992942887
493	Daniel	Jimenez	2020-07-24	602-555-0016	daniel.jimenez44@example.org	9739 W Union Hills Dr, Phoenix, AZ 85025	AZB-802420005
494	Hector	Santos	2005-01-08	602-555-0797	hector.santos16@example.org	4106 W Union Hills Dr, Phoenix, AZ 85018	SUN-398888523
495	Jasmine	Flores	1946-12-26	602-555-6101	jasmine.flores81@example.org	9146 W Bethany Home Rd, Phoenix, AZ 85042	SUN-487248479
496	Tanya	Garcia	1946-10-30	602-555-8008	tanya.garcia80@example.org	3042 W Baseline Rd, Phoenix, AZ 85014	DES-282118157
497	Elijah	Vargas	1948-05-08	602-555-1419	elijah.vargas82@example.org	965 W Bell Rd, Phoenix, AZ 85042	MRC-881594609
498	Imani	Reyes	1973-11-29	602-555-0701	imani.reyes80@example.org	8019 W Thunderbird Rd, Phoenix, AZ 85010	MRC-652025917
499	Nathan	Medina	2011-11-06	602-555-8297	nathan.medina5@example.org	1409 W McDowell Rd, Phoenix, AZ 85012	AZB-195417868
500	Wren	Yazzie	1969-12-03	602-555-0362	wren.yazzie22@example.org	8780 W Thomas Rd, Phoenix, AZ 85013	AZB-505380866
501	Jasmine	Begay	1968-07-30	602-555-0374	jasmine.begay9@example.org	5768 W Peoria Ave, Phoenix, AZ 85017	AZB-101656869
502	Diego	Hernandez	1962-11-15	602-555-4737	diego.hernandez87@example.org	9718 W Southern Ave, Phoenix, AZ 85033	CPR-779988787
503	Victor	Delgado	1943-04-13	602-555-1754	victor.delgado62@example.org	6180 W McDowell Rd, Phoenix, AZ 85034	DES-868186179
504	Nathan	Velasquez	1979-04-19	602-555-9202	nathan.velasquez91@example.org	8846 W Union Hills Dr, Phoenix, AZ 85030	MRC-381911240
505	Sebastian	Bennett	2000-03-03	602-555-1477	sebastian.bennett96@example.org	8349 W Bethany Home Rd, Phoenix, AZ 85028	AZB-678110394
506	Aaliyah	Rivera	1995-03-19	602-555-7108	aaliyah.rivera48@example.org	3214 W Southern Ave, Phoenix, AZ 85045	AZB-544243265
507	Wren	Singh	1984-11-22	602-555-3510	wren.singh8@example.org	1536 W Camelback Rd, Phoenix, AZ 85035	AZB-597196036
508	Xavier	Williams	1975-10-10	602-555-6090	xavier.williams23@example.org	8370 W Thomas Rd, Phoenix, AZ 85041	CPR-742922818
509	Olivia	Vasquez	2017-01-10	602-555-9965	olivia.vasquez92@example.org	8831 W Southern Ave, Phoenix, AZ 85010	AZB-927284199
510	Talia	Castillo	1979-05-08	602-555-3497	talia.castillo4@example.org	758 W Southern Ave, Phoenix, AZ 85049	AZB-411313170
511	Jonah	Ramirez	2019-07-11	602-555-6500	jonah.ramirez8@example.org	5010 W Thunderbird Rd, Phoenix, AZ 85028	MRC-817251690
512	Tomas	Sanchez	1943-10-19	602-555-6577	tomas.sanchez83@example.org	7480 W Indian School Rd, Phoenix, AZ 85029	CPR-748902236
513	Alma	Acosta	1941-11-08	602-555-3777	alma.acosta51@example.org	1672 W Greenway Rd, Phoenix, AZ 85014	MRC-714426751
514	Lena	Jimenez	1975-11-18	602-555-7316	lena.jimenez26@example.org	9351 W Union Hills Dr, Phoenix, AZ 85015	MRC-590292549
515	Renata	Silva	2018-10-12	602-555-1409	renata.silva85@example.org	1728 W Baseline Rd, Phoenix, AZ 85019	DES-405364663
516	Talia	Torres	2021-06-19	602-555-6394	talia.torres70@example.org	1860 W Southern Ave, Phoenix, AZ 85027	DES-646181129
517	Xavier	Valdez	1995-02-13	602-555-9271	xavier.valdez19@example.org	6771 W Baseline Rd, Phoenix, AZ 85041	AZB-230230805
518	Diego	Vasquez	1990-04-17	602-555-4370	diego.vasquez85@example.org	882 W McDowell Rd, Phoenix, AZ 85040	AZB-640351992
519	Omar	Garcia	2019-02-06	602-555-0989	omar.garcia59@example.org	5094 W Dunlap Ave, Phoenix, AZ 85016	SUN-333377834
520	Daniel	Castillo	1970-03-03	602-555-6796	daniel.castillo67@example.org	2351 W Bethany Home Rd, Phoenix, AZ 85015	SUN-169628219
521	Omar	Valdez	2017-03-03	602-555-9372	omar.valdez59@example.org	7325 W Thomas Rd, Phoenix, AZ 85033	CPR-641634783
522	Mateo	Patel	1986-02-03	602-555-9386	mateo.patel85@example.org	999 W Northern Ave, Phoenix, AZ 85015	SUN-661690013
523	Serena	Flores	2018-02-26	602-555-8004	serena.flores8@example.org	7045 W Dunlap Ave, Phoenix, AZ 85015	CPR-557868255
524	Paloma	Young	1963-05-15	602-555-5395	paloma.young9@example.org	203 W Peoria Ave, Phoenix, AZ 85025	MRC-694665257
525	Wren	Vasquez	1964-10-21	602-555-2018	wren.vasquez61@example.org	3122 W Northern Ave, Phoenix, AZ 85013	CPR-601911300
526	Javier	Lopez	2010-06-19	602-555-0330	javier.lopez4@example.org	1120 W Indian School Rd, Phoenix, AZ 85028	CPR-512760450
527	Noor	Delgado	1991-06-15	602-555-4146	noor.delgado6@example.org	9191 W Bethany Home Rd, Phoenix, AZ 85042	DES-263191369
528	Zoe	Acosta	1967-04-22	602-555-6404	zoe.acosta63@example.org	2439 W Bethany Home Rd, Phoenix, AZ 85043	DES-460858561
529	Hana	Flores	1999-09-19	602-555-8501	hana.flores55@example.org	8731 W Union Hills Dr, Phoenix, AZ 85042	MRC-618708183
530	Mateo	Romero	1943-07-11	602-555-4847	mateo.romero39@example.org	4885 W Thomas Rd, Phoenix, AZ 85022	CPR-407781487
531	Elijah	Washington	1952-08-16	602-555-4554	elijah.washington98@example.org	477 W Dunlap Ave, Phoenix, AZ 85026	DES-730331575
532	Celeste	Flores	1945-05-29	602-555-9896	celeste.flores27@example.org	1733 W Dunlap Ave, Phoenix, AZ 85039	MRC-150033248
533	Tanya	Ramirez	1940-03-13	602-555-1603	tanya.ramirez62@example.org	5200 W Camelback Rd, Phoenix, AZ 85024	AZB-297046248
534	Gavin	Acosta	1954-06-28	602-555-1201	gavin.acosta52@example.org	8376 W McDowell Rd, Phoenix, AZ 85024	CPR-796529926
535	Dolores	Vasquez	1961-07-25	602-555-8636	dolores.vasquez57@example.org	2934 W Greenway Rd, Phoenix, AZ 85037	CPR-674363430
536	Esperanza	Hernandez	1986-02-16	602-555-4753	esperanza.hernandez32@example.org	2651 W Union Hills Dr, Phoenix, AZ 85047	MRC-732436215
537	Jasmine	Washington	1976-12-15	602-555-7211	jasmine.washington83@example.org	5651 W Indian School Rd, Phoenix, AZ 85018	MRC-394038613
538	Carlos	Gutierrez	1975-12-26	602-555-3116	carlos.gutierrez85@example.org	3293 W Southern Ave, Phoenix, AZ 85011	CPR-788780141
539	Elijah	Gomez	2015-04-30	602-555-0551	elijah.gomez99@example.org	6507 W Southern Ave, Phoenix, AZ 85031	CPR-695510322
540	Adrian	Dominguez	2003-10-07	602-555-9310	adrian.dominguez74@example.org	8843 W Dunlap Ave, Phoenix, AZ 85044	SUN-686629649
541	Jonah	Washington	1964-12-29	602-555-9457	jonah.washington54@example.org	7526 W McDowell Rd, Phoenix, AZ 85050	SUN-147313306
542	Paloma	Medina	1940-09-21	602-555-0134	paloma.medina98@example.org	9784 W Union Hills Dr, Phoenix, AZ 85025	CPR-835388120
543	Paloma	Singh	1975-10-22	602-555-6313	paloma.singh93@example.org	2893 W Bethany Home Rd, Phoenix, AZ 85013	MRC-113627066
544	Adrian	Singh	1962-10-08	602-555-2239	adrian.singh47@example.org	1920 W Union Hills Dr, Phoenix, AZ 85046	CPR-891618692
545	Gavin	Jimenez	2003-10-02	602-555-7769	gavin.jimenez51@example.org	4291 W Northern Ave, Phoenix, AZ 85034	SUN-465586827
546	Carlos	Vargas	1947-09-04	602-555-9271	carlos.vargas80@example.org	9955 W McDowell Rd, Phoenix, AZ 85038	DES-466724481
547	Isaac	Chavez	1996-09-27	602-555-5093	isaac.chavez9@example.org	3365 W Baseline Rd, Phoenix, AZ 85024	DES-309830490
548	Gabriela	Ramirez	1961-08-19	602-555-5209	gabriela.ramirez50@example.org	1707 W Glendale Ave, Phoenix, AZ 85044	CPR-227781836
549	Rafael	Espinoza	1991-03-25	602-555-8010	rafael.espinoza6@example.org	3477 W Baseline Rd, Phoenix, AZ 85047	AZB-715444292
550	Carlos	Rivera	1968-06-03	602-555-5981	carlos.rivera19@example.org	6424 W Thunderbird Rd, Phoenix, AZ 85026	DES-473088399
551	Benjamin	Castillo	1968-10-22	602-555-2212	benjamin.castillo81@example.org	2639 W Bethany Home Rd, Phoenix, AZ 85029	MRC-546203834
552	Owen	Yazzie	2000-05-31	602-555-6128	owen.yazzie58@example.org	4421 W Peoria Ave, Phoenix, AZ 85010	MRC-704269137
553	Celeste	Ortiz	2020-09-12	602-555-4584	celeste.ortiz69@example.org	4017 W Cactus Rd, Phoenix, AZ 85024	MRC-796939164
554	Wren	Ramirez	2004-06-22	602-555-3606	wren.ramirez31@example.org	135 W Indian School Rd, Phoenix, AZ 85035	CPR-361711315
555	Marcus	Patel	1999-11-16	602-555-3089	marcus.patel78@example.org	8435 W Dunlap Ave, Phoenix, AZ 85011	AZB-478503673
556	Hana	Flores	1993-12-20	602-555-2486	hana.flores79@example.org	2286 W Southern Ave, Phoenix, AZ 85040	AZB-791519092
557	Serena	Flores	1966-06-22	602-555-8169	serena.flores60@example.org	9922 W McDowell Rd, Phoenix, AZ 85014	MRC-226070782
558	Samuel	Romero	1965-11-22	602-555-9541	samuel.romero9@example.org	7129 W Thomas Rd, Phoenix, AZ 85021	AZB-320747314
559	Olivia	Torres	1965-04-01	602-555-9958	olivia.torres12@example.org	7724 W Peoria Ave, Phoenix, AZ 85046	CPR-872967051
560	Tomas	Vargas	1993-12-31	602-555-8900	tomas.vargas59@example.org	9719 W Peoria Ave, Phoenix, AZ 85026	DES-344519470
561	Valeria	Kim	1949-11-10	602-555-5439	valeria.kim84@example.org	880 W Thomas Rd, Phoenix, AZ 85051	AZB-678773787
562	Diego	Perez	1950-09-18	602-555-7849	diego.perez71@example.org	685 W Indian School Rd, Phoenix, AZ 85022	MRC-149437256
563	Sebastian	Washington	1961-08-04	602-555-7428	sebastian.washington31@example.org	5799 W Peoria Ave, Phoenix, AZ 85028	CPR-565727556
564	Javier	Yazzie	1954-12-15	602-555-4926	javier.yazzie74@example.org	6190 W Peoria Ave, Phoenix, AZ 85031	CPR-503338094
565	Noor	Jackson	1994-11-07	602-555-0547	noor.jackson44@example.org	9787 W Cactus Rd, Phoenix, AZ 85022	AZB-245462752
566	Lena	Dominguez	1992-03-13	602-555-4546	lena.dominguez55@example.org	2567 W Northern Ave, Phoenix, AZ 85024	CPR-824626285
567	Kenji	Silva	1940-05-03	602-555-8835	kenji.silva56@example.org	4083 W Glendale Ave, Phoenix, AZ 85032	MRC-401391291
568	Miguel	Ortiz	1986-05-18	602-555-8224	miguel.ortiz6@example.org	788 W Glendale Ave, Phoenix, AZ 85027	AZB-420763408
569	Rosa	Ibarra	1981-06-26	602-555-3841	rosa.ibarra43@example.org	4996 W Cactus Rd, Phoenix, AZ 85012	DES-364098634
570	Benjamin	Chen	1960-04-13	602-555-5198	benjamin.chen51@example.org	6630 W Glendale Ave, Phoenix, AZ 85046	DES-153749558
571	Xavier	Mendoza	1975-01-04	602-555-7703	xavier.mendoza10@example.org	6920 W McDowell Rd, Phoenix, AZ 85051	MRC-695058726
572	Carla	Begay	1980-03-31	602-555-2708	carla.begay54@example.org	5211 W Southern Ave, Phoenix, AZ 85042	MRC-181579918
573	Kaya	Ibarra	2000-12-19	602-555-8621	kaya.ibarra83@example.org	105 W Bell Rd, Phoenix, AZ 85041	DES-152703167
574	Xavier	Acosta	2004-07-30	602-555-3656	xavier.acosta25@example.org	1501 W Indian School Rd, Phoenix, AZ 85047	DES-658852378
575	Rafael	Ibarra	2000-09-29	602-555-7297	rafael.ibarra60@example.org	1711 W Northern Ave, Phoenix, AZ 85013	CPR-467163585
576	Beatriz	Ibarra	1986-06-27	602-555-1454	beatriz.ibarra89@example.org	4110 W Glendale Ave, Phoenix, AZ 85018	CPR-546782372
577	Marcus	Jackson	1970-03-24	602-555-7289	marcus.jackson1@example.org	3122 W Bethany Home Rd, Phoenix, AZ 85024	SUN-864032164
578	Beatriz	Yazzie	1965-05-08	602-555-2895	beatriz.yazzie5@example.org	3660 W Bell Rd, Phoenix, AZ 85026	MRC-307494382
579	Marcus	Mendoza	1978-12-12	602-555-3505	marcus.mendoza31@example.org	9614 W Northern Ave, Phoenix, AZ 85018	SUN-745514828
580	Owen	Gutierrez	2000-01-12	602-555-9563	owen.gutierrez7@example.org	9406 W Thomas Rd, Phoenix, AZ 85014	MRC-751913155
581	Daniel	Rivera	1945-04-20	602-555-7751	daniel.rivera62@example.org	4295 W Glendale Ave, Phoenix, AZ 85049	MRC-929869710
582	Lena	Morales	1959-05-06	602-555-4434	lena.morales49@example.org	7975 W Cactus Rd, Phoenix, AZ 85035	AZB-339632936
583	Kenji	Young	1986-12-08	602-555-7673	kenji.young1@example.org	2418 W McDowell Rd, Phoenix, AZ 85027	CPR-543915610
584	Paloma	Medina	1990-12-18	602-555-7106	paloma.medina57@example.org	9484 W McDowell Rd, Phoenix, AZ 85047	DES-252543529
585	Ana	Padilla	1983-04-20	602-555-4421	ana.padilla27@example.org	8199 W Cactus Rd, Phoenix, AZ 85014	MRC-776228314
586	Imani	Dominguez	2009-04-12	602-555-2018	imani.dominguez46@example.org	5800 W Greenway Rd, Phoenix, AZ 85028	AZB-923795917
587	Uriel	Espinoza	2019-05-23	602-555-0756	uriel.espinoza15@example.org	3721 W Peoria Ave, Phoenix, AZ 85027	DES-887205923
588	Adrian	Garcia	1949-07-31	602-555-9939	adrian.garcia54@example.org	6642 W Glendale Ave, Phoenix, AZ 85038	DES-652539210
589	Esperanza	Valdez	2007-10-08	602-555-6078	esperanza.valdez57@example.org	6119 W Northern Ave, Phoenix, AZ 85028	CPR-621163084
590	Wren	Santos	1978-04-07	602-555-9858	wren.santos81@example.org	4560 W Indian School Rd, Phoenix, AZ 85047	MRC-486305020
591	Quentin	Chavez	1977-05-23	602-555-7544	quentin.chavez91@example.org	5201 W Peoria Ave, Phoenix, AZ 85048	CPR-930142845
592	Carlos	Santos	1948-01-30	602-555-6180	carlos.santos82@example.org	2357 W McDowell Rd, Phoenix, AZ 85024	MRC-508462406
593	Diego	Yazzie	1966-12-23	602-555-1206	diego.yazzie34@example.org	9994 W Camelback Rd, Phoenix, AZ 85033	CPR-666697640
594	Jasmine	Gutierrez	1950-03-09	602-555-5156	jasmine.gutierrez8@example.org	752 W Southern Ave, Phoenix, AZ 85050	CPR-957935859
595	Xavier	Valdez	1969-03-25	602-555-0878	xavier.valdez25@example.org	3699 W Camelback Rd, Phoenix, AZ 85013	DES-565230539
596	Daniel	Padilla	1955-10-11	602-555-1355	daniel.padilla69@example.org	6496 W Union Hills Dr, Phoenix, AZ 85010	AZB-414715875
597	Alma	Mendoza	1979-06-10	602-555-0347	alma.mendoza90@example.org	8216 W Peoria Ave, Phoenix, AZ 85033	MRC-935762136
598	Hector	Valdez	1974-10-31	602-555-1347	hector.valdez39@example.org	9604 W Union Hills Dr, Phoenix, AZ 85033	SUN-413953554
599	Yara	Patel	1977-10-27	602-555-7608	yara.patel95@example.org	1729 W Peoria Ave, Phoenix, AZ 85010	SUN-795856548
600	Zoe	Morales	1982-06-14	602-555-2411	zoe.morales83@example.org	6481 W Bethany Home Rd, Phoenix, AZ 85044	AZB-838276472
\.


--
-- Data for Name: providers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.providers (provider_id, full_name, specialty, npi) FROM stdin;
1	Dr. Elena Vasquez	Family Medicine	1030485390
2	Dr. Nadia Yazzie	Family Medicine	1872645184
3	Dr. Kaya Ortiz	Family Medicine	1067852158
4	Dr. Kenji Foster	Pediatrics	1353014498
5	Dr. Miguel Garcia	Pediatrics	1355238798
6	Dr. Alma Martinez	Internal Medicine	1797722309
7	Dr. Aaliyah Velasquez	Internal Medicine	1460666083
8	Alma Yazzie	Nurse Practitioner	1245466467
9	Yara Jackson	Nurse Practitioner	1006767915
10	Olivia Rivera	Physician Assistant	1324602679
11	Kaya Mendoza	Behavioral Health	1263531291
12	Dr. Yara Rivera	Family Medicine	1179184744
\.


--
-- Data for Name: staff_accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.staff_accounts (account_id, username, role_name, provider_id) FROM stdin;
1	evasquez	provider	1
2	nyazzie	provider	2
3	kortiz	provider	3
4	kfoster	provider	4
5	mgarcia	provider	5
6	amartinez	provider	6
7	avelasquez	provider	7
8	ayazzie	provider	8
9	yjackson	provider	9
10	orivera	provider	10
11	kmendoza	provider	11
12	yrivera	provider	12
13	bsalazar	frontdesk	\N
14	itsosie	frontdesk	\N
15	wperez	frontdesk	\N
16	jsalazar	frontdesk	\N
17	gyazzie	billing	\N
18	kfoster17	billing	\N
19	treyes	office_manager	\N
20	grobinson	it_admin	\N
\.


--
-- Data for Name: visit_notes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.visit_notes (note_id, appointment_id, diagnosis_code, note_text) FROM stdin;
1	1	I10	Reviewed symptoms and history.
2	2	N39.0	Referred to specialist.
3	3	M54.5	Medication adjusted. Recheck in 6 weeks.
4	5	Z00.00	Referred to specialist.
5	6	J06.9	Vitals stable. Continue current plan.
6	7	Z00.00	Medication adjusted. Recheck in 6 weeks.
7	10	K21.9	Referred to specialist.
8	12	Z00.00	Referred to specialist.
9	13	I10	Reviewed symptoms and history.
10	14	J06.9	Preventive counseling provided.
11	15	R51.9	Discussed lab results with patient.
12	16	Z00.00	Preventive counseling provided.
13	18	N39.0	Referred to specialist.
14	19	M54.5	Medication adjusted. Recheck in 6 weeks.
15	20	L30.9	Medication adjusted. Recheck in 6 weeks.
16	22	I10	Preventive counseling provided.
17	23	E11.9	Referred to specialist.
18	24	J45.909	Medication adjusted. Recheck in 6 weeks.
19	25	M54.5	Medication adjusted. Recheck in 6 weeks.
20	26	I10	Medication adjusted. Recheck in 6 weeks.
21	27	M54.5	Discussed lab results with patient.
22	29	I10	Medication adjusted. Recheck in 6 weeks.
23	30	I10	Vitals stable. Continue current plan.
24	31	M54.5	Preventive counseling provided.
25	32	I10	Vitals stable. Continue current plan.
26	33	J45.909	Reviewed symptoms and history.
27	34	F41.1	Referred to specialist.
28	35	F41.1	Referred to specialist.
29	36	E78.5	Reviewed symptoms and history.
30	37	N39.0	Referred to specialist.
31	38	R51.9	Vitals stable. Continue current plan.
32	39	J06.9	Medication adjusted. Recheck in 6 weeks.
33	40	R51.9	Referred to specialist.
34	42	Z00.00	Vitals stable. Continue current plan.
35	43	R51.9	Medication adjusted. Recheck in 6 weeks.
36	44	Z00.00	Referred to specialist.
37	45	E11.9	Referred to specialist.
38	47	Z00.00	Reviewed symptoms and history.
39	48	F41.1	Discussed lab results with patient.
40	49	L30.9	Medication adjusted. Recheck in 6 weeks.
41	50	E78.5	Medication adjusted. Recheck in 6 weeks.
42	51	E78.5	Vitals stable. Continue current plan.
43	52	J06.9	Medication adjusted. Recheck in 6 weeks.
44	53	F41.1	Medication adjusted. Recheck in 6 weeks.
45	54	F41.1	Preventive counseling provided.
46	56	R51.9	Preventive counseling provided.
47	57	M54.5	Referred to specialist.
48	58	F41.1	Discussed lab results with patient.
49	59	Z00.00	Referred to specialist.
50	60	F41.1	Referred to specialist.
51	62	E11.9	Medication adjusted. Recheck in 6 weeks.
52	63	R51.9	Medication adjusted. Recheck in 6 weeks.
53	64	R51.9	Referred to specialist.
54	66	J45.909	Referred to specialist.
55	67	J06.9	Discussed lab results with patient.
56	68	J45.909	Vitals stable. Continue current plan.
57	69	E11.9	Referred to specialist.
58	70	K21.9	Preventive counseling provided.
59	71	F41.1	Reviewed symptoms and history.
60	72	R51.9	Vitals stable. Continue current plan.
61	73	Z00.00	Preventive counseling provided.
62	74	I10	Medication adjusted. Recheck in 6 weeks.
63	76	N39.0	Discussed lab results with patient.
64	79	R51.9	Medication adjusted. Recheck in 6 weeks.
65	81	N39.0	Referred to specialist.
66	82	M54.5	Referred to specialist.
67	83	J06.9	Discussed lab results with patient.
68	84	M54.5	Referred to specialist.
69	86	F41.1	Vitals stable. Continue current plan.
70	87	M54.5	Reviewed symptoms and history.
71	89	L30.9	Preventive counseling provided.
72	90	J06.9	Referred to specialist.
73	92	K21.9	Discussed lab results with patient.
74	93	R51.9	Vitals stable. Continue current plan.
75	94	L30.9	Referred to specialist.
76	95	F41.1	Discussed lab results with patient.
77	96	F41.1	Preventive counseling provided.
78	97	N39.0	Discussed lab results with patient.
79	98	J45.909	Reviewed symptoms and history.
80	100	M54.5	Reviewed symptoms and history.
81	104	M54.5	Reviewed symptoms and history.
82	106	J45.909	Preventive counseling provided.
83	108	Z00.00	Reviewed symptoms and history.
84	109	K21.9	Medication adjusted. Recheck in 6 weeks.
85	110	J06.9	Reviewed symptoms and history.
86	111	J06.9	Reviewed symptoms and history.
87	112	M54.5	Reviewed symptoms and history.
88	113	F41.1	Medication adjusted. Recheck in 6 weeks.
89	114	K21.9	Preventive counseling provided.
90	115	L30.9	Reviewed symptoms and history.
91	116	M54.5	Discussed lab results with patient.
92	118	N39.0	Vitals stable. Continue current plan.
93	119	N39.0	Reviewed symptoms and history.
94	120	E78.5	Vitals stable. Continue current plan.
95	121	N39.0	Discussed lab results with patient.
96	122	F41.1	Referred to specialist.
97	123	Z00.00	Discussed lab results with patient.
98	124	J06.9	Medication adjusted. Recheck in 6 weeks.
99	125	I10	Reviewed symptoms and history.
100	126	F41.1	Reviewed symptoms and history.
101	127	K21.9	Vitals stable. Continue current plan.
102	128	J45.909	Preventive counseling provided.
103	129	E11.9	Vitals stable. Continue current plan.
104	130	J06.9	Vitals stable. Continue current plan.
105	131	F41.1	Medication adjusted. Recheck in 6 weeks.
106	132	K21.9	Vitals stable. Continue current plan.
107	134	R51.9	Reviewed symptoms and history.
108	135	Z00.00	Medication adjusted. Recheck in 6 weeks.
109	136	F41.1	Medication adjusted. Recheck in 6 weeks.
110	137	L30.9	Reviewed symptoms and history.
111	138	N39.0	Preventive counseling provided.
112	139	I10	Vitals stable. Continue current plan.
113	140	N39.0	Vitals stable. Continue current plan.
114	141	L30.9	Preventive counseling provided.
115	142	M54.5	Preventive counseling provided.
116	143	N39.0	Medication adjusted. Recheck in 6 weeks.
117	144	F41.1	Referred to specialist.
118	146	J06.9	Reviewed symptoms and history.
119	147	E11.9	Vitals stable. Continue current plan.
120	148	F41.1	Preventive counseling provided.
121	149	M54.5	Referred to specialist.
122	150	F41.1	Preventive counseling provided.
123	151	K21.9	Referred to specialist.
124	152	J45.909	Discussed lab results with patient.
125	153	K21.9	Vitals stable. Continue current plan.
126	154	K21.9	Reviewed symptoms and history.
127	155	J06.9	Reviewed symptoms and history.
128	156	K21.9	Reviewed symptoms and history.
129	157	N39.0	Medication adjusted. Recheck in 6 weeks.
130	158	K21.9	Preventive counseling provided.
131	159	R51.9	Discussed lab results with patient.
132	161	E78.5	Discussed lab results with patient.
133	162	N39.0	Discussed lab results with patient.
134	164	E78.5	Reviewed symptoms and history.
135	165	R51.9	Preventive counseling provided.
136	166	K21.9	Reviewed symptoms and history.
137	167	R51.9	Reviewed symptoms and history.
138	169	L30.9	Referred to specialist.
139	170	F41.1	Vitals stable. Continue current plan.
140	171	L30.9	Reviewed symptoms and history.
141	172	J45.909	Vitals stable. Continue current plan.
142	173	J06.9	Medication adjusted. Recheck in 6 weeks.
143	175	M54.5	Reviewed symptoms and history.
144	176	M54.5	Medication adjusted. Recheck in 6 weeks.
145	178	N39.0	Preventive counseling provided.
146	180	N39.0	Preventive counseling provided.
147	181	Z00.00	Reviewed symptoms and history.
148	182	F41.1	Medication adjusted. Recheck in 6 weeks.
149	184	M54.5	Vitals stable. Continue current plan.
150	185	N39.0	Discussed lab results with patient.
151	186	L30.9	Referred to specialist.
152	187	E78.5	Discussed lab results with patient.
153	188	E78.5	Vitals stable. Continue current plan.
154	189	N39.0	Medication adjusted. Recheck in 6 weeks.
155	190	E78.5	Reviewed symptoms and history.
156	191	I10	Discussed lab results with patient.
157	193	L30.9	Reviewed symptoms and history.
158	194	R51.9	Medication adjusted. Recheck in 6 weeks.
159	196	F41.1	Preventive counseling provided.
160	198	M54.5	Discussed lab results with patient.
161	199	E78.5	Discussed lab results with patient.
162	200	E11.9	Reviewed symptoms and history.
163	203	I10	Reviewed symptoms and history.
164	204	K21.9	Preventive counseling provided.
165	205	J45.909	Vitals stable. Continue current plan.
166	206	L30.9	Vitals stable. Continue current plan.
167	207	M54.5	Referred to specialist.
168	209	R51.9	Medication adjusted. Recheck in 6 weeks.
169	210	E11.9	Reviewed symptoms and history.
170	211	E11.9	Discussed lab results with patient.
171	213	N39.0	Referred to specialist.
172	214	M54.5	Discussed lab results with patient.
173	215	K21.9	Discussed lab results with patient.
174	217	F41.1	Preventive counseling provided.
175	218	J45.909	Referred to specialist.
176	219	E11.9	Discussed lab results with patient.
177	220	N39.0	Medication adjusted. Recheck in 6 weeks.
178	221	J45.909	Vitals stable. Continue current plan.
179	222	R51.9	Vitals stable. Continue current plan.
180	223	R51.9	Discussed lab results with patient.
181	225	J06.9	Reviewed symptoms and history.
182	229	E11.9	Medication adjusted. Recheck in 6 weeks.
183	230	J06.9	Referred to specialist.
184	231	Z00.00	Discussed lab results with patient.
185	235	E11.9	Reviewed symptoms and history.
186	236	L30.9	Preventive counseling provided.
187	237	K21.9	Reviewed symptoms and history.
188	238	I10	Referred to specialist.
189	239	J06.9	Reviewed symptoms and history.
190	240	J45.909	Preventive counseling provided.
191	241	J06.9	Referred to specialist.
192	242	R51.9	Preventive counseling provided.
193	243	M54.5	Preventive counseling provided.
194	245	M54.5	Discussed lab results with patient.
195	246	E11.9	Medication adjusted. Recheck in 6 weeks.
196	247	J45.909	Medication adjusted. Recheck in 6 weeks.
197	249	E78.5	Reviewed symptoms and history.
198	250	J45.909	Reviewed symptoms and history.
199	251	J06.9	Discussed lab results with patient.
200	252	E11.9	Referred to specialist.
201	254	N39.0	Medication adjusted. Recheck in 6 weeks.
202	255	R51.9	Reviewed symptoms and history.
203	257	E78.5	Vitals stable. Continue current plan.
204	259	M54.5	Medication adjusted. Recheck in 6 weeks.
205	260	J45.909	Referred to specialist.
206	261	I10	Vitals stable. Continue current plan.
207	262	E78.5	Medication adjusted. Recheck in 6 weeks.
208	263	K21.9	Reviewed symptoms and history.
209	264	K21.9	Medication adjusted. Recheck in 6 weeks.
210	266	J06.9	Medication adjusted. Recheck in 6 weeks.
211	267	I10	Reviewed symptoms and history.
212	268	M54.5	Reviewed symptoms and history.
213	269	F41.1	Reviewed symptoms and history.
214	270	L30.9	Preventive counseling provided.
215	271	I10	Medication adjusted. Recheck in 6 weeks.
216	272	I10	Reviewed symptoms and history.
217	273	R51.9	Medication adjusted. Recheck in 6 weeks.
218	274	K21.9	Reviewed symptoms and history.
219	275	F41.1	Referred to specialist.
220	280	J06.9	Referred to specialist.
221	283	F41.1	Discussed lab results with patient.
222	286	N39.0	Discussed lab results with patient.
223	287	J45.909	Preventive counseling provided.
224	288	I10	Preventive counseling provided.
225	289	I10	Vitals stable. Continue current plan.
226	290	E78.5	Preventive counseling provided.
227	291	K21.9	Referred to specialist.
228	292	I10	Discussed lab results with patient.
229	295	J06.9	Referred to specialist.
230	297	E11.9	Referred to specialist.
231	298	E78.5	Reviewed symptoms and history.
232	301	I10	Medication adjusted. Recheck in 6 weeks.
233	302	I10	Medication adjusted. Recheck in 6 weeks.
234	303	E78.5	Preventive counseling provided.
235	305	E11.9	Medication adjusted. Recheck in 6 weeks.
236	307	E11.9	Referred to specialist.
237	308	M54.5	Medication adjusted. Recheck in 6 weeks.
238	309	E78.5	Medication adjusted. Recheck in 6 weeks.
239	311	L30.9	Reviewed symptoms and history.
240	312	M54.5	Referred to specialist.
241	314	J45.909	Medication adjusted. Recheck in 6 weeks.
242	315	M54.5	Referred to specialist.
243	316	R51.9	Medication adjusted. Recheck in 6 weeks.
244	317	R51.9	Preventive counseling provided.
245	318	R51.9	Reviewed symptoms and history.
246	319	Z00.00	Discussed lab results with patient.
247	320	K21.9	Discussed lab results with patient.
248	321	E78.5	Preventive counseling provided.
249	322	F41.1	Discussed lab results with patient.
250	324	N39.0	Preventive counseling provided.
251	325	E78.5	Referred to specialist.
252	326	F41.1	Vitals stable. Continue current plan.
253	327	K21.9	Preventive counseling provided.
254	328	J06.9	Medication adjusted. Recheck in 6 weeks.
255	329	E11.9	Vitals stable. Continue current plan.
256	330	J06.9	Reviewed symptoms and history.
257	332	Z00.00	Reviewed symptoms and history.
258	334	F41.1	Preventive counseling provided.
259	335	I10	Vitals stable. Continue current plan.
260	336	F41.1	Discussed lab results with patient.
261	337	L30.9	Preventive counseling provided.
262	338	F41.1	Preventive counseling provided.
263	340	E11.9	Vitals stable. Continue current plan.
264	341	E11.9	Vitals stable. Continue current plan.
265	342	M54.5	Referred to specialist.
266	343	L30.9	Reviewed symptoms and history.
267	344	I10	Referred to specialist.
268	346	F41.1	Medication adjusted. Recheck in 6 weeks.
269	348	I10	Vitals stable. Continue current plan.
270	349	E11.9	Vitals stable. Continue current plan.
271	350	J45.909	Medication adjusted. Recheck in 6 weeks.
272	355	F41.1	Discussed lab results with patient.
273	357	R51.9	Reviewed symptoms and history.
274	358	L30.9	Referred to specialist.
275	359	M54.5	Medication adjusted. Recheck in 6 weeks.
276	360	J06.9	Discussed lab results with patient.
277	361	M54.5	Referred to specialist.
278	362	K21.9	Vitals stable. Continue current plan.
279	363	J06.9	Medication adjusted. Recheck in 6 weeks.
280	364	N39.0	Discussed lab results with patient.
281	366	J45.909	Reviewed symptoms and history.
282	367	J06.9	Vitals stable. Continue current plan.
283	368	E11.9	Preventive counseling provided.
284	369	J06.9	Preventive counseling provided.
285	371	J45.909	Discussed lab results with patient.
286	373	J45.909	Preventive counseling provided.
287	374	M54.5	Vitals stable. Continue current plan.
288	375	J45.909	Discussed lab results with patient.
289	376	N39.0	Vitals stable. Continue current plan.
290	377	J06.9	Vitals stable. Continue current plan.
291	379	L30.9	Reviewed symptoms and history.
292	380	E78.5	Reviewed symptoms and history.
293	381	E78.5	Referred to specialist.
294	382	J06.9	Reviewed symptoms and history.
295	383	K21.9	Discussed lab results with patient.
296	384	J06.9	Reviewed symptoms and history.
297	385	L30.9	Vitals stable. Continue current plan.
298	386	I10	Preventive counseling provided.
299	387	I10	Referred to specialist.
300	388	Z00.00	Discussed lab results with patient.
301	389	J06.9	Vitals stable. Continue current plan.
302	390	N39.0	Referred to specialist.
303	391	K21.9	Referred to specialist.
304	393	N39.0	Reviewed symptoms and history.
305	394	Z00.00	Preventive counseling provided.
306	395	E78.5	Preventive counseling provided.
307	396	K21.9	Discussed lab results with patient.
308	397	J45.909	Preventive counseling provided.
309	398	J45.909	Preventive counseling provided.
310	399	F41.1	Medication adjusted. Recheck in 6 weeks.
311	400	J06.9	Reviewed symptoms and history.
312	402	K21.9	Preventive counseling provided.
313	403	J06.9	Medication adjusted. Recheck in 6 weeks.
314	404	I10	Preventive counseling provided.
315	405	L30.9	Vitals stable. Continue current plan.
316	406	I10	Referred to specialist.
317	407	M54.5	Preventive counseling provided.
318	408	K21.9	Discussed lab results with patient.
319	411	Z00.00	Reviewed symptoms and history.
320	412	R51.9	Reviewed symptoms and history.
321	413	E11.9	Reviewed symptoms and history.
322	414	I10	Referred to specialist.
323	415	E11.9	Medication adjusted. Recheck in 6 weeks.
324	416	J45.909	Medication adjusted. Recheck in 6 weeks.
325	417	J06.9	Vitals stable. Continue current plan.
326	419	R51.9	Referred to specialist.
327	420	M54.5	Medication adjusted. Recheck in 6 weeks.
328	421	K21.9	Referred to specialist.
329	422	E11.9	Preventive counseling provided.
330	423	M54.5	Vitals stable. Continue current plan.
331	424	L30.9	Preventive counseling provided.
332	425	J06.9	Referred to specialist.
333	426	N39.0	Referred to specialist.
334	428	M54.5	Reviewed symptoms and history.
335	429	R51.9	Reviewed symptoms and history.
336	431	F41.1	Discussed lab results with patient.
337	432	E11.9	Vitals stable. Continue current plan.
338	433	E11.9	Medication adjusted. Recheck in 6 weeks.
339	435	R51.9	Preventive counseling provided.
340	437	E78.5	Reviewed symptoms and history.
341	438	J45.909	Vitals stable. Continue current plan.
342	440	I10	Referred to specialist.
343	441	L30.9	Referred to specialist.
344	442	J06.9	Preventive counseling provided.
345	443	J45.909	Medication adjusted. Recheck in 6 weeks.
346	445	M54.5	Discussed lab results with patient.
347	446	I10	Reviewed symptoms and history.
348	449	L30.9	Medication adjusted. Recheck in 6 weeks.
349	450	J45.909	Preventive counseling provided.
350	451	J06.9	Medication adjusted. Recheck in 6 weeks.
351	452	N39.0	Medication adjusted. Recheck in 6 weeks.
352	453	J06.9	Reviewed symptoms and history.
353	455	M54.5	Reviewed symptoms and history.
354	456	E78.5	Medication adjusted. Recheck in 6 weeks.
355	457	E78.5	Discussed lab results with patient.
356	458	L30.9	Reviewed symptoms and history.
357	459	L30.9	Reviewed symptoms and history.
358	460	F41.1	Referred to specialist.
359	461	J06.9	Vitals stable. Continue current plan.
360	462	J45.909	Preventive counseling provided.
361	463	J45.909	Vitals stable. Continue current plan.
362	468	M54.5	Preventive counseling provided.
363	469	E11.9	Medication adjusted. Recheck in 6 weeks.
364	471	M54.5	Reviewed symptoms and history.
365	473	N39.0	Referred to specialist.
366	475	L30.9	Referred to specialist.
367	476	R51.9	Reviewed symptoms and history.
368	478	M54.5	Referred to specialist.
369	480	E78.5	Discussed lab results with patient.
370	481	J06.9	Referred to specialist.
371	482	E78.5	Referred to specialist.
372	484	J45.909	Preventive counseling provided.
373	485	L30.9	Referred to specialist.
374	486	R51.9	Reviewed symptoms and history.
375	492	I10	Referred to specialist.
376	493	J06.9	Referred to specialist.
377	494	K21.9	Reviewed symptoms and history.
378	495	M54.5	Vitals stable. Continue current plan.
379	496	I10	Discussed lab results with patient.
380	497	I10	Referred to specialist.
381	498	J06.9	Vitals stable. Continue current plan.
382	499	K21.9	Medication adjusted. Recheck in 6 weeks.
383	501	F41.1	Referred to specialist.
384	502	Z00.00	Discussed lab results with patient.
385	504	R51.9	Referred to specialist.
386	509	E78.5	Vitals stable. Continue current plan.
387	510	K21.9	Vitals stable. Continue current plan.
388	511	N39.0	Vitals stable. Continue current plan.
389	512	N39.0	Preventive counseling provided.
390	513	E11.9	Medication adjusted. Recheck in 6 weeks.
391	516	N39.0	Preventive counseling provided.
392	517	E11.9	Medication adjusted. Recheck in 6 weeks.
393	518	L30.9	Referred to specialist.
394	522	I10	Discussed lab results with patient.
395	523	J45.909	Reviewed symptoms and history.
396	524	N39.0	Reviewed symptoms and history.
397	525	Z00.00	Referred to specialist.
398	526	J45.909	Medication adjusted. Recheck in 6 weeks.
399	527	K21.9	Preventive counseling provided.
400	528	L30.9	Discussed lab results with patient.
401	530	E78.5	Vitals stable. Continue current plan.
402	531	Z00.00	Medication adjusted. Recheck in 6 weeks.
403	532	L30.9	Medication adjusted. Recheck in 6 weeks.
404	534	F41.1	Discussed lab results with patient.
405	535	Z00.00	Vitals stable. Continue current plan.
406	536	E78.5	Vitals stable. Continue current plan.
407	537	J06.9	Preventive counseling provided.
408	541	E11.9	Preventive counseling provided.
409	542	J45.909	Preventive counseling provided.
410	543	F41.1	Preventive counseling provided.
411	544	K21.9	Vitals stable. Continue current plan.
412	545	M54.5	Preventive counseling provided.
413	546	Z00.00	Reviewed symptoms and history.
414	548	M54.5	Discussed lab results with patient.
415	550	K21.9	Vitals stable. Continue current plan.
416	551	E11.9	Discussed lab results with patient.
417	552	R51.9	Discussed lab results with patient.
418	553	M54.5	Preventive counseling provided.
419	556	J06.9	Preventive counseling provided.
420	557	L30.9	Discussed lab results with patient.
421	558	M54.5	Discussed lab results with patient.
422	559	R51.9	Medication adjusted. Recheck in 6 weeks.
423	560	E78.5	Referred to specialist.
424	561	F41.1	Preventive counseling provided.
425	563	J06.9	Reviewed symptoms and history.
426	564	E78.5	Referred to specialist.
427	565	I10	Referred to specialist.
428	566	M54.5	Preventive counseling provided.
429	567	M54.5	Medication adjusted. Recheck in 6 weeks.
430	568	E78.5	Vitals stable. Continue current plan.
431	570	N39.0	Preventive counseling provided.
432	572	J06.9	Discussed lab results with patient.
433	573	I10	Referred to specialist.
434	574	L30.9	Referred to specialist.
435	576	E78.5	Preventive counseling provided.
436	577	I10	Referred to specialist.
437	579	F41.1	Discussed lab results with patient.
438	580	K21.9	Preventive counseling provided.
439	581	R51.9	Medication adjusted. Recheck in 6 weeks.
440	584	K21.9	Reviewed symptoms and history.
441	585	E78.5	Referred to specialist.
442	587	E78.5	Reviewed symptoms and history.
443	588	N39.0	Vitals stable. Continue current plan.
444	591	R51.9	Discussed lab results with patient.
445	592	K21.9	Preventive counseling provided.
446	593	F41.1	Discussed lab results with patient.
447	594	Z00.00	Discussed lab results with patient.
448	595	I10	Medication adjusted. Recheck in 6 weeks.
449	596	M54.5	Discussed lab results with patient.
450	598	M54.5	Discussed lab results with patient.
451	599	M54.5	Preventive counseling provided.
452	600	E11.9	Referred to specialist.
453	602	E11.9	Discussed lab results with patient.
454	603	J06.9	Preventive counseling provided.
455	605	K21.9	Referred to specialist.
456	606	J06.9	Vitals stable. Continue current plan.
457	607	K21.9	Vitals stable. Continue current plan.
458	608	I10	Vitals stable. Continue current plan.
459	609	Z00.00	Vitals stable. Continue current plan.
460	611	J45.909	Referred to specialist.
461	612	E11.9	Referred to specialist.
462	613	E78.5	Preventive counseling provided.
463	615	R51.9	Referred to specialist.
464	616	E78.5	Preventive counseling provided.
465	617	E78.5	Referred to specialist.
466	618	I10	Medication adjusted. Recheck in 6 weeks.
467	619	L30.9	Discussed lab results with patient.
468	622	E78.5	Medication adjusted. Recheck in 6 weeks.
469	623	J06.9	Discussed lab results with patient.
470	624	E11.9	Vitals stable. Continue current plan.
471	625	E11.9	Discussed lab results with patient.
472	627	J45.909	Discussed lab results with patient.
473	628	Z00.00	Reviewed symptoms and history.
474	630	E11.9	Discussed lab results with patient.
475	633	E11.9	Medication adjusted. Recheck in 6 weeks.
476	634	J45.909	Reviewed symptoms and history.
477	635	L30.9	Discussed lab results with patient.
478	636	L30.9	Preventive counseling provided.
479	638	R51.9	Discussed lab results with patient.
480	640	E78.5	Referred to specialist.
481	641	Z00.00	Medication adjusted. Recheck in 6 weeks.
482	642	I10	Referred to specialist.
483	643	F41.1	Preventive counseling provided.
484	644	J45.909	Preventive counseling provided.
485	646	E78.5	Vitals stable. Continue current plan.
486	647	M54.5	Referred to specialist.
487	648	J06.9	Discussed lab results with patient.
488	649	M54.5	Reviewed symptoms and history.
489	650	Z00.00	Reviewed symptoms and history.
490	651	J06.9	Preventive counseling provided.
491	652	J45.909	Discussed lab results with patient.
492	654	F41.1	Discussed lab results with patient.
493	655	I10	Reviewed symptoms and history.
494	657	Z00.00	Reviewed symptoms and history.
495	658	E78.5	Discussed lab results with patient.
496	660	F41.1	Medication adjusted. Recheck in 6 weeks.
497	661	J06.9	Preventive counseling provided.
498	662	E78.5	Preventive counseling provided.
499	663	R51.9	Vitals stable. Continue current plan.
500	664	I10	Medication adjusted. Recheck in 6 weeks.
501	667	M54.5	Preventive counseling provided.
502	669	E11.9	Discussed lab results with patient.
503	670	J06.9	Preventive counseling provided.
504	671	N39.0	Referred to specialist.
505	673	N39.0	Vitals stable. Continue current plan.
506	676	F41.1	Medication adjusted. Recheck in 6 weeks.
507	677	Z00.00	Referred to specialist.
508	678	J45.909	Referred to specialist.
509	680	I10	Medication adjusted. Recheck in 6 weeks.
510	682	I10	Vitals stable. Continue current plan.
511	683	J45.909	Medication adjusted. Recheck in 6 weeks.
512	684	N39.0	Preventive counseling provided.
513	685	E78.5	Vitals stable. Continue current plan.
514	687	K21.9	Preventive counseling provided.
515	688	E11.9	Medication adjusted. Recheck in 6 weeks.
516	689	M54.5	Medication adjusted. Recheck in 6 weeks.
517	690	M54.5	Reviewed symptoms and history.
518	691	J45.909	Reviewed symptoms and history.
519	692	L30.9	Reviewed symptoms and history.
520	696	I10	Medication adjusted. Recheck in 6 weeks.
521	697	L30.9	Reviewed symptoms and history.
522	698	M54.5	Referred to specialist.
523	699	J45.909	Medication adjusted. Recheck in 6 weeks.
524	700	K21.9	Medication adjusted. Recheck in 6 weeks.
525	701	J45.909	Preventive counseling provided.
526	702	N39.0	Vitals stable. Continue current plan.
527	703	F41.1	Referred to specialist.
528	705	L30.9	Medication adjusted. Recheck in 6 weeks.
529	706	R51.9	Discussed lab results with patient.
530	707	K21.9	Reviewed symptoms and history.
531	709	J06.9	Discussed lab results with patient.
532	710	Z00.00	Vitals stable. Continue current plan.
533	711	J06.9	Discussed lab results with patient.
534	712	E11.9	Discussed lab results with patient.
535	713	K21.9	Reviewed symptoms and history.
536	715	N39.0	Referred to specialist.
537	716	N39.0	Discussed lab results with patient.
538	717	K21.9	Vitals stable. Continue current plan.
539	718	K21.9	Medication adjusted. Recheck in 6 weeks.
540	719	M54.5	Medication adjusted. Recheck in 6 weeks.
541	721	K21.9	Reviewed symptoms and history.
542	723	R51.9	Medication adjusted. Recheck in 6 weeks.
543	724	L30.9	Referred to specialist.
544	725	L30.9	Reviewed symptoms and history.
545	726	Z00.00	Vitals stable. Continue current plan.
546	727	J45.909	Preventive counseling provided.
547	728	R51.9	Preventive counseling provided.
548	729	N39.0	Reviewed symptoms and history.
549	730	Z00.00	Referred to specialist.
550	731	M54.5	Preventive counseling provided.
551	732	F41.1	Vitals stable. Continue current plan.
552	733	N39.0	Vitals stable. Continue current plan.
553	735	L30.9	Referred to specialist.
554	737	L30.9	Referred to specialist.
555	738	N39.0	Reviewed symptoms and history.
556	739	L30.9	Medication adjusted. Recheck in 6 weeks.
557	740	Z00.00	Preventive counseling provided.
558	741	N39.0	Reviewed symptoms and history.
559	743	E11.9	Medication adjusted. Recheck in 6 weeks.
560	744	J45.909	Reviewed symptoms and history.
561	746	E78.5	Referred to specialist.
562	750	E11.9	Medication adjusted. Recheck in 6 weeks.
563	751	N39.0	Discussed lab results with patient.
564	752	R51.9	Referred to specialist.
565	753	J06.9	Vitals stable. Continue current plan.
566	754	I10	Medication adjusted. Recheck in 6 weeks.
567	755	I10	Medication adjusted. Recheck in 6 weeks.
568	756	J45.909	Medication adjusted. Recheck in 6 weeks.
569	757	E78.5	Reviewed symptoms and history.
570	758	J06.9	Referred to specialist.
571	759	N39.0	Vitals stable. Continue current plan.
572	760	Z00.00	Vitals stable. Continue current plan.
573	761	I10	Vitals stable. Continue current plan.
574	762	J06.9	Referred to specialist.
575	763	K21.9	Vitals stable. Continue current plan.
576	764	N39.0	Vitals stable. Continue current plan.
577	766	E78.5	Preventive counseling provided.
578	768	N39.0	Medication adjusted. Recheck in 6 weeks.
579	769	J45.909	Preventive counseling provided.
580	770	L30.9	Discussed lab results with patient.
581	771	M54.5	Referred to specialist.
582	772	E78.5	Medication adjusted. Recheck in 6 weeks.
583	773	N39.0	Discussed lab results with patient.
584	775	R51.9	Referred to specialist.
585	776	K21.9	Medication adjusted. Recheck in 6 weeks.
586	777	E78.5	Referred to specialist.
587	778	M54.5	Vitals stable. Continue current plan.
588	779	K21.9	Medication adjusted. Recheck in 6 weeks.
589	780	M54.5	Discussed lab results with patient.
590	781	M54.5	Vitals stable. Continue current plan.
591	782	J06.9	Discussed lab results with patient.
592	785	J06.9	Discussed lab results with patient.
593	788	K21.9	Discussed lab results with patient.
594	790	J45.909	Medication adjusted. Recheck in 6 weeks.
595	791	F41.1	Discussed lab results with patient.
596	792	E78.5	Discussed lab results with patient.
597	794	E11.9	Discussed lab results with patient.
598	796	N39.0	Medication adjusted. Recheck in 6 weeks.
599	797	N39.0	Preventive counseling provided.
600	799	K21.9	Reviewed symptoms and history.
601	800	Z00.00	Medication adjusted. Recheck in 6 weeks.
602	801	K21.9	Vitals stable. Continue current plan.
603	802	K21.9	Vitals stable. Continue current plan.
604	804	K21.9	Vitals stable. Continue current plan.
605	805	J45.909	Discussed lab results with patient.
606	807	M54.5	Vitals stable. Continue current plan.
607	808	N39.0	Vitals stable. Continue current plan.
608	809	E78.5	Reviewed symptoms and history.
609	811	L30.9	Discussed lab results with patient.
610	812	F41.1	Reviewed symptoms and history.
611	815	I10	Medication adjusted. Recheck in 6 weeks.
612	816	Z00.00	Medication adjusted. Recheck in 6 weeks.
613	817	F41.1	Preventive counseling provided.
614	818	M54.5	Vitals stable. Continue current plan.
615	820	E78.5	Referred to specialist.
616	821	R51.9	Medication adjusted. Recheck in 6 weeks.
617	822	R51.9	Discussed lab results with patient.
618	823	L30.9	Preventive counseling provided.
619	824	F41.1	Medication adjusted. Recheck in 6 weeks.
620	826	F41.1	Reviewed symptoms and history.
621	827	I10	Vitals stable. Continue current plan.
622	830	R51.9	Vitals stable. Continue current plan.
623	832	L30.9	Discussed lab results with patient.
624	833	I10	Discussed lab results with patient.
625	834	F41.1	Preventive counseling provided.
626	837	E11.9	Discussed lab results with patient.
627	838	N39.0	Preventive counseling provided.
628	839	M54.5	Discussed lab results with patient.
629	841	K21.9	Vitals stable. Continue current plan.
630	842	Z00.00	Referred to specialist.
631	844	E11.9	Reviewed symptoms and history.
632	847	I10	Reviewed symptoms and history.
633	848	F41.1	Preventive counseling provided.
634	849	Z00.00	Referred to specialist.
635	850	J45.909	Vitals stable. Continue current plan.
636	853	Z00.00	Referred to specialist.
637	854	J06.9	Preventive counseling provided.
638	856	J06.9	Referred to specialist.
639	857	F41.1	Reviewed symptoms and history.
640	858	E78.5	Preventive counseling provided.
641	860	L30.9	Reviewed symptoms and history.
642	861	K21.9	Medication adjusted. Recheck in 6 weeks.
643	862	I10	Vitals stable. Continue current plan.
644	863	E11.9	Discussed lab results with patient.
645	866	J06.9	Reviewed symptoms and history.
646	867	I10	Referred to specialist.
647	868	L30.9	Discussed lab results with patient.
648	869	K21.9	Medication adjusted. Recheck in 6 weeks.
649	871	Z00.00	Reviewed symptoms and history.
650	872	M54.5	Medication adjusted. Recheck in 6 weeks.
651	873	N39.0	Reviewed symptoms and history.
652	874	L30.9	Medication adjusted. Recheck in 6 weeks.
653	875	M54.5	Discussed lab results with patient.
654	876	F41.1	Reviewed symptoms and history.
655	877	F41.1	Reviewed symptoms and history.
656	878	Z00.00	Medication adjusted. Recheck in 6 weeks.
657	879	N39.0	Vitals stable. Continue current plan.
658	880	R51.9	Vitals stable. Continue current plan.
659	882	E11.9	Reviewed symptoms and history.
660	883	J45.909	Reviewed symptoms and history.
661	884	J06.9	Reviewed symptoms and history.
662	885	K21.9	Reviewed symptoms and history.
663	886	I10	Reviewed symptoms and history.
664	888	J45.909	Reviewed symptoms and history.
665	889	M54.5	Medication adjusted. Recheck in 6 weeks.
666	890	R51.9	Preventive counseling provided.
667	892	K21.9	Reviewed symptoms and history.
668	895	J45.909	Medication adjusted. Recheck in 6 weeks.
669	897	J45.909	Discussed lab results with patient.
670	899	I10	Preventive counseling provided.
671	901	K21.9	Referred to specialist.
672	903	I10	Preventive counseling provided.
673	905	I10	Discussed lab results with patient.
674	906	E11.9	Referred to specialist.
675	907	M54.5	Vitals stable. Continue current plan.
676	909	N39.0	Vitals stable. Continue current plan.
677	911	Z00.00	Reviewed symptoms and history.
678	912	Z00.00	Medication adjusted. Recheck in 6 weeks.
679	914	M54.5	Referred to specialist.
680	917	R51.9	Preventive counseling provided.
681	918	N39.0	Medication adjusted. Recheck in 6 weeks.
682	920	I10	Medication adjusted. Recheck in 6 weeks.
683	921	E11.9	Reviewed symptoms and history.
684	922	E78.5	Vitals stable. Continue current plan.
685	924	J45.909	Discussed lab results with patient.
686	925	J06.9	Medication adjusted. Recheck in 6 weeks.
687	926	I10	Medication adjusted. Recheck in 6 weeks.
688	927	E78.5	Reviewed symptoms and history.
689	928	F41.1	Reviewed symptoms and history.
690	929	E11.9	Vitals stable. Continue current plan.
691	930	I10	Reviewed symptoms and history.
692	932	M54.5	Preventive counseling provided.
693	933	R51.9	Preventive counseling provided.
694	934	N39.0	Referred to specialist.
695	935	E11.9	Discussed lab results with patient.
696	936	E11.9	Vitals stable. Continue current plan.
697	937	J06.9	Reviewed symptoms and history.
698	938	M54.5	Referred to specialist.
699	939	E11.9	Vitals stable. Continue current plan.
700	940	I10	Reviewed symptoms and history.
701	945	I10	Vitals stable. Continue current plan.
702	946	J45.909	Vitals stable. Continue current plan.
703	948	R51.9	Referred to specialist.
704	949	N39.0	Medication adjusted. Recheck in 6 weeks.
705	950	F41.1	Reviewed symptoms and history.
706	951	L30.9	Vitals stable. Continue current plan.
707	952	E11.9	Vitals stable. Continue current plan.
708	953	Z00.00	Vitals stable. Continue current plan.
709	954	N39.0	Discussed lab results with patient.
710	958	M54.5	Discussed lab results with patient.
711	959	M54.5	Referred to specialist.
712	960	E11.9	Preventive counseling provided.
713	961	E78.5	Discussed lab results with patient.
714	962	J06.9	Reviewed symptoms and history.
715	963	L30.9	Preventive counseling provided.
716	965	E11.9	Vitals stable. Continue current plan.
717	966	M54.5	Vitals stable. Continue current plan.
718	969	Z00.00	Medication adjusted. Recheck in 6 weeks.
719	970	Z00.00	Medication adjusted. Recheck in 6 weeks.
720	971	M54.5	Referred to specialist.
721	973	M54.5	Preventive counseling provided.
722	974	J45.909	Vitals stable. Continue current plan.
723	975	M54.5	Vitals stable. Continue current plan.
724	976	K21.9	Discussed lab results with patient.
725	977	M54.5	Medication adjusted. Recheck in 6 weeks.
726	978	N39.0	Medication adjusted. Recheck in 6 weeks.
727	979	M54.5	Vitals stable. Continue current plan.
728	980	L30.9	Medication adjusted. Recheck in 6 weeks.
729	983	N39.0	Discussed lab results with patient.
730	984	K21.9	Discussed lab results with patient.
731	985	E11.9	Vitals stable. Continue current plan.
732	986	I10	Vitals stable. Continue current plan.
733	987	E78.5	Referred to specialist.
734	989	I10	Discussed lab results with patient.
735	990	J06.9	Discussed lab results with patient.
736	991	J06.9	Preventive counseling provided.
737	994	I10	Reviewed symptoms and history.
738	996	N39.0	Discussed lab results with patient.
739	997	J06.9	Reviewed symptoms and history.
740	999	M54.5	Referred to specialist.
741	1002	J45.909	Discussed lab results with patient.
742	1005	M54.5	Medication adjusted. Recheck in 6 weeks.
743	1008	N39.0	Preventive counseling provided.
744	1010	F41.1	Reviewed symptoms and history.
745	1011	J45.909	Reviewed symptoms and history.
746	1012	Z00.00	Vitals stable. Continue current plan.
747	1013	M54.5	Reviewed symptoms and history.
748	1014	E11.9	Medication adjusted. Recheck in 6 weeks.
749	1015	M54.5	Preventive counseling provided.
750	1017	K21.9	Reviewed symptoms and history.
751	1018	M54.5	Discussed lab results with patient.
752	1020	I10	Reviewed symptoms and history.
753	1021	F41.1	Vitals stable. Continue current plan.
754	1022	I10	Reviewed symptoms and history.
755	1024	K21.9	Preventive counseling provided.
756	1025	E11.9	Reviewed symptoms and history.
757	1027	E78.5	Preventive counseling provided.
758	1028	J45.909	Medication adjusted. Recheck in 6 weeks.
759	1029	L30.9	Referred to specialist.
760	1031	K21.9	Referred to specialist.
761	1032	K21.9	Referred to specialist.
762	1034	E11.9	Reviewed symptoms and history.
763	1035	N39.0	Preventive counseling provided.
764	1037	J06.9	Vitals stable. Continue current plan.
765	1038	E11.9	Reviewed symptoms and history.
766	1039	E11.9	Reviewed symptoms and history.
767	1040	R51.9	Vitals stable. Continue current plan.
768	1041	Z00.00	Reviewed symptoms and history.
769	1042	E78.5	Referred to specialist.
770	1043	J06.9	Discussed lab results with patient.
771	1044	M54.5	Preventive counseling provided.
772	1045	I10	Preventive counseling provided.
773	1046	M54.5	Medication adjusted. Recheck in 6 weeks.
774	1047	J45.909	Vitals stable. Continue current plan.
775	1048	J06.9	Preventive counseling provided.
776	1049	F41.1	Preventive counseling provided.
777	1050	L30.9	Referred to specialist.
778	1052	J45.909	Vitals stable. Continue current plan.
779	1053	I10	Referred to specialist.
780	1054	F41.1	Referred to specialist.
781	1056	E11.9	Vitals stable. Continue current plan.
782	1058	J06.9	Reviewed symptoms and history.
783	1059	F41.1	Reviewed symptoms and history.
784	1060	L30.9	Referred to specialist.
785	1061	E78.5	Reviewed symptoms and history.
786	1062	Z00.00	Referred to specialist.
787	1063	J06.9	Vitals stable. Continue current plan.
788	1064	F41.1	Vitals stable. Continue current plan.
789	1066	K21.9	Medication adjusted. Recheck in 6 weeks.
790	1067	Z00.00	Discussed lab results with patient.
791	1068	M54.5	Medication adjusted. Recheck in 6 weeks.
792	1069	L30.9	Reviewed symptoms and history.
793	1071	N39.0	Preventive counseling provided.
794	1072	J45.909	Discussed lab results with patient.
795	1073	M54.5	Referred to specialist.
796	1074	N39.0	Referred to specialist.
797	1075	N39.0	Preventive counseling provided.
798	1076	F41.1	Reviewed symptoms and history.
799	1077	E78.5	Referred to specialist.
800	1079	M54.5	Discussed lab results with patient.
801	1080	I10	Preventive counseling provided.
802	1081	J45.909	Referred to specialist.
803	1082	J45.909	Medication adjusted. Recheck in 6 weeks.
804	1083	K21.9	Preventive counseling provided.
805	1085	J06.9	Medication adjusted. Recheck in 6 weeks.
806	1086	M54.5	Medication adjusted. Recheck in 6 weeks.
807	1088	R51.9	Preventive counseling provided.
808	1090	J06.9	Medication adjusted. Recheck in 6 weeks.
809	1091	Z00.00	Referred to specialist.
810	1093	K21.9	Medication adjusted. Recheck in 6 weeks.
811	1094	L30.9	Reviewed symptoms and history.
812	1095	E78.5	Referred to specialist.
813	1097	Z00.00	Vitals stable. Continue current plan.
814	1098	J45.909	Medication adjusted. Recheck in 6 weeks.
815	1102	J45.909	Discussed lab results with patient.
816	1103	I10	Vitals stable. Continue current plan.
817	1104	R51.9	Referred to specialist.
818	1106	M54.5	Reviewed symptoms and history.
819	1107	N39.0	Reviewed symptoms and history.
820	1108	Z00.00	Medication adjusted. Recheck in 6 weeks.
821	1109	F41.1	Medication adjusted. Recheck in 6 weeks.
822	1110	R51.9	Discussed lab results with patient.
823	1111	R51.9	Vitals stable. Continue current plan.
824	1114	I10	Vitals stable. Continue current plan.
825	1115	K21.9	Vitals stable. Continue current plan.
826	1116	J45.909	Preventive counseling provided.
827	1117	F41.1	Preventive counseling provided.
828	1118	E78.5	Reviewed symptoms and history.
829	1122	E11.9	Preventive counseling provided.
830	1125	L30.9	Discussed lab results with patient.
831	1126	J45.909	Vitals stable. Continue current plan.
832	1127	Z00.00	Preventive counseling provided.
833	1128	Z00.00	Medication adjusted. Recheck in 6 weeks.
834	1129	E11.9	Medication adjusted. Recheck in 6 weeks.
835	1130	J06.9	Preventive counseling provided.
836	1131	I10	Referred to specialist.
837	1132	N39.0	Medication adjusted. Recheck in 6 weeks.
838	1133	J06.9	Vitals stable. Continue current plan.
839	1134	M54.5	Medication adjusted. Recheck in 6 weeks.
840	1135	E11.9	Preventive counseling provided.
841	1136	J06.9	Medication adjusted. Recheck in 6 weeks.
842	1137	F41.1	Medication adjusted. Recheck in 6 weeks.
843	1138	E78.5	Reviewed symptoms and history.
844	1139	J45.909	Discussed lab results with patient.
845	1142	K21.9	Medication adjusted. Recheck in 6 weeks.
846	1143	L30.9	Preventive counseling provided.
847	1144	J06.9	Reviewed symptoms and history.
848	1145	J45.909	Discussed lab results with patient.
849	1146	R51.9	Medication adjusted. Recheck in 6 weeks.
850	1147	N39.0	Vitals stable. Continue current plan.
851	1149	M54.5	Preventive counseling provided.
852	1151	E78.5	Reviewed symptoms and history.
853	1152	N39.0	Vitals stable. Continue current plan.
854	1153	L30.9	Reviewed symptoms and history.
855	1154	R51.9	Vitals stable. Continue current plan.
856	1155	I10	Vitals stable. Continue current plan.
857	1156	E11.9	Discussed lab results with patient.
858	1157	E78.5	Reviewed symptoms and history.
859	1160	L30.9	Reviewed symptoms and history.
860	1161	F41.1	Discussed lab results with patient.
861	1163	I10	Vitals stable. Continue current plan.
862	1164	L30.9	Medication adjusted. Recheck in 6 weeks.
863	1165	J06.9	Discussed lab results with patient.
864	1166	L30.9	Reviewed symptoms and history.
865	1167	K21.9	Reviewed symptoms and history.
866	1169	M54.5	Vitals stable. Continue current plan.
867	1170	E11.9	Vitals stable. Continue current plan.
868	1171	M54.5	Vitals stable. Continue current plan.
869	1172	Z00.00	Preventive counseling provided.
870	1173	N39.0	Referred to specialist.
871	1174	E78.5	Referred to specialist.
872	1175	J45.909	Preventive counseling provided.
873	1178	E11.9	Vitals stable. Continue current plan.
874	1179	E78.5	Referred to specialist.
875	1180	J06.9	Discussed lab results with patient.
876	1181	Z00.00	Referred to specialist.
877	1182	I10	Vitals stable. Continue current plan.
878	1185	E11.9	Preventive counseling provided.
879	1186	Z00.00	Preventive counseling provided.
880	1187	L30.9	Reviewed symptoms and history.
881	1189	L30.9	Discussed lab results with patient.
882	1191	J06.9	Referred to specialist.
883	1192	F41.1	Vitals stable. Continue current plan.
884	1193	R51.9	Medication adjusted. Recheck in 6 weeks.
885	1194	J06.9	Reviewed symptoms and history.
886	1195	K21.9	Vitals stable. Continue current plan.
887	1196	Z00.00	Vitals stable. Continue current plan.
888	1197	Z00.00	Referred to specialist.
889	1198	F41.1	Vitals stable. Continue current plan.
890	1199	F41.1	Referred to specialist.
891	1201	J06.9	Vitals stable. Continue current plan.
892	1203	J06.9	Reviewed symptoms and history.
893	1205	F41.1	Vitals stable. Continue current plan.
894	1206	I10	Referred to specialist.
895	1207	E78.5	Preventive counseling provided.
896	1208	I10	Referred to specialist.
897	1209	J45.909	Vitals stable. Continue current plan.
898	1210	K21.9	Discussed lab results with patient.
899	1212	Z00.00	Medication adjusted. Recheck in 6 weeks.
900	1214	J06.9	Medication adjusted. Recheck in 6 weeks.
901	1215	K21.9	Preventive counseling provided.
902	1216	F41.1	Vitals stable. Continue current plan.
903	1217	I10	Discussed lab results with patient.
904	1218	Z00.00	Discussed lab results with patient.
905	1219	K21.9	Referred to specialist.
906	1221	E78.5	Referred to specialist.
907	1222	N39.0	Referred to specialist.
908	1223	Z00.00	Vitals stable. Continue current plan.
909	1224	L30.9	Referred to specialist.
910	1225	F41.1	Reviewed symptoms and history.
911	1226	L30.9	Discussed lab results with patient.
912	1227	E11.9	Medication adjusted. Recheck in 6 weeks.
913	1229	F41.1	Preventive counseling provided.
914	1230	E11.9	Preventive counseling provided.
915	1231	L30.9	Medication adjusted. Recheck in 6 weeks.
916	1234	I10	Reviewed symptoms and history.
917	1235	M54.5	Medication adjusted. Recheck in 6 weeks.
918	1237	L30.9	Vitals stable. Continue current plan.
919	1238	J45.909	Preventive counseling provided.
920	1239	J45.909	Medication adjusted. Recheck in 6 weeks.
921	1241	J06.9	Preventive counseling provided.
922	1242	N39.0	Medication adjusted. Recheck in 6 weeks.
923	1243	L30.9	Discussed lab results with patient.
924	1244	F41.1	Discussed lab results with patient.
925	1245	J06.9	Medication adjusted. Recheck in 6 weeks.
926	1246	J06.9	Reviewed symptoms and history.
927	1247	K21.9	Referred to specialist.
928	1248	I10	Reviewed symptoms and history.
929	1249	I10	Vitals stable. Continue current plan.
930	1251	K21.9	Preventive counseling provided.
931	1252	J45.909	Vitals stable. Continue current plan.
932	1254	R51.9	Preventive counseling provided.
933	1255	N39.0	Discussed lab results with patient.
934	1256	E78.5	Preventive counseling provided.
935	1257	N39.0	Medication adjusted. Recheck in 6 weeks.
936	1258	E11.9	Preventive counseling provided.
937	1259	M54.5	Medication adjusted. Recheck in 6 weeks.
938	1260	E78.5	Referred to specialist.
939	1261	E78.5	Reviewed symptoms and history.
940	1264	F41.1	Reviewed symptoms and history.
941	1266	F41.1	Referred to specialist.
942	1267	N39.0	Preventive counseling provided.
943	1268	F41.1	Discussed lab results with patient.
944	1270	R51.9	Referred to specialist.
945	1272	F41.1	Vitals stable. Continue current plan.
946	1274	L30.9	Referred to specialist.
947	1275	R51.9	Discussed lab results with patient.
948	1276	L30.9	Preventive counseling provided.
949	1277	N39.0	Vitals stable. Continue current plan.
950	1278	N39.0	Referred to specialist.
951	1279	E78.5	Discussed lab results with patient.
952	1280	E78.5	Referred to specialist.
953	1281	M54.5	Referred to specialist.
954	1283	L30.9	Preventive counseling provided.
955	1285	Z00.00	Preventive counseling provided.
956	1287	R51.9	Discussed lab results with patient.
957	1288	N39.0	Preventive counseling provided.
958	1292	E78.5	Preventive counseling provided.
959	1293	K21.9	Discussed lab results with patient.
960	1294	K21.9	Reviewed symptoms and history.
961	1295	Z00.00	Discussed lab results with patient.
962	1297	E78.5	Referred to specialist.
963	1300	J45.909	Vitals stable. Continue current plan.
964	1304	N39.0	Medication adjusted. Recheck in 6 weeks.
965	1305	L30.9	Reviewed symptoms and history.
966	1306	R51.9	Reviewed symptoms and history.
967	1309	K21.9	Vitals stable. Continue current plan.
968	1311	R51.9	Discussed lab results with patient.
969	1312	E78.5	Discussed lab results with patient.
970	1313	L30.9	Preventive counseling provided.
971	1316	I10	Discussed lab results with patient.
972	1318	L30.9	Discussed lab results with patient.
973	1319	K21.9	Referred to specialist.
974	1320	K21.9	Referred to specialist.
975	1321	N39.0	Medication adjusted. Recheck in 6 weeks.
976	1322	Z00.00	Medication adjusted. Recheck in 6 weeks.
977	1323	E78.5	Medication adjusted. Recheck in 6 weeks.
978	1324	L30.9	Discussed lab results with patient.
979	1325	E11.9	Preventive counseling provided.
980	1326	K21.9	Vitals stable. Continue current plan.
981	1328	E78.5	Discussed lab results with patient.
982	1329	J06.9	Preventive counseling provided.
983	1331	R51.9	Preventive counseling provided.
984	1332	K21.9	Discussed lab results with patient.
985	1333	M54.5	Referred to specialist.
986	1334	R51.9	Discussed lab results with patient.
987	1337	J45.909	Preventive counseling provided.
988	1340	J06.9	Vitals stable. Continue current plan.
989	1341	E11.9	Vitals stable. Continue current plan.
990	1342	J45.909	Vitals stable. Continue current plan.
991	1343	K21.9	Discussed lab results with patient.
992	1345	Z00.00	Vitals stable. Continue current plan.
993	1346	F41.1	Discussed lab results with patient.
994	1347	I10	Preventive counseling provided.
995	1348	F41.1	Medication adjusted. Recheck in 6 weeks.
996	1349	J06.9	Referred to specialist.
997	1350	F41.1	Preventive counseling provided.
998	1352	E11.9	Preventive counseling provided.
999	1353	E78.5	Discussed lab results with patient.
1000	1355	F41.1	Reviewed symptoms and history.
1001	1356	M54.5	Discussed lab results with patient.
1002	1358	J06.9	Preventive counseling provided.
1003	1359	L30.9	Vitals stable. Continue current plan.
1004	1360	F41.1	Referred to specialist.
1005	1361	M54.5	Preventive counseling provided.
1006	1363	M54.5	Medication adjusted. Recheck in 6 weeks.
1007	1366	L30.9	Medication adjusted. Recheck in 6 weeks.
1008	1367	J06.9	Discussed lab results with patient.
1009	1368	J06.9	Referred to specialist.
1010	1369	E11.9	Vitals stable. Continue current plan.
1011	1370	N39.0	Preventive counseling provided.
1012	1371	K21.9	Reviewed symptoms and history.
1013	1372	N39.0	Vitals stable. Continue current plan.
1014	1374	N39.0	Discussed lab results with patient.
1015	1377	F41.1	Vitals stable. Continue current plan.
1016	1378	F41.1	Reviewed symptoms and history.
1017	1379	I10	Discussed lab results with patient.
1018	1380	L30.9	Preventive counseling provided.
1019	1381	N39.0	Referred to specialist.
1020	1383	E78.5	Referred to specialist.
1021	1384	I10	Medication adjusted. Recheck in 6 weeks.
1022	1386	L30.9	Vitals stable. Continue current plan.
1023	1388	Z00.00	Vitals stable. Continue current plan.
1024	1389	J45.909	Reviewed symptoms and history.
1025	1390	M54.5	Preventive counseling provided.
1026	1391	I10	Medication adjusted. Recheck in 6 weeks.
1027	1392	E11.9	Vitals stable. Continue current plan.
1028	1393	E78.5	Medication adjusted. Recheck in 6 weeks.
1029	1394	J06.9	Medication adjusted. Recheck in 6 weeks.
1030	1395	M54.5	Vitals stable. Continue current plan.
1031	1396	J45.909	Referred to specialist.
1032	1397	Z00.00	Referred to specialist.
1033	1398	R51.9	Reviewed symptoms and history.
1034	1399	E11.9	Preventive counseling provided.
1035	1400	R51.9	Preventive counseling provided.
1036	1401	J45.909	Vitals stable. Continue current plan.
1037	1402	I10	Preventive counseling provided.
1038	1403	I10	Vitals stable. Continue current plan.
1039	1406	M54.5	Reviewed symptoms and history.
1040	1407	J06.9	Vitals stable. Continue current plan.
1041	1408	I10	Reviewed symptoms and history.
1042	1410	K21.9	Medication adjusted. Recheck in 6 weeks.
1043	1411	K21.9	Preventive counseling provided.
1044	1412	E78.5	Reviewed symptoms and history.
1045	1413	M54.5	Referred to specialist.
1046	1414	K21.9	Vitals stable. Continue current plan.
1047	1416	E78.5	Referred to specialist.
1048	1419	K21.9	Referred to specialist.
1049	1420	J45.909	Medication adjusted. Recheck in 6 weeks.
1050	1421	L30.9	Vitals stable. Continue current plan.
1051	1422	F41.1	Referred to specialist.
1052	1423	J06.9	Vitals stable. Continue current plan.
1053	1424	J45.909	Preventive counseling provided.
1054	1426	J45.909	Medication adjusted. Recheck in 6 weeks.
1055	1427	R51.9	Preventive counseling provided.
1056	1428	E11.9	Preventive counseling provided.
1057	1430	R51.9	Medication adjusted. Recheck in 6 weeks.
1058	1432	E11.9	Referred to specialist.
1059	1434	E78.5	Discussed lab results with patient.
1060	1435	L30.9	Medication adjusted. Recheck in 6 weeks.
1061	1436	E78.5	Discussed lab results with patient.
1062	1437	M54.5	Vitals stable. Continue current plan.
1063	1438	M54.5	Discussed lab results with patient.
1064	1439	F41.1	Preventive counseling provided.
1065	1440	N39.0	Medication adjusted. Recheck in 6 weeks.
1066	1442	Z00.00	Medication adjusted. Recheck in 6 weeks.
1067	1443	J06.9	Referred to specialist.
1068	1444	L30.9	Reviewed symptoms and history.
1069	1446	R51.9	Medication adjusted. Recheck in 6 weeks.
1070	1447	E11.9	Medication adjusted. Recheck in 6 weeks.
1071	1450	L30.9	Reviewed symptoms and history.
1072	1451	E78.5	Preventive counseling provided.
1073	1453	E78.5	Preventive counseling provided.
1074	1454	F41.1	Medication adjusted. Recheck in 6 weeks.
1075	1456	N39.0	Vitals stable. Continue current plan.
1076	1457	E11.9	Referred to specialist.
1077	1458	K21.9	Vitals stable. Continue current plan.
1078	1459	I10	Discussed lab results with patient.
1079	1460	K21.9	Discussed lab results with patient.
1080	1461	F41.1	Discussed lab results with patient.
1081	1462	J45.909	Vitals stable. Continue current plan.
1082	1465	N39.0	Medication adjusted. Recheck in 6 weeks.
1083	1466	J06.9	Referred to specialist.
1084	1467	E78.5	Referred to specialist.
1085	1471	Z00.00	Referred to specialist.
1086	1472	J06.9	Preventive counseling provided.
1087	1473	E78.5	Medication adjusted. Recheck in 6 weeks.
1088	1475	Z00.00	Vitals stable. Continue current plan.
1089	1476	E11.9	Vitals stable. Continue current plan.
1090	1477	E78.5	Medication adjusted. Recheck in 6 weeks.
1091	1479	I10	Preventive counseling provided.
1092	1480	J45.909	Medication adjusted. Recheck in 6 weeks.
1093	1481	E11.9	Referred to specialist.
1094	1482	M54.5	Medication adjusted. Recheck in 6 weeks.
1095	1483	K21.9	Preventive counseling provided.
1096	1486	K21.9	Vitals stable. Continue current plan.
1097	1488	J45.909	Medication adjusted. Recheck in 6 weeks.
1098	1492	R51.9	Discussed lab results with patient.
1099	1493	N39.0	Reviewed symptoms and history.
1100	1494	J06.9	Referred to specialist.
1101	1495	K21.9	Medication adjusted. Recheck in 6 weeks.
1102	1496	I10	Referred to specialist.
1103	1497	K21.9	Preventive counseling provided.
1104	1498	E11.9	Referred to specialist.
1105	1499	I10	Medication adjusted. Recheck in 6 weeks.
1106	1500	Z00.00	Medication adjusted. Recheck in 6 weeks.
1107	1501	K21.9	Medication adjusted. Recheck in 6 weeks.
1108	1502	E78.5	Vitals stable. Continue current plan.
1109	1505	N39.0	Reviewed symptoms and history.
1110	1506	E11.9	Reviewed symptoms and history.
1111	1507	E78.5	Preventive counseling provided.
1112	1509	J45.909	Reviewed symptoms and history.
1113	1510	R51.9	Referred to specialist.
1114	1512	R51.9	Vitals stable. Continue current plan.
1115	1513	E11.9	Reviewed symptoms and history.
1116	1514	J06.9	Preventive counseling provided.
1117	1516	Z00.00	Discussed lab results with patient.
1118	1517	L30.9	Referred to specialist.
1119	1519	M54.5	Vitals stable. Continue current plan.
1120	1521	N39.0	Preventive counseling provided.
1121	1524	F41.1	Referred to specialist.
1122	1525	E11.9	Reviewed symptoms and history.
1123	1526	J45.909	Medication adjusted. Recheck in 6 weeks.
1124	1527	Z00.00	Medication adjusted. Recheck in 6 weeks.
1125	1528	L30.9	Vitals stable. Continue current plan.
1126	1529	E78.5	Medication adjusted. Recheck in 6 weeks.
1127	1530	N39.0	Preventive counseling provided.
1128	1532	F41.1	Vitals stable. Continue current plan.
1129	1533	Z00.00	Medication adjusted. Recheck in 6 weeks.
1130	1534	E11.9	Medication adjusted. Recheck in 6 weeks.
1131	1535	L30.9	Vitals stable. Continue current plan.
1132	1536	E78.5	Preventive counseling provided.
1133	1537	R51.9	Discussed lab results with patient.
1134	1538	N39.0	Medication adjusted. Recheck in 6 weeks.
1135	1540	L30.9	Medication adjusted. Recheck in 6 weeks.
1136	1541	E78.5	Referred to specialist.
1137	1542	L30.9	Preventive counseling provided.
1138	1544	E78.5	Vitals stable. Continue current plan.
1139	1545	I10	Reviewed symptoms and history.
1140	1547	Z00.00	Vitals stable. Continue current plan.
1141	1548	J45.909	Vitals stable. Continue current plan.
1142	1550	J06.9	Vitals stable. Continue current plan.
1143	1551	E78.5	Vitals stable. Continue current plan.
1144	1552	Z00.00	Discussed lab results with patient.
1145	1553	L30.9	Vitals stable. Continue current plan.
1146	1554	K21.9	Vitals stable. Continue current plan.
1147	1556	F41.1	Preventive counseling provided.
1148	1557	L30.9	Medication adjusted. Recheck in 6 weeks.
1149	1558	M54.5	Medication adjusted. Recheck in 6 weeks.
1150	1559	L30.9	Referred to specialist.
1151	1560	F41.1	Medication adjusted. Recheck in 6 weeks.
1152	1561	Z00.00	Preventive counseling provided.
1153	1563	E78.5	Discussed lab results with patient.
1154	1564	Z00.00	Medication adjusted. Recheck in 6 weeks.
1155	1567	J45.909	Referred to specialist.
1156	1568	J06.9	Medication adjusted. Recheck in 6 weeks.
1157	1569	I10	Discussed lab results with patient.
1158	1570	F41.1	Preventive counseling provided.
1159	1572	F41.1	Preventive counseling provided.
1160	1573	F41.1	Referred to specialist.
1161	1574	E11.9	Medication adjusted. Recheck in 6 weeks.
1162	1575	M54.5	Vitals stable. Continue current plan.
1163	1577	K21.9	Medication adjusted. Recheck in 6 weeks.
1164	1578	L30.9	Reviewed symptoms and history.
1165	1579	E11.9	Preventive counseling provided.
1166	1580	K21.9	Preventive counseling provided.
1167	1581	K21.9	Reviewed symptoms and history.
1168	1582	L30.9	Discussed lab results with patient.
1169	1583	K21.9	Referred to specialist.
1170	1586	F41.1	Reviewed symptoms and history.
1171	1587	L30.9	Preventive counseling provided.
1172	1588	R51.9	Discussed lab results with patient.
1173	1589	K21.9	Referred to specialist.
1174	1591	I10	Referred to specialist.
1175	1592	L30.9	Discussed lab results with patient.
1176	1595	Z00.00	Preventive counseling provided.
1177	1596	J45.909	Preventive counseling provided.
1178	1597	M54.5	Preventive counseling provided.
1179	1601	M54.5	Referred to specialist.
1180	1602	M54.5	Discussed lab results with patient.
1181	1603	K21.9	Medication adjusted. Recheck in 6 weeks.
1182	1604	J06.9	Discussed lab results with patient.
1183	1605	K21.9	Vitals stable. Continue current plan.
1184	1606	R51.9	Reviewed symptoms and history.
1185	1607	R51.9	Vitals stable. Continue current plan.
1186	1609	I10	Discussed lab results with patient.
1187	1610	E11.9	Reviewed symptoms and history.
1188	1611	K21.9	Discussed lab results with patient.
1189	1614	J45.909	Medication adjusted. Recheck in 6 weeks.
1190	1615	J06.9	Medication adjusted. Recheck in 6 weeks.
1191	1616	J06.9	Preventive counseling provided.
1192	1617	I10	Vitals stable. Continue current plan.
1193	1618	E78.5	Vitals stable. Continue current plan.
1194	1619	F41.1	Discussed lab results with patient.
1195	1620	K21.9	Referred to specialist.
1196	1622	K21.9	Referred to specialist.
1197	1623	F41.1	Medication adjusted. Recheck in 6 weeks.
1198	1624	E78.5	Vitals stable. Continue current plan.
1199	1626	J45.909	Discussed lab results with patient.
1200	1627	L30.9	Vitals stable. Continue current plan.
1201	1628	M54.5	Reviewed symptoms and history.
1202	1629	M54.5	Reviewed symptoms and history.
1203	1631	R51.9	Referred to specialist.
1204	1632	L30.9	Vitals stable. Continue current plan.
1205	1634	M54.5	Medication adjusted. Recheck in 6 weeks.
1206	1637	J45.909	Referred to specialist.
1207	1639	E78.5	Reviewed symptoms and history.
1208	1640	N39.0	Medication adjusted. Recheck in 6 weeks.
1209	1641	I10	Referred to specialist.
1210	1642	E11.9	Discussed lab results with patient.
1211	1645	M54.5	Discussed lab results with patient.
1212	1646	J45.909	Referred to specialist.
1213	1647	R51.9	Referred to specialist.
1214	1649	L30.9	Discussed lab results with patient.
1215	1651	L30.9	Preventive counseling provided.
1216	1653	F41.1	Reviewed symptoms and history.
1217	1654	E11.9	Vitals stable. Continue current plan.
1218	1655	E78.5	Vitals stable. Continue current plan.
1219	1656	J06.9	Vitals stable. Continue current plan.
1220	1657	N39.0	Referred to specialist.
1221	1659	E11.9	Referred to specialist.
1222	1660	E78.5	Preventive counseling provided.
1223	1661	I10	Vitals stable. Continue current plan.
1224	1662	L30.9	Reviewed symptoms and history.
1225	1663	Z00.00	Vitals stable. Continue current plan.
1226	1664	Z00.00	Medication adjusted. Recheck in 6 weeks.
1227	1666	R51.9	Preventive counseling provided.
1228	1667	E11.9	Referred to specialist.
1229	1670	E11.9	Preventive counseling provided.
1230	1671	F41.1	Reviewed symptoms and history.
1231	1672	F41.1	Vitals stable. Continue current plan.
1232	1673	L30.9	Referred to specialist.
1233	1674	R51.9	Referred to specialist.
1234	1675	F41.1	Medication adjusted. Recheck in 6 weeks.
1235	1676	R51.9	Discussed lab results with patient.
1236	1681	N39.0	Vitals stable. Continue current plan.
1237	1682	M54.5	Preventive counseling provided.
1238	1683	L30.9	Vitals stable. Continue current plan.
1239	1685	J06.9	Preventive counseling provided.
1240	1687	I10	Preventive counseling provided.
1241	1689	J06.9	Discussed lab results with patient.
1242	1690	R51.9	Discussed lab results with patient.
1243	1691	Z00.00	Preventive counseling provided.
1244	1692	Z00.00	Discussed lab results with patient.
1245	1693	N39.0	Discussed lab results with patient.
1246	1694	E11.9	Medication adjusted. Recheck in 6 weeks.
1247	1695	M54.5	Medication adjusted. Recheck in 6 weeks.
1248	1696	F41.1	Preventive counseling provided.
1249	1697	E11.9	Medication adjusted. Recheck in 6 weeks.
1250	1699	L30.9	Discussed lab results with patient.
1251	1700	K21.9	Referred to specialist.
1252	1701	F41.1	Vitals stable. Continue current plan.
1253	1702	I10	Preventive counseling provided.
1254	1703	K21.9	Discussed lab results with patient.
1255	1704	F41.1	Medication adjusted. Recheck in 6 weeks.
1256	1706	J45.909	Reviewed symptoms and history.
1257	1709	F41.1	Discussed lab results with patient.
1258	1712	J06.9	Preventive counseling provided.
1259	1713	E11.9	Vitals stable. Continue current plan.
1260	1714	E78.5	Medication adjusted. Recheck in 6 weeks.
1261	1716	K21.9	Medication adjusted. Recheck in 6 weeks.
1262	1719	K21.9	Discussed lab results with patient.
1263	1720	Z00.00	Medication adjusted. Recheck in 6 weeks.
1264	1721	J06.9	Reviewed symptoms and history.
1265	1722	L30.9	Preventive counseling provided.
1266	1723	N39.0	Preventive counseling provided.
1267	1724	J45.909	Referred to specialist.
1268	1725	E78.5	Vitals stable. Continue current plan.
1269	1728	J45.909	Vitals stable. Continue current plan.
1270	1729	J06.9	Discussed lab results with patient.
1271	1730	K21.9	Medication adjusted. Recheck in 6 weeks.
1272	1731	J06.9	Reviewed symptoms and history.
1273	1732	M54.5	Vitals stable. Continue current plan.
1274	1733	N39.0	Referred to specialist.
1275	1734	E78.5	Medication adjusted. Recheck in 6 weeks.
1276	1735	I10	Vitals stable. Continue current plan.
1277	1738	J45.909	Preventive counseling provided.
1278	1739	I10	Vitals stable. Continue current plan.
1279	1740	F41.1	Reviewed symptoms and history.
1280	1741	M54.5	Preventive counseling provided.
1281	1742	Z00.00	Medication adjusted. Recheck in 6 weeks.
1282	1743	J45.909	Preventive counseling provided.
1283	1744	E11.9	Preventive counseling provided.
1284	1745	R51.9	Preventive counseling provided.
1285	1746	J45.909	Referred to specialist.
1286	1747	F41.1	Discussed lab results with patient.
1287	1748	M54.5	Medication adjusted. Recheck in 6 weeks.
1288	1750	M54.5	Referred to specialist.
1289	1751	R51.9	Discussed lab results with patient.
1290	1752	F41.1	Discussed lab results with patient.
1291	1753	J06.9	Medication adjusted. Recheck in 6 weeks.
1292	1755	K21.9	Discussed lab results with patient.
1293	1756	J45.909	Medication adjusted. Recheck in 6 weeks.
1294	1757	N39.0	Vitals stable. Continue current plan.
1295	1758	N39.0	Reviewed symptoms and history.
1296	1759	I10	Preventive counseling provided.
1297	1760	J06.9	Referred to specialist.
1298	1761	M54.5	Discussed lab results with patient.
1299	1762	L30.9	Reviewed symptoms and history.
1300	1763	E11.9	Medication adjusted. Recheck in 6 weeks.
1301	1764	J06.9	Vitals stable. Continue current plan.
1302	1765	R51.9	Medication adjusted. Recheck in 6 weeks.
1303	1766	Z00.00	Referred to specialist.
1304	1768	F41.1	Vitals stable. Continue current plan.
1305	1769	R51.9	Vitals stable. Continue current plan.
1306	1770	R51.9	Referred to specialist.
1307	1771	M54.5	Reviewed symptoms and history.
1308	1772	K21.9	Preventive counseling provided.
1309	1773	K21.9	Discussed lab results with patient.
1310	1775	J45.909	Medication adjusted. Recheck in 6 weeks.
1311	1776	M54.5	Preventive counseling provided.
1312	1777	J45.909	Discussed lab results with patient.
1313	1779	J45.909	Discussed lab results with patient.
1314	1780	K21.9	Discussed lab results with patient.
1315	1782	R51.9	Referred to specialist.
1316	1783	R51.9	Medication adjusted. Recheck in 6 weeks.
1317	1784	N39.0	Discussed lab results with patient.
1318	1786	F41.1	Reviewed symptoms and history.
1319	1787	L30.9	Vitals stable. Continue current plan.
1320	1788	E78.5	Medication adjusted. Recheck in 6 weeks.
1321	1789	Z00.00	Preventive counseling provided.
1322	1791	E78.5	Vitals stable. Continue current plan.
1323	1792	E78.5	Preventive counseling provided.
1324	1794	K21.9	Preventive counseling provided.
1325	1796	F41.1	Medication adjusted. Recheck in 6 weeks.
1326	1797	J06.9	Referred to specialist.
1327	1798	L30.9	Vitals stable. Continue current plan.
1328	1800	M54.5	Preventive counseling provided.
1329	1801	E78.5	Preventive counseling provided.
1330	1803	J45.909	Vitals stable. Continue current plan.
1331	1804	E11.9	Referred to specialist.
1332	1805	N39.0	Discussed lab results with patient.
1333	1806	Z00.00	Discussed lab results with patient.
1334	1807	J45.909	Vitals stable. Continue current plan.
1335	1808	E78.5	Vitals stable. Continue current plan.
1336	1809	I10	Preventive counseling provided.
1337	1810	E11.9	Preventive counseling provided.
1338	1812	R51.9	Preventive counseling provided.
1339	1813	I10	Discussed lab results with patient.
1340	1814	K21.9	Discussed lab results with patient.
1341	1815	Z00.00	Medication adjusted. Recheck in 6 weeks.
1342	1816	M54.5	Discussed lab results with patient.
1343	1818	L30.9	Reviewed symptoms and history.
1344	1819	J45.909	Discussed lab results with patient.
1345	1821	M54.5	Medication adjusted. Recheck in 6 weeks.
1346	1822	E11.9	Medication adjusted. Recheck in 6 weeks.
1347	1823	I10	Reviewed symptoms and history.
1348	1824	J45.909	Discussed lab results with patient.
1349	1825	J45.909	Reviewed symptoms and history.
1350	1827	F41.1	Referred to specialist.
1351	1828	I10	Vitals stable. Continue current plan.
1352	1829	R51.9	Vitals stable. Continue current plan.
1353	1830	L30.9	Reviewed symptoms and history.
1354	1831	K21.9	Reviewed symptoms and history.
1355	1832	F41.1	Vitals stable. Continue current plan.
1356	1833	J45.909	Medication adjusted. Recheck in 6 weeks.
1357	1835	R51.9	Preventive counseling provided.
1358	1836	R51.9	Discussed lab results with patient.
1359	1837	K21.9	Medication adjusted. Recheck in 6 weeks.
1360	1838	F41.1	Vitals stable. Continue current plan.
1361	1839	F41.1	Discussed lab results with patient.
1362	1841	Z00.00	Reviewed symptoms and history.
1363	1843	J45.909	Referred to specialist.
1364	1844	E78.5	Referred to specialist.
1365	1846	J45.909	Discussed lab results with patient.
1366	1847	F41.1	Discussed lab results with patient.
1367	1849	L30.9	Reviewed symptoms and history.
1368	1850	Z00.00	Vitals stable. Continue current plan.
1369	1852	R51.9	Medication adjusted. Recheck in 6 weeks.
1370	1854	Z00.00	Reviewed symptoms and history.
1371	1855	N39.0	Reviewed symptoms and history.
1372	1856	I10	Referred to specialist.
1373	1857	J45.909	Reviewed symptoms and history.
1374	1858	I10	Vitals stable. Continue current plan.
1375	1859	E11.9	Vitals stable. Continue current plan.
1376	1860	N39.0	Reviewed symptoms and history.
1377	1863	J45.909	Discussed lab results with patient.
1378	1864	E78.5	Preventive counseling provided.
1379	1865	E78.5	Medication adjusted. Recheck in 6 weeks.
1380	1866	F41.1	Referred to specialist.
1381	1867	R51.9	Referred to specialist.
1382	1868	Z00.00	Reviewed symptoms and history.
1383	1869	N39.0	Reviewed symptoms and history.
1384	1870	J45.909	Discussed lab results with patient.
1385	1871	I10	Vitals stable. Continue current plan.
1386	1872	J06.9	Vitals stable. Continue current plan.
1387	1873	N39.0	Discussed lab results with patient.
1388	1877	J45.909	Vitals stable. Continue current plan.
1389	1879	E78.5	Discussed lab results with patient.
1390	1880	Z00.00	Medication adjusted. Recheck in 6 weeks.
1391	1881	J06.9	Preventive counseling provided.
1392	1882	L30.9	Medication adjusted. Recheck in 6 weeks.
1393	1883	J45.909	Preventive counseling provided.
1394	1884	N39.0	Referred to specialist.
1395	1885	L30.9	Preventive counseling provided.
1396	1886	M54.5	Discussed lab results with patient.
1397	1887	M54.5	Medication adjusted. Recheck in 6 weeks.
1398	1888	I10	Vitals stable. Continue current plan.
1399	1889	J06.9	Preventive counseling provided.
1400	1890	K21.9	Referred to specialist.
1401	1891	E78.5	Reviewed symptoms and history.
1402	1893	J45.909	Referred to specialist.
1403	1894	F41.1	Referred to specialist.
1404	1895	I10	Vitals stable. Continue current plan.
1405	1896	F41.1	Referred to specialist.
1406	1898	L30.9	Referred to specialist.
1407	1900	L30.9	Preventive counseling provided.
1408	1902	L30.9	Preventive counseling provided.
1409	1903	J06.9	Preventive counseling provided.
1410	1904	N39.0	Preventive counseling provided.
1411	1905	J06.9	Reviewed symptoms and history.
1412	1907	E78.5	Discussed lab results with patient.
1413	1908	F41.1	Medication adjusted. Recheck in 6 weeks.
1414	1910	K21.9	Medication adjusted. Recheck in 6 weeks.
1415	1911	Z00.00	Vitals stable. Continue current plan.
1416	1912	Z00.00	Preventive counseling provided.
1417	1913	E78.5	Reviewed symptoms and history.
1418	1914	J06.9	Reviewed symptoms and history.
1419	1915	E78.5	Preventive counseling provided.
1420	1916	F41.1	Discussed lab results with patient.
1421	1920	F41.1	Vitals stable. Continue current plan.
1422	1921	J45.909	Reviewed symptoms and history.
1423	1922	E11.9	Preventive counseling provided.
1424	1923	E78.5	Reviewed symptoms and history.
1425	1924	Z00.00	Referred to specialist.
1426	1925	M54.5	Vitals stable. Continue current plan.
1427	1926	N39.0	Discussed lab results with patient.
1428	1927	R51.9	Reviewed symptoms and history.
1429	1928	F41.1	Preventive counseling provided.
1430	1931	E78.5	Reviewed symptoms and history.
1431	1932	J06.9	Medication adjusted. Recheck in 6 weeks.
1432	1934	I10	Reviewed symptoms and history.
1433	1935	M54.5	Reviewed symptoms and history.
1434	1937	J45.909	Reviewed symptoms and history.
1435	1938	F41.1	Reviewed symptoms and history.
1436	1939	E78.5	Reviewed symptoms and history.
1437	1940	J06.9	Referred to specialist.
1438	1941	Z00.00	Vitals stable. Continue current plan.
1439	1942	E78.5	Vitals stable. Continue current plan.
1440	1943	F41.1	Discussed lab results with patient.
1441	1944	E78.5	Reviewed symptoms and history.
1442	1945	N39.0	Reviewed symptoms and history.
1443	1946	E11.9	Referred to specialist.
1444	1949	K21.9	Referred to specialist.
1445	1950	F41.1	Reviewed symptoms and history.
1446	1952	Z00.00	Discussed lab results with patient.
1447	1953	Z00.00	Reviewed symptoms and history.
1448	1954	Z00.00	Discussed lab results with patient.
1449	1955	L30.9	Preventive counseling provided.
1450	1956	I10	Referred to specialist.
1451	1957	M54.5	Vitals stable. Continue current plan.
1452	1958	Z00.00	Reviewed symptoms and history.
1453	1959	E78.5	Medication adjusted. Recheck in 6 weeks.
1454	1960	N39.0	Medication adjusted. Recheck in 6 weeks.
1455	1961	J06.9	Medication adjusted. Recheck in 6 weeks.
1456	1962	K21.9	Vitals stable. Continue current plan.
1457	1966	R51.9	Reviewed symptoms and history.
1458	1968	F41.1	Medication adjusted. Recheck in 6 weeks.
1459	1969	K21.9	Preventive counseling provided.
1460	1970	E78.5	Medication adjusted. Recheck in 6 weeks.
1461	1971	E78.5	Reviewed symptoms and history.
1462	1972	M54.5	Referred to specialist.
1463	1973	N39.0	Discussed lab results with patient.
1464	1974	Z00.00	Vitals stable. Continue current plan.
1465	1975	R51.9	Discussed lab results with patient.
1466	1977	I10	Referred to specialist.
1467	1978	N39.0	Preventive counseling provided.
1468	1980	J45.909	Preventive counseling provided.
1469	1981	M54.5	Reviewed symptoms and history.
1470	1982	N39.0	Referred to specialist.
1471	1983	J06.9	Discussed lab results with patient.
1472	1984	J45.909	Vitals stable. Continue current plan.
1473	1986	R51.9	Reviewed symptoms and history.
1474	1987	R51.9	Medication adjusted. Recheck in 6 weeks.
1475	1988	J06.9	Referred to specialist.
1476	1989	R51.9	Reviewed symptoms and history.
1477	1990	R51.9	Reviewed symptoms and history.
1478	1991	L30.9	Referred to specialist.
1479	1992	R51.9	Preventive counseling provided.
1480	1993	L30.9	Reviewed symptoms and history.
1481	1994	Z00.00	Reviewed symptoms and history.
1482	1995	J06.9	Preventive counseling provided.
1483	1998	R51.9	Referred to specialist.
1484	1999	J45.909	Medication adjusted. Recheck in 6 weeks.
1485	2000	M54.5	Preventive counseling provided.
1486	2001	E11.9	Vitals stable. Continue current plan.
1487	2003	F41.1	Vitals stable. Continue current plan.
1488	2005	Z00.00	Discussed lab results with patient.
1489	2007	M54.5	Referred to specialist.
1490	2008	Z00.00	Reviewed symptoms and history.
1491	2009	I10	Reviewed symptoms and history.
1492	2013	K21.9	Preventive counseling provided.
1493	2014	J06.9	Referred to specialist.
1494	2015	I10	Discussed lab results with patient.
1495	2018	L30.9	Medication adjusted. Recheck in 6 weeks.
1496	2020	J45.909	Medication adjusted. Recheck in 6 weeks.
1497	2021	N39.0	Discussed lab results with patient.
1498	2022	I10	Reviewed symptoms and history.
1499	2023	M54.5	Vitals stable. Continue current plan.
1500	2025	E78.5	Discussed lab results with patient.
1501	2026	K21.9	Medication adjusted. Recheck in 6 weeks.
1502	2027	M54.5	Reviewed symptoms and history.
1503	2028	Z00.00	Referred to specialist.
1504	2029	I10	Referred to specialist.
1505	2030	E78.5	Vitals stable. Continue current plan.
1506	2031	J06.9	Referred to specialist.
1507	2032	Z00.00	Discussed lab results with patient.
1508	2033	J06.9	Medication adjusted. Recheck in 6 weeks.
1509	2034	Z00.00	Referred to specialist.
1510	2035	J45.909	Preventive counseling provided.
1511	2036	E78.5	Preventive counseling provided.
1512	2038	R51.9	Reviewed symptoms and history.
1513	2040	J06.9	Medication adjusted. Recheck in 6 weeks.
1514	2041	M54.5	Preventive counseling provided.
1515	2042	K21.9	Vitals stable. Continue current plan.
1516	2043	M54.5	Vitals stable. Continue current plan.
1517	2045	E11.9	Discussed lab results with patient.
1518	2046	K21.9	Medication adjusted. Recheck in 6 weeks.
1519	2048	K21.9	Reviewed symptoms and history.
1520	2049	E78.5	Preventive counseling provided.
1521	2050	N39.0	Discussed lab results with patient.
1522	2051	M54.5	Referred to specialist.
1523	2053	R51.9	Referred to specialist.
1524	2054	N39.0	Discussed lab results with patient.
1525	2055	E11.9	Discussed lab results with patient.
1526	2056	M54.5	Discussed lab results with patient.
1527	2057	K21.9	Reviewed symptoms and history.
1528	2058	R51.9	Referred to specialist.
1529	2060	E78.5	Preventive counseling provided.
1530	2061	E78.5	Reviewed symptoms and history.
1531	2062	Z00.00	Vitals stable. Continue current plan.
1532	2063	I10	Medication adjusted. Recheck in 6 weeks.
1533	2064	F41.1	Medication adjusted. Recheck in 6 weeks.
1534	2065	J45.909	Medication adjusted. Recheck in 6 weeks.
1535	2066	M54.5	Preventive counseling provided.
1536	2067	J06.9	Referred to specialist.
1537	2069	Z00.00	Preventive counseling provided.
1538	2070	F41.1	Referred to specialist.
1539	2072	I10	Vitals stable. Continue current plan.
1540	2074	Z00.00	Reviewed symptoms and history.
1541	2075	L30.9	Vitals stable. Continue current plan.
1542	2076	E11.9	Medication adjusted. Recheck in 6 weeks.
1543	2077	K21.9	Discussed lab results with patient.
1544	2078	L30.9	Reviewed symptoms and history.
1545	2079	R51.9	Discussed lab results with patient.
1546	2080	I10	Reviewed symptoms and history.
1547	2081	I10	Vitals stable. Continue current plan.
1548	2082	F41.1	Preventive counseling provided.
1549	2083	R51.9	Vitals stable. Continue current plan.
1550	2084	Z00.00	Referred to specialist.
1551	2087	L30.9	Referred to specialist.
1552	2088	J45.909	Reviewed symptoms and history.
1553	2089	Z00.00	Vitals stable. Continue current plan.
1554	2090	K21.9	Reviewed symptoms and history.
1555	2091	N39.0	Preventive counseling provided.
1556	2094	J45.909	Discussed lab results with patient.
1557	2095	L30.9	Vitals stable. Continue current plan.
1558	2096	L30.9	Medication adjusted. Recheck in 6 weeks.
1559	2097	E78.5	Medication adjusted. Recheck in 6 weeks.
1560	2099	M54.5	Preventive counseling provided.
1561	2101	E78.5	Preventive counseling provided.
1562	2102	I10	Medication adjusted. Recheck in 6 weeks.
1563	2105	E11.9	Vitals stable. Continue current plan.
1564	2107	F41.1	Discussed lab results with patient.
1565	2108	L30.9	Preventive counseling provided.
1566	2109	M54.5	Referred to specialist.
1567	2110	R51.9	Vitals stable. Continue current plan.
1568	2111	L30.9	Reviewed symptoms and history.
1569	2112	I10	Vitals stable. Continue current plan.
1570	2113	N39.0	Reviewed symptoms and history.
1571	2114	E78.5	Referred to specialist.
1572	2115	J45.909	Referred to specialist.
1573	2116	J06.9	Discussed lab results with patient.
1574	2117	E78.5	Reviewed symptoms and history.
1575	2118	Z00.00	Discussed lab results with patient.
1576	2120	E78.5	Reviewed symptoms and history.
1577	2122	E78.5	Preventive counseling provided.
1578	2123	J45.909	Medication adjusted. Recheck in 6 weeks.
1579	2124	I10	Vitals stable. Continue current plan.
1580	2125	K21.9	Vitals stable. Continue current plan.
1581	2127	L30.9	Medication adjusted. Recheck in 6 weeks.
1582	2128	N39.0	Referred to specialist.
1583	2129	N39.0	Medication adjusted. Recheck in 6 weeks.
1584	2130	K21.9	Reviewed symptoms and history.
1585	2131	E11.9	Preventive counseling provided.
1586	2132	E78.5	Referred to specialist.
1587	2133	E11.9	Vitals stable. Continue current plan.
1588	2134	R51.9	Vitals stable. Continue current plan.
1589	2136	E11.9	Discussed lab results with patient.
1590	2138	J06.9	Reviewed symptoms and history.
1591	2140	R51.9	Preventive counseling provided.
1592	2142	F41.1	Medication adjusted. Recheck in 6 weeks.
1593	2144	N39.0	Referred to specialist.
1594	2146	K21.9	Vitals stable. Continue current plan.
1595	2148	I10	Preventive counseling provided.
1596	2151	E11.9	Discussed lab results with patient.
1597	2152	E78.5	Reviewed symptoms and history.
1598	2153	J06.9	Vitals stable. Continue current plan.
1599	2154	L30.9	Medication adjusted. Recheck in 6 weeks.
1600	2158	J45.909	Referred to specialist.
1601	2159	R51.9	Preventive counseling provided.
1602	2160	R51.9	Discussed lab results with patient.
1603	2161	M54.5	Preventive counseling provided.
1604	2162	K21.9	Reviewed symptoms and history.
1605	2163	J45.909	Vitals stable. Continue current plan.
1606	2164	I10	Discussed lab results with patient.
1607	2166	E78.5	Reviewed symptoms and history.
1608	2167	N39.0	Discussed lab results with patient.
1609	2168	J06.9	Discussed lab results with patient.
1610	2169	F41.1	Reviewed symptoms and history.
1611	2170	M54.5	Reviewed symptoms and history.
1612	2171	J45.909	Preventive counseling provided.
1613	2173	L30.9	Medication adjusted. Recheck in 6 weeks.
1614	2175	M54.5	Preventive counseling provided.
1615	2177	R51.9	Preventive counseling provided.
1616	2178	J45.909	Vitals stable. Continue current plan.
1617	2179	E78.5	Referred to specialist.
1618	2180	E78.5	Medication adjusted. Recheck in 6 weeks.
1619	2181	J45.909	Discussed lab results with patient.
1620	2182	F41.1	Medication adjusted. Recheck in 6 weeks.
1621	2183	K21.9	Referred to specialist.
1622	2184	J45.909	Discussed lab results with patient.
1623	2185	R51.9	Reviewed symptoms and history.
1624	2186	E78.5	Reviewed symptoms and history.
1625	2187	E11.9	Preventive counseling provided.
1626	2188	Z00.00	Reviewed symptoms and history.
1627	2189	K21.9	Vitals stable. Continue current plan.
1628	2190	M54.5	Medication adjusted. Recheck in 6 weeks.
1629	2191	F41.1	Medication adjusted. Recheck in 6 weeks.
1630	2192	L30.9	Vitals stable. Continue current plan.
1631	2193	E11.9	Reviewed symptoms and history.
1632	2194	L30.9	Reviewed symptoms and history.
1633	2196	L30.9	Medication adjusted. Recheck in 6 weeks.
1634	2198	K21.9	Reviewed symptoms and history.
1635	2199	E11.9	Discussed lab results with patient.
1636	2201	E11.9	Vitals stable. Continue current plan.
1637	2202	E78.5	Reviewed symptoms and history.
1638	2203	J45.909	Preventive counseling provided.
1639	2205	M54.5	Reviewed symptoms and history.
1640	2206	J45.909	Reviewed symptoms and history.
1641	2207	J06.9	Discussed lab results with patient.
1642	2208	F41.1	Vitals stable. Continue current plan.
1643	2209	M54.5	Preventive counseling provided.
1644	2210	F41.1	Medication adjusted. Recheck in 6 weeks.
1645	2212	L30.9	Discussed lab results with patient.
1646	2213	E11.9	Discussed lab results with patient.
1647	2214	J06.9	Vitals stable. Continue current plan.
1648	2215	K21.9	Discussed lab results with patient.
1649	2218	M54.5	Vitals stable. Continue current plan.
1650	2219	E11.9	Preventive counseling provided.
1651	2220	K21.9	Referred to specialist.
1652	2222	N39.0	Preventive counseling provided.
1653	2223	N39.0	Referred to specialist.
1654	2224	J06.9	Preventive counseling provided.
1655	2225	Z00.00	Preventive counseling provided.
1656	2226	J06.9	Vitals stable. Continue current plan.
1657	2227	I10	Reviewed symptoms and history.
1658	2228	R51.9	Referred to specialist.
1659	2229	K21.9	Preventive counseling provided.
1660	2230	K21.9	Preventive counseling provided.
1661	2231	E78.5	Referred to specialist.
1662	2233	F41.1	Discussed lab results with patient.
1663	2234	M54.5	Discussed lab results with patient.
1664	2236	L30.9	Referred to specialist.
1665	2238	E11.9	Preventive counseling provided.
1666	2239	L30.9	Reviewed symptoms and history.
1667	2241	E78.5	Preventive counseling provided.
1668	2242	R51.9	Reviewed symptoms and history.
1669	2243	K21.9	Referred to specialist.
1670	2244	L30.9	Reviewed symptoms and history.
1671	2245	E11.9	Reviewed symptoms and history.
1672	2246	M54.5	Discussed lab results with patient.
1673	2247	L30.9	Reviewed symptoms and history.
1674	2248	R51.9	Medication adjusted. Recheck in 6 weeks.
1675	2249	L30.9	Vitals stable. Continue current plan.
1676	2250	I10	Medication adjusted. Recheck in 6 weeks.
1677	2251	Z00.00	Reviewed symptoms and history.
1678	2252	F41.1	Reviewed symptoms and history.
1679	2253	M54.5	Reviewed symptoms and history.
1680	2254	K21.9	Referred to specialist.
1681	2255	J06.9	Medication adjusted. Recheck in 6 weeks.
1682	2256	R51.9	Discussed lab results with patient.
1683	2257	E11.9	Vitals stable. Continue current plan.
1684	2258	F41.1	Referred to specialist.
1685	2259	J06.9	Preventive counseling provided.
1686	2260	Z00.00	Vitals stable. Continue current plan.
1687	2263	E11.9	Referred to specialist.
1688	2264	I10	Preventive counseling provided.
1689	2265	E11.9	Referred to specialist.
1690	2266	E78.5	Reviewed symptoms and history.
1691	2267	I10	Reviewed symptoms and history.
1692	2268	J45.909	Vitals stable. Continue current plan.
1693	2271	J45.909	Referred to specialist.
1694	2272	I10	Reviewed symptoms and history.
1695	2273	E11.9	Medication adjusted. Recheck in 6 weeks.
1696	2274	I10	Vitals stable. Continue current plan.
1697	2275	N39.0	Reviewed symptoms and history.
1698	2276	K21.9	Referred to specialist.
1699	2277	E78.5	Vitals stable. Continue current plan.
1700	2283	F41.1	Preventive counseling provided.
1701	2284	L30.9	Vitals stable. Continue current plan.
1702	2285	M54.5	Preventive counseling provided.
1703	2286	R51.9	Vitals stable. Continue current plan.
1704	2287	E78.5	Medication adjusted. Recheck in 6 weeks.
1705	2288	R51.9	Referred to specialist.
1706	2289	J45.909	Referred to specialist.
1707	2291	I10	Preventive counseling provided.
1708	2292	L30.9	Referred to specialist.
1709	2294	Z00.00	Preventive counseling provided.
1710	2295	K21.9	Medication adjusted. Recheck in 6 weeks.
1711	2296	R51.9	Discussed lab results with patient.
1712	2297	I10	Reviewed symptoms and history.
1713	2298	E11.9	Vitals stable. Continue current plan.
1714	2299	I10	Discussed lab results with patient.
1715	2300	E78.5	Preventive counseling provided.
1716	2301	R51.9	Referred to specialist.
1717	2303	R51.9	Preventive counseling provided.
1718	2304	N39.0	Discussed lab results with patient.
1719	2306	E11.9	Reviewed symptoms and history.
1720	2307	Z00.00	Vitals stable. Continue current plan.
1721	2308	Z00.00	Reviewed symptoms and history.
1722	2310	L30.9	Preventive counseling provided.
1723	2311	J45.909	Vitals stable. Continue current plan.
1724	2312	E11.9	Vitals stable. Continue current plan.
1725	2313	Z00.00	Reviewed symptoms and history.
1726	2314	K21.9	Vitals stable. Continue current plan.
1727	2316	R51.9	Preventive counseling provided.
1728	2317	L30.9	Vitals stable. Continue current plan.
1729	2318	N39.0	Referred to specialist.
1730	2319	I10	Medication adjusted. Recheck in 6 weeks.
1731	2320	Z00.00	Reviewed symptoms and history.
1732	2321	E78.5	Referred to specialist.
1733	2322	I10	Discussed lab results with patient.
1734	2323	N39.0	Discussed lab results with patient.
1735	2324	E78.5	Discussed lab results with patient.
1736	2325	M54.5	Medication adjusted. Recheck in 6 weeks.
1737	2327	E11.9	Referred to specialist.
1738	2328	J06.9	Reviewed symptoms and history.
1739	2329	E78.5	Vitals stable. Continue current plan.
1740	2330	N39.0	Medication adjusted. Recheck in 6 weeks.
1741	2331	Z00.00	Referred to specialist.
1742	2332	N39.0	Referred to specialist.
1743	2333	M54.5	Vitals stable. Continue current plan.
1744	2334	I10	Discussed lab results with patient.
1745	2335	F41.1	Reviewed symptoms and history.
1746	2338	M54.5	Vitals stable. Continue current plan.
1747	2340	L30.9	Referred to specialist.
1748	2341	E11.9	Discussed lab results with patient.
1749	2342	E78.5	Preventive counseling provided.
1750	2343	K21.9	Reviewed symptoms and history.
1751	2344	N39.0	Referred to specialist.
1752	2346	E11.9	Vitals stable. Continue current plan.
1753	2347	K21.9	Reviewed symptoms and history.
1754	2348	L30.9	Referred to specialist.
1755	2349	K21.9	Reviewed symptoms and history.
1756	2350	Z00.00	Reviewed symptoms and history.
1757	2351	N39.0	Preventive counseling provided.
1758	2352	J45.909	Preventive counseling provided.
1759	2353	N39.0	Vitals stable. Continue current plan.
1760	2354	R51.9	Referred to specialist.
1761	2355	L30.9	Referred to specialist.
1762	2356	E78.5	Discussed lab results with patient.
1763	2358	L30.9	Reviewed symptoms and history.
1764	2359	J45.909	Medication adjusted. Recheck in 6 weeks.
1765	2360	E11.9	Referred to specialist.
1766	2364	J45.909	Vitals stable. Continue current plan.
1767	2365	L30.9	Preventive counseling provided.
1768	2366	J06.9	Referred to specialist.
1769	2367	L30.9	Medication adjusted. Recheck in 6 weeks.
1770	2368	I10	Medication adjusted. Recheck in 6 weeks.
1771	2369	L30.9	Vitals stable. Continue current plan.
1772	2370	E78.5	Reviewed symptoms and history.
1773	2371	E78.5	Reviewed symptoms and history.
1774	2373	R51.9	Medication adjusted. Recheck in 6 weeks.
1775	2374	E11.9	Discussed lab results with patient.
1776	2377	E11.9	Discussed lab results with patient.
1777	2378	M54.5	Discussed lab results with patient.
1778	2379	E11.9	Reviewed symptoms and history.
1779	2380	N39.0	Preventive counseling provided.
1780	2382	J45.909	Vitals stable. Continue current plan.
1781	2384	K21.9	Reviewed symptoms and history.
1782	2385	R51.9	Vitals stable. Continue current plan.
1783	2386	F41.1	Medication adjusted. Recheck in 6 weeks.
1784	2388	E11.9	Medication adjusted. Recheck in 6 weeks.
1785	2389	F41.1	Discussed lab results with patient.
1786	2390	J06.9	Referred to specialist.
1787	2393	K21.9	Vitals stable. Continue current plan.
1788	2394	K21.9	Reviewed symptoms and history.
1789	2395	F41.1	Referred to specialist.
1790	2396	F41.1	Referred to specialist.
1791	2399	E78.5	Referred to specialist.
1792	2400	J06.9	Preventive counseling provided.
1793	2402	Z00.00	Reviewed symptoms and history.
1794	2403	Z00.00	Discussed lab results with patient.
1795	2404	I10	Vitals stable. Continue current plan.
1796	2405	M54.5	Preventive counseling provided.
1797	2406	I10	Preventive counseling provided.
1798	2407	N39.0	Reviewed symptoms and history.
1799	2409	F41.1	Vitals stable. Continue current plan.
1800	2410	F41.1	Discussed lab results with patient.
1801	2412	J06.9	Vitals stable. Continue current plan.
1802	2413	N39.0	Referred to specialist.
1803	2414	Z00.00	Discussed lab results with patient.
1804	2417	M54.5	Referred to specialist.
1805	2420	J45.909	Referred to specialist.
1806	2423	N39.0	Vitals stable. Continue current plan.
1807	2424	M54.5	Preventive counseling provided.
1808	2425	E78.5	Reviewed symptoms and history.
1809	2426	J45.909	Discussed lab results with patient.
1810	2427	J45.909	Vitals stable. Continue current plan.
1811	2428	L30.9	Vitals stable. Continue current plan.
1812	2429	Z00.00	Reviewed symptoms and history.
1813	2430	N39.0	Discussed lab results with patient.
1814	2431	J45.909	Preventive counseling provided.
1815	2432	F41.1	Vitals stable. Continue current plan.
1816	2433	N39.0	Reviewed symptoms and history.
1817	2435	Z00.00	Vitals stable. Continue current plan.
1818	2439	F41.1	Discussed lab results with patient.
1819	2440	I10	Preventive counseling provided.
1820	2441	F41.1	Referred to specialist.
1821	2443	L30.9	Preventive counseling provided.
1822	2446	E78.5	Vitals stable. Continue current plan.
1823	2447	E78.5	Discussed lab results with patient.
1824	2448	E78.5	Referred to specialist.
1825	2450	K21.9	Referred to specialist.
1826	2451	E78.5	Discussed lab results with patient.
1827	2452	R51.9	Medication adjusted. Recheck in 6 weeks.
1828	2455	Z00.00	Medication adjusted. Recheck in 6 weeks.
1829	2456	I10	Referred to specialist.
1830	2457	M54.5	Medication adjusted. Recheck in 6 weeks.
1831	2458	E11.9	Preventive counseling provided.
1832	2459	J45.909	Vitals stable. Continue current plan.
1833	2460	J45.909	Vitals stable. Continue current plan.
1834	2461	R51.9	Preventive counseling provided.
1835	2462	M54.5	Discussed lab results with patient.
1836	2463	M54.5	Reviewed symptoms and history.
1837	2464	K21.9	Medication adjusted. Recheck in 6 weeks.
1838	2465	E78.5	Medication adjusted. Recheck in 6 weeks.
1839	2466	F41.1	Preventive counseling provided.
1840	2468	R51.9	Medication adjusted. Recheck in 6 weeks.
1841	2469	Z00.00	Referred to specialist.
1842	2470	K21.9	Referred to specialist.
1843	2471	L30.9	Reviewed symptoms and history.
1844	2472	M54.5	Reviewed symptoms and history.
1845	2473	R51.9	Vitals stable. Continue current plan.
1846	2475	Z00.00	Reviewed symptoms and history.
1847	2476	N39.0	Reviewed symptoms and history.
1848	2478	M54.5	Vitals stable. Continue current plan.
1849	2479	I10	Referred to specialist.
1850	2480	L30.9	Medication adjusted. Recheck in 6 weeks.
1851	2481	K21.9	Referred to specialist.
1852	2482	F41.1	Discussed lab results with patient.
1853	2483	J45.909	Preventive counseling provided.
1854	2485	L30.9	Preventive counseling provided.
1855	2486	K21.9	Discussed lab results with patient.
1856	2489	L30.9	Discussed lab results with patient.
1857	2491	L30.9	Vitals stable. Continue current plan.
1858	2492	E78.5	Reviewed symptoms and history.
1859	2493	J06.9	Vitals stable. Continue current plan.
1860	2494	F41.1	Preventive counseling provided.
1861	2495	M54.5	Preventive counseling provided.
1862	2497	K21.9	Discussed lab results with patient.
1863	2498	Z00.00	Discussed lab results with patient.
1864	2499	N39.0	Discussed lab results with patient.
1865	2500	J45.909	Discussed lab results with patient.
1866	2501	J45.909	Referred to specialist.
1867	2502	Z00.00	Reviewed symptoms and history.
1868	2503	L30.9	Referred to specialist.
1869	2504	I10	Reviewed symptoms and history.
1870	2507	E11.9	Reviewed symptoms and history.
1871	2508	Z00.00	Vitals stable. Continue current plan.
1872	2509	R51.9	Vitals stable. Continue current plan.
1873	2511	N39.0	Referred to specialist.
1874	2512	R51.9	Discussed lab results with patient.
1875	2515	Z00.00	Reviewed symptoms and history.
1876	2516	N39.0	Medication adjusted. Recheck in 6 weeks.
1877	2517	E11.9	Preventive counseling provided.
1878	2518	K21.9	Medication adjusted. Recheck in 6 weeks.
1879	2519	N39.0	Vitals stable. Continue current plan.
1880	2520	I10	Discussed lab results with patient.
1881	2522	K21.9	Discussed lab results with patient.
1882	2523	M54.5	Referred to specialist.
1883	2525	K21.9	Reviewed symptoms and history.
1884	2527	E11.9	Reviewed symptoms and history.
1885	2529	J45.909	Medication adjusted. Recheck in 6 weeks.
1886	2530	M54.5	Medication adjusted. Recheck in 6 weeks.
1887	2531	J45.909	Discussed lab results with patient.
1888	2532	L30.9	Medication adjusted. Recheck in 6 weeks.
1889	2534	R51.9	Reviewed symptoms and history.
1890	2535	J06.9	Vitals stable. Continue current plan.
1891	2539	E78.5	Discussed lab results with patient.
1892	2540	R51.9	Referred to specialist.
1893	2542	E11.9	Vitals stable. Continue current plan.
1894	2543	M54.5	Referred to specialist.
1895	2544	E11.9	Referred to specialist.
1896	2545	E78.5	Discussed lab results with patient.
1897	2546	K21.9	Discussed lab results with patient.
1898	2549	M54.5	Reviewed symptoms and history.
1899	2550	K21.9	Medication adjusted. Recheck in 6 weeks.
1900	2551	I10	Vitals stable. Continue current plan.
1901	2552	R51.9	Discussed lab results with patient.
1902	2554	F41.1	Referred to specialist.
1903	2556	K21.9	Medication adjusted. Recheck in 6 weeks.
1904	2557	R51.9	Discussed lab results with patient.
1905	2558	E11.9	Referred to specialist.
1906	2561	J45.909	Preventive counseling provided.
1907	2564	K21.9	Referred to specialist.
1908	2565	E78.5	Preventive counseling provided.
1909	2566	L30.9	Referred to specialist.
1910	2567	F41.1	Medication adjusted. Recheck in 6 weeks.
1911	2568	R51.9	Referred to specialist.
1912	2569	K21.9	Discussed lab results with patient.
1913	2570	I10	Medication adjusted. Recheck in 6 weeks.
1914	2571	Z00.00	Vitals stable. Continue current plan.
1915	2572	L30.9	Preventive counseling provided.
1916	2573	Z00.00	Vitals stable. Continue current plan.
1917	2574	L30.9	Medication adjusted. Recheck in 6 weeks.
1918	2575	J06.9	Reviewed symptoms and history.
1919	2576	L30.9	Vitals stable. Continue current plan.
1920	2577	I10	Vitals stable. Continue current plan.
1921	2578	R51.9	Preventive counseling provided.
1922	2579	R51.9	Discussed lab results with patient.
1923	2580	Z00.00	Discussed lab results with patient.
1924	2581	Z00.00	Vitals stable. Continue current plan.
1925	2583	I10	Medication adjusted. Recheck in 6 weeks.
1926	2584	N39.0	Medication adjusted. Recheck in 6 weeks.
1927	2585	E78.5	Vitals stable. Continue current plan.
1928	2587	L30.9	Referred to specialist.
1929	2589	J45.909	Discussed lab results with patient.
1930	2590	J06.9	Referred to specialist.
1931	2592	I10	Discussed lab results with patient.
1932	2593	J45.909	Vitals stable. Continue current plan.
1933	2594	E11.9	Vitals stable. Continue current plan.
1934	2596	E78.5	Referred to specialist.
1935	2598	J06.9	Preventive counseling provided.
1936	2600	M54.5	Vitals stable. Continue current plan.
1937	2601	Z00.00	Discussed lab results with patient.
1938	2602	I10	Vitals stable. Continue current plan.
1939	2603	R51.9	Reviewed symptoms and history.
1940	2605	L30.9	Preventive counseling provided.
1941	2609	E11.9	Discussed lab results with patient.
1942	2610	L30.9	Vitals stable. Continue current plan.
1943	2611	M54.5	Reviewed symptoms and history.
1944	2612	E11.9	Preventive counseling provided.
1945	2613	R51.9	Medication adjusted. Recheck in 6 weeks.
1946	2615	E78.5	Reviewed symptoms and history.
1947	2616	N39.0	Referred to specialist.
1948	2617	E11.9	Referred to specialist.
1949	2618	F41.1	Referred to specialist.
1950	2619	L30.9	Vitals stable. Continue current plan.
1951	2620	I10	Preventive counseling provided.
1952	2621	Z00.00	Medication adjusted. Recheck in 6 weeks.
1953	2622	L30.9	Discussed lab results with patient.
1954	2624	N39.0	Preventive counseling provided.
1955	2625	E11.9	Reviewed symptoms and history.
1956	2626	N39.0	Referred to specialist.
1957	2627	M54.5	Medication adjusted. Recheck in 6 weeks.
1958	2628	Z00.00	Referred to specialist.
1959	2629	I10	Discussed lab results with patient.
1960	2630	M54.5	Vitals stable. Continue current plan.
1961	2632	Z00.00	Discussed lab results with patient.
1962	2633	I10	Reviewed symptoms and history.
1963	2634	I10	Discussed lab results with patient.
1964	2638	R51.9	Discussed lab results with patient.
1965	2639	F41.1	Referred to specialist.
1966	2640	R51.9	Reviewed symptoms and history.
1967	2641	K21.9	Vitals stable. Continue current plan.
1968	2642	J45.909	Discussed lab results with patient.
1969	2644	K21.9	Discussed lab results with patient.
1970	2645	N39.0	Medication adjusted. Recheck in 6 weeks.
1971	2647	J06.9	Vitals stable. Continue current plan.
1972	2649	L30.9	Medication adjusted. Recheck in 6 weeks.
1973	2650	M54.5	Vitals stable. Continue current plan.
1974	2651	Z00.00	Medication adjusted. Recheck in 6 weeks.
1975	2654	L30.9	Preventive counseling provided.
1976	2655	F41.1	Referred to specialist.
1977	2657	L30.9	Reviewed symptoms and history.
1978	2658	R51.9	Referred to specialist.
1979	2659	J06.9	Discussed lab results with patient.
1980	2661	E78.5	Reviewed symptoms and history.
1981	2662	L30.9	Referred to specialist.
1982	2663	K21.9	Discussed lab results with patient.
1983	2664	J06.9	Medication adjusted. Recheck in 6 weeks.
1984	2668	E78.5	Discussed lab results with patient.
1985	2669	E78.5	Medication adjusted. Recheck in 6 weeks.
1986	2670	E11.9	Preventive counseling provided.
1987	2671	K21.9	Discussed lab results with patient.
1988	2672	Z00.00	Reviewed symptoms and history.
1989	2674	M54.5	Preventive counseling provided.
1990	2675	M54.5	Preventive counseling provided.
1991	2676	L30.9	Medication adjusted. Recheck in 6 weeks.
1992	2678	Z00.00	Preventive counseling provided.
1993	2679	J45.909	Referred to specialist.
1994	2680	N39.0	Vitals stable. Continue current plan.
1995	2681	M54.5	Discussed lab results with patient.
1996	2682	I10	Discussed lab results with patient.
1997	2683	L30.9	Referred to specialist.
1998	2684	N39.0	Reviewed symptoms and history.
1999	2686	E11.9	Referred to specialist.
2000	2688	F41.1	Referred to specialist.
2001	2689	L30.9	Medication adjusted. Recheck in 6 weeks.
2002	2690	J45.909	Reviewed symptoms and history.
2003	2691	E11.9	Vitals stable. Continue current plan.
2004	2692	F41.1	Discussed lab results with patient.
2005	2693	R51.9	Referred to specialist.
2006	2695	E11.9	Discussed lab results with patient.
2007	2696	Z00.00	Preventive counseling provided.
2008	2697	J06.9	Referred to specialist.
2009	2699	E11.9	Referred to specialist.
2010	2700	K21.9	Vitals stable. Continue current plan.
2011	2702	Z00.00	Reviewed symptoms and history.
2012	2703	I10	Reviewed symptoms and history.
2013	2705	J45.909	Vitals stable. Continue current plan.
2014	2707	L30.9	Discussed lab results with patient.
2015	2708	I10	Vitals stable. Continue current plan.
2016	2709	K21.9	Referred to specialist.
2017	2711	E78.5	Medication adjusted. Recheck in 6 weeks.
2018	2712	J06.9	Reviewed symptoms and history.
2019	2713	N39.0	Preventive counseling provided.
2020	2714	I10	Preventive counseling provided.
2021	2716	E78.5	Vitals stable. Continue current plan.
2022	2717	K21.9	Reviewed symptoms and history.
2023	2718	J06.9	Referred to specialist.
2024	2720	K21.9	Discussed lab results with patient.
2025	2721	L30.9	Preventive counseling provided.
2026	2722	K21.9	Vitals stable. Continue current plan.
2027	2723	M54.5	Preventive counseling provided.
2028	2724	J45.909	Medication adjusted. Recheck in 6 weeks.
2029	2725	J45.909	Discussed lab results with patient.
2030	2726	L30.9	Referred to specialist.
2031	2729	M54.5	Vitals stable. Continue current plan.
2032	2730	E78.5	Medication adjusted. Recheck in 6 weeks.
2033	2731	K21.9	Referred to specialist.
2034	2732	L30.9	Medication adjusted. Recheck in 6 weeks.
2035	2733	L30.9	Medication adjusted. Recheck in 6 weeks.
2036	2735	J06.9	Medication adjusted. Recheck in 6 weeks.
2037	2737	L30.9	Discussed lab results with patient.
2038	2738	F41.1	Discussed lab results with patient.
2039	2739	I10	Discussed lab results with patient.
2040	2740	L30.9	Referred to specialist.
2041	2742	N39.0	Vitals stable. Continue current plan.
2042	2743	E11.9	Preventive counseling provided.
2043	2746	N39.0	Reviewed symptoms and history.
2044	2747	J45.909	Reviewed symptoms and history.
2045	2750	R51.9	Reviewed symptoms and history.
2046	2751	N39.0	Reviewed symptoms and history.
2047	2752	F41.1	Reviewed symptoms and history.
2048	2753	E11.9	Medication adjusted. Recheck in 6 weeks.
2049	2754	M54.5	Medication adjusted. Recheck in 6 weeks.
2050	2757	Z00.00	Discussed lab results with patient.
2051	2758	E78.5	Medication adjusted. Recheck in 6 weeks.
2052	2760	J06.9	Referred to specialist.
2053	2764	J45.909	Reviewed symptoms and history.
2054	2765	J45.909	Reviewed symptoms and history.
2055	2766	J45.909	Referred to specialist.
2056	2767	J06.9	Preventive counseling provided.
2057	2771	M54.5	Reviewed symptoms and history.
2058	2772	Z00.00	Medication adjusted. Recheck in 6 weeks.
2059	2773	J45.909	Discussed lab results with patient.
2060	2774	M54.5	Vitals stable. Continue current plan.
2061	2775	E11.9	Medication adjusted. Recheck in 6 weeks.
2062	2776	E78.5	Discussed lab results with patient.
2063	2777	Z00.00	Reviewed symptoms and history.
2064	2779	R51.9	Vitals stable. Continue current plan.
2065	2780	Z00.00	Discussed lab results with patient.
2066	2781	J45.909	Vitals stable. Continue current plan.
2067	2782	R51.9	Discussed lab results with patient.
2068	2783	N39.0	Medication adjusted. Recheck in 6 weeks.
2069	2784	J06.9	Medication adjusted. Recheck in 6 weeks.
2070	2785	Z00.00	Referred to specialist.
2071	2786	J45.909	Referred to specialist.
2072	2789	R51.9	Vitals stable. Continue current plan.
2073	2791	N39.0	Medication adjusted. Recheck in 6 weeks.
2074	2792	E11.9	Discussed lab results with patient.
2075	2793	L30.9	Vitals stable. Continue current plan.
2076	2794	I10	Preventive counseling provided.
2077	2795	R51.9	Preventive counseling provided.
2078	2796	K21.9	Referred to specialist.
2079	2797	J45.909	Reviewed symptoms and history.
2080	2798	K21.9	Discussed lab results with patient.
2081	2799	E78.5	Discussed lab results with patient.
2082	2800	F41.1	Medication adjusted. Recheck in 6 weeks.
2083	2801	N39.0	Discussed lab results with patient.
2084	2802	J06.9	Reviewed symptoms and history.
2085	2803	J45.909	Discussed lab results with patient.
2086	2804	E78.5	Reviewed symptoms and history.
2087	2805	Z00.00	Preventive counseling provided.
2088	2806	R51.9	Reviewed symptoms and history.
2089	2807	I10	Vitals stable. Continue current plan.
2090	2808	M54.5	Discussed lab results with patient.
2091	2809	L30.9	Medication adjusted. Recheck in 6 weeks.
2092	2810	E78.5	Preventive counseling provided.
2093	2811	Z00.00	Medication adjusted. Recheck in 6 weeks.
2094	2812	I10	Reviewed symptoms and history.
2095	2813	J45.909	Referred to specialist.
2096	2814	R51.9	Reviewed symptoms and history.
2097	2817	K21.9	Discussed lab results with patient.
2098	2818	E11.9	Preventive counseling provided.
2099	2819	J06.9	Vitals stable. Continue current plan.
2100	2820	K21.9	Referred to specialist.
2101	2821	L30.9	Reviewed symptoms and history.
2102	2822	I10	Referred to specialist.
2103	2823	J06.9	Medication adjusted. Recheck in 6 weeks.
2104	2824	K21.9	Vitals stable. Continue current plan.
2105	2825	J06.9	Preventive counseling provided.
2106	2826	R51.9	Medication adjusted. Recheck in 6 weeks.
2107	2827	R51.9	Preventive counseling provided.
2108	2828	K21.9	Medication adjusted. Recheck in 6 weeks.
2109	2829	K21.9	Medication adjusted. Recheck in 6 weeks.
2110	2831	M54.5	Medication adjusted. Recheck in 6 weeks.
2111	2832	E11.9	Discussed lab results with patient.
2112	2833	J06.9	Preventive counseling provided.
2113	2835	J06.9	Referred to specialist.
2114	2838	L30.9	Preventive counseling provided.
2115	2839	R51.9	Reviewed symptoms and history.
2116	2841	N39.0	Medication adjusted. Recheck in 6 weeks.
2117	2842	J45.909	Discussed lab results with patient.
2118	2844	R51.9	Vitals stable. Continue current plan.
2119	2845	E78.5	Discussed lab results with patient.
2120	2846	J06.9	Preventive counseling provided.
2121	2847	N39.0	Referred to specialist.
2122	2848	F41.1	Vitals stable. Continue current plan.
2123	2849	R51.9	Preventive counseling provided.
2124	2850	Z00.00	Vitals stable. Continue current plan.
2125	2851	K21.9	Referred to specialist.
2126	2852	J06.9	Referred to specialist.
2127	2853	F41.1	Vitals stable. Continue current plan.
2128	2854	L30.9	Reviewed symptoms and history.
2129	2855	M54.5	Discussed lab results with patient.
2130	2856	M54.5	Medication adjusted. Recheck in 6 weeks.
2131	2858	N39.0	Vitals stable. Continue current plan.
2132	2859	L30.9	Reviewed symptoms and history.
2133	2861	R51.9	Referred to specialist.
2134	2863	E11.9	Medication adjusted. Recheck in 6 weeks.
2135	2864	F41.1	Medication adjusted. Recheck in 6 weeks.
2136	2866	R51.9	Medication adjusted. Recheck in 6 weeks.
2137	2867	Z00.00	Preventive counseling provided.
2138	2869	M54.5	Reviewed symptoms and history.
2139	2870	F41.1	Vitals stable. Continue current plan.
2140	2871	R51.9	Preventive counseling provided.
2141	2872	I10	Reviewed symptoms and history.
2142	2873	N39.0	Reviewed symptoms and history.
2143	2874	J45.909	Vitals stable. Continue current plan.
2144	2878	J06.9	Discussed lab results with patient.
2145	2879	F41.1	Reviewed symptoms and history.
2146	2880	I10	Discussed lab results with patient.
2147	2881	L30.9	Referred to specialist.
2148	2882	I10	Discussed lab results with patient.
2149	2883	J06.9	Vitals stable. Continue current plan.
2150	2884	I10	Referred to specialist.
2151	2885	R51.9	Medication adjusted. Recheck in 6 weeks.
2152	2886	E11.9	Medication adjusted. Recheck in 6 weeks.
2153	2887	M54.5	Reviewed symptoms and history.
2154	2888	Z00.00	Referred to specialist.
2155	2889	R51.9	Referred to specialist.
2156	2890	E11.9	Discussed lab results with patient.
2157	2891	R51.9	Reviewed symptoms and history.
2158	2892	J06.9	Vitals stable. Continue current plan.
2159	2894	F41.1	Vitals stable. Continue current plan.
2160	2895	L30.9	Referred to specialist.
2161	2896	F41.1	Vitals stable. Continue current plan.
2162	2898	I10	Preventive counseling provided.
2163	2899	M54.5	Referred to specialist.
2164	2900	J45.909	Discussed lab results with patient.
2165	2901	F41.1	Reviewed symptoms and history.
2166	2902	J06.9	Preventive counseling provided.
2167	2903	L30.9	Discussed lab results with patient.
2168	2905	I10	Discussed lab results with patient.
2169	2906	J06.9	Referred to specialist.
2170	2907	K21.9	Vitals stable. Continue current plan.
2171	2908	N39.0	Discussed lab results with patient.
2172	2909	I10	Reviewed symptoms and history.
2173	2912	Z00.00	Preventive counseling provided.
2174	2916	L30.9	Referred to specialist.
2175	2918	I10	Vitals stable. Continue current plan.
2176	2919	L30.9	Vitals stable. Continue current plan.
2177	2920	F41.1	Discussed lab results with patient.
2178	2921	J06.9	Preventive counseling provided.
2179	2922	M54.5	Referred to specialist.
2180	2923	E11.9	Discussed lab results with patient.
2181	2924	E11.9	Referred to specialist.
2182	2925	I10	Vitals stable. Continue current plan.
2183	2926	L30.9	Medication adjusted. Recheck in 6 weeks.
2184	2927	E78.5	Medication adjusted. Recheck in 6 weeks.
2185	2928	N39.0	Vitals stable. Continue current plan.
2186	2929	I10	Vitals stable. Continue current plan.
2187	2930	K21.9	Discussed lab results with patient.
2188	2931	J06.9	Medication adjusted. Recheck in 6 weeks.
2189	2932	R51.9	Medication adjusted. Recheck in 6 weeks.
2190	2933	Z00.00	Discussed lab results with patient.
2191	2934	K21.9	Referred to specialist.
2192	2936	I10	Medication adjusted. Recheck in 6 weeks.
2193	2937	M54.5	Referred to specialist.
2194	2938	M54.5	Medication adjusted. Recheck in 6 weeks.
2195	2939	N39.0	Preventive counseling provided.
2196	2941	K21.9	Medication adjusted. Recheck in 6 weeks.
2197	2942	E11.9	Reviewed symptoms and history.
2198	2943	J06.9	Medication adjusted. Recheck in 6 weeks.
2199	2945	L30.9	Reviewed symptoms and history.
2200	2947	J06.9	Reviewed symptoms and history.
2201	2948	E78.5	Discussed lab results with patient.
2202	2949	E78.5	Preventive counseling provided.
2203	2950	E78.5	Discussed lab results with patient.
2204	2953	M54.5	Medication adjusted. Recheck in 6 weeks.
2205	2954	L30.9	Vitals stable. Continue current plan.
2206	2955	K21.9	Medication adjusted. Recheck in 6 weeks.
2207	2956	E78.5	Discussed lab results with patient.
2208	2957	E78.5	Vitals stable. Continue current plan.
2209	2958	Z00.00	Discussed lab results with patient.
2210	2959	M54.5	Reviewed symptoms and history.
2211	2961	E78.5	Vitals stable. Continue current plan.
2212	2962	F41.1	Referred to specialist.
2213	2964	L30.9	Referred to specialist.
2214	2965	I10	Discussed lab results with patient.
2215	2966	F41.1	Vitals stable. Continue current plan.
2216	2967	F41.1	Preventive counseling provided.
2217	2968	I10	Reviewed symptoms and history.
2218	2969	J45.909	Reviewed symptoms and history.
2219	2970	R51.9	Referred to specialist.
2220	2972	F41.1	Reviewed symptoms and history.
2221	2974	Z00.00	Vitals stable. Continue current plan.
2222	2976	L30.9	Preventive counseling provided.
2223	2978	R51.9	Medication adjusted. Recheck in 6 weeks.
2224	2979	R51.9	Discussed lab results with patient.
2225	2980	I10	Reviewed symptoms and history.
2226	2981	J06.9	Referred to specialist.
2227	2982	J45.909	Preventive counseling provided.
2228	2983	J06.9	Vitals stable. Continue current plan.
2229	2984	E11.9	Vitals stable. Continue current plan.
2230	2985	J45.909	Vitals stable. Continue current plan.
2231	2986	Z00.00	Preventive counseling provided.
2232	2990	L30.9	Vitals stable. Continue current plan.
2233	2993	R51.9	Medication adjusted. Recheck in 6 weeks.
2234	2994	N39.0	Preventive counseling provided.
2235	2998	L30.9	Referred to specialist.
2236	2999	F41.1	Referred to specialist.
2237	3000	E78.5	Referred to specialist.
2238	3001	E11.9	Discussed lab results with patient.
2239	3002	R51.9	Referred to specialist.
2240	3003	I10	Medication adjusted. Recheck in 6 weeks.
2241	3004	Z00.00	Preventive counseling provided.
2242	3005	I10	Reviewed symptoms and history.
2243	3007	K21.9	Reviewed symptoms and history.
2244	3008	L30.9	Referred to specialist.
2245	3009	M54.5	Vitals stable. Continue current plan.
2246	3011	J45.909	Medication adjusted. Recheck in 6 weeks.
2247	3012	K21.9	Reviewed symptoms and history.
2248	3013	E11.9	Discussed lab results with patient.
2249	3014	N39.0	Vitals stable. Continue current plan.
2250	3015	E78.5	Discussed lab results with patient.
2251	3016	L30.9	Vitals stable. Continue current plan.
2252	3019	J45.909	Discussed lab results with patient.
2253	3020	E78.5	Medication adjusted. Recheck in 6 weeks.
2254	3021	J45.909	Reviewed symptoms and history.
2255	3022	J45.909	Discussed lab results with patient.
2256	3023	Z00.00	Referred to specialist.
2257	3025	K21.9	Medication adjusted. Recheck in 6 weeks.
2258	3026	N39.0	Referred to specialist.
2259	3028	J45.909	Reviewed symptoms and history.
2260	3030	N39.0	Medication adjusted. Recheck in 6 weeks.
2261	3031	N39.0	Referred to specialist.
2262	3033	I10	Preventive counseling provided.
2263	3034	L30.9	Discussed lab results with patient.
2264	3035	R51.9	Reviewed symptoms and history.
2265	3036	M54.5	Medication adjusted. Recheck in 6 weeks.
2266	3038	J45.909	Preventive counseling provided.
2267	3039	Z00.00	Reviewed symptoms and history.
2268	3043	M54.5	Discussed lab results with patient.
2269	3044	L30.9	Reviewed symptoms and history.
2270	3045	K21.9	Preventive counseling provided.
2271	3046	I10	Medication adjusted. Recheck in 6 weeks.
2272	3047	F41.1	Referred to specialist.
2273	3050	E78.5	Discussed lab results with patient.
2274	3051	E78.5	Medication adjusted. Recheck in 6 weeks.
2275	3052	K21.9	Referred to specialist.
2276	3053	J06.9	Reviewed symptoms and history.
2277	3055	N39.0	Vitals stable. Continue current plan.
2278	3056	F41.1	Discussed lab results with patient.
2279	3059	E78.5	Medication adjusted. Recheck in 6 weeks.
2280	3060	K21.9	Vitals stable. Continue current plan.
2281	3061	F41.1	Vitals stable. Continue current plan.
2282	3062	R51.9	Referred to specialist.
2283	3064	N39.0	Discussed lab results with patient.
2284	3065	Z00.00	Reviewed symptoms and history.
2285	3066	J06.9	Reviewed symptoms and history.
2286	3068	I10	Preventive counseling provided.
2287	3069	K21.9	Referred to specialist.
2288	3070	N39.0	Medication adjusted. Recheck in 6 weeks.
2289	3071	N39.0	Vitals stable. Continue current plan.
2290	3073	I10	Referred to specialist.
2291	3075	E11.9	Referred to specialist.
2292	3076	K21.9	Preventive counseling provided.
2293	3077	J45.909	Reviewed symptoms and history.
2294	3078	I10	Vitals stable. Continue current plan.
2295	3079	Z00.00	Medication adjusted. Recheck in 6 weeks.
2296	3080	N39.0	Medication adjusted. Recheck in 6 weeks.
2297	3081	R51.9	Preventive counseling provided.
2298	3083	J06.9	Vitals stable. Continue current plan.
2299	3084	I10	Medication adjusted. Recheck in 6 weeks.
2300	3086	N39.0	Referred to specialist.
2301	3087	E78.5	Preventive counseling provided.
2302	3088	I10	Vitals stable. Continue current plan.
2303	3089	N39.0	Preventive counseling provided.
2304	3090	E11.9	Medication adjusted. Recheck in 6 weeks.
2305	3091	K21.9	Discussed lab results with patient.
2306	3094	Z00.00	Medication adjusted. Recheck in 6 weeks.
2307	3095	F41.1	Medication adjusted. Recheck in 6 weeks.
2308	3096	E11.9	Vitals stable. Continue current plan.
2309	3098	R51.9	Vitals stable. Continue current plan.
2310	3099	N39.0	Vitals stable. Continue current plan.
2311	3101	Z00.00	Reviewed symptoms and history.
2312	3102	N39.0	Discussed lab results with patient.
2313	3103	F41.1	Referred to specialist.
2314	3104	E78.5	Vitals stable. Continue current plan.
2315	3106	N39.0	Preventive counseling provided.
2316	3107	N39.0	Reviewed symptoms and history.
2317	3109	E11.9	Vitals stable. Continue current plan.
2318	3110	I10	Referred to specialist.
2319	3111	J06.9	Referred to specialist.
2320	3112	J45.909	Preventive counseling provided.
2321	3113	I10	Medication adjusted. Recheck in 6 weeks.
2322	3114	R51.9	Discussed lab results with patient.
2323	3116	I10	Discussed lab results with patient.
2324	3117	L30.9	Referred to specialist.
2325	3118	E11.9	Referred to specialist.
2326	3119	K21.9	Medication adjusted. Recheck in 6 weeks.
2327	3120	F41.1	Referred to specialist.
2328	3121	J06.9	Medication adjusted. Recheck in 6 weeks.
2329	3123	R51.9	Vitals stable. Continue current plan.
2330	3124	Z00.00	Vitals stable. Continue current plan.
2331	3125	I10	Vitals stable. Continue current plan.
2332	3127	K21.9	Referred to specialist.
2333	3128	I10	Referred to specialist.
2334	3129	E11.9	Vitals stable. Continue current plan.
2335	3130	E78.5	Reviewed symptoms and history.
2336	3131	I10	Reviewed symptoms and history.
2337	3132	J45.909	Preventive counseling provided.
2338	3135	Z00.00	Reviewed symptoms and history.
2339	3137	K21.9	Vitals stable. Continue current plan.
2340	3138	E78.5	Preventive counseling provided.
2341	3139	J06.9	Vitals stable. Continue current plan.
2342	3141	E11.9	Medication adjusted. Recheck in 6 weeks.
2343	3142	J45.909	Preventive counseling provided.
2344	3143	F41.1	Discussed lab results with patient.
2345	3144	E11.9	Discussed lab results with patient.
2346	3145	F41.1	Reviewed symptoms and history.
2347	3146	J45.909	Vitals stable. Continue current plan.
2348	3147	I10	Reviewed symptoms and history.
2349	3148	I10	Preventive counseling provided.
2350	3150	E78.5	Preventive counseling provided.
2351	3151	E78.5	Reviewed symptoms and history.
2352	3152	I10	Referred to specialist.
2353	3153	E78.5	Discussed lab results with patient.
2354	3154	L30.9	Referred to specialist.
2355	3156	E78.5	Referred to specialist.
2356	3157	J06.9	Vitals stable. Continue current plan.
2357	3158	E78.5	Referred to specialist.
2358	3159	Z00.00	Vitals stable. Continue current plan.
2359	3162	I10	Medication adjusted. Recheck in 6 weeks.
2360	3163	E78.5	Preventive counseling provided.
2361	3165	M54.5	Discussed lab results with patient.
2362	3166	J06.9	Referred to specialist.
2363	3168	J06.9	Reviewed symptoms and history.
2364	3169	L30.9	Discussed lab results with patient.
2365	3170	E78.5	Discussed lab results with patient.
2366	3171	Z00.00	Preventive counseling provided.
2367	3172	M54.5	Discussed lab results with patient.
2368	3173	Z00.00	Discussed lab results with patient.
2369	3175	J06.9	Preventive counseling provided.
2370	3176	K21.9	Medication adjusted. Recheck in 6 weeks.
2371	3178	N39.0	Referred to specialist.
2372	3179	E11.9	Preventive counseling provided.
2373	3180	J06.9	Discussed lab results with patient.
2374	3182	I10	Referred to specialist.
2375	3183	J06.9	Medication adjusted. Recheck in 6 weeks.
2376	3186	E11.9	Referred to specialist.
2377	3187	E78.5	Preventive counseling provided.
2378	3189	N39.0	Preventive counseling provided.
2379	3190	I10	Vitals stable. Continue current plan.
2380	3191	R51.9	Vitals stable. Continue current plan.
2381	3192	I10	Medication adjusted. Recheck in 6 weeks.
2382	3193	I10	Preventive counseling provided.
2383	3194	M54.5	Vitals stable. Continue current plan.
2384	3195	J06.9	Referred to specialist.
2385	3196	F41.1	Preventive counseling provided.
2386	3197	Z00.00	Discussed lab results with patient.
2387	3200	R51.9	Discussed lab results with patient.
2388	3201	J06.9	Preventive counseling provided.
2389	3202	L30.9	Medication adjusted. Recheck in 6 weeks.
2390	3204	Z00.00	Referred to specialist.
2391	3205	R51.9	Medication adjusted. Recheck in 6 weeks.
2392	3206	Z00.00	Referred to specialist.
2393	3207	E78.5	Vitals stable. Continue current plan.
2394	3208	N39.0	Referred to specialist.
2395	3210	K21.9	Medication adjusted. Recheck in 6 weeks.
2396	3211	E11.9	Vitals stable. Continue current plan.
2397	3212	M54.5	Discussed lab results with patient.
2398	3213	R51.9	Preventive counseling provided.
2399	3214	E78.5	Discussed lab results with patient.
2400	3215	E11.9	Reviewed symptoms and history.
2401	3217	E78.5	Preventive counseling provided.
2402	3219	J45.909	Referred to specialist.
2403	3221	J45.909	Discussed lab results with patient.
2404	3223	M54.5	Referred to specialist.
2405	3224	M54.5	Vitals stable. Continue current plan.
2406	3225	E11.9	Medication adjusted. Recheck in 6 weeks.
2407	3226	J45.909	Reviewed symptoms and history.
2408	3227	F41.1	Reviewed symptoms and history.
2409	3229	K21.9	Discussed lab results with patient.
2410	3230	J45.909	Referred to specialist.
2411	3231	I10	Vitals stable. Continue current plan.
2412	3234	J45.909	Medication adjusted. Recheck in 6 weeks.
2413	3235	E11.9	Vitals stable. Continue current plan.
2414	3236	E78.5	Referred to specialist.
2415	3237	J06.9	Vitals stable. Continue current plan.
2416	3240	J06.9	Discussed lab results with patient.
2417	3241	F41.1	Referred to specialist.
2418	3244	Z00.00	Discussed lab results with patient.
2419	3245	J45.909	Preventive counseling provided.
2420	3246	J45.909	Reviewed symptoms and history.
2421	3248	K21.9	Reviewed symptoms and history.
2422	3249	M54.5	Referred to specialist.
2423	3250	M54.5	Referred to specialist.
2424	3251	E78.5	Medication adjusted. Recheck in 6 weeks.
2425	3252	R51.9	Preventive counseling provided.
2426	3253	E11.9	Medication adjusted. Recheck in 6 weeks.
2427	3254	N39.0	Vitals stable. Continue current plan.
2428	3256	F41.1	Medication adjusted. Recheck in 6 weeks.
2429	3258	L30.9	Medication adjusted. Recheck in 6 weeks.
2430	3259	L30.9	Vitals stable. Continue current plan.
2431	3261	M54.5	Referred to specialist.
2432	3263	L30.9	Preventive counseling provided.
2433	3264	K21.9	Preventive counseling provided.
2434	3265	F41.1	Vitals stable. Continue current plan.
2435	3266	I10	Medication adjusted. Recheck in 6 weeks.
2436	3267	E78.5	Preventive counseling provided.
2437	3268	K21.9	Medication adjusted. Recheck in 6 weeks.
2438	3269	M54.5	Referred to specialist.
2439	3270	E11.9	Referred to specialist.
2440	3272	I10	Preventive counseling provided.
2441	3274	E11.9	Referred to specialist.
2442	3275	J45.909	Medication adjusted. Recheck in 6 weeks.
2443	3276	J45.909	Discussed lab results with patient.
2444	3277	E11.9	Discussed lab results with patient.
2445	3278	I10	Preventive counseling provided.
2446	3279	M54.5	Preventive counseling provided.
2447	3280	Z00.00	Discussed lab results with patient.
2448	3283	E11.9	Vitals stable. Continue current plan.
2449	3284	K21.9	Vitals stable. Continue current plan.
2450	3285	Z00.00	Medication adjusted. Recheck in 6 weeks.
2451	3286	Z00.00	Preventive counseling provided.
2452	3288	R51.9	Referred to specialist.
2453	3290	F41.1	Discussed lab results with patient.
2454	3292	L30.9	Preventive counseling provided.
2455	3293	E78.5	Vitals stable. Continue current plan.
2456	3295	K21.9	Reviewed symptoms and history.
2457	3296	J06.9	Referred to specialist.
2458	3297	I10	Medication adjusted. Recheck in 6 weeks.
2459	3298	E11.9	Discussed lab results with patient.
2460	3299	E11.9	Discussed lab results with patient.
2461	3300	K21.9	Preventive counseling provided.
2462	3302	E11.9	Discussed lab results with patient.
2463	3303	E11.9	Vitals stable. Continue current plan.
2464	3304	K21.9	Referred to specialist.
2465	3305	I10	Vitals stable. Continue current plan.
2466	3306	F41.1	Discussed lab results with patient.
2467	3307	K21.9	Discussed lab results with patient.
2468	3310	F41.1	Preventive counseling provided.
2469	3311	F41.1	Reviewed symptoms and history.
2470	3312	N39.0	Vitals stable. Continue current plan.
2471	3313	J06.9	Referred to specialist.
2472	3315	M54.5	Medication adjusted. Recheck in 6 weeks.
2473	3320	I10	Preventive counseling provided.
2474	3321	K21.9	Discussed lab results with patient.
2475	3323	I10	Reviewed symptoms and history.
2476	3324	M54.5	Discussed lab results with patient.
2477	3325	E11.9	Medication adjusted. Recheck in 6 weeks.
2478	3326	J06.9	Reviewed symptoms and history.
2479	3327	N39.0	Referred to specialist.
2480	3328	J06.9	Discussed lab results with patient.
2481	3329	N39.0	Reviewed symptoms and history.
2482	3330	N39.0	Medication adjusted. Recheck in 6 weeks.
2483	3333	L30.9	Discussed lab results with patient.
2484	3334	L30.9	Medication adjusted. Recheck in 6 weeks.
2485	3335	J06.9	Medication adjusted. Recheck in 6 weeks.
2486	3336	F41.1	Medication adjusted. Recheck in 6 weeks.
2487	3337	J06.9	Preventive counseling provided.
2488	3338	J06.9	Vitals stable. Continue current plan.
2489	3339	M54.5	Preventive counseling provided.
2490	3340	Z00.00	Referred to specialist.
2491	3342	I10	Preventive counseling provided.
2492	3343	J45.909	Medication adjusted. Recheck in 6 weeks.
2493	3344	I10	Medication adjusted. Recheck in 6 weeks.
2494	3345	L30.9	Reviewed symptoms and history.
2495	3346	I10	Reviewed symptoms and history.
2496	3348	M54.5	Discussed lab results with patient.
2497	3350	L30.9	Medication adjusted. Recheck in 6 weeks.
2498	3351	E78.5	Vitals stable. Continue current plan.
2499	3352	M54.5	Reviewed symptoms and history.
2500	3353	L30.9	Vitals stable. Continue current plan.
2501	3354	R51.9	Preventive counseling provided.
2502	3355	M54.5	Medication adjusted. Recheck in 6 weeks.
2503	3357	I10	Medication adjusted. Recheck in 6 weeks.
2504	3358	E78.5	Medication adjusted. Recheck in 6 weeks.
2505	3359	Z00.00	Vitals stable. Continue current plan.
2506	3360	M54.5	Medication adjusted. Recheck in 6 weeks.
2507	3362	I10	Referred to specialist.
2508	3364	J45.909	Reviewed symptoms and history.
2509	3366	N39.0	Referred to specialist.
2510	3367	Z00.00	Discussed lab results with patient.
2511	3368	N39.0	Reviewed symptoms and history.
2512	3369	L30.9	Reviewed symptoms and history.
2513	3370	E11.9	Referred to specialist.
2514	3371	K21.9	Referred to specialist.
2515	3372	E78.5	Preventive counseling provided.
2516	3373	L30.9	Referred to specialist.
2517	3375	L30.9	Referred to specialist.
2518	3376	N39.0	Medication adjusted. Recheck in 6 weeks.
2519	3377	Z00.00	Medication adjusted. Recheck in 6 weeks.
2520	3378	E11.9	Referred to specialist.
2521	3379	F41.1	Preventive counseling provided.
2522	3380	K21.9	Discussed lab results with patient.
2523	3385	E11.9	Reviewed symptoms and history.
2524	3386	J06.9	Preventive counseling provided.
2525	3387	I10	Reviewed symptoms and history.
2526	3388	R51.9	Vitals stable. Continue current plan.
2527	3390	N39.0	Discussed lab results with patient.
2528	3391	J45.909	Vitals stable. Continue current plan.
2529	3392	M54.5	Preventive counseling provided.
2530	3393	N39.0	Preventive counseling provided.
2531	3394	Z00.00	Referred to specialist.
2532	3395	J06.9	Medication adjusted. Recheck in 6 weeks.
2533	3397	K21.9	Vitals stable. Continue current plan.
2534	3398	E11.9	Referred to specialist.
2535	3399	K21.9	Medication adjusted. Recheck in 6 weeks.
2536	3400	R51.9	Reviewed symptoms and history.
2537	3401	F41.1	Reviewed symptoms and history.
2538	3402	L30.9	Medication adjusted. Recheck in 6 weeks.
2539	3407	L30.9	Preventive counseling provided.
2540	3408	L30.9	Reviewed symptoms and history.
2541	3409	N39.0	Vitals stable. Continue current plan.
2542	3410	E78.5	Referred to specialist.
2543	3412	M54.5	Preventive counseling provided.
2544	3416	J45.909	Reviewed symptoms and history.
2545	3417	I10	Medication adjusted. Recheck in 6 weeks.
2546	3418	J45.909	Preventive counseling provided.
2547	3419	K21.9	Preventive counseling provided.
2548	3420	N39.0	Reviewed symptoms and history.
2549	3421	K21.9	Discussed lab results with patient.
2550	3422	J45.909	Vitals stable. Continue current plan.
2551	3424	E78.5	Discussed lab results with patient.
2552	3425	M54.5	Referred to specialist.
2553	3426	E11.9	Reviewed symptoms and history.
2554	3427	M54.5	Discussed lab results with patient.
2555	3428	J45.909	Preventive counseling provided.
2556	3430	I10	Referred to specialist.
2557	3431	E11.9	Medication adjusted. Recheck in 6 weeks.
2558	3432	N39.0	Preventive counseling provided.
2559	3433	J06.9	Medication adjusted. Recheck in 6 weeks.
2560	3434	M54.5	Reviewed symptoms and history.
2561	3435	M54.5	Referred to specialist.
2562	3436	E78.5	Referred to specialist.
2563	3437	N39.0	Preventive counseling provided.
2564	3438	J45.909	Medication adjusted. Recheck in 6 weeks.
2565	3439	J45.909	Medication adjusted. Recheck in 6 weeks.
2566	3440	Z00.00	Reviewed symptoms and history.
2567	3442	M54.5	Vitals stable. Continue current plan.
2568	3444	N39.0	Medication adjusted. Recheck in 6 weeks.
2569	3445	I10	Vitals stable. Continue current plan.
2570	3446	N39.0	Medication adjusted. Recheck in 6 weeks.
2571	3450	F41.1	Referred to specialist.
2572	3451	F41.1	Medication adjusted. Recheck in 6 weeks.
2573	3452	J45.909	Preventive counseling provided.
2574	3453	R51.9	Referred to specialist.
2575	3455	E11.9	Vitals stable. Continue current plan.
2576	3456	M54.5	Vitals stable. Continue current plan.
2577	3457	J06.9	Reviewed symptoms and history.
2578	3459	N39.0	Vitals stable. Continue current plan.
2579	3460	M54.5	Referred to specialist.
2580	3461	K21.9	Medication adjusted. Recheck in 6 weeks.
2581	3462	E78.5	Preventive counseling provided.
2582	3463	L30.9	Vitals stable. Continue current plan.
2583	3465	J45.909	Reviewed symptoms and history.
2584	3466	N39.0	Vitals stable. Continue current plan.
2585	3467	Z00.00	Preventive counseling provided.
2586	3468	E11.9	Preventive counseling provided.
2587	3470	F41.1	Referred to specialist.
2588	3471	L30.9	Medication adjusted. Recheck in 6 weeks.
2589	3474	N39.0	Preventive counseling provided.
2590	3475	E11.9	Reviewed symptoms and history.
2591	3476	E78.5	Discussed lab results with patient.
2592	3477	K21.9	Discussed lab results with patient.
2593	3478	N39.0	Preventive counseling provided.
2594	3479	Z00.00	Referred to specialist.
2595	3481	R51.9	Reviewed symptoms and history.
2596	3482	M54.5	Vitals stable. Continue current plan.
2597	3483	E11.9	Vitals stable. Continue current plan.
2598	3484	Z00.00	Preventive counseling provided.
2599	3485	L30.9	Medication adjusted. Recheck in 6 weeks.
2600	3486	E11.9	Reviewed symptoms and history.
2601	3487	L30.9	Vitals stable. Continue current plan.
2602	3488	J45.909	Reviewed symptoms and history.
2603	3489	E11.9	Referred to specialist.
2604	3491	E78.5	Preventive counseling provided.
2605	3492	E11.9	Medication adjusted. Recheck in 6 weeks.
2606	3493	K21.9	Reviewed symptoms and history.
2607	3494	I10	Vitals stable. Continue current plan.
2608	3495	J06.9	Discussed lab results with patient.
2609	3496	R51.9	Medication adjusted. Recheck in 6 weeks.
2610	3497	E78.5	Vitals stable. Continue current plan.
2611	3498	L30.9	Referred to specialist.
2612	3499	J45.909	Referred to specialist.
2613	3500	K21.9	Vitals stable. Continue current plan.
2614	3502	E78.5	Referred to specialist.
2615	3506	I10	Medication adjusted. Recheck in 6 weeks.
2616	3509	N39.0	Discussed lab results with patient.
2617	3510	N39.0	Vitals stable. Continue current plan.
2618	3512	R51.9	Discussed lab results with patient.
2619	3513	E78.5	Referred to specialist.
2620	3514	K21.9	Referred to specialist.
2621	3515	J45.909	Referred to specialist.
2622	3516	F41.1	Preventive counseling provided.
2623	3518	R51.9	Discussed lab results with patient.
2624	3519	N39.0	Discussed lab results with patient.
2625	3520	E11.9	Medication adjusted. Recheck in 6 weeks.
2626	3521	I10	Vitals stable. Continue current plan.
2627	3523	F41.1	Reviewed symptoms and history.
2628	3525	L30.9	Discussed lab results with patient.
2629	3526	N39.0	Vitals stable. Continue current plan.
2630	3527	L30.9	Reviewed symptoms and history.
2631	3528	R51.9	Medication adjusted. Recheck in 6 weeks.
2632	3529	E11.9	Referred to specialist.
2633	3530	E78.5	Reviewed symptoms and history.
2634	3531	M54.5	Vitals stable. Continue current plan.
2635	3533	N39.0	Reviewed symptoms and history.
2636	3534	I10	Discussed lab results with patient.
2637	3537	Z00.00	Reviewed symptoms and history.
2638	3539	K21.9	Referred to specialist.
2639	3540	L30.9	Medication adjusted. Recheck in 6 weeks.
2640	3541	M54.5	Discussed lab results with patient.
2641	3542	M54.5	Referred to specialist.
2642	3543	F41.1	Medication adjusted. Recheck in 6 weeks.
2643	3544	N39.0	Vitals stable. Continue current plan.
2644	3545	L30.9	Reviewed symptoms and history.
2645	3546	L30.9	Discussed lab results with patient.
2646	3548	L30.9	Reviewed symptoms and history.
2647	3551	N39.0	Reviewed symptoms and history.
2648	3552	F41.1	Vitals stable. Continue current plan.
2649	3554	E11.9	Discussed lab results with patient.
2650	3555	F41.1	Preventive counseling provided.
2651	3556	F41.1	Referred to specialist.
2652	3557	J45.909	Reviewed symptoms and history.
2653	3558	Z00.00	Medication adjusted. Recheck in 6 weeks.
2654	3559	K21.9	Medication adjusted. Recheck in 6 weeks.
2655	3563	N39.0	Vitals stable. Continue current plan.
2656	3564	E11.9	Discussed lab results with patient.
2657	3565	I10	Referred to specialist.
2658	3566	K21.9	Medication adjusted. Recheck in 6 weeks.
2659	3567	E11.9	Medication adjusted. Recheck in 6 weeks.
2660	3569	J06.9	Vitals stable. Continue current plan.
2661	3570	N39.0	Referred to specialist.
2662	3571	J45.909	Vitals stable. Continue current plan.
2663	3572	K21.9	Reviewed symptoms and history.
2664	3573	Z00.00	Preventive counseling provided.
2665	3574	I10	Reviewed symptoms and history.
2666	3575	R51.9	Reviewed symptoms and history.
2667	3576	M54.5	Discussed lab results with patient.
2668	3577	N39.0	Reviewed symptoms and history.
2669	3579	I10	Vitals stable. Continue current plan.
2670	3580	E11.9	Discussed lab results with patient.
2671	3581	J06.9	Referred to specialist.
2672	3582	R51.9	Reviewed symptoms and history.
2673	3583	J06.9	Reviewed symptoms and history.
2674	3584	E11.9	Referred to specialist.
2675	3585	M54.5	Reviewed symptoms and history.
2676	3586	R51.9	Medication adjusted. Recheck in 6 weeks.
2677	3587	M54.5	Reviewed symptoms and history.
2678	3588	F41.1	Preventive counseling provided.
2679	3589	N39.0	Vitals stable. Continue current plan.
2680	3590	M54.5	Discussed lab results with patient.
2681	3591	F41.1	Referred to specialist.
2682	3592	F41.1	Discussed lab results with patient.
2683	3593	J06.9	Discussed lab results with patient.
2684	3594	L30.9	Medication adjusted. Recheck in 6 weeks.
2685	3596	Z00.00	Discussed lab results with patient.
2686	3597	Z00.00	Medication adjusted. Recheck in 6 weeks.
2687	3598	I10	Medication adjusted. Recheck in 6 weeks.
2688	3599	I10	Vitals stable. Continue current plan.
2689	3602	E11.9	Medication adjusted. Recheck in 6 weeks.
2690	3603	J45.909	Preventive counseling provided.
2691	3604	K21.9	Vitals stable. Continue current plan.
2692	3610	R51.9	Reviewed symptoms and history.
2693	3611	E11.9	Vitals stable. Continue current plan.
2694	3612	K21.9	Reviewed symptoms and history.
2695	3613	E78.5	Vitals stable. Continue current plan.
2696	3614	J06.9	Vitals stable. Continue current plan.
2697	3615	E11.9	Discussed lab results with patient.
2698	3617	L30.9	Preventive counseling provided.
2699	3619	Z00.00	Reviewed symptoms and history.
2700	3620	K21.9	Discussed lab results with patient.
2701	3621	Z00.00	Medication adjusted. Recheck in 6 weeks.
2702	3622	J06.9	Referred to specialist.
2703	3623	I10	Preventive counseling provided.
2704	3624	M54.5	Medication adjusted. Recheck in 6 weeks.
2705	3625	N39.0	Discussed lab results with patient.
2706	3626	R51.9	Reviewed symptoms and history.
2707	3628	J06.9	Referred to specialist.
2708	3631	I10	Referred to specialist.
2709	3632	I10	Medication adjusted. Recheck in 6 weeks.
2710	3633	I10	Referred to specialist.
2711	3634	N39.0	Vitals stable. Continue current plan.
2712	3636	R51.9	Medication adjusted. Recheck in 6 weeks.
2713	3637	E11.9	Referred to specialist.
2714	3638	R51.9	Medication adjusted. Recheck in 6 weeks.
2715	3639	M54.5	Vitals stable. Continue current plan.
2716	3640	E78.5	Preventive counseling provided.
2717	3641	I10	Referred to specialist.
2718	3642	E78.5	Preventive counseling provided.
2719	3643	J06.9	Reviewed symptoms and history.
2720	3644	Z00.00	Reviewed symptoms and history.
2721	3645	E11.9	Discussed lab results with patient.
2722	3646	K21.9	Referred to specialist.
2723	3647	F41.1	Vitals stable. Continue current plan.
2724	3648	R51.9	Medication adjusted. Recheck in 6 weeks.
2725	3649	J45.909	Referred to specialist.
2726	3650	E78.5	Preventive counseling provided.
2727	3651	I10	Reviewed symptoms and history.
2728	3653	J45.909	Preventive counseling provided.
2729	3654	M54.5	Vitals stable. Continue current plan.
2730	3655	I10	Referred to specialist.
2731	3656	L30.9	Preventive counseling provided.
2732	3657	J45.909	Medication adjusted. Recheck in 6 weeks.
2733	3658	I10	Reviewed symptoms and history.
2734	3659	M54.5	Discussed lab results with patient.
2735	3661	E78.5	Vitals stable. Continue current plan.
2736	3662	F41.1	Discussed lab results with patient.
2737	3663	R51.9	Medication adjusted. Recheck in 6 weeks.
2738	3665	Z00.00	Vitals stable. Continue current plan.
2739	3666	I10	Preventive counseling provided.
2740	3667	K21.9	Referred to specialist.
2741	3668	E11.9	Reviewed symptoms and history.
2742	3669	K21.9	Medication adjusted. Recheck in 6 weeks.
2743	3670	Z00.00	Reviewed symptoms and history.
2744	3671	Z00.00	Vitals stable. Continue current plan.
2745	3673	I10	Preventive counseling provided.
2746	3675	E11.9	Preventive counseling provided.
2747	3676	M54.5	Reviewed symptoms and history.
2748	3677	J06.9	Discussed lab results with patient.
2749	3678	R51.9	Reviewed symptoms and history.
2750	3679	I10	Preventive counseling provided.
2751	3682	Z00.00	Discussed lab results with patient.
2752	3683	L30.9	Reviewed symptoms and history.
2753	3684	R51.9	Reviewed symptoms and history.
2754	3686	R51.9	Referred to specialist.
2755	3687	I10	Referred to specialist.
2756	3688	E11.9	Discussed lab results with patient.
2757	3690	R51.9	Vitals stable. Continue current plan.
2758	3691	R51.9	Vitals stable. Continue current plan.
2759	3693	I10	Reviewed symptoms and history.
2760	3694	R51.9	Referred to specialist.
2761	3695	M54.5	Reviewed symptoms and history.
2762	3696	M54.5	Reviewed symptoms and history.
2763	3698	M54.5	Referred to specialist.
2764	3699	E11.9	Vitals stable. Continue current plan.
2765	3700	N39.0	Reviewed symptoms and history.
2766	3701	E11.9	Referred to specialist.
2767	3702	N39.0	Preventive counseling provided.
2768	3703	J45.909	Discussed lab results with patient.
2769	3704	L30.9	Discussed lab results with patient.
2770	3706	L30.9	Reviewed symptoms and history.
2771	3707	J45.909	Vitals stable. Continue current plan.
2772	3708	J45.909	Discussed lab results with patient.
2773	3709	N39.0	Referred to specialist.
2774	3710	J45.909	Vitals stable. Continue current plan.
2775	3711	N39.0	Preventive counseling provided.
2776	3712	L30.9	Vitals stable. Continue current plan.
2777	3714	E78.5	Vitals stable. Continue current plan.
2778	3715	J45.909	Reviewed symptoms and history.
2779	3716	K21.9	Referred to specialist.
2780	3717	I10	Discussed lab results with patient.
2781	3718	R51.9	Preventive counseling provided.
2782	3721	M54.5	Referred to specialist.
2783	3722	J06.9	Preventive counseling provided.
2784	3723	Z00.00	Referred to specialist.
2785	3724	E78.5	Referred to specialist.
2786	3726	E78.5	Reviewed symptoms and history.
2787	3727	L30.9	Referred to specialist.
2788	3728	Z00.00	Reviewed symptoms and history.
2789	3729	J06.9	Medication adjusted. Recheck in 6 weeks.
2790	3730	L30.9	Preventive counseling provided.
2791	3731	J45.909	Discussed lab results with patient.
2792	3736	J45.909	Referred to specialist.
2793	3737	N39.0	Referred to specialist.
2794	3738	N39.0	Referred to specialist.
2795	3739	R51.9	Reviewed symptoms and history.
2796	3741	J06.9	Discussed lab results with patient.
2797	3744	J45.909	Preventive counseling provided.
2798	3745	E11.9	Vitals stable. Continue current plan.
2799	3746	N39.0	Discussed lab results with patient.
2800	3747	M54.5	Reviewed symptoms and history.
2801	3750	L30.9	Reviewed symptoms and history.
2802	3751	K21.9	Vitals stable. Continue current plan.
2803	3752	M54.5	Discussed lab results with patient.
2804	3753	K21.9	Reviewed symptoms and history.
2805	3755	M54.5	Discussed lab results with patient.
2806	3758	R51.9	Preventive counseling provided.
2807	3759	F41.1	Discussed lab results with patient.
2808	3760	N39.0	Discussed lab results with patient.
2809	3761	L30.9	Discussed lab results with patient.
2810	3762	I10	Referred to specialist.
2811	3763	J45.909	Preventive counseling provided.
2812	3764	I10	Reviewed symptoms and history.
2813	3765	E11.9	Vitals stable. Continue current plan.
2814	3766	L30.9	Reviewed symptoms and history.
2815	3767	M54.5	Vitals stable. Continue current plan.
2816	3768	R51.9	Preventive counseling provided.
2817	3769	F41.1	Preventive counseling provided.
2818	3773	Z00.00	Medication adjusted. Recheck in 6 weeks.
2819	3775	K21.9	Referred to specialist.
2820	3776	J45.909	Medication adjusted. Recheck in 6 weeks.
2821	3778	J45.909	Medication adjusted. Recheck in 6 weeks.
2822	3779	E78.5	Medication adjusted. Recheck in 6 weeks.
2823	3780	R51.9	Reviewed symptoms and history.
2824	3781	K21.9	Referred to specialist.
2825	3782	K21.9	Vitals stable. Continue current plan.
2826	3783	F41.1	Discussed lab results with patient.
2827	3784	F41.1	Discussed lab results with patient.
2828	3785	K21.9	Medication adjusted. Recheck in 6 weeks.
2829	3786	R51.9	Discussed lab results with patient.
2830	3787	E11.9	Medication adjusted. Recheck in 6 weeks.
2831	3788	I10	Discussed lab results with patient.
2832	3789	E78.5	Vitals stable. Continue current plan.
2833	3790	Z00.00	Preventive counseling provided.
2834	3791	Z00.00	Vitals stable. Continue current plan.
2835	3792	M54.5	Vitals stable. Continue current plan.
2836	3793	J45.909	Referred to specialist.
2837	3794	F41.1	Referred to specialist.
2838	3797	Z00.00	Vitals stable. Continue current plan.
2839	3798	L30.9	Discussed lab results with patient.
2840	3799	J45.909	Reviewed symptoms and history.
2841	3800	L30.9	Preventive counseling provided.
2842	3801	E78.5	Discussed lab results with patient.
2843	3802	E11.9	Referred to specialist.
2844	3803	E78.5	Vitals stable. Continue current plan.
2845	3804	E11.9	Preventive counseling provided.
2846	3805	I10	Vitals stable. Continue current plan.
2847	3806	E11.9	Medication adjusted. Recheck in 6 weeks.
2848	3807	E11.9	Preventive counseling provided.
2849	3810	K21.9	Discussed lab results with patient.
2850	3811	J06.9	Preventive counseling provided.
2851	3812	I10	Medication adjusted. Recheck in 6 weeks.
2852	3813	Z00.00	Preventive counseling provided.
2853	3814	K21.9	Reviewed symptoms and history.
2854	3815	L30.9	Referred to specialist.
2855	3816	K21.9	Referred to specialist.
2856	3818	E11.9	Discussed lab results with patient.
2857	3819	N39.0	Medication adjusted. Recheck in 6 weeks.
2858	3820	K21.9	Referred to specialist.
2859	3822	E11.9	Reviewed symptoms and history.
2860	3823	M54.5	Preventive counseling provided.
2861	3824	M54.5	Discussed lab results with patient.
2862	3825	M54.5	Discussed lab results with patient.
2863	3827	K21.9	Discussed lab results with patient.
2864	3829	E11.9	Reviewed symptoms and history.
2865	3830	R51.9	Reviewed symptoms and history.
2866	3831	J06.9	Discussed lab results with patient.
2867	3833	E78.5	Medication adjusted. Recheck in 6 weeks.
2868	3835	M54.5	Referred to specialist.
2869	3836	I10	Discussed lab results with patient.
2870	3837	N39.0	Discussed lab results with patient.
2871	3838	R51.9	Preventive counseling provided.
2872	3839	L30.9	Medication adjusted. Recheck in 6 weeks.
2873	3840	R51.9	Preventive counseling provided.
2874	3842	R51.9	Vitals stable. Continue current plan.
2875	3845	E11.9	Referred to specialist.
2876	3847	R51.9	Reviewed symptoms and history.
2877	3849	J45.909	Vitals stable. Continue current plan.
2878	3850	J06.9	Referred to specialist.
2879	3851	J45.909	Reviewed symptoms and history.
2880	3852	M54.5	Vitals stable. Continue current plan.
2881	3853	L30.9	Medication adjusted. Recheck in 6 weeks.
2882	3856	J06.9	Reviewed symptoms and history.
2883	3858	E78.5	Medication adjusted. Recheck in 6 weeks.
2884	3859	K21.9	Referred to specialist.
2885	3861	J06.9	Discussed lab results with patient.
2886	3862	F41.1	Reviewed symptoms and history.
2887	3864	E78.5	Reviewed symptoms and history.
2888	3865	N39.0	Medication adjusted. Recheck in 6 weeks.
2889	3866	E11.9	Referred to specialist.
2890	3867	J45.909	Vitals stable. Continue current plan.
2891	3868	I10	Reviewed symptoms and history.
2892	3869	J45.909	Preventive counseling provided.
2893	3870	M54.5	Reviewed symptoms and history.
2894	3872	E11.9	Vitals stable. Continue current plan.
2895	3873	J06.9	Vitals stable. Continue current plan.
2896	3874	J06.9	Preventive counseling provided.
2897	3875	N39.0	Referred to specialist.
2898	3877	F41.1	Vitals stable. Continue current plan.
2899	3879	E11.9	Preventive counseling provided.
2900	3880	M54.5	Vitals stable. Continue current plan.
2901	3881	L30.9	Referred to specialist.
2902	3884	M54.5	Preventive counseling provided.
2903	3885	R51.9	Discussed lab results with patient.
2904	3886	F41.1	Referred to specialist.
2905	3888	J45.909	Vitals stable. Continue current plan.
2906	3889	N39.0	Reviewed symptoms and history.
2907	3890	K21.9	Medication adjusted. Recheck in 6 weeks.
2908	3891	R51.9	Referred to specialist.
2909	3892	J45.909	Medication adjusted. Recheck in 6 weeks.
2910	3893	F41.1	Medication adjusted. Recheck in 6 weeks.
2911	3895	R51.9	Referred to specialist.
2912	3896	N39.0	Reviewed symptoms and history.
2913	3897	I10	Medication adjusted. Recheck in 6 weeks.
2914	3898	L30.9	Discussed lab results with patient.
2915	3899	L30.9	Referred to specialist.
2916	3900	J45.909	Referred to specialist.
2917	3903	E78.5	Vitals stable. Continue current plan.
2918	3904	R51.9	Referred to specialist.
2919	3905	F41.1	Referred to specialist.
2920	3906	M54.5	Reviewed symptoms and history.
2921	3908	M54.5	Vitals stable. Continue current plan.
2922	3909	J45.909	Referred to specialist.
2923	3910	I10	Discussed lab results with patient.
2924	3911	N39.0	Referred to specialist.
2925	3912	R51.9	Referred to specialist.
2926	3913	K21.9	Preventive counseling provided.
2927	3915	M54.5	Discussed lab results with patient.
2928	3916	I10	Preventive counseling provided.
2929	3917	F41.1	Reviewed symptoms and history.
2930	3918	E78.5	Vitals stable. Continue current plan.
2931	3919	E78.5	Medication adjusted. Recheck in 6 weeks.
2932	3923	I10	Referred to specialist.
2933	3924	J45.909	Reviewed symptoms and history.
2934	3925	N39.0	Discussed lab results with patient.
2935	3926	E78.5	Referred to specialist.
2936	3927	L30.9	Vitals stable. Continue current plan.
2937	3928	E11.9	Reviewed symptoms and history.
2938	3929	E78.5	Vitals stable. Continue current plan.
2939	3930	J45.909	Medication adjusted. Recheck in 6 weeks.
2940	3931	I10	Referred to specialist.
2941	3934	F41.1	Referred to specialist.
2942	3935	K21.9	Preventive counseling provided.
2943	3936	M54.5	Reviewed symptoms and history.
2944	3937	J45.909	Vitals stable. Continue current plan.
2945	3938	I10	Medication adjusted. Recheck in 6 weeks.
2946	3941	Z00.00	Reviewed symptoms and history.
2947	3942	E11.9	Preventive counseling provided.
2948	3943	L30.9	Preventive counseling provided.
2949	3944	L30.9	Medication adjusted. Recheck in 6 weeks.
2950	3945	M54.5	Reviewed symptoms and history.
2951	3946	E78.5	Medication adjusted. Recheck in 6 weeks.
2952	3948	I10	Discussed lab results with patient.
2953	3951	M54.5	Reviewed symptoms and history.
2954	3952	L30.9	Reviewed symptoms and history.
2955	3953	L30.9	Referred to specialist.
2956	3954	K21.9	Reviewed symptoms and history.
2957	3955	E11.9	Preventive counseling provided.
2958	3956	J45.909	Medication adjusted. Recheck in 6 weeks.
2959	3957	N39.0	Medication adjusted. Recheck in 6 weeks.
2960	3958	J45.909	Referred to specialist.
2961	3959	E11.9	Vitals stable. Continue current plan.
2962	3961	E11.9	Referred to specialist.
2963	3963	L30.9	Medication adjusted. Recheck in 6 weeks.
2964	3964	K21.9	Discussed lab results with patient.
2965	3965	F41.1	Medication adjusted. Recheck in 6 weeks.
2966	3967	F41.1	Reviewed symptoms and history.
2967	3968	L30.9	Preventive counseling provided.
2968	3970	E78.5	Preventive counseling provided.
2969	3971	J06.9	Preventive counseling provided.
2970	3972	E11.9	Medication adjusted. Recheck in 6 weeks.
2971	3973	J45.909	Reviewed symptoms and history.
2972	3974	F41.1	Medication adjusted. Recheck in 6 weeks.
2973	3975	J06.9	Vitals stable. Continue current plan.
2974	3977	K21.9	Preventive counseling provided.
2975	3980	L30.9	Vitals stable. Continue current plan.
2976	3981	J45.909	Discussed lab results with patient.
2977	3982	J06.9	Medication adjusted. Recheck in 6 weeks.
2978	3983	N39.0	Referred to specialist.
2979	3984	E11.9	Referred to specialist.
2980	3985	K21.9	Medication adjusted. Recheck in 6 weeks.
2981	3986	F41.1	Medication adjusted. Recheck in 6 weeks.
2982	3987	F41.1	Preventive counseling provided.
2983	3990	J45.909	Preventive counseling provided.
2984	3992	K21.9	Medication adjusted. Recheck in 6 weeks.
2985	3995	K21.9	Referred to specialist.
2986	3996	L30.9	Vitals stable. Continue current plan.
2987	3998	E11.9	Discussed lab results with patient.
2988	3999	F41.1	Preventive counseling provided.
2989	4000	J06.9	Reviewed symptoms and history.
2990	4002	J45.909	Reviewed symptoms and history.
2991	4003	J06.9	Referred to specialist.
2992	4005	J45.909	Medication adjusted. Recheck in 6 weeks.
2993	4006	L30.9	Vitals stable. Continue current plan.
2994	4008	L30.9	Referred to specialist.
2995	4013	K21.9	Medication adjusted. Recheck in 6 weeks.
2996	4015	E78.5	Preventive counseling provided.
2997	4016	R51.9	Discussed lab results with patient.
2998	4018	J06.9	Discussed lab results with patient.
2999	4020	L30.9	Referred to specialist.
3000	4021	E78.5	Referred to specialist.
3001	4023	J45.909	Vitals stable. Continue current plan.
3002	4025	E78.5	Referred to specialist.
3003	4026	K21.9	Medication adjusted. Recheck in 6 weeks.
3004	4027	L30.9	Referred to specialist.
3005	4028	E11.9	Discussed lab results with patient.
3006	4029	Z00.00	Reviewed symptoms and history.
3007	4030	E78.5	Discussed lab results with patient.
3008	4031	M54.5	Discussed lab results with patient.
3009	4032	I10	Discussed lab results with patient.
3010	4034	J06.9	Referred to specialist.
3011	4035	I10	Referred to specialist.
3012	4036	F41.1	Discussed lab results with patient.
3013	4037	I10	Vitals stable. Continue current plan.
3014	4038	Z00.00	Reviewed symptoms and history.
3015	4039	F41.1	Preventive counseling provided.
3016	4040	Z00.00	Referred to specialist.
3017	4041	L30.9	Vitals stable. Continue current plan.
3018	4042	F41.1	Reviewed symptoms and history.
3019	4044	L30.9	Preventive counseling provided.
3020	4046	R51.9	Vitals stable. Continue current plan.
3021	4047	E11.9	Vitals stable. Continue current plan.
3022	4050	J06.9	Discussed lab results with patient.
3023	4051	K21.9	Discussed lab results with patient.
3024	4054	E78.5	Preventive counseling provided.
3025	4055	I10	Reviewed symptoms and history.
3026	4056	J45.909	Vitals stable. Continue current plan.
3027	4058	K21.9	Preventive counseling provided.
3028	4059	Z00.00	Referred to specialist.
3029	4062	E11.9	Referred to specialist.
3030	4063	Z00.00	Reviewed symptoms and history.
3031	4064	J06.9	Reviewed symptoms and history.
3032	4067	F41.1	Preventive counseling provided.
3033	4068	E11.9	Preventive counseling provided.
3034	4069	E78.5	Referred to specialist.
3035	4070	Z00.00	Medication adjusted. Recheck in 6 weeks.
3036	4071	N39.0	Referred to specialist.
3037	4072	F41.1	Discussed lab results with patient.
3038	4073	J06.9	Reviewed symptoms and history.
3039	4076	Z00.00	Discussed lab results with patient.
3040	4077	N39.0	Preventive counseling provided.
3041	4078	K21.9	Reviewed symptoms and history.
3042	4079	E11.9	Vitals stable. Continue current plan.
3043	4081	F41.1	Reviewed symptoms and history.
3044	4082	L30.9	Discussed lab results with patient.
3045	4083	J45.909	Reviewed symptoms and history.
3046	4084	R51.9	Discussed lab results with patient.
3047	4085	K21.9	Discussed lab results with patient.
3048	4086	R51.9	Medication adjusted. Recheck in 6 weeks.
3049	4087	M54.5	Referred to specialist.
3050	4088	M54.5	Medication adjusted. Recheck in 6 weeks.
3051	4089	L30.9	Referred to specialist.
3052	4091	E11.9	Discussed lab results with patient.
3053	4092	Z00.00	Vitals stable. Continue current plan.
3054	4093	E78.5	Referred to specialist.
3055	4094	N39.0	Discussed lab results with patient.
3056	4095	K21.9	Referred to specialist.
3057	4096	K21.9	Vitals stable. Continue current plan.
3058	4098	J06.9	Referred to specialist.
3059	4100	I10	Referred to specialist.
3060	4101	Z00.00	Referred to specialist.
3061	4102	E78.5	Reviewed symptoms and history.
3062	4103	Z00.00	Preventive counseling provided.
3063	4104	R51.9	Preventive counseling provided.
3064	4105	R51.9	Referred to specialist.
3065	4108	J45.909	Discussed lab results with patient.
3066	4110	F41.1	Reviewed symptoms and history.
3067	4111	E11.9	Medication adjusted. Recheck in 6 weeks.
3068	4112	Z00.00	Referred to specialist.
3069	4114	K21.9	Preventive counseling provided.
3070	4115	Z00.00	Preventive counseling provided.
3071	4116	E11.9	Preventive counseling provided.
3072	4117	R51.9	Referred to specialist.
3073	4118	E11.9	Vitals stable. Continue current plan.
3074	4119	J06.9	Referred to specialist.
3075	4120	J45.909	Vitals stable. Continue current plan.
3076	4123	K21.9	Preventive counseling provided.
3077	4124	M54.5	Vitals stable. Continue current plan.
3078	4125	K21.9	Referred to specialist.
3079	4128	J06.9	Discussed lab results with patient.
3080	4129	R51.9	Reviewed symptoms and history.
3081	4130	I10	Referred to specialist.
3082	4131	E11.9	Referred to specialist.
3083	4133	Z00.00	Discussed lab results with patient.
3084	4135	J06.9	Referred to specialist.
3085	4137	F41.1	Vitals stable. Continue current plan.
3086	4138	N39.0	Medication adjusted. Recheck in 6 weeks.
3087	4140	Z00.00	Discussed lab results with patient.
3088	4141	E11.9	Discussed lab results with patient.
3089	4142	M54.5	Vitals stable. Continue current plan.
3090	4145	F41.1	Reviewed symptoms and history.
3091	4146	R51.9	Preventive counseling provided.
3092	4148	M54.5	Preventive counseling provided.
3093	4149	R51.9	Referred to specialist.
3094	4150	E11.9	Referred to specialist.
3095	4151	K21.9	Medication adjusted. Recheck in 6 weeks.
3096	4152	I10	Preventive counseling provided.
3097	4153	R51.9	Vitals stable. Continue current plan.
3098	4154	R51.9	Discussed lab results with patient.
3099	4156	L30.9	Discussed lab results with patient.
3100	4158	E11.9	Referred to specialist.
3101	4159	F41.1	Referred to specialist.
3102	4160	E78.5	Discussed lab results with patient.
3103	4161	F41.1	Referred to specialist.
3104	4162	M54.5	Reviewed symptoms and history.
3105	4163	E11.9	Reviewed symptoms and history.
3106	4164	R51.9	Preventive counseling provided.
3107	4165	J06.9	Vitals stable. Continue current plan.
3108	4166	R51.9	Referred to specialist.
3109	4167	E11.9	Discussed lab results with patient.
3110	4168	N39.0	Referred to specialist.
3111	4169	J06.9	Discussed lab results with patient.
3112	4170	L30.9	Reviewed symptoms and history.
3113	4171	J06.9	Referred to specialist.
3114	4172	E78.5	Preventive counseling provided.
3115	4173	I10	Referred to specialist.
3116	4174	N39.0	Referred to specialist.
3117	4175	E78.5	Discussed lab results with patient.
3118	4176	E11.9	Medication adjusted. Recheck in 6 weeks.
3119	4178	Z00.00	Reviewed symptoms and history.
3120	4179	F41.1	Medication adjusted. Recheck in 6 weeks.
3121	4180	L30.9	Vitals stable. Continue current plan.
3122	4181	I10	Preventive counseling provided.
3123	4182	E11.9	Discussed lab results with patient.
3124	4183	N39.0	Preventive counseling provided.
3125	4184	E11.9	Medication adjusted. Recheck in 6 weeks.
3126	4185	N39.0	Referred to specialist.
3127	4186	E11.9	Medication adjusted. Recheck in 6 weeks.
3128	4187	J45.909	Discussed lab results with patient.
3129	4188	L30.9	Discussed lab results with patient.
3130	4189	E11.9	Preventive counseling provided.
3131	4190	Z00.00	Medication adjusted. Recheck in 6 weeks.
3132	4191	M54.5	Vitals stable. Continue current plan.
3133	4192	Z00.00	Medication adjusted. Recheck in 6 weeks.
3134	4194	E11.9	Preventive counseling provided.
3135	4195	L30.9	Reviewed symptoms and history.
3136	4196	I10	Preventive counseling provided.
3137	4197	M54.5	Preventive counseling provided.
3138	4199	F41.1	Medication adjusted. Recheck in 6 weeks.
3139	4200	L30.9	Preventive counseling provided.
3140	4201	J06.9	Medication adjusted. Recheck in 6 weeks.
3141	4202	J45.909	Preventive counseling provided.
3142	4203	R51.9	Medication adjusted. Recheck in 6 weeks.
3143	4204	J06.9	Reviewed symptoms and history.
3144	4205	F41.1	Discussed lab results with patient.
3145	4207	R51.9	Reviewed symptoms and history.
3146	4208	E11.9	Reviewed symptoms and history.
3147	4209	L30.9	Referred to specialist.
3148	4211	I10	Reviewed symptoms and history.
3149	4214	E78.5	Reviewed symptoms and history.
3150	4215	R51.9	Referred to specialist.
3151	4216	L30.9	Reviewed symptoms and history.
3152	4217	J06.9	Discussed lab results with patient.
3153	4218	J45.909	Referred to specialist.
3154	4219	J06.9	Referred to specialist.
3155	4220	N39.0	Reviewed symptoms and history.
3156	4221	M54.5	Medication adjusted. Recheck in 6 weeks.
3157	4224	E78.5	Referred to specialist.
3158	4225	L30.9	Medication adjusted. Recheck in 6 weeks.
3159	4226	I10	Medication adjusted. Recheck in 6 weeks.
3160	4227	N39.0	Reviewed symptoms and history.
3161	4228	L30.9	Reviewed symptoms and history.
3162	4229	J06.9	Reviewed symptoms and history.
3163	4230	N39.0	Referred to specialist.
3164	4231	F41.1	Preventive counseling provided.
3165	4232	R51.9	Reviewed symptoms and history.
3166	4233	I10	Preventive counseling provided.
3167	4236	L30.9	Vitals stable. Continue current plan.
3168	4238	K21.9	Referred to specialist.
3169	4243	J45.909	Reviewed symptoms and history.
3170	4245	J06.9	Reviewed symptoms and history.
3171	4246	L30.9	Preventive counseling provided.
3172	4247	R51.9	Referred to specialist.
3173	4248	Z00.00	Discussed lab results with patient.
3174	4249	J06.9	Discussed lab results with patient.
3175	4251	Z00.00	Medication adjusted. Recheck in 6 weeks.
3176	4252	L30.9	Referred to specialist.
3177	4253	J06.9	Vitals stable. Continue current plan.
3178	4254	Z00.00	Vitals stable. Continue current plan.
3179	4255	M54.5	Vitals stable. Continue current plan.
3180	4257	F41.1	Discussed lab results with patient.
3181	4259	J06.9	Preventive counseling provided.
3182	4260	Z00.00	Reviewed symptoms and history.
3183	4261	J06.9	Referred to specialist.
3184	4262	N39.0	Preventive counseling provided.
3185	4263	E78.5	Reviewed symptoms and history.
3186	4264	J45.909	Reviewed symptoms and history.
3187	4265	J06.9	Reviewed symptoms and history.
3188	4266	F41.1	Discussed lab results with patient.
3189	4267	J06.9	Discussed lab results with patient.
3190	4268	J06.9	Referred to specialist.
3191	4272	J06.9	Referred to specialist.
3192	4273	K21.9	Discussed lab results with patient.
3193	4274	R51.9	Medication adjusted. Recheck in 6 weeks.
3194	4275	L30.9	Reviewed symptoms and history.
3195	4276	L30.9	Discussed lab results with patient.
3196	4277	I10	Medication adjusted. Recheck in 6 weeks.
3197	4278	Z00.00	Medication adjusted. Recheck in 6 weeks.
3198	4279	M54.5	Referred to specialist.
3199	4281	I10	Vitals stable. Continue current plan.
3200	4282	E78.5	Referred to specialist.
3201	4283	K21.9	Preventive counseling provided.
3202	4284	Z00.00	Medication adjusted. Recheck in 6 weeks.
3203	4285	K21.9	Discussed lab results with patient.
3204	4286	E11.9	Reviewed symptoms and history.
3205	4287	N39.0	Medication adjusted. Recheck in 6 weeks.
3206	4288	Z00.00	Vitals stable. Continue current plan.
3207	4289	L30.9	Medication adjusted. Recheck in 6 weeks.
3208	4291	N39.0	Medication adjusted. Recheck in 6 weeks.
3209	4292	Z00.00	Reviewed symptoms and history.
3210	4293	N39.0	Referred to specialist.
3211	4294	I10	Reviewed symptoms and history.
3212	4295	J06.9	Preventive counseling provided.
3213	4297	Z00.00	Vitals stable. Continue current plan.
3214	4298	F41.1	Preventive counseling provided.
3215	4302	F41.1	Medication adjusted. Recheck in 6 weeks.
3216	4304	L30.9	Vitals stable. Continue current plan.
3217	4305	R51.9	Referred to specialist.
3218	4308	L30.9	Referred to specialist.
3219	4309	E78.5	Preventive counseling provided.
3220	4310	L30.9	Referred to specialist.
3221	4312	L30.9	Discussed lab results with patient.
3222	4313	Z00.00	Preventive counseling provided.
3223	4315	L30.9	Reviewed symptoms and history.
3224	4316	L30.9	Discussed lab results with patient.
3225	4317	J06.9	Medication adjusted. Recheck in 6 weeks.
3226	4318	E78.5	Reviewed symptoms and history.
3227	4319	E78.5	Medication adjusted. Recheck in 6 weeks.
3228	4320	J06.9	Preventive counseling provided.
3229	4321	N39.0	Vitals stable. Continue current plan.
3230	4322	I10	Vitals stable. Continue current plan.
3231	4323	F41.1	Reviewed symptoms and history.
3232	4324	J45.909	Preventive counseling provided.
3233	4326	E78.5	Referred to specialist.
3234	4327	N39.0	Vitals stable. Continue current plan.
3235	4329	Z00.00	Referred to specialist.
3236	4331	J45.909	Medication adjusted. Recheck in 6 weeks.
3237	4332	E78.5	Referred to specialist.
3238	4334	K21.9	Medication adjusted. Recheck in 6 weeks.
3239	4336	J45.909	Referred to specialist.
3240	4337	F41.1	Vitals stable. Continue current plan.
3241	4338	J45.909	Discussed lab results with patient.
3242	4340	E11.9	Preventive counseling provided.
3243	4341	Z00.00	Reviewed symptoms and history.
3244	4342	M54.5	Reviewed symptoms and history.
3245	4343	K21.9	Referred to specialist.
3246	4344	F41.1	Vitals stable. Continue current plan.
3247	4345	J06.9	Vitals stable. Continue current plan.
3248	4346	N39.0	Preventive counseling provided.
3249	4347	E78.5	Referred to specialist.
3250	4348	J06.9	Medication adjusted. Recheck in 6 weeks.
3251	4349	J45.909	Medication adjusted. Recheck in 6 weeks.
3252	4350	R51.9	Preventive counseling provided.
3253	4352	R51.9	Preventive counseling provided.
3254	4353	L30.9	Vitals stable. Continue current plan.
3255	4354	R51.9	Referred to specialist.
3256	4355	I10	Discussed lab results with patient.
3257	4356	M54.5	Vitals stable. Continue current plan.
3258	4357	N39.0	Preventive counseling provided.
3259	4358	E78.5	Reviewed symptoms and history.
3260	4359	J45.909	Referred to specialist.
3261	4360	J45.909	Reviewed symptoms and history.
3262	4362	E11.9	Referred to specialist.
3263	4364	J45.909	Referred to specialist.
3264	4366	E78.5	Reviewed symptoms and history.
3265	4368	J45.909	Preventive counseling provided.
3266	4369	K21.9	Medication adjusted. Recheck in 6 weeks.
3267	4370	M54.5	Medication adjusted. Recheck in 6 weeks.
3268	4372	E78.5	Preventive counseling provided.
3269	4373	N39.0	Medication adjusted. Recheck in 6 weeks.
3270	4375	J06.9	Referred to specialist.
3271	4376	F41.1	Medication adjusted. Recheck in 6 weeks.
3272	4378	J06.9	Referred to specialist.
3273	4379	R51.9	Discussed lab results with patient.
3274	4380	L30.9	Discussed lab results with patient.
3275	4381	E11.9	Discussed lab results with patient.
3276	4382	J06.9	Discussed lab results with patient.
3277	4384	J45.909	Preventive counseling provided.
3278	4385	J06.9	Reviewed symptoms and history.
3279	4386	J06.9	Discussed lab results with patient.
3280	4387	N39.0	Reviewed symptoms and history.
3281	4390	J45.909	Vitals stable. Continue current plan.
3282	4391	J06.9	Medication adjusted. Recheck in 6 weeks.
3283	4395	J45.909	Medication adjusted. Recheck in 6 weeks.
3284	4396	Z00.00	Referred to specialist.
3285	4399	K21.9	Discussed lab results with patient.
3286	4400	F41.1	Preventive counseling provided.
3287	4402	L30.9	Reviewed symptoms and history.
3288	4403	L30.9	Discussed lab results with patient.
3289	4404	R51.9	Preventive counseling provided.
3290	4405	R51.9	Vitals stable. Continue current plan.
3291	4406	R51.9	Vitals stable. Continue current plan.
3292	4407	M54.5	Medication adjusted. Recheck in 6 weeks.
3293	4409	M54.5	Discussed lab results with patient.
3294	4412	J45.909	Referred to specialist.
3295	4413	K21.9	Referred to specialist.
3296	4414	M54.5	Preventive counseling provided.
3297	4415	N39.0	Preventive counseling provided.
3298	4416	F41.1	Medication adjusted. Recheck in 6 weeks.
3299	4417	E11.9	Discussed lab results with patient.
3300	4418	F41.1	Vitals stable. Continue current plan.
3301	4419	N39.0	Discussed lab results with patient.
3302	4420	K21.9	Vitals stable. Continue current plan.
3303	4422	J45.909	Referred to specialist.
3304	4424	I10	Reviewed symptoms and history.
3305	4425	L30.9	Reviewed symptoms and history.
3306	4426	M54.5	Discussed lab results with patient.
3307	4432	R51.9	Preventive counseling provided.
3308	4433	I10	Discussed lab results with patient.
3309	4434	E11.9	Medication adjusted. Recheck in 6 weeks.
3310	4435	N39.0	Vitals stable. Continue current plan.
3311	4436	E78.5	Medication adjusted. Recheck in 6 weeks.
3312	4437	N39.0	Preventive counseling provided.
3313	4438	J06.9	Discussed lab results with patient.
3314	4439	Z00.00	Referred to specialist.
3315	4441	E78.5	Referred to specialist.
3316	4442	E78.5	Preventive counseling provided.
3317	4443	J45.909	Referred to specialist.
3318	4449	K21.9	Discussed lab results with patient.
3319	4450	F41.1	Medication adjusted. Recheck in 6 weeks.
3320	4451	E11.9	Reviewed symptoms and history.
3321	4452	K21.9	Medication adjusted. Recheck in 6 weeks.
3322	4453	J45.909	Referred to specialist.
3323	4454	E78.5	Reviewed symptoms and history.
3324	4455	E78.5	Vitals stable. Continue current plan.
3325	4456	Z00.00	Discussed lab results with patient.
3326	4457	F41.1	Preventive counseling provided.
3327	4459	L30.9	Reviewed symptoms and history.
3328	4460	N39.0	Vitals stable. Continue current plan.
3329	4461	R51.9	Discussed lab results with patient.
3330	4462	R51.9	Reviewed symptoms and history.
3331	4463	I10	Vitals stable. Continue current plan.
3332	4464	J45.909	Discussed lab results with patient.
3333	4465	R51.9	Discussed lab results with patient.
3334	4466	Z00.00	Discussed lab results with patient.
3335	4467	Z00.00	Preventive counseling provided.
3336	4468	R51.9	Reviewed symptoms and history.
3337	4469	M54.5	Reviewed symptoms and history.
3338	4470	K21.9	Referred to specialist.
3339	4471	J45.909	Reviewed symptoms and history.
3340	4473	R51.9	Reviewed symptoms and history.
3341	4474	K21.9	Referred to specialist.
3342	4475	N39.0	Referred to specialist.
3343	4476	N39.0	Reviewed symptoms and history.
3344	4477	E78.5	Referred to specialist.
3345	4479	J45.909	Medication adjusted. Recheck in 6 weeks.
3346	4480	L30.9	Vitals stable. Continue current plan.
3347	4482	E78.5	Referred to specialist.
3348	4484	E11.9	Reviewed symptoms and history.
3349	4485	E11.9	Medication adjusted. Recheck in 6 weeks.
3350	4486	M54.5	Vitals stable. Continue current plan.
3351	4488	K21.9	Medication adjusted. Recheck in 6 weeks.
3352	4489	E11.9	Vitals stable. Continue current plan.
3353	4490	M54.5	Medication adjusted. Recheck in 6 weeks.
3354	4492	J45.909	Vitals stable. Continue current plan.
3355	4493	J06.9	Preventive counseling provided.
3356	4494	L30.9	Discussed lab results with patient.
3357	4497	E78.5	Referred to specialist.
3358	4498	M54.5	Referred to specialist.
3359	4502	I10	Reviewed symptoms and history.
3360	4503	K21.9	Vitals stable. Continue current plan.
3361	4504	K21.9	Vitals stable. Continue current plan.
3362	4505	J06.9	Vitals stable. Continue current plan.
3363	4506	E78.5	Preventive counseling provided.
3364	4507	M54.5	Referred to specialist.
3365	4508	I10	Discussed lab results with patient.
3366	4510	E11.9	Referred to specialist.
3367	4511	J45.909	Reviewed symptoms and history.
3368	4512	R51.9	Referred to specialist.
3369	4514	Z00.00	Vitals stable. Continue current plan.
3370	4515	F41.1	Medication adjusted. Recheck in 6 weeks.
3371	4517	J45.909	Referred to specialist.
3372	4518	K21.9	Preventive counseling provided.
3373	4519	Z00.00	Referred to specialist.
3374	4520	J45.909	Vitals stable. Continue current plan.
3375	4521	J45.909	Medication adjusted. Recheck in 6 weeks.
3376	4522	J06.9	Medication adjusted. Recheck in 6 weeks.
3377	4523	L30.9	Vitals stable. Continue current plan.
3378	4524	M54.5	Vitals stable. Continue current plan.
3379	4525	I10	Vitals stable. Continue current plan.
3380	4526	F41.1	Medication adjusted. Recheck in 6 weeks.
3381	4527	K21.9	Preventive counseling provided.
3382	4528	K21.9	Reviewed symptoms and history.
3383	4529	L30.9	Preventive counseling provided.
3384	4530	F41.1	Vitals stable. Continue current plan.
3385	4531	J45.909	Medication adjusted. Recheck in 6 weeks.
3386	4532	J06.9	Medication adjusted. Recheck in 6 weeks.
3387	4535	R51.9	Referred to specialist.
3388	4536	J45.909	Referred to specialist.
3389	4540	M54.5	Vitals stable. Continue current plan.
3390	4541	M54.5	Referred to specialist.
3391	4543	L30.9	Reviewed symptoms and history.
3392	4544	J06.9	Preventive counseling provided.
3393	4545	I10	Referred to specialist.
3394	4547	I10	Vitals stable. Continue current plan.
3395	4548	J06.9	Vitals stable. Continue current plan.
3396	4550	R51.9	Discussed lab results with patient.
3397	4552	E78.5	Referred to specialist.
3398	4553	M54.5	Vitals stable. Continue current plan.
3399	4554	R51.9	Discussed lab results with patient.
3400	4555	M54.5	Referred to specialist.
3401	4557	Z00.00	Medication adjusted. Recheck in 6 weeks.
3402	4561	F41.1	Medication adjusted. Recheck in 6 weeks.
3403	4562	E78.5	Medication adjusted. Recheck in 6 weeks.
3404	4564	K21.9	Referred to specialist.
3405	4565	L30.9	Preventive counseling provided.
3406	4566	E11.9	Discussed lab results with patient.
3407	4567	E78.5	Discussed lab results with patient.
3408	4569	L30.9	Reviewed symptoms and history.
3409	4570	J45.909	Reviewed symptoms and history.
3410	4571	Z00.00	Reviewed symptoms and history.
3411	4574	N39.0	Reviewed symptoms and history.
3412	4575	J06.9	Reviewed symptoms and history.
3413	4576	E11.9	Preventive counseling provided.
3414	4577	M54.5	Preventive counseling provided.
3415	4578	J45.909	Reviewed symptoms and history.
3416	4579	M54.5	Reviewed symptoms and history.
3417	4580	J06.9	Vitals stable. Continue current plan.
3418	4581	N39.0	Medication adjusted. Recheck in 6 weeks.
3419	4582	J45.909	Medication adjusted. Recheck in 6 weeks.
3420	4584	R51.9	Reviewed symptoms and history.
3421	4585	N39.0	Vitals stable. Continue current plan.
3422	4586	K21.9	Preventive counseling provided.
3423	4589	K21.9	Referred to specialist.
3424	4590	M54.5	Vitals stable. Continue current plan.
3425	4592	J45.909	Preventive counseling provided.
3426	4593	M54.5	Discussed lab results with patient.
3427	4594	F41.1	Preventive counseling provided.
3428	4595	R51.9	Vitals stable. Continue current plan.
3429	4596	K21.9	Discussed lab results with patient.
3430	4598	Z00.00	Discussed lab results with patient.
3431	4599	J45.909	Preventive counseling provided.
3432	4600	J45.909	Preventive counseling provided.
3433	4601	F41.1	Preventive counseling provided.
3434	4602	E11.9	Referred to specialist.
3435	4603	N39.0	Discussed lab results with patient.
3436	4604	F41.1	Reviewed symptoms and history.
3437	4605	I10	Preventive counseling provided.
3438	4606	L30.9	Preventive counseling provided.
3439	4608	L30.9	Discussed lab results with patient.
3440	4609	J06.9	Referred to specialist.
3441	4612	M54.5	Reviewed symptoms and history.
3442	4613	F41.1	Vitals stable. Continue current plan.
3443	4615	Z00.00	Discussed lab results with patient.
3444	4616	F41.1	Discussed lab results with patient.
3445	4617	M54.5	Referred to specialist.
3446	4618	E11.9	Medication adjusted. Recheck in 6 weeks.
3447	4619	Z00.00	Preventive counseling provided.
3448	4621	R51.9	Discussed lab results with patient.
3449	4622	L30.9	Vitals stable. Continue current plan.
3450	4624	J06.9	Preventive counseling provided.
3451	4625	J06.9	Preventive counseling provided.
3452	4626	Z00.00	Preventive counseling provided.
3453	4627	F41.1	Medication adjusted. Recheck in 6 weeks.
3454	4629	F41.1	Reviewed symptoms and history.
3455	4630	R51.9	Discussed lab results with patient.
3456	4636	R51.9	Medication adjusted. Recheck in 6 weeks.
3457	4637	N39.0	Preventive counseling provided.
3458	4638	J45.909	Medication adjusted. Recheck in 6 weeks.
3459	4639	R51.9	Discussed lab results with patient.
3460	4641	E78.5	Referred to specialist.
3461	4642	N39.0	Referred to specialist.
3462	4643	J06.9	Reviewed symptoms and history.
3463	4644	N39.0	Reviewed symptoms and history.
3464	4645	K21.9	Discussed lab results with patient.
3465	4646	J45.909	Vitals stable. Continue current plan.
3466	4647	L30.9	Discussed lab results with patient.
3467	4648	N39.0	Discussed lab results with patient.
3468	4649	L30.9	Vitals stable. Continue current plan.
3469	4650	J45.909	Referred to specialist.
3470	4651	J45.909	Medication adjusted. Recheck in 6 weeks.
3471	4652	Z00.00	Vitals stable. Continue current plan.
3472	4653	F41.1	Preventive counseling provided.
3473	4655	L30.9	Referred to specialist.
3474	4659	F41.1	Medication adjusted. Recheck in 6 weeks.
3475	4660	M54.5	Preventive counseling provided.
3476	4661	J45.909	Referred to specialist.
3477	4662	L30.9	Referred to specialist.
3478	4663	F41.1	Discussed lab results with patient.
3479	4664	M54.5	Referred to specialist.
3480	4665	I10	Referred to specialist.
3481	4667	N39.0	Reviewed symptoms and history.
3482	4668	N39.0	Discussed lab results with patient.
3483	4670	J06.9	Referred to specialist.
3484	4671	I10	Discussed lab results with patient.
3485	4672	K21.9	Vitals stable. Continue current plan.
3486	4674	N39.0	Referred to specialist.
3487	4676	E11.9	Referred to specialist.
3488	4677	J06.9	Vitals stable. Continue current plan.
3489	4679	I10	Medication adjusted. Recheck in 6 weeks.
3490	4681	E11.9	Preventive counseling provided.
3491	4684	F41.1	Discussed lab results with patient.
3492	4685	R51.9	Vitals stable. Continue current plan.
3493	4687	L30.9	Medication adjusted. Recheck in 6 weeks.
3494	4689	F41.1	Discussed lab results with patient.
3495	4690	F41.1	Medication adjusted. Recheck in 6 weeks.
3496	4695	N39.0	Vitals stable. Continue current plan.
3497	4696	L30.9	Discussed lab results with patient.
3498	4698	E78.5	Referred to specialist.
3499	4699	I10	Reviewed symptoms and history.
3500	4700	K21.9	Referred to specialist.
3501	4701	N39.0	Reviewed symptoms and history.
3502	4702	I10	Discussed lab results with patient.
3503	4703	Z00.00	Referred to specialist.
3504	4705	J45.909	Preventive counseling provided.
3505	4706	E78.5	Preventive counseling provided.
3506	4707	Z00.00	Vitals stable. Continue current plan.
3507	4708	L30.9	Referred to specialist.
3508	4709	I10	Vitals stable. Continue current plan.
3509	4713	L30.9	Reviewed symptoms and history.
3510	4714	E78.5	Reviewed symptoms and history.
3511	4715	Z00.00	Preventive counseling provided.
3512	4716	E78.5	Vitals stable. Continue current plan.
3513	4717	E78.5	Preventive counseling provided.
3514	4718	E11.9	Vitals stable. Continue current plan.
3515	4719	J06.9	Medication adjusted. Recheck in 6 weeks.
3516	4721	E78.5	Preventive counseling provided.
3517	4722	M54.5	Vitals stable. Continue current plan.
3518	4723	Z00.00	Reviewed symptoms and history.
3519	4724	J45.909	Medication adjusted. Recheck in 6 weeks.
3520	4725	K21.9	Vitals stable. Continue current plan.
3521	4726	F41.1	Reviewed symptoms and history.
3522	4727	N39.0	Reviewed symptoms and history.
3523	4728	M54.5	Vitals stable. Continue current plan.
3524	4729	R51.9	Referred to specialist.
3525	4730	J06.9	Referred to specialist.
3526	4732	L30.9	Reviewed symptoms and history.
3527	4734	I10	Discussed lab results with patient.
3528	4735	E11.9	Medication adjusted. Recheck in 6 weeks.
3529	4737	Z00.00	Referred to specialist.
3530	4738	M54.5	Reviewed symptoms and history.
3531	4739	R51.9	Referred to specialist.
3532	4740	E78.5	Reviewed symptoms and history.
3533	4741	K21.9	Reviewed symptoms and history.
3534	4742	F41.1	Vitals stable. Continue current plan.
3535	4743	J45.909	Vitals stable. Continue current plan.
3536	4744	K21.9	Discussed lab results with patient.
3537	4745	K21.9	Referred to specialist.
3538	4746	J45.909	Vitals stable. Continue current plan.
3539	4747	N39.0	Reviewed symptoms and history.
3540	4748	M54.5	Vitals stable. Continue current plan.
3541	4749	M54.5	Preventive counseling provided.
3542	4750	J45.909	Medication adjusted. Recheck in 6 weeks.
3543	4752	F41.1	Reviewed symptoms and history.
3544	4753	Z00.00	Medication adjusted. Recheck in 6 weeks.
3545	4755	J45.909	Preventive counseling provided.
3546	4756	Z00.00	Reviewed symptoms and history.
3547	4758	L30.9	Vitals stable. Continue current plan.
3548	4759	L30.9	Vitals stable. Continue current plan.
3549	4760	L30.9	Referred to specialist.
3550	4762	R51.9	Discussed lab results with patient.
3551	4763	K21.9	Preventive counseling provided.
3552	4765	L30.9	Referred to specialist.
3553	4768	M54.5	Vitals stable. Continue current plan.
3554	4769	I10	Preventive counseling provided.
3555	4770	L30.9	Medication adjusted. Recheck in 6 weeks.
3556	4771	E78.5	Medication adjusted. Recheck in 6 weeks.
3557	4772	I10	Preventive counseling provided.
3558	4773	J06.9	Vitals stable. Continue current plan.
3559	4774	Z00.00	Medication adjusted. Recheck in 6 weeks.
3560	4775	E78.5	Discussed lab results with patient.
3561	4776	E78.5	Referred to specialist.
3562	4777	E78.5	Preventive counseling provided.
3563	4778	R51.9	Referred to specialist.
3564	4780	J06.9	Referred to specialist.
3565	4781	N39.0	Medication adjusted. Recheck in 6 weeks.
3566	4782	R51.9	Vitals stable. Continue current plan.
3567	4783	N39.0	Referred to specialist.
3568	4784	J06.9	Vitals stable. Continue current plan.
3569	4786	Z00.00	Discussed lab results with patient.
3570	4787	L30.9	Discussed lab results with patient.
3571	4788	Z00.00	Referred to specialist.
3572	4789	E11.9	Discussed lab results with patient.
3573	4790	J45.909	Preventive counseling provided.
3574	4791	N39.0	Referred to specialist.
3575	4793	I10	Referred to specialist.
3576	4794	R51.9	Reviewed symptoms and history.
3577	4795	F41.1	Discussed lab results with patient.
3578	4796	J45.909	Medication adjusted. Recheck in 6 weeks.
3579	4798	J45.909	Reviewed symptoms and history.
3580	4799	E78.5	Discussed lab results with patient.
3581	4800	L30.9	Vitals stable. Continue current plan.
3582	4804	J45.909	Referred to specialist.
3583	4807	R51.9	Vitals stable. Continue current plan.
3584	4808	L30.9	Preventive counseling provided.
3585	4809	E11.9	Preventive counseling provided.
3586	4810	J06.9	Discussed lab results with patient.
3587	4811	E78.5	Discussed lab results with patient.
3588	4812	I10	Preventive counseling provided.
3589	4813	E11.9	Vitals stable. Continue current plan.
3590	4816	I10	Medication adjusted. Recheck in 6 weeks.
3591	4817	N39.0	Discussed lab results with patient.
3592	4818	R51.9	Vitals stable. Continue current plan.
3593	4819	N39.0	Preventive counseling provided.
3594	4820	L30.9	Reviewed symptoms and history.
3595	4821	F41.1	Referred to specialist.
3596	4824	F41.1	Vitals stable. Continue current plan.
3597	4825	L30.9	Discussed lab results with patient.
3598	4827	F41.1	Preventive counseling provided.
3599	4829	R51.9	Reviewed symptoms and history.
3600	4830	Z00.00	Reviewed symptoms and history.
3601	4832	F41.1	Vitals stable. Continue current plan.
3602	4833	K21.9	Vitals stable. Continue current plan.
3603	4834	N39.0	Preventive counseling provided.
3604	4835	L30.9	Preventive counseling provided.
3605	4836	R51.9	Medication adjusted. Recheck in 6 weeks.
3606	4837	K21.9	Referred to specialist.
3607	4838	R51.9	Preventive counseling provided.
3608	4839	L30.9	Reviewed symptoms and history.
3609	4840	I10	Vitals stable. Continue current plan.
3610	4841	R51.9	Preventive counseling provided.
3611	4843	E78.5	Preventive counseling provided.
3612	4845	R51.9	Reviewed symptoms and history.
3613	4846	J45.909	Vitals stable. Continue current plan.
3614	4847	E11.9	Preventive counseling provided.
3615	4848	L30.9	Preventive counseling provided.
3616	4849	N39.0	Preventive counseling provided.
3617	4850	R51.9	Referred to specialist.
3618	4851	E78.5	Preventive counseling provided.
3619	4852	E78.5	Discussed lab results with patient.
3620	4853	K21.9	Preventive counseling provided.
3621	4855	J45.909	Medication adjusted. Recheck in 6 weeks.
3622	4856	R51.9	Vitals stable. Continue current plan.
3623	4857	J45.909	Referred to specialist.
3624	4858	N39.0	Preventive counseling provided.
3625	4860	L30.9	Vitals stable. Continue current plan.
3626	4861	N39.0	Vitals stable. Continue current plan.
3627	4862	Z00.00	Reviewed symptoms and history.
3628	4863	N39.0	Vitals stable. Continue current plan.
3629	4864	E78.5	Vitals stable. Continue current plan.
3630	4866	Z00.00	Referred to specialist.
3631	4867	E11.9	Reviewed symptoms and history.
3632	4869	I10	Reviewed symptoms and history.
3633	4871	J06.9	Medication adjusted. Recheck in 6 weeks.
3634	4872	R51.9	Preventive counseling provided.
3635	4874	N39.0	Vitals stable. Continue current plan.
3636	4876	N39.0	Discussed lab results with patient.
3637	4877	R51.9	Medication adjusted. Recheck in 6 weeks.
3638	4879	J45.909	Discussed lab results with patient.
3639	4880	N39.0	Medication adjusted. Recheck in 6 weeks.
3640	4881	E78.5	Referred to specialist.
3641	4882	K21.9	Medication adjusted. Recheck in 6 weeks.
3642	4883	F41.1	Medication adjusted. Recheck in 6 weeks.
3643	4884	E78.5	Vitals stable. Continue current plan.
3644	4886	N39.0	Discussed lab results with patient.
3645	4888	L30.9	Reviewed symptoms and history.
3646	4890	F41.1	Reviewed symptoms and history.
3647	4891	E78.5	Referred to specialist.
3648	4892	Z00.00	Reviewed symptoms and history.
3649	4894	R51.9	Vitals stable. Continue current plan.
3650	4895	E78.5	Reviewed symptoms and history.
3651	4897	M54.5	Discussed lab results with patient.
3652	4899	I10	Discussed lab results with patient.
3653	4901	K21.9	Medication adjusted. Recheck in 6 weeks.
3654	4902	I10	Medication adjusted. Recheck in 6 weeks.
3655	4903	E78.5	Medication adjusted. Recheck in 6 weeks.
3656	4904	E78.5	Discussed lab results with patient.
3657	4905	E11.9	Medication adjusted. Recheck in 6 weeks.
3658	4907	E11.9	Discussed lab results with patient.
3659	4910	M54.5	Discussed lab results with patient.
3660	4911	K21.9	Medication adjusted. Recheck in 6 weeks.
3661	4912	M54.5	Medication adjusted. Recheck in 6 weeks.
3662	4913	R51.9	Medication adjusted. Recheck in 6 weeks.
3663	4914	N39.0	Vitals stable. Continue current plan.
3664	4915	E78.5	Referred to specialist.
3665	4916	I10	Reviewed symptoms and history.
3666	4918	N39.0	Preventive counseling provided.
3667	4919	F41.1	Discussed lab results with patient.
3668	4921	F41.1	Preventive counseling provided.
3669	4922	E11.9	Vitals stable. Continue current plan.
3670	4923	M54.5	Discussed lab results with patient.
3671	4924	R51.9	Referred to specialist.
3672	4925	M54.5	Preventive counseling provided.
3673	4926	F41.1	Medication adjusted. Recheck in 6 weeks.
3674	4927	R51.9	Referred to specialist.
3675	4928	Z00.00	Discussed lab results with patient.
3676	4929	Z00.00	Preventive counseling provided.
3677	4930	L30.9	Reviewed symptoms and history.
3678	4931	E11.9	Medication adjusted. Recheck in 6 weeks.
3679	4932	L30.9	Vitals stable. Continue current plan.
3680	4933	E11.9	Preventive counseling provided.
3681	4935	Z00.00	Referred to specialist.
3682	4936	E11.9	Referred to specialist.
3683	4937	J45.909	Vitals stable. Continue current plan.
3684	4938	E78.5	Vitals stable. Continue current plan.
3685	4939	F41.1	Medication adjusted. Recheck in 6 weeks.
3686	4940	R51.9	Reviewed symptoms and history.
3687	4941	K21.9	Reviewed symptoms and history.
3688	4942	E11.9	Referred to specialist.
3689	4943	K21.9	Medication adjusted. Recheck in 6 weeks.
3690	4944	F41.1	Medication adjusted. Recheck in 6 weeks.
3691	4945	M54.5	Discussed lab results with patient.
3692	4948	I10	Discussed lab results with patient.
3693	4951	E11.9	Discussed lab results with patient.
3694	4953	J06.9	Discussed lab results with patient.
3695	4954	M54.5	Referred to specialist.
3696	4955	I10	Medication adjusted. Recheck in 6 weeks.
3697	4956	E11.9	Reviewed symptoms and history.
3698	4957	J45.909	Medication adjusted. Recheck in 6 weeks.
3699	4958	E11.9	Preventive counseling provided.
3700	4959	F41.1	Medication adjusted. Recheck in 6 weeks.
3701	4961	L30.9	Medication adjusted. Recheck in 6 weeks.
3702	4962	E11.9	Referred to specialist.
3703	4963	J06.9	Medication adjusted. Recheck in 6 weeks.
3704	4965	L30.9	Preventive counseling provided.
3705	4966	Z00.00	Vitals stable. Continue current plan.
3706	4967	F41.1	Reviewed symptoms and history.
3707	4968	R51.9	Vitals stable. Continue current plan.
3708	4969	J45.909	Discussed lab results with patient.
3709	4970	N39.0	Vitals stable. Continue current plan.
3710	4971	N39.0	Discussed lab results with patient.
3711	4972	F41.1	Medication adjusted. Recheck in 6 weeks.
3712	4975	F41.1	Vitals stable. Continue current plan.
3713	4977	R51.9	Discussed lab results with patient.
3714	4978	K21.9	Vitals stable. Continue current plan.
3715	4979	J45.909	Reviewed symptoms and history.
3716	4980	J06.9	Medication adjusted. Recheck in 6 weeks.
3717	4982	F41.1	Vitals stable. Continue current plan.
3718	4984	K21.9	Referred to specialist.
3719	4985	K21.9	Discussed lab results with patient.
3720	4987	I10	Vitals stable. Continue current plan.
3721	4988	J06.9	Referred to specialist.
3722	4989	L30.9	Preventive counseling provided.
3723	4990	J45.909	Reviewed symptoms and history.
3724	4991	E78.5	Referred to specialist.
3725	4992	Z00.00	Medication adjusted. Recheck in 6 weeks.
3726	4994	I10	Reviewed symptoms and history.
3727	4995	L30.9	Referred to specialist.
3728	4996	K21.9	Vitals stable. Continue current plan.
3729	4997	Z00.00	Medication adjusted. Recheck in 6 weeks.
3730	4998	F41.1	Medication adjusted. Recheck in 6 weeks.
3731	4999	E78.5	Preventive counseling provided.
3732	5000	E11.9	Discussed lab results with patient.
3733	5001	F41.1	Preventive counseling provided.
3734	5002	I10	Reviewed symptoms and history.
3735	5003	R51.9	Referred to specialist.
3736	5004	L30.9	Discussed lab results with patient.
3737	5005	F41.1	Vitals stable. Continue current plan.
3738	5006	J06.9	Vitals stable. Continue current plan.
3739	5007	I10	Vitals stable. Continue current plan.
3740	5008	E78.5	Preventive counseling provided.
3741	5011	J06.9	Referred to specialist.
3742	5014	Z00.00	Reviewed symptoms and history.
3743	5015	N39.0	Reviewed symptoms and history.
3744	5016	J06.9	Reviewed symptoms and history.
3745	5017	J45.909	Medication adjusted. Recheck in 6 weeks.
3746	5018	J45.909	Medication adjusted. Recheck in 6 weeks.
3747	5019	J45.909	Medication adjusted. Recheck in 6 weeks.
3748	5020	M54.5	Reviewed symptoms and history.
3749	5021	E11.9	Referred to specialist.
3750	5022	F41.1	Referred to specialist.
3751	5023	N39.0	Reviewed symptoms and history.
3752	5024	J06.9	Discussed lab results with patient.
3753	5025	N39.0	Medication adjusted. Recheck in 6 weeks.
3754	5027	I10	Reviewed symptoms and history.
3755	5028	M54.5	Discussed lab results with patient.
3756	5029	R51.9	Medication adjusted. Recheck in 6 weeks.
3757	5031	N39.0	Preventive counseling provided.
3758	5032	I10	Vitals stable. Continue current plan.
3759	5033	Z00.00	Vitals stable. Continue current plan.
3760	5034	Z00.00	Discussed lab results with patient.
3761	5035	L30.9	Discussed lab results with patient.
3762	5036	I10	Vitals stable. Continue current plan.
3763	5037	E78.5	Preventive counseling provided.
3764	5038	J06.9	Medication adjusted. Recheck in 6 weeks.
3765	5039	R51.9	Medication adjusted. Recheck in 6 weeks.
3766	5040	M54.5	Reviewed symptoms and history.
3767	5041	I10	Discussed lab results with patient.
3768	5042	Z00.00	Reviewed symptoms and history.
3769	5043	F41.1	Referred to specialist.
3770	5044	F41.1	Medication adjusted. Recheck in 6 weeks.
3771	5046	J45.909	Discussed lab results with patient.
3772	5048	M54.5	Preventive counseling provided.
3773	5049	R51.9	Reviewed symptoms and history.
3774	5050	F41.1	Preventive counseling provided.
3775	5051	I10	Reviewed symptoms and history.
3776	5052	L30.9	Discussed lab results with patient.
3777	5053	J06.9	Vitals stable. Continue current plan.
3778	5054	J06.9	Discussed lab results with patient.
3779	5055	L30.9	Medication adjusted. Recheck in 6 weeks.
3780	5057	E11.9	Medication adjusted. Recheck in 6 weeks.
3781	5058	M54.5	Vitals stable. Continue current plan.
3782	5059	N39.0	Discussed lab results with patient.
3783	5060	R51.9	Medication adjusted. Recheck in 6 weeks.
3784	5061	F41.1	Referred to specialist.
3785	5062	F41.1	Reviewed symptoms and history.
3786	5063	K21.9	Reviewed symptoms and history.
3787	5064	J06.9	Reviewed symptoms and history.
3788	5066	K21.9	Referred to specialist.
3789	5067	I10	Referred to specialist.
3790	5068	K21.9	Discussed lab results with patient.
3791	5069	E78.5	Medication adjusted. Recheck in 6 weeks.
3792	5070	M54.5	Preventive counseling provided.
3793	5071	L30.9	Medication adjusted. Recheck in 6 weeks.
3794	5072	J45.909	Medication adjusted. Recheck in 6 weeks.
3795	5073	R51.9	Medication adjusted. Recheck in 6 weeks.
3796	5074	J45.909	Medication adjusted. Recheck in 6 weeks.
3797	5077	L30.9	Referred to specialist.
3798	5079	E78.5	Vitals stable. Continue current plan.
3799	5080	N39.0	Vitals stable. Continue current plan.
3800	5081	J45.909	Preventive counseling provided.
3801	5082	L30.9	Preventive counseling provided.
3802	5083	J45.909	Reviewed symptoms and history.
3803	5084	L30.9	Preventive counseling provided.
3804	5086	J06.9	Referred to specialist.
3805	5087	I10	Discussed lab results with patient.
3806	5088	M54.5	Preventive counseling provided.
3807	5089	K21.9	Preventive counseling provided.
3808	5091	M54.5	Vitals stable. Continue current plan.
3809	5092	R51.9	Preventive counseling provided.
3810	5093	Z00.00	Medication adjusted. Recheck in 6 weeks.
3811	5095	Z00.00	Referred to specialist.
3812	5097	K21.9	Preventive counseling provided.
3813	5098	J06.9	Discussed lab results with patient.
3814	5099	J45.909	Discussed lab results with patient.
3815	5100	E78.5	Discussed lab results with patient.
3816	5102	E78.5	Vitals stable. Continue current plan.
3817	5104	J45.909	Discussed lab results with patient.
3818	5105	L30.9	Referred to specialist.
3819	5106	E11.9	Reviewed symptoms and history.
3820	5107	J45.909	Preventive counseling provided.
3821	5108	N39.0	Vitals stable. Continue current plan.
3822	5110	N39.0	Discussed lab results with patient.
3823	5111	J45.909	Preventive counseling provided.
3824	5112	K21.9	Reviewed symptoms and history.
3825	5113	E11.9	Preventive counseling provided.
3826	5114	J06.9	Referred to specialist.
3827	5116	E78.5	Referred to specialist.
3828	5117	R51.9	Medication adjusted. Recheck in 6 weeks.
3829	5118	N39.0	Discussed lab results with patient.
3830	5121	L30.9	Medication adjusted. Recheck in 6 weeks.
3831	5122	J06.9	Medication adjusted. Recheck in 6 weeks.
3832	5123	N39.0	Medication adjusted. Recheck in 6 weeks.
3833	5125	R51.9	Discussed lab results with patient.
3834	5126	R51.9	Preventive counseling provided.
3835	5127	K21.9	Referred to specialist.
3836	5128	K21.9	Discussed lab results with patient.
3837	5129	E11.9	Preventive counseling provided.
3838	5131	J45.909	Reviewed symptoms and history.
3839	5132	F41.1	Discussed lab results with patient.
3840	5136	K21.9	Referred to specialist.
3841	5137	M54.5	Preventive counseling provided.
3842	5138	Z00.00	Medication adjusted. Recheck in 6 weeks.
3843	5140	Z00.00	Preventive counseling provided.
3844	5142	J06.9	Reviewed symptoms and history.
3845	5143	E11.9	Vitals stable. Continue current plan.
3846	5144	R51.9	Preventive counseling provided.
3847	5147	E78.5	Reviewed symptoms and history.
3848	5148	L30.9	Discussed lab results with patient.
3849	5150	I10	Referred to specialist.
3850	5151	E11.9	Preventive counseling provided.
3851	5152	Z00.00	Referred to specialist.
3852	5153	E11.9	Preventive counseling provided.
3853	5154	M54.5	Preventive counseling provided.
3854	5155	R51.9	Discussed lab results with patient.
3855	5156	Z00.00	Referred to specialist.
3856	5157	K21.9	Reviewed symptoms and history.
3857	5158	J06.9	Referred to specialist.
3858	5160	J06.9	Vitals stable. Continue current plan.
3859	5161	J06.9	Vitals stable. Continue current plan.
3860	5162	E11.9	Medication adjusted. Recheck in 6 weeks.
3861	5164	N39.0	Reviewed symptoms and history.
3862	5165	R51.9	Reviewed symptoms and history.
3863	5166	E78.5	Discussed lab results with patient.
3864	5167	J06.9	Preventive counseling provided.
3865	5169	M54.5	Medication adjusted. Recheck in 6 weeks.
3866	5170	Z00.00	Vitals stable. Continue current plan.
3867	5173	E78.5	Preventive counseling provided.
3868	5176	Z00.00	Discussed lab results with patient.
3869	5178	M54.5	Referred to specialist.
3870	5179	I10	Discussed lab results with patient.
3871	5180	I10	Medication adjusted. Recheck in 6 weeks.
3872	5181	I10	Discussed lab results with patient.
3873	5184	E11.9	Vitals stable. Continue current plan.
3874	5186	F41.1	Preventive counseling provided.
3875	5187	M54.5	Medication adjusted. Recheck in 6 weeks.
3876	5189	M54.5	Reviewed symptoms and history.
3877	5190	I10	Preventive counseling provided.
3878	5191	F41.1	Preventive counseling provided.
3879	5192	K21.9	Medication adjusted. Recheck in 6 weeks.
3880	5193	I10	Reviewed symptoms and history.
3881	5194	K21.9	Discussed lab results with patient.
3882	5195	K21.9	Preventive counseling provided.
3883	5196	L30.9	Medication adjusted. Recheck in 6 weeks.
3884	5197	J45.909	Medication adjusted. Recheck in 6 weeks.
3885	5198	J06.9	Discussed lab results with patient.
3886	5199	E11.9	Reviewed symptoms and history.
3887	5201	N39.0	Reviewed symptoms and history.
3888	5203	Z00.00	Medication adjusted. Recheck in 6 weeks.
3889	5205	E11.9	Discussed lab results with patient.
3890	5206	M54.5	Vitals stable. Continue current plan.
3891	5207	F41.1	Medication adjusted. Recheck in 6 weeks.
3892	5208	R51.9	Medication adjusted. Recheck in 6 weeks.
3893	5209	J06.9	Reviewed symptoms and history.
3894	5210	E78.5	Preventive counseling provided.
3895	5211	M54.5	Vitals stable. Continue current plan.
3896	5213	E11.9	Discussed lab results with patient.
3897	5215	E78.5	Medication adjusted. Recheck in 6 weeks.
3898	5218	J45.909	Discussed lab results with patient.
3899	5219	K21.9	Reviewed symptoms and history.
3900	5220	L30.9	Preventive counseling provided.
3901	5221	N39.0	Discussed lab results with patient.
3902	5222	L30.9	Preventive counseling provided.
3903	5224	K21.9	Referred to specialist.
3904	5226	J45.909	Vitals stable. Continue current plan.
3905	5227	L30.9	Discussed lab results with patient.
3906	5228	N39.0	Reviewed symptoms and history.
3907	5229	E78.5	Medication adjusted. Recheck in 6 weeks.
3908	5231	J06.9	Referred to specialist.
3909	5232	E11.9	Preventive counseling provided.
3910	5233	E78.5	Reviewed symptoms and history.
3911	5234	F41.1	Vitals stable. Continue current plan.
3912	5235	R51.9	Vitals stable. Continue current plan.
3913	5236	Z00.00	Vitals stable. Continue current plan.
3914	5237	L30.9	Referred to specialist.
3915	5238	J45.909	Medication adjusted. Recheck in 6 weeks.
3916	5240	I10	Discussed lab results with patient.
3917	5241	M54.5	Reviewed symptoms and history.
3918	5242	E11.9	Reviewed symptoms and history.
3919	5245	E11.9	Discussed lab results with patient.
3920	5246	R51.9	Referred to specialist.
3921	5247	K21.9	Vitals stable. Continue current plan.
3922	5248	I10	Reviewed symptoms and history.
3923	5249	K21.9	Referred to specialist.
3924	5250	R51.9	Referred to specialist.
3925	5252	K21.9	Reviewed symptoms and history.
3926	5253	K21.9	Discussed lab results with patient.
3927	5254	J06.9	Medication adjusted. Recheck in 6 weeks.
3928	5255	Z00.00	Discussed lab results with patient.
3929	5256	L30.9	Referred to specialist.
3930	5257	K21.9	Preventive counseling provided.
3931	5261	Z00.00	Discussed lab results with patient.
3932	5263	J45.909	Preventive counseling provided.
3933	5264	F41.1	Medication adjusted. Recheck in 6 weeks.
3934	5269	R51.9	Medication adjusted. Recheck in 6 weeks.
3935	5270	E11.9	Vitals stable. Continue current plan.
3936	5271	F41.1	Discussed lab results with patient.
3937	5272	L30.9	Reviewed symptoms and history.
3938	5274	N39.0	Referred to specialist.
3939	5276	M54.5	Vitals stable. Continue current plan.
3940	5277	J06.9	Discussed lab results with patient.
3941	5278	L30.9	Preventive counseling provided.
3942	5279	K21.9	Reviewed symptoms and history.
3943	5280	J06.9	Referred to specialist.
3944	5281	F41.1	Reviewed symptoms and history.
3945	5282	K21.9	Medication adjusted. Recheck in 6 weeks.
3946	5285	L30.9	Medication adjusted. Recheck in 6 weeks.
3947	5287	M54.5	Referred to specialist.
3948	5288	Z00.00	Reviewed symptoms and history.
3949	5289	L30.9	Vitals stable. Continue current plan.
3950	5290	E11.9	Preventive counseling provided.
3951	5291	N39.0	Vitals stable. Continue current plan.
3952	5292	L30.9	Reviewed symptoms and history.
3953	5293	E11.9	Discussed lab results with patient.
3954	5294	J06.9	Referred to specialist.
3955	5295	I10	Reviewed symptoms and history.
3956	5297	M54.5	Referred to specialist.
3957	5298	I10	Discussed lab results with patient.
3958	5299	J06.9	Medication adjusted. Recheck in 6 weeks.
3959	5302	E78.5	Preventive counseling provided.
3960	5304	K21.9	Preventive counseling provided.
3961	5305	M54.5	Medication adjusted. Recheck in 6 weeks.
3962	5306	R51.9	Medication adjusted. Recheck in 6 weeks.
3963	5307	N39.0	Reviewed symptoms and history.
3964	5310	L30.9	Medication adjusted. Recheck in 6 weeks.
3965	5311	K21.9	Reviewed symptoms and history.
3966	5313	R51.9	Preventive counseling provided.
3967	5314	N39.0	Vitals stable. Continue current plan.
3968	5316	E11.9	Medication adjusted. Recheck in 6 weeks.
3969	5317	L30.9	Referred to specialist.
3970	5319	I10	Referred to specialist.
3971	5321	E11.9	Reviewed symptoms and history.
3972	5322	L30.9	Referred to specialist.
3973	5323	N39.0	Reviewed symptoms and history.
3974	5326	Z00.00	Medication adjusted. Recheck in 6 weeks.
3975	5327	J06.9	Preventive counseling provided.
3976	5328	E11.9	Vitals stable. Continue current plan.
3977	5329	J06.9	Discussed lab results with patient.
3978	5330	Z00.00	Referred to specialist.
3979	5331	N39.0	Vitals stable. Continue current plan.
3980	5332	K21.9	Discussed lab results with patient.
3981	5333	K21.9	Discussed lab results with patient.
3982	5335	K21.9	Medication adjusted. Recheck in 6 weeks.
3983	5338	E11.9	Referred to specialist.
3984	5339	E11.9	Vitals stable. Continue current plan.
3985	5340	J45.909	Preventive counseling provided.
3986	5341	J45.909	Reviewed symptoms and history.
3987	5342	K21.9	Reviewed symptoms and history.
3988	5344	J06.9	Reviewed symptoms and history.
3989	5345	L30.9	Medication adjusted. Recheck in 6 weeks.
3990	5347	Z00.00	Medication adjusted. Recheck in 6 weeks.
3991	5350	J06.9	Discussed lab results with patient.
3992	5351	I10	Reviewed symptoms and history.
3993	5352	E11.9	Medication adjusted. Recheck in 6 weeks.
3994	5353	K21.9	Medication adjusted. Recheck in 6 weeks.
3995	5354	L30.9	Discussed lab results with patient.
3996	5355	J06.9	Preventive counseling provided.
3997	5356	E78.5	Referred to specialist.
3998	5358	E11.9	Vitals stable. Continue current plan.
3999	5359	J45.909	Referred to specialist.
4000	5360	M54.5	Reviewed symptoms and history.
4001	5361	R51.9	Preventive counseling provided.
4002	5362	E11.9	Preventive counseling provided.
4003	5363	N39.0	Referred to specialist.
4004	5364	M54.5	Medication adjusted. Recheck in 6 weeks.
4005	5365	J06.9	Referred to specialist.
4006	5366	N39.0	Vitals stable. Continue current plan.
4007	5367	Z00.00	Preventive counseling provided.
4008	5368	L30.9	Discussed lab results with patient.
4009	5369	F41.1	Reviewed symptoms and history.
4010	5370	E78.5	Medication adjusted. Recheck in 6 weeks.
4011	5372	F41.1	Referred to specialist.
4012	5373	E78.5	Medication adjusted. Recheck in 6 weeks.
4013	5375	K21.9	Medication adjusted. Recheck in 6 weeks.
4014	5376	E11.9	Vitals stable. Continue current plan.
4015	5377	I10	Reviewed symptoms and history.
4016	5378	I10	Preventive counseling provided.
4017	5379	N39.0	Vitals stable. Continue current plan.
4018	5380	M54.5	Referred to specialist.
4019	5381	N39.0	Discussed lab results with patient.
4020	5383	J06.9	Preventive counseling provided.
4021	5387	J45.909	Vitals stable. Continue current plan.
4022	5388	E11.9	Vitals stable. Continue current plan.
4023	5390	F41.1	Referred to specialist.
4024	5391	I10	Preventive counseling provided.
4025	5392	F41.1	Preventive counseling provided.
4026	5393	L30.9	Reviewed symptoms and history.
4027	5394	F41.1	Discussed lab results with patient.
4028	5395	K21.9	Discussed lab results with patient.
4029	5396	J45.909	Medication adjusted. Recheck in 6 weeks.
4030	5397	I10	Vitals stable. Continue current plan.
4031	5398	I10	Vitals stable. Continue current plan.
4032	5399	Z00.00	Preventive counseling provided.
4033	5400	K21.9	Referred to specialist.
4034	5402	R51.9	Medication adjusted. Recheck in 6 weeks.
4035	5403	K21.9	Reviewed symptoms and history.
4036	5404	E11.9	Reviewed symptoms and history.
4037	5406	M54.5	Medication adjusted. Recheck in 6 weeks.
4038	5407	L30.9	Preventive counseling provided.
4039	5408	J45.909	Medication adjusted. Recheck in 6 weeks.
4040	5409	K21.9	Referred to specialist.
4041	5410	E78.5	Medication adjusted. Recheck in 6 weeks.
4042	5411	K21.9	Medication adjusted. Recheck in 6 weeks.
4043	5412	M54.5	Vitals stable. Continue current plan.
4044	5413	E11.9	Discussed lab results with patient.
4045	5414	Z00.00	Medication adjusted. Recheck in 6 weeks.
4046	5416	I10	Preventive counseling provided.
4047	5419	E11.9	Discussed lab results with patient.
4048	5420	J06.9	Reviewed symptoms and history.
4049	5421	K21.9	Medication adjusted. Recheck in 6 weeks.
4050	5422	F41.1	Reviewed symptoms and history.
4051	5423	R51.9	Preventive counseling provided.
4052	5424	R51.9	Referred to specialist.
4053	5425	M54.5	Preventive counseling provided.
4054	5427	L30.9	Medication adjusted. Recheck in 6 weeks.
4055	5428	J45.909	Medication adjusted. Recheck in 6 weeks.
4056	5429	I10	Medication adjusted. Recheck in 6 weeks.
4057	5430	N39.0	Vitals stable. Continue current plan.
4058	5431	I10	Referred to specialist.
4059	5432	J06.9	Referred to specialist.
4060	5434	I10	Discussed lab results with patient.
4061	5435	K21.9	Reviewed symptoms and history.
4062	5436	R51.9	Preventive counseling provided.
4063	5437	Z00.00	Referred to specialist.
4064	5438	E11.9	Vitals stable. Continue current plan.
4065	5439	J06.9	Referred to specialist.
4066	5440	M54.5	Vitals stable. Continue current plan.
4067	5441	J45.909	Discussed lab results with patient.
4068	5442	R51.9	Vitals stable. Continue current plan.
4069	5443	M54.5	Vitals stable. Continue current plan.
4070	5444	R51.9	Preventive counseling provided.
4071	5445	J45.909	Vitals stable. Continue current plan.
4072	5446	R51.9	Preventive counseling provided.
4073	5447	M54.5	Vitals stable. Continue current plan.
4074	5448	R51.9	Referred to specialist.
4075	5449	E11.9	Preventive counseling provided.
4076	5450	K21.9	Discussed lab results with patient.
4077	5453	L30.9	Reviewed symptoms and history.
4078	5454	J45.909	Medication adjusted. Recheck in 6 weeks.
4079	5455	E11.9	Reviewed symptoms and history.
4080	5457	R51.9	Discussed lab results with patient.
4081	5459	F41.1	Preventive counseling provided.
4082	5460	N39.0	Preventive counseling provided.
4083	5461	L30.9	Reviewed symptoms and history.
4084	5462	E78.5	Discussed lab results with patient.
4085	5463	M54.5	Preventive counseling provided.
4086	5464	E78.5	Vitals stable. Continue current plan.
4087	5466	E78.5	Preventive counseling provided.
4088	5467	J06.9	Referred to specialist.
4089	5470	R51.9	Medication adjusted. Recheck in 6 weeks.
4090	5471	L30.9	Preventive counseling provided.
4091	5472	Z00.00	Vitals stable. Continue current plan.
4092	5473	M54.5	Preventive counseling provided.
4093	5474	R51.9	Medication adjusted. Recheck in 6 weeks.
4094	5476	F41.1	Reviewed symptoms and history.
4095	5477	J45.909	Medication adjusted. Recheck in 6 weeks.
4096	5478	Z00.00	Vitals stable. Continue current plan.
4097	5479	Z00.00	Preventive counseling provided.
4098	5480	M54.5	Vitals stable. Continue current plan.
4099	5481	J06.9	Reviewed symptoms and history.
4100	5482	L30.9	Vitals stable. Continue current plan.
4101	5483	I10	Reviewed symptoms and history.
4102	5484	N39.0	Medication adjusted. Recheck in 6 weeks.
4103	5485	J45.909	Preventive counseling provided.
4104	5486	J45.909	Referred to specialist.
4105	5487	F41.1	Discussed lab results with patient.
4106	5488	M54.5	Reviewed symptoms and history.
4107	5489	J45.909	Reviewed symptoms and history.
4108	5490	I10	Medication adjusted. Recheck in 6 weeks.
4109	5491	K21.9	Discussed lab results with patient.
4110	5493	N39.0	Reviewed symptoms and history.
4111	5494	J45.909	Discussed lab results with patient.
4112	5497	E11.9	Medication adjusted. Recheck in 6 weeks.
4113	5498	J06.9	Preventive counseling provided.
4114	5499	F41.1	Reviewed symptoms and history.
4115	5500	R51.9	Referred to specialist.
4116	5501	M54.5	Preventive counseling provided.
4117	5502	M54.5	Medication adjusted. Recheck in 6 weeks.
4118	5503	I10	Medication adjusted. Recheck in 6 weeks.
4119	5504	L30.9	Discussed lab results with patient.
4120	5507	J06.9	Referred to specialist.
4121	5508	K21.9	Discussed lab results with patient.
4122	5509	L30.9	Discussed lab results with patient.
4123	5511	J06.9	Preventive counseling provided.
4124	5512	J45.909	Preventive counseling provided.
4125	5513	E11.9	Vitals stable. Continue current plan.
4126	5516	I10	Vitals stable. Continue current plan.
4127	5518	M54.5	Reviewed symptoms and history.
4128	5519	L30.9	Vitals stable. Continue current plan.
4129	5521	I10	Referred to specialist.
4130	5523	M54.5	Referred to specialist.
4131	5524	E78.5	Preventive counseling provided.
4132	5525	R51.9	Discussed lab results with patient.
4133	5526	E11.9	Referred to specialist.
4134	5527	E11.9	Discussed lab results with patient.
4135	5528	K21.9	Referred to specialist.
4136	5529	J06.9	Preventive counseling provided.
4137	5530	M54.5	Reviewed symptoms and history.
4138	5531	J45.909	Medication adjusted. Recheck in 6 weeks.
4139	5532	M54.5	Referred to specialist.
4140	5533	N39.0	Discussed lab results with patient.
4141	5534	R51.9	Referred to specialist.
4142	5535	I10	Discussed lab results with patient.
4143	5536	E78.5	Preventive counseling provided.
4144	5537	M54.5	Medication adjusted. Recheck in 6 weeks.
4145	5540	I10	Vitals stable. Continue current plan.
4146	5541	J06.9	Referred to specialist.
4147	5542	L30.9	Referred to specialist.
4148	5543	N39.0	Reviewed symptoms and history.
4149	5545	L30.9	Discussed lab results with patient.
4150	5546	I10	Vitals stable. Continue current plan.
4151	5547	J45.909	Reviewed symptoms and history.
4152	5548	M54.5	Reviewed symptoms and history.
4153	5551	J06.9	Medication adjusted. Recheck in 6 weeks.
4154	5552	M54.5	Reviewed symptoms and history.
4155	5553	J45.909	Preventive counseling provided.
4156	5556	I10	Vitals stable. Continue current plan.
4157	5557	I10	Discussed lab results with patient.
4158	5558	K21.9	Referred to specialist.
4159	5562	L30.9	Vitals stable. Continue current plan.
4160	5563	R51.9	Vitals stable. Continue current plan.
4161	5567	J06.9	Referred to specialist.
4162	5568	F41.1	Vitals stable. Continue current plan.
4163	5569	L30.9	Reviewed symptoms and history.
4164	5570	F41.1	Referred to specialist.
4165	5571	K21.9	Preventive counseling provided.
4166	5572	K21.9	Referred to specialist.
4167	5574	E11.9	Preventive counseling provided.
4168	5575	Z00.00	Referred to specialist.
4169	5576	E78.5	Discussed lab results with patient.
4170	5577	R51.9	Medication adjusted. Recheck in 6 weeks.
4171	5579	K21.9	Discussed lab results with patient.
4172	5580	Z00.00	Medication adjusted. Recheck in 6 weeks.
4173	5582	F41.1	Vitals stable. Continue current plan.
4174	5584	M54.5	Referred to specialist.
4175	5585	Z00.00	Reviewed symptoms and history.
4176	5586	N39.0	Medication adjusted. Recheck in 6 weeks.
4177	5588	J45.909	Medication adjusted. Recheck in 6 weeks.
4178	5589	J06.9	Vitals stable. Continue current plan.
4179	5590	E78.5	Referred to specialist.
4180	5592	J45.909	Medication adjusted. Recheck in 6 weeks.
4181	5594	M54.5	Reviewed symptoms and history.
4182	5596	F41.1	Medication adjusted. Recheck in 6 weeks.
4183	5597	L30.9	Medication adjusted. Recheck in 6 weeks.
4184	5598	L30.9	Discussed lab results with patient.
4185	5600	J45.909	Reviewed symptoms and history.
4186	5601	K21.9	Medication adjusted. Recheck in 6 weeks.
4187	5602	L30.9	Discussed lab results with patient.
4188	5603	K21.9	Preventive counseling provided.
4189	5604	F41.1	Medication adjusted. Recheck in 6 weeks.
4190	5607	Z00.00	Discussed lab results with patient.
4191	5608	E78.5	Discussed lab results with patient.
4192	5610	F41.1	Preventive counseling provided.
4193	5612	Z00.00	Preventive counseling provided.
4194	5614	R51.9	Discussed lab results with patient.
4195	5615	E11.9	Medication adjusted. Recheck in 6 weeks.
4196	5616	E11.9	Discussed lab results with patient.
4197	5617	F41.1	Reviewed symptoms and history.
4198	5620	M54.5	Referred to specialist.
4199	5621	J06.9	Reviewed symptoms and history.
4200	5622	E78.5	Vitals stable. Continue current plan.
4201	5625	E11.9	Medication adjusted. Recheck in 6 weeks.
4202	5626	M54.5	Discussed lab results with patient.
4203	5627	K21.9	Referred to specialist.
4204	5628	M54.5	Referred to specialist.
4205	5629	K21.9	Reviewed symptoms and history.
4206	5631	E78.5	Referred to specialist.
4207	5632	N39.0	Medication adjusted. Recheck in 6 weeks.
4208	5634	N39.0	Medication adjusted. Recheck in 6 weeks.
4209	5637	K21.9	Vitals stable. Continue current plan.
4210	5638	F41.1	Vitals stable. Continue current plan.
4211	5639	E11.9	Reviewed symptoms and history.
4212	5640	F41.1	Reviewed symptoms and history.
4213	5641	J45.909	Discussed lab results with patient.
4214	5642	N39.0	Referred to specialist.
4215	5643	R51.9	Discussed lab results with patient.
4216	5644	I10	Discussed lab results with patient.
4217	5645	J45.909	Vitals stable. Continue current plan.
4218	5646	J45.909	Medication adjusted. Recheck in 6 weeks.
4219	5647	M54.5	Reviewed symptoms and history.
4220	5652	I10	Discussed lab results with patient.
4221	5653	E11.9	Reviewed symptoms and history.
4222	5654	Z00.00	Discussed lab results with patient.
4223	5655	N39.0	Referred to specialist.
4224	5657	L30.9	Discussed lab results with patient.
4225	5658	Z00.00	Vitals stable. Continue current plan.
4226	5659	I10	Reviewed symptoms and history.
4227	5660	E78.5	Medication adjusted. Recheck in 6 weeks.
4228	5661	E78.5	Reviewed symptoms and history.
4229	5662	I10	Referred to specialist.
4230	5663	M54.5	Referred to specialist.
4231	5665	J45.909	Reviewed symptoms and history.
4232	5666	K21.9	Preventive counseling provided.
4233	5667	E11.9	Reviewed symptoms and history.
4234	5668	E78.5	Vitals stable. Continue current plan.
4235	5669	J06.9	Preventive counseling provided.
4236	5670	I10	Referred to specialist.
4237	5671	I10	Referred to specialist.
4238	5672	L30.9	Reviewed symptoms and history.
4239	5673	E11.9	Medication adjusted. Recheck in 6 weeks.
4240	5674	L30.9	Reviewed symptoms and history.
4241	5675	L30.9	Preventive counseling provided.
4242	5676	N39.0	Reviewed symptoms and history.
4243	5677	Z00.00	Vitals stable. Continue current plan.
4244	5680	Z00.00	Reviewed symptoms and history.
4245	5681	I10	Discussed lab results with patient.
4246	5682	N39.0	Preventive counseling provided.
4247	5683	E78.5	Referred to specialist.
4248	5685	J06.9	Referred to specialist.
4249	5686	J06.9	Discussed lab results with patient.
4250	5687	N39.0	Vitals stable. Continue current plan.
4251	5688	L30.9	Reviewed symptoms and history.
4252	5689	Z00.00	Preventive counseling provided.
4253	5691	E78.5	Preventive counseling provided.
4254	5693	Z00.00	Discussed lab results with patient.
4255	5694	E11.9	Medication adjusted. Recheck in 6 weeks.
4256	5695	Z00.00	Vitals stable. Continue current plan.
4257	5696	J45.909	Reviewed symptoms and history.
4258	5697	L30.9	Discussed lab results with patient.
4259	5698	K21.9	Medication adjusted. Recheck in 6 weeks.
4260	5699	J06.9	Reviewed symptoms and history.
4261	5700	R51.9	Vitals stable. Continue current plan.
4262	5701	Z00.00	Referred to specialist.
4263	5703	L30.9	Referred to specialist.
4264	5704	R51.9	Reviewed symptoms and history.
4265	5706	L30.9	Medication adjusted. Recheck in 6 weeks.
4266	5707	J06.9	Vitals stable. Continue current plan.
4267	5708	L30.9	Referred to specialist.
4268	5709	E78.5	Vitals stable. Continue current plan.
4269	5710	K21.9	Medication adjusted. Recheck in 6 weeks.
4270	5711	F41.1	Vitals stable. Continue current plan.
4271	5712	K21.9	Medication adjusted. Recheck in 6 weeks.
4272	5713	E78.5	Reviewed symptoms and history.
4273	5714	J45.909	Reviewed symptoms and history.
4274	5715	I10	Discussed lab results with patient.
4275	5716	R51.9	Preventive counseling provided.
4276	5717	Z00.00	Reviewed symptoms and history.
4277	5718	E78.5	Medication adjusted. Recheck in 6 weeks.
4278	5719	F41.1	Discussed lab results with patient.
4279	5720	J06.9	Referred to specialist.
4280	5721	F41.1	Discussed lab results with patient.
4281	5722	J06.9	Medication adjusted. Recheck in 6 weeks.
4282	5723	I10	Preventive counseling provided.
4283	5724	R51.9	Preventive counseling provided.
4284	5726	J45.909	Referred to specialist.
4285	5727	L30.9	Discussed lab results with patient.
4286	5728	Z00.00	Medication adjusted. Recheck in 6 weeks.
4287	5730	J06.9	Medication adjusted. Recheck in 6 weeks.
4288	5732	E11.9	Referred to specialist.
4289	5733	J06.9	Preventive counseling provided.
4290	5734	M54.5	Vitals stable. Continue current plan.
4291	5735	E11.9	Reviewed symptoms and history.
4292	5736	K21.9	Vitals stable. Continue current plan.
4293	5737	M54.5	Referred to specialist.
4294	5738	J45.909	Vitals stable. Continue current plan.
4295	5739	Z00.00	Referred to specialist.
4296	5741	L30.9	Reviewed symptoms and history.
4297	5742	J06.9	Preventive counseling provided.
4298	5743	M54.5	Referred to specialist.
4299	5744	I10	Referred to specialist.
4300	5745	J45.909	Medication adjusted. Recheck in 6 weeks.
4301	5748	E78.5	Vitals stable. Continue current plan.
4302	5750	N39.0	Referred to specialist.
4303	5752	J45.909	Medication adjusted. Recheck in 6 weeks.
4304	5753	E11.9	Medication adjusted. Recheck in 6 weeks.
4305	5754	E78.5	Discussed lab results with patient.
4306	5755	R51.9	Vitals stable. Continue current plan.
4307	5756	I10	Reviewed symptoms and history.
4308	5757	L30.9	Vitals stable. Continue current plan.
4309	5758	R51.9	Medication adjusted. Recheck in 6 weeks.
4310	5759	N39.0	Vitals stable. Continue current plan.
4311	5760	E11.9	Vitals stable. Continue current plan.
4312	5761	M54.5	Preventive counseling provided.
4313	5762	I10	Discussed lab results with patient.
4314	5763	I10	Preventive counseling provided.
4315	5764	F41.1	Reviewed symptoms and history.
4316	5766	L30.9	Referred to specialist.
4317	5767	E11.9	Reviewed symptoms and history.
4318	5769	L30.9	Discussed lab results with patient.
4319	5770	E11.9	Preventive counseling provided.
4320	5774	L30.9	Referred to specialist.
4321	5775	J45.909	Vitals stable. Continue current plan.
4322	5777	K21.9	Reviewed symptoms and history.
4323	5778	F41.1	Referred to specialist.
4324	5779	E11.9	Preventive counseling provided.
4325	5780	M54.5	Medication adjusted. Recheck in 6 weeks.
4326	5781	N39.0	Preventive counseling provided.
4327	5782	J06.9	Discussed lab results with patient.
4328	5784	F41.1	Referred to specialist.
4329	5785	M54.5	Reviewed symptoms and history.
4330	5786	F41.1	Referred to specialist.
4331	5787	N39.0	Preventive counseling provided.
4332	5788	K21.9	Vitals stable. Continue current plan.
4333	5789	J45.909	Vitals stable. Continue current plan.
4334	5790	Z00.00	Vitals stable. Continue current plan.
4335	5791	I10	Medication adjusted. Recheck in 6 weeks.
4336	5793	N39.0	Medication adjusted. Recheck in 6 weeks.
4337	5794	N39.0	Reviewed symptoms and history.
4338	5795	E11.9	Medication adjusted. Recheck in 6 weeks.
4339	5796	Z00.00	Vitals stable. Continue current plan.
4340	5797	F41.1	Referred to specialist.
4341	5798	I10	Discussed lab results with patient.
4342	5799	E11.9	Preventive counseling provided.
4343	5800	J06.9	Referred to specialist.
4344	5801	M54.5	Discussed lab results with patient.
4345	5802	J45.909	Vitals stable. Continue current plan.
4346	5803	K21.9	Referred to specialist.
4347	5805	N39.0	Referred to specialist.
4348	5808	N39.0	Reviewed symptoms and history.
4349	5810	I10	Referred to specialist.
4350	5812	F41.1	Preventive counseling provided.
4351	5813	L30.9	Medication adjusted. Recheck in 6 weeks.
4352	5814	L30.9	Preventive counseling provided.
4353	5815	N39.0	Medication adjusted. Recheck in 6 weeks.
4354	5819	N39.0	Referred to specialist.
4355	5820	K21.9	Reviewed symptoms and history.
4356	5822	K21.9	Referred to specialist.
4357	5823	M54.5	Vitals stable. Continue current plan.
4358	5824	L30.9	Referred to specialist.
4359	5825	E78.5	Reviewed symptoms and history.
4360	5826	N39.0	Reviewed symptoms and history.
4361	5828	K21.9	Preventive counseling provided.
4362	5829	K21.9	Medication adjusted. Recheck in 6 weeks.
4363	5830	K21.9	Medication adjusted. Recheck in 6 weeks.
4364	5833	K21.9	Vitals stable. Continue current plan.
4365	5834	J06.9	Vitals stable. Continue current plan.
4366	5836	R51.9	Reviewed symptoms and history.
4367	5837	F41.1	Reviewed symptoms and history.
4368	5838	E78.5	Referred to specialist.
4369	5839	F41.1	Reviewed symptoms and history.
4370	5841	Z00.00	Vitals stable. Continue current plan.
4371	5842	K21.9	Referred to specialist.
4372	5843	J06.9	Vitals stable. Continue current plan.
4373	5845	E78.5	Vitals stable. Continue current plan.
4374	5846	J45.909	Discussed lab results with patient.
4375	5848	K21.9	Preventive counseling provided.
4376	5850	E78.5	Preventive counseling provided.
4377	5852	E11.9	Reviewed symptoms and history.
4378	5853	J45.909	Referred to specialist.
4379	5854	J06.9	Vitals stable. Continue current plan.
4380	5857	L30.9	Medication adjusted. Recheck in 6 weeks.
4381	5858	K21.9	Preventive counseling provided.
4382	5860	E11.9	Vitals stable. Continue current plan.
4383	5861	J06.9	Reviewed symptoms and history.
4384	5862	F41.1	Reviewed symptoms and history.
4385	5863	Z00.00	Referred to specialist.
4386	5864	I10	Preventive counseling provided.
4387	5865	J06.9	Referred to specialist.
4388	5866	R51.9	Reviewed symptoms and history.
4389	5867	R51.9	Vitals stable. Continue current plan.
4390	5870	J45.909	Reviewed symptoms and history.
4391	5871	I10	Referred to specialist.
4392	5873	M54.5	Vitals stable. Continue current plan.
4393	5874	I10	Discussed lab results with patient.
4394	5875	J06.9	Referred to specialist.
4395	5876	K21.9	Reviewed symptoms and history.
4396	5877	Z00.00	Preventive counseling provided.
4397	5879	N39.0	Discussed lab results with patient.
4398	5880	R51.9	Discussed lab results with patient.
4399	5881	I10	Vitals stable. Continue current plan.
4400	5882	E11.9	Vitals stable. Continue current plan.
4401	5883	I10	Preventive counseling provided.
4402	5884	L30.9	Discussed lab results with patient.
4403	5886	M54.5	Discussed lab results with patient.
4404	5887	Z00.00	Medication adjusted. Recheck in 6 weeks.
4405	5888	E11.9	Reviewed symptoms and history.
4406	5889	M54.5	Medication adjusted. Recheck in 6 weeks.
4407	5890	I10	Reviewed symptoms and history.
4408	5891	E78.5	Discussed lab results with patient.
4409	5892	F41.1	Reviewed symptoms and history.
4410	5893	R51.9	Preventive counseling provided.
4411	5894	J45.909	Reviewed symptoms and history.
4412	5895	Z00.00	Discussed lab results with patient.
4413	5897	N39.0	Medication adjusted. Recheck in 6 weeks.
4414	5900	N39.0	Vitals stable. Continue current plan.
4415	5901	I10	Discussed lab results with patient.
4416	5902	E11.9	Referred to specialist.
4417	5903	J45.909	Preventive counseling provided.
4418	5905	E78.5	Referred to specialist.
4419	5907	F41.1	Medication adjusted. Recheck in 6 weeks.
4420	5908	N39.0	Medication adjusted. Recheck in 6 weeks.
4421	5909	J45.909	Reviewed symptoms and history.
4422	5910	J45.909	Discussed lab results with patient.
4423	5911	Z00.00	Reviewed symptoms and history.
4424	5912	M54.5	Reviewed symptoms and history.
4425	5915	I10	Preventive counseling provided.
4426	5916	R51.9	Reviewed symptoms and history.
4427	5918	M54.5	Referred to specialist.
4428	5919	J06.9	Preventive counseling provided.
4429	5920	L30.9	Vitals stable. Continue current plan.
4430	5921	I10	Preventive counseling provided.
4431	5923	L30.9	Referred to specialist.
4432	5924	I10	Preventive counseling provided.
4433	5926	J45.909	Referred to specialist.
4434	5928	M54.5	Preventive counseling provided.
4435	5929	R51.9	Reviewed symptoms and history.
4436	5931	E11.9	Vitals stable. Continue current plan.
4437	5932	E78.5	Preventive counseling provided.
4438	5933	R51.9	Reviewed symptoms and history.
4439	5936	N39.0	Preventive counseling provided.
4440	5938	M54.5	Preventive counseling provided.
4441	5939	K21.9	Referred to specialist.
4442	5940	E11.9	Reviewed symptoms and history.
4443	5941	R51.9	Referred to specialist.
4444	5943	M54.5	Discussed lab results with patient.
4445	5944	N39.0	Discussed lab results with patient.
4446	5945	N39.0	Discussed lab results with patient.
4447	5946	I10	Reviewed symptoms and history.
4448	5947	M54.5	Vitals stable. Continue current plan.
4449	5948	F41.1	Referred to specialist.
4450	5949	Z00.00	Vitals stable. Continue current plan.
4451	5950	Z00.00	Medication adjusted. Recheck in 6 weeks.
4452	5951	K21.9	Medication adjusted. Recheck in 6 weeks.
4453	5952	E11.9	Reviewed symptoms and history.
4454	5953	F41.1	Preventive counseling provided.
4455	5956	I10	Preventive counseling provided.
4456	5957	F41.1	Discussed lab results with patient.
4457	5958	N39.0	Referred to specialist.
4458	5959	J06.9	Medication adjusted. Recheck in 6 weeks.
4459	5960	F41.1	Vitals stable. Continue current plan.
4460	5961	E78.5	Referred to specialist.
4461	5964	F41.1	Vitals stable. Continue current plan.
4462	5965	K21.9	Referred to specialist.
4463	5966	I10	Referred to specialist.
4464	5968	F41.1	Reviewed symptoms and history.
4465	5970	R51.9	Reviewed symptoms and history.
4466	5972	K21.9	Discussed lab results with patient.
4467	5973	E11.9	Vitals stable. Continue current plan.
4468	5974	E11.9	Reviewed symptoms and history.
4469	5975	I10	Vitals stable. Continue current plan.
4470	5976	J06.9	Reviewed symptoms and history.
4471	5977	M54.5	Preventive counseling provided.
4472	5978	K21.9	Reviewed symptoms and history.
4473	5980	E11.9	Reviewed symptoms and history.
4474	5981	F41.1	Discussed lab results with patient.
4475	5984	L30.9	Referred to specialist.
4476	5985	Z00.00	Preventive counseling provided.
4477	5986	E78.5	Discussed lab results with patient.
4478	5987	Z00.00	Vitals stable. Continue current plan.
4479	5988	L30.9	Referred to specialist.
4480	5989	J45.909	Vitals stable. Continue current plan.
4481	5991	E11.9	Discussed lab results with patient.
4482	5992	E11.9	Reviewed symptoms and history.
4483	5994	E78.5	Reviewed symptoms and history.
4484	5995	J06.9	Reviewed symptoms and history.
4485	5996	M54.5	Discussed lab results with patient.
4486	5999	K21.9	Reviewed symptoms and history.
\.


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (appointment_id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (patient_id);


--
-- Name: providers providers_npi_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_npi_key UNIQUE (npi);


--
-- Name: providers providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (provider_id);


--
-- Name: staff_accounts staff_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_accounts
    ADD CONSTRAINT staff_accounts_pkey PRIMARY KEY (account_id);


--
-- Name: staff_accounts staff_accounts_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_accounts
    ADD CONSTRAINT staff_accounts_username_key UNIQUE (username);


--
-- Name: visit_notes visit_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visit_notes
    ADD CONSTRAINT visit_notes_pkey PRIMARY KEY (note_id);


--
-- Name: appointments appointments_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(patient_id);


--
-- Name: appointments appointments_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(provider_id);


--
-- Name: staff_accounts staff_accounts_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_accounts
    ADD CONSTRAINT staff_accounts_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(provider_id);


--
-- Name: visit_notes visit_notes_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visit_notes
    ADD CONSTRAINT visit_notes_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(appointment_id);


--
-- PostgreSQL database dump complete
--

\unrestrict iG6zvAsI2pl9cAD34RbQ74T38RPj26YjIPBbeGLFh6jxeM17NVwXEnBLhDdhsmb

