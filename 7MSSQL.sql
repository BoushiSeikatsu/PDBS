-- #### 8.1 Stránkování výsledku dotazu
SELECT count(*) FROM Customer;
set statistics io on;
set statistics time on;
set statistics io off;
set statistics time off;

-- Full
SELECT * FROM Customer where idCustomer % 5 = 0
option (maxdop 1);
-- 'Customer'. Scan count 1, logical reads 1750
-- CPU time = 78 ms,  elapsed time = 1077 ms.
-- 300,000 rows retrieved starting from 1 in 2 s 571 ms (execution: 26 ms, fetching: 2 s 545 ms)

-- First page
SELECT *
FROM Customer where idCustomer % 5 = 0
ORDER BY idCustomer
OFFSET 0 ROWS FETCH NEXT 100 ROWS ONLY
option (maxdop 1);
-- 'Customer'. Scan count 1, logical reads 103
-- CPU time = 0 ms,  elapsed time = 0 ms.
-- 100 rows retrieved starting from 1 in 255 ms (execution: 23 ms, fetching: 232 ms)

-- Last page
SELECT *
FROM Customer where idCustomer % 5 = 0
ORDER BY idCustomer
OFFSET 59900 ROWS FETCH NEXT 100 ROWS ONLY
option (maxdop 1);
-- 'Customer'. Scan count 1, logical reads 1750
-- CPU time = 187 ms, elapsed time = 172 ms.
-- 100 rows retrieved starting from 1 in 513 ms (execution: 266 ms, fetching: 247 ms)

-- Transferred bytes
EXEC sp_spaceused 'Customer';
-- 14336000 bytes full
-- 4779 bytes paged




-- #### 8.2 Komprimace tabulek a indexů
-- 1. Převeďte tabulku OrderItem na shlukovanou tabulku, resp. vytvořte shlukovanou tabulku OrderItem_ct
-- Pro komprimaci none, row a page proveďte úkoly 2 - 4 a výsledky porovnejte
CREATE TABLE OrderItem_ct_none (
    idOrder INT NOT NULL REFERENCES "Order"(idOrder),
    idProduct INT NOT NULL REFERENCES Product(idProduct),
    unit_price BIGINT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY CLUSTERED (idOrder, idProduct)
)
WITH (DATA_COMPRESSION = NONE);
INSERT INTO OrderItem_ct_none (idOrder, idProduct, unit_price, quantity)
SELECT idOrder, idProduct, unit_price, quantity FROM OrderItem;
exec PrintPagesClusterTable OrderItem_ct_none
-- Total Pages: 18033

CREATE TABLE OrderItem_ct_row (
    idOrder INT NOT NULL REFERENCES "Order"(idOrder),
    idProduct INT NOT NULL REFERENCES Product(idProduct),
    unit_price BIGINT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY CLUSTERED (idOrder, idProduct)
)
WITH (DATA_COMPRESSION = ROW);
INSERT INTO OrderItem_ct_row (idOrder, idProduct, unit_price, quantity)
SELECT idOrder, idProduct, unit_price, quantity FROM OrderItem;
exec PrintPagesClusterTable OrderItem_ct_row
-- Total Pages: 9497

CREATE TABLE OrderItem_ct_page (
    idOrder INT NOT NULL REFERENCES "Order"(idOrder),
    idProduct INT NOT NULL REFERENCES Product(idProduct),
    unit_price BIGINT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY CLUSTERED (idOrder, idProduct)
)
WITH (DATA_COMPRESSION = PAGE);
INSERT INTO OrderItem_ct_page (idOrder, idProduct, unit_price, quantity)
SELECT idOrder, idProduct, unit_price, quantity FROM OrderItem;
exec PrintPagesClusterTable OrderItem_ct_page
-- Total Pages: 8545

-- Query 1
SELECT idOrder, idProduct, unit_price, quantity
FROM OrderItem
WHERE unit_price = 11000 or unit_price = 11001
-- None
SELECT idOrder, idProduct, unit_price, quantity
FROM OrderItem_ct_none
WHERE unit_price = 11000 or unit_price = 110011
option (maxdop 1);
-- CPU Time: 7.6 ms
-- Elapsed Time = 6 ms
-- Logical reads: 113

-- Row
SELECT idOrder, idProduct, unit_price, quantity
FROM OrderItem_ct_row
WHERE unit_price = 11000 or unit_price = 11001
option (maxdop 1);
-- CPU Time: 9.6 ms
-- Elapsed Time = 9 ms
-- Logical reads: 58

-- Page
SELECT idOrder, idProduct, unit_price, quantity
FROM OrderItem
WHERE unit_price = 11000 or unit_price = 11001
option (maxdop 1);
-- CPU Time: 11.6 ms
-- Elapsed Time = 11 ms
-- Logical reads: 57


-- Query 2
SELECT unit_price, idOrder, idProduct, quantity
FROM OrderItem
WHERE unit_price BETWEEN 1000000 AND 1000200;
-- None
SELECT unit_price, idOrder, idProduct, quantity
FROM OrderItem_ct_none
WHERE unit_price BETWEEN 1000000 AND 1000200 AND 53252 = 53252
option (maxdop 1);
-- CPU Time: 269 ms
-- Elapsed Time = 268 ms
-- Logical reads: 18007

-- Row
SELECT unit_price, idOrder, idProduct, quantity
FROM OrderItem_ct_row
WHERE unit_price BETWEEN 1000000 AND 1000200 AND 53253 = 53253
option (maxdop 1);
-- CPU Time: 417 ms
-- Elapsed Time = 415 ms
-- Logical reads: 9476

-- Page
SELECT unit_price, idOrder, idProduct, quantity
FROM OrderItem_ct_page
WHERE unit_price BETWEEN 1000000 AND 1000200 AND 53254 = 53254
option (maxdop 1);
-- CPU Time: 490 ms
-- Elapsed Time = 490 ms
-- Logical reads: 8528
