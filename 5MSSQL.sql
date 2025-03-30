exec PrintPagesHeap 'CustomerHeap';
create or alter procedure PrintPagesClusterTable 
  @tableName varchar(30)
as
  exec PrintPages @tableName, 1

create or alter procedure PrintPagesIndex @indexName varchar(30)
as
  select 
    i.name as IndexName,
    p.rows as ItemCounts,
    sum(a.total_pages) as TotalPages, 
    round(cast(sum(a.total_pages) * 8 as float) / 1024, 1) 
      as TotalPages_MB, 
    sum(a.used_pages) as UsedPages,
    round(cast(sum(a.used_pages) * 8 as float) / 1024, 1) 
      as UsedPages_MB
  from sys.indexes i
  inner join sys.partitions p on i.object_id = p.OBJECT_ID and i.index_id = p.index_id
  inner join sys.allocation_units a on p.partition_id = a.container_id
  where i.name = @indexName
  group by i.name, p.Rows
  order by i.name
go

drop table IF EXISTS OrderItem
drop table IF EXISTS "Order"
drop table IF EXISTS Staff
drop table IF EXISTS Store
drop table IF EXISTS Product
drop table IF EXISTS Customer

create table CustomerHeap (
  idCustomer int primary key nonclustered,
  fName varchar(20) not null,
  lName varchar(30) not null,
  residence varchar(20) not null,
  gender char(1) not null,
  birthday date not null
);

exec PrintPagesIndex 'CUSTOMERHEAP'

insert into CustomerHeap select * from ProductOrder.dbo.Customer;
insert into Product select * from ProductOrder.dbo.Product;
insert into Store select * from ProductOrder.dbo.Store;
insert into Staff select * from ProductOrder.dbo.Staff;
insert into "Order" select * from ProductOrder.dbo."Order";
insert into OrderItem select * from ProductOrder.dbo.OrderItem;

create clustered index Customer on Customer(idCustomer);

exec PrintPagesClusterTable 'Customer';

exec PrintPagesHeap 'Customer';

alter table Customer rebuild;

--------------------------------

drop table Customer

create

SELECT 
t.NAME AS TableName, i.name, i.type_desc, p.rows AS RowCounts,
a.total_pages AS TotalPages, a.used_pages AS UsedPages
FROM sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND 
    i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.NAME = 'Customer' and p.index_id > 1

select i.name, s.index_level as level, s.page_count, s.record_count, 
  s.avg_record_size_in_bytes as avg_record_size,
  round(s.avg_page_space_used_in_percent,1) as page_utilization, 
  round(s.avg_fragmentation_in_percent,2) as avg_frag
from sys.dm_db_index_physical_stats(DB_ID(N'dub0074'), OBJECT_ID(N'Customer'), NULL, NULL , 'DETAILED') s
join sys.indexes i on s.object_id=i.object_id and s.index_id=i.index_id

select * from Customer where idCustomer between 1000 and 2000;

SELECT * FROM
Customer c where lname = 'Pospíšilová' and fname='Jana' and RESIDENCE = 'Jihlava'
option (maxdop 1);

set statistics time on;
set statistics time off;
set statistics io on;
set statistics io off;
set showplan_all on;
set showplan_all off;

CREATE INDEX customer_name_res ON CustomerHeap (lname, fname, residence);