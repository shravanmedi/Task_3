use sakila;
-- List all customers from 'London'
SELECT c.first_name, c.last_name, a.address, ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
WHERE ci.city = 'London';

-- Top 10 most rented films
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;

-- INNER JOIN: Rentals with customer names and film titles
SELECT r.rental_id, c.first_name, c.last_name, f.title, r.rental_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
LIMIT 20;

-- LEFT JOIN: All customers and their rentals (if any)
SELECT c.customer_id, c.first_name, r.rental_id
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id;

-- Customers who rented more films than the average
SELECT c.first_name, c.last_name
FROM customer c
WHERE (
    SELECT COUNT(*) FROM rental r WHERE r.customer_id = c.customer_id
) > (
    SELECT AVG(rentals_per_customer)
    FROM (
        SELECT COUNT(*) AS rentals_per_customer
        FROM rental
        GROUP BY customer_id
    ) sub
);

-- Total number of rentals
SELECT COUNT(*) AS total_rentals FROM rental;

-- Average film length
SELECT f.title, AVG(f.length) AS avg_duration
FROM film f
GROUP BY f.title;


-- View: Top 5 most rented films
CREATE VIEW top_rented_films AS
SELECT f.title, COUNT(r.rental_id) AS total_rentals
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY total_rentals DESC
LIMIT 5;

-- Create index on rental date for faster filtering
CREATE INDEX idx_rental_date ON rental(rental_date);




