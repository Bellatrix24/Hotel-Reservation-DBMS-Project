-- 08_triggers.sql
-- This script creates database triggers to automate business logic and maintain an audit trail.

USE HotelReservationDB;
GO

-- 1. trg_AfterReservationInsert
-- Trigger fires after a new reservation is inserted.
-- It automatically marks the associated room as 'Occupied' if the reservation is active.
-- It also logs the creation event into the AuditLog table.
-- Written to handle multiple inserted rows simultaneously (set-based operation).
CREATE OR ALTER TRIGGER trg_AfterReservationInsert
ON Reservations
AFTER INSERT
AS
BEGIN
    -- Prevent extra result sets from interfering with SELECT statements
    SET NOCOUNT ON;

    -- Update Room status to 'Occupied' if the new reservation is 'Booked' or 'CheckedIn'
    UPDATE rm
    SET rm.RoomStatus = 'Occupied'
    FROM Rooms rm
    INNER JOIN inserted i ON rm.RoomID = i.RoomID
    WHERE i.ReservationStatus IN ('Booked', 'CheckedIn');

    -- Insert an audit trail record for every newly created reservation
    INSERT INTO AuditLog (TableName, OperationType, RecordID, ChangeDescription)
    SELECT 
        'Reservations', 
        'INSERT', 
        i.ReservationID, 
        'New reservation created for RoomID ' + CAST(i.RoomID AS NVARCHAR(20)) + ' with status ' + i.ReservationStatus
    FROM inserted i;
END
GO

-- 2. trg_AfterReservationUpdate
-- Trigger fires after an existing reservation is updated (e.g., guest checks out or cancels).
-- It synchronizes the Room table's status based on the new ReservationStatus.
-- It also logs the update event into the AuditLog table.
-- Written to handle multiple updated rows simultaneously.
CREATE OR ALTER TRIGGER trg_AfterReservationUpdate
ON Reservations
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- If reservation status becomes CheckedOut or Cancelled, free up the room
    UPDATE rm
    SET rm.RoomStatus = 'Available'
    FROM Rooms rm
    INNER JOIN inserted i ON rm.RoomID = i.RoomID
    WHERE i.ReservationStatus IN ('CheckedOut', 'Cancelled');

    -- If reservation status is reverted or changed to Booked or CheckedIn, occupy the room
    UPDATE rm
    SET rm.RoomStatus = 'Occupied'
    FROM Rooms rm
    INNER JOIN inserted i ON rm.RoomID = i.RoomID
    WHERE i.ReservationStatus IN ('Booked', 'CheckedIn');

    -- Insert an audit trail record detailing the update
    INSERT INTO AuditLog (TableName, OperationType, RecordID, ChangeDescription)
    SELECT 
        'Reservations', 
        'UPDATE', 
        i.ReservationID, 
        'Reservation status updated to ' + i.ReservationStatus
    FROM inserted i;
END
GO

-- 3. trg_AfterPaymentInsert
-- Trigger fires after a new payment is recorded.
-- It securely logs the financial transaction event into the AuditLog table.
-- Written to handle multiple inserted rows simultaneously.
CREATE OR ALTER TRIGGER trg_AfterPaymentInsert
ON Payments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert an audit trail record for every newly created payment
    INSERT INTO AuditLog (TableName, OperationType, RecordID, ChangeDescription)
    SELECT 
        'Payments', 
        'INSERT', 
        i.PaymentID, 
        'Payment of amount ' + CAST(i.AmountPaid AS NVARCHAR(20)) + ' processed for BillID ' + CAST(i.BillID AS NVARCHAR(20)) + ' with status ' + i.PaymentStatus
    FROM inserted i;
END
GO

PRINT 'Triggers created successfully.';
GO

-- ==========================================
-- Sample test queries to view the AuditLog
-- ==========================================

PRINT 'Displaying AuditLog contents (Note: Log might be empty until new data is manipulated):';
SELECT TOP 10 * FROM AuditLog ORDER BY ChangedAt DESC;
GO
