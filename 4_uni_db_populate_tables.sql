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
