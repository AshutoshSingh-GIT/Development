Create schema schema2;

/* CREATE OR REPLACE TASK TASK_1
   WAREHOUSE = ''
   SCHEDULE = ''
   AFTER dependent_task_name_if_exists
   
   AS 
   
   SQL Query or Stored Procedure */
   
    Alter task Task_1 ADD AFTER TASK_2;
    Alter task Task_1 REMOVE AFTER TASK_2;
    Alter task Task_1 SET SCHEDULE = '5 minutes';
    Alter task Task_1 RESUME; -- by default tasks are suspended
    Alter task Task_1 SUSPEND;
    
    
    ----- USING CRON :: -- 
    Every cron conatins 5 stars (*****)
       using cron ***** timezone
    
    --Directed Acyclic graph (DAG)---
    direction and dependencies to task execution 
    
    
    ---------
    Task_History()
    Select * from table(Information_schema.task_History())
    
    
    Troubleshooting task;
    1. confirm if task is in resume state
    2. check task history and check execution state, if it is failed take query id,
    check failure reason
    3. View permission granted to the task owner,
    should have access to database, schema, table and warehose
    4. Verify the conditions 
    
    
    
    
    ----------------------------------------
    
    Create or replace Table My_DB.SCHEMA2.TRACK_LOAD_TIME (
      ID INT AUTOINCREMENT START =1 INCREMENT =1,
      Name varchar (20) default 'Ashutosh',
      LoAD_TIME timestamp
    );
    
    create or replace task My_DB.SCHEMA2.TASK_TRACK_TIME
    warehouse = WAREMINI
    SCHEDULE = '1 minute'
    AS
    INSERT into My_DB.SCHEMA2.TRACK_LOAD_TIME 
    (LoAD_TIME)
    values
    (Current_timestamp);
    
    create or replace task My_DB.SCHEMA2.TASK_TRACK_TIME2
    warehouse = WAREMINI
    SCHEDULE = 'USING CRON * * * * * UTC'
    AS
    INSERT into My_DB.SCHEMA2.TRACK_LOAD_TIME 
    (NAME, LOAD_TIME)
    values
    ('ANSHU',Current_timestamp);
    
    
    
    Select * from My_DB.SCHEMA2.TRACK_LOAD_TIME;
    
    show tasks;
    desc task My_DB.SCHEMA2.TASK_TRACK_TIME;
    desc task My_DB.SCHEMA2.TASK_TRACK_TIME2;
    
    Alter task My_DB.SCHEMA2.TASK_TRACK_TIME RESUME;
    alter task My_DB.SCHEMA2.TASK_TRACK_TIME SUSPEND;
    
    
    
    Alter task My_DB.SCHEMA2.TASK_TRACK_TIME2 RESUME;
    alter task My_DB.SCHEMA2.TASK_TRACK_TIME2 SUSPEND;
    
    
    
    --Example of cron entry::::
    
// Every day at 7AM UTC timezone
SCHEDULE = 'USING CRON 0 7 * * * UTC'

// Every day at 10AM and 10PM
SCHEDULE = 'USING CRON 0 10,22 * * * UTC'

// Every month last day at 11 PM
SCHEDULE = 'USING CRON 0 23 L * * UTC'

// Every Monday at 6.30 AM
SCHEDULE = 'USING CRON 30 6 * * 1 UTC'

// First day of the month only from January to March at 7 AM
SCHEDULE = 'USING CRON 0 7 1 1-3 * UTC'

--google crom maker and get cron command based on requirements
    
    
    
 Creating DAG of TASKS;
 
 create OR REPLACE table MY_DB.SCHEMA2.CUST_ADMIN
 (
 CUST_ID INT AUTOINCREMENT START=1 INCREMENT=1,
 CUST_NAME VARCHAR(50) DEFAULT 'ASHUTOSH SINGH',
 DEPT_NAME VARCHAR(20) DEFAULT 'MARKETING',
 LOAD_TIME TIMESTAMP  
 );
 
 --ROOT TASK
 CREATE OR REPLACE TASK MY_DB.SCHEMA2.TASK_CUST_ADMIN
 WAREHOUSE=WAREMINI
 SCHEDULE= 'USING CRON * * * * * UTC'
 AS 
 INSERT INTO MY_DB.SCHEMA2.CUST_ADMIN
 (LOAD_TIME)
 VALUES
 (CURRENT_TIMESTAMP);
 
 --CHILD TASK
 CREATE OR REPLACE TASK MY_DB.SCHEMA2.TASK_CUST_MARKETING
 WAREHOUsE = WAREMINI
 AFTER MY_DB.SCHEMA2.TASK_CUST_ADMIN
 AS 
 CREATE OR REPLACE TABLE MY_DB.SCHEMA2.CUST_MARKETING
 AS
 SELECT * FROM MY_DB.SCHEMA2.CUST_ADMIN where DEPT_NAME = 'MARKETING'
 
 
 --CHILD TASK
 CREATE OR REPLACE TASK MY_DB.SCHEMA2.TASK_CUST_HR
 --WAREHOSUE = WAREMINI by defualt it will use snowflake compute resource
 AFTER MY_DB.SCHEMA2.TASK_CUST_ADMIN
 AS 
 CREATE OR REPLACE TABLE MY_DB.SCHEMA2.CUST_HR
 AS
 SELECT * FROM MY_DB.SCHEMA2.CUST_ADMIN where DEPT_NAME = 'HR'
 
 --CHILD TASK depend on previous chlid task
 CREATE OR REPLACE TASK MY_DB.SCHEMA2.TASK_CUST_SALES
 AS 
 CREATE OR REPLACE TABLE MY_DB.SCHEMA2.CUST_SALES
 AS
 SELECT * FROM MY_DB.SCHEMA2.CUST_ADMIN where DEPT_NAME = 'SALES'
  
  ALTER TASK MY_DB.SCHEMA2.TASK_CUST_SALES ADD AFTER MY_DB.SCHEMA2.TASK_CUST_MARKETING;
  ALTER TASK MY_DB.SCHEMA2.TASK_CUST_SALES ADD AFTER MY_DB.SCHEMA2.TASK_CUST_HR;
  
  SHOW TASKS;
  ALTER TASK TASK_CUST_SALES resume;
  ALTER TASK TASK_CUST_HR resume;
  ALTER TASK TASK_CUST_MARKETING Resume;
  ALTER TASK TASK_CUST_ADMIN RESUME;
  
  ALTER TASK TASK_CUST_ADMIN SUSPEND;
  ALTER TASK TASK_CUST_MARKETING SUSPEND;
  ALTER TASK TASK_CUST_HR Suspend;
  ALTER TASK TASK_CUST_SALES Suspend;

  
  Select * from MY_DB.SCHEMA2.CUST_ADMIN
  Select * from MY_DB.SCHEMA2.CUST_MARKETING
  Select * from MY_DB.SCHEMA2.CUST_HR
  Select * from MY_DB.SCHEMA2.CUST_SALES
  
  -- To alter task susspend first
  Alter task TASK_CUST_ADMIN 
  MODIFY 
  AS
  INSERT INTO MY_DB.SCHEMA2.CUST_ADMIN (CUST_NAME,DEPT_NAME, LOAD_TIME)
  VALUES
  ('ANSHU','SALES',CURRENT_TIMESTAMP);
  
  
  -- check the task_history
  select * from table  (information_schema.TASK_HISTORY());
  select * from table  (information_schema.TASK_HISTORY(task_name => 'task_TRACK_TIME'));
  select * from table  (information_schema.TASK_HISTORY(
  Scheduled_time_range_start=>dateadd('hour',-6,current_timestamp()),
    result_limit => 10,
    task_name => 'task_TRACK_TIME')
  );
  select * from table  (information_schema.TASK_HISTORY(
  Scheduled_time_range_start=>to_timestamp_ltz('2023-03-25 12:56:48.561 -0700'),
  Scheduled_time_range_end=>to_timestamp_ltz('2023-03-26 2:00:48.561 -0700')
  )
  );
  select to_timestamp_ltz(current_timestamp);
 