--Oracle CREATE INDEX examples

CREATE TABLE members(
    member_id INT GENERATED BY DEFAULT AS IDENTITY,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100) NOT NULL,
    gender CHAR(1) NOT NULL,
    dob DATE NOT NULL,
    email VARCHAR2(255) NOT NULL,
    PRIMARY KEY(member_id)
);

select count(member_id) from members;

--if we want to search a member id 999 then
select * from members where member_id = 999;

--if we want to search record whose last name is Surtees then
select * from members where last_name = 'Surtees';

--But u can see , it is taking time to search , so to avoid this 
-- time, we are using indexes

create index i_members_lastname 
on members (last_name);

explain plan for
select * from members 
where last_name = 'Harse';

SELECT 
    PLAN_TABLE_OUTPUT 
FROM 
    TABLE(DBMS_XPLAN.DISPLAY());
    
    
    
EXPLAIN PLAN FOR
SELECT * FROM members
WHERE first_name = 'Delores';

SELECT 
    PLAN_TABLE_OUTPUT 
FROM 
    TABLE(DBMS_XPLAN.DISPLAY());
    
    
    
    
 --Oracle UNIQUE index

create unique index members_email_i
on members(email);

--By having this members_email_i index, you cannot have two rows with the same value in the email column.

INSERT INTO members(first_name, last_name, gender, dob, email)
VALUES('Pegpa','Elce','F',DATE '1990-01-02','pelce0@trellian.com');
-- this will give error 

--Oracle UNIQUE index, Primary Key constraint, and Unique constraint

CREATE TABLE t1 (
    pk1 INT PRIMARY KEY,
    c1 INT
);

SELECT 
    index_name, 
    index_type, 
    visibility, 
    status 
FROM 
    all_indexes
WHERE 
    table_name = 'T1';
    
    
--as can be seen clearly from the output, the SYS_C008369
--  unique index was created automatically with the , generated name

--To specify the na,e for primary key column , 
-- you can use the unique index as shown 

CREATE TABLE T2
(
    PK2 INT PRIMARY KEY
        USING INDEX 
        (
        CREATE INDEX T1_PK1_I ON T2 (PK2)
        ),
        C2 INT
);  

SELECT 
    index_name, 
    index_type, 
    visibility, 
    status 
FROM 
    all_indexes
WHERE 
    table_name = 'T2';


commit;   
    
    
   -- FUNCTION BASED INDEX


create index members_last_name_i
on members(last_name);

select * from members
where last_name = 'Sans';

select * from members
where last_name = 'SANS';  --there is no record

--However, if you use a function on the indexed column last_name as follows:

select * from members 
where UPPER(last_name) = 'SANS';

explain plan for
select * from members 
where UPPER(last_name) = 'SANS';

select plan_table_output
from table(dbms_xplan.display());


--To encounter this, Oracle introduced function-based indexes.

--A function-based index calculates the result of a function that
--involves one or more columns and stores that result in the index.

--Oracle function-based index example

create index members_last_name_fi
on members (UPPER(last_name));

explain plan for
select * from members 
where UPPER(last_name) = 'SANS';

select plan_table_output
from table(dbms_xplan.display());

--A function-based index helps you perform more flexible sorts.
--For example, the index expression can call  UPPER() and LOWER()
--functions for case-insensitive sorts or NLSSORT() function for 
--linguistic-based sorts.

 
    
    -- Oracle bitmap index

SELECT 
    *
FROM
    members
WHERE
    gender = 'F';
    

SELECT 
    gender, count(*)
FROM
    members
group by
    gender;
  -- as here are only two distinct values , we can count it in low cardinality value

--Oracle has a special kind of index for these types of columns which is called a bitmap index.
--Oracle uses a mapping function to converts each bit in the bitmap to the corresponding rowid of the members table.

create bitmap index members_gender_i
on members(gender);

explain plan for
SELECT 
    *
FROM
    members
WHERE
    gender = 'F';
    
select
plan_table_output
from table(dbms_xplan.display());

--When to use Oracle bitmap indexes

    --you should use the bitmap index for the column that have low cardinality.
    
--LETS See the cardinality values from emp table;

select empno, count(empno) from emp group by empno;    
--AS U CAN SEE THERE ARE 14 VALUES , SO WE CAN COUNT EMPNO IN MAXIMUN CARDINALITY VALUES
select deptno , count(*) from emp group by deptno;
-- this can be count in low cv
select mgr, count(*) from emp group by mgr;

--BEFORE APPLYING INDEX

select * from emp where deptno = 30;

--NOW WE ARE APPLYING INDEX ON DEPTNO

create bitmap index deptno_index
on emp(deptno);

explain plan for 
select * from emp where deptno = 30;

select plan_table_output from table(dbms_xplan.display());

----------------------------------------------------------------------------------------------

--Infrequently updated or read-only tables

CREATE TABLE bitmap_index_demo(
    id INT GENERATED BY DEFAULT AS IDENTITY,
    active NUMBER NOT NULL,
    PRIMARY KEY(id)
);


CREATE BITMAP INDEX bitmap_index_demo_active_i
ON bitmap_index_demo(active);

INSERT INTO bitmap_index_demo(active) 
VALUES(1);

INSERT INTO bitmap_index_demo(active) 
VALUES(0);

INSERT INTO bitmap_index_demo(active) 
VALUES(0);

select * from bitmap_index_demo;


--ORACLe fetch



select 
dname, sal
from emp 
inner join dept
using (deptno)
order by sal desc
fetch next 5 rows only;

--A) Top N rows example

select
ename,dname,sal,job
from emp
inner join dept
using(deptno)
order by
sal
fetch next 10 rows only;

--B) WITH TIES example

select
ename,dname,sal,job
from emp
inner join dept
using(deptno)
order by
sal
fetch next 10 rows with ties;

--C) Limit by percentage of rows example

select
ename,dname,sal,job
from emp
inner join dept
using(deptno)
order by
sal
fetch first 43 percent rows only;


--OFFSET example
select
ename,dname,sal,job
from emp
inner join dept
using(deptno)
order by
sal
OFFSET 10 ROWS 
FETCH NEXT 10 ROWS ONLY;






















    
    
    
    
    
    
    
    
    
    
    