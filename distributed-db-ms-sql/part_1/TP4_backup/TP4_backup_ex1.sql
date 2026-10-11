/*

-- 1. sa creates a sql server login
CREATE LOGIN user1 WITH PASSWORD = 'user1@aya';
-- Assign the dbcreator role
EXEC sp_addsrvrolemember 'user1', 'dbcreator';
GO


-- 2. Creating the DB named BD1 by user1 with full recovery mode 
CREATE DATABASE BD1;
GO
ALTER DATABASE BD1 SET RECOVERY FULL;
GO


-- Create the table and insert records
USE BD1;
GO

CREATE TABLE produit (idprod INT, libprod VARCHAR(50));
INSERT INTO produit (idprod, libprod) VALUES (1, 'Ubuntu Server'), (2, 'Cisco Router');
GO


-- 3. Create user2 and assign server roles
CREATE LOGIN user2 WITH PASSWORD = 'user2@aya';
EXEC sp_addsrvrolemember 'user2', 'dbcreator';
EXEC sp_addsrvrolemember 'user2', 'diskadmin';
GO

-- Map the user to the database and assign the database role
USE BD1;
GO
CREATE USER user2 FOR LOGIN user2;
EXEC sp_addrolemember 'db_backupoperator', 'user2';
GO



-- 4. Create the logical device (the C:\tests\ folder must exist)
EXEC sp_addumpdevice 'disk', 'Backup1', 'C:\tests\SauverBD.bak';
GO

-- Verify creation in the system view
SELECT name, type_desc, physical_name FROM sys.backup_devices;
GO


-- 5. performs a full backup with user2
BACKUP DATABASE BD1 TO Backup1 WITH INIT;
GO


-- 6. user1 adds data
USE BD1;
INSERT INTO produit (idprod, libprod) VALUES (3, 'Switch');
GO

-- verify
USE BD1;
SELECT * FROM produit


-- 7. user2 backup trn
BACKUP LOG BD1 TO DISK = 'C:\tests\BD1_LOG1.trn';
GO

-- 8. Take BD1 offline using sa
ALTER DATABASE BD1 SET OFFLINE;
GO

-- 9. user2 restores the full backup
USE master;
GO

RESTORE DATABASE BD1 FROM Backup1 WITH NORECOVERY, REPLACE;
GO

-- 10. Restore the transaction log and bring the database online
USE master;
GO

RESTORE LOG BD1 FROM DISK = 'C:\tests\BD1_LOG1.trn' WITH RECOVERY;
GO

*/

-- Connect to the database and verify the contents
USE BD1;
GO
SELECT * FROM produit;
GO