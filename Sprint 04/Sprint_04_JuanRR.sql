
#Nivel 1 Ex 01
select * from user
where id in (select user_id from transactions
group by user_id
having count(transactions.id) >= 30
);

#Ex02
#Ex 02
#Esta query trata los iban en conjunto, es decir no divide entre mismos iban, el monto de las transacciones se suma
#pero no se trata un mismo iban como una entidad diferente
select avg(suma_iban)
from (select sum(amount) as suma_iban
from transactions
join credit_cards on transactions.card_id= credit_cards.id
join companies on transactions.business_id=companies.comapny_id
where companies.company_name= 'Donec Ltd'
group by iban) as suma_por_iban;

#En este caso se suma las transacciones y se divide por el numero de iban aunque sean el mismo:
select  avg(transactions.amount) as media_trans_iban_DonecLtd
from transactions
join credit_cards on transactions.card_id = credit_cards.id
join companies on transactions.business_id = companies.comapny_id
where companies.company_name= 'Donec Ltd'
group by iban;

select card_id, timestamp,declined from transactions
order by card_id, timestamp desc
;

#Creacion Tabla Tarjetas Activadas:
#CREACION TABLA NIVEL 2
#en este caso usamos un case y una subquery que esta seleciona los ultimos tres declined usando timestamp como orderby
#una vez hecho esto indicamos en el case que si el valor del declined en las ultimas 3 transacciones
#es inferior a 3 contara como activada (1) y si es 3( que indica que los 3 ultimos declined son 1) contara 
#como 0(desactivada)


create table tarjetas_activadas as
SELECT t.card_id,
       CASE 
           WHEN (SELECT COUNT(*) 
                 FROM (SELECT declined 
                       FROM transactions t2 
                       WHERE t2.card_id = t.card_id 
                       ORDER BY t2.timestamp DESC 
                       LIMIT 3) AS last_three 
                 WHERE declined = 1) = 3 THEN 0 ELSE 1 
       END AS activada
FROM transactions t
GROUP BY t.card_id;

#Comprobamos
select * from tarjetas_activadas;

#ex 03
SELECT COUNT(CARD_ID) AS CANTIDAD_TARJETAS_ACTIVAS
FROM TARJETAS_ACTIVADAS
WHERE ACTIVADA = 1;

#La tabla de enlace fue creada en powerquery en el pdf esta explicado.
#Nivel 3 Ex01
select p.product_name, count(tp.product_id) as recuento_ventas
from products p
join transactions_product tp on p.id = tp.product_id
group by p.product_name;