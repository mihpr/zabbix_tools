#!/bin/bash

DB_NAME="deprecated"

tables=(
  "history_old"
  "history_uint_old"
  "history_str_old"
  "history_log_old"
  "history_text_old"
  "trends_old"
)

for table in "${tables[@]}"; do
  echo "Dropping table $table..."
  echo "DROP TABLE $table;" | sudo -u postgres psql $DB_NAME
done

echo "All specified tables have been dropped."
