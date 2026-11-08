#!/bin/sh
set -e

# License server only needs the user and database.
# It does its own migrations, so no table is needed here.

if [ -z "${LICENSE_SERVER_ENABLED}" ]; then
    echo "License server not enabled"
else
    if [ -z "${CONNECTION_STRING}" ]; then
        cat << EOF | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
        CREATE USER ${LICENSE_SERVER_USERNAME} WITH ENCRYPTED PASSWORD '${LICENSE_SERVER_PASSWORD}';
        CREATE DATABASE ${LICENSE_SERVER_DATABASE} WITH OWNER ${LICENSE_SERVER_USERNAME};
EOF
    else
        cat << EOF | psql -v ON_ERROR_STOP=1 "${CONNECTION_STRING}"
        CREATE USER ${LICENSE_SERVER_USERNAME} WITH ENCRYPTED PASSWORD '${LICENSE_SERVER_PASSWORD}';
        CREATE DATABASE ${LICENSE_SERVER_DATABASE} WITH OWNER ${LICENSE_SERVER_USERNAME};
EOF
    fi
    echo "License user: ${LICENSE_SERVER_USERNAME} and database ${LICENSE_SERVER_DATABASE} created"
fi
