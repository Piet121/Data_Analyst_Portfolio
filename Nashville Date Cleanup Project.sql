/*

 Data Cleaning Project - Transform

*/

--Standardize Date Formant

SELECT *
FROM [Portfolio Project]..NashvilleHousing

ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate date


--Populate Property Address data where Property address is NULL


SELECT *
FROM [Portfolio Project]..NashvilleHousing



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM [Portfolio Project]..NashvilleHousing as a
JOIN [Portfolio Project]..NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	
WHERE a.PropertyAddress is null



UPDATE a
SET a.PropertyAddress = b.PropertyAddress
FROM [Portfolio Project]..NashvilleHousing as a
JOIN [Portfolio Project]..NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM [Portfolio Project]..NashvilleHousing


SELECT 

--SUBSTRING(PropertyAddress, 1, CHARINDEX(' ', PropertyAddress) -1) As HouseNumber
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) As Address
	,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) As Address
FROM [Portfolio Project]..NashvilleHousing



ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *

From [Portfolio Project]..NashvilleHousing