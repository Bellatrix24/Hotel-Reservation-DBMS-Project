-- 02_ddl_tables.sql
-- This script defines the table structure for the Hotel Reservation System.

USE HotelReservationDB;
GO

-- 1. Customers Table
-- Stores personal details and contact information of guests.
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Address NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 2. RoomCategories Table
-- Defines types of rooms and their base prices (e.g., Deluxe, Suite).
CREATE TABLE RoomCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    BasePrice DECIMAL(18, 2) NOT NULL,
    Description NVARCHAR(255)
);
GO

-- 3. Rooms Table
-- Stores individual room information linked to a category.
CREATE TABLE Rooms (
    RoomID INT IDENTITY(1,1) PRIMARY KEY,
    RoomNumber NVARCHAR(10) NOT NULL UNIQUE,
    CategoryID INT NOT NULL,
    RoomStatus NVARCHAR(20) NOT NULL 
        CONSTRAINT CHK_RoomStatus CHECK (RoomStatus IN ('Available', 'Occupied', 'Maintenance')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID) REFERENCES RoomCategories(CategoryID)
);
GO

-- 4. Reservations Table
-- Manages booking details, dates, and current status.
CREATE TABLE Reservations (
    ReservationID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    RoomID INT NOT NULL,
    CheckInDate DATETIME NOT NULL,
    CheckOutDate DATETIME NOT NULL,
    ReservationStatus NVARCHAR(20) NOT NULL 
        CONSTRAINT CHK_ReservationStatus CHECK (ReservationStatus IN ('Booked', 'CheckedIn', 'CheckedOut', 'Cancelled')),
    TotalAmount DECIMAL(18, 2) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Reservations_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Reservations_Room FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    CONSTRAINT CHK_Dates CHECK (CheckOutDate > CheckInDate)
);
GO

-- 5. Bills Table
-- Generated bills linked to a specific reservation.
CREATE TABLE Bills (
    BillID INT IDENTITY(1,1) PRIMARY KEY,
    ReservationID INT NOT NULL,
    TotalAmount DECIMAL(18, 2) NOT NULL,
    BillDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Bills_Reservation FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);
GO

-- 6. Payments Table
-- Tracks payments made against bills.
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    BillID INT NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    AmountPaid DECIMAL(18, 2) NOT NULL,
    PaymentMethod NVARCHAR(20) NOT NULL 
        CONSTRAINT CHK_PaymentMethod CHECK (PaymentMethod IN ('Cash', 'Card', 'UPI')),
    PaymentStatus NVARCHAR(20) NOT NULL 
        CONSTRAINT CHK_PaymentStatus CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed')),
    CONSTRAINT FK_Payments_Bill FOREIGN KEY (BillID) REFERENCES Bills(BillID)
);
GO

-- 7. AuditLog Table
-- Tracks changes made to the database for security and debugging.
CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50) NOT NULL,
    OperationType NVARCHAR(20) NOT NULL, -- e.g., INSERT, UPDATE, DELETE
    RecordID INT NOT NULL,
    ChangeDescription NVARCHAR(MAX),
    ChangedBy NVARCHAR(100) DEFAULT SUSER_NAME(),
    ChangedAt DATETIME DEFAULT GETDATE()
);
GO

PRINT 'All tables created successfully with constraints.';
GO
