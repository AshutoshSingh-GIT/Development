 https://www.youtube.com/watch?v=ZML_EJrBhnY

Q1 --> From the table delete records where all data is duplicated.

--- Q1: Delete duplicate data --- 

drop table if exists cars;
create table cars
(
	model_id		int primary key,
	model_name		varchar(100),
	color			varchar(100),
	brand			varchar(100)
);
insert into cars values(1,'Leaf', 'Black', 'Nissan');
insert into cars values(2,'Leaf', 'Black', 'Nissan');
insert into cars values(3,'Model S', 'Black', 'Tesla');
insert into cars values(4,'Model X', 'White', 'Tesla');
insert into cars values(5,'Ioniq 5', 'Black', 'Hyundai');
insert into cars values(6,'Ioniq 5', 'Black', 'Hyundai');
insert into cars values(7,'Ioniq 6', 'White', 'Hyundai');

select * from cars;


---------My solution 


Select * from 
(select *,row_number() over(partition by brand, color, model_name order by model_id) as rn from cars)
tb
where rn=1
order by model_id


select * from cars where model_id in (Select min(model_id) m_id from cars group by brand, color, model_name)



