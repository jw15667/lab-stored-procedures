-- Write queries, stored procedures to answer the following questions:
use sakila;
-- In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
-- Convert the query into a simple stored procedure. Use the following query:

drop procedure if exists first_name_email_last;

delimiter //
create procedure first_name_email_last (out param1 float)
begin
  select first_name, last_name, email from customer 
	join rental
	using ( customer_id )
	join inventory
	using ( inventory_id)
	join film_category
	using (film_id)
	join category
	using (category_id)
	where name = 'Action'
	group by customer_id, first_name, last_name;
end;
//
delimiter ;

call first_name_email_last(@x);

-- Now keep working on the previous stored procedure to make it more dynamic. 
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that 
-- rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.
drop procedure if exists any_category;

delimiter //
create procedure any_category (in param1 varchar(10))
begin
  select first_name, last_name, email from customer 
	join rental
	using ( customer_id )
	join inventory
	using ( inventory_id)
	join film_category
	using (film_id)
	join category
	using (category_id)
    where name COLLATE utf8mb4_general_ci = param1
	group by first_name, last_name, customer_id;
end;
//
delimiter ;

call any_category("Action");
-- Write a query to check the number of movies released in each movie category. 

select count(distinct film_id) as total_films, name as category_name from film_category f
	join category
	using (category_id) 
    group by category_name;

-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.

drop procedure if exists min_num_category;

delimiter //
create procedure min_num_category (in param1 int)
begin
	select count(distinct film_id) as total_films, name as category_name from film_category f
	join category
	using (category_id) 
    group by category_name
	having count(distinct film_id) > param1;
end ;
//
delimiter ;

call min_num_category(65);


