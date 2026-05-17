-- 09_transactions.sql
-- This script demonstrates explicit transactions, error handling, and concurrency control in the Hotel Reservation System.

USE HotelReservationDB;
GO

PRINT '==================================================';
PRINT 'DEMO 1: Successful Booking Transaction';
PRINT '==================================================';
GO

BEGIN TRY
    -- Start explicitly declaring a transaction boundary
    BEGIN TRANSACTION;

    DECLARE @NewReservationID INT;
    DECLARE @NewBillID INT;

    -- 1. Insert a new reservation
    -- Using a future date block to avoid conflicts with sample data
    INSERT INTO Reservations (CustomerID, RoomID, CheckInDate, CheckOutDate, ReservationStatus, TotalAmount)
    VALUES (1, 1, '2026-09-01 14:00:00', '2026-09-05 11:00:00', 'Booked', 400.00);

    -- Capture the newly generated ReservationID using SCOPE_IDENTITY()
    SET @NewReservationID = SCOPE_IDENTITY();
    PRINT 'Inserted Reservation successfully. ReservationID: ' + CAST(@NewReservationID AS NVARCHAR(10));

    -- 2. Insert a matching bill for the reservation
    INSERT INTO Bills (ReservationID, TotalAmount, BillDate)
    VALUES (@NewReservationID, 400.00, GETDATE());

    -- Capture the newly generated BillID using SCOPE_IDENTITY()
    SET @NewBillID = SCOPE_IDENTITY();
    PRINT 'Inserted Bill successfully. BillID: ' + CAST(@NewBillID AS NVARCHAR(10));

    -- 3. Insert a matching payment
    INSERT INTO Payments (BillID, PaymentDate, AmountPaid, PaymentMethod, PaymentStatus)
    VALUES (@NewBillID, GETDATE(), 400.00, 'Card', 'Completed');
    
    PRINT 'Inserted Payment successfully.';

    -- If all operations succeed without throwing an error, permanently commit the transaction
    COMMIT TRANSACTION;
    PRINT 'DEMO 1 Completed: Transaction COMMITTED successfully.';
END TRY
BEGIN CATCH
    -- Error handling block for Demo 1
    PRINT 'An error occurred in DEMO 1.';
    PRINT 'Error Message: ' + ERROR_MESSAGE();

    -- XACT_STATE() = -1 means transaction is uncommittable (e.g., severe error).
    -- XACT_STATE() = 1 means transaction is active and committable, but we caught an error so we should rollback to maintain integrity.
    IF (XACT_STATE()) = -1 OR (XACT_STATE()) = 1
    BEGIN
        PRINT 'Rolling back transaction to maintain database consistency.';
        ROLLBACK TRANSACTION;
    END
END CATCH
GO

PRINT '';
PRINT '==================================================';
PRINT 'DEMO 2: Failed Double-Booking Transaction';
PRINT '==================================================';
GO

BEGIN TRY
    BEGIN TRANSACTION;
    
   DECLARE @DesiredRoomID INT = 2;
DECLARE @DesiredCheckIn DATETIME = '2026-05-16 14:00:00';
DECLARE @DesiredCheckOut DATETIME = '2026-05-18 11:00:00';
    DECLARE @ConflictExists BIT = 0;

    -- 1. Check for overlapping reservations
    -- A conflict exists if there's a Booked/CheckedIn reservation where (ExistingCheckIn < DesiredCheckOut) AND (ExistingCheckOut > DesiredCheckIn)
    IF EXISTS (
        SELECT 1 
        FROM Reservations 
        WHERE RoomID = @DesiredRoomID 
          AND ReservationStatus IN ('Booked', 'CheckedIn')
          AND (CheckInDate < @DesiredCheckOut AND CheckOutDate > @DesiredCheckIn)
    )
    BEGIN
        SET @ConflictExists = 1;
    END

    -- 2. Process based on availability check
    IF @ConflictExists = 1
    BEGIN
        -- Conflict found, safely abort the transaction
        PRINT '*** Booking FAILED due to room unavailability. ***';
        PRINT 'Room ' + CAST(@DesiredRoomID AS NVARCHAR(10)) + ' is already booked for the selected dates.';
        ROLLBACK TRANSACTION;
        PRINT 'DEMO 2 Completed: Transaction ROLLED BACK safely.';
    END
    ELSE
    BEGIN
        -- No conflict, proceed with inserting the booking
        INSERT INTO Reservations (CustomerID, RoomID, CheckInDate, CheckOutDate, ReservationStatus, TotalAmount)
        VALUES (2, @DesiredRoomID, @DesiredCheckIn, @DesiredCheckOut, 'Booked', 500.00);
        
        PRINT 'Booking successful. Committing transaction.';
        COMMIT TRANSACTION;
    END
END TRY
BEGIN CATCH
    -- Error handling block for Demo 2
    PRINT 'An unexpected error occurred in DEMO 2.';
    PRINT 'Error Message: ' + ERROR_MESSAGE();

    -- Use XACT_STATE to safely rollback if a runtime SQL error occurred
    IF (XACT_STATE()) <> 0
    BEGIN
        PRINT 'Rolling back transaction due to error.';
        ROLLBACK TRANSACTION;
    END
END CATCH
GO
