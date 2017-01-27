--driverlicense.schema.sql
--making of driverlicense tables for postgresql

\set ON_ERROR_STOP on
\echo 'Creating new database  driverlicense'
drop database if exists driverlicense;
create database driverlicense;
\c driverlicense;
-- conecting to driverlicense database
--########### agestate table
--# id: serial 
--#learnerperage:int : 17
--#restrictedperage:int : 17
--#fulllicenseage:int : 18
--# name: varchar(200)
drop table if exists agestate;
create table agestate(
name varchar(30) not null primary key,
learnerpermitage integer not null,
restrictedpermitage integer not null,
fulllicenseage integer not null
);
\d agestate;

