# Databricks notebook source
from pyspark.sql.functions import *

# COMMAND ----------

fire_df = spark.read\
                .format("CSV")\
                .option("inferschema","true")\
                .option("header","true")\
                .load("/databricks-datasets/learning-spark-v2/sf-fire/sf-fire-calls.csv")
display(fire_df)  
#df.show()                

# COMMAND ----------

Alt_df = spark.read.csv(
    "/databricks-datasets/learning-spark-v2/sf-fire/sf-fire-calls.csv",
    inferSchema="True",
    header="True",
)
# Alt_df.show()
display(Alt_df)

# COMMAND ----------

#dataframeReader.csv
#dataframeReader.json
#dataframeReader.xml
#dataframeReader.parquet
#dataframeReader.avro
#dataframeReader.orc
#dataframeReader.table
#dataframeReader.jdbc

# COMMAND ----------

Alt_df.printSchema()

# COMMAND ----------

col_Renamed_df = fire_df\
        .withColumnRenamed("Call Number", "CallNumber")\
        .withColumnRenamed("Unit ID", "UnitID")\
        .withColumnRenamed("Incident Number", "IncidentNumber")\
        .withColumnRenamed("Call Date", "CallDate")\
        .withColumnRenamed("Watch Date", "WatchDate")\
        .withColumnRenamed("Call Final Disposition", "CallFinalDisposition")\
        .withColumnRenamed("Available DtTm", "AvailableDtTm")\
        .withColumnRenamed("Zipcode of Incident", "ZipcodeOfIncident")\
        .withColumnRenamed("Station Area", "StationArea")\
        .withColumnRenamed("Final Priority", "FinalPriority")\
        .withColumnRenamed("ALS Unit", "ALSUnit")\
        .withColumnRenamed("Call Type Group", "CallTypeGroup")\
        .withColumnRenamed("Unit sequence in call dispatch", "UnitSequenceInCallDispatch")\
        .withColumnRenamed("Fire Prevention District", "FirePreventionDistrict")\
        .withColumnRenamed("Supervisor District", "Supervisor District")

display(col_Renamed_df)    
        

# COMMAND ----------

dataType_df = col_Renamed_df\
                .withColumn("CallDate",to_date("CallDate","MM/dd/yyyy"))\
                .withColumn("WatchDate",to_date("WatchDate","MM/dd/yyyy"))\
                .withColumn("AvailableDtTm",to_timestamp("AvailableDtTm","MM/dd/yyyy hh:mm:ss a"))\
                .withColumn("Delay",round("Delay",2))
dataType_df.show(1)    
display(dataType_df)            

# COMMAND ----------

# MAGIC %md
# MAGIC caching dataframe in memory to speed up processing time, as cached dataframe will be used next time to run different query.

# COMMAND ----------

df= dataType_df
df.cache()

# COMMAND ----------

# MAGIC %md
# MAGIC Q1. How Many distinct types of call were made to the fire depaertment?

# COMMAND ----------

df1 = df.select("CallType").filter("CallType is not null").distinct()
df1.count()

# COMMAND ----------

# MAGIC %md
# MAGIC Q2. What were the distinct type of calls made to the fire department?

# COMMAND ----------

df2 = df.select(expr("CallType as DistinctCallType"))\
        .filter("CallType is not null")\
        .distinct()

# After a action is called no new method can be implmented after that.  
# Only 1 action can be chained at the last.           
display(df2)        

# COMMAND ----------

# MAGIC %md
# MAGIC Q3. Find out all response time where delay time was greater than 5 min?

# COMMAND ----------

df3 = df.select("CallNumber","Delay")\
            .where("Delay > 5")
display(df3)            

# COMMAND ----------

Q4. What were the most common call types?

# COMMAND ----------

df2 = df.select("CallType")\
        .filter("CallType is not null")\
        .groupBy("CallType")\
        .count()\
        .orderBy(["count"],ascending=False)

# Count after groupby is a transformation #
 
display(df2)

# COMMAND ----------

# MAGIC %md
# MAGIC Q5. What zip code accounted for most commmon calls?

# COMMAND ----------

df5 = df.select("CallType","ZipcodeOfIncident")\
                .filter("CallType is not null")\
                .groupBy("CallType","ZipcodeOfIncident")\
                .count()\
                .orderBy(["count"], ascending=False)\
                .show(10)

# COMMAND ----------

# MAGIC %md
# MAGIC Q6. What San Fransisco neighbourhoods are in the Zip codes 94102 and 94103?

# COMMAND ----------

df6 = df.select("Neighborhood","ZipcodeOfIncident")\
        .filter("ZipcodeOfIncident == 94102" or "ZipcodeOfIncident == 94103")\
        .show()

# COMMAND ----------

# MAGIC %md
# MAGIC Q7. What was the sum of all calls, average, min and max of the all calls repsonse time?

# COMMAND ----------

df7 = df.select(sum("NumAlarms").alias("SUM_OF_ALL_ALARMS")\
                ,round(avg("Delay"),2).alias("Average_Delay")\
                ,max("Delay").alias("Maximum_Delay")\
                ,min("Delay").alias("Minimum_Delay"))
df7.show()                
display(df7)                

# COMMAND ----------

# MAGIC %md
# MAGIC Q8. How many distinct years of data are available in the CSV file? 

# COMMAND ----------

df8 = df.select(year("Calldate").alias("YEAR"))\
        .distinct()\
        .orderBy("YEAR",ascending=True)\
        .show()

# COMMAND ----------

# MAGIC %md
# MAGIC Q9. What week of the year in 2018 had the most fire call?

# COMMAND ----------

df9 = df.filter(year("Calldate") == 2018 )\
        .select(weekofyear("Calldate").alias("MAX_WEEK_OF_THE_YEAR"))\
        .groupBy("MAX_WEEK_OF_THE_YEAR")\
        .count()\
        .orderBy("count",ascending=False)\
        .show()    
        

# COMMAND ----------

# MAGIC %md
# MAGIC Q10. What neighbourhood in San Fransisco had the worse response time in 2018?

# COMMAND ----------

df10 = df.where(year("Calldate")==2018)\
            .select("Neighborhood","Delay")\
            .orderBy("Delay", ascending=False)\
            .show()   
