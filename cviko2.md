# Názvy indexu
## Oracle
| TABLE_NAME  | INDEX_NAME   | COLUMN_NAME  |
|------------|------------|-------------|
| CUSTOMER   | SYS_C0021346 | IDCUSTOMER  |
| PRODUCT    | SYS_C0021350 | IDPRODUCT   |
| STORE      | SYS_C0021353 | IDSTORE     |
| STAFF      | SYS_C0021361 | IDSTAFF     |
| Order      | SYS_C0021367 | IDORDER     |
| ORDERITEM  | SYS_C0021375 | IDORDER     |
| ORDERITEM  | SYS_C0021375 | IDPRODUCT   |

## MSSQL
| TableName  | IndexName                                  | ColumnName  |
|------------|-------------------------------------------|-------------|
| Customer   | PK__Customer__D0587687F0CB9B2B           | idCustomer  |
| Product    | PK__Product__5EEC79D053A2F1B7            | idProduct   |
| Store      | PK__Store__A4B611B1BAAFBBA4              | idStore     |
| Staff      | PK__Staff__98C868A3FAB9381              | idStaff     |
| Order      | PK__Order__C8AAFF6E599EC930              | idOrder     |
| OrderItem  | PK__OrderIte__CD44316346565EB0           | idOrder     |
| OrderItem  | PK__OrderIte__CD44316346565EB0           | idProduct   |

# Porovnání velikosti indexů a tabulek v heapu
## Oracle
| TableName  | IndexName      | IndexSizeMB | HeapSizeMB |
|------------|--------------|------------|------------|
| Customer   | SYS_C0021346 | 5          | 16         |
| Product    | SYS_C0021350 | 2          | 5          |
| Store      | SYS_C0021353 | 0.0625     | 0.0625     |
| Staff      | SYS_C0021361 | 0.375      | 0.75       |
| Order      | SYS_C0021367 | 8          | 19         |
| OrderItem  | SYS_C0021375 | 104        | 128        |

## MSSQL
| TableName  | IndexName                                  | IndexSizeMB | HeapSizeMB |
|------------|-------------------------------------------|------------|------------|
| Customer   | PK__Customer__D0587687F0CB9B2B           | 5          | 13         |
| Order      | PK__Order__C8AAFF6E599EC930              | 8          | 17         |
| OrderItem  | PK__OrderIte__CD44316346565EB0           | 184        | 146        |
| Product    | PK__Product__5EEC79D053A2F1B7            | 1          | 4          |
| Staff      | PK__Staff__98C868A3FAB9381              | 1          | 0          |
| Store      | PK__Store__A4B611B1BAAFBBA4              | 0          | 0          |

## Odpovědi
Proč je relativní velikost vůči haldě v případě indexu pro primární klíč tabulky OrderItem větší než u ostatních automaticky vytvořených indexů?  
  
- Primární klíč OrderItem je pravděpodobně složený (idOrder, idProduct), což znamená, že každý záznam v indexu zabírá více místa než jednoduchý číselný primární klíč v jiných tabulkách.

# B-Tree 
## Oracle
| INDEX_NAME  | TREE_HEIGHT | LEAF_BLOCKS | NUM_ROWS | DISTINCT_KEYS | AVG_LEAF_BLOCKS_PER_KEY |
|------------|------------|-------------|----------|---------------|--------------------------|
| SYS_C0021346 | (null) | (null) | (null) | (null) | (null) |
| SYS_C0021350 | (null) | (null) | (null) | (null) | (null) |
| SYS_C0021361 | (null) | (null) | (null) | (null) | (null) |
| SYS_C0021375 | (null) | (null) | (null) | (null) | (null) |
| SYS_C0021367 | (null) | (null) | (null) | (null) | (null) |
| SYS_C0021353 | (null) | (null) | (null) | (null) | (null) |
### Velikost B-Tree
| TABLESPACE_NAME | SEGMENT_NAME  | SIZE_MB | BLOCKS | EXTENTS |
|----------------|--------------|--------|--------|---------|
| USERS         | SYS_C0021346  | 5      | 640    | 20      |
| USERS         | SYS_C0021375  | 104    | 13312  | 84      |
| USERS         | SYS_C0021361  | 0.375  | 48     | 6       |
| USERS         | SYS_C0021367  | 8      | 1024   | 23      |
| USERS         | SYS_C0021350  | 2      | 256    | 17      |
| USERS         | SYS_C0021353  | 0.0625 | 8      | 1       |

### IO Cost Bodového a intervalového rozsahu

 - Nejhorší případ je h + počet všech listových stránek
 - Cost bodového dotazu je h + 1




## MSSQL
| IndexName                                  | IndexType     | TreeHeight | TotalPages | RecordCount |
|--------------------------------------------|--------------|------------|------------|-------------|
| PK__Customer__D0587687F0CB9B2B            | NONCLUSTERED | 3          | 669        | 300000      |
| PK__Customer__D0587687F0CB9B2B            | NONCLUSTERED | 3          | 2          | 669         |
| PK__Customer__D0587687F0CB9B2B            | NONCLUSTERED | 3          | 1          | 2         |
| PK__Product__5EEC79D053A2F1B7             | NONCLUSTERED | 2          | 223        | 100000      |
| PK__Product__5EEC79D053A2F1B7             | NONCLUSTERED | 2          | 1        | 223      |
| PK__Store__A4B611B1BAAFBBA4               | NONCLUSTERED | 2          | 3          | 1000          |
| PK__Store__A4B611B1BAAFBBA4               | NONCLUSTERED | 2          | 1          | 3          |
| PK__Staff__98C868A3FAB9381               | NONCLUSTERED | 2          | 42         | 10000          |
| PK__Staff__98C868A3FAB9381               | NONCLUSTERED | 2          | 1         | 42          |
| PK__Order__C8AAFF6E599EC930               | NONCLUSTERED | 3          | 1115       | 500046      |
| PK__Order__C8AAFF6E599EC930               | NONCLUSTERED | 3          | 3          | 1115        |
| PK__Order__C8AAFF6E599EC930               | NONCLUSTERED | 3          | 1          | 3        |
| PK__OrderIte__CD44316346565EB0            | NONCLUSTERED | 3          | 23503      | 5000000      |
| PK__OrderIte__CD44316346565EB0            | NONCLUSTERED | 3          | 110        | 23503       |
| PK__OrderIte__CD44316346565EB0            | NONCLUSTERED | 3          | 1        | 110         |

### Velikost B-Tree
| IndexName                                  | SizeMB | UsedMB |
|--------------------------------------------|--------|--------|
| PK__Customer__D0587687F0CB9B2B            | 5      | 5      |
| PK__Order__C8AAFF6E599EC930               | 8      | 8      |
| PK__OrderIte__CD44316346565EB0            | 184    | 184    |
| PK__Product__5EEC79D053A2F1B7             | 1      | 1      |
| PK__Staff__98C868A3FAB9381               | 0      | 0      |
| PK__Store__A4B611B1BAAFBBA4               | 0      | 0      |

  
## Odpovědi
Proč není využití stránek u indexu pro primární klíč tabulky OrderItem 100 %, jako je tomu u ostatních automaticky vytvořených indexů?  
  
- Složený primární klíč (idOrder, idProduct) znamená, že se klíče mohou vkládat nesekvenčně, což může vést k nerovnoměrnému zaplnění stránek.

Jaký je maximální počet klíčů v B-stromu řádu C = 600 pro h = 1 a h = 2?  
  
- Pro h = 1 (jedna úroveň listů): Maximální počet klíčů je C - 1 = 600 - 1 = 599.
- Pro h = 2 (kořen + listy): Kořen může mít až C ukazatelů na listy, takže maximální počet klíčů je C * (C - 1) = 600 * 599 = 359400

# Vytvoření Indexu
| SEGMENT_NAME      | SEGMENT_TYPE | BLOCKS | SIZE_MB |
|------------------|-------------|--------|--------|
| SYS_C0021346     | INDEX       | 640    | 5      |
| IDX_CUSTOMER_LNAME | INDEX       | 1024   | 8      |

## Odpovědi
Proč je položka listového uzlu u tohoto indexu větší než u indexu vytvořeného pro primární klíč?  
  
- Index na lName obsahuje delší textová data (VARCHAR2), zatímco primární klíč (idCustomer) je pravděpodobně číslo (INT), které zabírá méně místa.

Proč je tento index větší než index vytvořený pro primární klíč?  
  
- Sekundární index (lName) musí kromě klíče obsahovat i ROWID pro nalezení odpovídajícího řádku v tabulce, zatímco primární klíč slouží přímo k vyhledání.

# Optimizace velikosti indexu 
## Předtím 
| IndexName                              | TableName  | IndexType      | TreeHeight | TotalPages | RecordCount | PageUtilization  |
|----------------------------------------|-----------|---------------|------------|------------|-------------|------------------|
| PK__OrderIte__CD44316346565EB0         | OrderItem | NONCLUSTERED   | 3          | 23503      | 5000000     | 57.536452322154  |
## Potom 
| IndexName                              | TableName  | IndexType          | TreeHeight | TotalPages | RecordCount | PageUtilization  |
|----------------------------------------|-----------|--------------------|------------|------------|-------------|------------------|
| PK__OrderIte__CD44316346565EB0         | OrderItem | NONCLUSTERED INDEX | 3          | 13605      | 500000      | 99.867346182357  |

