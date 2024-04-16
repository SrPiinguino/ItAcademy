#Nivel 1 - Ex01
SELECT *
FROM transaction
  WHERE company_id IN (
    SELECT id
    FROM company
    WHERE country = "Germany"
  );

#Nivel 1 - ex02
SELECT company_name
FROM company
WHERE EXISTS (
    SELECT 1
    FROM transaction
    WHERE company_id = company.id
    AND amount > (SELECT AVG(amount) FROM transaction)
);

#Nivel 1 - ex03
SELECT company_name, t.* 
FROM transaction t, 
(SELECT id, company_name
FROM company
WHERE company_name like "c%") AS c
WHERE company_id = c.id;

#Nivel 1 - ex04
SELECT company_name 
FROM company
 WHERE NOT EXISTS (SELECT * 
					FROM transaction
                    WHERE company_id = company.id);                    

#Nivel 2 - ex01
SELECT t.*
FROM transaction t
WHERE company_id IN (
    SELECT id 
    FROM company  
    WHERE country = (SELECT country FROM company WHERE company_name= "Non Institute")
);

#Nivel 2 -ex02
SELECT *
FROM company 
WHERE id IN (SELECT company_id
			FROM transaction
            WHERE amount = (SELECT max(amount)
							FROM transaction));

#Nivel 3 - ex01
SELECT AVG(t.amount) AS avg_transaction,
    (SELECT c.country FROM company c WHERE c.id = t.company_id) AS country    
FROM transaction t
GROUP BY country
HAVING avg_transaction > (SELECT AVG(amount) FROM transaction)
;


#Nivel 3 Ex02
SELECT 
    c.company_name,
    CASE 
        WHEN (SELECT COUNT(*) 
              FROM transaction t 
              WHERE t.company_id = c.id) > 4 THEN 'Más de 4 Transacciones'
        ELSE 'Menos de 4 Transacciones'
    END AS transaction_count
FROM 
    company c;

