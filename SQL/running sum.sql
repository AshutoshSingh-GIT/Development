CREATE TABLE department(
ID int,
SALARY int,
NAME Varchar(20),
DEPT_ID Varchar(255));

INSERT INTO department 
VALUES (1, 34000, 'ANURAG', 'UI DEVELOPERS');

INSERT INTO department 
VALUES (2, 33000, 'harsh', 'BACKEND DEVELOPERS');

INSERT INTO department 
VALUES (3, 36000, 'SUMIT', 'BACKEND DEVELOPERS');

INSERT INTO department 
VALUES (4, 36000, 'RUHI', 'UI DEVELOPERS');

INSERT INTO department 
VALUES (5, 37000, 'KAE', 'UI DEVELOPERS');

select * from department;

-- example 1.a window function
select *, 
sum(salary) over (order by id) running_total
from department;

-- example 1.b window function
SELECT *
   ,SUM(SALARY) OVER  (
PARTITION BY DEPT_ID  ORDER BY Id
) AS Running_Total
FROM department


--example 2 as subquery
	select *,
	(select sum (T2.salary) from department T2 where T2.ID<=T1.ID) Running_count
	from 
	department T1;
	
	
	
CREATE TABLE tblEmployee(
 Empid int NOT NULL,
 EmpName varchar(50) NOT NULL,
 Salary_Date DATE NOT NULL,
 Salary int NULL 
) 


-- Inserting data in to tblEmployee table
INSERT INTO tblEmployee
           (Empid,EmpName,Salary_Date,Salary)
     VALUES
     (1,'smith','2020-03-01',8000) ,(1,'smith','2020-04-01',8050)  ,(1,'smith','2020-05-01',8100)
    ,(1,'smith','2020-06-01',8150) ,(1,'smith','2020-07-01',8150)  ,(2,'Allen','2020-05-01',7000)
    ,(2,'Allen','2020-06-01',9000) ,(2,'Allen','2020-07-01',9000)  ,(3,'Peter','2020-07-01',8000)

	
select *,
 cast(SUM(Salary) OVER (PARTITION BY empname order by Empid,Salary_Date) as iNT) RUN_SUM_Salary,
 CAST(AVG(SALARY) OVER (PARTITION BY empname order by Empid,Salary_Date) as INT) RUN_AVG_Salary
from tblEmployee


---self join

select
E1.empid,
E1.empname,
E1.salary_date,
E1.salary,
E2.*
--sum(E2.salary),
--CAST(AVG(E2.Salary) AS DECIMAL(19,2))
from tblEmployee E1
inner join tblEmployee E2
on E1.empid=E2.empid
AND E1.salary_date<=E2.salary_date
GROUP BY E1.empid,E1.empname,E1.salary_date,E1.salary
ORDER BY E1.empid

	
	
	

