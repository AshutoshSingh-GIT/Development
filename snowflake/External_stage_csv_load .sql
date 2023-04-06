---****Integration between Snowflake and cloud provide***---
--1. create a role with full access to AWS s3 bucket on aws side 
--2. create a storage integration object on snowflake side
// Create storage integration object
create or replace storage INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::555064756008:role/aws_s3_snowflake_intg'
  STORAGE_ALLOWED_LOCATIONS = ('s3://bucket-name/path/', 's3://bucket-name/path/')
  COMMENT = 'Integration with aws s3 buckets' ;
   
   
// Get external_id and update it in S3
DESC integration s3_int;

// ARN -- Amazon Resource Names
// S3 -- Simple Storage Service
// IAM --(integrated Account Management) -- for Identity and Access Management


--Create your own warehouse
 create or replace warehouse WareMini 
 with
 Warehouse_size = 'X-SMALL'
 auto_suspend = 120
 auto_resume = true;
 
use warehouse waremini;
alter warehouse WAREMINI Suspend;
alter warehouse WAREMINI Resume;

-- Create a file format
Create or replace file format MyCsvFormat
type = 'CSV',
field_delimiter = ',',
skip_header=1;


Show file formats;
show file formats like %My%Fo%;
show file formats in database DEMO;
show file formats in Schema DEMO.MODEL;
DESC file format demo.model.MyCsvFormat;

Alter file format demo.model.MyCsvFormat
set skip_header=1

additional fields

{"TYPE":"CSV","RECORD_DELIMITER":"\n",
"FIELD_DELIMITER":",","FILE_EXTENSION":null,
"SKIP_HEADER":1,"DATE_FORMAT":"AUTO",
"TIME_FORMAT":"AUTO",
"TIMESTAMP_FORMAT":"AUTO","BINARY_FORMAT":"HEX",
"ESCAPE":"NONE","ESCAPE_UNENCLOSED_FIELD":"\\",
"TRIM_SPACE":false,"FIELD_OPTIONALLY_ENCLOSED_BY":"NONE",
"NULL_IF":["\\N"],"COMPRESSION":"AUTO","ERROR_ON_COLUMN_COUNT_MISMATCH":true,
"VALIDATE_UTF8":true,"SKIP_BLANK_LINES":false,"REPLACE_INVALID_CHARACTERS":false,
"EMPTY_FIELD_AS_NULL":true,"SKIP_BYTE_ORDER_MARK":true,"ENCODING":"UTF8"} 

--Create a EXTERNAL_NAMED stage objects

Create or replace Stage MYCSVSTAGE
file_format = MYCSVFORMAT,
--STORAGE_INTEGRATION = s3_int
url = 's3://bucketsnowflakes3';

Show stages like '%MY%';
Show stages;
show stages in database Demo;
show stages in schema Demo.Model;
Select * from Information_Schema.Stages where Stage_Name='MYCSVSTAGE';
DESC STAGE MYCSVSTAGE;

--List files in external/Internal stage
list @Mycsvstage;

-- Create a table 
 Create table if not exists Demo.Model.OrderDetails(
 order_ID varchar(50),
   Amount int,
   profit int,
   quantity int,
   category varchar(30),
   subcategory varchar(30)
 );
select * from Demo.Model.OrderDetails;
truncate table Demo.Model.OrderDetails;

-- copy data from external stage;
COPY INTO Demo.Model.OrderDetails
from @Mycsvstage
--file_format = (type = csv field_delimiter=',' skip_header=1)
--files = ('OrderDetails.csv')
pattern = '.*Details.*';



