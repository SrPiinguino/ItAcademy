CREATE TABLE credit_card (
    id VARCHAR(15)  PRIMARY KEY,
    iban VARCHAR(100),
    pan VARCHAR(255),
    pin VARCHAR(50),
    cvv VARCHAR(50),
    expiring_date VARCHAR(255) NOT NULL
);

drop table credit_card;


#Aqui introducimos el Script para los datos de la tabla

#luego introducimos los valores que nos han proporcionado en el otro script y comprobamos:
SELECT * 
FROM credit_card;

#Añadimos la Foreign KEy a la tabla transaction
ALTER TABLE transaction ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);



#ex02
UPDATE credit_card
SET iban = "TR323456312213576817699999"
WHERE id="CcU-2938";

#COMPROBACION DEL CAMBIO:
SELECT * 
FROM credit_card 
WHERE id= "CcU-2938";

#ex03
#debido a errores con insertar un registro en company_id que no existe en la tabla company, he dejado introducido
#el id de la compañia y de la tarjeta de credito de la nueva transaccion con tal de añadir sus datos posteriormente
#pero tambien podriamos haber alterado la relaciones de las tablas para poder introducirlo sin necesidad de dejar
#preparado los datos de la compañia
INSERT INTO company (id)
VALUES ('b-9999');
INSERT INTO credit_card (id)
VALUES ('CcU-9999');
#insertamos los valores requeridos.
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount,declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999','9999','829.999','-117.999',null,'111.11','0');

#Comprobacion del cambio:
SELECT * 
FROM transaction 
WHERE company_id = 'b-9999';


#Ex04
ALTER TABLE credit_card 
DROP COLUMN pan;
#Comprobamos:
SELECT * 
FROM credit_card;

#Nivel 2 Ex 01
DELETE 
FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

#Comprobamos:
SELECT * 
FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

#Nivel 2 Ex 02
CREATE VIEW VistaMarketing AS
SELECT 
    company.company_name AS Compañia, 
    company.phone AS telefono, 
    company.country AS pais,
    AVG(transaction.amount) AS promedio
    FROM company
    JOIN transaction ON company.id = transaction.company_id
    GROUP BY Compañia,telefono,pais
    ORDER BY promedio DESC;

#Comprobamos:
SELECT * 
FROM VistaMarketing;

#Nivel 2 Ex03
SELECT *
FROM VistaMarketing
WHERE pais = 'Germany';

#Nivel 3 Ex01
#Primero creamos el indice y la tabla data_user que alamecena los datos de usuario
CREATE INDEX idx_user_id ON transaction(user_id); 
CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)    
    );
    


#Modificamos la tabla credit_card para añadir la columna fecha_actual
ALTER TABLE credit_card 
ADD COLUMN fecha_actual DATE;

#Eliminamos la columna website de la tabla company
ALTER TABLE company 
DROP COLUMN website;

#Modificamos algunas columnas de credit_card
ALTER TABLE credit_card 
MODIFY COLUMN id VARCHAR(20),
MODIFY COLUMN iban VARCHAR(50),
MODIFY COLUMN pin VARCHAR(4),
MODIFY COLUMN expiring_date VARCHAR(10),
MODIFY COLUMN cvv int; #Apunto que en la anterior correcion se me aviso que este tipo de dato podria 
					#dar error si hay 0 en la izquierda pero el ejercicio lo requiere


-- Insertamos datos de user


#renombramos la tabla user, al nombre correspodiente, data_user
RENAME TABLE user TO data_user;

#Modificamos la columna email a personal_email
alter table data_user
change email personal_email VARCHAR(150);
 

 #Establecemos la relacion entre las tablas transactions y data_user
#Para ello previamente debemos introucir el usuario que hemos creado antes en la tabla transaccion
INSERT INTO data_user (id) 
VALUES('9999');
ALTER TABLE transaction ADD FOREIGN KEY (user_id) REFERENCES data_user(id);



#Nivel 3 Ex02
#En este ejercicio he añadido el monto de la transaccion, pais usuario y pais compañia como datos de interes.
CREATE VIEW InformeTecnico AS
SELECT transaction.id AS id_transaccion,
transaction.amount AS monto_transaccion,
data_user.name AS nombre_usuario, 
data_user.surname AS apellido,
data_user.country AS Pais_usuario,
credit_card.iban, 
company.company_name AS compañia,
company.country AS Pais_Compañia
FROM transaction
JOIN data_user ON data_user.id = transaction.user_id
JOIN credit_card ON credit_card.id = transaction.credit_card_id
JOIN company ON company.id	=	transaction.company_id;

SELECT * 
FROM InformeTecnico;