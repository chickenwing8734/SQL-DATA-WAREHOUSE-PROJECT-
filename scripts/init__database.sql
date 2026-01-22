/* 
----------------------------------------------------------------------------------------
Create Database and Schemas
----------------------------------------------------------------------------------------
Script purpose:
	This script creates a new datebase and drop any existing Database. 
	This script sets up 3 schemas within the databases namely bronze, sliver and gold
----------------------------------------------------------------------------------------
WARNING:
	Running this script will result in droping existing database.
	All data will be permanently DELETED. 
	Make sure there is a backup copy before executing this script.
*/

USE master;
GO

-- Drop and recreate the DataWarehouse database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name= 'DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END
GO

CREATE DATABASE  DataWarehouse;
GO

USE DataWarehouse;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
