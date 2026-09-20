#!/bin/sh
# Runs once on FIRST init (fresh pgdata): allow TCP replication from the
# streaming replica (profile `replica`) with the superuser password.
set -eu
grep -qs '^host[[:space:]]\+replication[[:space:]]\+all[[:space:]]\+all[[:space:]]' "$PGDATA/pg_hba.conf" \
  || echo 'host replication all all scram-sha-256' >> "$PGDATA/pg_hba.conf"
