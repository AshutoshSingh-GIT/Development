--source -- https://www.youtube.com/watch?v=ZML_EJrBhnY

--- Q2: Display highest and lowest salary corresponding to each department --- 

drop table if exists employee;
create table employee
(
	id 			int primary key GENERATED ALWAYS AS IDENTITY,
	name 		varchar(100),
	dept 		varchar(100),
	salary 		int
);
insert into employee values(default, 'Alexander', 'Admin', 6500);
insert into employee values(default, 'Leo', 'Finance', 7000);
insert into employee values(default, 'Robin', 'IT', 2000);
insert into employee values(default, 'Ali', 'IT', 4000);
insert into employee values(default, 'Maria', 'IT', 6000);
insert into employee values(default, 'Alice', 'Admin', 5000);
insert into employee values(default, 'Sebastian', 'HR', 3000);
insert into employee values(default, 'Emma', 'Finance', 4000);
insert into employee values(default, 'John', 'HR', 4500);
insert into employee values(default, 'Kabir', 'IT', 8000);

select * from employee;

-- my solution
select *,
max(salary) over (partition by dept order by salary desc) Max_salary_in_dept, 
min(salary) over (partition by dept order by salary asc) Min_salary_in_dept
from employee
order by dept, salary desc


important
read about frame clause --range unbounder preceding and unbounded following