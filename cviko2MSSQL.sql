
-- Názvy indexu
SELECT t.name AS TableName, i.name AS IndexName, c.name AS ColumnName
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.is_primary_key = 1;

-- Získání velikosti indexu
SELECT i.name AS IndexName, 
       SUM(a.total_pages) * 8 / 1024 AS SizeMB
FROM sys.indexes i
JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE i.is_primary_key = 1
GROUP BY i.name;

-- Získání velikosti tabulek v heapu
SELECT 
    t.name AS TableName, 
    SUM(a.total_pages) * 8 / 1024 AS HeapSizeMB
FROM sys.tables t
JOIN sys.partitions p ON t.object_id = p.object_id
JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE p.index_id IN (0,1)  -- 0 = heap, 1 = clustered index
GROUP BY t.name;

-- B strom
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    p.index_depth AS TreeHeight,
    p.page_count AS TotalPages,
    p.record_count AS RecordCount
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') p
JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
WHERE i.is_primary_key = 1;

SELECT 
    i.name AS IndexName, 
    SUM(a.total_pages) * 8 / 1024 AS SizeMB,
    SUM(a.used_pages) * 8 / 1024 AS UsedMB
FROM sys.indexes i
JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE i.is_primary_key = 1
GROUP BY i.name;


SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    SUM(s.avg_record_size_in_bytes) / COUNT(*) AS AvgRecordSize
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') s
JOIN sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
WHERE i.is_primary_key = 1
GROUP BY i.object_id, i.name;

SET STATISTICS IO ON;
SELECT * FROM OrderItem WHERE idOrder = 123;



SELECT * FROM OrderItem WHERE idOrder BETWEEN 1000 AND 2000;

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

exec PrintPagesIndex PK__OrderIte__CD44316346565EB0

-- Optimizace indexu 
SELECT 
    i.name AS IndexName,
    OBJECT_NAME(i.object_id) AS TableName,
    p.index_type_desc AS IndexType,
    p.index_depth AS TreeHeight,
    p.page_count AS TotalPages,
    p.record_count AS RecordCount,
    (p.avg_page_space_used_in_percent) AS PageUtilization
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') p
JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
WHERE p.avg_page_space_used_in_percent < 70  -- Filtrujeme indexy s nízkým využitím stránek
ORDER BY p.avg_page_space_used_in_percent ASC;

ALTER INDEX PK__OrderIte__CD44316346565EB0 ON OrderItem REORGANIZE;

ALTER INDEX PK__OrderIte__CD44316346565EB0 ON OrderItem REBUILD;

SELECT 
    i.name AS IndexName,
    OBJECT_NAME(i.object_id) AS TableName,
    p.index_type_desc AS IndexType,
    p.index_depth AS TreeHeight,
    p.page_count AS TotalPages,
    p.record_count AS RecordCount,
    (p.avg_page_space_used_in_percent) AS PageUtilization
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') p
JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
WHERE i.name = 'PK__OrderIte__CD44316346565EB0';  -- Název optimalizovaného indexu
