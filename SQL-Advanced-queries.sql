use sakila;

#1. List each pair of actors that have worked together.
select fa1.film_id, a1.actor_id, a1.first_name, a1.last_name, a2.actor_id, a2.first_name, a2.last_name from actor a1
join film_actor fa1 on a1.actor_id = fa1.actor_id
join film_actor fa2
on fa1.actor_id <> fa2.actor_id
and fa1.film_id = fa2.film_id
join actor a2 on fa2.actor_id = a2.actor_id;


#2. For each film, list actor that has acted in more films.
select film_id, title, (select actor_id from (
	select *, count(film_id) over (partition by actor_id) as cnt
    from film_actor) as sub
where film_id = f1.film_id
order by cnt desc limit 1) as most
from film f1;

-- or

with cte_actor as (select *, count(film_id) over (partition by actor_id) as cnt
    from film_actor
)
select film_id, title, (
	select actor_id
    from cte_actor
	where film_id = f1.film_id
	order by cnt desc limit 1) as most
from film f1; 
	