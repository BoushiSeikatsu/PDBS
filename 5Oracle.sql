select blocks from user_segments 
where segment_name = 'CUSTOMERHEAP';
-- 16640

select index_name from user_indexes 
where table_name='CUSTOMER';
-- SYS_IOT_TOP_645742

select blocks from user_segments 
where segment_name = 'SYS_IOT_TOP_323862';
-- 16384

alter table Customer shrink space;

-- ProductOrderDb, A database for Physical Database Design
-- Oracle Version
--
-- Michal Kratky, Radim Baca
-- dbedu@cs.vsb.cz, 2023-2024
-- last update: 2025-02-14

drop table CustomerHeap

create table CustomerHeap (
  idCustomer int primary key,
  fName varchar(20) not null,
  lName varchar(30) not null,
  residence varchar(20) not null,
  gender char(1) not null,
  birthday date not null
);

insert into CustomerHeap select * from ProductOrder.Customer;
insert into Product select * from ProductOrder.Product;
insert into Store select * from ProductOrder.Store;
insert into Staff select * from ProductOrder.Staff;
insert into "Order" select * from ProductOrder."Order";
insert into OrderItem select * from ProductOrder.OrderItem;
commit;

select * from Customer

exec PrintPages_unused_space('CUSTOMER','DUB0074', 'TABLE');

alter table OrderItem shrink space;

select blocks from user_segments 
where segment_name = 'SYS_IOT_TOP_645742';
-- 16384


EXPLAIN plan for 
select * from CustomerHeap where idCustomer between 1000 and 2000;
select * from table(dbms_xplan.display);

set FEEDBACK ON SQL_ID;

select * from CustomerHeap where idCustomer between 1000 and 2000;

set FEEDBACK OFF SQL_ID;

exec PRINTQUERYSTAT('b1gwn5wbma1dh',2902097167);

exec PRINTQUERYSTAT('8gn6v0wbx5jnd',3676540013);

explain plan for
SELECT * FROM
CUSTOMER c where lname = 'Pospíšilová' and fname='Jana' and RESIDENCE = 'Jihlava';
select * from table(dbms_xplan.display);

set feedback on SQL_ID;
SELECT * FROM
CUSTOMER c where lname = 'Pospíšilová' and fname='Jana' and RESIDENCE = 'Jihlava';
set feedback off SQL_ID;
exec PrintQueryStat('7g5hs78t6tdvt', 2774043550);
exec PrintQueryStat('965g9115w3780', 929437095);
CREATE INDEX customer_name_resHeap ON CustomerHeap(lname, fname, residence);

select * from sys.dm_exec_query_stats