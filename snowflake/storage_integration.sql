//Create a storage inetegration object 

Create or replace Storage integration  ASWS_S3_Integration
Type = External_Stage
STORAGE_PROVIDER=S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN='arn:aws:iam::589990408564:role/AWS_S3_Snowflake_Integration'
STORAGE_ALLOWED_LOCATIONS=('s3://akkus3bucket/csv/','s3://akkus3bucket/json/','s3://akkus3bucket/json/')
COMMENT='Integration with AWS s3 Akku bucket'

// Get external_id (STORAGE_AWS_IAM_USER_ARN) and update it in S3
Desc Integration ASWS_S3_Integration;

// ARN -- Amazon Resource Names
// S3 -- Simple Storage Service
// IAM -- Identity and Access Management



// 1. Create database and schema
// 2. Create file format object
// 3. Create stage object with integration object & file format object
// 4. Listing files under your s3 buckets
// 5. Create a table first
// 6. Use Copy command to load the files
// 7. Validate the data

// 1.
Create schema IF NOT EXISTS MY_DB.Integration_Schema;

// 2.
Create file format if not exists MY_DB.Integration_Schema.EXT_Intg_CSV_LOAD 
  type = CSV
  field_delimiter = ','
  skip_header = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '\042'
  empty_field_as_null = TRUE; 
  
// 3.
Create STAGE IF NOT EXISTS MY_DB.Integration_Schema.EXT_INTG_STG
 file_format = MY_DB.Integration_Schema.EXT_Intg_CSV_LOAD
 Storage_integration = ASWS_S3_Integration
 URL = 's3://akkus3bucket/csv/';
 
 --DESC Stage MY_DB.Integration_Schema.EXT_INTG_STG;
 --show stages in schema my_db.INTEGRATION_SCHEMA

// 4. 
list @MY_DB.Integration_Schema.EXT_INTG_STG;

// 5.
Create or replace table MY_DB.Integration_Schema.Currency
(
code varchar(20),
symbol varchar(20),
Name varchar(50)
);

// 6.
Copy into MY_DB.Integration_Schema.Currency
from @MY_DB.Integration_Schema.EXT_INTG_STG
pattern = '.*currency.*'

// 7. 
Select * from MY_DB.Integration_Schema.Currency;
  