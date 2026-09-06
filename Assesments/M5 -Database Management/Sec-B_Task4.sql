-- SECTION B - TASK 4
-- PL/SQL Order Placement Procedure

USE foodapp_db;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    wallet_balance DECIMAL(10,2) NOT NULL DEFAULT 0.00
);

INSERT INTO customers
(customer_name, wallet_balance)
VALUES
('Rahul Sharma', 10000.00),
('Priya Patel', 5000.00),
('Amit Shah', 2000.00);

SELECT * FROM customers;

-- adding customer_id to orders

ALTER TABLE orders
ADD COLUMN customer_id INT;

-- PROCEDURE

DELIMITER $$

CREATE PROCEDURE place_order(
    IN p_customer_id INT,
    IN p_restaurant_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN

    DECLARE v_wallet_balance DECIMAL(10,2);

    -- Start transaction
    START TRANSACTION;

    -- Get customer's wallet balance
    SELECT wallet_balance
    INTO v_wallet_balance
    FROM customers
    WHERE customer_id = p_customer_id
    FOR UPDATE;

    -- Check customer
    IF v_wallet_balance IS NULL THEN

        ROLLBACK;

        SELECT 'Customer does not exist. Transaction rolled back.' AS message;

    -- Check sufficient balance
    ELSEIF v_wallet_balance < p_amount THEN

        ROLLBACK;

        SELECT 'Insufficient wallet balance. Transaction rolled back.' AS message;

    ELSE

        -- Deduct wallet amount
        UPDATE customers
        SET wallet_balance = wallet_balance - p_amount
        WHERE customer_id = p_customer_id;

        -- Insert order
        INSERT INTO orders
        (restaurant_id, customer_id, customer_name, total_amount, order_date)
        SELECT
            p_restaurant_id,
            customer_id,
            customer_name,
            p_amount,
            NOW()
        FROM customers
        WHERE customer_id = p_customer_id;

        -- Save transaction
        COMMIT;

        SELECT 'Order placed successfully.' AS message;

    END IF;

END$$

DELIMITER ;

-- Deduct the amount from the customer's wallet_balance in a customers table and insert a new record into the orders table.

CALL place_order(1, 1, 2000.00);

--  Checking Wallet

SELECT * FROM customers
WHERE customer_id = 1;

-- Checking order

SELECT * FROM orders ORDER BY order_id DESC LIMIT 1;

-- Testing Insufficent balance

CALL place_order(3, 1, 5000.00);

-- Checking Wallet

SELECT * FROM customers
WHERE customer_id = 3;

COMMIT;