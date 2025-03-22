SELECT lname, fname,
residence, count(*) FROM
CUSTOMER c GROUP BY
RESIDENCE, LNAME, FNAME
order by count(*) desc, lname, fname, residence;

SELECT lname, fname, count(*) FROM
CUSTOMER c GROUP BY LNAME, FNAME
order by count(*), lname, fname;

SELECT lname, fname, count(*) FROM
CUSTOMER c GROUP BY LNAME, FNAME
order by count(*) desc, lname, fname;

SELECT lname, residence, count(*) FROM
CUSTOMER c GROUP BY
RESIDENCE, LNAME
order by count(*), lname, residence;

SELECT lname, residence, count(*) FROM
CUSTOMER c GROUP BY
RESIDENCE, LNAME
order by count(*) desc, lname, residence;

set statistics time on;
set statistics time off;
set statistics io on;
set statistics io off;
SET SHOWPLAN_ALL ON
	SELECT * FROM
	CUSTOMER c Where lname = 'Nováková' and fname = 'Lenka'
	option (maxdop 1);
SET SHOWPLAN_ALL OFF

CREATE INDEX customer_name_res ON Customer (lname, fname, residence);

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

exec PrintPagesIndex 'CUSTOMER_NAME_RES'
exec PrintPagesIndex 'PK__Customer__D0587687F0CB9B2B'


select i.name, s.index_depth - 1 as height, sum(s.page_count) as page_count 
from sys.dm_db_index_physical_stats(DB_ID(N'dub0074'), OBJECT_ID(N'Customer'), NULL, NULL , 'DETAILED') s
join sys.indexes i on s.object_id=i.object_id and s.index_id=i.index_id
group by i.name, s.index_depth

select s.index_level as level, s.page_count, s.record_count, 
  s.avg_record_size_in_bytes as avg_record_size,
  round(s.avg_page_space_used_in_percent,1) as page_utilization, 
  round(s.avg_fragmentation_in_percent,2) as avg_frag
from sys.dm_db_index_physical_stats(DB_ID(N'dub0074'), OBJECT_ID(N'Customer'), NULL, NULL , 'DETAILED') s
join sys.indexes i on s.object_id=i.object_id and s.index_id=i.index_id