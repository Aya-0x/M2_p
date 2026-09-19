-- Database Creation & Setup 

CREATE DATABASE BD_Lib;
GO

USE BD_Lib;
GO

-- 1. Create User-Defined Data Type (TDDU)
CREATE TYPE nom FROM VARCHAR(30) NOT NULL;
GO

-- 1 & 2. Create Tables with Primary and Foreign Keys
CREATE TABLE EDITEUR (
    RefEdt INT NOT NULL,
    NomEdt nom,
    VilleEdt CHAR(6),
    CONSTRAINT PK_EDITEUR PRIMARY KEY (RefEdt)
);

CREATE TABLE RAYON (
    NumRay INT NOT NULL,
    NomRay nom,
    AdrRay CHAR(35),
    CONSTRAINT PK_RAYON PRIMARY KEY (NumRay)
);

CREATE TABLE LIVRE (
    NumLiv INT NOT NULL,
    TitreLiv CHAR(35),
    RefEdt INT NOT NULL,
    NumRay INT NOT NULL,
    CONSTRAINT PK_LIVRE PRIMARY KEY (NumLiv),
    CONSTRAINT UQ_TitreLiv UNIQUE (TitreLiv),
    CONSTRAINT FK_LIVRE_EDITEUR FOREIGN KEY (RefEdt) REFERENCES EDITEUR(RefEdt),
    CONSTRAINT FK_LIVRE_RAYON FOREIGN KEY (NumRay) REFERENCES RAYON(NumRay)
);

CREATE TABLE CLIENT (
    CodeCli INT NOT NULL,
    NomCli nom,
    AdrCli CHAR(30),
    CONSTRAINT PK_CLIENT PRIMARY KEY (CodeCli)
);

CREATE TABLE COMMANDER (
    NumLiv INT NOT NULL,
    CodeCli INT NOT NULL,
    CONSTRAINT PK_COMMANDER PRIMARY KEY (NumLiv, CodeCli),
    CONSTRAINT FK_CMD_LIVRE FOREIGN KEY (NumLiv) REFERENCES LIVRE(NumLiv),
    CONSTRAINT FK_CMD_CLIENT FOREIGN KEY (CodeCli) REFERENCES CLIENT(CodeCli)
);
GO

-- 3. Modify VilleEdt data type to CHAR(18)
ALTER TABLE EDITEUR 
ALTER COLUMN VilleEdt CHAR(18);
GO

-- 4. Add DEFAULT constraints ('a corriger')
ALTER TABLE EDITEUR 
ADD CONSTRAINT DF_NomEdt DEFAULT 'a corriger' FOR NomEdt;

ALTER TABLE RAYON 
ADD CONSTRAINT DF_NomRay DEFAULT 'a corriger' FOR NomRay;

ALTER TABLE CLIENT 
ADD CONSTRAINT DF_NomCli DEFAULT 'a corriger' FOR NomCli;
GO

-- 5. Add CHECK constraint on VilleEdt
ALTER TABLE EDITEUR 
ADD CONSTRAINT cont1 CHECK (VilleEdt IN ('Agadir', 'Fès', 'Casablanca'));
GO

-- 6. Add CHECK constraints to reject 'x9y8'
ALTER TABLE EDITEUR 
ADD CONSTRAINT val1_edt CHECK (NomEdt <> 'x9y8');

ALTER TABLE RAYON 
ADD CONSTRAINT val1_ray CHECK (NomRay <> 'x9y8');

ALTER TABLE CLIENT 
ADD CONSTRAINT val1_cli CHECK (NomCli <> 'x9y8');
GO

-- 8. Insert initial data
INSERT INTO EDITEUR (RefEdt, NomEdt, VilleEdt) VALUES
(2, 'edt1', 'Agadir'),
(30, 'edt2', 'Casablanca'),
(55, 'edt3', 'Fès');

INSERT INTO RAYON (NumRay, NomRay, AdrRay) VALUES
(2, 'R1', 'zoneA'),
(15, 'R12', 'zoneB'),
(18, 'R30', 'zoneC');

INSERT INTO LIVRE (NumLiv, TitreLiv, RefEdt, NumRay) VALUES
(3, 'Roman-Histoire', 30, 2),
(4, 'BD-Aventure', 2, 18),
(7, 'Poesie', 30, 15);

INSERT INTO CLIENT (CodeCli, NomCli, AdrCli) VALUES
(5, 'cli1', 'adrcli1'),
(6, 'cli2', 'adrcli2'),
(8, 'cli3', 'adrcli3');
GO

-- 9. Add to the Table EDITEUR the record (60, 'Agadir')
USE BD_Lib;
INSERT INTO EDITEUR (RefEdt, VilleEdt) VALUES (60, 'Agadir');
SELECT * FROM EDITEUR WHERE RefEdt = 60;

-- 10. Will it be possible to Add to table RAYON these records (25, 'x9y8', 'zoneD')?
-- The query will fail with a CHECK constraint error because 'x9y8' is forbidden
INSERT INTO RAYON (NumRay, NomRay, AdrRay) VALUES (25, 'x9y8', 'zoneD');

-- 11. Display NomEdt and NomRay for the NumLiv >= 4
SELECT E.NomEdt, R.NomRay, L.NumLiv, L.TitreLiv
FROM LIVRE L
JOIN EDITEUR E ON L.RefEdt = E.RefEdt
JOIN RAYON R ON L.NumRay = R.NumRay
WHERE L.NumLiv >= 4;

-- 12. Update AdrRay in the table RAYON from "zoneA" to "secteur_nord"
UPDATE RAYON
SET AdrRay = 'secteur_nord'
WHERE AdrRay = 'zoneA';
