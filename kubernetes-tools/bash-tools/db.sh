#!/bin/bash

# MySQL database credentials
DB_USER="username"
DB_PASS="password"
DB_NAME="database_name"

# Dump file names
FULL_DUMP_FILE="full_dump.sql.gz"
MINIMIZED_DUMP_FILE="minimized_dump.sql.gz"
COMBINED_DUMP_FILE="combined_dump.sql.gz"

# Generate full dump of the database and compress it
mysqldump --user="$DB_USER" --password="$DB_PASS" --databases "$DB_NAME" --single-transaction --quick | gzip > "$FULL_DUMP_FILE"

# Generate minimized dump of the database, excluding data from tables with the "log_" prefix, and compress it
mysqldump --user="$DB_USER" --password="$DB_PASS" --databases "$DB_NAME" --single-transaction --quick --ignore-table="$DB_NAME.log_*" | gzip > "$MINIMIZED_DUMP_FILE"

# Combine the two dumps into a single file
cat "$FULL_DUMP_FILE" "$MINIMIZED_DUMP_FILE" > "$COMBINED_DUMP_FILE"

# Clean up temporary files
rm "$FULL_DUMP_FILE" "$MINIMIZED_DUMP_FILE"
