-- Database Setup Script for Marine Travel Agency
-- Run this in SQL Server Management Studio (SSMS)

-- Create Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'MarineTravelDB')
BEGIN
    CREATE DATABASE MarineTravelDB;
END
GO

USE MarineTravelDB;
GO

-- 1. Users Table
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL, -- In real app, salt+hash. Simple hash for demo.
    Email NVARCHAR(100) NOT NULL UNIQUE, -- Added UNIQUE constraint
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    PhoneNumber NVARCHAR(20),
    Role NVARCHAR(20) DEFAULT 'Agent', -- Admin, Agent
    ProfileImageUrl NVARCHAR(MAX) DEFAULT '~/assets/img/default-avatar.png',
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 2. Destinations Table
IF OBJECT_ID('Destinations', 'U') IS NOT NULL DROP TABLE Destinations;
CREATE TABLE Destinations (
    DestinationId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    ImageUrl NVARCHAR(255)
);
GO

-- 3. Trips Table
IF OBJECT_ID('Trips', 'U') IS NOT NULL DROP TABLE Trips;
CREATE TABLE Trips (
    TripId INT IDENTITY(1,1) PRIMARY KEY,
    DestinationId INT FOREIGN KEY REFERENCES Destinations(DestinationId),
    ShipName NVARCHAR(100) NOT NULL,
    DepartureDate DATETIME NOT NULL,
    ReturnDate DATETIME NOT NULL,
    PricePerPerson DECIMAL(18, 2) NOT NULL,
    MaxCapacity INT NOT NULL,
    AvailableSeats INT NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Scheduled' -- Scheduled, Completed, Cancelled
);
GO

-- 4. Bookings Table
IF OBJECT_ID('Bookings', 'U') IS NOT NULL DROP TABLE Bookings;
CREATE TABLE Bookings (
    BookingId INT IDENTITY(1,1) PRIMARY KEY,
    TripId INT FOREIGN KEY REFERENCES Trips(TripId),
    UserId INT FOREIGN KEY REFERENCES Users(UserId),
    CustomerName NVARCHAR(100) NOT NULL,
    CustomerEmail NVARCHAR(100) NOT NULL,
    CustomerPhone NVARCHAR(20),
    NumberOfGuests INT NOT NULL,
    TotalAmount DECIMAL(18, 2) NOT NULL,
    BookingDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Confirmed' -- Confirmed, Cancelled
);
GO

-- Indexes
CREATE INDEX IX_Trips_DestinationId ON Trips(DestinationId);
CREATE INDEX IX_Bookings_TripId ON Bookings(TripId);
GO

-- Stored Procedures

-- sp_LoginUser
IF OBJECT_ID('sp_LoginUser', 'P') IS NOT NULL DROP PROCEDURE sp_LoginUser;
GO
CREATE PROCEDURE sp_LoginUser
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT UserId, Username, Role, ProfileImageUrl FROM Users 
    WHERE Username = @Username AND PasswordHash = @PasswordHash;
END
GO

-- sp_RegisterUser
IF OBJECT_ID('sp_RegisterUser', 'P') IS NOT NULL DROP PROCEDURE sp_RegisterUser;
GO
CREATE PROCEDURE sp_RegisterUser
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(255),
    @Email NVARCHAR(100),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @PhoneNumber NVARCHAR(20),
    @Role NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if Username or Email exists
    IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
    BEGIN
        THROW 51001, 'Username is already taken.', 1;
    END

    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        THROW 51002, 'Email is already registered.', 1;
    END

    INSERT INTO Users (Username, PasswordHash, Email, FirstName, LastName, PhoneNumber, Role)
    VALUES (@Username, @PasswordHash, @Email, @FirstName, @LastName, @PhoneNumber, @Role);
END
GO

-- sp_AddBooking
IF OBJECT_ID('sp_AddBooking', 'P') IS NOT NULL DROP PROCEDURE sp_AddBooking;
GO
CREATE PROCEDURE sp_AddBooking
    @TripId INT,
    @UserId INT = NULL,
    @CustomerName NVARCHAR(100),
    @CustomerEmail NVARCHAR(100),
    @CustomerPhone NVARCHAR(20),
    @NumberOfGuests INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Price DECIMAL(18,2);
    DECLARE @Available INT;

    SELECT @Price = PricePerPerson, @Available = AvailableSeats FROM Trips WHERE TripId = @TripId;

    IF @Available >= @NumberOfGuests
    BEGIN
        INSERT INTO Bookings (TripId, UserId, CustomerName, CustomerEmail, CustomerPhone, NumberOfGuests, TotalAmount)
        VALUES (@TripId, @UserId, @CustomerName, @CustomerEmail, @CustomerPhone, @NumberOfGuests, @Price * @NumberOfGuests);

        UPDATE Trips SET AvailableSeats = AvailableSeats - @NumberOfGuests WHERE TripId = @TripId;
        
        SELECT SCOPE_IDENTITY() AS BookingId; -- Return new ID
    END
    ELSE
    BEGIN
        THROW 51000, 'Not enough seats available.', 1;
    END
END
GO

-- sp_GetAllUsers
IF OBJECT_ID('sp_GetAllUsers', 'P') IS NOT NULL DROP PROCEDURE sp_GetAllUsers;
GO
CREATE PROCEDURE sp_GetAllUsers
AS
BEGIN
    SET NOCOUNT ON;
    SELECT UserId, Username, Email, FirstName, LastName, PhoneNumber, Role, ProfileImageUrl, CreatedAt FROM Users;
END
GO

-- sp_UpdateUser
IF OBJECT_ID('sp_UpdateUser', 'P') IS NOT NULL DROP PROCEDURE sp_UpdateUser;
GO
CREATE PROCEDURE sp_UpdateUser
    @UserId INT,
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(255) = NULL,
    @Email NVARCHAR(100),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @PhoneNumber NVARCHAR(20),
    @Role NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for unique constraints on Username and Email (excluding current user)
    IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username AND UserId <> @UserId)
    BEGIN
        THROW 51001, 'Username is already taken.', 1;
    END

    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email AND UserId <> @UserId)
    BEGIN
        THROW 51002, 'Email is already registered.', 1;
    END

    UPDATE Users
    SET Username = @Username,
        Email = @Email,
        FirstName = @FirstName,
        LastName = @LastName,
        PhoneNumber = @PhoneNumber,
        Role = @Role,
        PasswordHash = ISNULL(@PasswordHash, PasswordHash) -- Only update password if provided
    WHERE UserId = @UserId;
END
GO

-- sp_DeleteUser
IF OBJECT_ID('sp_DeleteUser', 'P') IS NOT NULL DROP PROCEDURE sp_DeleteUser;
GO
CREATE PROCEDURE sp_DeleteUser
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Users WHERE UserId = @UserId;
END
GO

-- Seed Data (Somaliland Marine Destinations)

INSERT INTO Destinations (Name, Country, Description) VALUES 
('Berbera Coast', 'Somaliland', 'Historic port city offering marine trips, snorkeling, and coastal cruises along the Red Sea.'),
('Sa’ad ad-Din Island', 'Somaliland', 'Uninhabited island near Zeila, known for coral reefs, marine biodiversity, and eco-tourism trips.'),
('Zeila Coastal Tour', 'Somaliland', 'Historical coastal area with shallow waters suitable for boat tours and marine exploration.'),
('Berbera Marine Reserve', 'Somaliland', 'Protected marine zone ideal for educational sea expeditions and underwater discovery tours.');
GO

-- Add a default Admin user (Password: password123)
-- NOTE: Password hashing is simplified for academic demonstration purposes
EXEC sp_RegisterUser 
    'admin', 
    'password123', 
    'admin@marinetravel.com', 
    'System', 
    'Admin', 
    '555-0199', 
    'Admin';
GO
