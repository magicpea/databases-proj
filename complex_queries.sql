USE INFO_330_6AB

-- Complex query 1
-- Which farmer meets all of the following conditions: 
-- A)  was in charge of over 2 orders from Distributor Greg Hay since March 12, 2019 
-- B) worked in King County store location and has received at least 3 reviews with 5 star ratings between January 1 2011 and now (Quynh)
	
SELECT A.FarmerID, A.FarmerFname, A.FarmerLname, A.TotalOrders100, B.TotalReviews5
FROM
(SELECT F.FarmerID, F.FarmerFname, F.FarmerLname, COUNT(*) AS TotalOrders100
FROM tblFARMER F
JOIN tblPURCHASE_ORDER PO ON F.FarmerID = PO.FarmerID
JOIN tblDISTRIBUTOR D ON PO.DistributorID = D.DistributorID
WHERE D.DistributorName = 'Greg Hay'
AND PO.OrderDate > 'March 12, 2019'
GROUP BY F.FarmerID, F.FarmerFname, F.FarmerLname
HAVING COUNT(*) > 2) AS A,
 
(SELECT F.FarmerID, F.FarmerFname, F.FarmerLname, COUNT(*) AS TotalReviews5
FROM tblFARMER F
JOIN tblCOUNTY C ON F.CountyID = C.CountyID
JOIN tblDISTRIBUTOR D ON C.CountyID = D.CountyID
JOIN tblSALES_ORDER SO ON D.DistributorID = SO.DistributorID
JOIN tblREVIEW R ON SO.SalesOrderID = R.SalesOrderID
JOIN tblRATING Ra ON R.RatingID = Ra.RatingID
WHERE C.CountyName = 'King County'
AND SO.OrderDate BETWEEN 'January 1,2021' AND GETDATE()
AND Ra.RatingNumber = '5'
GROUP BY F.FarmerID, F.FarmerFname, F.FarmerLname
HAVING COUNT(*) >= 3) AS B
WHERE A.FarmerID = B.FarmerID


-- Complex query 2
-- Which distributor meets all of the following conditions: 
-- A) has made top 5 orders of product type ‘vegetables' between 2018 and 2020  
-- B) has had orders of products of more than 100 lbs after August 17, 2020 to store type ‘supermarket’ (Quynh)

SELECT A.DistributorID, A.DistributorName, A.TotalOrders, B.TotalProductAmount
FROM
(SELECT TOP 5 D.DistributorID, D.DistributorName, COUNT(SO.SalesOrderID) AS TotalOrders
FROM tblDISTRIBUTOR D
JOIN tblSALES_ORDER SO ON D.DistributorID = SO.DistributorID
JOIN tblORDER_PRODUCT OD ON SO.SalesOrderID = OD.SalesOrderID
JOIN tblPRODUCT P ON OD.ProductID = P.ProductID
JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
WHERE PT.ProductTypeName = 'vegetables'
AND SO.OrderDate BETWEEN 'January 1, 2018' AND 'December 30, 2020'
GROUP BY D.DistributorID, D.DistributorName
ORDER BY TotalOrders DESC) AS A,
(SELECT D.DistributorID, D.DistributorName, SUM(OrderQuanntity) AS TotalProductAmount
FROM tblDISTRIBUTOR D
JOIN tblSALES_ORDER SO ON D.DistributorID = SO.DistributorID
JOIN tblORDER_PRODUCT OP ON SO.SalesOrderID = OP.SalesOrderID
JOIN tblSTORE S ON SO.StoreID = S.StoreID
JOIN tblSTORE_TYPE ST ON S.StoreTypeID = ST.StoreTypeID
WHERE SO.OrderDate > 'August 17, 2020'
AND ST.StoreTypeName = 'supermarket'
GROUP BY D.DistributorID, D.DistributorName
HAVING SUM(OrderQuanntity) > 100) AS B
WHERE A.FarmerID = B.FarmerID


-- Complex query 3
-- Which product meets all of the following conditions:
--  A) has at least 5 sales orders between October 11th, 2017 and November 26th, 2019. 
--  B) has a product type of “root vegetable” and a price of over $3 per pound (Marie)

SELECT DISTINCT P.ProductName
FROM tblPRODUCT P
JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
JOIN tblSALES_ORDER SO ON OP.SalesOrderID = SO.SalesOrderID
JOIN(SELECT DISTINCT P.ProductID
        FROM tblPRODUCT P
        JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
        WHERE PT.ProductTypeName = 'root vegetable'
        AND P.ProductPrice > '3.00') AS SQ1 ON P.ProductID = SQ1.ProductID
WHERE SO.OrderDate BETWEEN '10-11-2017' AND '11-26-2019'
HAVING SUM(SO.SalesOrderID) >= '5'


-- Complex query 4
-- Which sales order meets all of the following criteria:
--  A) comes from a store type of “Market” located in King County, WA. 
--  B) has at least 2 review descriptions containing the phrase “this product sucks” (Marie)

SELECT DISTINCT SO.OrderDescription
FROM tblSALES_ORDER SO
JOIN tblSTORE S ON SO.StoreID = S.StoreID
JOIN tblSTORE_TYPE ST ON S.StoreTypeID = ST.StoreTypeID
JOIN tblCOUNTY C ON S.CountyID = C.CountyID
JOIN tblSTATE SA ON C.StateID = SA.StateID
JOIN(SELECT DISTINCT SO.OrderDescription
        FROM tblSALES_ORDER SO
        JOIN tblREVIEW R ON SO.SalesOrderID = R.SalesOrderID
        WHERE R.ReviewDescr LIKE '%this product sucks%'
        HAVING SUM(SO.SalesOrderID) >= '2') AS SQ2 ON SO.OrderDescription = SQ2.OrderDescription
WHERE ST.StoreTypeName = 'Market'
AND C.CountyName = 'King County'
AND SA.StateAbbr = 'WA'


-- Complex query 5
-- Find the top 5 stores in Terrebonne County, Louisiana that had:
-- A) The most sales orders with a distributor name of “John Cena” in 2011 
-- B) the most sales orders containing product 'potatoes' (Kelly)

SELECT TOP 5 A.StoreName, A.NumOfSalesOrderJohnCena2011, B.NumOfSalesOrderContainPatatoes
FROM
(SELECT S.StoreID, S.StoreName, COUNT(SO.SalesOrderID) AS NumOfSalesOrderJohnCena2011
FROM tblSTORE AS S
JOIN tblSALES_ORDER SO ON S.StoreID = SO.StoreID
JOIN tblDISTRIBUTOR D ON D.DistributorID = SO.DistributorID
JOIN tblCOUNTY C ON C.CountyID = S.CountyID
JOIN tblSTATE ST ON ST.StateID = C.StateID
WHERE D.DistributorName = 'John Cena'
AND C.CountyName = 'Terrebonne'
AND ST.StateName = 'Louisiana'
AND YEAR(SO.OrderDate) = 2011
GROUP BY S.StoreName) AS A
 JOIN
(SELECT S.StoreID, S.StoreName, COUNT(SO.SalesOrderID) AS NumOfSalesOrderContainPatatoes
FROM tblSTORE AS S
JOIN tblSALES_ORDER SO ON S.StoreID = SO.StoreID
JOIN tblDISTRIBUTOR D ON D.DistributorID = SO.DistributorID
JOIN tblCOUNTY C ON C.CountyID = S.CountyID
JOIN tblSTATE ST ON ST.StateID = C.StateID
JOIN tblORDER_PRODUCT OP ON OP.SalesOrderID = SO.SalesOrderID
JOIN tblPRODUCT P ON P.ProductID = OP.ProductID
WHERE P.ProductName = 'potatoes'
AND C.CountyName = 'Terrebonne'
AND ST.StateName = 'Louisiana'
GROUP BY S.StoreID, S.StoreName) AS B ON A.StoreID = B.StoreID


-- Complex query 6
-- Which product meets all of the following conditions:
-- A) has a price higher than $2.50
-- B) has at least 2 review descriptions containing the phrase “this is amazing” (Kelly)

SELECT *
FROM
(SELECT P.ProductID, P.ProductName, COUNT(R.ReviewID) AS NumOfReview_This_Is_Amazing
FROM tblPRODUCT AS P
JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
WHERE P.ProductPrice > 2.5) AS A,
 
(SELECT P.ProductID, P.ProductName, COUNT(R.ReviewID) AS NumOfReview_This_Is_Amazing
FROM tblPRODUCT AS P
JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
JOIN tblORDER_PRODUCT OP ON OP.ProductID = P.ProductID
JOIN tblSALES_ORDER SO ON S.StoreID = SO.StoreID
JOIN tblREVIEW R ON R.SalesOrderID = SO.SalesOrderID
WHERE R.ReviewDescr LIKE '%this is amazing%'
GROUP BY P.ProductID, P.ProductName
HAVING COUNT(R.ReviewID) >= 2) AS B
 
WHERE A.ProductID = B.ProductID


-- Complex query 7
-- Which store meets all of the following conditions:
-- A) have spent more than $1000 on orders since February 18, 2016 
-- B) places more than 50 orders between November 6, 2015 and July 9, 2019  (Marala) 

SELECT A.StoreName, A.SpentMoreThanOrders, B.PlacesMoreThan50Orders
FROM
(SELECT S.StoreID, S.StoreName, SUM(P.ProductPrice) AS SpentMoreThanOrders
FROM tblSTORE AS S
JOIN tblSALES_ORDER SO ON S.StoreID = SO.StoreID
JOIN tblORDER_PRODUCT OP on SO.SalesOrderID = OP.SalesOrderID
JOIN tblPRODUCT P on OP.ProductID = P.ProductID
WHERE SO.OrderDate > 'February 18, 2016'
   GROUP BY S.StoreID, S.StoreName
   HAVING SUM(P.ProductPrice) > '1000') AS A,
(SELECT S.StoreID, S.StoreName, SUM(OP.OrderQuantity) AS
   PlacesMoreThan50Orders)
   FROM tblSTORE AS S
JOIN tblSALES_ORDER SO ON S.StoreID = SO.StoreID
JOIN tblORDER_PRODUCT OP on SO.SalesOrderID = OP.SalesOrderID
JOIN tblPRODUCT P on OP.ProductID = P.ProductID
WHERE SO.OrderDate BETWEEN 'November 6, 2015' AND 'July 9, 2019'
   GROUP BY S.StoreID, S.StoreName
   HAVING SUM(OP.OrderQuantity) > '50') AS B
WHERE A.StoreID = B.StoreID


-- Complex query 8
-- Which store meets all of the following conditions:
-- A) has at least 10 ratings that are less than 2/5 between January 1, 2021 and December 31, 2021.
-- B) has purchased more than 100 items. (Marala)
 
SELECT A.StoreName, A.LowReviews, B.PurchasedMoreThan100Items
FROM
(SELECT S.StoreID, S.StoreName, COUNT(*) AS LowRatings
FROM tblSTORE AS S
   JOIN tblSALES_ORDER SO ON S.StoreID = SO.StoreID
   JOIN tblREVIEW R on SO.SalesOrderID = R.SalesOrderID
   JOIN tblRATING RA on R.RatingID = RA.RatingID
   WHERE SO.OrderDate BETWEEN 'January 1, 2021' AND 'December 31, 2021'
   AND RA.RatingNumber < '2/5'
   GROUP BY S.StoreID, S.StoreName
   HAVING COUNT(*) >= 10) AS A,
   (SELECT S.StoreID, S.StoreName, SUM(LI.LineItemQuantity AS PurchasedMoreThan100Items
FROM tblSTORE AS
   JOIN tblSALES_ORDER SO ON S.StoreID = SO.StoreID
   JOIN tblDISTRIBUTOR D ON D.DistributorID = SO.DistributorID
   JOIN tblPURCHASE_ORDER P on D.DistributorID = P.DistributorID
   JOIN tblLINE_ITEM LI on P.PurchaseOrderID = LI.PurchaseOrderID
GROUP BY S.StoreID, S.StoreName
HAVING SUM(LI.LineItemQuantity) > '100') AS B
WHERE A.StoreID = B.StoreID
