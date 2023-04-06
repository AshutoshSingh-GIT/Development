/* 
Copy INTO <TABLE_NAME>
from <Stage_Name>
file_format = <FF_Name>
file/Pattern = ('f1','f2'),<.*.*>
.
.
.
--Copy_options
VALIDATION_MODE = RETURN_n_ROWS/REturn_Error/RETURN_ALL_ERORRS
RETURN_FAILED_ONLY = TRUE/FALSE -- Display names of the files that have failed to load
ON_ERROR = Continue/Skip_file/skip_file_num/skip_file_num%/Abort_Statement
FORCE = True/false
SIZE_LIMIT = <Number or data in bytes>
TRUNCATE_COLUMNS = TRUE/FALSE -- default is false
ENFORCE_LENGTHS = TRUE/FALSE -- Default is true  
PURGE = TRUE/FALSE --- By default it is false i.e. files will not be removed from stage
LOAD_UNCERTAIN_FILES = True/false -- file in stage with unknown status will be loaded if true, by default is false
*/

List 
s3://snowflakebucket-copyoption/size/