DROP DATABASE IF EXISTS dbt3;

SET sql_mode='NO_ENGINE_SUBSTITUTION';

CREATE DATABASE dbt3;

USE dbt3;

CREATE TABLE supplier (
	s_suppkey  INTEGER PRIMARY KEY,
	s_name CHAR(25),
	s_address VARCHAR(40),
	s_nationkey INTEGER,
	s_phone CHAR(15),
	s_acctbal REAL,
	s_comment VARCHAR(101)) engine=myisam;

CREATE TABLE part (
	p_partkey INTEGER PRIMARY KEY,
	p_name VARCHAR(55),
	p_mfgr CHAR(25),
	p_brand CHAR(10),
	p_type VARCHAR(25),
	p_size INTEGER,
	p_container CHAR(10),
	p_retailprice REAL,
	p_comment VARCHAR(23)) engine=myisam;

CREATE TABLE partsupp (
	ps_partkey INTEGER,
	ps_suppkey INTEGER,
	ps_availqty INTEGER,
	ps_supplycost REAL,
	ps_comment VARCHAR(199),
	PRIMARY KEY (ps_partkey, ps_suppkey)) engine=myisam;

CREATE TABLE customer (
	c_custkey INTEGER primary key,
	c_name VARCHAR(25),
	c_address VARCHAR(40),
	c_nationkey INTEGER,
	c_phone CHAR(15),
	c_acctbal REAL,
	c_mktsegment CHAR(10),
	c_comment VARCHAR(117)) engine=myisam;

CREATE TABLE orders (
	o_orderkey INTEGER primary key,
	o_custkey INTEGER,
	o_orderstatus CHAR(1),
	o_totalprice REAL,
	o_orderDATE DATE,
	o_orderpriority CHAR(15),
	o_clerk CHAR(15),
	o_shippriority INTEGER,
	o_comment VARCHAR(79)) engine=myisam;

CREATE TABLE lineitem (
	l_orderkey INTEGER,
	l_partkey INTEGER,
	l_suppkey INTEGER,
	l_linenumber INTEGER,
	l_quantity REAL,
	l_extendedprice REAL,
	l_discount REAL,
	l_tax REAL,
	l_returnflag CHAR(1),
	l_linestatus CHAR(1),
	l_shipDATE DATE,
	l_commitDATE DATE,
	l_receiptDATE DATE,
	l_shipinstruct CHAR(25),
	l_shipmode CHAR(10),
	l_comment VARCHAR(44),
	PRIMARY KEY (l_orderkey, l_linenumber)) engine=myisam;

CREATE TABLE nation (
	n_nationkey INTEGER primary key,
	n_name CHAR(25),
	n_regionkey INTEGER,
	n_comment VARCHAR(152)) engine=myisam;

CREATE TABLE region (
	r_regionkey INTEGER primary key,
	r_name CHAR(25),
	r_comment VARCHAR(152)) engine=myisam;

CREATE TABLE time_statistics (
	task_name VARCHAR(40),
	s_time TIMESTAMP,
	e_time TIMESTAMP,
	int_time INTEGER) engine=myisam;

ALTER TABLE supplier DISABLE KEYS;
ALTER TABLE part     DISABLE KEYS;
ALTER TABLE partsupp DISABLE KEYS;
ALTER TABLE customer DISABLE KEYS;
ALTER TABLE orders   DISABLE KEYS;
ALTER TABLE lineitem DISABLE KEYS;
ALTER TABLE nation   DISABLE KEYS;
ALTER TABLE region   DISABLE KEYS;

LOAD DATA INFILE '/backup/benchmarks/dataload/dbt3s10/nation.tbl' into table nation fields terminated by '|';
LOAD DATA INFILE '/backup/benchmarks/dataload/dbt3s10/region.tbl' into table region fields terminated by '|';
LOAD DATA INFILE '/backup/benchmarks/dataload/dbt3s10/supplier.tbl' into table supplier fields terminated by '|';
LOAD DATA INFILE '/backup/benchmarks/dataload/dbt3s10/part.tbl' into table part fields terminated by '|';
LOAD DATA INFILE '/backup/benchmarks/dataload/dbt3s10/customer.tbl' into table customer fields terminated by '|';
LOAD DATA INFILE '/backup/benchmarks/dataload/dbt3s10/orders.tbl' into table orders fields terminated by '|';
LOAD DATA INFILE '/backup/benchmarks/dataload/dbt3s10/partsupp.tbl' into table partsupp fields terminated by '|';
LOAD DATA INFILE '/backup/benchmarks/dataload/dbt3s10/lineitem.tbl' into table lineitem fields terminated by '|';

ALTER TABLE supplier ENABLE KEYS;
ALTER TABLE part     ENABLE KEYS;
ALTER TABLE partsupp ENABLE KEYS;
ALTER TABLE customer ENABLE KEYS;
ALTER TABLE orders   ENABLE KEYS;
ALTER TABLE lineitem ENABLE KEYS;
ALTER TABLE nation   ENABLE KEYS;
ALTER TABLE region   ENABLE KEYS;

ALTER TABLE lineitem 
   ADD INDEX i_l_shipdate(l_shipdate),
   ADD INDEX i_l_suppkey_partkey (l_partkey, l_suppkey),
   ADD INDEX i_l_partkey (l_partkey),
   ADD INDEX i_l_suppkey (l_suppkey),
   ADD INDEX i_l_receiptdate (l_receiptdate),
   ADD INDEX i_l_orderkey (l_orderkey),
   ADD INDEX i_l_orderkey_quantity (l_orderkey, l_quantity),
   ADD INDEX i_l_commitdate (l_commitdate);

CREATE INDEX i_c_nationkey ON customer (c_nationkey);

ALTER TABLE orders
  ADD INDEX i_o_orderdate (o_orderdate),
  ADD INDEX i_o_custkey (o_custkey);

CREATE INDEX i_s_nationkey ON supplier (s_nationkey);

ALTER TABLE partsupp 
  ADD INDEX i_ps_partkey (ps_partkey),
  ADD INDEX i_ps_suppkey (ps_suppkey);

CREATE INDEX i_n_regionkey ON nation (n_regionkey);


ANALYZE TABLE supplier;
ANALYZE TABLE part;
ANALYZE TABLE partsupp;
ANALYZE TABLE customer;
ANALYZE TABLE orders;
ANALYZE TABLE lineitem;
ANALYZE TABLE nation;
ANALYZE TABLE region;