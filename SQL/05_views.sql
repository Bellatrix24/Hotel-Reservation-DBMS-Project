-- 05_views.sql
-- This script creates views for simplified data access in the Hotel Reservation System.

USE HotelReservationDB;
GO

-- 1. vw_ReservationDetails
-- Provides a comprehensive overview of reservations including guest and room details.
CREATE OR ALTER VIEW vw_ReservationDetails AS
SELECT 
    r.ReservationID,
    c.FirstName + ' ' + c.LastName AS CustomerFullName,
    c.Email,
    c.Phone,
    rm.RoomNumber,
    rc.CategoryName AS RoomCategory,
    r.CheckInDate,
    r.CheckOutDate,
    r.ReservationStatus,
    r.TotalAmount
FROM 
    Reservations r
INNER JOIN 
    Customers c ON r.CustomerID = c.CustomerID
INNER JOIN 
    Rooms rm ON r.RoomID = rm.RoomID
INNER JOIN 
    RoomCategories rc ON rm.CategoryID = rc.CategoryID;
GO

-- 2. vw_CustomerBookingHistory
-- Summarizes the booking history for all customers.
-- Uses LEFT JOINs to ensure customers without current bookings are still represented.
CREATE OR ALTER VIEW vw_CustomerBookingHistory AS
SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerFullName,
    r.ReservationID,
    rm.RoomNumber,
    r.CheckInDate,
    r.CheckOutDate,
    r.ReservationStatus,
    r.TotalAmount
FROM 
    Customers c
LEFT JOIN 
    Reservations r ON c.CustomerID = r.CustomerID
LEFT JOIN 
    Rooms rm ON r.RoomID = rm.RoomID;
GO

-- 3. vw_RevenueByCategory
-- Calculates the total revenue and booking count per room category.
-- Excludes cancelled reservations from the revenue calculation.
CREATE OR ALTER VIEW vw_RevenueByCategory AS
SELECT 
    rc.CategoryName AS RoomCategory,
    COUNT(r.ReservationID) AS NumberOfReservations,
    SUM(r.TotalAmount) AS TotalRevenue
FROM 
    RoomCategories rc
INNER JOIN 
    Rooms rm ON rc.CategoryID = rm.CategoryID
INNER JOIN 
    Reservations r ON rm.RoomID = r.RoomID
WHERE 
    r.ReservationStatus != 'Cancelled'
GROUP BY 
    rc.CategoryName;
GO

-- 4. vw_PendingPayments
-- Identifies payments that are in a 'Pending' state and calculates the remaining balance.
-- Uses a correlated subquery to determine the sum of completed payments for a bill.
CREATE OR ALTER VIEW vw_PendingPayments AS
SELECT 
    c.FirstName + ' ' + c.LastName AS CustomerFullName,
    b.BillID,
    b.TotalAmount AS BillAmount,
    p.AmountPaid,
    (b.TotalAmount - ISNULL((
        SELECT SUM(p2.AmountPaid) 
        FROM Payments p2 
        WHERE p2.BillID = b.BillID AND p2.PaymentStatus = 'Completed'
    ), 0)) AS RemainingAmount,
    p.PaymentStatus,
    p.PaymentDate
FROM 
    Payments p
INNER JOIN 
    Bills b ON p.BillID = b.BillID
INNER JOIN 
    Reservations r ON b.ReservationID = r.ReservationID
INNER JOIN 
    Customers c ON r.CustomerID = c.CustomerID
WHERE 
    p.PaymentStatus = 'Pending';
GO

PRINT 'Views created successfully.';
GO
