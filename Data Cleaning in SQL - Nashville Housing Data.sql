/*

 DATA CLEANING IN SQL

*/


SELECT *
FROM PortfolioProject..NashvilleHousing



-- Standard date format


SELECT SaleDate, CONVERT(Date,SaleDate)
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject..NashvilleHousing





-- Populate Property Address Data


SELECT *
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null




-- Breaking out address into individual column (Address, City, State)


SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 ,LEN(PropertyAddress)) as Address
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255) ;

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD  PropertySplitCity nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 ,LEN(PropertyAddress))

SELECT *
FROM PortfolioProject..NashvilleHousing




SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255) ;

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
ADD  OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255) ;

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


SELECT *
FROM PortfolioProject..NashvilleHousing






-- Change Y and N to Yes and NO in SoldAsVacant


SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2 


SELECT SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 END
FROM PortfolioProject..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 END






-- REMOVE DUPLICATES


with RowNumCTE AS(
SELECT *,
	ROW_NUMBER() over(
	Partition by parcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	order by UniqueID
	) as RowNum

FROM PortfolioProject..NashvilleHousing
--order by ParcelID
)
SELECT *
FROM RowNumCTE
where RowNum > 1
order by PropertyAddress







-- Delete unused colums


Select *
From PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter table PortfolioProject..NashvilleHousing
Drop Column SaleDate



