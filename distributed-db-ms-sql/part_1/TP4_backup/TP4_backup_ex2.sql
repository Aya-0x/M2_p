/* Exercise 2

CREATE DATABASE Gestion;
GO
ALTER DATABASE Gestion SET RECOVERY FULL;
GO



USE Gestion;
CREATE TABLE clients (idclient INT IDENTITY, nom VARCHAR(50), ville VARCHAR(50));
GO
-- Inserting 10 records using a loop while
DECLARE @i INT = 0;
WHILE @i < 10
BEGIN
    INSERT INTO clients (nom, ville) VALUES ('Client ' + CAST(@i AS VARCHAR), 'Tangier');
    SET @i = @i + 1;
END
GO

-- 1. Full backup
BACKUP DATABASE Gestion TO DISK = 'C:\tests\Gestion_FULL.bak';
GO


USE Gestion;
-- 2. Insert 3 clients, then backup LOG1
INSERT INTO clients (nom, ville) VALUES ('Client A', 'Fes'), ('Client B', 'Fes'), ('Client C', 'Fes');
BACKUP LOG Gestion TO DISK = 'C:\tests\Gestion_LOG1.trn';
GO

-- 3. Insert 3 clients, then differential backup DIFF
INSERT INTO clients (nom, ville) VALUES ('Client D', 'Rabat'), ('Client E', 'Rabat'), ('Client F', 'Rabat');
BACKUP DATABASE Gestion TO DISK = 'C:\tests\Gestion_DIFF.bak' WITH DIFFERENTIAL;
GO

-- 4. Insert 3 clients, then backup LOG2
INSERT INTO clients (nom, ville) VALUES ('Client G', 'Casa'), ('Client H', 'Casa'), ('Client I', 'Casa');
BACKUP LOG Gestion TO DISK = 'C:\tests\Gestion_LOG2.trn';
GO

-- 5. Insert 3 clients, then backup LOG3
INSERT INTO clients (nom, ville) VALUES ('Client J', 'Agadir'), ('Client K', 'Agadir'), ('Client L', 'Agadir');
BACKUP LOG Gestion TO DISK = 'C:\tests\Gestion_LOG3.trn';
GO

-- 6. Restore under a new name by moving physical files
RESTORE DATABASE Gestion_Copie FROM DISK = 'C:\tests\Gestion_FULL.bak' 
WITH MOVE 'Gestion' TO 'C:\tests\Gestion_Copie.mdf', 
MOVE 'Gestion_log' TO 'C:\tests\Gestion_Copie_log.ldf', NORECOVERY;

RESTORE DATABASE Gestion_Copie FROM DISK = 'C:\tests\Gestion_DIFF.bak' WITH NORECOVERY;
RESTORE LOG Gestion_Copie FROM DISK = 'C:\tests\Gestion_LOG2.trn' WITH NORECOVERY;
RESTORE LOG Gestion_Copie FROM DISK = 'C:\tests\Gestion_LOG3.trn' WITH RECOVERY;
GO

*/

-- To verify the client count
USE Gestion_Copie;
SELECT COUNT(*) AS TotalClients FROM clients; 
GO

