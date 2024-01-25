create schema sq;
--drop schema subquery;

 create table sq.department
(
	dept_id		int ,
	dept_name	varchar(50) PRIMARY KEY,
	location	varchar(100)
);

insert into sq.department values (1, 'Admin', 'Bangalore');
insert into sq.department values (2, 'HR', 'Bangalore');
insert into sq.department values (3, 'IT', 'Bangalore');
insert into sq.department values (4, 'Finance', 'Mumbai');
insert into sq.department values (5, 'Marketing', 'Bangalore');
insert into sq.department values (6, 'Sales', 'Mumbai');

select * from sq.department;

--
CREATE TABLE sq.EMPLOYEE
(
    EMP_ID      INT PRIMARY KEY,
    EMP_NAME    VARCHAR(50) NOT NULL,
    DEPT_NAME   VARCHAR(50) NOT NULL,
    SALARY      INT,
    constraint fk_emp foreign key(dept_name) references sq.department(dept_name)
);

insert into sq.employee values(101, 'Mohan', 'Admin', 4000);
insert into sq.employee values(102, 'Rajkumar', 'HR', 3000);
insert into sq.employee values(103, 'Akbar', 'IT', 4000);
insert into sq.employee values(104, 'Dorvin', 'Finance', 6500);
insert into sq.employee values(105, 'Rohit', 'HR', 3000);
insert into sq.employee values(106, 'Rajesh',  'Finance', 5000);
insert into sq.employee values(107, 'Preet', 'HR', 7000);
insert into sq.employee values(108, 'Maryam', 'Admin', 4000);
insert into sq.employee values(109, 'Sanjay', 'IT', 6500);
insert into sq.employee values(110, 'Vasudha', 'IT', 7000);
insert into sq.employee values(111, 'Melinda', 'IT', 8000);
insert into sq.employee values(112, 'Komal', 'IT', 10000);
insert into sq.employee values(113, 'Gautham', 'Admin', 2000);
insert into sq.employee values(114, 'Manisha', 'HR', 3000);
insert into sq.employee values(115, 'Chandni', 'IT', 4500);
insert into sq.employee values(116, 'Satya', 'Finance', 6500);
insert into sq.employee values(117, 'Adarsh', 'HR', 3500);
insert into sq.employee values(118, 'Tejaswi', 'Finance', 5500);
insert into sq.employee values(119, 'Cory', 'HR', 8000);
insert into sq.employee values(120, 'Monica', 'Admin', 5000);
insert into sq.employee values(121, 'Rosalin', 'IT', 6000);
insert into sq.employee values(122, 'Ibrahim', 'IT', 8000);
insert into sq.employee values(123, 'Vikram', 'IT', 8000);
insert into sq.employee values(124, 'Dheeraj', 'IT', 11000);

select * from sq.employee;

--
CREATE TABLE sq.employee_history
(
    emp_id      INT PRIMARY KEY,
    emp_name    VARCHAR(50) NOT NULL,
    dept_name   VARCHAR(50),
    salary      INT,
    location    VARCHAR(100),
    constraint fk_emp_hist_01 foreign key(dept_name) references sq.department(dept_name),
    constraint fk_emp_hist_02 foreign key(emp_id) references sq.employee(emp_id)
);

select * from sq.employee_history;

--
create table sq.sales
(
	store_id  		int,
	store_name  	varchar(50),
	product_name	varchar(50),
	quantity		int,
	price	     	int
);
insert into sq.sales values
(1, 'Apple Store 1','iPhone 13 Pro', 1, 1000),
(1, 'Apple Store 1','MacBook pro 14', 3, 6000),
(1, 'Apple Store 1','AirPods Pro', 2, 500),
(2, 'Apple Store 2','iPhone 13 Pro', 2, 2000),
(3, 'Apple Store 3','iPhone 12 Pro', 1, 750),
(3, 'Apple Store 3','MacBook pro 14', 1, 2000),
(3, 'Apple Store 3','MacBook Air', 4, 4400),
(3, 'Apple Store 3','iPhone 13', 2, 1800),
(3, 'Apple Store 3','AirPods Pro', 3, 750),
(4, 'Apple Store 4','iPhone 12 Pro', 2, 1500),
(4, 'Apple Store 4','MacBook pro 16', 1, 3500);

select * from sq.sales;

---


/*  Scaler Subquery */

--In where caluse 
select * from sq.employee where salary >= (Select cast(avg(salary) as int) from sq.employee);

--In from clause 
select * from 
sq.employee E
inner join (Select cast(avg(salary) as int) Sal from sq.employee) A
on  E.salary>=A.sal

/*  Multiple Subquery */
--multiple column multiple records or rows
--select * from sq.employee
with cte as (select emp_name,dept_name,salary, 
row_number() over (partition by dept_name order by salary desc) rn
from sq.employee 
group by emp_name,dept_name,salary)
select * from cte where rn=1

select * from sq.employee where (dept_name, salary) in (
select dept_name, max(salary) from sq.employee group by dept_name);

-- single column mutiple records or rows
select * from sq.employee
select * from sq.department

select * from sq.department where dept_name not in (
select dept_name from sq.employee group by dept_name);

select * from sq.department where dept_name not in (
select distinct dept_name from sq.employee);


/*  correlated Subquery */
-- A subquery which is related to the Outer query

select * 
from sq.employee e1
where salary > ( select avg(salary) from sq.employee e2
			   		where e1.dept_name = e2.dept_name);
					
--alternate solution					

select * from sq.employee e1
inner join
(select distinct dept_name, cast(avg(salary) over (partition by dept_name) as int) avg_sal_by_dept from sq.employee) e2
on e1.dept_name = e2.dept_name
and e1.salary>e2.avg_sal_by_dept;



select * from sq.department d where not exists (
select 1 from sq.employee e where e.dept_name=d.dept_name);

select 1 from sq.employee e where e.dept_name='Marketing'


/* SUBQUERY inside SUBQUERY (NESTED Subquery)*/
/* QUESTION: Find stores who's sales where better than the average sales accross all stores 
1) find the sales for each store
2) average sales for all stores
3) compare 2 with 1 */

select * from sq.sales

with cte as (select distinct store_name ,cast(sum(price) over (partition by store_name) as int) avg_p_by_store from sq.sales)
select * from cte where avg_p_by_store >
(select cast(avg(price) as int) from sq.sales)

Select * from 
(select distinct store_name ,cast(sum(price) over (partition by store_name) as int) avg_p_by_store from sq.sales) w
inner join 
(select cast(avg(avg_p_by_store) as Int) avg_store_Sale from (
select distinct store_name ,cast(sum(price) over (partition by store_name) as int) avg_p_by_store from sq.sales) x) y
on w.avg_p_by_store>y.avg_store_Sale

--alternate with cte
with cte as (
select distinct store_name ,cast(sum(price) over (partition by store_name) as int) avg_p_by_store from sq.sales
)
Select * from 
cte w
inner join 
(select cast(avg(avg_p_by_store) as Int) avg_store_Sale from cte ) y
on w.avg_p_by_store>y.avg_store_Sale

/*** sub queries can be used in following 
1. select 
2. from
3. where
4. having
****/

-- inside your select clause
select *,
(case when salary > (select avg(salary) from sq.employee ) then 'High'
	else 'low' end 
) as remark
from sq.employee

--Alternative 
 
select *
,(case when salary > average  then 'High'
	else 'low' end 
) as remark
from sq.employee A
cross Join (select avg(salary) average from sq.employee) B;


-- subquery inside your having clause
select * from sq.sales

select store_name, sum(quantity) from sq.sales
group by store_name
having sum(quantity) > (select avg(quantity) from sq.sales);


/*** sql commands which supports subquery ***/ 

select * from sq.employee_history

insert into sq.employee_history
select e.emp_id, e.emp_name, d.dept_name, e.salary, d.location
from sq.employee e
inner join sq.department d 
on d.dept_name=e.dept_name
where not exists (select 1 from sq.employee_history eh
				 where eh.emp_id = e.emp_id)
				 
--update 	
select * from sq.employee
select * from sq.employee_history

update sq.employee e
set salary = (select max(salary)*1.10
			 from sq.employee_history eh
			 where e.dept_name=eh.dept_name)
Where e.dept_name in (select dept_name from sq.department where dept_name='Bangalore')
and e.emp_id in (select emp_id from sq.employee_history);
					  
--delete 

delete from sq.department 
where dept_name in (select dept_name from sq.department d 
						where not exists ( select 1 from sq.employee e where e.dept_name = d.dept_name ) 
					)
			
