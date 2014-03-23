-- Log in to postgres as its super user (postgres)
-- sudo -su postgres
-- psql

CREATE FOREIGN TABLE nginx_log_raw
(
    remote_addr TEXT,
    remote_user TEXT,
    time_local TIMESTAMP WITH TIME ZONE,
    request TEXT,
    status TEXT,
    body_bytes_sent TEXT,
    http_referer TEXT,
    http_user_agent TEXT
)
SERVER json_server
OPTIONS (filename '/home/ubolonton/Programming/projects/postgresql-examples/nginx-log/access.log.2.gz'
        -- This is only needed because my nginx json log config has
        -- bugs, so it's not actually valid json objects sometimes
        , max_error_count '99999');

CREATE VIEW nginx_log AS (
    SELECT remote_addr::INET
         , remote_user
         , time_local
         , request
         , status::INTEGER
         , body_bytes_sent::INTEGER
         , http_referer
         , http_user_agent
   FROM nginx_log_raw
);

GRANT ALL PRIVILEGES ON TABLE nginx_log to ubolonton;

----------------------------------------------------------------------
-- Log in to postgres as normal user


-- Request counts by status
SELECT status, COUNT(*)
FROM nginx_log
GROUP BY status
ORDER BY status;

-- Average response size
SELECT AVG(body_bytes_sent)
FROM nginx_log;

-- All requests not from me
SELECT COUNT(*)
FROM nginx_log
WHERE http_user_agent NOT LIKE '%conkeror%';

-- Requests by hour
WITH tmp AS (
    SELECT *, EXTRACT(HOUR FROM (time_local AT TIME ZONE '+07:00')) AS hour
    FROM nginx_log
)
SELECT hour, COUNT(*)
FROM tmp
GROUP BY hour
ORDER BY hour;
