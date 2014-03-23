CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    created TIMESTAMP DEFAULT NOW(),
    amount INTEGER,
    user_id INTEGER REFERENCES users(id)
);

INSERT INTO users (name)
VALUES
('Anh'), ('Nguyen');

INSERT INTO orders (user_id, amount) VALUES (1, 100);
INSERT INTO orders (user_id, amount) VALUES (1, 500);
INSERT INTO orders (user_id, amount) VALUES (2, 300);
INSERT INTO orders (user_id, amount) VALUES (1, 150);
INSERT INTO orders (user_id, amount) VALUES (2, 850);
INSERT INTO orders (user_id, amount) VALUES (2, 600);
INSERT INTO orders (user_id, amount) VALUES (1, 120);
INSERT INTO orders (user_id, amount) VALUES (1, 980);
INSERT INTO orders (user_id, amount) VALUES (1, 750);


-- First orders
SELECT DISTINCT u.id, u.name
     , FIRST_VALUE(o.id) OVER creation order_id
     , FIRST_VALUE(o.amount) OVER creation order_amount
FROM users u
JOIN orders o ON o.user_id = u.id
WINDOW creation AS (PARTITION BY user_id ORDER BY created);

-- Biggest orders
SELECT DISTINCT u.id, u.name
     , FIRST_VALUE(o.id) OVER creation order_id
     , FIRST_VALUE(o.amount) OVER creation order_amount
FROM users u
JOIN orders o ON o.user_id = u.id
WINDOW creation AS (PARTITION BY user_id ORDER BY amount DESC);

-- Orders' ordinal number
SELECT u.id, u.name, o.id order_id, o.amount
     , RANK() OVER creation user_order_number
FROM users u
JOIN orders o ON o.user_id = u.id
WINDOW creation AS (PARTITION BY user_id ORDER BY created);
