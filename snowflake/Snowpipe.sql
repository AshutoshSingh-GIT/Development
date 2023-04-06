// 1. Create a storage integration object
// 2. create a stage object using storage integration object
// 3. Create and test copy command to load the data 
// 4. Create a pipe using the copy command
// 5. Setup event notification at cloud storage providers end. 


/* 
Create or replace pipe Pipe_Name
Auto_Ingest= TRUE/FALSE
AS
<Copy Command>

--Operations
Create pipe 
Alter pipe (Alter pipe PIPE_NAME pipe_Excecution_Paused= True/False)
drop pipe
describe pipe/ Desc pipe 
show pipes
*/

Create schema if not exists My_DB.sp;

// 1.
Create or replace storage integration SP_S3_INT
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER= S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN='arn:aws:iam::589990408564:role/AWS_S3_Snowflake_Integration'
STORAGE_ALLOWED_LOCATIONS=('s3://akkus3bucket/csv/','s3://akkus3bucket/json/','s3://akkus3bucket/json/')
COMMENT='Integration with AWS s3 pipe bucket'

Alter STORAGE INTEGRATION SP_S3_INT SET STORAGE_ALLOWED_LOCATIONS= ('s3://akkus3bucket/Snowpipe/csv/')

--DESC STORAGE INTEGRATION SP_S3_INT
--show STORAGE INTEGRATIONS

// 2. 
Create or replace file format MY_DB.SP.SP_FF
type=csv
field_Delimiter = ','
skip_header=1
empty_field_as_null = TRUE
field_optionally_enclosed_by = '\042';


Create or replace stage MY_DB.SP.SP_EXT_STG
URL='s3://akkus3bucket/Snowpipe/csv/'
Storage_integration = SP_S3_INT
file_format= MY_DB.SP.SP_FF;

List @MY_DB.SP.SP_EXT_STG;

// 3.
Create or replace table My_DB.sp.SP_TEST(
Name Varchar(50),
Mobile_Number int,
Age int,
color varchar(20),
height Varchar(50),	
works varchar(20)
); 

Copy into My_DB.SP.SP_TEST 
from @MY_DB.SP.SP_EXT_STG
pattern='.*File.*'
ON_ERROR=SKIP_FILE
PURGE=TRUE
VALIDATION_MODE=Return_6_Rows--Return_Errors--RETURN_ALL_ERRORS
--Files=('File1.csv','File1.csv','File1.csv')


Select * from My_DB.SP.SP_TEST 
truncate table My_DB.SP.SP_TEST

// 4. 
Create or replace Pipe MY_DB.SP.S3_CSV_SP
AUTO_INGEST=TRUE
AS
Copy into My_DB.SP.SP_TEST 
from @MY_DB.SP.SP_EXT_STG
pattern='.*File.*'
ON_ERROR=SKIP_FILE;

--Desc pipe MY_DB.SP.S3_CSV_SP;
--Show pipes in schema MY_DB.SP;

--Pause pipe
ALTER PIPE MY_DB.SP.S3_CSV_SP  SET PIPE_EXECUTION_PAUSED = true;
-- Update copy command pipe
Create or replace Pipe MY_DB.SP.S3_CSV_SP
AUTO_INGEST=TRUE
AS
Copy into My_DB.SP.SP_TEST 
from @MY_DB.SP.SP_EXT_STG
pattern='.*File.*'
ON_ERROR=SKIP_FILE;
--Resume pipe
ALTER PIPE MY_DB.SP.S3_CSV_SP  SET PIPE_EXECUTION_PAUSED = False;

// 5 Create event notification
--notification_channel: arn:aws:sqs:ap-southeast-1:666340804752:sf-snowpipe-AIDAZWJIBZCIJT3D52C2M-DBoTQRVsYRxtsMvQ3CtxIw
// Get Notification channel ARN and update the same in event notifications SQS queue


/**********************
Troubleshooting pipes
**********************/
1. Cheking the pipe status
SELECT SYSTEM$PIPE_STATUS('S3_CSV_SP');
{"executionState":"RUNNING","pendingFileCount":0,"lastIngestedTimestamp":"2023-03-30T10:16:47.72Z","lastIngestedFilePath":"File1.csv",
"notificationChannelName":"arn:aws:sqs:ap-southeast-1:666340804752:sf-snowpipe-AIDAZWJIBZCIJT3D52C2M-DBoTQRVsYRxtsMvQ3CtxIw","numOutstandingMessagesOnChannel":5,"
lastReceivedMessageTimestamp":"2023-03-30T10:16:47.528Z","lastForwardedMessageTimestamp":"2023-03-30T10:16:50.61Z",
"lastPulledFromChannelTimestamp":"2023-03-30T10:18:07.419Z","lastForwardedFilePath":"akkus3bucket/Snowpipe/csv/File1.csv"}
select current_timestamp UTC --2023-03-30 03:17:43.908 -0700

2. Check copy history
select * from Table (Information_schema.copy_history(
table_name=>'My_DB.SP.SP_TEST',
Start_time=>DATEADD(HOUR,-1,Current_timestamp())) );

3. validate the pipe load status
select * from table(Information_schema.Validate_pipe_load(
pipe_name=>'MY_DB.SP.S3_CSV_SP',
Start_time=>DATEADD(HOUR,-1,Current_timestamp())
));

4. 
Load the files using copy command manually

5. 
validate the data in the table








