select * from information_schema.tables;
select * from postgres.public.test;
Drop table postgres.public.test;

create table if not exists postgres.public.test
(
Name varchar(20),
	age int
)

insert into postgres.public.test
(Name, Age)
values
('Ramesj',78)
,('suressh',87)

('Aditi',12),
('Avi', 1),
('kavi', 21)


--Subquery to get total row in new column.
Select 
name,
age,
(Select count(1) from postgres.public.test) total 
from postgres.public.test group by name,age ;

