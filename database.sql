--
-- PostgreSQL database dump
--

\restrict cah18lSosyGrrq67nMd52rBvkuZ2ynCxoAvqTtspqT0mcB3UDniyBSr8uhBU3co

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

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

--
-- Name: address; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.address AS (
	street character varying(100),
	city character varying(50)
);


ALTER TYPE public.address OWNER TO postgres;

--
-- Name: contactinformation; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.contactinformation AS (
	email character varying(100),
	phone character varying(20)
);


ALTER TYPE public.contactinformation OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: academicevent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.academicevent (
    eventid integer NOT NULL,
    eventname character varying(150) NOT NULL,
    spaceid integer NOT NULL,
    eventdate date NOT NULL,
    CONSTRAINT academicevent_eventdate_check CHECK ((eventdate >= CURRENT_DATE))
);


ALTER TABLE public.academicevent OWNER TO postgres;

--
-- Name: academicevent_eventid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.academicevent_eventid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.academicevent_eventid_seq OWNER TO postgres;

--
-- Name: academicevent_eventid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.academicevent_eventid_seq OWNED BY public.academicevent.eventid;


--
-- Name: academicspace; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.academicspace (
    spaceid integer NOT NULL,
    roomnumber character varying(20) NOT NULL,
    capacity integer NOT NULL,
    spacetype character varying(20) NOT NULL,
    CONSTRAINT academicspace_capacity_check CHECK ((capacity > 0)),
    CONSTRAINT academicspace_spacetype_check CHECK (((spacetype)::text = ANY ((ARRAY['Classroom'::character varying, 'Laboratory'::character varying])::text[])))
);


ALTER TABLE public.academicspace OWNER TO postgres;

--
-- Name: academicspace_spaceid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.academicspace_spaceid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.academicspace_spaceid_seq OWNER TO postgres;

--
-- Name: academicspace_spaceid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.academicspace_spaceid_seq OWNED BY public.academicspace.spaceid;


--
-- Name: attendancelog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendancelog (
    attendanceid integer NOT NULL,
    sessionid integer NOT NULL,
    studentid integer NOT NULL,
    attendancedate date DEFAULT CURRENT_DATE NOT NULL,
    ispresent boolean DEFAULT true NOT NULL
);


ALTER TABLE public.attendancelog OWNER TO postgres;

--
-- Name: attendancelog_attendanceid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendancelog_attendanceid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendancelog_attendanceid_seq OWNER TO postgres;

--
-- Name: attendancelog_attendanceid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendancelog_attendanceid_seq OWNED BY public.attendancelog.attendanceid;


--
-- Name: course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course (
    courseid integer NOT NULL,
    coursecode character varying(20) NOT NULL,
    coursename character varying(150) NOT NULL,
    credits integer NOT NULL,
    departmentid integer NOT NULL,
    CONSTRAINT course_credits_check CHECK (((credits > 0) AND (credits <= 15)))
);


ALTER TABLE public.course OWNER TO postgres;

--
-- Name: course_courseid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_courseid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_courseid_seq OWNER TO postgres;

--
-- Name: course_courseid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_courseid_seq OWNED BY public.course.courseid;


--
-- Name: courseallocation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courseallocation (
    allocationid integer NOT NULL,
    lecturerid integer NOT NULL,
    courseid integer NOT NULL,
    semester character varying(20) NOT NULL,
    academicyear character varying(9) NOT NULL,
    CONSTRAINT courseallocation_academicyear_check CHECK (((academicyear)::text ~ '^[0-9]{4}/[0-9]{4}$'::text))
);


ALTER TABLE public.courseallocation OWNER TO postgres;

--
-- Name: courseallocation_allocationid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courseallocation_allocationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.courseallocation_allocationid_seq OWNER TO postgres;

--
-- Name: courseallocation_allocationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courseallocation_allocationid_seq OWNED BY public.courseallocation.allocationid;


--
-- Name: coursesession; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coursesession (
    sessionid integer NOT NULL,
    courseid integer NOT NULL,
    spaceid integer NOT NULL,
    weekday character varying(10) NOT NULL,
    starttime time without time zone NOT NULL,
    endtime time without time zone NOT NULL,
    CONSTRAINT chk_time_window CHECK ((endtime > starttime)),
    CONSTRAINT coursesession_weekday_check CHECK (((weekday)::text = ANY ((ARRAY['Monday'::character varying, 'Tuesday'::character varying, 'Wednesday'::character varying, 'Thursday'::character varying, 'Friday'::character varying, 'Saturday'::character varying, 'Sunday'::character varying])::text[])))
);


ALTER TABLE public.coursesession OWNER TO postgres;

--
-- Name: coursesession_sessionid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coursesession_sessionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.coursesession_sessionid_seq OWNER TO postgres;

--
-- Name: coursesession_sessionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coursesession_sessionid_seq OWNED BY public.coursesession.sessionid;


--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    departmentid integer NOT NULL,
    deptname character varying(150) NOT NULL,
    facultyid integer NOT NULL
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: department_departmentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.department_departmentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.department_departmentid_seq OWNER TO postgres;

--
-- Name: department_departmentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_departmentid_seq OWNED BY public.department.departmentid;


--
-- Name: enrollment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollment (
    enrollmentid integer NOT NULL,
    studentid integer NOT NULL,
    courseid integer NOT NULL,
    semester character varying(20) NOT NULL,
    grade numeric(5,2),
    CONSTRAINT enrollment_grade_check CHECK (((grade >= 0.00) AND (grade <= 100.00)))
);


ALTER TABLE public.enrollment OWNER TO postgres;

--
-- Name: enrollment_enrollmentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enrollment_enrollmentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.enrollment_enrollmentid_seq OWNER TO postgres;

--
-- Name: enrollment_enrollmentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enrollment_enrollmentid_seq OWNED BY public.enrollment.enrollmentid;


--
-- Name: eventattendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventattendance (
    eventid integer NOT NULL,
    participantid integer NOT NULL
);


ALTER TABLE public.eventattendance OWNER TO postgres;

--
-- Name: eventparticipant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventparticipant (
    participantid integer NOT NULL,
    personid integer NOT NULL,
    roleinevent character varying(50) NOT NULL,
    CONSTRAINT eventparticipant_roleinevent_check CHECK (((roleinevent)::text = ANY ((ARRAY['Keynote Speaker'::character varying, 'Presenter'::character varying, 'Evaluation Panelist'::character varying, 'Attendee'::character varying])::text[])))
);


ALTER TABLE public.eventparticipant OWNER TO postgres;

--
-- Name: eventparticipant_participantid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eventparticipant_participantid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eventparticipant_participantid_seq OWNER TO postgres;

--
-- Name: eventparticipant_participantid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.eventparticipant_participantid_seq OWNED BY public.eventparticipant.participantid;


--
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty (
    facultyid integer NOT NULL,
    facultyname character varying(150) NOT NULL,
    deanname character varying(100) NOT NULL
);


ALTER TABLE public.faculty OWNER TO postgres;

--
-- Name: faculty_facultyid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_facultyid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_facultyid_seq OWNER TO postgres;

--
-- Name: faculty_facultyid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_facultyid_seq OWNED BY public.faculty.facultyid;


--
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    personid integer NOT NULL,
    fullname character varying(100) NOT NULL,
    homeaddress public.address,
    contact public.contactinformation,
    phonenumbers character varying(20)[]
);


ALTER TABLE public.person OWNER TO postgres;

--
-- Name: person_personid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_personid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.person_personid_seq OWNER TO postgres;

--
-- Name: person_personid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_personid_seq OWNED BY public.person.personid;


--
-- Name: lecturer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lecturer (
    personid integer DEFAULT nextval('public.person_personid_seq'::regclass),
    employeeid character varying(20) NOT NULL,
    academicrank character varying(50) NOT NULL,
    primarydeptid integer NOT NULL,
    CONSTRAINT lecturer_academicrank_check CHECK (((academicrank)::text = ANY ((ARRAY['Tutorial Assistant'::character varying, 'Assistant Lecturer'::character varying, 'Lecturer'::character varying, 'Senior Lecturer'::character varying, 'Associate Professor'::character varying, 'Professor'::character varying])::text[])))
)
INHERITS (public.person);


ALTER TABLE public.lecturer OWNER TO postgres;

--
-- Name: projectsupervision; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projectsupervision (
    supervisionid integer NOT NULL,
    lecturerid integer NOT NULL,
    studentid integer NOT NULL,
    projectid integer NOT NULL,
    startdate date DEFAULT CURRENT_DATE NOT NULL,
    isactive boolean DEFAULT true
);


ALTER TABLE public.projectsupervision OWNER TO postgres;

--
-- Name: projectsupervision_supervisionid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projectsupervision_supervisionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projectsupervision_supervisionid_seq OWNER TO postgres;

--
-- Name: projectsupervision_supervisionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projectsupervision_supervisionid_seq OWNED BY public.projectsupervision.supervisionid;


--
-- Name: researchproject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.researchproject (
    projectid integer NOT NULL,
    title character varying(250) NOT NULL,
    metadata jsonb NOT NULL
);


ALTER TABLE public.researchproject OWNER TO postgres;

--
-- Name: researchproject_projectid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.researchproject_projectid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.researchproject_projectid_seq OWNER TO postgres;

--
-- Name: researchproject_projectid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.researchproject_projectid_seq OWNED BY public.researchproject.projectid;


--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    personid integer DEFAULT nextval('public.person_personid_seq'::regclass),
    studentid character varying(20) NOT NULL,
    enrollmentdate date DEFAULT CURRENT_DATE NOT NULL,
    majordeptid integer NOT NULL
)
INHERITS (public.person);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: academicevent eventid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academicevent ALTER COLUMN eventid SET DEFAULT nextval('public.academicevent_eventid_seq'::regclass);


--
-- Name: academicspace spaceid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academicspace ALTER COLUMN spaceid SET DEFAULT nextval('public.academicspace_spaceid_seq'::regclass);


--
-- Name: attendancelog attendanceid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendancelog ALTER COLUMN attendanceid SET DEFAULT nextval('public.attendancelog_attendanceid_seq'::regclass);


--
-- Name: course courseid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course ALTER COLUMN courseid SET DEFAULT nextval('public.course_courseid_seq'::regclass);


--
-- Name: courseallocation allocationid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courseallocation ALTER COLUMN allocationid SET DEFAULT nextval('public.courseallocation_allocationid_seq'::regclass);


--
-- Name: coursesession sessionid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursesession ALTER COLUMN sessionid SET DEFAULT nextval('public.coursesession_sessionid_seq'::regclass);


--
-- Name: department departmentid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department ALTER COLUMN departmentid SET DEFAULT nextval('public.department_departmentid_seq'::regclass);


--
-- Name: enrollment enrollmentid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment ALTER COLUMN enrollmentid SET DEFAULT nextval('public.enrollment_enrollmentid_seq'::regclass);


--
-- Name: eventparticipant participantid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventparticipant ALTER COLUMN participantid SET DEFAULT nextval('public.eventparticipant_participantid_seq'::regclass);


--
-- Name: faculty facultyid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty ALTER COLUMN facultyid SET DEFAULT nextval('public.faculty_facultyid_seq'::regclass);


--
-- Name: person personid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person ALTER COLUMN personid SET DEFAULT nextval('public.person_personid_seq'::regclass);


--
-- Name: projectsupervision supervisionid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projectsupervision ALTER COLUMN supervisionid SET DEFAULT nextval('public.projectsupervision_supervisionid_seq'::regclass);


--
-- Name: researchproject projectid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.researchproject ALTER COLUMN projectid SET DEFAULT nextval('public.researchproject_projectid_seq'::regclass);


--
-- Data for Name: academicevent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.academicevent (eventid, eventname, spaceid, eventdate) FROM stdin;
1	Annual Science and Technology Symposium 2026	7	2026-07-15
2	Business Innovation and Entrepreneurship Forum	7	2026-08-10
3	Law and Governance Conference	3	2026-08-20
4	ICT Research Day	1	2026-09-05
5	Mental Health Awareness Workshop	5	2026-09-12
6	Environment and Sustainable Development Summit	7	2026-09-25
7	Education and Pedagogy Colloquium	4	2026-10-08
8	ULK Annual Research Dissemination Day	7	2026-10-20
\.


--
-- Data for Name: academicspace; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.academicspace (spaceid, roomnumber, capacity, spacetype) FROM stdin;
1	A101	60	Classroom
2	A102	60	Classroom
3	A201	80	Classroom
4	A202	80	Classroom
5	B101	40	Classroom
6	B102	40	Classroom
7	B201	100	Classroom
8	C101	30	Laboratory
9	C102	30	Laboratory
10	C201	25	Laboratory
11	C202	25	Laboratory
12	D101	50	Classroom
\.


--
-- Data for Name: attendancelog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendancelog (attendanceid, sessionid, studentid, attendancedate, ispresent) FROM stdin;
1	1	21	2025-02-03	t
2	1	22	2025-02-03	t
3	1	23	2025-02-03	f
4	1	36	2025-02-03	t
5	1	51	2025-02-03	t
6	2	21	2025-02-04	t
7	2	22	2025-02-04	f
8	2	66	2025-02-04	t
9	2	65	2025-02-04	t
10	3	21	2025-02-05	t
11	3	35	2025-02-05	t
12	3	51	2025-02-05	f
13	4	22	2025-02-06	t
14	4	36	2025-02-06	t
15	5	37	2025-02-07	t
16	5	52	2025-02-07	f
17	6	22	2025-02-10	t
18	6	37	2025-02-10	t
19	7	38	2025-02-11	f
20	7	53	2025-02-11	t
21	8	38	2025-02-12	t
22	8	53	2025-02-12	t
23	9	23	2025-02-13	t
24	9	39	2025-02-13	f
25	10	39	2025-02-14	t
26	10	54	2025-02-14	t
27	11	24	2025-02-17	t
28	11	40	2025-02-17	f
29	11	55	2025-02-17	t
30	12	24	2025-02-18	t
31	12	40	2025-02-18	t
32	13	25	2025-02-19	t
33	13	41	2025-02-19	t
34	14	25	2025-02-20	f
35	14	56	2025-02-20	t
36	15	25	2025-02-21	t
37	15	42	2025-02-21	t
38	16	26	2025-02-24	t
39	16	57	2025-02-24	f
40	17	26	2025-02-25	t
41	17	43	2025-02-25	t
42	18	27	2025-02-26	t
43	18	43	2025-02-26	f
44	19	27	2025-02-27	t
45	19	44	2025-02-27	t
46	20	28	2025-03-03	t
47	20	44	2025-03-03	t
48	21	28	2025-03-04	f
49	21	60	2025-03-04	t
50	22	29	2025-03-05	t
51	22	45	2025-03-05	t
52	23	29	2025-03-06	t
53	23	61	2025-03-06	f
54	24	30	2025-03-07	t
55	24	46	2025-03-07	t
56	25	30	2025-03-10	t
57	25	47	2025-03-10	f
58	26	31	2025-03-11	t
59	26	62	2025-03-11	t
\.


--
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course (courseid, coursecode, coursename, credits, departmentid) FROM stdin;
1	CS101	Introduction to Computer Science	3	1
2	CS201	Data Structures and Algorithms	4	1
3	CS301	Database Management Systems	4	1
4	CS401	Artificial Intelligence	4	1
5	CS402	Machine Learning	4	1
6	IT101	Networking Fundamentals	3	2
7	IT201	Cybersecurity Essentials	3	2
8	IT301	Cloud Computing	3	2
9	SE101	Software Engineering Principles	3	3
10	SE201	Agile and Scrum Methodology	3	3
11	CE101	Mechanics of Materials	4	4
12	CE201	Structural Analysis	4	4
13	BA101	Principles of Management	3	5
14	BA201	Marketing Management	3	5
15	BA301	Entrepreneurship and Innovation	3	5
16	AF101	Financial Accounting	4	6
17	AF201	Managerial Accounting	4	6
18	EC101	Microeconomics	3	7
19	EC201	Macroeconomics	3	7
20	SO101	Introduction to Sociology	3	8
21	SO201	Social Research Methods	3	8
22	PS101	General Psychology	3	9
23	PS201	Developmental Psychology	3	9
24	CM101	Introduction to Communication	3	10
25	CM201	Digital Media and Society	3	10
26	LW101	Introduction to Law	4	11
27	LW201	Constitutional Law	4	11
28	PA101	Public Administration Fundamentals	3	12
29	ED101	Foundations of Education	3	13
30	EN101	Academic Writing in English	3	14
\.


--
-- Data for Name: courseallocation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courseallocation (allocationid, lecturerid, courseid, semester, academicyear) FROM stdin;
1	1	1	Semester 1	2024/2025
2	2	2	Semester 1	2024/2025
3	3	3	Semester 1	2024/2025
4	1	4	Semester 2	2024/2025
5	16	5	Semester 2	2024/2025
6	2	6	Semester 1	2024/2025
7	17	7	Semester 1	2024/2025
8	2	8	Semester 2	2024/2025
9	3	9	Semester 1	2024/2025
10	18	10	Semester 2	2024/2025
11	4	11	Semester 1	2024/2025
12	19	12	Semester 2	2024/2025
13	5	13	Semester 1	2024/2025
14	5	14	Semester 2	2024/2025
15	5	15	Semester 2	2024/2025
16	6	16	Semester 1	2024/2025
17	6	17	Semester 2	2024/2025
18	7	18	Semester 1	2024/2025
19	7	19	Semester 2	2024/2025
20	8	20	Semester 1	2024/2025
21	8	21	Semester 2	2024/2025
22	9	22	Semester 1	2024/2025
23	9	23	Semester 2	2024/2025
24	10	24	Semester 1	2024/2025
25	10	25	Semester 2	2024/2025
26	11	26	Semester 1	2024/2025
27	11	27	Semester 2	2024/2025
28	12	28	Semester 1	2024/2025
29	13	29	Semester 1	2024/2025
30	14	30	Semester 1	2024/2025
\.


--
-- Data for Name: coursesession; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coursesession (sessionid, courseid, spaceid, weekday, starttime, endtime) FROM stdin;
1	1	1	Monday	08:00:00	10:00:00
2	2	2	Tuesday	08:00:00	10:00:00
3	3	3	Wednesday	10:00:00	12:00:00
4	4	1	Thursday	08:00:00	10:00:00
5	5	2	Friday	08:00:00	10:00:00
6	6	4	Monday	10:00:00	12:00:00
7	7	4	Tuesday	10:00:00	12:00:00
8	8	5	Wednesday	08:00:00	10:00:00
9	9	6	Thursday	10:00:00	12:00:00
10	10	6	Friday	10:00:00	12:00:00
11	11	7	Monday	14:00:00	16:00:00
12	12	7	Tuesday	14:00:00	16:00:00
13	13	1	Wednesday	14:00:00	16:00:00
14	14	2	Thursday	14:00:00	16:00:00
15	15	3	Friday	14:00:00	16:00:00
16	16	8	Monday	08:00:00	10:00:00
17	17	8	Tuesday	10:00:00	12:00:00
18	18	9	Wednesday	08:00:00	10:00:00
19	19	9	Thursday	08:00:00	10:00:00
20	20	5	Monday	16:00:00	18:00:00
21	21	5	Tuesday	16:00:00	18:00:00
22	22	6	Wednesday	16:00:00	18:00:00
23	23	7	Thursday	16:00:00	18:00:00
24	24	10	Friday	08:00:00	10:00:00
25	25	10	Monday	12:00:00	14:00:00
26	26	11	Tuesday	12:00:00	14:00:00
27	27	11	Wednesday	12:00:00	14:00:00
28	28	12	Thursday	12:00:00	14:00:00
29	29	12	Friday	12:00:00	14:00:00
30	30	3	Saturday	08:00:00	10:00:00
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.department (departmentid, deptname, facultyid) FROM stdin;
1	Computer Science	1
2	Information Technology	1
3	Software Engineering	1
4	Civil Engineering	1
5	Business Administration	2
6	Accounting and Finance	2
7	Economics	2
8	Sociology	3
9	Psychology	3
10	Communication and Media	3
11	Law	4
12	Public Administration	4
13	Education	5
14	English Language and Literature	5
15	French Language and Literature	5
\.


--
-- Data for Name: enrollment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enrollment (enrollmentid, studentid, courseid, semester, grade) FROM stdin;
1	21	1	Semester 1	72.50
2	21	2	Semester 1	68.00
3	21	3	Semester 1	80.00
4	22	1	Semester 1	65.00
5	22	4	Semester 2	78.50
6	22	6	Semester 1	71.00
7	23	1	Semester 1	55.50
8	23	2	Semester 1	60.00
9	23	9	Semester 1	74.00
10	24	11	Semester 1	82.00
11	24	12	Semester 2	79.00
12	25	13	Semester 1	88.00
13	25	14	Semester 2	91.00
14	25	15	Semester 2	85.50
15	26	16	Semester 1	70.00
16	26	17	Semester 2	66.50
17	27	18	Semester 1	63.00
18	27	19	Semester 2	59.00
19	28	20	Semester 1	77.00
20	28	21	Semester 2	75.00
21	29	22	Semester 1	81.50
22	29	23	Semester 2	78.00
23	30	24	Semester 1	69.00
24	30	25	Semester 2	72.50
25	31	26	Semester 1	84.00
26	31	27	Semester 2	87.00
27	32	28	Semester 1	76.50
28	33	29	Semester 1	73.00
29	34	30	Semester 1	67.00
30	35	1	Semester 1	90.00
31	35	3	Semester 1	88.00
32	36	2	Semester 1	74.00
33	36	4	Semester 2	70.00
34	37	5	Semester 2	83.00
35	37	6	Semester 1	77.50
36	38	7	Semester 1	62.00
37	38	8	Semester 2	65.00
38	39	9	Semester 1	78.00
39	39	10	Semester 2	80.00
40	40	11	Semester 1	56.00
41	40	12	Semester 2	61.50
42	41	13	Semester 1	92.00
43	41	14	Semester 2	89.00
44	42	15	Semester 2	76.00
45	42	16	Semester 1	71.50
46	43	17	Semester 2	68.00
47	43	18	Semester 1	64.00
48	44	19	Semester 2	85.50
49	44	20	Semester 1	82.00
50	45	21	Semester 2	74.50
51	45	22	Semester 1	79.00
52	46	23	Semester 2	66.00
53	46	24	Semester 1	70.50
54	47	25	Semester 2	88.50
55	47	26	Semester 1	93.00
56	48	27	Semester 2	77.00
57	48	28	Semester 1	73.50
58	49	29	Semester 1	69.00
59	49	30	Semester 1	75.00
60	50	1	Semester 1	58.00
61	50	2	Semester 1	62.50
62	51	3	Semester 1	84.00
63	51	4	Semester 2	87.50
64	52	5	Semester 2	79.00
65	52	6	Semester 1	72.00
66	53	7	Semester 1	65.50
67	53	8	Semester 2	69.00
68	54	9	Semester 1	91.00
69	54	10	Semester 2	88.00
70	55	11	Semester 1	76.00
71	55	12	Semester 2	80.50
72	56	13	Semester 1	83.00
73	56	14	Semester 2	86.00
74	57	15	Semester 2	70.00
75	57	16	Semester 1	67.50
76	58	17	Semester 2	73.00
77	58	18	Semester 1	78.50
78	59	19	Semester 2	61.00
79	59	20	Semester 1	64.50
80	60	21	Semester 2	95.00
81	60	22	Semester 1	92.50
82	61	23	Semester 2	80.00
83	61	24	Semester 1	77.00
84	62	25	Semester 2	74.00
85	62	26	Semester 1	71.50
86	63	27	Semester 2	68.50
87	63	28	Semester 1	65.00
88	64	29	Semester 1	89.00
89	64	30	Semester 1	85.50
90	65	1	Semester 1	76.00
91	65	2	Semester 1	79.50
92	66	3	Semester 1	82.00
93	66	4	Semester 2	78.00
94	67	5	Semester 2	71.00
95	67	6	Semester 1	74.50
96	68	7	Semester 1	67.00
97	68	8	Semester 2	63.50
98	69	9	Semester 1	88.00
99	69	10	Semester 2	84.00
100	70	11	Semester 1	57.00
101	70	12	Semester 2	60.50
102	111	1	Semester 1	\N
103	111	2	Semester 1	\N
104	112	6	Semester 1	\N
105	112	7	Semester 1	\N
106	113	9	Semester 1	\N
107	113	10	Semester 2	\N
108	114	11	Semester 1	\N
109	115	13	Semester 1	\N
110	115	14	Semester 2	\N
111	116	18	Semester 1	\N
112	117	22	Semester 1	\N
113	118	24	Semester 1	\N
114	119	26	Semester 1	\N
115	120	29	Semester 1	\N
\.


--
-- Data for Name: eventattendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eventattendance (eventid, participantid) FROM stdin;
1	1
1	2
1	11
1	12
1	13
2	3
2	4
2	14
2	15
3	5
3	6
3	16
4	1
4	7
4	11
4	17
4	18
5	9
5	10
5	19
5	20
6	2
6	8
6	13
8	3
8	6
\.


--
-- Data for Name: eventparticipant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eventparticipant (participantid, personid, roleinevent) FROM stdin;
1	1	Keynote Speaker
2	2	Presenter
3	3	Keynote Speaker
4	4	Presenter
5	5	Evaluation Panelist
6	6	Keynote Speaker
7	7	Presenter
8	8	Evaluation Panelist
9	9	Presenter
10	10	Evaluation Panelist
11	21	Presenter
12	22	Presenter
13	23	Attendee
14	24	Attendee
15	25	Presenter
16	26	Attendee
17	27	Attendee
18	28	Presenter
19	29	Attendee
20	30	Attendee
\.


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty (facultyid, facultyname, deanname) FROM stdin;
1	Faculty of Science and Technology	Prof. Jean-Pierre Habimana
2	Faculty of Business and Economics	Prof. Marie-Claire Uwimana
3	Faculty of Social Sciences	Dr. Emmanuel Nkurunziza
4	Faculty of Law and Governance	Prof. Diane Mukamana
5	Faculty of Education and Humanities	Dr. Claude Ndayishimiye
\.


--
-- Data for Name: lecturer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lecturer (personid, fullname, homeaddress, contact, phonenumbers, employeeid, academicrank, primarydeptid) FROM stdin;
1	Dr. Alice Uwase	("KG 12 Ave",Kigali)	(alice.uwase@ulk.ac.rw,+250788100001)	{+250788100001}	EMP001	Senior Lecturer	1
2	Dr. Bernard Nzeyimana	("KN 5 St",Kigali)	(bernard.nzeyimana@ulk.ac.rw,+250788100002)	{+250788100002}	EMP002	Lecturer	2
3	Prof. Christine Ingabire	("KG 34 Ave",Kigali)	(c.ingabire@ulk.ac.rw,+250788100003)	{+250788100003,+250722100003}	EMP003	Professor	3
4	Dr. David Hakizimana	("KN 17 St",Kigali)	(d.hakizimana@ulk.ac.rw,+250788100004)	{+250788100004}	EMP004	Lecturer	4
5	Dr. Esther Mukandori	("KG 56 Ave",Kigali)	(e.mukandori@ulk.ac.rw,+250788100005)	{+250788100005}	EMP005	Assistant Lecturer	5
6	Prof. François Nsengimana	("KN 8 St",Kigali)	(f.nsengimana@ulk.ac.rw,+250788100006)	{+250788100006,+250722100006}	EMP006	Professor	6
7	Dr. Grace Uwimana	("KG 22 Ave",Kigali)	(g.uwimana@ulk.ac.rw,+250788100007)	{+250788100007}	EMP007	Senior Lecturer	7
8	Dr. Henri Bizimana	("KN 3 St",Kigali)	(h.bizimana@ulk.ac.rw,+250788100008)	{+250788100008}	EMP008	Lecturer	8
9	Dr. Irène Mukamurenzi	("KG 45 Ave",Kigali)	(i.mukamurenzi@ulk.ac.rw,+250788100009)	{+250788100009}	EMP009	Associate Professor	9
10	Dr. Jacques Ndikumana	("KN 29 St",Kigali)	(j.ndikumana@ulk.ac.rw,+250788100010)	{+250788100010}	EMP010	Lecturer	10
11	Prof. Keza Uwera	("KG 67 Ave",Kigali)	(k.uwera@ulk.ac.rw,+250788100011)	{+250788100011,+250722100011}	EMP011	Professor	11
12	Dr. Léon Habimana	("KN 41 St",Kigali)	(l.habimana@ulk.ac.rw,+250788100012)	{+250788100012}	EMP012	Senior Lecturer	12
13	Dr. Marie Nyirahabimana	("KG 78 Ave",Kigali)	(m.nyirahabimana@ulk.ac.rw,+250788100013)	{+250788100013}	EMP013	Lecturer	13
14	Dr. Nicolas Nkurunziza	("KN 55 St",Kigali)	(n.nkurunziza@ulk.ac.rw,+250788100014)	{+250788100014}	EMP014	Lecturer	14
15	Dr. Olive Mukashema	("KG 89 Ave",Kigali)	(o.mukashema@ulk.ac.rw,+250788100015)	{+250788100015}	EMP015	Assistant Lecturer	15
16	Prof. Paul Rubayiza	("KN 63 St",Kigali)	(p.rubayiza@ulk.ac.rw,+250788100016)	{+250788100016,+250722100016}	EMP016	Professor	1
17	Dr. Queen Mutesi	("KG 90 Ave",Kigali)	(q.mutesi@ulk.ac.rw,+250788100017)	{+250788100017}	EMP017	Tutorial Assistant	2
18	Dr. Robert Tuyishime	("KN 74 St",Kigali)	(r.tuyishime@ulk.ac.rw,+250788100018)	{+250788100018}	EMP018	Lecturer	3
19	Dr. Suzanne Iradukunda	("KG 11 Ave",Kigali)	(s.iradukunda@ulk.ac.rw,+250788100019)	{+250788100019}	EMP019	Senior Lecturer	4
20	Prof. Thomas Karangwa	("KN 82 St",Kigali)	(t.karangwa@ulk.ac.rw,+250788100020)	{+250788100020,+250722100020}	EMP020	Associate Professor	5
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person (personid, fullname, homeaddress, contact, phonenumbers) FROM stdin;
1	Dr. Alice Uwase	("KG 12 Ave",Kigali)	(alice.uwase@ulk.ac.rw,+250788100001)	{+250788100001}
2	Dr. Bernard Nzeyimana	("KN 5 St",Kigali)	(bernard.nzeyimana@ulk.ac.rw,+250788100002)	{+250788100002}
3	Prof. Christine Ingabire	("KG 34 Ave",Kigali)	(c.ingabire@ulk.ac.rw,+250788100003)	{+250788100003,+250722100003}
4	Dr. David Hakizimana	("KN 17 St",Kigali)	(d.hakizimana@ulk.ac.rw,+250788100004)	{+250788100004}
5	Dr. Esther Mukandori	("KG 56 Ave",Kigali)	(e.mukandori@ulk.ac.rw,+250788100005)	{+250788100005}
6	Prof. François Nsengimana	("KN 8 St",Kigali)	(f.nsengimana@ulk.ac.rw,+250788100006)	{+250788100006,+250722100006}
7	Dr. Grace Uwimana	("KG 22 Ave",Kigali)	(g.uwimana@ulk.ac.rw,+250788100007)	{+250788100007}
8	Dr. Henri Bizimana	("KN 3 St",Kigali)	(h.bizimana@ulk.ac.rw,+250788100008)	{+250788100008}
9	Dr. Irène Mukamurenzi	("KG 45 Ave",Kigali)	(i.mukamurenzi@ulk.ac.rw,+250788100009)	{+250788100009}
10	Dr. Jacques Ndikumana	("KN 29 St",Kigali)	(j.ndikumana@ulk.ac.rw,+250788100010)	{+250788100010}
11	Prof. Keza Uwera	("KG 67 Ave",Kigali)	(k.uwera@ulk.ac.rw,+250788100011)	{+250788100011,+250722100011}
12	Dr. Léon Habimana	("KN 41 St",Kigali)	(l.habimana@ulk.ac.rw,+250788100012)	{+250788100012}
13	Dr. Marie Nyirahabimana	("KG 78 Ave",Kigali)	(m.nyirahabimana@ulk.ac.rw,+250788100013)	{+250788100013}
14	Dr. Nicolas Nkurunziza	("KN 55 St",Kigali)	(n.nkurunziza@ulk.ac.rw,+250788100014)	{+250788100014}
15	Dr. Olive Mukashema	("KG 89 Ave",Kigali)	(o.mukashema@ulk.ac.rw,+250788100015)	{+250788100015}
16	Prof. Paul Rubayiza	("KN 63 St",Kigali)	(p.rubayiza@ulk.ac.rw,+250788100016)	{+250788100016,+250722100016}
17	Dr. Queen Mutesi	("KG 90 Ave",Kigali)	(q.mutesi@ulk.ac.rw,+250788100017)	{+250788100017}
18	Dr. Robert Tuyishime	("KN 74 St",Kigali)	(r.tuyishime@ulk.ac.rw,+250788100018)	{+250788100018}
19	Dr. Suzanne Iradukunda	("KG 11 Ave",Kigali)	(s.iradukunda@ulk.ac.rw,+250788100019)	{+250788100019}
20	Prof. Thomas Karangwa	("KN 82 St",Kigali)	(t.karangwa@ulk.ac.rw,+250788100020)	{+250788100020,+250722100020}
21	Amina Nkurunziza	("KG 101 St",Kigali)	(amina.nkurunziza@student.ulk.ac.rw,+250788200001)	{+250788200001}
22	Brian Habimana	("KN 22 Ave",Kigali)	(brian.habimana@student.ulk.ac.rw,+250788200002)	{+250788200002}
23	Claudine Mukamana	("KG 33 St",Kigali)	(claudine.mukamana@student.ulk.ac.rw,+250788200003)	{+250788200003}
24	Denis Niyonzima	("KN 44 Ave",Kigali)	(denis.niyonzima@student.ulk.ac.rw,+250788200004)	{+250788200004}
25	Elise Uwera	("KG 55 St",Kigali)	(elise.uwera@student.ulk.ac.rw,+250788200005)	{+250788200005}
26	Fabrice Tuyishime	("KN 66 Ave",Kigali)	(fabrice.tuyishime@student.ulk.ac.rw,+250788200006)	{+250788200006}
27	Gorette Iradukunda	("KG 77 St",Kigali)	(gorette.iradukunda@student.ulk.ac.rw,+250788200007)	{+250788200007}
28	Hervé Ndayishimiye	("KN 88 Ave",Kigali)	(herve.ndayishimiye@student.ulk.ac.rw,+250788200008)	{+250788200008}
29	Isabelle Mutesi	("KG 99 St",Kigali)	(isabelle.mutesi@student.ulk.ac.rw,+250788200009)	{+250788200009}
30	Jean-Paul Bizimana	("KN 10 Ave",Kigali)	(jeanpaul.bizimana@student.ulk.ac.rw,+250788200010)	{+250788200010}
31	Karine Mukashema	("KG 111 St",Kigali)	(karine.mukashema@student.ulk.ac.rw,+250788200011)	{+250788200011}
32	Lionel Nsengimana	("KN 121 Ave",Kigali)	(lionel.nsengimana@student.ulk.ac.rw,+250788200012)	{+250788200012}
33	Martine Nyirahabimana	("KG 132 St",Kigali)	(martine.n@student.ulk.ac.rw,+250788200013)	{+250788200013}
34	Nathan Rubayiza	("KN 142 Ave",Kigali)	(nathan.rubayiza@student.ulk.ac.rw,+250788200014)	{+250788200014}
35	Odette Karangwa	("KG 153 St",Kigali)	(odette.karangwa@student.ulk.ac.rw,+250788200015)	{+250788200015}
36	Patrick Uwimana	("KN 163 Ave",Kigali)	(patrick.uwimana@student.ulk.ac.rw,+250788200016)	{+250788200016}
37	Quirine Ingabire	("KG 174 St",Kigali)	(quirine.ingabire@student.ulk.ac.rw,+250788200017)	{+250788200017}
38	Remy Hakizimana	("KN 184 Ave",Kigali)	(remy.hakizimana@student.ulk.ac.rw,+250788200018)	{+250788200018}
39	Sandra Ndikumana	("KG 195 St",Kigali)	(sandra.ndikumana@student.ulk.ac.rw,+250788200019)	{+250788200019}
40	Thierry Mukamurenzi	("KN 205 Ave",Kigali)	(thierry.mukamurenzi@student.ulk.ac.rw,+250788200020)	{+250788200020}
41	Ursule Nkurunziza	("KG 216 St",Kigali)	(ursule.nkurunziza@student.ulk.ac.rw,+250788200021)	{+250788200021}
42	Victor Habimana	("KN 226 Ave",Kigali)	(victor.habimana@student.ulk.ac.rw,+250788200022)	{+250788200022}
43	Wanjiru Mukamana	("KG 237 St",Kigali)	(wanjiru.mukamana@student.ulk.ac.rw,+250788200023)	{+250788200023}
44	Xavier Niyonzima	("KN 247 Ave",Kigali)	(xavier.niyonzima@student.ulk.ac.rw,+250788200024)	{+250788200024}
45	Yvette Uwera	("KG 258 St",Kigali)	(yvette.uwera@student.ulk.ac.rw,+250788200025)	{+250788200025}
46	Zacharie Tuyishime	("KN 268 Ave",Kigali)	(zacharie.tuyishime@student.ulk.ac.rw,+250788200026)	{+250788200026}
47	Adèle Iradukunda	("KG 279 St",Kigali)	(adele.iradukunda@student.ulk.ac.rw,+250788200027)	{+250788200027}
48	Benjamin Ndayishimiye	("KN 289 Ave",Kigali)	(benjamin.n@student.ulk.ac.rw,+250788200028)	{+250788200028}
49	Cécile Mutesi	("KG 290 St",Kigali)	(cecile.mutesi@student.ulk.ac.rw,+250788200029)	{+250788200029}
50	Didier Bizimana	("KN 301 Ave",Kigali)	(didier.bizimana@student.ulk.ac.rw,+250788200030)	{+250788200030}
51	Esperance Mukashema	("KG 311 St",Kigali)	(esperance.m@student.ulk.ac.rw,+250788200031)	{+250788200031}
52	Félicien Nsengimana	("KN 321 Ave",Kigali)	(felicien.n@student.ulk.ac.rw,+250788200032)	{+250788200032}
53	Gisèle Nyirahabimana	("KG 332 St",Kigali)	(gisele.n@student.ulk.ac.rw,+250788200033)	{+250788200033}
54	Hubert Rubayiza	("KN 342 Ave",Kigali)	(hubert.rubayiza@student.ulk.ac.rw,+250788200034)	{+250788200034}
55	Immaculée Karangwa	("KG 353 St",Kigali)	(immaculee.k@student.ulk.ac.rw,+250788200035)	{+250788200035}
56	Jules Uwimana	("KN 363 Ave",Kigali)	(jules.uwimana@student.ulk.ac.rw,+250788200036)	{+250788200036}
57	Kenza Ingabire	("KG 374 St",Kigali)	(kenza.ingabire@student.ulk.ac.rw,+250788200037)	{+250788200037}
58	Landry Hakizimana	("KN 384 Ave",Kigali)	(landry.h@student.ulk.ac.rw,+250788200038)	{+250788200038}
59	Mireille Ndikumana	("KG 395 St",Kigali)	(mireille.n@student.ulk.ac.rw,+250788200039)	{+250788200039}
60	Noël Mukamurenzi	("KN 405 Ave",Kigali)	(noel.m@student.ulk.ac.rw,+250788200040)	{+250788200040}
61	Odile Nkurunziza	("KG 416 St",Kigali)	(odile.nkurunziza@student.ulk.ac.rw,+250788200041)	{+250788200041}
62	Pierre Habimana	("KN 426 Ave",Kigali)	(pierre.habimana@student.ulk.ac.rw,+250788200042)	{+250788200042}
63	Rachel Mukamana	("KG 437 St",Kigali)	(rachel.mukamana@student.ulk.ac.rw,+250788200043)	{+250788200043}
64	Samuel Niyonzima	("KN 447 Ave",Kigali)	(samuel.n@student.ulk.ac.rw,+250788200044)	{+250788200044}
65	Trésor Uwera	("KG 458 St",Kigali)	(tresor.uwera@student.ulk.ac.rw,+250788200045)	{+250788200045}
66	Uria Tuyishime	("KN 468 Ave",Kigali)	(uria.tuyishime@student.ulk.ac.rw,+250788200046)	{+250788200046}
67	Vanessa Iradukunda	("KG 479 St",Kigali)	(vanessa.i@student.ulk.ac.rw,+250788200047)	{+250788200047}
68	Wilfried Ndayishimiye	("KN 489 Ave",Kigali)	(wilfried.n@student.ulk.ac.rw,+250788200048)	{+250788200048}
69	Xavière Mutesi	("KG 490 St",Kigali)	(xaviere.mutesi@student.ulk.ac.rw,+250788200049)	{+250788200049}
70	Yannick Bizimana	("KN 501 Ave",Kigali)	(yannick.bizimana@student.ulk.ac.rw,+250788200050)	{+250788200050}
71	Zita Mukashema	("KG 511 St",Kigali)	(zita.mukashema@student.ulk.ac.rw,+250788200051)	{+250788200051}
72	Alexis Nsengimana	("KN 521 Ave",Kigali)	(alexis.n@student.ulk.ac.rw,+250788200052)	{+250788200052}
73	Beatrice Nyirahabimana	("KG 532 St",Kigali)	(beatrice.n@student.ulk.ac.rw,+250788200053)	{+250788200053}
74	Cyrus Rubayiza	("KN 542 Ave",Kigali)	(cyrus.rubayiza@student.ulk.ac.rw,+250788200054)	{+250788200054}
75	Delphine Karangwa	("KG 553 St",Kigali)	(delphine.k@student.ulk.ac.rw,+250788200055)	{+250788200055}
76	Etienne Uwimana	("KN 563 Ave",Kigali)	(etienne.uwimana@student.ulk.ac.rw,+250788200056)	{+250788200056}
77	Flavia Ingabire	("KG 574 St",Kigali)	(flavia.ingabire@student.ulk.ac.rw,+250788200057)	{+250788200057}
78	Gerard Hakizimana	("KN 584 Ave",Kigali)	(gerard.h@student.ulk.ac.rw,+250788200058)	{+250788200058}
79	Henriette Ndikumana	("KG 595 St",Kigali)	(henriette.n@student.ulk.ac.rw,+250788200059)	{+250788200059}
80	Innocent Mukamurenzi	("KN 605 Ave",Kigali)	(innocent.m@student.ulk.ac.rw,+250788200060)	{+250788200060}
81	Josiane Nkurunziza	("KG 616 St",Kigali)	(josiane.n@student.ulk.ac.rw,+250788200061)	{+250788200061}
82	Kevin Habimana	("KN 626 Ave",Kigali)	(kevin.habimana@student.ulk.ac.rw,+250788200062)	{+250788200062}
83	Larissa Mukamana	("KG 637 St",Kigali)	(larissa.mukamana@student.ulk.ac.rw,+250788200063)	{+250788200063}
84	Marcel Niyonzima	("KN 647 Ave",Kigali)	(marcel.n@student.ulk.ac.rw,+250788200064)	{+250788200064}
85	Nadège Uwera	("KG 658 St",Kigali)	(nadege.uwera@student.ulk.ac.rw,+250788200065)	{+250788200065}
86	Olive Tuyishime	("KN 668 Ave",Kigali)	(olive.tuyishime@student.ulk.ac.rw,+250788200066)	{+250788200066}
87	Pascal Iradukunda	("KG 679 St",Kigali)	(pascal.i@student.ulk.ac.rw,+250788200067)	{+250788200067}
88	Quinta Ndayishimiye	("KN 689 Ave",Kigali)	(quinta.n@student.ulk.ac.rw,+250788200068)	{+250788200068}
89	Roland Mutesi	("KG 690 St",Kigali)	(roland.mutesi@student.ulk.ac.rw,+250788200069)	{+250788200069}
90	Sandrine Bizimana	("KN 701 Ave",Kigali)	(sandrine.b@student.ulk.ac.rw,+250788200070)	{+250788200070}
91	Théodore Mukashema	("KG 711 St",Kigali)	(theodore.m@student.ulk.ac.rw,+250788200071)	{+250788200071}
92	Uvera Nsengimana	("KN 721 Ave",Kigali)	(uvera.n@student.ulk.ac.rw,+250788200072)	{+250788200072}
93	Valentine Nyirahabimana	("KG 732 St",Kigali)	(valentine.n@student.ulk.ac.rw,+250788200073)	{+250788200073}
94	Wendell Rubayiza	("KN 742 Ave",Kigali)	(wendell.r@student.ulk.ac.rw,+250788200074)	{+250788200074}
95	Xenia Karangwa	("KG 753 St",Kigali)	(xenia.karangwa@student.ulk.ac.rw,+250788200075)	{+250788200075}
96	Yves Uwimana	("KN 763 Ave",Kigali)	(yves.uwimana@student.ulk.ac.rw,+250788200076)	{+250788200076}
97	Zara Ingabire	("KG 774 St",Kigali)	(zara.ingabire@student.ulk.ac.rw,+250788200077)	{+250788200077}
98	Adolphe Hakizimana	("KN 784 Ave",Kigali)	(adolphe.h@student.ulk.ac.rw,+250788200078)	{+250788200078}
99	Brigitte Ndikumana	("KG 795 St",Kigali)	(brigitte.n@student.ulk.ac.rw,+250788200079)	{+250788200079}
100	César Mukamurenzi	("KN 805 Ave",Kigali)	(cesar.m@student.ulk.ac.rw,+250788200080)	{+250788200080}
101	Danielle Nkurunziza	("KG 816 St",Kigali)	(danielle.n@student.ulk.ac.rw,+250788200081)	{+250788200081}
102	Emery Habimana	("KN 826 Ave",Kigali)	(emery.habimana@student.ulk.ac.rw,+250788200082)	{+250788200082}
103	Fidèle Mukamana	("KG 837 St",Kigali)	(fidele.mukamana@student.ulk.ac.rw,+250788200083)	{+250788200083}
104	Gaston Niyonzima	("KN 847 Ave",Kigali)	(gaston.n@student.ulk.ac.rw,+250788200084)	{+250788200084}
105	Honorée Uwera	("KG 858 St",Kigali)	(honoree.uwera@student.ulk.ac.rw,+250788200085)	{+250788200085}
106	Imelda Tuyishime	("KN 868 Ave",Kigali)	(imelda.t@student.ulk.ac.rw,+250788200086)	{+250788200086}
107	Joël Iradukunda	("KG 879 St",Kigali)	(joel.iradukunda@student.ulk.ac.rw,+250788200087)	{+250788200087}
108	Kizito Ndayishimiye	("KN 889 Ave",Kigali)	(kizito.n@student.ulk.ac.rw,+250788200088)	{+250788200088}
109	Laeticia Mutesi	("KG 890 St",Kigali)	(laeticia.mutesi@student.ulk.ac.rw,+250788200089)	{+250788200089}
110	Maxime Bizimana	("KN 901 Ave",Kigali)	(maxime.b@student.ulk.ac.rw,+250788200090)	{+250788200090}
111	Nathalie Mukashema	("KG 911 St",Kigali)	(nathalie.m@student.ulk.ac.rw,+250788200091)	{+250788200091}
112	Oswald Nsengimana	("KN 921 Ave",Kigali)	(oswald.n@student.ulk.ac.rw,+250788200092)	{+250788200092}
113	Priscille Nyirahabimana	("KG 932 St",Kigali)	(priscille.n@student.ulk.ac.rw,+250788200093)	{+250788200093}
114	Quentin Rubayiza	("KN 942 Ave",Kigali)	(quentin.r@student.ulk.ac.rw,+250788200094)	{+250788200094}
115	Régine Karangwa	("KG 953 St",Kigali)	(regine.k@student.ulk.ac.rw,+250788200095)	{+250788200095}
116	Sylvain Uwimana	("KN 963 Ave",Kigali)	(sylvain.u@student.ulk.ac.rw,+250788200096)	{+250788200096}
117	Thérèse Ingabire	("KG 974 St",Kigali)	(therese.i@student.ulk.ac.rw,+250788200097)	{+250788200097}
118	Urbain Hakizimana	("KN 984 Ave",Kigali)	(urbain.h@student.ulk.ac.rw,+250788200098)	{+250788200098}
119	Violette Ndikumana	("KG 995 St",Kigali)	(violette.n@student.ulk.ac.rw,+250788200099)	{+250788200099}
120	William Mukamurenzi	("KN 1005 Ave",Kigali)	(william.m@student.ulk.ac.rw,+250788200100)	{+250788200100}
\.


--
-- Data for Name: projectsupervision; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projectsupervision (supervisionid, lecturerid, studentid, projectid, startdate, isactive) FROM stdin;
1	1	21	1	2025-01-10	t
2	1	22	1	2025-01-10	t
3	2	23	2	2025-01-15	t
4	3	24	3	2025-02-01	t
5	4	25	4	2025-02-01	t
6	5	26	5	2025-02-10	t
7	6	27	6	2025-02-15	t
8	7	28	7	2025-02-20	t
9	8	29	8	2025-03-01	t
10	9	30	9	2025-03-01	t
11	10	31	10	2025-03-05	t
12	11	32	1	2025-03-10	t
13	12	33	2	2025-03-10	t
14	16	35	4	2025-03-15	t
15	18	36	5	2025-03-15	f
\.


--
-- Data for Name: researchproject; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.researchproject (projectid, title, metadata) FROM stdin;
1	AI-Powered Crop Disease Detection in Rwanda	{"tags": ["AI", "Agriculture", "Computer Vision"], "status": "Active", "funding": {"source": "RDB", "amount_USD": 15000}, "milestones": [{"due": "2025-03-01", "done": true, "title": "Data Collection"}, {"due": "2025-06-01", "done": false, "title": "Model Training"}]}
2	Blockchain-Based Land Registry System	{"tags": ["Blockchain", "Land Management", "e-Government"], "status": "Active", "funding": {"source": "World Bank", "amount_USD": 25000}, "milestones": [{"due": "2025-02-01", "done": true, "title": "Requirements"}, {"due": "2025-07-01", "done": false, "title": "Prototype"}]}
3	Impact of Mobile Banking on SME Growth	{"tags": ["FinTech", "Economics", "SME"], "status": "Active", "funding": {"source": "BNR", "amount_USD": 10000}, "milestones": [{"due": "2025-01-15", "done": true, "title": "Literature Review"}, {"due": "2025-04-01", "done": false, "title": "Field Survey"}]}
4	E-Learning Adoption in Rwandan Universities	{"tags": ["EdTech", "Education", "ICT"], "status": "Active", "funding": {"source": "MINEDUC", "amount_USD": 8000}, "milestones": [{"due": "2025-02-01", "done": true, "title": "Survey Design"}, {"due": "2025-05-01", "done": false, "title": "Data Analysis"}]}
5	Smart Traffic Management Using IoT	{"tags": ["IoT", "Smart City", "Engineering"], "status": "Planning", "funding": {"source": "RURA", "amount_USD": 12000}, "milestones": [{"due": "2025-04-01", "done": false, "title": "Feasibility Study"}]}
6	Mental Health Awareness Among University Students	{"tags": ["Psychology", "Public Health", "Students"], "status": "Active", "funding": {"source": "WHO", "amount_USD": 9000}, "milestones": [{"due": "2025-02-15", "done": true, "title": "Ethics Approval"}, {"due": "2025-05-01", "done": false, "title": "Interviews"}]}
7	Legal Framework for Data Protection in Rwanda	{"tags": ["Law", "Data Protection", "Cybersecurity"], "status": "Active", "funding": {"source": "RISA", "amount_USD": 7000}, "milestones": [{"due": "2025-03-01", "done": true, "title": "Policy Review"}, {"due": "2025-06-01", "done": false, "title": "Draft Report"}]}
8	Gender and Leadership in Rwandan Public Sector	{"tags": ["Gender Studies", "Public Administration", "Leadership"], "status": "Planning", "funding": {"source": "UN Women", "amount_USD": 11000}, "milestones": [{"due": "2025-05-01", "done": false, "title": "Research Proposal"}]}
9	Renewable Energy Adoption in Rural Communities	{"tags": ["Energy", "Environment", "Rural Development"], "status": "Active", "funding": {"source": "MININFRA", "amount_USD": 20000}, "milestones": [{"due": "2025-03-15", "done": true, "title": "Community Mapping"}, {"due": "2025-09-01", "done": false, "title": "Pilot Installation"}]}
10	Social Media and Political Participation Among Youth	{"tags": ["Social Media", "Politics", "Youth"], "status": "Active", "funding": {"source": "NURC", "amount_USD": 6000}, "milestones": [{"due": "2025-04-01", "done": false, "title": "Focus Groups"}]}
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (personid, fullname, homeaddress, contact, phonenumbers, studentid, enrollmentdate, majordeptid) FROM stdin;
21	Amina Nkurunziza	("KG 101 St",Kigali)	(amina.nkurunziza@student.ulk.ac.rw,+250788200001)	{+250788200001}	STU2022001	2022-09-01	1
22	Brian Habimana	("KN 22 Ave",Kigali)	(brian.habimana@student.ulk.ac.rw,+250788200002)	{+250788200002}	STU2022002	2022-09-01	2
23	Claudine Mukamana	("KG 33 St",Kigali)	(claudine.mukamana@student.ulk.ac.rw,+250788200003)	{+250788200003}	STU2022003	2022-09-01	3
24	Denis Niyonzima	("KN 44 Ave",Kigali)	(denis.niyonzima@student.ulk.ac.rw,+250788200004)	{+250788200004}	STU2022004	2022-09-01	4
25	Elise Uwera	("KG 55 St",Kigali)	(elise.uwera@student.ulk.ac.rw,+250788200005)	{+250788200005}	STU2022005	2022-09-01	5
26	Fabrice Tuyishime	("KN 66 Ave",Kigali)	(fabrice.tuyishime@student.ulk.ac.rw,+250788200006)	{+250788200006}	STU2022006	2022-09-01	6
27	Gorette Iradukunda	("KG 77 St",Kigali)	(gorette.iradukunda@student.ulk.ac.rw,+250788200007)	{+250788200007}	STU2022007	2022-09-01	7
28	Hervé Ndayishimiye	("KN 88 Ave",Kigali)	(herve.ndayishimiye@student.ulk.ac.rw,+250788200008)	{+250788200008}	STU2022008	2022-09-01	8
29	Isabelle Mutesi	("KG 99 St",Kigali)	(isabelle.mutesi@student.ulk.ac.rw,+250788200009)	{+250788200009}	STU2022009	2022-09-01	9
30	Jean-Paul Bizimana	("KN 10 Ave",Kigali)	(jeanpaul.bizimana@student.ulk.ac.rw,+250788200010)	{+250788200010}	STU2022010	2022-09-01	10
31	Karine Mukashema	("KG 111 St",Kigali)	(karine.mukashema@student.ulk.ac.rw,+250788200011)	{+250788200011}	STU2022011	2022-09-01	11
32	Lionel Nsengimana	("KN 121 Ave",Kigali)	(lionel.nsengimana@student.ulk.ac.rw,+250788200012)	{+250788200012}	STU2022012	2022-09-01	12
33	Martine Nyirahabimana	("KG 132 St",Kigali)	(martine.n@student.ulk.ac.rw,+250788200013)	{+250788200013}	STU2022013	2022-09-01	13
34	Nathan Rubayiza	("KN 142 Ave",Kigali)	(nathan.rubayiza@student.ulk.ac.rw,+250788200014)	{+250788200014}	STU2022014	2022-09-01	14
35	Odette Karangwa	("KG 153 St",Kigali)	(odette.karangwa@student.ulk.ac.rw,+250788200015)	{+250788200015}	STU2022015	2022-09-01	15
36	Patrick Uwimana	("KN 163 Ave",Kigali)	(patrick.uwimana@student.ulk.ac.rw,+250788200016)	{+250788200016}	STU2022016	2022-09-01	1
37	Quirine Ingabire	("KG 174 St",Kigali)	(quirine.ingabire@student.ulk.ac.rw,+250788200017)	{+250788200017}	STU2022017	2022-09-01	2
38	Remy Hakizimana	("KN 184 Ave",Kigali)	(remy.hakizimana@student.ulk.ac.rw,+250788200018)	{+250788200018}	STU2022018	2022-09-01	3
39	Sandra Ndikumana	("KG 195 St",Kigali)	(sandra.ndikumana@student.ulk.ac.rw,+250788200019)	{+250788200019}	STU2022019	2022-09-01	4
40	Thierry Mukamurenzi	("KN 205 Ave",Kigali)	(thierry.mukamurenzi@student.ulk.ac.rw,+250788200020)	{+250788200020}	STU2022020	2022-09-01	5
41	Ursule Nkurunziza	("KG 216 St",Kigali)	(ursule.nkurunziza@student.ulk.ac.rw,+250788200021)	{+250788200021}	STU2023001	2023-09-01	6
42	Victor Habimana	("KN 226 Ave",Kigali)	(victor.habimana@student.ulk.ac.rw,+250788200022)	{+250788200022}	STU2023002	2023-09-01	7
43	Wanjiru Mukamana	("KG 237 St",Kigali)	(wanjiru.mukamana@student.ulk.ac.rw,+250788200023)	{+250788200023}	STU2023003	2023-09-01	8
44	Xavier Niyonzima	("KN 247 Ave",Kigali)	(xavier.niyonzima@student.ulk.ac.rw,+250788200024)	{+250788200024}	STU2023004	2023-09-01	9
45	Yvette Uwera	("KG 258 St",Kigali)	(yvette.uwera@student.ulk.ac.rw,+250788200025)	{+250788200025}	STU2023005	2023-09-01	10
46	Zacharie Tuyishime	("KN 268 Ave",Kigali)	(zacharie.tuyishime@student.ulk.ac.rw,+250788200026)	{+250788200026}	STU2023006	2023-09-01	11
47	Adèle Iradukunda	("KG 279 St",Kigali)	(adele.iradukunda@student.ulk.ac.rw,+250788200027)	{+250788200027}	STU2023007	2023-09-01	12
48	Benjamin Ndayishimiye	("KN 289 Ave",Kigali)	(benjamin.n@student.ulk.ac.rw,+250788200028)	{+250788200028}	STU2023008	2023-09-01	13
49	Cécile Mutesi	("KG 290 St",Kigali)	(cecile.mutesi@student.ulk.ac.rw,+250788200029)	{+250788200029}	STU2023009	2023-09-01	14
50	Didier Bizimana	("KN 301 Ave",Kigali)	(didier.bizimana@student.ulk.ac.rw,+250788200030)	{+250788200030}	STU2023010	2023-09-01	15
51	Esperance Mukashema	("KG 311 St",Kigali)	(esperance.m@student.ulk.ac.rw,+250788200031)	{+250788200031}	STU2023011	2023-09-01	1
52	Félicien Nsengimana	("KN 321 Ave",Kigali)	(felicien.n@student.ulk.ac.rw,+250788200032)	{+250788200032}	STU2023012	2023-09-01	2
53	Gisèle Nyirahabimana	("KG 332 St",Kigali)	(gisele.n@student.ulk.ac.rw,+250788200033)	{+250788200033}	STU2023013	2023-09-01	3
54	Hubert Rubayiza	("KN 342 Ave",Kigali)	(hubert.rubayiza@student.ulk.ac.rw,+250788200034)	{+250788200034}	STU2023014	2023-09-01	4
55	Immaculée Karangwa	("KG 353 St",Kigali)	(immaculee.k@student.ulk.ac.rw,+250788200035)	{+250788200035}	STU2023015	2023-09-01	5
56	Jules Uwimana	("KN 363 Ave",Kigali)	(jules.uwimana@student.ulk.ac.rw,+250788200036)	{+250788200036}	STU2023016	2023-09-01	6
57	Kenza Ingabire	("KG 374 St",Kigali)	(kenza.ingabire@student.ulk.ac.rw,+250788200037)	{+250788200037}	STU2023017	2023-09-01	7
58	Landry Hakizimana	("KN 384 Ave",Kigali)	(landry.h@student.ulk.ac.rw,+250788200038)	{+250788200038}	STU2023018	2023-09-01	8
59	Mireille Ndikumana	("KG 395 St",Kigali)	(mireille.n@student.ulk.ac.rw,+250788200039)	{+250788200039}	STU2023019	2023-09-01	9
60	Noël Mukamurenzi	("KN 405 Ave",Kigali)	(noel.m@student.ulk.ac.rw,+250788200040)	{+250788200040}	STU2023020	2023-09-01	10
61	Odile Nkurunziza	("KG 416 St",Kigali)	(odile.nkurunziza@student.ulk.ac.rw,+250788200041)	{+250788200041}	STU2023021	2023-09-01	11
62	Pierre Habimana	("KN 426 Ave",Kigali)	(pierre.habimana@student.ulk.ac.rw,+250788200042)	{+250788200042}	STU2023022	2023-09-01	12
63	Rachel Mukamana	("KG 437 St",Kigali)	(rachel.mukamana@student.ulk.ac.rw,+250788200043)	{+250788200043}	STU2023023	2023-09-01	13
64	Samuel Niyonzima	("KN 447 Ave",Kigali)	(samuel.n@student.ulk.ac.rw,+250788200044)	{+250788200044}	STU2023024	2023-09-01	14
65	Trésor Uwera	("KG 458 St",Kigali)	(tresor.uwera@student.ulk.ac.rw,+250788200045)	{+250788200045}	STU2023025	2023-09-01	15
66	Uria Tuyishime	("KN 468 Ave",Kigali)	(uria.tuyishime@student.ulk.ac.rw,+250788200046)	{+250788200046}	STU2023026	2023-09-01	1
67	Vanessa Iradukunda	("KG 479 St",Kigali)	(vanessa.i@student.ulk.ac.rw,+250788200047)	{+250788200047}	STU2023027	2023-09-01	2
68	Wilfried Ndayishimiye	("KN 489 Ave",Kigali)	(wilfried.n@student.ulk.ac.rw,+250788200048)	{+250788200048}	STU2023028	2023-09-01	3
69	Xavière Mutesi	("KG 490 St",Kigali)	(xaviere.mutesi@student.ulk.ac.rw,+250788200049)	{+250788200049}	STU2023029	2023-09-01	4
70	Yannick Bizimana	("KN 501 Ave",Kigali)	(yannick.bizimana@student.ulk.ac.rw,+250788200050)	{+250788200050}	STU2023030	2023-09-01	5
71	Zita Mukashema	("KG 511 St",Kigali)	(zita.mukashema@student.ulk.ac.rw,+250788200051)	{+250788200051}	STU2024001	2024-09-01	6
72	Alexis Nsengimana	("KN 521 Ave",Kigali)	(alexis.n@student.ulk.ac.rw,+250788200052)	{+250788200052}	STU2024002	2024-09-01	7
73	Beatrice Nyirahabimana	("KG 532 St",Kigali)	(beatrice.n@student.ulk.ac.rw,+250788200053)	{+250788200053}	STU2024003	2024-09-01	8
74	Cyrus Rubayiza	("KN 542 Ave",Kigali)	(cyrus.rubayiza@student.ulk.ac.rw,+250788200054)	{+250788200054}	STU2024004	2024-09-01	9
75	Delphine Karangwa	("KG 553 St",Kigali)	(delphine.k@student.ulk.ac.rw,+250788200055)	{+250788200055}	STU2024005	2024-09-01	10
76	Etienne Uwimana	("KN 563 Ave",Kigali)	(etienne.uwimana@student.ulk.ac.rw,+250788200056)	{+250788200056}	STU2024006	2024-09-01	11
77	Flavia Ingabire	("KG 574 St",Kigali)	(flavia.ingabire@student.ulk.ac.rw,+250788200057)	{+250788200057}	STU2024007	2024-09-01	12
78	Gerard Hakizimana	("KN 584 Ave",Kigali)	(gerard.h@student.ulk.ac.rw,+250788200058)	{+250788200058}	STU2024008	2024-09-01	13
79	Henriette Ndikumana	("KG 595 St",Kigali)	(henriette.n@student.ulk.ac.rw,+250788200059)	{+250788200059}	STU2024009	2024-09-01	14
80	Innocent Mukamurenzi	("KN 605 Ave",Kigali)	(innocent.m@student.ulk.ac.rw,+250788200060)	{+250788200060}	STU2024010	2024-09-01	15
81	Josiane Nkurunziza	("KG 616 St",Kigali)	(josiane.n@student.ulk.ac.rw,+250788200061)	{+250788200061}	STU2024011	2024-09-01	1
82	Kevin Habimana	("KN 626 Ave",Kigali)	(kevin.habimana@student.ulk.ac.rw,+250788200062)	{+250788200062}	STU2024012	2024-09-01	2
83	Larissa Mukamana	("KG 637 St",Kigali)	(larissa.mukamana@student.ulk.ac.rw,+250788200063)	{+250788200063}	STU2024013	2024-09-01	3
84	Marcel Niyonzima	("KN 647 Ave",Kigali)	(marcel.n@student.ulk.ac.rw,+250788200064)	{+250788200064}	STU2024014	2024-09-01	4
85	Nadège Uwera	("KG 658 St",Kigali)	(nadege.uwera@student.ulk.ac.rw,+250788200065)	{+250788200065}	STU2024015	2024-09-01	5
86	Olive Tuyishime	("KN 668 Ave",Kigali)	(olive.tuyishime@student.ulk.ac.rw,+250788200066)	{+250788200066}	STU2024016	2024-09-01	6
87	Pascal Iradukunda	("KG 679 St",Kigali)	(pascal.i@student.ulk.ac.rw,+250788200067)	{+250788200067}	STU2024017	2024-09-01	7
88	Quinta Ndayishimiye	("KN 689 Ave",Kigali)	(quinta.n@student.ulk.ac.rw,+250788200068)	{+250788200068}	STU2024018	2024-09-01	8
89	Roland Mutesi	("KG 690 St",Kigali)	(roland.mutesi@student.ulk.ac.rw,+250788200069)	{+250788200069}	STU2024019	2024-09-01	9
90	Sandrine Bizimana	("KN 701 Ave",Kigali)	(sandrine.b@student.ulk.ac.rw,+250788200070)	{+250788200070}	STU2024020	2024-09-01	10
91	Théodore Mukashema	("KG 711 St",Kigali)	(theodore.m@student.ulk.ac.rw,+250788200071)	{+250788200071}	STU2024021	2024-09-01	11
92	Uvera Nsengimana	("KN 721 Ave",Kigali)	(uvera.n@student.ulk.ac.rw,+250788200072)	{+250788200072}	STU2024022	2024-09-01	12
93	Valentine Nyirahabimana	("KG 732 St",Kigali)	(valentine.n@student.ulk.ac.rw,+250788200073)	{+250788200073}	STU2024023	2024-09-01	13
94	Wendell Rubayiza	("KN 742 Ave",Kigali)	(wendell.r@student.ulk.ac.rw,+250788200074)	{+250788200074}	STU2024024	2024-09-01	14
95	Xenia Karangwa	("KG 753 St",Kigali)	(xenia.karangwa@student.ulk.ac.rw,+250788200075)	{+250788200075}	STU2024025	2024-09-01	15
96	Yves Uwimana	("KN 763 Ave",Kigali)	(yves.uwimana@student.ulk.ac.rw,+250788200076)	{+250788200076}	STU2024026	2024-09-01	1
97	Zara Ingabire	("KG 774 St",Kigali)	(zara.ingabire@student.ulk.ac.rw,+250788200077)	{+250788200077}	STU2024027	2024-09-01	2
98	Adolphe Hakizimana	("KN 784 Ave",Kigali)	(adolphe.h@student.ulk.ac.rw,+250788200078)	{+250788200078}	STU2024028	2024-09-01	3
99	Brigitte Ndikumana	("KG 795 St",Kigali)	(brigitte.n@student.ulk.ac.rw,+250788200079)	{+250788200079}	STU2024029	2024-09-01	4
100	César Mukamurenzi	("KN 805 Ave",Kigali)	(cesar.m@student.ulk.ac.rw,+250788200080)	{+250788200080}	STU2024030	2024-09-01	5
101	Danielle Nkurunziza	("KG 816 St",Kigali)	(danielle.n@student.ulk.ac.rw,+250788200081)	{+250788200081}	STU2024031	2024-09-01	6
102	Emery Habimana	("KN 826 Ave",Kigali)	(emery.habimana@student.ulk.ac.rw,+250788200082)	{+250788200082}	STU2024032	2024-09-01	7
103	Fidèle Mukamana	("KG 837 St",Kigali)	(fidele.mukamana@student.ulk.ac.rw,+250788200083)	{+250788200083}	STU2024033	2024-09-01	8
104	Gaston Niyonzima	("KN 847 Ave",Kigali)	(gaston.n@student.ulk.ac.rw,+250788200084)	{+250788200084}	STU2024034	2024-09-01	9
105	Honorée Uwera	("KG 858 St",Kigali)	(honoree.uwera@student.ulk.ac.rw,+250788200085)	{+250788200085}	STU2024035	2024-09-01	10
106	Imelda Tuyishime	("KN 868 Ave",Kigali)	(imelda.t@student.ulk.ac.rw,+250788200086)	{+250788200086}	STU2024036	2024-09-01	11
107	Joël Iradukunda	("KG 879 St",Kigali)	(joel.iradukunda@student.ulk.ac.rw,+250788200087)	{+250788200087}	STU2024037	2024-09-01	12
108	Kizito Ndayishimiye	("KN 889 Ave",Kigali)	(kizito.n@student.ulk.ac.rw,+250788200088)	{+250788200088}	STU2024038	2024-09-01	13
109	Laeticia Mutesi	("KG 890 St",Kigali)	(laeticia.mutesi@student.ulk.ac.rw,+250788200089)	{+250788200089}	STU2024039	2024-09-01	14
110	Maxime Bizimana	("KN 901 Ave",Kigali)	(maxime.b@student.ulk.ac.rw,+250788200090)	{+250788200090}	STU2024040	2024-09-01	15
111	Nathalie Mukashema	("KG 911 St",Kigali)	(nathalie.m@student.ulk.ac.rw,+250788200091)	{+250788200091}	STU2025001	2025-09-01	1
112	Oswald Nsengimana	("KN 921 Ave",Kigali)	(oswald.n@student.ulk.ac.rw,+250788200092)	{+250788200092}	STU2025002	2025-09-01	2
113	Priscille Nyirahabimana	("KG 932 St",Kigali)	(priscille.n@student.ulk.ac.rw,+250788200093)	{+250788200093}	STU2025003	2025-09-01	3
114	Quentin Rubayiza	("KN 942 Ave",Kigali)	(quentin.r@student.ulk.ac.rw,+250788200094)	{+250788200094}	STU2025004	2025-09-01	4
115	Régine Karangwa	("KG 953 St",Kigali)	(regine.k@student.ulk.ac.rw,+250788200095)	{+250788200095}	STU2025005	2025-09-01	5
116	Sylvain Uwimana	("KN 963 Ave",Kigali)	(sylvain.u@student.ulk.ac.rw,+250788200096)	{+250788200096}	STU2025006	2025-09-01	6
117	Thérèse Ingabire	("KG 974 St",Kigali)	(therese.i@student.ulk.ac.rw,+250788200097)	{+250788200097}	STU2025007	2025-09-01	7
118	Urbain Hakizimana	("KN 984 Ave",Kigali)	(urbain.h@student.ulk.ac.rw,+250788200098)	{+250788200098}	STU2025008	2025-09-01	8
119	Violette Ndikumana	("KG 995 St",Kigali)	(violette.n@student.ulk.ac.rw,+250788200099)	{+250788200099}	STU2025009	2025-09-01	9
120	William Mukamurenzi	("KN 1005 Ave",Kigali)	(william.m@student.ulk.ac.rw,+250788200100)	{+250788200100}	STU2025010	2025-09-01	10
\.


--
-- Name: academicevent_eventid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.academicevent_eventid_seq', 8, true);


--
-- Name: academicspace_spaceid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.academicspace_spaceid_seq', 12, true);


--
-- Name: attendancelog_attendanceid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendancelog_attendanceid_seq', 59, true);


--
-- Name: course_courseid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_courseid_seq', 30, true);


--
-- Name: courseallocation_allocationid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courseallocation_allocationid_seq', 30, true);


--
-- Name: coursesession_sessionid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coursesession_sessionid_seq', 30, true);


--
-- Name: department_departmentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_departmentid_seq', 15, true);


--
-- Name: enrollment_enrollmentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enrollment_enrollmentid_seq', 115, true);


--
-- Name: eventparticipant_participantid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eventparticipant_participantid_seq', 20, true);


--
-- Name: faculty_facultyid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_facultyid_seq', 5, true);


--
-- Name: person_personid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_personid_seq', 120, true);


--
-- Name: projectsupervision_supervisionid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projectsupervision_supervisionid_seq', 15, true);


--
-- Name: researchproject_projectid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.researchproject_projectid_seq', 10, true);


--
-- Name: academicevent academicevent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academicevent
    ADD CONSTRAINT academicevent_pkey PRIMARY KEY (eventid);


--
-- Name: academicspace academicspace_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academicspace
    ADD CONSTRAINT academicspace_pkey PRIMARY KEY (spaceid);


--
-- Name: academicspace academicspace_roomnumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academicspace
    ADD CONSTRAINT academicspace_roomnumber_key UNIQUE (roomnumber);


--
-- Name: attendancelog attendancelog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendancelog
    ADD CONSTRAINT attendancelog_pkey PRIMARY KEY (attendanceid);


--
-- Name: course course_coursecode_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_coursecode_key UNIQUE (coursecode);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (courseid);


--
-- Name: courseallocation courseallocation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courseallocation
    ADD CONSTRAINT courseallocation_pkey PRIMARY KEY (allocationid);


--
-- Name: coursesession coursesession_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursesession
    ADD CONSTRAINT coursesession_pkey PRIMARY KEY (sessionid);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (departmentid);


--
-- Name: enrollment enrollment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT enrollment_pkey PRIMARY KEY (enrollmentid);


--
-- Name: eventattendance eventattendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventattendance
    ADD CONSTRAINT eventattendance_pkey PRIMARY KEY (eventid, participantid);


--
-- Name: eventparticipant eventparticipant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventparticipant
    ADD CONSTRAINT eventparticipant_pkey PRIMARY KEY (participantid);


--
-- Name: faculty faculty_facultyname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_facultyname_key UNIQUE (facultyname);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (facultyid);


--
-- Name: lecturer lecturer_employeeid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer
    ADD CONSTRAINT lecturer_employeeid_key UNIQUE (employeeid);


--
-- Name: lecturer lecturer_personid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer
    ADD CONSTRAINT lecturer_personid_key UNIQUE (personid);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (personid);


--
-- Name: projectsupervision projectsupervision_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projectsupervision
    ADD CONSTRAINT projectsupervision_pkey PRIMARY KEY (supervisionid);


--
-- Name: researchproject researchproject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.researchproject
    ADD CONSTRAINT researchproject_pkey PRIMARY KEY (projectid);


--
-- Name: student student_personid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_personid_key UNIQUE (personid);


--
-- Name: student student_studentid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_studentid_key UNIQUE (studentid);


--
-- Name: courseallocation fk_allocation_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courseallocation
    ADD CONSTRAINT fk_allocation_course FOREIGN KEY (courseid) REFERENCES public.course(courseid) ON DELETE CASCADE;


--
-- Name: eventattendance fk_attendance_event; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventattendance
    ADD CONSTRAINT fk_attendance_event FOREIGN KEY (eventid) REFERENCES public.academicevent(eventid) ON DELETE CASCADE;


--
-- Name: eventattendance fk_attendance_participant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventattendance
    ADD CONSTRAINT fk_attendance_participant FOREIGN KEY (participantid) REFERENCES public.eventparticipant(participantid) ON DELETE CASCADE;


--
-- Name: attendancelog fk_attendance_session; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendancelog
    ADD CONSTRAINT fk_attendance_session FOREIGN KEY (sessionid) REFERENCES public.coursesession(sessionid) ON DELETE CASCADE;


--
-- Name: course fk_course_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT fk_course_department FOREIGN KEY (departmentid) REFERENCES public.department(departmentid) ON DELETE CASCADE;


--
-- Name: department fk_dept_faculty; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT fk_dept_faculty FOREIGN KEY (facultyid) REFERENCES public.faculty(facultyid) ON DELETE RESTRICT;


--
-- Name: enrollment fk_enrollment_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT fk_enrollment_course FOREIGN KEY (courseid) REFERENCES public.course(courseid) ON DELETE CASCADE;


--
-- Name: academicevent fk_event_space; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academicevent
    ADD CONSTRAINT fk_event_space FOREIGN KEY (spaceid) REFERENCES public.academicspace(spaceid) ON DELETE CASCADE;


--
-- Name: lecturer fk_lecturer_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer
    ADD CONSTRAINT fk_lecturer_department FOREIGN KEY (primarydeptid) REFERENCES public.department(departmentid) ON DELETE RESTRICT;


--
-- Name: eventparticipant fk_participant_person; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventparticipant
    ADD CONSTRAINT fk_participant_person FOREIGN KEY (personid) REFERENCES public.person(personid) ON DELETE CASCADE;


--
-- Name: coursesession fk_session_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursesession
    ADD CONSTRAINT fk_session_course FOREIGN KEY (courseid) REFERENCES public.course(courseid) ON DELETE CASCADE;


--
-- Name: coursesession fk_session_space; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coursesession
    ADD CONSTRAINT fk_session_space FOREIGN KEY (spaceid) REFERENCES public.academicspace(spaceid) ON DELETE CASCADE;


--
-- Name: student fk_student_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT fk_student_department FOREIGN KEY (majordeptid) REFERENCES public.department(departmentid) ON DELETE RESTRICT;


--
-- Name: projectsupervision fk_supervision_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projectsupervision
    ADD CONSTRAINT fk_supervision_project FOREIGN KEY (projectid) REFERENCES public.researchproject(projectid) ON DELETE CASCADE;


--
-- Name: courseallocation virtual_fk_allocation_lecturer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courseallocation
    ADD CONSTRAINT virtual_fk_allocation_lecturer FOREIGN KEY (lecturerid) REFERENCES public.lecturer(personid);


--
-- Name: attendancelog virtual_fk_attendance_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendancelog
    ADD CONSTRAINT virtual_fk_attendance_student FOREIGN KEY (studentid) REFERENCES public.student(personid);


--
-- Name: enrollment virtual_fk_enrollment_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT virtual_fk_enrollment_student FOREIGN KEY (studentid) REFERENCES public.student(personid);


--
-- Name: lecturer virtual_fk_lecturer_person; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer
    ADD CONSTRAINT virtual_fk_lecturer_person FOREIGN KEY (personid) REFERENCES public.person(personid);


--
-- Name: student virtual_fk_student_person; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT virtual_fk_student_person FOREIGN KEY (personid) REFERENCES public.person(personid);


--
-- Name: projectsupervision virtual_fk_supervision_lecturer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projectsupervision
    ADD CONSTRAINT virtual_fk_supervision_lecturer FOREIGN KEY (lecturerid) REFERENCES public.lecturer(personid);


--
-- Name: projectsupervision virtual_fk_supervision_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projectsupervision
    ADD CONSTRAINT virtual_fk_supervision_student FOREIGN KEY (studentid) REFERENCES public.student(personid);


--
-- PostgreSQL database dump complete
--

\unrestrict cah18lSosyGrrq67nMd52rBvkuZ2ynCxoAvqTtspqT0mcB3UDniyBSr8uhBU3co

