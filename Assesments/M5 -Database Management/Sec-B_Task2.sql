-- SECTION B - TASK 2
-- Aggregate Revenue Reporting on Orders

USE foodapp_db;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATETIME NOT NULL
);

-- Insert 12 orders
INSERT INTO orders
(restaurant_id, customer_name, total_amount, order_date)
VALUES
(1, 'Rahul', 1200.00, '2026-08-20 12:30:00'),
(1, 'Amit', 1800.00, '2026-08-21 13:00:00'),
(1, 'Neha', 2500.00, '2026-08-22 14:00:00'),

(2, 'Priya', 1500.00, '2026-08-23 12:45:00'),
(2, 'Karan', 2200.00, '2026-08-24 13:30:00'),
(2, 'Meera', 1800.00, '2026-08-25 14:00:00'),

(3, 'Arjun', 3000.00, '2026-08-26 19:00:00'),
(3, 'Riya', 2800.00, '2026-08-27 19:30:00'),
(3, 'Vivek', 1500.00, '2026-08-28 20:00:00'),

(4, 'Pooja', 900.00, '2026-08-29 12:00:00'),
(4, 'Jay', 1700.00, '2026-08-30 13:00:00'),
(4, 'Simran', 2100.00, '2026-08-31 14:00:00');

-- Total revenue and average order value
SELECT
    restaurant_id,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_order_value
FROM orders
GROUP BY restaurant_id;

-- HAVING Query

SELECT
    restaurant_id,
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY restaurant_id
HAVING SUM(total_amount) > 5000;

-- Five Most Recent Orders

SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 5;