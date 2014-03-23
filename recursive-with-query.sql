INSERT INTO category (description)
VALUES
('web'),
('mobile'),
('sysadmin');

INSERT INTO category (parent_id, description)
SELECT *
FROM
(SELECT id FROM category WHERE description = 'web') tmp
CROSS JOIN
(SELECT unnest(ARRAY['front-end', 'back-end'])) positions;

INSERT INTO category (parent_id, description)
SELECT *
FROM
(SELECT id FROM category WHERE description = 'mobile') tmp
CROSS JOIN
(SELECT unnest(ARRAY['ios', 'android', 'windows'])) positions;

INSERT INTO category (parent_id, description)
SELECT *
FROM
(SELECT id FROM category WHERE description = 'sysadmin') tmp
CROSS JOIN
(SELECT unnest(ARRAY['linux', 'windows'])) positions;

INSERT INTO category (parent_id, description)
SELECT *
FROM
(SELECT id FROM category WHERE description = 'back-end') tmp
CROSS JOIN
(SELECT unnest(ARRAY['javascript', 'python', 'clojure', 'sql'])) positions;


WITH RECURSIVE subs(id, parent_id, ids, descriptions) AS (
    SELECT id, parent_id
         , ARRAY[id], ARRAY[description]
    FROM category
    UNION ALL
    SELECT s.id, c.parent_id
         , ARRAY_PREPEND(c.id, s.ids)
         , ARRAY_PREPEND(c.description, s.descriptions)
    FROM subs s, category c
    WHERE s.parent_id = c.id
)
SELECT id, ids, descriptions
FROM subs;
