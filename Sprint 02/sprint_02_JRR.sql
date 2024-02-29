#Ex01
select Alemania.*
from (
  select *
  from transactions.transaction
  where transactions.transaction.company_id in (
    select transactions.company.id
    from transactions.company
    where transactions.company.country = "Germany"
  )
) as Alemania;

select distinct transaction.*, country
from transactions.transaction
join company on transaction.company_id = company.id
where company.country= "Germany";

#ex02
select transactions.company.company_name, SUM(transactions.transaction.amount) as total_amount
from transactions.transaction
join transactions.company  ON transactions.transaction.company_id = transactions.company.id
group by transactions.company.company_name
having SUM(transactions.transaction.amount) > (select avg(amount) from transactions.transaction);

#ex03
Select transactions.company.company_name,transactions.transaction.*
from transactions.transaction
join  transactions.company  on transactions.transaction.company_id = transactions.company.id
where transactions.company.company_name like "C%" or "c%" ;

#ex04
select transactions.company.company_name from transactions.company
 where not exists (select * from transactions.transaction
                    where transactions.transaction.company_id = transactions.company.id);

#Ex05
select transaction.*, company.country
from transactions.transaction
join transactions.company on transaction.company_id = company.id
where company.country in (
    select country
    from transactions.company
    where company_name = 'Non Institute'
);



#EX06
select transactions.company.company_name
from transactions.company
join transactions.transaction on transactions.company.id = transactions.transaction.company_id
group by transactions.company.company_name
having sum(transactions.transaction.amount) = (
    select MAX(total_amount)
    from (
        select sum(transactions.transaction.amount) as total_amount
        from transactions.transaction
        group by transactions.transaction.company_id
    ) AS subquery
);

#Ex07
select country
from transactions.company
join transactions.transaction on company.id = transaction.company_id
group by country
having count(transaction.id) > (select avg(recuento_id)
from (select count(transaction.id) as recuento_id from transactions.transaction
join transactions.company on transaction.company_id = company.id
group by country) as sq);


