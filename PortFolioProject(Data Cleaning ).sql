select * 
from portfolioproject.dbo.nashville;
/* DATA CLEANING USING ALEX THE ANALYST DATASET AND HIS TUTORIALS */
-- Standardise the date
Update portfolioproject.dbo.nashville
set SaleDate = cast(SaleDate as date);

alter table nashville
add SaleDateConverted Date;

Update portfolioproject.dbo.nashville
set SaleDateConverted = cast(SaleDate as date);

select SaleDateConverted
from portfolioproject.dbo.nashville ;


-- Populate the property address data
/* we checked the property address and found some null value in them and then joined the table to it self to pupulate them*/

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress , isnull(a.PropertyAddress,b.PropertyAddress)/* isnull checks if the first column is empty fill it with second column*/
from portfolioproject.dbo.nashville a
join portfolioproject.dbo.nashville b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]/*Unique ID is different but parcelid is same we used that to join table and find the null in property address*/ 
where a.PropertyAddress is null


update a
set 
PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)/*here we assign Propery address */
from portfolioproject.dbo.nashville a
join portfolioproject.dbo.nashville b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking Down Address into individual columns

select PropertyAddress
from portfolioproject.dbo.nashville ;
/*After this query we got to know Property address have comma in them we need toseperate themfor betterr analysis*/

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))  as Address
from portfolioproject.dbo.nashville;
/*Here we used substring to select the string value in proprty address and then used charindex to search for comma and then -1 to ignore than comma */
-- and then I don't know what is going on I just copying everything from tutorial

alter table portfolioproject.dbo.nashville
add PropertySplitAddress nvarchar(255);

Update portfolioproject.dbo.nashville
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1);

alter table portfolioproject.dbo.nashville
add PropertySplitCity nvarchar(255);

Update portfolioproject.dbo.nashville
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress));

select PropertySplitAddress, PropertySplitCity
from portfolioproject.dbo.nashville ;

-- Seperating owner address using parse

select 
parsename(replace(OwnerAddress,',','.') ,3),
parsename(replace(OwnerAddress,',','.') ,2),
parsename(replace(OwnerAddress,',','.') ,1)

from portfolioproject.dbo.nashville ;


alter table portfolioproject.dbo.nashville
add OwnerSplitAddress nvarchar(255);

Update portfolioproject.dbo.nashville
set OwnerSplitAddress = parsename(replace(OwnerAddress,',','.') ,3);

alter table portfolioproject.dbo.nashville
add OwnerSplitCity nvarchar(255);

Update portfolioproject.dbo.nashville
set OwnerSplitCity = parsename(replace(OwnerAddress,',','.') ,2);

alter table portfolioproject.dbo.nashville
add OwnerSplitState nvarchar(255);

Update portfolioproject.dbo.nashville
set OwnerSplitState = parsename(replace(OwnerAddress,',','.') ,1);

select OwnerSplitAddress,OwnerSplitCity,OwnerSplitState
from portfolioproject.dbo.nashville;

-- Change Y and N to Yes and No in sold as Vacant

select distinct(SoldAsVacant), count(SoldAsVacant)
from portfolioproject.dbo.nashville 
group by SoldAsVacant
order by 2;

select SoldAsVacant ,
case when SoldAsVacant = 'Y' then 'Yes' 
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from portfolioproject.dbo.nashville;

update portfolioproject.dbo.nashville
set 
SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes' 
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end ;


-- Removing Duplicates 
/* I have no idea what I did*/ 

with RowNumCTE as (
select * ,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) row_num
from portfolioproject.dbo.nashville
)
Select *
from RowNumCTE
where row_num > 1


-- Delete Unused columns
alter table portfolioproject.dbo.nashville
drop column OwnerAddress, TaxDistrict,PropertyAddress , SaleDate

select * 
from portfolioproject.dbo.nashville



