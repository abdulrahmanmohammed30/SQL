
create database PrivateTutoring
Go

use PrivateTutoring
Go

create schema Individuals
Go

CREATE FUNCTION Individuals.IsValidEmail (@Email NVARCHAR(255))
RETURNS BIT
AS
BEGIN
    IF @Email IS NULL
        RETURN 0;

    -- Basic email pattern check using LIKE
    IF @Email LIKE '%_@__%.__%' 
        RETURN 1; -- Valid email format

    RETURN 0; -- Invalid email format
END;
Go

create table Individuals.Persons (
  ID INT Identity(1,1) primary key, 
  FirstName nvarchar(50) not null, 
  LastName nvarchar(50) not null, 
  FullName as (FirstName + LastName),
  PhoneNumber char(11) not null unique, 
  Email nvarchar(50) not null unique Check(Individuals.IsValidEmail(Email)=1), 
  CreatedAt DATETIME2 not null default getdate(),
  Constraint CK_Persons_CreatedAt Check (Year(CreatedAt) >= 2012 and Year(CreatedAt) <= Year(getdate())),
  Constraint CK_Persons_PhoneNumber Check (PhoneNumber NOT Like '%[^0-9]%'), 
);
Go

create table Individuals.Teachers (
  ID INT not null, 
  Specialization nvarchar(50) not null, 
  HourlyRate Decimal(10,2) not null Check (HourlyRate >= 0),
  BirthDate DATETIME2 not null,
  Age as (Year(getdate()) - Year(BirthDate)),

  Constraint PK_Teachers_ID primary key (ID),
  Constraint FK_Teachers_Individuals foreign key(ID) references Individuals.Persons(ID),
  Constraint CK_Teachers_BirthDate Check (Year(getdate()) - Year(BirthDate) between 20 and 60)
);

create table Individuals.Students (
  ID INT Identity(1,1) primary key,  
  EnrollmentStatus BIT not null, 
  Constraint FK_Students_Individuals foreign key(ID) references Individuals.Persons(ID),
)
Go

create schema Locations; 
Go

create table Locations.Centers (
  ID INT not null, 
  Name varchar(50) not null, 
  City varchar(50) not null, 
  Address varchar(200) not null,
  Capacity smallINT not null, 
  PhoneNumber varchar(11) not null unique, 
  CreatedAt DATETIME2 not null default getdate(),

 Constraint PK_Centers_ID Primary Key(ID), 
 Constraint CK_Centers_PhoneNumber Check (PhoneNumber NOT Like '%[^0-9]%'), 
 Constraint CK_Centers_Capacity Check (Capacity > 0 ), 
 Constraint CK_Centers_CreatedAt Check (Year(CreatedAT) > 2012 and Year(CreatedAT) <= Year(getdate())),
 CONSTRAINT CK_Centers_City CHECK (
        City IN (
            'Cairo', 
            'Alexandria', 
            'Giza', 
            'Shubra El Kheima', 
            'Port Said', 
            'Suez', 
            'Mansoura', 
            'Tanta', 
            'Asyut', 
            'Ismailia', 
            'Faiyum', 
            'Zagazig', 
            'Damanhur', 
            'Qalyubia', 
            '6th of October', 
            '10th of Ramadan', 
            'Marsa Matruh', 
            'El Minya', 
            'Beni Suef', 
            'Kafr El Sheikh', 
            'Dakahlia', 
            'Sharqia', 
            'Gharbia', 
            'Helwan', 
            'New Cairo', 
            'October 6 City', 
            'Dayrout', 
            'Maqatir', 
            'Nag Hammadi', 
            'Hurghada', 
            'Sharm El Sheikh', 
            'Luxor', 
            'Aswan', 
            'Taba', 
            'Dahab', 
            'El Alamein', 
            'Port Said', 
            'Ain Shams', 
            'Haram', 
            'Salah Salem', 
            'Maadi', 
            'Obour City', 
            'Sadat City', 
            'Al Arish', 
            'Nuweiba', 
            'Al Jizah', 
            'Al Qalyubia', 
            'Wadi El Natron', 
            'Nile City Towers',
            'Sohag', 
            'Qena', 
            'Malawi', 
            'Kom Ombo',
            'Kassasin', 
            'Badr City', 
            'New Sharqia', 
            'New Valley'
        ))
)
Go

create schema Academics
Go


create table Academics.Levels (
 ID TINYINT Identity(1,1) primary key, 
 Text varchar(30) not null unique
)

create table Academics.Subjects (
	ID INT Identity(1,1) primary key, 
	Name varchar(30) not null, 
	
	Level TINYINT not null foreign key references Academics.Levels(ID),
	CreatedAt DATETIME2 not null default getdate(),
)
Go

create table Academics.Classes (
	ID INT Identity(1,1) primary key, 
	TeacherID INT foreign key references Individuals.Teachers(ID) on update cascade on delete set null, 
	SubjectID INT not null foreign key references Academics.Subjects(ID) on update cascade on delete cascade, 
	CenterID INT foreign key references Locations.Centers(ID) on update cascade on delete set null, 
	StartDate DATETIME2 not null, 
	EndDate DATETIME2 not null, 
	MaxStudents smallint not null,
	CreatedAT DATETIME2 not null default getdate()
)
Go

create table Academics.ClassSchedules (
    ID INT Identity(1,1) Primary key,
	ClassID INT not null, 

    -- Days starts at Saturday as 0 and Friday as 6
	WeekDay TINYINT not null Check(WeekDay >= 0 and Weekday <=6), 
	StartTime TIME not null, 
	EndTime Time not null,

    Constraint FK_ClassSchedule_Classes FOREIGN KEY (ClassID) REFERENCES Academics.Classes(ID) on update cascade on delete cascade
);
Go

create table Academics.Enrollments (
 ID INT not null primary key, 
 StudentID INT not null foreign key references Individuals.Students(ID) on update cascade on delete cascade,  
 ClassID INT not null foreign key references Academics.Classes(ID) on update cascade on delete cascade, 
 Grade decimal(4, 2) null,
 AttendancePercentage INT not null Check (AttendancePercentage between 0 and 100), 
 Feedback nvarchar(3000) not null,
 CreatedAT DATETIME2 not null default getdate()
)
GO

create schema Finances
GO

create table Finances.PaymentMethod (
  ID INT IDentity(1,1) primary key, 
  Text varchar(50) not null unique
)
GO

create table Finances.Payments (
  ID INT not null primary key, 
  StudentID INT not null foreign key references Individuals.Students(ID) on update cascade on delete cascade ,  
  ClassID INT not null foreign key references Academics.Classes(ID) on update cascade on delete cascade , 
  AmountPaid decimal(19,2) not null, 
  PaymentDate DATETIME2 not null default getdate(),
  
  PaymentMethod INT not null foreign key references Finances.PaymentMethod(ID), 
  CreatedAt DATETIME2 not null default getdate(),
)
Go

create rule ValidMoney as @x >=0 
GO

sp_bindrule ValidMoney, 'Finances.Payments.AmountPaid'
Go

create table Feedbacks (
 ID INT Identity(1,1) primary key, 
 StudentID INT not null foreign key references Individuals.Students(ID),  
 TeacherID INT not null foreign key references Individuals.Teachers(ID), 
 Feedback nvarchar(3000) not null,
 Rating TINYINT not null Check ( Rating >=1 and Rating <=5), 
 FeedbackDate DATETIME2 not null default getdate(),
)
Go

use PrivateTutoring 

INSERT INTO Individuals.Persons (FirstName, LastName, PhoneNumber, Email)
VALUES 
('Amr', 'Hassan', '01234567890', 'amr.hassan@gmail.com'),
('Fatma', 'Ibrahim', '01112223333', 'fatma.ibrahim@yahoo.com'),
('Mohamed', 'Khalil', '01098765432', 'mkhalil@hotmail.com'),
('Aisha', 'Ahmed', '01156789012', 'aisha.a@gmail.com'),
('Khaled', 'Mostafa', '01234567891', 'kmostafa@yahoo.com'),
('Nour', 'El-Din', '01187654321', 'nour.eldin@gmail.com'),
('Heba', 'Mahmoud', '01123456789', 'heba.m@hotmail.com'),
('Youssef', 'Samir', '01009876543', 'ysamir@gmail.com'),
('Mariam', 'Adel', '01167890123', 'mariam.adel@yahoo.com'),
('Ahmed', 'Gamal', '01198765432', 'agamal@gmail.com'),
('Layla', 'Zaki', '01223456789', 'layla.z@gmail.com'),
('Omar', 'Farouk', '01134567890', 'ofarouk@yahoo.com'),
('Dina', 'Sherif', '01145678901', 'dina.sherif@hotmail.com'),
('Karim', 'Wahba', '01156789023', 'kwahba@gmail.com'),
('Rana', 'Hamdy', '01167890134', 'rana.h@yahoo.com'),
('Tarek', 'Safwat', '01178901234', 'tsafwat@gmail.com'),
('Yasmin', 'Reda', '01189012345', 'yasmin.r@hotmail.com'),
('Hassan', 'Mahmoud', '01190123456', 'hmahmoud@yahoo.com'),
('Salma', 'Essam', '01201234567', 'salma.e@gmail.com'),
('Ziad', 'Hany', '01212345678', 'ziad.h@yahoo.com');

INSERT INTO Individuals.Teachers (ID, Specialization, HourlyRate, BirthDate)
VALUES 
(1, 'Mathematics', 200.00, '1985-06-15'),
(3, 'Physics', 180.00, '1988-03-22'),
(5, 'Arabic Language', 150.00, '1990-11-30'),
(7, 'Chemistry', 190.00, '1987-09-18'),
(9, 'English Language', 170.00, '1992-01-25'),
(11, 'Biology', 160.00, '1986-07-14'),
(13, 'History', 140.00, '1989-04-03'),
(15, 'Geography', 130.00, '1991-12-08'),
(17, 'Computer Science', 210.00, '1984-08-27'),
(19, 'French Language', 165.00, '1993-02-19'),
(2, 'Science', 175.00, '1988-05-11'),
(4, 'Social Studies', 145.00, '1990-09-29'),
(6, 'Art Education', 120.00, '1992-03-16'),
(8, 'Music', 135.00, '1987-11-05'),
(10, 'Physical Education', 125.00, '1989-01-23'),
(12, 'Religious Studies', 155.00, '1986-10-31'),
(14, 'Economics', 185.00, '1985-12-07'),
(16, 'Psychology', 195.00, '1991-06-25'),
(18, 'Philosophy', 170.00, '1988-08-14'),
(20, 'Statistics', 180.00, '1990-04-02');

-- set identity_insert Individuals.Students ON 
INSERT INTO Individuals.Students (ID,EnrollmentStatus)
VALUES 
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1),
(6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
(11, 0), (12, 1), (13, 1), (14, 0), (15, 1),
(16, 1), (17, 0), (18, 1), (19, 1), (20, 1);
-- set identity_insert Individuals.Students OFF 

INSERT INTO Locations.Centers (ID, Name, City, Address, Capacity, PhoneNumber)
VALUES 
(1, 'Al-Nour Academy', 'Cairo', 'Maadi, Street 9', 100, '02024567890'),
(2, 'El-Mostaqbal Center', 'Alexandria', 'Smouha, Victor Emanuel St', 80, '03034567891'),
(3, 'Al-Manara Institute', 'Giza', 'Dokki, Tahrir Street', 120, '02024567892'),
(4, 'El-Rowad Center', '6th of October', 'Al Hosary Square', 90, '02024567893'),
(5, 'Al-Baraka Academy', 'New Cairo', 'Fifth Settlement, Street 90', 150, '02024567894'),
(6, 'El-Nahda Institute', 'Helwan', 'Helwan University St', 85, '02024567895'),
(7, 'Al-Shorouk Center', 'Shubra El Kheima', 'Shubra St', 95, '02024567896'),
(8, 'El-Hedaya Academy', 'Tanta', 'El-Geish Street', 110, '04024567897'),
(9, 'Al-Fajr Institute', 'Mansoura', 'Gehan Street', 75, '05024567898'),
(10, 'El-Ghad Center', 'Asyut', 'El-Gomhoreya St', 88, '08824567899'),
(11, 'Al-Amal Academy', 'Zagazig', 'Farouk Street', 92, '05524567800'),
(12, 'El-Masry Institute', 'Ismailia', 'Sheikh Zayed St', 105, '06424567801'),
(13, 'Al-Sharq Center', 'Port Said', 'El-Togary Street', 115, '06624567802'),
(14, 'El-Watany Academy', 'Suez', 'El-Geish Road', 98, '06224567803'),
(15, 'Al-Salam Institute', 'Faiyum', 'Saad Zaghloul St', 82, '08424567804'),
(16, 'El-Tahrir Center', 'Luxor', 'Karnak Temple St', 78, '09524567805'),
(17, 'Al-Ahram Academy', 'Aswan', 'Corniche El Nile', 86, '09724567806'),
(18, 'El-Nile Institute', 'Damietta', 'Port Said Street', 94, '05724567807'),
(19, 'Al-Delta Center', 'Kafr El Sheikh', 'El-Geish Road', 102, '04724567808'),
(20, 'El-Shams Academy', 'Beni Suef', 'Salah Salem St', 88, '08224567809');

insert into Academics.Levels (Text) 
values ('Beginner'), ('Intermediate'), ('Advanced')

INSERT INTO Academics.Subjects (Name, Level)
VALUES 
('Arabic', 1), ('Mathematics', 2), ('Physics', 3), ('Chemistry', 3),
('English', 2), ('Biology', 3), ('History', 2), ('Geography', 2),
('Computer Science', 3), ('French', 2), ('Art', 1), ('Music', 1),
('Physical Education', 1), ('Religious Studies', 2), ('Economics', 3),
('Statistics', 3), ('Psychology', 3), ('Philosophy', 3), ('Geology', 3),
('Social Studies', 2);

INSERT INTO Academics.Classes (TeacherID, SubjectID, CenterID, StartDate, EndDate, MaxStudents)
VALUES 
(1, 13, 1, '2024-09-01', '2025-05-31', 15),
(2, 2, 2, '2024-09-01', '2025-05-31', 12),
(3, 3, 3, '2024-09-01', '2025-05-31', 20),
(4, 4, 4, '2024-09-01', '2025-05-31', 10),
(5, 5, 5, '2024-09-01', '2025-05-31', 18),
(6, 6, 6, '2024-09-01', '2025-05-31', 15),
(7, 7, 7, '2024-09-01', '2025-05-31', 14),
(8, 8, 8, '2024-09-01', '2025-05-31', 16),
(9, 9, 9, '2024-09-01', '2025-05-31', 12),
(10, 10, 10, '2024-09-01', '2025-05-31', 10),
(11, 11, 11, '2024-09-01', '2025-05-31', 20),
(12, 12, 12, '2024-09-01', '2025-05-31', 15),
(13, 13, 13, '2024-09-01', '2025-05-31', 18),
(14, 14, 14, '2024-09-01', '2025-05-31', 17),
(15, 15, 15, '2024-09-01', '2025-05-31', 13),
(16, 16, 16, '2024-09-01', '2025-05-31', 11),
(17, 17, 17, '2024-09-01', '2025-05-31', 19),
(18, 18, 18, '2024-09-01', '2025-05-31', 16),
(19, 19, 19, '2024-09-01', '2025-05-31', 14),
(20, 20, 20, '2024-09-01', '2025-05-31', 15);

INSERT INTO Academics.ClassSchedules (ClassID, WeekDay, StartTime, EndTime)
VALUES 
(5, 4, '13:00', '14:30'), (6, 5, '14:00', '15:30'),
(7, 6, '15:00', '16:30'), (8, 0, '16:00', '17:30'),
(9, 1, '17:00', '18:30'), (10, 2, '18:00', '19:30'),
(11, 3, '09:30', '11:00'), (12, 4, '10:30', '12:00'),
(13, 5, '11:30', '13:00'), (14, 6, '12:30', '14:00'),
(15, 0, '13:30', '15:00'), (16, 1, '14:30', '16:00'),
(17, 2, '15:30', '17:00'), (18, 3, '16:30', '18:00'),
(19, 4, '17:30', '19:00'), (20, 5, '18:30', '20:00');

INSERT INTO Academics.Enrollments (ID, StudentID, ClassID, Grade, AttendancePercentage, Feedback)
VALUES 
(4, 4, 4, 88.25, 88, 'Strong grasp of chemistry principles'),
(5, 5, 5, 76.50, 82, 'Improving steadily in English'),
(6, 6, 6, 91.75, 93, 'Excellent participation in biology'),
(7, 7, 7, 83.00, 87, 'Good analytical skills in history'),
(8, 8, 8, 79.25, 84, 'Showing interest in geography'),
(9, 9, 9, 94.50, 96, 'Exceptional coding skills'),
(10, 10, 10, 87.75, 89, 'Good progress in French language'),
(11, 11, 11, 81.00, 86, 'Creative approach to art projects'),
(12, 12, 12, 85.25, 88, 'Enthusiastic participation in music'),
(13, 13, 13, 90.50, 92, 'Great team player in physical education'),
(14, 14, 14, 77.75, 83, 'Good understanding of religious concepts'),
(15, 15, 15, 93.00, 94, 'Strong analytical skills in economics'),
(16, 16, 16, 86.25, 89, 'Good grasp of statistical concepts'),
(17, 17, 17, 82.50, 87, 'Insightful contributions in psychology'),
(18, 18, 18, 89.75, 91, 'Deep thinking in philosophy discussions'),
(19, 19, 19, 84.00, 88, 'Good understanding of geological concepts'),
(20, 20, 20, 80.25, 85, 'Improving in social studies analysis');

INSERT INTO Finances.PaymentMethod (Text)
VALUES 
    ('Credit Card'),
    ('Debit Card'),
    ('PayPal'),
    ('Bank Transfer'),
    ('Cash'),
    ('Cryptocurrency'),
    ('Gift Card'),
    ('Wire Transfer'),
    ('eCheck'),
    ('Mobile Payment'),
    ('Apple Pay'),
    ('Google Pay');

INSERT INTO Finances.Payments (ID, StudentID, ClassID, AmountPaid, PaymentDate, PaymentMethod)
VALUES 
(9, 9, 9, 580.00, '2024-01-22', 3),
(10, 10, 10, 530.00, '2024-01-23', 4),
(11, 11, 11, 495.00, '2024-01-24', 5),
(12, 12, 12, 515.00, '2024-01-25', 1),
(13, 13, 13, 545.00, '2024-01-26', 2),
(14, 14, 14, 505.00, '2024-01-27', 3),
(15, 15, 15, 570.00, '2024-01-28', 4),
(16, 16, 16, 485.00, '2024-01-29', 5),
(17, 17, 17, 525.00, '2024-01-30', 1),
(18, 18, 18, 535.00, '2024-01-31', 2),
(19, 19, 19, 490.00, '2024-02-01', 3),
(20, 20, 20, 520.00, '2024-02-02', 4);

INSERT INTO Feedbacks (StudentID, TeacherID, Feedback, Rating, FeedbackDate)
VALUES 
(1, 1, 'Excellent teaching methods, very clear explanations', 5, '2024-02-15'),
(2, 2, 'Good instructor, could improve time management', 4, '2024-02-16'),
(3, 3, 'Very knowledgeable and patient teacher', 5, '2024-02-17'),
(4, 4, 'Helpful and supportive throughout the course', 4, '2024-02-18'),
(5, 5, 'Makes complex topics easy to understand', 5, '2024-02-19'),
(6, 6, 'Engaging teaching style, great examples', 5, '2024-02-20'),
(7, 7, 'Could provide more practice exercises', 3, '2024-02-21'),
(8, 8, 'Very organized and structured lessons', 4, '2024-02-22'),
(9, 9, 'Excellent at encouraging class participation', 5, '2024-02-23'),
(10, 10, 'Sometimes moves too quickly through material', 3, '2024-02-24'),
(11, 11, 'Creates a positive learning environment', 4, '2024-02-25'),
(12, 12, 'Very responsive to student questions', 5, '2024-02-26'),
(13, 13, 'Good use of practical examples', 4, '2024-02-27'),
(14, 14, 'Could improve homework feedback', 3, '2024-02-28'),
(15, 15, 'Makes lessons interesting and fun', 5, '2024-02-29'),
(16, 16, 'Very professional and well-prepared', 4, '2024-03-01'),
(17, 17, 'Excellent at explaining difficult concepts', 5, '2024-03-02'),
(18, 18, 'Good balance of theory and practice', 4, '2024-03-03'),
(19, 19, 'Sometimes runs over class time', 3, '2024-03-04'),
(20, 20, 'Very helpful during office hours', 4, '2024-03-05');

INSERT INTO Academics.Classes (TeacherID, SubjectID, CenterID, StartDate, EndDate, MaxStudents)
VALUES 
(1, 2, 1, '2024-09-01', '2025-05-31', 15),
(1, 3, 2, '2024-09-01', '2025-05-31', 12),
(1, 16, 3, '2024-09-01', '2025-05-31', 18),
(1, 2, 4, '2024-09-01', '2025-05-31', 20),
(1, 3, 5, '2024-09-01', '2025-05-31', 15),
(2, 6, 1, '2024-09-01', '2025-05-31', 16),
(2, 4, 2, '2024-09-01', '2025-05-31', 14),
(2, 3, 3, '2024-09-01', '2025-05-31', 18),
(2, 6, 4, '2024-09-01', '2025-05-31', 15),
(2, 4, 5, '2024-09-01', '2025-05-31', 20),
(3, 5, 6, '2024-09-01', '2025-05-31', 18),
(3, 5, 7, '2024-09-01', '2025-05-31', 15),
(3, 10, 8, '2024-09-01', '2025-05-31', 12),
(3, 8, 9, '2024-09-01', '2025-05-31', 20),
(3, 5, 10, '2024-09-01', '2025-05-31', 16),
(4, 7, 11, '2024-09-01', '2025-05-31', 15),
(4, 8, 12, '2024-09-01', '2025-05-31', 18),
(4, 20, 13, '2024-09-01', '2025-05-31', 20),
(4, 7, 14, '2024-09-01', '2025-05-31', 17),
(4, 8, 15, '2024-09-01', '2025-05-31', 19),
(5, 14, 17, '2024-09-01', '2025-05-31', 16),
(5, 1, 18, '2024-09-01', '2025-05-31', 18),
(5, 14, 19, '2024-09-01', '2025-05-31', 15),
(5, 12, 20, '2024-09-01', '2025-05-31', 20),
(6, 6, 1, '2024-09-01', '2025-05-31', 15),
(6, 4, 2, '2024-09-01', '2025-05-31', 18),
(6, 6, 3, '2024-09-01', '2025-05-31', 16),
(6, 4, 4, '2024-09-01', '2025-05-31', 20),
(6, 6, 5, '2024-09-01', '2025-05-31', 15),
(7, 9, 6, '2024-09-01', '2025-05-31', 12),
(7, 16, 7, '2024-09-01', '2025-05-31', 15),
(7, 9, 8, '2024-09-01', '2025-05-31', 18),
(7, 16, 9, '2024-09-01', '2025-05-31', 14),
(7, 9, 10, '2024-09-01', '2025-05-31', 16),
(8, 5, 11, '2024-09-01', '2025-05-31', 20),
(8, 10, 12, '2024-09-01', '2025-05-31', 15),
(8, 5, 13, '2024-09-01', '2025-05-31', 18),
(8, 10, 14, '2024-09-01', '2025-05-31', 16),
(8, 5, 15, '2024-09-01', '2025-05-31', 20),
(9, 15, 16, '2024-09-01', '2025-05-31', 15),
(9, 17, 17, '2024-09-01', '2025-05-31', 18),
(9, 18, 18, '2024-09-01', '2025-05-31', 14),
(9, 15, 19, '2024-09-01', '2025-05-31', 16),
(9, 17, 20, '2024-09-01', '2025-05-31', 20),
(10, 11, 1, '2024-09-01', '2025-05-31', 15),
(10, 12, 2, '2024-09-01', '2025-05-31', 18),
(10, 13, 3, '2024-09-01', '2025-05-31', 16),
(10, 11, 4, '2024-09-01', '2025-05-31', 20),
(10, 12, 5, '2024-09-01', '2025-05-31', 15),
(11, 2, 6, '2024-09-01', '2025-05-31', 18),
(11, 16, 7, '2024-09-01', '2025-05-31', 15),
(11, 2, 8, '2024-09-01', '2025-05-31', 20),
(11, 16, 9, '2024-09-01', '2025-05-31', 16),
(11, 2, 10, '2024-09-01', '2025-05-31', 18),
(12, 3, 11, '2024-09-01', '2025-05-31', 15),
(12, 4, 12, '2024-09-01', '2025-05-31', 20),
(12, 6, 13, '2024-09-01', '2025-05-31', 16),
(12, 3, 14, '2024-09-01', '2025-05-31', 18),
(12, 4, 15, '2024-09-01', '2025-05-31', 15),
(13, 7, 16, '2024-09-01', '2025-05-31', 20),
(13, 8, 17, '2024-09-01', '2025-05-31', 16),
(13, 20, 18, '2024-09-01', '2025-05-31', 18),
(13, 7, 19, '2024-09-01', '2025-05-31', 15),
(13, 8, 20, '2024-09-01', '2025-05-31', 20),
(14, 18, 1, '2024-09-01', '2025-05-31', 16),
(14, 5, 2, '2024-09-01', '2025-05-31', 18),
(14, 10, 3, '2024-09-01', '2025-05-31', 15),
(14, 15, 4, '2024-09-01', '2025-05-31', 20),
(14, 5, 5, '2024-09-01', '2025-05-31', 16),
(15, 9, 6, '2024-09-01', '2025-05-31', 18),
(15, 16, 7, '2024-09-01', '2025-05-31', 15),
(15, 9, 8, '2024-09-01', '2025-05-31', 20),
(15, 16, 9, '2024-09-01', '2025-05-31', 16),
(15, 9, 10, '2024-09-01', '2025-05-31', 18),
(16, 15, 11, '2024-09-01', '2025-05-31', 15),
(16, 17, 12, '2024-09-01', '2025-05-31', 20),
(16, 18, 13, '2024-09-01', '2025-05-31', 16),
(16, 15, 14, '2024-09-01', '2025-05-31', 18),
(16, 17, 15, '2024-09-01', '2025-05-31', 15),
(17, 11, 16, '2024-09-01', '2025-05-31', 20),
(17, 12, 17, '2024-09-01', '2025-05-31', 16),
(17, 13, 18, '2024-09-01', '2025-05-31', 18),
(17, 11, 19, '2024-09-01', '2025-05-31', 15),
(17, 12, 20, '2024-09-01', '2025-05-31', 20),
(18, 2, 1, '2024-09-01', '2025-05-31', 16),
(18, 3, 2, '2024-09-01', '2025-05-31', 18),
(18, 16, 3, '2024-09-01', '2025-05-31', 15),
(18, 2, 4, '2024-09-01', '2025-05-31', 20),
(18, 3, 5, '2024-09-01', '2025-05-31', 16),
(19, 6, 6, '2024-09-01', '2025-05-31', 18),
(19, 4, 7, '2024-09-01', '2025-05-31', 15),
(19, 6, 8, '2024-09-01', '2025-05-31', 20),
(19, 4, 9, '2024-09-01', '2025-05-31', 16),
(19, 6, 10, '2024-09-01', '2025-05-31', 18),
(20, 15, 11, '2024-09-01', '2025-05-31', 15),
(20, 5, 12, '2024-09-01', '2025-05-31', 20),
(20, 10, 13, '2024-09-01', '2025-05-31', 16),
(20, 1, 14, '2024-09-01', '2025-05-31', 18),
(20, 5, 15, '2024-09-01', '2025-05-31', 15),
(1, 2, 16, '2024-09-01', '2025-05-31', 20),
(1, 3, 17, '2024-09-01', '2025-05-31', 16),
(1, 16, 18, '2024-09-01', '2025-05-31', 18),
(1, 2, 19, '2024-09-01', '2025-05-31', 15),
(1, 3, 20, '2024-09-01', '2025-05-31', 20),
(2, 6, 1, '2024-09-01', '2025-05-31', 16),
(2, 4, 2, '2024-09-01', '2025-05-31', 18),
(2, 3, 3, '2024-09-01', '2025-05-31', 15),
(2, 6, 4, '2024-09-01', '2025-05-31', 20),
(2, 4, 5, '2024-09-01', '2025-05-31', 16),
(3, 9, 6, '2024-09-01', '2025-05-31', 18),
(3, 5, 7, '2024-09-01', '2025-05-31', 15),
(3, 10, 8, '2024-09-01', '2025-05-31', 20),
(3, 8, 9, '2024-09-01', '2025-05-31', 16),
(3, 5, 10, '2024-09-01', '2025-05-31', 18),
(4, 7, 11, '2024-09-01', '2025-05-31', 15),
(4, 8, 12, '2024-09-01', '2025-05-31', 20),
(4, 20, 13, '2024-09-01', '2025-05-31', 16),
(4, 7, 14, '2024-09-01', '2025-05-31', 18),
(4, 8, 15, '2024-09-01', '2025-05-31', 15),
(5, 14, 17, '2024-09-01', '2025-05-31', 16),
(5, 14, 19, '2024-09-01', '2025-05-31', 15),
(5, 1, 20, '2024-09-01', '2025-05-31', 20),
(6, 6, 1, '2024-09-01', '2025-05-31', 16),
(6, 4, 2, '2024-09-01', '2025-05-31', 18),
(6, 6, 3, '2024-09-01', '2025-05-31', 15),
(6, 4, 4, '2024-09-01', '2025-05-31', 20),
(6, 6, 5, '2024-09-01', '2025-05-31', 16),
(7, 9, 6, '2024-09-01', '2025-05-31', 18),
(7, 16, 7, '2024-09-01', '2025-05-31', 15),
(7, 9, 8, '2024-09-01', '2025-05-31', 20),
(7, 16, 9, '2024-09-01', '2025-05-31', 16),
(7, 9, 10, '2024-09-01', '2025-05-31', 18),
(8, 5, 11, '2024-09-01', '2025-05-31', 15),
(8, 10, 12, '2024-09-01', '2025-05-31', 20);

create synonym Students for Individuals.Students 
Go

create synonym Enrollments for Academics.Enrollments
Go 

create synonym Classes for Academics.Classes
Go 

create synonym Teachers for Individuals.Teachers
Go 

create synonym Subjects for Academics.Subjects
Go 
