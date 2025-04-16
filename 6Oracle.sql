SELECT *
FROM OrderItem oi
INNER JOIN Product p ON oi.idProduct = p.idProduct
WHERE p.unit_price BETWEEN 20000000 AND 20002000;

select * from Product WHERE unit_price BETWEEN 20000000 AND 20002000 and 1=1;



explain plan for
select * from OrderItem oi inner join Product p on p.IDPRODUCT = oi.IDPRODUCT where p.UNIT_PRICE BETWEEN 20000000 AND 20002000 AND 1=1;
select * from table(dbms_xplan.display);
set feedback on SQL_ID;
select * from OrderItem oi inner join Product p on p.IDPRODUCT = oi.IDPRODUCT where p.UNIT_PRICE BETWEEN 20000000 AND 20002000 AND 1=1;
set feedback off SQL_ID;
exec PrintQueryStat('bhg4xs5cy0gzg', 862617916);

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE sql_text LIKE '%AND 1=1%'
ORDER BY last_active_time DESC;

select * from OrderItem oi inner join Product p on p.IDPRODUCT = oi.IDPRODUCT where p.UNIT_PRICE BETWEEN 4000000 AND 20000000 AND 1=1;

CREATE INDEX IX_Product_price ON Product(unit_price);
CREATE INDEX IX_OrderItem_idProduct ON OrderItem(idProduct);
CREATE INDEX IX_OrderItem_idProd_inc_qty ON OrderItem(idProduct, quantity);

select index_name from user_indexes 
where table_name='PRODUCT';

BEGIN
  -- Pro tabulku PRODUCT a její indexy (včetně nového na UNIT_PRICE)
  DBMS_STATS.GATHER_TABLE_STATS(ownname => DUB0074, -- Nebo jméno vašeho schématu
                                tabname => 'PRODUCT'); -- cascade=>TRUE zajistí i statistiky pro indexy

  -- Pro tabulku ORDERITEM a její indexy (včetně nového na IDPRODUCT)
  DBMS_STATS.GATHER_TABLE_STATS(ownname => DUB0074, -- Nebo jméno vašeho schématu
                                tabname => 'ORDERITEM');
END;

SELECT COUNT(oi.IDORDER), SUM(oi.quantity)
FROM OrderItem oi
INNER JOIN Product p ON oi.idProduct = p.idProduct
WHERE p.UNIT_price BETWEEN 20000000 AND 20002000;

drop index IX_OrderItem_idProduct

explain plan for
SELECT COUNT(oi.IDORDER), SUM(oi.quantity)
FROM OrderItem oi
INNER JOIN Product p ON oi.idProduct = p.idProduct
WHERE p.UNIT_price BETWEEN 20000000 AND 20002000;
select * from table(dbms_xplan.display);
set feedback on SQL_ID;
SELECT COUNT(oi.IDORDER), SUM(oi.quantity)
FROM OrderItem oi
INNER JOIN Product p ON oi.idProduct = p.idProduct
WHERE p.UNIT_price BETWEEN 20000000 AND 20002000;
set feedback off SQL_ID;
exec PrintQueryStat('ca5rm4rhdtzh6', 2921254681);

delete from OrderItem;
insert into OrderItem select * from ProductOrder.OrderItem;

delete from "Order"