-- Nazvy indexu
SELECT table_name, index_name, column_name
FROM user_ind_columns
WHERE index_name IN (
    SELECT constraint_name FROM user_constraints WHERE constraint_type = 'P'
);

-- velikost v MB indexu
SELECT segment_name, segment_type, bytes/1024/1024 AS size_mb
FROM user_segments
WHERE segment_type = 'INDEX';

--velikost v MB tabulky v heapu
SELECT segment_name AS table_name, segment_type, bytes/1024/1024 AS size_mb
FROM user_segments
WHERE segment_type = 'TABLE';


--  B strom
SELECT 
    index_name, 
    blevel + 1 AS tree_height, 
    leaf_blocks, 
    num_rows,
    distinct_keys, 
    avg_leaf_blocks_per_key
FROM user_indexes
WHERE index_name IN (
    SELECT constraint_name FROM user_constraints WHERE constraint_type = 'P'
);

-- select * from user_indexes;
SELECT 
    tablespace_name, 
    segment_name, 
    bytes/1024/1024 AS size_mb, 
    blocks, 
    extents
FROM user_segments
WHERE segment_name IN (
    SELECT index_name FROM user_indexes WHERE index_name IN (
        SELECT constraint_name FROM user_constraints WHERE constraint_type = 'P'
    )
);

SELECT 
    table_name, 
    avg_row_len
FROM user_tables
WHERE table_name = 'Order';  -- Změň podle své tabulky

EXPLAIN PLAN FOR 
SELECT * FROM OrderItem WHERE idOrder = 123;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR 
SELECT * FROM OrderItem WHERE idOrder BETWEEN 1000 AND 2000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT * FROM PLAN_TABLE;

EXPLAIN PLAN FOR 
SELECT * FROM OrderItem WHERE idOrder = 123;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());


--drop index idx_customer_lname;
-- Vytvoření indexu
CREATE INDEX idx_customer_lname 
ON Customer(lName);

SELECT segment_name, segment_type, blocks, bytes/1024/1024 AS size_mb
FROM user_segments
WHERE segment_name = 'IDX_CUSTOMER_LNAME';

SELECT index_name FROM user_indexes 
    WHERE table_name = 'CUSTOMER';

SELECT segment_name, segment_type, blocks, bytes/1024/1024 AS size_mb
FROM user_segments
WHERE segment_name = ANY(
    SELECT index_name FROM user_indexes 
    WHERE table_name = 'CUSTOMER'
);

SELECT segment_name, segment_type, blocks, bytes/1024/1024 AS size_mb
FROM user_segments
WHERE segment_name = 'CUSTOMER';
