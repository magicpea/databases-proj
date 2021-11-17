-- Quynh 
--- stored procedure: insert a new order made by a new distributor to a new farmer  
CREATE PROCEDURE qdoanINSERT_FARMER_ORDER
@F varchar(30),
@L varchar(30),
@OD varchar(50),
@OA Numeric(8,2),
@ODa Date,
@DT varchar(30),
@DN varchar(30)
AS
DECLARE @F_ID INT, @D_ID INT 
SET @F_ID = (SELECT FarmerID FROM tblFARMER WHERE FarmerFname = @F and FarmerLname = @L)
SET @D_ID = (SELECT DistributorID FROM tblDISTRIBUTOR WHERE DistributorType = @DT and DistributorName = @DN)

BEGIN TRANSACTION T1
INSERT INTO tblFARMER (FarmerFname, FarmerLname)
VALUES(@F, @L)

SET @F_ID = (SELECT SCOPE_IDENTITY()) 

INSERT INTO tblDISTRIBUTOR(DistributorType, DistributorName)
VALUES(@DT, @DN)

SET @D_ID = (SELECT SCOPE_IDENTITY()) 

INSERT INTO tblPURCHASE_ORDER(FarmerID, OrderDescription, OrderAmount, OrderDate, DistributorID)
VALUES(@F_ID, @OD, @OA, @ODa, @D_ID)

COMMIT TRANSACTION T1

--- example of executing this procedure 
EXECUTE qdoanINSERT_FARMER_ORDER 
@F = "Kenny",
@L = "Luong",
@OD = "Monthly fresh vegetables and fruits",
@OA = "50.0",
@ODa = 'November 2, 2021',
@DT = "retail",
@DN = "Costco"

GO

-- Marie 
-- insert a new review made by an existing store to an existing distributor
CREATE PROCEDURE moconnellINSERT_NEW_REVIEW_STORE_DISTRIB
@RD VARCHAR(100),
@SO VARCHAR(30)

AS

DECLARE @SO_ID INT
SET @SO_ID = (SELECT R.ReviewID FROM tblREVIEW WHERE R.ReviewID = @R_ID)