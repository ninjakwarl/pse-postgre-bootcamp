store_db=# \dt
Did not find any tables.
store_db=# CREATE TABLE customers (
store_db(#     customer_id SERIAL PRIMARY KEY,
store_db(#     full_name TEXT,
store_db(#     email TEXT UNIQUE,
store_db(#     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
store_db(# );
CREATE TABLE
store_db=# CREATE TABLE products (
store_db(#     product_id SERIAL PRIMARY KEY,
store_db(#     product_name TEXT,
store_db(#     category TEXT,
store_db(#     price NUMERIC
store_db(# );
CREATE TABLE
store_db=# CREATE TABLE orders (
store_db(#     order_id SERIAL PRIMARY KEY,
store_db(#     customer_id INT REFERENCES customers(customer_id),
store_db(#     order_date DATE,
store_db(#     status TEXT
store_db(# );
CREATE TABLE
store_db=# CREATE TABLE order_items (
store_db(#     order_item_id SERIAL PRIMARY KEY,
store_db(#     order_id INT REFERENCES orders(order_id),
store_db(#     product_id INT REFERENCES products(product_id),
store_db(#     quantity INT,
store_db(#     total_price NUMERIC
store_db(# );
CREATE TABLE
store_db=# \dt
             List of tables
 Schema |    Name     | Type  |  Owner
--------+-------------+-------+----------
 public | customers   | table | postgres
 public | order_items | table | postgres
 public | orders      | table | postgres
 public | products    | table | postgres
(4 rows)


store_db=#

store_db=# select count(*) from customers;
 count
-------
     0
(1 row)


store_db=# INSERT INTO customers (full_name, email)
store_db-# SELECT
store_db-#     'Customer_' || i,
store_db-#     'customer_' || i || '@email.com'
store_db-# FROM generate_series(1, 10000) i;
INSERT 0 10000
store_db=# select count(*) from customers;
 count
-------
 10000
(1 row)


store_db=# select count(*) from products;
 count
-------
     0
(1 row)


store_db=# INSERT INTO products (product_name, category, price)
store_db-# SELECT
store_db-#     'Product_' || i,
store_db-#     CASE
store_db-#         WHEN i % 3 = 0 THEN 'Electronics'
store_db-#         WHEN i % 3 = 1 THEN 'Clothing'
store_db-#         ELSE 'Home'
store_db-#     END,
store_db-#     (random()*5000)::numeric
store_db-# FROM generate_series(1, 2000) i;
INSERT 0 2000
store_db=# select count(*) from products;
 count
-------
  2000
(1 row)


store_db=#

store_db=# select count(*) from orders;
 count
-------
     0
(1 row)


store_db=# INSERT INTO orders (customer_id, order_date, status)
store_db-# SELECT
store_db-#     (random()*10000)::int + 1,
store_db-#     CURRENT_DATE - (random()*365)::int,
store_db-#     CASE
store_db-#         WHEN random() < 0.7 THEN 'Completed'
store_db-#         ELSE 'Pending'
store_db-#     END
store_db-# FROM generate_series(1, 300000);
INSERT 0 300000
store_db=#
store_db=# select count(*) from orders;
 count
--------
 300000
(1 row)


store_db=# select count(*) from order_items;
 count
-------
     0
(1 row)


store_db=# INSERT INTO order_items (order_id, product_id, quantity, total_price)
store_db-# SELECT
store_db-#     o.order_id,
store_db-#     p.product_id,
store_db-#     (floor(random() * 5) + 1)::int AS quantity,
store_db-#     round((random() * 10000)::numeric, 2) AS total_price
store_db-# FROM generate_series(1, 500000) AS g(n)
store_db-# CROSS JOIN LATERAL (
store_db(#     SELECT order_id
store_db(#     FROM orders
store_db(#     ORDER BY random()
store_db(#     LIMIT 1
store_db(# ) AS o
store_db-# CROSS JOIN LATERAL (
store_db(#     SELECT product_id
store_db(#     FROM products
store_db(#     ORDER BY random()
store_db(#     LIMIT 1
store_db(# ) AS p;
INSERT 0 500000
store_db=# select count(*) from order_items;
 count
--------
 500000
(1 row)

store_db=# EXPLAIN ANALYZE
store_db-# SELECT
store_db-#     c.full_name,
store_db-#     COUNT(o.order_id) AS total_orders,
store_db-#     SUM(oi.total_price) AS total_spent
store_db-# FROM customers c
store_db-# JOIN orders o ON c.customer_id = o.customer_id
store_db-# JOIN order_items oi ON o.order_id = oi.order_id
store_db-# WHERE o.status = 'Completed'
store_db-# AND oi.total_price > 500
store_db-# GROUP BY c.full_name
store_db-# ORDER BY total_spent DESC
store_db-# LIMIT 10;
                                                                                 QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=16558.36..16558.39 rows=10 width=53) (actual time=322.654..332.293 rows=1.00 loops=1)
   Buffers: shared hit=3511
   ->  Sort  (cost=16558.36..16583.36 rows=10000 width=53) (actual time=322.653..332.291 rows=1.00 loops=1)
         Sort Key: (sum(oi.total_price)) DESC
         Sort Method: quicksort  Memory: 25kB
         Buffers: shared hit=3511
         ->  Finalize HashAggregate  (cost=16217.26..16342.26 rows=10000 width=53) (actual time=322.623..332.274 rows=1.00 loops=1)
               Group Key: c.full_name
               Batches: 1  Memory Usage: 289kB
               Buffers: shared hit=3508
               ->  Gather  (cost=13452.26..15977.26 rows=24000 width=53) (actual time=322.200..332.222 rows=3.00 loops=1)
                     Workers Planned: 2
                     Workers Launched: 2
                     Buffers: shared hit=3508
                     ->  Partial HashAggregate  (cost=12452.26..12577.26 rows=10000 width=53) (actual time=190.881..190.891 rows=1.00 loops=3)
                           Group Key: c.full_name
                           Batches: 1  Memory Usage: 289kB
                           Buffers: shared hit=3508
                           Worker 0:  Batches: 1  Memory Usage: 289kB
                           Worker 1:  Batches: 1  Memory Usage: 289kB
                           ->  Hash Join  (cost=328.43..11416.84 rows=138056 width=23) (actual time=5.622..144.086 rows=158400.33 loops=3)
                                 Hash Cond: (o.customer_id = c.customer_id)
                                 Buffers: shared hit=3508
                                 ->  Nested Loop  (cost=0.43..10726.29 rows=138056 width=14) (actual time=0.065..103.473 rows=158400.33 loops=3)
                                       Buffers: shared hit=3199
                                       ->  Parallel Seq Scan on order_items oi  (cost=0.00..5789.17 rows=197448 width=10) (actual time=0.017..35.911 rows=158400.33 loops=3)
                                             Filter: (total_price > '500'::numeric)
                                             Rows Removed by Filter: 8266
                                             Buffers: shared hit=3185
                                       ->  Memoize  (cost=0.43..0.48 rows=1 width=8) (actual time=0.000..0.000 rows=1.00 loops=475201)
                                             Cache Key: oi.order_id
                                             Cache Mode: logical
                                             Hits: 229312  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             Buffers: shared hit=14
                                             Worker 0:  Hits: 129366  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             Worker 1:  Hits: 116520  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             ->  Index Scan using orders_pkey on orders o  (cost=0.42..0.47 rows=1 width=8) (actual time=0.040..0.040 rows=1.00 loops=3)
                                                   Index Cond: (order_id = oi.order_id)
                                                   Filter: (status = 'Completed'::text)
                                                   Index Searches: 3
                                                   Buffers: shared hit=14
                                 ->  Hash  (cost=203.00..203.00 rows=10000 width=17) (actual time=5.480..5.481 rows=10001.00 loops=3)
                                       Buckets: 16384  Batches: 1  Memory Usage: 636kB
                                       Buffers: shared hit=309
                                       ->  Seq Scan on customers c  (cost=0.00..203.00 rows=10000 width=17) (actual time=2.770..3.972 rows=10001.00 loops=3)
                                             Buffers: shared hit=309
 Planning:
   Buffers: shared hit=141 dirtied=1
 Planning Time: 0.460 ms
 Execution Time: 332.922 ms
(50 rows)

store_db=# CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX
store_db=# CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX
store_db=# CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX
store_db=# CREATE INDEX idx_order_items_price ON order_items(total_price);
CREATE INDEX

store_db=#

store_db=# EXPLAIN ANALYZE
store_db-# SELECT
store_db-#     c.full_name,
store_db-#     COUNT(o.order_id) AS total_orders,
store_db-#     SUM(oi.total_price) AS total_spent
store_db-# FROM customers c
store_db-# JOIN orders o ON c.customer_id = o.customer_id
store_db-# JOIN order_items oi ON o.order_id = oi.order_id
store_db-# WHERE o.status = 'Completed'
store_db-# AND oi.total_price > 500
store_db-# GROUP BY c.full_name
store_db-# ORDER BY total_spent DESC
store_db-# LIMIT 10;
                                                                                 QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=16558.35..16558.38 rows=10 width=53) (actual time=308.628..319.649 rows=1.00 loops=1)
   Buffers: shared hit=3508
   ->  Sort  (cost=16558.35..16583.35 rows=10000 width=53) (actual time=308.627..319.647 rows=1.00 loops=1)
         Sort Key: (sum(oi.total_price)) DESC
         Sort Method: quicksort  Memory: 25kB
         Buffers: shared hit=3508
         ->  Finalize HashAggregate  (cost=16217.25..16342.25 rows=10000 width=53) (actual time=308.600..319.638 rows=1.00 loops=1)
               Group Key: c.full_name
               Batches: 1  Memory Usage: 289kB
               Buffers: shared hit=3508
               ->  Gather  (cost=13452.25..15977.25 rows=24000 width=53) (actual time=308.208..319.566 rows=3.00 loops=1)
                     Workers Planned: 2
                     Workers Launched: 2
                     Buffers: shared hit=3508
                     ->  Partial HashAggregate  (cost=12452.25..12577.25 rows=10000 width=53) (actual time=179.345..179.355 rows=1.00 loops=3)
                           Group Key: c.full_name
                           Batches: 1  Memory Usage: 289kB
                           Buffers: shared hit=3508
                           Worker 0:  Batches: 1  Memory Usage: 289kB
                           Worker 1:  Batches: 1  Memory Usage: 289kB
                           ->  Hash Join  (cost=328.43..11416.84 rows=138055 width=23) (actual time=6.368..135.436 rows=158400.33 loops=3)
                                 Hash Cond: (o.customer_id = c.customer_id)
                                 Buffers: shared hit=3508
                                 ->  Nested Loop  (cost=0.43..10726.29 rows=138055 width=14) (actual time=0.059..96.353 rows=158400.33 loops=3)
                                       Buffers: shared hit=3199
                                       ->  Parallel Seq Scan on order_items oi  (cost=0.00..5789.17 rows=197448 width=10) (actual time=0.015..33.718 rows=158400.33 loops=3)
                                             Filter: (total_price > '500'::numeric)
                                             Rows Removed by Filter: 8266
                                             Buffers: shared hit=3185
                                       ->  Memoize  (cost=0.43..0.48 rows=1 width=8) (actual time=0.000..0.000 rows=1.00 loops=475201)
                                             Cache Key: oi.order_id
                                             Cache Mode: logical
                                             Hits: 214429  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             Buffers: shared hit=14
                                             Worker 0:  Hits: 120747  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             Worker 1:  Hits: 140022  Misses: 1  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                             ->  Index Scan using orders_pkey on orders o  (cost=0.42..0.47 rows=1 width=8) (actual time=0.038..0.038 rows=1.00 loops=3)
                                                   Index Cond: (order_id = oi.order_id)
                                                   Filter: (status = 'Completed'::text)
                                                   Index Searches: 3
                                                   Buffers: shared hit=14
                                 ->  Hash  (cost=203.00..203.00 rows=10000 width=17) (actual time=6.234..6.235 rows=10001.00 loops=3)
                                       Buckets: 16384  Batches: 1  Memory Usage: 636kB
                                       Buffers: shared hit=309
                                       ->  Seq Scan on customers c  (cost=0.00..203.00 rows=10000 width=17) (actual time=3.934..4.949 rows=10001.00 loops=3)
                                             Buffers: shared hit=309
 Planning:
   Buffers: shared hit=13
 Planning Time: 0.304 ms
 Execution Time: 320.303 ms
(50 rows)


store_db=#


store_db=# SELECT product_id, price FROM products WHERE product_id = 1;
 product_id |      price
------------+------------------
          1 | 987.615711933189
(1 row)


store_db=# SELECT order_id, status FROM orders WHERE order_id = 999999;
 order_id | status
----------+--------
(0 rows)


store_db=# BEGIN;
BEGIN
store_db=*#
store_db=*# UPDATE products
store_db-*# SET price = price - 100
store_db-*# WHERE product_id = 1;
UPDATE 1
store_db=*#
store_db=*# -- Simulate system error
store_db=*# UPDATE orders
store_db-*# SET status = 'Completed'
store_db-*# WHERE order_id = 999999; -- does not exist
UPDATE 0
store_db=*# SELECT product_id, price FROM products WHERE product_id = 1;
 product_id |      price
------------+------------------
          1 | 887.615711933189
(1 row)


store_db=*# SELECT order_id, status FROM orders WHERE order_id = 999999;
 order_id | status
----------+--------
(0 rows)


store_db=*# ROLLBACK;
ROLLBACK
store_db=# SELECT product_id, price FROM products WHERE product_id = 1;
 product_id |      price
------------+------------------
          1 | 987.615711933189
(1 row)


store_db=# SELECT order_id, status FROM orders WHERE order_id = 999999;
 order_id | status
----------+--------
(0 rows)


store_db=#

store_db=# \d public.products;
                                   Table "public.products"
    Column    |  Type   | Collation | Nullable |                   Default
--------------+---------+-----------+----------+----------------------------------------------
 product_id   | integer |           | not null | nextval('products_product_id_seq'::regclass)
 product_name | text    |           |          |
 category     | text    |           |          |
 price        | numeric |           |          |
Indexes:
    "products_pkey" PRIMARY KEY, btree (product_id)
Referenced by:
    TABLE "order_items" CONSTRAINT "order_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(product_id)


store_db=# ALTER TABLE products ADD CONSTRAINT price_positive CHECK (price > 0);
ALTER TABLE
store_db=# \d public.products;
                                   Table "public.products"
    Column    |  Type   | Collation | Nullable |                   Default
--------------+---------+-----------+----------+----------------------------------------------
 product_id   | integer |           | not null | nextval('products_product_id_seq'::regclass)
 product_name | text    |           |          |
 category     | text    |           |          |
 price        | numeric |           |          |
Indexes:
    "products_pkey" PRIMARY KEY, btree (product_id)
Check constraints:
    "price_positive" CHECK (price > 0::numeric)
Referenced by:
    TABLE "order_items" CONSTRAINT "order_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(product_id)


store_db=#

store_db=# SELECT product_id, price FROM products WHERE product_id = 1;
 product_id |      price
------------+------------------
          1 | 987.615711933189
(1 row)


store_db=# UPDATE products SET price = -500 WHERE product_id = 1;
ERROR:  new row for relation "products" violates check constraint "price_positive"
DETAIL:  Failing row contains (1, Product_1, Clothing, -500).
store_db=# SELECT product_id, price FROM products WHERE product_id = 1;
 product_id |      price
------------+------------------
          1 | 987.615711933189
(1 row)


store_db=#

store_db=# \dt
             List of tables
 Schema |    Name     | Type  |  Owner
--------+-------------+-------+----------
 public | customers   | table | postgres
 public | order_items | table | postgres
 public | orders      | table | postgres
 public | products    | table | postgres
(4 rows)


store_db=# CREATE TABLE orders_partitioned (
store_db(#     order_id INT,
store_db(#     customer_id INT,
store_db(#     order_date DATE,
store_db(#     status TEXT
store_db(# ) PARTITION BY RANGE (order_date);
CREATE TABLE
store_db=# CREATE TABLE orders_2023 PARTITION OF orders_partitioned
store_db-# FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
CREATE TABLE
store_db=# CREATE TABLE orders_2024 PARTITION OF orders_partitioned
store_db-# FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
CREATE TABLE
store_db=# \dt
                       List of tables
 Schema |        Name        |       Type        |  Owner
--------+--------------------+-------------------+----------
 public | customers          | table             | postgres
 public | order_items        | table             | postgres
 public | orders             | table             | postgres
 public | orders_2023        | table             | postgres
 public | orders_2024        | table             | postgres
 public | orders_partitioned | partitioned table | postgres
 public | products           | table             | postgres
(7 rows)


store_db=#

QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------
 Seq Scan on orders_2023 orders_partitioned  (cost=0.00..24.12 rows=6 width=44) (actual time=0.016..0.016 rows=0.00 loops=1)
   Filter: (order_date = '2023-06-01'::date)
 Planning:
   Buffers: shared hit=2
 Planning Time: 0.487 ms
 Execution Time: 0.033 ms
(6 rows)


store_db=# SHOW work_mem;
 work_mem
----------
 4MB
(1 row)


store_db=# SHOW shared_buffers;
 shared_buffers
----------------
 128MB
(1 row)


store_db=# SHOW effective_cache_size;
 effective_cache_size
----------------------
 4GB
(1 row)

store_db=# EXPLAIN ANALYZE
store_db-#
store_db-# SELECT
store_db-#     p.category,
store_db-#     SUM(oi.total_price) AS revenue
store_db-# FROM products p
store_db-# JOIN order_items oi ON p.product_id = oi.product_id
store_db-# GROUP BY p.category
store_db-# ORDER BY revenue DESC;
                                                                              QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=7921.04..7921.05 rows=3 width=40) (actual time=200.682..211.038 rows=1.00 loops=1)
   Sort Key: (sum(oi.total_price)) DESC
   Sort Method: quicksort  Memory: 25kB
   Buffers: shared hit=3252
   ->  Finalize GroupAggregate  (cost=7920.11..7921.02 rows=3 width=40) (actual time=200.676..211.032 rows=1.00 loops=1)
         Group Key: p.category
         Buffers: shared hit=3252
         ->  Gather Merge  (cost=7920.11..7920.93 rows=7 width=40) (actual time=200.667..211.023 rows=3.00 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               Buffers: shared hit=3252
               ->  Sort  (cost=6920.09..6920.10 rows=3 width=40) (actual time=91.261..91.263 rows=1.00 loops=3)
                     Sort Key: p.category
                     Sort Method: quicksort  Memory: 25kB
                     Buffers: shared hit=3252
                     Worker 0:  Sort Method: quicksort  Memory: 25kB
                     Worker 1:  Sort Method: quicksort  Memory: 25kB
                     ->  Partial HashAggregate  (cost=6920.03..6920.07 rows=3 width=40) (actual time=91.236..91.238 rows=1.00 loops=3)
                           Group Key: p.category
                           Batches: 1  Memory Usage: 32kB
                           Buffers: shared hit=3236
                           Worker 0:  Batches: 1  Memory Usage: 32kB
                           Worker 1:  Batches: 1  Memory Usage: 32kB
                           ->  Hash Join  (cost=62.00..5878.36 rows=208333 width=14) (actual time=3.537..54.004 rows=166666.67 loops=3)
                                 Hash Cond: (oi.product_id = p.product_id)
                                 Buffers: shared hit=3236
                                 ->  Parallel Seq Scan on order_items oi  (cost=0.00..5268.33 rows=208333 width=10) (actual time=0.012..11.459 rows=166666.67 loops=3)
                                       Buffers: shared hit=3185
                                 ->  Hash  (cost=37.00..37.00 rows=2000 width=12) (actual time=3.513..3.514 rows=2000.00 loops=3)
                                       Buckets: 2048  Batches: 1  Memory Usage: 108kB
                                       Buffers: shared hit=51
                                       ->  Seq Scan on products p  (cost=0.00..37.00 rows=2000 width=12) (actual time=3.122..3.297 rows=2000.00 loops=3)
                                             Buffers: shared hit=51
 Planning:
   Buffers: shared hit=9 dirtied=2
 Planning Time: 0.978 ms
 Execution Time: 211.490 ms
(37 rows)


store_db=# SELECT indexname, indexdef
store_db-# FROM pg_indexes
store_db-# WHERE schemaname = 'public'
store_db-#   AND tablename = 'order_items';
       indexname       |                                        indexdef
-----------------------+----------------------------------------------------------------------------------------
 order_items_pkey      | CREATE UNIQUE INDEX order_items_pkey ON public.order_items USING btree (order_item_id)
 idx_order_items_order | CREATE INDEX idx_order_items_order ON public.order_items USING btree (order_id)
 idx_order_items_price | CREATE INDEX idx_order_items_price ON public.order_items USING btree (total_price)
(3 rows)


store_db=# EXPLAIN ANALYZE
store_db-#
store_db-# SELECT
store_db-#     p.category,
store_db-#     SUM(oi.total_price) AS revenue
store_db-# FROM products p
store_db-# JOIN order_items oi ON p.product_id = oi.product_id
store_db-# GROUP BY p.category
store_db-# ORDER BY revenue DESC;
                                                                              QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=7921.04..7921.05 rows=3 width=40) (actual time=184.680..192.410 rows=1.00 loops=1)
   Sort Key: (sum(oi.total_price)) DESC
   Sort Method: quicksort  Memory: 25kB
   Buffers: shared hit=3252
   ->  Finalize GroupAggregate  (cost=7920.11..7921.02 rows=3 width=40) (actual time=184.670..192.399 rows=1.00 loops=1)
         Group Key: p.category
         Buffers: shared hit=3252
         ->  Gather Merge  (cost=7920.11..7920.93 rows=7 width=40) (actual time=184.659..192.389 rows=3.00 loops=1)
               Workers Planned: 2
               Workers Launched: 2
               Buffers: shared hit=3252
               ->  Sort  (cost=6920.09..6920.10 rows=3 width=40) (actual time=84.774..84.776 rows=1.00 loops=3)
                     Sort Key: p.category
                     Sort Method: quicksort  Memory: 25kB
                     Buffers: shared hit=3252
                     Worker 0:  Sort Method: quicksort  Memory: 25kB
                     Worker 1:  Sort Method: quicksort  Memory: 25kB
                     ->  Partial HashAggregate  (cost=6920.03..6920.07 rows=3 width=40) (actual time=84.752..84.754 rows=1.00 loops=3)
                           Group Key: p.category
                           Batches: 1  Memory Usage: 32kB
                           Buffers: shared hit=3236
                           Worker 0:  Batches: 1  Memory Usage: 32kB
                           Worker 1:  Batches: 1  Memory Usage: 32kB
                           ->  Hash Join  (cost=62.00..5878.36 rows=208333 width=14) (actual time=3.613..50.138 rows=166666.67 loops=3)
                                 Hash Cond: (oi.product_id = p.product_id)
                                 Buffers: shared hit=3236
                                 ->  Parallel Seq Scan on order_items oi  (cost=0.00..5268.33 rows=208333 width=10) (actual time=0.013..10.461 rows=166666.67 loops=3)
                                       Buffers: shared hit=3185
                                 ->  Hash  (cost=37.00..37.00 rows=2000 width=12) (actual time=3.588..3.588 rows=2000.00 loops=3)
                                       Buckets: 2048  Batches: 1  Memory Usage: 108kB
                                       Buffers: shared hit=51
                                       ->  Seq Scan on products p  (cost=0.00..37.00 rows=2000 width=12) (actual time=3.237..3.399 rows=2000.00 loops=3)
                                             Buffers: shared hit=51
 Planning Time: 0.208 ms
 Execution Time: 192.525 ms
(35 rows)


store_db=#