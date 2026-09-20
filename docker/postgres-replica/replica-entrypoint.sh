#!/bin/sh
# Streaming-replica bootstrap (Phase 4, profile `replica`).
# First start: pg_basebackup from primary with standby.signal (-R), then run
# stock entrypoint which detects the seeded PGDATA and just starts postgres.
# Restarts: PG_VERSION exists -> skip bootstrap, start immediately.
set -eu

: "${PRIMARY_HOST:?PRIMARY_HOST required}"
: "${POSTGRES_USER:?POSTGRES_USER required}"
: "${POSTGRES_PASSWORD:?POSTGRES_PASSWORD required}"
: "${PGDATA:?PGDATA required}"

if [ ! -s "$PGDATA/PG_VERSION" ]; then
  echo "[replica] waiting for primary $PRIMARY_HOST ..."
  until pg_isready -h "$PRIMARY_HOST" -U "$POSTGRES_USER" -d mydatabase -t 5; do
    sleep 2
  done
  echo "[replica] running pg_basebackup ..."
  rm -rf "${PGDATA:?}/"*
  PGPASSWORD="$POSTGRES_PASSWORD" pg_basebackup \
    -h "$PRIMARY_HOST" -p 5432 -U "$POSTGRES_USER" \
    -D "$PGDATA" -Fp -Xs -P -R
  # -R writes primary_conninfo without a password; append it so the standby
  # can authenticate with scram-sha-256.
  if grep -q "^primary_conninfo" "$PGDATA/postgresql.auto.conf" 2>/dev/null; then
    sed -i "s/^primary_conninfo = '/primary_conninfo = 'password=${POSTGRES_PASSWORD} /" \
      "$PGDATA/postgresql.auto.conf"
  else
    printf "primary_conninfo = 'host=%s port=5432 user=%s password=%s application_name=replica1'\n" \
      "$PRIMARY_HOST" "$POSTGRES_USER" "$POSTGRES_PASSWORD" >> "$PGDATA/postgresql.auto.conf"
  fi
  chown -R postgres:postgres "$PGDATA"
  chmod 700 "$PGDATA"
  echo "[replica] bootstrap done"
fi

exec /usr/local/bin/docker-entrypoint.sh postgres \
  -c hot_standby=on \
  -c hot_standby_feedback=on
