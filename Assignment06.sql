--ORACLE SYNONYMS

-- create aliases for schema objects such as tables, views,
-- materialized views, sequences, procedures, and stored function.

--SYSNTAX

--CREATE [OR REPLACE] [PUBLIC] SYNONYM schema.synonym_name
--FOR schema.object;

select * from c##aduser.emp; --as all the privileges are given to the aduser in asgr schema, it can access all the tables
select * from c##aduser.member;  --"table or view does not exist" bicuz , it is in another schema called practice

select * from c##aduser.branch;
create public synonym syn_branch for c##aduser.branch;      --Synonym SYN_BRANCH created.
select * from syn_branch;           --synonyms allow you to change complicated and lengthy names by simplified aliases.

create table INFO
(
eid int,
ename varchar(7)
);

insert into info values (1,'Monica');
insert into info values (2,'Joey');
insert into info values (3,'Phoebe');
insert into info values (4,'Ross');

select * from info;

select * from c##aduser.info;

--CREATING SYNONYM

create public synonym syn_info for c##aduser.info;      --Synonym SYN_INFO created.
select * from syn_info;

--INSERTING INTO SYNONYM
INSERT INTO syn_info  values (5, 'Rachel');

drop synonym syn_info force ;


--CREATING SEQUENCE

create sequence eid
increment by 1
maxvalue 1000
minvalue 1
cache 20;

create table emps (
empid number primary key,
ename varchar(15) not null);


insert into emps values (eid.nextval, 'Monica');
insert into emps values (eid.nextval, 'Chandler');
insert into emps values (eid.nextval, 'Ross');
insert into emps values (eid.nextval, 'Rachel');
insert into emps values (eid.nextval, 'Joey');
insert into emps values (eid.nextval, 'Phoebe');

select * from emps;

alter sequence eid maxvalue 1002;

drop sequence eid;




CREATE VIEW customer_category_sales AS
SELECT 
    category_name category, 
    customers.name customer, 
    SUM(quantity*unit_price) sales_amount
FROM 
    orders
    INNER JOIN customers USING(customer_id)
    INNER JOIN order_items USING (order_id)
    INNER JOIN products USING (product_id)
    INNER JOIN product_categories USING (category_id)
WHERE 
    customer_id IN (1,2)
GROUP BY 
    category_name, 
    customers.name;

SELECT 
    customer, 
    category, 
    sales_amount 
FROM 
    customer_category_sales
ORDER BY
    customer,
    category;

--(category)
SELECT 
    category, 
    SUM(sales_amount) 
FROM 
    customer_category_sales
GROUP BY 
    category;

--(customer)
SELECT 
    customer, 
    SUM(sales_amount)
FROM 
    customer_category_sales
GROUP BY 
    customer;    

--(category, customer)
SELECT 
    customer, 
    category, 
    sales_amount 
FROM 
    customer_category_sales
ORDER BY
    customer,
    category;

--()
SELECT 
    SUM(sales_amount)
FROM 
    customer_category_sales;

--the UNION ALL operator requires all involved queries return the same number of columns. 
--Therefore, to make it works, you need to add NULL to the select list of each query
SELECT 
    category, 
    NULL,
    SUM(sales_amount) 
FROM 
    customer_category_sales
GROUP BY 
    category
UNION ALL    
SELECT 
    customer,
    NULL,
    SUM(sales_amount)
FROM 
    customer_category_sales
GROUP BY 
    customer
UNION ALL
SELECT 
    customer, 
    category, 
    sum(sales_amount)
FROM 
    customer_category_sales
GROUP BY 
    customer,
    category
UNION ALL   
SELECT
    NULL,
    NULL,
    SUM(sales_amount)
FROM 
    customer_category_sales;

SELECT 
    customer, 
    category,
    SUM(sales_amount)
FROM 
    customer_category_sales
GROUP BY 
    GROUPING SETS(
        (customer,category),
        (customer),
        (category),
        ()
    )
ORDER BY 
    customer, 
    category;     

SELECT 
    customer, 
    category,
    GROUPING(customer) customer_grouping,
    GROUPING(category) category_grouping,
    SUM(sales_amount) 
FROM customer_category_sales
GROUP BY 
    GROUPING SETS(
        (customer,category),
        (customer),
        (category),
        ()
    )
ORDER BY 
    customer, 
    category;

SELECT 
    DECODE(GROUPING(customer),1,'ALL customers', customer) customer,
    DECODE(GROUPING(category),1,'ALL categories', category) category,
    SUM(sales_amount) 
FROM 
    customer_category_sales
GROUP BY 
    GROUPING SETS(
        (customer,category),
        (customer),
        (CATEGORY),
        ()
    )
ORDER BY 
    customer, 
    category;

SELECT 
    customer, 
    category,
    GROUPING_ID(customer,category) grouping,
    SUM(sales_amount) 
FROM customer_category_sales
GROUP BY 
    GROUPING SETS(
        (customer,category),
        (customer),
        (category),
        ()
    )
ORDER BY 
    customer, 
    category;










