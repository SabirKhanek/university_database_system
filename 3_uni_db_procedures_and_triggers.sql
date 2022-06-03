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

@4_uni_db_populate_tables