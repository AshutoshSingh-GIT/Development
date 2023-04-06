/* JavaScript Object Notation (Json)

Data Representation format
lightweight and easy to read/write
easy to integrate with other languages

---Json DataTypes-----
Strings
Numbers 
booleans
Null
Arrays ["1","3","hello"]
Objects {"Key":"Value"}

---file structure 

{ 
"Name":"ASHU",
"Favourite_Number": 3,
"IsProgrammer":True
"hobbies":["weight lifting","cricket"],
"friends":[{
n"Name":"Joe",
"Favourite_Number": 9,
"IsProgrammer":No
"hobbies":["wall climbing","hockey"],
"friends":[{...}]
}]
}
*/

CREATE OR REPLACE Database MY_DB;

CREATE OR REPLACE SCHEMA MY_DB.Schema1;

create or replace warehouse WareMini 
 with
 Warehouse_size = 'X-SMALL'
 auto_suspend = 120
 auto_resume = true;
 
 
Create or replace file format MY_DB.schema1.file_format_json
type = JSON;

Create or replace stage MY_DB.schema1.json_internal_stage
file_format = file_format_json

put file:///Users/ashutosh/Downloads/example.json @json_internal_stage;

list  @MY_DB.Schema1.json_internal_stage;


--Creating Stage Table to store RAW Data 
Create or replace table MY_DB.Schema1.Json_Raw(
Column_1 variant
);


--Copy the RAW data into a Stage Table
Copy Into MY_DB.Schema1.Json_Raw
from @MY_DB.Schema1.json_internal_stage
files = ('example.json.gz');


select * from MY_DB.Schema1.Json_Raw;

select 
column_1:Name as NAME,
column_1:DOB as DOB,
column_1:Gender as GENDER,
column_1:Pets[0] as "PETs",
column_1:Phone.Home as HOME,
column_1:Phone.work as WORK,
column_1:Address.House_Number as HO_NO,
column_1:Address.City as CITY,
column_1:Address.State As STATE
from MY_DB.Schema1.Json_Raw
UNION ALL
select 
column_1:Name as NAME,
column_1:DOB as DOB,
column_1:Gender as GENDER,
column_1:Pets[1] as "PETs",
column_1:Phone.Home as HOME,
column_1:Phone.work as WORK,
column_1:Address.House_Number as HO_NO,
column_1:Address.City as CITY,
column_1:Address.State As STATE
from MY_DB.Schema1.Json_Raw
UNION ALL
select 
column_1:Name as NAME,
column_1:DOB as DOB,
column_1:Gender as GENDER,
column_1:Pets[2] as "PETs",
column_1:Phone.Home as HOME,
column_1:Phone.work as WORK,
column_1:Address.House_Number as HO_NO,
column_1:Address.City as CITY,
column_1:Address.State As STATE
from MY_DB.Schema1.Json_Raw
where "PETs" is not null;


Create or replace table My_DB.schema1.JSON_Flatten
As 
select 
column_1:Name as NAME,
column_1:DOB as DOB,
column_1:Gender as GENDER,
column_1:Pets[0] as "PETs",
column_1:Phone.Home as HOME,
column_1:Phone.work as WORK,
column_1:Address.House_Number as HO_NO,
column_1:Address.City as CITY,
column_1:Address.State As STATE
from MY_DB.Schema1.Json_Raw
UNION ALL
select 
column_1:Name as NAME,
column_1:DOB as DOB,
column_1:Gender as GENDER,
column_1:Pets[1] as "PETs",
column_1:Phone.Home as HOME,
column_1:Phone.work as WORK,
column_1:Address.House_Number as HO_NO,
column_1:Address.City as CITY,
column_1:Address.State As STATE
from MY_DB.Schema1.Json_Raw
UNION ALL
select 
column_1:Name as NAME,
column_1:DOB as DOB,
column_1:Gender as GENDER,
column_1:Pets[2] as "PETs",
column_1:Phone.Home as HOME,
column_1:Phone.work as WORK,
column_1:Address.House_Number as HO_NO,
column_1:Address.City as CITY,
column_1:Address.State As STATE
from MY_DB.Schema1.Json_Raw
where "PETs" is not null;

select * from JSON_FLATTEN;
truncate JSON_FLATTEN
desc table JSON_FLATTEN


Insert into JSON_FLATTEN
 select 
column_1:Name as NAME,
column_1:DOB as DOB,
column_1:Gender as GENDER,
F1.value as "PETs",
column_1:Phone.Home as HOME,
column_1:Phone.work as WORK,
column_1:Address.House_Number as HO_NO,
column_1:Address.City as CITY,
column_1:Address.State As STATE
from json_raw,
table (flatten(column_1:Pets)) F1;
 



