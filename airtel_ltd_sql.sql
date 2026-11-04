CREATE DATABASE airtel;
USE airtel;

CREATE TABLE subscribers (
    subscriber_id INT PRIMARY KEY AUTO_INCREMENT,
    subscriber_name VARCHAR(100),
    phone_number VARCHAR(15) UNIQUE,
    city VARCHAR(50),
    activation_date DATE
);

CREATE TABLE recharge_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    subscriber_id INT,
    plan_name VARCHAR(100),
    amount DECIMAL(8,2),
    validity_days INT,
    recharge_date DATE,
    FOREIGN KEY (subscriber_id) REFERENCES subscribers(subscriber_id)
);

INSERT INTO subscribers
(subscriber_name, phone_number, city, activation_date)
VALUES
('Manish Gupta', '9000000001', 'Bengaluru', '2022-01-10'),
('Ritika Saha', '9000000002', 'Kolkata', '2023-03-15'),
('Aarav Singh', '9000000003', 'Delhi', '2021-06-20'),
('Meera Nair', '9000000004', 'Chennai', '2024-02-05'),
('Rohan Verma', '9000000005', 'Hyderabad', '2020-09-12'),
('Ananya Rao', '9000000006', 'Pune', '2025-01-05');

INSERT INTO recharge_plans
(subscriber_id, plan_name, amount, validity_days, recharge_date)
VALUES
(1, 'Unlimited 28 Days', 299, 28, '2026-01-10'),
(2, 'Unlimited 84 Days', 799, 84, '2026-01-15'),
(3, 'Unlimited 28 Days', 299, 28, '2026-02-01'),
(4, 'Data Booster', 149, 14, '2026-02-05'),
(5, 'Unlimited 365 Days', 2999, 365, '2026-02-10'),
(6, 'Unlimited 28 Days', 299, 28, '2026-02-15'),
(1, 'Data Booster', 149, 14, '2026-03-01'),
(3, 'Unlimited 84 Days', 799, 84, '2026-03-05');

SELECT * FROM subscribers;

SELECT subscriber_name, city
FROM subscribers
WHERE city LIKE 'B%';

SELECT s.subscriber_name,
       COUNT(r.plan_id) AS recharge_count,
       SUM(r.amount) AS total_recharge
FROM subscribers s
LEFT JOIN recharge_plans r ON s.subscriber_id = r.subscriber_id
GROUP BY s.subscriber_id, s.subscriber_name;

SELECT plan_name,
       COUNT(*) AS subscribers,
       AVG(amount) AS average_amount
FROM recharge_plans
GROUP BY plan_name;

SELECT subscriber_name,
       activation_date,
       TIMESTAMPDIFF(YEAR, activation_date, CURDATE()) AS years_active
FROM subscribers;

SELECT plan_name,
       amount,
       amount / validity_days AS daily_cost
FROM recharge_plans;

SELECT subscriber_name
FROM subscribers
WHERE subscriber_id IN (
    SELECT subscriber_id
    FROM recharge_plans
    GROUP BY subscriber_id
    HAVING SUM(amount) > 500
);

SELECT subscriber_name,
       COALESCE(MAX(recharge_date), 'No Recharge') AS latest_recharge
FROM subscribers s
LEFT JOIN recharge_plans r ON s.subscriber_id = r.subscriber_id
GROUP BY s.subscriber_id, s.subscriber_name;

UPDATE recharge_plans
SET amount = 349
WHERE plan_id = 1;

CREATE VIEW subscriber_recharge_view AS
SELECT s.subscriber_name, s.phone_number, s.city,
       r.plan_name, r.amount, r.recharge_date
FROM subscribers s
JOIN recharge_plans r ON s.subscriber_id = r.subscriber_id;

SELECT * FROM subscriber_recharge_view;