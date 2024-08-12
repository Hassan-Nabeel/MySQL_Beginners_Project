SHOW DATABASES;
CREATE DATABASE music_store;
USE music_store;
ALTER TABLE album2 RENAME TO album;
# DROP DATABASE music_stores;

---  SET-1 ---
--- 1. SENIOR MOST EMPLOYEE ON JOB TITLE ---
SELECT * 
FROM employee 
ORDER BY levels DESC
LIMIT 1;

--- 2. COUNTRIES HAVE THE MSOT INVOICES ---
SELECT billing_country, COUNT(*) 
FROM invoice
GROUP BY billing_country
ORDER BY COUNT(*) DESC;

--- 3. TOP 3 VALUES OF TOTAL INVOICES ---
SELECT total 
FROM invoice
ORDER BY total DESC
LIMIT 3;

--- 4. CITY WHICH HAS BEST CUSTOMER & HIGHEST SUM OF INVOICE TOTAL ---
SELECT billing_city, ROUND(SUM(total), 2) AS invoice_total 
FROM invoice
GROUP BY billing_city
ORDER BY  invoice_total DESC;

--- 5. BEST CUSTOMER, WHO SPEND THE MOST MONEY ---- 
SELECT customer.customer_id, customer.first_name, customer.last_name, ROUND(SUM(invoice.total), 2) AS total_money 
FROM customer
LEFT JOIN invoice
ON customer.customer_id =  invoice.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total_money DESC
LIMIT 1;



--- SET 2 ---
--- 1. RETURN EMAIL, FIRST_NAME, LAST_NAME OF ALL ROCK MUSIC LISTENER, RETURN YOUR LIST ORDERED ALPHABETICALLY A BY EMAIL ---
SELECT DISTINCT email, first_name, last_name
FROM customer 
LEFT JOIN invoice ON customer.customer_id = invoice.customer_id
LEFT JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
		SELECT track_id 
		FROM track
		LEFT JOIN genre ON track.genre_id = genre.genre_id
		WHERE genre.name LIKE 'Rock'
        )
ORDER BY email;


--- 2. ARTIST WRITTEN THE MOST ROCK MUSIC & RETURN TOP 10 ARTIST NAME & TRACK COUNT OF TOP 10 ROCK BANDS ---
--- METHOD 1 ---
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS no_of_songs
FROM artist
LEFT JOIN album ON artist.artist_id = album.artist_id
LEFT JOIN track ON album.album_id = track.album_id
LEFT JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY no_of_songs DESC
LIMIT 10;


--- 3. RETURN ALL TRACK NAMES THAT HAVE SONG LENGTH LONGER THAN THE AVERAGE SONG LENGTH ALSO RETURN NAME & MILLISECOND ----
SELECT name, milliseconds 
FROM track 
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;

SELECT AVG(milliseconds) FROM track;



---- SET 3 ----
--- 1. HOW MUCH SPENT BY EACH CUSTOMER ON ARTIST, RETURN CUSTOMER NAME, ARTIST NAME, TOTAL SPENT ---
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, (artist.name) AS artist_name, ROUND(SUM(invoice_line.unit_price*invoice_line.quantity), 2) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1,2
	ORDER BY 3 DESC
	-- LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, ROUND(SUM(il.unit_price*il.quantity), 2) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;


---- 2. Find out the most popular music Genre for each country. Determine the most popular genre as the genre with the highest amount of purchases.
--- Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres ---
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1;






