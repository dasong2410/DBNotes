-- Test index creation on null geometries
-- An index on more than 459 null geometries (with or without actual geometires)
--   used to fail on PostgreSQL 8.2.

CREATE TABLE "test" (
	"num" integer,
	"the_geom" geometry
);
select sn_create_distributed_table('test', 'num', 'none');

INSERT INTO "test" ("num", "the_geom") VALUES (	1	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	2	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	3	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	4	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	5	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	6	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	7	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	8	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	9	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	10	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	11	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	12	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	13	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	14	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	15	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	16	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	17	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	18	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	19	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	20	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	21	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	22	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	23	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	24	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	25	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	26	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	27	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	28	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	29	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	30	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	31	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	32	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	33	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	34	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	35	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	36	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	37	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	38	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	39	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	40	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	41	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	42	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	43	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	44	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	45	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	46	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	47	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	48	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	49	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	50	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	51	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	52	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	53	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	54	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	55	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	56	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	57	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	58	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	59	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	60	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	61	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	62	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	63	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	64	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	65	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	66	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	67	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	68	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	69	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	70	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	71	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	72	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	73	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	74	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	75	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	76	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	77	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	78	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	79	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	80	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	81	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	82	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	83	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	84	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	85	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	86	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	87	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	88	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	89	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	90	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	91	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	92	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	93	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	94	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	95	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	96	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	97	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	98	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	99	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	100	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	101	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	102	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	103	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	104	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	105	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	106	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	107	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	108	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	109	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	110	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	111	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	112	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	113	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	114	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	115	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	116	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	117	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	118	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	119	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	120	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	121	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	122	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	123	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	124	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	125	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	126	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	127	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	128	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	129	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	130	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	131	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	132	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	133	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	134	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	135	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	136	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	137	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	138	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	139	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	140	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	141	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	142	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	143	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	144	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	145	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	146	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	147	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	148	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	149	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	150	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	151	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	152	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	153	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	154	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	155	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	156	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	157	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	158	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	159	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	160	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	161	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	162	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	163	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	164	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	165	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	166	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	167	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	168	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	169	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	170	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	171	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	172	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	173	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	174	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	175	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	176	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	177	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	178	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	179	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	180	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	181	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	182	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	183	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	184	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	185	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	186	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	187	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	188	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	189	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	190	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	191	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	192	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	193	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	194	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	195	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	196	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	197	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	198	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	199	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	200	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	201	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	202	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	203	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	204	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	205	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	206	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	207	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	208	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	209	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	210	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	211	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	212	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	213	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	214	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	215	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	216	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	217	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	218	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	219	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	220	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	221	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	222	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	223	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	224	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	225	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	226	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	227	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	228	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	229	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	230	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	231	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	232	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	233	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	234	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	235	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	236	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	237	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	238	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	239	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	240	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	241	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	242	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	243	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	244	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	245	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	246	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	247	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	248	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	249	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	250	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	251	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	252	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	253	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	254	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	255	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	256	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	257	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	258	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	259	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	260	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	261	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	262	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	263	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	264	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	265	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	266	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	267	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	268	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	269	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	270	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	271	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	272	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	273	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	274	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	275	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	276	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	277	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	278	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	279	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	280	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	281	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	282	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	283	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	284	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	285	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	286	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	287	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	288	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	289	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	290	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	291	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	292	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	293	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	294	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	295	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	296	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	297	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	298	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	299	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	300	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	301	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	302	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	303	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	304	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	305	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	306	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	307	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	308	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	309	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	310	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	311	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	312	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	313	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	314	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	315	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	316	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	317	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	318	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	319	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	320	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	321	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	322	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	323	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	324	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	325	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	326	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	327	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	328	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	329	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	330	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	331	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	332	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	333	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	334	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	335	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	336	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	337	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	338	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	339	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	340	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	341	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	342	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	343	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	344	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	345	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	346	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	347	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	348	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	349	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	350	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	351	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	352	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	353	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	354	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	355	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	356	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	357	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	358	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	359	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	360	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	361	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	362	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	363	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	364	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	365	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	366	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	367	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	368	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	369	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	370	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	371	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	372	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	373	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	374	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	375	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	376	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	377	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	378	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	379	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	380	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	381	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	382	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	383	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	384	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	385	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	386	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	387	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	388	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	389	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	390	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	391	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	392	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	393	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	394	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	395	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	396	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	397	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	398	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	399	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	400	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	401	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	402	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	403	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	404	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	405	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	406	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	407	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	408	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	409	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	410	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	411	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	412	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	413	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	414	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	415	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	416	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	417	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	418	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	419	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	420	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	421	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	422	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	423	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	424	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	425	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	426	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	427	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	428	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	429	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	430	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	431	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	432	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	433	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	434	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	435	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	436	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	437	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	438	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	439	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	440	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	441	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	442	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	443	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	444	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	445	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	446	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	447	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	448	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	449	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	450	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	451	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	452	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	453	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	454	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	455	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	456	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	457	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	458	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	459	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	460	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	461	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	462	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	463	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	464	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	465	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	466	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	467	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	468	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	469	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	470	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	471	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	472	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	473	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	474	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	475	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	476	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	477	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	478	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	479	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	480	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	481	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	482	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	483	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	484	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	485	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	486	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	487	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	488	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	489	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	490	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	491	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	492	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	493	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	494	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	495	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	496	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	497	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	498	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	499	, NULL);
INSERT INTO "test" ("num", "the_geom") VALUES (	500	, NULL);

