CREATE USER bsky_readonly;
ALTER USER bsky_readonly WITH ENCRYPTED PASSWORD 'bsky_readonly';
GRANT CONNECT ON DATABASE bluesky TO bsky_readonly;
GRANT USAGE ON SCHEMA public TO bsky_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO bsky_readonly;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
