CREATE DATABASE INFO_330_6AB
USE INFO_330_6AB

-- in DB
CREATE TABLE tblPRODUCT
(ProductID INT IDENTITY(1,1) primary key,
ProductName VARCHAR(30) NOT NULL,
ProductDEescription VARCHAR (100) NULL,
ProductTypeID INT FOREIGN KEY REFERENCES tblPRODUCT_TYPE (ProductTypeID) NOT NULL,
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
FarmerLname VARCHAR(30) NOT NULL,
FarmerBirth DATE NOT NULL,
FarmerTypeID INT FOREIGN KEY REFERENCES tblFARMER_TYPE (FarmerTypeID) NOT NULL)
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

ALTER TABLE tblPRODUCT ADD ProductTypeID INT FOREIGN KEY REFERENCES tblPRODUCT_TYPE (ProductTypeID) not null;

ALTER TABLE tblFARMER ADD FarmerBirth DATE;

ALTER TABLE tblFARMER ADD FarmerTypeID INT FOREIGN KEY REFERENCES tblFARMER_TYPE (FarmerTypeID);

ALTER TABLE tblSTORE ADD CountyID INT FOREIGN KEY REFERENCES tblCOUNTY (CountyID);

ALTER TABLE tblSTORE ADD StoreTypeID INT FOREIGN KEY REFERENCES tblSTORE_TYPE (StoreTypeID);

ALTER TABLE tblREVIEW ADD RatingID INT FOREIGN KEY REFERENCES tblRATING (RatingID);

ALTER TABLE tblDISTRIBUTOR ADD DistributorTypeID INT FOREIGN KEY REFERENCES tblDISTRIBUTOR_TYPE(DistributorTypeID);

DROP TABLE tblMEASUREMENT;

ALTER TABLE tblFARMER ADD CountyID INT FOREIGN KEY REFERENCES tblCOUNTY (CountyID);

ALTER TABLE tblDISTRIBUTOR ADD CountyID INT FOREIGN KEY REFERENCES tblCOUNTY (CountyID);




INSERT INTO tblPRODUCT_TYPE (ProductTypeName, ProductTypeDescr)
VALUES ('vegetable', 'a plant or part of a plant used as food')
 
INSERT INTO tblPRODUCT_TYPE (ProductTypeName, ProductTypeDescr)
VALUES ('fruit', 'The sweet and fleshy product of a tree or other plant that contains seed and can be eaten as food')
 
INSERT INTO tblPRODUCT_TYPE (ProductTypeName, ProductTypeDescr)
VALUES ('livestock', 'cattle, poultry, etc.')
 
INSERT INTO tblPRODUCT_TYPE (ProductTypeName, ProductTypeDescr)
VALUES ('dairy', 'milk products')

INSERT INTO tblFARMER_TYPE (FarmerTypeName, FarmerTypeDescr)
VALUES ('Small Farmer', 'Farmers that own or/and cultivate less than 2.0 hectare of land')
 
INSERT INTO tblFARMER_TYPE (FarmerTypeName, FarmerTypeDescr)
VALUES ('Semi Medium Farmer', 'Farmers that own or/and cultivate between 2.0-4.0 hectare of land')
 
INSERT INTO tblFARMER_TYPE (FarmerTypeName, FarmerTypeDescr)
VALUES ('Dairy Farmer', 'Farmers who have a herd producing milk')

INSERT INTO tblSTATE (StateName, StateAbbr)
VALUES ('Washington', 'WA')
 
INSERT INTO tblSTATE (StateName, StateAbbr)
VALUES ('Oregon', 'OR')
 
INSERT INTO tblSTATE (StateName, StateAbbr)
VALUES ('California', 'CA')

INSERT INTO tblSTORE_TYPE (StoreTypeName, StoreTypeDescr)
VALUES ('Supermarket', 'a large self-service store selling foods and household goods'), ('Convenience store', 'a store with extended opening hours and in a convenient location'), ('farmers\’ market', 'a food market at which local farmers sell fruit and vegetables and often meat, cheese, and bakery products directly to consumers')

INSERT INTO tblRATING(RatingNumber, RatingDescr)
VALUES('1', 'Very bad'), ('5', 'The best'), ('5', 'The best'), ('4', 'Very good'), ('3', 'Fine')

INSERT INTO tblDISTRIBUTOR_TYPE(DistributorTypeName, DistributorTypeDescr)
VALUES('Feed distributor','‘Sells only animal feed'), ('Grain distributor', 'Sells only wheat and oats'), ('Legume distributor', 'Sells only beans, lentils, and peas'), ('Vegetable Distributor', 'Sells only vegetables')



BACKUP DATABASE INFO_330_6AB TO DISK = 'C:\SQL\INFO_330_6AB.BAK'

-- BACKUP DATABASE INFO_330_6AB TO DISK = '/Users/marieoconnell/Desktop/INFO 330/databases-proj/INFO_330_6AB.BAK'
