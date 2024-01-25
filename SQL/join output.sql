CREATE TABLE Employee1(
 Empid int NOT NULL,
 EmpName varchar(50) NOT NULL
);

CREATE TABLE Employee2(
 Empid int NOT NULL,
 EmpName varchar(50) NOT NULL
);

truncate table Employee1

INSERT INTO Employee1
           (Empid,EmpName)
     VALUES
     (1,'smith'),
	 (1,'jay'),
	 (2,'Ashutosh'),
	 (3,'Asf'),
	 (4,'qw'),
	 (4,'ashk')

INSERT INTO Employee2
           (Empid,EmpName)
     VALUES
     (1,'dfg'),
	 (2,'as'),
	 (2,'ashk'),
	 (2,'gjdj'),
	 (2,'dvhdv'),
	 (3,'yrh'),
	 (3,'qhjfw')
	
	select A.Empid, A.EmpName, B.Empid, B.EmpName 
	from Employee1 A Left JOIN Employee2 B on 
	A.Empid=B.Empid;
	
	select A.Empid, A.EmpName, B.Empid, B.EmpName 
	from Employee1 A Right JOIN Employee2 B on 
	A.Empid=B.Empid;
	
	select A.Empid, A.EmpName, B.Empid, B.EmpName 
	from Employee1 A Inner JOIN Employee2 B on 
	A.Empid=B.Empid;
	
	select A.Empid, A.EmpName, B.Empid, B.EmpName 
	from Employee1 A inner JOIN Employee1 B on 
	A.Empid=B.Empid;