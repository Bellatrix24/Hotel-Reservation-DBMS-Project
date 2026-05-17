-- 03_dml_sample_data.sql
-- This script populates the Hotel Reservation System with realistic sample data.

USE HotelReservationDB;
GO

-- 1. Insert Customers (8 customers)
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES
('John', 'Doe', 'john.doe@example.com', '555-0101', '123 Elm St, Springfield'),
('Jane', 'Smith', 'jane.smith@example.com', '555-0102', '456 Oak St, Metropolis'),
('Alice', 'Johnson', 'alice.j@example.com', '555-0103', '789 Pine St, Gotham'),
('Bob', 'Brown', 'bob.b@example.com', '555-0104', '321 Maple St, Star City'),
('Charlie', 'Davis', 'charlie.d@example.com', '555-0105', '654 Cedar St, Central City'),
('Diana', 'Miller', 'diana.m@example.com', '555-0106', '987 Birch St, Coast City'),
('Eve', 'Wilson', 'eve.w@example.com', '555-0107', '147 Walnut St, Starling'),
('Frank', 'Moore', 'frank.m@example.com', '555-0108', '258 Cherry St, Bludhaven');
GO

-- 2. Insert RoomCategories (4 categories)
INSERT INTO RoomCategories (CategoryName, BasePrice, Description) VALUES
('Standard', 100.00, 'Basic room with essential amenities.'),
('Deluxe', 150.00, 'Spacious room with a city view and upgraded amenities.'),
('Suite', 250.00, 'Luxury suite with a separate living area.'),
('Family', 200.00, 'Large room with multiple beds suitable for families.');
GO

-- 3. Insert Rooms (12 rooms)
-- Category IDs: 1 (Standard), 2 (Deluxe), 3 (Suite), 4 (Family)
-- Note: RoomStatus must be Available, Occupied, or Maintenance.
INSERT INTO Rooms (RoomNumber, CategoryID, RoomStatus) VALUES
('101', 1, 'Available'),
('102', 1, 'Occupied'),
('103', 1, 'Maintenance'),
('104', 1, 'Available'),
('201', 2, 'Available'),
('202', 2, 'Occupied'),
('203', 2, 'Available'),
('301', 3, 'Available'),
('302', 3, 'Occupied'),
('401', 4, 'Available'),
('402', 4, 'Available'),
('403', 4, 'Available');
GO

-- 4. Insert Reservations (10 reservations)
-- Ensure CheckOutDate > CheckInDate and no overlaps for the same room.
-- Statuses: Booked, CheckedIn, CheckedOut, Cancelled.
INSERT INTO Reservations (CustomerID, RoomID, CheckInDate, CheckOutDate, ReservationStatus, TotalAmount) VALUES
(1, 1, '2026-06-01 14:00:00', '2026-06-05 11:00:00', 'Booked', 400.00),      -- Standard, 4 days (100 * 4)
(2, 2, '2026-05-15 14:00:00', '2026-05-20 11:00:00', 'CheckedIn', 500.00),   -- Standard, 5 days (100 * 5)
(3, 5, '2026-04-01 14:00:00', '2026-04-03 11:00:00', 'CheckedOut', 300.00),  -- Deluxe, 2 days (150 * 2)
(4, 6, '2026-05-12 14:00:00', '2026-05-20 11:00:00', 'CheckedIn', 1200.00),  -- Deluxe, 8 days (150 * 8)
(5, 8, '2026-07-10 14:00:00', '2026-07-15 11:00:00', 'Booked', 1250.00),     -- Suite, 5 days (250 * 5)
(6, 9, '2026-05-14 14:00:00', '2026-05-16 11:00:00', 'CheckedIn', 500.00),   -- Suite, 2 days (250 * 2)
(7, 10, '2026-03-10 14:00:00', '2026-03-15 11:00:00', 'CheckedOut', 1000.00),-- Family, 5 days (200 * 5)
(8, 11, '2026-06-15 14:00:00', '2026-06-20 11:00:00', 'Cancelled', 0.00),    -- Family, Cancelled, no charge
(1, 12, '2026-08-01 14:00:00', '2026-08-10 11:00:00', 'Booked', 1800.00),    -- Family, 9 days (200 * 9)
(2, 7, '2026-05-01 14:00:00', '2026-05-05 11:00:00', 'CheckedOut', 600.00);  -- Deluxe, 4 days (150 * 4)
GO

-- 5. Insert Bills
-- Matching the 10 reservations.
INSERT INTO Bills (ReservationID, TotalAmount, BillDate) VALUES
(1, 400.00, '2026-06-01 14:30:00'),
(2, 500.00, '2026-05-15 14:15:00'),
(3, 300.00, '2026-04-03 10:30:00'),
(4, 1200.00, '2026-05-12 14:45:00'),
(5, 1250.00, '2026-07-10 14:10:00'),
(6, 500.00, '2026-05-14 14:05:00'),
(7, 1000.00, '2026-03-15 10:45:00'),
(8, 0.00, '2026-06-10 09:00:00'), -- Cancelled reservation bill
(9, 1800.00, '2026-08-01 15:00:00'),
(10, 600.00, '2026-05-05 10:00:00');
GO

-- 6. Insert Payments
-- Matching the bills.
-- Statuses: Pending, Completed, Failed.
-- Methods: Cash, Card, UPI.
INSERT INTO Payments (BillID, PaymentDate, AmountPaid, PaymentMethod, PaymentStatus) VALUES
(1, '2026-06-01 14:35:00', 400.00, 'Card', 'Completed'),
(2, '2026-05-15 14:20:00', 500.00, 'UPI', 'Completed'),
(3, '2026-04-03 10:35:00', 300.00, 'Cash', 'Completed'),
(4, '2026-05-12 14:50:00', 600.00, 'Card', 'Completed'),   -- Partial payment
(4, '2026-05-13 10:00:00', 600.00, 'Card', 'Completed'),     -- Remaining payment
(5, '2026-07-10 14:15:00', 1250.00, 'UPI', 'Pending'),
(6, '2026-05-14 14:10:00', 500.00, 'Card', 'Failed'),      -- Failed attempt
(6, '2026-05-14 14:20:00', 500.00, 'Cash', 'Completed'),   -- Successful attempt
(7, '2026-03-15 10:50:00', 1000.00, 'Card', 'Completed'),
(9, '2026-08-01 15:05:00', 1800.00, 'UPI', 'Completed'),
(10, '2026-05-05 10:05:00', 600.00, 'Card', 'Completed');
GO

PRINT 'Sample data inserted successfully.';
GO
