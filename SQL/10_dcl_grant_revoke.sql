-- 10_dcl_grant_revoke.sql
-- This script demonstrates Data Control Language (DCL) by establishing 
-- Role-Based Access Control (RBAC) in the Hotel Reservation System.

USE HotelReservationDB;
GO

PRINT '==================================================';
PRINT '1. Creating Roles';
PRINT '==================================================';

-- Check if HotelManagerRole exists; if not, create it
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'HotelManagerRole' AND type = 'R')
BEGIN
    CREATE ROLE HotelManagerRole;
    PRINT 'Role HotelManagerRole created.';
END
ELSE
BEGIN
    PRINT 'Role HotelManagerRole already exists.';
END

-- Check if ReceptionistRole exists; if not, create it
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'ReceptionistRole' AND type = 'R')
BEGIN
    CREATE ROLE ReceptionistRole;
    PRINT 'Role ReceptionistRole created.';
END
ELSE
BEGIN
    PRINT 'Role ReceptionistRole already exists.';
END
GO

PRINT '';
PRINT '==================================================';
PRINT '2. Granting Permissions';
PRINT '==================================================';

-- Grant broad operational permissions to HotelManagerRole
-- Managers need to modify data across all operational tables
GRANT SELECT, INSERT, UPDATE ON Customers TO HotelManagerRole;
GRANT SELECT, INSERT, UPDATE ON Rooms TO HotelManagerRole;
GRANT SELECT, INSERT, UPDATE ON Reservations TO HotelManagerRole;
GRANT SELECT, INSERT, UPDATE ON Bills TO HotelManagerRole;
GRANT SELECT, INSERT, UPDATE ON Payments TO HotelManagerRole;
PRINT 'Granted SELECT, INSERT, UPDATE on core tables to HotelManagerRole.';

-- Grant restricted permissions to ReceptionistRole
-- Receptionists only need to view and add customers and reservations
GRANT SELECT, INSERT ON Customers TO ReceptionistRole;
GRANT SELECT, INSERT ON Reservations TO ReceptionistRole;
PRINT 'Granted SELECT, INSERT on Customers and Reservations to ReceptionistRole.';
GO

PRINT '';
PRINT '==================================================';
PRINT '3. Revoking DELETE Permissions';
PRINT '==================================================';

-- Revoke DELETE ensures that even if permissions were mistakenly granted previously, 
-- they are removed. (Note: DENY could be used for strict enforcement, but REVOKE satisfies the requirement).
-- This protects against accidental data deletion by staff.
REVOKE DELETE ON Customers FROM HotelManagerRole, ReceptionistRole;
REVOKE DELETE ON Rooms FROM HotelManagerRole, ReceptionistRole;
REVOKE DELETE ON Reservations FROM HotelManagerRole, ReceptionistRole;
REVOKE DELETE ON Bills FROM HotelManagerRole, ReceptionistRole;
REVOKE DELETE ON Payments FROM HotelManagerRole, ReceptionistRole;
PRINT 'Revoked DELETE permissions from both roles on all core tables.';
GO

PRINT '';
PRINT '==================================================';
PRINT '4. Sample Test: User Creation and Role Assignment';
PRINT '==================================================';

-- Create a dummy database user without a server login for testing purposes
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'TestReceptionist' AND type = 'S')
BEGIN
    CREATE USER TestReceptionist WITHOUT LOGIN;
    PRINT 'Test user TestReceptionist created.';
END

-- Assign the ReceptionistRole to the test user using the modern ALTER ROLE syntax
ALTER ROLE ReceptionistRole ADD MEMBER TestReceptionist;
PRINT 'Assigned TestReceptionist to ReceptionistRole.';
GO

PRINT '';
PRINT '==================================================';
PRINT 'Showing Permissions for ReceptionistRole';
PRINT '==================================================';

-- Query the system catalog to prove what permissions the ReceptionistRole actually holds
SELECT 
    USER_NAME(dp.grantee_principal_id) AS GranteeRole,
    dp.class_desc AS ObjectType,
    OBJECT_NAME(dp.major_id) AS ObjectName,
    dp.permission_name AS Permission,
    dp.state_desc AS PermissionState
FROM 
    sys.database_permissions dp
INNER JOIN 
    sys.database_principals princ ON princ.principal_id = dp.grantee_principal_id
WHERE 
    princ.name = 'ReceptionistRole'
ORDER BY 
    ObjectName, Permission;
GO
