-- SECTION B - TASK 1
-- Design and Populate a Restaurant Database

CREATE DATABASE IF NOT EXISTS foodapp_db;

USE foodapp_db;

-- Remove old table if it exists
DROP TABLE IF EXISTS restaurants;

-- Create restaurants table
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    cuisine_type VARCHAR(100),
    rating DECIMAL(3,1)
);

-- Insert 6 restaurants
INSERT INTO restaurants
(name, city, cuisine_type, rating)
VALUES
('Spice Garden', 'Surat', 'Indian', 4.5),
('Pizza Hub', 'Ahmedabad', 'Italian', 4.2),
('Tandoori Palace', 'Mumbai', 'North Indian', 4.7),
('Green Bowl', 'Surat', 'Healthy Food', 4.1),
('Royal Biryani', 'Ahmedabad', 'Biryani', 4.6),
('Ocean Grill', 'Mumbai', 'Seafood', 4.3);

-- Update one restaurant rating
UPDATE restaurants
SET rating = 4.8
WHERE restaurant_id = 3;

-- Delete one restaurant
DELETE FROM restaurants
WHERE restaurant_id = 6;

-- Display restaurants sorted by rating
SELECT *
FROM restaurants
ORDER BY rating DESC;