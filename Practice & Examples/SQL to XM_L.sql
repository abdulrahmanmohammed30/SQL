 
 use PrivateTutoring;
 
 select Senses.Id 'Sense/@Id', Senses.Definition 'Sense/Definition',
 Examples.Id 'Sense/Examples/Example/@Id' ,
 Examples.Text 'Sense/Examples/Example/Text'
 from Examples 
 join Senses 
 on Examples.SenseId = Senses.Id
 for xml path('Sense'), root('Senses')


 select * 
 from Examples 
 for xml raw('Example'), root('Exmaples'), Elements

 create synonym Persons for Individuals.Persons

 SELECT Persons.ID '@Id', 
        Persons.FullName 'Name',
		Teachers.Specialization 'Specialization', 
		Teachers.HourlyRate 'HourlyRate', 
		Persons.Email 'Email',
		Persons.PhoneNumber 'PhoneNumber'
 FROM Persons 
 JOIN Teachers
 on Persons.Id = Teachers.ID
for xml path('Teacher'), root('Teachers'), elements xsinil

create synonym Levels for Academics.Levels
create synonym Centers for Locations.Centers
create synonym ClassSchedules for Academics.ClassSchedules

select Subjects.ID '@Id',
       Subjects.Name 'Name',
	   Levels.Text 'Level',
	   Classes.ID 'Classes/Class/@Id',
	   Classes.StartDate 'Classes/Class/StartDate',
	   Classes.EndDate 'Classes/Class/EndDate',
	   Classes.MaxStudents 'Classes/Class/MaxStudents',
	   ClassSchedules.ID 'Classes/Class/Schedule/@Id',
	   ClassSchedules.WeekDay 'Classes/Class/Schedule/WeekDay',
	   ClassSchedules.StartTime 'Classes/Class/Schedule/StartTime',
	   ClassSchedules.EndTime 'Classes/Class/Schedule/EndTime',
	   Centers.ID 'Classes/Class/Centers/Centere/@Id',
	   Centers.Name 'Classes/Class/Centers/Centere/Name',
	   Centers.City 'Classes/Class/Centers/Centere/City',
	   Centers.Address 'Classes/Class/Centers/Centere/Address',
	   Centers.Capacity 'Classes/Class/Centers/Centere/Capacity',
	   Centers.PhoneNumber 'Classes/Class/Centers/Centere/PhoneNumber',
	   Persons.ID 'Classes/Class/Teacher/@Id', 
       Persons.FullName 'Classes/Class/Teacher/Name',
	   Teachers.Specialization 'Classes/Class/Teacher/Specialization', 
	   Teachers.HourlyRate 'Classes/Class/Teacher/HourlyRate', 
	   Persons.Email 'Classes/Class/Teacher/Email',
	   Persons.PhoneNumber 'Classes/Class/Teacher/PhoneNumber'
from Subjects
join Levels on Subjects.Level = Levels.ID 
join Classes on Classes.SubjectID = Subjects.ID
join Centers on Classes.CenterID = Centers.ID
join ClassSchedules on ClassSchedules.ClassID = Classes.ID
join Teachers on Classes.TeacherID = Teachers.ID
join Persons on Teachers.Id = Persons.ID
for xml path ('Subject'), root('Subjects'), elements xsinil



use Bikes;
select * 
from Bikeshares 
join Stations StartStation on Bikeshares.StartStationNumber = StartStation.StationNumber
join Stations EndStation on Bikeshares.EndStationNumber = EndStation.StationNumber
join BikeShareMemebershipTypes on Bikeshares.MemberTypeID = BikeShareMemebershipTypes.ID
for xml auto, root('Bikeshares'), elements, elements xsinil

use remove3;
select * from employees

select * 
from Employees 
for xml raw('Employee'), root('Employees'), elements xsinil