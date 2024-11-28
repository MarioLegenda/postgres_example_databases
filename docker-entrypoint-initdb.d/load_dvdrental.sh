#!/bin/bash


psql -v ON_ERROR_STOP=1 --username postgres <<-EOSQL
    CREATE DATABASE dvdrental
EOSQL

pg_restore -U postgres -d dvdrental /app/dvdrental.tar