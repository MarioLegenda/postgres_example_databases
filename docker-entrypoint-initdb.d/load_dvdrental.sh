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
EOSQL

pg_restore -U postgres -d dvdrental /app/dvdrental.tar
psql -U postgres -f /app/periodic_table.sql
psql -U postgres -f /app/happiness_index.sql
psql -U postgres -f /app/titanic.sql
psql -U postgres -f /app/netflix.sql
psql -U postgres -f /app/pagila.sql
psql -U postgres -f /app/lego.sql

psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
    CREATE DATABASE employees;
    \c employees
    CREATE SCHEMA employees;
EOSQL

pg_restore -U postgres -d employees -Fc employees.sql.gz -c -v --no-owner --no-privileges