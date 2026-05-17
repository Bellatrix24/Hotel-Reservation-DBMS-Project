-- 01_create_database.sql
-- This script initializes the Hotel Reservation Database.

/* 
   1. Drop the database if it already exists.
   We check sys.databases to see if HotelReservationDB exists.
   If it does, we switch context to master, force close all connections (SINGLE_USER), 
   and then drop the database.
*/
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'HotelReservationDB')
BEGIN
    USE master;
    -- Set to single user mode to kill existing connections
    ALTER DATABASE HotelReservationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HotelReservationDB;
    PRINT 'Existing HotelReservationDB dropped successfully.';
END
GO

/* 
   2. Create the Hotel Reservation Database.
   This creates a new instance of the database with default settings.
*/
CREATE DATABASE HotelReservationDB;
PRINT 'HotelReservationDB created successfully.';
GO

/* 
   3. Use HotelReservationDB.
   Sets the current database context to the newly created database 
   for subsequent scripts.
*/
USE HotelReservationDB;
PRINT 'Switched to HotelReservationDB context.';
GO
