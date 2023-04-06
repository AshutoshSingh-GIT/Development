-- 1. Permanent_table
-- 2. Transient_table
-- 3. Temporary_table
-- 4. External_table


/*DROP TABLE mytable;

DROP SCHEMA myschema;

DROP DATABASE mydatabase;


UNDROP TABLE mytable;

UNDROP SCHEMA myschema;

UNDROP DATABASE mydatabase;*/


show tables in database MY_DB;
show tables in schema MY_DB.schema1;

Desc table MY_DB.schema1.JSON_FLATTEN;
select get_ddl('table', 'MY_DB.schema1.JSON_FLATTEN');


Create or replace table My_DB.Schema1.Perm (id number);
Create or replace transient table My_DB.Schema1.Tran_table (id number);
Create or replace temporary table My_DB.Schema1.Temp_table (id float);

Alter table My_DB.Schema1.Perm Set DATA_RETENTION_TIME_IN_DAYS=0;

--CREATE TABLE mytable(col1 NUMBER, col2 DATE) DATA_RETENTION_TIME_IN_DAYS=90;
--ALTER TABLE mytable SET DATA_RETENTION_TIME_IN_DAYS=30;


Insert into My_DB.Schema1.Tran_table
(Id)
Values
(18);

Show tables History like 'Tran%' in My_DB.Schema1; 
Show tables History in My_DB.Schema1; 

/*SHOW TABLES HISTORY LIKE 'load%' IN mytestdb.myschema;

SHOW SCHEMAS HISTORY IN mytestdb;

SHOW DATABASES HISTORY;*/



##Snowflake time travel  -- recover deleted / updated data
     1.  Select *  from table_name 
           before (timestamp => '2022-08-09 00:00:00:00'::timestamp);
     2.  Select *  from table_name 
           before (statement => 'query_id');
     3.   Select *  from table_name 
           at (offset => -60*60*24*2); 
           
#####. Revert back to table ::::           
    select * from  My_DB.Schema1.TRAN_TABLE; 
    select * from  My_DB.Schema1.TRAN_TABLE
    at (offset => -60*15);
    select * from  My_DB.Schema1.TRAN_TABLE
    before (statement => '01ab2953-3200-afec-0000-0003ad26d6c1');
    select * from  My_DB.Schema1.TRAN_TABLE
    AT (timestamp => '2023-03-24 07:00:00'::TIMESTAMP );
    
    select Current_timestamp();
## Table, schemas, databases can be undropped  -- based on time retention perid of 1-90 

