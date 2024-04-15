#Nivel 1 - Ex01
select *
from transaction
  where transaction.company_id in (
    select id
    from company
    where company.country = "Germany"
  );

#Nivel 1 - ex02
SELECT company_name
FROM company
WHERE EXISTS (
    SELECT 1
    FROM transaction
    WHERE transaction.company_id = company.id
    AND transaction.amount > (SELECT AVG(amount) FROM transaction)
);

#Nivel 1 - ex03
select company_name, t.* 
from transaction t, 
(select id, company_name
from company
where company_name like "c%") as c
where company_id = c.id;

#Nivel 1 - ex04
select company_name from company
 where not exists (select * from transaction
                    where company_id = company.id);                    

#Nivel 2 - ex01
SELECT t.*, 
       (SELECT country FROM company WHERE id = t.company_id) AS country
FROM transaction t
WHERE EXISTS (
    SELECT 1 
    FROM company c 
    WHERE c.id = t.company_id 
    AND c.country IN (
        SELECT country 
        FROM company 
        WHERE company_name = 'Non Institute'
    )
);

#Nivel 2 -ex02
select c.company_name, valor
from company c, (select company_id, max(amount) as valor
from transaction
group by company_id
order by valor desc limit 1) as t
where c.id = t.company_id
;

#Nivel 3 - ex01
select country, avg(amount)as media
from company, transaction
where company.id= transaction.company_id
group by country 
having avg(amount)>(select avg(amount) 
from transaction)
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

