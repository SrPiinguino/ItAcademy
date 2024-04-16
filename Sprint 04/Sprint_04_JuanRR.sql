
#Nivel 1 Ex 01
SELECT * FROM user
WHERE id IN (SELECT user_id FROM transactions
GROUP BY user_id
HAVING count(transactions.id) >= 30
);

#Ex02
#En este caso se suma las transacciones y se divide por el numero de iban aunque sean el mismo:
SELECT  AVG(transactions.amount) as media_trans_iban_DonecLtd, iban
FROM transactions
JOIN credit_cards ON transactions.card_id = credit_cards.id
JOIN companies ON transactions.business_id = companies.comapny_id
WHERE companies.company_name= 'Donec Ltd'
GROUP BY iban;


#Creacion Tabla Tarjetas Activadas:
#CREACION TABLA NIVEL 2
#en este caso usamos un case y una subquery que esta seleciona los ultimos tres declined usando timestamp como orderby
#una vez hecho esto indicamos en el case que si el valor del declined en las ultimas 3 transacciones
#es inferior a 3 contara como activada (1) y si es 3( que indica que los 3 ultimos declined son 1) contara 
#como 0(desactivada)


CREATE TABLE tarjetas_activadas AS
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
SELECT *
FROM tarjetas_activadas;

#ex 03
SELECT COUNT(CARD_ID) AS CANTIDAD_TARJETAS_ACTIVAS
FROM TARJETAS_ACTIVADAS
WHERE ACTIVADA = 1;

#La tabla de enlace fue creada en powerquery en el pdf esta explicado.
#Nivel 3 Ex01
SELECT p.product_name, count(tp.product_id) as recuento_ventas
FROM products p
JOIN transactions_product tp ON p.id = tp.product_id
GROUP BY p.product_name;