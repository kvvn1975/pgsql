
-- ===============================
-- POSTGRESQL FULL DEMO DATABASE SCRIPT
-- Banking + HRMS + Sales
-- ===============================

-- ===============================
-- BANKING SYSTEM
-- ===============================
DROP SCHEMA IF EXISTS banking CASCADE;
CREATE SCHEMA banking;
SET search_path=banking;

CREATE TABLE customers (
  customer_id BIGSERIAL PRIMARY KEY,
  full_name TEXT,
  email TEXT,
  city TEXT
);

CREATE TABLE accounts (
  account_id BIGSERIAL PRIMARY KEY,
  customer_id BIGINT REFERENCES customers(customer_id),
  balance NUMERIC(12,2)
);

CREATE TABLE transactions (
  txn_id BIGSERIAL PRIMARY KEY,
  account_id BIGINT REFERENCES accounts(account_id),
  amount NUMERIC(12,2),
  txn_date DATE
);

INSERT INTO customers(full_name,email,city)
SELECT 'Customer '||g,'c'||g||'@bank.com','City'||(g%10)
FROM generate_series(1,10000) g;

INSERT INTO accounts(customer_id,balance)
SELECT (g%10000)+1, random()*100000
FROM generate_series(1,30000) g;

INSERT INTO transactions(account_id,amount,txn_date)
SELECT (g%30000)+1, random()*5000, CURRENT_DATE-(g%365)
FROM generate_series(1,120000) g;

-- ===============================
-- HRMS SYSTEM
-- ===============================
DROP SCHEMA IF EXISTS hrms CASCADE;
CREATE SCHEMA hrms;
SET search_path=hrms;

CREATE TABLE employees (
  emp_id BIGSERIAL PRIMARY KEY,
  emp_name TEXT,
  salary NUMERIC(10,2)
);

CREATE TABLE attendance (
  att_id BIGSERIAL PRIMARY KEY,
  emp_id BIGINT REFERENCES employees(emp_id),
  att_date DATE
);

INSERT INTO employees(emp_name,salary)
SELECT 'Emp '||g, random()*120000+30000
FROM generate_series(1,20000) g;

INSERT INTO attendance(emp_id,att_date)
SELECT (g%20000)+1, CURRENT_DATE-(g%365)
FROM generate_series(1,120000) g;

-- ===============================
-- SALES SYSTEM
-- ===============================
DROP SCHEMA IF EXISTS sales CASCADE;
CREATE SCHEMA sales;
SET search_path=sales;

CREATE TABLE products (
  product_id BIGSERIAL PRIMARY KEY,
  product_name TEXT,
  price NUMERIC(10,2)
);

CREATE TABLE orders (
  order_id BIGSERIAL PRIMARY KEY,
  order_date DATE
);

CREATE TABLE order_items (
  item_id BIGSERIAL PRIMARY KEY,
  order_id BIGINT REFERENCES orders(order_id),
  product_id BIGINT REFERENCES products(product_id),
  qty INT
);

INSERT INTO products(product_name,price)
SELECT 'Product '||g, random()*5000+50
FROM generate_series(1,5000) g;

INSERT INTO orders(order_date)
SELECT CURRENT_DATE-(g%365)
FROM generate_series(1,50000) g;

INSERT INTO order_items(order_id,product_id,qty)
SELECT (g%50000)+1, (g%5000)+1, (g%5)+1
FROM generate_series(1,150000) g;
