import snowflake.connector
from  variables import username,password,account

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
    cur.execute("CREATE TABLE IF NOT EXISTS MY_DB.SCHEMA1.PYTHON_TEST_TABLE ( "
                "ID INT,"
                "NAME VARCHAR (20));")
    cur.execute("INSERT INTO MY_DB.SCHEMA1.PYTHON_TEST_TABLE"
                "(ID, NAME) VALUES"
                "(1,'Ankit'),"
                "(2,'Romesh')")
    cur.execute("select * from MY_DB.SCHEMA1.PYTHON_TEST_TABLE")
    out=cur.fetchall()
    print(out)
finally:
    cur.close()
conn.close()        