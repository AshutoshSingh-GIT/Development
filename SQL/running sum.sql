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

	
	
	


-- Source --> https://www.youtube.com/watch?v=ZML_EJrBhnY

--- Q3 : Find actual distance --- 

drop table car_travels;
create table car_travels
(
    cars                    varchar(40),
    days                    varchar(10),
    cumulative_distance     int
);
insert into car_travels values ('Car1', 'Day1', 50);
insert into car_travels values ('Car1', 'Day2', 100);
insert into car_travels values ('Car1', 'Day3', 200);
insert into car_travels values ('Car2', 'Day1', 0);
insert into car_travels values ('Car3', 'Day1', 0);
insert into car_travels values ('Car3', 'Day2', 50);
insert into car_travels values ('Car3', 'Day3', 50);
insert into car_travels values ('Car3', 'Day4', 100);

select * from car_travels;

Select cars, days, cumulative_distance, cu_sum, 
case when (cumulative_distance-lag_value) is not null then (cumulative_distance-lag_value) else cumulative_distance end as actual_val 
from (
select *, 
lag(cumulative_distance) over (partition by cars order by days) lag_value,
sum(cumulative_distance) over (partition by cars order by days) cu_sum 
from car_travels ) x

--important alternative
cumulative_distance- lag(cumulative_distance,1,0) over (partition by cars order by days) as actual_days
