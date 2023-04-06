# to check snowsql version in terminal
  snowsql -v
  
  ## connecting to snow flake using snowsql ##
   1. by providing the username and password
   snowsql -a <account_name> -u <login_name>
   Enter your password when prompted. Enter !quit to quit the connection. 
   2. by keeping the credentails in configuration file of snowsql
   -----
   open ~/.snowsql/config
   -----
   Add your connection information to the ~/.snowsql/config file:
   accountname = <account_name>
   username = <account_name>
   password = <password> 
  Execute the following command to connect to Snowflake:
  snowsql
  or double click the SnowSQL application icon in the Applications directory. 