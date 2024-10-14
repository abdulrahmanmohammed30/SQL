
--declare @xmlVar xml
--declare @xmlVarPointer INT 
--select @xmlVar=cast(BulkColumn as xml) from openrowset(Bulk 'F:\files\file2.xml',SINGLE_BLOB) x

--exec sp_xml_preparedocument @xmlVarPointer output, @xmlVar

--select * 
--from openxml(@xmlVarPointer, '//Subject')
--with (
--    Id INT '@Id',
--    Name NVARCHAR(100) 'Name',
--    Level NVARCHAR(50) 'Level',
--    ClassId INT 'Classes/Class/@Id',
--    StartDate DATETIME 'Classes/Class/StartDate',
--    EndDate DATETIME 'Classes/Class/EndDate',
--    MaxStudents INT 'Classes/Class/MaxStudents',
--    ScheduleId INT 'Classes/Class/Schedule/@Id',
--    WeekDay INT 'Classes/Class/Schedule/WeekDay',
--    StartTime TIME 'Classes/Class/Schedule/StartTime',
--    EndTime TIME 'Classes/Class/Schedule/EndTime',
--    CenterId INT 'Classes/Class/Centers/Centere/@Id',
--    CenterName NVARCHAR(100) 'Classes/Class/Centers/Centere/Name',
--    City NVARCHAR(50) 'Classes/Class/Centers/Centere/City',
--    Address NVARCHAR(100) 'Classes/Class/Centers/Centere/Address',
--    Capacity INT 'Classes/Class/Centers/Centere/Capacity',
--    CenterPhoneNumber NVARCHAR(20) 'Classes/Class/Centers/Centere/PhoneNumber',
--    TeacherId INT 'Classes/Class/Teacher/@Id',
--    TeacherName NVARCHAR(100) 'Classes/Class/Teacher/Name',
--    Specialization NVARCHAR(50) 'Classes/Class/Teacher/Specialization',
--    HourlyRate DECIMAL(10, 2) 'Classes/Class/Teacher/HourlyRate',
--    TeacherEmail NVARCHAR(100) 'Classes/Class/Teacher/Email',
--    TeacherPhoneNumber NVARCHAR(20) 'Classes/Class/Teacher/PhoneNumber'

--)

--exec sp_xml_removedocument @xmlVarPointer



--Declare @file XML 
--Declare @hfile INT
--select @file=cast(BulkColumn as xml) from openrowset(Bulk 'F:\files\file1.xml', SINGLE_BLOB) x

--exec sp_xml_preparedocument @hfile output, @file

--select * 
--from OPENXML(@hfile, '//Employee')
--with (
--   Id INT 'EmployeeID',
--   Name varchar(50) 'Name',
--   JobTitle varchar(50) 'JobTitle',
--   DepartmentID INT 'DepartmentID',
--   HireDate date 'HireDate',
--   Salary decimal(19,2) 'Salary'
--)

--exec sp_xml_removedocument @hfile


--declare @v xml, @ptr int 
--select @v=cast(bulkcolumn as xml) from openrowset(bulk 'F:\files\file3.xml', single_blob) x

--exec sp_xml_preparedocument @ptr output, @v 

--select * from openxml(@ptr, '//Teacher')
--with (
--    TeacherId INT 'Classes/Class/Teacher/@Id',
--    TeacherName NVARCHAR(100) 'Classes/Class/Teacher/Name',
--    Specialization NVARCHAR(50) 'Classes/Class/Teacher/Specialization',
--    HourlyRate DECIMAL(10, 2) 'Classes/Class/Teacher/HourlyRate',
--    TeacherEmail NVARCHAR(100) 'Classes/Class/Teacher/Email',
--    TeacherPhoneNumber NVARCHAR(20) 'Classes/Class/Teacher/PhoneNumber'
--)

--exec sp_xml_removedocument @ptr