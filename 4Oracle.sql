SELECT lname, fname,
residence, count(*) FROM
CUSTOMER c GROUP BY
RESIDENCE, LNAME, FNAME
order by count(*), lname, fname, residence;

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

explain plan for
SELECT * FROM
CUSTOMER c where lname = 'Pospíšilová' and fname='Jana' and RESIDENCE = 'Jihlava';
select * from table(dbms_xplan.display);

set feedback on SQL_ID;
SELECT * FROM
CUSTOMER c where lname = 'Pospíšilová' and fname='Jana' and RESIDENCE = 'Jihlava';
set feedback off SQL_ID;
exec PrintQueryStat('7g5hs78t6tdvt', 2844954298);
exec PrintQueryStat('7g5hs78t6tdvt', 3304523282);

drop INDEX customer_name_res

set feedback on SQL_ID;
CREATE INDEX customer_name_res ON customer(LNAME, FNAME, RESIDENCE);
set feedback off SQL_ID;

SELECT
    *
FROM
    v$sql
WHERE
    sql_text LIKE '%customer_name_res%' and PARSING_SCHEMA_NAME = 'DUB0074'

create or replace procedure PrintPages_unused_space(p_table_name varchar, p_user_name varchar, p_type varchar)
as
   free_blocks number;
   blocks      number;
   bytes       number;
   unused_blocks    number;
   unused_bytes     number;
   expired_blocks   number;
   expired_bytes    number;
   unexpired_blocks number;
   unexpired_bytes  number;
   mega number := 1024.0 * 1024.0;
begin
  -- dbms_space.free_blocks(p_user_name, p_table_name, p_type, 0, free_blocks);
  dbms_space.unused_space(p_user_name, p_table_name, p_type, blocks, bytes, unused_blocks, 
    unused_bytes, expired_blocks, expired_bytes, unexpired_blocks, unexpired_bytes);
    
  dbms_output.put_line('blocks:        ' || blocks || ',' || CHR(9) || ' size (MB): ' || (bytes / mega));
  -- dbms_output.put_line('free blocks:        ' || free_blocks || ',' || CHR(9) || ' size (MB): ' || ((free_blocks * 8192) / mega));
  dbms_output.put_line('used_blocks:   ' || (blocks - unused_blocks) ||  ',' || CHR(9) ||  ' size (MB): ' || ((bytes / mega) - (unused_bytes / mega)));
  dbms_output.put_line('unused_blocks: ' || unused_blocks ||  ',' || CHR(9) || ' size (MB): ' || (unused_bytes / mega));
  dbms_output.put_line('expired_blocks: ' || expired_blocks ||  ',' || CHR(9) || ' unexpired_blocks: ' || unexpired_blocks);
end;

exec PrintPages_unused_space('CUSTOMER_NAME_RES', 'DUB0074', 'INDEX')
exec PrintPages_unused_space('IDX_CUSTOMER_LNAME', 'DUB0074', 'INDEX')
exec PrintPages_unused_space('SYS_C0021346', 'DUB0074', 'INDEX')

select index_name, blevel, leaf_blocks
from user_indexes where table_name='CUSTOMER';

explain plan for
SELECT * FROM
CUSTOMER c where lname = 'Pospíšilová' and fname='Alena';
select * from table(dbms_xplan.display);

set feedback on SQL_ID;
SELECT * FROM
CUSTOMER c where lname = 'Pospíšilová' and fname='Alena';
set feedback off SQL_ID;

exec PrintQueryStat('7yantcff8pq8v', 2844954298);

explain plan for
SELECT * FROM
CUSTOMER c where lname = 'Kučerová' and fname='Lucie"';
select * from table(dbms_xplan.display);

set feedback on SQL_ID;
SELECT * FROM
CUSTOMER c where lname = 'Kučerová' and fname='Lucie';
set feedback off SQL_ID;

exec PrintQueryStat('24nsfqp08fmyg', 2844954298);