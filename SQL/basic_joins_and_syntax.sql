select * from leftTable
select * from righttable


insert into leftTable(ID, NAME)
VALUES (1,'a'),(2,'b'),(2,'c'),(2,'d');

insert into RightTable(ID, dept)
VALUES (1,'csc'),(2,'civil'),(3,'IT'),(2,'EE');

--Inner join
select * from
LeftTable T1, rightTable T2
WHERE T1.ID=t2.id


select * from 
LeftTable t1
inner join RightTable  t2
on t1.id=t2.id


select * from 
LeftTable t1
join RightTable  t2
on t1.id=t2.id


-- Left Join
select * from 
LeftTable t1
left join RightTable  t2
on t1.id=t2.id


-- Right Join
select * from 
LeftTable t1
Right join RightTable  t2
on t1.id=t2.id


--full join
select * from 
LeftTable t1
 full join RightTable  t2
on t1.id=t2.id


-- Self join
select * from 
LeftTable t1
 join leftTable  t2
on t1.id=t2.id


-- cross join/cartesian join
select * from 
LeftTable t1
cross join leftTable t2



