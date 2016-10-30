CREATE EXTENSION mysql_fdw;
CREATE EXTENSION redis_fdw;
CREATE EXTENSION tds_fdw;

       CREATE SERVER mysql_server
FOREIGN DATA WRAPPER mysql_fdw
           OPTIONS ( host 'mysql'
                   , port '3306'
                   );

CREATE USER MAPPING FOR PUBLIC
                 SERVER mysql_server
              OPTIONS ( username 'root'
                      , password 'mysqlpassword'
                      );

CREATE FOREIGN TABLE sample_mysql
                   ( id int
                   , value float
                   )
              SERVER mysql_server
           OPTIONS ( dbname 'fdw_challenge'
                   , table_name 'sample'
                   );

       CREATE SERVER redis_server
FOREIGN DATA WRAPPER redis_fdw
           OPTIONS ( address 'redis'
                   , port '6379'
                   );

CREATE USER MAPPING FOR PUBLIC
             SERVER redis_server
            OPTIONS (password 'secret');

 CREATE FOREIGN TABLE sample_redis (key text, val text)
               SERVER redis_server
              OPTIONS (database '0');

CREATE TABLE sample_postgres
           ( id VARCHAR(32)
           , tid INT NOT NULL
           );

INSERT INTO sample_postgres
          ( id
          , tid
          )
   VALUES ( 'a', 100)
        , ( 'b', 200)
        , ( 'c', 300)
        ;
