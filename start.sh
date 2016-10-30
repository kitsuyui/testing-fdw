#!/usr/bin/env bash
pguser='kitsuyui'
pgdb='db'
pgpass='postgrespassword'


psql(){
  docker run -it --rm -e PGPASSWORD="$pgpass" --link postgres_fdw_test postgres psql -h postgres_fdw_test -U "$pguser" -d "$pgdb" "$*"
}

psql_notty(){
  docker run -i --rm -e PGPASSWORD="$pgpass" --link postgres_fdw_test postgres psql -h postgres_fdw_test -U "$pguser" -d "$pgdb" "$*"
}

mysql() {
  docker run -it --link mysql_fdw_test:mysql --rm mysql \
  sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
}

mysql_notty() {
  docker run -i --link mysql_fdw_test:mysql --rm mysql \
  sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
}

redis() {
  docker run -it --link redis_fdw_test:redis --rm redis redis-cli -h redis -p 6379 "$*"
}

redis_notty() {
  docker run -t --link redis_fdw_test:redis --rm redis redis-cli -h redis -p 6379 $*
}

docker build -t fdwpostgres .
docker create --name fdw_data fdwpostgres
docker run --volumes-from fdw_data -e USERNAME="$pguser" -e PASSPHRASE="$pgpass" -e DATABASE="$pgdb" fdwpostgres --initialize
docker-compose up -d
mysql_notty < mysql.sql
redis_notty 'SET' 'a' '1'
redis_notty 'SET' 'b' '2'
redis_notty 'SET' 'c' '3'
psql_notty < fdwpostgres.sql
psql <<EOT
    SELECT *
      FROM sample_redis AS SR
INNER JOIN sample_mysql AS SM
        ON SR.val::int = SM.id
INNER JOIN sample_postgres AS SP
        ON SR.key = SP.id
EOT
