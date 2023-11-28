SHOW DATABASES;
CREATE DATABASE music_store;
USE music_store;
ALTER TABLE album2 RENAME TO album;
# DROP DATABASE music_stores;

---  SET-1 ---
--- SENIOR MOST EMPLOYEE ON JOB TITLE ---
SELECT * 
FROM employee 
ORDER BY levels DESC
LIMIT 1;

--- COUNTRIES HAVE THE MSOT INVOICES ---
SELECT billing_country, COUNT(*) 
FROM invoice
GROUP BY billing_country
ORDER BY COUNT(*) DESC;

--- TOP 3 VALUES OF TOTAL INVOICES ---
SELECT total 
FROM invoice
ORDER BY total DESC
LIMIT 3;

--- CITY WHICH HAS BEST CUSTOMER & HIGHEST SUM OF INVOICE TOTAL ---
SELECT billing_city, SUM(total) AS invoice_total 
FROM invoice
GROUP BY billing_city
ORDER BY  invoice_total DESC;

--- BEST CUSTOMER, WHO SPEND THE MOST MONEY ---- 
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS total_money 
FROM customer
LEFT JOIN invoice
ON customer.customer_id =  invoice.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total_money DESC
LIMIT 1;

--- SET 2 ---
--- RETURN EMAIL, FIRST_NAME, LAST_NAME OF ALL ROCK MUSIC LISTENER, RETURN YOUR LIST ORDERED ALPHABETICALLY A BY EMAIL ---
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

--- ARTIST WRITTEN THE MOST ROCK MUSIC & RETURN TOP 10 ARTIST NAME & TRACK COUNT OF TOP 10 ROCK BANDS ---
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

SELECT album.artist_id, COUNT(album.artist_id) AS song
FROM album
#LEFT JOIN album ON artist.artist_id = album.artist_id
LEFT JOIN track ON track.album_id = album.album_id
LEFT JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY album.artist_id
ORDER BY song DESC ;

--- METHOD 2 ---
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS no_of_songs
FROM track
LEFT JOIN album ON track.album_id = album.album_id
LEFT JOIN artist ON album.artist_id = artist.artist_id
LEFT JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY no_of_songs DESC ;

SELECT name, artist_id, COUNT(*) FROM artist GROUP BY name,artist_id  ORDER BY name;


---- RETURN ALL TRACK NAMES THAT HAVE SONG LENGTH LONGER THAN THE AVERAGE SONG LENGTH ALSO RETURN NAMR & MILLISECOND ----
SELECT name, milliseconds 
FROM track 
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;

SELECT AVG(milliseconds) FROM track;


---- SET 3 ----
--- HOW MUCH SPENT BY EACH CUSTOMER ON ARTIST, RETURN CUSTOMER NAME, ARTIST NAME, TOTAL SPENT ---
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, MAX(artist.name) AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

    
    





SELECT * FROM invoice;





