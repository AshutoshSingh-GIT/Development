import snowflake.connector as sfc
from  variables import username,password,account

connection= sfc.connect(
    user=username,
    password=password,
    account=account,
    warehouse='WAREMINI',
    database='',
    schema=''
)

cur=connection.cursor()
try:
    cur.execute("CREATE TABLE IF NOT EXISTS MY_DB.SCHEMA1.PY_TAB_02("
                "ID INT AUTOINCREMENT(1,1),"
                "NAME VARCHAR(20),"
                "SKILL varchar(20));"
                )
    Insert_records = [('Ashutosh','SQL'),('ASHISH','JAVASCRIPT'),('AKANKSHA','POWERBI')]
    cur.executemany("INSERT INTO MY_DB.SCHEMA1.PY_TAB_02 (NAME,SKILL)"
                    "values (%s,%s)"
                    , Insert_records)
    cur.execute("select * from MY_DB.SCHEMA1.PY_TAB_02")
    output=cur.fetchall()
    print(output)
finally:
    cur.close()
connection.close()