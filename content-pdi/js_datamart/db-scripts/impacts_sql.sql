CREATE SCHEMA IF NOT EXISTS pdi_logging AUTHORIZATION local_writer;
CREATE SCHEMA IF NOT EXISTS pdi_control AUTHORIZATION local_writer;
-- pdi_logging.log_channel definition

DROP TABLE IF EXISTS pdi_logging.log_channel;
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

DROP TABLE pdi_logging.log_job;
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

DROP TABLE pdi_logging.log_tran;
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

DROP TABLE pdi_control.job_control;
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




