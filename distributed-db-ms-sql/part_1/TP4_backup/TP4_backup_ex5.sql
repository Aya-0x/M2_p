/*
Exercise 5


-- 1. Creating the database
USE master;
GO

CREATE DATABASE Volume;
GO


-- Create the table
USE Volume;
GO

CREATE TABLE ventes (
    id INT IDENTITY, 
    date_vente DATETIME, 
    montant FLOAT, 
    commentaire VARCHAR(100)
);
GO

-- Insert 500000 rows 
USE Volume;
GO

INSERT INTO ventes (date_vente, montant, commentaire)
SELECT TOP (500000)
    DATEADD (DAY, -ABS (CHECKSUM (NEWID())) % 1000, GETDATE()),
    ABS (CHECKSUM(NEWID())) % 10000 / 10.0,
    REPLICATE (N'vente', 10)
FROM sys.all_objects a CROSS JOIN sys.all_objects b;
GO

*/

-- 2.The two backups
-- Full backup without compression
BACKUP DATABASE Volume TO DISK = 'C:\tests\Volume_No_Compression.bak';
GO

-- Full backup with the new ZSTD 
BACKUP DATABASE Volume TO DISK = 'C:\tests\Volume_ZSTD.bak' WITH COMPRESSION (ALGORITHM = ZSTD);
GO