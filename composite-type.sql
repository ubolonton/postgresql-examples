CREATE TYPE log_item AS (
    remote_addr TEXT,
    time_local TIMESTAMP,
    request TEXT,
    http_user_agent TEXT
);

CREATE TABLE server_log (
    id SERIAL PRIMARY KEY,
    item log_item
);

INSERT INTO server_log (item)
  SELECT ROW(item->>'remote_addr', (item->>'time_local')::timestamp, item->>'request', item->>'http_user_agent')::log_item
  FROM json_log;

SELECT (item).*
FROM server_log
WHERE (item).http_user_agent LIKE '%robot%';
