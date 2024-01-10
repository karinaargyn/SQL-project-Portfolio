*/
--DATA CLEANING IN SQL
/*

--date format
select *
from [dbo].[Nashville_Housing]

select SaleDateConverted, Convert(Date,saleDate)
from [dbo].[Nashville_Housing]

Update [dbo].[Nashville_Housing]
Set SaleDate = convert(date, saledate)

Alter table [dbo].[Nashville_Housing]
add saledateconverted date;

Update [dbo].[Nashville_Housing]
Set saledateconverted = convert(date, saledate)


-- Populate Property Address data

select *
from [dbo].[Nashville_Housing]
--Where PropertyAddress is null
Order by ParcelID

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
from [dbo].[Nashville_Housing] a
join [dbo].[Nashville_Housing] b
	on a.parcelid = b.parcelid
	and a.uniqueID<>b.uniqueid
Where a.propertyaddress is null

update a
set propertyaddress = isnull(a.propertyaddress,'No Address')
from [dbo].[Nashville_Housing] a
join [dbo].[Nashville_Housing] b
	on a.parcelid = b.parcelid
	and a.uniqueID<>b.uniqueid
Where a.propertyaddress is null


-- Breaking address into individual columns

select PropertyAddress
from [dbo].[Nashville_Housing]
--Where PropertyAddress is null
--Order by ParcelID

Select 
Substring(PropertyAddress, 1, charindex(',', PropertyAddress) - 1) as Address
, Substring(PropertyAddress, charindex(',', PropertyAddress)+1, len(Propertyaddress)) as Address

From [dbo].[Nashville_Housing]


Alter table [dbo].[Nashville_Housing]
add PropertySplitAddress Nvarchar (255);

Update [dbo].[Nashville_Housing]
Set PropertySplitAddress = (PropertyAddress, 1, charindex(',', PropertyAddress) - 1)

Alter table [dbo].[Nashville_Housing]
add PropertySplitCity Nvarchar (255);

Update [dbo].[Nashville_Housing]
Set PropertySplitCity = (PropertyAddress, charindex(',', PropertyAddress)+1, len(Propertyaddress))


Select *
From [dbo].[Nashville_Housing]


Select Owneraddress
From [dbo].[Nashville_Housing]


Select 
Parsename(Replace (Owneraddress, ',', ' '), 3)
,Parsename(Replace (Owneraddress, ',', ' '), 2)
,Parsename(Replace (Owneraddress, ',', ' '), 1)
From [dbo].[Nashville_Housing]

Alter table [dbo].[Nashville_Housing]
add OwnerSplitAddress Nvarchar (255);

Update [dbo].[Nashville_Housing]
Set OwnerSplitAddress = Parsename(Replace (Owneraddress, ',', ' '), 3)

Alter table [dbo].[Nashville_Housing]
add OwnerSplitCity Nvarchar (255);

Update [dbo].[Nashville_Housing]
Set OwnerSplitCity = Parsename(Replace (Owneraddress, ',', ' '), 2)

Alter table [dbo].[Nashville_Housing]
add OwnerSplitState Nvarchar (255);

Update [dbo].[Nashville_Housing]
Set OwnerSplitState = Parsename(Replace (Owneraddress, ',', ' '), 1)


Select *
From [dbo].[Nashville_Housing]

-- Change Y and N to Yes and No in "Sold asVacant" field

Select Distinct (SoldasVacant),count(SoldasVacant)
From [dbo].[Nashville_Housing]
Group by SoldasVacant
Order by 2

Select SoldasVacant
, case When Soldasvacant = 'Y' then 'Yes'
	when Soldasvacant = 'N' then 'No'
	Else soldasvacant 
	End
From [dbo].[Nashville_Housing]


Update [dbo].[Nashville_Housing]
Set SoldasVacant = case When Soldasvacant = 'Y' then 'Yes'
	when Soldasvacant = 'N' then 'No'
	Else soldasvacant 
	End


-- Remove Duplicates


With RownumCTE as(
Select *,
	Row_number() over (
	Partition by ParcelID,
				Propertyaddress,
				SalePrice,
				Saledate,
				LegalReference
				Order by UniqueID
				) row_num

From [dbo].[Nashville_Housing]
--Order by ParcelID
)
Delete
From RowNumCTE
Where row_num>1
--Order by PropertyAddress



--Delete unused columns
Select *
From [dbo].[Nashville_Housing]

Alter Table [dbo].[Nashville_Housing]
Drop Column OwnerAddress, PropertyAddress

Alter Table [dbo].[Nashville_Housing]
Drop Column SaleDate