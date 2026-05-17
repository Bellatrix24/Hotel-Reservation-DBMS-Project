-- 07_functions.sql
-- This script creates user-defined scalar functions for the Hotel Reservation System.

USE HotelReservationDB;
GO

-- 1. fn_CalculateNights
-- Calculates the number of nights between a check-in and check-out date.
-- Returns 0 if the check-out date is before or equal to the check-in date.
CREATE OR ALTER FUNCTION dbo.fn_CalculateNights (
    @CheckInDate DATETIME,
    @CheckOutDate DATETIME
)
RETURNS INT
AS
BEGIN
    DECLARE @Nights INT;

    -- Validate dates: Checkout must be strictly after Checkin
    IF @CheckOutDate <= @CheckInDate
    BEGIN
        SET @Nights = 0;
    END
    ELSE
    BEGIN
        -- Calculate the difference in days
        SET @Nights = DATEDIFF(DAY, @CheckInDate, @CheckOutDate);
    END

    RETURN @Nights;
END
GO

-- 2. fn_CalculateRoomCost
-- Calculates the total cost of a room based on the RoomID and the stay duration.
-- Returns 0 if the RoomID is invalid or if the dates are invalid.
CREATE OR ALTER FUNCTION dbo.fn_CalculateRoomCost (
    @RoomID INT,
    @CheckInDate DATETIME,
    @CheckOutDate DATETIME
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TotalCost DECIMAL(18,2) = 0;
    DECLARE @BasePrice DECIMAL(18,2);
    DECLARE @Nights INT;

    -- Step 1: Calculate nights using the first function
    SET @Nights = dbo.fn_CalculateNights(@CheckInDate, @CheckOutDate);

    -- Proceed only if dates are valid (Nights > 0)
    IF @Nights > 0
    BEGIN
        -- Step 2: Retrieve the base price for the given RoomID by joining Rooms to RoomCategories
        SELECT @BasePrice = rc.BasePrice
        FROM Rooms rm
        INNER JOIN RoomCategories rc ON rm.CategoryID = rc.CategoryID
        WHERE rm.RoomID = @RoomID;

        -- Step 3: If a valid base price was found, calculate the total cost
        IF @BasePrice IS NOT NULL
        BEGIN
            SET @TotalCost = @BasePrice * @Nights;
        END
    END

    RETURN @TotalCost;
END
GO

PRINT 'Functions created successfully.';
GO

-- ==========================================
-- Sample SELECT statements to test functions
-- ==========================================

PRINT 'Testing dbo.fn_CalculateNights...';
SELECT 
    dbo.fn_CalculateNights('2026-06-01', '2026-06-05') AS ValidStayNights,      -- Should return 4
    dbo.fn_CalculateNights('2026-06-05', '2026-06-01') AS InvalidDatesNights;    -- Should return 0
GO

PRINT 'Testing dbo.fn_CalculateRoomCost...';
-- Note: Assuming RoomID 1 exists and is a Standard room (BasePrice = 100) from 03_dml_sample_data.sql
SELECT 
    dbo.fn_CalculateRoomCost(1, '2026-06-01', '2026-06-05') AS ValidRoomCost,    -- Should return 400.00
    dbo.fn_CalculateRoomCost(999, '2026-06-01', '2026-06-05') AS InvalidRoomCost,  -- Should return 0.00 (ID not found)
    dbo.fn_CalculateRoomCost(1, '2026-06-05', '2026-06-01') AS InvalidDateCost;  -- Should return 0.00 (Nights = 0)
GO
