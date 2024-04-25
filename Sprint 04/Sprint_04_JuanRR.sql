
#Nivel 1 Ex 01
SELECT * 
FROM user
WHERE id IN (SELECT user_id FROM transactions
GROUP BY user_id
HAVING count(transactions.id) >= 30
);


#Ex02
#En este caso se suma las transacciones y se divide por el numero de iban aunque sean el mismo:
SELECT  AVG(transactions.amount) as media_trans_iban_DonecLtd, iban
FROM transactions
JOIN credit_cards ON card_id = credit_cards.id
JOIN companies ON business_id = companies.comapny_id
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
                 WHERE declined = 1) = 3 THEN "Desactivada" ELSE "Activada" 
       END AS Estado_Tarjeta
FROM transactions t
GROUP BY t.card_id;

#Comprobamos
SELECT *
FROM tarjetas_activadas;

#NIVEL 2 Ex 03
SELECT COUNT(CARD_ID) AS CANTIDAD_TARJETAS_ACTIVAS
FROM TARJETAS_ACTIVADAS
WHERE Estado_Tarjeta = "Activada";


#NIVEL 3
/*La tabla de enlace fue creada en powerquery en el pdf esta explicado. sin embargo comentando en clase se me dijo 
que era necesario hacerlo a traves de sql por eso he añadido el siguiente paso para hacerlo por ambos metodos
*/
##Primer Paso crear tabla de enlace:
CREATE TABLE productos_transacciones_enlace (
    transaction_id VARCHAR(255),
    product_id INT
);
## Siguiente hacer una consulta para seleccionar las columnas y los datos que nos interesa

INSERT INTO productos_transacciones_enlace (Transaction_ID, Product_ID) #Los valores seran introducidos en las columnas creadas de la nuva tabla
SELECT id, SUBSTRING_INDEX(SUBSTRING_INDEX(Product_ids, ',', numbers.n), ',', -1) as Product_ID #Selecionamos el id de las transacciones y usamos la funcion substring index para poder buscar y separar las comas
FROM Transactions
JOIN (
    SELECT 1 as n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 #unimos las tablas generadas por indicices
) numbers ON CHAR_LENGTH(Product_ids) - CHAR_LENGTH(REPLACE(Product_ids, ',', '')) >= numbers.n - 1; #Aqui restamos la longitud  real del registro menos la longitud del registro sin las comas para saber cuantas comas hay


## Una vez creada la tabla establecemos las relaciones con las demas
ALTER TABLE productos_transacciones_enlace ADD FOREIGN KEY (transaction_id) REFERENCES transactions(id);
ALTER TABLE productos_transacciones_enlace ADD FOREIGN KEY (product_id) REFERENCES products(id);

#Comprobamos la tabla
SELECT *
FROM productos_transacciones_enlace;
##AÑADO COMO INTERES QUE TANTO LA TABLA CREADA CON POWER QUERY COMO ESTA TIENEN LOS MISMOS RESULTADOS:
SELECT *
FROM transactions_product;

#Nivel 3 Ex01
SELECT p.product_name, count(tp.product_id) as recuento_ventas
FROM products p
JOIN productos_transacciones_enlace tp ON p.id = tp.product_id
GROUP BY p.product_name;
