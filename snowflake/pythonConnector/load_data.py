import snowflake.connector as sf
from variables import password,username,account
import pandas as pd 

conn= sf.connect(
    user=username,
    password=password,
    account=account,
    warehouse='WAREMINI',
    database='MY_DB',
    schema=''
)

cur=conn.cursor()

try:
    cur.execute("CREATE SCHEMA IF NOT EXISTS MY_DB.PYSCHEMA")

    cur.execute("CREATE FILE FORMAT IF NOT EXISTS MY_DB.PYSCHEMA.PYLOAD_FF "
        " type = 'csv' "
        " field_delimiter = ','  "
        " skip_header = 1 "
        )

    cur.execute("CREATE STAGE IF NOT EXISTS MY_DB.PYSCHEMA.PYLOAD_STG"
        " File_format=MY_DB.PYSCHEMA.PYLOAD_FF ")

    cur.execute(" put file:///Users/ashutosh/Downloads/sampleemployee.csv @MY_DB.PYSCHEMA.PYLOAD_STG "
        " auto_compress = false overwrite = true ")

    cur.execute("CREATE TABLE IF NOT EXISTS MY_DB.PYSCHEMA.PY_EMPLOYEE_LOAD("
                    "EMP_ID INTEGER,"
                    "EMP_NAME STRING,"
                    "EMP_MAIL STRING,"
                    "EMP_SSN STRING);"
    )

    cur.execute("COPY INTO  MY_DB.PYSCHEMA.PY_EMPLOYEE_LOAD "
        " FROM @MY_DB.PYSCHEMA.PYLOAD_STG "
        " FILES=('sampleemployee.csv') "
        " ON_ERROR=SKIP_FILE "
        )

    cur.execute("select * from MY_DB.PYSCHEMA.PY_EMPLOYEE_LOAD")
    output=cur.fetchall()
    df=pd.DataFrame(output)
    print(df)
    #cur.fetch_pandas_all("select * from MY_DB.PYSCHEMA.PY_EMPLOYEE_LOAD")
finally:
    cur.close()
conn.close()
