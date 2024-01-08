---
--- Data model scripts ---
---
/*
-- Use only to cleanup
DROP TABLE FACT_TABLE ;
DROP TABLE DIM_DATETIME ;
DROP TABLE DIM_DROPOFF_LOCATION ;
DROP TABLE DIM_PASSENGER_COUNT ;
DROP TABLE DIM_PAYMENT_TYPE ;
DROP TABLE DIM_PICKUP_LOCATION ;
DROP TABLE DIM_RATE_CODE ;
DROP TABLE DIM_TRIP_DISTANCE ;

*/
create table dim_passenger_count(
passenger_count_id  INT GENERATED ALWAYS AS IDENTITY,
passenger_count     numeric
);
alter table dim_passenger_count add constraint pk_dim_passenger_count primary key (passenger_count_id);

create table dim_trip_distance(
trip_distance_id  INT GENERATED ALWAYS AS IDENTITY,
trip_distance     numeric(10,2)
);
alter table dim_trip_distance add constraint pk_dim_trip_distance primary key (trip_distance_id);

create table dim_rate_code(
rate_code_id    INT GENERATED ALWAYS AS IDENTITY,
ratecodeid      numeric,
rate_code_name  varchar(255)
);
alter table dim_rate_code add constraint pk_dim_rate_code primary key (rate_code_id);

create table dim_payment_type(
payment_type_id   INT GENERATED ALWAYS AS IDENTITY,
payment_type      numeric,
payment_type_name varchar(255)
);
alter table dim_payment_type add constraint pk_dim_payment_type primary key (payment_type_id);

create table dim_dropoff_location(
dropoff_location_id INT GENERATED ALWAYS AS IDENTITY,
dropoff_latitude    numeric(10,2),
dropoff_longitude   numeric(10,2)
);
alter table dim_dropoff_location add constraint pk_dim_dropoff_location primary key (dropoff_location_id);

create table dim_pickup_location(
pickup_location_id  INT GENERATED ALWAYS AS IDENTITY,
pickup_latitude     numeric(10,2),
pickup_longitue     numeric(10,2)
);
alter table dim_pickup_location add constraint pk_dim_pickup_location primary key (pickup_location_id);

create table dim_datetime(
datetime_id           INT GENERATED ALWAYS AS IDENTITY,
tpep_pickup_datetime  date,
pick_hour             numeric,
pick_day              numeric,
pick_month            numeric,
pick_year             numeric,
pick_weekday          numeric,
tpep_dropoff_datetime date,
drop_hour             numeric,
drop_day              numeric,
drop_month            numeric,
drop_year             numeric,
drop_weekday          numeric
);
alter table dim_datetime add constraint pk_dim_datetime primary key (datetime_id);

create table fact_table(
trip_id               INT GENERATED ALWAYS AS IDENTITY,
vendorid              int,
datetime_id           int,
passenger_count_id    int,
trip_distance_id      int,
rate_code_id          int,
store_and_fwd_flag    int,
pickup_location_id    int,
dropoff_location_id   int,
payment_type_id       int,
fare_amout            numeric(10,2),
extra                 numeric(10,2),
mta_tax               numeric(10,2),
tip_amount            numeric(10,2),
tolls_amount          numeric(10,2),
improvement_surcharge numeric(10,2),
total_amount          numeric(10,2)
)PARTITION BY HASH(trip_id);


CREATE TABLE fact_table_p0 PARTITION OF fact_table 
FOR VALUES WITH (modulus 3, remainder 0);

CREATE TABLE fact_table_p1 PARTITION OF fact_table 
FOR VALUES WITH (modulus 3, remainder 1);

CREATE TABLE fact_table_p2 PARTITION OF fact_table 
FOR VALUES WITH (modulus 3, remainder 2);


alter table fact_table add constraint pk_fact_table primary key (trip_id);
alter table fact_table add constraint fk_dim_passenger_count foreign key (passenger_count_id) references dim_passenger_count(passenger_count_id);
alter table fact_table add constraint fk_dim_trip_distance foreign key (trip_distance_id) references dim_trip_distance(trip_distance_id);
alter table fact_table add constraint fk_dim_rate_code foreign key (rate_code_id) references dim_rate_code(rate_code_id);
alter table fact_table add constraint fk_dim_payment_type foreign key (payment_type_id) references dim_payment_type(payment_type_id);
alter table fact_table add constraint fk_dim_dropoff_location foreign key (dropoff_location_id) references dim_dropoff_location(dropoff_location_id);
alter table fact_table add constraint fk_dim_pickup_location foreign key (pickup_location_id) references dim_pickup_location(pickup_location_id);
alter table fact_table add constraint fk_dim_datetime foreign key (datetime_id) references dim_datetime(datetime_id);

--
-- Populate static DIM
--
INSERT INTO dim_rate_code (ratecodeid,rate_code_name) VALUES (1,'Standard rate');
INSERT INTO dim_rate_code (ratecodeid,rate_code_name) VALUES (2,'JFK');
INSERT INTO dim_rate_code (ratecodeid,rate_code_name) VALUES (3,'Newark');
INSERT INTO dim_rate_code (ratecodeid,rate_code_name) VALUES (4,'Nassau or Westchester');
INSERT INTO dim_rate_code (ratecodeid,rate_code_name) VALUES (5,'Negotiated fare');
INSERT INTO dim_rate_code (ratecodeid,rate_code_name) VALUES (6,'Group ride');
--
INSERT INTO dim_payment_type (payment_type,payment_type_name) VALUES (1,'Credit card');
INSERT INTO dim_payment_type (payment_type,payment_type_name) VALUES (2,'Cash');
INSERT INTO dim_payment_type (payment_type,payment_type_name) VALUES (3,'No charge');
INSERT INTO dim_payment_type (payment_type,payment_type_name) VALUES (4,'Dispute');
INSERT INTO dim_payment_type (payment_type,payment_type_name) VALUES (5,'Unknown');
INSERT INTO dim_payment_type (payment_type,payment_type_name) VALUES (6,'Voided trip');
--