SET SHOWPLAN_ALL ON
SELECT * FROM OrderItem oi WHERE oi.unit_price > 2189000000;
SET SHOWPLAN_ALL OFF

SELECT count(*) FROM OrderItem oi;

SET STATISTICS IO ON
SELECT * FROM OrderItem oi WHERE oi.unit_price > 2189000000;
SET STATISTICS IO OFF

SET STATISTICS TIME ON
SELECT * FROM OrderItem oi WHERE oi.unit_price > 2187000000;
SET STATISTICS TIME OFF

SET SHOWPLAN_ALL ON
SELECT * FROM OrderItem oi WHERE oi.unit_price > 2187000000 OPTION (MAXDOP 1);
SET SHOWPLAN_ALL OFFcreate or alter procedure PrintPages @tableName varchar(30), @indexId int
AS
  SELECT 
    t.NAME AS TableName,
    p.rows AS RowCounts,
    SUM(a.total_pages) AS TotalPages, 
    round(cast(SUM(a.total_pages) * 8 as float) / 1024, 1) AS TotalPages_MB, 
    SUM(a.used_pages) AS UsedPages,
    round(cast(SUM(a.used_pages) * 8 as float) / 1024, 1) AS UsedPages_MB
  FROM sys.tables t
    INNER JOIN      
      sys.indexes i ON t.OBJECT_ID = i.object_id
    INNER JOIN 
      sys.partitions p ON i.object_id = p.OBJECT_ID AND 
      i.index_id = p.index_id
    INNER JOIN 
      sys.allocation_units a ON p.partition_id = a.container_id
  WHERE t.NAME = @tableName and p.index_id = @indexId
  GROUP BY t.Name, p.Rows
  ORDER BY t.Name
go

create or alter procedure PrintPagesHeap @tableName varchar(30)
as
  exec PrintPages @tableName, 0
goexec PrintPagesHeap 'ORDERITEM'exec PrintPages 'ORDERITEM', 0DELETE FROM OrderItem WHERE idOrder % 2 = 0ALTER table ORDERITEM REBUILD;