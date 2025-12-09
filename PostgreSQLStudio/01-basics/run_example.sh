#!/bin/bash

# Script to run PostgreSQL basics example

# Check if we're in the right directory
if [ ! -f "example.sql" ]; then
  echo "Error: example.sql not found in current directory"
  exit 1
fi

# Check if psql is installed
if ! command -v psql &> /dev/null; then
  echo "Error: psql is not installed or not in PATH"
  exit 1
fi

# Get PostgreSQL connection details
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_USER=${DB_USER:-postgres}
DB_NAME=${DB_NAME:-postgres}

echo "Running PostgreSQL basics example..."
echo "Connecting to database: $DB_NAME at $DB_HOST:$DB_PORT as user $DB_USER"

# Execute the SQL file
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f example.sql

echo "Example completed."