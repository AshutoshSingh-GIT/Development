import snowflake.connector
from  variables import username,password,account
import pandas

conn = snowflake.connector.connect(
    user=username,
    password=password,
    account=account,
    warehouse='WAREMINI',
    database='',
    schema=''
)
cur=conn.cursor()
try:
    cur.execute("select * from MY_DB.SCHEMA1.JSON_FLATTEN")
    one_row=cur.fetchall()
    print(one_row)

    cur.execute("select * from MY_DB.PYSCHEMA.PY_EMPLOYEE_LOAD")
    df=cur.fetch_pandas_all()
    df

finally:
    cur.close()
conn.close()        

