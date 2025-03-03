-- ProductOrderDb, A database for Physical Database Design
-- Oracle Version
--
-- Michal Kratky, Radim Baca
-- dbedu@cs.vsb.cz, 2023-2024
-- last update: 2025-02-14
-- QOa45YWxvRsRaMdj
select count(*) from Customer;
select blocks from user_segments where segment_name = 'CUSTOMER';

select count(*) from ORDERITEM;
select blocks from user_segments where segment_name = 'ORDERITEM';

select count(*) from "Order";
select segment_name, blocks from user_segments where segment_name = 'ORDER';

select count(*) from PRODUCT;
select blocks from user_segments where segment_name = 'PRODUCT';

select count(*) from STAFF;
select blocks from user_segments where segment_name = 'STAFF';

select count(*) from STORE;
select blocks from user_segments where segment_name = 'STORE';

select blocks , bytes/1024/1024 as MB
from user_segments;

select blocks from user_segments 
  where segment_name = 'CUSTOMER';

select blocks, bytes/1024/1024 as MB from user_segments
 where segment_name = 'CUSTOMER';

select segment_type, sum(blocks) "Total Blocks", sum(bytes/1024/1024) "MB"
from user_segments
where segment_name in ('CUSTOMER', 'STAFF', 'Order', 'ORDERITEM', 'PRODUCT', 'STORE')
group by segment_type;

select table_name,blocks, empty_blocks,pct_free,pct_used from user_tables 
where table_name='CUSTOMER';

create or replace procedure PrintPages(p_table_name varchar, p_user_name varchar)
as
   blocks           number;
   bytes            number;
   unused_blocks    number;
   unused_bytes     number;
   expired_blocks   number;
   expired_bytes    number;
   unexpired_blocks number;
   unexpired_bytes  number;
   mega number := 1024.0 * 1024.0;
begin 
  dbms_space.unused_space(p_user_name, p_table_name, 'TABLE', blocks, bytes, unused_blocks, 
    unused_bytes, expired_blocks, expired_bytes, unexpired_blocks, unexpired_bytes);
    
  dbms_output.put_line('blocks: ' || blocks);
  dbms_output.put_line('size (MB): ' || (bytes / mega));
  dbms_output.put_line('used_blocks: ' || (blocks - unused_blocks));
  dbms_output.put_line('size used (MB): ' || ((bytes / mega) - (unused_bytes / mega)));
  dbms_output.put_line('unused_blocks: ' || unused_blocks);
  dbms_output.put_line('size unused (MB): ' || (unused_bytes / mega));
end;

DELETE FROM OrderItem;
DELETE FROM "Order"; -- Pokud je "Order" klíčové slovo, použijte uvozovky
COMMIT;

SELECT segment_name, blocks, bytes/1024/1024 AS size_MB
FROM user_segments 
WHERE segment_name IN ('Order', 'ORDERITEM');

ALTER TABLE "Order" ENABLE ROW MOVEMENT;
ALTER TABLE "Order" SHRINK SPACE;

ALTER TABLE OrderItem ENABLE ROW MOVEMENT;
ALTER TABLE OrderItem SHRINK SPACE;

SELECT segment_name, blocks, bytes/1024/1024 AS size_MB
FROM user_segments 
WHERE segment_name IN ('Order', 'ORDERITEM');

EXEC generate_orders;

SELECT COUNT(*) FROM Order;
SELECT COUNT(*) FROM OrderItem;

SELECT segment_name, blocks, bytes/1024/1024 AS size_MB
FROM user_segments 
WHERE segment_name IN ('Order', 'ORDERITEM');

SELECT segment_name, blocks, bytes/1024/1024 AS size_MB
FROM user_segments 
WHERE segment_name = 'CUSTOMER';

ALTER TABLE Customer ENABLE ROW MOVEMENT;
ALTER TABLE Customer SHRINK SPACE;

SELECT segment_name, blocks, blocks - unused_blocks, bytes/1024/1024 AS size_MB
FROM user_segments 
WHERE segment_name = 'CUSTOMER';

    exec PRINTPAGES('CUSTOMER', 'DUB0074')

