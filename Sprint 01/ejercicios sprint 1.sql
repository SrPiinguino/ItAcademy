Select * from transactions.transaction;
select distinct * from company;

##NIVEL 1 - EX02
SELECT company_name , email, country 
FROM company
order by company_name asc;

##NIVEL 1 - EX03 
select distinct country
from company
JOIN transaction on company.id = transaction.company_id;


#NIVEL 1 - Ex04
select  count( distinct country) as Cantidad_Paises_Compra
from company
JOIN transaction on company.id = transaction.company_id
;

#NIVEL 1 - EX05
select company_name, country
from transactions.company
where transactions.company.id = "b-2354"
;

#NIVEL 1 - Ex06
select company_name, 
avg(amount) as Media_Transacciones
from company
join transaction on company.id = transaction.company_id
group by company_name
order by Media_Transacciones desc limit 1;

#Nivel 2 
#Nivel 2 Ex01
select  id as empresas_duplicadas
from transactions.company
group by empresas_duplicadas
having count(id) > 1;
## Nota personal: haciendo este ejercicio, y viendo por encima los datos me he fijado que
# hay id de tarjetas
##Que se repiten con id de compañias diferentes, no sé si es posible 
#o es un error de las base de datos.

#Nivel 2 Ex02
Select date(timestamp) as fecha, 
sum(amount) as valor_total
from transaction
group by fecha
order by valor_total desc limit 5;

#Nivel 2 Ex03
Select date(timestamp) as fecha, 
sum(amount) as valor_total
from transaction
group by fecha
order by valor_total asc limit 5;


#Nivel 2 Ex04
Select country, 
avg(amount) as media_transacciones
from company
join transaction on company.id = transaction.company_id
group by country
order by media_transacciones desc;

#Nivel 3 
#Nivel 3 Ex01
select  company_name, phone, country, transaction.amount as Transacciones_total
from company
join transaction on company.id = transaction.company_id
where amount >= 100 and amount <= 200 ##Tambien podemos usar between
order by Transacciones_total desc;

#Nivel 3 Ex02 
Select distinct company_name 
from company
join transaction on company.id = transaction.company_id
where date(timestamp) in ("2022-03-16", "2022-02-13","2022-02-28")
;


