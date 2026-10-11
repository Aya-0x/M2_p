/*
Exercise 3

-- 1. new full backup
BACKUP DATABASE Gestion TO DISK = 'C:\tests\Gestion_FULL_Ex3.bak';
GO

-- 2. Insert 2 clients, note the exact time, wait, execute the DELETE error
USE Gestion;
INSERT INTO clients (nom, ville) VALUES ('Error 1', 'Oujda'), ('Error 2', 'Oujda');
GO

-- Exact time
SELECT SYSDATETIME() AS ErrorTime; 
GO

-- Wait for 1 minute
WAITFOR DELAY '00:01:00';
GO

DELETE FROM clients;
GO

-- 3. backup transaction log
BACKUP LOG Gestion TO DISK = 'C:\tests\Gestion_LOG_Ex3.trn';
GO


-- 4. restore gestion_restore using MOVE and STOPAT
RESTORE DATABASE Gestion_Restore FROM DISK = 'C:\tests\Gestion_FULL_Ex3.bak' 
WITH MOVE 'Gestion' TO 'C:\tests\Gestion_Restore.mdf', 
MOVE 'Gestion_log' TO 'C:\tests\Gestion_Restore_log.ldf', NORECOVERY;
GO

RESTORE LOG Gestion_Restore FROM DISK = 'C:\tests\Gestion_LOG_Ex3.trn' 
WITH STOPAT = '2026-10-10T22:05:54', RECOVERY;
GO

-- Verify the clients were recovered
USE Gestion_Restore;
GO
SELECT COUNT(*) AS RecoveredClients FROM clients;
GO
*/
-- 5. Copy the recovered clients back to the original database
USE Gestion;
GO
INSERT INTO clients (nom, ville)
SELECT nom, ville FROM Gestion_Restore.dbo.clients;
GO