-- SECTION B - TASK 3
-- Multi-Table JOINs and Menu Summary View

USE foodapp_db;

DROP VIEW IF EXISTS restaurant_menu_summary;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS restaurants;

-- Restaurants table
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100)
);

-- Menu items table
CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50),

    CONSTRAINT fk_menu_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);

-- Insert 5 restaurants
INSERT INTO restaurants
(name, city)
VALUES
('Spice Garden', 'Surat'),
('Pizza Hub', 'Ahmedabad'),
('Tandoori Palace', 'Mumbai'),
('Green Bowl', 'Surat'),
('Royal Biryani', 'Ahmedabad');

-- Insert 12 menu items
-- Restaurant 5 intentionally has NO menu items

INSERT INTO menu_items
(restaurant_id, item_name, price, category)
VALUES
(1, 'Paneer Tikka', 250.00, 'Starter'),
(1, 'Butter Naan', 80.00, 'Bread'),
(1, 'Veg Biryani', 220.00, 'Main Course'),

(2, 'Margherita Pizza', 350.00, 'Pizza'),
(2, 'Farmhouse Pizza', 450.00, 'Pizza'),
(2, 'Garlic Bread', 180.00, 'Starter'),

(3, 'Chicken Tikka', 400.00, 'Starter'),
(3, 'Butter Chicken', 500.00, 'Main Course'),
(3, 'Tandoori Roti', 60.00, 'Bread'),

(4, 'Green Salad', 180.00, 'Salad'),
(4, 'Veg Wrap', 220.00, 'Main Course'),
(4, 'Fruit Bowl', 160.00, 'Dessert');

-- INNER JOIN

SELECT
    r.name AS restaurant_name,
    m.item_name,
    m.price
FROM restaurants r
INNER JOIN menu_items m
    ON r.restaurant_id = m.restaurant_id;

-- LEFT JOIN

SELECT
    r.name AS restaurant_name,
    m.item_name,
    m.price
FROM restaurants r
LEFT JOIN menu_items m
    ON r.restaurant_id = m.restaurant_id;

-- CREATE VIEW

CREATE VIEW restaurant_menu_summary AS
SELECT
    r.name AS restaurant_name,
    COUNT(m.item_id) AS total_menu_items,
    AVG(m.price) AS average_item_price
FROM restaurants r
LEFT JOIN menu_items m
    ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_id, r.name;

SELECT * FROM restaurant_menu_summary;