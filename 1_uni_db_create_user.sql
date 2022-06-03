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

@2_uni_db_ddl