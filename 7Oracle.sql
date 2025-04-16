-- #### 8.1 Stránkování výsledku dotazu
SELECT count(*) FROM Customer;

-- Full
SELECT * FROM Customer;
-- IO Cost: 1955
-- CPU Time: 86.5 ms
-- Elapsed Time: 1767 ms
-- Client Time: 4 s 179 ms (execution: 1 s 658 ms, fetching: 2 s 521 ms)

SELECT * FROM Customer WHERE 174 = 174;

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE sql_text LIKE '%174 = 174%'
ORDER BY last_active_time DESC;
-- ga4krmd28t5q3
select executions as executions,
buffer_gets/executions as io_cost,
(cpu_time/executions)/1000.0 as cpu_time_ms,
(elapsed_time/executions)/1000.0 as elapsed_time_ms
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='ga4krmd28t5q3'

-- First page
SELECT *
FROM Customer
ORDER BY idCustomer
OFFSET 0 ROWS FETCH NEXT 100 ROWS ONLY;
-- IO Cost: 3
-- CPU Time: 0 ms
-- Elapsed Time: 0.2 ms
-- Client Time: 289 ms (execution: 25 ms, fetching: 264 ms)

SELECT *
FROM Customer
WHERE 123 = 123
ORDER BY idCustomer
OFFSET 0 ROWS FETCH NEXT 100 ROWS ONLY;

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE sql_text LIKE '%123 = 123%'
ORDER BY last_active_time DESC;
-- b2kp61kj985fu
select executions as executions,
buffer_gets/executions as io_cost,
(cpu_time/executions)/1000.0 as cpu_time_ms,
(elapsed_time/executions)/1000.0 as elapsed_time_ms
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='b2kp61kj985fu'

-- Last page
SELECT *
FROM Customer
ORDER BY idCustomer
OFFSET 299900 ROWS FETCH NEXT 100 ROWS ONLY;
-- IO Cost: 2477
-- CPU Time: 129 ms
-- Elapsed Time: 131 ms
-- Client Time: 425 ms (execution: 169 ms, fetching: 256 ms)

SELECT *
FROM Customer
WHERE 111 = 111
ORDER BY idCustomer
OFFSET 299900 ROWS FETCH NEXT 100 ROWS ONLY;

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE sql_text LIKE '%111 = 111%'
ORDER BY last_active_time DESC;
-- dmns3nutrqgxu
select executions as executions,
buffer_gets/executions as io_cost,
(cpu_time/executions)/1000.0 as cpu_time_ms,
(elapsed_time/executions)/1000.0 as elapsed_time_ms
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='dmns3nutrqgxu'

-- Transferred bytes
SELECT
    SEGMENT_NAME AS TableName,
    BYTES AS TableSizeBytes
FROM DBA_SEGMENTS
WHERE SEGMENT_NAME = 'CUSTOMER' AND OWNER = 'REZ0125';
-- 16777216 bytes full
-- 5593 bytes paged




-- #### 8.3 Sloupcové uložení tabulky
CREATE TABLE OrderItem_Query_Low (
  idOrder INT NOT NULL,
  idProduct INT NOT NULL,
  unit_price INT NOT NULL,
  quantity INT NOT NULL,
  PRIMARY KEY(idOrder, idProduct)
)
INMEMORY MEMCOMPRESS FOR QUERY LOW PRIORITY CRITICAL;

CREATE TABLE OrderItem_Capacity_High (
  idOrder INT NOT NULL,
  idProduct INT NOT NULL,
  unit_price INT NOT NULL,
  quantity INT NOT NULL,
  PRIMARY KEY(idOrder, idProduct)
)
INMEMORY MEMCOMPRESS FOR CAPACITY HIGH PRIORITY CRITICAL;
drop table OrderItem_Capacity_High
INSERT INTO OrderItem_Query_Low SELECT * FROM OrderItem;
INSERT INTO OrderItem_Capacity_High SELECT * FROM OrderItem;

SELECT * FROM OrderItem_Capacity_High
-- Stats Heap
-- Qry 1
set feedback on SQL_ID;
explain plan for
select avg(unit_price) from ORDERITEM;
select * from table(dbms_xplan.display);
set feedback off SQL_ID;
-- --------------------------------------------------------------------------------
-- | Id  | Operation          | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-- --------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT   |           |     1 |     6 |  4475   (2)| 00:00:01 |
-- |   1 |  SORT AGGREGATE    |           |     1 |     6 |            |          |
-- |   2 |   TABLE ACCESS FULL| ORDERITEM |  5000K|    28M|  4475   (2)| 00:00:01 |
-- --------------------------------------------------------------------------------

select avg(unit_price) from ORDERITEM
WHERE 142 = 142;

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE sql_text LIKE '%142 = 142%'
ORDER BY last_active_time DESC;
-- fbjdyxuk9ab31
select executions as executions,
buffer_gets/executions as io_cost,
(cpu_time/executions)/1000.0 as cpu_time_ms,
(elapsed_time/executions)/1000.0 as elapsed_time_ms
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='fbjdyxuk9ab31'
-- IO Cost: 15982
-- CPU Time: 216 ms
-- Elapsed Time: 212 ms


BEGIN
    PrintPages('ORDERITEM_QUERY_LOW', 'DUB0074');
END
;

BEGIN
    PrintPages('ORDERITEM', 'DUB0074');
END
;

-- Qry 2
set feedback on SQL_ID;
explain plan for
select avg(unit_price), quantity from ORDERITEM
group by quantity;
select * from table(dbms_xplan.display);
set feedback off SQL_ID;
-- --------------------------------------------------------------------------------
-- | Id  | Operation          | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-- --------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT   |           |    10 |    90 |  4865  (10)| 00:00:01 |
-- |   1 |  HASH GROUP BY     |           |    10 |    90 |  4865  (10)| 00:00:01 |
-- |   2 |   TABLE ACCESS FULL| ORDERITEM |  5000K|    42M|  4483   (2)| 00:00:01 |
-- --------------------------------------------------------------------------------

select avg(unit_price), quantity from ORDERITEM
WHERE 2345 = 2345
group by quantity;

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE sql_text LIKE '%2345 = 2345%'
ORDER BY last_active_time DESC;
-- gwp1dvtd79gs8
select executions as executions,
buffer_gets/executions as io_cost,
(cpu_time/executions)/1000.0 as cpu_time_ms,
(elapsed_time/executions)/1000.0 as elapsed_time_ms
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='gwp1dvtd79gs8'
-- IO Cost: 15982
-- CPU Time: 475 ms
-- Elapsed Time: 464 ms




-- Column table - query low
-- Force it to INMEM
SELECT table_name, inmemory_compression, inmemory_priority
FROM user_tables
WHERE table_name = 'ORDERITEM_QUERY_LOW';
ALTER TABLE OrderItem_Query_Low INMEMORY PRIORITY CRITICAL;
-- spam this or similar
SELECT /*+ FULL(t) */ COUNT(*) FROM OrderItem_Query_Low t;
-- when this return something it should be inmem
SELECT segment_name,
       ROUND(bytes_not_populated/bytes*100, 2) as pct_not_populated
FROM v$im_segments
WHERE segment_name = 'ORDERITEM_QUERY_LOW';


-- Qry 1
set feedback on SQL_ID;
explain plan for
select avg(unit_price) from OrderItem_Query_Low;
select * from table(dbms_xplan.display);
set feedback off SQL_ID;
-- ---------------------------------------------------------------------------------------------------
-- | Id  | Operation                   | Name                | Rows  | Bytes | Cost (%CPU)| Time     |
-- ---------------------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT            |                     |     1 |    13 |   185   (7)| 00:00:01 |
-- |   1 |  SORT AGGREGATE             |                     |     1 |    13 |            |          |
-- |   2 |   TABLE ACCESS INMEMORY FULL| ORDERITEM_QUERY_LOW |  4798K|    59M|   185   (7)| 00:00:01 |
-- ---------------------------------------------------------------------------------------------------

select avg(unit_price) from OrderItem_Query_Low
WHERE 53453 = 53453;

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE sql_text LIKE '%53453 = 53453%'
ORDER BY last_active_time DESC;
-- 235xqty6u333y
select executions as executions,
buffer_gets/executions as io_cost,
(cpu_time/executions)/1000.0 as cpu_time_ms,
(elapsed_time/executions)/1000.0 as elapsed_time_ms
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='235xqty6u333y'
-- IO Cost: 10
-- CPU Time: 82 ms
-- Elapsed Time: 85.5 ms


-- Qry 2
set feedback on SQL_ID;
explain plan for
select avg(unit_price), quantity from OrderItem_Query_Low
group by quantity;
select * from table(dbms_xplan.display);
set feedback off SQL_ID;
-- ---------------------------------------------------------------------------------------------------
-- | Id  | Operation                   | Name                | Rows  | Bytes | Cost (%CPU)| Time     |
-- ---------------------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT            |                     |  4798K|   118M|   197  (13)| 00:00:01 |
-- |   1 |  HASH GROUP BY              |                     |  4798K|   118M|   197  (13)| 00:00:01 |
-- |   2 |   TABLE ACCESS INMEMORY FULL| ORDERITEM_QUERY_LOW |  4798K|   118M|   196  (12)| 00:00:01 |
-- ---------------------------------------------------------------------------------------------------

select avg(unit_price), quantity from OrderItem_Query_Low
WHERE 42131 = 42131
group by quantity;

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE sql_text LIKE '%42131 = 42131%'
ORDER BY last_active_time DESC;
-- 9xauj4jtv5qsw
select executions as executions,
buffer_gets/executions as io_cost,
(cpu_time/executions)/1000.0 as cpu_time_ms,
(elapsed_time/executions)/1000.0 as elapsed_time_ms
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='9xauj4jtv5qsw'
-- IO Cost: 10
-- CPU Time: 217 ms
-- Elapsed Time: 220 ms



-- Column table - capacity high
-- Force it to INMEM
SELECT table_name, inmemory_compression, inmemory_priority
FROM user_tables
WHERE table_name = 'ORDERITEM_CAPACITY_HIGH';
ALTER TABLE ORDERITEM_CAPACITY_HIGH INMEMORY PRIORITY CRITICAL;
-- spam this or similar
SELECT /*+ FULL(t) */ COUNT(*) FROM ORDERITEM_CAPACITY_HIGH t;
-- when this return something it should be inmem
SELECT segment_name,
       ROUND(bytes_not_populated/bytes*100, 2) as pct_not_populated
FROM v$im_segments
WHERE segment_name = 'ORDERITEM_CAPACITY_HIGH';


-- Qry 1
set feedback on SQL_ID;
explain plan for
select avg(unit_price) from ORDERITEM_CAPACITY_HIGH;
select * from table(dbms_xplan.display);
set feedback off SQL_ID;
-- -------------------------------------------------------------------------------------------------------
-- | Id  | Operation                   | Name                    | Rows  | Bytes | Cost (%CPU)| Time     |
-- -------------------------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT            |                         |     1 |    13 |   213  (23)| 00:00:01 |
-- |   1 |  SORT AGGREGATE             |                         |     1 |    13 |            |          |
-- |   2 |   TABLE ACCESS INMEMORY FULL| ORDERITEM_CAPACITY_HIGH |  4534K|    56M|   213  (23)| 00:00:01 |
-- -------------------------------------------------------------------------------------------------------

select avg(unit_price) from ORDERITEM_CAPACITY_HIGH
WHERE 1235 = 1235;

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE sql_text LIKE '%1235 = 1235%'
ORDER BY last_active_time DESC;
-- 2cnugtdcw2sdg
select executions as executions,
buffer_gets/executions as io_cost,
(cpu_time/executions)/1000.0 as cpu_time_ms,
(elapsed_time/executions)/1000.0 as elapsed_time_ms
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='2cnugtdcw2sdg'
-- IO Cost: 9
-- CPU Time: 168 ms
-- Elapsed Time: 158 ms


-- Qry 2
set feedback on SQL_ID;
explain plan for
select avg(unit_price), quantity from ORDERITEM_CAPACITY_HIGH
group by quantity;
select * from table(dbms_xplan.display);
set feedback off SQL_ID;
-- -------------------------------------------------------------------------------------------------------
-- | Id  | Operation                   | Name                    | Rows  | Bytes | Cost (%CPU)| Time     |
-- -------------------------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT            |                         |  4534K|   112M|   229  (28)| 00:00:01 |
-- |   1 |  HASH GROUP BY              |                         |  4534K|   112M|   229  (28)| 00:00:01 |
-- |   2 |   TABLE ACCESS INMEMORY FULL| ORDERITEM_CAPACITY_HIGH |  4534K|   112M|   228  (28)| 00:00:01 |
-- -------------------------------------------------------------------------------------------------------

select avg(unit_price), quantity from ORDERITEM_CAPACITY_HIGH
WHERE 12444 = 12444
group by quantity;

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE sql_text LIKE '%12444 = 12444%'
ORDER BY last_active_time DESC;
-- bus02mpdsm8mn
select executions as executions,
buffer_gets/executions as io_cost,
(cpu_time/executions)/1000.0 as cpu_time_ms,
(elapsed_time/executions)/1000.0 as elapsed_time_ms
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='bus02mpdsm8mn'
-- IO Cost: 9
-- CPU Time: 254 ms
-- Elapsed Time: 257 ms

-- Table Size Comparison
DELETE FROM SPACE_USAGE_OUTPUT WHERE 1 = 1;
BEGIN
  PrintPages('ORDERITEM', USER);
  PrintPages('ORDERITEM_QUERY_LOW', USER);
  PrintPages('ORDERITEM_CAPACITY_HIGH', USER);
END;
SELECT * FROM SPACE_USAGE_OUTPUT;
-- ORDERITEM (Heap):
    -- Blocks: 16384
    -- Size: 128 MB
-- ORDERITEM_QUERY_LOW
    -- Blocks: 16896
    -- Size: 132 MB
-- ORDERITEM_CAPACITY_HIGH
    -- Blocks: 16256
    -- Size: 127 MB
