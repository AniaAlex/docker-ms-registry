#!/usr/bin/env bash

# Start script for MS Registry using Django/uWSGI
set -e

echo "Starting MS Registry Service..."

# Essential environment variables
UWSGI_INI=${UWSGI_INI:-/etc/uwsgi/app.ini}
RUN_MIGRATIONS=${RUN_MIGRATIONS:-true}
COLLECT_STATIC=${COLLECT_STATIC:-true}

echo "Configuration:"
echo "  uWSGI Config: ${UWSGI_INI}"
echo "  Run Migrations: ${RUN_MIGRATIONS}"
echo "  Collect Static: ${COLLECT_STATIC}"
echo ""

# Wait for database to be ready
echo "Waiting for database to be ready..."
until python manage.py check --database default 2>/dev/null; do
    echo "Database not ready yet, waiting..."
    sleep 2
done
echo "Database is ready!"

# Run migrations if enabled
if [ "${RUN_MIGRATIONS}" = "true" ]; then
    echo "Running database migrations..."
    python manage.py migrate --noinput
fi

# Collect static files if enabled
if [ "${COLLECT_STATIC}" = "true" ]; then
    echo "Collecting static files..."
    python manage.py collectstatic --noinput
fi

echo "Starting uWSGI server..."
echo "---"

# Execute uWSGI
exec /usr/local/bin/uwsgi --ini "${UWSGI_INI}"
