import snowflake.snowpark as snowpark 
from snowflake.snowpark import Window
from snowflake.snowpark.functions import col, min, max, avg, rank

def main (session: snowpark. Session):

############# Read tables in snowpark API #############
    # tableName = 'DATABASE.SCHEMA.TABLE1'
    # dataframe = session.table(tableName)
    df0 = session.table('DATABASE.SCHEMA.TABLE0')
    df1 = session.table('DATABASE.SCHEMA.TABLE1')
    df2 = session.table('DATABASE.SCHEMA.TABLE2')
    
    
#############  Filter\Where datafrom table  #############
    dataframe = session.sql('SELECT * FROM DATABASE.SCHEMA.TABLE1').filter(col("COMPANY") =='#N/A')
    dataframe = session.sql('SELECT * FROM DATABASE.SCHEMA.TABLE1').where(col("CODE") == '#N/A')

   
#############  Select columns from table  ############# 
    dataframe = session.sql('SELECT * FROM DATABASE.SCHEMA.TABLE1')
    dataframe = session.table('DATABASE.SCHEMA.TABLE1').select(col("*"))
    dataframe = session.table('DATABASE.SCHEMA.TABLE1').select(col("SOURCE","COMPANY","CODE"))
    dataframe = session.table('DATABASE.SCHEMA.TABLE1').select(col("SOURCE"),col("COMPANY"),col("CODE"))


############# Aggregation in snowpark #############
    dataframe = session.sql('SELECT MAX(AGE),MIN(AGE),AVG(AGE) FROM DATABASE.SCHEMA.TABLE1')
    dataframe = df1.select(max("AGE"),min("AGE"),avg("AGE"))
    list_age = [("AGE","max"),("AGE","min"),("AGE","avg")]
    dataframe = df1.agg(list_age)
    dataframe = df1.agg([("AGE","max"),("AGE","min"),("AGE","avg")])
    dataframe = df1.agg({"AGE":'avg'})


#############  Order by in snowpark #############
    dataframe = session.sql('SELECT SOURCE, PRODUCT_ID FROM DATABASE.SCHEMA.TABLE1 GROUP BY SOURCE,PRODUCT_ID ORDER BY 1')
    dataframe = session.table('DATABASE.SCHEMA.TABLE1').select(col("SOURCE","PRODUCT")).group_by("SOURCE","PRODUCT").agg().order_by("SOURCE")
    dataframe = session.table('DATABASE.SCHEMA.TABLE1').select(col("SOURCE","PRODUCT")).order_by(col("SOURCE")).group_by("SOURCE","PRODUCT").agg()

#############  Group by & Having in snowpark #############
    dataframe = session.sql('SELECT PRICE, COUNT(1) FROM DATABASE.SCHEMA.TABLE1 GROUP BY PRICE HAVING COUNT(1)>1')

    df = df1.select(col("PRICE" ))
    df_grp = df. group_by("PRICE")
    df_grp_cnt = df_grp.count()
    df_dups= df_grp_cnt.where(col("count")>1)
    dataframe = df_dups

    dataframe = df1.select (col("PRICE")).group_by(col ("PRICE")).count().where(col("count")>1)

    print(df1.agg(min("PRICE").as_("MIN_PRICE")).collect()[0]['MIN_PG'])
    dataframe = df1.select("SOURCE", "PROFIT", "PRICE").where(col("PRICE") == df1.agg(min("PRICE")).collect()[0]['PRICE'])


############### IN clause in Snowpark #############
    dataframe = session.sql("SELECT * FROM DATABASE.SCHEMA.TABLE1 WHERE PRICE IN (SELECT PRICE FROM DATABASE.SCHEMA.TABLE1 WHERE PRICE = '3154')")
    dataframe = df1.where(col("PRICE").in_(df1.select("PRICE").where(col("PRICE")==3154)))



############### Join in Snowpark #############
    dataframe = session.sql('SELECT T1.SOURCE, T2.PROFIT, T2.COMPANY FROM DATABASE.SCHEMA.TABLE1 AS T1 INNER JOIN DATABASE.SCHEMA.TABLE2 AS T2 ON T1.SOURCE = T2.SOURCE AND T1.PROFIT=T2.PROFIT AND T1.COMPANY = T2.COMPANY')

    dataframe_join = df1.join(df2, (df1.SOURCE == df2.SOURCE) & (df1.PROFIT == df2.PROFIT) & (df1.COMPANY == df2.COMPANY))
    dataframe = dataframe_join.select(df1.SOURCE.alias("DF1_SOURCE"),df2.PROFIT.alias("DF1_PROFIT"),df2.COMPANY.alias("DF1_COMPANY"))

    dataframe = df0.join(df1,(df0["SOURCE"] == df1["SOURCE"]) & (df0["PRICE"] == df1["PRICE"]) & (df0["COMPANY"] == df1["COMPANY"])\
    # & df1["PROFIT"] == '4300' \
    , "INNER" ).\
    join(df2, df0["SOURCE"] == df2["SOURCE"]) & (df0["PRICE"] == df2["PRICE"]) & (df0["COMPANY"] == df2["COMPANY"], "INNER").\
    filter(col(df1.PROFIT) == '4300').\
    select(df0.SOURCE.alias("DF0_SOURCE"),df0.PRICE.alias("DF0_PRICE"),df0.COMPANY.aias("DF0_COMPANY"),
           df0.SOURCE.as_("DF1_SOURCE"),df0.PRICE.as_("DF1_PRICE"),df0.COMPANY.as_("DF1_COMPANY"),
           df0.SOURCE.as_("DF2_SOURCE"),df0.PRICE.as_("DF2_PRICE"),df0.COMPANY.as_("DF2_COMPANY"))
                         

############### Window Function in snowpark ###############
    dataframe = session.sql('select profit, company, price , rn from (SELECT * , rank() over (order by profit desc) as rn from DATABASE.SCHEMA.TABLE1) where rn = 1')
    dataframe = session.table('DATABASE.SCHEMA.TABLE1').select("PROFIT","COMPANY","PRICE",rank().over(Window.order_by(col("PROFIT").desc())).as_('rn')).filter(col('RN') == 1)
                                       

############### Print a sample of the dataframe to standard output ############### 
    dataframe. show()
    

    return dataframe