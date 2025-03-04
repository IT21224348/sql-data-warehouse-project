/*
=========================================================================
Create database and Schemas
=========================================================================
Script Purpose:
  This scripts creates a new database called "Datawarehouse" after checking if it is already available.
  If the database existed, it is dropped and recreated. Additionally scripts sets up 3 schemas
  within the database.
*/



-- Create Database 'DataWarehouse'

use master;
go

--Drop and recreate the "Datawarehouse" database
if exists (select 1 from sys.databases where name='Datawarehouse')
begin
    alter database Datawarehouse set single_user with rollback immediate;
	end;
	go;


create database Datawarehouse;

use Datawarehouse;

create schema bronze;
go
create schema silver;
go
create schema gold;
