Select * from transactions.transaction;
select distinct * from company;

##EX02
SELECT transactions.company.company_name, transactions.company.email, transactions.company.country
FROM company
order by company_name asc;

##EX03 
select distinct transactions.company.country
from company
JOIN transactions.transaction on transactions.company.id = transactions.transaction.company_id;


#Ex04
select  count( distinct transactions.company.country) as Cantidad_Paises_Compra
from company
JOIN transactions.transaction on transactions.company.id = transactions.transaction.company_id
;

#EX05
select transactions.company.company_name, transactions.company.country
from transactions.company
where transactions.company.id = "b-2354"
;

#Ex06
select transactions.company.company_name, 
avg(transactions.transaction.amount) as Media_Transacciones
from transactions.company
join transactions.transaction on transactions.company.id = transactions.transaction.company_id
group by transactions.company.company_name
order by Media_Transacciones desc limit 1;

#Nivel 2
#Ex01
select  transactions.company.id as empresas_duplicadas
from transactions.company
group by empresas_duplicadas
having count(transactions.company.id) > 1;
## Nota personal: haciendo este ejercicio, y viendo por encima los datos me he fijado que
# hay id de tarjetas
##Que se repiten con id de compañias diferentes, no sé si es posible 
#o es un error de las base de datos.

#Ex02
Select date(transactions.transaction.timestamp) as fecha, 
sum(transactions.transaction.amount) as valor_total
from transactions.transaction
group by fecha
order by valor_total desc limit 5;

#Ex03
Select date(transactions.transaction.timestamp) as fecha, 
sum(transactions.transaction.amount) as valor_total
from transactions.transaction
group by fecha
order by valor_total asc limit 5;


#Ex04
Select transactions.company.country, 
avg(transactions.transaction.amount) as media_transacciones
from transactions.company
join transactions.transaction on transactions.company.id = transactions.transaction.company_id
group by transactions.company.country
order by media_transacciones desc;

#Nivel 3
#Ex01
select  transactions.company.company_name, transactions.company.phone, 
		transactions.company.country, sum(transactions.transaction.amount) as Transacciones_total
from transactions.company
join transactions.transaction on transactions.company.id = transactions.transaction.company_id
where transactions.transaction.amount >= 100 and transactions.transaction.amount <= 200
group by transactions.company.company_name, transactions.company.phone,transactions.company.country
order by Transacciones_total desc;

#Ex02 
Select distinct transactions.company.company_name 
from transactions.company
join transactions.transaction on transactions.company.id = transactions.transaction.company_id
where date(transactions.transaction.timestamp) in ("2022-03-16", "2022-02-13","2022-02-28")
;


