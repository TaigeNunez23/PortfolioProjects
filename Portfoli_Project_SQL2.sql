Select *
From SQLCleaningProject.dbo.NashvilleHousing

--Standardize Date Format

Select SaleDate, Convert(date,SaleDate)
From dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(date,SaleDate)


--Populate Property Address data

Select*
From SQLCleaningProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,B.PropertyAddress)
From SQLCleaningProject.dbo.NashvilleHousing a
Join SQLCleaningProject.dbo.NashvilleHousing b
	on a.ParcelID = b. ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From SQLCleaningProject.dbo.NashvilleHousing a
Join SQLCleaningProject.dbo.NashvilleHousing b
	on a.ParcelID = b. ParcelID
	AND a.[UniqueID] <> b.[UniqueID]


--Breaking out Address into Individual Columns (Address,City,State)


Select PropertyAddress
From SQLCleaningProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

From SQLCleaningProject.dbo.NashvilleHousing


ALTER TABLE SQLCleaningProject.dbo.NashvilleHousing
add PropertySplitAddress Nvarchar(255)

Update SQLCleaningProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE SQLCleaningProject.dbo.NashvilleHousing
add PropertySplitCity Nvarchar(255)


update SQLCleaningProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) 


Select *
From SQLCleaningProject.dbo.NashvilleHousing




Select OwnerAddress
From SQLCleaningProject.dbo.NashvilleHousing




Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From SQLCleaningProject.dbo.NashvilleHousing



ALTER TABLE SQLCleaningProject.dbo.NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

Update SQLCleaningProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE SQLCleaningProject.dbo.NashvilleHousing
add OwnerSplitCity Nvarchar(255)


update SQLCleaningProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE SQLCleaningProject.dbo.NashvilleHousing
add OwnerSplitState Nvarchar(255)


update SQLCleaningProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


Select Distinct(SoldAsVacant), Count(SoldasVacant)
From SQLCleaningProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
From SQLCleaningProject.dbo.NashvilleHousing


Update SQLCleaningProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE 
	   When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END


--Removing Duplicates
 
 With RowNumCTE AS(
 Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY
		UniqueID
		) row_num
From SQLCleaningProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num >1
Order by PropertyAddress


--Delete Unused Column

Select *
From SQLCleaningProject.dbo.NashvilleHousing


Alter Table SQLCleaningProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict

Alter Table SQLCleaningProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
