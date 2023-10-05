                                                           /*MUSIC STORE DATA ANALYSIS/*
use prac;
/* Q1: Who is the senior most employee based on job title? */
select concat(first_name,' ',last_name) as full_name,levels from employee order by levels desc limit 1;
/* Q2: Which countries have the most Invoices? */
select billing_country,count(billing_country) as count from invoice group by billing_country order by count desc ;
/* Q3: What are top 3 values of total invoice? */
select total as 'total value' from invoice order by total desc limit 3;
/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
select billing_city,sum(total) as invoice_total from invoice group by billing_city order by invoice_total desc limit 1;
/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
select c.customer_id,c.first_name,c.last_name,sum(total) as total from customer as c 
join invoice as i on c.customer_id=i.customer_id 
group by customer_id order by total desc limit 1;
/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
select distinct(email),first_name,last_name,g.name from customer as c join invoice as i on c.customer_id=i.customer_id 
join invoice_line as l on i.invoice_id=l.invoice_line_id 
join track as t on l.track_id=t.track_id 
join genre as g on t.genre_id=g.genre_id 
where email like 'a%' order by c.email ;
/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
select a.artist_id,a.name,count(a.artist_id) as number_of_songs from track as t 
join album as b on t.album_id=b.album_id 
join artist as a on b.artist_id=a.artist_id 
group by a.artist_id order by number_of_songs desc limit 10;
/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
select name, milliseconds from track where milliseconds>(select avg(milliseconds) from track) order by milliseconds desc;
/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */
select distinct(concat(c.first_name,' ',c.last_name)) as full_name,a.name,sum(l.unit_price*l.quantity) 
over(partition by first_name)as total_amount_spent from customer as c 
join invoice as i on c.customer_id=i.customer_id 
join invoice_line as l on i.invoice_id=l.invoice_line_id 
join track as t on l.track_id=t.track_id 
join album as b on t.album_id=b.album_id 
join artist as a on b.artist_id=a.artist_id order by total_amount_spent desc;
/* Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
select g.genre_id,c.country, count(l.quantity) over(partition by i.billing_country) as purchases from customer as c 
join invoice as i on c.customer_id=i.customer_id 
join invoice_line as l on i.invoice_id=l.invoice_line_id 
join track as t on l.track_id=t.track_id join genre as g on t.genre_id=g.genre_id order by purchases desc;
/* Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1




