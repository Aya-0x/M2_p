/* 
Exercise 4

USE BD1;
GO
DECLARE @compteur INT = 0;
WHILE @compteur < 90
BEGIN
    INSERT INTO produit (idprod, libprod) VALUES (1000 + @compteur, 'Produit Test');
    WAITFOR DELAY '00:00:10';
    SET @compteur = @compteur + 1;
END
GO


USE BD1;
SELECT * FROM produit;
GO



-- 4. Drop BD1 and restore using SMSS 
USE master;
GO
ALTER DATABASE BD1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE BD1;
GO

*/

-- After restoration 
USE BD1;
SELECT COUNT(*) FROM BD1.dbo.produit;
GO