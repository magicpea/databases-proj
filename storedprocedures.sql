-- 1. Write the code to create a stored procedure to
-- Insert a new row into Sales Order of a Store NOT yet in the database and an existing Distributor

CREATE PROCEDURE kelly_INSERT_into_SalesOrder_newStore_existingDistr
@OrderDescr varchar(500),
@OrderDate date,
@StoreName varchar(30),
@DistributorName varchar(30),
@StoreTypeName varchar(30)
 
AS
DECLARE @S_ID INT, @D_ID INT, @ST_ID INT
SET @S_ID = (SELECT StoreID FROM tblSTORE WHERE StoreName = @StoreName)
 
SET @ST_ID = (SELECT StoreTypeID FROM tblSTORE_TYPE WHERE StoreTypeName = @StoreTypeName)
 
SET @D_ID = (SELECT DistributorID FROM tblDISTRIBUTOR WHERE DistributorName = @DistributorName)
 
BEGIN TRANSACTION T1 -- explicit transaction allows a wrapper around all statements --> "All or nothing"
 
INSERT INTO tblSTORE (StoreName)
VALUES (@StoreName)
 
SET @S_ID = (SELECT SCOPE_IDENTITY()) -- within this transaction, ....
 
INSERT INTO tblSALES_ORDER (OrderDescription, OrderDate, StoreID, DistributorID)
VALUES (@OrderDescr, @OrderDate, @S_ID, @D_ID)
 
COMMIT TRANSACTION T1
 
 
EXECUTE kelly_INSERT_into_SalesOrder_newStore_existingDistr
@OrderDescr = NULL,
@OrderDate = 'July 21, 2021',
@StoreName = 'District Market',
@DistributorName = 'Costco',
@StoreTypeName = 'Retail'
GO



-- Marie 
-- insert a new store with an existing county and a store type NOT yet in the database
CREATE PROCEDURE moconnellINSERT_NEW_STORE_COUNTY_TYPE
@SN VARCHAR(30),
@STN VARCHAR(30),
@CN VARCHAR(30),
@STDescr VARCHAR(100)
AS
-- declare all the fks
DECLARE @ST_ID INT, @C_ID INT
SET @ST_ID = (SELECT StoreTypeID FROM tblSTORE_TYPE WHERE StoreTypeName = @STN AND StoreTypeDescr = @STDescr)
SET @C_ID = (SELECT CountyID FROM tblCOUNTY WHERE CountyName = @CN)

BEGIN TRANSACTION T1

INSERT INTO tblSTORE_TYPE(StoreTypeName, StoreTypeDescr)
VALUES (@STN, @STDescr)

SET @ST_ID = (SELECT SCOPE_IDENTITY()) 

INSERT INTO tblSTORE(StoreName, StoreTypeID, CountyID)
VALUES (@SN, @ST_ID, @C_ID)

COMMIT TRANSACTION T1

EXECUTE moconnellINSERT_NEW_STORE_COUNTY_TYPE
@SN = 'ampm Too Much Good Stuff',
@STN = 'minimart',
@CN = 'Monroe',
@STDescr = 'sells both meat and vegetables'

GO
-- insert a new order product from an existing sales order and an existing product 
CREATE PROCEDURE moconnellINSERT_ORDER_PRODUCT_SALES_ORDER
@O_Descr VARCHAR(100),
@O_Date DATE, 


AS
-- declare the fks here
DECLARE
SET
SET 

-- Marie 
-- insert a new product order from a new product to an existing sales order
CREATE PROCEDURE moconnellINSERT_PRODUCT_ORDER
@O_Descr VARCHAR(100),
@O_Date DATE,
@P_Name VARCHAR(30),
@P_Descr VARCHAR(100),
@P_Price NUMERIC(8,2),
@O_Quant VARCHAR(10),
@M_Name VARCHAR(10),
@D_Name VARCHAR(10),
@S_Name VARCHAR(10)
AS
DECLARE @SO_ID INT, @P_ID INT, @M_ID INT, @D_ID INT, @S_ID INT
SET @SO_ID = (SELECT SO.SalesOrderID 
                FROM tblSALES_ORDER SO
                JOIN tblDISTRIBUTOR D ON SO.DistributorID = D.DistributorID
                JOIN tblSTORE S ON SO.StoreID = S.StoreID
                WHERE SO.OrderDescription = @O_Descr 
                AND SO.OrderDate = @O_Date)
SET @P_ID = (SELECT ProductID FROM tblPRODUCT WHERE ProductName = @P_Name AND ProductDescription = @P_Descr AND ProductPrice = @P_Price)
SET @M_ID = (SELECT MeasureMentID FROM tblMEASUREMENT WHERE MeasurementName = @M_Name)
SET @S_ID = (SELECT StoreID FROM tblSTORE WHERE StoreName = @S_Name)
SET @D_ID = (SELECT DistributorID FROM tblDISTRIBUTOR WHERE DistributorName = @D_Name)
BEGIN TRANSACTION T1

INSERT INTO tblSALES_ORDER(OrderDescription, OrderDate, StoreID, DistributorID)
VALUES(@O_Descr, @O_Date, @S_ID, @D_ID)

INSERT INTO tblPRODUCT(ProductName, ProductDescription, ProductPrice)
VALUES(@P_Name, @P_Descr, @P_Price)

SET @P_ID = (SELECT SCOPE_IDENTITY()) 

INSERT INTO tblORDER_PRODUCT(SalesOrderID, ProductID, OrderQuantity, MeasurementID)
VALUES(@SO_ID, @P_ID, @O_Quant, @M_ID)

COMMIT TRANSACTION T1

-- example of filling this with info

EXECUTE moconnellINSERT_PRODUCT_ORDER
@D_Descr = 'Distributes berries',
@D_Date = '11-11-2011',
@P_Name = 'Blackberries',
@P_Descr = 'Scrumptious blackberries grown in the Skagit Valley',
@P_Price = 11.11,
@O_Quant = '11',
@M_Name = 'Bushels',
@D_Name = 'Berry Distribution Center Inc',
@S_Name = 'Berry Barn'

GO




CREATE FUNCTION fn_qdoanTotalAmount(@PK INT)
RETURNS INTEGER
AS
BEGIN
 
DECLARE @RET INT = (SELECT SUM(OP.OrderQuanntity)
                   FROM tblDISTRIBUTOR D
                   JOIN tblSALES_ORDER SO ON D.DistributorID = SO.DistributorID
                   JOIN tblORDER_PRODUCT OP ON SO.SalesOrderID = OP.SalesOrderID
                   JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
                   JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
                   WHERE SO.OrderDate > DATEADD(Year, -4, GETDATE()
                   AND PT.ProductTypeName = 'vegetable'
                   AND D.DistributorID = @PK)
RETURN @RET
END
GO
 
ALTER TABLE tblORDER_PRODUCT
ADD CalcTotalAmount AS (dbo.fn_qdoanTotalAmount(DistributorID))


-- total number of 5/5 reviews coming from all sales orders after 2019
GO

CREATE FUNCTION fn_moconnellTotalRevFive(@PK INT)
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INT = (SELECT COUNT(RV.ReviewID)
                    FROM tblREVIEW RV 
                    JOIN tblRATING RA ON RV.RatingID = RA.RatingID
                    JOIN tblSALES_ORDER SO ON RV.ReviewID = SO.SalesOrderID
                    WHERE RA.RatingNumber = '5'
                    AND SO.OrderDate > '11-01-2019'
                    AND SO.SalesOrderID = @PK)

RETURN @RET
END
GO

ALTER TABLE tblSALES_ORDER
ADD CalcTotalFiveStarReviews AS (dbo.fn_moconnellTotalRevFive(SalesOrderID))

-- Total number of stores in Kootenai County in the state of Idaho with a store type of minimart
GO
CREATE FUNCTION fn_moconnellTotalKootenaiMinimarts(@PK INT)
RETURNS INTEGER 
AS 
BEGIN 

DECLARE @RET INT = (SELECT COUNT(S.StoreID)
                    FROM tblSTORE S 
                    JOIN tblSTORE_TYPE ST ON S.StoreTypeID = ST.StoreTypeID
                    JOIN tblCOUNTY C ON S.CountyID = C.CountyID
                    WHERE C.CountyName = 'Kootenai'
                    AND S.StoreName = 'Idaho'
                    AND ST.StoreTypeName = 'minimart'
                    AND S.StoreID = @PK)

RETURN @RET
END
GO

ALTER TABLE tblSTORE
ADD CalcKootenaiMinimarts AS (dbo.fn_moconnellTotalKootenaiMinimarts(StoreID))
GO


-- No product with a price larger than $15 can be ordered with a quantity smaller than 50lbs. (Marie)
CREATE FUNCTION fn_moconnellLargePriceQuantity()
RETURNS INTEGER
AS
BEGIN 

DECLARE @RET INTEGER = 0
IF EXISTS(SELECT * FROM tblPRODUCT P
            JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
            WHERE P.ProductPrice > '15',
            AND OP.OrderQuantity < '50')

SET @RET = 1
RETURN @RET
END 
GO

ALTER TABLE tblPRODUCT
ADD CONSTRAINT ck_NoExpensiveOrder
CHECK (dbo.fn_moconnellLargePriceQuantity() = 0)
GO
-- No store with the type that “sells both meat and vegetables" can order from a distributor type of "baked goods vendor". (Marie)
CREATE FUNCTION fn_moconnellMeatVegetable()
RETURNS INTEGER
AS
BEGIN

DECLARE @RET INTEGER = 0
IF EXISTS(SELECT * FROM tblSTORE S 
            JOIN tblSTORE_TYPE ST ON S.StoreTypeID = ST.StoreTypeID
            JOIN tblCOUNTY C ON S.CountyID = C.CountyID
            JOIN tblSALES_ORDER SO ON S.StoreID = SO.StoreID
            JOIN tblDISTRIBUTOR D ON SO.DistributorID = D.DistributorID
            JOIN tblDISTRIBUTOR_TYPE DT ON D.DistributorTypeID = DT.DistributorTypeID
            WHERE ST.StoreTypeDescr = 'sells both meat and vegetables'
            AND DT.DistributorTypeName = 'baked goods vendor')
SET @RET = 1
RETURN @RET
END 
GO

-- was not sure which table to alter, will ask team about this

ALTER TABLE tblSALES_ORDER
ADD CONSTRAINT ck_NoMeatVegetableMismatch
CHECK (dbo.fn_moconnellMeatVegetable() = 0)
GO 


