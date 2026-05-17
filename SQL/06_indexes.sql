-- 06_indexes.sql
-- This script creates non-clustered indexes to improve query performance in the Hotel Reservation System.
-- It checks for the existence of each index before creation to ensure the script is safe to rerun.

USE HotelReservationDB;
GO

-- 1. Index for searching customers by email.
-- Useful for fast lookups during login or when querying a specific customer's details by their email address.
-- (Note: While the UNIQUE constraint on Email creates an index implicitly, explicitly defining naming conventions for indexes is good practice).
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_Customers_Email' AND object_id = OBJECT_ID(N'Customers'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customers_Email ON Customers(Email);
    PRINT 'Index IX_Customers_Email created.';
END
ELSE
BEGIN
    PRINT 'Index IX_Customers_Email already exists.';
END
GO

-- 2. Index for searching rooms by room number.
-- Speeds up queries that check the status or details of a specific room by its human-readable RoomNumber.
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_Rooms_RoomNumber' AND object_id = OBJECT_ID(N'Rooms'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Rooms_RoomNumber ON Rooms(RoomNumber);
    PRINT 'Index IX_Rooms_RoomNumber created.';
END
ELSE
BEGIN
    PRINT 'Index IX_Rooms_RoomNumber already exists.';
END
GO

-- 3. Index for finding reservations by customer.
-- Essential for quickly retrieving a guest's booking history without full table scans (Foreign Key lookup).
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_Reservations_CustomerID' AND object_id = OBJECT_ID(N'Reservations'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Reservations_CustomerID ON Reservations(CustomerID);
    PRINT 'Index IX_Reservations_CustomerID created.';
END
ELSE
BEGIN
    PRINT 'Index IX_Reservations_CustomerID already exists.';
END
GO

-- 4. Index for finding reservations by room.
-- Crucial for checking the reservation history of a particular room to see past and future occupants.
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_Reservations_RoomID' AND object_id = OBJECT_ID(N'Reservations'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Reservations_RoomID ON Reservations(RoomID);
    PRINT 'Index IX_Reservations_RoomID created.';
END
ELSE
BEGIN
    PRINT 'Index IX_Reservations_RoomID already exists.';
END
GO

-- 5. Index for checking availability using CheckInDate and CheckOutDate.
-- Greatly improves the performance of availability checks that filter by overlapping date ranges.
-- Using a composite index covers both columns used in standard availability queries.
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_Reservations_Dates' AND object_id = OBJECT_ID(N'Reservations'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Reservations_Dates ON Reservations(CheckInDate, CheckOutDate);
    PRINT 'Index IX_Reservations_Dates created.';
END
ELSE
BEGIN
    PRINT 'Index IX_Reservations_Dates already exists.';
END
GO

-- 6. Index for finding payments by bill.
-- Optimizes the retrieval of all payment transactions associated with a specific bill.
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_Payments_BillID' AND object_id = OBJECT_ID(N'Payments'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Payments_BillID ON Payments(BillID);
    PRINT 'Index IX_Payments_BillID created.';
END
ELSE
BEGIN
    PRINT 'Index IX_Payments_BillID already exists.';
END
GO

-- 7. Index for finding bills by reservation.
-- Speeds up queries that need to link a reservation to its financial bill details.
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_Bills_ReservationID' AND object_id = OBJECT_ID(N'Bills'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Bills_ReservationID ON Bills(ReservationID);
    PRINT 'Index IX_Bills_ReservationID created.';
END
ELSE
BEGIN
    PRINT 'Index IX_Bills_ReservationID already exists.';
END
GO
