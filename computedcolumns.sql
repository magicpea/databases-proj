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
