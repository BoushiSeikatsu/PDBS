-- 3.1.1
SET AUTOTRACE ON;
set feedback on SQL_ID;
SELECT * FROM OrderItem WHERE unit_price > 2189000000 ;
set feedback off SQL_ID;
SET AUTOTRACE OFF;

select * from "Order";
-- 3.1.2.2
set feedback on SQL_ID;
explain plan for
SELECT * FROM OrderItem WHERE unit_price > 2189000000 ;
select * from table(dbms_xplan.display);
set feedback off SQL_ID;




SELECT substr (lpad('_', level-1) || operation ||
       '_(' || options || ')',1,30 ) "Operation",
       object_name "Object", "COST" "Cost",
       cpu_cost "CPU_Cost"
FROM PLAN_TABLE
START with id = 0
CONNECT by prior id=parent.id;

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

select executions as executions,
 buffer_gets/executions as buffer_gets,
 (cpu_time/executions)/1000.0 as cpu_time_ms,
 (elapsed_time/executions)/1000.0 as elapsed_time_ms,
 rows_processed/executions as rows_processed,
 du.username, sql_text
from v$sql
inner join dba_users du on du.user_id=parsing_user_id
where sql_id='495nagftk4uu1' and plan_hash_value=4294024870;


BEGIN
    PrintPages('ORDERITEM', 'DUB0074');
END
;

select avg(unit_price) from OrderItem;

create or replace procedure PrintQueryStat(p_sqlId varchar2, p_planHash int)
as
begin
  -- report the statistics of the query processing
  for rec in (
    select executions as executions, 
      buffer_gets/executions as buffer_gets, 
      (cpu_time/executions)/1000.0 as cpu_time_ms, 
      (elapsed_time/executions)/1000.0 as elapsed_time_ms, 
      rows_processed/executions as rows_processed, 
      du.username, sql_text 
    from v$sql 
    inner join dba_users du on du.user_id=parsing_user_id
    where sql_id=p_sqlId and plan_hash_value=p_planHash
  )
  loop
    dbms_output.put_line('---- Query Processing Statistics ----');
    dbms_output.put_line('executions: ' || chr(9) || rec.executions);
    dbms_output.put_line('buffer gets: ' || chr(9) || rec.buffer_gets);
    dbms_output.put_line('cpu_time_ms: ' || chr(9) || rec.cpu_time_ms);
    dbms_output.put_line('elapsed_time_ms: ' || chr(9) || rec.elapsed_time_ms);
    dbms_output.put_line('rows_processed: ' || chr(9) || rec.rows_processed);
    dbms_output.put_line('username: ' || chr(9) || rec.username);
    dbms_output.put_line('query: ' || chr(9) || rec.sql_text);
  end loop;
end;

exec PrintQueryStat('495nagftk4uu1', 4294024870);

DELETE FROM OrderItem where MOD( idOrder , 2)=0;

select count(*) from OrderItem;

alter table OrderItem enable row movement;
alter table OrderItem shrink space;
