	SELECT oi.*, p.*, o.* -- Nebo vyjmenovat potřebné sloupce
	FROM OrderItem oi
	JOIN Product p ON oi.idProduct = p.idProduct
	JOIN [Order] o ON oi.idOrder = o.idOrder -- [Order] je nutné kvůli klíčovému slovu ORDER
	WHERE p.Name LIKE 'Auto%'
	  -- AND YEAR(o.OrderDate) = 2022 -- Původní, NENÍ SARGable
	  AND o.order_datetime >= '2022-01-01' AND o.order_datetime < '2023-01-01' -- SARGable verze
	  AND oi.unit_price BETWEEN 1000000 AND 1010000
	  option (maxdop 1);

  set statistics io on;
set statistics io off;
set showplan_all on;
set showplan_text off

select top 1000 * from sys.dm_exec_query_stats order by last_execution_time desc

SELECT qs.execution_count,
 SUBSTRING(qt.text,qs.statement_start_offset/2 +1,
                 (CASE WHEN qs.statement_end_offset = -1
                       THEN LEN(CONVERT(nvarchar(max), qt.text)) * 2
                       ELSE qs.statement_end_offset end -
                            qs.statement_start_offset
                 )/2
             ) AS query_text,
qs.total_worker_time/qs.execution_count AS avg_cpu_time, qp.dbid, qt.text
--   qs.plan_handle, qp.query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) as qp
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
where qp.dbid=DB_ID() and qs.execution_count > 10
--  and query_text LIKE '%SELECT * FROM [OrderItem]%'
ORDER BY avg_cpu_time DESC;

DROP INDEX IF EXISTS IX_OrderItem_Price ON OrderItem;
 DROP INDEX IF EXISTS IX_OrderItem_idProduct ON OrderItem;
 DROP INDEX IF EXISTS IX_OrderItem_idOrder ON OrderItem;

CREATE NONCLUSTERED INDEX IX_OrderItem_Covering_Agg
    ON OrderItem(unit_price, idProduct, idOrder) -- Klíče pro seek a join
    INCLUDE (quantity); -- Sloupec pro agregaci


SELECT CAST(SUM(CASE WHEN UNIT_PRICE BETWEEN 20000000 AND 20002000 THEN 1 ELSE 0 END) AS DECIMAL(18, 10))/
    -- Denominator: Total rows in the Product table (handle potential division by zero)
    NULLIF(CAST(COUNT(*) AS DECIMAL(18, 10)), 0)
AS FilterSelectivity
FROM
    Product;

select * from OrderItem oi inner join Product p on p.IDPRODUCT = oi.IDPRODUCT where p.UNIT_PRICE BETWEEN 20000000 AND 20002000 AND 1=1;

SELECT CAST(SUM(CASE WHEN o.order_datetime >= '2022-01-01' AND o.order_datetime < '2023-01-01' THEN 1 ELSE 0 END) AS DECIMAL(18, 10))/
    -- Denominator: Total rows in the Product table (handle potential division by zero)
    NULLIF(CAST(COUNT(*) AS DECIMAL(18, 10)), 0)
AS FilterSelectivity
FROM
    [Order] o;

SELECT CAST(SUM(CASE WHEN p.Name LIKE 'Auto%' THEN 1 ELSE 0 END) AS DECIMAL(18, 10))/
    -- Denominator: Total rows in the Product table (handle potential division by zero)
    NULLIF(CAST(COUNT(*) AS DECIMAL(18, 10)), 0)
AS FilterSelectivity
FROM
    Product p;

-- Původní dotaz (s možnou úpravou filtru data pro SARGability)
SELECT count(*), SUM(oi.quantity) 
FROM OrderItem oi
JOIN Product p ON oi.idProduct = p.idProduct
JOIN [Order] o ON oi.idOrder = o.idOrder
WHERE p.Name LIKE 'Auto%'
  -- AND YEAR(o.OrderDate) = 2022 -- Původní, NENÍ SARGable
  AND o.order_datetime >= '2022-01-01' AND o.order_datetime < '2023-01-01' -- SARGable verze
  AND oi.unit_price BETWEEN 1000000 AND 1010000
  option (maxdop 1);

  -- Pro Product.Name
CREATE NONCLUSTERED INDEX IX_Product_Name ON Product(Name);

-- Pro Order.OrderDate (nutno použít SARGable podmínku v dotazu!)
CREATE NONCLUSTERED INDEX IX_Order_OrderDate ON [Order](order_datetime);

-- Pro OrderItem.Price
CREATE NONCLUSTERED INDEX IX_OrderItem_Price ON OrderItem(unit_price);

-- Pro spojení OrderItem -> Product
CREATE NONCLUSTERED INDEX IX_OrderItem_idProduct ON OrderItem(idProduct);

-- Pro spojení OrderItem -> Order
CREATE NONCLUSTERED INDEX IX_OrderItem_idOrder ON OrderItem(idOrder);