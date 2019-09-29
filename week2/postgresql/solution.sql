SELECT customer.first_name, COUNT(*) AS total_rentals
FROM customer LEFT JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.first_name
ORDER BY COUNT(*) DESC;

/* MARION has rented most times: 68 */

SELECT customer.first_name, SUM(payment.amount) AS total_spent
FROM customer LEFT JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name
ORDER BY SUM(payment.amount) DESC;

/* MARION has spent most in total: 310.32 */

SELECT customer.first_name, ROUND(AVG(payment.amount), 1) AS average_spent
FROM customer LEFT JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name
ORDER BY average_spent DESC;

/* BRITTANY has spent most in average: 5.7 */

/* MARION has spent more in total while coming more times, but spending less each
   time than BRITTANY who probably rent more in value or quantity each time */

/*
SELECT film.title, COUNT(rental.rental_id) AS total_rents
FROM film LEFT JOIN inventory ON film.film_id = inventory.film_id
	LEFT JOIN rental ON rental.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY total_rents DESC
LIMIT 5;

SELECT film.title, COUNT(rental.rental_id) AS total_rents
FROM rental RIGHT JOIN inventory ON inventory.inventory_id = rental.inventory_id
	RIGHT JOIN film ON film.film_id = inventory.inventory_id
GROUP BY film.title
ORDER BY total_rents DESC
LIMIT 5;
*/

SELECT film.title, COUNT(rental.rental_id) AS total_rents
FROM rental RIGHT JOIN inventory ON rental.inventory_id = inventory.inventory_id
	RIGHT JOIN film ON inventory.film_id = film.film_id
GROUP BY film.title
ORDER BY total_rents DESC
LIMIT 5;

/* The most rented film is BUCKET BROTHERHOOD: 34 */

SELECT category.name, COUNT(rental.rental_id) AS total_rents
FROM rental RIGHT JOIN inventory ON rental.inventory_id = inventory.inventory_id
	RIGHT JOIN film ON inventory.film_id = film.film_id
	RIGHT JOIN film_category ON film.film_id = film_category.film_id
	RIGHT JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY total_rents DESC;

/* The most rented category is SPORTS */

SELECT customer.first_name, COUNT(*), category.name
FROM customer LEFT JOIN rental ON customer.customer_id = rental.customer_id
	RIGHT JOIN inventory ON rental.inventory_id = inventory.inventory_id
	RIGHT JOIN film ON inventory.film_id = film.film_id
	RIGHT JOIN film_category ON film.film_id = film_category.film_id
	RIGHT JOIN category ON film_category.category_id = category.category_id
GROUP BY customer.first_name, category.name
ORDER BY COUNT(category.name) DESC;

/* I can see who rented the most of a single category but I can't order by
   how much films each one rented */