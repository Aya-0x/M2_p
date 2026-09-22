USE Northwind;
GO
/*

------------------------------ Q1

CREATE VIEW Vexe1 AS
SELECT ProductID,ProductName
FROM Products;
GO

SELECT * FROM Vexe1;
GO

--------------------------- Q2

SELECT 
    ProductID,
    ProductName,
    UnitsInStock,
    CASE 
        WHEN UnitsInStock < 10 THEN 'a commander immédiatement'
        ELSE 'a commander ultérieurement'
    END AS CommandeStatus
FROM Products;
GO

--------------------------- Q3

DECLARE @n INT = 10;
DECLARE @i INT = 1;
DECLARE @f INT = 1;

WHILE @i <= @n
BEGIN
    SET @f = @f * @i;
    SET @i = @i + 1;
END

PRINT 'La factorielle de ' + CAST(@n AS VARCHAR(3)) + ' est : ' + CAST(@f AS VARCHAR(10));
GO

-- parameters de varchar represente taille maximale que la chaine texte peut contenir
-- n = 10 => 2 caracters et f ne depasse pas 10 chiffres
-- CAST est une fonction de conversion de type de data


---------------------- Q4


CREATE PROCEDURE Pexe4 (@Num INT)
AS

BEGIN
    -- in case the number is less than 0
    IF @Num < 0
    BEGIN
        Print 'Erreur, il n''existe pas factorielle d''un nombre négatif';
        RETURN;
    END
    
    DECLARE @f INT = 1,  -- Declaring and initializing values at the same time is possible in Tsql
            @i INT = 1;
    
    WHILE @i <= @num
    BEGIN
        SET @f = @f * @i;
        SET @i += 1;    -- Starting with SQL Server 2008, you can use the += shortcut
    END

    PRINT 'La factorielle de ' + CAST(@num AS varchar(10)) + ' est : ' + CAST(@f AS varchar(27))

END;
GO

-- To test this procedure
exec Pexe4 10
GO 


-- you can find the procedure in databases -> northwind -> programmability -> stored procedures 


------------------ Q5



CREATE FUNCTION Fexe5 (@Stock INT,@CategoryID INT) -- stock c'est la valeur limite du stock, category recherchee
RETURNS TABLE  -- indique qu'il s'agit d'une fonction de type table (Inline Table-Valued Function = elle retourne un jeu de résultats sous forme de table)
AS
RETURN
(
    SELECT ProductName, UnitsInStock, CategoryID
    FROM Products
    WHERE @Stock > UnitsInStock AND @CategoryID = CategoryID
    -- stock strictement inférieur au 1er paramètre && catégorie égale au 2ème paramètr
);
GO

-- Test de la fonction avec 10 comme seuil de stock et 2 comme ID de catégorie
SELECT * FROM dbo.Fexe5(10, 2);
GO

*/

------------------Q6

CREATE OR ALTER FUNCTION Fexe6 (@ProductID INT) 
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
        p.ProductID,
        p.ProductName,
        e.FirstName,   
        e.LastName     
    FROM Products p
    -- link the products to detaisl of commands
    INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
    -- link details of commands to header of the command
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    -- link the commands to employees before order
    INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
    -- filter products to the specific ones
    WHERE p.ProductID = @ProductID
);
GO

-- Test de la fonction pour le produit dont le ProductID est 1
SELECT * FROM dbo.Fexe6(1);
GO

-- To prevent repetition use DISTINCT next to SELECT


------------------------Q7

CREATE VIEW Vexe7 AS
SELECT FirstName, LastName
FROM dbo.Fexe6(2);  -- Utilisation directe de la fonction avec la valeur fixée à ProductID = 2
GO

-- To reuse the q6 in this question either change the create in q6 by CREATE OR ALTER FUNCTION Fexe6 
-- Or delete the dbo.Fexe6 in the folder programmability -> Functions -> Table-valued Functions

SELECT * FROM Vexe7;
GO

------------------------Q8

CREATE PROCEDURE Pexe8
    @ProductID INT 
AS
BEGIN
    SELECT FirstName, LastName
    FROM dbo.Fexe6(@ProductID)   -- directly passing the parameter to the function Fexe6 
    WHERE LastName LIKE 'D%';    -- LIKE 'D%' search all lastname starting with D
END;
GO

EXEC Pexe8 @ProductID = 2;
GO
