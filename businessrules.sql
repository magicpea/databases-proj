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


