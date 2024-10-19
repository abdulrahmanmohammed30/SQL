
-- Problem 1 
create view VechicleMasterDetails 
as 
	select ID,
		   VehicleDetails.MakeID, 
		   Make, VehicleDetails.ModelID,
		   ModelName, VehicleDetails.SubModelId, 
		   SubModelName,
		   VehicleDetails.BodyID
		   BodyName, 
		   Year, 
		   VehicleDetails.DriveTypeID, 
		   DriveTypeName,
		   Engine,
		   Engine_CC,
		   Engine_Cylinders,
		   Engine_Liter_Display,
		   VehicleDetails.FuelTypeID,
		   FuelTypeName,
		   NumDoors
	from VehicleDetails 
	join Makes on VehicleDetails.MakeID = Makes.MakeID
	join MakeModels on VehicleDetails.ModelID =MakeModels.ModelID
	join SubModels on VehicleDetails.SubModelID = SubModels.SubModelID 
	join Bodies on VehicleDetails.BodyID = Bodies.BodyID
	join DriveTypes on VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
	join FuelTypes on VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID 
select * from VechicleMasterDetails

-- Problem 2 
select * as NumberOfVehicles
from VehicleDetails
where Year between 1950 and 2000 

-- Problem 3
select count(1) as NumberOfVehicles
from VehicleDetails
where Year between 1950 and 2000 

-- Problem 4
select Makes.Make, count(1) as NumberOfVehicles
from VehicleDetails
inner join Makes on VehicleDetails.MakeID = Makes.MakeID
where Year between 1950 and 2000
group by Makes.Make
order by NumberOfVehicles desc

--Problem 5
--Problem 5 : Get All Makes that have manufactured more than 12000 Vehicles in years 1950 to 2000
-- using having
select Makes.Make, count(1) as NumberOfVehicles
from VehicleDetails
inner join Makes on VehicleDetails.MakeID = Makes.MakeID
where Year between 1950 and 2000
group by Makes.Make
having count(1) > 12000
order by NumberOfVehicles desc

-- using SubQueries 
select * 
from (
   select Makes.Make, count(1) as NumberOfVehicles
   from VehicleDetails
   inner join Makes on VehicleDetails.MakeID = Makes.MakeID
   where Year between 1950 and 2000
   group by Makes.Make
)x 
where NumberOfVehicles > 12000
order by NumberOfVehicles desc

--Problem 6
--Problem 6: Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside
select Makes.Make, count(1) as NumberOfVehicles, (select count(*) from VehicleDetails) as TotalVehicles
from VehicleDetails
inner join Makes on VehicleDetails.MakeID = Makes.MakeID
where Year between 1950 and 2000
group by Makes.Make
having count(1) > 12000
order by NumberOfVehicles desc


 --Problem 7: Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside it,
 --then calculate it's percentage
 -- don't round values in the database 
select Make, NumberOfVehicles, TotalVehicles, cast(NumberOfVehicles as decimal)/cast(TotalVehicles as decimal) as Perc from 
(
	select Makes.Make, count(1) as NumberOfVehicles, (select count(*) from VehicleDetails) as TotalVehicles
	from VehicleDetails
	inner join Makes on VehicleDetails.MakeID = Makes.MakeID
	where Year between 1950 and 2000
	group by Makes.Make
	having count(1) > 12000
)x
order by NumberOfVehicles desc

 --Problem 8: Get Make, FuelTypeName and Number of Vehicles per FuelType per Make
select Makes.Make, FuelTypeName, count(1) as NumberOfVehicles
from VehicleDetails
join Makes on VehicleDetails.MakeID = Makes.MakeID
join FuelTypes on VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
where Year between 1950 and 2000
group by Makes.Make, FuelTypes.FuelTypeName
order by Makes.Make

--Problem 9: Get all vehicles that runs with GAS  FuelTypeID 

--Problem 10: Get all Makes that runs with GAS
select distinct Makes.Make, FuelTypeName		   
from Makes
join VehicleDetails on Makes.MakeID = VehicleDetails.MakeID 
join FuelTypes on VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
where FuelTypeName = 'gas'

--Problem 11: Get Total Makes that runs with GAS
select count(distinct Makes.Make)		   
from Makes
join VehicleDetails on Makes.MakeID = VehicleDetails.MakeID 
join FuelTypes on VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
where FuelTypeName = 'gas'

--Problem 12: Count Vehicles by make and order them by NumberOfVehicles from high to low.
select Makes.Make, count(1) as NumberOfVehicles		   
from Makes
join VehicleDetails on Makes.MakeID = VehicleDetails.MakeID 
group by Makes.Make
order by NumberOfVehicles desc

--Problem 13: Get all Makes/Count Of Vehicles that manufactures more than 20K Vehicles
select Makes.Make, count(1) as NumberOfVehicles		   
from Makes
join VehicleDetails on Makes.MakeID = VehicleDetails.MakeID 
group by Makes.Make
having count(1) > 20000
order by NumberOfVehicles desc

--Problem 14: Get all Makes with make starts with 'B'
select Makes.MakeID, Makes.Make
from Makes
where Makes.Make Like 'B%'

 --Problem 15: Get all Makes with make ends with 'W'
select Makes.MakeID, Makes.Make
from Makes
where Makes.Make Like '%W'

--Problem 16: Get all Makes that manufactures DriveTypeName = FWD
select distinct Makes.Make, DriveTypes.DriveTypeName
from Makes
join VehicleDetails on Makes.MakeID = VehicleDetails.MakeID 
join DriveTypes on VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
where DriveTypeName = 'FWD'

--Problem 17: Get total Makes that Mantufactures DriveTypeName=FWD
select count(distinct Makes.Make)
from Makes
join VehicleDetails on Makes.MakeID = VehicleDetails.MakeID 
join DriveTypes on VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
where DriveTypeName = 'FWD'

--Problem 18: Get total vehicles per DriveTypeName Per Make and order them per make asc then per total Desc
select Makes.Make, DriveTypes.DriveTypeName, count(1) as TotalVehicles
from VehicleDetails
join Makes on VehicleDetails.MakeID = Makes.MakeID
join DriveTypes on VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
group by Makes.Make, DriveTypes.DriveTypeName
order by Makes.Make, TotalVehicles desc 

--Problem 19: Get total vehicles per DriveTypeName Per Make then filter only results with total > 10,000
select Makes.Make, DriveTypes.DriveTypeName, count(1) as TotalVehicles
from VehicleDetails
join Makes on VehicleDetails.MakeID = Makes.MakeID
join DriveTypes on VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
group by Makes.Make, DriveTypes.DriveTypeName
having count(1) > 10000
order by Makes.Make, TotalVehicles desc 

--Problem 20: Get all Vehicles that number of doors is not specified
select * 
from VehicleDetails 
where NumDoors is null 

--Problem 28: Get all vehicles that their body is 'Coupe' or 'Hatchback' or 'Sedan' and manufactured in year 2008 or 2020 or 2021
select * 
from VehicleDetails 
join Bodies on VehicleDetails.BodyID = Bodies.BodyID
where BodyName in ('Coupe','Hatchback','Sedan') and Year in (2008,2020,2021)


--Problem 29: Return found=1 if there is any vehicle made in year 1950
if exists (select 1 from VehicleDetails where Year = 1950)
 select 1 as found


--Problem 30: Get all Vehicle_Display_Name, NumDoors and add extra column to describe number of doors by words,
--and if door is null display 'Not Set'

select Vehicle_Display_Name, NumDoors, 
  case NumDoors
  when 0 then 'No Door'
  when 1 then 'One Door'
  when 2 then 'Two Doors'
  when 3 then 'Three Doors'
  when 4 then 'Four Doors'
  when 5 then 'Five Doors'
  when 6 then 'Six Doors'
  when 8 then 'Eight Doors'
  else 'Not Set'
  end 
from VehicleDetails


select distinct NumDoors
from VehicleDetails
order by NumDoors


-- Problem 40: Get all vehicles that has one of the Max 3 Engine CC
select 
           MakeID, 
		   ModelID,
		   SubModelId, 
		   BodyID
		   BodyName, 
		   Year, 
		   DriveTypeID, 
		   Engine,
		   Engine_CC,
		   Engine_Cylinders,
		   Engine_Liter_Display,
		   FuelTypeID,
		   NumDoors
from (
   select VehicleDetails.*,  dense_rank() over(order by Engine_CC desc) as rank from VehicleDetails 
)x 
where rank <=3

select 
 MakeID, 
		   ModelID,
		   SubModelId, 
		   BodyID
		   BodyName, 
		   Year, 
		   DriveTypeID, 
		   Engine,
		   VehicleDetails.Engine_CC,
		   Engine_Cylinders,
		   Engine_Liter_Display,
		   FuelTypeID,
		   NumDoors
from 
VehicleDetails 
join
(
	select distinct top 3 Engine_CC
	from VehicleDetails
	order by Engine_CC desc 
)x 
 on x.Engine_CC = VehicleDetails.Engine_CC


 select * from VehicleDetails 
 where Engine_CC in 
  (
	  select distinct top 3 Engine_CC
      from VehicleDetails
	  order by Engine_CC desc 
  )

-- Problem 44: Get Total Number Of Doors Manufactured by 'Ford'
select Makes.Make, sum(isnull(numDoors,0)) as TotalNumberOfDoors
from VehicleDetails
join Makes on VehicleDetails.MakeID = Makes.MakeID
where Makes.Make ='Ford'
group by Makes.Make

--Problem 46: Get the highest 3 manufacturers that make the highest number of models
select top 3 Makes.Make, count(1) as NumberOfModels
	from MakeModels 
	join Makes on MakeModels.MakeID = Makes.MakeID
	group by Makes.Make
	order by NumberOfModels desc	


--Problem 48: Get the highest Manufacturers manufactured the highest number of models
--Get the highest Manufacturers manufactured the highest number of models , 
--remember that they could be more than one manufacturer have the same high number of models
select top 1 with ties count(1) as NumberOfModels
	from MakeModels 
	join Makes on MakeModels.MakeID = Makes.MakeID
	group by Makes.Make
	order by NumberOfModels desc


select Makes.Make, count(1) as NumberOfModels
from MakeModels 
join Makes on MakeModels.MakeID = Makes.MakeID
group by Makes.Make
having count(1) =  
(
select max(NumberOfModels) 
from 
 (
	  select count(1) as NumberOfModels
	  from MakeModels 
	  join Makes on MakeModels.MakeID = Makes.MakeID
	  group by Makes.Make
 )x
)


select Makes.Make, count(1) as NumberOfModels
from MakeModels 
join Makes on MakeModels.MakeID = Makes.MakeID
group by Makes.Make
having count(1) =  
(
select min(NumberOfModels) 
from 
 (
	  select count(1) as NumberOfModels
	  from MakeModels 
	  join Makes on MakeModels.MakeID = Makes.MakeID
	  group by Makes.Make
 )x
)

