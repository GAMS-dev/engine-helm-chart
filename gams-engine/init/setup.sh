#!/bin/bash
cat /docker-entrypoint-initdb.d/users | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "gamsrest"
cat /docker-entrypoint-initdb.d/create_tables_and_set_permissions | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "gamsrest"
echo "CREATE DATABASE test_gamsrest;" | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "gamsrest"
cat /docker-entrypoint-initdb.d/create_tables_and_set_permissions | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "test_gamsrest"
