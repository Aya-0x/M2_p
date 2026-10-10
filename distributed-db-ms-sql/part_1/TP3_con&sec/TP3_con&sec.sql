/*

-- 1. create 2 sql logins account

CREATE LOGIN compte1 WITH PASSWORD = 'compte1pass', DEFAULT_DATABASE = master;
CREATE LOGIN compte2 WITH PASSWORD = 'compte2pass', DEFAULT_DATABASE = master;


-- 2. creating ecole db

CREATE DATABASE ecole;
GO


USE ecole;
GO
CREATE TABLE cours (
    idcours int not null,
    libcours char(20)
);
GO

-- Associate compte1 to the database


CREATE USER compte1 FOR LOGIN compte1;
GO

-- To verify we'll use this the db for both users and see the execution 

Use ecole

-- drop user compte1


USE ecole;
GO

DROP USER compte1;
GO

-- 3.creating a third login and assign a server role dbcreator



CREATE LOGIN compte3 WITH PASSWORD = 'compte3pass';
GO



ALTER SERVER ROLE dbcreator ADD MEMBER compte3;
GO



CREATE DATABASE role1;
GO

-- 4. Mapping logins to database users
-- Creating users and assign roles (as sa)
USE ecole;
CREATE USER compte1 FOR LOGIN compte1;
CREATE USER compte2 FOR LOGIN compte2;
ALTER ROLE db_datareader ADD MEMBER compte1;
ALTER ROLE db_datawriter ADD MEMBER compte2;
GO



-- insert data (as compte2)

USE ecole;
INSERT INTO cours (idcours, libcours) VALUES (1, 'SQL Server');
INSERT INTO cours (idcours, libcours) VALUES (2, 'UML');
GO



-- Read data (as compte1)
USE ecole;
SELECT * FROM cours;
GO



-- 5. Creating a custom database role
-- custom role and grant permissions (as admin)

USE ecole;
CREATE ROLE rl1;
ALTER ROLE rl1 ADD MEMBER compte1;
GRANT CREATE TABLE, CREATE VIEW TO rl1;
GO



-- creating a view (as compte1)
USE ecole;
GRANT ALTER ON SCHEMA::dbo TO rl1;
GO



USE ecole;
GO

CREATE VIEW vue1 AS 
SELECT idcours FROM cours;
GO



-- 6. direct object and update

USE ecole;
GO
GRANT SELECT, UPDATE ON cours TO compte2;
GO



USE ecole;
GO

-- Display the table before update
SELECT * FROM cours;
GO



-- update
USE ecole
UPDATE cours SET idcours = 3 WHERE libcours = 'UML';
GO



-- display table after update
USE ecole
SELECT * FROM cours;
GO

-- 7. revoke the direct permissions and replace them with a custom role
USE ecole;
GO

-- Remove direct permissions
REVOKE SELECT, UPDATE ON cours FROM compte2;
GO



USE ecole;
GO

-- Create the role and add the user
CREATE ROLE rl2;
ALTER ROLE rl2 ADD MEMBER compte2;
GO


USE ecole;
GO

-- Grant permission to the role
GRANT SELECT ON cours TO rl2;
GO




-- 9. Encryption 
-- creating a master key and certificat
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssw0rd__aY@';
GO
CREATE CERTIFICATE CertificatEcole WITH SUBJECT = 'Certificat_Ecole';
GO



-- Creating encryption key and enable on ecole
USE ecole;
GO
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE CertificatEcole;
GO
ALTER DATABASE ecole SET ENCRYPTION ON;
GO

*/

-- To verify, first checking database id of ecole then checking in sys.dm_database_encryption_keys
SELECT name, database_id 
FROM sys.databases 
WHERE name = 'ecole';

SELECT * FROM sys.dm_database_encryption_keys;