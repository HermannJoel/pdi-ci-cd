-- pdi_logging.log_channel definition

-- Drop table

-- DROP TABLE pdi_logging.log_channel;

CREATE TABLE pdi_logging.log_channel (
	id_batch int4 NULL,
	channel_id varchar(255) NULL,
	log_date timestamp NULL,
	logging_object_type varchar(255) NULL,
	object_name varchar(255) NULL,
	object_copy varchar(255) NULL,
	repository_directory varchar(255) NULL,
	filename varchar(255) NULL,
	object_id varchar(255) NULL,
	object_revision varchar(255) NULL,
	parent_channel_id varchar(255) NULL,
	root_channel_id varchar(255) NULL
);


-- pdi_logging.log_job definition

-- Drop table

-- DROP TABLE pdi_logging.log_job;

CREATE TABLE pdi_logging.log_job (
	id_job int4 NULL,
	channel_id varchar(255) NULL,
	jobname varchar(255) NULL,
	status varchar(15) NULL,
	lines_read int8 NULL,
	lines_written int8 NULL,
	lines_updated int8 NULL,
	lines_input int8 NULL,
	lines_output int8 NULL,
	lines_rejected int8 NULL,
	errors int8 NULL,
	startdate timestamp NULL,
	enddate timestamp NULL,
	logdate timestamp NULL,
	depdate timestamp NULL,
	replaydate timestamp NULL,
	log_field text NULL
);
CREATE INDEX "IDX_log_job_1" ON pdi_logging.log_job USING btree (id_job);
CREATE INDEX "IDX_log_job_2" ON pdi_logging.log_job USING btree (errors, status, jobname);

-- pdi_logging.log_tran definition

-- Drop table

-- DROP TABLE pdi_logging.log_tran;

CREATE TABLE pdi_logging.log_tran (
	id_batch int4 NULL,
	channel_id varchar(255) NULL,
	transname varchar(255) NULL,
	status varchar(15) NULL,
	lines_read int8 NULL,
	lines_written int8 NULL,
	lines_updated int8 NULL,
	lines_input int8 NULL,
	lines_output int8 NULL,
	lines_rejected int8 NULL,
	errors int8 NULL,
	startdate timestamp NULL,
	enddate timestamp NULL,
	logdate timestamp NULL,
	depdate timestamp NULL,
	replaydate timestamp NULL,
	log_field text NULL
);
CREATE INDEX "IDX_log_tran_1" ON pdi_logging.log_tran USING btree (id_batch);
CREATE INDEX "IDX_log_tran_2" ON pdi_logging.log_tran USING btree (errors, status, transname);


-- pdi_control.job_control definition

-- Drop table

-- DROP TABLE pdi_control.job_control;

CREATE TABLE pdi_control.job_control (
	batch_id int4 NULL,
	jobname varchar(124) NULL,
	work_unit varchar(124) NULL,
	status varchar(32) NULL,
	project varchar(64) NULL,
	starttime timestamp NULL,
	logtime timestamp NULL,
	ip_address text NULL,
	hostname text NULL,
	pid int4 NULL
);

CREATE SCHEMA js_dw AUTHORIZATION local_writer;
CREATE TABLE js_dw.buy_methods (
                buy_code CHAR(4) NOT NULL,
                buy_desc CHAR(25) NOT NULL,
                PRIMARY KEY (buy_code)
);

-- ALTER TABLE buy_methods COMMENT 'store, internet, TE.';


CREATE TABLE js_dw.payment_methods (
                pay_code CHAR(4) NOT NULL,
                pay_desc CHAR(25) NOT NULL,
                PRIMARY KEY (pay_code)
);

-- ALTER TABLE payment_methods COMMENT 'method of payment: cash, credit card, check.';


CREATE TABLE js_dw.countries (
                cou_id smallint NOT NULL,
                country_name CHAR(30) NOT NULL,
                PRIMARY KEY (cou_id)
);

-- ALTER TABLE countries COMMENT '';


CREATE TABLE js_dw.cities (
                city_id integer NOT NULL,
                city_name CHAR(30) NOT NULL,
                cou_id smallint NOT NULL,
                PRIMARY KEY (city_id)
);

-- ALTER TABLE cities COMMENT '';


CREATE TABLE js_dw.customers (
                cus_id integer NOT NULL,
                cus_name CHAR(30) NOT NULL,
                cus_lastname CHAR(30) NOT NULL,
                add_street CHAR(50),
                add_zipcode CHAR(10),
                city_id integer NOT NULL,
                PRIMARY KEY (cus_id)
);

-- ALTER TABLE customers COMMENT '';


CREATE TABLE js_dw.invoices (
                invoice_number integer NOT NULL,
                buy_code CHAR(4) NOT NULL,
                inv_date DATE NOT NULL,
                pay_code CHAR(4) NOT NULL,
                inv_price NUMERIC(8,2) DEFAULT 0 NOT NULL,
                cus_id integer NOT NULL,
                PRIMARY KEY (invoice_number)
);

-- ALTER TABLE invoices COMMENT '';


CREATE TABLE js_dw.manufacturers (
                man_code CHAR(3) NOT NULL,
                man_desc CHAR(25) NOT NULL,
                PRIMARY KEY (man_code)
);

-- ALTER TABLE manufacturers COMMENT 'Puzzle Manufacturers';


CREATE TABLE js_dw.products (
                pro_code CHAR(8) NOT NULL,
                man_code CHAR(3) NOT NULL,
                pro_name CHAR(35) NOT NULL,
                pro_description CHAR(100),
                pro_type CHAR(10) DEFAULT 'PUZZLE' NOT NULL,
                pro_theme CHAR(50),
                pro_pieces integer,
                pro_packaging CHAR(20),
                pro_shape CHAR(20),
                pro_style CHAR(20),
                pro_buy_price NUMERIC(6,2) DEFAULT 0 NOT NULL,
                pro_sel_price NUMERIC(6,2) DEFAULT 0 NOT NULL,
                pro_stock integer DEFAULT 0 NOT NULL,
                pro_stock_min integer DEFAULT 0 NOT NULL,
                pro_stock_max integer DEFAULT 0 NOT NULL,
                PRIMARY KEY (pro_code, man_code)
);

-- ALTER TABLE products COMMENT 'Products (Puzzles & Accesories)';


CREATE TABLE js_dw.invoices_detail (
                invoice_number integer NOT NULL,
                linenr smallint NOT NULL,
                pro_code CHAR(8) NOT NULL,
                man_code CHAR(3) NOT NULL,
                cant_prod smallint NOT NULL,
                price_unit NUMERIC(6,2) NOT NULL,
                price NUMERIC(8,2) NOT NULL,
                PRIMARY KEY (invoice_number, linenr)
);

-- ALTER TABLE invoices_detail COMMENT '';


ALTER TABLE js_dw.invoices ADD CONSTRAINT buy_place_invoices_fk
FOREIGN KEY (buy_code)
REFERENCES js_dw.buy_methods (buy_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js_dw.invoices ADD CONSTRAINT payment_methods_invoices_fk
FOREIGN KEY (pay_code)
REFERENCES js_dw.payment_methods (pay_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js_dw.cities ADD CONSTRAINT countries_cities_fk
FOREIGN KEY (cou_id)
REFERENCES js_dw.countries (cou_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js_dw.customers ADD CONSTRAINT cities_clients_fk
FOREIGN KEY (city_id)
REFERENCES js_dw.cities (city_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js_dw.invoices ADD CONSTRAINT clients_invoices_fk
FOREIGN KEY (cus_id)
REFERENCES js_dw.customers (cus_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js_dw.invoices_detail ADD CONSTRAINT invoices_invoices_detail_fk
FOREIGN KEY (invoice_number)
REFERENCES js_dw.invoices (invoice_number)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js_dw.products ADD CONSTRAINT manufacturers_products_fk
FOREIGN KEY (man_code)
REFERENCES js_dw.manufacturers (man_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE js_dw.invoices_detail ADD CONSTRAINT products_invoices_detail_fk
FOREIGN KEY (pro_code, man_code)
REFERENCES js_dw.products (pro_code, man_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION;


-------------

CREATE SCHEMA lkp;
CREATE TABLE stg.LK_THEMES (
                id integer NOT NULL,
                theme CHAR(50) NOT NULL,
                PRIMARY KEY (id)
);

-- ALTER TABLE LK_THEMES COMMENT '';


CREATE TABLE stg.LK_PIECES (
                id integer NOT NULL,
                min integer DEFAULT 0 NOT NULL,
                max integer DEFAULT 0 NOT NULL,
                description CHAR(30) NOT NULL
);

-- ALTER TABLE LK_PIECES COMMENT '';


CREATE TABLE stg.LK_REGIONS_2 (
                id integer NOT NULL,
                city CHAR(30) DEFAULT 'N/A' NOT NULL,
                country CHAR(30) DEFAULT 'N/A' NOT NULL,
                region CHAR(30) DEFAULT 'N/A' NOT NULL,
                id_js integer DEFAULT 0 NOT NULL,
                start_date DATE,
                end_date DATE,
                version integer DEFAULT 1 NOT NULL,
                current CHAR(1) DEFAULT 'Y' NOT NULL,
                lastupdate DATE,
                PRIMARY KEY (id)
);

-- ALTER TABLE LK_REGIONS_2 COMMENT '';


CREATE TABLE stg.FT_PUZZ_SALES (
                date integer NOT NULL,
                id_manufacturer integer NOT NULL,
                id_region integer NOT NULL,
                id_junk_prod integer NOT NULL,
                id_puzzle integer NOT NULL,
                id_pieces integer NOT NULL,
                quantity integer NOT NULL
);

-- ALTER TABLE FT_PUZZ_SALES COMMENT '';


CREATE TABLE stg.FT_SALES (
                date integer NOT NULL,
                id_manufacturer integer NOT NULL,
                id_region integer NOT NULL,
                id_junk_sales integer NOT NULL,
                product_type CHAR(10) NOT NULL,
                quantity integer DEFAULT 0 NOT NULL,
                amount NUMERIC(8,2) DEFAULT 0 NOT NULL
);

-- ALTER TABLE FT_SALES COMMENT '';
-- COMMENT ON COLUMN FT_SALES.product_type IS 'puzzle or accesory';


CREATE TABLE stg.LK_JUNK_SALES (
                id integer NOT NULL,
                buy_method CHAR(25) NOT NULL,
                payment_method CHAR(25) NOT NULL,
                PRIMARY KEY (id, buy_method, payment_method)
);

-- ALTER TABLE LK_JUNK_SALES COMMENT '';


CREATE TABLE stg.LK_JUNK_PROD (
                id integer NOT NULL,
                glowsInDark CHAR(1) NOT NULL,
                is3D CHAR(1) NOT NULL,
                wooden CHAR(1) NOT NULL,
                isPanoramic CHAR(1) NOT NULL,
                nrPuzzles smallint NOT NULL,
                PRIMARY KEY (id, glowsInDark, is3D, wooden, isPanoramic, nrPuzzles)
);

-- ALTER TABLE LK_JUNK_PROD COMMENT '';


CREATE TABLE stg.LK_PUZZLES (
                id integer NOT NULL,
                name CHAR(35) DEFAULT 'N/A' NOT NULL,
                theme CHAR(50) DEFAULT 'N/A' NOT NULL,
                id_js_prod CHAR(8) DEFAULT 00000000 NOT NULL,
                id_js_man CHAR(3) DEFAULT 000 NOT NULL,
                start_date DATE,
                end_date DATE,
                version integer DEFAULT 1 NOT NULL,
                current CHAR(1) DEFAULT 'Y' NOT NULL,
                lastupdate DATE,
                PRIMARY KEY (id)
);

-- ALTER TABLE LK_PUZZLES COMMENT '';


CREATE TABLE stg.LK_MANUFACTURERS (
                id integer NOT NULL,
                name CHAR(25) DEFAULT 'N/A' NOT NULL,
                id_js CHAR(3) NOT NULL,
                lastupdate DATE,
                PRIMARY KEY (id)
);

-- ALTER TABLE LK_MANUFACTURERS COMMENT '';


CREATE TABLE stg.LK_REGIONS (
                id integer NOT NULL,
                city CHAR(30) DEFAULT 'N/A' NOT NULL,
                country CHAR(30) DEFAULT 'N/A' NOT NULL,
                region CHAR(30) DEFAULT 'N/A' NOT NULL,
                id_js integer NOT NULL,
                lastupdate DATE,
                PRIMARY KEY (id)
);

-- ALTER TABLE LK_REGIONS COMMENT '';

CREATE TABLE stg.LK_TIME_SIMPLE (
                dateid integer NOT NULL,
                year integer NOT NULL,
                month smallint NOT NULL,
                day smallint NOT NULL,
                week_day smallint NOT NULL,
                PRIMARY KEY (dateid)
);


CREATE TABLE stg.LK_TIME (
                dateid integer NOT NULL,
                year integer NOT NULL,
                month smallint NOT NULL,
                day smallint NOT NULL,
                week_day smallint NOT NULL,
                week_desc CHAR(10) NOT NULL,
                week_short_desc CHAR(3) NOT NULL,
                month_desc CHAR(10) NOT NULL,
                month_short_desc CHAR(3) NOT NULL,
                PRIMARY KEY (dateid)
);
