
if not exists (select 1 from sys.databases where name = 'Hospital')
	CREATE Database Hospital
	GO

USE Hospital
GO


--CREATE FUNCTION IsAllLetters (@inputString VARCHAR(MAX))
--returns BIT 
--BEGIN
--  declare @res BIT = 1
--  declare @index INT = 1

--  WHILE @index < Len(@inputString) 
--  BEGIN
--    if ASCII(substring(@inputString, @index, 1)) not between 65 and 90 AND 
--	   ASCII(SUBSTRING(@inputString, @index, 1)) not between 97 and 122
--	BEGIN
--	 SET @res = 0 
--	 BREAK;
--	END
--	SET @index= @index + 1
--  END 
--  RETURN @res
--END 
--GO

--CREATE FUNCTION dbo.IsValidEmail (@email VARCHAR(255))
--RETURNS BIT
--AS
--BEGIN
--    DECLARE @isValid BIT = 0;

--    IF @email LIKE '%_@__%.__%'
--        AND @email NOT LIKE '%[^a-zA-Z0-9._-]%'
--        AND @email NOT LIKE '%[._-]@%'
--        AND @email NOT LIKE '%@._%'
--        AND @email NOT LIKE '%@-%'
--        AND @email NOT LIKE '%-%@%'
--        AND @email NOT LIKE '%._.%'
--        AND @email NOT LIKE '%.-.%'
--    BEGIN
--        SET @isValid = 1;
--    END

--    RETURN @isValid;
--END
--GO

CREATE OR ALTER FUNCTION dbo.IsAllLetters (@inputString NVARCHAR(MAX))
RETURNS BIT 
AS
BEGIN
    RETURN CASE WHEN @inputString NOT LIKE '%[^a-zA-Z]%' THEN 1 ELSE 0 END;
END;
GO

CREATE OR ALTER FUNCTION dbo.IsValidEmail (@email NVARCHAR(255))
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN @email LIKE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' THEN 1 ELSE 0 END;
END;
GO

CREATE TABLE Individuals 
(
    Individual_ID INT Primary Key Identity(1,1),
  	FirstName nvarchar(50) not null check (dbo.IsAllLetters(FirstName) = 1),
	LastName nvarchar(50) not null check (dbo.IsAllLetters(LastName) = 1),
	Name as (FirstName +' '+ LastName), 
	BirthDate date not null CHECK (BirthDate <= GETDATE()), 
	Gender char(1) not null CHECK (Gender in ('M', 'F')),
	Address nvarchar(80) not null,
	Email varchar(255) not null CHECK (dbo.IsValidEmail(Email) = 1),
	CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
)
GO

CREATE TABLE Patients 
(
	Patient_ID INT Primary Key,
    Constraint PK_Patients_Individuals FOREIGN KEY (Patient_ID) REFERENCES Individuals(Individual_ID)
)
GO

CREATE TABLE Doctors 
(
	Doctor_ID INT Primary Key,
	Specialization nvarchar(100) not null,
	Constraint PK_Doctors_Individuals FOREIGN KEY (Doctor_ID) REFERENCES Individuals(Individual_ID)
)
GO

create table PhoneNumbers(
 PhoneNumber_ID INT PRIMARY KEY IDENTITY(1,1), 
 Individual_ID INT NOT NULL,
 PhoneNumber NVARCHAR(20) NOT NULL CHECK (PhoneNumber NOT LIKE '%[^0-9+()-]%'),
 CONSTRAINT FK_PhoneNumbers_Individuals FOREIGN KEY (Individual_ID) REFERENCES Individuals(Individual_ID)
)
GO 

create table Appointments 
(
	Appointment_ID INT PRIMARY KEY IDENTITY(1,1), 
	Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
	Appointment_Datetime datetime2 not null, 
    Status TINYINT NOT NULL DEFAULT 0,
	MedicalRecord_ID INT not null, 
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Appointments_Patients FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    CONSTRAINT FK_Appointments_Doctors FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID),
	CONSTRAINT FK_Appointments_MedicalRecords FOREIGN KEY (MedicalRecord_ID) REFERENCES MedicalRecords(MedicalRecord_ID)
)   
GO

create table MedicalRecords (
   MedicalRecord_ID INT PRIMARY KEY Identity(1,1), 
   DescriptionVisit nvarchar(MAX) not null, 
   Diagnosis nvarchar(MAX) not null, 
   AdditionalNotes varchar(max),
   CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
   UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
)
GO

CREATE TABLE Prescriptions 
(
  Prescription_ID INT PRIMARY KEY IDENTITY(1,1),
  MedicalRecord_ID INT NOT NULL,
  Medication_Name nvarchar(80) not null,
  Dosage nvarchar(50) not null, 
  Frequency nvarchar(50) not null, 
  StartDate date not null, 
  EndDate date not null, 
  Special_Instructions varchar(max),
  CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
  UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
  CONSTRAINT FK_Prescriptions_MedicalRecords FOREIGN KEY (MedicalRecord_ID) REFERENCES MedicalRecords(MedicalRecord_ID),
  CONSTRAINT CHK_Prescriptions_Dates CHECK (StartDate <= EndDate)
)
GO

CREATE TABLE Payments (
	Payment_ID INT PRIMARY KEY IDENTITY(1,1),
	Appointment_ID INT NOT NULL, 
	Payment_Date Datetime2 not null CHECK(Payment_Date <= getdate()) default getdate(), 
	Payment_Method varchar(50) not null, 
	Amount_Paid decimal(10,2) not null CHECK(Amount_Paid >= 0),
    AdditionalNotes varchar(max),
	CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Payments_Appointments FOREIGN KEY (Appointment_ID) REFERENCES Appointments(Appointment_ID)
)
GO



USE Hospital;
GO
-- Insert data into Individuals table
INSERT INTO Individuals (FirstName, LastName, BirthDate, Gender, Address, Email)
VALUES 
('Ahmed', 'Mohamed', '1980-05-15', 'M', 'Cairo', 'ahmed.mohamed@example.com'),
('Fatima', 'Ali', '1992-11-20', 'F', 'Alexandria', 'fatima.ali@example.com'),
('Mohamed', 'Hassan', '1975-03-10', 'M', 'Giza', 'mohamed.hassan@example.com'),
('Nour', 'Ibrahim', '1988-07-25', 'F', 'Luxor', 'nour.ibrahim@example.com'),
('Omar', 'Mahmoud', '1995-01-30', 'M', 'Aswan', 'omar.mahmoud@example.com'),
('Amira', 'Samir', '1983-09-12', 'F', 'Hurghada', 'amira.samir@example.com'),
('Khaled', 'Abdel', '1970-12-05', 'M', 'Sharm El Sheikh', 'khaled.abdel@example.com'),
('Laila', 'Mostafa', '1991-04-18', 'F', 'Mansoura', 'laila.mostafa@example.com'),
('Youssef', 'Hamed', '1987-08-22', 'M', 'Tanta', 'youssef.hamed@example.com'),
('Mariam', 'Farouk', '1993-06-14', 'F', 'Asyut', 'mariam.farouk@example.com'),
('Hassan', 'Nasser', '1978-02-28', 'M', 'Port Said', 'hassan.nasser@example.com'),
('Dina', 'Saleh', '1989-10-09', 'F', 'Suez', 'dina.saleh@example.com'),
('Karim', 'Fawzy', '1985-07-17', 'M', 'Ismailia', 'karim.fawzy@example.com'),
('Yasmin', 'Adel', '1997-03-23', 'F', 'Damietta', 'yasmin.adel@example.com'),
('Tarek', 'Ezzat', '1982-11-11', 'M', 'Faiyum', 'tarek.ezzat@example.com');

-- Insert data into Patients table
INSERT INTO Patients (Patient_ID)
SELECT Individual_ID FROM Individuals WHERE Individual_ID <= 10;

-- Insert data into Doctors table
INSERT INTO Doctors (Doctor_ID, Specialization)
VALUES 
(11, 'Cardiology'),
(12, 'Pediatrics'),
(13, 'Orthopedics'),
(14, 'Dermatology'),
(15, 'Neurology');

-- Insert data into PhoneNumbers table

INSERT INTO PhoneNumbers (Individual_ID, PhoneNumber)
VALUES 
(2, '+20 111 234 5678'),
(3, '+20 122 345 6789'),
(4, '+20 133 456 7890'),
(5, '+20 144 567 8901'),
(6, '+20 155 678 9012'),
(7, '+20 166 789 0123'),
(8, '+20 177 890 1234'),
(9, '+20 188 901 2345'),
(10, '+20 199 012 3456'),
(11, '+20 100 987 6543'),
(12, '+20 111 876 5432'),
(13, '+20 122 765 4321'),
(14, '+20 133 654 3210'),
(15, '+20 144 543 2109');

-- Insert data into Appointments table
INSERT INTO Appointments (Patient_ID, Doctor_ID, Appointment_Datetime, Status)
VALUES 
(2, 12, '2023-10-21 10:30:00', 'Confirmed'),
(3, 13, '2023-10-21 14:00:00', 'Confirmed'),
(4, 14, '2023-10-22 11:15:00', 'Pending'),
(5, 15, '2023-10-22 15:45:00', 'Pending'),
(6, 11, '2023-10-23 08:30:00', 'Confirmed'),
(7, 12, '2023-10-23 13:00:00', 'Confirmed'),
(8, 13, '2023-10-24 10:00:00', 'Pending'),
(9, 14, '2023-10-24 14:30:00', 'Confirmed'),
(10, 15, '2023-10-25 09:45:00', 'Confirmed'),
(2, 14, '2023-10-26 11:30:00', 'Confirmed'),
(3, 15, '2023-10-26 14:45:00', 'Pending'),
(4, 11, '2023-10-27 09:15:00', 'Confirmed'),
(5, 12, '2023-10-27 13:30:00', 'Confirmed');

-- Insert data into MedicalRecords table
INSERT INTO MedicalRecords (Appointment_ID, DescriptionVisit, Diagnosis, AdditionalNotes)
VALUES 

(11, 'Flu symptoms', 'Common cold', 'Prescribed rest and fluids'),
(12, 'Knee pain', 'Minor sprain', 'Recommended physiotherapy'),
(13, 'Skin rash', 'Eczema', 'Prescribed topical cream'),
(14, 'Headaches', 'Tension headache', 'Advised stress management techniques'),
(15, 'Follow-up', 'Hypertension', 'Blood pressure slightly elevated, adjusted medication'),
(16, 'Vaccination', 'Routine immunization', 'Administered scheduled vaccines'),
(17, 'Back pain', 'Muscle strain', 'Recommended exercises and pain relief'),
(18, 'Acne treatment', 'Moderate acne', 'Prescribed oral antibiotics and topical treatment'),
(19, 'Dizziness', 'Vertigo', 'Ordered additional tests'),
(20, 'Shoulder pain', 'Rotator cuff tendinitis', 'Referred to physical therapy'),
(21, 'Annual checkup', 'Healthy', 'No significant findings'),
(22, 'Numbness in hands', 'Carpal tunnel syndrome', 'Recommended wrist brace and ergonomic adjustments'),
(23, 'Chest pain', 'Gastroesophageal reflux', 'Prescribed antacids and dietary changes'),
(11, 'Growth assessment', 'Normal growth', 'Height and weight within normal range');

-- Insert data into Prescriptions table
INSERT INTO Prescriptions (MedicalRecord_ID, Medication_Name, Dosage, Frequency, StartDate, EndDate, Special_Instructions)
VALUES 
(18, 'Aspirin', '81 mg', 'Once daily', '2023-10-21', '2023-11-21', 'Take with food'),
(17, 'Paracetamol', '500 mg', 'Every 6 hours as needed', '2023-10-21', '2023-10-24', 'Do not exceed 4 doses in 24 hours'),
(16, 'Ibuprofen', '400 mg', 'Twice daily', '2023-10-21', '2023-10-28', 'Take with food'),
(15, 'Hydrocortisone cream', '1%', 'Apply twice daily', '2023-10-22', '2023-11-05', 'Apply a thin layer to affected areas'),
(14, 'Sumatriptan', '50 mg', 'As needed for migraine', '2023-10-22', '2023-11-22', 'Do not exceed 2 doses in 24 hours'),
(13, 'Lisinopril', '10 mg', 'Once daily', '2023-10-23', '2024-01-23', 'Take in the morning'),
(12, 'Multivitamin', '1 tablet', 'Once daily', '2023-10-23', '2024-10-23', 'Take with breakfast'),
(11, 'Naproxen', '500 mg', 'Twice daily', '2023-10-24', '2023-10-31', 'Take with food'),
(10, 'Doxycycline', '100 mg', 'Twice daily', '2023-10-24', '2023-11-23', 'Take on an empty stomach'),
(10, 'Meclizine', '25 mg', 'Three times daily', '2023-10-25', '2023-11-01', 'May cause drowsiness'),
(9, 'Diclofenac gel', '1%', 'Apply three times daily', '2023-10-25', '2023-11-08', 'Massage gently into affected area'),
(8, 'Vitamin D', '1000 IU', 'Once daily', '2023-10-26', '2024-10-26', 'Take with a meal'),
(7, 'Gabapentin', '300 mg', 'Three times daily', '2023-10-26', '2023-11-09', 'May cause dizziness'),
(6, 'Omeprazole', '20 mg', 'Once daily', '2023-10-27', '2023-11-27', 'Take before breakfast'),
(5, 'Iron supplement', '65 mg', 'Once daily', '2023-10-27', '2024-01-27', 'Take with orange juice for better absorption');

-- Insert data into Payments table
INSERT INTO Payments (Appointment_ID, Payment_Method, Amount_Paid, AdditionalNotes)
VALUES 
(11, 'Cash', 200.00, 'Full payment received'),
(12, 'Credit Card', 150.00, 'Visa ending in 4567'),
(13, 'Health Insurance', 300.00, 'Co-pay: 50.00'),
(14, 'Cash', 175.00, 'Full payment received'),
(15, 'Debit Card', 250.00, 'MasterCard ending in 7890'),
(16, 'Health Insurance', 280.00, 'Co-pay: 30.00'),
(17, 'Cash', 100.00, 'Vaccination fee'),
(18, 'Credit Card', 200.00, 'American Express ending in 3456'),
(19, 'Health Insurance', 320.00, 'Co-pay: 40.00'),
(20, 'Debit Card', 225.00, 'Visa ending in 6789'),
(21, 'Cash', 180.00, 'Full payment received'),
(22, 'Health Insurance', 290.00, 'Co-pay: 35.00'),
(23, 'Credit Card', 210.00, 'MasterCard ending in 2345'),
(11, 'Health Insurance', 350.00, 'Co-pay: 50.00'),
(13, 'Cash', 120.00, 'Full payment received');

select * from Individuals