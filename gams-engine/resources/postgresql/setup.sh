#!/bin/sh
set -euo pipefail
run_psql() {
    if [ -z "${POSTGRES_CONNECTION_STRING}" ]; then
        psql -v ON_ERROR_STOP=1 "$@" --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
    else
        psql -v ON_ERROR_STOP=1 "$@" "${POSTGRES_CONNECTION_STRING}"
    fi
}
trap 'echo "Script failed! Keeping pod alive for debugging..."; tail -f /dev/null' ERR
# Count the number of user tables in the public schema
TABLE_COUNT=$(run_psql -tAc "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';")

if [ "$TABLE_COUNT" != "0" ]; then
    echo "Database already initialized ($TABLE_COUNT tables found). Skipping Postgres setup."
    exit 0
fi

echo "No tables found in public schema. Running initial Postgres setup."

cat << EOF | run_psql
    CREATE USER broker WITH ENCRYPTED PASSWORD '${GMS_RUNNER_DATABASE_BROKER_PWD}';
    CREATE USER worker WITH ENCRYPTED PASSWORD '${GMS_RUNNER_DATABASE_WORKER_PWD}';
    CREATE USER cleaner WITH ENCRYPTED PASSWORD '${GMS_RUNNER_DATABASE_CLEANER_PWD}';
    CREATE USER dep_check WITH ENCRYPTED PASSWORD '${GMS_RUNNER_DATABASE_DEPENDENCY_CHECK_PWD}';
    CREATE USER job_spawner WITH ENCRYPTED PASSWORD '${GMS_RUNNER_DATABASE_SPWN_PWD}';
    CREATE USER event_manager WITH ENCRYPTED PASSWORD '${GMS_RUNNER_DATABASE_EVENT_MANAGER_PWD}';
    CREATE USER k8s_job_canceler WITH ENCRYPTED PASSWORD '${GMS_RUNNER_DATABASE_K8S_CANCEL_PWD}';
    CREATE USER k8s_job_watcher WITH ENCRYPTED PASSWORD '${GMS_RUNNER_DATABASE_K8S_JOB_WATCHER_PWD}';

EOF

cat /docker-entrypoint-initdb.d/create_tables_and_set_permissions | run_psql
