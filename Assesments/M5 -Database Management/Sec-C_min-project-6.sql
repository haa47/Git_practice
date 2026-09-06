-- Creating database

CREATE DATABASE assessment_sec_c_db;

-- Creating Tables

CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL,

    CONSTRAINT fk_menu_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    restaurant_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),

    CONSTRAINT fk_order_item
        FOREIGN KEY (item_id)
        REFERENCES menu_items(item_id)
);

CREATE TABLE order_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    action VARCHAR(20) NOT NULL,
    log_time DATETIME NOT NULL
);

-- Insertion data in tables

INSERT INTO restaurants
(name, city, cuisine_type)
VALUES
('Spice Garden', 'Surat', 'Indian'),
('Pizza Hub', 'Ahmedabad', 'Italian'),
('Tandoori Palace', 'Mumbai', 'North Indian'),
('Green Bowl', 'Surat', 'Healthy Food');

INSERT INTO menu_items
(restaurant_id, item_name, price, category)
VALUES

-- Spice Garden
(1, 'Paneer Tikka', 250.00, 'Starter'),
(1, 'Veg Biryani', 220.00, 'Main Course'),
(1, 'Butter Naan', 80.00, 'Bread'),
(1, 'Gulab Jamun', 100.00, 'Dessert'),

-- Pizza Hub
(2, 'Margherita Pizza', 350.00, 'Pizza'),
(2, 'Farmhouse Pizza', 450.00, 'Pizza'),
(2, 'Garlic Bread', 180.00, 'Starter'),
(2, 'Chocolate Cake', 200.00, 'Dessert'),

-- Tandoori Palace
(3, 'Chicken Tikka', 400.00, 'Starter'),
(3, 'Butter Chicken', 500.00, 'Main Course'),
(3, 'Tandoori Roti', 60.00, 'Bread'),
(3, 'Chicken Biryani', 450.00, 'Main Course'),

-- Green Bowl
(4, 'Green Salad', 180.00, 'Salad'),
(4, 'Veg Wrap', 220.00, 'Main Course'),
(4, 'Fruit Bowl', 160.00, 'Dessert');

INSERT INTO orders
(customer_name, restaurant_id, item_id, quantity, total_amount, order_date)
VALUES

('Rahul', 1, 1, 2, 500.00, '2026-08-01 12:00:00'),
('Priya', 1, 2, 1, 220.00, '2026-08-02 13:00:00'),
('Amit', 1, 3, 4, 320.00, '2026-08-03 14:00:00'),
('Neha', 1, 4, 2, 200.00, '2026-08-04 15:00:00'),

('Karan', 2, 5, 1, 350.00, '2026-08-05 18:00:00'),
('Meera', 2, 6, 2, 900.00, '2026-08-06 19:00:00'),
('Riya', 2, 7, 2, 360.00, '2026-08-07 19:30:00'),
('Vivek', 2, 8, 1, 200.00, '2026-08-08 20:00:00'),

('Arjun', 3, 9, 2, 800.00, '2026-08-09 20:30:00'),
('Pooja', 3, 10, 1, 500.00, '2026-08-10 21:00:00'),
('Jay', 3, 11, 5, 300.00, '2026-08-11 21:30:00'),
('Simran', 3, 12, 1, 450.00, '2026-08-12 22:00:00'),

('Dev', 4, 13, 2, 360.00, '2026-08-13 12:30:00'),
('Anjali', 4, 14, 2, 440.00, '2026-08-14 13:30:00'),
('Nikhil', 4, 15, 3, 480.00, '2026-08-15 14:30:00');

-- Creating View

CREATE VIEW restaurant_sales_summary AS
SELECT
    r.name AS restaurant_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue
FROM restaurants r
LEFT JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name;

SELECT *
FROM restaurant_sales_summary;

-- Stored Procedure — add_order

DELIMITER $$

CREATE PROCEDURE add_order(
    IN p_customer_name VARCHAR(100),
    IN p_restaurant_id INT,
    IN p_item_id INT,
    IN p_quantity INT
)
BEGIN

    DECLARE v_restaurant_count INT DEFAULT 0;
    DECLARE v_item_count INT DEFAULT 0;
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);

    START TRANSACTION;

    -- Validate restaurant
    SELECT COUNT(*)
    INTO v_restaurant_count
    FROM restaurants
    WHERE restaurant_id = p_restaurant_id;

    IF v_restaurant_count = 0 THEN

        ROLLBACK;

        SELECT 'Restaurant does not exist. Order cancelled.' AS message;

    ELSE

        -- Validate menu item
        SELECT COUNT(*)
        INTO v_item_count
        FROM menu_items
        WHERE item_id = p_item_id
          AND restaurant_id = p_restaurant_id;

        IF v_item_count = 0 THEN

            ROLLBACK;

            SELECT 'Menu item does not belong to this restaurant. Order cancelled.' AS message;

        ELSEIF p_quantity <= 0 THEN

            ROLLBACK;

            SELECT 'Quantity must be greater than zero. Order cancelled.' AS message;

        ELSE

            -- Get item price
            SELECT price
            INTO v_price
            FROM menu_items
            WHERE item_id = p_item_id
              AND restaurant_id = p_restaurant_id;

            -- Calculate total
            SET v_total = v_price * p_quantity;

            -- Insert order
            INSERT INTO orders
            (
                customer_name,
                restaurant_id,
                item_id,
                quantity,
                total_amount,
                order_date
            )
            VALUES
            (
                p_customer_name,
                p_restaurant_id,
                p_item_id,
                p_quantity,
                v_total,
                NOW()
            );

            COMMIT;

            SELECT
                'Order added successfully.' AS message,
                v_total AS total_amount;

        END IF;

    END IF;

END$$

DELIMITER ;

-- Test — add_order

-- Valid order

CALL add_order('Haaris', 1, 1, 2);

-- Invalid restaurant

CALL add_order('Haaris', 999, 1, 2);

-- Invalid menu item/restaurant combination

CALL add_order('Haaris', 1, 5, 2);

-- Triggger — after_order_insert

DELIMITER $$

CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN

    INSERT INTO order_audit
    (
        order_id,
        restaurant_id,
        action,
        log_time
    )
    VALUES
    (
        NEW.order_id,
        NEW.restaurant_id,
        'INSERT',
        NOW()
    );

END$$

DELIMITER ;

-- Testing Trigger

-- adding order

CALL add_order('Test Customer', 2, 5, 2);

-- Checking

SELECT * FROM order_audit
ORDER BY audit_id DESC;