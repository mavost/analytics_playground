
/* Prepare database for REST API ingestion (sink)

Instructions: 
- Authenticate with development server/DB and run the following script
- Note: adjust table names in accordance with ".env" customization:
  - SQL_SCHEMA (default: dev)
  - BI_STAGING_TABLE (default: staging_usage)
  - BI_LOG_TABLE (default: etl_log)

Meta data:
- Author: vsm
- Date: 2025-06-30
- Team: GS - BI/ERP
*/

-- Switch to the spotify_metadata database before running the next statements
-- \c spotify_metadata

-- Optionally, create the dev schema if not already existing
CREATE SCHEMA IF NOT EXISTS dev;

-- Grant access to the 'dev' schema
GRANT USAGE ON SCHEMA dev TO spotify_user;
GRANT CREATE ON SCHEMA dev TO spotify_user;

-- Grant standard DML rights (Data Manipulation Language) on existing tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA dev TO spotify_user;

-- Ensure future tables created in the schema automatically grant access to spotify_user
ALTER DEFAULT PRIVILEGES IN SCHEMA dev
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO spotify_user;

-- Drop the 'staging_playback_data' table if it exists
DROP TABLE IF EXISTS dev.staging_playback_data;

-- Create the 'staging_playback_data' table
CREATE TABLE dev.staging_playback_data (
    event_time TIMESTAMPTZ,     -- PostgreSQL equivalent of DATETIME
    data_json TEXT,             -- TEXT is appropriate for JSON in raw form
    hash CHAR(64)               -- SHA-256 style hash
);

-- Create a unique index on the 'hash' column
CREATE UNIQUE INDEX idx_hash_unique ON dev.staging_playback_data (hash);

-- Drop the 'etl_log' table if it exists
DROP TABLE IF EXISTS dev.etl_log;

-- Create the 'etl_log' table
CREATE TABLE dev.etl_log (
    run_time TIMESTAMP,         -- Same as DATETIME in SQL Server
    service_name VARCHAR(30),
    success BOOLEAN,            -- BOOLEAN instead of BIT
    inserted_rows INTEGER,
    max_event_time TIMESTAMP
);
