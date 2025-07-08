
/* Prepare database for REST API ingestion (sink)

Instructions: 
- Authenticate with development server/DB and run the following script
- Note: adjust table names in accordance with ".env" customization:
  - SQL_SCHEMA (default: dev)
  - BI_STAGING_TABLE (default: staging_usage)
  - BI_LOG_TABLE (default: etl_log)

Meta data:
  Author: vsm
  Date: 2025-06-30
  Team: GS - BI/ERP
*/

-- As admin: Create a dedicated metadata database for REST API ingestion
CREATE DATABASE spotify_metadata;

-- Create a user account for the sink system (e.g. ingestion pipeline)
CREATE USER spotify_user WITH PASSWORD '<USERPASSWORD>';

-- Grant basic connection privileges
GRANT CONNECT ON DATABASE spotify_metadata TO spotify_user;
