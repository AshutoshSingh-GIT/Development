-- Source --> https://www.youtube.com/watch?v=ZML_EJrBhnY

--- Q5 : Ungroup the given input data --- 

drop table travel_items;
create table travel_items
(
	id              int,
	item_name       varchar(50),
	total_count     int
);
insert into travel_items values (1, 'Water Bottle', 2);
insert into travel_items values (2, 'Tent', 1);
insert into travel_items values (3, 'Apple', 4);


select * from travel_items;

---solution ******************important*******************

with recursive cte as (
select id,item_name,total_count, 1 as level from travel_items
Union all
Select cte.id,cte.item_name,cte.total_count-1,level+1 as level
from cte
inner join travel_items ti
on ti.id=cte.id
and ti.item_name=cte.item_name
	where cte.total_count>1
)
select * from cte
order by item_name,level