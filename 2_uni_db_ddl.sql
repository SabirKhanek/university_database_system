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

@3_uni_db_procedures_and_triggers