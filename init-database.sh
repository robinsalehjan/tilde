#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER tilde;
    CREATE DATABASE tilde_database;
    GRANT ALL PRIVILEGES ON DATABASE tilde_database TO tilde;
EOSQL