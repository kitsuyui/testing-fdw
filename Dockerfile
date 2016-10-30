FROM quay.io/aptible/postgresql:9.5-contrib
# by https://hub.docker.com/r/rungeict/postgres-redis/~/dockerfile/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get -y install git gcc make libhiredis-dev \
 && mkdir -p /inst/ \
 && cd /inst \
 && git clone https://github.com/pg-redis-fdw/redis_fdw.git --branch REL9_5_STABLE --single-branch \
 && cd /inst/redis_fdw \
 && PATH=/usr/local/postgresql/bin/:$PATH make USE_PGXS=1 \
 && PATH=/usr/local/postgresql/bin/:$PATH make USE_PGXS=1 install \
 && apt-get purge -y --auto-remove git gcc make \
 && rm -Rf /inst
