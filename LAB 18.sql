/*1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?*/

select f.title, count(*) as available_copies
from inventory i
inner join film f 
on i.film_id = f.film_id
where f.title = 'Hunchback Impossible';

/*2. List all films whose length is longer than the average of all the films.*/

select film_id, title, length from film
where length > (select avg(length) from film);

/*3. Use subqueries to display all actors who appear in the film _Alone Trip_.*/ 

select a.film_id, f.title, a.actor_id, b.first_name, b.last_name from film_actor a 
inner join actor b 
on a.actor_id=b.actor_id
inner join film f 
on f.film_id=a.film_id
where f.film_id in 
(select film_id FROM film f where title='ALONE TRIP');  

/*4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.*/

select f.title, c.name from film f
inner join film_category fc
on f.film_id=fc.film_id
inner join category c
on c.category_id=fc.category_id
where c.category_id in
(select category_id from category c where name = 'Family');

/*5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.*/

select cu.first_name, cu.last_name, cu.email, c.country from customer cu
inner join address a
on  cu.address_id=a.address_id
inner join city ci
on a.city_id=ci.city_id
inner join country c
on c.country_id=ci.country_id
where c.country_id in
(select country_id from country c where country = 'Canada');

select cu.first_name, cu.last_name, cu.email, c.country from customer cu
inner join address a
on  cu.address_id=a.address_id
inner join city ci
on a.city_id=ci.city_id
inner join country c
on c.country_id=ci.country_id
where c.country = 'Canada';

/*6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number 
of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.*/

select f.title from film f
inner join film_actor fa
on fa.film_id=f.film_id
where fa.actor_id =
(select actor_id from film_actor fa
group by actor_id
order by count(*) desc
limit 1);

/*7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer 
ie the customer that has made the largest sum of payments*/

select f.title from film f
inner join inventory i
on i.film_id=f.film_id
inner join rental r
on r.inventory_id=i.inventory_id
inner join payment p
on p.customer_id=r.customer_id
where p.customer_id =
(select customer_id from payment p
group by customer_id
order by sum(amount) desc
limit 1);

/*8. Get the `client_id` and the `total_amount_spent` of those clients 
who spent more than the average of the `total_amount` spent by each client.*/

select customer_id, sum(amount) as total_amount_spent from payment
group by customer_id
having sum(amount) > (select avg(total_amount) from (select sum(amount) as total_amount from payment
group by customer_id) as sub1);