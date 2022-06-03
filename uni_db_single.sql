/*
    CREATE USER uni_db
*/
set serveroutput on
set escape on
PROMPT specify password for uni_db:
DEFINE pass     = &1

PROMPT What is password of SYSTEM user:
DEFINE sysusr   = &2

PROMPT Enter connection_string like @localhost:1521/xe leave empty if not applicable
DEFINE conn_str = &3  

conn SYSTEM/&sysusr&conn_str

alter session set "_oracle_script"=true;

DROP USER UNI_DB CASCADE;

CREATE USER UNI_DB IDENTIFIED BY &pass;

alter session set "_oracle_script"=false;

conn SYSTEM/&sysusr&conn_str

ALTER USER UNI_DB DEFAULT TABLESPACE users;

ALTER USER UNI_DB TEMPORARY TABLESPACE TEMP;

GRANT CONNECT TO UNI_DB;
GRANT CREATE SESSION TO UNI_DB;
GRANT CREATE VIEW TO UNI_DB;
GRANT ALTER SESSION TO UNI_DB;
GRANT CREATE TABLE TO UNI_DB;
GRANT CREATE SEQUENCE TO UNI_DB;
GRANT CREATE SYNONYM TO UNI_DB;
GRANT CREATE DATABASE LINK TO UNI_DB;
GRANT RESOURCE TO UNI_DB;
GRANT UNLIMITED TABLESPACE TO UNI_DB;


conn UNI_DB/&pass&conn_str
-- DROPPING TABLES IN CASE USER ALREADY EXISTS
DROP TABLE STUDENT CASCADE CONSTRAINTS;
DROP TABLE DEPARTMENT CASCADE CONSTRAINTS;
DROP TABLE COURSE CASCADE CONSTRAINTS;
DROP TABLE PROGRAM CASCADE CONSTRAINTS;
DROP TABLE FACULTY_ALLOCATION CASCADE CONSTRAINTS;
DROP TABLE SECTION CASCADE CONSTRAINTS;
DROP TABLE PROGRAM_COURSE_ROADMAP CASCADE CONSTRAINTS;
DROP TABLE FACULTY CASCADE CONSTRAINTS;
DROP TABLE ENROLLMENT CASCADE CONSTRAINTS;
DROP TABLE SEMESTER CASCADE CONSTRAINTS;
DROP TABLE STUDENT_SGPA CASCADE CONSTRAINTS;
DROP TABLE JOBS CASCADE CONSTRAINTS;
DROP TABLE MISC_CHALLAN CASCADE CONSTRAINTS;
DROP TABLE MISC_PAYMENT_STRUCTURE CASCADE CONSTRAINTS;
DROP TABLE FULFILLED_CHALLAN CASCADE CONSTRAINTS;
DROP TABLE FEE_CHALLAN CASCADE CONSTRAINTS;
DROP TABLE FEE_STRUCTURE CASCADE CONSTRAINTS;
DROP TABLE REGISTRATION CASCADE CONSTRAINTS;
DROP TABLE CERTIFICATE CASCADE CONSTRAINTS;
DROP TABLE APPLICATION CASCADE CONSTRAINTS;
DROP TABLE BANK_ACCOUNT CASCADE CONSTRAINTS;
DROP TABLE PARTNER_BANK CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE GRADE CASCADE CONSTRAINTS;
DROP TABLE GATE CASCADE CONSTRAINTS;
DROP TABLE GATE_CHECKIN CASCADE CONSTRAINTS;
DROP TABLE PAYCHECK CASCADE CONSTRAINTS ;



-- DROPPING EXISTING SEQUENCES AND CREATING NEW ONES
DROP SEQUENCE seq_faculty;
DROP SEQUENCE seq_fee_challan;
DROP SEQUENCE seq_misc_challan;
DROP SEQUENCE seq_employee;
DROP SEQUENCE seq_fulfilled_challan;
DROP SEQUENCE seq_enrollment;
DROP SEQUENCE seq_application;
DROP SEQUENCE seq_paycheck_id;
DROP SEQUENCE seq_certificate_id;
DROP SEQUENCE seq_gate_checkin;

CREATE SEQUENCE seq_gate_checkin;
CREATE SEQUENCE seq_faculty;
CREATE SEQUENCE seq_fee_challan;
CREATE SEQUENCE seq_misc_challan;
CREATE SEQUENCE seq_employee;
CREATE SEQUENCE seq_fulfilled_challan;
CREATE SEQUENCE seq_enrollment;
CREATE SEQUENCE seq_application;
CREATE SEQUENCE seq_paycheck_id;
CREATE SEQUENCE seq_certificate_id;


create table department (
    dept_id varchar(5) NOT NULL ,
    dept_name varchar(40) NOT NULL ,
    phone_no varchar(14),
    email varchar(25),
    hod varchar(12) NOT NULL,
    CONSTRAINT pk_department_dept_id primary key (dept_id)
);

create table student (
    std_id varchar(12) NOT NULL,
    registration_id varchar(17) not null,
    std_name varchar(50) NOT NULL,
    father_name varchar(50),
    phone_no varchar(14),
    cnic varchar(13),
    program varchar(5) NOT NULL,
    section varchar(10) NOT NULL,
    status varchar(20) DEFAULT 'STUDYING' NOT NULL ,
    CONSTRAINT pk_student_std_id primary key (std_id),
    CONSTRAINT domain_student_status check ( status IN ('STUDYING', 'GRADUATED') ),
    CONSTRAINT unq_student_std_id_prg_id unique (std_id, program)
);

CREATE TABLE APPLICATION (
    applicant_id varchar(15) NOT NULL, -- app-0001
    program varchar(5) NOT NULL ,
    applicant_name varchar(50) NOT NULL ,
    applicant_father_name varchar(50) NOT NULL ,
    application_type varchar(12) DEFAULT 'Open Merit' NOT NULL ,
    CONSTRAINT domain_application_type CHECK ( application_type IN ('Disability', 'Hifz-e-Quran', 'Open Merit') ),
    cnic varchar(13) NOT NULL ,
    phone_no varchar(14) NOT NULL ,
    matric_marks int NOT NULL ,
    inter_marks int NOT NULL ,
    application_date varchar(20) DEFAULT CAST(SYSDATE as varchar(20)),
    status varchar(30) default 'Applied' NOT NULL,
    CONSTRAINT pk_application primary key (applicant_id),
    constraint domain_application_status check ( status IN ('Applied', 'Application-Dropped', 'Application challan Issued', 'Application in-process', 'not-on-list' ,'On-list', 'Registration challan issued', 'Registered') )
);

CREATE TABLE student_sgpa (
    student_id varchar(12) NOT NULL ,
    semester_id int NOT NULL ,
    SGPA float NOT NULL ,
    CONSTRAINT pk_student_sgpa primary key (student_id, semester_id),
    CONSTRAINT domain_student_sgpa check ( SGPA <= 4.0 )
);

CREATE TABLE MISC_PAYMENT_STRUCTURE(
    collection_code varchar(14) NOT NULL ,  -- ADMIT-BSCS-22, REG-BSCS-22
    program varchar(5) NOT NULL ,
    payment_type varchar(15) NOT NULL,
    fee_amount int NOT NULL,
    CONSTRAINT pk_misc_payment_structure primary key (collection_code),
    CONSTRAINT domain_misc_payment_structure CHECK ( payment_type IN ('ADMISSION', 'REGISTRATION') )
);

CREATE TABLE MISC_CHALLAN (
    CHALLAN_ID varchar(20) NOT NULL,
    collection_code varchar(14) NOT NULL ,
    applicant_id varchar(15) NOT NULL,
    ISSUED_BY varchar(11) NOT NULL ,
    CONSTRAINT pk_misc_challan primary key (CHALLAN_ID)
);

CREATE TABLE FEE_STRUCTURE (
    collection_code varchar(14) NOT NULL ,   -- FEE_BSCS_S1_22
    prg_id varchar(5) NOT NULL ,
    semester int NOT NULL ,
    fee_amount int NOT NULL,
    CONSTRAINT pk_fee_structure primary key (collection_code),
    CONSTRAINT fee_structure_uq_1 unique (prg_id, semester),
    CONSTRAINT fee_structure_uq_2 unique (collection_code, fee_amount)  -- TO add foreign key in FEE CHALLAN TABLE
);

CREATE TABLE JOBS (
    JOB_ID varchar(20) NOT NULL ,
    JOB_NAME varchar(30) NOT NULL ,
    max_salary int not null ,
    max_employess int DEFAULT 1,
    CONSTRAINT pk_jobs primary key (JOB_ID)
);

CREATE TABLE EMPLOYEE (
    EMPLOYEE_ID varchar(11) NOT NULL ,  -- EMP-0001
    JOB varchar(20) NOT NULL ,
    name varchar(50) not null ,
    CNIC varchar(13) NOT NULL ,
    phone_no varchar(14) NOT NULL ,
    salary int DEFAULT 999 NOT NULL,
    hire_date varchar(9) default CAST(SYSDATE as varchar(9)),
    CONSTRAINT pk_employee primary key (EMPLOYEE_ID)
);

CREATE TABLE FEE_CHALLAN (
    CHALLAN_ID varchar(20) NOT NULL ,
    STUDENT_ID varchar(12) NOT NULL ,
    ISSUED_BY varchar(11) NOT NULL ,
    collection_code varchar(14) NOT NULL ,
    status varchar(7) DEFAULT 'UN-PAID',
    CONSTRAINT domain_fee_challan_status CHECK ( status in ('UN-PAID', 'PAID') ),
    CONSTRAINT pk_fee_challan primary key (CHALLAN_ID)
);


CREATE TABLE FULFILLED_CHALLAN (
    payment_id varchar(9) NOT NULL , -- fc-0001
    MISC_CHALLAN_ID varchar(20) NULL ,
    FEE_CHALLAN_ID varchar(20) NULL,
    VALIDATED_BY varchar(11) NOT NULL,
    dep_account varchar(14) NOT NULL ,
    payment_mode varchar(20), -- ON-BRANCH, ONLINE
    CONSTRAINT domain_fulfilled_challan check ( payment_mode in ('ON-BRANCH', 'ONLINE')  ),
    CONSTRAINT pk_fulfilled_challans primary key (payment_id),
    CONSTRAINT verify_misc_or_fee_challan check
        ( CASE WHEN MISC_CHALLAN_ID IS NULL THEN 0 ELSE 1 END +
          CASE WHEN FEE_CHALLAN_ID IS NULL THEN 0 ELSE 1 END = 1)  -- it'll ensure that either MISC_CHALLAN_ID or FEE_CHALLAN_ID is filled
);

CREATE TABLE PARTNER_BANK (
    BANK_ID varchar(10) NOT NULL ,
    BANK_NAME varchar(30) NOT NULL ,
    BANK_ADDRESS varchar(100) NULL ,
    MANAGER_NAME varchar(30) NULL ,
    TELEPHONE_NO varchar(14) NULL ,
    CONSTRAINT pk_partner_bank primary key (BANK_ID)
);

CREATE TABLE BANK_ACCOUNT (
    ACCOUNT_NO varchar(14) NOT NULL,
    BANK_ID varchar(10) NOT NULL,
    ACCOUNT_ALIAS varchar(30) NULL ,
    ACCOUNT_TYPE varchar(10) DEFAULT 'BUSINESS',
    CONSTRAINT pk_bank_account primary key (ACCOUNT_NO),
    CONSTRAINT bank_account_account_no_char_bound check ( LENGTH(ACCOUNT_NO) = 14 )
);


create TABLE program (
    prg_id varchar(5) NOT NULL,
    prg_name varchar(40) NOT NULL ,
    prg_duration number NOT NULL,
    dept_id varchar(5) NOT NULL,
    no_semesters number DEFAULT 8,
    credit_hours int DEFAULT 0 NOT NULL ,
    CONSTRAINT limit_program_duration check ( prg_duration <= 5 and prg_duration >= 2 ),
    CONSTRAINT pk_program_prg_id primary key (prg_id)
);

CREATE TABLE COURSE (
    COURSE_CODE VARCHAR(20) NOT NULL,
    COURSE_NAME VARCHAR(60) not null,
    CREDIT_HOURS NUMBER NOT NULL,
    CONSTRAINT pk_course_course_code primary key (COURSE_CODE)
);

CREATE TABLE FACULTY (
    FACULTY_ID varchar(9) NOT NULL, -- FA-00001
    NAME VARCHAR(50) NOT NULL ,
    F_NAME VARCHAR(50),
    CNIC VARCHAR(13) NOT NULL,
    PHONE_NUM VARCHAR(14) ,
    EMAIL VARCHAR(50),
    DEPT_ID VARCHAR(5) NOT NULL,
    salary int not null,
    CONSTRAINT pk_faculty_faculty_id primary key (FACULTY_ID)
);


CREATE TABLE SECTION (
    SECTION_ID VARCHAR(10) NOT NULL ,
    PROGRAM VARCHAR(5) NOT NULL ,
    session_year int NOT NULL ,
    semester number DEFAULT 1 NOT NULL,  -- ADD TRIGGER EXCEPTION SO SEMESTER CANNOT BE GREATER THAN PROGRAM SEMESTERS
    STATUS varchar(20) DEFAULT 'IN-TERM' NOT NULL ,
    CONSTRAINT section_status CHECK ( STATUS in ('IN-TERM', 'TERM-ENDED') ),
    CONSTRAINT pk_section_section_id primary key (SECTION_ID),
    CONSTRAINT unq_student_sect_id_prg_id unique (SECTION_ID, program)
);

CREATE TABLE SEMESTER (
    SEMESTER_ID INT NOT NULL ,
    SEMESTER_NAME varchar(32) not null ,
    -- Semester should not be greater than 10 (program duration limit: 5)
    CONSTRAINT semesters_limit check ( SEMESTER_ID <= 10),
    CONSTRAINT pk_semester primary key (SEMESTER_ID)
);

CREATE TABLE GRADE (
    ENROLLMENT_ID varchar(16) NOT NULL ,
    quiz int NOT NULL ,
    assignment int NOT NULL ,
    mid_term int NOT NULL ,
    final int NOT NULL ,
    grade varchar(2) NOT NULL ,
    status varchar(20) NOT NULL ,
    grade_points float not null ,
    CONSTRAINT pk_grade primary key (ENROLLMENT_ID),    -- A student maybe improving a course so course code can appear again
    CONSTRAINT grade_quiz_marks_upper_bound check ( quiz <= 10 ),
    CONSTRAINT grade_assignment_upper_bound check ( assignment <= 10 ),
    CONSTRAINT grade_mid_term_upper_bound check ( mid_term <= 20 ),
    CONSTRAINT grade_marks_upper_bound check ( final <= 60 ),
    CONSTRAINT domain_grade_status CHECK (status IN ('PASS', 'FAIL', 'DISCARDED'))
);


CREATE TABLE FACULTY_ALLOCATION (
    section_id varchar(10) not null,
    faculty_id varchar(9) not null,
    course_code varchar(20) not null,
    CONSTRAINT pk_faculty_allocation primary key (section_id, course_code)
);

CREATE TABLE ENROLLMENT (
    enrollment_id varchar(16) not null, -- ENR-0000001
    prg_id varchar(5) not null ,
    section varchar(10) not null ,
    course_code varchar(20) not null ,
    student_id varchar(12) not null ,
    enrollment_type varchar(10) default 'ON-TERM',
    enrollment_date varchar(9) DEFAULT CAST(SYSDATE as varchar(9)) NOT NULL ,
    STATUS varchar(20) DEFAULT 'ACTIVE' NOT NULL ,
    CONSTRAINT domain_enrollment_status check ( STATUS IN ('ACTIVE', 'FINISHED') ),
    CONSTRAINT domain_enrollment_type check ( enrollment_type IN ('ON-TERM', 'REPEAT') ),  -- ON-TERM means that student will be enrolled in its own section whereas REPEAT will be enrolled in junior's section
    CONSTRAINT pk_enrollment_enrollment_id primary key (enrollment_id),
    CONSTRAINT enrollment_unique_enrollment_id_std_id unique (enrollment_id, student_id)
);

CREATE TABLE PROGRAM_COURSE_ROADMAP (
    course_code varchar(20) not null ,
    prg_id varchar(5) not null,
    semester number not null,
    CONSTRAINT pk_prg_course_rel primary key (course_code, prg_id)
);

CREATE TABLE GATE (
    GATE_id varchar(5) NOT NULL, -- GT-1
    gate_alias varchar(30) NOT NULL, -- PG-GATE MAIN GATE
    head_guard varchar(11) NOT NULL,
    CONSTRAINT pk_gate primary key (gate_id)
);

CREATE TABLE GATE_CHECKIN (
    checkin_id varchar(12),
    GATE_id varchar(5) NOT NULL,
    faculty_id varchar(9) null,
    checkin_date varchar(12) DEFAULT CAST(SYSDATE as varchar(12)) NOT NULL ,
    std_id varchar(12) NULL,
    checkin_time varchar(15) DEFAULT to_char(sysdate,'HH24:MI:SS AM') NOT NULL ,
    CONSTRAINT uk_gate_checkin unique (faculty_id, std_id, checkin_date) ,
    CONSTRAINT pk_gate_checkin unique (checkin_id) ,
    CONSTRAINT verify_gate_checkin_either_std_or_emp CHECK ( CASE WHEN std_id IS NULL THEN 0 ELSE 1 END +
          CASE WHEN faculty_id IS NULL THEN 0 ELSE 1 END = 1 )
);



CREATE TABLE PAYCHECK(
    PAYCHECK_ID varchar(12) NOT NULL , -- JAN-20-01
    employee_id varchar(11) NULL,
    faculty_id varchar(9) NULL,
    paid_from varchar(14) DEFAULT '04095423123451' NOT NULL ,
    month varchar(9) DEFAULT to_char(sysdate,'Month') NOT NULL,
    year varchar(4) DEFAULT EXTRACT(YEAR from sysdate) NOT NULL,
    CONSTRAINT pk_paycheck primary key (PAYCHECK_ID),
    constraint uq_paycheck_employee_faculty_month_year unique (faculty_id, employee_id, month, year),
    CONSTRAINT verify_paycheck_either_employee_or_faculty CHECK ( CASE WHEN employee_id IS NULL THEN 0 ELSE 1 END +
          CASE WHEN faculty_id IS NULL THEN 0 ELSE 1 END = 1 )
);


CREATE TABLE CERTIFICATE(
    certificate_id varchar(15) NOT NULL, -- GCU-BSCS-20-001
    std_registration_id varchar(17) NOT NULL ,
    CGPA DECIMAL(3,2) NOT NULL ,
    certification_date varchar(9) DEFAULT CAST(SYSDATE as varchar(9))NOT NULL,
    CONSTRAINT pk_certificate_id primary key (certificate_id)
);

CREATE TABLE REGISTRATION(
    registration_id varchar(17) NOT NULL ,  -- BSCS-20-001
    applicant_id varchar(15) NOT NULL ,
    registered_by varchar(11) NOT NULL ,
    payment_id varchar(9) NOT NULL ,
    registration_year int NOT NULL,
    CONSTRAINT pk_registration primary key (registration_id),
    constraint domain_reg_year check ( registration_year > 2000 )
);

ALTER TABLE PAYCHECK
ADD(
    constraint fk_paycheck_employee foreign key (employee_id) references EMPLOYEE(EMPLOYEE_ID),
    constraint fk_paycheck_faculty foreign key (faculty_id) references FACULTY(FACULTY_ID),
    constraint fk_paycheck_bank_account foreign key (paid_from) references BANK_ACCOUNT(ACCOUNT_NO)
);

ALTER TABLE GATE_CHECKIN
ADD(
    constraint fk_gate_checkin_faculty_id foreign key (faculty_id) references FACULTY(FACULTY_ID),
    constraint fk_gate_checkin_student foreign key (std_id) references STUDENT(std_id),
    constraint fk_gate_checkin_gate foreign key (GATE_id) references GATE(GATE_id)
);

ALTER TABLE GATE
ADD(
    constraint fk_gate_employee foreign key (head_guard) references EMPLOYEE(EMPLOYEE_ID)
);

ALTER TABLE GRADE
ADD(
    CONSTRAINT fk_grade_enrollment foreign key (ENROLLMENT_ID) references ENROLLMENT(ENROLLMENT_ID)
);

ALTER TABLE student_sgpa
ADD(
    CONSTRAINT fk_student_sgpa_std_id foreign key (student_id) references student(std_id),
    CONSTRAINT fk_student_sgpa_semester foreign key (semester_id) references SEMESTER(semester_id)
);

ALTER TABLE department
ADD(
    CONSTRAINT fk_dept_faculty_hod foreign key (hod) references FACULTY(FACULTY_ID)
);

ALTER TABLE FACULTY
ADD(
    CONSTRAINT fk_faculty_department_dept_id foreign key (DEPT_ID) references DEPARTMENT(DEPT_ID)
);

ALTER TABLE program
ADD(
    CONSTRAINT fk_program_department_dept_id foreign key (dept_id) references department(DEPT_ID)
);

ALTER TABLE PROGRAM_COURSE_ROADMAP
ADD (
    CONSTRAINT fk_prg_course_rel_prg_id foreign key (prg_id) references PROGRAM(prg_id),
    CONSTRAINT fk_prg_course_rel_course_code foreign key (course_code) references COURSE(course_code),
    CONSTRAINT fk_prg_course_rel_semester foreign key (semester) references SEMESTER(SEMESTER_ID)
);

ALTER TABLE student
ADD (
    CONSTRAINT fk_student_program foreign key (program) references program(prg_id),
    CONSTRAINT fk_student_section foreign key (section, program) references SECTION(SECTION_ID, program),
    CONSTRAINT fk_student_registration foreign key (registration_id) references REGISTRATION(registration_id)
);

ALTER TABLE SECTION
ADD (
    CONSTRAINT fk_section_program_program foreign key (PROGRAM) references PROGRAM(prg_id)
);

ALTER TABLE ENROLLMENT
ADD (
    CONSTRAINT fk_enrollment_prg_course_rel foreign key (prg_id,course_code) references PROGRAM_COURSE_ROADMAP(prg_id, course_code),
    CONSTRAINT fk_enrollment_student foreign key (student_id, prg_id) references STUDENT(std_id, program),
    CONSTRAINT fk_enrollment_section foreign key (section, prg_id) references SECTION(SECTION_ID, PROGRAM)
);

ALTER TABLE FACULTY_ALLOCATION
ADD (
    CONSTRAINT fk_faculty_allocation_course foreign key (course_code) references COURSE(course_code),
    CONSTRAINT fk_faculty_allocation_section foreign key (section_id) references SECTION(section_id),
    CONSTRAINT fk_faculty_allocation_faculty foreign key (faculty_id) references FACULTY(faculty_id)
);

ALTER TABLE APPLICATION
ADD(
    CONSTRAINT fk_application_program foreign key (program) references program(prg_id)
);

ALTER TABLE CERTIFICATE
ADD(
    CONSTRAINT fk_certificate_registration foreign key (std_registration_id) references REGISTRATION(registration_id)
);

ALTER TABLE REGISTRATION
ADD(
    CONSTRAINT fk_registration_application foreign key (applicant_id) references APPLICATION(applicant_id),
    CONSTRAINT fk_registration_employee foreign key (registered_by) references EMPLOYEE(EMPLOYEE_ID),
    CONSTRAINT fk_registration_fulfilled_challan foreign key (payment_id) references FULFILLED_CHALLAN(payment_id)
);

ALTER TABLE MISC_PAYMENT_STRUCTURE
ADD(
    CONSTRAINT fk_misc_payment_struct_program foreign key (program) references program(prg_id)
);

ALTER TABLE MISC_CHALLAN
ADD(
    CONSTRAINT fk_misc_challan_misc_payment_struct foreign key (collection_code) references MISC_PAYMENT_STRUCTURE(collection_code),
    CONSTRAINT fk_misc_challan_applicant_id foreign key (applicant_id) references APPLICATION(applicant_id),
    CONSTRAINT fk_misc_challan_issued_by foreign key (ISSUED_BY) references EMPLOYEE(EMPLOYEE_ID)
);

ALTER TABLE BANK_ACCOUNT
ADD(
    CONSTRAINT fk_bank_account_partner_bank foreign key (BANK_ID) references PARTNER_BANK(BANK_ID)
);

ALTER TABLE FEE_STRUCTURE
ADD(
    CONSTRAINT fk_fee_structure_program foreign key (prg_id) references program(prg_id),
    CONSTRAINT fk_fee_structure_semester foreign key (semester) references SEMESTER(SEMESTER_ID)
);

ALTER TABLE FULFILLED_CHALLAN
ADD (
    CONSTRAINT fk_fulfilled_challan_fee_challan foreign key (FEE_CHALLAN_ID) references FEE_CHALLAN(CHALLAN_ID),
    CONSTRAINT fk_fulfilled_challan_misc_fee_challan foreign key (MISC_CHALLAN_ID) references MISC_CHALLAN(CHALLAN_ID),
    CONSTRAINT fk_fulfilled_challan_employee_validator foreign key (VALIDATED_BY) references EMPLOYEE(EMPLOYEE_ID),
    CONSTRAINT fk_fulfilled_challan_bank_account foreign key (dep_account) references BANK_ACCOUNT(ACCOUNT_NO)
);

ALTER TABLE FEE_CHALLAN
ADD(
    CONSTRAINT fk_fee_challan_student foreign key (STUDENT_ID) references student(std_id),
    CONSTRAINT fk_fee_challan_employee foreign key (ISSUED_BY) references EMPLOYEE(EMPLOYEE_ID),
    CONSTRAINT fk_fee_challan_fee_structure foreign key (collection_code) references FEE_STRUCTURE(collection_code)
);

ALTER TABLE EMPLOYEE
ADD(
    CONSTRAINT fk_employee_job foreign key (JOB) references JOBS(JOB_ID)
);


/*
    PROCEDURES FUNCTIONS AND TRIGGERS
*/

CREATE OR REPLACE PROCEDURE incr_sem_section
IS
BEGIN
    for sec in (select * from SECTION where STATUS = 'IN-TERM')
    LOOP
        UPDATE SECTION set SEMESTER = sec.semester+1 where SECTION_ID = sec.SECTION_ID;
    end loop;
end;
/

CREATE OR REPLACE procedure enroll_courses_all_sections
IS
BEGIN
    for rec in (select * from SECTION where STATUS = 'IN-TERM')
    LOOP
        ENROLL_SEM_COURSES(rec.SECTION_ID);
    end loop;
end;
/

CREATE OR REPLACE PROCEDURE turn_down_no_challan_applics
IS
BEGIN
    for rec in (select * from APPLICATION where status = 'Applied')
    LOOP
        update application set status = 'Application-Dropped' where applicant_id = rec.applicant_id;
    end loop;
end;
/

CREATE OR REPLACE TRIGGER increment_section_semester
    BEFORE UPDATE ON SECTION
    FOR EACH ROW
DECLARE
    temp_cgpa decimal(3,2);
    past_enrollments_finished int default 0;
BEGIN
    if(:old.semester = :new.semester)
    then
        return;
    end if;
    for rec in (select * from enrollment where enrollment.section = :old.section_id)
    LOOP
        if(rec.STATUS != 'FINISHED')
        THEN
            past_enrollments_finished := 1;
        end if;
    end loop;
    if(past_enrollments_finished = 1)
    THEN
        raise_application_error(-20001, 'Declare result of previous semester enrollments first...');
    end if;
    if(:new.semester - :old.semester != 1)
    THEN
        raise_application_error(-20001, 'SEMESTER CAN ONLY BE INCREMENTED BY 1');
    end if;
    if(:new.semester > GET_N_SEMESTERS(:old.PROGRAM))
    THEN
        :new.status := 'TERM-ENDED';
        :new.semester := 0;
        for stud in (select * from student where student.section = :old.section_id)
        LOOP
            update student set status = 'GRADUATED' where std_id = stud.std_id;
            select CAST(sum(SGPA)/count(SGPA) as DECIMAL(3,2)) into temp_cgpa from student_sgpa where student_id = stud.std_id;
            INSERT INTO CERTIFICATE (std_registration_id, CGPA, CERTIFICATION_DATE)
            VALUES (
                    stud.registration_id,
                    temp_cgpa,
                    concat(concat(LPAD(FLOOR(DBMS_RANDOM.VALUE(1,30)), 2, '0'), '-'),CONCAT('DEC-',substr(CAST(:old.session_year as int)+4, -2))));
        end loop;
    end if;
end;
/

CREATE OR REPLACE FUNCTION get_1fac_prg(prg PROGRAM.prg_id%type)
RETURN FACULTY.faculty_id%type
IS
    fact_id_ FACULTY.faculty_id%type;
BEGIN
    select FACULTY.FACULTY_ID into fact_id_ from FACULTY INNER JOIN program on program.dept_id = FACULTY.DEPT_ID where program.prg_id = prg
    ORDER BY DBMS_RANDOM.VALUE() fetch first 1 row only;
    return fact_id_;
end;
/


CREATE OR REPLACE PROCEDURE allocate_courses
IS
BEGIN
    for sec in (select * from SECTION)
    LOOP
        for course in (select * from PROGRAM_COURSE_ROADMAP where semester = sec.semester and PROGRAM_COURSE_ROADMAP.prg_id = sec.PROGRAM)
        LOOP
            INSERT INTO FACULTY_ALLOCATION (section_id, faculty_id, course_code) VALUES (sec.SECTION_ID, get_1fac_prg(sec.PROGRAM), course.course_code);
        end loop;
    end loop;
end;
/

CREATE OR REPLACE FUNCTION get_n_semesters(
    program_id varchar
) RETURN NUMBER
IS
    t_semesters NUMBER DEFAULT 0;
BEGIN
    select no_semesters INTO  t_semesters from PROGRAM where PRG_ID = program_id;
    return t_semesters;
end;
/

CREATE OR REPLACE FUNCTION get_1emp_job_id(
    inp_job_id varchar
) RETURN varchar
IS
    out_emp_id varchar(11);
BEGIN
    select EMPLOYEE_ID INTO out_emp_id from EMPLOYEE where EMPLOYEE.JOB = inp_job_id order by DBMS_RANDOM.VALUE() fetch first 1 row only;
    return out_emp_id;
end;
/

CREATE OR REPLACE FUNCTION get_misc_col_code(
    inp_prog varchar,
    inp_app_type varchar
) RETURN varchar
IS
    out_col_code MISC_PAYMENT_STRUCTURE.COLLECTION_CODE%type;
BEGIN
    select COLLECTION_CODE INTO out_col_code from MISC_PAYMENT_STRUCTURE where PROGRAM = inp_prog and payment_TYPE = inp_app_type;
    return out_col_code;
end;
/

CREATE OR REPLACE PROCEDURE auto_admit_challan_issue(
    year varchar
)
IS
    applic_collection_code MISC_PAYMENT_STRUCTURE.COLLECTION_CODE%type;
    issuer_emp varchar(11);
    app_count int;
BEGIN
    select ceil(count(*) * 0.8) into app_count from APPLICATION where APPLICATION.status = 'Applied' and substr(application_date,-2) = year;
    FOR record in (
        select * from APPLICATION where APPLICATION.status = 'Applied' and substr(application_date,-2) = year order by DBMS_RANDOM.VALUE() fetch first app_count rows only
    )
    LOOP
        issuer_emp := get_1emp_job_id('fs_receipt');
        applic_collection_code := get_misc_col_code(record.program, 'ADMISSION');
        INSERT INTO MISC_CHALLAN (COLLECTION_CODE, APPLICANT_ID, ISSUED_BY)  VALUES (applic_collection_code, record.APPLICANT_ID, issuer_emp);
    end loop;
end;
/

CREATE OR REPLACE PROCEDURE auto_registration_challan_issue(
    year varchar
)
IS
    applic_collection_code MISC_PAYMENT_STRUCTURE.COLLECTION_CODE%type;
    issuer_emp varchar(11);
    app_count int;
BEGIN
    select ceil(count(*) * 0.9) into app_count from APPLICATION where APPLICATION.status = 'On-list' and substr(application_date,-2) = year;
    FOR record in (
        select * from APPLICATION where APPLICATION.status = 'On-list' and substr(application_date,-2) = year order by DBMS_RANDOM.VALUE() fetch first app_count rows only
    )
    LOOP
        issuer_emp := get_1emp_job_id('fs_receipt');
        applic_collection_code := get_misc_col_code(record.program, 'REGISTRATION');
        INSERT INTO MISC_CHALLAN (COLLECTION_CODE, APPLICANT_ID, ISSUED_BY)  VALUES (applic_collection_code, record.APPLICANT_ID, issuer_emp);
    end loop;
end;
/

CREATE OR REPLACE FUNCTION get_payment_type(
    col_code MISC_PAYMENT_STRUCTURE.COLLECTION_CODE%type
) RETURN MISC_PAYMENT_STRUCTURE.payment_type%type
IS
    out_payment_type MISC_PAYMENT_STRUCTURE.payment_type%type;
BEGIN
    select PAYMENT_TYPE into out_payment_type from MISC_PAYMENT_STRUCTURE where COLLECTION_CODE = col_code;
    return out_payment_type;
end;
/

CREATE OR REPLACE PROCEDURE fulfill_challans_register(
    year int
)
IS
    app_count int;
    rec_challan_id MISC_CHALLAN.CHALLAN_ID%type;
    rec_payment_id FULFILLED_CHALLAN.PAYMENT_ID%type;
    rand_int int;
    rand_int_2 int;
BEGIN
    select ceil(count(*) * 0.9) into app_count from APPLICATION where status = 'Registration challan issued' and substr(application_date,-2) = year;
    for rec in (
        select applicant_id from APPLICATION where status = 'Registration challan issued' and substr(application_date,-2) = year
        order by DBMS_RANDOM.VALUE() fetch first app_count rows only
    )
    LOOP
        select CHALLAN_ID INTO rec_challan_id from MISC_CHALLAN where APPLICANT_ID = rec.applicant_id and get_payment_type(collection_code) = 'REGISTRATION';
        select FLOOR(DBMS_RANDOM.VALUE(0, 2.9)) INTO rand_int from DUAL;
        select FLOOR(DBMS_RANDOM.VALUE(0, 1.9)) INTO rand_int_2 from DUAL;

        INSERT INTO FULFILLED_CHALLAN (MISC_CHALLAN_ID, VALIDATED_BY, DEP_ACCOUNT, PAYMENT_MODE)
        VALUES (
                rec_challan_id,
                get_1emp_job_id('fs_incharge'),
                CASE
                    WHEN rand_int = 0 THEN '05787689123467'
                    WHEN rand_int = 1 THEN '45014567808531'
                    when rand_int = 2 THEN '09723554214684'
                END ,
                CASE
                    WHEN  rand_int_2 = 0 then 'ON-BRANCH'
                    WHEN rand_int_2 = 1 THEN 'ONLINE'
                END);
        select PAYMENT_ID INTO rec_payment_id from FULFILLED_CHALLAN where MISC_CHALLAN_ID = rec_challan_id;
        INSERT INTO REGISTRATION (APPLICANT_ID, REGISTERED_BY, PAYMENT_ID, REGISTRATION_YEAR) VALUES (rec.applicant_id, get_1emp_job_id('uni_registrar'), rec_payment_id, CONCAT('20', year));
    end loop;
end;
/

CREATE OR REPLACE PROCEDURE fulfill_challans_admit(
    year int
)
IS
    app_count int;
    rec_challan_id MISC_CHALLAN.CHALLAN_ID%type;
    rand_int int;
    rand_int_2 int;
BEGIN
    select ceil(count(*) * 0.8) into app_count from APPLICATION where status = 'Application challan Issued' and substr(application_date,-2) = year;
    for rec in (
        select applicant_id from APPLICATION where status = 'Application challan Issued' and substr(application_date,-2) = year
        order by DBMS_RANDOM.VALUE() fetch first app_count rows only
    )
    LOOP
        select CHALLAN_ID INTO rec_challan_id from MISC_CHALLAN where APPLICANT_ID = rec.applicant_id and get_payment_type(collection_code) = 'ADMISSION';
        select FLOOR(DBMS_RANDOM.VALUE(0, 2.9)) INTO rand_int from DUAL;
        select FLOOR(DBMS_RANDOM.VALUE(0, 1.9)) INTO rand_int_2 from DUAL;
        INSERT INTO FULFILLED_CHALLAN (MISC_CHALLAN_ID, VALIDATED_BY, DEP_ACCOUNT, PAYMENT_MODE)
        VALUES (
                rec_challan_id,
                get_1emp_job_id('fs_incharge'),
                CASE
                    WHEN rand_int = 0 THEN '05787689123467'
                    WHEN rand_int = 1 THEN '45014567808531'
                    when rand_int = 2 THEN '09723554214684'
                END ,
                CASE
                    WHEN  rand_int_2 = 0 then 'ON-BRANCH'
                    WHEN rand_int_2 = 1 THEN 'ONLINE'
                END);
    end loop;
end;
/

CREATE OR REPLACE PROCEDURE auto_merit_listing(
    year varchar
)
IS
    sel_count int;
BEGIN
    for prg in (
        select distinct program from APPLICATION where status = 'Application in-process' and substr(application_date,-2) = year
    )
    LOOP
        select count(*) into sel_count
        from APPLICATION where APPLICATION.status = 'Application in-process' and APPLICATION.program = prg.program and substr(APPLICATION.application_date,-2) = year;
        sel_count := ceil(sel_count * 0.8);
        for on_list_rec in (
            select * from APPLICATION where program = prg.program and APPLICATION.status = 'Application in-process' and substr(application_date,-2) = year
            order by (matric_marks + APPLICATION.inter_marks) desc fetch first sel_count rows only
        )
        LOOP
            UPDATE APPLICATION SET STATUS = 'On-list' where APPLICANT_ID = on_list_rec.applicant_id;
        end loop;

        FOR not_on_list_rec in (
            select * from APPLICATION where program = prg.program and APPLICATION.status = 'Application in-process'
        )
        LOOP
            UPDATE APPLICATION SET STATUS = 'not-on-list' where applicant_id = not_on_list_rec.applicant_id;
        end loop;
    end loop;
end;
/

CREATE OR REPLACE FUNCTION get_employee_job(
    inp_emp_id varchar
) RETURN varchar
IS
    out_job_id varchar(20);
BEGIN
    select job INTO out_job_id from EMPLOYEE where EMPLOYEE_ID=inp_emp_id;
    return out_job_id;
end;
/

CREATE OR REPLACE FUNCTION get_job_salary(
    inp_job_id varchar
) RETURN NUMBER
IS
    salary NUMBER DEFAULT 0;
BEGIN
    select max_salary INTO  salary from JOBS where JOBS.JOB_ID = inp_job_id;
    return salary;
end;
/

CREATE OR REPLACE FUNCTION get_std_id_from_enrollment(enr_id ENROLLMENT.ENROLLMENT_ID%type)
RETURN student.std_id%type
IS
    out_std_id student.std_id%type;
BEGIN
    select STUDENT_ID INTO out_std_id FROM ENROLLMENT where enrollment_id = enr_id;
    return out_std_id;
end;
/


CREATE OR REPLACE FUNCTION get_course_code_from_enrollment(enr_id ENROLLMENT.ENROLLMENT_ID%type)
RETURN course.course_code%type
IS
    out_course_code course.course_code%type;
BEGIN
    select course_code INTO out_course_code FROM ENROLLMENT where enrollment_id = enr_id;
    return out_course_code;
end;
/

CREATE OR REPLACE FUNCTION get_grade_status_from_enrollment(enr_id ENROLLMENT.ENROLLMENT_ID%type)
RETURN GRADE.STATUS%type
IS
    out_status GRADE.STATUS%type;
BEGIN
    select GRADE.STATUS INTO out_status FROM GRADE where enrollment_id = enr_id;
    return out_status;
end;
/


-- THIS PROCEDURE WILL PRODUCE DUMMY REPEAT ENROLLMENTS FOR some 20 batch studs in Enrollments with 21 batch studs for repeat purpose
CREATE OR REPLACE procedure generate_dummy_repeat_enrolls
IS
    temp_section varchar(7);
    temp_new_enrol_id ENROLLMENT.ENROLLMENT_ID%type;
    rand_int int;
    temp_course_code COURSE.course_code%type;
BEGIN
    select FLOOR(count(*)*0.2) into rand_int from student where section in (select SECTION_ID from SECTION where session_year = 2020);

    for stud in ( select *
                  from student
                  where section in
                        (select SECTION_ID
                         from SECTION
                         where session_year = 2020)
                  order by DBMS_RANDOM.VALUE() fetch first rand_int rows only)
    LOOP
        temp_section := CONCAT(substr(stud.section, 1, 2), CONCAT('-21-', substr(stud.section, -1)));
        select course_code
        into temp_course_code
        from PROGRAM_COURSE_ROADMAP
        where prg_id = stud.program and
              semester = 1
        order by DBMS_RANDOM.VALUE() fetch first 1 rows only;
        INSERT INTO ENROLLMENT (prg_id, section, course_code, student_id, enrollment_type) VALUES (stud.program, temp_section, temp_course_code, stud.std_id, 'REPEAT');
        select enrollment_id into temp_new_enrol_id from ENROLLMENT where student_id = stud.std_id and enrollment_type = 'REPEAT' and course_code = temp_course_code;
        INSERT INTO GRADE
            (ENROLLMENT_ID, quiz, assignment, mid_term, final)
        values
            (temp_new_enrol_id,
             FLOOR(DBMS_RANDOM.value(7, 10.99)),
             FLOOR(DBMS_RANDOM.value(7, 10.99)),
             FLOOR(DBMS_RANDOM.value(15, 20.99)),
             FLOOR(DBMS_RANDOM.value(50, 59.99)));
    end loop;
end;
/

CREATE OR REPLACE FUNCTION GET_SEMESTER_FROM_COURSE_CODE (
    COURSE_CODE_ COURSE.COURSE_CODE%type,
    prg_id_  program.prg_id%type
)
RETURN int
IS
    out_sem_id int;
BEGIN
    select semester into out_sem_id from PROGRAM_COURSE_ROADMAP where course_code = COURSE_CODE_ and prg_id = prg_id_;
    return out_sem_id;
end;
/

-- This trigger will run on insert of a record that is if a student is improving
-- a course grade that is same std_id and same course_code but different enrollment_id
-- Then if new grade is better than the previous enrollment than the PASS status will be
-- converted to DISCARDED which means that the enrollment will not be counted
-- Moreover ENROLLMENT STATUS WILL BE UPDATED TO FINISHED WHENEVER A NEW GRADE IS INSERTED
CREATE OR REPLACE TRIGGER update_status_grade
    BEFORE INSERT
    ON GRADE
    FOR EACH ROW
DECLARE
    temp_grade GRADE%rowtype;
    total_sum_cr_hrs float default 0;
    cr_hrs_got float default 0;
    temp_cr_hr float;
    temp_gp float;
    temp_SGPA DECIMAL(3,2);
BEGIN
    UPDATE ENROLLMENT SET ENROLLMENT.STATUS = 'FINISHED' WHERE ENROLLMENT_ID = :new.enrollment_id;
    for record in (
        SELECT *
        FROM  ENROLLMENT
        WHERE ENROLLMENT.student_id = get_std_id_from_enrollment(:new.ENROLLMENT_ID) and
              ENROLLMENT.course_code = GET_COURSE_CODE_FROM_ENROLLMENT(:new.ENROLLMENT_ID)
              and ENROLLMENT.enrollment_id != :new.enrollment_id)
    LOOP
        if (GET_GRADE_STATUS_FROM_ENROLLMENT(record.enrollment_id) != 'PASS')
        THEN
            return;
        end if;
        select * into temp_grade from GRADE where ENROLLMENT_ID = record.enrollment_id;
        IF ((:new.quiz + :new.mid_term + :new.final + :new.assignment) > (temp_grade.final+temp_grade.assignment+temp_grade.mid_term+temp_grade.quiz)) THEN
            UPDATE GRADE SET status = 'DISCARDED' WHERE ENROLLMENT_ID = temp_grade.ENROLLMENT_ID;
            select calc_gp(:new.quiz, :new.mid_term, :new.final, :new.assignment) into temp_gp from dual;
            select credit_hours into temp_cr_hr from COURSE where COURSE_CODE = record.course_code;
            cr_hrs_got := cr_hrs_got + (temp_gp * temp_cr_hr);
            total_sum_cr_hrs := total_sum_cr_hrs + temp_cr_hr;
            for course_ in ( select * from PROGRAM_COURSE_ROADMAP
                                      where prg_id = record.prg_id and
                                            semester = GET_SEMESTER_from_course_code(record.course_code, record.prg_id)
                                            and course_code != record.course_code)
            LOOP
                select CREDIT_HOURS into temp_cr_hr from COURSE where COURSE_CODE = course_.course_code;
                total_sum_cr_hrs := total_sum_cr_hrs + temp_cr_hr;
                select grade_points into temp_gp
                from ENROLLMENT
                    INNER JOIN GRADE
                        on GRADE.ENROLLMENT_ID = ENROLLMENT.enrollment_id
                where GRADE.status  != 'DISCARDED' and
                      ENROLLMENT.student_id = record.student_id and
                      ENROLLMENT.course_code = course_.course_code;
                cr_hrs_got := cr_hrs_got + (temp_cr_hr * temp_gp);
            end loop;
            select CAST((cr_hrs_got/total_sum_cr_hrs) as DECIMAL(3,2)) into temp_SGPA from DUAL;
            DBMS_OUTPUT.PUT_LINE(temp_SGPA);
            UPDATE STUDENT_SGPA SET SGPA = CAST(temp_SGPA as FLOAT) where STUDENT_SGPA.student_id = record.student_id and STUDENT_SGPA.semester_id = GET_SEMESTER_from_course_code(record.course_code, record.prg_id);
        end if;
    END LOOP;
end;
/


CREATE OR REPLACE function calc_gp(
    inp_a int,
    inp_m int,
    inp_f int,
    inp_q int
) RETURN DECIMAL
IS
    tot_marks int;
    percentage float;
    out_grade varchar(2);
    out_gp float;
BEGIN
    tot_marks := inp_a + inp_f + inp_m + inp_q;
    percentage := (tot_marks/100.0) * 100;
    out_grade := CASE WHEN percentage >= 86 and percentage <= 100 THEN 'A+'
                     WHEN percentage >= 82 and percentage < 86 THEN 'A-'
                     WHEN percentage >= 78 and percentage < 82 THEN 'B+'
                     WHEN percentage >= 74 and percentage < 78 then 'B'
                     WHEN percentage >= 70 and percentage < 74 then 'B-'
                     WHEN percentage >= 66 and percentage < 70 then 'C+'
                     WHEN percentage >= 62 and percentage < 66 then 'C'
                     WHEN percentage >= 58 and percentage < 62 then 'C-'
                     WHEN percentage >= 54 and percentage < 58 then 'D+'
                     WHEN percentage >= 50 and percentage < 54 then 'D'
                     WHEN percentage < 50 then 'F' END;
    out_gp :=
        CASE
            WHEN out_grade = 'A+' THEN 4.0
            WHEN out_grade = 'A-' THEN 3.67
            WHEN out_grade = 'B+' THEN 3.33
            WHEN out_grade = 'B' THEN 3.00
            WHEN out_grade = 'B-' THEN 2.67
            WHEN out_grade = 'C+' THEN 2.33
            WHEN out_grade = 'C' THEN 2.00
            WHEN out_grade = 'C-' THEN 1.67
            WHEN out_grade = 'D+' THEN 1.33
            WHEN out_grade = 'D' THEN 1.00
            WHEN out_grade = 'F' THEN 0.00
        END;
    return out_gp;
end;
/

CREATE OR REPLACE TRIGGER ensure_issuer_post_misc_challan
    BEFORE INSERT
    ON MISC_CHALLAN
    FOR EACH ROW
BEGIN
    IF (get_employee_job(:new.issued_by) != 'fs_receipt')
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Challan can only be issued by employees with job-id: fs_receipt');
    end if;
end;
/

CREATE OR REPLACE TRIGGER ensure_issuer_post_fee_challan
    BEFORE INSERT
    ON FEE_CHALLAN
    FOR EACH ROW
BEGIN
    IF (get_employee_job(:new.issued_by) != 'fs_receipt')
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Challan can only be issued by employees with job-id: fs_receipt');
    end if;
end;
/

CREATE OR REPLACE TRIGGER ensure_registrar_post
    BEFORE INSERT
    ON REGISTRATION
    FOR EACH ROW
BEGIN
    IF (get_employee_job(:new.registered_by) != 'uni_registrar')
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Registrations can only be registered by employees with job-id: uni-registrar');
    end if;
end;
/

CREATE OR REPLACE TRIGGER ensure_employee_salary
    BEFORE INSERT
    ON EMPLOYEE
    FOR EACH ROW
BEGIN
    if (:new.salary > get_job_salary(:new.JOB))
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be greater than max salary of this post...');
    end if;
end;
/

CREATE OR REPLACE TRIGGER ensure_challan_validator_post
    BEFORE INSERT
    ON FULFILLED_CHALLAN
    FOR EACH ROW
BEGIN
    IF (get_employee_job(:new.VALIDATED_BY) != 'fs_incharge')
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Challan can only be validated by employees with job-id: fs_incharge');
    end if;
end;
/

CREATE OR REPLACE TRIGGER ensure_gate_head_guard_post
    BEFORE INSERT
    ON GATE
    FOR EACH ROW
BEGIN
    IF (get_employee_job(:new.head_guard) != 'gate_guard')
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Head GUard of a gate can only be a security guard with job-id: gate_guard');
    end if;
end;
/

-- This trigger will be fired whenever a grade
-- record is inserted or updated that is GRADE
-- will be calculated and assigned and STATUS
-- will also be assigned either PASS or FAIL
CREATE OR REPLACE TRIGGER calculate_grade_after_insert
    BEFORE INSERT OR UPDATE
    ON GRADE FOR EACH ROW
DECLARE
    tot_marks int;
    percentage float;
    out_grade varchar(2);
    out_status varchar(4);
    out_gp float;
BEGIN
    IF :new.status = 'DISCARDED'
    THEN
        return ;
    end if;
    tot_marks := :NEW.assignment + :new.quiz + :NEW.mid_term + :NEW.final ;
    percentage := (tot_marks/100.0) * 100;
    out_grade := CASE WHEN percentage >= 86 and percentage <= 100 THEN 'A+'
                     WHEN percentage >= 82 and percentage < 86 THEN 'A-'
                     WHEN percentage >= 78 and percentage < 82 THEN 'B+'
                     WHEN percentage >= 74 and percentage < 78 then 'B'
                     WHEN percentage >= 70 and percentage < 74 then 'B-'
                     WHEN percentage >= 66 and percentage < 70 then 'C+'
                     WHEN percentage >= 62 and percentage < 66 then 'C'
                     WHEN percentage >= 58 and percentage < 62 then 'C-'
                     WHEN percentage >= 54 and percentage < 58 then 'D+'
                     WHEN percentage >= 50 and percentage < 54 then 'D'
                     WHEN percentage < 50 then 'F' END;
    out_gp :=
        CASE
            WHEN out_grade = 'A+' THEN 4.0
            WHEN out_grade = 'A-' THEN 3.67
            WHEN out_grade = 'B+' THEN 3.33
            WHEN out_grade = 'B' THEN 3.00
            WHEN out_grade = 'B-' THEN 2.67
            WHEN out_grade = 'C+' THEN 2.33
            WHEN out_grade = 'C' THEN 2.00
            WHEN out_grade = 'C-' THEN 1.67
            WHEN out_grade = 'D+' THEN 1.33
            WHEN out_grade = 'D' THEN 1.00
            WHEN out_grade = 'F' THEN 0.00
        END;

    :new.grade_points := out_gp;
    out_status := CASE WHEN percentage >= 50 THEN 'PASS' WHEN percentage < 50 THEN 'FAIL' END;
    :new.grade := out_grade;
    :new.status := out_status;
end;
/

CREATE OR REPLACE TRIGGER increm_prg_total_cr_hrs
    AFTER INSERT
    ON PROGRAM_COURSE_ROADMAP
    FOR EACH ROW
DECLARE
    inc_course_cr_hr NUMBER;
    increment_in int;
BEGIN
    select credit_hours INTO increment_in from PROGRAM where prg_id = :new.prg_id;
    select CREDIT_HOURS INTO inc_course_cr_hr from COURSE where COURSE_CODE = :new.course_code;
    UPDATE program set credit_hours = (increment_in + inc_course_cr_hr) where prg_id = :new.prg_id;
end;
/

CREATE OR REPLACE TRIGGER ensure_student_section_session_integrity
    BEFORE UPDATE
    ON student
    FOR EACH ROW
declare
    reg_session int;
    section_session int;
BEGIN
    if(:new.section = :old.section)
    THEN
        return;
    end if;
    select registration_year INTO reg_session from registration where REGISTRATION.registration_id = :old.registration_id;
    select SECTION.session_year INTO section_session from section where section_id = :new.section;
    if (reg_session != section_session)
        THEN
            RAISE_APPLICATION_ERROR(-20001, 'Section and student registration session year must match');
    end if;
end;
/

CREATE OR REPLACE TRIGGER generate_misc_payment_structure
    BEFORE INSERT
    ON MISC_PAYMENT_STRUCTURE
    FOR EACH ROW
BEGIN
    :new.collection_code := CONCAT(CONCAT(substr(:new.PAYMENT_TYPE, 1,3), '-') , substr(:new.program, -2));
end;
/

CREATE OR REPLACE TRIGGER generate_fee_structure_col_code
    BEFORE INSERT
    ON FEE_STRUCTURE
    FOR EACH ROW
BEGIN
    :new.collection_code := CONCAT(CONCAT(CONCAT(CONCAT('FEE-',:NEW.prg_id), '-'),'S'),:new.semester);
end;
/

CREATE OR REPLACE TRIGGER assign_registration_id
    BEFORE INSERT
    ON REGISTRATION
    FOR EACH ROW
DECLARE
    id_num int;
    inp_program varchar(5);
BEGIN
    select program into inp_program from APPLICATION where APPLICATION.applicant_id = :new.applicant_id;
    select count(*) INTO id_num FROM REGISTRATION
    INNER JOIN APPLICATION ON APPLICATION.applicant_id = REGISTRATION.applicant_id
    WHERE registration_year = :new.registration_year and application.program = inp_program;
    id_num := id_num + 1;
    :new.registration_id := CONCAT(CONCAT('REG-' , UPPER(inp_program)),CONCAT(CONCAT('-', SUBSTR(:new.registration_year,-2)), CONCAT('-' , LPAD(id_num, 4, '0'))));
end;
/

CREATE OR REPLACE PROCEDURE assign_student_id_after_registry(
    year varchar
)
IS
    id_num int;
    inp_program varchar(5);
    std_id_to_be varchar(12);
    phone_no_ varchar(14);
    cnic_ varchar(13);
    name_ varchar(50);
    f_name varchar(50);
    section_to_be varchar(11);
    sec_count int;
BEGIN
    for rec in (
        select * from REGISTRATION where registration_year = concat('20', year)
    )
    LOOP
        select program into inp_program from APPLICATION where APPLICATION.applicant_id = rec.applicant_id;

        id_num := cast(substr(rec.registration_id, -4) as int);

        select program, applicant_name, applicant_father_name, cnic, phone_no into inp_program, name_, f_name, cnic_, phone_no_ from APPLICATION where APPLICATION.applicant_id = rec.applicant_id;

        section_to_be := CASE WHEN MOD(id_num,2) = 0 THEN CONCAT(CONCAT(SUBSTR(inp_program,-2) , CONCAT('-',year)),concat('-', 'A'))
                         WHEN MOD(id_num,2) = 1 THEN CONCAT(CONCAT(SUBSTR(inp_program,-2) , CONCAT('-',year)),concat('-', 'B')) END;

        select count(*) INTO sec_count from SECTION where SECTION_ID = section_to_be;
        if (sec_count = 0)
        THEN
            INSERT INTO SECTION (SECTION_ID, PROGRAM, SESSION_YEAR) VALUES (section_to_be , inp_program, concat('20', year));
        end if;

        std_id_to_be := CONCAT( CONCAT(CONCAT(LPAD(id_num, 4, '0') , '-'), CONCAT(UPPER(inp_program), '-')), year);
        INSERT INTO STUDENT (STD_ID, REGISTRATION_ID, STD_NAME, FATHER_NAME, PHONE_NO, CNIC, PROGRAM, SECTION)
        VALUES (std_id_to_be, rec.registration_id, name_, f_name, phone_no_, cnic_, inp_program, section_to_be);
    end loop;
end;
/


CREATE OR REPLACE TRIGGER assign_employee_id
    BEFORE INSERT
    ON EMPLOYEE
    FOR EACH ROW
DECLARE
    id_num int;
BEGIN
    select seq_employee.nextval INTO id_num from dual;
    :new.employee_id := CONCAT('emp-' , LPAD(id_num, 6, '0'));
end;
/


CREATE OR REPLACE TRIGGER assign_checkin_id
    BEFORE INSERT
    ON GATE_CHECKIN
    FOR EACH ROW
DECLARE
    id_num int;
BEGIN
    select seq_gate_checkin.nextval INTO id_num from dual;
    :new.checkin_id := CONCAT('CIN-' , LPAD(id_num, 8, '0'));
end;
/


CREATE OR REPLACE TRIGGER assign_fulfilled_challan_payment_id
    BEFORE INSERT
    ON FULFILLED_CHALLAN
    FOR EACH ROW
DECLARE
    id_num int;
BEGIN
    select seq_fulfilled_challan.nextval INTO id_num from dual;
    :new.payment_id := CONCAT('fc-',LPAD(id_num, 6, '0'));
end;
/

CREATE OR REPLACE TRIGGER assign_enrollment_id
    BEFORE INSERT
    ON ENROLLMENT
    FOR EACH ROW
DECLARE
    id_num int;
    random_num int;
BEGIN
    select seq_enrollment.nextval INTO id_num from dual;
    select FLOOR(DBMS_RANDOM.VALUE(1000, 9999)) into random_num from DUAL;
    :new.enrollment_id := CONCAT(CONCAT(CONCAT('ENR-' , random_num) , '-') , LPAD(id_num, 6, '0'));
end;
/

CREATE OR REPLACE TRIGGER assign_application_id
    BEFORE INSERT
    ON APPLICATION
    FOR EACH ROW
DECLARE
    id_num int;
    random_num varchar(4);
BEGIN
    select seq_application.nextval INTO id_num from dual;
    select CAST(FLOOR(DBMS_RANDOM.VALUE(100, 999)) as varchar(3)) into random_num from DUAL;
    :new.applicant_id := CONCAT(concat('APP-', random_num), concat('-' , LPAD(id_num, 7, '0')));
end;
/

CREATE OR REPLACE TRIGGER assign_paycheck_id
    BEFORE INSERT
    ON PAYCHECK
    FOR EACH ROW
DECLARE
    id_num int;
    random_num int;
BEGIN
    select seq_paycheck_id.nextval INTO id_num from dual;
    select FLOOR(DBMS_RANDOM.VALUE(100, 999)) into random_num from DUAL;
    :new.paycheck_id := CONCAT(concat('PC-' , random_num) , concat('-' , LPAD(id_num, 5, '0')));
end;
/


CREATE OR REPLACE TRIGGER assign_certificate_id
    BEFORE INSERT
    ON CERTIFICATE
    FOR EACH ROW
DECLARE
    id_num int;
    random_num int;
BEGIN
    select seq_certificate_id.nextval INTO id_num from dual;
    select FLOOR(DBMS_RANDOM.VALUE(100, 999)) into random_num from DUAL;
    :new.certificate_id := CONCAT(concat('CERT-' , random_num) , concat('-' , LPAD(id_num, 6, '0')));
end;
/

CREATE OR REPLACE TRIGGER assign_fac_id
    BEFORE INSERT
    ON FACULTY
    FOR EACH ROW
DECLARE
    id_num int;
BEGIN
    select seq_faculty.nextval INTO id_num from dual;
    :new.faculty_id := CONCAT('FAC-' , LPAD(id_num, 5, '0'));
end;
/

CREATE OR REPLACE TRIGGER assign_fee_challan_id
    BEFORE INSERT
    ON FEE_CHALLAN
    FOR EACH ROW
DECLARE
    id_num int;
    random_num int;
BEGIN
    select seq_fee_challan.nextval INTO id_num from dual;
    select FLOOR(DBMS_RANDOM.VALUE(1000000, 9999999)) into random_num from DUAL;
    :new.challan_id := CONCAT(CONCAT('FEE-' , random_num) , CONCAT('-' , LPAD(id_num, 6, '0')));
end;
/

CREATE OR REPLACE TRIGGER assign_misc_challan_id
    BEFORE INSERT
    ON MISC_CHALLAN
    FOR EACH ROW
DECLARE
    id_num int;
    random_num int;
    pay_type MISC_PAYMENT_STRUCTURE.payment_type%type;
BEGIN
    select GET_PAYMENT_TYPE(:new.collection_code) INTO pay_type from DUAL;
    select seq_misc_challan.nextval INTO id_num from dual;
    select FLOOR(DBMS_RANDOM.VALUE(1000000, 9999999)) INTO random_num from DUAL;
    :new.challan_id := CONCAT(CONCAT((CASE WHEN pay_type = 'ADMISSION' THEN 'ADD-' WHEN pay_type = 'REGISTRATION' THEN 'REG-' END) , random_num) , CONCAT('-' , LPAD(id_num, 6, '0')));
end;
/

CREATE OR REPLACE TRIGGER update_application_status_misc_challan_issued
    AFTER INSERT ON MISC_CHALLAN
    FOR EACH ROW
DECLARE
    payment_type_ MISC_PAYMENT_STRUCTURE.PAYMENT_TYPE%type;
BEGIN
    select payment_type INTO payment_type_ from MISC_PAYMENT_STRUCTURE where MISC_PAYMENT_STRUCTURE.collection_code = :new.collection_code;
    if (payment_type_ = 'ADMISSION')
    THEN
        UPDATE APPLICATION set status = 'Application challan Issued' where applicant_id = :new.applicant_id;
    ELSIF (payment_type_ = 'REGISTRATION')
    THEN
        UPDATE APPLICATION set status = 'Registration challan issued' where applicant_id = :new.applicant_id;
    end if;
end;
/

CREATE OR REPLACE PROCEDURE populate_paychecks_table
IS
    month_year date DEFAULT to_date('01/11/2020', 'DD/MM/YYYY');
    month_ PAYCHECK.month%type;
    year_ PAYCHECK.year%type;
    rand_int int;
    temp_date date;
BEGIN
    WHILE (month_year < to_date('01/11/2024', 'DD/MM/YYYY'))
    LOOP
        select EXTRACT(YEAR from month_year) INTO year_ from dual;
        select to_char(month_year,'Month') INTO month_ from dual;
        FOR fac in (
            select * from FACULTY
        )
        LOOP
            select FLOOR(DBMS_RANDOM.VALUE(0, 2.9)) INTO rand_int from DUAL;
            INSERT INTO PAYCHECK (faculty_id, paid_from, month, year)
            VALUES (
                    fac.FACULTY_ID,
                    CASE
                        WHEN rand_int = 0 THEN '04095423123451'
                        WHEN rand_int = 1 THEN '05784234525452'
                        WHEN rand_int = 2 THEN '09465324453456'
                    END ,
                    month_,
                    year_
                );
        end loop;

        FOR emp in (
            select * from EMPLOYEE
        )
        LOOP
            select FLOOR(DBMS_RANDOM.VALUE(0, 2.9)) INTO rand_int from DUAL;
            INSERT INTO PAYCHECK (employee_id, paid_from, month, year)
            VALUES (
                    emp.EMPLOYEE_ID,
                    CASE
                        WHEN rand_int = 0 THEN '04095423123451'
                        WHEN rand_int = 1 THEN '05784234525452'
                        WHEN rand_int = 2 THEN '09465324453456'
                    END ,
                    month_,
                    year_
                );
        end loop;
        select ADD_MONTHS(month_year, 1) INTO temp_date from DUAL;
        month_year := temp_date;
    end loop;
end;
/


CREATE OR REPLACE FUNCTION GET_SEMESTER (
    SECTION_ID_ SECTION.SECTION_ID%type
)
RETURN int
IS
    out_sem_id int;
BEGIN
    select semester into out_sem_id from SECTION where SECTION_ID = SECTION_ID_;
    return out_sem_id;
end;
/

CREATE OR REPLACE procedure auto_generate_fee_challan
IS
    std_sem int;
    challan_col_code FEE_STRUCTURE.COLLECTION_CODE%type;
BEGIN
    for stud in (select * from student where status != 'GRADUATED')
    LOOP
        select GET_SEMESTER(stud.section) into std_sem from dual;
        select collection_code into challan_col_code from FEE_STRUCTURE where semester = std_sem and prg_id = stud.program;
        INSERT INTO FEE_CHALLAN (STUDENT_ID, ISSUED_BY, collection_code) VALUES (stud.std_id, get_1emp_job_id('fs_receipt'), challan_col_code);
    end loop;
end;
/

CREATE OR REPLACE PROCEDURE auto_fulfill_fee_challan
IS
    rand_int int;
    rand_int_2 int;
BEGIN
    for f_chal in (select * from FEE_CHALLAN where status = 'UN-PAID')
    LOOP
        select FLOOR(DBMS_RANDOM.VALUE(0, 3.9)) INTO rand_int from DUAL;
        select FLOOR(DBMS_RANDOM.VALUE(0, 1.9)) INTO rand_int_2 from DUAL;
        INSERT INTO FULFILLED_CHALLAN (FEE_CHALLAN_ID, VALIDATED_BY, DEP_ACCOUNT, PAYMENT_MODE)
        VALUES
        (
            f_chal.CHALLAN_ID,
            get_1emp_job_id('fs_incharge'),
            CASE
                WHEN rand_int = 0 THEN '04093544352342'
                WHEN rand_int = 1 THEN '05787689123467'
                when rand_int = 2 THEN '45014567808531'
                when rand_int = 3 THEN '09723554214684'
            END ,
            CASE
                WHEN  rand_int_2 = 0 then 'ON-BRANCH'
                WHEN rand_int_2 = 1 THEN 'ONLINE'
            END
        );
    end loop;
end;
/

CREATE OR REPLACE TRIGGER update_fee_challan_status_paid
    AFTER INSERT ON FULFILLED_CHALLAN
    FOR EACH ROW
DECLARE
BEGIN
    if(:new.MISC_CHALLAN_ID IS NOT NULL)
    THEN
        return ;
    end if;
    UPDATE FEE_CHALLAN set status = 'PAID' where CHALLAN_ID = :new.FEE_CHALLAN_ID;
end;
/


CREATE OR REPLACE TRIGGER update_application_status_misc_challan_paid
    AFTER INSERT ON FULFILLED_CHALLAN
    FOR EACH ROW
DECLARE
    challan_col_code MISC_CHALLAN.challan_id%type;
    payment_type_ MISC_PAYMENT_STRUCTURE.PAYMENT_TYPE%type;
    applic_id APPLICATION.applicant_id%type;
BEGIN
    if(:new.MISC_CHALLAN_ID IS NULL)
    THEN
        return ;
    end if;
    select COLLECTION_CODE, applicant_id INTO challan_col_code, applic_id from MISC_CHALLAN where CHALLAN_ID = :new.misc_challan_id;
    select payment_type INTO payment_type_ from MISC_PAYMENT_STRUCTURE where MISC_PAYMENT_STRUCTURE.collection_code = challan_col_code;
    if (payment_type_ = 'ADMISSION')
    THEN
        UPDATE APPLICATION set status = 'Application in-process' where applicant_id = applic_id;
    ELSIF (payment_type_ = 'REGISTRATION')
    THEN
        UPDATE APPLICATION set status = 'Registered' where applicant_id = applic_id;
    end if;
end;
/



CREATE OR REPLACE PROCEDURE populate_gate_checkin(
    year varchar,
    dat_ varchar
)
IS
    curr_date date;
    rand_int int;
    rand_int_gt int;
    counter int default 1;
    target_date date;
    random_time varchar(16);
    nstd int;
    nfaculty int;
BEGIN
    select FLOOR(count(*) * 0.4) into nstd from student;
    select FLOOR(count(*) * 0.6) into nfaculty from FACULTY;
    select to_date(CONCAT(CONCAT(lpad(dat_, 2, '0'),  '/11/'), concat(20,year)), 'DD/MM/YYYY') INTO curr_date from DUAL;
    target_date := curr_date + 365;
    while (curr_date <= target_date)
    LOOP
        for stud in (
            select * from student order by DBMS_RANDOM.VALUE() fetch first nstd rows only
        )
        LOOP
            select
            CONCAT(CONCAT(CONCAT(LPAD(floor(DBMS_RANDOM.VALUE(8,9.99)), 2, '0'), ':'),
            CONCAT(CONCAT(LPAD(floor(DBMS_RANDOM.VALUE(0,60.99)), 2, '0'), ':'), LPAD(floor(DBMS_RANDOM.VALUE(0,60.99)), 2, '0'))), ' AM')
            into random_time from dual;
            select FLOOR(DBMS_RANDOM.VALUE(3, 9.9)) INTO rand_int from DUAL;
            select FLOOR(DBMS_RANDOM.VALUE(0, 2.9)) INTO rand_int_gt from DUAL;
            if (rand_int = 9)
            THEN
                INSERT INTO GATE_CHECKIN (GATE_id, checkin_date, std_id, checkin_time)
                VALUES (
                        CASE
                            WHEN rand_int_gt = 0 THEN 'GT-01'
                            WHEN rand_int_gt = 1 THEN 'GT-02'
                            WHEN rand_int_gt = 2 THEN 'GT-03'
                        END ,
                        CAST(curr_date as varchar(12)),
                        stud.std_id,
                        random_time
                       );
            end if;
        end loop;

        for fac in (
            select * from faculty order by DBMS_RANDOM.VALUE() fetch first nfaculty rows only
        )
        LOOP
            select
            CONCAT(CONCAT(CONCAT(LPAD(floor(DBMS_RANDOM.VALUE(8,9.99)), 2, '0'), ':'),
            CONCAT(CONCAT(LPAD(floor(DBMS_RANDOM.VALUE(0,60.99)), 2, '0'), ':'), LPAD(floor(DBMS_RANDOM.VALUE(0,60.99)), 2, '0'))), ' AM')
            into random_time from dual;
            select FLOOR(DBMS_RANDOM.VALUE(4, 9.9)) INTO rand_int from DUAL;
            select FLOOR(DBMS_RANDOM.VALUE(0, 2.9)) INTO rand_int_gt from DUAL;
            if (rand_int = 9 and counter!=6 and counter!=7)
            THEN
                INSERT INTO GATE_CHECKIN (GATE_id, checkin_date, faculty_id, checkin_time)
                VALUES (
                        CASE
                        WHEN rand_int_gt = 0 THEN 'GT-01'
                        WHEN rand_int_gt = 1 THEN 'GT-02'
                        WHEN rand_int_gt = 2 THEN 'GT-03'
                        END ,
                        CAST(curr_date as varchar(12)),
                        fac.FACULTY_ID,
                        random_time
                );
            end if;
        end loop;
        curr_date := curr_date + 1;
        if (counter = 5)
        THEN
            counter := 1;
            curr_date := curr_date + 2;
        ELSE
            counter := counter + 1;
        end if;
    end loop;
end;
/

CREATE OR REPLACE PROCEDURE enroll_courses_to_first_sem
IS
BEGIN
    for sec in (select * from SECTION where semester = 1)
    LOOP
        enroll_sem_courses(sec.SECTION_ID);
    end loop;
end;
/

CREATE OR REPLACE PROCEDURE auto_generate_grade
IS
    temp_mid int;
    temp_assignment int;
    temp_quiz int;
    temp_final int;
BEGIN
        for enrol in (select  * from ENROLLMENT where STATUS = 'ACTIVE')
        LOOP
            temp_mid := ROUND(DBMS_RANDOM.VALUE(10,20));
            temp_assignment := ROUND(DBMS_RANDOM.VALUE(5,10));
            temp_quiz := ROUND(DBMS_RANDOM.VALUE(5,10));
            temp_final := ROUND(DBMS_RANDOM.VALUE(30,60));
            INSERT INTO GRADE (ENROLLMENT_ID, quiz, assignment, mid_term, final, grade) VALUES (enrol.enrollment_id, temp_quiz,temp_assignment, temp_mid, temp_final, 'A');
        end loop;
end;
/

CREATE OR REPLACE PROCEDURE calculate_sgpa
IS
    total_sum_cr_hrs float default 0;
    cr_hrs_got float default 0;
    temp_cr_hr float;
    temp_gp float;
BEGIN
    for sec in (select * from SECTION where STATUS = 'IN-TERM')
    LOOP
        for stud in (select * from student where section = sec.SECTION_ID)
        LOOP
            for course_ in (select * from PROGRAM_COURSE_ROADMAP where prg_id = sec.PROGRAM and semester = sec.semester)
            LOOP
                select CREDIT_HOURS into temp_cr_hr from COURSE where COURSE_CODE = course_.course_code;
                total_sum_cr_hrs := total_sum_cr_hrs + temp_cr_hr;
                select grade_points into temp_gp
                from ENROLLMENT
                    INNER JOIN GRADE
                        on GRADE.ENROLLMENT_ID = ENROLLMENT.enrollment_id
                where GRADE.status  != 'DISCARDED' and
                      ENROLLMENT.student_id = stud.std_id and
                      ENROLLMENT.course_code = course_.course_code;
                cr_hrs_got := cr_hrs_got + (temp_cr_hr * temp_gp);
            end loop;
            insert into student_sgpa (student_id, semester_id, SGPA) VALUES (stud.std_id, sec.semester, cast((cr_hrs_got / total_sum_cr_hrs) as DECIMAL(3,2)));
            cr_hrs_got := 0;
            total_sum_cr_hrs := 0;
        end loop;
    end loop;
end;
/

CREATE OR REPLACE PROCEDURE enroll_sem_courses(
    SECTION_ID_ SECTION.SECTION_ID%type
)
IS
    sem_id SEMESTER.SEMESTER_ID%type;
    year_ int;
BEGIN
    select semester into sem_id from SECTION where SECTION_ID = SECTION_ID_;
    select session_year into year_ from SECTION where SECTION_ID = SECTION_ID_;
    year_ := year_ +
             CASE
                WHEN sem_id = 1 or sem_id = 2 THEN 0
                WHEN sem_id = 3 or sem_id = 4 THEN 1
                WHEN sem_id = 5 or sem_id = 6 THEN 2
                WHEN sem_id = 7 or sem_id = 8 THEN 3
                WHEN sem_id = 9 or sem_id = 10 THEN 4
             END;
    for std in (
        select * from student where student.section = SECTION_ID_
    )
    LOOP
        for courses in (
            select * from PROGRAM_COURSE_ROADMAP where prg_id = std.program and semester = sem_id
        )
        LOOP
            INSERT INTO ENROLLMENT (ENROLLMENT_DATE, prg_id, section, course_code, student_id)
            VALUES (
                    concat(concat(LPAD(FLOOR(DBMS_RANDOM.VALUE(1,30)), 2, '0'), '-'),CONCAT(CONCAT(CASE WHEN MOD(sem_id, 2) = 0 THEN 'APR' WHEN MOD(sem_id, 2) = 1 THEN 'NOV' END,'-'),substr(year_, -2))),
                    std.program,
                    SECTION_ID_,
                    courses.course_code,
                    std.std_id);
        end LOOP;
    end LOOP;
end;
/

/*
    ************************************
    |POPULATING TABLES WITH SAMPLE DATA|
    ************************************
*/
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (0, 'PLACEHOLDER SEMESTER - GRADUATED');
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (1, 'Semester 1 Fall');
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (3, 'Semester 3 Fall');
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (5, 'Semester 5 Fall');
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (7, 'Semester 7 Fall');
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (9, 'Semester 9 Fall');
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (2, 'Semester 2 Spring');
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (4, 'Semester 4 Spring');
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (6, 'Semester 6 Spring');
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (8, 'Semester 8 Spring');
INSERT INTO SEMESTER (SEMESTER_ID, SEMESTER_NAME) values (10, 'Semester 10 Spring');


INSERT INTO PARTNER_BANK (BANK_ID, BANK_NAME, BANK_ADDRESS, MANAGER_NAME, TELEPHONE_NO) VALUES ('UBL', 'United Bank Ltd.', 'UBL HQ Building Jail Road', 'Jaffar Sadiq', '042-3626022');
INSERT INTO BANK_ACCOUNT (ACCOUNT_NO, BANK_ID, ACCOUNT_ALIAS) VALUES ('04095423123451', 'UBL', 'UBL Paycheck Payments Account');
INSERT INTO BANK_ACCOUNT (ACCOUNT_NO, BANK_ID, ACCOUNT_ALIAS, ACCOUNT_TYPE) VALUES ('04093451234674', 'UBL', 'UBL Donations Account', 'CHARITY');
INSERT INTO BANK_ACCOUNT (ACCOUNT_NO, BANK_ID, ACCOUNT_ALIAS) VALUES ('04093544352342', 'UBL', 'UBL Fee Collection Account');
INSERT INTO PARTNER_BANK (BANK_ID, BANK_NAME, BANK_ADDRESS, MANAGER_NAME, TELEPHONE_NO) VALUES ('HBL', 'Habib Bank Ltd.', 'HBL HQ Building Johar Town', 'Anwar Razaq', '042-3905866');
INSERT INTO BANK_ACCOUNT (ACCOUNT_NO, BANK_ID, ACCOUNT_ALIAS) VALUES ('05787689123467', 'HBL', 'HBL Fee Collection Account');
INSERT INTO BANK_ACCOUNT (ACCOUNT_NO, BANK_ID, ACCOUNT_ALIAS) VALUES ('05784234525452', 'HBL', 'HBL Paycheck Payments Account');
INSERT INTO PARTNER_BANK (BANK_ID, BANK_NAME, BANK_ADDRESS, MANAGER_NAME, TELEPHONE_NO) VALUES ('JS', 'JS Bank Ltd.', 'JS HQ Gulberg', 'Asif Malik', '042-2435435');
INSERT INTO BANK_ACCOUNT (ACCOUNT_NO, BANK_ID, ACCOUNT_ALIAS) VALUES ('45014567808531', 'JS', 'JS Fee Collection Account 1');
INSERT INTO BANK_ACCOUNT (ACCOUNT_NO, BANK_ID, ACCOUNT_ALIAS) VALUES ('09723554214684', 'JS', 'JS Fee Collection Account 2');
INSERT INTO BANK_ACCOUNT (ACCOUNT_NO, BANK_ID, ACCOUNT_ALIAS) VALUES ('09465324453456', 'JS', 'JS Paycheck Payments Account');

INSERT INTO JOBS (JOB_ID, JOB_NAME, max_salary, max_employess) VALUES ('fs_receipt', 'FEE SECTION RECEPTIONIST', 30000, 5);
INSERT INTO JOBS (JOB_ID, JOB_NAME, max_salary, max_employess) VALUES ('fs_incharge', 'FEE SECTION SUPERVISOR', 45000, 2);
INSERT INTO JOBS (JOB_ID, JOB_NAME, max_salary, max_employess) VALUES ('uni_registrar', 'UNIVERSITY REGISTRAR', 60000, 2);
INSERT INTO JOBS (JOB_ID, JOB_NAME, max_salary, max_employess) VALUES ('gate_guard', 'Security Guard', 20000, 50);

INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('fs_receipt', 'Asad Rasheed', '3620949043217', '0342-4524125', 25000);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('fs_receipt', 'Rehan Mehmood', '3620935532417', '0323-4567125', 29000);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('fs_incharge', 'Talha Akmal', '3534696234517', '0323-6723515', 44000);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('uni_registrar', 'Ihtisham Akmal', '3542309344120', '0323-0887515', 55000);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('gate_guard', 'Shikamaru Nara', '3545609346640', '0368-0887908', 15000);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('gate_guard', 'Neji Hyuga', '3556309379895', '0323-5345908', 19000);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('gate_guard', 'Kakashi Hatake', '3753209456640', '0314-0887908', 16000);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('fs_receipt', 'Rehan Ali', '3620956324479', '0329-4563234', 25600);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('fs_receipt', 'Sakura', '3563143235467', '0309-71892646', 29600);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('fs_receipt', 'Choji', '3520256443251', '0337-7644564', 29300);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('fs_incharge', 'Hashirama Senju', '3780865453386', '0300-6352562', 44900);
INSERT INTO EMPLOYEE (JOB, name, CNIC, phone_no, salary) VALUES ('uni_registrar', 'Madara Uchiha', '3904254365456', '0312-8174564', 59950);

INSERT INTO GATE (GATE_id, gate_alias, head_guard) VALUES ('GT-01', 'Main Gate', 'emp-000007');
INSERT INTO GATE (GATE_id, gate_alias, head_guard) VALUES ('GT-02', 'PG-Gate', 'emp-000006');
INSERT INTO GATE (GATE_id, gate_alias, head_guard) VALUES ('GT-03', 'Anarkali Gate', 'emp-000005');



-- INSERTING TWO DEPARTMENTS IN THE DEPARTMENT TABLE
ALTER TABLE DEPARTMENT MODIFY (HOD NULL);
-- Temporarily disabling to insert departments without HOD for now
INSERT INTO DEPARTMENT (dept_id, dept_name, phone_no, email) VALUES ('DCS', 'Department of Computer Science', '042-3626401', 'dcs@gcu.edu.pk');
INSERT INTO DEPARTMENT (dept_id, dept_name, phone_no, email) VALUES ('DENG', 'Department of Engineering', '042-3626402', 'deng@gcu.edu.pk');

INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Muhammad Ayub', 'Abdul Raffay Khan', '3520219078630','03416969100', 'hafeezdcs@gcu.edu.pk', 'DCS', 50000);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Fawad', 'Muhammad Ayan', '3520257674345','03135675476', 'syedalirazadcs@gcu.edu.pk', 'DCS', 60000);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Syed Jibran', 'Muhammad Rohaan', '3520265809753','03334579456', 'asadrazadcs@gcu.edu.pk', 'DCS', 100000);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Muhammad Hanzala', 'Nasir Khan', '3520278460323','03036433780', 'hanzaladpsy@gcu.edu.pk', 'DENG', 45000);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Saeed ur Rehman', 'Nusrat Ali Khan', '3520267480743','03376589080', 'saeeddpsy@gcu.edu.pk', 'DENG', 75000);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Nuzhat Butt', 'Abdul Raheem', '3520267823450','03030979470', 'nuzhatdpsy@gcu.edu.pk', 'DENG', 45000);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Tamara' , 'Bax' , '3520290300717' , '03403601805' , 'tamaradcs@gcu.edu.pk' , 'DCS' , '54586');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Leona' , 'Neighbors' , '3520299680234' , '03792239577' , 'leonadcs@gcu.edu.pk' , 'DCS' , '30002');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('David' , 'Llamas' , '3520243675560' , '03702874930' , 'daviddcs@gcu.edu.pk' , 'DCS' , '77255');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Richard' , 'Rainey' , '3520219870043' , '03114167739' , 'richarddcs@gcu.edu.pk' , 'DCS' , '60029');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Thomas' , 'Hobby' , '3520235958428' , '03281625420' , 'thomasdcs@gcu.edu.pk' , 'DCS' , '54900');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Amy' , 'Navarrete' , '3520264085513' , '03950911522' , 'amydcs@gcu.edu.pk' , 'DCS' , '53111');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Ruth' , 'Prior' , '3520270516677' , '03729378882' , 'ruthdcs@gcu.edu.pk' , 'DCS' , '44495');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Krysten' , 'Sanchez' , '3520292025854' , '03300799973' , 'krystendcs@gcu.edu.pk' , 'DCS' , '93169');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Chris' , 'Thomas' , '3520223867236' , '03520541854' , 'chrisdcs@gcu.edu.pk' , 'DCS' , '63988');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Laurie' , 'Reth' , '3520220045686' , '03965578228' , 'lauriedcs@gcu.edu.pk' , 'DCS' , '56275');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Ines' , 'Summey' , '3520226447584' , '03960364762' , 'inesdeng@gcu.edu.pk' , 'DENG' , '31704');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Angela' , 'Cole' , '3520274415177' , '03140309482' , 'angeladeng@gcu.edu.pk' , 'DENG' , '37132');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('John' , 'Dana' , '3520296894283' , '03554128415' , 'johndeng@gcu.edu.pk' , 'DENG' , '33471');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Melanie' , 'Hickman' , '3520257901776' , '03455138450' , 'melaniedeng@gcu.edu.pk' , 'DENG' , '46625');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Michael' , 'Wackerly' , '3520267843505' , '03801259994' , 'michaeldeng@gcu.edu.pk' , 'DENG' , '34469');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Maribel' , 'Thomas' , '3520224973957' , '03573673273' , 'maribeldeng@gcu.edu.pk' , 'DENG' , '50485');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Jerilyn' , 'Wallace' , '3520250002028' , '03432498807' , 'jerilyndeng@gcu.edu.pk' , 'DENG' , '53866');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Rachel' , 'Hord' , '3520296973564' , '03774123115' , 'racheldeng@gcu.edu.pk' , 'DENG' , '35095');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Christopher' , 'Harden' , '3520224471632' , '03943980811' , 'christopherdeng@gcu.edu.pk' , 'DENG' , '42694');
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Robert' , 'Martin' , '3520265580472' , '03796833227' , 'robertdeng@gcu.edu.pk' , 'DENG' , '76217');

-- GENERATING PAYCHECK OF EMPS AND FACS FOR 4 years
BEGIN
    populate_paychecks_table();
end;
/

UPDATE DEPARTMENT SET HOD = 'FAC-00003' where DEPT_ID='DCS';
UPDATE DEPARTMENT SET HOD = 'FAC-00006' where DEPT_ID='DENG';
ALTER TABLE DEPARTMENT MODIFY (HOD NOT NULL);
-- An HOD can be employee of another department even if it has no employee

INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Julie', 'Gribbin', '3520245937650', '03664892813', 'Julie@std.gcu.edu.pk', 'DENG', 78542);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Peggy', 'Shannon', '3520238809883', '03675074758', 'Peggy@std.gcu.edu.pk', 'DENG', 85607);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Herbert', 'Wilder', '3520252302801', '03220217193', 'Herbert@std.gcu.edu.pk', 'DENG', 19552);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Kimberly', 'Johnson', '3520233711146', '03613246343', 'Kimberly@std.gcu.edu.pk', 'DENG', 58520);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Terry', 'Cohen', '3520254293582', '03876887929', 'Terry@std.gcu.edu.pk', 'DENG', 19923);

INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Manuel', 'Pogue', '3520210120659', '03785766579', 'Manuel@std.gcu.edu.pk', 'DCS', 85072);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('David', 'Daugherty', '3520274337020', '03886615191', 'David@std.gcu.edu.pk', 'DCS', 77923);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Edith', 'Kirkpatrick', '3520256504242', '03844154777', 'Edith@std.gcu.edu.pk', 'DCS', 87741);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Anthony', 'Chandler', '3520257301516', '03866509505', 'Anthony@std.gcu.edu.pk', 'DCS', 28156);
INSERT INTO FACULTY (NAME, F_NAME, CNIC, PHONE_NUM, EMAIL, DEPT_ID, salary) VALUES ('Jane', 'Lepe', '3520243244466', '03131281823', 'Jane@std.gcu.edu.pk', 'DCS', 88852);

-- INSERT 1 PROGRAM for each DEPARTMENT
INSERT INTO PROGRAM (prg_id, prg_name, prg_duration, DEPT_ID) VALUES ('BSCS', 'Bachelors in Computer Science', 4, 'DCS');
INSERT INTO PROGRAM (prg_id, prg_name, prg_duration, dept_id) VALUES ('BSCV', 'Bachelors in Civil Engineering', 4, 'DENG');

INSERT INTO MISC_PAYMENT_STRUCTURE (program, payment_type, fee_amount) values ('BSCS', 'ADMISSION', 1000);
INSERT INTO MISC_PAYMENT_STRUCTURE (program, payment_type, fee_amount) values ('BSCS', 'REGISTRATION', 25000);

INSERT INTO MISC_PAYMENT_STRUCTURE (program, payment_type, fee_amount) values ('BSCV', 'ADMISSION', 1000);
INSERT INTO MISC_PAYMENT_STRUCTURE (program, payment_type, fee_amount) values ('BSCV', 'REGISTRATION', 17500);

INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCS', 1, 69000);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCS', 2, 60100);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCS', 3, 61400);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCS', 4, 61700);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCS', 5, 61900);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCS', 6, 61800);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCS', 7, 61500);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCS', 8, 54000);

INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCV', 1, 95000);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCV', 2, 89100);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCV', 3, 77400);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCV', 4, 34700);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCV', 5, 75900);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCV', 6, 79800);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCV', 7, 73500);
INSERT INTO FEE_STRUCTURE (prg_id, semester, fee_amount) VALUES ('BSCV', 8, 54000);

-- INSERTING COURSES in COURSES TABLE
SET ESCAPE ON;
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-1101', 'Introduction to Information \& Communication Technology', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('MATH-2201', 'Calculus and Analytical Geometry', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('PH-231', 'Applied Physics', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('ENG-1101', 'English Composition and Comprehension', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('PK-2101', 'Pakistan Studies', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-2201', 'Programming Fundamentals', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-1201', 'Object Oriented Programming', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-2203', 'Digital Logic Design', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('MATH-2101', 'Linear Algebra', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('ENG-2101', 'Communication \& Presentation Skills', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('STAT-1101', 'Probabailty and Statistics', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-3301', 'Computer Organization \& Assembly Language', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-2101', 'Data Structures and Algorithms', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-1203', 'Discrete Structures', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('MATH-3201', 'Differential Equations', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('AC-1101', 'Financial Accounting', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('ISL-2101', 'Islamic Studies', '2');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('ETH-2101', 'Ethic', '2');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-3118', 'Design and Analysis of Algorithms', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('HM-3123', 'Professional Practices', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-2044', 'Theory of Automata', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-2014', 'Database Systems', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-3314', 'Logical Paradigm of Computing', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-4207', 'Compiler Construction', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-2205', 'Operating System', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-2105', 'Software Engineering', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-4102', 'Graph Theory', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-3102', 'Artificial Intelligence and Neural Networks', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-5102', 'Computer Networks', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-4144', 'Chinese', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-4132', 'Data Mining', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-4230', 'Software Development Process', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-4560', 'Advanced Software Engineering', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-3216', 'Parallel \& Distributed Computing', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-3315', 'Theory of Programming Languages', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('BIT-1532', 'Technical \& Business Writing', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CSB-4408', 'Entrepreneurship', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('MATH-3101', 'Multivariate Calculus', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('PSY-6632', 'Cognitive Psychology', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-4807', 'Advanced Software Engineering', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-4572', 'Information Security', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-4575', 'Web Engineering', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-3896', 'Software Quality Assurance', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-1246', 'Intellectual Property Rights \& Cyber Law', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CS-4479', 'Numerical Computing', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CEME-1013', 'Basic Electro-Mechanical Engineering', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-1112', 'Civil Engineering Drawing', '2');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-1342', 'Civil Engineering Materials', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-1142', 'Engineering Survey', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-1133', 'Engineering Geology', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CEMT-2033', 'Applied Mathematics', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CEME-2023', 'Engineering Mechanics', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-2162', 'Architecture \& Town Planning', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-2172', 'Engineering Survey II', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CEMG-2313', 'Construction Engineering \& Management', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-2212', 'Strength of Materials I', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-2181', 'Civil Engineering Drawing \& Estimation', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-2412', 'Fluid Mechanics I', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-3233', 'Theory of Structures I', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-3242', 'Steel Structures', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-3223', 'Strength of Materials II', '4');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-3422', 'Fluid Mechanics II', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-3252', 'Theory of Structures II', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-3262', 'Plain and Reinforced Concrete I', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-3432', 'Engineering Hydrology', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-3512', 'Soil Mechanics', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-3612', 'Environmental Engineering I', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-4272', 'Plain and Reinforced Concrete II', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-4442', 'Hydraulics Engineering', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-4522', 'Geotechnical \& Foundation Engineering', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-4532', 'Transportation Engineering I', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-4622', 'Environmental Engineering II', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-4912', 'Civil Engineering Project I', '2');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-4201', 'Design of Structures', '3');
INSERT INTO COURSE (COURSE_CODE, COURSE_NAME, CREDIT_HOURS) VALUES ('CE-4452', 'Irrigation and Drainage Engineering', '3');


-- INSERTING COURSES THAT ARE OFFERED IN A PROGRAM
--      BSCS SEMESTER 1
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-1101','BSCS','1');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('MATH-2201','BSCS','1');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('PH-231','BSCS','1');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('ENG-1101','BSCS','1');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('PK-2101','BSCS','1');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-2201','BSCS','1');

--      BSCS SEMESTER 2
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-1201','BSCS','2');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-2203','BSCS','2');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('MATH-2101','BSCS','2');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('ENG-2101','BSCS','2');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('STAT-1101','BSCS','2');

--      BSCS SEMESTER 3
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-3301','BSCS','3');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-2101','BSCS','3');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-1203','BSCS','3');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('MATH-3201','BSCS','3');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('AC-1101','BSCS','3');

--      BSCS SEMESTER 4
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('ISL-2101','BSCS','4');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('ETH-2101','BSCS','4');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-3118','BSCS','4');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('HM-3123','BSCS','4');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-2044','BSCS','4');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-2014','BSCS','4');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-3314','BSCS','4');

--      BSCS SEMESTER 5
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-4207','BSCS','5');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-2205','BSCS','5');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-2105','BSCS','5');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-4102','BSCS','5');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-3102','BSCS','5');

--      BSCS SEMESTER 6
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-5102','BSCS','6');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-4144','BSCS','6');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-4230','BSCS','6');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-4560','BSCS','6');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-3216','BSCS','6');

--      BSCS SEMESTER 7
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-3315','BSCS','7');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('BIT-1532','BSCS','7');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CSB-4408','BSCS','7');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('MATH-3101','BSCS','7');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('PSY-6632','BSCS','7');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-4807','BSCS','7');

--      BSCS SEMESTER 8
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-4572','BSCS','8');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-4575','BSCS','8');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-3896','BSCS','8');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-1246','BSCS','8');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-4479','BSCS','8');

--      BSCV SEMESTER 1
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('MATH-2201', 'BSCV', '1');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('ISL-2101', 'BSCV', '1');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CEME-1013', 'BSCV', '1');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-1112', 'BSCV', '1');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-1342', 'BSCV', '1');

--      BSCV SEMESTER 2
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('PSY-6632', 'BSCV', '2');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-1142', 'BSCV', '2');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-1133', 'BSCV', '2');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-2201', 'BSCV', '2');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('ENG-1101', 'BSCV', '2');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('PK-2101', 'BSCV', '2');

--      BSCV SEMESTER 3
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CEMT-2033', 'BSCV', '3');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CEME-2023', 'BSCV', '3');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-2162', 'BSCV', '3');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-2172', 'BSCV', '3');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CEMG-2313', 'BSCV', '3');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CSB-4408', 'BSCV', '3');

--      BSCV SEMESTER 4
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CS-4479', 'BSCV', '4');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-2212', 'BSCV', '4');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-2181', 'BSCV', '4');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-2412', 'BSCV', '4');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('ENG-2101', 'BSCV', '4');

--      BSCV SEMESTER 5
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-3233', 'BSCV', '5');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('STAT-1101', 'BSCV', '5');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-3242', 'BSCV', '5');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-3223', 'BSCV', '5');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-3422', 'BSCV', '5');

--      BSCV SEMESTER 6
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-3252', 'BSCV', '6');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-3262', 'BSCV', '6');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-3432', 'BSCV', '6');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-3512', 'BSCV', '6');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-3612', 'BSCV', '6');

--      BSCV SEMESTER 7
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-4272', 'BSCV', '7');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-4442', 'BSCV', '7');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-4522', 'BSCV', '7');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-4532', 'BSCV', '7');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-4622', 'BSCV', '7');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-4912', 'BSCV', '7');

--      BSCV SEMESTER 8
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-4201', 'BSCV', '8');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('CE-4452', 'BSCV', '8');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('AC-1101', 'BSCV', '8');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('HM-3123', 'BSCV', '8');
INSERT INTO PROGRAM_COURSE_ROADMAP (course_code, prg_id, semester) VALUES ('BIT-1532', 'BSCV', '8');


-- INSERTING Applications IN BSCS PROGRAM
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no, program , application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Muhammad Awais', 'Muhammad Shehzad', '03085643642', 'BSCS' , 'Open Merit', '4734246805212', 967, 920, '10-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Lubna', 'Khizer', '03087905457', 'BSCS', 'Open Merit', '6534143678334', 1098,1090, '06-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Abdul Raffay Khan', 'Rifet Khan', '03085643642', 'BSCS', 'Open Merit', '6534143678334', 950,1000, '06-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Muhammad Usama', 'Muhammad Khalid', '03346748031', 'BSCS', 'Open Merit', '6534156738921', 800,970, '08-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Syeda Hurmat Zahra', 'Zeeshan Ali', '03436803137', 'BSCS', 'Open Merit', '6534156738921', 1090,1095, '08-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Muhammad Saad', 'Muhammad Irfan', '03135843679', 'BSCS', 'Open Merit', '4523456738964', 748,900, '08-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Muhammad Khawar', 'Muhammad Sharjeel', '030899797465', 'BSCS', 'Open Merit', '5637956738921', 900,970, '08-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Minahil', 'Majid', '03085686124', 'BSCS', 'Open Merit', '6534156738875', 915,970, '11-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Muhammad Tayyab', 'Muhammad Irfan', '03085643642','BSCS', 'Open Merit', '9087556738345', 750,970, '11-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Jawad', 'Sajjad', '03085643642', 'BSCS', 'Open Merit', '6534156097921', 800,900, '08-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Fred' , 'Perea' , '03781422273' , 'BSCS' , 'Open Merit' , '3520293077322' , '808' , '866' , '28-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Greg' , 'Larson' , '03134238977' , 'BSCS' , 'Open Merit' , '3520267829174' , '931' , '1049' , '07-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Mary' , 'Oliver' , '03594134401' , 'BSCS' , 'Open Merit' , '3520253302852' , '900' , '969' , '11-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Nicholas' , 'Mcmanus' , '03178918706' , 'BSCS' , 'Open Merit' , '3520253332907' , '964' , '857' , '02-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Lawrence' , 'Altmiller' , '03343406055' , 'BSCS' , 'Open Merit' , '3520220183774' , '804' , '1078' , '28-SEP-20');

-- INSERTING APPLICANTS IN BSCV PROGRAM
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Goldie' , 'Mccormack' , '03197543101' , 'BSCV' , 'Open Merit' , '3520211725187' , '882' , '975' , '24-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Gladys' , 'Roach' , '03639832235' , 'BSCV' , 'Open Merit' , '3520286387950' , '1062' , '1088' , '04-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Claire' , 'Armstrong' , '03748603558' , 'BSCV' , 'Open Merit' , '3520248103209' , '828' , '985' , '10-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Leroy' , 'Carlton' , '03411528379' , 'BSCV' , 'Open Merit' , '3520211509762' , '1037' , '978' , '18-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Elvin' , 'Kilgo' , '03835542661' , 'BSCV' , 'Open Merit' , '3520225767045' , '824' , '957' , '27-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Misty' , 'Fitzgerald' , '03977931575' , 'BSCV' , 'Open Merit' , '3520292591331' , '923' , '942' , '06-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Gladys' , 'Fogle' , '03944762898' , 'BSCV' , 'Open Merit' , '3520249134102' , '991' , '1073' , '30-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Terry' , 'Widger' , '03336297099' , 'BSCV' , 'Open Merit' , '3520240636561' , '1059' , '949' , '16-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Nathaniel' , 'Topping' , '03635292750' , 'BSCV' , 'Open Merit' , '3520286232841' , '1009' , '927' , '01-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Lashonda' , 'Jones' , '03570544304' , 'BSCV' , 'Open Merit' , '3520248611655' , '843' , '947' , '20-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Lorraine' , 'Tramel' , '03182692734' , 'BSCV' , 'Open Merit' , '3520288594341' , '953' , '911' , '17-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Michael' , 'Sanchez' , '03122593208' , 'BSCV' , 'Open Merit' , '3520230848944' , '873' , '932' , '20-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Mary' , 'Atwell' , '03990928668' , 'BSCV' , 'Open Merit' , '3520231934690' , '840' , '800' , '14-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Troy' , 'Vandy' , '03986964732' , 'BSCV' , 'Open Merit' , '3520232169754' , '1097' , '1084' , '27-SEP-20');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE)
VALUES ('Adam' , 'Church' , '03429566932' , 'BSCV' , 'Open Merit' , '3520253724764' , '807' , '848' , '29-SEP-20');

BEGIN
    -- ADMIT PROCESS AUTOMATION
    auto_admit_challan_issue('20');
    DBMS_OUTPUT.PUT_LINE('ADMIT CHALLAN ARE ISSUED S20');
END;
/
BEGIN
    fulfill_challans_admit('20');
    DBMS_OUTPUT.PUT_LINE('ADMIT CHALLAN ARE FULFILLED S20');
END;
/
BEGIN
    auto_merit_listing('20');
    DBMS_OUTPUT.PUT_LINE('MERIT LISTING S20');
END;
/
BEGIN
    auto_registration_challan_issue('20');
    DBMS_OUTPUT.PUT_LINE('REGISTRATION CHALLAN ARE ISSUED S20');
END;
/
BEGIN
    fulfill_challans_register('20');
    DBMS_OUTPUT.PUT_LINE('REGISTRATION CHALLAN ARE FULFILLED S20');
END;
/
BEGIN
    assign_student_id_after_registry('20');
    DBMS_OUTPUT.PUT_LINE('ASSIGNED STUDENT IDS TO REGISTRATION S20');
END;
/
BEGIN
    turn_down_no_challan_applics();
    DBMS_OUTPUT.PUT_LINE('NO CHALLAN PAID APPLICATION STATUS ARE UPDATED S20');
    DBMS_OUTPUT.PUT_LINE('ADMIT PROCESS DONE S20');
END;
/
BEGIN
    populate_gate_checkin('20', '02') ;
    DBMS_OUTPUT.PUT_LINE('GATE_CHECKINS ARE POPULATED');
END;
/
BEGIN
    -- FEE CHALLAN ISSUE
    auto_generate_fee_challan();
    DBMS_OUTPUT.PUT_LINE('GENERATED FEE CHALLANS S20');
END;
/
BEGIN
    auto_fulfill_fee_challan();
    DBMS_OUTPUT.PUT_LINE('FEE CHALLANS ARE FULFILLED S20');
END;
/
BEGIN
    -- Academics
    enroll_courses_all_sections();
    DBMS_OUTPUT.PUT_LINE('STUDENTS IN ALL SECTIONS ARE ENROLLED IN COURSES S20');
END;
/
BEGIN
    allocate_courses();
    DBMS_OUTPUT.PUT_LINE('FACULTY ARE ALLOCATED TO STUDENTS FALL S20');
END;
/
BEGIN
    auto_generate_grade();
    DBMS_OUTPUT.PUT_LINE('GRADES ARE GENERATED FOR ENROLLMENTS S20');
END;
/
BEGIN
    calculate_sgpa();
    DBMS_OUTPUT.PUT_LINE('SGPA IS CALCULATED S20');
end;
/
BEGIN
    -- Spring Semester
    --delete FACULTY_ALLOCATION; -- Allocation is changed after every semester
    incr_sem_section();
    DBMS_OUTPUT.PUT_LINE('SEMESTER IS INCREMENTED FOR EVERY SECTION S20');
END;
/
BEGIN
    enroll_courses_all_sections();
    DBMS_OUTPUT.PUT_LINE('STUDENTS IN ALL SECTIONS ARE ENROLLED IN COURSES SPRING S20');
END;
/
BEGIN
    auto_generate_fee_challan();
    DBMS_OUTPUT.PUT_LINE('GENERATED FEE CHALLANS SPRING S20');
END;
/
BEGIN
    auto_fulfill_fee_challan();
    DBMS_OUTPUT.PUT_LINE('FEE CHALLANS ARE FULFILLED SPRING S20');
END;
/
BEGIN
    allocate_courses();
    DBMS_OUTPUT.PUT_LINE('FACULTY ARE ALLOCATED TO STUDENTS SPRING S20');
END;
/
BEGIN
    auto_generate_grade();
    DBMS_OUTPUT.PUT_LINE('GRADES ARE GENERATED FOR ENROLLMENTS SPRING S20');
END;
/
BEGIN
    calculate_sgpa();
    DBMS_OUTPUT.PUT_LINE('SGPA IS CALCULATED SPRINGS 20');
END;
/
BEGIN
    incr_sem_section();
    DBMS_OUTPUT.PUT_LINE('SEMESTER IS INCREMENTED FOR EVERY SECTION FOR S20');
end;
/

-- BATCH 21 Admit
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Carol' , 'Sigmon' , '03722452533' , 'BSCS' , 'Open Merit' , '3520210466253' , '1045' , '1025' , '20-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Roberto' , 'Cutting' , '03610133756' , 'BSCS' , 'Open Merit' , '3520252118609' , '1002' , '848' , '24-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Thomas' , 'Smiley' , '03799102834' , 'BSCS' , 'Open Merit' , '3520261142722' , '992' , '1083' , '27-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Valerie' , 'Mankowski' , '03120465167' , 'BSCS' , 'Open Merit' , '3520250063739' , '1065' , '899' , '26-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Sandra' , 'Paul' , '03167510487' , 'BSCS' , 'Open Merit' , '3520231555637' , '904' , '997' , '29-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Rebecca' , 'Bradley' , '03912750790' , 'BSCS' , 'Open Merit' , '3520244268994' , '1028' , '873' , '05-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Kathleen' , 'Sherburne' , '03185594596' , 'BSCS' , 'Open Merit' , '3520232933538' , '1032' , '949' , '22-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Stephanie' , 'Bradley' , '03539550758' , 'BSCS' , 'Open Merit' , '3520235528122' , '856' , '909' , '27-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('James' , 'Hilliard' , '03388889593' , 'BSCS' , 'Open Merit' , '3520222836012' , '1039' , '1093' , '03-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Janet' , 'Martin' , '03313790985' , 'BSCS' , 'Open Merit' , '3520266214241' , '944' , '1007' , '16-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Karen' , 'Riley' , '03628795803' , 'BSCS' , 'Open Merit' , '3520264306425' , '1016' , '810' , '25-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jason' , 'Gattis' , '03917331281' , 'BSCS' , 'Open Merit' , '3520276143833' , '1097' , '943' , '22-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Zoila' , 'Graybill' , '03333228192' , 'BSCS' , 'Open Merit' , '3520257617253' , '930' , '830' , '07-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Greg' , 'Woods' , '03857548948' , 'BSCS' , 'Open Merit' , '3520235165978' , '1009' , '838' , '25-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('John' , 'Rodriguez' , '03383100222' , 'BSCS' , 'Open Merit' , '3520212770384' , '861' , '812' , '16-SEP-21');


INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Judith' , 'Kreger' , '03395751236' , 'BSCV' , 'Open Merit' , '3520218027607' , '1070' , '870' , '27-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Mary' , 'Abrego' , '03169345090' , 'BSCV' , 'Open Merit' , '3520291801206' , '1048' , '818' , '25-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Nicholas' , 'Mcmillen' , '03148698518' , 'BSCV' , 'Open Merit' , '3520291152296' , '1008' , '872' , '08-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Robert' , 'Miguel' , '03127780558' , 'BSCV' , 'Open Merit' , '3520221288197' , '912' , '1051' , '16-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Edna' , 'Wyse' , '03530242328' , 'BSCV' , 'Open Merit' , '3520218459007' , '961' , '935' , '26-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Janet' , 'Pritchard' , '03182209303' , 'BSCV' , 'Open Merit' , '3520265436563' , '972' , '903' , '12-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Terrence' , 'Atkinson' , '03764724794' , 'BSCV' , 'Open Merit' , '3520247643286' , '1065' , '1061' , '04-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Sally' , 'Goucher' , '03455852363' , 'BSCV' , 'Open Merit' , '3520228717104' , '1099' , '1055' , '25-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Calvin' , 'Luppino' , '03206584379' , 'BSCV' , 'Open Merit' , '3520278923098' , '821' , '1001' , '26-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Cynthia' , 'Morton' , '03415379367' , 'BSCV' , 'Open Merit' , '3520286384523' , '1028' , '909' , '18-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Norman' , 'Gholston' , '03446789101' , 'BSCV' , 'Open Merit' , '3520257302872' , '1010' , '886' , '27-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Tommie' , 'Zanders' , '03380625727' , 'BSCV' , 'Open Merit' , '3520289679972' , '1046' , '908' , '02-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Brian' , 'Wallack' , '03907403649' , 'BSCV' , 'Open Merit' , '3520232224040' , '984' , '1093' , '03-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Robert' , 'Doran' , '03604641876' , 'BSCV' , 'Open Merit' , '3520236683494' , '977' , '1075' , '07-SEP-21');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Steven' , 'Castillo' , '03565235863' , 'BSCV' , 'Open Merit' , '3520232222824' , '1000' , '1091' , '16-SEP-21');

BEGIN
    -- ADMIT PROCESS AUTOMATION
    auto_admit_challan_issue('21');
    DBMS_OUTPUT.PUT_LINE('ADMIT CHALLAN ARE ISSUED S21');
END;
/
BEGIN
    fulfill_challans_admit('21');
    DBMS_OUTPUT.PUT_LINE('ADMIT CHALLAN ARE FULFILLED S21');
END;
/
BEGIN
    auto_merit_listing('21');
    DBMS_OUTPUT.PUT_LINE('MERIT LISTING S21');
END;
/
BEGIN
    auto_registration_challan_issue('21');
    DBMS_OUTPUT.PUT_LINE('REGISTRATION CHALLAN ARE ISSUED S21');
END;
/
BEGIN
    fulfill_challans_register('21');
    DBMS_OUTPUT.PUT_LINE('REGISTRATION CHALLAN ARE FULFILLED S21');
END;
/
BEGIN
    assign_student_id_after_registry('21');
    DBMS_OUTPUT.PUT_LINE('ASSIGNED STUDENT IDS TO REGISTRATION S21');
END;
/
BEGIN
    turn_down_no_challan_applics();
    DBMS_OUTPUT.PUT_LINE('NO CHALLAN PAID APPLICATION STATUS ARE UPDATED S21');
    DBMS_OUTPUT.PUT_LINE('ADMIT PROCESS DONE S21');
END;
/
BEGIN
    populate_gate_checkin('21', '08') ;
    DBMS_OUTPUT.PUT_LINE('GATE_CHECKINS ARE POPULATED');
END;
/
BEGIN
    -- FEE CHALLAN ISSUE
    auto_generate_fee_challan();
    DBMS_OUTPUT.PUT_LINE('GENERATED FEE CHALLANS S21');
END;
/
BEGIN
    auto_fulfill_fee_challan();
    DBMS_OUTPUT.PUT_LINE('FEE CHALLANS ARE FULFILLED S21');
END;
/
BEGIN
    -- Academics
    enroll_courses_all_sections();
    DBMS_OUTPUT.PUT_LINE('STUDENTS IN ALL SECTIONS ARE ENROLLED IN COURSES S21');
END;
/
BEGIN
    generate_dummy_repeat_enrolls();
    DBMS_OUTPUT.PUT_LINE('REPEATERS FROM S3 ARE ENROLLED IN S1');
END;
/
BEGIN
    allocate_courses();
    DBMS_OUTPUT.PUT_LINE('FACULTY ARE ALLOCATED TO STUDENTS FALL S21');
END;
/
BEGIN
    auto_generate_grade();
    DBMS_OUTPUT.PUT_LINE('GRADES ARE GENERATED FOR ENROLLMENTS S21');
END;
/
BEGIN
    calculate_sgpa();
    DBMS_OUTPUT.PUT_LINE('SGPA IS CALCULATED S21');
end;
/
BEGIN
    -- Spring Semester
    --delete FACULTY_ALLOCATION; -- Allocation is changed after every semester
    incr_sem_section();
    DBMS_OUTPUT.PUT_LINE('SEMESTER IS INCREMENTED FOR EVERY SECTION S21');
END;
/
BEGIN
    enroll_courses_all_sections();
    DBMS_OUTPUT.PUT_LINE('STUDENTS IN ALL SECTIONS ARE ENROLLED IN COURSES SPRING S21');
END;
/
BEGIN
    auto_generate_fee_challan();
    DBMS_OUTPUT.PUT_LINE('GENERATED FEE CHALLANS SPRING S21');
END;
/
BEGIN
    auto_fulfill_fee_challan();
    DBMS_OUTPUT.PUT_LINE('FEE CHALLANS ARE FULFILLED SPRING S21');
END;
/
BEGIN
    allocate_courses();
    DBMS_OUTPUT.PUT_LINE('FACULTY ARE ALLOCATED TO STUDENTS SPRING S21');
END;
/
BEGIN
    auto_generate_grade();
    DBMS_OUTPUT.PUT_LINE('GRADES ARE GENERATED FOR ENROLLMENTS SPRING S21');
END;
/
BEGIN
    calculate_sgpa();
    DBMS_OUTPUT.PUT_LINE('SGPA IS CALCULATED SPRINGS 21');
END;
/
BEGIN
    incr_sem_section();
    DBMS_OUTPUT.PUT_LINE('SEMESTER IS INCREMENTED FOR EVERY SECTION FOR S21');
end;
/

-- BATCH S22
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Candace' , 'Dunham' , '03569930332' , 'BSCV' , 'Open Merit' , '3520216656028' , '984' , '863' , '13-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Lisa' , 'Young' , '03104767614' , 'BSCV' , 'Open Merit' , '3520267797511' , '935' , '925' , '01-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Carmen' , 'Reynolds' , '03719831439' , 'BSCV' , 'Open Merit' , '3520298049982' , '888' , '929' , '12-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('John' , 'Taylor' , '03566113513' , 'BSCV' , 'Open Merit' , '3520288854947' , '1084' , '868' , '21-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Stan' , 'Leclair' , '03146043375' , 'BSCV' , 'Open Merit' , '3520240604801' , '864' , '970' , '28-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('David' , 'Crow' , '03570332818' , 'BSCV' , 'Open Merit' , '3520226832283' , '951' , '1047' , '01-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Henry' , 'Dandy' , '03272816247' , 'BSCV' , 'Open Merit' , '3520220453688' , '806' , '960' , '23-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Michelle' , 'Carrington' , '03172250963' , 'BSCV' , 'Open Merit' , '3520259231578' , '906' , '850' , '20-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Vasiliki' , 'Gaddis' , '03275152335' , 'BSCV' , 'Open Merit' , '3520211307364' , '951' , '1046' , '16-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Ezequiel' , 'Dondero' , '03679418019' , 'BSCV' , 'Open Merit' , '3520221167665' , '859' , '918' , '19-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Sheila' , 'Nguyen' , '03161964703' , 'BSCV' , 'Open Merit' , '3520269854420' , '931' , '872' , '04-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Walter' , 'Smith' , '03367345319' , 'BSCV' , 'Open Merit' , '3520263219580' , '883' , '985' , '07-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Kathy' , 'Weitzel' , '03784802323' , 'BSCV' , 'Open Merit' , '3520215938704' , '974' , '935' , '01-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Andrew' , 'Roller' , '03701991115' , 'BSCV' , 'Open Merit' , '3520212790568' , '1047' , '867' , '13-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Bert' , 'Martin' , '03702142338' , 'BSCV' , 'Open Merit' , '3520271929356' , '1055' , '1099' , '23-SEP-22');


INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jay' , 'Pocius' , '03326723464' , 'BSCS' , 'Open Merit' , '3520271874722' , '945' , '975' , '14-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Patricia' , 'Williams' , '03618602067' , 'BSCS' , 'Open Merit' , '3520213776991' , '918' , '990' , '28-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Thomas' , 'Chavarria' , '03913530265' , 'BSCS' , 'Open Merit' , '3520221124132' , '1005' , '814' , '14-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Ramona' , 'Lara' , '03607423192' , 'BSCS' , 'Open Merit' , '3520242968983' , '1084' , '907' , '18-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jose' , 'Mendez' , '03122084607' , 'BSCS' , 'Open Merit' , '3520226050990' , '872' , '839' , '05-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jamie' , 'Lawson' , '03641245655' , 'BSCS' , 'Open Merit' , '3520291781152' , '901' , '914' , '08-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Thomas' , 'Jolly' , '03313161730' , 'BSCS' , 'Open Merit' , '3520240004216' , '1078' , '980' , '01-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Dana' , 'Grist' , '03143747161' , 'BSCS' , 'Open Merit' , '3520265982155' , '846' , '948' , '15-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Aurelia' , 'Johnson' , '03249284024' , 'BSCS' , 'Open Merit' , '3520218760760' , '878' , '878' , '08-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Shirley' , 'Miller' , '03190090821' , 'BSCS' , 'Open Merit' , '3520264911676' , '846' , '921' , '16-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Wayne' , 'Lew' , '03160154755' , 'BSCS' , 'Open Merit' , '3520285757039' , '832' , '910' , '09-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Bethany' , 'Ditch' , '03164464706' , 'BSCS' , 'Open Merit' , '3520238405796' , '889' , '944' , '05-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Edna' , 'Sloan' , '03200478268' , 'BSCS' , 'Open Merit' , '3520214693337' , '1025' , '934' , '18-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Nichole' , 'Rice' , '03199314683' , 'BSCS' , 'Open Merit' , '3520298839107' , '1099' , '944' , '27-SEP-22');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Steven' , 'Gibson' , '03316698690' , 'BSCS' , 'Open Merit' , '3520287738133' , '897' , '884' , '27-SEP-22');


BEGIN
    -- ADMIT PROCESS AUTOMATION
    auto_admit_challan_issue('22');
    DBMS_OUTPUT.PUT_LINE('ADMIT CHALLAN ARE ISSUED S22');
END;
/
BEGIN
    fulfill_challans_admit('22');
    DBMS_OUTPUT.PUT_LINE('ADMIT CHALLAN ARE FULFILLED S22');
END;
/
BEGIN
    auto_merit_listing('22');
    DBMS_OUTPUT.PUT_LINE('MERIT LISTING S22');
END;
/
BEGIN
    auto_registration_challan_issue('22');
    DBMS_OUTPUT.PUT_LINE('REGISTRATION CHALLAN ARE ISSUED S22');
END;
/
BEGIN
    fulfill_challans_register('22');
    DBMS_OUTPUT.PUT_LINE('REGISTRATION CHALLAN ARE FULFILLED S22');
END;
/
BEGIN
    assign_student_id_after_registry('22');
    DBMS_OUTPUT.PUT_LINE('ASSIGNED STUDENT IDS TO REGISTRATION S22');
END;
/
BEGIN
    turn_down_no_challan_applics();
    DBMS_OUTPUT.PUT_LINE('NO CHALLAN PAID APPLICATION STATUS ARE UPDATED S22');
    DBMS_OUTPUT.PUT_LINE('ADMIT PROCESS DONE S22');
END;
/
BEGIN
    populate_gate_checkin('22', '14') ;
    DBMS_OUTPUT.PUT_LINE('GATE_CHECKINS ARE POPULATED');
END;
/
BEGIN
    -- FEE CHALLAN ISSUE
    auto_generate_fee_challan();
    DBMS_OUTPUT.PUT_LINE('GENERATED FEE CHALLANS S22');
END;
/
BEGIN
    auto_fulfill_fee_challan();
    DBMS_OUTPUT.PUT_LINE('FEE CHALLANS ARE FULFILLED S22');
END;
/
BEGIN
    -- Academics
    enroll_courses_all_sections();
    DBMS_OUTPUT.PUT_LINE('STUDENTS IN ALL SECTIONS ARE ENROLLED IN COURSES S22');
END;
/

BEGIN
    allocate_courses();
    DBMS_OUTPUT.PUT_LINE('FACULTY ARE ALLOCATED TO STUDENTS FALL S22');
END;
/
BEGIN
    auto_generate_grade();
    DBMS_OUTPUT.PUT_LINE('GRADES ARE GENERATED FOR ENROLLMENTS S22');
END;
/
BEGIN
    calculate_sgpa();
    DBMS_OUTPUT.PUT_LINE('SGPA IS CALCULATED S22');
end;
/
BEGIN
    -- Spring Semester
    --delete FACULTY_ALLOCATION; -- Allocation is changed after every semester
    incr_sem_section();
    DBMS_OUTPUT.PUT_LINE('SEMESTER IS INCREMENTED FOR EVERY SECTION S22');
END;
/
BEGIN
    enroll_courses_all_sections();
    DBMS_OUTPUT.PUT_LINE('STUDENTS IN ALL SECTIONS ARE ENROLLED IN COURSES SPRING S22');
END;
/
BEGIN
    auto_generate_fee_challan();
    DBMS_OUTPUT.PUT_LINE('GENERATED FEE CHALLANS SPRING S22');
END;
/
BEGIN
    auto_fulfill_fee_challan();
    DBMS_OUTPUT.PUT_LINE('FEE CHALLANS ARE FULFILLED SPRING S22');
END;
/
BEGIN
    allocate_courses();
    DBMS_OUTPUT.PUT_LINE('FACULTY ARE ALLOCATED TO STUDENTS SPRING S22');
END;
/
BEGIN
    auto_generate_grade();
    DBMS_OUTPUT.PUT_LINE('GRADES ARE GENERATED FOR ENROLLMENTS SPRING S22');
END;
/
BEGIN
    calculate_sgpa();
    DBMS_OUTPUT.PUT_LINE('SGPA IS CALCULATED SPRINGS 22');
END;
/
BEGIN
    incr_sem_section();
    DBMS_OUTPUT.PUT_LINE('SEMESTER IS INCREMENTED FOR EVERY SECTION FOR S22');
end;
/

-- BATCH 23
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jackie' , 'Valentine' , '03871093835' , 'BSCV' , 'Open Merit' , '3520278862221' , '929' , '1031' , '20-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Norma' , 'Ohanlon' , '03996408837' , 'BSCV' , 'Open Merit' , '3520245980305' , '863' , '935' , '08-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Demetria' , 'Harris' , '03622590059' , 'BSCV' , 'Open Merit' , '3520220024399' , '901' , '1072' , '29-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Anna' , 'Rojas' , '03707273188' , 'BSCV' , 'Open Merit' , '3520251903262' , '1050' , '809' , '08-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Roberto' , 'Kelly' , '03941532733' , 'BSCV' , 'Open Merit' , '3520242139681' , '835' , '857' , '30-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Larry' , 'Whittle' , '03954513669' , 'BSCV' , 'Open Merit' , '3520237847089' , '1001' , '966' , '13-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Michael' , 'Gritton' , '03220615434' , 'BSCV' , 'Open Merit' , '3520248372983' , '933' , '936' , '24-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Vicky' , 'Rodriguez' , '03658495107' , 'BSCV' , 'Open Merit' , '3520228519332' , '1051' , '962' , '29-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Armando' , 'Fowler' , '03240844091' , 'BSCV' , 'Open Merit' , '3520253001798' , '979' , '1050' , '28-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Eric' , 'Childers' , '03239460038' , 'BSCV' , 'Open Merit' , '3520246653180' , '940' , '822' , '12-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Mary' , 'Arroyo' , '03608971461' , 'BSCV' , 'Open Merit' , '3520229687851' , '956' , '932' , '29-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Willard' , 'Cerverizzo' , '03230946333' , 'BSCV' , 'Open Merit' , '3520273888743' , '891' , '1060' , '04-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Ron' , 'Caraballo' , '03422727787' , 'BSCV' , 'Open Merit' , '3520288784714' , '987' , '981' , '17-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jacob' , 'Matheny' , '03891664658' , 'BSCV' , 'Open Merit' , '3520250330387' , '1035' , '848' , '29-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Samantha' , 'Brewer' , '03301074460' , 'BSCV' , 'Open Merit' , '3520261394783' , '1045' , '888' , '22-SEP-23');


INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Christopher' , 'Alewine' , '03544547572' , 'BSCS' , 'Open Merit' , '3520279139271' , '926' , '1002' , '29-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('James' , 'Lee' , '03207269485' , 'BSCS' , 'Open Merit' , '3520238991994' , '809' , '846' , '29-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Michael' , 'Scott' , '03706272229' , 'BSCS' , 'Open Merit' , '3520299611695' , '1024' , '1059' , '02-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Harriet' , 'Miller' , '03461044737' , 'BSCS' , 'Open Merit' , '3520228188060' , '1007' , '978' , '28-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Scott' , 'Wygant' , '03875912344' , 'BSCS' , 'Open Merit' , '3520236248684' , '945' , '1008' , '17-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('John' , 'Honeycutt' , '03649620082' , 'BSCS' , 'Open Merit' , '3520292062024' , '827' , '1048' , '19-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jermaine' , 'Harris' , '03873909404' , 'BSCS' , 'Open Merit' , '3520271677570' , '1087' , '1073' , '10-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Darius' , 'Alexander' , '03261560924' , 'BSCS' , 'Open Merit' , '3520284281711' , '912' , '1078' , '03-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('James' , 'Pennachio' , '03362082910' , 'BSCS' , 'Open Merit' , '3520299262172' , '918' , '1036' , '28-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Gladys' , 'Patterson' , '03506036356' , 'BSCS' , 'Open Merit' , '3520223396002' , '1094' , '1002' , '10-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Zella' , 'Roehrig' , '03472616023' , 'BSCS' , 'Open Merit' , '3520288451202' , '871' , '922' , '05-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Glen' , 'Stroth' , '03231291303' , 'BSCS' , 'Open Merit' , '3520255067850' , '956' , '1030' , '19-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Carlton' , 'Harten' , '03832914973' , 'BSCS' , 'Open Merit' , '3520298691480' , '929' , '1005' , '02-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Julio' , 'Ellis' , '03262355749' , 'BSCS' , 'Open Merit' , '3520259399676' , '820' , '960' , '19-SEP-23');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Elisha' , 'Velazquez' , '03358207546' , 'BSCS' , 'Open Merit' , '3520291513090' , '934' , '1049' , '23-SEP-23');


BEGIN
    -- ADMIT PROCESS AUTOMATION
    auto_admit_challan_issue('23');
    DBMS_OUTPUT.PUT_LINE('ADMIT CHALLAN ARE ISSUED S23');
END;
/
BEGIN
    fulfill_challans_admit('23');
    DBMS_OUTPUT.PUT_LINE('ADMIT CHALLAN ARE FULFILLED S23');
END;
/
BEGIN
    auto_merit_listing('23');
    DBMS_OUTPUT.PUT_LINE('MERIT LISTING S23');
END;
/
BEGIN
    auto_registration_challan_issue('23');
    DBMS_OUTPUT.PUT_LINE('REGISTRATION CHALLAN ARE ISSUED S23');
END;
/
BEGIN
    fulfill_challans_register('23');
    DBMS_OUTPUT.PUT_LINE('REGISTRATION CHALLAN ARE FULFILLED S23');
END;
/
BEGIN
    assign_student_id_after_registry('23');
    DBMS_OUTPUT.PUT_LINE('ASSIGNED STUDENT IDS TO REGISTRATION S23');
END;
/
BEGIN
    turn_down_no_challan_applics();
    DBMS_OUTPUT.PUT_LINE('NO CHALLAN PAID APPLICATION STATUS ARE UPDATED S23');
    DBMS_OUTPUT.PUT_LINE('ADMIT PROCESS DONE S23');
END;
/
BEGIN
    populate_gate_checkin('23', '20') ;
    DBMS_OUTPUT.PUT_LINE('GATE_CHECKINS ARE POPULATED');
END;
/
BEGIN
    -- FEE CHALLAN ISSUE
    auto_generate_fee_challan();
    DBMS_OUTPUT.PUT_LINE('GENERATED FEE CHALLANS S23');
END;
/
BEGIN
    auto_fulfill_fee_challan();
    DBMS_OUTPUT.PUT_LINE('FEE CHALLANS ARE FULFILLED S23');
END;
/
BEGIN
    -- Academics
    enroll_courses_all_sections();
    DBMS_OUTPUT.PUT_LINE('STUDENTS IN ALL SECTIONS ARE ENROLLED IN COURSES S23');
END;
/

BEGIN
    allocate_courses();
    DBMS_OUTPUT.PUT_LINE('FACULTY ARE ALLOCATED TO STUDENTS FALL S23');
END;
/
BEGIN
    auto_generate_grade();
    DBMS_OUTPUT.PUT_LINE('GRADES ARE GENERATED FOR ENROLLMENTS S23');
END;
/
BEGIN
    calculate_sgpa();
    DBMS_OUTPUT.PUT_LINE('SGPA IS CALCULATED S23');
end;
/
BEGIN
    -- Spring Semester
    --delete FACULTY_ALLOCATION; -- Allocation is changed after every semester
    incr_sem_section();
    DBMS_OUTPUT.PUT_LINE('SEMESTER IS INCREMENTED FOR EVERY SECTION S23');
END;
/
BEGIN
    enroll_courses_all_sections();
    DBMS_OUTPUT.PUT_LINE('STUDENTS IN ALL SECTIONS ARE ENROLLED IN COURSES SPRING S23');
END;
/
BEGIN
    auto_generate_fee_challan();
    DBMS_OUTPUT.PUT_LINE('GENERATED FEE CHALLANS SPRING S23');
END;
/
BEGIN
    auto_fulfill_fee_challan();
    DBMS_OUTPUT.PUT_LINE('FEE CHALLANS ARE FULFILLED SPRING S23');
END;
/
BEGIN
    allocate_courses();
    DBMS_OUTPUT.PUT_LINE('FACULTY ARE ALLOCATED TO STUDENTS SPRING S23');
END;
/
BEGIN
    auto_generate_grade();
    DBMS_OUTPUT.PUT_LINE('GRADES ARE GENERATED FOR ENROLLMENTS SPRING S23');
END;
/
BEGIN
    calculate_sgpa();
    DBMS_OUTPUT.PUT_LINE('SGPA IS CALCULATED SPRINGS 23');
END;
/
BEGIN
    incr_sem_section();
    DBMS_OUTPUT.PUT_LINE('SEMESTER IS INCREMENTED FOR EVERY SECTION FOR S23');
end;
/

-- BATCH 24
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Rita' , 'Cobb' , '03412011085' , 'BSCV' , 'Open Merit' , '3520226888243' , '860' , '1026' , '16-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Sheila' , 'Gardner' , '03334547656' , 'BSCV' , 'Open Merit' , '3520287655636' , '960' , '1055' , '16-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Vicki' , 'Molina' , '03699947980' , 'BSCV' , 'Open Merit' , '3520270312231' , '919' , '823' , '23-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Maxine' , 'Oliver' , '03593343741' , 'BSCV' , 'Open Merit' , '3520288844923' , '918' , '934' , '22-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jonah' , 'Millington' , '03853262729' , 'BSCV' , 'Open Merit' , '3520257962148' , '925' , '857' , '03-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jessica' , 'Seawell' , '03220942418' , 'BSCV' , 'Open Merit' , '3520223765612' , '1099' , '1079' , '11-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Rosalind' , 'Young' , '03110066753' , 'BSCV' , 'Open Merit' , '3520290961152' , '1019' , '847' , '24-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Anthony' , 'Castro' , '03328472526' , 'BSCV' , 'Open Merit' , '3520233986389' , '980' , '832' , '20-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('David' , 'Bowen' , '03955220013' , 'BSCV' , 'Open Merit' , '3520218605367' , '857' , '832' , '12-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Michael' , 'Townsend' , '03833942668' , 'BSCV' , 'Open Merit' , '3520254602886' , '868' , '813' , '05-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Peggy' , 'Sibley' , '03997298892' , 'BSCV' , 'Open Merit' , '3520262927130' , '801' , '895' , '24-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Linda' , 'Lansdell' , '03526201636' , 'BSCV' , 'Open Merit' , '3520221821962' , '830' , '820' , '12-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Mary' , 'Ward' , '03578396176' , 'BSCV' , 'Open Merit' , '3520213165877' , '972' , '939' , '15-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Samuel' , 'Womack' , '03746810848' , 'BSCV' , 'Open Merit' , '3520263288207' , '829' , '896' , '18-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Rigoberto' , 'Anderson' , '03270881538' , 'BSCV' , 'Open Merit' , '3520246016570' , '1080' , '811' , '10-SEP-24');


INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jose' , 'Curran' , '03265501771' , 'BSCS' , 'Open Merit' , '3520229523099' , '894' , '936' , '17-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Wyatt' , 'Clester' , '03161463638' , 'BSCS' , 'Open Merit' , '3520289671855' , '973' , '823' , '18-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Susan' , 'Tullius' , '03361972833' , 'BSCS' , 'Open Merit' , '3520214666284' , '981' , '818' , '02-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Ruby' , 'Cowger' , '03837918714' , 'BSCS' , 'Open Merit' , '3520252627550' , '1033' , '1080' , '02-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Miranda' , 'Witherspoon' , '03125610569' , 'BSCS' , 'Open Merit' , '3520250389698' , '817' , '1062' , '10-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Kevin' , 'Lilly' , '03195537810' , 'BSCS' , 'Open Merit' , '3520265634457' , '851' , '1025' , '02-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Joe' , 'Bunce' , '03929606127' , 'BSCS' , 'Open Merit' , '3520211988504' , '885' , '990' , '02-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Randall' , 'Johnson' , '03227606285' , 'BSCS' , 'Open Merit' , '3520232736766' , '871' , '998' , '14-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Katie' , 'Ponce' , '03701733382' , 'BSCS' , 'Open Merit' , '3520236117962' , '1044' , '824' , '04-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Ronald' , 'Drake' , '03774535731' , 'BSCS' , 'Open Merit' , '3520241775764' , '1039' , '1093' , '30-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Eric' , 'Bass' , '03676925778' , 'BSCS' , 'Open Merit' , '3520281842036' , '1008' , '1052' , '07-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Jacob' , 'Boney' , '03731615802' , 'BSCS' , 'Open Merit' , '3520286339750' , '839' , '1094' , '18-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Josephine' , 'Davis' , '03226944232' , 'BSCS' , 'Open Merit' , '3520268583931' , '850' , '974' , '15-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Salvatore' , 'Rael' , '03283775387' , 'BSCS' , 'Open Merit' , '3520238950757' , '1094' , '1071' , '26-SEP-24');
INSERT INTO APPLICATION (applicant_name, applicant_father_name, phone_no , program ,application_type, cnic, matric_marks, inter_marks, APPLICATION_DATE) VALUES ('Mamie' , 'Wittels' , '03239792096' , 'BSCS' , 'Open Merit' , '3520228961666' , '971' , '923' , '10-SEP-24');

BEGIN
    -- ADMIT PROCESS AUTOMATION
    auto_admit_challan_issue('24');
    DBMS_OUTPUT.PUT_LINE('ADMIT CHALLAN ARE ISSUED S24');
END;
/
BEGIN
    fulfill_challans_admit('24');
    DBMS_OUTPUT.PUT_LINE('ADMIT CHALLAN ARE FULFILLED S24');
END;
/
BEGIN
    auto_merit_listing('24');
    DBMS_OUTPUT.PUT_LINE('MERIT LISTING S24');
END;
/
BEGIN
    auto_registration_challan_issue('24');
    DBMS_OUTPUT.PUT_LINE('REGISTRATION CHALLAN ARE ISSUED S24');
END;
/
BEGIN
    fulfill_challans_register('24');
    DBMS_OUTPUT.PUT_LINE('REGISTRATION CHALLAN ARE FULFILLED S24');
END;
/
BEGIN
    assign_student_id_after_registry('24');
    DBMS_OUTPUT.PUT_LINE('ASSIGNED STUDENT IDS TO REGISTRATION S24');
END;
/
BEGIN
    turn_down_no_challan_applics();
    DBMS_OUTPUT.PUT_LINE('NO CHALLAN PAID APPLICATION STATUS ARE UPDATED S24');
    DBMS_OUTPUT.PUT_LINE('ADMIT PROCESS DONE S24');
END;
/
BEGIN
    -- FEE CHALLAN ISSUE
    auto_generate_fee_challan();
    DBMS_OUTPUT.PUT_LINE('GENERATED FEE CHALLANS S24');
END;
/
BEGIN
    auto_fulfill_fee_challan();
    DBMS_OUTPUT.PUT_LINE('FEE CHALLANS ARE FULFILLED S24');
END;
/
BEGIN
    -- Academics
    enroll_courses_all_sections();
    DBMS_OUTPUT.PUT_LINE('STUDENTS IN ALL SECTIONS ARE ENROLLED IN COURSES S24');
END;
/

BEGIN
    allocate_courses();
    DBMS_OUTPUT.PUT_LINE('FACULTY ARE ALLOCATED TO STUDENTS FALL S24');
END;
/
BEGIN
    auto_generate_grade();
    DBMS_OUTPUT.PUT_LINE('GRADES ARE GENERATED FOR ENROLLMENTS S24');
END;
/
BEGIN
    calculate_sgpa();
    DBMS_OUTPUT.PUT_LINE('SGPA IS CALCULATED S24');
end;
/
