/*    Internal stage (data file on local machine or linux/unix server)
1. user stage (@~)
   whenever a user is added in snowflake a storage area is allocated 
   user stage cannot be altered or deleted 
   user stage not approprite if other user need access to data file
2. Table stage (@%TableName)
   whenever a new table is created a staging area is allocated , with same name as the table
   stage file by multiple users in table stage but can can only be loaded in one table
   table stgae can not be altered or dropped
3. Named Internal stage (@InternalStageName)
   It is a database object i.e. required to be created
   multiple users can load files into multiple tables.
   CREATE STAGE IF NOT EXISTS MyInternalStage;
*/

create table if not exists DEMO.MODEL.ANNUAL_ENTERPRISE_SURVEY (
year INT,
Industry_code_ANZSIC varchar(255),
Industry_name_ANZSIC varchar(100),
Rme_size_grp varchar(255),
Variable varchar(255),
Value varchar(255),
Unit varchar(255)
);

alter table DEMO.MODEL.ANNUAL_ENTERPRISE_SURVEY ALTER Industry_code_ANZSIC  SET DATA Type varchar(255);
desc table DEMO.MODEL.ANNUAL_ENTERPRISE_SURVEY;


drop table DEMO.MODEL.ANNUAL_ENTERPRISE_SURVEY;
truncate table DEMO.MODEL.ANNUAL_ENTERPRISE_SURVEY;
select * from DEMO.MODEL.ANNUAL_ENTERPRISE_SURVEY where len(INDUSTRY_CODE_ANZSIC)>1 
--17028
--17028
--17028


list @~;
list @%ANNUAL_ENTERPRISE_SURVEY;
list @myInternalNamedStage;



-- Put file in internal stage from local machinee/linux server (through snowsql only)
for linux/macos
put file:///Users/ashutosh/Downloads/annual-enterprise-survey.csv @~/staged;
put file:///Users/ashutosh/Downloads/annual-enterprise-survey.csv @%ANNUAL_ENTERPRISE_SURVEY;
put file:///Users/ashutosh/Downloads/annual-enterprise-survey.csv @myInternalNamedStage;

Create file format if not exists myInternalNamedFileFormat
type = 'CSV',
field_delimiter = ',',
skip_header=1;

show file formats like '%myInternalNamedFileFormat%'
desc file format myInternalNamedFileFormat;
Alter file format myInternalNamedFileFormat 
set FIELD_OPTIONALLY_ENCLOSED_BY ='\"';

ALTER FILE FORMAT "DEMO"."MODEL".MYINTERNALNAMEDFILEFORMAT 
SET COMPRESSION = 'AUTO' FIELD_DELIMITER = ',' RECORD_DELIMITER = '\n' 
SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '\042' TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE ESCAPE = 'NONE' ESCAPE_UNENCLOSED_FIELD = '\134' DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO' NULL_IF = ('\\N');
 
Create Stage if not exists myInternalNamedStage
file_format = myInternalNamedFileFormat;

desc stage myInternalNamedStage;
show stages like '%myInternalNamedStage%';


for windows 
put file://c:\data/data.csv @~/staged;
put file://c:\data/data.csv @%myTable;
put file://c:\data/data.csv @myStage;

-- copy command 
--copy from user stage
COPY INTO DEMO.MODEL.ANNUAL_ENTERPRISE_SURVEY
from @~/staged
file_format = (type = csv field_delimiter=',' skip_header=1 FIELD_OPTIONALLY_ENCLOSED_BY ='\"')
pattern = '.*annual-enterprise-survey.*';

--copy from table stage
COPY INTO DEMO.MODEL.ANNUAL_ENTERPRISE_SURVEY
from @%ANNUAL_ENTERPRISE_SURVEY
file_format = (type = csv field_delimiter=',' skip_header=1 FIELD_OPTIONALLY_ENCLOSED_BY ='\"')
files = ('annual-enterprise-survey.csv.gz');

--copy from internal named stage
COPY INTO DEMO.MODEL.ANNUAL_ENTERPRISE_SURVEY
from @myInternalNamedStage
pattern = '.*annual-enterprise-survey.*';

