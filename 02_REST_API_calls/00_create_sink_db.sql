
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

-- Create a new schema called 'dev' (for development or staging purposes)
CREATE SCHEMA dev;

-- Alternatively, create another schema named 'NewSchemaName' and assign ownership to a specific user
--CREATE SCHEMA dev AUTHORIZATION UserName;

-- Drop the table 'staging_usage' in 'dev' schema if it already exists
-- This ensures we start with a clean table definition
DROP TABLE IF EXISTS dev.staging_usage;

-- Create the 'staging_usage' table to temporarily hold Power BI usage data
CREATE TABLE dev.staging_usage (
    event_time DATETIME,         -- Timestamp of the Power BI event
    data_json NVARCHAR(MAX),     -- Raw event data stored in JSON format
    hash CHAR(64)                -- Unique hash to detect duplicates
);

-- Create a unique non-clustered index on the 'hash' column
-- Ensures no duplicate event rows are inserted based on the hash value
CREATE UNIQUE NONCLUSTERED INDEX idx_hash_unique ON dev.staging_usage (hash);

DROP TABLE IF EXISTS dev.etl_log;

-- Create a table to log ETL run details (for tracking and auditing)
CREATE TABLE dev.etl_log (
    run_time DATETIME,           -- Timestamp when the ETL job ran
    success BIT,                 -- 1 = Success, 0 = Failure
    inserted_rows INT,           -- Number of new rows inserted during the run
    max_event_time DATETIME      -- Latest timestamp found in inserted data or max data in case nothing was added
);
