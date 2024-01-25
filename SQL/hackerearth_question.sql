create schema "ques";

create table ques.gods (
	g_id int,
	g_name varchar,
	g_gender varchar
)

insert into  ques.gods 
(g_id,g_name,g_gender)
values 
(4,'hereditus','F'),
(5,'prometheus', 'F')


(1,'Zeus','M')
,(2, 'Aries',	'M')
,(3, 'sisphus', 'F');

insert into  ques.relationship
(c_id,p_id)
values 
(2,1),
(2,3),
(4,1),
(4,5)

select * from ques.relationship
create table ques.relationship(
c_id int,
	p_id  int
)




-- select * from ques.gods (g_id,g_name,g_gender)
-- select * from ques.relationship ((c_id,p_id))





with cte1 as 
(
select distinct a.c_id,p_id, b.g_name from ques.relationship a
inner join ques.gods b
on a.c_id=b.g_id
)
,cte2 As
(
    Select c.g_id,d.c_id,c.g_name,c.g_gender 
	from ques.gods c
	Inner join ques.relationship d
	on c.g_id = d.p_id
	where c.g_id in (select distinct p_id from cte1)
)
,cte3 as
(--select * from cte2
select 
distinct 
f.c_id,
f.g_name as child,
case when e.g_gender='M' then e.g_name end as father
from cte1 f
left join cte2 e on e.c_id= f.c_id
)
,cte4 as 
(	
select 
distinct 
f.c_id,
f.g_name as child,
case when e.g_gender='F' then e.g_name end as mother
from cte1 f
left join cte2 e on e.c_id= f.c_id
)
select p.child ,p.father, q.mother 
from cte3 p
natural join cte4 q
where father is not null
and mother is not null




 


