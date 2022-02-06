-- Assignment 03--

select * from emp;

======================
select unique job
from emp;

===================

select ename from emp
order by sal asc;

==================
SELECT* FROM emp
    
ORDER BY
    deptno ASC,job DESC;

====================

select unique  job  
from emp
order by job desc;

================================

select * from emp 
where job= 'MANAGER';

=======================================
select *  from emp
where hiredate <('01-01-81');

=============================
select empno ,ename ,sal,sal/30 DailySal
from emp 
order by Sal*12;

==================================================


SELECT EMPNO,
       ENAME,
       JOB,
       HIREDATE,
       MONTHS_BETWEEN(SYSDATE,HIREDATE) EXP
FROM EMP
WHERE EMPNO IN
    (SELECT MGR
     FROM EMP);
     
   === ==== ==================================================
   select empno,ename,sal from emp 
   where mgr = 7369;
   ============================================
   
   select * from emp where comm > sal;
   ====================================
   
select * from emp
where (sal/30) >100;.

==============================================
SELECT *
FROM emp
WHERE job='CLERK'
  OR job='ANALYST'
ORDER BY job DESC;

===========================================

SELECT *
FROM emp
WHERE hiredate IN ('01-05-81',
                    '03-12-81',
                    '17-12-81',
                    '19-01-80')
ORDER BY hiredate ASC;
=====================================

 select * from emp where deptno = 10 or deptno = 20 ;
 
 ==========================================================
 
  select * from emp where to_char(hiredate,'YYYY') = '1981' ;
  =================================================================
  
  select * from emp where 12*sal between 22000 and 45000;
  
================================================================
SELECT  ename  
FROM emp 
WHERE length(ename) = 5;
=========================================
SELECT  ename  
FROM emp 
WHERE length(ename) = 5 and  ename like 'S%';

===========================================================
SELECT  ename  
FROM emp 
where ename like '__R%';

=================================================================
SELECT  ename  
FROM emp 
WHERE length(ename) = 5 and  ename like 'S%H';

=====================================================================

  select * from emp where to_char(hiredate,'MM') = '01' ;
  =====================================================================
  select ename from emp where ename like '%LL%';
  =======================================================================
  select * from emp 
  where not deptno not in  (20);
  ===========================================================================
  SELECT *
FROM emp
WHERE job NOT IN ('PRESIDENT',
                       'MANAGER')
ORDER BY sal ASC;

==================================================================================

SELECT * FROM EMP WHERE EMPNO NOT LIKE '78%';

====================================================
select * from emp 
where mgr in(select empno from emp where job='MANAGER');

======================================================================
select * from emp where to_char (hiredate,'MM') not in ('05');
===============================================================
select * from emp where job ='CLERK' and deptno = 20;

=================================================================
select * from emp where to_char(hiredate,'YYYY') = '1981' and (deptno =30 or deptno =10) ;
=======================================================================================
select * from emp where ename='SMITH';

===============================
 select loc
 from emp e , 
 dept d 
 where e.ename = 'SMITH'  and e.deptno = d.deptno ;

 

