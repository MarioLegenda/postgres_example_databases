This is a collection of databases from [this repository](https://github.com/neondatabase-labs/postgres-sample-dbs) already loaded and dockerized.

This project needs an `.env` file to work. If you want, you can just rename the `.env.example` to `.env` and
add the postgres database password there. 

To build, run:

`docker compose up --build`

Then, go into the container with:

`docker exec -it db sh`

When in container:

`psql -U postgres`

When in postgres:

`\l`

And it will list all of the loaded databases. 

This repo does not include the `postgres_air` database or the `wikipedia vector database` since they are too
big for Github. But, you can include it after cloning this project. 

For example, to include [postgres_air](https://github.com/hettie-d/postgres_air?tab=readme-ov-file) database,
add this line in docker-entrypoint-initdb.d/load_databases.sh:

> NOTE
>
> You need to download the database at the above link. Just scroll a little bit and you will see 'Download link'

> A BIG NOTE
> 
> Loading postgres_air database could take a long time. I have a pretty good laptop and it 
> took about 5 minutes to finish.

````
psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
CREATE DATABASE dvdrental;
CREATE DATABASE periodic_table;
CREATE DATABASE world_happiness;
CREATE DATABASE titanic;
CREATE DATABASE netflix;
CREATE DATABASE pagila;
CREATE DATABASE chinook;
CREATE DATABASE lego;
CREATE DATABASE postgres_air // this was added
EOSQL
````

and then add this line in the place where databases are loaded:

`psql -U postgres -f /app/postgres_air.sql`

The final product should look like this:

````
#!/bin/bash


psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
    CREATE DATABASE dvdrental;
    CREATE DATABASE periodic_table;
    CREATE DATABASE world_happiness;
    CREATE DATABASE titanic;
    CREATE DATABASE netflix;
    CREATE DATABASE pagila;
    CREATE DATABASE chinook;
    CREATE DATABASE lego;
    CREATE DATABASE postgres_air
EOSQL

pg_restore -U postgres -d dvdrental /app/dvdrental.tar
psql -U postgres -f /app/periodic_table.sql
psql -U postgres -f /app/happiness_index.sql
psql -U postgres -f /app/titanic.sql
psql -U postgres -f /app/netflix.sql
psql -U postgres -f /app/pagila.sql
psql -U postgres -f /app/lego.sql
psql -U postgres -f /app/postgres_air.sql // this waas added

psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
    CREATE DATABASE employees;
    \c employees
    CREATE SCHEMA employees;
EOSQL

pg_restore -U postgres -d employees -Fc employees.sql.gz -c -v --no-owner --no-privileges
````

This is also a way to add any other database. 