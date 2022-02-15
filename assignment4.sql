-- Oracle MERGE statement

CREATE TABLE members (
    member_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    rank VARCHAR2(20)
);

CREATE TABLE member_staging AS 
SELECT * FROM members;

-- insert into members table    
INSERT INTO members(member_id, first_name, last_name, rank) VALUES(1,'Abel','Wolf','Gold');
INSERT INTO members(member_id, first_name, last_name, rank) VALUES(2,'Clarita','Franco','Platinum');
INSERT INTO members(member_id, first_name, last_name, rank) VALUES(3,'Darryl','Giles','Silver');
INSERT INTO members(member_id, first_name, last_name, rank) VALUES(4,'Dorthea','Suarez','Silver');
INSERT INTO members(member_id, first_name, last_name, rank) VALUES(5,'Katrina','Wheeler','Silver');
INSERT INTO members(member_id, first_name, last_name, rank) VALUES(6,'Lilian','Garza','Silver');
INSERT INTO members(member_id, first_name, last_name, rank) VALUES(7,'Ossie','Summers','Gold');
INSERT INTO members(member_id, first_name, last_name, rank) VALUES(8,'Paige','Mcfarland','Platinum');
INSERT INTO members(member_id, first_name, last_name, rank) VALUES(9,'Ronna','Britt','Platinum');
INSERT INTO members(member_id, first_name, last_name, rank) VALUES(10,'Tressie','Short','Bronze');

-- insert into member_staging table
INSERT INTO member_staging(member_id, first_name, last_name, rank) VALUES(1,'Abel','Wolf','Silver');
INSERT INTO member_staging(member_id, first_name, last_name, rank) VALUES(2,'Clarita','Franco','Platinum');
INSERT INTO member_staging(member_id, first_name, last_name, rank) VALUES(3,'Darryl','Giles','Bronze');
INSERT INTO member_staging(member_id, first_name, last_name, rank) VALUES(4,'Dorthea','Gate','Gold');
INSERT INTO member_staging(member_id, first_name, last_name, rank) VALUES(5,'Katrina','Wheeler','Silver');
INSERT INTO member_staging(member_id, first_name, last_name, rank) VALUES(6,'Lilian','Stark','Silver');

MERGE INTO member_staging x
USING (SELECT member_id, first_name, last_name, rank FROM members) y
ON (x.member_id  = y.member_id)
WHEN MATCHED THEN
    UPDATE SET x.first_name = y.first_name, 
                        x.last_name = y.last_name, 
                        x.rank = y.rank
    WHERE x.first_name <> y.first_name OR 
           x.last_name <> y.last_name OR 
           x.rank <> y.rank 
WHEN NOT MATCHED THEN
    INSERT(x.member_id, x.first_name, x.last_name, x.rank)  
    VALUES(y.member_id, y.first_name, y.last_name, y.rank);
    
    
------------------------------------------------------------------------------------------------------------

select * from emp;
select * from dept;
select * from branch;


---merge statement example

create table branchDetails as
select * from branch;


	INSERT INTO branchDetails VALUES 	(101,'Geneva','NEW YORK');
	INSERT INTO branchDetails VALUES 	(103,'CHICAGO','Geneva');
	INSERT INTO branchDetails VALUES 	(105,'Kingston','CHICAGO');
    
    
merge into branchDetails x
using (select BRANCHNO, BRANCHNAME, LOCATION from branch) y
on (x.branchno = y.branchno)
when matched then 
    update set x.BRANCHNAME = y.BRANCHNAME,
               x.location = y.location
    where x.BRANCHNAME <> y.BRANCHNAME or
               x.location <> y.location
when not matched then
    insert (x.BRANCHNO, x.BRANCHNAME, x.LOCATION)
    values(y.BRANCHNO, y.BRANCHNAME, y.LOCATION);

select BRANCHNO, BRANCHNAME, LOCATION from branchDetails;


--Oracle Updatable View

CREATE TABLE brands(
	brand_id NUMBER GENERATED BY DEFAULT AS IDENTITY,
	brand_name VARCHAR2(50) NOT NULL,
	PRIMARY KEY(brand_id)
);

CREATE TABLE cars (
	car_id NUMBER GENERATED BY DEFAULT AS IDENTITY,
	car_name VARCHAR2(255) NOT NULL,
	brand_id NUMBER NOT NULL,
	PRIMARY KEY(car_id),
	FOREIGN KEY(brand_id) 
	REFERENCES brands(brand_id) ON DELETE CASCADE
);

INSERT INTO brands(brand_name)
VALUES('Audi');


INSERT INTO brands(brand_name)
VALUES('BMW');


INSERT INTO brands(brand_name)
VALUES('Ford');


INSERT INTO brands(brand_name)
VALUES('Honda');


INSERT INTO brands(brand_name)
VALUES('Toyota');


INSERT INTO cars (car_name,brand_id)
VALUES('Audi R8 Coupe',
       1);


INSERT INTO cars (car_name,brand_id)
VALUES('Audi Q2',
       1);


INSERT INTO cars (car_name,brand_id)
VALUES('Audi S1',
       1);


INSERT INTO cars (car_name,brand_id)
VALUES('BMW 2-serie Cabrio',
       2);


INSERT INTO cars (car_name,brand_id)
VALUES('BMW i8',
       2);


INSERT INTO cars (car_name,brand_id)
VALUES('Ford Edge',
       3);


INSERT INTO cars (car_name,brand_id)
VALUES('Ford Mustang Fastback',
       3);


INSERT INTO cars (car_name,brand_id)
VALUES('Honda S2000',
       4);


INSERT INTO cars (car_name,brand_id)
VALUES('Honda Legend',
       4);


INSERT INTO cars (car_name,brand_id)
VALUES('Toyota GT86',
       5);


INSERT INTO cars (car_name,brand_id)
VALUES('Toyota C-HR',
       5);
       
--    Oracle updatable view example

--creates a new view named cars_master:

  CREATE VIEW cars_master AS 
SELECT
    car_id,
    car_name
FROM
    cars;
    
--It?s possible to delete a row from the cars table via the cars_master view, for example:

   DELETE
FROM
    cars_master
WHERE
    car_id = 1;
  
--And you can update any column values exposed to the cars_master view:   

UPDATE
    cars_master
SET
    car_name = 'Audi RS7 Sportback'
WHERE
    car_id = 2;

--However, insert a new row into the cars table via the cars_master view is not possible. Because the cars table has a not null column ( brand_id) without a default value.

INSERT INTO cars_master
VALUES('Audi S1 Sportback');



--Oracle updatable join view example

CREATE VIEW all_cars AS 
SELECT
    car_id,
    car_name,
    c.brand_id,
    brand_name
FROM
    cars c
INNER JOIN brands b ON
    b.brand_id = c.brand_id; 
    

    
 
    
--The following statement inserts a new row into the cars table via the call_cars view:
INSERT INTO all_cars(car_name, brand_id )
VALUES('Audi A5 Cabriolet', 1);



select * from all_cars;

DELETE
FROM
    all_cars
WHERE
    brand_name = 'Honda';

--Find updatable columns of a join view

SELECT
    *
FROM
    USER_UPDATABLE_COLUMNS
WHERE
    TABLE_NAME = 'ALL_CARS';
   
--------------------------------------------------------------------------------------------------------- 

--UPDATABLE VIEW ON JOIN EXAMPLE

create view all_emp as
select
    empno,
    ename,
    d.deptno,
    dname
from
    emp e
inner join dept d on
    e.deptno = d.deptno;
    
select * from all_emp;

delete from all_emp
where
ename = 'ADAMS';

SELECT
    *
FROM
    USER_UPDATABLE_COLUMNS
WHERE
    TABLE_NAME = 'all_emp';
    
    insert into all_emp(deptno, empno)
values (40, 7777);  --there is no column in which user can modify!





--Inline View in Oracle


--A) simple Oracle inline view example
select
*
from
(
    select
    empno, ename, job, sal
    from
    emp
    order by
    empno
)
where 
rownum <= 10;


--B) Inline view joins with a table example

select
    ename, dname
from
    emp e, dept d
where e.deptno = d.deptno
order by dname;

--C) LATERAL inline view example

select
dname,
branchname
from
dept d,
lateral(select * from branch b where b.branchno = d.branchno)
order by
dname;

