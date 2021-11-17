CREATE DATABASE INFO_330_6AB
USE INFO_330_6AB

-- in DB
CREATE TABLE tblPRODUCT
(ProductID INT IDENTITY(1,1) primary key,
ProductName VARCHAR(30) NOT NULL,
ProductDEescription VARCHAR (100) NULL,
ProductPrice NUMERIC(8,2))
GO

-- in DB
CREATE TABLE tblORDER_PRODUCT
(OrderProductID INT IDENTITY(1,1) primary key,
SalesOrderID INT FOREIGN KEY REFERENCES tblSALES_ORDER (SalesOrderID) NOT NULL,
ProductID INT FOREIGN KEY REFERENCES tblPRODUCT (ProductID) NOT NULL,
OrderQuanntity VARCHAR(10) NOT NULL)
GO

-- in DB
CREATE TABLE tblSALES_ORDER
(SalesOrderID INT IDENTITY(1,1) primary key,
OrderDescription VARCHAR(100) NULL,
OrderDate DATE NOT NULL,
StoreID INT FOREIGN KEY REFERENCES tblSTORE (StoreID) NOT NULL,
DistributorID INT FOREIGN KEY REFERENCES tblDISTRIBUTOR (DistributorID) NOT NULL,
OrderAmount VARCHAR(10))
GO

-- in DB
CREATE TABLE tblRATING
(RatingID INT IDENTITY(1,1) primary key,
RatingNumber INT,
RatingDescr varchar(500) null)
GO

-- in DB
CREATE TABLE tblREVIEW
(ReviewID INT IDENTITY(1,1) primary key,
ReviewDescr VARCHAR(100) NULL,
SalesOrderID INT FOREIGN KEY REFERENCES tblSALES_ORDER (SalesOrderID) NOT NULL)
GO

-- in DB
CREATE TABLE tblSTORE
(StoreID INT IDENTITY(1,1) primary key,
StoreName VARCHAR(30) NOT NULL)
GO

-- in DB
CREATE TABLE tblSTORE_TYPE
(StoreTypeID INT IDENTITY(1,1) primary key,
StoreTypeName varchar(50) not null,
StoreTypeDescr varchar(500) null)
GO

-- in DB
CREATE TABLE tblPURCHASE_ORDER
(PurchaseOrderID INT IDENTITY(1,1) primary key,
FarmerID INT FOREIGN KEY REFERENCES tblFARMER (FarmerID) NOT NULL,
OrderDescription VARCHAR(100) NULL,
OrderAmount NUMERIC(8, 2) NOT NULL,
OrderDate DATE NOT NULL,
DistributorID INT FOREIGN KEY REFERENCES tblDISTRIBUTOR (DistributorID) NOT NULL)
GO

-- in DB
CREATE TABLE tblFARMER
(FarmerID INT IDENTITY(1,1) primary key,
FarmerFname VARCHAR(10) NOT NULL,
FarmerLname VARCHAR(30) NOT NULL)
GO

-- in DB
CREATE TABLE tblFARMER_TYPE
(FarmerTypeID INT IDENTITY(1,1) primary key,
FarmerTypeName varchar(50) not null,
FarmerTypeDescr varchar(500) null)
GO

-- in DB
CREATE TABLE tblDISTRIBUTOR
(DistributorID INT IDENTITY(1,1) primary key,
DistributorTypeID INT foreign key references tblDISTRIBUTOR_TYPE (DistributorTypeID) not null,
DistributorName varchar(50) not null,
CountyID INT foreign key references tblCOUNTY (CountyID) not null)
GO

-- in DB 
CREATE TABLE tblDISTRIBUTOR_TYPE
(DistributorTypeID INT IDENTITY(1,1) primary key,
DistributorTypeName varchar(50) not null,
DistributorTypeDescr varchar(500) null)
GO

-- in DB
CREATE TABLE tblCOUNTY
(CountyID INT IDENTITY(1,1) primary key,
CountyName varchar(30) not null,
StateID INT foreign key references tblSTATE (StateID) not null)
GO

-- in DB
CREATE TABLE tblSTATE
(StateID INT IDENTITY(1,1) primary key,
StateName varchar(30) not null,
StateAbbr char(10) not null)

-- in DB
CREATE TABLE tblLINE_ITEM
(LineItemID INT IDENTITY(1,1) primary key,
ItemID INT foreign key references tblITEM (ItemID) not null,
PurchaseOrderID INT foreign key references tblPURCHASE_ORDER (PurchaseOrderID) not null,
LineItemQuantity INT not null,
LineItemPrice numeric(8,2) not null)
GO

-- in DB 
CREATE TABLE tblITEM
(ItemID INT IDENTITY(1,1) primary key,
ItemTypeID INT foreign key references tblITEM_TYPE (ItemTypeID) not null,
ItemName varchar(50) not null)
GO
 
-- in DB 
CREATE TABLE tblITEM_TYPE
(ItemTypeID INT IDENTITY(1,1) primary key,
ItemTypeName varchar(50) not null,
ItemTypeDesr varchar(500) null)
GO

-- in DB
CREATE TABLE tblPRODUCT_TYPE
(ProductTypeID INT IDENTITY(1,1) primary key,
ProductTypeName varchar(50) not null,
ProductTypeDescr varchar(500) null)
GO

-- in DB
CREATE TABLE tblMEASUREMENT
(MeasurementID INT IDENTITY(1,1) primary key,
MeasureName varchar(50) not null,
MeasureAbbre char(10) not null)
GO


ALTER TABLE tblSALES_ORDER
DROP COLUMN OrderAmount;
